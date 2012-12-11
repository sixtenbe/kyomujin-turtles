Kyomujin-Turtles
A turtle library for the minecraft mod ComputerCraft.

Installing my library and my programs is incredibly easy.

There are 2 possible work flows for installing the library and I recommend option 1.


Option 1.
Get a computer and connect this to a disk drive with a disk inserted in it.
Download my install script by entering the following commands:

pastebin get kV8masLW install
install

This script will detect the disk and download the libraries and programs to it and if existing files are discovered you will be prompted about a overwrite.

You now have a automatic install station for all your turtles.
To install to a turtle simply place a turtle next to the disk drive and the needed files will automatically be copied and if existing files are discovered you will be prompted about a overwrite.
In addition to all the programs the install script is also copied to the turtle if you ever need to update the code, but don't want to bring it to the station. When in the root directory of your turtle simply type:
install
and it will update the library/programs from pastebin

Option 2.
Here we use the same script as in option 1 but instead of installing it to a disk, we install it directly to a turtle. To install run the following commands:

pastebin get kV8masLW install
install

You might be prompted about a overwrite.


For running the programs you must first navigate to the created prog folder by typing:

cd prog

To list all the available programs type: "ls" and entering the name of a program should show the available arguments.

It is also possible to directly interface with the kurtle, kbuild and builder libraries from the lua interpreter and perform some interactive programming. e.g. typing "builder.platform(5,7)" in lua will make the turtle build a 5 by 7 platform.