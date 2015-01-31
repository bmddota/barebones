-- GREAT UTILITY FUNCTIONS

-- adds ability to a unit, sets the level to 1, then returns ability handle.
function AddAbilityToUnit(hUnit, sName)
	if not hUnit or sName == "" then return end

	if not hUnit:HasAbility(sName) then
		hUnit:AddAbility(sName)
	end
	local abil = hUnit:FindAbilityByName(sName)
	abil:SetLevel(1)

	return abil
end

function GetOppositeTeam( unit )
	if unit:GetTeam() == DOTA_TEAM_GOODGUYS then
		return DOTA_TEAM_BADGUYS
	else
		return DOTA_TEAM_GOODGUYS
	end
end

-- returns true 50% of the time.
function CoinFlip(  )
	return RollPercentage(50)
end

-- theta is in radians.
function RotateVector2D(v,theta)
	local xp = v.x*math.cos(theta)-v.y*math.sin(theta)
	local yp = v.x*math.sin(theta)+v.y*math.cos(theta)
	return Vector(xp,yp,v.z):Normalized()
end

function PrintVector(v)
	print('x: ' .. v.x .. ' y: ' .. v.y .. ' z: ' .. v.z)
end

function TableContains( list, element )
	if list == nil then return false end
	for k,v in pairs(list) do
		if k == element then
			return true
		end
	end
	return false
end

function GetIndex(list, element)
	if list == nil then return false end
	for i=1,#list do
		if list[i] == element then
			return i
		end
	end
	return -1
end

-- useful with GameRules:SendCustomMessage
function ColorIt( sStr, sColor )
	if sStr == nil or sColor == nil then
		return
	end

	--Default is cyan.
	local color = "00FFFF"

	if sColor == "green" then
		color = "ADFF2F"
	elseif sColor == "purple" then
		color = "EE82EE"
	elseif sColor == "blue" then
		color = "00BFFF"
	elseif sColor == "orange" then
		color = "FFA500"
	elseif sColor == "pink" then
		color = "DDA0DD"
	elseif sColor == "red" then
		color = "FF6347"
	elseif sColor == "cyan" then
		color = "00FFFF"
	elseif sColor == "yellow" then
		color = "FFFF00"
	elseif sColor == "brown" then
		color = "A52A2A"
	elseif sColor == "magenta" then
		color = "FF00FF"
	elseif sColor == "teal" then
		color = "008080"
	end
	return "<font color='#" .. color .. "'>" .. sStr .. "</font>"
end

--[[
	p: the raw point (Vector)
	center: center of the square. (Vector)
	length: length of 1 side of square. (Float)
]]
function IsPointWithinSquare(p, center, length)
	if (p.x > center.x-length and p.x < center.x+length) and 
		(p.y > center.y-length and p.y < center.y+length) then
		return true
	else
		return false
	end
end

--[[
  Continuous collision algorithm for circular 2D bodies, see
  http://www.gvu.gatech.edu/people/official/jarek/graphics/material/collisionFitzgeraldForsthoefel.pdf
  
  body1 and body2 are tables that contain:
  v: velocity (Vector)
  c: center (Vector)
  r: radius (Float)

  Returns the time-till-collision.
]]
function TimeTillCollision(body1,body2)
	local W = body2.v-body1.v
	local D = body2.c-body1.c
	local A = DotProduct(W,W)
	local B = 2*DotProduct(D,W)
	local C = DotProduct(D,D)-(body1.r+body2.r)*(body1.r+body2.r)
	local d = B*B-(4*A*C)
	if d>=0 then
		local t1=(-B-math.sqrt(d))/(2*A)
		if t1<0 then t1=2 end
		local t2=(-B+math.sqrt(d))/(2*A)
		if t2<0 then t2=2 end
		local m = math.min(t1,t2)
		--if ((-0.02<=m) and (m<=1.02)) then
		return m
			--end
	end
	return 2
end

function DotProduct(v1,v2)
  return (v1.x*v2.x)+(v1.y*v2.y)
end

--MODULE LOADER STUFF
BASE_LOG_PREFIX = '[B]'
LOG_FILE = "log/Barebones.txt"

InitLogFile(LOG_FILE, "[[ Barebones ]]")

function log(msg)
	print(BASE_LOG_PREFIX .. msg)
	AppendToLogFile(LOG_FILE, msg .. '\n')
end

function err(msg)
	display('[X] '..msg, COLOR_RED)
end

function warning(msg)
	display('[W] '..msg, COLOR_DYELLOW)
end

function display(text, color)
	color = color or COLOR_LGREEN

	log('> '..text)

	Say(nil, color..text, false)
end
--END OF MODULE LOADER STUFF

function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then return end

	done = done or {}
	done[t] = true
	indent = indent or 0

	local l = {}
	for k, v in pairs(t) do
		table.insert(l, k)
	end

	table.sort(l)
	for k, v in ipairs(l) do
		-- Ignore FDesc
		if v ~= 'FDesc' then
			local value = t[v]

			if type(value) == "table" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..":")
				PrintTable (value, indent + 2, done)
			elseif type(value) == "userdata" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
			else
				if t.FDesc and t.FDesc[v] then
					print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
				else
					print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				end
			end
		end
	end
end

-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'



--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
--
--=============================================================================

--/////////////////////////////////////////////////////////////////////////////
-- Debug helpers
--
--  Things that are really for during development - you really should never call any of this
--  in final/real/workshop submitted code
--/////////////////////////////////////////////////////////////////////////////

-- if you want a table printed to console formatted like a table (dont we already have this somewhere?)
scripthelp_LogDeepPrintTable = "Print out a table (and subtables) to the console"
logFile = "log/log.txt"

function LogDeepSetLogFile( file )
	logFile = file
end

function LogEndLine ( line )
	AppendToLogFile(logFile, line .. "\n")
end

function _LogDeepPrintMetaTable( debugMetaTable, prefix )
	_LogDeepPrintTable( debugMetaTable, prefix, false, false )
	if getmetatable( debugMetaTable ) ~= nil and getmetatable( debugMetaTable ).__index ~= nil then
		_LogDeepPrintMetaTable( getmetatable( debugMetaTable ).__index, prefix )
	end
end

function _LogDeepPrintTable(debugInstance, prefix, isOuterScope, chaseMetaTables )
	prefix = prefix or ""
	local string_accum = ""
	if debugInstance == nil then
		LogEndLine( prefix .. "<nil>" )
		return
	end
	local terminatescope = false
	local oldPrefix = ""
	if isOuterScope then  -- special case for outer call - so we dont end up iterating strings, basically
		if type(debugInstance) == "table" then
			LogEndLine( prefix .. "{" )
			oldPrefix = prefix
			prefix = prefix .. "   "
			terminatescope = true
	else
		LogEndLine( prefix .. " = " .. (type(debugInstance) == "string" and ("\"" .. debugInstance .. "\"") or debugInstance))
	end
	end
	local debugOver = debugInstance

	-- First deal with metatables
	if chaseMetaTables == true then
		if getmetatable( debugOver ) ~= nil and getmetatable( debugOver ).__index ~= nil then
			local thisMetaTable = getmetatable( debugOver ).__index
			if vlua.find(_LogDeepprint_alreadyseen, thisMetaTable ) ~= nil then
				LogEndLine( string.format( "%s%-32s\t= %s (table, already seen)", prefix, "metatable", tostring( thisMetaTable ) ) )
			else
				LogEndLine(prefix .. "metatable = " .. tostring( thisMetaTable ) )
				LogEndLine(prefix .. "{")
				table.insert( _LogDeepprint_alreadyseen, thisMetaTable )
				_LogDeepPrintMetaTable( thisMetaTable, prefix .. "   ", false )
				LogEndLine(prefix .. "}")
			end
		end
	end

	-- Now deal with the elements themselves
	-- debugOver sometimes a string??
	for idx, data_value in pairs(debugOver) do
		if type(data_value) == "table" then
			if vlua.find(_LogDeepprint_alreadyseen, data_value) ~= nil then
				LogEndLine( string.format( "%s%-32s\t= %s (table, already seen)", prefix, idx, tostring( data_value ) ) )
			else
				local is_array = #data_value > 0
				local test = 1
				for idx2, val2 in pairs(data_value) do
					if type( idx2 ) ~= "number" or idx2 ~= test then
						is_array = false
						break
					end
					test = test + 1
				end
				local valtype = type(data_value)
				if is_array == true then
					valtype = "array table"
				end
				LogEndLine( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), valtype ) )
				LogEndLine(prefix .. (is_array and "[" or "{"))
				table.insert(_LogDeepprint_alreadyseen, data_value)
				_LogDeepPrintTable(data_value, prefix .. "   ", false, true)
				LogEndLine(prefix .. (is_array and "]" or "}"))
			end
		elseif type(data_value) == "string" then
			LogEndLine( string.format( "%s%-32s\t= \"%s\" (%s)", prefix, idx, data_value, type(data_value) ) )
		else
			LogEndLine( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), type(data_value) ) )
		end
	end
	if terminatescope == true then
		LogEndLine( oldPrefix .. "}" )
	end
end


function LogDeepPrintTable( debugInstance, prefix, isPublicScriptScope )
	prefix = prefix or ""
	_LogDeepprint_alreadyseen = {}
	table.insert(_LogDeepprint_alreadyseen, debugInstance)
	_LogDeepPrintTable(debugInstance, prefix, true, isPublicScriptScope )
end


--/////////////////////////////////////////////////////////////////////////////
-- Fancy new LogDeepPrint - handles instances, and avoids cycles
--
--/////////////////////////////////////////////////////////////////////////////

-- @todo: this is hideous, there must be a "right way" to do this, im dumb!
-- outside the recursion table of seen recurses so we dont cycle into our components that refer back to ourselves
_LogDeepprint_alreadyseen = {}


-- the inner recursion for the LogDeep print
function _LogDeepToString(debugInstance, prefix)
	local string_accum = ""
	if debugInstance == nil then
		return "LogDeep Print of NULL" .. "\n"
	end
	if prefix == "" then  -- special case for outer call - so we dont end up iterating strings, basically
		if type(debugInstance) == "table" or type(debugInstance) == "table" or type(debugInstance) == "UNKNOWN" or type(debugInstance) == "table" then
			string_accum = string_accum .. (type(debugInstance) == "table" and "[" or "{") .. "\n"
			prefix = "   "
	else
		return " = " .. (type(debugInstance) == "string" and ("\"" .. debugInstance .. "\"") or debugInstance) .. "\n"
	end
	end
	local debugOver = type(debugInstance) == "UNKNOWN" and getclass(debugInstance) or debugInstance
	for idx, val in pairs(debugOver) do
		local data_value = debugInstance[idx]
		if type(data_value) == "table" or type(data_value) == "table" or type(data_value) == "UNKNOWN" or type(data_value) == "table" then
			if vlua.find(_LogDeepprint_alreadyseen, data_value) ~= nil then
				string_accum = string_accum .. prefix .. idx .. " ALREADY SEEN " .. "\n"
			else
				local is_array = type(data_value) == "table"
				string_accum = string_accum .. prefix .. idx .. " = ( " .. type(data_value) .. " )" .. "\n"
				string_accum = string_accum .. prefix .. (is_array and "[" or "{") .. "\n"
				table.insert(_LogDeepprint_alreadyseen, data_value)
				string_accum = string_accum .. _LogDeepToString(data_value, prefix .. "   ")
				string_accum = string_accum .. prefix .. (is_array and "]" or "}") .. "\n"
			end
		else
			--string_accum = string_accum .. prefix .. idx .. "\t= " .. (type(data_value) == "string" and ("\"" .. data_value .. "\"") or data_value) .. "\n"
			string_accum = string_accum .. prefix .. idx .. "\t= " .. "\"" .. tostring(data_value) .. "\"" .. "\n"
		end
	end
	if prefix == "   " then
		string_accum = string_accum .. (type(debugInstance) == "table" and "]" or "}") .. "\n" -- hack for "proving" at end - this is DUMB!
	end
	return string_accum
end


scripthelp_LogDeepString = "Convert a class/array/instance/table to a string"

function LogDeepToString(debugInstance, prefix)
	prefix = prefix or ""
	_LogDeepprint_alreadyseen = {}
	table.insert(_LogDeepprint_alreadyseen, debugInstance)
	return _LogDeepToString(debugInstance, prefix)
end


scripthelp_LogDeepPrint = "Print out a class/array/instance/table to the console"

function LogDeepPrint(debugInstance, prefix)
	prefix = prefix or ""
	LogEndLine(LogDeepToString(debugInstance, prefix))
end
