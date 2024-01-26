-- Trigger: Existing Character. 


-- Trigger Patterns:
-- 0 (start of line): Existing Character.

-- Script Code:
sendGMCP("Char.Group.List")
sendGMCP("Char.Status")
sendGMCP("Char.Vitals")

tempTimer(4, function()

  local char_name = string.lower(gmcp.Char.Status.character_name):gsub("^%l", string.upper)

  if char_name == "" then 
  cecho("<yellow>Vagonuth-Inventory-Mgmt error: <white>could not get character name, gmcp returning <red>" .. char_name .. "\n")
  cecho("If this is different than the name you logged in with, try reconnecting to AVATAR\n")
  error("gmcp.Char.Status.character_name not returning character name"); return false; end

  -- Sometimes gmcp.Char.Status bugs out and requires a relog. We can check this against gmcp.Char.Group.List
  for _,Player in ipairs(gmcp.Char.Group.List) do
    if Player.name == char_name then
      return true
    end
  end
  
  cecho("<yellow>Vagonuth-Inventory-Mgmt error: <white>could not get character name, gmcp returning <red>" .. char_name .. "\n")
  cecho("If this is different than the name you logged in with, try reconnecting to AVATAR\n")
  display(gmcp.Char.Group.List)

  error("gmcp.Char.Status is not matching gmcp.Char.Group")
  return false

end)

