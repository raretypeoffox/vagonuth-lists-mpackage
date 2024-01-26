-- Trigger: Pracs 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You need \d+ experience to level and have (\d+) practices.$
-- 1 (regex): 'You have (\d+) practice sessions left.'

-- Script Code:
AltList.UpdatePracs(matches[2])