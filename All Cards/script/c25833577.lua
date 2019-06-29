--Vanquisher Inquisition
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.ConfirmCards(p,g)
	local g=Duel.GetFieldGroup(1-p,LOCATION_HAND,0)
	local dt=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dt==0 then return end
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,0,LOCATION_HAND,nil)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
