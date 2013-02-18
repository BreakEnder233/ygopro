--魔導書の神判
function c46448938.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c46448938.cost)
	e1:SetOperation(c46448938.activate)
	c:RegisterEffect(e1)
end
function c46448938.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,46448938)==0 end
	Duel.RegisterFlagEffect(tp,46448938,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c46448938.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c46448938.regcon)
	e1:SetOperation(c46448938.regop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetCondition(c46448938.regcon)
	e2:SetOperation(c46448938.regop2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(46448938,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetTarget(c46448938.efftg)
	e3:SetOperation(c46448938.effop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
end
function c46448938.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c46448938.regop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(ct+1)
end
function c46448938.regop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if ct==0 then ct=1 end
	e:GetLabelObject():SetLabel(ct-1)
end
function c46448938.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c46448938.sfilter(c)
	return c:IsSetCard(0x106e) and c:GetCode()~=46448938 and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c46448938.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c46448938.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c46448938.sfilter,tp,LOCATION_DECK,0,1,e:GetLabel(),nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c46448938.spfilter,tp,LOCATION_DECK,0,1,nil,g:GetCount(),e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(46448938,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c46448938.spfilter,tp,LOCATION_DECK,0,1,1,nil,g:GetCount(),e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
