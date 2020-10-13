local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_mul = mvector3.multiply
local mvec3_sub = mvector3.subtract
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_dis = mvector3.distance
local mvec3_set_l = mvector3.set_length
local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec3_cross = mvector3.cross
local mvec3_rot = mvector3.rotate_with
local mvec3_rand_orth = mvector3.random_orthogonal
local mvec3_lerp = mvector3.lerp
local mvec3_copy = mvector3.copy
local mrot_axis_angle = mrotation.set_axis_angle
local math_min = math.min
local math_lerp = math.lerp
local math_round = math.round
local math_random = math.random
local math_clamp = math.clamp
local math_up = math.UP
local temp_vec2 = Vector3()
local temp_rot1 = Rotation()

function CopActionShoot:init(action_desc, common_data)
	self._common_data = common_data
	self._ext_movement = common_data.ext_movement
	self._ext_anim = common_data.ext_anim
	self._ext_brain = common_data.ext_brain
	self._ext_inventory = common_data.ext_inventory
	self._ext_base = common_data.ext_base
	self._body_part = action_desc.body_part
	self._machine = common_data.machine
	self._unit = common_data.unit
	local weapon_unit = self._ext_inventory:equipped_unit()

	if not weapon_unit then
		return false
	end

	local weap_tweak = weapon_unit:base():weapon_tweak_data()
	local weapon_usage_tweak = common_data.char_tweak.weapon[weap_tweak.usage]
	self._doom_enemy = common_data.char_tweak.stop_firing_on_hurt
	self._weapon_unit = weapon_unit
	self._weapon_base = weapon_unit:base()
	self._weap_tweak = weap_tweak
	self._w_usage_tweak = weapon_usage_tweak

	self._aim_delay_minmax = weapon_usage_tweak.aim_delay or {0, 0}
	self._focus_delay = weapon_usage_tweak.focus_delay or 0
	self._focus_displacement = weapon_usage_tweak.focus_dis or 500
	self._spread = weapon_usage_tweak.spread or 20
	self._miss_dis = weapon_usage_tweak.miss_dis or 30
	self._automatic_weap = weap_tweak.auto and weapon_usage_tweak.autofire_rounds and true or nil
	self._falloff = weapon_usage_tweak.FALLOFF or {
		{
			dmg_mul = 1,
			r = 1500,
			acc = {
				0.2,
				0.6
			},
			recoil = {
				0.45,
				0.8
			},
			mode = {
				1,
				3,
				3,
				1
			}
		}
	}

	self._variant = action_desc.variant
	self._body_part = action_desc.body_part
	self._shoot_t = 0

	local suppressive = self._weapon_base.suppression and self._weapon_base.suppression >= 2 or nil
	self._fireline_t = suppressive and 2 or 0.7

	local t = TimerManager:game():time()
	self._melee_timeout_t = t

	local shoot_from_pos = self._ext_movement:m_head_pos()
	self._shoot_from_pos = shoot_from_pos
	
	self._mindcontrol_table = {
		effect = Idstring("effects/pd2_mod_hh/particles/weapons/lotus_passive"),
		parent = self._unit:get_object(Idstring("RightForeArm"))
	}
	
	if PD2THHSHIN and PD2THHSHIN:GlintEnabled() then
		if self._weapon_base._hivis then
			self._hivis = true
			self._hivis_table = {
				effect = Idstring("effects/pd2_mod_hh/particles/character/prefire_glint"),
				parent = self._unit:get_object(Idstring("Head"))
			}
		end
	end

	self._shield = alive(self._ext_inventory._shield_unit) and self._ext_inventory._shield_unit or nil
	self._tank_animations = self._ext_movement._anim_global == "tank" and true or nil
	self._is_team_ai = managers.groupai:state():is_unit_team_AI(self._unit) and true or nil
	self._shield_slotmask = managers.slot:get_mask("enemy_shield_check")
	self._use_mindcontrol = common_data.char_tweak.use_lotus_effect

	if not self._is_team_ai then
		if self._ext_brain.converted and self._ext_brain:converted() or managers.groupai:state():is_enemy_converted_to_criminal(self._unit) then
			self._is_converted = true
		end
	end

	self._draw_melee_sphere_rays = nil
	self._draw_aim_delay_vis_proc = nil
	self._draw_fire_line_ray = nil
	self._draw_focus_displacement = nil
	self._draw_focus_delay_vis_reset = nil

	if not self._shield then
		local melee_weapon = self._ext_base.melee_weapon and self._ext_base:melee_weapon()

		if melee_weapon then
			local damage = 3
			local dmg_mul = 1
			local speed = 1
			local retry_delay = {1, 1}
			local range = 150
			local slotmask = managers.slot:get_mask("bullet_impact_targets_no_police")
			slotmask = slotmask + 3
			local hit_player = true
			local electrical = nil
			local shield_knock = nil
			local anim_param = nil
			local anim_vars = {
				"var1",
				"var2"
			}

			if self._is_team_ai then
				damage = self._w_usage_tweak.melee_dmg
				slotmask = managers.slot:get_mask("bullet_impact_targets_no_criminals")
				shield_knock = true
				hit_player = nil
			elseif self._is_converted then
				slotmask = managers.slot:get_mask("bullet_impact_targets_no_criminals")
				hit_player = nil
			end

			if self._w_usage_tweak.melee_retry_delay then
				retry_delay = self._w_usage_tweak.melee_retry_delay
			end

			local is_weapon = melee_weapon == "weapon"

			if is_weapon then
				if self._w_usage_tweak.melee_dmg then
					damage = self._w_usage_tweak.melee_dmg
				end

				if self._w_usage_tweak.melee_speed then
					speed = self._w_usage_tweak.melee_speed
				end
			else
				if self._common_data.char_tweak.melee_weapon_dmg_multiplier then
					dmg_mul = self._common_data.char_tweak.melee_weapon_dmg_multiplier
				elseif self._w_usage_tweak.melee_dmg then
					damage = self._w_usage_tweak.melee_dmg
				end

				if self._common_data.char_tweak.melee_weapon_speed then
					speed = self._common_data.char_tweak.melee_weapon_speed
				elseif self._w_usage_tweak.melee_speed then
					speed = self._w_usage_tweak.melee_speed
				end

				local melee_weapon_stats = tweak_data.weapon.npc_melee[melee_weapon]

				if melee_weapon_stats then
					if self._w_usage_tweak.melee_dmg then
						damage = self._w_usage_tweak.melee_dmg				
					elseif melee_weapon_stats.damage then
						damage = melee_weapon_stats.damage
					end

					if melee_weapon_stats.range then
						range = melee_weapon_stats.range
					end

					if melee_weapon_stats.electrical then
						electrical = true
					end
					
					if melee_weapon_stats.animation_param then
						anim_param = melee_weapon_stats.animation_param
					end
				end

				if self._common_data.char_tweak.melee_anims then
					anim_vars = self._common_data.char_tweak.melee_anims
				end
			end

			self._melee_weapon_data = {
				melee_weapon = melee_weapon,
				damage = damage,
				dmg_mul = dmg_mul,
				speed = speed,
				retry_delay = retry_delay,
				range = range,
				slotmask = slotmask,
				hit_player = hit_player,
				electrical = electrical,
				shield_knock = shield_knock,
				anim_param = anim_param,
				anim_vars = anim_vars
			}
		end
	end

	self._is_server = Network:is_server()
	self._is_shin_shootout = Global.game_settings.one_down and true or nil

	if Global.game_settings.incsmission and managers.crime_spree then
		self._cs_acc_mul = managers.crime_spree:get_acc_mult()
	end

	if self._is_server then
		self._ext_movement:set_stance_by_code(3)
		common_data.ext_network:send("action_aim_state", true)
	else
		self._turn_allowed = true
		self._turn_speed = nil

		local difficulty_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)

		if not self._tank_animations then
			if difficulty_index == 8 then
				self._turn_speed = 1.75
			elseif difficulty_index == 6 or difficulty_index == 7 then
				self._turn_speed = 1.5
			else
				self._turn_speed = 1.25
			end
		end
	end

	local preset_name = self._ext_anim.base_aim_ik or "spine"
	local preset_data = self._ik_presets[preset_name]
	self._ik_preset = preset_data
	self[preset_data.start](self)

	self:on_attention(common_data.attention)

	CopActionAct._create_blocks_table(self, action_desc.blocks)

	self._skipped_frames = 1

	return true
end

function CopActionShoot:on_exit()
	if self._is_server then
		if not self._exiting_to_reload then
			if not self._attention or not self._attention.reaction or self._attention.reaction < AIAttentionObject.REACT_AIM then
				self._ext_movement:set_stance_by_code(2)
			end
		end

		self._common_data.ext_network:send("action_aim_state", false)
	end

	if self._modifier_on then
		self[self._ik_preset.stop](self)
	end
	
	if self._mindcontrol_effect then
		World:effect_manager():kill(self._mindcontrol_effect)
		self._mindcontrol_effect = nil
	end

	if self._autofiring then
		self._weapon_base:stop_autofire()
		self._ext_movement:play_redirect("up_idle")
	end

	if self._shooting_player and alive(self._attention.unit) then
		self._attention.unit:movement():on_targetted_for_attack(false, self._common_data.unit)
	end
end

function CopActionShoot:on_attention(attention, old_attention)
	if self._shooting_player and old_attention and alive(old_attention.unit) then
		old_attention.unit:movement():on_targetted_for_attack(false, self._common_data.unit)
	end

	self._shooting_player = nil
	self._shooting_husk_unit = nil
	self._next_vis_ray_t = nil

	if attention then
		local t = TimerManager:game():time()

		self[self._ik_preset.start](self)

		local vis_state = self._ext_base:lod_stage()

		if vis_state and vis_state < 3 and self[self._ik_preset.get_blend](self) > 0 then
			self._aim_transition = {
				duration = 0.333,
				start_t = t,
				start_vec = mvector3.copy(self._common_data.look_vec)
			}
			self._get_target_pos = self._get_transition_target_pos
		else
			self._aim_transition = nil
			self._get_target_pos = nil
		end

		self._mod_enable_t = t + 0.5
		local ding = nil
		local play_it_here = nil

		if attention.unit then
			if attention.unit:base() and attention.unit:base().is_local_player then
				self._shooting_player = true
				local vis_state = self._ext_base:lod_stage()
				if self._hivis and self._ext_movement._allow_fire and self._ext_movement._allow_fire == true then
					if not vis_state then
						self._play_hivis_glint = true
					else
						play_it_here = true
					end
				end
				attention.unit:movement():on_targetted_for_attack(true, self._unit)
			else
				if self._is_server then
					if attention.unit:base() and attention.unit:base().is_husk_player then
						self._shooting_husk_unit = true
						self._next_vis_ray_t = t
					end
				else
					self._shooting_husk_unit = true
					self._next_vis_ray_t = t
				end
			end

			self._line_of_sight_t = t - 2

			local target_pos, _, target_dis = self:_get_target_pos(self._shoot_from_pos, attention, t)
			local usage_tweak = self._w_usage_tweak
			local shoot_hist = self._shoot_history
			local aim_delay = 0
			local aim_delay_minmax = self._aim_delay_minmax

			if shoot_hist then
				local displacement = mvec3_dis(target_pos, shoot_hist.m_last_pos)
				
				if play_it_here then
					local dis = mvec3_dis(target_pos, self._shoot_from_pos)
					
					if dis <= 300 then
						ding = true
					end
				end
				
				if displacement > self._focus_displacement then
					if self._draw_focus_displacement then
						local line_1 = Draw:brush(Color.blue:with_alpha(0.5), 2)
						line_1:cylinder(self._shoot_from_pos, shoot_hist.m_last_pos, 0.5)

						local line_2 = Draw:brush(Color.blue:with_alpha(0.5), 2)
						line_2:cylinder(self._shoot_from_pos, target_pos, 0.5)

						local line_3 = Draw:brush(Color.blue:with_alpha(0.5), 2)
						line_3:cylinder(target_pos, shoot_hist.m_last_pos, 0.5)
					end

					if aim_delay_minmax[1] ~= 0 or aim_delay_minmax[2] ~= 0 then
						if aim_delay_minmax[1] == aim_delay_minmax[2] then
							aim_delay = aim_delay_minmax[1]
						else
							local lerp_dis = math_min(1, self._focus_displacement / displacement)

							aim_delay = math_lerp(aim_delay_minmax[2], aim_delay_minmax[1], lerp_dis)
						end

						if self._common_data.is_suppressed and self._is_shin_shootout then
							aim_delay = aim_delay * 1.5
						end
					end

					self._shoot_t = t + aim_delay
					local melee_delay = math_min(aim_delay, 0.35)
					self._melee_start_allowed_t = t + melee_delay
					shoot_hist.focus_start_t = t
				end

				shoot_hist.m_last_pos = mvec3_copy(target_pos)
				if shoot_hist.unit then
					if shoot_hist.unit ~= attention.unit then
						self._played_hivis_glint = nil
					end
				end
				shoot_hist.unit = attention.unit
			else
				if aim_delay_minmax[1] ~= 0 or aim_delay_minmax[2] ~= 0 then
					if aim_delay_minmax[1] == aim_delay_minmax[2] then
						aim_delay = aim_delay_minmax[1]
					else
						local lerp_dis = math_min(1, target_dis / self._falloff[#self._falloff].r)

						aim_delay = math_lerp(aim_delay_minmax[1], aim_delay_minmax[2], lerp_dis)
					end

					if self._common_data.is_suppressed and not self._is_shin_shootout then
						aim_delay = aim_delay * 1.5
					end
				end
				
				if play_it_here then
					local dis = target_dis
					
					if dis <= 300 then
						ding = true
					end
				end

				self._shoot_t = t + aim_delay
				local melee_delay = math_min(aim_delay, 0.35)
				self._melee_start_allowed_t = t + melee_delay

				shoot_hist = {
					focus_start_t = t,
					focus_delay = self._focus_delay,
					m_last_pos = mvec3_copy(target_pos),
					unit = attention.unit
				}
				self._shoot_history = shoot_hist
			end
		end
		
		if self._use_mindcontrol then
			if not self._mindcontrol_effect then
				self._mindcontrol_effect = World:effect_manager():spawn(self._mindcontrol_table)
			end
		end
		
		if play_it_here then
			self:play_glint_effect(ding)
		end
	else
		self[self._ik_preset.stop](self)
		
		if self._mindcontrol_effect then
			World:effect_manager():kill(self._mindcontrol_effect)
			self._mindcontrol_effect = nil
		end

		if self._aim_transition then
			self._aim_transition = nil
			self._get_target_pos = nil
		end
	end

	self._attention = attention
end

function CopActionShoot:play_glint_effect(ding)
	if self._played_hivis_glint then
		return
	end
	
	local done = World:effect_manager():spawn(self._hivis_table)
		
	if ding then
		self._unit:sound():play("bell_ring")
	end
	
	if done then
		self._played_hivis_glint = true
	end
end

function CopActionShoot:update(t)
	local vis_state = self._ext_base:lod_stage()
	vis_state = vis_state or 4

	if not self._autofiring and vis_state ~= 1 then
		if self._skipped_frames < vis_state * 3 then
			self._skipped_frames = self._skipped_frames + 1

			return
		else
			self._skipped_frames = 1
		end
	end

	local shoot_from_pos = self._shoot_from_pos
	local ext_anim = self._ext_anim
	local target_pos, target_vec, target_dis, autotarget = nil

	if self._attention then
		target_pos, target_vec, target_dis, autotarget = self:_get_target_pos(shoot_from_pos, self._attention, t)
		local tar_vec_flat = temp_vec2

		mvec3_set(tar_vec_flat, target_vec)
		mvec3_set_z(tar_vec_flat, 0)
		mvec3_norm(tar_vec_flat)

		local fwd = self._common_data.fwd
		local fwd_dot = mvec3_dot(fwd, tar_vec_flat)

		if self._turn_allowed then
			local active_actions = self._common_data.active_actions

			if not active_actions[2] or active_actions[2]:type() == "idle" then
				local queued_actions = self._common_data.queued_actions

				if not queued_actions or not queued_actions[1] and not queued_actions[2] then
					if not self._ext_movement:chk_action_forbidden("turn") then
						local fwd_dot_flat = mvec3_dot(tar_vec_flat, fwd)

						if fwd_dot_flat < 0.96 then
							local spin = tar_vec_flat:to_polar_with_reference(fwd, math.UP).spin
							local new_action_data = {
								body_part = 2,
								type = "turn",
								speed = self._turn_speed,
								angle = spin
							}

							self._ext_movement:action_request(new_action_data)
						end
					end
				end
			end
		end

		target_vec = self:_upd_ik(target_vec, fwd_dot, t)
	end
	
	local shouldnt_shoot = nil
	
	if self._doom_enemy and ext_anim.upper_body_hurt then
		shouldnt_shoot = true
		--log("doom")
	end

	if not ext_anim.reload and not ext_anim.equip and not ext_anim.melee and not shouldnt_shoot then
		local can_melee = self._melee_weapon_data and self._common_data.allow_fire and target_vec and true or nil

		if can_melee then
			if self._is_server or autotarget then
				local melee_start_range = self._melee_weapon_data.range - 20

				if target_dis > melee_start_range then
					can_melee = nil
				end
			else
				can_melee = nil
			end
		end
		
		local do_melee = self._melee_start_allowed_t and self._melee_start_allowed_t < t and can_melee and self:check_melee_start(t, self._attention, target_dis, autotarget, shoot_from_pos) and self:_chk_start_melee()
		
		if do_melee then
			if self._autofiring then
				self._weapon_base:stop_autofire()

				self._autofiring = nil
				self._autoshots_fired = nil
			end

			self._shoot_t = t + 1
		elseif self._weapon_base:clip_empty() then
			if self._autofiring then
				self._weapon_base:stop_autofire()
				self._ext_movement:play_redirect("up_idle")

				self._autofiring = nil
				self._autoshots_fired = nil
			end

			if self._is_server then
				self._exiting_to_reload = true

				local reload_action = {
					body_part = 3,
					type = "reload"
				}

				self._ext_movement:action_request(reload_action)
			end
		elseif self._autofiring then
			if not target_vec or not self._common_data.allow_fire then
				self._weapon_base:stop_autofire()

				self._shoot_t = t + 0.6
				self._autofiring = nil
				self._autoshots_fired = nil

				self._ext_movement:play_redirect("up_idle")
			else
				local spread = self._spread
				local falloff, i_range = self:_get_shoot_falloff(target_dis, self._falloff)
				local dmg_buff = self._ext_base:get_total_buff("base_damage")
				local dmg_mul = (1 + dmg_buff) * falloff.dmg_mul
				local new_target_pos = self._shoot_history and self:_get_unit_shoot_pos(t, target_pos, target_dis, falloff, i_range, autotarget)

				if new_target_pos then
					target_pos = new_target_pos
				else
					spread = math_min(20, spread)
				end

				local spread_pos = temp_vec2

				mvec3_rand_orth(spread_pos, target_vec)
				mvec3_set_l(spread_pos, spread)
				mvec3_add(spread_pos, target_pos)
				mvec3_dir(target_vec, shoot_from_pos, spread_pos)

				local fired = self._weapon_base:trigger_held(shoot_from_pos, target_vec, dmg_mul, autotarget, nil, nil, nil, self._attention.unit)

				if fired then
					if vis_state == 1 and not ext_anim.recoil and not ext_anim.base_no_recoil and not ext_anim.move then
						if self._tank_animations then
							self._ext_movement:play_redirect("recoil_single")
						else
							self._ext_movement:play_redirect("recoil_auto")
						end
					end

					if not self._autofiring or self._autofiring - 1 <= self._autoshots_fired then
						self._autofiring = nil
						self._autoshots_fired = nil

						self._weapon_base:stop_autofire()
						self._ext_movement:play_redirect("up_idle")

						local lerp_dis = math_min(1, target_dis / self._falloff[#self._falloff].r)
						local shoot_delay = math_lerp(falloff.recoil[1], falloff.recoil[2], lerp_dis)
						
						if self._unit:character_damage()._punk_effect then
							shoot_delay = shoot_delay * 0.25
						end

						self._shoot_t = t + shoot_delay
					else
						self._autoshots_fired = self._autoshots_fired + 1
					end
				end
			end
		elseif self._common_data.allow_fire and target_vec and self._mod_enable_t < t then
			local shoot = nil
			
			if vis_state < 4 and self._play_hivis_glint then
				if self._hivis and self._ext_movement._allow_fire and self._ext_movement._allow_fire == true then
					local ding = nil
					if target_dis and target_dis <= 300 then
						ding = true
					end
					
					self:play_glint_effect(ding)
				end
			end

			if self._common_data.char_tweak.no_move_and_shoot and self._common_data.active_actions[2] and self._common_data.active_actions[2]:type() == "walk" then
				local moving_cooldown = self._common_data.char_tweak.move_and_shoot_cooldown or 1

				self._shoot_t = t + moving_cooldown
			elseif self._line_of_sight_t then
				if not self._shooting_husk_unit or self._shooting_husk_unit and self._next_vis_ray_t and self._next_vis_ray_t < t or not self._next_vis_ray_t and self._shooting_husk_unit then
					if self._shooting_husk_unit then
						self._next_vis_ray_t = t + 2
					end

					local fire_line_is_obstructed = self._unit:raycast("ray", shoot_from_pos, target_pos, "slot_mask", managers.slot:get_mask("AI_visibility"), "ray_type", "ai_vision")

					if fire_line_is_obstructed then
						if t - self._line_of_sight_t > 3 then
							if self._draw_aim_delay_vis_proc then
								local draw_duration = self._shooting_husk_unit and 4 or 2

								local line = Draw:brush(Color.yellow:with_alpha(0.5), draw_duration)
								line:cylinder(shoot_from_pos, fire_line_is_obstructed.position, 0.5)
							end

							local aim_delay = 0
							local aim_delay_minmax = self._aim_delay_minmax

							if aim_delay_minmax[1] ~= 0 or aim_delay_minmax[2] ~= 0 then
								if aim_delay_minmax[1] == aim_delay_minmax[2] then
									aim_delay = aim_delay_minmax[1]
								else
									local lerp_dis = math_min(1, target_dis / self._falloff[#self._falloff].r)

									aim_delay = math_lerp(aim_delay_minmax[1], aim_delay_minmax[2], lerp_dis)
								end

								aim_delay = aim_delay + self:_pseudorandom() * aim_delay * 0.3

								if self._common_data.is_suppressed and not self._is_shin_shootout then
									aim_delay = aim_delay * 1.5
								end
							end

							self._shoot_t = t + aim_delay
						elseif fire_line_is_obstructed.distance > 300 and t - self._line_of_sight_t < self._fireline_t then
							shoot = true
						end
					else
						local shield_in_the_way = nil

						--bullets can't hit the player even if they're able to go through things, because it counts as being obstructed by whatever they go through
						if not self._weapon_base._use_armor_piercing or self._shooting_player then
							if self._shield then
								shield_in_the_way = self._unit:raycast("ray", shoot_from_pos, target_pos, "slot_mask", self._shield_slotmask, "ignore_unit", self._shield, "report")
							else
								shield_in_the_way = self._unit:raycast("ray", shoot_from_pos, target_pos, "slot_mask", self._shield_slotmask, "report")
							end
						end

						if not shield_in_the_way then
							shoot = true
						end

						if not self._last_vis_check_status and t - self._line_of_sight_t > 1 then
							if self._draw_focus_delay_vis_reset then
								local draw_duration = self._shooting_husk_unit and 4 or 2

								local line_1 = Draw:brush(Color.green:with_alpha(0.5), draw_duration)
								line_1:cylinder(shoot_from_pos, self._shoot_history.m_last_pos, 0.5)

								local line_2 = Draw:brush(Color.green:with_alpha(0.5), draw_duration)
								line_2:cylinder(shoot_from_pos, target_pos, 0.5)

								local line_3 = Draw:brush(Color.green:with_alpha(0.5), draw_duration)
								line_3:cylinder(target_pos, self._shoot_history.m_last_pos, 0.5)
							end

							self._shoot_history.focus_start_t = t
						end

						self._shoot_history.m_last_pos = mvec3_copy(target_pos)
						self._line_of_sight_t = t
					end

					if self._draw_fire_line_ray then
						local draw_duration = self._shooting_husk_unit and 2 or 0.1
						local line_to_pos = fire_line_is_obstructed and fire_line_is_obstructed.position or target_pos
						local line = fire_line_is_obstructed and Draw:brush(Color.red:with_alpha(0.2), draw_duration) or Draw:brush(Color.white:with_alpha(0.2), draw_duration)
						line:cylinder(shoot_from_pos, line_to_pos, 0.1)
					end

					self._last_vis_check_status = shoot
				elseif self._shooting_husk_unit then
					shoot = self._last_vis_check_status
				end
			else
				shoot = true
			end

			if shoot and self._shoot_t < t then
				local falloff, i_range = self:_get_shoot_falloff(target_dis, self._falloff)
				local dmg_buff = self._unit:base():get_total_buff("base_damage")
				local dmg_mul = (1 + dmg_buff) * falloff.dmg_mul
				local firemode = nil

				if self._automatic_weap then
					firemode = falloff.mode and falloff.mode[1] or 1
					local random_mode = self:_pseudorandom()

					for i_mode, mode_chance in ipairs(falloff.mode) do
						if random_mode <= mode_chance then
							firemode = i_mode

							break
						end
					end
				else
					firemode = 1
				end

				if firemode > 1 then
					self._weapon_base:start_autofire(firemode < 4 and firemode)

					if self._w_usage_tweak.autofire_rounds then
						if firemode < 4 then
							self._autofiring = firemode
						elseif falloff.autofire_rounds then
							local diff = falloff.autofire_rounds[2] - falloff.autofire_rounds[1]
							self._autofiring = math_round(falloff.autofire_rounds[1] + self:_pseudorandom() * diff)
						else
							local diff = self._w_usage_tweak.autofire_rounds[2] - self._w_usage_tweak.autofire_rounds[1]
							self._autofiring = math_round(self._w_usage_tweak.autofire_rounds[1] + self:_pseudorandom() * diff)
						end
					--[[else
						Application:stack_dump_error("autofire_rounds is missing from weapon usage tweak data!", self._weap_tweak.usage)]]
					end

					self._autoshots_fired = 0

					if vis_state == 1 and not ext_anim.recoil and not ext_anim.base_no_recoil and not ext_anim.move then
						if self._tank_animations then
							self._ext_movement:play_redirect("recoil_single")
						else
							self._ext_movement:play_redirect("recoil_auto")
						end
					end
				else
					local spread = self._spread
					local new_target_pos = self._shoot_history and self:_get_unit_shoot_pos(t, target_pos, target_dis, falloff, i_range, autotarget)

					if new_target_pos then
						target_pos = new_target_pos
					else
						spread = math_min(20, spread)
					end

					local spread_pos = temp_vec2

					mvec3_rand_orth(spread_pos, target_vec)
					mvec3_set_l(spread_pos, spread)
					mvec3_add(spread_pos, target_pos)
					mvec3_dir(target_vec, shoot_from_pos, spread_pos)

					local fired = self._weapon_base:singleshot(shoot_from_pos, target_vec, dmg_mul, autotarget, nil, nil, nil, self._attention.unit)

					if fired then
						if vis_state == 1 and not ext_anim.base_no_recoil and not ext_anim.move then
							self._ext_movement:play_redirect("recoil_single")
						end

						local recoil_1 = nil
						local recoil_2 = nil

						if self._weap_tweak.custom_single_fire_rate then
							recoil_1 = self._weap_tweak.custom_single_fire_rate
							recoil_2 = self._weap_tweak.custom_single_fire_rate * #self._falloff * 1.5
						else
							recoil_1 = falloff.recoil[1]
							recoil_2 = falloff.recoil[2]
						end

						local lerp_dis = math_min(1, target_dis / self._falloff[#self._falloff].r)
						local shoot_delay = math_lerp(recoil_1, recoil_2, lerp_dis)

						if self._unit:character_damage()._punk_effect then
							shoot_delay = shoot_delay * 0.25
						end

						self._shoot_t = t + shoot_delay
					end
				end
			end
		end
	end

	if self._ext_anim.base_need_upd then
		self._ext_movement:upd_m_head_pos()
	end
end

function CopActionShoot:check_melee_start(t, attention, target_dis, autotarget, shoot_from_pos)
	if not self._common_data.melee_countered_t or t - self._common_data.melee_countered_t > 15 then
		if self._melee_timeout_t < t then
			if not attention.unit or not attention.unit:base() or attention.unit:base().is_husk_player or not attention.unit:character_damage() then
				return false
			end

			if not attention.unit:base().sentry_gun and not attention.unit:character_damage().damage_melee then --sentries take bullet damage, but check for damage_melee for anything else
				return false
			end

			if attention.unit:character_damage().dead and attention.unit:character_damage():dead() then --target is dead
				return false
			end

			local my_fwd = mvec3_copy(self._ext_movement:m_head_rot():z())
			local target_pos = Vector3()

			mvec3_set(target_pos, my_fwd)
			mvec3_mul(target_pos, target_dis)
			mvec3_add(target_pos, shoot_from_pos)

			local obstructed_by_geometry = self._unit:raycast("ray", shoot_from_pos, target_pos, "sphere_cast_radius", 20, "slot_mask", managers.slot:get_mask("world_geometry", "vehicles"), "ray_type", "body melee", "report")

			if not obstructed_by_geometry then
				local target_has_shield = alive(attention.unit:inventory() and attention.unit:inventory()._shield_unit) and true or nil
				local target_is_covered_by_shield = self._unit:raycast("ray", shoot_from_pos, target_pos, "sphere_cast_radius", 20, "slot_mask", self._shield_slotmask, "ray_type", "body melee", "report")

				if autotarget then
					if not target_is_covered_by_shield then
						if not self._melee_weapon_data.electrical or not attention.unit:movement():tased() then
							return true
						end
					end
				elseif attention.unit:base().sentry_gun then
					if not self._melee_weapon_data.electrical then --since it'll probably be worse most of the time rather than just shooting at it
						if not target_is_covered_by_shield then
							return true
						end
					end
				else
					if target_has_shield then
						if target_is_covered_by_shield then
							local can_be_knocked = self._melee_weapon_data.shield_knock and attention.unit:base():char_tweak().damage.shield_knocked and not attention.unit:base().is_phalanx and not attention.unit:character_damage():is_immune_to_shield_knockback()

							if can_be_knocked then
								if not attention.unit:movement():chk_action_forbidden("hurt") then
									return true
								end
							end
						else
							if self._melee_weapon_data.electrical then
								local can_be_tased = attention.unit:base():char_tweak().can_be_tased == nil or attention.unit:base():char_tweak().can_be_tased

								if can_be_tased then
									if not attention.unit:movement():chk_action_forbidden("hurt") then
										return true
									end
								end
							else
								return true
							end
						end
					else
						if not target_is_covered_by_shield then
							if self._melee_weapon_data.electrical then
								local can_be_tased = attention.unit:base():char_tweak().can_be_tased == nil or attention.unit:base():char_tweak().can_be_tased

								if can_be_tased then
									if not attention.unit:movement():chk_action_forbidden("hurt") then
										return true
									end
								end
							else
								return true
							end
						end
					end
				end
			end
		end
	end

	return false
end

function CopActionShoot:_get_unit_shoot_pos(t, pos, dis, falloff, i_range, shooting_local_player)
	local shoot_hist = self._shoot_history
	local focus_delay, focus_prog = nil

	if shoot_hist and shoot_hist.focus_delay then
		focus_delay = shoot_hist.focus_delay

		if self._attention.unit and self._attention.unit:character_damage() and self._attention.unit:character_damage().focus_delay_mul then
			focus_delay = self._attention.unit:character_damage():focus_delay_mul() * focus_delay
		end

		if focus_delay > 0 then
			local time_passed = t - shoot_hist.focus_start_t
			focus_prog = time_passed / focus_delay
		end

		if not focus_prog or focus_prog >= 1 then
			shoot_hist.focus_delay = nil
			focus_prog = 1
		end
	else
		focus_prog = 1
	end

	local dis_lerp = nil
	local hit_chances = falloff.acc
	local hit_chance = nil

	if i_range == 1 then
		dis_lerp = dis / falloff.r
		hit_chance = math_lerp(hit_chances[1], hit_chances[2], focus_prog)
	else
		local prev_falloff = self._falloff[i_range - 1]
		dis_lerp = math_min(1, (dis - prev_falloff.r) / (falloff.r - prev_falloff.r))
		local prev_range_hit_chance = math_lerp(prev_falloff.acc[1], prev_falloff.acc[2], focus_prog)
		hit_chance = math_lerp(prev_range_hit_chance, math_lerp(hit_chances[1], hit_chances[2], focus_prog), dis_lerp)
	end

	if not self._is_shin_shootout then
		if self._common_data.is_suppressed then --their accuracy is not affected by suppression on shin mode
			hit_chance = hit_chance * 0.5
		end

		if self._common_data.ext_anim.run then
			hit_chance = hit_chance * 0.75
		end

		if self._common_data.active_actions[2] and self._common_data.active_actions[2]:type() == "dodge" then --their accuracy is not affected while dodging on shin mode
			hit_chance = hit_chance * self._common_data.active_actions[2]:accuracy_multiplier()
		end
	end

	if self._attention and self._attention.unit and self._attention.unit:anim_data() and self._attention.unit:anim_data().dodge then
		hit_chance = hit_chance * 0.5
	end

	if self._cs_acc_mul then
		hit_chance = hit_chance * self._cs_acc_mul
	end

	if self._unit:character_damage().accuracy_multiplier then
		hit_chance = hit_chance * self._unit:character_damage():accuracy_multiplier()
	end
	
	if self._unit:character_damage()._punk_effect then
		hit_chance = hit_chance * 3
	end
	
	--log("hit_chance: " .. hit_chance .. "")

	if self:_pseudorandom() < hit_chance then
		mvec3_set(shoot_hist.m_last_pos, pos)
	else
		local enemy_vec = temp_vec2

		mvec3_set(enemy_vec, pos)
		mvec3_sub(enemy_vec, self._common_data.pos)

		local error_vec = Vector3()

		mvec3_cross(error_vec, enemy_vec, math_up)
		mrot_axis_angle(temp_rot1, enemy_vec, math_random(360))
		mvec3_rot(error_vec, temp_rot1)

		local miss_min_dis = shooting_local_player and 10 or 40
		local error_vec_len = nil
		
		if shooting_local_player then
			error_vec_len = self._spread + self._miss_dis
		else
			error_vec_len = self._spread + self._miss_dis * 2
		end

		mvec3_set_l(error_vec, error_vec_len)
		mvec3_add(error_vec, pos)
		mvec3_set(shoot_hist.m_last_pos, error_vec)

		return error_vec
	end
end

function CopActionShoot:_chk_start_melee()
	local melee_weapon = self._melee_weapon_data.melee_weapon
	local is_weapon = melee_weapon == "weapon"
	local redir_name = is_weapon and "melee" or "melee_item"
	local tank_melee = nil

	if is_weapon then
		if self._weap_tweak.usage == "mini" then
			redir_name = "melee_bayonet" --bash with the front of the minigun's barrel like in first person
		end
	elseif melee_weapon == "fists" and self._tank_animations then
		redir_name = "melee" --use tank_melee unique punching animation as originally intended
		tank_melee = true
	end

	local melee_res = self._ext_movement:play_redirect(redir_name)

	if melee_res then
		if self._melee_weapon_data.speed ~= 1 then
			self._common_data.machine:set_speed(melee_res, self._melee_weapon_data.speed)
		end

		if not is_weapon and not tank_melee then
			if #self._melee_weapon_data.anim_vars == 1 then
				self._common_data.machine:set_parameter(melee_res, self._melee_weapon_data.anim_vars[1], 1)
			else
				local melee_var = self:_pseudorandom(#self._melee_weapon_data.anim_vars)

				self._common_data.machine:set_parameter(melee_res, self._melee_weapon_data.anim_vars[melee_var], 1)
			end

			if self._melee_weapon_data.anim_param then
				self._common_data.machine:set_parameter(melee_res, self._melee_weapon_data.anim_param, 1)
			end
		end

		--let other players see when NPCs attempt a melee attack instead of nothing (not actually cosmetic as melee attacks are tied to the animation, but the necessary checks to prevent issues with that are there)
		managers.network:session():send_to_peers_synched("play_distance_interact_redirect", self._unit, redir_name)

		if self._melee_weapon_data.retry_delay[1] == self._melee_weapon_data.retry_delay[2] then
			self._melee_timeout_t = TimerManager:game():time() + self._melee_weapon_data.retry_delay[1]
		else
			self._melee_timeout_t = TimerManager:game():time() + math_lerp(self._melee_weapon_data.retry_delay[1], self._melee_weapon_data.retry_delay[2], self:_pseudorandom())
		end

		return true
	else
		--debug_pause_unit(self._common_data.unit, "[CopActionShoot:_chk_start_melee] redirect failed in state", self._common_data.machine:segment_state(Idstring("base")), self._common_data.unit)
	end
end

function CopActionShoot:anim_clbk_melee_strike()
	if not self._melee_weapon_data then
		return
	end

	local shoot_from_pos = self._shoot_from_pos
	local my_fwd = mvec3_copy(self._ext_movement:m_head_rot():z())
	local target_pos = Vector3()

	mvec3_set(target_pos, my_fwd)
	mvec3_mul(target_pos, self._melee_weapon_data.range)
	mvec3_add(target_pos, shoot_from_pos)

	--similar to player melee attacks, use a sphere ray instead of just a normal plain ray
	local col_ray = self._unit:raycast("ray", shoot_from_pos, target_pos, "sphere_cast_radius", 20, "slot_mask", self._melee_weapon_data.slotmask, "ray_type", "body melee")
	
	if self._draw_melee_sphere_rays then
		local draw_duration = 3
		local new_brush = col_ray and Draw:brush(Color.red:with_alpha(0.5), draw_duration) or Draw:brush(Color.white:with_alpha(0.5), draw_duration)
		local sphere_draw_pos = col_ray and col_ray.position or target_pos
		local sphere_draw_size = col_ray and 5 or 20
		new_brush:sphere(sphere_draw_pos, sphere_draw_size)
	end

	local local_player = managers.player:player_unit()

	--a more clean method of determining if the local player should get hit or not, without cancelling the attack if the player can't get hit, like it did before
	--sadly, no raycasts I tried so far (even with target_unit/target_body) seem to be able to hit the local player
	if self._melee_weapon_data.hit_player and alive(local_player) and not self._unit:character_damage():is_friendly_fire(local_player) then
		local player_head_pos = local_player:movement():m_head_pos()
		local player_vec = Vector3()
		local player_distance = mvec3_dir(player_vec, mvec3_copy(shoot_from_pos), mvec3_copy(player_head_pos))

		if player_distance <= self._melee_weapon_data.range then
			if not col_ray or col_ray.distance > player_distance or not self._unit:raycast("ray", shoot_from_pos, player_head_pos, "sphere_cast_radius", 5, "slot_mask", self._melee_weapon_data.slotmask, "ray_type", "body melee", "report") then
				local flat_vec = Vector3()

				mvec3_set(flat_vec, player_vec)
				mvec3_set_z(flat_vec, 0)
				mvec3_norm(flat_vec)

				local min_dot = math_lerp(0, 0.4, player_distance / self._melee_weapon_data.range)
				local fwd_dot = mvec3_dot(my_fwd, flat_vec)

				if fwd_dot >= min_dot then
					col_ray = {
						unit = local_player,
						position = player_head_pos,
						ray = mvec3_copy(player_vec:normalized())
					}

					if self._draw_melee_sphere_rays then
						local draw_duration = 3
						local new_brush = Draw:brush(Color.yellow:with_alpha(0.5), draw_duration)
						local sphere_draw_pos = player_head_pos
						local sphere_draw_size = 5
						new_brush:sphere(sphere_draw_pos, sphere_draw_size)
					end
				end
			end
		end
	end

	if col_ray and alive(col_ray.unit) then
		local melee_weapon = self._melee_weapon_data.melee_weapon
		local is_weapon = melee_weapon == "weapon"
		local damage = self._melee_weapon_data.damage
		local damage_multiplier = self._melee_weapon_data.dmg_mul * (1 + self._ext_base:get_total_buff("base_damage"))
		damage = damage * damage_multiplier

		managers.game_play_central:physics_push(col_ray) --the function already has sanity checks so it's fine to just use it like this

		local hit_unit = col_ray.unit
		local character_unit, shield_knock = nil
		local defense_data = nil

		if self._is_server and hit_unit:in_slot(self._shield_slotmask) and alive(hit_unit:parent()) then
			local can_be_knocked = self._melee_weapon_data.shield_knock and not hit_unit:parent():base().is_phalanx and hit_unit:parent():base():char_tweak().damage.shield_knocked and not hit_unit:parent():character_damage():is_immune_to_shield_knockback()

			if can_be_knocked then
				shield_knock = true
				character_unit = hit_unit:parent()
			end
		end

		character_unit = character_unit or hit_unit

		if character_unit == local_player then
			local push_dis = 600
			
			if self._common_data.ext_base._tweak_table == "fbi" or self._common_data.ext_base._tweak_table == "fbi_xc45" or self._common_data.ext_base._tweak_table == "fbi_pager" then
				damage = 15 * damage_multiplier
				push_dis = 1200
			end
			
			local action_data = {
				variant = "melee",
				damage = damage,
				weapon_unit = self._weapon_unit,
				attacker_unit = self._unit,
				melee_weapon = melee_weapon,
				push_vel = mvec3_copy(col_ray.ray:with_z(0.1)) * push_dis,
				tase_player = self._melee_weapon_data.electrical and true or nil,
				col_ray = col_ray
			}

			defense_data = character_unit:character_damage():damage_melee(action_data)
		else
			if self._is_server then --only allow melee damage against NPCs for the host (used in case an enemy targets a client locally but hits something else instead)
				if character_unit:character_damage() and character_unit:base() then
					if character_unit:base().sentry_gun then
						local action_data = {
							variant = "bullet",
							damage = damage,
							weapon_unit = self._weapon_unit,
							attacker_unit = self._unit,
							origin = shoot_from_pos,
							col_ray = col_ray
						}

						defense_data = character_unit:character_damage():damage_bullet(action_data) --sentries/turrets lack a melee damage function
					else
						if character_unit:character_damage().damage_melee and not character_unit:base().is_husk_player then --ignore player husks as the damage CAN be synced and dealt to them
							local variant = shield_knock and "melee" or self._melee_weapon_data.electrical and "taser_tased" or "melee"
							local action_data = {
								variant = variant,
								damage = shield_knock and 0 or damage,
								damage_effect = damage * 2,
								weapon_unit = is_weapon and self._weapon_unit or nil,
								attacker_unit = self._unit,
								name_id = melee_weapon,
								shield_knock = shield_knock,
								col_ray = col_ray
							}

							defense_data = character_unit:character_damage():damage_melee(action_data)
						end
					end
				end

				if character_unit:damage() and col_ray.body:extension() and col_ray.body:extension().damage then --damage objects with body extensions (like glass), just like players are able to
					damage = math_clamp(damage, 0, 63)

					col_ray.body:extension().damage:damage_melee(self._unit, col_ray.normal, col_ray.position, col_ray.ray, damage)
					managers.network:session():send_to_peers_synched("sync_body_damage_melee", col_ray.body, self._unit, col_ray.normal, col_ray.position, col_ray.ray, damage)
				end
			end
		end

		if defense_data and defense_data ~= "friendly_fire" then
			if defense_data == "countered" then
				self._common_data.melee_countered_t = TimerManager:game():time()

				local attack_dir = self._unit:movement():m_com() - character_unit:movement():m_head_pos()
				mvec3_norm(attack_dir)

				local counter_data = {
					damage = 0,
					damage_effect = 1,
					variant = "counter_spooc",
					attacker_unit = character_unit,
					attack_dir = attack_dir,
					col_ray = {
						position = mvec3_copy(self._unit:movement():m_com()),
						body = self._unit:body("body"),
						ray = attack_dir
					},
					name_id = character_unit == local_player and managers.blackmarket:equipped_melee_weapon() or character_unit:base():melee_weapon()
				}

				self._unit:character_damage():damage_melee(counter_data)
			else
				if not shield_knock and character_unit ~= local_player and character_unit:character_damage() and not character_unit:character_damage()._no_blood then
					if character_unit:base().sentry_gun then
						managers.game_play_central:play_impact_sound_and_effects({
							no_decal = true,
							col_ray = col_ray
						})
					else
						managers.game_play_central:sync_play_impact_flesh(col_ray.position, col_ray.ray)
					end
				end
			end
		end
	end
end
