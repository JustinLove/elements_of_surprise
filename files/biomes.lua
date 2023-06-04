local nxml = dofile_once("mods/material_mimics/files/lib/nxml.lua")

local function build_colors(info)
	local colors = {}
	for normal,mimic in pairs(info.wang_colors) do
		local opaque = 'ff' .. string.sub(normal, -6)
		local default = normal
		if string.sub(default, 1, 2) == 'ff' then
			default = 'fe' .. string.sub(normal, -6)
		end
		colors[#colors+1] = nxml.new_element('RandomColor', {
			input_color=opaque,
			output_colors=default..","..mimic
		})
		--print(tostring(colors[#colors]))
	end
	return colors
end

local function mm_edit_biome(biome, colors)
	local content = ModTextFileGetContent(biome)
	local xml = nxml.parse(content)
	local el_topo = xml:first_of('Topology')
	local el_random
	if el_topo then
		el_random = el_topo:first_of('RandomMaterials')
	end
	--print(tostring(el_random))
	if el_random then
		el_random:add_children(colors)
		--print(tostring(el_random))
	elseif el_topo then
		el_random = nxml.new_element('RandomMaterials', {})
		el_topo:add_child(el_random)
		el_random:add_children(colors)
	end
	--print(biome)
	--print(tostring(xml))
	ModTextFileSetContent(biome, tostring(xml))
end

function mm_edit_biomes(info)
	local colors = build_colors(info)
	mm_edit_biome("data/biome/coalmine.xml", colors)
	mm_edit_biome("data/biome/coalmine_alt.xml", colors)
	mm_edit_biome("data/biome/liquidcave.xml", colors)
	mm_edit_biome("data/biome/excavationsite.xml", colors)
	mm_edit_biome("data/biome/snowcave.xml", colors)
	mm_edit_biome("data/biome/winter.xml", colors)
	mm_edit_biome("data/biome/winter_caves.xml", colors)
	mm_edit_biome("data/biome/snowcastle.xml", colors)
	mm_edit_biome("data/biome/rainforest.xml", colors)
	mm_edit_biome("data/biome/fungicave.xml", colors)
	mm_edit_biome("data/biome/vault.xml", colors)
	mm_edit_biome("data/biome/crypt.xml", colors)
	mm_edit_biome("data/biome/pyramid.xml", colors)
	mm_edit_biome("data/biome/pyramid_entrance.xml", colors)
	mm_edit_biome("data/biome/pyramid_hallway.xml", colors)
	mm_edit_biome("data/biome/pyramid_left.xml", colors)
	mm_edit_biome("data/biome/pyramid_right.xml", colors)
	mm_edit_biome("data/biome/pyramid_top.xml", colors)
	mm_edit_biome("data/biome/wizardcave.xml", colors)
	mm_edit_biome("data/biome/wandcave.xml", colors)
	mm_edit_biome("data/biome/sandcave.xml", colors)
	mm_edit_biome("data/biome/the_end.xml", colors)
	mm_edit_biome("data/biome/fungiforest.xml", colors)
	mm_edit_biome("data/biome/vault_frozen.xml", colors)
end
