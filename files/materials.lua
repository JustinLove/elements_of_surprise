local nxml = dofile_once("mods/elements_of_surprise/files/lib/nxml.lua")

function eos_create_materials(materials)
	local info = {
		wang_colors = {},
		name_to_mimic = {},
		name_to_effect = {},
	}
	local files = {}
	local function add_xml(path)
		files[#files+1] = {
			path = path,
			xml = nxml.parse(ModTextFileGetContent(path)),
			new_elements = {},
		}
	end
	dofile("mods/elements_of_surprise/files/material_xml_list.lua")
	for _,path in ipairs(eos_material_xml_list) do
		add_xml(path)
	end
	local wang_color = 0xff3131c0

	local element_index = {}

	for i,file in ipairs(files) do
		for element in file.xml:each_child() do
			if (element.name == 'CellData' or element.name == 'CellDataChild') then
				element_index[string.lower(element.attr.name)] = element
				element.file_index = i
			end
		end
	end

	for _,list in pairs(materials) do
		local looks_like = string.lower(list[1])
		local el_looks_like = element_index[looks_like]

		if not el_looks_like then
			print('could not find ', looks_like)
		end

		local acts_like = string.lower(list[2])
		local el_acts_like = element_index[acts_like]

		if not_el_acts_like then
			print('could not find ', acts_like)
		end

		if el_acts_like and el_looks_like then
			local new_wang_color = string.format("%08x", wang_color)
			local el = nxml.new_element( 'CellDataChild', {
				_parent=el_acts_like.attr.name, -- using element in case CAPS_NAME
				_inherit_reactions="1",
				name='actual_'..looks_like,
				ui_name=el_looks_like.attr.ui_name,
				--ui_name='Actual '..looks_like,
				wang_color=new_wang_color,
				gfx_glow=el_looks_like.attr.gfx_glow or "0",
				danger_radioactive=el_looks_like.attr.danger_radioactive or '0',
				danger_fire=el_looks_like.attr.danger_fire or '0',
				danger_water=el_looks_like.attr.danger_water or '0',
				danger_poison=el_looks_like.attr.danger_poison or '0',
			})
			if el_looks_like.attr.on_fire == "1" then
				el.attr.burnable="1"
				el.attr.generates_smoke="0"
				el.attr.generates_flames="0"
				el.attr.on_fire="1"
				el.attr.fire_hp="-1"
				el.attr.requires_oxygen="0"
				el.attr.temperature_of_fire="0"
			end
			if el_acts_like.attr.gfx_glow and el.attr.gfx_glow then
				local ll = tonumber(el.attr.gfx_glow)
				local al = tonumber(el_acts_like.attr.gfx_glow)
				local glow = ll + math.floor((al-ll)*0.1)
				el.attr.gfx_glow = tostring(glow)
			end
			local start,nd = string.find(el_acts_like.attr.tags or '', '[evaporable_custom],',nil,true)
			if start then
				el.attr.tags = string.gsub(el_acts_like.attr.tags, '%[evaporable_custom%],', '')
			end
			start,nd = string.find(el_acts_like.attr.tags or '', '[meltable_metal],',nil,true)
			if start then
				el.attr.tags = string.gsub(el_acts_like.attr.tags, '%[meltable_metal%],', '')
			end
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
			info.wang_colors[el_looks_like.attr.wang_color] = el.attr.wang_color
			info.name_to_mimic[looks_like] = el.attr.name
			info.name_to_effect[acts_like] = el.attr.name
			local new_elements = files[el_acts_like.file_index].new_elements
			new_elements[#new_elements+1] = el
			wang_color = wang_color + 1
		end
	end

	-- materials in the same file get sorted, perhaps by type.
	-- this can cause later material ids to change
	-- moving vanilla materials into our append file prevents core mats like glass and gold from changing
	-- but mod materials may still have issues.
	-- Reason: it seems like entity files get cached, including the id of their material (e.g. gold_box2d is 440)
	-- if Noita soft restarts between games, these entities have the old id, but it may be a new or invalid material.
	if #(files[1].new_elements) > 0 then
		files[2].xml:add_children(files[1].new_elements)
		files[1].new_elements = {}
	end

	-- otherwise, define materials in their mod file.
	-- It seems like child materials need to be defined after
	-- their parents, and we can't run after a mod that
	-- does a material append before us (material append acts as a stack)

	for _,file in ipairs(files) do
		if #(file.new_elements) > 0 then
			file.xml:add_children(file.new_elements)
			--print(file.path)
			ModTextFileSetContent(file.path, tostring(file.xml))
		end
	end

	return info
end

function eos_potion_materials()
	dofile("data/scripts/items/potion.lua")
	local materials = {}

	local function table_names(mats)
		local length = #mats
		for i = 1,length do
			if mats[i].material == 'liquid_fire' then
				materials[#materials+1] = 'fake_liquid_fire'
			elseif not string.find(mats[i].material or '', 'gold', nil,true) then
				materials[#materials+1] = mats[i].material
			end
		end
	end

	table_names(materials_standard)
	table_names(materials_magic)

	return materials
end

function eos_gather_materials()
	local potion = eos_potion_materials()
	dofile('mods/elements_of_surprise/files/extra_materials.lua')
	for _,name in ipairs(eos_extra_materials) do
		potion[#potion+1] = name
	end
	return potion
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

function eos_randomize_materials(looks_names, acts_names, materials)
	local acts_like_names = copy_array(acts_names)
	shuffleTable(acts_like_names)
	for i,name in ipairs(looks_names) do
		if name ~= acts_like_names[i] then
			materials[#materials+1] = {name, acts_like_names[i]}
		end
	end

	return materials
end

function eos_extend_component_materials(info, path, component, attr)
	local content = ModTextFileGetContent(path)
	local xml = nxml.parse(content)
	for element in xml:each_child(componenet) do
		if element.attr[attr] then
			local changed = string.gsub(element.attr[attr], '[^,]+', function(s)
				if info.name_to_effect[s] then
					return s..','..info.name_to_effect[s]
				else
					return s
				end
			end)
			element.attr[attr] = changed
			break
		end
	end
	ModTextFileSetContent(path, tostring(xml))
end
