local translations = [[
eos_perk_bleed_slime,Actual Slime Blood,,,,,,,,,,,,,
eos_perkdesc_bleed_slime,"You bleed 100% certified organic slime, but slime no longer slows you down.",,,,,,,,,,,,,
eos_perk_bleed_oil,Actual Oil Blood,,,,,,,,,,,,,
eos_perkdesc_bleed_oil,"You bleed 100% certified authentic oil, but fire no longer burns you.",,,,,,,,,,,,,
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
	if (string.sub(translations, -2) ~= "\r\n") then
		translations = string.gsub(translations, "\n", "\r\n")
	end
	local text = content .. joint .. translations
	--print(string.sub(text, -(string.len(translations) + 80)))
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
