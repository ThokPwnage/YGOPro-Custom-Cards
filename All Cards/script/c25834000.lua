--Little Xia
local s, id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x16c)
	c:SetCounterLimit(0x16c,10)
	c:RegisterFlagEffect(0x16c,RESET_EVENT,0,0xffffffffffffffff)
	--energy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(s.enrgcon)
	e1:SetOperation(s.enrgop)
	c:RegisterEffect(e1)
	--update energy flag
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.updateop)
	c:RegisterEffect(e2)
end
c25834000.lvupcount=3
c25834000.lvup={25834002,25834010,25834013}

function s.enrgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x16c,1)
	c:SetFlagEffectLabel(0x16c,c:GetCounter(0x16c))
end

function s.enrgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function s.updateop(e)
	local c=e:GetHandler()
	c:SetFlagEffectLabel(0x16c,c:GetCounter(0x16c))
end
