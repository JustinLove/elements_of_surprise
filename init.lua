eos_material_info = {}

function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	if GameHasFlagRun('EOS_FIRST_RUN') then
		return
	end

	--[[
	dofile('mods/elements_of_surprise/files/test.lua')
	eos_test_player_spawned(player_entity)
	--]]

	dofile('mods/elements_of_surprise/files/damage.lua')
	eos_change_materials_that_damage(player_entity, eos_material_info.name_to_effect)

	GameAddFlagRun('EOS_FIRST_RUN')
end

function OnMagicNumbersAndWorldSeedInitialized()
	dofile_once('mods/elements_of_surprise/files/materials.lua')
	if ModSettingGet('elements_of_surprise.randomized_materials') then
		local materials = eos_gather_materials()
		local mapping = {}
		SetRandomSeed( 331, 7283 )
		eos_randomize_materials(materials, materials, mapping)
		--dofile_once( "data/scripts/lib/utilities.lua" )
		--debug_print_table( mapping )
		eos_material_info = eos_create_materials(mapping)
	else
		dofile_once('mods/elements_of_surprise/files/mimic_materials.lua')
		eos_material_info = eos_create_materials(eos_mimic_materials)
	end

	dofile_once('mods/elements_of_surprise/files/codegen.lua')
	text = 'eos_material_info='..eos_table_to_string(eos_material_info)
	ModTextFileSetContent("mods/elements_of_surprise/files/eos_material_info.lua", text)

	if ModIsEnabled('EnableLogger') then
		dofile_once( "data/scripts/lib/utilities.lua" )
		debug_print_table( eos_material_info )
	end

	local natural_material_chance = ModSettingGet('elements_of_surprise.natural_material_chance')
	if natural ~= 'none' then
		dofile_once('mods/elements_of_surprise/files/biomes.lua')
		eos_edit_biomes(eos_material_info, natural_material_chance)
	end


	if ModIsEnabled('mo_creeps') then
		eos_extend_component_materials(eos_material_info, "mods/mo_creeps/files/entities/misc/remove_ground_mud.xml", "CellEaterComponent", "materials")
	end

	-- since we run potion to get material list, it's a bit safer to do that before adding stuff.
	ModLuaFileAppend( "data/scripts/items/potion.lua", "mods/elements_of_surprise/files/potion.lua" )
	ModLuaFileAppend( "data/scripts/items/potion_aggressive.lua", "mods/elements_of_surprise/files/potion.lua" )
	ModLuaFileAppend( "data/scripts/items/potion_starting.lua", "mods/elements_of_surprise/files/potion_starting.lua" )
end

ModLuaFileAppend( "data/scripts/biomes/temple_altar_top_shared.lua", "mods/elements_of_surprise/files/temple_altar_top_shared.lua" )

if ModSettingGet('elements_of_surprise.enable_perks') ~= false then
	ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/elements_of_surprise/files/perk_list.lua" )
end

if ModSettingGet('elements_of_surprise.enable_spells') ~= false then
	ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/elements_of_surprise/files/gun_actions.lua" )
end

dofile('mods/elements_of_surprise/files/translations.lua')
eos_append_translations()

ModLuaFileAppend( "data/scripts/biomes/coalmine.lua", "mods/elements_of_surprise/files/pixel_scenes.lua" )

-- special cases, most materials are added dynamically
ModMaterialsFileAdd( "mods/elements_of_surprise/files/materials.xml" )
