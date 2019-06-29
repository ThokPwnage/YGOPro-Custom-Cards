--Pandexpressmonium
local s,id=GetID()
local recval=0
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
	--add race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetTarget(s.target)
	e2:SetValue(RACE_PSYCHO)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetLabel(0)
	e3:SetCondition(s.reccon)
	e3:SetTarget(s.rectg)
	e3:SetOperation(s.recop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(s.thcon2)
	e4:SetTarget(s.thtg2)
	e4:SetOperation(s.thop2)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetTarget(s.target2)
	e5:SetValue(RACE_FIEND)
	c:RegisterEffect(e5)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(s.clear)
		Duel.RegisterEffect(ge2,0)
	end
end

function s.target(e,c)
	return c:IsSetCard(0x45) and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_PSYCHO)
end

function s.target2(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PSYCHO) and not c:IsSetCard(0x45)
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==Duel.GetTurnPlayer() and re:GetHandler():IsRace(RACE_PSYCHO) then
		local val=math.ceil(ev/2)
		recval=recval+val
	end
end

function s.clear(e,tp,eg,ep,ev,re,r,rp)
	recval=0
end

function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end

function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return recval>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(recval)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,recval)
end

function s.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp
end

function s.thfilter2(c)
	return (c:IsSetCard(0x45) or c:IsRace(RACE_PSYCHO)) and c:IsAbleToHand()
end

function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
