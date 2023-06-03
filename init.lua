function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	if GameHasFlagRun('MM_FIRST_RUN') then
		return
	end

	local x,y = EntityGetTransform(player_entity)
	--mm_container('actual_'..'water', x, y )
	EntityLoad( "data/entities/items/pickup/potion.xml", x, y )
	EntityLoad( "data/entities/items/pickup/potion.xml", x+1, y )
	EntityLoad( "data/entities/items/pickup/potion.xml", x+2, y )
	GameAddFlagRun('MM_FIRST_RUN')
end

mimic_materials = {
	lava = {'magic_liquid_berserk'},
	water = {'liquid_fire'},
	blood = {'urine'},
	alcohol = {'magic_liquid_unstable_polymorph'},
	oil = {'slime'},
	slime = {'magic_liquid_mana_regeneration'},
	acid = {'cement'},
	radioactive_liquid = {'magic_liquid_protection_all'},
	gunpowder_unstable = {'magic_liquid_invisibility'},
	liquid_fire = {'water'},
	blood_cold = {'lava'},
	magic_liquid_unstable_teleportation = {'acid'},
	magic_liquid_polymorph = {'magic_liquid_movement_faster'},
	magic_liquid_random_polymorph = {'magic_liquid_hp_regeneration'},
	magic_liquid_berserk = {'material_confusion'},
	magic_liquid_charm = {'magic_liquid_berserk'},
	magic_liquid_invisibility = {'magic_liquid_worm_attractor'},
	material_confusion = {'magic_liquid_movement_faster'},
	magic_liquid_movement_faster = {'slime'},
	magic_liquid_faster_levitation = {'magic_liquid_unstable_teleportation'},
	magic_liquid_worm_attractor = {'magic_liquid_teleportation'},
	magic_liquid_protection_all = {'magic_liquid_polymorph'},
	magic_liquid_mana_regeneration = {'alcohol'},
	purifying_powder = {'sodium'},
	magic_liquid_teleportation = {'slime'},
	magic_liquid_hp_regeneration = {'poison'},
	magic_liquid_hp_regeneration_unstable = {'gunpowder_unstable'},
	blood_worm = {'blood_fungi'},
	gold = {'gold_radioactive'},
	snow = {'fungi'},
	cement = {'acid'},
	urine = {'magic_liquid_protection_all'},
}

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

local nxml = dofile_once("mods/material_mimics/files/lib/nxml.lua")

local function create_materials(materials)
	local content = ModTextFileGetContent("data/materials.xml")
	local xml = nxml.parse(content)
	local new_elements = {}
	local wang_color = 0xff3131c0

	for looks_like,list in pairs(materials) do
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
				local new_wang_color = string.format("%08x", wang_color)
				local el = nxml.new_element( 'CellDataChild', {
					_parent=acts_like,
					_inherit_reactions="1",
					name='actual_'..looks_like,
					ui_name=el_looks_like.attr.ui_name,
					--ui_name='Actual '..looks_like,
					wang_color=new_wang_color,
				})
				--print(tostring(el_looks_like))
				local graphics = el_looks_like:first_of('Graphics')
				if graphics then
					el:add_child(nxml.new_element('Graphics', {
						color = graphics.attr.color,
						texture_file = graphics.attr.texture_file or '',
						fire_colors_index = graphics.attr.fire_colors_index,
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
				local explosion = el_acts_like:first_of('ExplosionConfig')
				if explosion then
					el:add_child(explosion)
				end
				--print(tostring(el))
				new_elements[#new_elements+1] = el
				wang_color = wang_color + 1
			end
		end
	end
	xml:add_children(new_elements)
	ModTextFileSetContent("data/materials.xml", tostring(xml))
end

local function potion_materials()
	dofile("data/scripts/items/potion.lua")
	local materials = {}

	local function table_names(mats)
		local length = #mats
		for i = 1,length do
			materials[#materials+1] = mats[i].material
		end
	end

	table_names(materials_standard)
	table_names(materials_magic)

	materials[#materials+1] = 'magic_liquid_hp_regeneration'
	materials[#materials+1] = 'purifying_powder'
	materials[#materials+1] = 'magic_liquid_teleportation'

	return materials
end


function shuffleTable( t )
	assert( t, "shuffleTable() expected a table, got nil" )
	local iterations = #t
	local j
	
	for i = iterations, 2, -1 do
		j = Random(1,i)
		t[i], t[j] = t[j], t[i]
	end
end

local function copy_array( from )
	local new = {}
	for i = 1,#from do
		new[i] = from[i]
	end
	return new
end

local function randomize_materials(looks_names, acts_names, materials)
	local acts_like_names = copy_array(acts_names)
	shuffleTable(acts_like_names)
	for i,name in ipairs(looks_names) do
		materials[name] = {acts_like_names[i]}
	end

	return materials
end

function OnMagicNumbersAndWorldSeedInitialized()
	if ModSettingGet('material_mimics.randomized_materials') then
		local potion = potion_materials()
		local mapping = {}
		SetRandomSeed( 331, 7283 )
		randomize_materials(potion, potion, mapping)
		--dofile_once( "data/scripts/lib/utilities.lua" )
		--debug_print_table( mapping )
		create_materials(mapping)
	else
		create_materials(mimic_materials)
	end
end

-- This code runs when all mods' filesystems are registered
ModLuaFileAppend( "data/scripts/items/potion.lua", "mods/material_mimics/files/potion.lua" )
