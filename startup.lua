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
    print(string.format("%s is missing, fix it", source))
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

--:make dirs for files
fs.makeDir("lib")
fs.makeDir("prog")

--:get lib and programs


for srcDir, destDir in pairs(dirList) do
  fileList = fs.list(srcDir)
  for _, file in ipairs(fileList) do
    if not fs.isDir(file) then
      print(string.format("copying %s", file))
      src = string.format("%s/%s", srcDir, file)
      dest = string.format("%s/%s", destDir, file)
      
      if not copy(src, dest) then return false end
    end
  end
  
end


--:end by adding lib folders to path
path = shell.path()
path = path..":/disk/lib/:/lib/"
shell.setPath (path)

print("finished")