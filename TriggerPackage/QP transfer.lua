-- Trigger: QP transfer 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\d+) Quest Points transferred to (\w+) and a fee of 0 quest points were automatically subtracted.$

-- Script Code:
local transferee = GMCP_name(matches[3])

if AltList.PlayerExists(transferee) then
  local transferee_qp = AltList.Chars[transferee].QP or 0
  transferee_qp = transferee_qp + matches[2]
  AltList.UpdateQP(transferee_qp, transferee)
else
  printGameMessage("Debug", "QP transferee not found, never logged in with this package on that alt?")
end