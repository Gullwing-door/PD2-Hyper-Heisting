local temp_vec1 = Vector3()

local mvec3_dis_sq = mvector3.distance_sq
local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_norm = mvector3.normalize
local mvec3_dis_sq = mvector3.distance_sq

Hooks:PostHook(PlayerStandard, "_calculate_standard_variables", "HH__calculate_standard_variables", function(self, t, dt)
	self._setting_hold_to_jump = managers.user:get_setting("hold_to_jump")
	self._setting_hold_to_fire = managers.user:get_setting("holdtofire")
end)


function PlayerStandard:_find_pickups(t)
	local pickups = World:find_units_quick("sphere", self._unit:movement():m_pos(), self._pickup_area, self._slotmask_pickups)
	local grenade_tweak = tweak_data.blackmarket.projectiles[managers.blackmarket:equipped_grenade()]
	local may_find_grenade = nil --blech, theres already a 5% chance now, so i dont think fully loaded needs this anymore

	for _, pickup in ipairs(pickups) do
		if pickup:pickup() and pickup:pickup():pickup(self._unit) then
			if may_find_grenade then
				local data = managers.player:upgrade_value("player", "regain_throwable_from_ammo", nil)

				if data then
					managers.player:add_coroutine("regain_throwable_from_ammo", PlayerAction.FullyLoaded, managers.player, data.chance, data.chance_inc)
				end
			end

			for id, weapon in pairs(self._unit:inventory():available_selections()) do
				managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
			end
		end
	end
end

function PlayerStandard:on_melee_stun(t, timer)
	if self:_is_meleeing() and managers.player:has_category_upgrade("player", "beatemup_aced") then
		return
	end

	self._melee_stunned_expire_t = t + timer
	self._melee_stunned = true

	self:_interupt_action_reload(t)
	self:_interupt_action_steelsight(t)
	self:_interupt_action_running(t)
	self:_interupt_action_charging_weapon(t)
	self:_interupt_action_melee(t)
	self:_interupt_action_interact(t)
	self:_interupt_action_throw_grenade(t)
	self:_interupt_action_throw_projectile(t)

	self:_play_unequip_animation()
end

function PlayerStandard:end_melee_stun()
	self._melee_stunned_expire_t = nil

	self:_play_equip_animation()
end

function PlayerStandard:_check_action_reload(t, input)
	local new_action = nil
	local action_wanted = input.btn_reload_press

	if action_wanted then
		local action_forbidden = self:_is_reloading() or self:_changing_weapon() or self:_is_meleeing() or self._use_item_expire_t or self:_interacting() or self:_is_throwing_projectile() or self._melee_stunned

		if not action_forbidden and self._equipped_unit and not self._equipped_unit:base():clip_full() then
			self:_start_action_reload_enter(t)

			new_action = true
		end
	end

	return new_action
end

function PlayerStandard:_check_use_item(t, input)
	local new_action = nil
	local action_wanted = input.btn_use_item_press

	if action_wanted then
		local action_forbidden = self._use_item_expire_t or self:_interacting() or self:_changing_weapon() or self:_is_throwing_projectile() or self:_is_meleeing() or self._melee_stunned

		if not action_forbidden and managers.player:can_use_selected_equipment(self._unit) then
			self:_start_action_use_item(t)

			new_action = true
		end
	end

	if input.btn_use_item_release then
		self:_interupt_action_use_item()
	end

	return new_action
end

function PlayerStandard:_check_change_weapon(t, input)
	local new_action = nil
	local action_wanted = input.btn_switch_weapon_press

	if action_wanted then
		local action_forbidden = self:_changing_weapon()
		action_forbidden = action_forbidden or self:_is_meleeing() or self._use_item_expire_t or self._change_item_expire_t
		action_forbidden = action_forbidden or self._unit:inventory():num_selections() == 1 or self:_interacting() or self:_is_throwing_projectile() or self:_is_deploying_bipod() or self._melee_stunned

		if not action_forbidden then
			local data = {
				next = true
			}
			self._change_weapon_pressed_expire_t = t + 0.33

			self:_start_action_unequip_weapon(t, data)

			new_action = true

			managers.player:send_message(Message.OnSwitchWeapon)
		end
	end

	return new_action
end

function PlayerStandard:_check_action_melee(t, input)
	if self._melee_stunned then
		return
	end
	
	if self._state_data.melee_attack_wanted then
		if not self._state_data.melee_attack_allowed_t then
			self._state_data.melee_attack_wanted = nil

			self:_do_action_melee(t, input)
		end

		return
	end

	local action_wanted = input.btn_melee_press or input.btn_melee_release or self._state_data.melee_charge_wanted

	if not action_wanted then
		return
	end

	if input.btn_melee_release then
		if self._state_data.meleeing then
			if self._state_data.melee_attack_allowed_t then
				self._state_data.melee_attack_wanted = true

				return
			end

			self:_do_action_melee(t, input)
		end

		return
	end

	local action_forbidden = not self:_melee_repeat_allowed() or self._use_item_expire_t or self:_changing_weapon() or self:_interacting() or self:_is_throwing_projectile() or self:_is_using_bipod() or self._melee_stunned

	if action_forbidden then
		return
	end

	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local instant = tweak_data.blackmarket.melee_weapons[melee_entry].instant

	self:_start_action_melee(t, input, instant)

	return true
end

function PlayerStandard:_play_distance_interact_redirect(t, variant)
	managers.network:session():send_to_peers_synched("play_distance_interact_redirect", self._unit, variant)

	if self._state_data.in_steelsight then
		return
	end
	
	if self._melee_stunned then
		return
	end

	if self._shooting or not self._equipped_unit:base():start_shooting_allowed() then
		return
	end

	if self:_is_reloading() or self:_changing_weapon() or self:_is_meleeing() or self._use_item_expire_t then
		return
	end

	if self._running then
		return
	end

	self._state_data.interact_redirect_t = t + 1

	self._ext_camera:play_redirect(Idstring(variant))
end

function PlayerStandard:_update_running_timers(t)
	if self._end_running_expire_t then
		if self._end_running_expire_t <= t then
			self._end_running_expire_t = nil

			self:set_running(false)
		end
	end
end

function PlayerStandard:_get_total_max_speed()
	local speed_tweak = self._tweak_data.movement.speed
	local movement_speed = speed_tweak.RUNNING_MAX * 1.2
	local speed_state = "run"

	movement_speed = managers.modifiers:modify_value("PlayerStandard:GetMaxWalkSpeed", movement_speed, self._state_data, speed_tweak)
	local morale_boost_bonus = self._ext_movement:morale_boost()
	local multiplier = managers.player:movement_speed_multiplier(speed_state, speed_state and morale_boost_bonus and morale_boost_bonus.move_speed_bonus, nil, self._ext_damage:health_ratio())
	multiplier = multiplier * (self._tweak_data.movement.multiplier[speed_state] or 1)
	local apply_weapon_penalty = true

	if speed_state == "climb" then
		multiplier = multiplier * 1.2
	else
		multiplier = 1.1
	end

	if self:_is_meleeing() then
		local melee_entry = managers.blackmarket:equipped_melee_weapon()
		apply_weapon_penalty = not tweak_data.blackmarket.melee_weapons[melee_entry].stats.remove_weapon_movement_penalty
	end

	if alive(self._equipped_unit) and apply_weapon_penalty then
		multiplier = multiplier * self._equipped_unit:base():movement_penalty()
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "increased_movement_speed") then
		multiplier = multiplier * managers.player:temporary_upgrade_value("temporary", "increased_movement_speed", 1)
	end
	
	if managers.player:has_category_upgrade("player", "criticalmode") then
		multiplier = multiplier * 1.25
	end
	
	if self._wave_dash_t and self._running then
		multiplier = multiplier * 1.25
	end
	
	if managers.player:has_category_upgrade("player", "perkdeck_movespeed_mult") then
		multiplier = multiplier * managers.player:upgrade_value("player", "perkdeck_movespeed_mult", 1)
	end
	
	local final_speed = movement_speed * multiplier
	
	if self._fall_damage_slow_t then
		local fall_lerp = self._fall_damage_slow_t - t
		local mul = math.max(math.lerp(1, 0, fall_lerp), 0.05)
	
		final_speed = final_speed * mul
	end
	
	return final_speed
end

function PlayerStandard:_get_max_walk_speed(t, force_run)
	local speed_tweak = self._tweak_data.movement.speed
	local movement_speed = speed_tweak.STANDARD_MAX
	local speed_state = "walk"

	if self._state_data.in_steelsight and not managers.player:has_category_upgrade("player", "steelsight_normal_movement_speed") and not _G.IS_VR then
		movement_speed = speed_tweak.STEELSIGHT_MAX
		speed_state = "steelsight"
	elseif self:on_ladder() then
		movement_speed = speed_tweak.CLIMBING_MAX
		speed_state = "climb"
	elseif self._state_data.ducking then
		movement_speed = speed_tweak.CROUCHING_MAX
		speed_state = "crouch"
	elseif self._state_data.in_air then
		movement_speed = speed_tweak.INAIR_MAX
		speed_state = nil
	elseif self._running or force_run then
		if self._unit:movement():is_above_stamina_threshold() then
			movement_speed = speed_tweak.RUNNING_MAX
		else
			movement_speed = speed_tweak.RUNNING_MAX * 0.75
		end
		
		speed_state = "run"
	end

	movement_speed = managers.modifiers:modify_value("PlayerStandard:GetMaxWalkSpeed", movement_speed, self._state_data, speed_tweak)
	local morale_boost_bonus = self._ext_movement:morale_boost()
	local multiplier = managers.player:movement_speed_multiplier(speed_state, speed_state and morale_boost_bonus and morale_boost_bonus.move_speed_bonus, nil, self._ext_damage:health_ratio())
	multiplier = multiplier * (self._tweak_data.movement.multiplier[speed_state] or 1)
	local apply_weapon_penalty = true
	
	if speed_state == "climb" then
		multiplier = multiplier * 1.2
	else
		multiplier = multiplier + 0.1
	end

	if self:_is_meleeing() then
		local melee_entry = managers.blackmarket:equipped_melee_weapon()
		apply_weapon_penalty = not tweak_data.blackmarket.melee_weapons[melee_entry].stats.remove_weapon_movement_penalty
	end

	if alive(self._equipped_unit) and apply_weapon_penalty then
		multiplier = multiplier * self._equipped_unit:base():movement_penalty()
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "increased_movement_speed") then
		multiplier = multiplier * managers.player:temporary_upgrade_value("temporary", "increased_movement_speed", 1)
	end
	
	if self._unit:movement():is_above_stamina_threshold() then
		if self._wave_dash_t and self._running then
			multiplier = multiplier * 1.25
		end
	end
	
	if managers.player:has_activate_temporary_upgrade("temporary", "copr_ability") then
		local out_of_health = self._unit:character_damage():health_ratio() + 0.01 < managers.player:upgrade_value("player", "copr_static_damage_ratio", 0)

		if out_of_health then
			multiplier = multiplier * managers.player:upgrade_value("player", "copr_out_of_health_move_slow", 1)
		end
	end
	
	if not force_run and self.tased then
		multiplier = multiplier * 0.2
	end
	
	local final_speed = movement_speed * multiplier
	
	if self._fall_damage_slow_t then
		local fall_lerp = self._fall_damage_slow_t - t
		local mul = math.max(math.lerp(1, 0, fall_lerp), 0.05)
	
		final_speed = final_speed * mul
	end

	return final_speed
end

function PlayerStandard:_check_action_jump(t, input)
	local new_action = nil
	local action_wanted = input.btn_jump_press or self._setting_hold_to_jump and input.btn_jump_state == true

	if action_wanted then
		local action_forbidden = self._jump_t and t < self._jump_t + 0.55
		
		if self._state_data.land_t and t - self._state_data.land_t < 0.05 then
			action_forbidden = nil
		end
		
		action_forbidden = action_forbidden or self._unit:base():stats_screen_visible() or self._state_data.in_air_enter_t and self._jump_t and t < self._jump_t + 0.55 or self._state_data.in_air_enter_t and t - self._state_data.in_air_enter_t > 0.05 or self:_interacting() or self:_on_zipline() or self:_does_deploying_limit_movement() or self:_is_using_bipod()

		if not action_forbidden then
			if self._state_data.ducking then
				self:_interupt_action_ducking(t)
			end
				
			if self._state_data.on_ladder then
				self:_interupt_action_ladder(t)
			end

			local action_start_data = {}
			local jump_vel_z = tweak_data.player.movement_state.standard.movement.jump_velocity.z
			action_start_data.jump_vel_z = jump_vel_z
			
			if self._move_dir then
				local is_running = self._running and self._unit:movement():is_above_stamina_threshold() and t - self._start_running_t > 0.4
				local jump_vel_xy = 250
					
				if math.abs(self._last_velocity_xy:length()) > jump_vel_xy then
					local fwd_dot = self._move_dir:normalized():dot(self._last_velocity_xy:normalized())
					local dot_mul = math.max(0, fwd_dot)
				
					local max_walk_speed_hopping = self:_get_max_walk_speed(t, true) * 1.5
					local mul = 1 + 125 / max_walk_speed_hopping
					
					--log(tostring(mul))
					
					jump_vel_xy = math.min(max_walk_speed_hopping, math.abs(self._last_velocity_xy:length()) * mul) * dot_mul
				end
				
				action_start_data.jump_vel_xy = jump_vel_xy

				if is_running then
					local stamina_subtraction = tweak_data.player.movement_state.stamina.JUMP_STAMINA_DRAIN
					
					if managers.player:has_category_upgrade("player", "start_action_stam_drain_reduct") then
						stamina_subtraction = stamina_subtraction * 0.5
					end
					
					self._unit:movement():subtract_stamina(stamina_subtraction)
				end
			elseif not mvector3.is_zero(self._last_velocity_xy) then
				local jump_vel_xy = math.abs(self._last_velocity_xy:length())				
				action_start_data.jump_vel_xy = jump_vel_xy
			end

			new_action = self:_start_action_jump(t, action_start_data)
		end
	end

	return new_action
end

local mvec_pos_new = Vector3()
local mvec_achieved_walk_vel = Vector3()
local mvec_move_dir_normalized = Vector3()

function PlayerStandard:_check_action_duck(t, input)
	if self:_is_using_bipod() then
		return
	end

	if self._setting_hold_to_duck and input.btn_duck_release then
		if self._state_data.ducking then
			self:_end_action_ducking(t)
		end
	elseif input.btn_duck_press and not self._unit:base():stats_screen_visible() then
		if not self._state_data.ducking then
			self:_start_action_ducking(t)
		elseif self._state_data.ducking then
			self:_end_action_ducking(t)
		end
		
		local a = nil
		
		if a then
			if not self._melee_stunned and self._state_data.in_air then
				if self._unit:mover():velocity().z < -99 then
					self._unit:mover():set_velocity(Vector3(0, 0, -1400))
					mvector3.set_static(self._last_velocity_xy, 0, 0, 0)
					self._state_data.diving = true
				end
			end
		end
	end
end

function PlayerStandard:_end_action_ducking(t, skip_can_stand_check)
	if not skip_can_stand_check and not self:_can_stand() then
		return
	end

	self._state_data.ducking = false
	self:_stance_entered()
	self:_update_crosshair_offset()

	local velocity = self._unit:mover():velocity()

	self._unit:kill_mover()
	self:_activate_mover(PlayerStandard.MOVER_STAND, velocity)
	self._ext_network:send("action_change_pose", 1, self._unit:position())
	self:_upd_attention()
end

function PlayerStandard:_update_movement(t, dt)
	local anim_data = self._unit:anim_data()
	local weapon_id = alive(self._equipped_unit) and self._equipped_unit:base() and self._equipped_unit:base():get_name_id()
	local weapon_tweak_data = weapon_id and tweak_data.weapon[weapon_id]
	local pos_new = nil
	self._target_headbob = self._target_headbob or 0
	self._headbob = self._headbob or 0
	local update_velocity = true
	
	local WALK_SPEED_MAX = self:_get_max_walk_speed(t)
		
	if self._state_data.in_air and self._jump_vel_xy then
		if math.abs(self._jump_vel_xy:length()) > 250 then
			WALK_SPEED_MAX = math.abs(self._jump_vel_xy:length())
		else
			WALK_SPEED_MAX = 250
		end
	end
	
	self._cached_final_speed = self._cached_final_speed or 0
		
	if WALK_SPEED_MAX ~= self._cached_final_speed then
		self._cached_final_speed = WALK_SPEED_MAX
		
		self._ext_network:send("action_change_speed", WALK_SPEED_MAX)
	end
	
	local acceleration = self:_get_max_walk_speed(t, true) * 8
	local decceleration = self._move_dir and acceleration * 0.7 or 2800
	
	if self._state_data.in_air or self._state_data.land_t and t - self._state_data.land_t < 0.05 then
		decceleration = 0
	end
	
	local floor_moving_ray = self:_chk_floor_moving_pos()
	local floor_moving_vel, floor_moving_pos
	
	if floor_moving_ray then
		floor_moving_vel = floor_moving_ray.body and math.abs(floor_moving_ray.body:velocity():length()) > 0 and floor_moving_ray.body:velocity() or nil
		--floor_moving_pos = floor_moving_ray.position
	end
	
	
	if self._state_data.on_zipline and self._state_data.zipline_data.position then
		local speed = mvector3.length(self._state_data.zipline_data.position - self._pos) / dt / 500
		pos_new = mvec_pos_new

		mvector3.set(pos_new, self._state_data.zipline_data.position)

		if self._state_data.zipline_data.camera_shake then
			self._ext_camera:shaker():set_parameter(self._state_data.zipline_data.camera_shake, "amplitude", speed)
		end

		if alive(self._state_data.zipline_data.zipline_unit) then
			local dot = mvector3.dot(self._ext_camera:rotation():x(), self._state_data.zipline_data.zipline_unit:zipline():current_direction())

			self._ext_camera:camera_unit():base():set_target_tilt(dot * 10 * speed)
		end

		self._target_headbob = 0
	elseif self._move_dir then
		local enter_moving = not self._moving
		self._moving = true

		if enter_moving then
			self._last_sent_pos_t = t

			self:_update_crosshair_offset()
		end

		mvector3.set(mvec_move_dir_normalized, self._move_dir)
		mvector3.normalize(mvec_move_dir_normalized)

		local wanted_walk_speed = WALK_SPEED_MAX * math.min(1, self._move_dir:length())	
		local achieved_walk_vel = mvec_achieved_walk_vel
		
		if self._running and self._wave_dash_t then
			acceleration = acceleration + wanted_walk_speed
		end
		
		local lleration = acceleration
		
		if math.abs(self._last_velocity_xy:length()) > wanted_walk_speed then
			--log("deccelerate!")
			lleration = decceleration
		end
		
		--log("lleration: " .. lleration .. "")
		
		if self._jump_vel_xy and self._state_data.in_air and mvector3.dot(self._jump_vel_xy, self._last_velocity_xy) >= 0 then
			local wanted_walk_speed_air = WALK_SPEED_MAX * math.min(1, self._move_dir:length())
			local acceleration = self._state_data.in_air and 1200 or lleration
			local input_move_vec = wanted_walk_speed_air * self._move_dir
			local jump_dir = mvector3.copy(self._last_velocity_xy)
			local jump_vel = mvector3.normalize(jump_dir)
			local fwd_dot = jump_dir:dot(input_move_vec)

			if fwd_dot < jump_vel then
				local sustain_dot = (input_move_vec:normalized() * jump_vel):dot(jump_dir)
				local new_move_vec = input_move_vec + jump_dir * (sustain_dot - fwd_dot)

				mvector3.step(achieved_walk_vel, self._last_velocity_xy, new_move_vec, acceleration * dt)
			else
				mvector3.multiply(mvec_move_dir_normalized, wanted_walk_speed_air)
				mvector3.step(achieved_walk_vel, self._last_velocity_xy, mvec_move_dir_normalized, acceleration * dt)
			end
		else
			mvector3.multiply(mvec_move_dir_normalized, wanted_walk_speed)
			mvector3.step(achieved_walk_vel, self._last_velocity_xy, mvec_move_dir_normalized, lleration * dt)
		end

		if mvector3.is_zero(self._last_velocity_xy) then
			mvector3.set_length(achieved_walk_vel, math.max(achieved_walk_vel:length(), 100))
		end

		pos_new = mvec_pos_new
		
		mvector3.set(pos_new, achieved_walk_vel)
		mvector3.multiply(pos_new, dt)
		mvector3.add(pos_new, self._pos)

		self._target_headbob = self:_get_walk_headbob()
		self._target_headbob = self._target_headbob * self._move_dir:length()

		if weapon_tweak_data and weapon_tweak_data.headbob and weapon_tweak_data.headbob.multiplier then
			self._target_headbob = self._target_headbob * weapon_tweak_data.headbob.multiplier
		end
	elseif not mvector3.is_zero(self._last_velocity_xy) then
		if not self._state_data.land_t or self._state_data.land_t and t - self._state_data.land_t >= 0.05 then
			local grad = decceleration
			
			local achieved_walk_vel = math.step(self._last_velocity_xy, Vector3(), grad * dt)
			
			pos_new = mvec_pos_new
			
			mvector3.set(pos_new, achieved_walk_vel)			
			mvector3.multiply(pos_new, dt)
			mvector3.add(pos_new, self._pos)
			self._target_headbob = 0
		else
			local achieved_walk_vel = mvec_achieved_walk_vel
			mvector3.set(achieved_walk_vel, self._last_velocity_xy)
			
			pos_new = mvec_pos_new
			
			mvector3.set(pos_new, achieved_walk_vel)			
			mvector3.multiply(pos_new, dt)
			mvector3.add(pos_new, self._pos)
		end 	
	elseif self._moving or floor_moving_vel then
		if floor_moving_vel then
			local achieved_walk_vel = mvec_achieved_walk_vel
			mvector3.set(achieved_walk_vel, floor_moving_vel)
			
			pos_new = mvec_pos_new
			mvector3.set(pos_new, achieved_walk_vel)
			mvector3.multiply(pos_new, dt)
			mvector3.add(pos_new, self._pos)
		end
		
		self._moving = false
		self._target_headbob = 0
		

		self:_update_crosshair_offset()
	end

	if self._headbob ~= self._target_headbob then
		local ratio = 4

		if weapon_tweak_data and weapon_tweak_data.headbob and weapon_tweak_data.headbob.speed_ratio then
			ratio = weapon_tweak_data.headbob.speed_ratio
		end

		self._headbob = math.step(self._headbob, self._target_headbob, dt / ratio)

		self._ext_camera:set_shaker_parameter("headbob", "amplitude", self._headbob)
	end	

	if pos_new then		
		if floor_moving_pos then
			pos_new.z = floor_moving_pos.z
		end
	
		self._unit:movement():set_position(pos_new)
		
		if update_velocity then	
			mvector3.set(self._last_velocity_xy, pos_new)		
			mvector3.subtract(self._last_velocity_xy, self._pos)

			if not self._state_data.on_ladder and not self._state_data.on_zipline then
				mvector3.set_z(self._last_velocity_xy, 0)
			end

			mvector3.divide(self._last_velocity_xy, dt)
		else
			mvector3.set_static(self._last_velocity_xy, 0, 0, 0)
		end
	else
		mvector3.set_static(self._last_velocity_xy, 0, 0, 0)
	end

	local cur_pos = pos_new or self._pos

	self:_update_network_jump(cur_pos, false)
	self:_update_network_position(t, dt, cur_pos, pos_new)
end

local melee_vars = {
	"player_melee",
	"player_melee_var2"
}

function PlayerStandard:_do_action_melee(t, input, skip_damage)
	self._state_data.meleeing = nil
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local instant_hit = tweak_data.blackmarket.melee_weapons[melee_entry].instant
	local pre_calc_hit_ray = tweak_data.blackmarket.melee_weapons[melee_entry].hit_pre_calculation
	local melee_damage_delay = tweak_data.blackmarket.melee_weapons[melee_entry].melee_damage_delay or 0
	melee_damage_delay = math.min(melee_damage_delay, tweak_data.blackmarket.melee_weapons[melee_entry].repeat_expire_t)
	local primary = managers.blackmarket:equipped_primary()
	local primary_id = primary.weapon_id
	local bayonet_id = managers.blackmarket:equipped_bayonet(primary_id)
	local bayonet_melee = false

	if bayonet_id and self._equipped_unit:base():selection_index() == 2 then
		bayonet_melee = true
	end
	
	local anim_speed_multiplier = 1
	local t_multiplier = 1
	
	if managers.player:has_category_upgrade("player", "beatemup_basic") then
		anim_speed_multiplier = anim_speed_multiplier + 0.5
		t_multiplier = t_multiplier - 0.25
	end
	
	local stack = self._state_data.stacking_melee_speed
	
	if stack and stack[2] then
		anim_speed_multiplier = anim_speed_multiplier + stack[2]
		local t_multiplier_reduction = stack[2] * 0.5
		t_multiplier = t_multiplier - t_multiplier_reduction
	end
	
	if t_multiplier < 0.01 then
		t_multiplier = 0.01
	end

	self._state_data.melee_expire_t = t + tweak_data.blackmarket.melee_weapons[melee_entry].expire_t * t_multiplier
	
	local repeat_expire_t = math.min(tweak_data.blackmarket.melee_weapons[melee_entry].repeat_expire_t, tweak_data.blackmarket.melee_weapons[melee_entry].expire_t) * t_multiplier
	
	self._state_data.melee_repeat_expire_t = t + repeat_expire_t

	if not instant_hit and not skip_damage then
		melee_damage_delay = melee_damage_delay * t_multiplier
		self._state_data.melee_damage_delay_t = t + melee_damage_delay

		if pre_calc_hit_ray then
			self._state_data.melee_hit_ray = self:_calc_melee_hit_ray(t, 20) or true
		else
			self._state_data.melee_hit_ray = nil
		end
	end

	local send_redirect = instant_hit and (bayonet_melee and "melee_bayonet" or "melee") or "melee_item"

	if instant_hit then
		managers.network:session():send_to_peers_synched("play_distance_interact_redirect", self._unit, send_redirect)
	else
		self._ext_network:send("sync_melee_discharge")
	end

	if self._state_data.melee_charge_shake then
		self._ext_camera:shaker():stop(self._state_data.melee_charge_shake)

		self._state_data.melee_charge_shake = nil
	end

	self._melee_attack_var = 0

	if instant_hit then
		local hit = skip_damage or self:_do_melee_damage(t, bayonet_melee)

		if hit then
			self._ext_camera:play_redirect(bayonet_melee and self:get_animation("melee_bayonet") or self:get_animation("melee"))
		else
			self._ext_camera:play_redirect(bayonet_melee and self:get_animation("melee_miss_bayonet") or self:get_animation("melee_miss"))
		end
	else
		local state = self._ext_camera:play_redirect(self:get_animation("melee_attack"), anim_speed_multiplier)
		local anim_attack_vars = tweak_data.blackmarket.melee_weapons[melee_entry].anim_attack_vars
		self._melee_attack_var = anim_attack_vars and math.random(#anim_attack_vars)

		self:_play_melee_sound(melee_entry, "hit_air", self._melee_attack_var)

		local melee_item_tweak_anim = "attack"
		local melee_item_prefix = ""
		local melee_item_suffix = ""
		local anim_attack_param = anim_attack_vars and anim_attack_vars[self._melee_attack_var]

		if anim_attack_param then
			self._camera_unit:anim_state_machine():set_parameter(state, anim_attack_param, 1)

			melee_item_prefix = anim_attack_param .. "_"
		end

		if self._state_data.melee_hit_ray and self._state_data.melee_hit_ray ~= true then
			self._camera_unit:anim_state_machine():set_parameter(state, "hit", 1)

			melee_item_suffix = "_hit"
		end

		melee_item_tweak_anim = melee_item_prefix .. melee_item_tweak_anim .. melee_item_suffix

		self._camera_unit:base():play_anim_melee_item(melee_item_tweak_anim)
	end
end

function PlayerStandard:_get_melee_charge_lerp_value(t, offset)
	offset = offset or 0
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local max_charge_time = tweak_data.blackmarket.melee_weapons[melee_entry].stats.charge_time
	
	--log("origin time: " .. max_charge_time .. "")
	
	if managers.player:has_category_upgrade("player", "momentummaker_aced") then
		max_charge_time = max_charge_time * 0.5
		--log("mod time: " .. max_charge_time .. "")
	end

	if not self._state_data.melee_start_t then
		return 0
	end

	return math.clamp(t - self._state_data.melee_start_t - offset, 0, max_charge_time) / max_charge_time
end

function PlayerStandard:_do_melee_damage(t, bayonet_melee, melee_hit_ray, melee_entry, hand_id)
	melee_entry = melee_entry or managers.blackmarket:equipped_melee_weapon()
	local instant_hit = tweak_data.blackmarket.melee_weapons[melee_entry].instant
	local melee_damage_delay = tweak_data.blackmarket.melee_weapons[melee_entry].melee_damage_delay or 0
	local charge_lerp_value = instant_hit and 0 or self:_get_melee_charge_lerp_value(t, melee_damage_delay)

	self._ext_camera:play_shaker(melee_vars[math.random(#melee_vars)], math.max(0.3, charge_lerp_value))

	local sphere_cast_radius = 20
	local col_ray = nil

	if melee_hit_ray then
		col_ray = melee_hit_ray ~= true and melee_hit_ray or nil
	else
		col_ray = self:_calc_melee_hit_ray(t, sphere_cast_radius)
	end

	if col_ray and alive(col_ray.unit) then
		local damage, damage_effect = managers.blackmarket:equipped_melee_weapon_damage_info(charge_lerp_value)
		local damage_effect_mul = math.max(managers.player:upgrade_value("player", "melee_knockdown_mul", 1), managers.player:upgrade_value(self._equipped_unit:base():weapon_tweak_data().categories and self._equipped_unit:base():weapon_tweak_data().categories[1], "melee_knockdown_mul", 1))
		damage = damage * managers.player:get_melee_dmg_multiplier()
		damage_effect = damage_effect * damage_effect_mul
		col_ray.sphere_cast_radius = sphere_cast_radius
		local hit_unit = col_ray.unit

		if hit_unit:character_damage() then
			if bayonet_melee then
				self._unit:sound():play("fairbairn_hit_body", nil, false)
			else
				local hit_sfx = "hit_body"

				if hit_unit:character_damage() and hit_unit:character_damage().melee_hit_sfx then
					hit_sfx = hit_unit:character_damage():melee_hit_sfx()
				end

				self:_play_melee_sound(melee_entry, hit_sfx, self._melee_attack_var)
			end

			if not hit_unit:character_damage()._no_blood then
				managers.game_play_central:play_impact_flesh({
					col_ray = col_ray
				})
				managers.game_play_central:play_impact_sound_and_effects({
					no_decal = true,
					no_sound = true,
					col_ray = col_ray
				})
			end

			self._camera_unit:base():play_anim_melee_item("hit_body")
		elseif self._on_melee_restart_drill and hit_unit:base() and (hit_unit:base().is_drill or hit_unit:base().is_saw) then
			hit_unit:base():on_melee_hit(managers.network:session():local_peer():id())
		else
			if bayonet_melee then
				self._unit:sound():play("knife_hit_gen", nil, false)
			else
				self:_play_melee_sound(melee_entry, "hit_gen", self._melee_attack_var)
			end

			self._camera_unit:base():play_anim_melee_item("hit_gen")
			managers.game_play_central:play_impact_sound_and_effects({
				no_decal = true,
				no_sound = true,
				col_ray = col_ray,
				effect = Idstring("effects/payday2/particles/impacts/fallback_impact_pd2")
			})
		end

		local custom_data = nil

		if _G.IS_VR and hand_id then
			custom_data = {
				engine = hand_id == 1 and "right" or "left"
			}
		end

		managers.rumble:play("melee_hit", nil, nil, custom_data)
		managers.game_play_central:physics_push(col_ray)

		local character_unit, shield_knock = nil
		local can_shield_knock = managers.player:has_category_upgrade("player", "shield_knock")

		if can_shield_knock and hit_unit:in_slot(8) and alive(hit_unit:parent()) and not hit_unit:parent():character_damage():is_immune_to_shield_knockback() then
			shield_knock = true
			character_unit = hit_unit:parent()
		end

		character_unit = character_unit or hit_unit

		if character_unit:character_damage() and character_unit:character_damage().damage_melee then
			local dmg_multiplier = 1

			if not managers.enemy:is_civilian(character_unit) and not managers.groupai:state():is_enemy_special(character_unit) then
				dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "non_special_melee_multiplier", 1)
			else
				dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "melee_damage_multiplier", 1)
			end
			
			if managers.player._melee_damage_mult then
				dmg_multiplier = dmg_multiplier + managers.player._melee_damage_mult
			end
			
			dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "melee_" .. tostring(tweak_data.blackmarket.melee_weapons[melee_entry].stats.weapon_type) .. "_damage_multiplier", 1)

			local health_ratio = self._ext_damage:health_ratio()
			local damage_health_ratio = managers.player:get_damage_health_ratio(health_ratio, "melee")

			if damage_health_ratio > 0 then
				local damage_ratio = damage_health_ratio
				dmg_multiplier = dmg_multiplier * (1 + managers.player:upgrade_value("player", "melee_damage_health_ratio_multiplier", 0) * damage_ratio)
			end

			dmg_multiplier = dmg_multiplier * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)
			local target_dead = character_unit:character_damage().dead and not character_unit:character_damage():dead()
			local target_hostile = managers.enemy:is_enemy(character_unit) and not tweak_data.character[character_unit:base()._tweak_table].is_escort and character_unit:brain():is_hostile()
			local life_leach_available = managers.player:has_category_upgrade("temporary", "melee_life_leech") and not managers.player:has_activate_temporary_upgrade("temporary", "melee_life_leech")

			if target_dead and target_hostile and life_leach_available then
				managers.player:activate_temporary_upgrade("temporary", "melee_life_leech")
				self._unit:character_damage():restore_health(managers.player:temporary_upgrade_value("temporary", "melee_life_leech", 1), true)
			end

			local special_weapon = tweak_data.blackmarket.melee_weapons[melee_entry].special_weapon
			local action_data = {
				variant = "melee"
			}

			if tweak_data.blackmarket.melee_weapons[melee_entry].tase_data and character_unit:character_damage().damage_tase then
				action_data.variant = "taser_tased"
			end

			if _G.IS_VR and melee_entry == "weapon" and not bayonet_melee then
				dmg_multiplier = 0.1
			end

			action_data.damage = shield_knock and 0 or damage * dmg_multiplier
			action_data.damage_effect = damage_effect
			action_data.attacker_unit = self._unit
			action_data.col_ray = col_ray

			if shield_knock then
				action_data.shield_knock = can_shield_knock
			end

			action_data.name_id = melee_entry
			action_data.charge_lerp_value = charge_lerp_value

			local defense_data = character_unit:character_damage():damage_melee(action_data)
			
			if managers.player:has_category_upgrade("melee", "stacking_hit_damage_multiplier") then
				if not self._state_data.stacking_dmg_mul or not self._state_data.stacking_dmg_mul.melee then
					self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
					self._state_data.stacking_dmg_mul.melee = self._state_data.stacking_dmg_mul.melee or {
						nil,
						0
					}
				end
				
				if defense_data and defense_data ~= "friendly_fire" then
					if target_dead then --note: actually means "not dead"
						self._state_data.stacking_melee_speed = self._state_data.stacking_melee_speed or {
							nil,
							0
						}
						
						local stack = self._state_data.stacking_melee_speed

						if stack[1] and t < stack[1] then
							if stack[2] < 0.99 then
								stack[2] = stack[2] + 0.25
							end
							stack[1] = t + 1.5
						else
							stack[1] = t + 1.5
							stack[2] = 0.25
						end
					end
				end
			end
			
			--managers.player:reset_bloodthirst_damage()
			
			self:_check_melee_dot_damage(col_ray, defense_data, melee_entry)
			self:_perform_sync_melee_damage(hit_unit, col_ray, action_data.damage)

			return defense_data
		else
			self:_perform_sync_melee_damage(hit_unit, col_ray, damage)
		end
	end

	if managers.player:has_category_upgrade("melee", "stacking_hit_damage_multiplier") then
		if not self._state_data.stacking_dmg_mul or not self._state_data.stacking_dmg_mul.melee then
			self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
			self._state_data.stacking_dmg_mul.melee = self._state_data.stacking_dmg_mul.melee or {
				nil,
				0
			}
		end
		self._state_data.stacking_melee_speed = self._state_data.stacking_melee_speed or {
			nil,
			0
		}
				
		local stack = self._state_data.stacking_melee_speed

		stack[1] = nil
		stack[2] = 0
	end

	return col_ray
end

function PlayerStandard:_update_reload_timers(t, dt, input)
	if self._state_data.reload_enter_expire_t and self._state_data.reload_enter_expire_t <= t then
		self._state_data.reload_enter_expire_t = nil

		self:_start_action_reload(t)
	end

	if self._state_data.reload_expire_t then
		local interupt = nil

		if self._equipped_unit:base():update_reloading(t, dt, self._state_data.reload_expire_t - t) then
			managers.hud:set_ammo_amount(self._equipped_unit:base():selection_index(), self._equipped_unit:base():ammo_info())

			if self._queue_reload_interupt then
				self._queue_reload_interupt = nil
				interupt = true
			end
		end

		if self._state_data.reload_expire_t <= t or interupt then
			managers.player:remove_property("shock_and_awe_reload_multiplier")
			managers.player:consume_bloodthirst_reload()
			
			self._state_data.reload_expire_t = nil

			if self._equipped_unit:base():reload_exit_expire_t() then
				local speed_multiplier = self._equipped_unit:base():reload_speed_multiplier()
				local is_reload_not_empty = not self._equipped_unit:base():started_reload_empty()
				local animation_name = is_reload_not_empty and "reload_not_empty_exit" or "reload_exit"
				local animation = self:get_animation(animation_name)
				self._state_data.reload_exit_expire_t = t + self._equipped_unit:base():reload_exit_expire_t(is_reload_not_empty) / speed_multiplier
				local result = self._ext_camera:play_redirect(animation, speed_multiplier)
				
				self._equipped_unit:base():tweak_data_anim_play(animation_name, speed_multiplier)
			elseif self._equipped_unit then
				if not interupt then
					self._equipped_unit:base():on_reload()
				end

				managers.statistics:reloaded()
				managers.hud:set_ammo_amount(self._equipped_unit:base():selection_index(), self._equipped_unit:base():ammo_info())

				if input.btn_steelsight_state then
					self._steelsight_wanted = true
				elseif self.RUN_AND_RELOAD and self._running and not self._end_running_expire_t and not self._equipped_unit:base():run_and_shoot_allowed() then
					self._ext_camera:play_redirect(self:get_animation("start_running"))
				end
			end
		end
	end

	if self._state_data.reload_exit_expire_t and self._state_data.reload_exit_expire_t <= t then
		self._state_data.reload_exit_expire_t = nil

		if self._equipped_unit then
			managers.statistics:reloaded()
			managers.hud:set_ammo_amount(self._equipped_unit:base():selection_index(), self._equipped_unit:base():ammo_info())

			if input.btn_steelsight_state then
				self._steelsight_wanted = true
			elseif self.RUN_AND_RELOAD and self._running and not self._end_running_expire_t and not self._equipped_unit:base():run_and_shoot_allowed() then
				self._ext_camera:play_redirect(self:get_animation("start_running"))
			end

			if self._equipped_unit:base().on_reload_stop then
				self._equipped_unit:base():on_reload_stop()
			end
		end
	end
end

function PlayerStandard:_activate_mover(mover, velocity)
	self._unit:activate_mover(mover, velocity)
	
	if self._state_data.on_ladder then
		self._unit:mover():set_gravity(Vector3(0, 0, 0))
		self._unit:mover():set_damping(self._tweak_data.gravity / self._tweak_data.terminal_velocity) --sets how fast the player accelerates downwards in the air, i have no clue what the value for this actually represents since its something like 0.14-ish.
		--self._unit:mover():set_damping(self._original_damping_standard)
	else
		self._unit:mover():set_gravity(Vector3(0, 0, -982)) --sets the actual gravity, you can set this to funny values if you want moon-jumping or something
		self._unit:mover():set_damping(self._tweak_data.gravity / self._tweak_data.terminal_velocity) --sets how fast the player accelerates downwards in the air, i have no clue what the value for this actually represents since its something like 0.14-ish.
	end
	
	if self._is_jumping then
		self._unit:mover():set_velocity(velocity)
	end
end

function PlayerStandard:_start_action_ladder(t, ladder_unit)
	self._state_data.on_ladder = true

	self:_interupt_action_running(t)
	self._unit:mover():set_velocity(Vector3())
	self._unit:mover():set_gravity(Vector3(0, 0, 0))
	--self._unit:mover():set_damping(self._original_damping_standard)
	self._unit:mover():jump()
	self._unit:movement():on_enter_ladder(ladder_unit)
end

function PlayerStandard:_end_action_ladder(t, input)
	if not self._state_data.on_ladder then
		return
	end

	self._state_data.on_ladder = false

	if self._unit:mover() then
		self._unit:mover():set_gravity(Vector3(0, 0, -982))
		self._unit:mover():set_damping(self._tweak_data.gravity / self._tweak_data.terminal_velocity)
	end

	self._unit:movement():on_exit_ladder()
end

function PlayerStandard:_start_action_melee(t, input, instant)
	self._equipped_unit:base():tweak_data_anim_stop("fire")
	self:_interupt_action_reload(t)
	self:_interupt_action_steelsight(t)
	--self:_interupt_action_running(t)
	self:_interupt_action_charging_weapon(t)

	self._state_data.melee_charge_wanted = nil
	self._state_data.meleeing = true
	self._state_data.melee_start_t = nil
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local primary = managers.blackmarket:equipped_primary()
	local primary_id = primary.weapon_id
	local bayonet_id = managers.blackmarket:equipped_bayonet(primary_id)
	local bayonet_melee = false

	if bayonet_id and melee_entry == "weapon" and self._equipped_unit:base():selection_index() == 2 then
		bayonet_melee = true
	end

	if instant then
		self:_do_action_melee(t, input)

		return
	end

	self:_stance_entered()

	if self._state_data.melee_global_value then
		self._camera_unit:anim_state_machine():set_global(self._state_data.melee_global_value, 0)
	end

	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	self._state_data.melee_global_value = tweak_data.blackmarket.melee_weapons[melee_entry].anim_global_param

	local t_multiplier = 1
	
	if managers.player:has_category_upgrade("player", "beatemup_basic") then
		t_multiplier = t_multiplier - 0.25
	end
	
	local stack = self._state_data.stacking_melee_speed
	
	if stack and stack[2] then
		local t_multiplier_reduction = stack[2] * 0.5
		t_multiplier = t_multiplier - t_multiplier_reduction
	end
	
	if t_multiplier < 0.01 then
		t_multiplier = 0.01
	end
	
	--log("t_multiplier is " .. tostring(t_multiplier) .. "")

	self._camera_unit:anim_state_machine():set_global(self._state_data.melee_global_value, 1)

	local current_state_name = self._camera_unit:anim_state_machine():segment_state(self:get_animation("base"))
	local attack_allowed_expire_t = tweak_data.blackmarket.melee_weapons[melee_entry].attack_allowed_expire_t or 0.15
	attack_allowed_expire_t = attack_allowed_expire_t * t_multiplier
	self._state_data.melee_attack_allowed_t = t + (current_state_name ~= self:get_animation("melee_attack_state") and attack_allowed_expire_t or 0) 
	local instant_hit = tweak_data.blackmarket.melee_weapons[melee_entry].instant

	if not instant_hit then
		self._ext_network:send("sync_melee_start", 0)
	end

	if current_state_name == self:get_animation("melee_attack_state") then
		self._ext_camera:play_redirect(self:get_animation("melee_charge"))

		return
	end

	local offset = nil

	if current_state_name == self:get_animation("melee_exit_state") then
		local segment_relative_time = self._camera_unit:anim_state_machine():segment_relative_time(self:get_animation("base"))
		offset = (1 - segment_relative_time) * 0.9
	end

	offset = math.max(offset or 0, attack_allowed_expire_t)

	self._ext_camera:play_redirect(self:get_animation("melee_enter"), speed_multiplier, offset)
end

function PlayerStandard:_set_no_run_t(duration)
	self._no_run_t = duration
end

function PlayerStandard:_check_action_run(t, input)
	local valid_t = not self._start_running_t or t - self._start_running_t > 0.05
	if self._setting_hold_to_run and input.btn_run_release or self._running and not self._move_dir then
		self._running_wanted = false

		if self._running and valid_t then
			self:_end_action_running(t)

			if input.btn_steelsight_state and not self._state_data.in_steelsight then
				self._steelsight_wanted = true
			end
		end
	elseif not self._setting_hold_to_run and not self._move_dir then
		self._running_wanted = false
	elseif input.btn_run_press or self._running_wanted then
		if not self._no_run_t and not managers.player:has_activate_temporary_upgrade("temporary", "copr_ability") then
			if not self._running or self._end_running_expire_t then
				self:_start_action_running(t)
			elseif self._running and valid_t and not self._setting_hold_to_run then
				self:_end_action_running(t)

				if input.btn_steelsight_state and not self._state_data.in_steelsight then
					self._steelsight_wanted = true
				end
			end
		else
			self._running_wanted = true
		end
	end
end

function PlayerStandard:_start_action_jump(t, action_start_data)
	if self._running and not self.RUN_AND_RELOAD and not self._equipped_unit:base():run_and_shoot_allowed() then
		self:_interupt_action_reload(t)
		self._ext_camera:play_redirect(self:get_animation("stop_running"), self._equipped_unit:base():exit_run_speed_multiplier())
	end

	self:_interupt_action_running(t)

	self._jump_t = t
	local jump_vec = action_start_data.jump_vel_z * math.UP

	self._unit:mover():jump()

	if self._move_dir then
		local move_dir_clamp = self._move_dir:normalized() * math.min(1, self._move_dir:length())
		self._last_velocity_xy = move_dir_clamp * action_start_data.jump_vel_xy
		self._jump_vel_xy = mvector3.copy(self._last_velocity_xy)
	elseif not mvector3.is_zero(self._last_velocity_xy) then
		self._jump_vel_xy = mvector3.copy(self._last_velocity_xy)
	else
		self._last_velocity_xy = Vector3()
	end

	self:_perform_jump(jump_vec)
	self._gnd_ray = false
end

local tmp_ground_from_vec = Vector3()
local tmp_ground_to_vec = Vector3()
local up_offset_vec = math.UP * 30
local down_offset_vec = math.UP * -40

function PlayerStandard:_update_ground_ray()
	local hips_pos = tmp_ground_from_vec
	local down_pos = tmp_ground_to_vec

	mvector3.set(hips_pos, self._pos)
	mvector3.add(hips_pos, up_offset_vec)
	mvector3.set(down_pos, hips_pos)
	mvector3.add(down_pos, down_offset_vec)

	if self._unit:movement():ladder_unit() then
		self._gnd_ray = self._unit:raycast("ray", hips_pos, down_pos, "slot_mask", self._slotmask_gnd_ray, "ignore_unit", self._unit:movement():ladder_unit(), "ray_type", "body mover", "sphere_cast_radius", 29, "bundle", 9, "report")
	else
		self._gnd_ray = self._unit:raycast("ray", hips_pos, down_pos, "slot_mask", self._slotmask_gnd_ray, "ray_type", "body mover", "sphere_cast_radius", 29, "bundle", 9, "report")
	end

	self._gnd_ray_chk = true
end

function PlayerStandard:_chk_floor_moving_pos(pos)
	local hips_pos = tmp_ground_from_vec
	local down_pos = tmp_ground_to_vec

	mvector3.set(hips_pos, self._pos)
	mvector3.add(hips_pos, up_offset_vec)
	mvector3.set(down_pos, hips_pos)
	mvector3.add(down_pos, down_offset_vec)

	local ground_ray = self._unit:raycast("ray", hips_pos, down_pos, "slot_mask", self._slotmask_gnd_ray, "ray_type", "body mover", "sphere_cast_radius", 29, "bundle", 9)

	if ground_ray then
		return ground_ray
	end
end

function PlayerStandard:_update_foley(t, input)
	if self._state_data.on_zipline then
		return
	end

	if not self._gnd_ray and not self._state_data.on_ladder then
		if not self._state_data.in_air then
			self._state_data.in_air = true
			
			self._state_data.in_air_enter_t = t
			self._state_data.enter_air_pos_z = self._pos.z

			self._unit:set_driving("orientation_object") -- i wonder what its like to constantly have this on lol
		end
	elseif self._state_data.in_air then
		self._unit:set_driving("script")

		self._state_data.in_air = false
		self._is_jumping = nil
		
		if t - self._state_data.in_air_enter_t > 0.02 then
			local from = self._pos + math.UP * 10
			local to = self._pos - math.UP * 60
			local material_name, pos, norm = World:pick_decal_material(from, to, self._slotmask_bullet_impact_targets)
			local height = self._state_data.enter_air_pos_z - self._pos.z
			self._unit:sound():play_land(material_name)
			
			if self._unit:character_damage():damage_fall({
				height = height
			}) then
				local fall_distance_lerp = math.min(5, height / 400)
				--self._running_wanted = false
				
				self._fall_damage_slow_t = t + 1
				managers.rumble:play("hard_land")
				self._ext_camera:play_shaker("player_fall_damage", fall_distance_lerp)
				self._ext_camera:play_shaker("player_land", fall_distance_lerp)
				self:on_melee_stun(t, 1)
				--self:_start_action_ducking(t)
			else
				if self._state_data.diving then					
					self._fall_damage_slow_t = t + 0.4
					managers.rumble:play("hard_land")
					self._ext_camera:play_shaker("player_fall_damage", 1)
					self._ext_camera:play_shaker("player_land", 1)
					
					self._state_data.diving = nil
				else
					self._ext_camera:play_shaker("player_land", 0.5)
				end
			end
		elseif self._state_data.diving then					
			self._fall_damage_slow_t = t + 0.4
			managers.rumble:play("hard_land")
			self._ext_camera:play_shaker("player_fall_damage", 1)
			self._ext_camera:play_shaker("player_land", 1)
			
			self._state_data.diving = nil
		end

		self._state_data.in_air_enter_t = nil
		self._state_data.land_t = t 
		
		managers.rumble:play("land")
	end
	
	if not self._state_data.in_air and self._state_data.land_t and t - self._state_data.land_t >= 0.05 then
		self._jump_t = nil
		self._jump_vel_xy = nil
	end

	self:_check_step(t)
end

function PlayerStandard:_start_action_running(t)
	if not self._move_dir then
		self._running_wanted = true

		return
	end
	
	if self._fall_damage_slow_t then
		return
	end

	if self:on_ladder() or self:_on_zipline() then
		return
	end

	if self._shooting and not self._equipped_unit:base():run_and_shoot_allowed() or self._use_item_expire_t or self._state_data.in_air_enter_t and t - self._state_data.in_air_enter_t > 0.1 or self:_is_throwing_projectile() or self:_is_charging_weapon() then
		self._running_wanted = true

		return
	end

	if self._state_data.ducking and not self:_can_stand() then
		self._running_wanted = true

		return
	end

	if not self:_can_run_directional() then
		return
	end

	self._running_wanted = false

	if managers.player:get_player_rule("no_run") then
		return
	end
	
	if self._unit:movement():is_above_stamina_threshold() then
		local stamina_subtraction = tweak_data.player.movement_state.stamina.JUMP_STAMINA_DRAIN
					
		if managers.player:has_category_upgrade("player", "start_action_stam_drain_reduct") then
			stamina_subtraction = stamina_subtraction * 0.5
		end
		
		self._unit:movement():subtract_stamina(stamina_subtraction)
		
		if managers.player:has_category_upgrade("player", "wavedash") then
			self._wave_dash_t = t + 0.3
		end
	end

	if (not self._state_data.shake_player_start_running or not self._ext_camera:shaker():is_playing(self._state_data.shake_player_start_running)) and managers.user:get_setting("use_headbob") then
		if managers.player:has_category_upgrade("player", "wavedash") then
			if self._unit:movement():is_above_stamina_threshold() then
				self._state_data.shake_player_start_running = self._ext_camera:play_shaker("player_start_running", 1)
			else
				self._state_data.shake_player_start_running = self._ext_camera:play_shaker("player_start_running", 0.75)
			end
		else
			self._state_data.shake_player_start_running = self._ext_camera:play_shaker("player_start_running", 0.75)
		end
	end
	
	self:set_running(true)
	
	local testing = true

	self._end_running_expire_t = nil
	self._start_running_t = t
	self._play_stop_running_anim = nil

	if not self:_is_reloading() or not self.RUN_AND_RELOAD then
		if not self._equipped_unit:base():run_and_shoot_allowed() and not self:_is_meleeing() and not self:_changing_weapon() then
			self._ext_camera:play_redirect(self:get_animation("start_running"))
		else
			if not self:_is_meleeing() and not self:_changing_weapon() then
				self._ext_camera:play_redirect(self:get_animation("idle"))
			end
		end
	end

	if not self.RUN_AND_RELOAD then
		self:_interupt_action_reload(t)
	end

	self:_interupt_action_steelsight(t)
	self:_interupt_action_ducking(t)
end

function PlayerStandard:_end_action_running(t)
	if not self._end_running_expire_t then
		local speed_multiplier = self._equipped_unit:base():exit_run_speed_multiplier()
		self._end_running_expire_t = t + 0.4 / speed_multiplier
		local stop_running = not self._equipped_unit:base():run_and_shoot_allowed() and (not self.RUN_AND_RELOAD or not self:_is_reloading()) and not self:_is_meleeing()

		if stop_running then
			self._ext_camera:play_redirect(self:get_animation("stop_running"), speed_multiplier)
		end
	end
end

function PlayerStandard:_play_interact_redirect(t)
	if self._shooting or not self._equipped_unit:base():start_shooting_allowed() then
		return
	end
	
	if self._melee_stunned then
		return
	end

	if self:_is_reloading() or self:_changing_weapon() or self:_is_meleeing() or self:in_steelsight() then
		return
	end

	if self._running then
		return
	end

	self._state_data.interact_redirect_t = t + 1

	self._ext_camera:play_redirect(self:get_animation("use"))
end

function PlayerStandard:_check_action_deploy_bipod(t, input)
	local new_action = nil
	local action_forbidden = false

	if not input.btn_deploy_bipod then
		return
	end

	action_forbidden = self:in_steelsight() or self:_on_zipline() or self:_is_throwing_projectile() or self:_is_meleeing() or self:is_equipping() or self:_changing_weapon() or self._melee_stunned

	if not action_forbidden then
		local weapon = self._equipped_unit:base()
		local bipod_part = managers.weapon_factory:get_parts_from_weapon_by_perk("bipod", weapon._parts)

		if bipod_part and bipod_part[1] then
			local bipod_unit = bipod_part[1].unit:base()

			bipod_unit:check_state()

			new_action = true
		end
	end

	return new_action
end

function PlayerStandard:_check_action_deploy_underbarrel(t, input)
	local new_action = nil
	local action_forbidden = false

	if not input.btn_deploy_bipod and not self._toggle_underbarrel_wanted then
		return new_action
	end

	action_forbidden = self:in_steelsight() or self:_is_throwing_projectile() or self:_is_meleeing() or self:is_equipping() or self:_changing_weapon() or self:shooting() or self:_is_reloading() or self:is_switching_stances() or self:_interacting() or self:running() and not self._equipped_unit:base():run_and_shoot_allowed() or self._melee_stunned

	if self._running and not self._equipped_unit:base():run_and_shoot_allowed() and not self._end_running_expire_t then
		self:_interupt_action_running(t)

		self._toggle_underbarrel_wanted = true

		return
	end

	if not action_forbidden then
		self._toggle_underbarrel_wanted = false
		local weapon = self._equipped_unit:base()
		local underbarrel_names = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("underbarrel", weapon._factory_id, weapon._blueprint)

		if underbarrel_names and underbarrel_names[1] then
			local underbarrel = weapon._parts[underbarrel_names[1]]

			if underbarrel then
				local underbarrel_base = underbarrel.unit:base()
				local underbarrel_tweak = tweak_data.weapon[underbarrel_base.name_id]

				if weapon.record_fire_mode then
					weapon:record_fire_mode()
				end

				underbarrel_base:toggle()

				new_action = true

				if weapon.reset_cached_gadget then
					weapon:reset_cached_gadget()
				end

				if weapon._update_stats_values then
					weapon:_update_stats_values(true)
				end

				local anim_ids = nil
				local switch_delay = 1

				if underbarrel_base:is_on() then
					anim_ids = Idstring("underbarrel_enter_" .. weapon.name_id)
					switch_delay = underbarrel_tweak.timers.equip_underbarrel

					self:set_animation_state("underbarrel")
				else
					anim_ids = Idstring("underbarrel_exit_" .. weapon.name_id)
					switch_delay = underbarrel_tweak.timers.unequip_underbarrel

					self:set_animation_state("standard")
				end

				if anim_ids then
					self._ext_camera:play_redirect(anim_ids, 1)
				end

				self:set_animation_weapon_hold(nil)
				self:set_stance_switch_delay(switch_delay)

				if alive(self._equipped_unit) then
					managers.hud:set_ammo_amount(self._equipped_unit:base():selection_index(), self._equipped_unit:base():ammo_info())
					managers.hud:set_teammate_weapon_firemode(HUDManager.PLAYER_PANEL, self._unit:inventory():equipped_selection(), self._equipped_unit:base():fire_mode())
				end

				managers.network:session():send_to_peers_synched("sync_underbarrel_switch", self._equipped_unit:base():selection_index(), underbarrel_base.name_id, underbarrel_base:is_on())
			end
		end
	end

	return new_action
end

function PlayerStandard:_check_action_cash_inspect(t, input)
	if not input.btn_cash_inspect_press then
		return
	end

	local action_forbidden = self:_interacting() or self:is_deploying() or self:_changing_weapon() or self:_is_throwing_projectile() or self:_is_meleeing() or self:_on_zipline() or self:running() or self:_is_reloading() or self:in_steelsight() or self:is_equipping() or self:shooting() or self:_is_cash_inspecting(t) or self._melee_stunned

	if action_forbidden then
		return
	end

	self._ext_camera:play_redirect(self:get_animation("cash_inspect"))
	managers.player:send_message(Message.OnCashInspectWeapon)
end

function PlayerStandard:_check_action_steelsight(t, input)
	local new_action = nil
	
	if self._melee_stunned then
		return
	end

	if alive(self._equipped_unit) then
		local result = nil
		local weap_base = self._equipped_unit:base()

		if weap_base.manages_steelsight and weap_base:manages_steelsight() then
			if input.btn_steelsight_press and weap_base.steelsight_pressed then
				result = weap_base:steelsight_pressed()
			elseif input.btn_steelsight_release and weap_base.steelsight_released then
				result = weap_base:steelsight_released()
			end

			if result then
				if result.enter_steelsight and not self._state_data.in_steelsight then
					self:_start_action_steelsight(t)

					new_action = true
				elseif result.exit_steelsight and self._state_data.in_steelsight then
					self:_end_action_steelsight(t)

					new_action = true
				end
			end

			return new_action
		end
	end

	if managers.user:get_setting("hold_to_steelsight") and input.btn_steelsight_release then
		self._steelsight_wanted = false

		if self._state_data.in_steelsight then
			self:_end_action_steelsight(t)

			new_action = true
		end
	elseif input.btn_steelsight_press or self._steelsight_wanted then
		if self._state_data.in_steelsight then
			self:_end_action_steelsight(t)

			new_action = true
		elseif not self._state_data.in_steelsight then
			self:_start_action_steelsight(t)

			new_action = true
		end
	end

	return new_action
end

function PlayerStandard:_check_stop_shooting()
	if self._shooting then
		self._equipped_unit:base():stop_shooting()
		self._camera_unit:base():stop_shooting(self._equipped_unit:base():recoil_wait())

		local weap_base = self._equipped_unit:base()
		local fire_mode = weap_base:fire_mode()

		if fire_mode == "auto" and (not weap_base.akimbo or weap_base:weapon_tweak_data().allow_akimbo_autofire) then
			self._ext_network:send("sync_stop_auto_fire_sound", 0)
		end

		if fire_mode == "auto" and not self:_is_reloading() and not self:_is_meleeing() then
			self._unit:camera():play_redirect(self:get_animation("recoil_exit"))
		end

		self._shooting = false
		self._shooting_t = nil
		self._shooting_t_pop = nil
	end
end

function PlayerStandard:_check_action_primary_attack(t, input)
	local new_action = nil
	local action_wanted = input.btn_primary_attack_state or input.btn_primary_attack_release

	if action_wanted then
		local action_forbidden = self:_is_reloading() or self:_changing_weapon() or self:_is_meleeing() or self._use_item_expire_t or self:_interacting() or self:_is_throwing_projectile() or self:_is_deploying_bipod() or self._menu_closed_fire_cooldown > 0 or self:is_switching_stances() or self._melee_stunned

		if not action_forbidden then
			self._queue_reload_interupt = nil
			local start_shooting = false

			self._ext_inventory:equip_selected_primary(false)

			if self._equipped_unit then
				local weap_base = self._equipped_unit:base()
				local fire_mode = weap_base:fire_mode()
				local fire_on_release = weap_base:fire_on_release()

				if weap_base:out_of_ammo() then
					if input.btn_primary_attack_press then
						weap_base:dryfire()
					end
				elseif weap_base.clip_empty and weap_base:clip_empty() then
					if self:_is_using_bipod() then
						if input.btn_primary_attack_press then
							weap_base:dryfire()
						end

						self._equipped_unit:base():tweak_data_anim_stop("fire")
					else
						new_action = true

						self:_start_action_reload_enter(t)
					end
				elseif self._running and not self._equipped_unit:base():run_and_shoot_allowed() then
					self:_interupt_action_running(t)
				else
					if not self._shooting then
						if weap_base:start_shooting_allowed() then							
							local start = fire_mode == "single" and input.btn_primary_attack_press
							start = start or self._setting_hold_to_fire and input.btn_primary_attack_state
							start = start or fire_mode ~= "single" and input.btn_primary_attack_state
							start = start and not fire_on_release
							start = start or fire_on_release and input.btn_primary_attack_release

							if start then
								weap_base:start_shooting()
								self._camera_unit:base():start_shooting()

								self._shooting = true
								self._shooting_t = t
								if not self._shooting_t_pop then
									self._shooting_t_pop = t + 3
								end
								start_shooting = true

								if fire_mode == "auto" then
									self._unit:camera():play_redirect(self:get_animation("recoil_enter"))

									if (not weap_base.akimbo or weap_base:weapon_tweak_data().allow_akimbo_autofire) and (not weap_base.third_person_important or weap_base.third_person_important and not weap_base:third_person_important()) then
										self._ext_network:send("sync_start_auto_fire_sound", 0)
									end
								end
							end
						else
							self:_check_stop_shooting()

							return false
						end
					end

					local suppression_ratio = self._unit:character_damage():suppression_ratio()
					local spread_mul = math.lerp(1, tweak_data.player.suppression.spread_mul, suppression_ratio)
					local autohit_mul = math.lerp(1, tweak_data.player.suppression.autohit_chance_mul, suppression_ratio)
					local suppression_mul = managers.blackmarket:threat_multiplier()
					local dmg_mul = managers.player:temporary_upgrade_value("temporary", "dmg_multiplier_outnumbered", 1)

					if managers.player:has_category_upgrade("player", "overkill_all_weapons") or weap_base:is_category("shotgun", "saw") then
						dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "overkill_damage_multiplier", 1)
					end

					local health_ratio = self._ext_damage:health_ratio()
					local primary_category = weap_base:weapon_tweak_data().categories[1]
					local damage_health_ratio = managers.player:get_damage_health_ratio(health_ratio, primary_category)

					if damage_health_ratio > 0 then
						local upgrade_name = weap_base:is_category("saw") and "melee_damage_health_ratio_multiplier" or "damage_health_ratio_multiplier"
						local damage_ratio = damage_health_ratio
						dmg_mul = dmg_mul * (1 + managers.player:upgrade_value("player", upgrade_name, 0) * damage_ratio)
					end

					dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)
					dmg_mul = dmg_mul * managers.player:get_property("trigger_happy", 1)
					dmg_mul = dmg_mul * managers.player:get_temporary_property("birthday_multiplier", 1)
					
					local fired = nil

					if fire_mode == "single" then
						if (input.btn_primary_attack_press or input.btn_primary_attack_state) and start_shooting then
							fired = weap_base:trigger_pressed(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
						elseif fire_on_release then
							if input.btn_primary_attack_release then
								fired = weap_base:trigger_released(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
							elseif input.btn_primary_attack_state then
								weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
							end
						end
					elseif input.btn_primary_attack_state then
						fired = weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
					end

					if weap_base.manages_steelsight and weap_base:manages_steelsight() then
						if weap_base:wants_steelsight() and not self._state_data.in_steelsight then
							self:_start_action_steelsight(t)
						elseif not weap_base:wants_steelsight() and self._state_data.in_steelsight then
							self:_end_action_steelsight(t)
						end
					end

					local charging_weapon = fire_on_release and weap_base:charging()

					if not self._state_data.charging_weapon and charging_weapon then
						self:_start_action_charging_weapon(t)
					elseif self._state_data.charging_weapon and not charging_weapon then
						self:_end_action_charging_weapon(t)
					end

					new_action = true

					if fired then
						local fire_rate = weap_base:fire_rate_multiplier()
						
						if managers.player._magic_bullet_aced_t then
							fire_rate = fire_rate * 1.2
						end
						
						if managers.player._pop_pop_mul then
							local mul = 1 +  math.abs(managers.player._pop_pop_mul)
							fire_rate = fire_rate * mul
						end
						
						managers.rumble:play("weapon_fire")

						local weap_tweak_data = tweak_data.weapon[weap_base:get_name_id()]
						local shake_multiplier = weap_tweak_data.shake[self._state_data.in_steelsight and "fire_steelsight_multiplier" or "fire_multiplier"]

						self._ext_camera:play_shaker("fire_weapon_rot", 1 * shake_multiplier)
						self._ext_camera:play_shaker("fire_weapon_kick", 1 * shake_multiplier, 1, 0.15)
						self._equipped_unit:base():tweak_data_anim_stop("unequip")
						self._equipped_unit:base():tweak_data_anim_stop("equip")

						if not self._state_data.in_steelsight or not weap_base:tweak_data_anim_play("fire_steelsight", fire_rate) then
							weap_base:tweak_data_anim_play("fire", fire_rate)
						end

						if fire_mode == "single" and weap_base:get_name_id() ~= "saw" then
							if not self._state_data.in_steelsight then
								self._ext_camera:play_redirect(self:get_animation("recoil"), fire_rate)
							elseif weap_tweak_data.animations.recoil_steelsight then
								self._ext_camera:play_redirect(weap_base:is_second_sight_on() and self:get_animation("recoil") or self:get_animation("recoil_steelsight"), 1)
							end
						end

						local recoil_multiplier = (weap_base:recoil() + weap_base:recoil_addend()) * weap_base:recoil_multiplier()
						
						recoil_multiplier = recoil_multiplier * managers.player:upgrade_value("player", "muscle_memory_aced", 1)

						cat_print("jansve", "[PlayerStandard] Weapon Recoil Multiplier: " .. tostring(recoil_multiplier))

						local up, down, left, right = unpack(weap_tweak_data.kick[self._state_data.in_steelsight and "steelsight" or self._state_data.ducking and "crouching" or "standing"])

						self._camera_unit:base():recoil_kick(up * recoil_multiplier, down * recoil_multiplier, left * recoil_multiplier, right * recoil_multiplier)
						
						if self._shooting_t then
							local time_shooting = t - self._shooting_t
							local achievement_data = tweak_data.achievement.never_let_you_go
							
							if achievement_data and weap_base:get_name_id() == achievement_data.weapon_id and achievement_data.timer <= time_shooting then
								managers.achievment:award(achievement_data.award)

								self._shooting_t = nil
							end
						end
						
						if managers.player:has_category_upgrade(primary_category, "stacking_hit_damage_multiplier") then
							self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
							self._state_data.stacking_dmg_mul[primary_category] = self._state_data.stacking_dmg_mul[primary_category] or {
								nil,
								0
							}
							local stack = self._state_data.stacking_dmg_mul[primary_category]

							if fired.hit_enemy then
								stack[1] = t + managers.player:upgrade_value(primary_category, "stacking_hit_expire_t", 1)
								stack[2] = math.min(stack[2] + 1, tweak_data.upgrades.max_weapon_dmg_mul_stacks or 5)
							else
								stack[1] = nil
								stack[2] = 0
							end
						end

						if weap_base.set_recharge_clbk then
							weap_base:set_recharge_clbk(callback(self, self, "weapon_recharge_clbk_listener"))
						end

						managers.hud:set_ammo_amount(weap_base:selection_index(), weap_base:ammo_info())

						local impact = not fired.hit_enemy

						if weap_base.third_person_important and weap_base:third_person_important() then
							self._ext_network:send("shot_blank_reliable", impact, 0)
						elseif weap_base.akimbo and not weap_base:weapon_tweak_data().allow_akimbo_autofire or fire_mode == "single" then
							self._ext_network:send("shot_blank", impact, 0)
						end
					elseif fire_mode == "single" then
						new_action = false
					end
				end
			end
		elseif self:_is_reloading() and self._equipped_unit:base():reload_interuptable() and input.btn_primary_attack_press then
			self._queue_reload_interupt = true
		end
	end

	if not new_action then
		self:_check_stop_shooting()
	end

	return new_action
end

function PlayerStandard:_interupt_action_reload(t)
	if alive(self._equipped_unit) then
		self._equipped_unit:base():check_bullet_objects()
	end

	if self:_is_reloading() then
		self._equipped_unit:base():tweak_data_anim_stop("reload_enter")
		self._equipped_unit:base():tweak_data_anim_stop("reload")
		self._equipped_unit:base():tweak_data_anim_stop("reload_not_empty")
		self._equipped_unit:base():tweak_data_anim_stop("reload_exit")
	end

	self._state_data.reload_enter_expire_t = nil
	self._state_data.reload_expire_t = nil
	self._state_data.reload_exit_expire_t = nil
	--Thanks ZDANN!!!
	self._queue_reload_interupt = nil

	managers.player:remove_property("shock_and_awe_reload_multiplier")
	self:send_reload_interupt()
end 

function PlayerStandard:_get_swap_speed_multiplier()
	local multiplier = 1.5
	local weapon_tweak_data = self._equipped_unit:base():weapon_tweak_data()
	multiplier = multiplier * managers.player:upgrade_value("weapon", "swap_speed_multiplier", 1)
	multiplier = multiplier * managers.player:upgrade_value("weapon", "passive_swap_speed_multiplier", 1)

	for _, category in ipairs(weapon_tweak_data.categories) do
		multiplier = multiplier * managers.player:upgrade_value(category, "swap_speed_multiplier", 1)
	end

	multiplier = multiplier * managers.player:upgrade_value("team", "crew_faster_swap", 1)
	multiplier = multiplier * managers.player:upgrade_value("player", "muscle_memory_basic", 1)
	
	if self._running then
		multiplier = multiplier * managers.player:upgrade_value("player", "hq_grease_basic", 1)
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "swap_weapon_faster") then
		multiplier = multiplier * managers.player:temporary_upgrade_value("temporary", "swap_weapon_faster", 1)
	end

	multiplier = managers.modifiers:modify_value("PlayerStandard:GetSwapSpeedMultiplier", multiplier)

	return multiplier
end

function PlayerStandard:_start_action_unequip_weapon(t, data)
	local speed_multiplier = self:_get_swap_speed_multiplier()

	self._equipped_unit:base():tweak_data_anim_stop("equip")
	self._equipped_unit:base():tweak_data_anim_play("unequip", speed_multiplier)

	local tweak_data = self._equipped_unit:base():weapon_tweak_data()
	self._change_weapon_data = data
	self._unequip_weapon_expire_t = t + (tweak_data.timers.unequip or 0.5) / speed_multiplier

	--self:_interupt_action_running(t)
	self:_interupt_action_charging_weapon(t)

	local result = self._ext_camera:play_redirect(self:get_animation("unequip"), speed_multiplier)

	self:_interupt_action_reload(t)
	self:_interupt_action_steelsight(t)
	self._ext_network:send("switch_weapon", speed_multiplier, 1)
end

function PlayerStandard:_start_action_equip_weapon(t)
	if self._change_weapon_data.next then
		local next_equip = self._ext_inventory:get_next_selection()
		next_equip = next_equip and next_equip.unit

		if next_equip then
			local state = self:_is_underbarrel_attachment_active(next_equip) and "underbarrel" or "standard"

			self:set_animation_state(state)
		end

		self._ext_inventory:equip_next(false)
	elseif self._change_weapon_data.previous then
		local prev_equip = self._ext_inventory:get_previous_selection()
		prev_equip = prev_equip and next_equip.unit

		if prev_equip then
			local state = self:_is_underbarrel_attachment_active(prev_equip) and "underbarrel" or "standard"

			self:set_animation_state(state)
		end

		self._ext_inventory:equip_previous(false)
	elseif self._change_weapon_data.selection_wanted then
		local select_equip = self._ext_inventory:get_selected(self._change_weapon_data.selection_wanted)
		select_equip = select_equip and select_equip.unit

		if select_equip then
			local state = self:_is_underbarrel_attachment_active(select_equip) and "underbarrel" or "standard"

			self:set_animation_state(state)
		end

		self._ext_inventory:equip_selection(self._change_weapon_data.selection_wanted, false)
	end

	self:set_animation_weapon_hold(nil)

	local speed_multiplier = self:_get_swap_speed_multiplier()
	
	speed_multiplier = speed_multiplier + 0.5 --why not?

	self._equipped_unit:base():tweak_data_anim_stop("unequip")
	self._equipped_unit:base():tweak_data_anim_play("equip", speed_multiplier)

	local tweak_data = self._equipped_unit:base():weapon_tweak_data()
	self._equip_weapon_expire_t = t + (tweak_data.timers.equip or 0.7) / speed_multiplier

	self._ext_camera:play_redirect(self:get_animation("equip"), speed_multiplier)
	self._equipped_unit:base():tweak_data_anim_stop("unequip")
	self._equipped_unit:base():tweak_data_anim_play("equip", speed_multiplier)
	managers.upgrades:setup_current_weapon()
end

function PlayerStandard:_check_action_throw_grenade(t, input)
	local action_wanted = input.btn_throw_grenade_press

	if not action_wanted then
		return
	end

	if not managers.player:can_throw_grenade() then
		return
	end

	local action_forbidden = not PlayerBase.USE_GRENADES or self:chk_action_forbidden("interact") or self._unit:base():stats_screen_visible() or self:_is_throwing_grenade() or self:_interacting() or self:is_deploying() or self:_changing_weapon() or self:_is_meleeing() or self:_is_using_bipod() or self._melee_stunned

	if action_forbidden then
		return
	end

	self:_start_action_throw_grenade(t, input)

	return action_wanted
end

function PlayerStandard:_check_action_throw_projectile(t, input)
	local projectile_entry = managers.blackmarket:equipped_projectile()
	local projectile_tweak = tweak_data.blackmarket.projectiles[projectile_entry]
	
	if projectile_tweak.ability then
		return
	end

	if projectile_tweak.is_a_grenade then
		return self:_check_action_throw_grenade(t, input)
	end

	if self._state_data.projectile_throw_wanted then
		if not self._state_data.projectile_throw_allowed_t then
			self._state_data.projectile_throw_wanted = nil

			self:_do_action_throw_projectile(t, input)
		end

		return
	end

	local action_wanted = input.btn_projectile_press or input.btn_projectile_release or self._state_data.projectile_idle_wanted

	if not action_wanted then
		return
	end

	if not managers.player:can_throw_grenade() then
		self._state_data.projectile_throw_wanted = nil
		self._state_data.projectile_idle_wanted = nil

		return
	end

	if input.btn_projectile_release then
		if self._state_data.throwing_projectile then
			if self._state_data.projectile_throw_allowed_t then
				self._state_data.projectile_throw_wanted = true

				return
			end

			self:_do_action_throw_projectile(t, input)
		end

		return
	end

	local action_forbidden = not PlayerBase.USE_GRENADES or not self:_projectile_repeat_allowed() or self:chk_action_forbidden("interact") or self:_interacting() or self:is_deploying() or self:_changing_weapon() or self:_is_meleeing() or self:_is_using_bipod()

	if action_forbidden then
		return
	end

	self:_start_action_throw_projectile(t, input)

	return true
end

function PlayerStandard:_check_action_interact(t, input)
	local keyboard = self._controller.TYPE == "pc" or managers.controller:get_default_wrapper_type() == "pc"
	local new_action, timer, interact_object = nil

	if input.btn_interact_press then
		if _G.IS_VR then
			self._interact_hand = input.btn_interact_left_press and PlayerHand.LEFT or PlayerHand.RIGHT
		end

		if not self:_action_interact_forbidden() then
			new_action, timer, interact_object = self._interaction:interact(self._unit, input.data, self._interact_hand)

			if new_action then
				self:_play_interact_redirect(t, input)
			end

			if timer then
				new_action = true

				self._ext_camera:camera_unit():base():set_limits(80, 50)
				self:_start_action_interact(t, input, timer, interact_object)
			end

			if not new_action then
				self._start_intimidate = true
				self._start_intimidate_t = t
			end
		end
	end

	local secondary_delay = tweak_data.team_ai.stop_action.delay
	local force_secondary_intimidate = false

	if not new_action and keyboard and input.btn_interact_secondary_press then
		force_secondary_intimidate = true
	end

	if input.btn_interact_release then
		local released = true

		if _G.IS_VR then
			local release_hand = input.btn_interact_left_release and PlayerHand.LEFT or PlayerHand.RIGHT
			released = release_hand == self._interact_hand
		end

		if released then
			if self._start_intimidate and not self:_action_interact_forbidden() then
				if t < self._start_intimidate_t + secondary_delay then
					self:_start_action_intimidate(t)

					self._start_intimidate = false
					
					return
				end
			else
				self:_interupt_action_interact()
			end
		end
	end

	if (self._start_intimidate or force_secondary_intimidate) and not self:_action_interact_forbidden() and (not keyboard and t > self._start_intimidate_t + secondary_delay or force_secondary_intimidate) then
		self:_start_action_intimidate(t, true)

		self._start_intimidate = false
		
		return
	end

	return new_action
end

function PlayerStandard:_start_action_throw_grenade(t, input)
	self:_check_stop_shooting()
	self:_interupt_action_reload(t)
	self:_interupt_action_steelsight(t)
	self:_interupt_action_running(t)
	self:_interupt_action_charging_weapon(t)

	local equipped_grenade = managers.blackmarket:equipped_grenade()
	local projectile_tweak = tweak_data.blackmarket.projectiles[equipped_grenade]

	if self._projectile_global_value then
		self._camera_unit:anim_state_machine():set_global(self._projectile_global_value, 0)

		self._projectile_global_value = nil
	end

	if projectile_tweak.anim_global_param then
		self._projectile_global_value = projectile_tweak.anim_global_param

		self._camera_unit:anim_state_machine():set_global(self._projectile_global_value, 1)
	end

	local delay = self:_get_projectile_throw_offset()

	managers.network:session():send_to_peers_synched("play_distance_interact_redirect_delay", self._unit, "throw_grenade", delay)
	self._ext_camera:play_redirect(Idstring(projectile_tweak.animation or "throw_grenade"))

	local projectile_data = tweak_data.blackmarket.projectiles[equipped_grenade]
	self._state_data.throw_grenade_expire_t = t + (projectile_data.expire_t or 1.1)

	self:_stance_entered()
end

local inputs = PlayerStandard._get_input

function PlayerStandard:_get_input(t, dt, paused)
	if self._state_data.controller_enabled ~= self._controller:enabled() then
		if self._state_data.controller_enabled then
			self._state_data.controller_enabled = self._controller:enabled()

			return self:_create_on_controller_disabled_input()
		end
	elseif not self._state_data.controller_enabled then
		local input = {
			is_customized = true,
			btn_interact_release = managers.menu:get_controller():get_input_released("interact")
		}

		return input
	end

	local pressed = self._controller:get_any_input_pressed()
	local released = self._controller:get_any_input_released()
	local downed = self._controller:get_any_input()

	if paused then
		self._input_paused = true
	elseif not downed then
		self._input_paused = false
	end
	
	if not released and not downed and not self._forced_inputs or self._input_paused then
		return {}
	end
	
	local input = inputs(self, t, dt, paused)
	
	if released then
		input.btn_jump_release = self._controller:get_input_released("jump")
	end
	
	if downed then
		input.btn_jump_state = self._controller:get_input_bool("jump")
	end
	
	return input
end

function PlayerStandard:_upd_nav_data()
	if mvec3_dis_sq(self._m_pos, self._pos) > 4 then
		if self._ext_movement:nav_tracker() then
			self._ext_movement:nav_tracker():move(self._pos)

			local nav_seg_id = self._ext_movement:nav_tracker():nav_segment()

			if self._standing_nav_seg_id ~= nav_seg_id then
				self._standing_nav_seg_id = nav_seg_id
				local metadata = managers.navigation:get_nav_seg_metadata(nav_seg_id)
				local location_id = metadata.location_id

				managers.hud:set_player_location(location_id)
				self._unit:base():set_suspicion_multiplier("area", metadata.suspicion_mul)
				self._unit:base():set_detection_multiplier("area", metadata.detection_mul and 1 / metadata.detection_mul or nil)
				managers.groupai:state():on_criminal_nav_seg_change(self._unit, nav_seg_id)
			end
		end

		if self._pos_reservation then
			managers.navigation:move_pos_rsrv(self._pos_reservation)

			local slow_dist = 100

			mvec3_set(temp_vec1, self._pos_reservation_slow.position)
			mvec3_sub(temp_vec1, self._pos_reservation.position)

			if slow_dist < mvec3_norm(temp_vec1) then
				mvec3_mul(temp_vec1, slow_dist)
				mvec3_add(temp_vec1, self._pos_reservation.position)
				mvec3_set(self._pos_reservation_slow.position, temp_vec1)
				managers.navigation:move_pos_rsrv(self._pos_reservation)
			end
		end

		self._ext_movement:set_m_pos(self._pos)
	end
end

function PlayerStandard:update(t, dt)
	PlayerMovementState.update(self, t, dt)
	self:_calculate_standard_variables(t, dt)
	
	local vel_z = 1

	if self._unit:mover() then
		vel_z = math.clamp(math.abs(self._unit:mover():velocity().z + 100), 0.01, 1)
	end

	if vel_z >= 0.2 or self._is_jumping then
		self:_update_ground_ray()
	else
		self._gnd_ray = true
		self._gnd_ray_chk = true
	end
	
	self:_update_fwd_ray()
	self:_update_check_actions(t, dt)

	if self._menu_closed_fire_cooldown > 0 then
		self._menu_closed_fire_cooldown = self._menu_closed_fire_cooldown - dt
	end

	self:_update_movement(t, dt)
	self:_upd_nav_data()
	managers.hud:_update_crosshair_offset(t, dt)
	self:_update_omniscience(t, dt)
	self:_upd_stance_switch_delay(t, dt)
end

function PlayerStandard:_update_check_actions(t, dt, paused)
	local input = self:_get_input(t, dt, paused)
	self:_update_foley(t, input)

	self:_determine_move_direction()
	
	if self._melee_stunned and not self._melee_stunned_expire_t or self._melee_stunned_expire_t and self._melee_stunned_expire_t < t then
		self._melee_stunned = nil
		self:end_melee_stun()
	end
	
	if self._wave_dash_t and self._wave_dash_t < t then
		self._wave_dash_t = nil
		self._speed_is_wavedash_boost = nil
	end
	
	if self._fall_damage_slow_t and self._fall_damage_slow_t < t then
		self._fall_damage_slow_t = nil
	end
	
	if self._no_run_t then
		if self._running then
			self:_interupt_action_running(t)
		end
	
		self._no_run_t = self._no_run_t - dt
		
		if self._no_run_t <= 0 then
			self._no_run_t = nil
		end
	end
	
	if self._state_data.in_air_enter_t then
		local t_in_air = t - self._state_data.in_air_enter_t
		
		if t_in_air > 0.1 then
			self:_interupt_action_running(t)
		end
	end
	
	self:_update_interaction_timers(t)
	self:_update_throw_projectile_timers(t, input)
	self:_update_reload_timers(t, dt, input)
	self:_update_melee_timers(t, input)
	self:_update_charging_weapon_timers(t, input)
	self:_update_use_item_timers(t, input)
	self:_update_equip_weapon_timers(t, input)
	self:_update_running_timers(t)
	self:_update_zipline_timers(t, dt)

	if self._change_item_expire_t and self._change_item_expire_t <= t then
		self._change_item_expire_t = nil
	end

	if self._change_weapon_pressed_expire_t and self._change_weapon_pressed_expire_t <= t then
		self._change_weapon_pressed_expire_t = nil
	end

	self:_update_steelsight_timers(t, dt)

	if input.btn_stats_screen_press then
		self._unit:base():set_stats_screen_visible(true)
	elseif input.btn_stats_screen_release then
		self._unit:base():set_stats_screen_visible(false)
	end

	local new_action = nil
	local anim_data = self._ext_anim
	new_action = new_action or self:_check_action_interact(t, input)
	
	local projectile_entry = managers.blackmarket:equipped_projectile()
	local projectile_tweak = tweak_data.blackmarket.projectiles[projectile_entry]
		
	if projectile_tweak.ability then
		self:_check_action_use_ability(t, input)
	else
		new_action = new_action or self:_check_action_throw_projectile(t, input)
	end
	
	new_action = new_action or self:_check_action_weapon_gadget(t, input)
	new_action = new_action or self:_check_action_weapon_firemode(t, input)
	new_action = new_action or self:_check_action_melee(t, input)
	new_action = new_action or self:_check_action_reload(t, input)
	new_action = new_action or self:_check_change_weapon(t, input)

	if not new_action then
		new_action = self:_check_action_primary_attack(t, input)

		if not _G.IS_VR and not new_action then
			self:_check_stop_shooting()
		end
	end

	new_action = new_action or self:_check_action_equip(t, input)
	new_action = new_action or self:_check_use_item(t, input)

	self:_check_action_jump(t, input)
	
	self:_check_action_run(t, input)
	
	self:_check_action_ladder(t, input)
	self:_check_action_zipline(t, input)
	self:_check_action_cash_inspect(t, input)

	if not new_action then
		new_action = self:_check_action_deploy_bipod(t, input)
		new_action = new_action or self:_check_action_deploy_underbarrel(t, input)
	end

	self:_check_action_change_equipment(t, input)
	self:_check_action_duck(t, input)
	self:_check_action_steelsight(t, input)
	self:_check_action_night_vision(t, input)
	
	self:_find_pickups(t)
end

function PlayerStandard:_add_unit_to_char_table(char_table, unit, unit_type, interaction_dist, interaction_through_walls, tight_area, priority, my_head_pos, cam_fwd, ray_ignore_units, ray_types)
	if unit:unit_data().disable_shout and not unit:brain():interaction_voice() then
		return
	end

	local u_head_pos = unit_type == 3 and unit:base():get_mark_check_position() or unit:movement():m_head_pos() + math.UP * 30
	local vec = u_head_pos - my_head_pos
	local dis = mvector3.normalize(vec)
	local max_dis = interaction_dist

	if dis < max_dis then
		local max_angle = math.max(8, math.lerp(tight_area and 30 or 90, tight_area and 10 or 30, dis / max_dis))
		local angle = vec:angle(cam_fwd)

		if angle < max_angle then
			local ing_wgt = dis * dis * (1 - vec:dot(cam_fwd)) / priority

			if interaction_through_walls then
				table.insert(char_table, {
					unit = unit,
					inv_wgt = ing_wgt,
					unit_type = unit_type
				})
			else
				local ray = self._unit:raycast("ray", my_head_pos, u_head_pos, "slot_mask", self._slotmask_AI_visibility, "ray_type", ray_types or "ai_vision", "ignore_unit", ray_ignore_units or {})

				if not ray or mvector3.distance_sq(ray.position, u_head_pos) < 900 then
					table.insert(char_table, {
						unit = unit,
						inv_wgt = ing_wgt,
						unit_type = unit_type
					})
				end
			end
		end
	end
end

function PlayerStandard:_action_interact_forbidden()
	local action_forbidden = self:chk_action_forbidden("interact") or self._unit:base():stats_screen_visible() or self:_interacting() or self._ext_movement:has_carry_restriction() or self:is_deploying() or self._melee_stunned

	return action_forbidden
end

function PlayerStandard:_play_distance_interact_redirect(t, variant)
	managers.network:session():send_to_peers_synched("play_distance_interact_redirect", self._unit, variant)

	if self._state_data.in_steelsight then
		return
	end

	if self._shooting or not self._equipped_unit:base():start_shooting_allowed() then
		return
	end

	if self:_is_reloading() or self:_changing_weapon() or self:_is_meleeing() or self._use_item_expire_t then
		return
	end
	
	if self._running and not self._equipped_unit:base():run_and_shoot_allowed() then
		return
	end
	
	if self:is_deploying() or self:_changing_weapon() or self:_is_throwing_projectile() or self:_interacting() then
		return
	end
	
	if self._melee_stunned then
		return
	end

	self._state_data.interact_redirect_t = t + 1

	self._ext_camera:play_redirect(Idstring(variant))
end

function PlayerStandard:_check_action_use_ability(t, input)
	local action_wanted = input.btn_throw_grenade_press

	if not action_wanted then
		return
	end
	
	if not managers.player:can_throw_grenade() then
		return
	end

	local equipped_ability = managers.blackmarket:equipped_grenade()

	managers.player:attempt_ability(equipped_ability) --return nothing in order to allow other actions while activating these
end

function PlayerStandard:_do_action_intimidate(t, interact_type, sound_name, skip_alert)
	if sound_name then
		self._intimidate_t = t

		self:say_line(sound_name, skip_alert)

		if _G.IS_VR then
			self._unit:hand():intimidate(self._interact_hand)
		end

		if interact_type and not self:_is_using_bipod() then
			self:_play_distance_interact_redirect(t, interact_type)
		end
	end
end

function PlayerStandard:_start_action_interact(t, input, timer, interact_object)
	self:_interupt_action_reload(t)
	self:_interupt_action_steelsight(t)
	self:_interupt_action_running(t)
	self:_interupt_action_charging_weapon(t)
	self:_interupt_action_melee(t)
	self:_interupt_action_interact(t)
	self:_interupt_action_throw_grenade(t)
	self:_interupt_action_throw_projectile(t)

	local final_timer = timer
	final_timer = managers.modifiers:modify_value("PlayerStandard:OnStartInteraction", final_timer, interact_object)
	self._interact_expire_t = final_timer
	local start_timer = 0
	self._interact_params = {
		object = interact_object,
		timer = final_timer,
		tweak_data = interact_object:interaction().tweak_data
	}

	self:_play_unequip_animation()
	managers.hud:show_interaction_bar(start_timer, final_timer)
	managers.network:session():send_to_peers_synched("sync_teammate_progress", 1, true, self._interact_params.tweak_data, final_timer, false)
	self._unit:network():send("sync_interaction_anim", true, self._interact_params.tweak_data)
end

