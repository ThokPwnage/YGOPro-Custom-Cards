--Arcwind Tome
local s,id=GetID()
local durability=16
local DUR_COUNTER=0x73a
local SP_COUNTER=0x67a
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
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	--lose durability
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.discon1)
	e3:SetOperation(s.disop1)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(s.discon2)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4)
	--self destruct
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(s.destcon)
	e5:SetOperation(s.destop)
	c:RegisterEffect(e5)
	--reduce atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetCondition(s.adcon)
	e6:SetTarget(s.adtg)
	e6:SetValue(-1000)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
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
	if tc:GetFlagEffect(0xfee92)==0 then 
		c:AddCounter(DUR_COUNTER,durability) 
		tc:AddCounter(SP_COUNTER,3)
		tc:RegisterFlagEffect(0xfee97c,RESET_EVENT,0,1,0,0)
		tc:RegisterFlagEffect(0xfee959,RESET_EVENT,0,1,3,1)
		tc:RegisterFlagEffect(0xfee954,RESET_EVENT,0,1,0,0)
	end
	tc:ResetFlagEffect(0xfee92)
	tc:RegisterFlagEffect(0xfe42,RESET_EVENT,0,1)
	c:RegisterFlagEffect(0xfee91,RESET_EVENT,0,1)
end


function s.immfilter(e,te)
	return te:GetHandler():GetControler()~=e:GetHandler():GetControler()
end

function s.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,id)
end

function s.discon1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget())
end

function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c:GetEquipTarget() and not Duel.GetAttackTarget()
end

function s.disop1(e,tp,re,r)
	local c=e:GetHandler()
	if not c:RemoveCounter(tp,DUR_COUNTER,1,REASON_EFFECT) then 
		Duel.SendtoGrave(c,REASON_RULE) 
	end
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsExists(s.filter,1,nil,tp) then return false end
	local tcg=tg:Filter(s.filter,nil,tp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	local check=false
	local tc=tcg:GetFirst()
	while tc do
		if tc==c:GetEquipTarget() then check=true end
		tc=tcg:GetNext()
	end
	if not check then return end
	s.disop1(e,tp,re,r)
end

function s.destcon(e,tp,re,r)
	local c=e:GetHandler()
	return e:GetHandler():GetCounter(DUR_COUNTER)==0 and e:GetHandler():GetEquipTarget() and c:GetFlagEffect(0xfee91)~=0
end

function s.destop(e,tp,re,r)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	tc:RemoveCounter(tp,SP_COUNTER,3,REASON_EFFECT)
	Duel.SendtoGrave(c,REASON_RULE)
end

function s.adcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE_CAL or ph==PHASE_DAMAGE or ph==PHASE_BATTLE_START or ph==PHASE_BATTLE_STEP) and Duel.GetAttackTarget() and Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end

function s.adtg(e,c)
	local bc=c:GetBattleTarget()
	return bc==e:GetHandler():GetEquipTarget() and bc==Duel.GetAttacker()
end
