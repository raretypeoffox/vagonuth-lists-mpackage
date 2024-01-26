-- Trigger: Worship 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You are \d+ years old \(\d+ real life hours?\) and a (?<devoted>devoted worshipper|worshipper) of (?<worship>.*).$

-- Script Code:
AltList.UpdateWorship(matches.worship, (matches.devoted == "devoted worshipper" and true or false))
