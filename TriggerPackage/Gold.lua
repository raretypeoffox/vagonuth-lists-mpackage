-- Trigger: Gold 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You have (?<onhand>\d+) gold coins in hand and (?<bank>\d+) gold coins in the bank.$

-- Script Code:
-- You have 38955 gold coins in hand and 2160189 gold coins in the bank.
--^account which now totals (?<bank>\d+) coins.$
local gold = matches.bank + (matches.onhand and matches.onhand or 0)
AltList.UpdateGold(gold)
