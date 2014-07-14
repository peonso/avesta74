local exhaust = createConditionObject(CONDITION_EXHAUST_HEAL)
setConditionParam(exhaust, CONDITION_PARAM_TICKS, 1000)

local drunk = createConditionObject(CONDITION_DRUNK)
setConditionParam(drunk, CONDITION_PARAM_TICKS, 120000)

local poison = createConditionObject(CONDITION_POISON)
setConditionParam(poison, CONDITION_PARAM_DELAYED, true)
addDamageCondition(poison, 5, 6000, -5)
addDamageCondition(poison, 5, 6000, -4)
addDamageCondition(poison, 7, 6000, -3)
addDamageCondition(poison, 10, 6000, -2)
addDamageCondition(poison, 19, 6000, -1)

local SPLASH = 2025
local FLUID = {WATER = 1, BLOOD = 2, BEER = 3, SLIME = 4, LEMONADE = 5, MILK = 6, MANA = 7,
				LIFE = 10, OIL = 11, URINE = 13, WINE = 15, MUD = 19, LAVA = 26, SWAMP = 28}

function onUse(cid, item, frompos, item2, topos)
	
	if item2.itemid == 1 then
		if item2.uid == cid then
			-- using fluid container on yourself
			if item.type ~= 0 then
				-- can't be empty
				if item.type == FLUID.BEER or item.type == FLUID.WINE then
					doPlayerSay(cid, "Aah...", 1)
					doAddCondition(cid, drunk)
				
				elseif item.type == FLUID.SLIME then
					doPlayerSay(cid, "Argh!", 1)
					doAddCondition(cid, poison)
				
				elseif item.type == FLUID.MANA then
					if hasCondition(cid, CONDITION_EXHAUST_COMBAT) or hasCondition(cid, CONDITION_EXHAUST_HEAL) then
						doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUAREEXHAUSTED)
						return true
					end
			
					doPlayerSay(cid, "Aaaah...", 1)
					doPlayerAddMana(cid, math.random(40, 80))
					doSendMagicEffect(topos, 12)
					doAddCondition(cid, exhaust)
				
				elseif item.type == FLUID.LIFE then
					if hasCondition(cid, CONDITION_EXHAUST_COMBAT) or hasCondition(cid, CONDITION_EXHAUST_HEAL) then
						doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUAREEXHAUSTED)
						return true
					end
				
					doPlayerSay(cid, "Aaaah...", 1)
					doPlayerAddHealth(cid, math.random(40, 80))
					doSendMagicEffect(topos, 12)
					doAddCondition(cid, exhaust)
				else
					doPlayerSay(cid, "Gulp.", 1)
				end
			end
			
			doChangeTypeItem(item.uid, 0)
		else
			-- using fluid container on somebody
			local splash = doCreateItem(SPLASH, item.type, topos)
			doDecayItem(splash)
			doChangeTypeItem(item.uid, 0)
		end
	elseif getFluidSourceType(item2.itemid) ~= 0 then
		if item.type ~= 0 then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
		else
			-- fill it
			local fluidType = getFluidSourceType(item2.itemid)
			doChangeTypeItem(item.uid, fluidType)
		end
	elseif isItemFluidContainer(item2.itemid) and topos.stackpos ~= 0 then
		-- using fluid container on another fluid container
		if item.type ~= 0 and item2.type ~= 0 then
			-- trying to fill fluid container that is already filled
			local splash = doCreateItem(SPLASH, item.type, topos)
			doDecayItem(splash)
			doChangeTypeItem(item.uid, 0)
		elseif item.type ~= 0 and item2.type == 0 then
			if hasProperty(item2.uid, CONST_PROP_BLOCKSOLID) then
				-- we can't use it on doors, walls, etc.
				return false
			end
			
			-- transfer fluid to another container
			doChangeTypeItem(item2.uid, item.type)
			doChangeTypeItem(item.uid, 0)
		else
			-- trying to use empty on empty or empty on filled
			doPlayerSendDefaultCancel(cid, RETURNVALUE_CANNOTUSETHISOBJECT)
		end
	else
		-- using fluid container on ground
		if item.type ~= 0 then
			local splash = doCreateItem(SPLASH, item.type, topos)
			doDecayItem(splash)
			doChangeTypeItem(item.uid, 0)
		else
			-- fluid container is empty
			doPlayerSendDefaultCancel(cid, RETURNVALUE_CANNOTUSETHISOBJECT)
		end
	end
	
	return true
end
