-- Trigger: Receive QP 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You have received an award of (\d+) quest points!$

-- Script Code:
-- You have received an award of 5 quest points!

local QP = AltList.Chars[AltList.GetCharName()].QP + matches[2]
printGameMessage("QP!", "Received " .. matches[2] .. " QP", "yellow", "white")
AltList.UpdateQP(QP)
