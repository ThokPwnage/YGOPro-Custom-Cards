--Vanquisher Bastion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.condition)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--disable summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.sumlimit)
	c:RegisterEffect(e3)
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x131)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.firefilter(c)
	return c:IsFaceup() and c:GetAttribute()==(ATTRIBUTE_FIRE)
end

function s.waterfilter(c)
	return c:IsFaceup() and c:GetAttribute()==(ATTRIBUTE_WATER)
end

function s.windfilter(c)
	return c:IsFaceup() and c:GetAttribute()==(ATTRIBUTE_WIND)
end

function s.earthfilter(c)
	return c:IsFaceup() and c:GetAttribute()==(ATTRIBUTE_EARTH)
end

function s.divinefilter(c)
	return c:IsFaceup() and c:GetAttribute()==(ATTRIBUTE_DEVINE)
end

function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and ((c:IsAttribute(ATTRIBUTE_FIRE) and not Duel.IsExistingMatchingCard(s.firefilter,c:GetControler(),LOCATION_MZONE,0,1,nil)) or (c:IsAttribute(ATTRIBUTE_WATER) and not Duel.IsExistingMatchingCard(s.waterfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)) or (c:IsAttribute(ATTRIBUTE_WIND) and not Duel.IsExistingMatchingCard(s.windfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)) or (c:IsAttribute(ATTRIBUTE_EARTH) and not Duel.IsExistingMatchingCard(s.earthfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)) or (c:IsAttribute(ATTRIBUTE_DEVINE) and not Duel.IsExistingMatchingCard(s.divinefilter,c:GetControler(),LOCATION_MZONE,0,1,nil)))
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
	end
end

function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
  return c:GetAttribute()==(ATTRIBUTE_LIGHT) or c:GetAttribute()==(ATTRIBUTE_DARK)
end
