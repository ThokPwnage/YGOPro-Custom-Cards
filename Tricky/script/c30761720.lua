--The Tricky Apprentice
local s,id=GetID()
function s.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_SZONE+LOCATION_FZONE+LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e1:SetValue(14778250)
	c:RegisterEffect(e1)
	--gain ad
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.aval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(s.dval)
	c:RegisterEffect(e3)
end

function s.filter(c)
	return c:IsCode(14778250)
end

function s.aval(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,e:GetHandler())
	return g:GetCount()*250
end

function s.dval(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,e:GetHandler())
	return g:GetCount()*150
end
