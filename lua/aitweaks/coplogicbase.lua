local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_dis = mvector3.distance
local mvec3_dis_sq = mvector3.distance_sq
local m_rot_y = mrotation.y
local m_rot_z = mrotation.z
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()

function CopLogicBase._set_attention_obj(data, new_att_obj, new_reaction)
	local my_data = data.internal_data
	local diff_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
	local old_att_obj = data.attention_obj
	data.attention_obj = new_att_obj

	if new_att_obj then
		new_reaction = new_reaction or new_att_obj.settings.reaction
		new_att_obj.reaction = new_reaction
		local new_crim_rec = new_att_obj.criminal_record
		local is_same_obj, contact_chatter_time_ok = nil

		if old_att_obj then
			if old_att_obj.u_key == new_att_obj.u_key then
				is_same_obj = true
				contact_chatter_time_ok = new_crim_rec and data.t - new_crim_rec.det_t > 8

				new_att_obj.stare_expire_t = nil
				new_att_obj.pause_expire_t = nil
				new_att_obj.settings.pause = nil
			else
				if old_att_obj.criminal_record then
					managers.groupai:state():on_enemy_disengaging(data.unit, old_att_obj.u_key)
				end

				if new_crim_rec then
					managers.groupai:state():on_enemy_engaging(data.unit, new_att_obj.u_key)
				end

				contact_chatter_time_ok = new_crim_rec and data.t - new_crim_rec.det_t > 15
			end
		else
			if new_crim_rec then
				managers.groupai:state():on_enemy_engaging(data.unit, new_att_obj.u_key)
			end

			contact_chatter_time_ok = new_crim_rec and data.t - new_crim_rec.det_t > 15
		end

		if not is_same_obj then
			new_att_obj.stare_expire_t = nil
			new_att_obj.pause_expire_t = nil
			new_att_obj.settings.pause = nil

			new_att_obj.acquire_t = data.t
		end
		
		local not_acting = data.unit:anim_data().idle or data.unit:anim_data().move
		
		if AIAttentionObject.REACT_COMBAT <= new_reaction and new_att_obj.verified and contact_chatter_time_ok and not_acting and new_att_obj.is_person and data.char_tweak.chatter and data.char_tweak.chatter.contact and not data.unit:raycast("ray", data.unit:movement():m_head_pos(), new_att_obj.m_head_pos, "slot_mask", managers.slot:get_mask("world_geometry", "vehicles"), "ignore_unit", new_att_obj.unit, "report") then --the fact i have to do this is just hghghghg
			if data.unit:base()._tweak_table == "gensec" then
				data.unit:sound():say("a01", true)			
			elseif data.unit:base()._tweak_table == "security" then
				data.unit:sound():say("a01", true)
			elseif data.unit:base()._tweak_table == "shield" then
				data.unit:sound():say("shield_identification", true)
			else
				data.unit:sound():say("c01", true)
			end

		end

		if data.char_tweak.weapon[data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].use_laser and not data.weapon_laser_on then
			data.unit:inventory():equipped_unit():base():set_laser_enabled(true)

			--turns on sniper lasers for assault snipers because overkill is fucking stupid
			data.weapon_laser_on = true

			managers.enemy:_destroy_unit_gfx_lod_data(data.key)
			managers.network:session():send_to_peers_synched("sync_unit_event_id_16", data.unit, "brain", HuskCopBrain._NET_EVENTS.weapon_laser_on)
		end

	elseif old_att_obj and old_att_obj.criminal_record then
		managers.groupai:state():on_enemy_disengaging(data.unit, old_att_obj.u_key)
	end
end

function CopLogicBase.should_get_att_obj_position_from_alert(data, alert_data)
	
	if alert_data[1] == "voice" then
		return
	end
	
	return true
end

--[[function CopLogicBase._upd_suspicion(data, my_data, attention_obj)
	local function _exit_func()
		attention_obj.unit:movement():on_uncovered(data.unit)

		local reaction, state_name = nil

		if attention_obj.dis < 2000 and attention_obj.verified and not data.char_tweak.no_arrest and not attention_obj.forced then
			reaction = AIAttentionObject.REACT_ARREST
			state_name = "arrest"
		else
			reaction = AIAttentionObject.REACT_COMBAT
			state_name = "attack"
		end

		attention_obj.reaction = reaction
		local allow_trans, obj_failed = CopLogicBase.is_obstructed(data, data.objective, nil, attention_obj)

		if allow_trans then
			if obj_failed then
				data.objective_failed_clbk(data.unit, data.objective)

				if my_data ~= data.internal_data then
					return true
				end
			end

			CopLogicBase._exit(data.unit, state_name)

			return true
		end
	end

	local dis = attention_obj.dis
	local susp_settings = attention_obj.unit:base():suspicion_settings()

	if attention_obj.settings.uncover_range and dis < math.min(attention_obj.settings.max_range, attention_obj.settings.uncover_range) * susp_settings.range_mul then
		attention_obj.unit:movement():on_suspicion(data.unit, true)
		managers.groupai:state():criminal_spotted(attention_obj.unit)

		return _exit_func()
	elseif attention_obj.verified and attention_obj.settings.suspicion_range and dis < math.min(attention_obj.settings.max_range, attention_obj.settings.suspicion_range) * susp_settings.range_mul then
		if attention_obj.last_suspicion_t then
			local dt = data.t - attention_obj.last_suspicion_t
			local range_max = (attention_obj.settings.suspicion_range - (attention_obj.settings.uncover_range or 0)) * susp_settings.range_mul
			local range_min = (attention_obj.settings.uncover_range or 0) * susp_settings.range_mul
			local mul = 1 - (dis - range_min) / range_max
			local progress = dt * mul * susp_settings.buildup_mul / attention_obj.settings.suspicion_duration
			attention_obj.uncover_progress = (attention_obj.uncover_progress or 0) + progress

			if attention_obj.uncover_progress < 1 then
				attention_obj.unit:movement():on_suspicion(data.unit, attention_obj.uncover_progress)
				managers.groupai:state():on_criminal_suspicion_progress(attention_obj.unit, data.unit, attention_obj.uncover_progress)
			else
				attention_obj.unit:movement():on_suspicion(data.unit, true)
				managers.groupai:state():criminal_spotted(attention_obj.unit)

				return _exit_func()
			end
		else
			attention_obj.uncover_progress = 0
		end

		attention_obj.last_suspicion_t = data.t
	elseif attention_obj.uncover_progress then
		if attention_obj.last_suspicion_t then
			local dt = data.t - attention_obj.last_suspicion_t
			attention_obj.uncover_progress = attention_obj.uncover_progress - dt

			if attention_obj.uncover_progress <= 0 then
				attention_obj.uncover_progress = nil
				attention_obj.last_suspicion_t = nil

				attention_obj.unit:movement():on_suspicion(data.unit, false)
			else
				attention_obj.unit:movement():on_suspicion(data.unit, attention_obj.uncover_progress)
			end
		else
			attention_obj.last_suspicion_t = data.t
		end
	end
end--]]
		

function CopLogicBase._chk_nearly_visible_chk_needed(data, attention_info, u_key)
	return not attention_info.criminal_record or attention_info.is_human_player
end

function CopLogicBase._upd_stance_and_pose(data, my_data, objective)
	if my_data ~= data.internal_data then
		--log("how is this man")
		return
	end

	if data.char_tweak.allowed_poses or data.is_converted or my_data.tasing or my_data.spooc_attack or data.unit:in_slot(managers.slot:get_mask("criminals")) then
		return
	end

	if data.team and data.team.id == tweak_data.levels:get_default_team_ID("player") or data.unit:movement():chk_action_forbidden("walk") then
		return
	end

	local obj_has_stance, obj_has_pose, agg_pose = nil
	local can_stand_or_crouch = nil

	if not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.crouch then
		if not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.stand then
			if data.char_tweak.crouch_move then
				can_stand_or_crouch = true
			end
		end
	end

	if can_stand_or_crouch then
		local diff_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)

		if data.is_suppressed then
			if diff_index <= 5 and not Global.game_settings.use_intense_AI then
				if data.unit:anim_data().stand then
					if not my_data.next_allowed_stance_t or my_data.next_allowed_stance_t < data.t then
						if CopLogicAttack._chk_request_action_crouch(data) then
							my_data.next_allowed_stance_t = data.t + math.random(1.5, 7)
							agg_pose = true
						end
					end
				end
			else
				if data.unit:anim_data().stand then
					if not my_data.next_allowed_stance_t or my_data.next_allowed_stance_t < data.t then
						if CopLogicAttack._chk_request_action_crouch(data) then
							my_data.next_allowed_stance_t = data.t + math.random(1.5, 7)
							agg_pose = true
						end
					end
				elseif data.unit:anim_data().crouch then
					if not my_data.next_allowed_stance_t or my_data.next_allowed_stance_t < data.t then
						if CopLogicAttack._chk_request_action_stand(data) then
							my_data.next_allowed_stance_t = data.t + math.random(1.5, 7)
							agg_pose = true
						end
					end
				end
			end
		elseif data.attention_obj and data.attention_obj.aimed_at and data.attention_obj.reaction and data.attention_obj.reaction >= AIAttentionObject.REACT_COMBAT and data.attention_obj.verified then
			if diff_index > 5 or Global.game_settings.use_intense_AI then
				if data.unit:anim_data().stand then
					if not my_data.next_allowed_stance_t or my_data.next_allowed_stance_t < data.t then
						if CopLogicAttack._chk_request_action_crouch(data) then
							my_data.next_allowed_stance_t = data.t + math.random(1.5, 7)
							agg_pose = true
						end
					end
				elseif data.unit:anim_data().crouch then
					if not my_data.next_allowed_stance_t or my_data.next_allowed_stance_t < data.t then
						if CopLogicAttack._chk_request_action_stand(data) then
							my_data.next_allowed_stance_t = data.t + math.random(1.5, 7)
							agg_pose = true
						end
					end
				end
			end
		end
	end
	
	if agg_pose then
		return
	end

	if data.char_tweak.allowed_poses and can_stand_or_crouch and not obj_has_pose and not agg_pose then
		for pose_name, state in pairs(data.char_tweak.allowed_poses) do
			if state then
			
				if pose_name == "stand" then
					CopLogicAttack._chk_request_action_stand(data)

					break
				end
				
				if pose_name == "crouch" then
					CopLogicAttack._chk_request_action_crouch(data)

					break
				end
			end
		end
	end
end

function CopLogicBase.chk_am_i_aimed_at(data, attention_obj, max_dot)
	if not attention_obj.is_person or attention_obj.unit:character_damage().dead and attention_obj.unit:character_damage():dead() then
		return
	end

	if attention_obj.dis < 700 and max_dot > 0.3 then
		max_dot = math.lerp(0.3, max_dot, (attention_obj.dis - 50) / 650)
	end

	local enemy_look_dir = nil
	local weapon_rot = nil

	if attention_obj.is_husk_player then
		enemy_look_dir = attention_obj.unit:movement():detect_look_dir()
	else
		enemy_look_dir = tmp_vec1

		if attention_obj.is_local_player then
			m_rot_y(attention_obj.unit:movement():m_head_rot(), enemy_look_dir)
		else
			if attention_obj.unit:inventory() and attention_obj.unit:inventory():equipped_unit() then
				if attention_obj.unit:movement()._stance.values[3] >= 0.6 then
					local weapon_fire_obj = attention_obj.unit:inventory():equipped_unit():get_object(Idstring("fire"))

					if alive(weapon_fire_obj) then
						weapon_rot = weapon_fire_obj:rotation()
					end
				end
			end

			if weapon_rot then
				m_rot_y(weapon_rot, enemy_look_dir)
			else
				m_rot_z(attention_obj.unit:movement():m_head_rot(), enemy_look_dir)
			end
		end
	end

	local enemy_vec = tmp_vec2
	mvec3_dir(enemy_vec, attention_obj.m_head_pos, data.unit:movement():m_com())

	return max_dot < mvec3_dot(enemy_vec, enemy_look_dir)
end

function CopLogicBase._update_haste(data, my_data)
	if my_data ~= data.internal_data then
		log("how is this man")
		return
	end
	
	if data.team and data.team.id == tweak_data.levels:get_default_team_ID("player") or data.is_converted or data.unit:in_slot(16) or data.unit:in_slot(managers.slot:get_mask("criminals")) then
		return
	end
	
	if data.unit:movement():chk_action_forbidden("walk") or my_data.tasing or my_data.spooc_attack then
		return
	end
	
	local path = my_data.chase_path or my_data.charge_path or my_data.advance_path or my_data.cover_path or my_data.expected_pos_path or my_data.hunt_path or my_data.flank_path
	
	if not path then
		return
	end
	
	local diff_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
	local can_perform_walking_action = not my_data.turning and not data.unit:movement():chk_action_forbidden("walk") and not my_data.has_old_action
	local pose = nil
	local mook_units = {
		"security",
		"security_undominatable",
		"cop",
		"cop_scared",
		"cop_female",
		"gensec",
		"fbi",
		"fbi_xc45",
		"fbi_pager",
		"swat",
		"heavy_swat",
		"fbi_swat",
		"fbi_heavy_swat",
		"city_swat",
		"gangster",
		"biker",
		"mobster",
		"bolivian",
		"bolivian_indoors",
		"medic",
		"taser",
		"spooc",
		"shadow_spooc",
		"spooc_heavy",
		"tank_ftsu",
		"tank_mini",
		"tank",
		"tank_medic"
	}
	local is_mook = nil
	for _, name in ipairs(mook_units) do
		if data.unit:base()._tweak_table == name then
			is_mook = true
		end
	end
	
	-- I'm gonna leave a note to myself here so that I never commit the same mistake ever again.
	-- AIAttentionObject.REACT_COMBAT <= data.attention_obj.reaction
	-- THIS IS HOW YOU CHECK FOR COMBAT REACTIONS, YOU DEHYDRATED RAISIN OF A PERSON, FUGLORE
	-- I SWEAR TO FUCKING GOD I WILL SLAUGHTER YOU IF YOU MAKE THE SAME MISTAKE AGAIN
	-- - Past Fuglore, thembo extraordinaire and apparently, no longer an idiot.
	
	-- geez this fuglore person must be really bad at coding lol
	
	if path and can_perform_walking_action and data.attention_obj then
		local haste = nil
		
		if is_mook and not data.is_converted and not data.unit:in_slot(16) then
			local enemyseeninlast4secs = data.attention_obj and data.attention_obj.verified_t and data.t - data.attention_obj.verified_t < 4
			local enemy_seen_range_bonus = enemyseeninlast4secs and 500 or 0
			local enemy_has_height_difference = data.attention_obj and AIAttentionObject.REACT_COMBAT <= data.attention_obj.reaction and data.attention_obj.dis >= 1200 and data.attention_obj.verified_t and data.t - data.attention_obj.verified_t < 4 and math.abs(data.m_pos.z - data.attention_obj.m_pos.z) > 250
			local height_difference_penalty = enemy_has_height_difference and 400 or 0
			local can_crouch = not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.crouch
			local can_stand = not data.char_tweak.allowed_poses or data.char_tweak.allowed_poses.stand
			
			
			local should_crouch = nil
			local pose = nil
			local end_pose = nil
			if data.unit:movement():cool() and data.unit:movement()._active_actions[2] and data.unit:movement()._active_actions[2]:type() == "walk" and data.unit:movement()._active_actions[2]:haste() == "run" then
				haste = "walk"
			elseif data.attention_obj and data.attention_obj.dis > 10000 and data.unit:movement()._active_actions[2] and data.unit:movement()._active_actions[2]:type() == "walk" and data.unit:movement()._active_actions[2]:haste() ~= "run" then
				haste = "run"
			elseif data.attention_obj and AIAttentionObject.REACT_COMBAT <= data.attention_obj.reaction and data.attention_obj.dis > 800 + enemy_seen_range_bonus and not data.unit:movement():cool() and not managers.groupai:state():whisper_mode() and data.unit:movement()._active_actions[2] and data.unit:movement()._active_actions[2]:type() == "walk" and data.unit:movement()._active_actions[2]:haste() ~= "run" and is_mook then
				haste = "run"
				my_data.has_reset_walk_cycle = nil
			elseif data.attention_obj and AIAttentionObject.REACT_COMBAT <= data.attention_obj.reaction and data.attention_obj.dis <= 800 + enemy_seen_range_bonus - height_difference_penalty and is_mook and data.tactics and not data.tactics.hitnrun and data.unit:movement()._active_actions[2] and data.unit:movement()._active_actions[2]:type() == "walk" and data.unit:movement()._active_actions[2]:haste() == "run" then
				haste = "walk"
				my_data.has_reset_walk_cycle = nil
			 else
				if data.unit:movement()._active_actions[2] and data.unit:movement()._active_actions[2]:type() == "walk" and data.unit:movement()._active_actions[2]:haste() ~= "run" then
					my_data.has_reset_walk_cycle = nil
					haste = "run"
				else
					--log("current haste is fine!")
					return
				end
			 end
				 
			local crouch_roll = math.random(0.01, 1)
			local stand_chance = nil
			
			local verified_chk = data.attention_obj.verified and data.attention_obj.dis <= 1500 or data.attention_obj.dis <= 1000
			
			if data.attention_obj and data.attention_obj.dis > 10000 then
				stand_chance = 1
				pose = "stand"
				end_pose = "stand"
			elseif data.attention_obj and AIAttentionObject.REACT_COMBAT <= data.attention_obj.reaction and data.attention_obj.dis > 2000 then
				stand_chance = 0.75
			elseif enemy_has_height_difference and can_crouch then
				stand_chance = 0.25
			elseif data.attention_obj and AIAttentionObject.REACT_COMBAT <= data.attention_obj.reaction and verified_chk and CopLogicTravel._chk_close_to_criminal(data, my_data) and data.tactics and data.tactics.flank and haste == "walk" then
				stand_chance = 0.25
			elseif my_data.moving_to_cover and can_crouch then
				stand_chance = 0.5
			else
				stand_chance = 1
				pose = "stand"
				end_pose = "stand"
			end
			
			--randomize enemy crouching to make enemies feel less easy to aim at, the fact they're always crouching all over the place always bugged me, plus, they shouldn't need to crouch so often when you're at long distances from them
			
			if not data.unit:movement():cool() and not managers.groupai:state():whisper_mode() then
				if stand_chance ~= 1 and crouch_roll > stand_chance and can_crouch then
					end_pose = "crouch"
					pose = "crouch"
					should_crouch = true
				end
			end
			
			if not pose then
				pose = not data.char_tweak.crouch_move and "stand" or data.char_tweak.allowed_poses and not data.char_tweak.allowed_poses.stand and "crouch" or should_crouch and "crouch" or "stand"
				end_pose = pose
			end

			if not data.unit:anim_data()[pose] then
				CopLogicAttack["_chk_request_action_" .. pose](data)
			end	
		end
	end	
	 
	if data.attention_obj and AIAttentionObject.REACT_COMBAT <= data.attention_obj.reaction and haste and can_perform_walking_action then
		if not my_data.has_reset_walk_cycle then
			local new_action = {
				body_part = 2,
				type = "idle"
			}

			data.unit:brain():action_request(new_action)
			my_data.has_reset_walk_cycle = true
		else
			local new_action_data = {
				type = "walk",
				body_part = 2,
				nav_path = path,
				variant = haste,
				pose = pose,
				end_pose = end_pose
			}
			
			if my_data.advancing then
				my_data.advancing = data.unit:brain():action_request(new_action_data)
				my_data.moving_to_cover = my_data.best_cover
				my_data.at_cover_shoot_pos = nil
				my_data.in_cover = nil

				data.brain:rem_pos_rsrv("path")
			end
		end
	end
end 

function CopLogicBase.action_taken(data, my_data)
	return my_data.turning or my_data.moving_to_cover or my_data.walking_to_cover_shoot_pos or my_data.has_old_action or data.unit:movement():chk_action_forbidden("walk")
end

function CopLogicBase.should_duck_on_alert(data, alert_data)
	--this fucking sucks.
	
	return
end
	
function CopLogicBase.chk_should_turn(data, my_data)
	return not my_data.turning and not my_data.has_old_action and not data.unit:movement():chk_action_forbidden("walk") and not my_data.moving_to_cover and not my_data.walking_to_cover_shoot_pos and not my_data.surprised
end

function CopLogicBase._upd_attention_obj_detection(data, min_reaction, max_reaction)
	local diff_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
	local t = data.t
	local detected_obj = data.detected_attention_objects
	local my_data = data.internal_data
	local my_key = data.key
	local my_pos = data.unit:movement():m_head_pos()
	local my_access = data.SO_access
	local all_attention_objects = managers.groupai:state():get_AI_attention_objects_by_filter(data.SO_access_str, data.team)
	local my_head_fwd = nil
	local my_tracker = data.unit:movement():nav_tracker()
	local chk_vis_func = my_tracker.check_visibility
	local is_detection_persistent = managers.groupai:state():chk_assault_active_atm() --LMAO
	local delay = 0.2
	
	local player_importance_wgt = data.unit:in_slot(managers.slot:get_mask("enemies")) and {}
	
	--stops cops from doing raycasts on lower reactions in loud
	if player_importance_wgt and not managers.groupai:state():whisper_mode() then
		min_reaction = AIAttentionObject.REACT_SCARED
	end

	local function _angle_chk(attention_pos, dis, strictness)
		mvector3.direction(tmp_vec1, my_pos, attention_pos)

		my_head_fwd = my_head_fwd or data.unit:movement():m_head_rot():z()
		local angle = mvector3.angle(my_head_fwd, tmp_vec1)
		local angle_max = math.lerp(180, my_data.detection.angle_max, math.clamp((dis - 150) / 700, 0, 1))

		if angle_max > angle * strictness then
			return true
		end
	end

	local function _angle_and_dis_chk(handler, settings, attention_pos)
		attention_pos = attention_pos or handler:get_detection_m_pos()
		local dis = mvector3.direction(tmp_vec1, my_pos, attention_pos)
		local dis_multiplier, angle_multiplier = nil
		local max_dis = math.min(my_data.detection.dis_max, settings.max_range or my_data.detection.dis_max)

		if settings.detection and settings.detection.range_mul then
			max_dis = max_dis * settings.detection.range_mul
		end

		dis_multiplier = dis / max_dis

		if settings.uncover_range and my_data.detection.use_uncover_range and dis < settings.uncover_range then
			return -1, 0
		end

		if dis_multiplier < 1 then
			if settings.notice_requires_FOV then
				my_head_fwd = my_head_fwd or data.unit:movement():m_head_rot():z()
				local angle = mvector3.angle(my_head_fwd, tmp_vec1)

				if angle < 55 and not my_data.detection.use_uncover_range and settings.uncover_range and dis < settings.uncover_range then
					return -1, 0
				end

				local angle_max = math.lerp(180, my_data.detection.angle_max, math.clamp((dis - 150) / 700, 0, 1))
				angle_multiplier = angle / angle_max

				if angle_multiplier < 1 then
					return angle, dis_multiplier
				end
			else
				return 0, dis_multiplier
			end
		end
	end

	local function _nearly_visible_chk(attention_info, detect_pos)
		local near_pos = tmp_vec1

		if attention_info.verified_dis < 2000 and math.abs(detect_pos.z - my_pos.z) < 300 then
			mvec3_set(near_pos, detect_pos)
			mvec3_set_z(near_pos, near_pos.z + 100)

			local near_vis_ray = World:raycast("ray", my_pos, near_pos, "slot_mask", data.visibility_slotmask, "ray_type", "ai_vision", "report")

			if near_vis_ray then
				local side_vec = tmp_vec1

				mvec3_set(side_vec, detect_pos)
				mvec3_sub(side_vec, my_pos)
				mvector3.cross(side_vec, side_vec, math.UP)
				mvector3.set_length(side_vec, 150)
				mvector3.set(near_pos, detect_pos)
				mvector3.add(near_pos, side_vec)

				local near_vis_ray = World:raycast("ray", my_pos, near_pos, "slot_mask", data.visibility_slotmask, "ray_type", "ai_vision", "report")

				if near_vis_ray then
					mvector3.multiply(side_vec, -2)
					mvector3.add(near_pos, side_vec)

					near_vis_ray = World:raycast("ray", my_pos, near_pos, "slot_mask", data.visibility_slotmask, "ray_type", "ai_vision", "report")
				end
			end

			if not near_vis_ray then
				attention_info.nearly_visible = true
				attention_info.last_verified_pos = mvector3.copy(near_pos)
			end
		end
	end

	local function _chk_record_acquired_attention_importance_wgt(attention_info)
		if not player_importance_wgt or not attention_info.is_human_player then
			return
		end

		local weight = mvector3.direction(tmp_vec1, attention_info.m_head_pos, my_pos)
		local e_fwd = nil

		if attention_info.is_husk_player then
			e_fwd = attention_info.unit:movement():detect_look_dir()
		else
			e_fwd = attention_info.unit:movement():m_head_rot():y()
		end

		local dot = mvector3.dot(e_fwd, tmp_vec1)
		local oneminusdot = 1 - dot
		weight = weight * weight * oneminusdot

		table.insert(player_importance_wgt, attention_info.u_key)
		table.insert(player_importance_wgt, weight)
	end

	local function _chk_record_attention_obj_importance_wgt(u_key, attention_info)
		if not player_importance_wgt then
			return
		end

		local is_human_player, is_local_player, is_husk_player = nil

		if attention_info.unit:base() then
			is_local_player = attention_info.unit:base().is_local_player
			is_husk_player = not is_local_player and attention_info.unit:base().is_husk_player
			is_human_player = is_local_player or is_husk_player
		end

		if not is_human_player then
			return
		end

		local weight = mvector3.direction(tmp_vec1, attention_info.handler:get_detection_m_pos(), my_pos)
		local e_fwd = nil

		if is_husk_player then
			e_fwd = attention_info.unit:movement():detect_look_dir()
		else
			e_fwd = attention_info.unit:movement():m_head_rot():y()
		end

		local dot = mvector3.dot(e_fwd, tmp_vec1)
		weight = weight * weight * (1 - dot)

		table.insert(player_importance_wgt, u_key)
		table.insert(player_importance_wgt, weight)
	end

	for u_key, attention_info in pairs(all_attention_objects) do
		if u_key ~= my_key and not detected_obj[u_key] and (not attention_info.nav_tracker or chk_vis_func(my_tracker, attention_info.nav_tracker)) then
			local settings = attention_info.handler:get_attention(my_access, min_reaction, max_reaction, data.team)

			if settings then
				local acquired = nil
				local attention_pos = attention_info.handler:get_detection_m_pos()

				if _angle_and_dis_chk(attention_info.handler, settings, attention_pos) then
					local vis_ray = World:raycast("ray", my_pos, attention_pos, "slot_mask", data.visibility_slotmask, "ray_type", "ai_vision")

					if not vis_ray or vis_ray.unit:key() == u_key then
						acquired = true
						detected_obj[u_key] = CopLogicBase._create_detected_attention_object_data(data.t, data.unit, u_key, attention_info, settings)
					end
				end

				if not acquired then
					_chk_record_attention_obj_importance_wgt(u_key, attention_info)
				end
			end
		end
	end

	for u_key, attention_info in pairs(detected_obj) do
		if t < attention_info.next_verify_t then
			if AIAttentionObject.REACT_SUSPICIOUS <= attention_info.reaction then
				delay = math.min(attention_info.next_verify_t - t, delay)
			end
		else
			attention_info.next_verify_t = t + (attention_info.identified and attention_info.verified and attention_info.settings.verification_interval or attention_info.settings.notice_interval or attention_info.settings.verification_interval)
			delay = math.min(delay, attention_info.settings.verification_interval)

			if not attention_info.identified then
				local noticable = nil
				local angle, dis_multiplier = _angle_and_dis_chk(attention_info.handler, attention_info.settings)

				if angle then
					local attention_pos = attention_info.handler:get_detection_m_pos()
					local vis_ray = World:raycast("ray", my_pos, attention_pos, "slot_mask", data.visibility_slotmask, "ray_type", "ai_vision")

					if not vis_ray or vis_ray.unit:key() == u_key then
						noticable = true
					end
				end

				local delta_prog = nil
				local dt = t - attention_info.prev_notice_chk_t

				if noticable then
					if angle == -1 then
						delta_prog = 1
					else
						local min_delay = my_data.detection.delay[1]
						local max_delay = my_data.detection.delay[2]
						local angle_mul_mod = 0.25 * math.min(angle / my_data.detection.angle_max, 1)
						local dis_mul_mod = 0.75 * dis_multiplier
						local notice_delay_mul = attention_info.settings.notice_delay_mul or 1

						if attention_info.settings.detection and attention_info.settings.detection.delay_mul then
							notice_delay_mul = notice_delay_mul * attention_info.settings.detection.delay_mul
						end

						local notice_delay_modified = math.lerp(min_delay * notice_delay_mul, max_delay, dis_mul_mod + angle_mul_mod)
						delta_prog = notice_delay_modified > 0 and dt / notice_delay_modified or 1
					end
				else
					delta_prog = dt * -0.125
				end

				attention_info.notice_progress = attention_info.notice_progress + delta_prog

				if attention_info.notice_progress > 1 then
					attention_info.notice_progress = nil
					attention_info.prev_notice_chk_t = nil
					attention_info.identified = true
					attention_info.release_t = t + attention_info.settings.release_delay
					attention_info.identified_t = t
					noticable = true

					data.logic.on_attention_obj_identified(data, u_key, attention_info)
				elseif attention_info.notice_progress < 0 then
					CopLogicBase._destroy_detected_attention_object_data(data, attention_info)

					noticable = false
				else
					noticable = attention_info.notice_progress
					attention_info.prev_notice_chk_t = t

					if data.cool and AIAttentionObject.REACT_SCARED <= attention_info.settings.reaction then
						managers.groupai:state():on_criminal_suspicion_progress(attention_info.unit, data.unit, noticable)
					end
				end

				if noticable ~= false and attention_info.settings.notice_clbk then
					attention_info.settings.notice_clbk(data.unit, noticable)
				end
			end

			if attention_info.identified then
				delay = math.min(delay, attention_info.settings.verification_interval)
				attention_info.nearly_visible = nil
				local verified, vis_ray = nil
				local attention_pos = attention_info.handler:get_detection_m_pos()
				local dis = mvector3.distance(data.m_pos, attention_info.m_pos)
				local thingy_chk1 = attention_info.settings.detection and attention_info.settings.detection.range_mul or 1
				local thingy_chk2 = not attention_info.settings.max_range or dis < attention_info.settings.max_range * thingy_chk1 * 1.2
				
				if dis < my_data.detection.dis_max * 1.2 and thingy_chk2 then
					local detect_pos = nil

					if attention_info.is_husk_player and attention_info.unit:anim_data().crouch then
						detect_pos = tmp_vec1

						mvector3.set(detect_pos, attention_info.m_pos)
						mvector3.add(detect_pos, tweak_data.player.stances.default.crouched.head.translation)
					else
						detect_pos = attention_pos
					end

					local in_FOV = not attention_info.settings.notice_requires_FOV or data.enemy_slotmask and attention_info.unit:in_slot(data.enemy_slotmask) or _angle_chk(attention_pos, dis, 0.8)

					if in_FOV then
						vis_ray = World:raycast("ray", my_pos, detect_pos, "slot_mask", data.visibility_slotmask, "ray_type", "ai_vision")

						if not vis_ray or vis_ray.unit:key() == u_key then
							attention_info.verified = true
						end
					end
				end

				attention_info.dis = dis
				attention_info.vis_ray = vis_ray or nil
				local is_ignored = false

				if attention_info.unit:movement() and attention_info.unit:movement().is_cuffed then
					is_ignored = attention_info.unit:movement():is_cuffed()
				end

				if is_ignored then
					CopLogicBase._destroy_detected_attention_object_data(data, attention_info)
				elseif attention_info.verified then
					attention_info.release_t = nil
					attention_info.verified_t = t

					mvector3.set(attention_info.verified_pos, attention_pos)

					attention_info.last_verified_pos = mvector3.copy(attention_pos)
					attention_info.verified_dis = dis
				elseif data.enemy_slotmask and attention_info.unit:in_slot(data.enemy_slotmask) then
					if attention_info.criminal_record and AIAttentionObject.REACT_COMBAT <= attention_info.settings.reaction then
						local seeninlast2seconds = attention_info.verified_t and attention_info.verified_t - t <= 2
						if not is_detection_persistent and not seeninlast2seconds and mvector3.distance(attention_pos, attention_info.verified_pos) > 250 then
							CopLogicBase._destroy_detected_attention_object_data(data, attention_info)
						else
							attention_info.verified_pos = mvector3.copy(attention_info.criminal_record.pos)
							attention_info.verified_dis = dis

							if attention_info.vis_ray and data.logic._chk_nearly_visible_chk_needed(data, attention_info, u_key) then
								_nearly_visible_chk(attention_info, attention_pos)
							end
						end
					elseif attention_info.release_t and attention_info.release_t < t then
						CopLogicBase._destroy_detected_attention_object_data(data, attention_info)
					else
						attention_info.release_t = attention_info.release_t or t + attention_info.settings.release_delay
					end
				elseif attention_info.release_t and attention_info.release_t < t then
					CopLogicBase._destroy_detected_attention_object_data(data, attention_info)
				else
					attention_info.release_t = attention_info.release_t or t + attention_info.settings.release_delay
				end
			end
		end

		_chk_record_acquired_attention_importance_wgt(attention_info)
	end

	if player_importance_wgt then
		managers.groupai:state():set_importance_weight(data.key, player_importance_wgt)
	end

	return delay
end

function CopLogicBase.chk_start_action_dodge(data, reason)

	if not data.char_tweak.dodge or not data.char_tweak.dodge.occasions[reason] then
		return
	end

	if data.dodge_timeout_t and data.t < data.dodge_timeout_t or data.dodge_chk_timeout_t and data.t < data.dodge_chk_timeout_t or data.unit:movement():chk_action_forbidden("walk") then
		return
	end
	local dodge_tweak = data.char_tweak.dodge.occasions[reason]
	
	data.dodge_chk_timeout_t = TimerManager:game():time() + math.lerp(dodge_tweak.check_timeout[1], dodge_tweak.check_timeout[2], math.random())
	if dodge_tweak.chance == 0 or dodge_tweak.chance < math.random() then
		return
	end
	
	local rand_nr = math.random()
	local total_chance = 0
	local variation, variation_data = nil
	for test_variation, test_variation_data in pairs(dodge_tweak.variations) do
		total_chance = total_chance + test_variation_data.chance
		if test_variation_data.chance > 0 and rand_nr <= total_chance then
			variation = test_variation
			variation_data = test_variation_data
			break
		end
	end

	local dodge_dir = Vector3()
	local face_attention = nil
	
	if data.attention_obj and AIAttentionObject.REACT_COMBAT <= data.attention_obj.reaction then
		mvec3_set(dodge_dir, data.attention_obj.m_pos)
		mvec3_sub(dodge_dir, data.m_pos)
		mvector3.set_z(dodge_dir, 0)
		mvector3.normalize(dodge_dir)
		if mvector3.dot(data.unit:movement():m_fwd(), dodge_dir) < 0 then
			return
		end
		mvector3.cross(dodge_dir, dodge_dir, math.UP)
		face_attention = true
	else
		mvector3.random_orthogonal(dodge_dir, math.UP)
	end
	
	local dodge_dir_reversed = false
	
	if math.random() < 0.5 then
		mvector3.negate(dodge_dir)
		dodge_dir_reversed = not dodge_dir_reversed
	end
	
	local prefered_space = 200
	local min_space = 130
	local ray_to_pos = tmp_vec1
	mvec3_set(ray_to_pos, dodge_dir)
	mvector3.multiply(ray_to_pos, 200)
	mvector3.add(ray_to_pos, data.m_pos)
	
	local ray_params = {
		trace = true,
		tracker_from = data.unit:movement():nav_tracker(),
		pos_to = ray_to_pos
	}
	
	local ray_hit1 = managers.navigation:raycast(ray_params)
	local dis = nil
	
	if ray_hit1 then
		local hit_vec = tmp_vec2
		mvec3_set(hit_vec, ray_params.trace[1])
		mvec3_sub(hit_vec, data.m_pos)
		mvec3_set_z(hit_vec, 0)
		dis = mvector3.length(hit_vec)
		mvec3_set(ray_to_pos, dodge_dir)
		mvector3.multiply(ray_to_pos, -200)
		mvector3.add(ray_to_pos, data.m_pos)
		ray_params.pos_to = ray_to_pos
		local ray_hit2 = managers.navigation:raycast(ray_params)
		if ray_hit2 then
			mvec3_set(hit_vec, ray_params.trace[1])
			mvec3_sub(hit_vec, data.m_pos)
			mvec3_set_z(hit_vec, 0)
			local prev_dis = dis
			dis = mvector3.length(hit_vec)
			if prev_dis < dis and min_space < dis then
				mvector3.negate(dodge_dir)
				dodge_dir_reversed = not dodge_dir_reversed
			end
		else
			mvector3.negate(dodge_dir)
			dis = nil
			dodge_dir_reversed = not dodge_dir_reversed
		end
	end
	
	if ray_hit1 and dis and dis < min_space then
		return
	end
	
	local dodge_side
	local fwd_dot = mvec3_dot(dodge_dir, data.unit:movement():m_fwd())
	local my_right = tmp_vec1
	mrotation.x(data.unit:movement():m_rot(), my_right)
	local right_dot = mvec3_dot(dodge_dir, my_right)
	dodge_side = math.abs(fwd_dot) > 0.7071067690849 and (fwd_dot > 0 and "fwd" or "bwd") or right_dot > 0 and "r" or "l"
	local body_part = 1
	local shoot_chance = variation_data.shoot_chance
	if shoot_chance and shoot_chance > 0 and math.random() < shoot_chance then
		body_part = 2
	end

	local action_data = {
		type = "dodge",
		body_part = body_part,
		variation = variation,
		side = dodge_side,
		direction = dodge_dir,
		timeout = variation_data.timeout,
		speed = data.char_tweak.dodge.speed,
		shoot_accuracy = variation_data.shoot_accuracy,
		blocks = {
			act = -1,
			tase = -1,
			bleedout = -1,
			dodge = -1,
			walk = -1,
			action = body_part == 1 and -1 or nil,
			aim = body_part == 1 and -1 or nil
		}
	}
	if variation ~= "side_step" then -- they can play hurts while side-stepping
		action_data.blocks.hurt = -1
		action_data.blocks.heavy_hurt = -1
	end
	local action = data.unit:movement():action_request(action_data)
	if action then
		local my_data = data.internal_data
		CopLogicAttack._cancel_cover_pathing(data, my_data)
		CopLogicAttack._cancel_charge(data, my_data)
		CopLogicAttack._cancel_expected_pos_path(data, my_data)
		CopLogicAttack._cancel_walking_to_cover(data, my_data, true)
	end
	return action
end

function CopLogicBase.on_suppressed_state(data)
	if not Global.game_settings.one_down then
		if data.is_suppressed and data.objective then
			local allow_trans, interrupt = CopLogicBase.is_obstructed(data, data.objective, nil, nil)

			if interrupt then
				data.objective_failed_clbk(data.unit, data.objective)
			end
		end
	end
end

function CopLogicBase.queue_task(internal_data, id, func, data, exec_t, asap)
	if internal_data.unit and internal_data ~= internal_data.unit:brain()._logic_data.internal_data then
		debug_pause("[CopLogicBase.queue_task] Task queued from the wrong logic", internal_data.unit, id, func, data, exec_t, asap)
	end

	local qd_tasks = internal_data.queued_tasks

	if qd_tasks then
		if qd_tasks[id] then
			debug_pause("[CopLogicBase.queue_task] Task queued twice", internal_data.unit, id, func, data, exec_t, asap)
		end

		qd_tasks[id] = true
	else
		internal_data.queued_tasks = {
			[id] = true
		}
	end
	
	if data.team and data.team.id == tweak_data.levels:get_default_team_ID("player") or data.is_converted or data.unit and data.unit:in_slot(16) or data.unit and data.unit:in_slot(managers.slot:get_mask("criminals")) or data.unit and data.unit:base():has_tag("special") then
		exec_t = 0
	end
	
	if data.t then
	
		exec_t = data.t + 0.016
		
		if not exec_t then
			exec_t = data.t
		end
	end

	managers.enemy:queue_task(id, func, data, exec_t, callback(CopLogicBase, CopLogicBase, "on_queued_task", internal_data), asap)
end

function CopLogicBase.death_clbk(data, damage_info)
	if data.weapon_laser_on then
		if data.unit:inventory():equipped_unit() then
			data.unit:inventory():equipped_unit():base():set_laser_enabled(false)
		end

		data.weapon_laser_on = nil
		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", data.unit, "brain", HuskCopBrain._NET_EVENTS.weapon_laser_off)

	end
end
