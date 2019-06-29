--Tiger Stance 4: Raging Wave
local s, id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetHintTiming(TIMING_BATTLE_START)
	e1:SetTarget(s.target)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.tdcon)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end

function s.filter(c,tp)
	return (c:GetCode()==25834003 or c:GetCode()==25834004) and c:IsControler(tp)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc==eg:GetFirst() end
	if chk==0 then return eg:GetFirst():IsFaceup() and eg:GetFirst():IsCanBeEffectTarget(e) and s.filter(eg:GetFirst(),tp) end
	Duel.SetTargetCard(eg:GetFirst())
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetFlagEffect(id)==0 then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			--chain next stance
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(id,2))
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e4:SetCode(EVENT_BATTLE_DESTROYING)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCountLimit(1)
			e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
			e4:SetOperation(s.setop)
			tc:RegisterEffect(e4)
		end
	end
end

function s.setfilter(c)
	return c:IsSetCard(0x6c) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (c:GetFlagEffect(25834005) and c:GetFlagEffect(25834006) and c:GetFlagEffect(25834007)) or (c:IsCode(25834004) and c:GetCounter(0x16c)>=9) then
		c:AddCounter(0x16c,1)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		--atk buff
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESET_PHASE+PHASE_END,3)
		e2:SetValue(s.atkval)
		c:RegisterEffect(e2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function s.atkval(e,c)
	return c:GetAttack()*0.3
end

function s.deckfilter(c)
	return not c:IsSetCard(0xfff)
end

function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(s.deckfilter,tp,LOCATION_DECK,0,nil)>0
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,nil,1,REASON_RULE)
	Duel.Draw(tp,1,REASON_RULE)
	local tc=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil):GetFirst()
	if not tc:IsSetCard(0x6c) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end
