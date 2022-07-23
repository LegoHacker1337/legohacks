local function ConvertToString(Value)
	if typeof(Value) == "Instance" then
		return Value:GetFullName()
	elseif typeof(Value) == "string" then
		return '[=['..Value..']=]'
	elseif typeof(Value) == "CFrame" then
		return "CFrame.new("..tostring(Value)..")"
	elseif typeof(Value) == "Vector3"  then
		return "Vector3.new("..tostring(Value)..")"
	elseif typeof(Value) == "Vector2"  then
		return "Vector2.new("..tostring(Value)..")"
	else
		return tostring(Value)
	end
end

local old = {}
local RecurseTable;
local RecurseFunction;

RecurseFunction = function(Function,Index)
	local str = string.format("%s( Name: %s Line: %s Path: %s):\n%s{\n%sConstants: {", tostring(Function), tostring(debug.getinfo(Function).name), tostring(debug.info(Function, "l")), getfenv(Function).script:GetFullName(), string.rep("    ", Index-1), string.rep("    ", Index))
	for i, v in pairs(debug.getconstants(Function))	 do
		if typeof(v) == "table" then
			if not table.find(old, v) then
				table.insert(old, v)
				task.wait()
				str = string.format("%s\n%s%s", str, string.rep("    ", Index + 1), RecurseTable(v, Index + 2))
			end
		elseif typeof(v) == "function" then
			if not table.find(old, v) then
				table.insert(old, v)
				task.wait()
				str = string.format("%s\n%s%s", str, string.rep("    ", Index + 1), RecurseFunction(v, Index + 2))
			end
		else
			str = string.format("%s\n%s[%s] = %s", str, string.rep("    ", Index + 1), ConvertToString(i), ConvertToString(v))
		end

	end
	str = string.format("%s\n%s}\n%sUpvalues: {", str, string.rep("    ", Index), string.rep("    ", Index))
	for i,v in pairs(debug.getupvalues(Function)) do
		if typeof(v) == "table" then
			if not table.find(old, v) then
				table.insert(old, v)
				task.wait()
				str = string.format("%s\n%s%s", str, string.rep("    ", Index), RecurseTable(v, Index + 2))
			end
		elseif typeof(v) == "function" then
			if not table.find(old, v) then
				table.insert(old, v)
				task.wait()
				str = string.format("%s\n%s%s", str, string.rep("    ", Index+1), RecurseFunction(v, Index + 2))
			end
		else
			str = string.format("%s\n%s[%s] = %s", str, string.rep("    ", Index + 1), ConvertToString(i), ConvertToString(v))
		end
	end
	str = string.format("%s\n%s}\n%sProtos: {", str, string.rep("    ", Index), string.rep("    ", Index))
	for i,v in pairs(debug.getprotos(Function)) do
		if typeof(v) == "function" then
			if not table.find(old, v) then
				table.insert(old, v)
				task.wait()
				str = string.format("%s\n%s%s", str, string.rep("    ", Index + 1), RecurseFunction(v, Index + 2))
			end
		else
			str = string.format("%s\n%s[%s] = %s", str, string.rep("    ", Index + 1), ConvertToString(i), ConvertToString(v))
		end
	end
	str = string.format("%s\n%s}\n%s}", str, string.rep("    ", Index), string.rep("    ", Index-1) )
	return str
end

RecurseTable = function(Table, Index)
	local str = string.format("    %s:\n%s{", tostring(Table), string.rep("    ", Index-1))
	for i,v in pairs(Table) do
		if typeof(v) == "table" then
			if not table.find(old, v) then
				table.insert(old, v)
				str = string.format("%s\n%s%s", str, string.rep("    ", Index), RecurseTable(v, Index + 1))
			end
		elseif typeof(v) == "function" then
			if not table.find(old, v) then
				table.insert(old, v)
				str = string.format("%s\n%s%s", str, string.rep("    ", Index), RecurseFunction(v, Index + 1))
			end
		else
			str = string.format("%s\n%s[%s] = %s", str, string.rep("    ", Index + 1), ConvertToString(i), ConvertToString(v))
		end
	end
	str = str.."\n"..string.rep("    ", Index-1).."}"
	return str
end

local ToSave = ""
for i,v in pairs(getgc()) do
	if typeof(v) == "function" then
		if getfenv(v).script ~= script then
			pcall(function()
				ToSave = ToSave..(RecurseFunction(v,1 ).."\n")
			end)
		end
	elseif typeof(v) == "table" then
		if v ~= old then
			pcall(function()
				ToSave = ToSave..(RecurseTable(v,1 ).."\n")
			end)
		end
	end	

end

rconsoleprint("SAVED!\n")
writefile("GCDump.txt", ToSave)
