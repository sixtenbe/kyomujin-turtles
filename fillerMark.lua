--  0.0.1
--
--  fillerMark
--  by Kyomujin
--
--  Will place 3 markers for a filler to mine up
-- 

--Includes--

local libs = {"kurtle", "kbuild"}
local lib = ""
for index, lib in  ipairs(libs) do
  path=shell.resolveProgram(lib)
    if path==nil or not os.loadAPI(path) then
      print("Can't load library: "..lib)
      return false
    end
end

--Declares--
local length = 0
local width = 0 --:spacing between torches
local height = 0

--Arguments--
local argv = {...}
if # argv ~= 3 then
  print("Usage: fillerMark <length> <width> <height>")
  return false
end
--:store arguments
length = tonumber (argv[1])
width = tonumber (argv[2])
height = tonumber (argv[3])


kurtle.forceFillTo((length+width+height) * 2)
--first marker
turtle.digDown()
turtle.placeDown()
--second marker
kurtle.fwd(length-1)
turtle.digDown()
turtle.placeDown()
--third marker
kurtle.right(2)
kurtle.fwd(length-1)
kurtle.left()
kurtle.fwd(width-1)
turtle.digDown()
turtle.placeDown()
--fourth marker
kurtle.right(2)
kurtle.fwd(width-1)
kurtle.up(height-1)
turtle.digUp()
turtle.placeUp()
kurtle.down(height-1)