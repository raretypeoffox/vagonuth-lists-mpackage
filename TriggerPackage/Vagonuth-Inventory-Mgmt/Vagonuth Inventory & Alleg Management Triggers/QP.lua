-- Trigger: QP 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You have (\d+) quest points?.$

-- Script Code:
AltList.UpdateQP(matches[2])