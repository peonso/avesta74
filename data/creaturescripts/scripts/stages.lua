STAGES = {
	{level = 10, rate = 150},
	{level = 25, rate = 100},
	{level = 50, rate = 75},
	{level = 75, rate = 40},
	{level = 100, rate = 20},
	{level = 150, rate = 10}
}

DEFAULT_RATE = 5

function checkStages(cid)
	local level = getPlayerLevel(cid)
	
	for i = 1, # STAGES do
		if level <= STAGES[i].level then
			doPlayerSetRate(cid, LEVEL_EXPERIENCE, STAGES[i].rate)
			return
		end
	end
	
	doPlayerSetRate(cid, LEVEL_EXPERIENCE, DEFAULT_RATE)
end

function onLogin(cid)
	registerCreatureEvent(cid, "stagesAdvance")
	
	checkStages(cid)
	return true
end

function onAdvance(cid, type, oldlevel, newlevel)
	if type == LEVEL_EXPERIENCE then
		checkStages(cid)
	end
	
	return true
end