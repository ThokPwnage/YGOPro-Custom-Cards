--Item Shop
local s,id=GetID()
local DUR_COUNTER=0x73a
local SP_COUNTER=0x67a
local LCK_COUNTER=0x70a
local SKILL_COUNTER=0x71a
local GOLD_COUNTER=0xcfe
function s.initial_effect(c)
	c:EnableCounterPermit(GOLD_COUNTER)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--buy a weapon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.eqcon)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	--sell cards
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(s.ctcost)
	e3:SetTarget(s.cttg)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)
	--passive gold
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetCondition(s.pgcon)
	e4:SetOperation(s.pgop)
	c:RegisterEffect(e4)
	--battle gold
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(s.bgcon2)
	e5:SetOperation(s.bgop)
	c:RegisterEffect(e5)
end

function s.thfilter(c)
	return c:IsSetCard(0x64a) and not c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end

function s.eqcon(e,tp,re,r)
	return (Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x64a) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():GetCounter(GOLD_COUNTER)>=250)
end

function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,63,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetLabel(),0,0x1)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():AddCounter(GOLD_COUNTER,200*ct)
end

function s.pgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function s.pgop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(GOLD_COUNTER,100)
end

function s.bgcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetControler()==tp
end

function s.bgop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(GOLD_COUNTER,200)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqg=Group.FromCards(c)
	local gold=c:GetCounter(GOLD_COUNTER)
	local op=1
	if gold>=1000 then op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3)) end
	local tc
	if op==1 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		tc=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0x64a):GetFirst()

	--find compatible weapons
	--swords
	if tc:IsCanAddCounter(0xfe1,1) then
		eqg:AddCard(Duel.CreateToken(tp,27240000))
		if gold>=500 then
			eqg:AddCard(Duel.CreateToken(tp,27240010))
		end
		if tc:GetLevel()>=8 and gold>=750 then
			eqg:AddCard(Duel.CreateToken(tp,27240020))
			eqg:AddCard(Duel.CreateToken(tp,27240030))
		end
	end
	--spears
	if tc:IsCanAddCounter(0xfe2,1) then
		eqg:AddCard(Duel.CreateToken(tp,27240100))
		if gold>=500 then
			eqg:AddCard(Duel.CreateToken(tp,27240110))
		end
		if tc:GetLevel()>=8 and gold>=750 then
			eqg:AddCard(Duel.CreateToken(tp,27240120))
			eqg:AddCard(Duel.CreateToken(tp,27240130))
		end
	end
	--axes
	if tc:IsCanAddCounter(0xfe3,1) then
		eqg:AddCard(Duel.CreateToken(tp,27240200))
		if gold>=500 then
			eqg:AddCard(Duel.CreateToken(tp,27240210))
		end
		if tc:GetLevel()>=8 and gold>=750 then
			eqg:AddCard(Duel.CreateToken(tp,27240220))
			eqg:AddCard(Duel.CreateToken(tp,27240230))
		end
	end
	--fire
	if tc:IsCanAddCounter(0xfe4,1) then
		eqg:AddCard(Duel.CreateToken(tp,27240300))
		if gold>=500 then
			eqg:AddCard(Duel.CreateToken(tp,27240310))
		end
		if tc:GetLevel()>=8 and gold>=750 then
			eqg:AddCard(Duel.CreateToken(tp,27240320))
		end
		if tc:GetLevel()>=12 and gold>=1000 then
			eqg:AddCard(Duel.CreateToken(tp,27240330))
		end
	end
	--thunder
	if tc:IsCanAddCounter(0xfe5,1) then
		eqg:AddCard(Duel.CreateToken(tp,27240400))
		if gold>=500 then
			eqg:AddCard(Duel.CreateToken(tp,27240410))
		end
		if tc:GetLevel()>=8 and gold>=750 then
			eqg:AddCard(Duel.CreateToken(tp,27240420))
		end
		if tc:GetLevel()>=12 and gold>=1000 then
			eqg:AddCard(Duel.CreateToken(tp,27240430))
		end
	end
	--wind
	if tc:IsCanAddCounter(0xfe6,1) then
		eqg:AddCard(Duel.CreateToken(tp,27240500))
		if gold>=500 then
			eqg:AddCard(Duel.CreateToken(tp,27240510))
		end
		if tc:GetLevel()>=8 and gold>=750 then
			eqg:AddCard(Duel.CreateToken(tp,27240520))
		end
		if tc:GetLevel()>=12 and gold>=1000 then
			eqg:AddCard(Duel.CreateToken(tp,27240530))
		end
	end
	--light
	if tc:IsCanAddCounter(0xfe7,1) then
		eqg:AddCard(Duel.CreateToken(tp,27240600))
		if gold>=500 then
			eqg:AddCard(Duel.CreateToken(tp,27240610))
		end
		if tc:GetLevel()>=8 and gold>=750 then
			eqg:AddCard(Duel.CreateToken(tp,27240620))
		end
		if tc:GetLevel()>=12 and gold>=1000 then
			eqg:AddCard(Duel.CreateToken(tp,27240630))
		end
	end
	--staves
	if tc:IsCanAddCounter(0x64c,1) then
		eqg:AddCard(Duel.CreateToken(tp,27240700))
		if gold>=500 then
			eqg:AddCard(Duel.CreateToken(tp,27240710))
		end
		if tc:GetLevel()>=8 and gold>=750 then
			eqg:AddCard(Duel.CreateToken(tp,27240720))
			eqg:AddCard(Duel.CreateToken(tp,27240730))
		end
		if tc:GetLevel()>=12 and gold>=1000 then
			eqg:AddCard(Duel.CreateToken(tp,27240740))
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local wep=eqg:Select(tp,1,1,e:GetHandler()):GetFirst()
	--spend gold
	if wep:IsSetCard(0x1fe) then c:RemoveCounter(tp,GOLD_COUNTER,250,REASON_COST) end
	if wep:IsSetCard(0x2fe) then c:RemoveCounter(tp,GOLD_COUNTER,500,REASON_COST) end
	if wep:IsSetCard(0x3fe) then c:RemoveCounter(tp,GOLD_COUNTER,750,REASON_COST) end
	if wep:IsSetCard(0x4fe) then c:RemoveCounter(tp,GOLD_COUNTER,1000,REASON_COST) end
	--remove old weapon
	local oldwep
	if tc:GetEquipCount()>0 then 
		local cureqg=tc:GetEquipGroup() 
		local cureq=cureqg:GetFirst()
		while cureq do
			if (cureq:IsSetCard(0x64b) and wep:IsSetCard(0x64b)) or (cureq:IsSetCard(0x64c) and wep:IsSetCard(0x64c)) then oldwep=cureq end
			cureq=cureqg:GetNext()
		end
		if oldwep then
			if tc:GetFlagEffect(0xfee959)~=0 then
				local sp=tc:GetFlagEffectLabel(0xfee959)
				local lck=tc:GetFlagEffectLabel(0xfee97c)
				local skill=tc:GetFlagEffectLabel(0xfee954)
				if sp>0 then tc:RemoveCounter(tp,SP_COUNTER,sp,REASON_EFFECT) end
			   if sp<0 then tc:AddCounter(SP_COUNTER,sp) end
				if lck>0 then tc:RemoveCounter(tp,LCK_COUNTER,lck,REASON_EFFECT) end
				if lck<0 then tc:AddCounter(LCK_COUNTER,lck) end
				if skill>0 then tc:RemoveCounter(tp,SKILL_COUNTER,skill,REASON_EFFECT) end
				if skill<0 then tc:AddCounter(tp,SKILL_COUNTER,skill,REASON_EFFECT) end
				tc:ResetFlagEffect(0xfee959)
				tc:ResetFlagEffect(0xfee97c)
				tc:ResetFlagEffect(0xfee954)
			end
			Duel.SendtoGrave(oldwep,REASON_EFFECT)
		end
	end
	--equip
	Duel.Equip(tp,wep,tc)
	else
		--generic
		local g2=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tc=g2:Select(tp,1,1,nil)
		c:RemoveCounter(tp,GOLD_COUNTER,1000,REASON_COST)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end
