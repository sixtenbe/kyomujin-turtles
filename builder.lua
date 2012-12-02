--0.9.0
--
-- Kyomujin Building function Library
-- Library for building standard structures
-- like walls and platforms
--



--Includes--

local libs = {"kurtle", "kbuild"}
local lib = ""
for index, lib in  ipairs(libs) do
  path=shell.resolveProgram(lib)
    if path==nil or not os.loadAPI(path) then
      print(string.format("Can't load library: %s", lib))
    end
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
    kurtle.fwd(lengthWall-1)
  end
end

--Goto end of a build i.e far right--
--:will not move in the vertical plane
function gotoEndPlatform(length, width)
  if width % 2 == 0 then
    kurtle.right(2)
    kurtle.fwd(length-1)
  end
end


function gotoEndWall(length, height)
  if height % 2 == 0 then
    kurtle.right(2)
    kurtle.fwd(lengthWall-1)
  end
end