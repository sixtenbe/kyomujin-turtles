--1.1.0
--
--  tunnelTorch
--  by Kyomujin
--
--  Will dig a 3x2 (WxH) tunnel and lay torches
--  At least 1 torch must be placed in the first slot
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
local space = 5 --:spacing between torches
local useEnder = false
local enderSlot = 16
local fuel = 0

--Arguments--
local argv = {...}
if # argv < 1 then
  print("Usage: tunnelTorch <length> <useEnderChest (def:false)>")
  return false
end
--:store arguments
length = tonumber (argv[1])
if # argv == 2 then
  useEnder = (string.lower(argv[2])=="true")
end



--Return funciton
local function gotoStart(dist)
  kurtle.right(2)
  kurtle.fwd(dist-1)
end

local function dropOff()
  local stop = 16
  if not useEnder then kurtle.fwd() end
  while not turtle.detectDown() do
    print("place a chest under the turtle to deposit items")
    sleep(5)
  end
  --deposit
  if useEnder then stop = 15 end
  
  for i=2, stop do
    turtle.select(i)
    if (turtle.getItemCount(i) > 0) and (not turtle.compareTo(1)) then
      while not turtle.dropDown() do
        print("Chest is full")
        sleep(5)
      end
    end
  end
  turtle.select(1)
  if not useEnder then kurtle.back() end
end

local function enderDropOff()
  turtle.digDown()
  turtle.select(enderSlot)
  turtle.placeDown()
  
  dropOff()
  
  turtle.select(enderSlot)
  turtle.digDown()
end


local function checkInvSpace()
  for i=2, 16 do
    if turtle.getItemCount(i) == 0 then
      return true
    end
  end
  --:if here, no free slot was found
  return false
end


--:fuel up before going
fuel = length * 3
if not useEnder then
  fuel = fuel + length * 2
end
kurtle.forceFillTo(fuel)



--main--
turtle.select(1)
while turtle.getItemCount(1) == 0 do
  print("place torches in slot 1")
  sleep(5)
end
if useEnder then
  while turtle.getItemCount(enderSlot) == 0 do
    print("place an enderchest in slot "..enderSlot)
    sleep(5)
  end
end
--:start the dig cycle at head height instead of feet
kurtle.up()
turtle.select(1)

for l=1, length do
  --:check inventory and dropp off if needed
  if not checkInvSpace() then
    if useEnder then
      enderDropOff()
    else
      gotoStart(l)
      dropOff()
      gotoStart(l)
    end
  end
  --:dig cycle
  --:left, dig, down, dig, 2right, dig, up, dig, left
  kurtle.patt("lFdF2rFuFl")
  --:check if torch should be placed
  if l%space == 0 then
    kbuild.refPlace()
  end
  --break if tunnel is finnished
  if l==length then break end
  --starting next cycle
  turtle.select(1)
  kurtle.fwd()
end

--return
gotoStart(length)
if useEnder then
  enderDropOff()
else
  dropOff()
end

return true
