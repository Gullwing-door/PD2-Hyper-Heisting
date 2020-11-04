ModifierNoHurtAnims = ModifierNoHurtAnims or class(BaseModifier)
ModifierNoHurtAnims._type = "ModifierNoHurtAnims"
ModifierNoHurtAnims.name_id = "none"
ModifierNoHurtAnims.desc_id = "menu_cs_modifier_no_hurt"
ModifierNoHurtAnims.IgnoredHurtTypes = {
	"expl_hurt",
	"heavy_hurt",
	"hurt"
}

function ModifierNoHurtAnims:modify_value(id, value)
	if dont then
		if id == "CopMovement:HurtType" and table.contains(ModifierNoHurtAnims.IgnoredHurtTypes, value) and math.random() < 0.5 then
			return nil, true
		end

		return value
	end
end

