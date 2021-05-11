local mvec_spread_direction = Vector3()

function BowWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	local unit = nil
	local spread_x, spread_y = self:_get_spread(user_unit)
	local right = direction:cross(Vector3(0, 0, 1)):normalized()
	local up = direction:cross(right):normalized()
	local theta = math.random() * 360
	local ax = math.sin(theta) * math.random() * spread_x * (spread_mul or 1)
	local ay = math.cos(theta) * math.random() * spread_y * (spread_mul or 1)

	mvector3.set(mvec_spread_direction, direction)
	mvector3.add(mvec_spread_direction, right * math.rad(ax))
	mvector3.add(mvec_spread_direction, up * math.rad(ay))

	local projectile_type = self._projectile_type or tweak_data.blackmarket:get_projectile_name_from_index(2)

	if self._ammo_data and self._ammo_data.launcher_grenade then
		if self:weapon_tweak_data().projectile_types then
			local equipped_type = self:weapon_tweak_data().projectile_types[self._ammo_data.launcher_grenade]
			projectile_type = equipped_type or self._ammo_data.launcher_grenade
		else
			projectile_type = self._ammo_data.launcher_grenade
		end
	end

	--self:_adjust_throw_z(mvec_spread_direction)
	local speed_mul = self:projectile_speed_multiplier()

	mvec_spread_direction = mvec_spread_direction * speed_mul
	
	local spawn_offset = self:_get_spawn_offset()
	self._dmg_mul = dmg_mul or 1

	if not self._client_authoritative then
		if Network:is_client() then
			local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_type)

			managers.network:session():send_to_host("request_throw_projectile", projectile_type_index, from_pos, mvec_spread_direction)
		else
			unit = ProjectileBase.throw_projectile(projectile_type, from_pos, mvec_spread_direction, managers.network:session():local_peer():id())
		end
	else
		unit = ArrowBase.throw_projectile(projectile_type, from_pos, mvec_spread_direction, managers.network:session():local_peer():id(), speed_mul > 0.8 and true)
	end

	managers.statistics:shot_fired({
		hit = false,
		weapon_unit = self._unit
	})

	return {}
end