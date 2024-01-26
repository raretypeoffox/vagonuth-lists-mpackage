-- Alias: remind me
-- Attribute: isActive

-- Pattern: ^(?i)say remind me$

-- Script Code:
AltList.GivenAllegRuby = true
send("say remind me", false)

local wait = tonumber(gmcp.Char.Vitals.lag)
local char_name = AltList.GetCharName()

wait = wait + 3


if AltList.RemindMeTimer then killTimer(AltList.RemindMeTimer); AltList.RemindMeTimer = nil end
AltList.RemindMeTimer = tempTimer(wait, function() if AltList.GivenAllegRuby and AltList.GetCharName() == char_name then AltList.GivenAllegRuby = false end; end)

registerAnonymousEventHandler("sysDisconnectionEvent", function() if AltList.RemindMeTimer then killTimer(AltList.RemindMeTimer); AltList.RemindMeTimer = nil end; end, true)

-- To Review: there was a bug in this before the event handler, ie, character does a remind me, relogs in with another character quickly and gives a ruby and the timer turns off AltList.GivenAllegRuby before the clue is given
-- The event handler is meant to fix this, ie, killing the timer on a disconnect/reconnect
-- To confirm in the future if this fixes the bug