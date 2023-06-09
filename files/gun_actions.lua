dofile('mods/elements_of_surprise/files/eos_material_info.lua')
dofile('mods/elements_of_surprise/files/translations.lua')
--dofile_once( "data/scripts/lib/utilities.lua" )

local function edit_spell(content, material, mimic, source, dest)
	content = string.gsub(content, 'material="'..material..'"', 'material="'..mimic..'"')
	content = string.gsub(content, 'emitted_material_name="'..material..'"', 'emitted_material_name="'..mimic..'"')
	content = string.gsub(content, 'to_material="'..material..'"', 'to_material="'..mimic..'"')
	content = string.gsub(content, 'on_death_emit_particle_type="'..material..'"', 'on_death_emit_particle_type="'..mimic..'"')
	content = string.gsub(content, 'value_string="'..source..'"', 'value_string="'..dest..'"')
	return content
end

local function edit_level_1(content, from, to)
	from = '"'..from..'",'
	to = from..'"'..to..'",'
	content = string.gsub(content, from, to)
	return content
end

eos_create_spells = _G['eos_create_spells'] or false
-- if action types aren't defined here, they aren't defined in the spells and we can't use them.
eos_types_undefined = not _G['ACTION_TYPE_MATERIAL']

if _G['eos_material_info'] then
	for i = 1,#actions do
		action = actions[i]
		local material
		local mimic
		local id
		local projectile
		local fun
		if eos_types_undefined or action.type == ACTION_TYPE_MATERIAL then
			if string.sub(action.id,1,4) == 'SEA_' then
				material = string.lower(string.sub(action.id, 5))
				mimic = eos_material_info.name_to_mimic[material]
				id = "EOS_SEA_"
				if mimic then
					projectile = string.gsub(action.related_projectiles[1], material, mimic)
					fun = function()
						add_projectile(projectile)
						c.fire_rate_wait = c.fire_rate_wait + 15
					end
				end
			end
			if string.sub(action.id,1,9) == 'MATERIAL_' then
				material = string.lower(string.sub(action.id, 10))
				mimic = eos_material_info.name_to_mimic[material]
				id = "EOS_MATERIAL_"
				if mimic then
					projectile = string.gsub(action.related_projectiles[1], material, mimic)
					fun 	= function()
						add_projectile(projectile)
						--c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_wet.xml,"
						c.fire_rate_wait = c.fire_rate_wait - 15
						current_reload_time = current_reload_time - 10
					end
				end
			end
			if string.sub(action.id,1,7) == 'CIRCLE_' then
				material = string.lower(string.sub(action.id, 8))
				mimic = eos_material_info.name_to_mimic[material]
				id = "EOS_CIRCLE_"
				if mimic then
					projectile = string.gsub(action.related_projectiles[1], material, mimic)
					fun = function()
						add_projectile(projectile)
						c.fire_rate_wait = c.fire_rate_wait + 20 
					end
				end
			end
			if string.sub(action.id,1,6) == 'TOUCH_' then
				material = string.lower(string.sub(action.id, 7))
				mimic = eos_material_info.name_to_mimic[material]
				id = "EOS_TOUCH_"
				if mimic then
					projectile = string.gsub(action.related_projectiles[1], material, mimic)
					fun = function()
						add_projectile(projectile)
					end
				end
			end
		end
		if eos_types_undefined or action.type == ACTION_TYPE_STATIC_PROJECTILE then
			if string.sub(action.id,1,6) == 'CLOUD_' then
				material = string.lower(string.sub(action.id, 7))
				mimic = eos_material_info.name_to_mimic[material]
				id = "EOS_CLOUD_"
				if mimic then
					projectile = string.gsub(action.related_projectiles[1], material, mimic)
					fun = function()
						add_projectile(projectile)
						c.fire_rate_wait = c.fire_rate_wait + 15
					end
				end
			elseif string.sub(action.id,-6) == '_BLAST' then
				material = string.lower(string.sub(action.id, 1, -7))
				mimic = eos_material_info.name_to_mimic[material]
				id = "EOS_BLAST_"
				if mimic then
					projectile = string.gsub(action.related_projectiles[1], material, mimic)
					fun = function()
						add_projectile(projectile)
						c.fire_rate_wait = c.fire_rate_wait + 3
						c.screenshake = c.screenshake + 0.5
					end
				end
			end
		end
		if eos_types_undefined or action.type == ACTION_TYPE_MODIFIER then
			if string.sub(action.id,-6) == '_TRAIL' then
				material = string.lower(string.sub(action.id, 1, -7))
				mimic = eos_material_info.name_to_mimic[material]
				id = "EOS_TRAIL_"
				if mimic then
					projectile = nil
					fun = function()
						c.trail_material = c.trail_material .. mimic .. ','
						c.trail_material_amount = c.trail_material_amount + 5
						draw_actions( 1, true )
					end
				end
			end
		end
		if mimic then
			local name = string.sub(action.name,2)
			local desc = string.sub(action.description,2)
			if string.find(eos_translations, name, 1, true) then
				name = '$eos_'.. name
			else
				name = action.name
			end
			if string.find(eos_translations, desc, 1, true) then
				desc = '$eos_'.. desc
			else
				desc = action.desc
			end
			local act = {
				id = id .. string.upper(mimic),
				name = name,
				description = desc,
				sprite = action.sprite,
				sprite_unidentified = action.sprite_unidentified,
				type = action.type,
				spawn_level = action.spawn_level,
				spawn_probability = action.spawn_probability,
				price = action.price,
				mana = action.mana,
				max_uses = action.max_uses,
				action = fun
			}
			if projectile then
				act.related_projectiles = {projectile}
				if eos_create_spells then
					local text = ModTextFileGetContent( action.related_projectiles[1] )
					if text then
						ModTextFileSetContent( projectile, edit_spell( text, material, mimic, action.related_projectiles[1], projectile ) )
					end
					if action.id == 'CLOUD_WATER' then
						local path = 'data/scripts/gun/procedural/level_1_wand.lua'
						local text = ModTextFileGetContent(path)
						if text then
							ModTextFileSetContent( path, edit_level_1(text, action.id, act.id))
						end
					end
				end
			end

			table.insert(actions, i+1, act)
		end
	end
else
	print('gun_actions.lua was evaluated without Elements of Surprise spells')
end
