eos_translations = [[
eos_perk_bleed_slime,Actual Slime Blood,,,,,,,,,,,,,
eos_perkdesc_bleed_slime,"You bleed 100% certified organic slime, but slime no longer slows you down.",,,,,,,,,,,,,
eos_perk_bleed_oil,Actual Oil Blood,,,,,,,,,,,,,
eos_perkdesc_bleed_oil,"You bleed 100% certified authentic oil, but fire no longer burns you.",,,,,,,,,,,,,
eos_action_sea_water,Sea of Actual Water,,,,,,,,,,,,,
eos_actiondesc_sea_water,Summons a large body of Actual Water below the caster,,,,,,,,,,,,,
eos_action_sea_lava,Sea of Actual Lava,,,,,,,,,,,,,
eos_actiondesc_sea_lava,Summons a large body of Actual Lava below the caster,,,,,,,,,,,,,
eos_action_sea_alcohol,Sea of Actual Alcohol,,,,,,,,,,,,,
eos_actiondesc_sea_alcohol,Summons a large body of tasty Actual Alcohol below the caster,,,,,,,,,,,,,
eos_action_sea_oil,Sea of Actual Oil,,,,,,,,,,,,,
eos_actiondesc_sea_oil,Summons a large body of Actual Oil below the caster,,,,,,,,,,,,,
eos_action_sea_acid,Sea of Actual Acid,,,,,,,,,,,,,
eos_actiondesc_sea_acid,Summons a large body of Actual Acid below the caster,,,,,,,,,,,,,
eos_action_material_water,Actual Water,,,,,,,,,,,,,
eos_actiondesc_material_water,Transmute drops of Actual Water from nothing,,,,,,,,,,,,,
eos_action_material_oil,Actual Oil,,,,,,,,,,,,,
eos_actiondesc_material_oil,Transmute drops of Actual Oil from nothing,,,,,,,,,,,,,
eos_action_material_blood,Actual Blood,,,,,,,,,,,,,
eos_actiondesc_material_blood,Actual actual actual blood,,,,,,,,,,,,,
eos_action_material_acid,Actual Acid,,,,,,,,,,,,,
eos_actiondesc_material_acid,Transmute drops of Actual Acid from nothing,,,,,,,,,,,,,
eos_action_material_cement,Actual Cement,,,,,,,,,,,,,
eos_actiondesc_material_cement,Transmute drops of Actual Cement from nothing,,,,,,,,,,,,,
eos_action_cloud_water,Actual Rain cloud,,,,,,,,,,,,,
eos_actiondesc_cloud_water,Creates an Acutal Watery weather phenomenon,,,,,,,,,,,,,
eos_action_cloud_oil,Actual Oil cloud,,,,,,,,,,,,,
eos_actiondesc_cloud_oil,Creates rain of Actual Oil,,,,,,,,,,,,,
eos_action_cloud_blood,Actual Blood cloud,,,,,,,,,,,,,
eos_actiondesc_cloud_blood,Creates rain of Actual Blood,,,,,,,,,,,,,
eos_action_cloud_acid,Actual Acid cloud,,,,,,,,,,,,,
eos_actiondesc_cloud_acid,Creates rain of Actual Acid,,,,,,,,,,,,,
eos_action_acid_trail,Actual Acid trail,,,,,,,,,,,,,
eos_actiondesc_acid_trail,Gives a projectile a trail of Actual Acid,,,,,,,,,,,,,
eos_action_oil_trail,Actual Oil trail,,,,,,,,,,,,,
eos_actiondesc_oil_trail,Gives a projectile a trail of Actual Oil,,,,,,,,,,,,,
eos_action_poison_trail,Actual Poison trail,,,,,,,,,,,,,
eos_actiondesc_poison_trail,Gives a projectile a trail of Actual Poison,,,,,,,,,,,,,
eos_action_water_trail,Actual Water trail,,,,,,,,,,,,,
eos_actiondesc_water_trail,Gives a projectile a trail of Actual Water,,,,,,,,,,,,,
eos_action_circle_acid,Circle of Actual Acid,,,,,,,,,,,,,
eos_actiondesc_circle_acid,An expanding circle of Actual Acid,,,,,,,,,,,,,
eos_action_circle_oil,Circle of Actual Oil,,,,,,,,,,,,,
eos_actiondesc_circle_oil,An expanding circle of Actual Oil,,,,,,,,,,,,,
eos_action_circle_water,Circle of Actual Water,,,,,,,,,,,,,
eos_actiondesc_circle_water,An expanding circle of Actual Acid,,,,,,,,,,,,,
eos_action_touch_gold,Touch of Actual Gold,,,,,,,,,,,,,
eos_actiondesc_touch_gold,"Transmutes everything in a short radius into Actual Gold, including walls, creatures... and you",,,,,,,,,,,,,
eos_action_touch_water,Touch of Actual Water,,,,,,,,,,,,,
eos_actiondesc_touch_water,"Transmutes everything in a short radius into Actual Water, including walls, creatures... and you",,,,,,,,,,,,,
eos_action_touch_oil,Touch of Actual Oil,,,,,,,,,,,,,
eos_actiondesc_touch_oil,"Transmutes everything in a short radius into Actual Oil, including walls, creatures... and you",,,,,,,,,,,,,
eos_action_touch_alcohol,Touch of Actual Spirits,,,,,,,,,,,,,
eos_actiondesc_touch_alcohol,"Transmutes everything in a short radius into Actual Alcohol, including walls, creatures... and you",,,,,,,,,,,,,
eos_action_touch_blood,Touch of Actual Blood,,,,,,,,,,,,,
eos_actiondesc_touch_blood,"Transmutes everything in a short radius into Actual Blood, including walls, creatures... and you",,,,,,,,,,,,,
eos_action_touch_smoke,Touch of Actual Smoke,,,,,,,,,,,,,
eos_actiondesc_touch_smoke,"Transmutes everything in a short radius into Actual Smoke, including walls, creatures... and you",,,,,,,,,,,,,
eos_action_alcohol_blast,Explosion of Actual Spirits,,,,,,,,,,,,,
eos_actiondesc_alcohol_blast,"A very mysterious explosion",,,,,,,,,,,,,
eos_action_poison_blast,Explosion of Actual Poison,,,,,,,,,,,,,
eos_actiondesc_poison_blast,"An actual alchemical explosion",,,,,,,,,,,,,
]]

local function append_translations(content)
	-- previous blank lines, copied from Noitavania
	while content:find("\r\n\r\n") do
		content = content:gsub("\r\n\r\n","\r\n");
	end
	--print(string.sub(content, -80))
	--print(string.byte(content, -3, string.len(content)))
	-- make sure our first linen doesn't get appended to last line
	local joint = ""
	if (string.sub(content, -1) ~= "\n") then
		joint = "\r\n"
	end
	-- inline lua strings get \n only; compound seems to be more expected by othe other mods
	if (string.sub(eos_translations, -2) ~= "\r\n") then
		translations = string.gsub(eos_translations, "\n", "\r\n")
	end
	local text = content .. joint .. eos_translations
	--print(string.sub(text, -(string.len(eos_translations) + 80)))
	return text
end

local function edit_file(path, f, arg)
	local text = ModTextFileGetContent( path )
	if text then
		ModTextFileSetContent( path, f( text, arg ) )
	end
end

function eos_append_translations()
	edit_file( "data/translations/common.csv", append_translations)
end
