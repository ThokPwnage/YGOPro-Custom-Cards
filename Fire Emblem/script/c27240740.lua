--Fortify Staff
local s,id=GetID()
local durability=3
local DUR_COUNTER=0x73a
local MAXHP_COUNTER=0x65a
local HP_COUNTER=0x66a
local SP_COUNTER=0x67a
local MAG_COUNTER=0x69a
local LCK_COUNTER=0x70a
local SKILL_COUNTER=0x71a
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	c:EnableCounterPermit(DUR_COUNTER)
	c:SetCounterLimit(DUR_COUNTER,durability)

	--add counters
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_COUNTER)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(s.initcon)
	e0:SetOperation(s.initop)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.immfilter)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	--heal
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(s.healop)
	c:RegisterEffect(e3)
	--self destruct
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.destcon)
	e4:SetOperation(s.destop)
	c:RegisterEffect(e4)
	--self recovery
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCondition(s.reccon)
	e5:SetOperation(s.recop)
	c:RegisterEffect(e5)
end

function s.initcon(e,tp,re,r)
	local c=e:GetHandler()
	if not c:GetEquipTarget() then return end
	local tc=c:GetEquipTarget()
	return c:GetFlagEffect(0xfee91)==0
end

function s.initop(e,tp,re,r)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if tc:GetFlagEffect(0xfee93)==0 then c:AddCounter(DUR_COUNTER,durability) end
	c:RegisterFlagEffect(0xfee91,RESET_EVENT,0,1)
	tc:ResetFlagEffect(0xfee93)
end

function s.immfilter(e,te)
	return te:GetHandler():GetControler()~=e:GetHandler():GetControler()
end

function s.healfilter(c)
	return c:IsSetCard(0x64a) and c:GetCounter(MAXHP_COUNTER)>c:GetCounter(HP_COUNTER)
end

function s.healop(e,tp,re,r)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	c:RemoveCounter(tp,DUR_COUNTER,1,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(s.healfilter,tp,LOCATION_MZONE,0,nil)
	local htg=g:GetFirst()
	while htg do
		if not htg:AddCounter(HP_COUNTER,5+tc:GetCounter(MAG_COUNTER)) then
			htg:AddCounter(HP_COUNTER,htg:GetCounter(MAXHP_COUNTER)-htg:GetCounter(HP_COUNTER))
		end
		htg=g:GetNext()
	end
	Duel.Recover(tp,500+tc:GetCounter(MAG_COUNTER)*100,REASON_EFFECT)
	tc:RegisterFlagEffect(0xfe64ca,RESET_EVENT,0,1)
end

function s.reccon(e,tp,re,r)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	return Duel.GetTurnPlayer()==tp and tc:GetCounter(MAXHP_COUNTER)>tc:GetCounter(HP_COUNTER)
end

function s.recop(e,tp,re,r)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if not tc:AddCounter(HP_COUNTER,5) then
		tc:AddCounter(tc:GetCounter(MAXHP_COUNTER)-tc:GetCounter(HP_COUNTER))
	end
end

function s.destcon(e,tp,re,r)
	local c=e:GetHandler()
	return e:GetHandler():GetCounter(DUR_COUNTER)==0 and e:GetHandler():GetEquipTarget() and c:GetFlagEffect(0xfee91)~=0
end

function s.destop(e,tp,re,r)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	Duel.SendtoGrave(c,REASON_RULE)
end
