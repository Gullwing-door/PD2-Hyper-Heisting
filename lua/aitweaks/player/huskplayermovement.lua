local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_z = mvector3.z
local mvec3_cpy = mvector3.copy
local mvec3_dist_sq = mvector3.distance_sq
local mvec3_lerp = mvector3.lerp
local mvec3_add = mvector3.add
local mvec3_sub = mvector3.subtract
local mvec3_mul = mvector3.multiply
local math_lerp = math.lerp

local math_random = math.random

local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()

local mrot_look = mrotation.set_look_at

local math_up = math.UP
local math_clamp = math.clamp
local math_point_on_line = math.point_on_line

local table_insert = table.insert
local table_remove = table.remove

local left_hand_str = Idstring("LeftHandMiddle2")
local right_hand_str = Idstring("RightHandMiddle2")

local post_init_original = HuskPlayerMovement.post_init
function HuskPlayerMovement:post_init()
	post_init_original(self)
	self._attention_handler:setup_attention_positions(self._m_detect_pos, self._m_newest_pos)
end

function HuskPlayerMovement:m_pos()
	return self._m_newest_pos
end

function HuskPlayerMovement:m_head_pos()
	return self._m_detect_pos
end

local init_original = HuskPlayerMovement.init
function HuskPlayerMovement:init(unit)

	self._stand_detection_offset_z = mvec3_z(tweak_data.player.stances.default.standard.head.translation)

	init_original(self, unit)
end

function HuskPlayerMovement:_calculate_m_pose()
	mrot_look(self._m_head_rot, self._look_dir, math_up)
	self._obj_head:m_position(self._m_head_pos)
end

function HuskPlayerMovement:_register_revive_SO()
	local followup_objective = {
		scan = true,
		type = "act",
		action = {
			variant = "crouch",
			body_part = 1,
			type = "act",
			blocks = {
				heavy_hurt = -1,
				hurt = -1,
				action = -1,
				aim = -1,
				walk = -1
			}
		}
	}
	local objective = {
		type = "revive",
		called = true,
		scan = true,
		destroy_clbk_key = false,
		follow_unit = self._unit,
		nav_seg = self._unit:movement():nav_tracker():nav_segment(),
		fail_clbk = callback(self, self, "on_revive_SO_failed"),
		complete_clbk = callback(self, self, "on_revive_SO_completed"),
		action = {
			align_sync = true,
			type = "act",
			body_part = 1,
			variant = self._state == "arrested" and "untie" or "revive",
			blocks = {
				light_hurt = -1,
				hurt = -1,
				action = -1,
				heavy_hurt = -1,
				aim = -1,
				walk = -1
			}
		},
		action_duration = tweak_data.interaction[self._state == "arrested" and "free" or "revive"].timer,
		followup_objective = followup_objective
	}
	local so_descriptor = {
		interval = 0,
		AI_group = "friendlies",
		base_chance = 1,
		chance_inc = 0,
		usage_amount = 1,
		objective = objective,
		search_pos = self._unit:position(),
		admin_clbk = callback(self, self, "on_revive_SO_administered"),
		verification_clbk = callback(HuskPlayerMovement, HuskPlayerMovement, "rescue_SO_verification", self._unit)
	}
	local so_id = "PlayerHusk_revive" .. tostring(self._unit:key())
	self._revive_SO_id = so_id

	managers.groupai:state():add_special_objective(so_id, so_descriptor)

	if not self._deathguard_SO_id then
		self._deathguard_SO_id = PlayerBleedOut._register_deathguard_SO(self._unit)
	end
end

function HuskPlayerMovement:sync_action_walk_nav_point(pos, speed, action, params)
	if pos then
		self:_update_real_pos(pos)
	end

	speed = speed or 1
	params = params or {}
	self._movement_path = self._movement_path or {}
	self._movement_history = self._movement_history or {}
	local path_len = #self._movement_path

	if not pos then
		if path_len <= 0 or self._movement_path[path_len].pos then
			pos = mvec3_cpy(self:m_pos())
		end
	end

	if Network:is_server() then
		if not self._pos_reservation then
			self._pos_reservation = {
				radius = 100,
				position = mvec3_cpy(pos),
				filter = self._pos_rsrv_id
			}
			self._pos_reservation_slow = {
				radius = 100,
				position = mvec3_cpy(pos),
				filter = self._pos_rsrv_id
			}

			managers.navigation:add_pos_reservation(self._pos_reservation)
			managers.navigation:add_pos_reservation(self._pos_reservation_slow)
		else
			self._pos_reservation.position = mvec3_cpy(pos)

			managers.navigation:move_pos_rsrv(self._pos_reservation)
			self:_upd_slow_pos_reservation()
		end
	end

	local can_add = true

	if not params.force and path_len > 0 then
		local last_node = self._movement_path[path_len]

		if last_node then
			local dist_sq = mvec3_dist_sq(pos, last_node.pos)
			can_add = dist_sq > 4
		end
	end

	if can_add then
		local on_ground = self:_chk_ground_ray(pos)
		local type = "ground"

		if self._zipline and self._zipline.enabled then
			type = "zipline"
		elseif not on_ground then
			type = "air"
		end

		local prev_node = self._movement_history[#self._movement_history]

		if type == "ground" and prev_node and self:action_is(prev_node.action, "jump") then
			type = "air"
		end

		if type == "ground" then
			local ground_z = self:_chk_floor_moving_pos()

			if ground_z then
				mvec3_set_z(pos, ground_z)
			end
		end

		local node = {
			pos = pos,
			speed = speed,
			type = type,
			action = {
				action
			}
		}

		table_insert(self._movement_path, node)
		table_insert(self._movement_history, node)

		if not params.force then
			local len = #self._movement_history

			if len > 1 then
				self:_determine_node_action(#self._movement_history, node)
			end
		end

		for i = 1, #self._movement_history - tweak_data.network.player_path_history do
			table_remove(self._movement_history, 1)
		end

		if params.execute and #self._movement_path <= tweak_data.network.player_path_interpolation then
			self:force_start_moving()
		end
	end
end

local draw_sync_player_newest_pos = nil
local draw_sync_player_detect_pos = nil

function HuskPlayerMovement:_update_real_pos(new_pos, new_pose_code)
	local newest_pos = self._m_newest_pos
	local detect_pos = self._m_detect_pos
	local stand_pos = self._m_stand_pos

	mvec3_set(newest_pos, new_pos)
	mvec3_set(detect_pos, new_pos)
	mvec3_set(stand_pos, new_pos)
	mvec3_set_z(stand_pos, new_pos.z + 140)

	local offset_z = nil

	if new_pose_code and new_pose_code == 2 or self._pose_code == 2 then
		offset_z = self._crouch_detection_offset_z
	else
		offset_z = self._stand_detection_offset_z
	end

	mvec3_set_z(detect_pos, detect_pos.z + offset_z)

	local m_com = self._m_com
	mvec3_lerp(m_com, newest_pos, detect_pos, 0.5)

	if draw_sync_player_newest_pos then
		local m_brush = Draw:brush(Color.blue:with_alpha(0.5), 0.1)
		m_brush:sphere(newest_pos, 15)
	end

	if draw_sync_player_detect_pos then
		local head_brush = Draw:brush(Color.yellow:with_alpha(0.5), 0.1)
		head_brush:sphere(detect_pos, 15)
	end
end

function HuskPlayerMovement:sync_action_change_pose(pose_code, pos)
	self._desired_pose_code = pose_code
	self:_update_real_pos(pos, pose_code)
end

function HuskPlayerMovement:_update_zipline_sled(t, dt)
	if self._zipline and self._zipline.attached then
		local zipline = self._zipline and self._zipline.zipline_unit and self._zipline.zipline_unit:zipline()

		if zipline then
			local closest_pos = math_point_on_line(zipline:start_pos(), zipline:end_pos(), self._m_pos)
			local distance = (zipline:start_pos() - closest_pos):length()
			local length = (zipline:start_pos() - zipline:end_pos()):length()
			local t = distance / length

			zipline:update_and_get_pos_at_time_linear(math_clamp(t, 0, 1))
		end
	end
end

function HuskPlayerMovement:anim_clbk_spawn_dropped_magazine()
	if not self:allow_dropped_magazines() then
		return
	end

	local equipped_weapon = self._unit:inventory():equipped_unit()

	if alive(equipped_weapon) and not equipped_weapon:base()._assembly_complete then
		return
	end

	local ref_unit = nil
	local allow_throw = true

	if not self._magazine_data then
		local w_td_crew = self:_equipped_weapon_crew_tweak_data()

		if not w_td_crew or not w_td_crew.pull_magazine_during_reload then
			return
		end

		self:anim_clbk_show_magazine_in_hand()

		if not self._magazine_data then --prevent the function from going any further if no data was defined with self:anim_clbk_show_magazine_in_hand()
			return
		elseif not alive(self._magazine_data.unit) then --prevent the function from going any further + delete the data if the magazine unit somehow didn't spawn
			self._magazine_data = nil

			return
		end

		local attach_bone = nil

		if not self._primary_hand or self._primary_hand == 0 then
			attach_bone = left_hand_str
		else
			attach_bone = right_hand_str
		end

		local bone_hand = self._unit:get_object(attach_bone)

		if bone_hand then
			mvec3_set(tmp_vec1, self._magazine_data.unit:position())
			mvec3_sub(tmp_vec1, self._magazine_data.unit:oobb():center())
			mvec3_add(tmp_vec1, bone_hand:position())
			self._magazine_data.unit:set_position(tmp_vec1)
		end

		ref_unit = self._magazine_data.part_unit
		allow_throw = false
	end

	if self._magazine_data and alive(self._magazine_data.unit) then
		ref_unit = ref_unit or self._magazine_data.unit

		self._magazine_data.unit:set_visible(false)

		local pos = ref_unit:position()
		local rot = ref_unit:rotation()
		local dropped_mag = self:_spawn_magazine_unit(self._magazine_data.id, self._magazine_data.name, pos, rot)

		self:_set_unit_bullet_objects_visible(dropped_mag, self._magazine_data.bullets, false)

		local mag_size = self._magazine_data.weapon_data.pull_magazine_during_reload

		if type(mag_size) ~= "string" then
			mag_size = "medium"
		end

		mvec3_set(tmp_vec1, ref_unit:oobb():center())
		mvec3_sub(tmp_vec1, pos)
		mvec3_set(tmp_vec2, pos)
		mvec3_add(tmp_vec2, tmp_vec1)

		local dropped_col = World:spawn_unit(HuskPlayerMovement.magazine_collisions[mag_size][1], tmp_vec2, rot)

		dropped_col:link(HuskPlayerMovement.magazine_collisions[mag_size][2], dropped_mag)

		if allow_throw then
			if self._left_hand_direction then
				local throw_force = 10

				mvec3_set(tmp_vec1, self._left_hand_direction)
				mvec3_mul(tmp_vec1, self._left_hand_velocity or 3)
				mvec3_mul(tmp_vec1, math_random(25, 45))
				mvec3_mul(tmp_vec1, -1)
				dropped_col:push(throw_force, tmp_vec1)
			end
		else
			local throw_force = 10
			local _t = (self._reload_speed_multiplier or 1) - 1

			mvec3_set(tmp_vec1, equipped_weapon:rotation():z())
			mvec3_mul(tmp_vec1, math_lerp(math_random(65, 80), math_random(140, 160), _t))
			mvec3_mul(tmp_vec1, math_random() < 0.0005 and 10 or -1) --0.0005% chance to send the magazine flying upwards (it's normally like this, just pointing it out)
			dropped_col:push(throw_force, tmp_vec1)
		end

		managers.enemy:add_magazine(dropped_mag, dropped_col)
	end
end

function HuskPlayerMovement:_get_max_move_speed(run)
	local my_tweak = tweak_data.player.movement_state.standard
	local move_speed = nil

	if self._synced_max_speed then
		move_speed = self._synced_max_speed
	elseif self._pose_code == 2 then
		move_speed = my_tweak.movement.speed.CROUCHING_MAX * (self._unit:base():upgrade_value("player", "crouch_speed_multiplier") or 1)
	elseif run then
		move_speed = my_tweak.movement.speed.RUNNING_MAX * (self._unit:base():upgrade_value("player", "run_speed_multiplier") or 1)
	else
		move_speed = my_tweak.movement.speed.STANDARD_MAX * (self._unit:base():upgrade_value("player", "walk_speed_multiplier") or 1)
	end

	if self._in_air then
		local t = self._air_time or 0
		local air_speed = math.exp(t * self:gravity() / self:terminal_velocity())
		air_speed = air_speed * self:gravity()
		air_speed = math.abs(air_speed)
		move_speed = math.max(move_speed, air_speed)
		move_speed = math.min(move_speed, math.abs(self:terminal_velocity()))
	end

	local zipline = self._zipline and self._zipline.enabled and self._zipline.zipline_unit and self._zipline.zipline_unit:zipline()

	if zipline then
		local step = 100
		local t = math.clamp((self._zipline.t or 0) / zipline:total_time(), 0, 1)
		local speed = 1.1 * zipline:speed_at_time(t, 1 / step) / step
		move_speed = math.max(speed * zipline:speed(), move_speed)
	end

	local path_length = #self._movement_path - tweak_data.network.player_path_interpolation

	if path_length > 0 then
		local speed_boost = 1 + path_length / tweak_data.network.player_tick_rate
		move_speed = move_speed * math.clamp(speed_boost, 1, 3)
	end

	return move_speed
end

function HuskPlayerMovement:_chk_ground_ray(check_pos, return_ray)
	local mover_radius = 60
	local up_pos = tmp_vec1

	mvec3_set(up_pos, math.UP)
	mvec3_mul(up_pos, 30)
	mvec3_add(up_pos, check_pos or self._m_pos)

	local down_pos = tmp_vec2

	mvec3_set(down_pos, math.UP)
	mvec3_mul(down_pos, -40)
	mvec3_add(down_pos, check_pos or self._m_pos)

	if return_ray then
		return World:raycast("ray", up_pos, down_pos, "slot_mask", self._slotmask_gnd_ray, "ray_type", "body mover", "sphere_cast_radius", 29, "bundle", 9)
	else
		return World:raycast("ray", up_pos, down_pos, "slot_mask", self._slotmask_gnd_ray, "ray_type", "body mover", "sphere_cast_radius", 29, "bundle", 9, "report")
	end
end

function HuskPlayerMovement:_update_air_time(t, dt)
	if self._in_air then
		self._check_air_time = 0
		self._air_time = self._air_time or 0
		self._air_time = self._air_time + dt

		if self._air_time > 0.5 then
			local on_ground = self:_chk_ground_ray(self._m_pos)

			if on_ground then
				self._in_air = false
				self._air_time = 0
			end
		end
	else
		self._air_time = 0
		
		self._check_air_time = self._check_air_time or 0
		self._check_air_time = self._check_air_time - dt
		
		if not self._check_air_time or self._check_air_time <= 0 then
			self._check_air_time = 1 / tweak_data.network.player_tick_rate
			
			local on_ground = self:_chk_ground_ray(self._m_pos)

			if not on_ground then
				if not self._bleedout then
					self:play_redirect("jump")
				end
				
				self._in_air = true
			end
		end
	end
end

function HuskPlayerMovement:_start_bleedout(event_desc)
	local redir_res = self:play_redirect("bleedout")

	if not redir_res then
		print("[HuskPlayerMovement:_start_bleedout] redirect failed in", self._machine:segment_state(self._ids_base), self._unit)

		return
	end

	self._unit:set_slot(3)
	managers.hud:set_mugshot_downed(self._unit:unit_data().mugshot_id)
	managers.groupai:state():on_criminal_disabled(self._unit)
	self._unit:interaction():set_tweak_data("revive")
	self:set_need_revive(true, event_desc.down_time)

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	return true
end

function HuskPlayerMovement:_start_tased(event_desc)
	local redir_res = self:play_redirect("tased")

	if not redir_res then
		print("[HuskPlayerMovement:_start_tased] redirect failed in", self._machine:segment_state(self._ids_base), self._unit)

		return
	end

	self._unit:set_slot(3)
	self:set_need_revive(false)
	managers.hud:set_mugshot_tased(self._unit:unit_data().mugshot_id)
	managers.groupai:state():on_criminal_disabled(self._unit, "electrified")

	self._tase_effect = World:effect_manager():spawn(self._tase_effect_table)

	self:set_need_assistance(true)

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	return true
end

function HuskPlayerMovement:_start_fatal(event_desc)
	local redir_res = self:play_redirect("fatal")

	if not redir_res then
		print("[HuskPlayerMovement:_start_fatal] redirect failed in", self._machine:segment_state(self._ids_base), self._unit)

		return
	end

	self._unit:set_slot(5)
	managers.hud:set_mugshot_downed(self._unit:unit_data().mugshot_id)
	managers.groupai:state():on_criminal_neutralized(self._unit)
	self._unit:interaction():set_tweak_data("revive")
	self:set_need_revive(true, event_desc.down_time)

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	return true
end

function HuskPlayerMovement:_start_incapacitated(event_desc)
	local redir_res = self:play_redirect("incapacitated")

	if not redir_res then
		print("[HuskPlayerMovement:_start_incapacitated] redirect failed in", self._machine:segment_state(self._ids_base), self._unit)

		return
	end

	self:set_need_revive(true)

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	return true
end

function HuskPlayerMovement:_start_dead(event_desc)
	local redir_res = self:play_redirect("death")

	if not redir_res then
		print("[HuskPlayerMovement:_start_dead] redirect failed in", self._machine:segment_state(self._ids_base), self._unit)

		return
	end

	if self._atention_on then
		local blend_out_t = 0.15

		self._machine:set_modifier_blend(self._look_modifier_name, blend_out_t)
		self._machine:set_modifier_blend(self._head_modifier_name, blend_out_t)
		self._machine:set_modifier_blend(self._arm_modifier_name, blend_out_t)
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	return true
end

function HuskPlayerMovement:_start_arrested(event_desc)
	if not self._ext_anim.hands_tied then
		local redir_res = self:play_redirect("tied")

		if not redir_res then
			print("[HuskPlayerMovement:_start_arrested] redirect failed in", self._machine:segment_state(self._ids_base), self._unit)

			return
		end
	end

	self._unit:set_slot(5)
	managers.hud:set_mugshot_cuffed(self._unit:unit_data().mugshot_id)
	managers.groupai:state():on_criminal_neutralized(self._unit)
	self._unit:interaction():set_tweak_data("free")
	self:set_need_revive(true)

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	return true
end


--[[local draw_player_newest_pos = nil
local draw_player_detect_pos = nil

local update_original = HuskPlayerMovement.update
function HuskPlayerMovement:update(unit, t, dt)
	update_original(self, unit, t, dt)

	if not self:_has_finished_loading() then
		return
	end

	if draw_player_newest_pos then
		local m_brush = Draw:brush(Color.blue:with_alpha(0.5), 0.1)
		m_brush:sphere(self._m_newest_pos, 15)
	end

	if draw_player_detect_pos then
		local head_brush = Draw:brush(Color.yellow:with_alpha(0.5), 0.1)
		head_brush:sphere(self._m_detect_pos, 15)
	end
end]]
