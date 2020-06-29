function NewNPCRaycastWeaponBase:init(unit)
	NewRaycastWeaponBase.super.super.init(self, unit, false)

	self._player_manager = managers.player
	self._unit = unit
	self._name_id = self.name_id or "m4_crew"
	self.name_id = nil
	self._bullet_slotmask = managers.slot:get_mask("bullet_impact_targets")
	self._blank_slotmask = managers.slot:get_mask("bullet_blank_impact_targets")

	self:_create_use_setups()

	self._setup = {}
	self._digest_values = false

	self:set_ammo_max(tweak_data.weapon[self._name_id].AMMO_MAX)
	self:set_ammo_total(self:get_ammo_max())
	self:set_ammo_max_per_clip(tweak_data.weapon[self._name_id].CLIP_AMMO_MAX)
	self:set_ammo_remaining_in_clip(self:get_ammo_max_per_clip())

	self._damage = tweak_data.weapon[self._name_id].DAMAGE
	self._next_fire_allowed = -1000
	self._obj_fire = self._unit:get_object(Idstring("fire"))
	self._sound_fire = SoundDevice:create_source("fire")

	self._sound_fire:link(self._unit:orientation_object())

	self._muzzle_effect = Idstring(self:weapon_tweak_data().muzzleflash or "effects/particles/test/muzzleflash_maingun")
	self._muzzle_effect_table = {
		force_synch = false,
		effect = self._muzzle_effect,
		parent = self._obj_fire
	}
	self._use_shell_ejection_effect = SystemInfo:platform() == Idstring("WIN32")

	if self:weapon_tweak_data().armor_piercing then
		self._use_armor_piercing = true
	end

	if self._use_shell_ejection_effect then
		self._obj_shell_ejection = self._unit:get_object(Idstring("a_shell"))
		self._shell_ejection_effect = Idstring(self:weapon_tweak_data().shell_ejection or "effects/payday2/particles/weapons/shells/shell_556")
		self._shell_ejection_effect_table = {
			effect = self._shell_ejection_effect,
			parent = self._obj_shell_ejection
		}
	end

	self._trail_effect_table = {
		effect = self.TRAIL_EFFECT,
		position = Vector3(),
		normal = Vector3()
	}
	self._flashlight_light_lod_enabled = true

	if self._multivoice then
		if not NewNPCRaycastWeaponBase._next_i_voice[self._name_id] then
			NewNPCRaycastWeaponBase._next_i_voice[self._name_id] = 1
		end

		self._voice = NewNPCRaycastWeaponBase._VOICES[NewNPCRaycastWeaponBase._next_i_voice[self._name_id]]

		if NewNPCRaycastWeaponBase._next_i_voice[self._name_id] == #NewNPCRaycastWeaponBase._VOICES then
			NewNPCRaycastWeaponBase._next_i_voice[self._name_id] = 1
		else
			NewNPCRaycastWeaponBase._next_i_voice[self._name_id] = NewNPCRaycastWeaponBase._next_i_voice[self._name_id] + 1
		end
	else
		self._voice = "a"
	end

	if self._unit:get_object(Idstring("ls_flashlight")) then
		self._flashlight_data = {
			light = self._unit:get_object(Idstring("ls_flashlight")),
			effect = self._unit:effect_spawner(Idstring("flashlight"))
		}

		self._flashlight_data.light:set_far_range(400)
		self._flashlight_data.light:set_spot_angle_end(25)
		self._flashlight_data.light:set_multiplier(2)
	end

	self._textures = {}
	self._cosmetics_data = nil
	self._materials = nil

	managers.mission:add_global_event_listener(tostring(self._unit:key()), {
		"on_peer_removed"
	}, callback(self, self, "_on_peer_removed"))
end

function NewNPCRaycastWeaponBase:setup(setup_data)
	self._autoaim = setup_data.autoaim
	self._alert_events = setup_data.alert_AI and {} or nil
	self._alert_size = tweak_data.weapon[self._name_id].alert_size
	self._alert_fires = {}
	self._suppression = tweak_data.weapon[self._name_id].suppression
	self._bullet_slotmask = setup_data.hit_slotmask or self._bullet_slotmask
	self._character_slotmask = managers.slot:get_mask("raycastable_characters")
	self._hit_player = setup_data.hit_player and true or false
	self._setup = setup_data
	self._part_stats = managers.weapon_factory:get_stats(self._factory_id, self._blueprint)

	if setup_data.user_unit:in_slot(16) then --allow bots to shoot through each other
		self._bullet_slotmask = self._bullet_slotmask - World:make_slot_mask(16, 22)
	end
end

local mvec_to = Vector3()
local mvec_spread = Vector3()

function NewNPCRaycastWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player)
	--check for the armor piercing skills (can't be done through init), this also allows body armor piercing without having to add a specicic check when hitting body_plate
	if not self._checked_for_ap then
		self._checked_for_ap = true

		if not self._use_armor_piercing then
			if self._is_team_ai and managers.player:has_category_upgrade("team", "crew_ai_ap_ammo") then
				self._use_armor_piercing = true
			end
		end
	end

	local char_hit = nil
	local result = {}
	local ray_distance = self._weapon_range or 20000

	mvector3.set(mvec_to, direction)
	mvector3.multiply(mvec_to, ray_distance)
	mvector3.add(mvec_to, from_pos)

	local damage = self._damage * (dmg_mul or 1)

	local ray_hits = nil
	local hit_enemy = false
	local went_through_wall = false
	local enemy_mask = managers.slot:get_mask("enemies")
	local wall_mask = managers.slot:get_mask("world_geometry", "vehicles")
	local shield_mask = managers.slot:get_mask("enemy_shield_check")
	local ai_vision_ids = Idstring("ai_vision")
	local bulletproof_ids = Idstring("bulletproof")

	if self._use_armor_piercing then
		ray_hits = World:raycast_wall("ray", from_pos, mvec_to, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units, "thickness", 40, "thickness_mask", wall_mask)
	else
		ray_hits = World:raycast_all("ray", from_pos, mvec_to, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units)
	end

	local units_hit = {}
	local unique_hits = {}

	for i, hit in ipairs(ray_hits) do
		if not units_hit[hit.unit:key()] then
			units_hit[hit.unit:key()] = true
			unique_hits[#unique_hits + 1] = hit
			hit.hit_position = hit.position
			hit_enemy = hit_enemy or hit.unit:in_slot(enemy_mask)
			local weak_body = hit.body:has_ray_type(ai_vision_ids)
			weak_body = weak_body or hit.body:has_ray_type(bulletproof_ids)

			if not self._use_armor_piercing then
				if hit_enemy or hit.unit:in_slot(wall_mask) and weak_body or hit.unit:in_slot(shield_mask) then
					break
				end
			else
				if hit.unit:in_slot(wall_mask) and weak_body then
					if went_through_wall then
						break
					else
						went_through_wall = true
					end
				end
			end
		end
	end

	local furthest_hit = unique_hits[#unique_hits]

	if #unique_hits > 0 then
		local hit_player = false

		for _, hit in ipairs(unique_hits) do
			if self._hit_player and not hit_player and shoot_player then
				local player_hit_ray = deep_clone(hit)
				local player_hit = self:damage_player(player_hit_ray, from_pos, direction, result)

				if player_hit then
					hit_player = true
					char_hit = true

					local damaged_player = InstantBulletBase:on_hit_player(player_hit_ray, self._unit, user_unit, damage)

					if damaged_player then
						if not self._use_armor_piercing then
							hit.unit = managers.player:player_unit()
							hit.body = hit.unit:body("inflict_reciever")
							hit.position = mvector3.copy(hit.body:position())
							hit.hit_position = hit.position
							hit.distance = mvector3.direction(hit.ray, mvector3.copy(from_pos), mvector3.copy(hit.position))
							hit.normal = -hit.ray
							furthest_hit = hit

							break
						end
					end	
				end
			end

			local hit_char = InstantBulletBase:on_collision(hit, self._unit, user_unit, damage)

			if hit_char then
				char_hit = true

				if hit_char.type and hit_char.type == "death" then
					if self:is_category("shotgun") then
						managers.game_play_central:do_shotgun_push(hit.unit, hit.position, hit.ray, hit.distance, user_unit)
					end

					if user_unit:unit_data().mission_element then
						user_unit:unit_data().mission_element:event("killshot", user_unit)
					end
				end
			end
		end
	else
		if self._hit_player and shoot_player then
			local player_hit, player_ray_data = self:damage_player(nil, from_pos, direction, result)

			if player_hit then
				local damaged_player = InstantBulletBase:on_hit_player(player_ray_data, self._unit, user_unit, damage)

				if damaged_player then
					char_hit = true

					if not self._use_armor_piercing then
						player_ray_data.unit = managers.player:player_unit()
						player_ray_data.body = player_ray_data.unit:body("inflict_reciever")
						player_ray_data.position = mvector3.copy(player_ray_data.body:position())
						player_ray_data.hit_position = player_ray_data.position
						player_ray_data.distance = mvector3.direction(player_ray_data.ray, mvector3.copy(from_pos), mvector3.copy(player_ray_data.position))
						player_ray_data.normal = -player_ray_data.ray
						furthest_hit = player_ray_data
					end
				end	
			end
		end
	end

	result.hit_enemy = char_hit

	if alive(self._obj_fire) then
		if furthest_hit and furthest_hit.distance > 600 or not furthest_hit then
			local trail_direction = furthest_hit and furthest_hit.ray or direction
			local right = trail_direction:cross(math.UP):normalized()
			local up = trail_direction:cross(right):normalized()
			local name_id = self.non_npc_name_id and self:non_npc_name_id() or self._name_id
			local num_rays = (tweak_data.weapon[name_id] or {}).rays or 1

			for v = 1, num_rays, 1 do
				mvector3.set(mvec_spread, trail_direction)

				if v > 1 then
					local spread_x, spread_y = self:_get_spread(user_unit)
					local theta = math.random() * 360
					local ax = math.sin(theta) * math.random() * spread_x
					local ay = math.cos(theta) * math.random() * (spread_y or spread_x)

					mvector3.add(mvec_spread, right * math.rad(ax))
					mvector3.add(mvec_spread, up * math.rad(ay))
				end

				self:_spawn_trail_effect(mvec_spread, furthest_hit)
			end
		end
	end

	if self._suppression then
		local suppression_slot_mask = user_unit:in_slot(16) and managers.slot:get_mask("enemies") or managers.slot:get_mask("players", "criminals")

		self:_suppress_units(mvector3.copy(from_pos), mvector3.copy(direction), ray_distance, suppression_slot_mask, user_unit, nil)
	end

	if self._alert_events then
		result.rays = unique_hits
	end

	return result
end