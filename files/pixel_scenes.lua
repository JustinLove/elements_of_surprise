dofile('mods/material_mimics/files/mm_material_info.lua')
--dofile_once( "data/scripts/lib/utilities.lua" )
local function mm_mimicify(spawns)
	local natural_material_chance = ModSettingGet('material_mimics.natural_material_chance')
	local chance = 10
	if natural_material_chance == 'none' then
		chance = 0
	elseif natural_material_chance == 'always' then
		chance = 100
	elseif natural_material_chance == 'even' then
		chance = 50
	else
		chance = 10
	end
	for _,scene in ipairs(spawns) do
		if scene.color_material and Random(1,100) <= chance then
			for _,list in pairs(scene.color_material) do
				for i,mat in ipairs(list) do
					mat = string.lower(mat)
					if mm_material_info.name_to_mimic[mat] then
						list[i] = mm_material_info.name_to_mimic[mat]
					end
				end
			end
		end
	end
end

mm_scenes = {
	'g_oiltank',
	'g_oiltank_alt',
	'g_pixel_scene_02',
}

SetRandomSeed( 36493, 27823 )
for _,spawns in ipairs(mm_scenes) do
	if _G[spawns] then
		mm_mimicify(_G[spawns])
	end
end