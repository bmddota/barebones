-- -*- coding: utf-8 -*-
--
-- Simple JSON encoding and decoding in pure Lua.
--
-- Copyright 2010-2013 Jeffrey Friedl
-- http://regex.info/blog/
--
-- Latest version: http://regex.info/blog/lua/json
--
-- This code is released under a Creative Commons CC-BY "Attribution" License:
-- http://creativecommons.org/licenses/by/3.0/deed.en_US
--
-- It can be used for any purpose so long as the copyright notice and
-- web-page links above are maintained. Enjoy.
--
local VERSION = 20131118.9  -- version history at end of file
local OBJDEF = { VERSION = VERSION }


--
-- Simple JSON encoding and decoding in pure Lua.
-- http://www.json.org/
--
--
--   JSON = (loadfile "JSON.lua")() -- one-time load of the routines
--
--   local lua_value = JSON:decode(raw_json_text)
--
--   local raw_json_text    = JSON:encode(lua_table_or_value)
--   local pretty_json_text = JSON:encode_pretty(lua_table_or_value) -- "pretty printed" version for human readability
--
--
-- DECODING
--
--   JSON = (loadfile "JSON.lua")() -- one-time load of the routines
--
--   local lua_value = JSON:decode(raw_json_text)
--
--   If the JSON text is for an object or an array, e.g.
--     { "what": "books", "count": 3 }
--   or
--     [ "Larry", "Curly", "Moe" ]
--
--   the result is a Lua table, e.g.
--     { what = "books", count = 3 }
--   or
--     { "Larry", "Curly", "Moe" }
--
--
--   The encode and decode routines accept an optional second argument, "etc", which is not used
--   during encoding or decoding, but upon error is passed along to error handlers. It can be of any
--   type (including nil).
--
--   With most errors during decoding, this code calls
--
--      JSON:onDecodeError(message, text, location, etc)
--
--   with a message about the error, and if known, the JSON text being parsed and the byte count
--   where the problem was discovered. You can replace the default JSON:onDecodeError() with your
--   own function.
--
--   The default onDecodeError() merely augments the message with data about the text and the
--   location if known (and if a second 'etc' argument had been provided to decode(), its value is
--   tacked onto the message as well), and then calls JSON.assert(), which itself defaults to Lua's
--   built-in assert(), and can also be overridden.
--
--   For example, in an Adobe Lightroom plugin, you might use something like
--
--          function JSON:onDecodeError(message, text, location, etc)
--             LrErrors.throwUserError("Internal Error: invalid JSON data")
--          end
--
--   or even just
--
--          function JSON.assert(message)
--             LrErrors.throwUserError("Internal Error: " .. message)
--          end
--
--   If JSON:decode() is passed a nil, this is called instead:
--
--      JSON:onDecodeOfNilError(message, nil, nil, etc)
--
--   and if JSON:decode() is passed HTML instead of JSON, this is called:
--
--      JSON:onDecodeOfHTMLError(message, text, nil, etc)
--
--   The use of the fourth 'etc' argument allows stronger coordination between decoding and error
--   reporting, especially when you provide your own error-handling routines. Continuing with the
--   the Adobe Lightroom plugin example:
--
--          function JSON:onDecodeError(message, text, location, etc)
--             local note = "Internal Error: invalid JSON data"
--             if type(etc) = 'table' and etc.photo then
--                note = note .. " while processing for " .. etc.photo:getFormattedMetadata('fileName')
--             end
--             LrErrors.throwUserError(note)
--          end
--
--            :
--            :
--
--          for i, photo in ipairs(photosToProcess) do
--               :
--               :
--               local data = JSON:decode(someJsonText, { photo = photo })
--               :
--               :
--          end
--
--
--
--

-- DECODING AND STRICT TYPES
--
--   Because both JSON objects and JSON arrays are converted to Lua tables, it's not normally
--   possible to tell which a JSON type a particular Lua table was derived from, or guarantee
--   decode-encode round-trip equivalency.
--
--   However, if you enable strictTypes, e.g.
--
--      JSON = (loadfile "JSON.lua")() --load the routines
--      JSON.strictTypes = true
--
--   then the Lua table resulting from the decoding of a JSON object or JSON array is marked via Lua
--   metatable, so that when re-encoded with JSON:encode() it ends up as the appropriate JSON type.
--
--   (This is not the default because other routines may not work well with tables that have a
--   metatable set, for example, Lightroom API calls.)
--
--
-- ENCODING
--
--   JSON = (loadfile "JSON.lua")() -- one-time load of the routines
--
--   local raw_json_text    = JSON:encode(lua_table_or_value)
--   local pretty_json_text = JSON:encode_pretty(lua_table_or_value) -- "pretty printed" version for human readability

--   On error during encoding, this code calls:
--
--    JSON:onEncodeError(message, etc)
--
--   which you can override in your local JSON object.
--
--   If the Lua table contains both string and numeric keys, it fits neither JSON's
--   idea of an object, nor its idea of an array. To get around this, when any string
--   key exists (or when non-positive numeric keys exist), numeric keys are converted
--   to strings.
--
--   For example,
--     JSON:encode({ "one", "two", "three", SOMESTRING = "some string" }))
--   produces the JSON object
--     {"1":"one","2":"two","3":"three","SOMESTRING":"some string"}
--
--   To prohibit this conversion and instead make it an error condition, set
--      JSON.noKeyConversion = true


--
-- SUMMARY OF METHODS YOU CAN OVERRIDE IN YOUR LOCAL LUA JSON OBJECT
--
--    assert
--    onDecodeError
--    onDecodeOfNilError
--    onDecodeOfHTMLError
--    onEncodeError
--
--  If you want to create a separate Lua JSON object with its own error handlers,
--  you can reload JSON.lua or use the :new() method.
--
---------------------------------------------------------------------------


local author = "-[ JSON.lua package by Jeffrey Friedl (http://regex.info/blog/lua/json), version " .. tostring(VERSION) .. " ]-"
local isArray  = { __tostring = function() return "JSON array"  end }    isArray.__index  = isArray
local isObject = { __tostring = function() return "JSON object" end }    isObject.__index = isObject


function OBJDEF:newArray(tbl)
   return setmetatable(tbl or {}, isArray)
end

function OBJDEF:newObject(tbl)
   return setmetatable(tbl or {}, isObject)
end

local function unicode_codepoint_as_utf8(codepoint)
   --
   -- codepoint is a number
   --
   if codepoint <= 127 then
      return string.char(codepoint)

   elseif codepoint <= 2047 then
      --
      -- 110yyyxx 10xxxxxx         <-- useful notation from http://en.wikipedia.org/wiki/Utf8
      --
      local highpart = math.floor(codepoint / 0x40)
      local lowpart  = codepoint - (0x40 * highpart)
      return string.char(0xC0 + highpart,
                         0x80 + lowpart)

   elseif codepoint <= 65535 then
      --
      -- 1110yyyy 10yyyyxx 10xxxxxx
      --
      local highpart  = math.floor(codepoint / 0x1000)
      local remainder = codepoint - 0x1000 * highpart
      local midpart   = math.floor(remainder / 0x40)
      local lowpart   = remainder - 0x40 * midpart

      highpart = 0xE0 + highpart
      midpart  = 0x80 + midpart
      lowpart  = 0x80 + lowpart

      --
      -- Check for an invalid character (thanks Andy R. at Adobe).
      -- See table 3.7, page 93, in http://www.unicode.org/versions/Unicode5.2.0/ch03.pdf#G28070
      --
      if ( highpart == 0xE0 and midpart < 0xA0 ) or
         ( highpart == 0xED and midpart > 0x9F ) or
         ( highpart == 0xF0 and midpart < 0x90 ) or
         ( highpart == 0xF4 and midpart > 0x8F )
      then
         return "?"
      else
         return string.char(highpart,
                            midpart,
                            lowpart)
      end

   else
      --
      -- 11110zzz 10zzyyyy 10yyyyxx 10xxxxxx
      --
      local highpart  = math.floor(codepoint / 0x40000)
      local remainder = codepoint - 0x40000 * highpart
      local midA      = math.floor(remainder / 0x1000)
      remainder       = remainder - 0x1000 * midA
      local midB      = math.floor(remainder / 0x40)
      local lowpart   = remainder - 0x40 * midB

      return string.char(0xF0 + highpart,
                         0x80 + midA,
                         0x80 + midB,
                         0x80 + lowpart)
   end
end

function OBJDEF:onDecodeError(message, text, location, etc)
   if text then
      if location then
         message = string.format("%s at char %d of: %s", message, location, text)
      else
         message = string.format("%s: %s", message, text)
      end
   end
   if etc ~= nil then
      message = message .. " (" .. OBJDEF:encode(etc) .. ")"
   end

   if self.assert then
      self.assert(false, message)
   else
      assert(false, message)
   end
end

OBJDEF.onDecodeOfNilError  = OBJDEF.onDecodeError
OBJDEF.onDecodeOfHTMLError = OBJDEF.onDecodeError

function OBJDEF:onEncodeError(message, etc)
   if etc ~= nil then
      message = message .. " (" .. OBJDEF:encode(etc) .. ")"
   end

   if self.assert then
      self.assert(false, message)
   else
      assert(false, message)
   end
end

local function grok_number(self, text, start, etc)
   --
   -- Grab the integer part
   --
   local integer_part = text:match('^-?[1-9]%d*', start)
                     or text:match("^-?0",        start)

   if not integer_part then
      self:onDecodeError("expected number", text, start, etc)
   end

   local i = start + integer_part:len()

   --
   -- Grab an optional decimal part
   --
   local decimal_part = text:match('^%.%d+', i) or ""

   i = i + decimal_part:len()

   --
   -- Grab an optional exponential part
   --
   local exponent_part = text:match('^[eE][-+]?%d+', i) or ""

   i = i + exponent_part:len()

   local full_number_text = integer_part .. decimal_part .. exponent_part
   local as_number = tonumber(full_number_text)

   if not as_number then
      self:onDecodeError("bad number", text, start, etc)
   end

   return as_number, i
end


local function grok_string(self, text, start, etc)

   if text:sub(start,start) ~= '"' then
      self:onDecodeError("expected string's opening quote", text, start, etc)
   end

   local i = start + 1 -- +1 to bypass the initial quote
   local text_len = text:len()
   local VALUE = ""
   while i <= text_len do
      local c = text:sub(i,i)
      if c == '"' then
         return VALUE, i + 1
      end
      if c ~= '\\' then
         VALUE = VALUE .. c
         i = i + 1
      elseif text:match('^\\b', i) then
         VALUE = VALUE .. "\b"
         i = i + 2
      elseif text:match('^\\f', i) then
         VALUE = VALUE .. "\f"
         i = i + 2
      elseif text:match('^\\n', i) then
         VALUE = VALUE .. "\n"
         i = i + 2
      elseif text:match('^\\r', i) then
         VALUE = VALUE .. "\r"
         i = i + 2
      elseif text:match('^\\t', i) then
         VALUE = VALUE .. "\t"
         i = i + 2
      else
         local hex = text:match('^\\u([0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])', i)
         if hex then
            i = i + 6 -- bypass what we just read

            -- We have a Unicode codepoint. It could be standalone, or if in the proper range and
            -- followed by another in a specific range, it'll be a two-code surrogate pair.
            local codepoint = tonumber(hex, 16)
            if codepoint >= 0xD800 and codepoint <= 0xDBFF then
               -- it's a hi surrogate... see whether we have a following low
               local lo_surrogate = text:match('^\\u([dD][cdefCDEF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])', i)
               if lo_surrogate then
                  i = i + 6 -- bypass the low surrogate we just read
                  codepoint = 0x2400 + (codepoint - 0xD800) * 0x400 + tonumber(lo_surrogate, 16)
               else
                  -- not a proper low, so we'll just leave the first codepoint as is and spit it out.
               end
            end
            VALUE = VALUE .. unicode_codepoint_as_utf8(codepoint)

         else

            -- just pass through what's escaped
            VALUE = VALUE .. text:match('^\\(.)', i)
            i = i + 2
         end
      end
   end

   self:onDecodeError("unclosed string", text, start, etc)
end

local function skip_whitespace(text, start)

   local match_start, match_end = text:find("^[ \n\r\t]+", start) -- [http://www.ietf.org/rfc/rfc4627.txt] Section 2
   if match_end then
      return match_end + 1
   else
      return start
   end
end

local grok_one -- assigned later

local function grok_object(self, text, start, etc)
   if not text:sub(start,start) == '{' then
      self:onDecodeError("expected '{'", text, start, etc)
   end

   local i = skip_whitespace(text, start + 1) -- +1 to skip the '{'

   local VALUE = self.strictTypes and self:newObject { } or { }

   if text:sub(i,i) == '}' then
      return VALUE, i + 1
   end
   local text_len = text:len()
   while i <= text_len do
      local key, new_i = grok_string(self, text, i, etc)

      i = skip_whitespace(text, new_i)

      if text:sub(i, i) ~= ':' then
         self:onDecodeError("expected colon", text, i, etc)
      end

      i = skip_whitespace(text, i + 1)

      local val, new_i = grok_one(self, text, i)

      VALUE[key] = val

      --
      -- Expect now either '}' to end things, or a ',' to allow us to continue.
      --
      i = skip_whitespace(text, new_i)

      local c = text:sub(i,i)

      if c == '}' then
         return VALUE, i + 1
      end

      if text:sub(i, i) ~= ',' then
         self:onDecodeError("expected comma or '}'", text, i, etc)
      end

      i = skip_whitespace(text, i + 1)
   end

   self:onDecodeError("unclosed '{'", text, start, etc)
end

local function grok_array(self, text, start, etc)
   if not text:sub(start,start) == '[' then
      self:onDecodeError("expected '['", text, start, etc)
   end

   local i = skip_whitespace(text, start + 1) -- +1 to skip the '['
   local VALUE = self.strictTypes and self:newArray { } or { }
   if text:sub(i,i) == ']' then
      return VALUE, i + 1
   end

   local text_len = text:len()
   while i <= text_len do
      local val, new_i = grok_one(self, text, i)

      table.insert(VALUE, val)

      i = skip_whitespace(text, new_i)

      --
      -- Expect now either ']' to end things, or a ',' to allow us to continue.
      --
      local c = text:sub(i,i)
      if c == ']' then
         return VALUE, i + 1
      end
      if text:sub(i, i) ~= ',' then
         self:onDecodeError("expected comma or '['", text, i, etc)
      end
      i = skip_whitespace(text, i + 1)
   end
   self:onDecodeError("unclosed '['", text, start, etc)
end


grok_one = function(self, text, start, etc)
   -- Skip any whitespace
   start = skip_whitespace(text, start)

   if start > text:len() then
      self:onDecodeError("unexpected end of string", text, nil, etc)
   end

   if text:find('^"', start) then
      return grok_string(self, text, start, etc)

   elseif text:find('^[-0123456789 ]', start) then
      return grok_number(self, text, start, etc)

   elseif text:find('^%{', start) then
      return grok_object(self, text, start, etc)

   elseif text:find('^%[', start) then
      return grok_array(self, text, start, etc)

   elseif text:find('^true', start) then
      return true, start + 4

   elseif text:find('^false', start) then
      return false, start + 5

   elseif text:find('^null', start) then
      return nil, start + 4

   else
      self:onDecodeError("can't parse JSON", text, start, etc)
   end
end

function OBJDEF:decode(text, etc)
   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      OBJDEF:onDecodeError("JSON:decode must be called in method format", nil, nil, etc)
   end

   if text == nil then
      self:onDecodeOfNilError(string.format("nil passed to JSON:decode()"), nil, nil, etc)
   elseif type(text) ~= 'string' then
      self:onDecodeError(string.format("expected string argument to JSON:decode(), got %s", type(text)), nil, nil, etc)
   end

   if text:match('^%s*$') then
      return nil
   end

   if text:match('^%s*<') then
      -- Can't be JSON... we'll assume it's HTML
      self:onDecodeOfHTMLError(string.format("html passed to JSON:decode()"), text, nil, etc)
   end

   --
   -- Ensure that it's not UTF-32 or UTF-16.
   -- Those are perfectly valid encodings for JSON (as per RFC 4627 section 3),
   -- but this package can't handle them.
   --
   if text:sub(1,1):byte() == 0 or (text:len() >= 2 and text:sub(2,2):byte() == 0) then
      self:onDecodeError("JSON package groks only UTF-8, sorry", text, nil, etc)
   end

   local success, value = pcall(grok_one, self, text, 1, etc)
   if success then
      return value
   else
      -- should never get here... JSON parse errors should have been caught earlier
      assert(false, value)
      return nil
   end
end

local function backslash_replacement_function(c)
   if c == "\n" then
      return "\\n"
   elseif c == "\r" then
      return "\\r"
   elseif c == "\t" then
      return "\\t"
   elseif c == "\b" then
      return "\\b"
   elseif c == "\f" then
      return "\\f"
   elseif c == '"' then
      return '\\"'
   elseif c == '\\' then
      return '\\\\'
   else
      return string.format("\\u%04x", c:byte())
   end
end

local chars_to_be_escaped_in_JSON_string
   = '['
   ..    '"'    -- class sub-pattern to match a double quote
   ..    '%\\'  -- class sub-pattern to match a backslash
   ..    '%z'   -- class sub-pattern to match a null
   ..    '\001' .. '-' .. '\031' -- class sub-pattern to match control characters
   .. ']'

local function json_string_literal(value)
   local newval = value:gsub(chars_to_be_escaped_in_JSON_string, backslash_replacement_function)
   return '"' .. newval .. '"'
end

local function object_or_array(self, T, etc)
   --
   -- We need to inspect all the keys... if there are any strings, we'll convert to a JSON
   -- object. If there are only numbers, it's a JSON array.
   --
   -- If we'll be converting to a JSON object, we'll want to sort the keys so that the
   -- end result is deterministic.
   --
   local string_keys = { }
   local number_keys = { }
   local number_keys_must_be_strings = false
   local maximum_number_key

   for key in pairs(T) do
      if type(key) == 'string' then
         table.insert(string_keys, key)
      elseif type(key) == 'number' then
         table.insert(number_keys, key)
         if key <= 0 or key >= math.huge then
            number_keys_must_be_strings = true
         elseif not maximum_number_key or key > maximum_number_key then
            maximum_number_key = key
         end
      else
         self:onEncodeError("can't encode table with a key of type " .. type(key), etc)
      end
   end

   if #string_keys == 0 and not number_keys_must_be_strings then
      --
      -- An empty table, or a numeric-only array
      --
      if #number_keys > 0 then
         return nil, maximum_number_key -- an array
      elseif tostring(T) == "JSON array" then
         return nil
      elseif tostring(T) == "JSON object" then
         return { }
      else
         -- have to guess, so we'll pick array, since empty arrays are likely more common than empty objects
         return nil
      end
   end

   table.sort(string_keys)

   local map
   if #number_keys > 0 then
      --
      -- If we're here then we have either mixed string/number keys, or numbers inappropriate for a JSON array
      -- It's not ideal, but we'll turn the numbers into strings so that we can at least create a JSON object.
      --

      if JSON.noKeyConversion then
         self:onEncodeError("a table with both numeric and string keys could be an object or array; aborting", etc)
      end

      --
      -- Have to make a shallow copy of the source table so we can remap the numeric keys to be strings
      --
      map = { }
      for key, val in pairs(T) do
         map[key] = val
      end

      table.sort(number_keys)

      --
      -- Throw numeric keys in there as strings
      --
      for _, number_key in ipairs(number_keys) do
         local string_key = tostring(number_key)
         if map[string_key] == nil then
            table.insert(string_keys , string_key)
            map[string_key] = T[number_key]
         else
            self:onEncodeError("conflict converting table with mixed-type keys into a JSON object: key " .. number_key .. " exists both as a string and a number.", etc)
         end
      end
   end

   return string_keys, nil, map
end

--
-- Encode
--
local encode_value -- must predeclare because it calls itself
function encode_value(self, value, parents, etc, indent) -- non-nil indent means pretty-printing

   if value == nil then
      return 'null'

   elseif type(value) == 'string' then
      return json_string_literal(value)

   elseif type(value) == 'number' then
      if value ~= value then
         --
         -- NaN (Not a Number).
         -- JSON has no NaN, so we have to fudge the best we can. This should really be a package option.
         --
         return "null"
      elseif value >= math.huge then
         --
         -- Positive infinity. JSON has no INF, so we have to fudge the best we can. This should
         -- really be a package option. Note: at least with some implementations, positive infinity
         -- is both ">= math.huge" and "<= -math.huge", which makes no sense but that's how it is.
         -- Negative infinity is properly "<= -math.huge". So, we must be sure to check the ">="
         -- case first.
         --
         return "1e+9999"
      elseif value <= -math.huge then
         --
         -- Negative infinity.
         -- JSON has no INF, so we have to fudge the best we can. This should really be a package option.
         --
         return "-1e+9999"
      else
         return tostring(value)
      end

   elseif type(value) == 'boolean' then
      return tostring(value)

   elseif type(value) ~= 'table' then
      self:onEncodeError("can't convert " .. type(value) .. " to JSON", etc)

   else
      --
      -- A table to be converted to either a JSON object or array.
      --
      local T = value

      if parents[T] then
         self:onEncodeError("table " .. tostring(T) .. " is a child of itself", etc)
      else
         parents[T] = true
      end

      local result_value

      local object_keys, maximum_number_key, map = object_or_array(self, T, etc)
      if maximum_number_key then
         --
         -- An array...
         --
         local ITEMS = { }
         for i = 1, maximum_number_key do
            table.insert(ITEMS, encode_value(self, T[i], parents, etc, indent))
         end

         if indent then
            result_value = "[ " .. table.concat(ITEMS, ", ") .. " ]"
         else
            result_value = "[" .. table.concat(ITEMS, ",") .. "]"
         end

      elseif object_keys then
         --
         -- An object
         --
         local TT = map or T

         if indent then

            local KEYS = { }
            local max_key_length = 0
            for _, key in ipairs(object_keys) do
               local encoded = encode_value(self, tostring(key), parents, etc, "")
               max_key_length = math.max(max_key_length, #encoded)
               table.insert(KEYS, encoded)
            end
            local key_indent = indent .. "    "
            local subtable_indent = indent .. string.rep(" ", max_key_length + 2 + 4)
            local FORMAT = "%s%" .. string.format("%d", max_key_length) .. "s: %s"

            local COMBINED_PARTS = { }
            for i, key in ipairs(object_keys) do
               local encoded_val = encode_value(self, TT[key], parents, etc, subtable_indent)
               table.insert(COMBINED_PARTS, string.format(FORMAT, key_indent, KEYS[i], encoded_val))
            end
            result_value = "{\n" .. table.concat(COMBINED_PARTS, ",\n") .. "\n" .. indent .. "}"

         else

            local PARTS = { }
            for _, key in ipairs(object_keys) do
               local encoded_val = encode_value(self, TT[key],       parents, etc, indent)
               local encoded_key = encode_value(self, tostring(key), parents, etc, indent)
               table.insert(PARTS, string.format("%s:%s", encoded_key, encoded_val))
            end
            result_value = "{" .. table.concat(PARTS, ",") .. "}"

         end
      else
         --
         -- An empty array/object... we'll treat it as an array, though it should really be an option
         --
         result_value = "[]"
      end

      parents[T] = false
      return result_value
   end
end


function OBJDEF:encode(value, etc)
   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      OBJDEF:onEncodeError("JSON:encode must be called in method format", etc)
   end
   return encode_value(self, value, {}, etc, nil)
end

function OBJDEF:encode_pretty(value, etc)
   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      OBJDEF:onEncodeError("JSON:encode_pretty must be called in method format", etc)
   end
   return encode_value(self, value, {}, etc, "")
end

function OBJDEF.__tostring()
   return "JSON encode/decode package"
end

OBJDEF.__index = OBJDEF

function OBJDEF:new(args)
   local new = { }

   if args then
      for key, val in pairs(args) do
         new[key] = val
      end
   end

   return setmetatable(new, OBJDEF)
end

-- Return an instance of the encoder
return OBJDEF:new()