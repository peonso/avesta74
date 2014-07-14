function onUse(cid, item, frompos, item2, topos)
	if(topos.x == 0 and topos.y == 0 and topos.z == 0) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return false
	end 
	
	topos.stackpos = 255
	local tmp = getThingFromPos(topos)
	if (tmp.itemid ~= 0) then
		return false
	end
	
	topos.stackpos = 254
	local field = getThingFromPos(topos)
	if (field.itemid ~= 0) then
		return false
	end
	
	newPos = {x = topos.x, y = topos.y, z = topos.z, stackpos = 0}
	groundItem = getThingFromPos(newPos)
	if (isIntegerInArray(ROPE_SPOT, groundItem.itemid)) then
		newPos.y = newPos.y + 1
		newPos.z = newPos.z - 1
		doTeleportThing(cid, newPos)
	elseif (isIntegerInArray(OPENED_HOLE, groundItem.itemid) or isIntegerInArray(OPENED_TRAP, groundItem.itemid) or isIntegerInArray(DOWN_LADDER, groundItem.itemid)) then
		newPos.y = newPos.y + 1
		downPos = {x = topos.x, y = topos.y, z = topos.z + 1, stackpos = 255}
		downItem = getThingFromPos(downPos)
		if (downItem.itemid > 0) then
			doTeleportThing(downItem.uid, newPos)
		else
			doPlayerSendCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		end
	else
		return false
	end
	
	return true
end