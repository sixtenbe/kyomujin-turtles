-- 1.0.0
--
-- Startup for disk drive
-- Will copy library and programs to connected turtles
--

--:copy wrapper that deletes the target file if neeeded
local function copy(source, target)
  if fs.exists(target) and not fs.isDir(target) then
    fs.delete(target)
  end
  
  if not fs.exists(source) then
    print("Source is missing, fix it")
    return false
  
  fs.copy(source, target)
  return true
end

--Declares--
local fileList=nil
local dest=""



--Main--
--:check if previous files exits
if fs.exists("lib") or fs.exists("prog") or fs.exists("startup") then
  print("Existing files/folders found. Overwrite? y/n")
  if not string.lower(read()) == "y" then
    print("aborting on user request")
    return false
  end
end

--:get turtle startup
if not copy("disk/startupTurtle", "startup") then return false end

--:make dirs for files
fs.makeDir("lib")
fs.makeDir("prog")

--:get lib stuff
fileList = fs.list("disk/lib")
for _, file in ipairs(fileList) do
  if not fs.isDir(file) then
    dest = string.format("lib/%s", fs.getName(file))
    if not copy(file, dest) then return false end
  end
end

--:get programs
fileList = fs.list("disk/prog")
for _, file in ipairs(fileList) do
  if not fs.isDir(file) then
    dest = string.format("prog/%s", fs.getName(file))
    if not copy(file, dest) then return false end
  end
end


--:end by adding lib folders to path
path = shell.path()
path = path..":/disk/lib/:/lib/"
shell.setPath (path)