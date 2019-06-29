--Vanquisher Defender
local s,id=GetID()
function s.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(s.indes)
	c:RegisterEffect(e1)
	--reflect battle dam
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetValue(s.condition)
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

function s.indes(e)
	local ph=Duel.GetCurrentPhase()
	if not (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a==e:GetHandler() and d and d:IsFaceup() and ( d:IsAttribute(ATTRIBUTE_DARK) or d:IsAttribute(ATTRIBUTE_LIGHT)))
		or (d==e:GetHandler() and ( a:IsAttribute(ATTRIBUTE_DARK) or a:IsAttribute(ATTRIBUTE_LIGHT)))
end

function s.condition(e)
	local ph=Duel.GetCurrentPhase()
	if not (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a==e:GetHandler() and d and d:IsFaceup() and d:IsAttribute(ATTRIBUTE_DARK))
		or (d==e:GetHandler() and a:IsAttribute(ATTRIBUTE_DARK))
end

function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
  return c:GetAttribute()==(ATTRIBUTE_LIGHT) or c:GetAttribute()==(ATTRIBUTE_DARK)
end
