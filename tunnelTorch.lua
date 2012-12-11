--1.0.0
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


--Arguments--
local argv = {...}
if # argv ~= 1 then
  print("Usage: tunnelTorch <length>")
  return 2
end
--:store arguments
length = tonumber (argv[1])


--Return funciton
local function gotoStart(dist)
  kurtle.right(2)
  kurtle.fwd(dist-1)
end

local function dropOff()
  kurtle.fwd()
  while not turtle.detectDown() do
    print("place a chest under the turtle to deposit items")
    sleep(5)
  end
  --deposit
  for i=2, 16 do
    turtle.select(i)
    if not turtle.compareTo(1) then
      while not turtle.dropDown() do
        print("Chest is full")
        sleep(5)
      end
    end
  end
  turtle.select(1)
  kurtle.back()
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

--main--
turtle.select(1)
while turtle.getItemCount(1) == 0 do
  print("place torches in slot 1")
  sleep(5)
end
--:start the dig cycle at head height instead of feet
kurtle.up()
turtle.select(1)

for l=1, length do
  --:check inventory and dropp off if needed
  if not checkInvSpace() then
    gotoStart(l)
    dropOff()
    gotoStart(l)
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
dropOff()