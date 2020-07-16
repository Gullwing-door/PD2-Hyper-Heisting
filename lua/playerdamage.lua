local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec3_sub = mvector3.subtract
local mvec3_mul = mvector3.multiply
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_set_l = mvector3.set_length
local mvec3_len = mvector3.length
local math_clamp = math.clamp
local math_lerp = math.lerp
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_rot1 = Rotation()

Hooks:PostHook(PlayerDamage, "init", "hhpost_lives", function(self, unit)
	self._lives_init = tweak_data.player.damage.LIVES_INIT

	if Global.game_settings.one_down then
		self._lives_init = tweak_data.player.damage.LIVES_INIT
	end

	self._lives_init = managers.modifiers:modify_value("PlayerDamage:GetMaximumLives", self._lives_init)
	
	if managers.player:has_category_upgrade("player", "criticalmode") then
		if self._lives_init ~= 1 then
			self._lives_init = self._lives_init - 1
		end
	end
	
	self._unit = unit
	self._max_health_reduction = managers.player:upgrade_value("player", "max_health_reduction", 1)
	self._healing_reduction = managers.player:upgrade_value("player", "healing_reduction", 1)
	self._revives = Application:digest_value(0, true)
	self._uppers_elapsed = 0

	self:replenish()

	local player_manager = managers.player
	self._bleed_out_health = Application:digest_value(tweak_data.player.damage.BLEED_OUT_HEALTH_INIT * player_manager:upgrade_value("player", "bleed_out_health_multiplier", 1), true)
	self._god_mode = Global.god_mode
	self._invulnerable = false
	self._mission_damage_blockers = {}
	self._gui = Overlay:newgui()
	self._ws = self._gui:create_screen_workspace()
	self._focus_delay_mul = 1
	self._dmg_interval = tweak_data.player.damage.MIN_DAMAGE_INTERVAL
	self._next_allowed_dmg_t = Application:digest_value(-100, true)
	self._last_received_dmg = 0
	self._next_allowed_sup_t = -100
	self._last_received_sup = 0
	self._supperssion_data = {}
	self._inflict_damage_body = self._unit:body("inflict_reciever")

	self._inflict_damage_body:set_extension(self._inflict_damage_body:extension() or {})

	local body_ext = PlayerBodyDamage:new(self._unit, self, self._inflict_damage_body)
	self._inflict_damage_body:extension().damage = body_ext

	managers.sequence:add_inflict_updator_body("fire", self._unit:key(), self._inflict_damage_body:key(), self._inflict_damage_body:extension().damage)

	self._doh_data = tweak_data.upgrades.damage_to_hot_data or {}
	self._damage_to_hot_stack = {}
	self._armor_stored_health = 0
	self._can_take_dmg_timer = 0
	self._regen_on_the_side_timer = 0
	self._regen_on_the_side = false
	self._interaction = managers.interaction
	self._armor_regen_mul = managers.player:upgrade_value("player", "armor_regen_time_mul", 1)
	self._dire_need = managers.player:has_category_upgrade("player", "armor_depleted_stagger_shot")
	self._has_damage_speed = managers.player:has_inactivate_temporary_upgrade("temporary", "damage_speed_multiplier")
	self._has_damage_speed_team = managers.player:upgrade_value("player", "team_damage_speed_multiplier_send", 0) ~= 0

	local function revive_player()
		self:revive(true)
	end

	managers.player:register_message(Message.RevivePlayer, self, revive_player)

	self._current_armor_fill = 0
	local has_swansong_skill = player_manager:has_category_upgrade("temporary", "berserker_damage_multiplier")
	self._current_state = nil
	self._listener_holder = unit:event_listener()

	if player_manager:has_category_upgrade("player", "damage_to_armor") then
		local damage_to_armor_data = player_manager:upgrade_value("player", "damage_to_armor", nil)
		local armor_data = tweak_data.blackmarket.armors[managers.blackmarket:equipped_armor(true, true)]

		if damage_to_armor_data and armor_data then
			local idx = armor_data.upgrade_level
			self._damage_to_armor = {
				armor_value = damage_to_armor_data[idx][1],
				target_tick = damage_to_armor_data[idx][2],
				elapsed = 0
			}

			local function on_damage(damage_info)
				local attacker_unit = damage_info and damage_info.attacker_unit

				if alive(attacker_unit) and attacker_unit:base() and attacker_unit:base().thrower_unit then
					attacker_unit = attacker_unit:base():thrower_unit()
				end

				if self._unit == attacker_unit then
					local time = Application:time()

					if self._damage_to_armor.target_tick < time - self._damage_to_armor.elapsed then
						self._damage_to_armor.elapsed = time

						self:restore_armor(self._damage_to_armor.armor_value, true)
					end
				end
			end

			CopDamage.register_listener("on_damage", {
				"on_damage"
			}, on_damage)
		end
	end

	self._listener_holder:add("on_use_armor_bag", {
		"on_use_armor_bag"
	}, callback(self, self, "_on_use_armor_bag_event"))

	if self:_init_armor_grinding_data() then
		function self._on_damage_callback_func()
			return callback(self, self, "_on_damage_armor_grinding")
		end

		self:_add_on_damage_event()
		self._listener_holder:add("on_enter_bleedout", {
			"on_enter_bleedout"
		}, callback(self, self, "_on_enter_bleedout_event"))

		if has_swansong_skill then
			self._listener_holder:add("on_enter_swansong", {
				"on_enter_swansong"
			}, callback(self, self, "_on_enter_swansong_event"))
			self._listener_holder:add("on_exit_swansong", {
				"on_enter_bleedout"
			}, callback(self, self, "_on_exit_swansong_event"))
		end

		self._listener_holder:add("on_revive", {
			"on_revive"
		}, callback(self, self, "_on_revive_event"))
	else
		self:_init_standard_listeners()
	end

	if player_manager:has_category_upgrade("temporary", "revive_damage_reduction") then
		self._listener_holder:add("combat_medic_damage_reduction", {
			"on_revive"
		}, callback(self, self, "_activate_combat_medic_damage_reduction"))
	end

	if player_manager:has_category_upgrade("player", "revive_damage_reduction") and player_manager:has_category_upgrade("player", "revive_damage_reduction") then
		local function on_revive_interaction_start()
			managers.player:set_property("revive_damage_reduction", player_manager:upgrade_value("player", "revive_damage_reduction"), 1)
		end

		local function on_exit_interaction()
			managers.player:remove_property("revive_damage_reduction")
		end

		local function on_revive_interaction_success()
			managers.player:activate_temporary_upgrade("temporary", "revive_damage_reduction")
		end

		self._listener_holder:add("on_revive_interaction_start", {
			"on_revive_interaction_start"
		}, on_revive_interaction_start)
		self._listener_holder:add("on_revive_interaction_interrupt", {
			"on_revive_interaction_interrupt"
		}, on_exit_interaction)
		self._listener_holder:add("on_revive_interaction_success", {
			"on_revive_interaction_success"
		}, on_revive_interaction_success)
	end

	managers.mission:add_global_event_listener("player_regenerate_armor", {
		"player_regenerate_armor"
	}, callback(self, self, "_regenerate_armor"))
	managers.mission:add_global_event_listener("player_force_bleedout", {
		"player_force_bleedout"
	}, callback(self, self, "force_into_bleedout", false))

	local level_tweak = tweak_data.levels[managers.job:current_level_id()]

	if level_tweak and level_tweak.is_safehouse and not level_tweak.is_safehouse_combat then
		self:set_mission_damage_blockers("damage_fall_disabled", true)
		self:set_mission_damage_blockers("invulnerable", true)
	end

	self._delayed_damage = {
		epsilon = 0.001,
		chunks = {}
	}

	self:clear_delayed_damage()
end)

Hooks:PostHook(PlayerDamage, "damage_melee", "hhpost_dmgmelee", function(self, attack_data)
	local player_unit = managers.player:player_unit()
	local cur_state = self._unit:movement():current_state_name()
	if attack_data then
		local next_allowed_dmg_t = type(self._next_allowed_dmg_t) == "number" and self._next_allowed_dmg_t or Application:digest_value(self._next_allowed_dmg_t, false)
		local t = managers.player:player_timer():time()
		local dmg_is_allowed = next_allowed_dmg_t and next_allowed_dmg_t > t
		
		--enemies were meleeing players and taking their guns away during invincibility frames and thats no bueno
		if alive(attack_data.attacker_unit) and not self:is_downed() and not self._bleed_out and not self._dead and cur_state ~= "fatal" and cur_state ~= "bleedout" and not self._invulnerable and not self._unit:character_damage().swansong and not self._unit:movement():tased() and not self._mission_damage_blockers.invulnerable and not self._god_mode and not self:incapacitated() and not self._unit:movement():current_state().immortal and dmg_is_allowed then
			-- log("balls")				
			if alive(player_unit) and tostring(attack_data.attacker_unit:base()._tweak_table) ~= "fbi" and tostring(attack_data.attacker_unit:base()._tweak_table) ~= "fbi_xc45" and tostring(attack_data.attacker_unit:base()._tweak_table) ~= "fbi_pager" then
				self._unit:movement():current_state():on_melee_stun(managers.player:player_timer():time(), 0.4)
			end
		end
		
		if alive(attack_data.attacker_unit) and not self:is_downed() and not self._bleed_out and not self._dead and cur_state ~= "fatal" and cur_state ~= "bleedout" and not self._invulnerable and not self._unit:character_damage().swansong and not self._unit:movement():tased() and not self._mission_damage_blockers.invulnerable and not self._god_mode and not self:incapacitated() and not self._unit:movement():current_state().immortal then
			if tostring(attack_data.attacker_unit:base()._tweak_table) == "fbi" or tostring(attack_data.attacker_unit:base()._tweak_table) == "fbi_xc45" or tostring(attack_data.attacker_unit:base()._tweak_table) == "fbi_pager" then
				if alive(player_unit) then
					managers.player:set_player_state("arrested")
				end
			end	
		end
	end
	
--[[	local go_through_armor = false --manual toggle
	local health_subtracted = nil
	local armor_broken = false

	if go_through_armor then
		health_subtracted = self:_calc_armor_damage(attack_data)

		attack_data.damage = attack_data.damage - health_subtracted

		health_subtracted = health_subtracted + self:_calc_health_damage(attack_data)

		armor_broken = self:_max_armor() == 0 or self:_max_armor() > 0 and self:get_real_armor() <= 0 --works when armor is broken and health damage is taken by the same hit
	else
		local armor_reduction_multiplier = 0

		if self:get_real_armor() <= 0 then --if armor is already broken, don't negate health damage
			armor_reduction_multiplier = 1
			armor_broken = true --checked before actually taking damage
		end

		health_subtracted = self:_calc_armor_damage(attack_data)

		if attack_data.melee_armor_piercing then --for specific cases, like say, making headless Dozers able to go through armor with melee when other enemies can't
			attack_data.damage = attack_data.damage - health_subtracted
		else
			attack_data.damage = attack_data.damage * armor_reduction_multiplier
		end

		health_subtracted = health_subtracted + self:_calc_health_damage(attack_data)
	end
	
	if self._bleed_out then
		self:_bleed_out_damage(attack_data)

		--bleed_out = always taking health damage, so use the appropiate sound and cause a blood effect if the weapon isn't tase capable
		local hit_sound = "hit_body"

		--unless damage is completely negated
		if attack_data.damage == 0 then
			hit_sound = "hit_gen"
		end

		self:play_melee_hit_sound_and_effects(attack_data, hit_sound, not attack_data.tase_player)

		return
	end	
	
	local hit_sound_type = "hit_gen"
	local blood_effect = false

	if armor_broken then
		hit_sound_type = "hit_body"
		blood_effect = not attack_data.tase_player
	end

	self:play_melee_hit_sound_and_effects(attack_data, hit_sound_type, blood_effect)--]]
end)

--[[local mvec1 = Vector3()

function PlayerDamage:play_melee_hit_sound_and_effects(attack_data, sound_type, play_blood_effect)
	if play_blood_effect then
		--make sure the weapon is supposed to cause a blood splatter
		local blood_effect = attack_data.melee_weapon and attack_data.melee_weapon == "weapon"
		blood_effect = blood_effect or attack_data.melee_weapon and tweak_data.weapon.npc_melee[attack_data.melee_weapon] and tweak_data.weapon.npc_melee[attack_data.melee_weapon].player_blood_effect or false

		if blood_effect then --spawn a blood splatter in front of the player
			local pos = mvec1

			mvector3.set(pos, self._unit:camera():forward())
			mvector3.multiply(pos, 20)
			mvector3.add(pos, self._unit:camera():position())

			local rot = self._unit:camera():rotation():z()

			World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/impacts/blood/blood_impact_a"),
				position = pos,
				normal = rot
			})
		end
	end

	local melee_name_id = nil
	local attacker_unit = attack_data.attacker_unit
	local valid_attacker = attacker_unit and alive(attacker_unit) and attacker_unit:base()

	if valid_attacker then
		--get melee weapon id
		if attacker_unit:base().is_husk_player then
			local peer_id = managers.network:session():peer_by_unit(attacker_unit):id()
			local peer = managers.network:session():peer(peer_id)

			melee_name_id = peer:melee_id()
		else
			melee_name_id = attacker_unit:base().melee_weapon and attacker_unit:base():melee_weapon()
		end

		if melee_name_id then
			if melee_name_id == "knife_1" then --knife used by NPCs
				melee_name_id = "kabar"
			elseif melee_name_id == "helloween" then --titan staff used by headless Dozers
				melee_name_id = "brass_knuckles"
			elseif not attacker_unit:base().is_husk_player and melee_name_id == "baton" then --cop baton (otherwise the ballistic baton's sounds are used)
				melee_name_id = "weapon"
			end

			local tweak_data = tweak_data.blackmarket.melee_weapons[melee_name_id]

			if tweak_data and tweak_data.sounds and tweak_data.sounds[sound_type] then
				local post_event = tweak_data.sounds[sound_type]
				local anim_attack_vars = tweak_data.anim_attack_vars
				local variation = anim_attack_vars and math.random(#anim_attack_vars)

				if type(post_event) == "table" then
					if variation then
						post_event = post_event[variation]
					else
						post_event = post_event[1]
					end
				end

				--some sounds are too low to hear, playing them twice helps and or accentuates a hit even more)
				self._unit:sound():play(post_event, nil, false)
				self._unit:sound():play(post_event, nil, false)
			end
		end
	end
end--]]

function PlayerDamage:clbk_kill_taunt(attack_data) -- just a nice little detail
	if attack_data.attacker_unit and attack_data.attacker_unit:alive() then
		if not attack_data.attacker_unit:base()._tweak_table then
			return
		end
		
		self._kill_taunt_clbk_id = nil
		if attack_data.attacker_unit:base():has_tag("tank") then
			attack_data.attacker_unit:sound():say("post_kill_taunt")
		elseif attack_data.attacker_unit:base():has_tag("law") and not attack_data.attacker_unit:base():has_tag("special") then	
			attack_data.attacker_unit:sound():say("i03")
		else
			--nothing
		end
	end
end

function PlayerDamage:has_jackpot_token()
	return self._jackpot_token
end

function PlayerDamage:activate_jackpot_token()
	self._jackpot_token = true
	--log("this party's gettin crazy")
end

function PlayerDamage:_regenerated(no_messiah)
	self:set_health(self:_max_health())
	self:_send_set_health()
	self:_set_health_effect()
	self._jackpot_token = nil

	self._said_hurt = false
	self._revives = Application:digest_value(self._lives_init + managers.player:upgrade_value("player", "additional_lives", 0), true)
	self._revive_health_i = 1

	managers.environment_controller:set_last_life(false)

	self._down_time = tweak_data.player.damage.DOWNED_TIME

	if not no_messiah then
		self._messiah_charges = managers.player:upgrade_value("player", "pistol_revive_from_bleed_out", 0)
	end
end

function PlayerDamage:_chk_dmg_too_soon(damage, ...)
	local next_allowed_dmg_t = type(self._next_allowed_dmg_t) == "number" and self._next_allowed_dmg_t or Application:digest_value(self._next_allowed_dmg_t, false)
	local t = managers.player:player_timer():time()
	if damage <= self._last_received_dmg + 0.01 and next_allowed_dmg_t > t then
		self._old_last_received_dmg = nil
		self._old_next_allowed_dmg_t = nil
		return true
	end
	
	if next_allowed_dmg_t > t then
		self._old_last_received_dmg = self._last_received_dmg
		self._old_next_allowed_dmg_t = next_allowed_dmg_t
	end
end

Hooks:PostHook(PlayerDamage, "damage_bullet", "hhpost_dmgbullet", function(self, attack_data)
	local armor_damage = self:_max_armor() > 0 and self:get_real_armor() < self:_max_armor()
	local cur_state = self._unit:movement():current_state_name()
	
	if self._bleed_out and self._akuma_effect then
		managers.groupai:state():chk_taunt()
	end
	
	if attack_data then
		if alive(attack_data.attacker_unit) and not self:is_downed() and not self._dead and cur_state ~= "fatal" and cur_state ~= "bleedout" and not self._invulnerable and not self._unit:character_damage().swansong and not self._unit:movement():tased() and not self._mission_damage_blockers.invulnerable and not self._god_mode and not self:incapacitated() and not self._unit:movement():current_state().immortal then
			if tostring(attack_data.attacker_unit:base()._tweak_table) == "akuma" then
				if alive(player_unit) then
					--self._akuma_effect = true
					self:build_suppression(99)
					return
				end
			end
		end
	end
	
	--local testing = true
	local state_chk = cur_state == "standard" or cur_state == "carry" or cur_state == "bipod"
	if Global.game_settings.bulletknock or testing then
		if alive(attack_data.attacker_unit) and state_chk then
			local from_pos = nil

			--probably unnecessary but you never know
			if attack_data.attacker_unit:movement() then
				if attack_data.attacker_unit:movement().m_head_pos then
					from_pos = attack_data.attacker_unit:movement():m_head_pos()
				elseif attack_data.attacker_unit:movement().m_pos then
					from_pos = attack_data.attacker_unit:movement():m_pos()
				else
					from_pos = attack_data.attacker_unit:position()
				end
			else
				from_pos = attack_data.attacker_unit:position()
			end

			local push_vec = Vector3()
			local distance = mvector3.direction(push_vec, from_pos, self._unit:movement():m_head_pos())
			mvector3.normalize(push_vec)

			local dis_lerp_value = math.clamp(distance, 0, 1000) / 1000
			local push_amount = math.lerp(1000, 0, dis_lerp_value)

			self._unit:movement():push(push_vec * push_amount)
		end
	end
	
	if not self:_chk_can_take_dmg() then
		return
	end
	
	local armor_subtracted = self:_calc_armor_damage(attack_data)
	if not self._bleed_out and armor_subtracted > 0 then
		managers.groupai:state():criminal_hurt_drama_armor(self._unit, attacker)
	end

end)

local _calc_armor_damage_original = PlayerDamage._calc_armor_damage
function PlayerDamage:_calc_armor_damage(attack_data, ...)
	attack_data.damage = attack_data.damage - (self._old_last_received_dmg or 0)
	self._next_allowed_dmg_t = self._old_next_allowed_dmg_t and Application:digest_value(self._old_next_allowed_dmg_t, true) or self._next_allowed_dmg_t
	self._old_last_received_dmg = nil
	self._old_next_allowed_dmg_t = nil
	return _calc_armor_damage_original(self, attack_data, ...)
end

function PlayerDamage:_calc_health_damage(attack_data)

	attack_data.damage = attack_data.damage - (self._old_last_received_dmg or 0)
	if self._unit then
		local state = self._unit:movement():current_state_name()
		if state == "driving" or self._unit:movement():zipline_unit() then
			attack_data.damage = attack_data.damage * 0.5
		end
	end
	self._next_allowed_dmg_t = self._old_next_allowed_dmg_t and Application:digest_value(self._old_next_allowed_dmg_t, true) or self._next_allowed_dmg_t
	self._old_last_received_dmg = nil
	self._old_next_allowed_dmg_t = nil
	
	local health_subtracted = 0
	local death_prevented = nil
	health_subtracted = self:get_real_health()
	
	if self._jackpot_token and self:get_real_health() - attack_data.damage <= 0 then
		death_prevented = true
	else
		self:change_health(-attack_data.damage)
	end

	health_subtracted = health_subtracted - self:get_real_health()
	local trigger_skills = table.contains({
		"bullet",
		"explosion",
		"melee",
		"delayed_tick"
	}, attack_data.variant)

	if self:get_real_health() == 0 and trigger_skills then
		self:_chk_cheat_death()
	end

	self:_damage_screen()
	self:_check_bleed_out(trigger_skills)
	managers.hud:set_player_health({
		current = self:get_real_health(),
		total = self:_max_health(),
		revives = Application:digest_value(self._revives, false)
	})
	self:_send_set_health()
	self:_set_health_effect()
	managers.statistics:health_subtracted(health_subtracted)
	
	if self._jackpot_token and death_prevented then
		self._jackpot_token = nil
		self._unit:sound():play("pickup_fak_skill")
		--log("Jackpot just saved you!")
		return 0
	else
		return health_subtracted
	end
end

function PlayerDamage:is_friendly_fire(unit)
	if not unit or not unit:movement() or unit:base().is_grenade then
		return false
	end

	if unit:movement() and unit:movement():team() and unit:movement():team() ~= self._unit:movement():team() and unit:movement():friendly_fire() then
		return false
	end

	local friendly_fire = not unit:movement():team().foes[self._unit:movement():team().id]
	friendly_fire = managers.mutators:modify_value("PlayerDamage:FriendlyFire", friendly_fire)

	return friendly_fire
end

function PlayerDamage:build_suppression(amount)
	--if self:_chk_suppression_too_soon(amount) then
		--return
	--end

	local data = self._supperssion_data
	amount = amount * managers.player:upgrade_value("player", "suppressed_multiplier", 1)
	local armor_damage = self:_max_armor() > 0 and self:get_real_armor() < self:_max_armor()
	
	if amount >= 99 then
		self._akuma_effect = true
		self._akuma_dampen = 50
		SoundDevice:set_rtpc("downed_state_progression", self._akuma_dampen)
	end
		
	local morale_boost_bonus = self._unit:movement():morale_boost()

	if morale_boost_bonus then
		amount = amount * morale_boost_bonus.suppression_resistance
	end

	amount = amount * tweak_data.player.suppression.receive_mul
	data.value = math.min(tweak_data.player.suppression.max_value, (data.value or 0) + amount * tweak_data.player.suppression.receive_mul)
	
	if managers.player:has_category_upgrade("player", "strong_spirit") and self:health_ratio() <= 0.5 then
		amount = amount * 0.5
	end
	
	self._last_received_sup = amount
	self._next_allowed_sup_t = managers.player:player_timer():time() + self._dmg_interval
	if not data.decay_start_t then
		if self._akuma_effect then
			data.decay_start_t = managers.player:player_timer():time() + 4
		else
			data.decay_start_t = managers.player:player_timer():time() + 1
		end
	else
		if self._akuma_effect then
			data.decay_start_t = managers.player:player_timer():time() + 4
		else
			local raw_decay_start_t = data.decay_start_t - managers.player:player_timer():time()
			if raw_decay_start_t <= 0.95 then
				data.decay_start_t = data.decay_start_t + 0.05
			end
		end
	end
end

function PlayerDamage:_upd_suppression(t, dt)
	local data = self._supperssion_data

	if data.value then
		if data.decay_start_t < t then
			data.value = data.value - data.value

			if data.value <= 0 then
				data.value = nil
				data.decay_start_t = nil

				managers.environment_controller:set_suppression_value(0, 0)
			end
		elseif data.value == tweak_data.player.suppression.max_value and self._regenerate_timer then
			self._listener_holder:call("suppression_max")
		end

		if data.value then
			managers.environment_controller:set_suppression_value(self:effective_suppression_ratio(), self:suppression_ratio())
		end
	end
end

function PlayerDamage:_begin_akuma_snddedampen()
	if self._akuma_dampen and self._akuma_dampen > 0 then
		self._akuma_dampen = 0
		SoundDevice:set_rtpc("downed_state_progression", self._akuma_dampen)		
	end
end

Hooks:PostHook(PlayerDamage, "_regenerate_armor", "hh_regenarmor", function(self, no_sound)
	self._akuma_effect = nil
	if self._akuma_dampen then
		--self._is_damping = true
		self:_begin_akuma_snddedampen()
	end
end)

function PlayerDamage:update(unit, t, dt)
	if _G.IS_VR and self._heartbeat_t and t < self._heartbeat_t then
		local intensity_mul = 1 - (t - self._heartbeat_start_t) / (self._heartbeat_t - self._heartbeat_start_t)
		local controller = self._unit:base():controller():get_controller("vr")

		for i = 0, 1, 1 do
			local intensity = get_heartbeat_value(t)
			intensity = intensity * (1 - math.clamp(self:health_ratio() / 0.3, 0, 1))
			intensity = intensity * intensity_mul

			controller:trigger_haptic_pulse(i, 0, intensity * 900)
		end
	end

	self:_check_update_max_health()
	self:_check_update_max_armor()
	self:_update_can_take_dmg_timer(dt)
	self:_update_regen_on_the_side(dt)
	
	if managers.player:has_category_upgrade("player", "melee_damage_health_ratio_multiplier") and self:health_ratio() <= 0.5 then
		if not self._unit:movement():next_reload_speed_multiplier() or self._unit:movement():next_reload_speed_multiplier() < 1.5 then
			self._unit:movement():set_next_reload_speed_multiplier(1.5)
		end
	end

	if not self._armor_stored_health_max_set then
		self._armor_stored_health_max_set = true

		self:update_armor_stored_health()
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "chico_injector") then
		self._chico_injector_active = true
		local total_time = managers.player:upgrade_value("temporary", "chico_injector")[2]
		local current_time = managers.player:get_activate_temporary_expire_time("temporary", "chico_injector") - t

		managers.hud:set_player_ability_radial({
			current = current_time,
			total = total_time
		})
	elseif self._chico_injector_active then
		managers.hud:set_player_ability_radial({
			current = 0,
			total = 1
		})

		self._chico_injector_active = nil
	end

	local is_berserker_active = managers.player:has_activate_temporary_upgrade("temporary", "berserker_damage_multiplier")

	if self._check_berserker_done then
		if is_berserker_active then
			if self._unit:movement():tased() then
				self._tased_during_berserker = true
			else
				self._tased_during_berserker = false
			end
		end

		if not is_berserker_active then
			if self._unit:movement():tased() then
				self._bleed_out_blocked_by_tased = true
			else
				self._bleed_out_blocked_by_tased = false
				self._check_berserker_done = nil

				managers.hud:set_teammate_condition(HUDManager.PLAYER_PANEL, "mugshot_normal", "")
				managers.hud:set_player_custom_radial({
					current = 0,
					total = self:_max_health(),
					revives = Application:digest_value(self._revives, false)
				})
				self:force_into_bleedout()

				if not self._bleed_out then
					self._disable_next_swansong = true
				end
			end
		else
			local expire_time = managers.player:get_activate_temporary_expire_time("temporary", "berserker_damage_multiplier")
			local total_time = managers.player:upgrade_value("temporary", "berserker_damage_multiplier")
			total_time = total_time and total_time[2] or 0
			local delta = 0
			local max_health = self:_max_health()

			if total_time ~= 0 then
				delta = math.clamp((expire_time - Application:time()) / total_time, 0, 1)
			end

			managers.hud:set_player_custom_radial({
				current = delta * max_health,
				total = max_health,
				revives = Application:digest_value(self._revives, false)
			})
			managers.network:session():send_to_peers("sync_swansong_timer", self._unit, delta * max_health, max_health, Application:digest_value(self._revives, false), managers.network:session():local_peer():id())
		end
	end

	if self._bleed_out_blocked_by_zipline and not self._unit:movement():zipline_unit() then
		self:force_into_bleedout(true)

		self._bleed_out_blocked_by_zipline = nil
	end

	if self._bleed_out_blocked_by_movement_state and not self._unit:movement():current_state():bleed_out_blocked() then
		self:force_into_bleedout()

		self._bleed_out_blocked_by_movement_state = nil
	end

	if self._bleed_out_blocked_by_tased and not self._tased_during_berserker and not self._unit:movement():tased() then
		self:force_into_bleedout()

		self._bleed_out_blocked_by_tased = nil
	end

	if self._current_state then
		self:_current_state(t, dt)
	end

	self:_update_armor_hud(t, dt)

	if self._tinnitus_data then
		self._tinnitus_data.intensity = (self._tinnitus_data.end_t - t) / self._tinnitus_data.duration

		if self._tinnitus_data.intensity <= 0 then
			self:_stop_tinnitus()
		else
			SoundDevice:set_rtpc("downed_state_progression", math.max(self._downed_progression or 0, self._tinnitus_data.intensity * 100))
		end
	end

	if self._concussion_data then
		self._concussion_data.intensity = (self._concussion_data.end_t - t) / self._concussion_data.duration

		if self._concussion_data.intensity <= 0 then
			self:_stop_concussion()
		else
			SoundDevice:set_rtpc("concussion_effect", self._concussion_data.intensity * 100)
		end
	end

	if not self._downed_timer and self._downed_progression then
		self._downed_progression = math.max(0, self._downed_progression - dt * 50)

		if not _G.IS_VR then
			managers.environment_controller:set_downed_value(self._downed_progression)
		end

		SoundDevice:set_rtpc("downed_state_progression", self._downed_progression)

		if self._downed_progression == 0 then
			self._unit:sound():play("critical_state_heart_stop")

			self._downed_progression = nil
		end
	end

	if self._auto_revive_timer then
		if not managers.platform:presence() == "Playing" or not self._bleed_out or self._dead or self:incapacitated() or self:arrested() or self._check_berserker_done then
			self._auto_revive_timer = nil
		else
			self._auto_revive_timer = self._auto_revive_timer - dt

			if self._auto_revive_timer <= 0 then
				self:revive(true)
				self._unit:sound_source():post_event("nine_lives_skill")

				self._auto_revive_timer = nil
			end
		end
	end

	if self._revive_miss then
		self._revive_miss = self._revive_miss - dt

		if self._revive_miss <= 0 then
			self._revive_miss = nil
		end
	end

	self:_upd_suppression(t, dt)

	if not self._dead and not self._bleed_out and not self._check_berserker_done then
		self:_upd_health_regen(t, dt)
	end

	if not self:is_downed() then
		self:_update_delayed_damage(t, dt)
	end
end

