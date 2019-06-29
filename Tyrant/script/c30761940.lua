--Bloodthirsty Mawcor
local s,id=GetID()
function s.initial_effect(c)
	--flurry
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(s.atchk)
	e1:SetCountLimit(1)
	e1:SetOperation(s.rctop)
	c:RegisterEffect(e1)
	--crush
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
end

function s.atchk(e)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c
end

function s.atop(e)
	Duel.ChainAttack()
end

function s.rctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local coin=Duel.SelectOption(tp,60,61)
	local res=Duel.TossCoin(tp,1)
	if coin~=res then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DAMAGE_STEP_END)
		e1:SetCountLimit(2)
		e1:SetCondition(s.atchk)
		e1:SetOperation(s.atop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
