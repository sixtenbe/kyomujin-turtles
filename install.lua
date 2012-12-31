-- 1.1.6
--
-- Install
-- Will retrieve library and programs to disk
--


--Some worker functions
local function copy(source, target)
  if fs.exists(target) and not fs.isDir(target) then
    fs.delete(target)
  end
  
  if not fs.exists(source) then
    print( source.." is missing, fix it")
    return false
  end
  
  fs.copy(source, target)
  return true
end


local function pastebinGet(bin, file)
  local h = http.get("http://www.pastebin.com/raw.php?i="..bin)
  if h==nil then
    print("Failed to get pastebin: "..bin)
    return false
  end
  
  local f = fs.open(file, "w")
  f.write(h.readAll())
  h.close()
  f.close()
  return true
end


local function retrievePastes(pastes, folder)
  for key, paste in pairs(pastes) do
    print("retrieving paste: "..key)
    if not pastebinGet(paste, fs.combine(folder, key)) then
      return false
    end
  end
  
  return true
end

local function YesNoQuerry()
  event, key = os.pullEvent("key")
  --:keycode 21 = "y"
  return key == 21
end

--Declare pastebins to use--

local pastesLib = {
  ['kurtle'] = "qY9ipkuZ", 
  ['kbuild'] = "JGTM1u7y",
  ['builder'] = "dj0rgEKG" 
}
local pastesProg = {
  ["act"] = "Q8Us0AG3",
  ["demoHouse"] = "35iXA1sB",
  ["fillerMark"] = "RtkdLfTK",
  ["house"] = "6dC0qzJv",
  ["mixing"] = "S07P4AgA",
  ["pyramid"] = "KE499ChC",
  ["pyramidInv"] = "swmUeQCx",
  ["stair"] = "iLbWEKt1",
  ["torchIt"] = "Z6AZb52p",
  ["tunnelTorch"] = "j3bDAgQ3",
  ["xcav"] = "iUAATh1q"
}

local pastesDisk = {
  ["startup"] = "29N1jFft",
  ["startupTurtle"] = "JyQi6kT6"
}

local dirRoot = "disk"
local dirLib = "disk/lib"
local dirProg = "disk/prog"
local diskExists = true


--Main--
--:check if disk is available
if not fs.exists(dirRoot) then
  --if not turtle abort
  if turtle==nil then
    print("A disk drive with a disk must be connected before running")
    return false
  end
  
  print("Should library be installed to turtle y/n")
  if not YesNoQuerry() then
    print("aborting on user request")
    return false
  end
  diskExists = false
  dirRoot = ""
  dirLib = "lib"
  dirProg = "prog"  
else
  --:check that install is running of disk or copy self to disk
  if shell.dir() ~= dirRoot then
    copy("install", fs.combine(dirRoot, "install"))
  end
end

--:check if files/folders already exist
if fs.exists(dirLib) or fs.exists(dirProg) or fs.exists(fs.combine(dirRoot, "startup")) then
  print("Existing files/folders found. Overwrite? y/n")
  if not YesNoQuerry() then
    print("aborting on user request")
    return false
  end
  print("Files will be overwritten")
end

--:Make lib and program folders
fs.makeDir(dirLib)
fs.makeDir(dirProg)

--:get lib and programs
if not retrievePastes(pastesLib, dirLib) then return false end
if not retrievePastes(pastesProg, dirProg) then return false end
if not retrievePastes(pastesDisk, dirRoot) then return false end

--:for turtles replace startup with startupTurtle
if not diskExists then
  fs.delete("startup")
  fs.move("startupTurtle", "startup")
  print("library installed to turtle")
  --:run the startup turtle script to get it going
  shell.run("/startup")
  return true
end

print("done, to initialize a turtle connect it to this disk drive")

