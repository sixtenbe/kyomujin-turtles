--
-- Startup for turtle
-- loads the lib folder to the path
--
path = shell.path()
path = path..":/disk/lib/:/lib/"
shell.setPath (path)


--Load libraries to api
--Should actually keep libraries loaded
--Making it possible call lib from lua prompt

local libs = {"kurtle", "kbuild", "builder"}
local lib = ""
for index, lib in  ipairs(libs) do
  path=shell.resolveProgram(lib)
    if path==nil or not os.loadAPI(path) then
      print(string.format("Can't load library: %s", lib))
    end
end