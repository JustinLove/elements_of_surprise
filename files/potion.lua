local function actual_table(mats)
	local length = #mats
	for i = 1,length do
		local mimic = eos_material_info.name_to_mimic[string.lower(mats[i].material)]
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
		if eos_material_info.name_to_mimic[mat] then
			mats[#mats+1] = {
				material = mat,
				cost = 200,
			}
		end
	end
end

eos_tables = {
	'materials_standard',
	'materials_magic',
	'potions',
}

local entity_id = GetUpdatedEntityID()
if entity_id and entity_id ~= 0 then
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x + 5351, y + 743 )
	local potion_mimic_chance = ModSettingGet("elements_of_surprise.potion_mimic_chance") or 10
	if Random(1, 100) <= potion_mimic_chance then
		dofile('mods/elements_of_surprise/files/eos_material_info.lua')
		for _,mats in ipairs(eos_tables) do
			if _G[mats] then
				actual_table(_G[mats])
			end
		end
		if _G['materials_magic'] then
			extra_materials(materials_magic, {
				'actual_magic_liquid_hp_regeneration',
				'purifying_powder',
				'actual_magic_liquid_teleportation',
			})
		end
	end
end
