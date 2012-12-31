-- 0.6.0
--
-- k47's Turtle Library
-- modified by Kyomujin
--
-- For originals see: pastebin.com/u/ck47
-- See readme for installing modified libraries
-- @ pastebin.com/u/kyomujin

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
  forceFillTo (n)
  for i=1,n do
    while not move() do
      if not dig() then
        --attack fail==bedrock
        if not attack() then return i-1 end
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

local function _dig(detect, dig)
  while detect () do
    dig ()
    if not (dig == turtle.digDown) then
      sleep(0.5)
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

-- Fuel handling --
function hasFuel(x)
 local  fuel = turtle.getFuelLevel()
  if fuel >= x then
   return true
 else
   return false
 end
end

function forceFillTo(x)
  if x ==nil then x = 1 end
  local printIt = true
  while not fillTo(x) do
    if printIt then
      print ("Waiting for more fuel...")
      printIt = false
    end
    sleep (5)
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
        while not hasFuel(x) do
          if not turtle.refuel(1) then break end
        end
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

function sink ()
  while turtle.down () do
    --sinking
  end
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

-- Dig wrappers
function dig ()
  _dig(turtle.detect, turtle.dig)
end

function digDown ()
  _dig(turtle.detectDown, turtle.digDown)
end

function digUp ()
  _dig(turtle.detectUp, turtle.digUp)
end


-- Pattern Interperater
-- prepend a command with a number to run n times
-- e.g: "24f2r107uf" will go 24 fwd 2 right 107 up 1 fwd
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
  ['F'] = dig,
  ['D'] = digDown,
  ['U'] = digUp,
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
  matches = string.gmatch (pattern, "%d*%D")
  
  for match in matches do
    if string.len (match) == 1 then
      actions[match] ()
    else
      --do action multiple times
      reps = tonumber (string.sub (match, 1, -2))
      cmd = string.sub (match,-1,-1)
      if move_actions[cmd] then
        actions[cmd] (reps)
      else
        for i=1, reps do
          actions[cmd] ()
        end
      end
    end
  end
end


function dumpToChest (direction, ...)
  --:extra arguments are used to specify slots to keep
  --:items identical to specified slots are keept as well
  local dropIt = true
  local slots = {}
  local detect = nil
  local drop = nil
  --get direction to excpect chest
  if string.lower(direction)=="f" then
    detect = turtle.detect
    drop = turtle.drop
  elseif string.lower(direction)=="u" then
    detect = turtle.detectUp
    drop = turtle.dropUp
  else
    detect = turtle.detectDown
    drop = turtle.dropDown
  end
  
  --get forbidden slots
  for _, slot in ipairs(arg) do
    slots[slot] = true
  end
  
  local printIt = true
  while not detect() do
    if printIt then
      print("place a chest under the turtle to deposit items")
      printIt = false
    end
    sleep(5)
  end
  
  
  for i=1,16 do
    --skip all forbidden slots
    if not slots[i] then
      turtle.select(i)
      if (turtle.getItemCount(i) > 0) then
        --Check if selected item corresponds to a forbidden item
        dropIt = true
        for _, slot in ipairs(arg) do
          if turtle.compareTo(slot) then
            dropIt = false
            break
          end
        end
        
        if dropIt then
          printIt=true
          while not drop() do
            if printIt then
              print("Chest is full")
              printIt = false
            end
            sleep(5)
          end
        end
        
      end --getItemCount
    end --slots
  end
  
end

-- vim: ft=lua sw=2 ts=2 sts=2
