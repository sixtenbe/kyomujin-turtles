-- 1.0.1
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
local function getDir(direction)
  local dirList = {
    ["right"] = "r",
    ["left"] = "l",
    
    ["r"] = "r",
    ["l"] = "l"
  }
  
  direct = dirList[string.lower(direction)]
  if direct==nil then
    print("invalid direction")
    return false
  end
  return direct
end

local function getDirINV(direction)
  local dirListINV = {
    ["r"] = "l",
    ["l"] = "r"
  }
  direct = dirListINV[string.lower(direction)]
  if direct==nil then
    print("invalid direction")
    return false
  end
  return direct
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

--Demolish structures--
function demoPlatform(length, width)
  turtle.digDown()
  for w=1, width do
    for l=1, length-1 do
      kurtle.fwd()
      if turtle.detectDown() then
        turtle.digDown()
      end
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
  if height == 0 then height = 1 end
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
