function eos_table_to_string(t)
	local s = {'{'}
	local probably_array = t[1]
	for k,v in pairs(t) do
		if not probably_array then
			s[#s+1] = '["'
			s[#s+1] = tostring(k)
			s[#s+1] = '"]='
		end
		if type(v) == 'table' then
			s[#s+1] = eos_table_to_string(v)
		elseif type(v) == 'string' then
			s[#s+1] = '"'
			s[#s+1] = v
			s[#s+1] = '"'
		end
		s[#s+1] = ','
	end
	s[#s+1] = '}'
	return table.concat(s)
end

function eos_table_to_string_pretty(t)
	local s = {'{\n'}
	local probably_array = t[1]
	for k,v in pairs(t) do
		if not probably_array then
			s[#s+1] = '["'
			s[#s+1] = tostring(k)
			s[#s+1] = '"]='
		end
		if type(v) == 'table' then
			s[#s+1] = eos_table_to_string(v)
		elseif type(v) == 'string' then
			s[#s+1] = '"'
			s[#s+1] = v
			s[#s+1] = '"'
		end
		s[#s+1] = ',\n'
	end
	s[#s+1] = '}\n'
	return table.concat(s)
end
