-- Trigger: Welcome Back 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Welcome( back)? to the AVATAR System(, Hero|, Lord|, Lady)? (?<charname>\w+)

-- Script Code:
AltList.LoginName = string.lower(matches.charname):gsub("^%l", string.upper)
InventoryList.LoginName = string.lower(matches.charname):gsub("^%l", string.upper)

--sendGMCP("Char.Group.List")
--sendGMCP("Char.Status")
--sendGMCP("Char.Vitals")

if AltList.TimeZone == 0 then tempTimer(5, function() send("time"); end); end
if not AltList.Chars[AltList.LoginName] then
  print("\n")
  printGameMessage("InvMgmt", "Running info collection commands on first login (" .. AltList.LoginName .. ")")
  printGameMessage("InvMgmt", "Please wait 10 seconds before logging in with a different alt")
  printGameMessage("InvMgmt", "Type ihelp for a full list of commands")  
  tempTimer(5, function() send("score" .. getCommandSeparator() .. "worth" .. getCommandSeparator() .. "questpoints" .. getCommandSeparator() .. "insig", false); end)
  tempTimer(10, function() printGameMessage("InvMgmt", "Info collected, thank you!") end)
  
  AltList.WelcomeTimer = AltList.WelcomeTimer or nil

  local function killWelcomeTimer()
    if AltList.WelcomeTimer then
      killTimer(AltList.WelcomeTimer)
    end
  end
  killWelcomeTimer()
  
  AltList.WelcomeTimer = tempTimer(5, function()
    InventoryList.UpdateItems("inv", false)
  end)
  
  registerAnonymousEventHandler("sysDisconnectionEvent", killWelcomeTimer, true)
end







