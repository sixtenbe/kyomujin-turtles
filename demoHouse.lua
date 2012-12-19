--1.0.1
--
--  demoHouse
--  by Kyomujin
--
-- Tears down a house
-- Default height is 5
-- 
-- 

--Includes--

local libs = {"kurtle", "builder"}
local lib = ""
for index, lib in  ipairs(libs) do
  path=shell.resolveProgram(lib)
    if path==nil or not os.loadAPI(path) then
      print(string.format("Can't load library: %s", lib))
      return false
    end
end

--Declares--
local length = 0
local width = 0
local height = 0
local heightWall = 0
local lengthWall = 0
local blocksNeeded = 0


--Arguments--
local argv = {...}
if # argv < 2 then
  print("Usage: demoHouse <length> <width> <height>")
  return false
else
  length = tonumber(argv[1])
  width = tonumber (argv[2])
  if # argv == 3 then
    height = tonumber(argv[3])
  else
    height = 5
  end
end

--:check if arguments are valid
if length < 3 or width < 3 or height < 3 then
  print("all dimensions must be higher than 3")
  return false
end

heightWall = height - 2


--Main--
builder.demoPlatform(length, width)
builder.gotoStartPlatform(length, width)
--:take down walls
kurtle.up(2)
for w=1, 4 do
  if w % 2 == 1 then
    lengthWall = length-1
  else
    lengthWall = width-1
  end
  builder.demoWall(lengthWall, heightWall)
  
  --:goto start of next wall or roof
  builder.gotoEndWall(lengthWall, heightWall, true)
  kurtle.patt("fr")
  --:don't go down if last wall
  if w==4 then break end
  kurtle.down(heightWall-3)
end
--:take down roof
if heightWall < 3 then
  kurtle.up(heightWall - 1)
else
  kurtle.up(2)
end
builder.demoPlatform(length, width)
--:return to start
builder.gotoStartPlatform(length, width)
kurtle.patt("2lf")
kurtle.down(height-1)

return true
