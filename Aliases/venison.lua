-- Alias: venison
-- Attribute: isActive

-- Pattern: ^(venison|run-venison)$

-- Script Code:
local cs = getCommandSeparator()
send("recall"..cs.."down"..cs.."west"..cs.."open west"..cs.."west"..cs.."north"..cs.."west"..cs.."open cabinet"..cs.."get venison cabinet"..cs.."east"..cs.."south"..cs.."open east"..cs.."east"..cs.."east"..cs.."south"..cs.."south"..cs.."south"..cs.."south"..cs.."south"..cs.."south"..cs.."south"..cs.."up"..cs.."south"..cs.."west"..cs.."give venison alleg")