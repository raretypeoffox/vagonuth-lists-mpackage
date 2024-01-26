-- Trigger: Bank deposit 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\w+, you deposit \d+ coins( and gemstones)?. Your account now has (?<bank>\d+) coins.$
-- 1 (regex): ^has a total of (?<bank>\d+) coins in it.$
-- 2 (regex): ^(account )?which now totals (?<bank>\d+) coins.$

-- Script Code:
sendGMCP("Char.Status")

local gold = matches.bank 

-- give gmcp.Char.Status.gold 2 seconds to update itself
tempTimer(2, function()
  gold = gold + (tonumber(gmcp.Char.Status.gold) or 0)
  AltList.UpdateGold(gold)
end)
