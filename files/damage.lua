-- code based on https://noita.wiki.gg/wiki/Modding:_Making_a_custom_material#Making_materials_deal_damage

local function stringsplit(inputstr, sep)
	sep = sep or "%s"
	local t = {}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

-- Returns a key-value table, where they keys are the material name and the values the damage.
function mm_get_materials_that_damage(entity_id)
	local out = {}
	local damage_model_component = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
	if damage_model_component then
		local materials_that_damage = ComponentGetValue2(damage_model_component, "materials_that_damage")
		materials_that_damage = stringsplit(materials_that_damage, ",")
		local materials_how_much_damage = ComponentGetValue2(damage_model_component, "materials_how_much_damage")
		materials_how_much_damage = stringsplit(materials_how_much_damage, ",")
		for i, v in ipairs(materials_that_damage) do
			out[v] = materials_how_much_damage[i]
		end
		return out
	end
end

function mm_change_materials_that_damage(entity_id, name_to_effect)
	-- At the time of writing (1st of September 2020) changes to DamageModelComponent:materials_that_damage
	-- do not take effect. One of the ways to work around that is to remove and re-add the component with
	-- the changes applied and the same old values for everything else
	local damage_model_component = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
	if damage_model_component then
		-- Retrieve and store all old values of the DamageModelComponent
		local old_values = {}
		local old_damage_multipliers = {}
		for k,v in pairs(ComponentGetMembers(damage_model_component)) do
			-- ComponentGetMembers does not return the value for ragdoll_fx_forced, ComponentGetValue2 is necessary
			if k == "ragdoll_fx_forced" then
				v = ComponentGetValue2(damage_model_component, k)
			end
			old_values[k] = v
		end
		for k,_ in pairs(ComponentObjectGetMembers(damage_model_component, "damage_multipliers")) do
			old_damage_multipliers[k] = ComponentObjectGetValue(damage_model_component, "damage_multipliers", k)
		end
		-- Build comma separated string
		old_values.materials_that_damage = ""
		old_values.materials_how_much_damage = ""
		local old_materials_that_damage = mm_get_materials_that_damage(entity_id)
		for material, damage in pairs(old_materials_that_damage) do
			if name_to_effect[material] then
				old_materials_that_damage[name_to_effect[material]] = damage
			end
		end
		dofile_once( "data/scripts/lib/utilities.lua" )
		debug_print_table( old_materials_that_damage )
		local materials_that_damage = {}
		local materials_how_much_damage = {}
		for material, damage in pairs(old_materials_that_damage) do
			materials_that_damage[#materials_that_damage+1] = material
			materials_how_much_damage[#materials_how_much_damage+1] = damage
		end
		old_values.materials_that_damage = table.concat(materials_that_damage, ',')
		old_values.materials_how_much_damage = table.concat(materials_how_much_damage, ',')
		EntityRemoveComponent(entity_id, damage_model_component)
		damage_model_component = EntityAddComponent(entity_id, "DamageModelComponent", old_values)
		ComponentSetValue2(damage_model_component, "ragdoll_fx_forced", old_values.ragdoll_fx_forced)
		for k, v in pairs(old_damage_multipliers) do
			ComponentObjectSetValue(damage_model_component, "damage_multipliers", k, v)
		end
	end
end
