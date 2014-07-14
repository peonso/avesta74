function onUse(cid, item, frompos, item2, topos)
	npos = {x = frompos.x, y = frompos.y, z = frompos.z}
	if (item.itemid == LADDER) then
		npos.y = npos.y + 1
		npos.z = npos.z - 1
	else
		npos.z = npos.z + 1
	end
	
	doTeleportThing(cid, npos)
	return true
end