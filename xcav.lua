--0.2.0
--
-- Xcavate
-- by k47
--
-- The turtle will bore 3 layers at a time.
-- The turtle will refuel itself periodically.
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
local length = 0
local width = 0
local depth = 0
local function descend(d)
  kurtle.down(d)
  turtle.digDown()
end
local function bore()
  descend(2)
  for d=1,depth do
    for w=1,width do
      for l=1,length-1 do
        kurtle.fwd()
        turtle.digUp()
        turtle.digDown()
      end
      if w==width then break end
      kurtle.uturn(w)
      kurtle.fwd()
      turtle.digUp()
      turtle.digDown()
      kurtle.uturn(w)
    end
    if d==depth then break end
    descend(3)
    if width % 2 == 0 then
      kurtle.right()
    else
      kurtle.left(2)
    end
  end
end
local function home()
  if width%2==0 then
    if depth%4==0 then
      kurtle.right()
    elseif depth%4==1 then
      kurtle.right()
      kurtle.fwd(width-1)
      kurtle.right()
    elseif depth%4==2 then
      kurtle.right()
      kurtle.fwd(length-1)
      kurtle.right ()
      kurtle.fwd (width-1)
      kurtle.right ()
    elseif depth%4==3 then
      kurtle.back (length-1)
    end
  else
    if depth%2==0 then
      kurtle.left(2)
    elseif depth%2==1 then
      kurtle.left()
      kurtle.fwd(width-1)
      kurtle.left ()
      kurtle.fwd (length-1)
      kurtle.left (2)
    end
  end
  kurtle.down()
end

--Arguments--
local argv = {...}
if #argv ~= 3 then
  print ("Usage: xcav <length> <width> <depth>")
  return 2
else
  length = tonumber (argv[1])
  width = tonumber (argv[2])
  depth = tonumber (argv[3]) / 3
end

--Main--
bore()
home()

-- vim: ft=lua ts=2 sts=2 sw=2