
local talonPath = "../../../Talon/bin/x86/Debug/"

--
-- Project "Rob" game
--
project "ProjectRob"
    uuid        "0A68D736-1AB3-4980-AB48-6F8DCDD9D148"
	targetname  "ProjectRobGame"
	language    "C++"
	kind        "WindowedApp"
	flags       { "FatalWarnings", "WinMain" }
	links 		{ "Talon" }

    includedirs {
        "./",
        "../../../Talon/include/"
    }

    libdirs {
    	talonPath
	}

	files {
		"*.cpp",
        "*.h"
	}

    local copyCommands = copy_cmd("Resources/*", "Resources")
    
    if (os.is("Windows")) then
    	copyCommands = copyCommands .. copy_cmd(path.getabsolute(talonPath .. "*.dll"))
    	copyCommands = copyCommands .. copy_cmd(path.getabsolute(talonPath .. "*.pdb"))
    	copyCommands = copyCommands .. copy_cmd(path.getabsolute(talonPath .. "*.pak"))
    	copyCommands = copyCommands .. copy_cmd(path.getabsolute(talonPath .. "awesomium_process.exe"))
    	copyCommands = copyCommands .. copy_cmd(path.getabsolute(talonPath .. "Resources/*", "Resources"))
    end

    -- Configuration
    configuration {}
        postbuildcommands { copyCommands }

    configuration "MacOSX"
        files {
            "Mac/**"
        }
        linkoptions { "-stdlib=libc++" }