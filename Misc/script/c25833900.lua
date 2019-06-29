--Unexpected Accident
local s,id=GetID()
function s.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end

function s.cfilter(c)
	return c:IsAbleToGraveAsCost()
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_EXTRA,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return #g>=1
	end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,60)
	local rg=g
	Duel.SendtoGrave(rg,REASON_COST)
	Duel.ConfirmCards(tp,g)
	local op=0
	op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	local h=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return #h>=1
	end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,60)
	local rg=h
	Duel.SendtoGrave(rg,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
	op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,60,REASON_EFFECT)
	Duel.DiscardDeck(tp,60,REASON_EFFECT)
end
