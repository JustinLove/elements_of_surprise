function eos_table_to_string(t)
	local s = {'{'}
	for k,v in pairs(t) do
		s[#s+1] = '["'
		s[#s+1] = tostring(k)
		s[#s+1] = '"]='
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
