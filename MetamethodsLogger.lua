
local rconsoleprint = (rconsoleprint or print)  

local _GetFullName = game.GetFullName
local _IsDescendantOf = game.IsDescendantOf
local _GetService = game.GetService
local _FindFirstChild = game.FindFirstChild



_NewGetFullName = function(...)
	local args = {...}
	if args[1] then
		if args[1] ~= game and not _IsDescendantOf(args[1], game) then
			return "nil.".._GetFullName(...)    
		end     
		args[1] = _GetFullName(args[1])
		local split = args[1]:split(".")
		if tostring(split[1]):lower() ~= "game" then
			return "game."..args[1]
		end
	end
	return _GetFullName(...)
end


local old1; old1 = hookmetamethod(game, "__index", function(tb, index, ...)
	if not checkcaller() then
		rconsoleprint(_NewGetFullName(getcallingscript())..": ".._NewGetFullName(tb).."."..tostring(index).."\n")
	end
	return old1(tb, index, ...)
end)

local old2; old2 = hookmetamethod(game, "__newindex", function(tb, index, new, ...)
	if not checkcaller() then
		local new1 = new
		if typeof(new) == "Instance" then
			new1 = _NewGetFullName(new)
		elseif typeof(new) == "string" then
			new1 = '"'..new..'"'
		elseif typeof(new) == "function" then
			new1 = '"'..tostring(new)..'"'
		end

		rconsoleprint(_NewGetFullName(getcallingscript())..": ".._NewGetFullName(tb).."."..tostring(index).." = "..tostring(new1).."\n")
	end
	return old2(tb, index, new, ...)
end)

local old3; old3 = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
	--({...})[1] ~= getnamecallmethod() xD LMAO im braindead
	if not checkcaller() then
		local args = {...}
		local str = ""
		for i,v in pairs(args) do
			if typeof(v) == "Instance" then
				v = _NewGetFullName(v) 
			elseif typeof(v) == "string" then
				v = '"'..v..'"'
			elseif typeof(v) == "function" then
				v = '"'..tostring(v)..'"'
			end	
			str = str..tostring(v)..((i ~= #{...} and ", ") or (""))
		end
		rconsoleprint(_NewGetFullName(getcallingscript())..": ".._NewGetFullName(self)..":"..getnamecallmethod().."("..str..")\n")
	end
	return old3(self, ...)
end))
