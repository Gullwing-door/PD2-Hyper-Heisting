local math_min = math.min

TeamAILogicAssault._COVER_CHK_INTERVAL = 0.1

function TeamAILogicAssault.action_complete_clbk(data, action)
	local my_data = data.internal_data
	local action_type = action:type()

	if action_type == "walk" then
		my_data.advancing = nil

		if my_data.surprised then
			my_data.surprised = false
		elseif my_data.moving_to_cover then
			if action:expired() then
				my_data.in_cover = my_data.moving_to_cover
				my_data.cover_enter_t = data.t
				my_data.cover_sideways_chk = nil
			end

			my_data.moving_to_cover = nil
		elseif my_data.walking_to_cover_shoot_pos then
			my_data.walking_to_cover_shoot_pos = nil
		end
		
		if action:expired() then
			CopLogicAttack._upd_aim(data, my_data)
		end	
	elseif action_type == "shoot" then
		my_data.shooting = nil
	elseif action_type == "turn" then
		my_data.turning = nil

		if my_data._turning_to_intimidate then
			my_data._turning_to_intimidate = nil

			TeamAILogicIdle.intimidate_civilians(data, data.unit, true, true, my_data._primary_intimidation_target)

			my_data._primary_intimidation_target = nil
		end
		
		if action:expired() then
			CopLogicAttack._upd_aim(data, my_data)
		end	
	elseif action_type == "hurt" then
		if action:expired() then
			CopLogicAttack._upd_aim(data, my_data)
		end
	elseif action_type == "dodge" then
		CopLogicAttack._upd_aim(data, my_data)
	end
end

function TeamAILogicAssault._upd_enemy_detection(data, is_synchronous)
	managers.groupai:state():on_unit_detection_updated(data.unit)

	data.t = TimerManager:game():time()
	local my_data = data.internal_data
	local max_reaction = nil

	if data.cool then
		max_reaction = AIAttentionObject.REACT_SURPRISED
	end

	local delay = CopLogicBase._upd_attention_obj_detection(data, nil, max_reaction)
	local new_attention, new_prio_slot, new_reaction = TeamAILogicIdle._get_priority_attention(data, data.detected_attention_objects, nil)
	local old_att_obj = data.attention_obj

	TeamAILogicBase._set_attention_obj(data, new_attention, new_reaction)
	
	if data.objective then
	
		if data.objective.type == "revive" and managers.player:is_custom_cooldown_not_active("team", "crew_inspire") then
			local attention = data.detected_attention_objects[data.objective.follow_unit:key()]

			TeamAILogicTravel.check_inspire(data, attention)
		end
		
		if data.objective.type == "follow" or data.objective.type == "revive" then
			if TeamAILogicIdle._check_should_relocate(data, my_data, data.objective) and not data.unit:movement():chk_action_forbidden("walk") then
				data.objective.in_place = nil

				data.objective.called = true

				TeamAILogicBase._exit(data.unit, "travel")

				return
			end
		elseif data.objective.type == "free" and data.objective.guard_unit then
			if TeamAILogicIdle._check_guard(data, my_data) and not data.unit:movement():chk_action_forbidden("walk") then
				data.objective.in_place = nil

				TeamAILogicBase._exit(data.unit, "travel")

				return
			end
		end
	end

	if my_data ~= data.internal_data then
		return
	end
	
	TeamAILogicAssault._chk_exit_attack_logic(data, new_reaction)

	if my_data ~= data.internal_data then
		return
	end
	
    if data.objective and data.objective.type == "follow" and data.objective.taserrescue then
        if not alive(data.objective.follow_unit) then
            data.objective_complete_clbk(data.unit, data.objective)
        elseif data.objective.follow_unit:character_damage():dead() then
            data.objective_complete_clbk(data.unit, data.objective)
        end
    end

	CopLogicAttack._upd_aim(data, my_data)

	if not data.unit:brain()._intimidate_t or data.unit:brain()._intimidate_t + 2 < data.t then
		if not my_data._turning_to_intimidate and data.unit:character_damage():health_ratio() > 0.5 then
			local can_turn = nil

			if not new_prio_slot or new_prio_slot > 5 then
				if not data.unit:movement():chk_action_forbidden("turn") then
					can_turn = true
				end
			end

			local is_assault = managers.groupai:state():get_assault_mode()
			local shout_angle = can_turn and 180 or 60
			local shout_distance = is_assault and 800 or 1200
			local civ = TeamAILogicIdle.find_civilian_to_intimidate(data.unit, shout_angle, shout_distance)

			if civ then
				data.unit:brain()._intimidate_t = data.t

				if can_turn and CopLogicAttack._chk_request_action_turn_to_enemy(data, my_data, data.unit:movement():m_pos(), civ:movement():m_pos()) then
					my_data._turning_to_intimidate = true
					my_data._primary_intimidation_target = civ
				else
					TeamAILogicIdle.intimidate_civilians(data, data.unit, true, false)
				end
			end
		end
	end

	if not my_data.acting then
		if not TeamAILogicAssault._mark_special_chk_t or TeamAILogicAssault._mark_special_chk_t + 0.75 < data.t then
			if not TeamAILogicAssault._mark_special_t or TeamAILogicAssault._mark_special_t + 3 < data.t then
				if not data.unit:sound():speaking() then
					TeamAILogicAssault._mark_special_chk_t = data.t
					
					if data.attention_obj and AIAttentionObject.REACT_COMBAT <= data.attention_obj.reaction and data.attention_obj.unit and data.attention_obj.unit:base().has_tag and data.attention_obj.unit:base():has_tag("special") and data.attention_obj.verified and data.attention_obj.verified_dis < 2000 then
						nmy = data.attention_obj.unit
					else
						nmy = TeamAILogicAssault.find_enemy_to_mark(data.detected_attention_objects)
					end

					if nmy then
						TeamAILogicAssault._mark_special_t = data.t
						TeamAILogicAssault.mark_enemy(data, data.unit, nmy, true, true)
					end
				end
			end
		end
	end

	TeamAILogicAssault._chk_request_combat_chatter(data, my_data)

	if not is_synchronous then
		CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicAssault._upd_enemy_detection, data, data.t + delay)
	end
end

function TeamAILogicAssault.find_enemy_to_mark(attention_objects)
	local best_nmy, best_nmy_wgt = nil
	
	for key, attention_info in pairs(attention_objects) do
		if attention_info.identified then
			if attention_info.verified then
				if attention_info.reaction and AIAttentionObject.REACT_COMBAT <= attention_info.reaction and attention_info.unit:contour() then
					if attention_info.is_deployable or attention_info.is_person and attention_info.char_tweak and attention_info.char_tweak.priority_shout then
						local in_range = nil

						if attention_info.is_deployable then
							local turret_tweak = attention_info.unit:brain() and attention_info.unit:brain()._tweak_data

							if turret_tweak then

								if attention_info.verified_dis < 2000 then
									in_range = true
								end
							end
						elseif not attention_info.char_tweak.priority_shout_max_dis or attention_info.verified_dis < 3000 then
							in_range = true
						end

						if in_range then
							local att_contour = attention_info.unit:contour()
							local mark = false

							if not att_contour._contour_list then
								mark = true
							else
								if attention_info.is_deployable then
									if not att_contour:has_id("mark_unit_dangerous") and not att_contour:has_id("mark_unit_dangerous_damage_bonus") and not att_contour:has_id("mark_unit_dangerous_damage_bonus_distance") then
										mark = true
									end
								else
									if not att_contour:has_id("mark_enemy") and not att_contour:has_id("mark_enemy_damage_bonus") and not att_contour:has_id("mark_enemy_damage_bonus_distance") then
										mark = true
									end
								end
							end

							if mark then
								if not best_nmy_wgt or attention_info.verified_dis < best_nmy_wgt then
									best_nmy_wgt = attention_info.verified_dis
									best_nmy = attention_info.unit
								end
							end
						end
					end
				end
			end
		end
	end

	return best_nmy
end

function TeamAILogicAssault.mark_enemy(data, criminal, to_mark, play_sound, play_action)
	if play_sound then
		local callout = not criminal:brain()._last_mark_shout or tweak_data.sound.criminal_sound.ai_callout_cooldown < TimerManager:game():time() - criminal:brain()._last_mark_shout

		if callout then
			if to_mark:base().sentry_gun then
				criminal:sound():say("f44x_any", true)
			elseif to_mark:base():char_tweak().bot_priority_shout then
				criminal:sound():say(to_mark:base():char_tweak().bot_priority_shout, true)
			else
				criminal:sound():say(to_mark:base():char_tweak().priority_shout .. "x_any", true)
			end

			criminal:brain()._last_mark_shout = TimerManager:game():time()
		end
	end

	if play_action then
		local can_play_action = not criminal:anim_data().reload and not data.internal_data.firing and not data.internal_data.shooting

		if can_play_action and not criminal:movement():chk_action_forbidden("action") then
			local new_action = {
				type = "act",
				variant = "arrest",
				body_part = 3,
				align_sync = true
			}

			if criminal:brain():action_request(new_action) then
				data.internal_data.gesture_arrest = true
			end
		end
	end

	if to_mark:base().sentry_gun then
		to_mark:contour():add("mark_unit_dangerous", true)
	else
		to_mark:contour():add("mark_enemy", true)
	end

	local skip_alert = managers.groupai:state():whisper_mode()

	if not skip_alert then
		local alert_rad = 500
		local alert = {
			"vo_cbt",
			criminal:movement():m_head_pos(),
			alert_rad,
			data.SO_access,
			criminal
		}

		managers.groupai:state():propagate_alert(alert)
	end
end

function TeamAILogicAssault._chk_request_combat_chatter(data, my_data)
	if not data.unit:sound():speaking() then
		if my_data.firing or my_data.shooting then
			local focus_enemy = data.attention_obj

			if focus_enemy and focus_enemy.identified and focus_enemy.verified and focus_enemy.is_person and focus_enemy.reaction and AIAttentionObject.REACT_COMBAT <= focus_enemy.reaction then
				managers.groupai:state():chk_say_teamAI_combat_chatter(data.unit)
			end
		end
	end
end
