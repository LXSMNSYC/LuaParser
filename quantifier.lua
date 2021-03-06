--[[
    MIT License
    Copyright (c) 2019 Alexis Munsayac
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
--]]
local eat = require "LuaParser.parser.eat"
local size = require "LuaParser.parser.size"

local M = {}

local function is(x)
    return type(x) == "table" and getmetatable(x) == M 
end

local function identity(x)
    return x 
end

local function new(_, expr, min, max, fn)
	return setmetatable({
		_expr = expr, _min = min or 0, _max = max, _listener = fn,
		_token = "QUANTIFIER"
	}, M)
end

local function eval(self, parser)
	local min = self._min
	local max = self._max or size(parser)
	local expr = self._expr 
	
	local result = {}
    local c = 0
	for i = min, max do 
		local r = expr:eval(parser)
		if(r) then 
            c = c + 1
            result[c] = r 
		else 
			break
		end
	end
	
	if(min > 0 and #result == 0) then
		return self._listener(nil) 
	end
	return self._listener(result)
end


M.__call = new
M.__index = {
	eval = eval,
    is = is
}

return setmetatable({}, M)