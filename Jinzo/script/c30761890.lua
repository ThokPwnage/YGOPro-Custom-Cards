--Lair of Jinzo
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--effect immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.target)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--clear
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(s.deactivate)
	c:RegisterEffect(e5)
end

function s.tfilter(c,tp)
	return c:GetFlagEffect(id)==0 and c:GetControler()==tp and c:IsFaceup() and c:IsCode(77585513)
end

function s.target(e,c)
	local tp=e:GetHandlerPlayer()
	return c:GetControler()==tp and c:IsFaceup() and c:IsCode(77585513)
end

function s.efilter(e,te)
	local tc=te:GetOwner()
	local tp=e:GetHandlerPlayer()
	return tc~=e:GetOwner() and tc~=e:GetHandler() and e:GetHandler():GetFlagEffect(id)~=0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,id)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tfilter,tp,LOCATION_MZONE,0,nil,tp)
	if g:GetCount()==0 then return end
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabel(id)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		tc=g:GetNext()
	end
end

function s.deactivate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		tc:ResetEffect(id,RESET_EVENT)
		tc:ResetFlagEffect(id)
		tc=g:GetNext()
	end
end

function s.val(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,TYPE_TRAP)
	return g*500
end
