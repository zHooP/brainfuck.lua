-- Author: zHooP
-- Date:   2019-11-30

-- How many cells should be available
local allocSize = 128

local function alloc(tbl, size)
	for i = 0, size do 
		tbl[i] = 0
	end
end 

local function parse(bfCode)
	local curChar = ""
	local loopPos = {}
	local loopLevel = 0
	local cells = {}
	local curCell = 0
	alloc(cells, allocSize) 
	for i = 1, bfCode:len() do 
		curChar = bfCode:sub(i, i)
		if curChar == "+" then
			cells[curCell] = cells[curCell] + 1
			if cells[curCell] == 256 then
				cells[curCell] = 0	
			end
		elseif curChar == "-" then
			cells[curCell] = cells[curCell] - 1
			if cells[curCell] == -1 then
				cells[curCell] = 255
			end
		elseif curChar == ">" then
			curCell = curCell + 1
			if cells[curCell] == nil then
				error("Cannot access invalid cell")
			end
		elseif curChar == "<" then
			curCell = curCell - 1
			if cells[curCell] == nil then
				error("Cannot access invalid cell")
			end
		elseif curChar == "[" then
			loopLevel = loopLevel + 1
			loopPos[loopLevel] = i + 1
		elseif curChar == "]" then
			if loopPos[loopLevel] ~= nil then
				if cells[curCell] ~= 0 then
					i = loopPos[loopLevel]
				else 
					loopPos[loopLevel] = nil
					loopLevel = loopLevel - 1
				end
			end
		elseif curChar == "." then
			io.write(string.char(cells[curCell]))
		elseif curChar == "," then
			cells[curCell] = string.byte(io.read(1))
		end
	end
end 

parse("brainfuck code here")
