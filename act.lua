-- 1.0.0
--
--  move
--  by Kyomujin
--
-- Sends argument to the kurtle.patt function
-- See the kurtle code for more information
-- 
-- 

--Includes--

local libs = {"kurtle"}
local lib = ""
for index, lib in  ipairs(libs) do
  path=shell.resolveProgram(lib)
    if path==nil or not os.loadAPI(path) then
      print(string.format("Can't load library: %s", lib))
      return false
    end
end

--Declares--
local movePattern = ""
local row = 0
local commandKey = {
  ['f'] = "fwd",
  ['b'] = "back",
  ['u'] = "up",
  ['d'] = "down",
  ['l'] = "left",
  ['r'] = "right",
  ['F'] = "dig",
  ['D'] = "digDown",
  ['U'] = "digUp",
  ['-'] = "place",
  ['_'] = "placeDown",
  ['^'] = "placeUp"
}



--Arguments--
local argv = {...}
if # argv ~= 1 then
  print("Usage: act <pattern>")
  print("For pattern guide type: act help")
  return false
end

movePattern = argv[1]

if string.lower(movePattern) == "help" then
  print("format of key table:")
  print("key: command")
  for key, command in pairs(commandKey) do
    print(key..": "..command)
    row = row + 1
    if row % 7 == 0 then
      print("press enter to continue")
      os.pullEvent("key")
    end
  end
  print("Each key can be prepended with a number to run the command n times")
  print("exampel pattern: 2ru11frfr11f")
  return nil
end

kurtle.patt(movePattern)
