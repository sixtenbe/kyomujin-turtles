--
-- Startup for turtle
-- loads the lib folder to the path
--
path = shell.path()
path = path..":/disk/lib/:/lib/"
shell.setPath (path)