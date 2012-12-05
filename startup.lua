-- 1.0.3
--
-- Startup for disk drive
-- Will copy library and programs to connected turtles
--

--:copy wrapper that deletes the target file if needed
local function copy(source, target)
  if fs.exists(target) and not fs.isDir(target) then
    fs.delete(target)
  end
  
  if not fs.exists(source) then
    print(source.." is missing, fix it")
    return false
  end
  
  fs.copy(source, target)
  return true
end

--Declares--
local fileList=nil
local dest=""
local src=""
local dirList = {
  ["disk/lib"] = "lib",
  ["disk/prog"] = "prog"
}



--Main--
--:check that startup is being run on a turtle
if turtle==nil then
  return nil
end
--:check if previous files exits
if fs.exists("lib") or fs.exists("prog") or fs.exists("startup") then
  print("Existing files/folders found. Overwrite? y/n")
  if not string.lower(read()) == "y" then
    print("aborting on user request")
    return false
  end
end

--:get turtle startup
print("copying startup")
if not copy("disk/startupTurtle", "startup") then return false end
print("copying install, for possible use")
if not copy("disk/install", "install") then return false end

--:make dirs for files
fs.makeDir("lib")
fs.makeDir("prog")

--:get lib and programs
for srcDir, destDir in pairs(dirList) do
  fileList = fs.list(srcDir)
  for _, file in ipairs(fileList) do
    src = fs.combine(srcDir, file)
    if not fs.isDir(src) then
      print("copying "..file)
      dest = fs.combine(destDir, file)
      
      if not copy(src, dest) then return false end
    end
  end
  
end


--:end by adding lib folders to path
path = shell.path()
path = path..":/disk/lib/:/lib/"
shell.setPath (path)

print("finished")