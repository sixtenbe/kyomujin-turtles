--0.1.1
--
--  torchIt
--  by Kyomujin
--
-- Places torches on a flat floor in a 5x5 pattern
-- lays torches to its right and forward
-- 
-- Needs kurtle 0.5.2 or later
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
local space = 5 --:spacing between torches


--Arguments--
local argv = {...}
if # argv ~= 2 then
  print("Usage: torchIt <length> <width>")
  return 2
else
  length = tonumber (argv[1])
  width = tonumber (argv[2])
  
  length = math.floor(length / space)
  width = math.floor(width / space)
end





--Main--
--:goto one block above ground
kurtle.sink ()

kurtle.up ()

--:in position start placing torches
for w=1,length do
  print(string.format ("Laying lane %d of %d", w, length))
  kbuild.refPlace ()
  
  for l=1,width-1 do
    kurtle.fwd (space)
    kbuild.refPlace ()
  end --length
  --:check if we should go to next lane
  if w==length then break end
  --:goto next lane of torch laying
  kurtle.uturn(w)
  kurtle.fwd(space)
  kurtle.uturn(w)
end --width

-- vim: ft=lua ts=2 sts=2 sw=2