--0.1.0
--
--  house
--  by Kyomujin
--
-- Builds floor, roof and walls
-- Default height is 5
-- Floor will be placed below the turtle's level
-- 

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

--Declares--
local length = 0
local width = 0
local height = 0
local height_wall = 0


--Arguments--
local argv = {...}
if # argv ~= 2 then
  print("Usage: builder <length> <width> <height>")
  return 2
else
  length = tonumber(argv[1])
  width = tonumber argv[2])
  if # argv == 3 then
    height = tonumber(argv[3])
  else
    height = 5
  end
end

--:check if valid arguments
if length < 3 or width < 3 or height < 3 then
  print("all dimensions must be higher than 3")
  return 2
end



function wall(_length, _height)
  --: place first block
  kbuild.refPlace()
  for h=1, _height do
    for l=1, _length-1 do
      kurtle.fwd()
      kbuild.refPlace()
    end
    
    --:if finishing platform break
    if w==_width then break end
    --:goto next level of wall
    kurtle.patt("u2r")
    kbuild.refPlace()
  end
end

function platform(_length, _width)
  --:place first block
  kbuild.refPlace()
  for w=1, _width do
    for l=1, _length-1 do
      kurtle.fwd()
      kbuild.refPlace()
    end
    
    --:if finishing platform break
    if w==_width then break end
    kurtle.uturn(w)
    kurtle.fwd()
    kurtle.uturn(w)
  end
end

function returnPlatform(_length, _width)
  if _width % 2 == 1 then
    kurtle.right(2)
    kurtle.fwd(_length-1)
  end
  kurtle.right()
  kurlte.fwd(_width-1)
end


--Main--
platform(length, width)

--:Return to start of build
returnPlatform(length, width)
kurtle.right()

--:start building walls
height_wall = height - 2
for w=1, 4 do
  wall(length-1, height_wall)
  
  --:goto start of next wall or roof
  if height_wall % 2 == 0 then
    kurtle.right(2)
    kurtle.fwd(length-2)
  end
  kurtle.patt("fr")
  kurtle.down(height_wall)
end

--:build roof
platform(length, width)

--:return to start
returnPlatform(length, width)
kurtle.patt("lf")
kurtle.down(height-1)