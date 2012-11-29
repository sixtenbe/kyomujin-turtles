--0.5.1
--
-- k47's Turtle Library
-- modified by Kyomujin
--
-- SEE MY README for instructions on installing my libraries
-- @ pastebin.com/u/ck47

-- Meta Functions --
local function _turn(n, hand)
	if n==nil then n=1 end
	for i=1,n do
		hand()
	end
	return n%4
end

local function _move(n, move, dig, attack, suck)
	if n==nil then n=1 end
	while not fillTo(n) do
		print ("Waiting for more fuel...")
		sleep (5)
	end
	for i=1,n do
		while not move() do
			if not dig() then
				attack()
				suck()
			end
			fillTo (1)
			sleep(0.5)
		end
	end
	return n
end

local function _place(p)
	for i=1,16 do
		turtle.select(i)
		if p() then
			return i
		end
	end
end

-- Private functions --
local function _dig_back()
	_turn(2, turtle.turnRight)
	local success = turtle.dig()
	_turn(2, turtle.turnLeft)
	return success
end

local function _attack_back()
	_turn(2, turtle.turnRight)
	return turtle.attack()
end

local function _suck_back()
	turtle.suck()
	_turn(2, turtle.turnLeft)
end

-- Fuel handling
function hasFuel(x)
 local	fuel = turtle.getFuelLevel()
	if fuel >= x then
   return true
 else
   return false
 end
end

function fillTo(x)
	if hasFuel(x) then
		return true
	else
		for f=1,16 do
			turtle.select(f)
			if turtle.refuel(1) then
				print("Found more fuel.")
			end
			if hasFuel(x) then
				turtle.select(1)
				return true
			end
		end
	end
	return false
end

-- Directional Wrappers --
function right (n)
	return _turn(n, turtle.turnRight)
end

function left (n)
	return _turn(n, turtle.turnLeft)
end

function uturn(w)
	if w % 2 == 1 then
		right()
	else
		left()
	end
end

-- Movement wrappers
function fwd (n)
	return _move(n, turtle.forward, turtle.dig, turtle.attack, turtle.suck)
end

function back (n)
	return _move(n, turtle.back, _dig_back(), _attack_back, _suck_back)
end

function up (n)
	return _move(n, turtle.up, turtle.digUp, turtle.attackUp, turtle.suckUp)
end

function down (n)
	return _move(n, turtle.down, turtle.digDown, turtle.attackDown, turtle.suckDown)
end

-- Place wrappers
function place ()
	_place(turtle.place)
end

function placeDown ()
	_place(turtle.placeDown)
end

function placeUp ()
	_place(turtle.placeUp)
end

-- Pattern Interperater
--[[ kurtle patterns:
move
 f = forward
 b = back
 u = up
 d = down
 l = left
 r = right
dig
 F = dig forward
 D = dig down
 U = dig up
]]--
actions = {
	['f'] = fwd,
	['b'] = back,
	['u'] = up,
	['d'] = down,
	['l'] = left,
	['r'] = right,
	['F'] = turtle.dig,
	['D'] = turtle.digDown,
	['U'] = turtle.digUp,
	['-'] = turtle.place,
	['_'] = turtle.placeDown,
	['^'] = turtle.placeUp
}

move_actions = {
	['f'] = true,
	['b'] = true,
	['u'] = true,
	['d'] = true,
	['l'] = true,
	['r'] = true,
}


function patt ( pattern )
	local matches = nil
  local match = ""
  local reps = nil
  local cmd = ""
  matches = string.gmatch(pattern, "%d?%D")
  
  for match in matches do
    if string.len(match) == 1 then
      actions[match]()
    else
      --do action multiple times
      reps = tonumber string.sub(match, 1, 1)
      cmd = string.sub(match,2,2)
      if move_actions[cmd] then
        actions[cmd](reps)
      else
        for i=1, reps do
          actions[cmd]()
        end
      end
    end
  end
end

-- vim: ft=lua sw=2 ts=2 sts=2