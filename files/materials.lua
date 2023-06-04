local nxml = dofile_once("mods/material_mimics/files/lib/nxml.lua")

function mm_create_materials(materials)
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

function mm_potion_materials()
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

function mm_randomize_materials(looks_names, acts_names, materials)
	local acts_like_names = copy_array(acts_names)
	shuffleTable(acts_like_names)
	for i,name in ipairs(looks_names) do
		materials[name] = {acts_like_names[i]}
	end

	return materials
end
