
eos_bleed_actual_slime =
	{
		id = "EOS_BLEED_ACTUAL_SLIME",
		ui_name = "$eos_perk_bleed_slime",
		ui_description = "$eos_perkdesc_bleed_slime",
		ui_icon = "data/ui_gfx/perk_icons/slime_blood.png",
		perk_icon = "data/items_gfx/perks/slime_blood.png",
		game_effect = "NO_SLIME_SLOWDOWN",
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "actual_slime" )
					ComponentSetValue( damagemodel, "blood_spray_material", "actual_slime" )
					ComponentSetValue( damagemodel, "blood_multiplier", "3.0" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_purple_$[1-3].xml" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_purple_$[1-3].xml" )
					
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 0.75
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				end
			end
			
		end,
		func_remove = function( entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "blood" )
					ComponentSetValue( damagemodel, "blood_spray_material", "blood" )
					ComponentSetValue( damagemodel, "blood_multiplier", "1.0" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "" )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", "1.0" )
				end
			end
		end,
	}

eos_bleed_actual_oil =
	{
		id = "EOS_BLEED_ACTUAL_OIL",
		ui_name = "$eos_perk_bleed_oil",
		ui_description = "$eos_perkdesc_bleed_oil",
		ui_icon = "data/ui_gfx/perk_icons/oil_blood.png",
		perk_icon = "data/items_gfx/perks/oil_blood.png",
		game_effect = "PROTECTION_FIRE",
		stackable = STACKABLE_NO,
		remove_other_perks = {"PROTECTION_FIRE"},
		usable_by_enemies = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
		
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "actual_oil" )
					ComponentSetValue( damagemodel, "blood_spray_material", "actual-oil" )
					ComponentSetValue( damagemodel, "blood_multiplier", "3.0" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_oil_$[1-3].xml" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_oil_$[1-3].xml" )
				end
			end
		end,
		func_remove = function( entity_who_picked )
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue( damagemodel, "blood_material", "blood" )
					ComponentSetValue( damagemodel, "blood_spray_material", "blood" )
					ComponentSetValue( damagemodel, "blood_multiplier", "1.0" )
					ComponentSetValue( damagemodel, "blood_sprite_directional", "" )
					ComponentSetValue( damagemodel, "blood_sprite_large", "" )
				end
			end
		end,
	}

dofile('mods/elements_of_surprise/files/eos_material_info.lua')
if _G['eos_material_info'] then
	if eos_material_info.name_to_mimic['slime'] then
		perk_list[#perk_list+1] = eos_bleed_actual_slime
	end
	if eos_material_info.name_to_mimic['oil'] then
		perk_list[#perk_list+1] = eos_bleed_actual_oil
	end
else
	print('perk_list.lua was evaluated without Elements of Surprise perks')
end
