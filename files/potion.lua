local function actual_table(mats)
	local length = #mats
	for i = 1,length do
		local mimic = mm_material_info.name_to_mimic[string.lower(mats[i].material)]
		if mimic then
			mats[i] = {
				material = mimic,
				costs = mats[i].cost,
			}
		end
	end
end
local function extra_materials(mats, extras)
	local length = #extras
	for i = 1,length do
		local mat = extras[i]
		if mm_material_info.name_to_mimic[mat] then
			mats[#mats+1] = {
				material = mat,
				cost = 200,
			}
		end
	end
end

local entity_id = GetUpdatedEntityID()
if entity_id and entity_id ~= 0 then
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x + 5351, y + 743 )
	local potion_mimic_chance = ModSettingGet("material_mimics.potion_mimic_chance") or 10
	if Random(1, 100) <= potion_mimic_chance then
		dofile('mods/material_mimics/files/mm_material_info.lua')
		actual_table(materials_standard)
		actual_table(materials_magic)
		extra_materials(materials_magic, {
			'actual_magic_liquid_hp_regeneration',
			'purifying_powder',
			'actual_magic_liquid_teleportation',
		})
	end
end
