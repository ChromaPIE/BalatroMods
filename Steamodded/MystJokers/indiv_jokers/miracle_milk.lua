local joker = {
    name = "Miracle Milk", slug = "miracle_milk",
    config = {extra = 0}, rarity = 1, cost = 4, 
    blueprint_compat = true, 
    eternal_compat = true
}

joker.localization = {
    name = "奇妙牛奶",
    text = {
        "使所有{C:attention}失效{}的牌在计分时{C:attention}复原",
        "每{C:attention}复原{}一张牌，本牌获得{C:chips}+10{}筹码",
        "{C:inactive}（当前为{C:chips}+#1#{C:inactive}筹码）"
    }
}

joker.calculate = function(self, context)
    if context.cardarea == G.jokers and context.before and context.scoring_hand and not context.blueprint then
        local cleanses = 0
        for _, v in ipairs(context.scoring_hand) do
            if v.debuff then
                cleanses = cleanses + 1
                v.debuff = false
                G.E_MANAGER:add_event(Event({
                    func = function()
                        v:juice_up()
                        return true
                    end
                }))
            end
        end

        if cleanses > 0 then
            self.ability.extra = self.ability.extra + 10 * cleanses
            return {
                message = localize('k_cleansed'),
                colour = G.C.JOKER_GREY,
                card = self
            }
        end
    end

    if SMODS.end_calculate_context(context) then
        return {
            message = localize{type='variable',key='a_chips',vars={self.ability.extra}},
            chip_mod = self.ability.extra, 
            colour = G.C.CHIPS
        }
    end
end

joker.loc_def = function(self)
    return { self.ability.extra }
end

return joker