--Noble Legs - The DomiMatrix
local s, id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,2)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	--attach
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_EQUIP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e4:SetTarget(s.ovtg)
	e4:SetOperation(s.ovop)
	c:RegisterEffect(e4)
	--win
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(s.winop)
	c:RegisterEffect(e5)
end

function s.atkval(e,c)
	return c:GetOverlayCount()*500
end

function s.thfilter(c)
	return (c:IsSetCard(0x107a) or c:IsSetCard(0x207a)) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if  c:IsType(TYPE_XYZ) then
		Duel.Overlay(c,tg)
	end
end

function s.ovfilter(c,ec)
	return c:GetEquipTarget()==ec
end

function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.ovfilter,1,nil,e:GetHandler()) end
	local dg=eg:Filter(s.ovfilter,nil,e:GetHandler())
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,dg,dg:GetCount(),0,0)
end

function s.noblefilter(c,g)
	return c:IsSetCard(0x7a) and not g:IsExists(aux.FilterBoolFunction(IsCode(c:GetCode())),1,nil)
end

function s.legfilter(c)
	return c:IsSetCard(0x307a)
end

function s.armfilter(c)
	return c:IsSetCard(0x207a) and not c:IsSetCard(0x107a)
end

function s.headfilter(c)
	return c:IsCode(25833809)
end

function s.knightfilter(c)
	return c:IsSetCard(0x107a) and not c:IsSetCard(0x207a)
end

function s.dayfilter(c)
	return c:IsCode(25833810)
end

function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_NOBLE=0x12
	local armcon=false
	local legcon=false
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local arms=g:Filter(s.armfilter,nil)
	local legs=g:Filter(s.legfilter,nil)
	local head=g:Filter(s.headfilter,nil)
	local knight=g:Filter(s.knightfilter,nil)
	local day=g:Filter(s.dayfilter,nil)
	local a1, l1
	if arms:GetCount()>=2 then
		a1=arms:GetFirst()
		local a2=a1
		while a2 do
			if a2:GetCode()~=a1:GetCode() then armcon=true
			end
			a2=arms:GetNext()
		end
	end
	if legs:GetCount()>=2 then
		l1=legs:GetFirst()
		local l2=l1
		while l2 do
			if l2:GetCode()~=l1:GetCode() then legcon=true
			end
			l2=legs:GetNext()
		end
	end
	if armcon and legcon and knight:GetCount()>=1 and head:GetCount()>=1 and day:GetCount()>=1 then
		Duel.Win(tp,WIN_REASON_NOBLE)
	end
end
