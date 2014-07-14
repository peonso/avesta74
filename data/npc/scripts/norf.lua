
_state = 0
_delay = 750

function getNext()
	nextPlayer = getQueuedPlayer()
	if (nextPlayer ~= nil) then
		if (getDistanceToCreature(nextPlayer) <= 4) then
			updateNpcIdle()
			setNpcFocus(nextPlayer)
			selfSay('Welcome, Pilgrim.', _delay * 2)
			return
		else
			getNext()
		end
	end
	
	setNpcFocus(0)
	resetNpcIdle()
end

function _selfSay(message)
	selfSay(message, _delay)
	updateNpcIdle()
end

function onCreatureAppear(cid)

end

function onCreatureDisappear(cid)
	if (getNpcFocus() == cid) then
		selfSay('Remember: If you are heavily wounded or poisoned, I will heal you.', _delay)
		getNext()
	else
		unqueuePlayer(cid)
	end
end

function onCreatureMove(cid, oldPos, newPos)
	if (getNpcFocus() == cid) then
		faceCreature(cid)
		
		if (oldPos.z ~= newPos.z or getDistanceToCreature(cid) > 4) then
			selfSay('Remember: If you are heavily wounded or poisoned, I will heal you.', _delay)
			getNext()
		end
	else
		if (oldPos.z ~= newPos.z or getDistanceToCreature(cid) > 4) then
			unqueuePlayer(cid)
		end
	end
end

function onCreatureSay(cid, type, msg)
	if (msgcontains(msg, 'heal')) then
		if (getPlayerHealth(cid) < 40) then
			doCreatureAddHealth(cid, 40)
			doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_BLUE)
			selfSay('You are looking really bad. Let me heal your wounds.', _delay)
		elseif (hasCondition(cid, CONDITION_POISON) == TRUE) then
			doRemoveCondition(cid, CONDITION_POISON)
			doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_GREEN)
			selfSay('You are poisoned. I will help you.', _delay)
		elseif (hasCondition(cid, CONDITION_FIRE) == TRUE) then
			doRemoveCondition(cid, CONDITION_FIRE)
			doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_RED)
			selfSay('You are burning. I will help you.', _delay)
		else
			if (getNpcFocus ~= cid) then
				selfSay('You aren\'t looking really bad, ' .. getCreatureName(cid) .. '. Sorry, I can\'t help you.', _delay)
			else
				selfSay('You aren\'t looking that bad. Sorry, I can\'t help you. But if you are looking for additional protection you should go on the pilgrimage of ashes.', _delay)
			end
		end
	elseif (getNpcFocus() == 0) then
		if ((msgcontains(msg, 'hi') or msgcontains(msg, 'hello')) and getDistanceToCreature(cid) <= 4) then
			updateNpcIdle()
			setNpcFocus(cid)
			selfSay('Welcome, Pilgrim.', _delay)
		end
	elseif (getNpcFocus() ~= cid) then
		if ((msgcontains(msg, 'hi') or msgcontains(msg, 'hello')) and getDistanceToCreature(cid) <= 4) then
			selfSay('Please wait a minute, ' .. getCreatureName(cid) .. '.', _delay)
			queuePlayer(cid)
		end
	else
		if (msgcontains(msg, 'bye') or msgcontains(msg, 'farewell')) then
			selfSay('Good bye, ' .. getCreatureName(cid) .. '.', _delay)
			getNext()

		elseif (msgcontains(msg, 'job')) then
			_selfSay('I am here to provide one of the five blessings.')
		
		elseif (msgcontains(msg, 'name')) then
			_selfSay('My name is Norf.')
		
		elseif (msgcontains(msg, 'pilgrimage') or msgcontains(msg, 'ashes')) then
			_selfSay('Whenever you receive a lethal wound your lifeforce is damaged. With every single of the five blessings you have this damage will be reduced.')
			
		elseif (msgcontains(msg, 'blessing')) then
			_selfSay('There are five different blessings available in five sacred places. These blessings are: the spiritual shielding, the spark of the phoenix, the embrace of tibia, the fire of the suns and the wisdom of solitude.')
			
		elseif (msgcontains(msg, 'sacred') and msgcontains(msg, 'places')) then
			_selfSay('Just ask in which of the five blessings you are interested in.')
			
		elseif (msgcontains(msg, 'spiritual') or msgcontains(msg, 'shielding')) then
			_selfSay('Here in the whiteflower temple you may receive the blessing of spiritual shielding. But we must ask of you to sacrifice 10.000 gold. Are you still interested?')
			_state = 1
			
		elseif (msgcontains(msg, 'spark') or msgcontains(msg, 'phoenix')) then
			_selfSay('The spark of the phoenix is given by the dwarven priests of earth and fire in Kazordoon.')
			
		elseif (msgcontains(msg, 'embrace')) then
			_selfSay('The druids north of Carlin will provide you with the embrace of tibia.')
			
		elseif (msgcontains(msg, 'fire') or msgcontains(msg, 'suns')) then
			_selfSay('You can ask for the blessing of the two suns in the suntower near Ab\'Dendriel.')
			
		elseif (msgcontains(msg, 'wisdom') or msgcontains(msg, 'solitude')) then
			_selfSay('Talk to the hermit Eremo on the isle of Cormaya about this blessing.')
			
		elseif (msgcontains(msg, 'time')) then
			_selfSay('Now, it is ' .. getTibiaTime() .. '. Ask Gorn for a watch, if you need one.', _delay)
			
		elseif (_state == 1) then
			if (msgcontains(msg, 'yes')) then
				--print(getPlayerStorageValue(cid, 10004) == -1)
				if (getPlayerStorageValue(cid, 10004) == -1) then
					if (doPlayerRemoveMoney(cid, 10000)) then
						setPlayerStorageValue(cid, 10004, 0)
						doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, getPlayerLossPercent(cid, PLAYERLOSS_EXPERIENCE) - 1)
						doSendMagicEffect(getPlayerPosition(cid), CONST_ME_MAGIC_BLUE)
						_selfSay('So receive the shielding of your spirit, pilgrim.', _delay)
					else
						_selfSay('Oh. You do not have enough money.', _delay)
					end
				else
					_selfSay('You already possess this blessing.', _delay)
				end
			else
				_selfSay('Ok. Suits me.', _delay)
			end
			
			_state = 0
		end
	end
end

function onThink()
	if (getNpcFocus() ~= 0) then
		if (isNpcIdle()) then
			selfSay('Remember: If you are heavily wounded or poisoned, I will heal you.', _delay)
			getNext()
		end
	end
end