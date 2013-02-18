--激流蘇生
function c7092142.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c7092142.condition)
	e1:SetCost(c7092142.cost)
	e1:SetTarget(c7092142.target)
	e1:SetOperation(c7092142.operation)
	c:RegisterEffect(e1)
end
function c7092142.cfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsAttribute(ATTRIBUTE_WATER)
end
function c7092142.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7092142.cfilter,1,nil,tp)
end
function c7092142.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,7092142)==0 end
	Duel.RegisterFlagEffect(tp,7092142,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c7092142.spfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7092142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=eg:FilterCount(c7092142.spfilter,nil,e,tp)
		return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
	end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c7092142.spfilter,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c7092142.spfilter2(c,e,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7092142.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=eg:Filter(c7092142.spfilter2,nil,e,tp)
	if ft<sg:GetCount() then return end
	local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
