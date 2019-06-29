--Raider Omega
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_MAIN1 and e:GetHandler():GetFlagEffect(id)==0
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE+LOCATION_FZONE,nil)
	Duel.Damage(1-tp,200,REASON_EFFECT)
	--weaken
	local tcm=mg:RandomSelect(nil,1):GetFirst()
	if tcm then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tcm:RegisterEffect(e1)
	end
	--siege
	local tcs=sg:RandomSelect(nil,1):GetFirst()
	if tcs then Duel.Destroy(tcs,REASON_EFFECT) end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
