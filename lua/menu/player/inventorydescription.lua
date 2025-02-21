local function is_weapon_category(weapon_tweak, ...)
	local arg = {
		...
	}
	local categories = weapon_tweak.categories

	for i = 1, #arg do
		if table.contains(categories, arg[i]) then
			return true
		end
	end

	return false
end

function WeaponDescription._get_skill_stats(name, category, slot, base_stats, mods_stats, silencer, single_mod, auto_mod, blueprint)
	local skill_stats = {}
	local tweak_stats = tweak_data.weapon.stats

	for _, stat in pairs(WeaponDescription._stats_shown) do
		skill_stats[stat.name] = {
			value = 0
		}
	end

	local detection_risk = 0

	if category then
		local custom_data = {
			[category] = managers.blackmarket:get_crafted_category_slot(category, slot)
		}
		detection_risk = managers.blackmarket:get_suspicion_offset_from_custom_data(custom_data, tweak_data.player.SUSPICION_OFFSET_LERP or 0.75)
		detection_risk = detection_risk * 100
	end

	local base_value, base_index, modifier, multiplier = nil
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
	local weapon_tweak = tweak_data.weapon[name]
	local primary_category = weapon_tweak.categories[1]

	for _, stat in ipairs(WeaponDescription._stats_shown) do
		if weapon_tweak.stats[stat.stat_name or stat.name] or stat.name == "totalammo" or stat.name == "fire_rate" then
			if stat.name == "magazine" then
				skill_stats[stat.name].value = managers.player:upgrade_value(name, "clip_ammo_increase", 0)
				local has_magazine = weapon_tweak.has_magazine
				local add_modifier = false

				if is_weapon_category(weapon_tweak, "shotgun") then
					if has_magazine then
						skill_stats[stat.name].value = skill_stats[stat.name].value + managers.player:upgrade_value("shotgun", "magazine_capacity_inc", 0)
						add_modifier = managers.player:has_category_upgrade("shotgun", "magazine_capacity_inc")

						if primary_category == "akimbo" then
							skill_stats[stat.name].value = skill_stats[stat.name].value * 2
						end
					end
					
					local mag_mul = managers.player:upgrade_value("player", "cool_hunting_basic", 1)
					
					if mag_mul > 1 then
						local to_add = weapon_tweak.CLIP_AMMO_MAX * mag_mul
						to_add = to_add - weapon_tweak.CLIP_AMMO_MAX
						
						to_add = math.ceil(to_add)
						
						if to_add >= 1 then
							add_modifier = true
						
							skill_stats[stat.name].value = skill_stats[stat.name].value + to_add
						end
					end
				elseif is_weapon_category(weapon_tweak, "pistol") and managers.player:has_category_upgrade("pistol", "magazine_capacity_inc") then
					skill_stats[stat.name].value = skill_stats[stat.name].value + managers.player:upgrade_value("pistol", "magazine_capacity_inc", 0)

					if primary_category == "akimbo" then
						skill_stats[stat.name].value = skill_stats[stat.name].value * 2
					end

					add_modifier = true
				elseif is_weapon_category(weapon_tweak, "smg", "assault_rifle", "lmg") then
					local mag_mul = managers.player:upgrade_value("player", "lead_demi_basic", 1)
					
					if mag_mul > 1 then
						local to_add = weapon_tweak.CLIP_AMMO_MAX * mag_mul
						to_add = to_add - weapon_tweak.CLIP_AMMO_MAX
						
						to_add = math.ceil(to_add)
						
						if to_add >= 1 then
							add_modifier = true
						
							skill_stats[stat.name].value = skill_stats[stat.name].value + to_add
						end
					end
				end

				if not weapon_tweak.upgrade_blocks or not weapon_tweak.upgrade_blocks.weapon or not table.contains(weapon_tweak.upgrade_blocks.weapon, "clip_ammo_increase") then
					skill_stats[stat.name].value = skill_stats[stat.name].value + managers.player:upgrade_value("weapon", "clip_ammo_increase", 0)
				end

				if not weapon_tweak.upgrade_blocks or not weapon_tweak.upgrade_blocks[primary_category] or not table.contains(weapon_tweak.upgrade_blocks[primary_category], "clip_ammo_increase") then
					skill_stats[stat.name].value = skill_stats[stat.name].value + managers.player:upgrade_value(primary_category, "clip_ammo_increase", 0)
				end

				skill_stats[stat.name].skill_in_effect = managers.player:has_category_upgrade(name, "clip_ammo_increase") or managers.player:has_category_upgrade("weapon", "clip_ammo_increase") or add_modifier
			elseif stat.name == "totalammo" then
				-- Nothing
			elseif stat.name == "reload" then
				local skill_in_effect = false
				local mult = 1

				for _, category in ipairs(weapon_tweak.categories) do
					if managers.player:has_category_upgrade(category, "reload_speed_multiplier") then
						mult = mult + 1 - managers.player:upgrade_value(category, "reload_speed_multiplier", 1)
						skill_in_effect = true
					end
				end

				mult = 1 / managers.blackmarket:_convert_add_to_mul(mult)
				local diff = base_stats[stat.name].value * mult - base_stats[stat.name].value
				skill_stats[stat.name].value = skill_stats[stat.name].value + diff
				skill_stats[stat.name].skill_in_effect = skill_in_effect
			else
				base_value = math.max(base_stats[stat.name].value + mods_stats[stat.name].value, 0)

				if base_stats[stat.name].index and mods_stats[stat.name].index then
					base_index = base_stats[stat.name].index + mods_stats[stat.name].index
				end

				multiplier = 1
				modifier = 0
				local is_single_shot = managers.weapon_factory:has_perk("fire_mode_single", factory_id, blueprint)

				if stat.name == "damage" then
					multiplier = managers.blackmarket:damage_multiplier(name, weapon_tweak.categories, silencer, detection_risk, nil, blueprint)
					modifier = math.floor(managers.blackmarket:damage_addend(name, weapon_tweak.categories, silencer, detection_risk, nil, blueprint) * tweak_data.gui.stats_present_multiplier * multiplier)
				elseif stat.name == "spread" then
					local fire_mode = single_mod and "single" or auto_mod and "auto" or weapon_tweak.FIRE_MODE or "single"
					multiplier = managers.blackmarket:accuracy_multiplier(name, weapon_tweak.categories, silencer, nil, nil, fire_mode, blueprint, nil, is_single_shot)
					modifier = managers.blackmarket:accuracy_addend(name, weapon_tweak.categories, base_index, silencer, nil, fire_mode, blueprint, nil, is_single_shot) * tweak_data.gui.stats_present_multiplier
				elseif stat.name == "recoil" then
					multiplier = managers.blackmarket:recoil_multiplier(name, weapon_tweak.categories, silencer, blueprint)
					modifier = managers.blackmarket:recoil_addend(name, weapon_tweak.categories, base_index, silencer, blueprint, nil, is_single_shot) * tweak_data.gui.stats_present_multiplier
				elseif stat.name == "suppression" then
					multiplier = managers.blackmarket:threat_multiplier(name, weapon_tweak.categories, silencer)
				elseif stat.name == "concealment" then
					if silencer and managers.player:has_category_upgrade("player", "silencer_concealment_increase") then
						modifier = managers.player:upgrade_value("player", "silencer_concealment_increase", 0)
					end

					if silencer and managers.player:has_category_upgrade("player", "silencer_concealment_penalty_decrease") then
						local stats = managers.weapon_factory:get_perk_stats("silencer", factory_id, blueprint)

						if stats and stats.concealment then
							modifier = modifier + math.min(managers.player:upgrade_value("player", "silencer_concealment_penalty_decrease", 0), math.abs(stats.concealment))
						end
					end
				elseif stat.name == "fire_rate" then
					multiplier = managers.blackmarket:fire_rate_multiplier(name, weapon_tweak.categories, silencer, detection_risk, nil, blueprint)
				end

				if modifier ~= 0 then
					local offset = math.min(tweak_stats[stat.name][1], tweak_stats[stat.name][#tweak_stats[stat.name]]) * tweak_data.gui.stats_present_multiplier

					if stat.revert then
						modifier = -modifier
					end

					if stat.percent then
						local max_stat = stat.index and #tweak_stats[stat.name] or math.max(tweak_stats[stat.name][1], tweak_stats[stat.name][#tweak_stats[stat.name]]) * tweak_data.gui.stats_present_multiplier

						if stat.offset then
							max_stat = max_stat - offset
						end

						local ratio = modifier / max_stat
						modifier = ratio * 100
					end
				end

				if stat.revert then
					multiplier = 1 / math.max(multiplier, 0.01)
				end

				skill_stats[stat.name].skill_in_effect = multiplier ~= 1 or modifier ~= 0
				skill_stats[stat.name].value = modifier + base_value * multiplier - base_value
			end
		end
	end

	return skill_stats
end