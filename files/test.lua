function eos_test_player_spawned(player_entity)
	local x,y = EntityGetTransform(player_entity)
	--eos_container('actual_'..'gunpowder_unstable', x, y )
	--eos_container('actual_'..'water', x+1, y )
	--eos_container('actual_'..'liquid_fire', x+1, y )
	eos_container('actual_'..'magic_liquid_protection_all', x+2, y )
	eos_container('actual_'..'magic_liquid_protection_all', x+3, y )
	--eos_container('gold_radioactive', x+3, y )
	--eos_container('fake_liquid_fire', x+1, y )
	--eos_container('liquid_fire', x+3, y )
	--EntityLoad( "data/entities/items/pickup/potion.xml", x, y )
	--EntityLoad( "data/entities/items/pickup/potion.xml", x+1, y )
	--EntityLoad( "data/entities/items/pickup/potion.xml", x+2, y )
	--EntityLoad( "data/entities/items/pickup/potion_aggressive.xml", x, y )
	--EntityLoad( "data/entities/items/pickup/potion_aggressive.xml", x+1, y )
	--EntityLoad( "data/entities/items/pickup/potion_aggressive.xml", x+2, y )
end

function eos_list_materials()
	for i = 1,1000 do
		local name = CellFactory_GetName(i)
		if name ~= 'unknown' then
			local ui = CellFactory_GetUIName(i)
			print(i, name, ui)
		else
			break
		end
	end
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

function eos_container( material_name, x, y )
	local entity
	if material_name == nil or material_name == "" then
		return
	elseif eos_get_material_type( material_name) == "powder" then
		entity = eos_powder_empty( x, y )
		AddMaterialInventoryMaterial(entity, material_name, 1000)
		return entity
	else
		entity = eos_potion_empty( x, y )
		AddMaterialInventoryMaterial(entity, material_name, 1000)
		return entity
	end
end

function eos_powder_empty( x, y )
	local entity = EntityLoad("data/entities/items/pickup/powder_stash.xml", x, y)
	empty_container_of_materials( entity )
	return entity
end

function eos_potion_empty( x, y )
	local entity = EntityLoad( "data/entities/items/pickup/potion_empty.xml", x+1, y )
	return entity
end

function eos_get_material_type( material_name )
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

