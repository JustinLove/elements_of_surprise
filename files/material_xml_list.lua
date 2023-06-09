-- CAUTION: we assume the index of the first two entries
eos_material_xml_list = {
	"data/materials.xml",
	"mods/elements_of_surprise/files/materials.xml",
}

function eso_add_material_xml(path)
	eos_material_xml_list[#eos_material_xml_list+1] = path
end

if ModIsEnabled('Hydroxide') then
	eso_add_material_xml("mods/Hydroxide/files/materials.xml")
end
if ModIsEnabled('grahamsperks') then
	eso_add_material_xml("mods/grahamsperks/files/materials/materials.xml")
end
if ModIsEnabled('mo_creeps') then
	eso_add_material_xml("mods/mo_creeps/files/scripts/materials/custom_materials.xml")
end
