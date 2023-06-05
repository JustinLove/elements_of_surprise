dofile_once("data/scripts/lib/utilities.lua")
dofile('mods/material_mimics/files/mm_material_info.lua')

mm_base_potion_a_materials = potion_a_materials
function potion_a_materials()
	local mat = mm_base_potion_a_materials()
	local potion_mimic_chance = ModSettingGet("material_mimics.potion_mimic_chance") or 10
	if Random(1, 100) <= potion_mimic_chance then
		return mm_material_info.name_to_mimic[mat] or mat
	else
		return mat
	end
end
