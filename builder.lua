-- 1.0.3
--
-- Kyomujin Building function Library
-- Library for building standard structures
-- like walls and platforms
--
-- See readme for installing libraries
-- @ pastebin.com/u/kyomujin



--Includes--
--[[
these libs needs to be loaded by the
startup on the turtle before builder
is loaded

local libs = {"kurtle", "kbuild"}
local lib = ""
for _, lib in  ipairs(libs) do
  path=shell.resolveProgram(lib)
  if path==nil or not os.loadAPI(path) then
    print(string.format("Can't load library: %s", lib))
  end
end
]]--
  
--private function--
function getDir(direction)
  local dirList = {
    ["right"] = "r",
    ["left"] = "l",
    ["up"] = "u",
    ["down"] = "d",
    
    ["r"] = "r",
    ["l"] = "l",
    ["u"] = "u",
    ["d"] = "d"
  }
  
  direction = dirList[string.lower(direction)]
  if direction==nil then
    print("invalid direction")
    return false
  end
  return direction
end

function getDirINV(direction)
  local dirListINV = {
    ["r"] = "l",
    ["l"] = "r",
    ["u"] = "d",
    ["d"] = "u"
  }
  direction = dirListINV[string.lower(direction)]
  if direction==nil then
    print("invalid direction")
    return false
  end
  return direction
end

--Functions for handling the movement of some build/demo functions
local function movePlatformOct(side, center, action)
  local diam = (side-1) * 3 + 1
  local length = side
  local grow = 2
  local static = 0
  local shrink = 0-2
  local change = grow
  
  if center==nil then center=true end
  
  --:goto start and place/break first block
  kurtle.fwd(side-1)
  if center then
    kurtle.left()
    kurtle.fwd(side + math.floor((side/2)) - 1)
    kurtle.right()
  end
  
  
  action()
  for d=1, diam do
    for l=1, length-1 do
      kurtle.fwd()
      action()
    end
    --:detect growth/shrinkage
    if (change==grow) and (length == diam) then
      change = static
    elseif (change==static) and (d==(side*2-1)) then
      change = shrink
    end
    
    length = length + change
    
    
    --:if finishing platform break
    if d==diam then break end
    --:if statements to handle growth/shrinkage of platform
    if change==grow then
      kurtle.fwd()
    end
    kurtle.uturn(d)
    kurtle.fwd()
    kurtle.uturn(d)
    if change==shrink then
      kurtle.fwd()
    end
    action()
  end
  
  return true
end


--building functions--
function wall(length, height)
  --: place first block
  kbuild.refPlace()
  for h=1, height do
    for l=1, length-1 do
      kurtle.fwd()
      kbuild.refPlace()
    end
    
    --:if finishing wall break
    if h==height then break end
    --:goto next level of wall
    kurtle.patt("u2r")
    kbuild.refPlace()
  end
  
  return true
end

function wallDiag(length, height, direction)
  --:build a diagional wall
  --:should diagional be fwd to the right or the left
  dir1 = getDir(direction)
  if dir1 == false then return false end
  dir2 = getDirINV(dir1)
  
  --: place first block
  kbuild.refPlace()
  for h=1, height do
    for l=1, length-1 do
      --:will go either fwd, right, fwd, left
      --:or fwd, left, fwd, right
      kurtle.patt(string.format("f%sf%s", dir1, dir2))
      kbuild.refPlace()
    end
    
    --:if finishing wall break
    if h==height then break end
    --:goto next level of wall
    kurtle.patt("u2r")
    kbuild.refPlace()
  end
  
  return true
end

function platform(length, width)
  --:place first block
  kbuild.refPlace()
  for w=1, width do
    for l=1, length-1 do
      kurtle.fwd()
      kbuild.refPlace()
    end
    
    --:if finishing platform break
    if w==width then break end
    kurtle.uturn(w)
    kurtle.fwd()
    kurtle.uturn(w)
    kbuild.refPlace()
  end
  
  return true
end


function platformOct(side, center)
  return movePlatformOct(side, center, kbuild.refPlace)
end



--Demolish structures--
function demoPlatform(length, width)
  turtle.digDown()
  for w=1, width do
    for l=1, length-1 do
      kurtle.fwd()
      turtle.digDown()
    end
    
    --:if last row break
    if w==width then break end
    kurtle.uturn(w)
    kurtle.fwd()
    kurtle.uturn(w)
    turtle.digDown()
  end
  
  return true
end

function demoPlatformOct(side, center)
  return movePlatformOct(side, center, turtle.digDown())
end


function demoWall(length, height)
  --:demolish wall 3 layers a time
  local remainder = height % 3
  height = math.floor(height / 3)
  if height == 0 then
    remainder = 0
    height = 1
  end
  
  kurtle.digUp()
  turtle.digDown()
  
  for h=1, height do
    for l=1, length-1 do
      kurtle.fwd()
      kurtle.digUp()
      turtle.digDown()
    end
    
    --:if finishing wall break
    if h==height then break end
    --:goto next level of wall
    kurtle.patt("3u2r")
    kurtle.digUp()
  end
  
  --:remove remainder
  if remainder > 0 then
    kurtle.up(remainder)
    kurtle.right(2)
    kurtle.digUp()
    for l=1, length-1 do
      kurtle.fwd()
      kurtle.digUp()
      --:no block is below so don't digDown
    end
  end
  
  return true
end

function demoWallDiag(length, height, direction)
  --:demolish a diagional wall
  --:should diagional be fwd to the right or the left
  dir1 = getDir(direction)
  if dir1 == false then return false end
  dir2 = getDirINV(dir1)
  
  --:demolish wall 3 layers a time
  local remainder = height % 3
  height = math.floor(height / 3)
  if height == 0 then
    remainder = 0
    height = 1
  end
  
  kurtle.digUp()
  turtle.digDown()
  for h=1, height do
    for l=1, length-1 do
      --:will go either fwd, right, fwd, left
      --:or fwd, left, fwd, right
      kurtle.patt(string.format("f%sf%s", dir1, dir2))
      kurtle.digUp()
      turtle.digDown()
    end
    
    --:if finishing wall break
    if h==height then break end
    --:goto next level of wall
    kurtle.patt("3u2r")
    kurtle.digUp()
  end
  
  --:remove remainder
  if remainder > 0 then
    kurtle.up(remainder)
    kurtle.right(2)
    kurtle.digUp()
    for l=1, length-1 do
      kurtle.patt(string.format("f%sf%s", dir1, dir2))
      kurtle.digUp()
      --:no block is below so don't digDown
    end
  end
end

--Goto start of a build--
--:will not move in the vertical plane
--:will face same direction as when build function started
function gotoStartPlatform(length, width)
  if width % 2 == 1 then
    kurtle.right(2)
    kurtle.fwd(length-1)
  end
  kurtle.right()
  kurtle.fwd(width-1)
  kurtle.right()
end


function gotoStartWall(length, height, wasDemo)
  if wasDemo then
    --:okey goto start of DemoWall instead of build
    height = math.ceil(height / 3)
  end
  if height == 0 then height = 1 end
  if height % 2 == 1 then
    kurtle.right(2)
    kurtle.fwd(length-1)
  end
  kurtle.right(2)
  
  return true
end

function gotoStartWallDiag(length, height, direction, wasDemo)
  if wasDemo then
    --:okey goto start of DemoWallDiag instead of build
    height = math.ceil(height / 3)
  end
  if height == 0 then height = 1 end
  --Should this walk diag or is this OK
  if height % 2 == 1 then
    dir = getDir(direction)
    if dir==false then return false end
    kurtle.right(2)
    kurtle.fwd(length-1)
    kurtle.patt(dir)
    kurtle.fwd(length-1)
    kurtle.patt(getDirINV(dir))
  end
  
  return true
end

--Goto end of a build i.e far right--
--:will not move in the vertical plane
function gotoEndPlatform(length, width)
  if height == 0 then height = 1 end
  if width % 2 == 0 then
    kurtle.right(2)
    kurtle.fwd(length-1)
  end
  
  return true
end


function gotoEndWall(length, height, wasDemo)
  if wasDemo then
    --:okey goto end of DemoWall instead of build
    height = math.ceil(height / 3)
  end
  if height == 0 then height = 1 end
  if height % 2 == 0 then
    kurtle.right(2)
    kurtle.fwd(length-1)
  end
  
  return true
end

function gotoEndWallDiag(length, height, direction, wasDemo)
  if wasDemo then
    --:okey goto end of DemoWallDiag instead of build
    height = math.ceil(height / 3)
  end
  if height == 0 then height = 1 end
  --Should this walk diag or is this OK
  if height % 2 == 0 then
    dir = getDir(direction)
    if dir==false then return false end
    kurtle.right(2)
    kurtle.fwd(length-1)
    kurtle.patt(dir)
    kurtle.fwd(length-1)
    kurtle.patt(getDirINV(dir))
  end
  
  return true
end
