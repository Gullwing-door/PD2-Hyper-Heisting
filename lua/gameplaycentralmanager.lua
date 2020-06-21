function GamePlayCentralManager:do_shotgun_push(unit, hit_pos, dir, distance, attacker)
	if not distance then
		return
	end

	local max_distance = 500

	if attacker == managers.player:player_unit() or managers.groupai:state():is_unit_team_AI(attacker) then
		max_distance = self:get_shotgun_push_range()
	end

	if distance < max_distance then
		if unit:id() > 0 then
			local unit_pos = unit:position()
			local unit_rot = unit:rotation()

			managers.network:session():send_to_peers_synched("sync_fall_position", unit, unit_pos, unit_rot)
			managers.network:session():send_to_peers_synched("sync_shotgun_push", unit, hit_pos, dir, distance, attacker)

			self:_add_corpse_to_shotgun_push_sync_list(unit)
		end

		self:_do_shotgun_push(unit, hit_pos, dir, distance, attacker)
	end
end

function GamePlayCentralManager:_do_shotgun_push(unit, hit_pos, dir, distance, attacker)
	if unit:movement()._active_actions[1] and unit:movement()._active_actions[1]:type() == "hurt" then
		unit:movement()._active_actions[1]:force_ragdoll(true)
	end

	local scale = math.clamp(1 - distance / self:get_shotgun_push_range(), 0.5, 1)
	local height = mvector3.distance(hit_pos, unit:position()) - 100
	local twist_dir = math.random(2) == 1 and 1 or -1
	local rot_acc = (dir:cross(math.UP) + math.UP * 0.5 * twist_dir) * -1000 * math.sign(height)
	local rot_time = 1 + math.rand(2)
	local nr_u_bodies = unit:num_bodies()
	local i_u_body = 0

	while nr_u_bodies > i_u_body do
		local u_body = unit:body(i_u_body)

		if u_body:enabled() and u_body:dynamic() then
			local body_mass = u_body:mass()

			World:play_physic_effect(Idstring("physic_effects/shotgun_hit"), u_body, Vector3(dir.x, dir.y, dir.z + 0.5) * 600 * scale, 4 * body_mass / math.random(2), rot_acc, rot_time)
			managers.mutators:notify(Message.OnShotgunPush, unit, hit_pos, dir, distance, attacker)
		end

		i_u_body = i_u_body + 1
	end
end

local update_original = GamePlayCentralManager.update
function GamePlayCentralManager:update(t, dt)
	update_original(self, t, dt)

	if self._corpses_to_sync then
		if not managers.groupai:state():whisper_mode() then
			self._corpses_to_sync = nil

			return
		end

		for _, corpse_info in pairs(self._corpses_to_sync) do
			if t >= corpse_info.sync_t then
				local unit = corpse_info.unit

				self:_sync_shotgun_pushed_body(unit)

				local active_actions_1 = unit:movement()._active_actions[1]

				if active_actions_1 and active_actions_1:type() == "hurt" and active_actions_1._ragdoll_freeze_clbk_id then
					corpse_info.sync_t = t + 0.5
				else
					local unit_pos = unit:position()
					local unit_rot = unit:rotation()

					managers.network:session():send_to_peers_synched("sync_fall_position", unit, unit_pos, unit_rot)

					self:_remove_corpse_to_shotgun_push_sync_list(unit)
				end
			end
		end
	end
end

function GamePlayCentralManager:_add_corpse_to_shotgun_push_sync_list(unit)
	self._corpses_to_sync = self._corpses_to_sync or {}

	self._corpses_to_sync[unit:key()] = {
		unit = unit,
		sync_t = TimerManager:game():time() + 0.5
	}
end

function GamePlayCentralManager:_remove_corpse_to_shotgun_push_sync_list(unit)
	self._corpses_to_sync[unit:key()] = nil

	if table.size(self._corpses_to_sync) == 0 then
		self._corpses_to_sync = nil
	end
end

function GamePlayCentralManager:_sync_shotgun_pushed_body(unit)
	local nr_u_bodies = unit:num_bodies()
	local i_u_body = 0

	while nr_u_bodies > i_u_body do
		local u_body = unit:body(i_u_body)

		if u_body:enabled() and u_body:dynamic() then
			local body_pos = u_body:position()

			managers.network:session():send_to_peers_synched("m79grenade_explode_on_client", body_pos, Vector3(), unit, i_u_body, 0, 0)
		end

		i_u_body = i_u_body + 1
	end
end
