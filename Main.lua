-- This is the script that literally just loads it from github just in case I make an update to the main script, it will auto update
-- PREFIX IS -

local success, err = pcall(function()
    loadstring(
        game:HttpGet("https://raw.githubusercontent.com/SecretSupply/BoogaAdmin/main/Script.lua")
    )()
end)
if not success then return warn("Error while loading booga admin.", err) end
print("\nWelcome to Booga Admin.\nCreated by SecretSupply#6929.\nPrefix is -\nEnjoy!")
