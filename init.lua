function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	if GameHasFlagRun('MM_FIRST_RUN') then
		return
	end

	local x,y = EntityGetTransform(player_entity)
	mm_container('actual_'..'alcohol', x, y )
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

mimic_materials = {
	magic_liquid_protection_all = {'magic_liquid_polymorph'},
	magic_liquid_teleportation = {'slime'},
	magic_liquid_movement_faster = {'slime'},
	magic_liquid_faster_levitation = {'magic_liquid_unstable_teleportation'},
	magic_liquid_hp_regeneration = {'poison'},
	magic_liquid_invisibility = {'magic_liquid_worm_attractor'},
	lava = {'magic_liquid_berserk'},
	water = {'liquid_fire'},
	blood = {'urine'},
	alcohol = {'magic_liquid_unstable_polymorph'},
}

local nxml = dofile_once("mods/material_mimics/files/lib/nxml.lua")
local function create_materials()
	print('---------------------------------------------')
	local content = ModTextFileGetContent("data/materials.xml")
	local xml = nxml.parse(content)
	local new_elements = {}
	local wang_color = 0xff3131c0

	for looks_like,list in pairs(mimic_materials) do
		local el_looks_like
		for element in xml:each_child() do
			if element.attr.name == looks_like then
				el_looks_like = element
			end
		end

		if not el_looks_like then
			print('could not find ', looks_like)
		end

		for i,acts_like in ipairs(list) do
			local el_acts_like
			for element in xml:each_child() do
				if element.attr.name == acts_like then
					el_acts_like = element
				end
			end

			if not_el_acts_like then
				print('could not find ', acts_like)
			end

			if el_acts_like and el_looks_like then
				--local wang_color = tonumber(el_looks_like.attr.wang_color, 16)
				local new_wang_color = string.format("%08x", wang_color)
				local el = nxml.new_element( 'CellDataChild', {
					_parent=acts_like,
					_inherit_reactions="1",
					name='actual_'..looks_like,
					ui_name=el_looks_like.attr.ui_name,
					wang_color=new_wang_color,
				})
				--print(tostring(el_looks_like))
				local graphics = el_looks_like:first_of('Graphics')
				if graphics then
					el:add_child(nxml.new_element('Graphics', {
						color = graphics.attr.color,
						texture_file = graphics.attr.texture_file or '',
						fire_colors_index = graphics.attr.fire_colors_index or '',
					}))
				else
					el:add_child(nxml.new_element('Graphics', {
						color = el_looks_like.attr.wang_color,
						texture_file = '',
					}))
				end
				local effect = el_acts_like:first_of('ParticleEffect')
				if effect then
					el:add_child(effect)
				end
				print(tostring(el))
				new_elements[#new_elements+1] = el
				wang_color = wang_color + 1
			end
		end
	end
	xml:add_children(new_elements)
	ModTextFileSetContent("data/materials.xml", tostring(xml))
end

create_materials()

-- This code runs when all mods' filesystems are registered
--ModLuaFileAppend( "data/scripts/items/potion.lua", "mods/example/files/potion_appends.lua" )
