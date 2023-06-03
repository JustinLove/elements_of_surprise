local function actual_table(mats)
	local length = #mats
	for i = 1,length do
		mats[i] = {
			material = 'actual_'..mats[i].material,
			costs = mats[i].cost,
		}
	end
end
local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )
SetRandomSeed( x + 5351, y + 743 )
if Random(1, 100) <= 10 then
	actual_table(materials_standard)
	actual_table(materials_magic)
	materials_magic[#materials_magic+1] = {
		material = 'actual_magic_liquid_hp_regeneration',
		cost = 200,
	}
	materials_magic[#materials_magic+1] = {
		material = 'actual_purifying_powder',
		cost = 200,
	}
	materials_magic[#materials_magic+1] = {
		material = 'actual_magic_liquid_teleportation',
		cost = 200,
	}
end