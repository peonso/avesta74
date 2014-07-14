function onStepOut(cid, item, topos, frompos)
	if(item.actionid == 0) then
		-- This is not a special door
		return true
	end
 
	doRelocate(frompos, {x=frompos.x, y=frompos.y+1, z=frompos.z})
 
	-- Remove any item that was not moved
	-- Happens when there is an unmoveable item on the door, ie. a fire field
	local tmpPos = {x=frompos.x, y=frompos.y, z=frompos.z, stackpos=-1}
	local tileCount = getTileThingByPos(tmpPos)
	local i = 1
	local tmpItem = {uid = 1}
 
	while(tmpItem.uid ~= 0 and i < tileCount) do
		tmpPos.stackpos = i
		tmpItem = getTileThingByPos(tmpPos)
		if(tmpItem.uid ~= item.uid and tmpItem.uid ~= 0) then
			doRemoveItem(tmpItem.uid)
		else
			i = i + 1
		end
	end
 
	doTransformItem(item.uid, item.itemid-1)
	return true
end