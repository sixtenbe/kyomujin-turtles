--
-- Startup for turtle
-- loads the lib folder to the path
--
path = shell.path()
path = path..":/disk/lib/:/lib/"
--add programs to path to run from anywhere
path = path..":/prog/"
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
      return false
    end
end