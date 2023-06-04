function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	if GameHasFlagRun('MM_FIRST_RUN') then
		return
	end

	--[[
	dofile('mods/material_mimics/files/test.lua')
	mm_test_player_spawned(player_entity)
	--]]

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
		mm_create_materials(mapping)
	else
		dofile_once('mods/material_mimics/files/mimic_materials.lua')
		mm_create_materials(mm_mimic_materials)
	end
end

ModLuaFileAppend( "data/scripts/items/potion.lua", "mods/material_mimics/files/potion.lua" )
