dofile('mods/material_mimics/files/mm_material_info.lua')

local function actual(mat)
	return mm_material_info.name_to_mimic[string.lower(mat)] or mat
end

mm_base_spawn_altar_top = spawn_altar_top
function spawn_altar_top(x, y, is_solid)
	local natural_material_chance = ModSettingGet('material_mimics.natural_material_chance')
	local chance = 10
	if natural_material_chance == 'none' then
		return mm_base_spawn_altar_top(x, y, is_solid)
	elseif natural_material_chance == 'always' then
		return mm_spawn_mimic_altar_top(x, y, is_solid)
	elseif natural_material_chance == 'even' then
		chance = 50
	elseif natural_material_chance == 'sometimes' then
		chance = 25
	else
		chance = 10
	end
	SetRandomSeed( x + 9391, y + 16607 )
	if Random(1, 100) <= chance then
		return mm_spawn_mimic_altar_top(x, y, is_solid)
	else
		return mm_base_spawn_altar_top(x, y, is_solid)
	end
end

function mm_spawn_mimic_altar_top(x, y, is_solid)
	SetRandomSeed( x, y )
	local randomtop = Random( 1, 50 )
	local file_visual = "data/biome_impl/temple/altar_top_visual.png"
	
	LoadBackgroundSprite( "data/biome_impl/temple/wall_background.png", x-1, y - 30, 35 )

	if( y > 12000 ) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_boss_arena.png", file_visual, x, y-40, "", true )
	else
		if (randomtop == 5) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_water.png", file_visual, x, y-40, "", true, false, { ["ff2f554c"] = actual("water") } )
		elseif (randomtop == 8) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_blood.png", file_visual, x, y-40, "", true, false, { ["ff830000"] = actual("blood") } )
		elseif (randomtop == 11) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_oil.png", file_visual, x, y-40, "", true, false, { ["ff3b2b3c"] = actual("oil") } )
		elseif (randomtop == 13) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_radioactive.png", file_visual, x, y-40, "", true, false, { ["ff00ff33"] = actual("radioactive_liquid") } )
		elseif (randomtop == 15) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_lava.png", file_visual, x, y-40, "", true, false, { ["ffff6000"] = actual("lava") } )
		else
			LoadPixelScene( "data/biome_impl/temple/altar_top.png", file_visual, x, y-40, "", true )
		end
	end	

	if is_solid then LoadPixelScene( "data/biome_impl/temple/solid.png", "", x, y-40+300, "", true ) end
end
