--After the long depression I finally can script again. I'm back.
--Put this script in your autoexec folder or I'll steal your fursuit

--By the way, script closures was added about 1 week ago, now you can get a specific script closure without using the getscriptclosure() function

local Closures = {}
local WeakTables = {}

local function Set()
	for i,v in pairs(debug.getregistry()) do
		if typeof(v) == "table" and v["__mode"] == "kvs" then
			for i,v2 in pairs(v) do
				if i ~= "__mode" then
					if typeof(v2) == "Instance" then
						WeakTables["Instances"] = v
					else
						WeakTables["Closures"] = v
					end
					break
				end
			end 
		end
	end
end

Set()

local function GetTableLen(Table)
	local Integer = 0
	for i,v in pairs(Table) do
		Integer = Integer + 1
	end
	return Integer
end

local function Test()
	local Numba1 = GetTableLen(WeakTables["Instances"])
	local TrashDebrisGarbageStupidIdiotUselessThing = Instance.new("Part") 
	local Numba2 = GetTableLen(WeakTables["Instances"])
	assert((Numba2-Numba1) == 1, "Something is wrong with you and your stupid skidded exploit!")

	return "Ba"..math.sqrt(-1).."a"
end


game.DescendantAdded:Connect(function(obj)
	if obj:IsA("LuaSourceContainer") then 
		for i,v in pairs(WeakTables["Closures"]) do
			if typeof(v) ~= "function" then continue end
			local scriptttt = rawget(getfenv(v), "script")
			if not Closures[scriptttt] then
				Closures[scriptttt] = v
			end
		end
	end
end)


--some tests because it may be pretty damn unstable
Test()


--This function does not show all closures, I warned you
getgenv().getscriptclosure2 = function(yiff) return Closures[yiff] end

--Returns each instance loaded in memory
getgenv().GetWeakElements = function() return WeakTables["Instances"] end
