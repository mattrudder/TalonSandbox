--
-- Premake build script for Project "Rob"
--

dofile("scripts/utils.lua")

local localHostName = trim(os.getenv("COMPUTERNAME") or os.outputof("hostname -s"))

if not _OPTIONS["to"] then
	if _ACTION then
		_OPTIONS["to"] = "build/generated/" .. _ACTION
	else
		_OPTIONS["to"] = "build/generated/"
	end
end

if not _OPTIONS["gfx"] then
	if os.is("windows") then
		_OPTIONS["gfx"] = "Direct3D11"
	else
		_OPTIONS["gfx"] = "OpenGL"
	end
end

local talonPath = path.getabsolute("../Talon/build/generated/" .. _ACTION)
if isgeneratoraction(_ACTION) then
	print("ProjectRob projects at " .. _OPTIONS["to"] .. ".")
	print(" - Host System: " .. localHostName .. " (" .. string.format("HOST_%s", string.upper(string.gsub(localHostName, "[^%a%d]", "_"))) .. ")")
	print(" - Graphics: " .. _OPTIONS["gfx"])
	print("Generating Talon projects...")

	local cmd = "premake4 --file=%s --to=%s --gfx=%s %s"

	cmd = string.format(cmd, path.getabsolute("../Talon/premake4.lua"), talonPath, _OPTIONS["gfx"], _ACTION)
	local output = os.outputof(cmd)
end

if _ACTION == "clean" then
	os.rmdir("bin")
	os.rmdir("build")
end

solution "ProjectRob"
	location(_OPTIONS["to"])
	configurations	{ "Release", "Debug" }
	defines 		{ string.format("HOST_%s", string.upper(string.gsub(localHostName, "[^%a%d]", "_"))) }
	flags       	{ "EnableSSE2", "ExtraWarnings", "FloatFast", "Unicode" }
	includedirs		{ "include" }

	configuration "Debug"
		defines "_DEBUG"
		flags { "Symbols" }
		targetdir "bin/x86/Debug"
		
	configuration "Release"
		defines "NDEBUG"
		flags { "OptimizeSpeed" }
		targetdir "bin/x86/Release"

	configuration "MacOSX"
		buildoptions { "-x objective-c++", "-std=c++11", "-stdlib=libc++" }

include "src"

newoption {
	trigger = "to",
	value   = "path",
	description = "Set the output location for the generated files"
}

newoption {
	trigger = "gfx",
	value   = "api",
	description = "Sets the graphics API to use",
	allowed = {
		{ "OpenGL",    "OpenGL" },
		{ "Direct3D11",  "Direct3D 11 (Windows only)" },
	},
	optional = true 
}
