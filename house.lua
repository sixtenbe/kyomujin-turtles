--0.1.2
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

local libs = {"kurtle", "kbuild", "builder"}
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
local heightWall = 0
local lengthWall = 0
local blocksNeeded = 0


--Arguments--
local argv = {...}
if # argv < 2 then
  print("Usage: house <length> <width> <height>")
  return 2
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
  return 2
end

--:calculate needed blocks
heightWall = height - 2
blocksNeeded = length * width * 2 
blocksNeeded = blocksNeeded + 2 * (heightWall * (length -1))
blocksNeeded = blocksNeeded + 2 * (heightWall * (width -1))
print(string.format("will use %d blocks", blocksNeeded))


--Main--
builder.platform(length, width)

--:Return to start of build
builder.gotoStartPlatform(length, width)

--:start building walls
kurtle.patt("ur")
for w=1, 4 do
  if w % 2 == 1 then
    lengthWall = length-1
  else
    lengthWall = width-1
  end
  builder.wall(lengthWall, heightWall)
  
  --:goto start of next wall or roof
  builder.gotoEndWall(lengthWall, heightWall)
  kurtle.patt("fr")
  --:don't go down if last wall
  if w==4 then break end
  kurtle.down(heightWall-1)
end

--:build roof
kurtle.up()
builder.platform(length, width)

--:return to start
builder.gotoStartPlatform(length, width)
kurtle.patt("lf")
kurtle.down(height-1)