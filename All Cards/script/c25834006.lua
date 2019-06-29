--Tiger Stance 2: Tiger Claw
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
	return (c:GetCode()==25834002 or c:GetCode()==25834003 or c:GetCode()==25834004) and c:IsControler(tp)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc==eg:GetFirst() end
	if chk==0 then return eg:GetFirst():IsFaceup() and eg:GetFirst():IsCanBeEffectTarget(e) and s.filter(eg:GetFirst(),tp) end
	Duel.SetTargetCard(eg:GetFirst())
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and bc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,1,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		tc:RegisterEffect(e2)
	end
	if c:GetCode()~=25834002 then
		local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		local tg=g:GetFirst()
		if tg then
			Duel.SSet(tp,tg)
			local ae=tg:GetActivateEffect()
			local fop=ae:GetOperation()
			Duel.SetTargetCard(c)
			Duel.ConfirmCards(1-tp,tg)
			fop(e,tp,eg,ep,ev,re,r,rp)
			Duel.SendtoGrave(tg,REASON_COST)
		end
	end
	if c:IsPosition(POS_FACEUP_ATTACK) then
		Duel.CalculateDamage(c,tc)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetFlagEffect(id)==0 then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			--reset dummy
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(id,1))
			e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e2:SetCode(EVENT_BATTLE_DESTROYING)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e2:SetCountLimit(1)
			e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
			e2:SetCondition(aux.bdogcon)
			e2:SetTarget(s.sptg)
			e2:SetOperation(s.spop)
			tc:RegisterEffect(e2)
			--energy
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			tc:AddCounter(0x16c,1)
		end
	end
end

function s.setfilter(c)
	return c:IsCode(25834007) and c:IsSSetable()
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
