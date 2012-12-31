--  0.1.0
--
--  stair
--  by Kyomujin
--
--  Will dig a stairwell up or down
-- 

--Includes--

local libs = {"kurtle", "kbuild", "builder"}
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
local direction = ""
local pattern = ""


--Arguments--
local argv = {...}
if # argv ~= 2 then
  print("Usage: stair <length> <direction [d|down|u|up]>")
  return false
end
--:store arguments
length = tonumber (argv[1])
direction = argv[2]


--main--
local goUp = "UfFu"
local goDown = "DfFd"

direction = builder.getDir(direction)
if direction=="u" then
  pattern = goUp
elseif direction=="d" then
  pattern = goDown
else
  print("invalid direction argument")
  return false
end

for i=1, length do
  kurtle.patt(pattern)
end

return true
