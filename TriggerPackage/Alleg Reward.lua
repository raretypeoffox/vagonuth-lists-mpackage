-- Trigger: Alleg Reward 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Allegaagse gives you (.*).$

-- Script Code:
printGameMessage("Alleg's reward", matches[2] .. " (" .. AltList.GetCharName() .. ")", "yellow", "white")

