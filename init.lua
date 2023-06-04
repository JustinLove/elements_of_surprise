mm_material_info = {}

function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	if GameHasFlagRun('MM_FIRST_RUN') then
		return
	end

	--[[
	dofile('mods/material_mimics/files/test.lua')
	mm_test_player_spawned(player_entity)
	--]]

	dofile('mods/material_mimics/files/damage.lua')
	mm_change_materials_that_damage(player_entity, mm_material_info.name_to_effect)

	GameAddFlagRun('MM_FIRST_RUN')
end

function OnMagicNumbersAndWorldSeedInitialized()
	dofile_once('mods/material_mimics/files/materials.lua')
	if ModSettingGet('material_mimics.randomized_materials') then
		local potion = mm_potion_materials()
		local mapping = {}
		SetRandomSeed( 331, 7283 )
		mm_randomize_materials(potion, potion, mapping)
		--dofile_once( "data/scripts/lib/utilities.lua" )
		--debug_print_table( mapping )
		mm_material_info = mm_create_materials(mapping)
	else
		dofile_once('mods/material_mimics/files/mimic_materials.lua')
		mm_material_info = mm_create_materials(mm_mimic_materials)
	end

	dofile_once('mods/material_mimics/files/codegen.lua')
	text = 'mm_material_info='..mm_table_to_string(mm_material_info)
	ModTextFileSetContent("mods/material_mimics/files/mm_material_info.lua", text)
	--dofile_once( "data/scripts/lib/utilities.lua" )
	--debug_print_table( mm_material_info )

	local natural_material_chance = ModSettingGet('material_mimics.natural_material_chance')
	if natural ~= 'none' then
		dofile_once('mods/material_mimics/files/biomes.lua')
		mm_edit_biomes(mm_material_info, natural_material_chance)
	end
end

ModLuaFileAppend( "data/scripts/items/potion.lua", "mods/material_mimics/files/potion.lua" )
