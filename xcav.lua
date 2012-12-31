-- 0.3.1
--
-- Xcavate
-- by k47
-- modfied by kyomjin
--
-- The turtle will bore 3 layers at a time.
-- The turtle will refuel itself periodically.
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
local depth = 0
local useEnder = false

--Arguments--
local argv = {...}
if #argv < 3 then
  print ("Usage: xcav <length> <width> <depth> <enderchest (def:false)>")
  return false
else
  length = tonumber (argv[1])
  width = tonumber (argv[2])
  depth = math.floor( tonumber (argv[3]) / 3 )
end

if # argv == 4 then
  useEnder = (string.lower(argv[4])=="true")
end


--Code for handling droppoff sequences--
local function checkInvSpace()
  for i=1, 16 do
    if turtle.getItemCount(i) == 0 then
      return true
    end
  end
  --:if here, no free slot was found
  return false
end


local function gotoStart(_length, _width, vert)
  kurtle.up(vert)
  
  if _width % 2 == 1 then
    kurtle.right(2)
    kurtle.fwd(_length-1)
  else
    kurtle.fwd(length - _length)
  end
  
  kurtle.right()
  kurtle.fwd(_width-1)
  kurtle.left()
end

local function gotoEnd(_length, _width, vert)
  kurtle.right()
  kurtle.fwd(_width-1)
  kurtle.left()
  
  if _width % 2 == 0 then
    kurtle.fwd(length - _length)
    kurtle.right(2)
  else
    kurtle.fwd(_length-1)
  end
  
  kurtle.down(vert)
end

local function normalDropOff(_length, _width, _depth)
  local vert = (_depth-1) * 3 + 2
  
  gotoStart(_length, _width, vert)
  
  kurtle.patt("uf")
  kurtle.dumpToChest("d")
  kurtle.patt("2rfd")
  
  gotoEnd(_length, _width, vert)
end

local function enderDropOff()
  turtle.digUp()
  turtle.select(16)
  turtle.placeUp()
  
  kurtle.dumpToChest("u")
  
  turtle.select(16)
  turtle.digUp()
end


local function fuelCheck(_length, _width, _depth)
  local vert = (_depth-1) * 3 + 2
  
  if not kurtle.fillTo(300) then
    gotoStart(_length, _width, vert)
    kurtle.right(2)
    kurtle.forceFillTo(3000)
    gotoEnd(_length, _width, vert)
  end
end


--mining code--
local function descend(d)
  d = kurtle.down(d)
  turtle.digDown()
  return d
end


local function bore()
  local offset=0
  
  descend(2)
  for d=1,depth do
    for w=1,width do
      for l=1,length-1 do
        if not checkInvSpace() then
          if useEnder then
            enderDropOff()
          else
            normalDropOff(l, w, d)
          end
        end
        --dig cycle
        turtle.select(1)
        kurtle.fwd()
        turtle.digUp()
        turtle.digDown()
      end --length
      --goto next lane
      if w==width then break end
      kurtle.uturn(w+offset)
      kurtle.fwd()
      turtle.digUp()
      turtle.digDown()
      kurtle.uturn(w+offset)
    end --width
    --last level test
    if d==depth then break end
    down = descend(3)
    if down ~=3 then
      --abort abort bedrock found
      kurtle.up(down)
      gotoStart(1,w+1,d)
    end
    
    --solving kurtle.uturn for an even width
    if width % 2 == 0 then
      offset = (offset+1)%2
    end
    
    if d%2==1 then
      w = width
    else
      w = 1
    end
    if w%2==1 then
      l = 1
    else
      l = length
    end
    
    
    fuelCheck(l, w, d+1)
    kurtle.left(2)
  end
end


--Main--
if useEnder then
  local printIt = true
  while turtle.getItemCount(16) == 0 do
    if printIt then
      print("place an enderchest in slot 16")
      printIt = false
    end
    sleep(5)
  end
end
bore()
gotoStart(length, width, depth)

return true

-- vim: ft=lua ts=2 sts=2 sw=2