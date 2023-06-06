dofile_once("data/scripts/lib/utilities.lua")
dofile('mods/elements_of_surprise/files/eos_material_info.lua')

eos_base_potion_a_materials = potion_a_materials
function potion_a_materials()
	local mat = eos_base_potion_a_materials()
	local potion_mimic_chance = ModSettingGet("elements_of_surprise.potion_mimic_chance") or 10
	if Random(1, 100) <= potion_mimic_chance then
		return eos_material_info.name_to_mimic[mat] or mat
	else
		return mat
	end
end
