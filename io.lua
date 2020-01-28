local IO = _G.RaidHeal.IO
local Locale = _G.RaidHeal.Locale
local data = _G.RaidHeal.data

function IO.Print(locale, ...)
    local msg = IO.Format(locale, ...)
    if msg and msg ~= "" then IO.PrintRaw(msg) end
end

function IO.Format(locale, ...)
    if Locale.Messages[locale] then
            local msg = string.format(Locale.Messages[locale], ...)
        return msg
    else
        return ""
    end
end

function IO.LoadFile(path, silent)
    path = IO._basePath .. path

    local f, err = loadfile(path)

    if err then
        if silent then
            IO.Print("ERROR_IO_LOADFILE", path, err)
        else
            error("IO.LoadFile: Error: "..tostring(err), 2)
        end
        return nil, err
    else
        return f()
    end
end

IO.PrintRaw = SendSystemChat

function IO.DeepCopy(from, to)
    for key, value in pairs(from) do
        if type(value) == "table" then
            if not to[key] then
                to[key] = {}
            end
            IO.DeepCopy(from[key], to[key])
        else
            to[key] = value
        end
    end
end

function IO.StripCopy(copy, compareTo)
    local ret = {}
    for key, value in pairs(copy) do
        if type(value) == "function" then
            ret[key] = nil
        elseif type(key) == "string" and key:sub(1, 1) == "_" then
            ret[key] = nil
        elseif type(value) == "table" and type(compareTo[key]) == "table" then
            ret[key] = IO.StripCopy(copy[key], compareTo[key])
            if not ret[key] or ret[key] == {} then ret[key] = nil end
        elseif copy[key] == compareTo[key] then
            ret[key] = nil
        else
            ret[key] = copy[key]
        end

        if type(ret[key]) == "table" and next(ret[key]) == nil then ret[key] = nil end
    end

    return ret
end

IO.Errors = {}
IO.LastError = ""
function IO.PrintError(error)
    if not error then return end
    IO.Errors[error] = (IO.Errors[error] or 0) + 1

    if IO._printErrors and error ~= IO.LastError then
        IO.Print("ERROR_GENERAL", tostring(error))
        IO.LastError = error
    end
end

if not IO.PrintDebug then
    function IO.PrintDebug() end
end

IO.FormatTable = function(input, indent)
    local msg = ""
    if not indent then indent = "" end
    if type(input) == "nil" then return "nil" end
    if type(input) == "boolean" then return input and "true" or "false" end
    if type(input) == "string" then return "\"" .. input .. "\"" end
    if type(input) ~= "table" then return tostring(input) end

    local formatted = {}
    local innerIndent = indent .. "    "
    for key, value in pairs(input) do
        formatted[#formatted+1] = string.format("%s[%s] = %s", indent, IO.FormatTable(key, innerIndent), IO.FormatTable(value, innerIndent))
    end

    msg = string.format("{\n%s\n%s}", table.concat(formatted, ",\n"), indent)
    return msg
end

function TheKasztanQ()

	
end
	
IO.FormatFuncs = {
    Numbers = {
        Simple = function(health, maxHealth)
		if not health then return end
		
        local result = ""
        local numFormat = "%.1f"

        if type(health) ~= "number" or type(maxHealth) ~= "number" then return result end

        if health == 0 then return "DEAD" end
		if health == maxHealth then return "FULL" end
	
----------------------------------------------------------------------------------------------------------
		--Wyswietlanie procentowe:
			
			-- local percent = (health/maxHealth)*100
			-- local formatNum = "%.0f"
		
			-- result = result .. "%"
			-- formatNum = "%i"
		
			-- result = string.format(formatNum .. "%s", percent, result)
		
			-- return result
	-- end
----------------------------------------------------------------------------------------------------------
	--Wyswietlanie z utraconym HP:

        -- local diff = health - maxHealth
        -- if diff == 0 then return "" end
		
        -- if math.abs(diff) < 999 then		--warunek dla roznicy mniejszej niz 999
            -- return string.format("%d", diff)
        -- end

        -- while math.abs(diff) / 1000 > 1.0 do
            -- result = result .. "k"
            -- diff = diff / 1000
        -- end
        -- if math.abs(diff) > 990 then		--roznica (w setkach) powyzej 990 bo bedzie pepega przy uwzglednianiu 1kk zycia 
            -- diff = math.floor(diff / 100) / 10
            -- result = result .. "k"
        -- elseif math.abs(health) > 99 then
            -- diff = math.floor(diff)
            -- numFormat = "%d"
        -- else
            -- diff = math.floor(diff * 10) / 10
        -- end
        -- result = string.format(numFormat .. "%s", diff, result)

        -- return result
    -- end
---------------------------------------------------------------------------------------------------------
	--Wyswietlanie z obecnym HP:
	local hp = health
	if hp == 0 then return "" end
			
	if hp < 999 then
        	return string.format("%d", hp) --numFormat = "%d" - zamienia na format double -> nie float, czyli bez %.0
	end		
	while hp / 1000 > 1.0 do
	        result = result .. "k"
		hp = hp / 1000
        end
        if hp > 900 then			--setki jezeli powyzej 900 to (dla 999 222)
       		hp = math.floor(hp / 100) / 10	-- podloga z np. (9.99222) /10 -> 9.9/10 ->0.99
                result = result .. "k"
	else 
		hp = math.floor(hp * 10) / 10 --jezeli nie to (dla 293.805) ->293.8
		
	end
        
	result = string.format(numFormat .. "%s", hp, result)

        return result
    end
---------------------------------------------------------------------------------------------------------

    }
}
