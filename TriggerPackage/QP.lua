-- Trigger: QP 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You have (\d+) quest points?.$
-- 1 (regex): ^You have (\d+) quest points? remaining.$

-- Script Code:
AltList.UpdateQP(matches[2])