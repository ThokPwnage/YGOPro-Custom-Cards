--Sentinel - Nephenee
local s, id=GetID()
local LV_COUNTER=0x64a
local MAXHP_COUNTER=0x65a
local HP_COUNTER=0x66a
local SP_COUNTER=0x67a  
local STR_COUNTER=0x68a
local MAG_COUNTER=0x69a
local LCK_COUNTER=0x70a 
local SKILL_COUNTER=0x71a 
local DEF_COUNTER=0x72a
local DUR_COUNTER=0x73a

function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableCounterPermit(LV_COUNTER)
	c:SetCounterLimit(LV_COUNTER,20)
	c:EnableCounterPermit(HP_COUNTER)
	c:EnableCounterPermit(SP_COUNTER)
	c:EnableCounterPermit(STR_COUNTER)
	c:EnableCounterPermit(MAG_COUNTER)
	c:EnableCounterPermit(LCK_COUNTER)
	c:EnableCounterPermit(SKILL_COUNTER)
	c:EnableCounterPermit(DEF_COUNTER)
	c:EnableCounterPermit(MAXHP_COUNTER)
	c:EnableCounterPermit(0xfe2)
	c:EnableReviveLimit()

	--base stats
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetOperation(s.base)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--halt normal battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(s.damcon)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(s.lvcon)
	e5:SetOperation(s.lvop)
	c:RegisterEffect(e5)
	--immune to effects
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(s.immfilter)
	c:RegisterEffect(e6)
	--cannot tribute
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_RELEASE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(0,1)
	e7:SetTarget(s.rellimit)
	c:RegisterEffect(e7)
	--atk limit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_ATTACK)
	e8:SetCondition(s.equipcon)
	c:RegisterEffect(e8)
	--cannot defend
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e9)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
	c:RegisterEffect(ea)
	local eb=ea:Clone()
	eb:SetCode(EFFECT_CANNOT_CHANGE_POS_E)
	c:RegisterEffect(eb)
	--update stats
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_SINGLE)
	ec:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ec:SetRange(LOCATION_MZONE)
	ec:SetCode(EFFECT_UPDATE_ATTACK)
	ec:SetValue(s.attackup)
	c:RegisterEffect(ec)
	local ed=ec:Clone()
	ed:SetRange(LOCATION_MZONE)
	ed:SetCode(EFFECT_UPDATE_DEFENSE)
	ed:SetValue(s.defenseup)
	c:RegisterEffect(ed)
	--weapon triangle
	local ee=Effect.CreateEffect(c)
	ee:SetCategory(CATEGORY_ATKCHANGE)
	ee:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ee:SetCode(EVENT_BATTLE_CONFIRM)
	ee:SetCondition(s.lvcon)
	ee:SetOperation(s.triop)
	c:RegisterEffect(ee)
	--extra level
	local ef=Effect.CreateEffect(c)
	ef:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ef:SetCode(EVENT_BATTLE_DESTROYING)
	ef:SetCondition(s.batlvcon)
	ef:SetOperation(s.lvop)
	c:RegisterEffect(ef)
	--attacking
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_DICE)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_BATTLE_START)
	e10:SetCondition(s.atchk)
	e10:SetOperation(s.rctop)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EVENT_BE_BATTLE_TARGET)
	e11:SetCondition(s.defchk)
	e11:SetOperation(s.attgop)
	c:RegisterEffect(e11)
	--targeted by effect
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_CHAIN_SOLVING)
	e12:SetRange(LOCATION_MZONE)
	e12:SetOperation(s.disop)
	c:RegisterEffect(e12)
	--kill yourself
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_ADJUST)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCondition(s.deathcon)
	e13:SetOperation(s.deathop)
	c:RegisterEffect(e13)
	--lose weapon
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_ADJUST)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCondition(s.dewepcon)
	e14:SetOperation(s.dewepop)
	c:RegisterEffect(e14)
	--wrath
	local e15=Effect.CreateEffect(c)
	e15:SetCategory(CATEGORY_COUNTER)
	e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e15:SetCode(EVENT_ADJUST)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCondition(s.wrathcon)
	e15:SetOperation(s.wrathop)
	c:RegisterEffect(e15)
	local e16=e15:Clone()
	e16:SetCondition(s.dewrathcon)
	e16:SetOperation(s.dewrathop)
	c:RegisterEffect(e16)
	--luna
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(EFFECT_UPDATE_ATTACK)
	e17:SetRange(LOCATION_MZONE)
	e17:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e17:SetTargetRange(0,LOCATION_MZONE)
	e17:SetCondition(s.lunacon)
	e17:SetTarget(s.lunatg)
	e17:SetValue(s.lunavala)
	c:RegisterEffect(e17)
	local e18=e17:Clone()
	e18:SetCode(EFFECT_UPDATE_DEFENSE)
	e18:SetValue(s.lunavald)
	c:RegisterEffect(e18)
end

c27200600.lvupcount=nil
c27200600.lvup={}

local BASE_HP=24
local PRO_HP=4
local HPGrowth=5
local BASE_SP=15
local PRO_SP=2
local SpGrowth=7
local BASE_MAG=0
local PRO_MAG=0
local MagGrowth=0
local BASE_STR=10
local PRO_STR=2
local StrGrowth=4
local BASE_LCK=8
local PRO_LCK=0 
local LckGrowth=4
local BASE_SKILL=14
local PRO_SKILL=200
local SkillGrowth=7
local BASE_DEF=12
local PRO_DEF=2  
local DefGrowth=5

function s.base(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSummonType()==SUMMON_TYPE_SYNCHRO then
		--base stats
		c:AddCounter(MAXHP_COUNTER,BASE_HP)
		c:AddCounter(SP_COUNTER,BASE_SP)
		c:AddCounter(STR_COUNTER,BASE_STR)
		c:AddCounter(MAG_COUNTER,BASE_MAG)
		c:AddCounter(LCK_COUNTER,BASE_LCK)
		c:AddCounter(SKILL_COUNTER,BASE_SKILL)
		c:AddCounter(DEF_COUNTER,BASE_DEF)
		--starting weapon
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			local tc=Duel.CreateToken(tp,27240100)
			Duel.Equip(tp,tc,c)
		end
	end
	c:AddCounter(LV_COUNTER,1)
	c:AddCounter(MAXHP_COUNTER,PRO_HP)
	c:SetCounterLimit(HP_COUNTER,c:GetCounter(MAXHP_COUNTER))
	c:AddCounter(HP_COUNTER,c:GetCounter(MAXHP_COUNTER))
	c:AddCounter(SP_COUNTER,PRO_SP)
	c:AddCounter(MAG_COUNTER,PRO_MAG)
	c:AddCounter(STR_COUNTER,PRO_STR)
	c:AddCounter(LCK_COUNTER,PRO_LCK)
	c:AddCounter(SKILL_COUNTER,PRO_SKILL)
	c:AddCounter(DEF_COUNTER,PRO_DEF)
	c:ResetFlagEffect(0xfec17)
end

function s.lunacon(e,tp,re,r)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return c:GetFlagEffect(0x704a)~=0 and (ph==PHASE_DAMAGE_CAL or ph==PHASE_DAMAGE or ph==PHASE_BATTLE_START or ph==PHASE_BATTLE_STEP) and Duel.GetAttackTarget() and Duel.GetAttacker()==c
end

function s.lunatg(e,c)
	local bc=c:GetBattleTarget()
	return bc==e:GetHandler() and bc==Duel.GetAttacker()
end

function s.lunavala(e,tp,re,r)
	return Duel.GetAttackTarget():GetAttack()*(-0.5)
end

function s.lunavald(e,tp,re,r)
	return Duel.GetAttackTarget():GetDefense()*(-0.5)
end

function s.wrathcon(e,tp,re,r)
	local c=e:GetHandler()
	return c:GetCounter(MAXHP_COUNTER)>0 and c:GetCounter(HP_COUNTER)>0 and c:GetCounter(HP_COUNTER)<=(c:GetCounter(MAXHP_COUNTER)*0.3) and c:GetFlagEffect(0x30cfe)==0
end

function s.dewrathcon(e,tp,re,r)
	local c=e:GetHandler()
	return c:GetFlagEffect(0x30cfe)~=0 and (c:GetCounter(HP_COUNTER)>(c:GetCounter(MAXHP_COUNTER)*0.3) or c:GetCounter(LCK_COUNTER)~=c:GetFlagEffectLabel(0x30cfe)*2) 
end

function s.wrathop(e,tp,re,r)
	local c=e:GetHandler()
	c:RegisterFlagEffect(0x30cfe,RESET_EVENT,0,1)
	c:SetFlagEffectLabel(0x30cfe,c:GetCounter(LCK_COUNTER))
	c:AddCounter(LCK_COUNTER,c:GetCounter(LCK_COUNTER))
end

function s.dewrathop(e,tp,re,r)
	local c=e:GetHandler()
	c:RemoveCounter(tp,LCK_COUNTER,c:GetFlagEffectLabel(0x30cfe),REASON_EFFECT)
	c:ResetFlagEffect(0x30cfe)
end

function s.dewepcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	return not g:IsExists(Card.IsSetCard,1,nil,0x64b) and c:GetFlagEffect(0xfee97c)~=0
end

function s.dewepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sp=c:GetFlagEffectLabel(0xfee959)
	local lck=c:GetFlagEffectLabel(0xfee97c)
	local skill=c:GetFlagEffectLabel(0xfee954)
	if sp>0 then c:RemoveCounter(tp,SP_COUNTER,sp,REASON_EFFECT) end
	if sp<0 then c:AddCounter(SP_COUNTER,sp) end
	if lck>0 then c:RemoveCounter(tp,LCK_COUNTER,lck,REASON_EFFECT) end
	if lck<0 then c:AddCounter(LCK_COUNTER,lck) end
	if skill>0 then c:RemoveCounter(tp,SKILL_COUNTER,skill,REASON_EFFECT) end
	if skill<0 then c:AddCounter(tp,SKILL_COUNTER,skill,REASON_EFFECT) end
	c:ResetFlagEffect(0xfee959)
	c:ResetFlagEffect(0xfee97c)
	c:ResetFlagEffect(0xfee954)
end

function s.immfilter(e,te)
	return te:GetHandler():GetControler()~=e:GetHandler():GetControler()
end

function s.tribfilter(e,tp,re,r)
	return tp~=e:GetHandler():GetControler()
end

function s.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsCode(id)
end

function s.spfilter(c,class,e,tp)
	local code=c:GetCode()
	for i=1,class.lvupcount do
		if code==class.lvup[i] then return c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	end
	return false
end

function s.rellimit(e,c,tp,sumtp)
	return c:IsSetCard(0x64a)
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget()
end

function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function s.batlvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end

function s.critcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and Duel.GetAttacker()==c
end

function s.tricon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
end

function s.equipcon(e)
	local eg=e:GetHandler():GetEquipGroup()
	return not eg or not eg:IsExists(Card.IsSetCard,1,nil,0x64b)
end

function s.deathcon(e,tp,re,r)
	local c=e:GetHandler()
	return (not c:GetCounter(HP_COUNTER) or c:GetCounter(HP_COUNTER)<1) and c:GetFlagEffect(0xfec17)==0 and c:GetCounter(MAXHP_COUNTER)>0
end

function s.piercecon(e,tp,re,r)
	return e:GetHandler():GetFlagEffect(0x91ec)~=0
end

function s.swapcon(e,tp,re,r)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL or ph==PHASE_BATTLE_START or ph==PHASE_BATTLE_STEP) and c:GetFlagEffect(0xfe5ad)~=0
end

function s.atchk(e)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:GetFlagEffect(0x84a7e)==0
end

function s.defchk(e)
	return Duel.GetAttackTarget()==e:GetHandler()
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetAttackTarget() then return end
	local c=e:GetHandler()
	local tc
	local ptg
	if c:GetFlagEffect(0x6fee)~=0 then
		c:ResetFlagEffect(0x6fee)
	end
	if c==Duel.GetAttacker() then 
		tc=Duel.GetAttackTarget() 
		ptg=1-tp
	else 
		tc=Duel.GetAttacker()
		ptg=tp
	end
	local dmg=Duel.GetBattleDamage(ptg)
	if not dmg or dmg<=0 then
		dmg=-dmg
		ptg=1-ptg
	end
	--sol
	if (ptg==tp and tc:GetFlagEffect(0xfe501)~=0) or (ptg==1-tp and c:GetFlagEffect(0xfe501)~=0) then dmg=dmg*1.5 end
	--luna
	if (ptg==tp and tc:GetFlagEffect(0x704a)~=0) or (ptg==1-tp and c:GetFlagEffect(0x704a)~=0) then dmg=dmg*2 end
	--crit
	if (ptg==tp and tc:GetFlagEffect(0x9fec)~=0) or (ptg==1-tp and c:GetFlagEffect(0x9fec)~=0) then dmg=dmg*3 end
	if ptg==tp then
		if not c:RemoveCounter(tp,HP_COUNTER,dmg/100,REASON_BATTLE) then
			c:RemoveCounter(tp,HP_COUNTER,c:GetCounter(HP_COUNTER),REASON_BATTLE)
		end
	end
	Duel.ChangeBattleDamage(ptg,dmg)
	c:ResetFlagEffect(0x9fec)
	c:ResetFlagEffect(0x91ec)
	c:ResetFlagEffect(0x704a)
end

function s.attackup(e,c)
	if c:GetFlagEffect(0xfe42)~=0 then
		return c:GetCounter(MAG_COUNTER)*100
	else
		return c:GetCounter(STR_COUNTER)*100
	end
end

function s.defenseup(e,c)
	return c:GetCounter(DEF_COUNTER)*100
end

function s.triop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc
	if Duel.GetAttacker()==c then tc=Duel.GetAttackTarget() end
	if Duel.GetAttackTarget()==c then tc=Duel.GetAttacker() end
	if not tc then return end
	local wep,twep
	if c:GetEquipCount()>0 then local eqg=c:GetEquipGroup() 
		local temp=eqg:GetFirst()
		while temp do
			if temp:IsSetCard(0x64b) then wep=temp end
			temp=eqg:GetNext()
		end
	end
	if tc:GetEquipCount()>0 then local eqtg=tc:GetEquipGroup() 
		local temp=eqtg:GetFirst()
		while temp do
			if temp:IsSetCard(0x64b) then twep=temp end
			temp=eqtg:GetNext()
		end
	end
	if wep and twep then
		--triangle advantage
		if (wep:IsSetCard(0xfe1) and twep:IsSetCard(0xfe3)) or (wep:IsSetCard(0xfe2) and twep:IsSetCard(0xfe1)) or (wep:IsSetCard(0xfe3) and twep:IsSetCard(0xfe2)) then
			local e11=Effect.CreateEffect(c)
			e11:SetCategory(CATEGORY_ATKCHANGE)
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetCode(EFFECT_UPDATE_ATTACK)
			e11:SetValue(c:GetAttack()*0.2)
			e11:SetCondition(s.tricon)
			e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e11)
			local e12=e11:Clone()
			e12:SetCode(EFFECT_UPDATE_DEFENSE)
			e12:SetValue(c:GetDefense()*0.2)
			c:RegisterEffect(e12)
		end
		--triangle disadvantage
		if (wep:IsSetCard(0xfe1) and twep:IsSetCard(0xfe2)) or (wep:IsSetCard(0xfe2) and twep:IsSetCard(0xfe3)) or (wep:IsSetCard(0xfe3) and twep:IsSetCard(0xfe1)) then
			local e10=Effect.CreateEffect(c)
			e10:SetCategory(CATEGORY_ATKCHANGE)
			e10:SetType(EFFECT_TYPE_SINGLE)
			e10:SetCode(EFFECT_UPDATE_ATTACK)
			e10:SetValue(-(c:GetAttack()*0.2))
			e10:SetCondition(s.tricon)
			e10:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e10)
			local e13=e10:Clone()
			e13:SetCode(EFFECT_UPDATE_DEFENSE)
			e13:SetValue(-(c:GetDefense()*0.2))
			c:RegisterEffect(e13)
		end
	end
end

function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end

function s.rctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc
	local dc=Duel.TossDice(c:GetControler(),1)
	local dc2=Duel.TossDice(c:GetControler(),1)
	local dc3=Duel.TossDice(c:GetControler(),1)
	local dc4=Duel.TossDice(c:GetControler(),1)
	local res1=dc3+dc4+(dc*dc2)
	local res2=((dc+dc2)*(dc+dc2)/2)+dc3+dc4
	if Duel.GetAttacker()==c and Duel.GetAttackTarget() then tc=Duel.GetAttackTarget() end
	if Duel.GetAttackTarget() and Duel.GetAttackTarget()==c then tc=Duel.GetAttacker() end
	--pierce def
	if res1>=50-c:GetCounter(SKILL_COUNTER) then 
		c:RegisterFlagEffect(0x91ec,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetCondition(s.piercecon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	--double attack
	if res1>=50-c:GetCounter(SP_COUNTER) and c:GetFlagEffect(0xfe2a7)==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetCode(EVENT_BATTLED)
		e1:SetCountLimit(1)
		e1:SetCondition(s.atchk)
		e1:SetOperation(s.atop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0xfe2a7,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	--luna
	if res2>=85-c:GetCounter(SKILL_COUNTER) then c:RegisterFlagEffect(0x704a,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
	--crit
	if res2>=85-c:GetCounter(LCK_COUNTER) then c:RegisterFlagEffect(0x9fec,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end

function s.attgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(c:GetControler(),1)
	local dc2=Duel.TossDice(c:GetControler(),1)
	local dc3=Duel.TossDice(c:GetControler(),1)
	local dc4=Duel.TossDice(c:GetControler(),1)
	local res1=dc3+dc4+(dc*dc2)
	local res2=((dc+dc2)*(dc+dc2)/2)+dc3+dc4
	if res1>=50-c:GetCounter(SP_COUNTER) then
		Duel.NegateAttack()
	else
		c:RegisterFlagEffect(0xfe5ad,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SWAP_AD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(s.swapcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsExists(s.filter,1,nil,tp) then return false end
	local rc=re:GetHandler()
	local c=e:GetHandler()
	--dodge roll
	local dc=Duel.TossDice(c:GetControler(),1)
	local dc2=Duel.TossDice(c:GetControler(),1)
	local dc3=Duel.TossDice(c:GetControler(),1)
	local dc4=Duel.TossDice(c:GetControler(),1)
	local res1=dc3+dc4+(dc*dc2)
	local res2=((dc+dc2)*(dc+dc2)/2)+dc3+dc4
	if res1<50-c:GetCounter(SP_COUNTER) then
		--lose health
		if c:GetCounter(HP_COUNTER)>10 then
			c:RemoveCounter(tp,HP_COUNTER,10,REASON_EFFECT)
		else 
			c:RemoveCounter(tp,HP_COUNTER,c:GetCounter(HP_COUNTER),REASON_EFFECT)
		end
	end
	--level up
	s.lvop(e,tp,eg,ep,ev,re,r,rp)
end

function s.deathop(e,tp,re,r)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if tc then 
		Duel.RaiseSingleEvent(tc,EVENT_BATTLE_DESTROYING,e,REASON_BATTLE,tp,1-tp,1)
		Duel.RaiseEvent(tc,EVENT_BATTLE_DESTROYING,e,REASON_BATTLE,tp,1-tp,1) 
		Duel.RaiseEvent(c,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,1-tp,tp,1) 
	end
	Duel.Destroy(c,REASON_RULE)
end

function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(0xfe5ad)
	if c:AddCounter(LV_COUNTER,1) then
		if Duel.TossDice(tp,1)+Duel.TossDice(tp,1)>=(12-HPGrowth) then
			c:AddCounter(MAXHP_COUNTER,1)
			c:SetCounterLimit(HP_COUNTER,c:GetCounter(MAXHP_COUNTER))
			c:AddCounter(HP_COUNTER,1)
		end
		if Duel.TossDice(tp,1)+Duel.TossDice(tp,1)>=(12-SpGrowth) then c:AddCounter(SP_COUNTER,1) end
		if Duel.TossDice(tp,1)+Duel.TossDice(tp,1)>=(12-StrGrowth) then c:AddCounter(STR_COUNTER,1) end
		if Duel.TossDice(tp,1)+Duel.TossDice(tp,1)>=(12-MagGrowth) then c:AddCounter(MAG_COUNTER,1) end
		if Duel.TossDice(tp,1)+Duel.TossDice(tp,1)>=(12-LckGrowth) then c:AddCounter(LCK_COUNTER,1) end
		if Duel.TossDice(tp,1)+Duel.TossDice(tp,1)>=(12-SkillGrowth) then c:AddCounter(SKILL_COUNTER,1) end
		if Duel.TossDice(tp,1)+Duel.TossDice(tp,1)>=(12-DefGrowth) then c:AddCounter(DEF_COUNTER,1) end
	else
		s.evolve(c,e,tp)
	end
end

function s.evolve(c,e,tp)
	local code=c:GetCode()
	local class=_G["c"..code]
	if class==nil or class.lvupcount==nil then return false end
	if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,class,e,tp) then
		local hp=c:GetCounter(MAXHP_COUNTER)
		local sp=c:GetCounter(SP_COUNTER)
		local str=c:GetCounter(STR_COUNTER)
		local mag=c:GetCounter(MAG_COUNTER)
		local lck=c:GetCounter(LCK_COUNTER)
		local skill=c:GetCounter(SKILL_COUNTER)
		local def=c:GetCounter(DEF_COUNTER)
		local WepDur
		local eqg=c:GetEquipGroup()
		local eqf=eqg:GetFirst()
		local wep
		while eqf do
			if eqf:IsSetCard(0x64b) then 
				wep=eqf:GetCode() 
				WepDur=eqf:GetCounter(DUR_COUNTER)
			end
			eqf=eqg:GetNext()
		end
		Duel.SendtoGrave(c,REASON_COST)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,class,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP_ATTACK)
			tc:RegisterFlagEffect(0xfec17,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			tc:AddCounter(LV_COUNTER,1)
			tc:AddCounter(MAXHP_COUNTER,hp)
			tc:AddCounter(SP_COUNTER,sp)
			tc:AddCounter(STR_COUNTER,str)
			tc:AddCounter(MAG_COUNTER,mag)
			tc:AddCounter(LCK_COUNTER,lck)
			tc:AddCounter(SKILL_COUNTER,skill)
			tc:AddCounter(DEF_COUNTER,def)
			if wep then
				tc:RegisterFlagEffect(0xfee92,RESET_EVENT,0,1)
				local eq=Duel.CreateToken(tp,wep)
				Duel.Equip(tp,eq,tc)
				eq:AddCounter(DUR_COUNTER,WepDur)
			end
			if tc:GetPreviousLocation()==LOCATION_DECK then Duel.ShuffleDeck(tp) end
		end
	end
end
