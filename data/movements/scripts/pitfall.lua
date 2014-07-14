function onStepIn(cid, item, topos, frompos)
	if item.itemid == 293 then
		doTransformItem(item.uid, 294)
    end
	
    return true
end