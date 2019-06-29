--Master Seal
local s,hp,sp,str,mag,lck,skill,def,eqdr,staff,staffdur,id=GetID()
local eqfg
local LV_COUNTER=0x64a
local MAXHP_COUNTER=0x65a
local SP_COUNTER=0x67a  
local STR_COUNTER=0x68a
local MAG_COUNTER=0x69a
local LCK_COUNTER=0x70a  
local SKILL_COUNTER=0x71a 
local DEF_COUNTER=0x72a   
local HP_COUNTER=0x66a
local DUR_COUNTER=0x73a

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.costfilter(c,e,tp)
	if not c:IsSetCard(0x64a) or not c:IsAbleToGraveAsCost() or not c:IsFaceup() then return false end
	local code=c:GetCode()
	local class=_G["c"..code]
	if class==nil or class.lvupcount==nil then return false end
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,class,e,tp)
end

function s.spfilter(c,class,e,tp)
	local code=c:GetCode()
	for i=1,class.lvupcount do
		if code==class.lvup[i] then return true end
	end
	return false
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local c=g:GetFirst()
	hp=c:GetCounter(MAXHP_COUNTER)
	sp=c:GetCounter(SP_COUNTER)
	str=c:GetCounter(STR_COUNTER)
	mag=c:GetCounter(MAG_COUNTER)
	lck=c:GetCounter(LCK_COUNTER)
	skill=c:GetCounter(SKILL_COUNTER)
	def=c:GetCounter(DEF_COUNTER)
	local eqg=c:GetEquipGroup()
	local eqf=eqg:GetFirst()
	while eqf do
		if eqf:IsSetCard(0x64b) then 
			eqfg=eqf:GetCode() 
			eqdr=eqf:GetCounter(DUR_COUNTER)
		end
		if eqf:IsSetCard(0x64c) then
			staff=eqf:GetCode()
			staffdur=eqf:GetCounter(DUR_COUNTER)
		end
		eqf=eqg:GetNext()
	end
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	local class=_G["c"..code]
	if class==nil or class.lvupcount==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,class,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_TEMPORARY)
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP_ATTACK)
		tc:RegisterFlagEffect(0xfec17,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc:AddCounter(MAXHP_COUNTER,hp)
		tc:AddCounter(SP_COUNTER,sp)
		tc:AddCounter(STR_COUNTER,str)
		tc:AddCounter(MAG_COUNTER,mag)
		tc:AddCounter(LCK_COUNTER,lck)
		tc:AddCounter(SKILL_COUNTER,skill)
		tc:AddCounter(DEF_COUNTER,def)
		if eqfg then
			tc:RegisterFlagEffect(0xfee92,RESET_EVENT,0,1)
			local wep=Duel.CreateToken(tp,eqfg)
			Duel.Equip(tp,wep,tc)
			wep:AddCounter(DUR_COUNTER,eqdr)
		end
		if staff then
			tc:RegisterFlagEffect(0xfee93,RESET_EVENT,0,1)
			local wep=Duel.CreateToken(tp,staff)
			Duel.Equip(tp,wep,tc)
			wep:AddCounter(DUR_COUNTER,staffdur)
		end
		if tc:GetPreviousLocation()==LOCATION_DECK then Duel.ShuffleDeck(tp) end
	end
end
