--0.1.0
--
-- Pyramid Builder
-- by k47
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
local radius = 0

--Arguments--
local argv = {...}
if # argv ~= 1 then
  print("Usage: pyramid <radius>")
  return 2
else
  radius = tonumber (argv[1])
end

--Main--
--:Mark Center
kbuild.place ()

--:Goto first corner
kurtle.fwd (radius-1)
kurtle.right ()
kurtle.fwd (radius-1)
kurtle.right ()

for h=radius*-1,-1 do
  if h==-1 then
    --:Place the end cap
    kurtle.down ()
    turtle.placeUp ()
    kurtle.down (radius-2)
    kurtle.right (2)
    break
  end
  kurtle.up ()
  for s=1,4 do -- for each side
    for l=1,(h+1)*-2 do
      kbuild.place ()
      kurtle.fwd ()
    end
    if s==4 then break end
    kurtle.right ()
  end
  kurtle.back ()
  kurtle.right ()
  kurtle.fwd ()
end

-- vim: ft=lua ts=2 sts=2 sw=2