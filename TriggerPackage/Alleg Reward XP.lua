-- Trigger: Alleg Reward XP 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (exact): Allegaagse says 'Here is something for your trouble.'
-- 1 (regex): ^You have received an award of (\d+) experience points!$

-- Script Code:

local reward_xp = multimatches[2][2]

printGameMessage("Alleg's reward", "XP: " .. reward_xp .. " (" .. AltList.GetCharName() .. ")", "yellow")