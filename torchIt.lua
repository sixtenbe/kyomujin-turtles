--1.1.0
--
--  torchIt
--  by Kyomujin
--
-- Places torches on a flat floor in a 5x5 pattern
-- lays torches to its right and forward
-- Use -1 to autodetect
-- 
-- Needs kurtle 0.5.2 or later
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
local width = 0
local space = 5 --:spacing between torches
local detectL = false
local detectW = false


--Arguments--
local argv = {...}
if # argv ~= 2 then
  print("Usage: torchIt <length> <width>")
  return 2
end
--:store commands
length = tonumber (argv[1])
width = tonumber (argv[2])

--Autodect dimension func--
local function detectDimension()
  _length = 0
  
  while turtle.forward() do
    _length = _length + 1
  end
  
  --:go to where last torch should be
  kurtle.back(_length%5)
  
  return _length
end

--:goto ground level
kurtle.sink()


--:check if autodetect is desired
if length==-1 or width==-1 then
  if length == -1 then
    detectL = true
    length = detectDimension()
    print("length detected as: ".. length)
  end
  
  if width == -1 then
    detectW = true
    kurtle.right()
    width = detectDimension()
    print("width detected as: ".. width)
  end
  
  --:detect needed rotation and swap length/width if needed
  if detectL == not detectW then
    --:swap length/width
    tmp = length
    length = width
    width = tmp
    tmp = nil
    
    if detectW then
      --:turn right 1 extra
      kurtle.right()
    end
  end
  --:will at least go 1 right
  kurtle.right()
end


--:get rows/coulumns to place
length = math.floor(length / space) + 1
width = math.floor(width / space) + 1


--Main--
kurtle.sink()
turtle.select(1)
--if block isn't a torch go up 1
if not turtle.compareDown() then
  kurtle.up ()
end

--:in position start placing torches
for w=1,width do
  print(string.format ("Laying lane %d of %d", w, width))
  kbuild.refPlace ()
  
  for l=1,length-1 do
    kurtle.fwd (space)
    kbuild.refPlace ()
  end --length
  --:break if placed last lane
  if w==width then break end
  --:goto next lane of torch laying
  kurtle.uturn(w)
  kurtle.fwd(space)
  kurtle.uturn(w)
end --width

-- vim: ft=lua ts=2 sts=2 sw=2