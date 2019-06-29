--Vanquisher Trooper
local s,id=GetID()
function s.initial_effect(c)
	--Disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(s.condition)
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

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if a==c then a=Duel.GetAttackTarget() end
	e:SetLabelObject(a)
	return a and a:IsAttribute(ATTRIBUTE_DARK) and a:IsRelateToBattle()
end

function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x57a0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x57a0000)
	tc:RegisterEffect(e2)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
  return c:GetAttribute()==(ATTRIBUTE_LIGHT) or c:GetAttribute()==(ATTRIBUTE_DARK)
end
