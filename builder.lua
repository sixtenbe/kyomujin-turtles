-- 1.0.0
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



--Goto start of a build--
--:will not move in the vertical plane
function gotoStartPlatform(length, width)
  if width % 2 == 1 then
    kurtle.right(2)
    kurtle.fwd(length-1)
  end
  kurtle.right()
  kurtle.fwd(width-1)
end


function gotoStartWall(length, height)
  if height % 2 == 1 then
    kurtle.right(2)
    kurtle.fwd(length-1)
  end
  
  return true
end

function gotoStartWallDiag(length, height, direction)
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
  if width % 2 == 0 then
    kurtle.right(2)
    kurtle.fwd(length-1)
  end
  
  return true
end


function gotoEndWall(length, height)
  if height % 2 == 0 then
    kurtle.right(2)
    kurtle.fwd(length-1)
  end
  
  return true
end

function gotoEndWallDiag(length, height, direction)
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
