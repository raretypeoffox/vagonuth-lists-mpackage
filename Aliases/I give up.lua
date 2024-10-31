-- Alias: I give up
-- Attribute: isActive

-- Pattern: ^(?i)(say I give up|igu|giveup)$

-- Script Code:
send("say I give up", false)

-- Try to make sure Alleg actually "hears" our "I give up" (ie he's not dealing with another player)
safeTempTrigger("AllegGiveUpTrig", "Allegaagse says 'Now go away. Maybe I will see if you can be useful some other time.'", function()
  AltList.AllegRecordGiveUp()
  print("\n")
  AltList.ReportNextAvailableAlleg()
end, "begin", 1)

safeTempTimer("AllegGiveUpKillTrig", 10, function() safeKillTrigger("AllegGiveUpTrig") end)


