print('init -----------------------------------------')
function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	print('Spawned --------------------------------')
	if GameHasFlagRun('MM_FIRST_RUN') then
		return
	end

	print('Running Spawned')
	local x,y = EntityGetTransform(player_entity)
	mm_container('actual_magic_liquid_protection_all', x, y )
	mm_container('magic_liquid_protection_all', x, y )
	mm_container('magic_liquid_polymorph', x, y )
	GameAddFlagRun('MM_FIRST_RUN')
end

-- from cheatgui
local function empty_container_of_materials(idx)
	for _ = 1, 1000 do -- avoid infinite loop
		local material = GetMaterialInventoryMainMaterial(idx)
		if material <= 0 then break end
		local matname = CellFactory_GetName(material)
		AddMaterialInventoryMaterial(idx, matname, 0)
	end
end

function mm_container( material_name, x, y )
	print(material_name, x, y, '--------------------------')
	local entity
	if material_name == nil or material_name == "" then
		return
	elseif mm_get_material_type( material_name) == "powder" then
		entity = mm_powder_empty( x, y )
		AddMaterialInventoryMaterial(entity, material_name, 1000)
		return entity
	else
		entity = mm_potion_empty( x, y )
		AddMaterialInventoryMaterial(entity, material_name, 1000)
		return entity
	end
end

function mm_powder_empty( x, y )
	local entity = EntityLoad("data/entities/items/pickup/powder_stash.xml", x, y)
	empty_container_of_materials( entity )
	return entity
end

function mm_potion_empty( x, y )
	local entity = EntityLoad( "data/entities/items/pickup/potion_empty.xml", x+1, y )
	return entity
end

function mm_get_material_type( material_name )
	local material_id = CellFactory_GetType( material_name )
	local tags = CellFactory_GetTags( material_id )

	for i,v in ipairs( tags ) do
		if v == "[sand_ground]" then
			return "powder"
		elseif v == "[sand_metal]" then
			return "powder"
		elseif v == "[sand_other]" then
			return "powder"
		elseif v == "[liquid]" then
			return "liquid"
		end
	end

	local sands = CellFactory_GetAllSands()
	for i,v in ipairs( sands ) do
		if v == material_name then
			return "powder"
		end
	end

	return "liquid" -- punt, use a flask
end

-- This code runs when all mods' filesystems are registered
ModMaterialsFileAdd( "mods/material_mimics/files/materials.xml" )
--ModLuaFileAppend( "data/scripts/items/potion.lua", "mods/example/files/potion_appends.lua" )
