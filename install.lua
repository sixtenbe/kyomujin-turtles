-- 1.0.1
--
-- Install
-- Will retrieve library and programs to disk
--


--Some worker functions
--[[
local function pastebinGet(bin, file)
  shell.run("pastebin", "get", bin, file)
end
]]--


local function pastebinGet(bin, file)
  local h = http.get(string.format("http://www.pastebin.com/raw.php?i=%s", bin))
  if h==nil then
    print(string.format("Failed to get pastebin: %s", bin))
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
    print(string.format("retrieving paste: %s", key))
    if not pastebinGet(paste, string.format("%s/%s", folder, key)) then
      return false
    end
  end
  
  return true
end

--Declare pastebins to use--

local pastesLib = {
  ['kurtle'] = "qY9ipkuZ", 
  ['kbuild'] = "JGTM1u7y",
  ['builder'] = "dj0rgEKG" 
}
local pastesProg = {
  ["house"] = "6dC0qzJv",
  ["mixing"] = "S07P4AgA",
  ["pyramid"] = "KE499ChC",
  ["pyramidInv"] = "swmUeQCx",
  ["torchIt"] = "Z6AZb52p",
  ["xcav"] = "iUAATh1q"
}

local pastesDisk = {
  ["startup"] = "29N1jFft",
  ["startupTurtle"] = "JyQi6kT6"
}



--Main--
--:check that script is being run from a disk
if not fs.exists("disk") then
  print("A disk drive with a disk must be connected before running")
  return false
end

--:check if files/folders already exist
if fs.exists("disk/lib") or fs.exists("disk/prog") or fs.exists("disk/startup") then
  print("Existing files/folders found. Overwrite? y/n")
  if not (string.lower(read()) == "y") then
    print("aborting on user request")
    return false
  end
  print("Overwriting")
  --[[
  --:Clear out files and folders
  fs.delete("disk/startup")
  fs.delete("disk/prog")
  fs.delete("disk/prog")
  ]]--
end

--:Make lib and program folders
fs.makeDir("disk/lib")
fs.makeDir("disk/prog")

--:get lib and programs
if not retrievePastes(pastesLib, "disk/lib") then return false end
if not retrievePastes(pastesProg, "disk/prog") then return false end
if not retrievePastes(pastesDisk, "disk") then return false end

print("done, to initialize a turtle connect it to this disk drive")

