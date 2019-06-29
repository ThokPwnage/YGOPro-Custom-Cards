--Snake World
local s, id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetValue(RACE_REPTILE)
	c:RegisterEffect(e2)
end
