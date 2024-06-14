local joker = {
    name = "Suspicious Joker", slug = "jimpostor",
    config = {}, rarity = 2, cost = 7, 
    blueprint_compat = true, 
    eternal_compat = true
}

joker.localization = {
    name = "贼心小丑",
    text = {
        "出牌后，使其牌型{C:attention}降级",
        "随后本牌获得{X:mult,C:white} X0.5 {}倍率",
        "{C:inactive}（当前为{X:mult,C:white} X#1# {C:inactive}倍率）"
    }
}

joker.calculate = function(self, context)
    if context.cardarea == G.jokers and context.before and not context.blueprint then
        if G.GAME.hands[context.scoring_name].level <= 1 then
            return
        end
        level_up_hand(context.blueprint_card or self, context.scoring_name, nil, -1)
        self.ability.x_mult = self.ability.x_mult + 0.5
        card_eval_status_text((context.blueprint_card or self), 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult}}})
    end
end

joker.loc_def = function(self)
    return { self.ability.x_mult }
end

return joker