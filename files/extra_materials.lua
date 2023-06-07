eos_extra_materials = {
	'magic_liquid_hp_regeneration',
	'purifying_powder',
	'magic_liquid_teleportation',
}

function eos_add_extra_material(name)
	eos_extra_materials[#eos_extra_materials+1] = name
end
