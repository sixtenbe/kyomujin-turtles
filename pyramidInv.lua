--0.1.2
--
-- Inverted pyramid Builder
-- based on code by k47  http://pastebin.com/YcSh5SB9
-- modified by Kyomujin
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
local diameter = 0
local limitClean = 0

--Arguments--
local argv = {...}
if # argv ~= 1 then
  print("Usage: pyramidInv <radius>")
  return 2
else
  radius = tonumber (argv[1])
end


--clean pyramid internals--
local function clean()
  turtle.digUp()
  turtle.digDown()
  for w=1,diameter do
    for l=1,diameter-1 do
      kurtle.fwd()
      turtle.digUp()
      turtle.digDown()
    end --length
    if w==diameter then break end
    kurtle.uturn(w)
    kurtle.fwd()
    turtle.digUp()
    turtle.digDown()
    kurtle.uturn(w)
  end --width
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
    kbuild.place ()
    --:Go to the shallow left corner of the lowest ring
    kurtle.up (2)
    kurtle.fwd (1)
    kurtle.right ()
    kurtle.fwd (1)
    kurtle.right ()
    --:run a xcav function to clean internals
    --:only clean every other level
    if radius % 2 == 1 then
      limitClean = radius - 2
    else
      limitClean = radius - 1
    end
    
    for lvl=1, radius-1, 2 do
      diameter = lvl * 2 + 1
      clean ()
      
      if lvl==limitClean then 
        --:return to start position
        kurtle.left ()
        kurtle.fwd (lvl)
        kurtle.right ()
        kurtle.back (lvl)
        --:last level done don't run remainder of loop
        break
      end
      --:get in the shallow left corner of the next level
      kurtle.up (2)
      kurtle.fwd (2)
      kurtle.right ()
      kurtle.fwd (2)
      kurtle.right ()
    end --:lvl
    
    
    --:Return to start block
    --kurtle.up (radius-2)
    --kurtle.right (2)
    break
  end
  kurtle.down ()
  for s=1,4 do -- for each side
    for l=1,(h+1)*-2 do
      kbuild.place ()
      kurtle.fwd ()
    end
    if s==4 then break end
    kurtle.right ()
  end --:sides
  kurtle.back ()
  kurtle.right ()
  kurtle.fwd ()
end --:radius

-- vim: ft=lua ts=2 sts=2 sw=2