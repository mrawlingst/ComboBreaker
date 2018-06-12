-- Based on ComboHitCounters by Marcelino Porcar (@MalkiosED)
-- Made by Zoids (Zularam of US-Ner'zhul)
-- Addon to provide some fun to hit combo mechanic with flavor texts

local tier1Combos = {
    "Super",
    "Great",
    "Superb",
    "Terrific",
    "Cool",
    "Groovy",
    "Hot",
    "Matchless",
    "Neat",
    "Incomparable"
}

local tier2Combos = {
    "Amazing",
    "Incredible",
    "Hyper",
    "Shocking",
    "Stunning",
    "Unbelievable",
}

local tier3Combos = {
    "Brutal",
    "Barbarous",
    "Ferocious",
    "Inhuman",
    "Merciless",
    "Ruthless",
    "Savage",
    "Vicious",
    "Bloodthirsty",
}

local tier4Combos = {
    "Master",
    "Ace",
    "Crack",
    "Expert",
    "Champion",
    "Savvy",
}

local tier5Combos = {
    "Monster",
    "Beast",
    "Behemoth",
    "Freak",
    "Whale",
    "Titan",
    "Colossal",
    "Gargantuan",
    "Herculean",
    "Jumbo"
}

local tier6Combos = {
    "Killer",
    "Guerrilla",
    "Slayer",
    "Torpedo",
    "Butcher",
    "Deadly",
    "Cutthroat",
    "Aggressive",
    "Ambitious",
    "Lulu"
}

local tier7Combos = {
    "God",
    "Demigod",
    "Demon",
    "Devil",
    "Jehovah",
    "Divine",
    "Unholy",
    "Allah"
}

-- Current state of combo
local comboState = false
-- Counts of combo
local combo = 0

local hit_delta = 8
local desc_delta = 8

-- Hide hit frame when time expires
local function HitFrame_OnUpdate()
    if HitFrame_Time < GetTime() - hit_delta then
        local alpha = ComboBreaker_HitFrame:GetAlpha()
        if alpha ~= 0 then
            ComboBreaker_HitFrame:SetAlpha(alpha - 0.5)
            ComboBreaker_DescriptionFrame:SetAlpha(alpha - 0.5)
        end
        if alpha == 0 then
            ComboBreaker_HitFrame:Hide()
            ComboBreaker_DescriptionFrame:Hide()
            if ComboBreaker_HitFrame:IsMouseEnabled() then
                ComboBreaker_HitFrame:EnableMouse(false)
                ComboBreaker_DescriptionFrame:EnableMouse(false)
            end
        end
    end
end

-- Hide description frame when time expires
local function DescriptionFrame_OnUpdate()
    if DescFrame_Time < GetTime() - desc_delta then
        local alpha = ComboBreaker_DescriptionFrame:GetAlpha()
        if alpha ~= 0 then
            ComboBreaker_DescriptionFrame:SetAlpha(alpha - 0.5)
        end
        if alpha == 0 then
            ComboBreaker_DescriptionFrame:Hide()
            if ComboBreaker_DescriptionFrame:IsMouseEnabled() then
                ComboBreaker_DescriptionFrame:EnableMouse(false)
            end
        end
    end
end

-- Frame for hit combo
ComboBreaker_HitFrame = CreateFrame("Frame", "ComboBreaker_HitFrame", UIParent);
ComboBreaker_HitFrame:SetMovable(true)
ComboBreaker_HitFrame:SetUserPlaced(true)
ComboBreaker_HitFrame:EnableMouse(false)
ComboBreaker_HitFrame:SetHeight(150)
ComboBreaker_HitFrame:SetWidth(1000)
ComboBreaker_HitFrame:Hide()
ComboBreaker_HitFrame.text = ComboBreaker_HitFrame:CreateFontString(nil, "BACKGROUND")
ComboBreaker_HitFrame.text:SetAllPoints()
ComboBreaker_HitFrame:SetPoint("CENTER", 0, 300)
ComboBreaker_HitFrame:SetScript("OnUpdate", HitFrame_OnUpdate)
ComboBreaker_HitFrame:RegisterForDrag("LeftButton")
ComboBreaker_HitFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
ComboBreaker_HitFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
HitFrame_Time = 0

-- Frame for combo description
ComboBreaker_DescriptionFrame = CreateFrame("Frame", "ComboBreaker_DescriptionFrame", UIParent)
ComboBreaker_DescriptionFrame:SetMovable(true)
ComboBreaker_DescriptionFrame:SetUserPlaced(true)
ComboBreaker_DescriptionFrame:EnableMouse(false)
ComboBreaker_DescriptionFrame:SetHeight(150)
ComboBreaker_DescriptionFrame:SetWidth(1000)
ComboBreaker_DescriptionFrame:Hide()
ComboBreaker_DescriptionFrame.text = ComboBreaker_DescriptionFrame:CreateFontString(nil, "BACKGROUND")
ComboBreaker_DescriptionFrame.text:SetAllPoints()
ComboBreaker_DescriptionFrame:SetPoint("CENTER", 0, 100)
ComboBreaker_DescriptionFrame:SetScript("OnUpdate", DescriptionFrame_OnUpdate)
ComboBreaker_DescriptionFrame:RegisterForDrag("LeftButton")
ComboBreaker_DescriptionFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
ComboBreaker_DescriptionFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
DescFrame_Time = 0


-- Slash Command
SLASH_COMBOBREAKER1 = "/combobreaker"

function SlashCmdList.COMBOBREAKER()
    if ComboBreaker_HitFrame:IsMouseEnabled() then
        ComboBreaker_HitFrame:EnableMouse(false)
        ComboBreaker_DescriptionFrame:EnableMouse(false)
    else
        HitFrame_DisplayMessage("Move Me", 40)
        ComboBreaker_HitFrame:EnableMouse(true)
        ComboBreaker_DescriptionFrame.text:SetTextColor(0.5, 1, 0.5, 1)
        DescriptionFrame_DisplayMessage("Move me also!", 50)
        ComboBreaker_DescriptionFrame:EnableMouse(true)
    end
end

-- Text Messages
function HitFrame_DisplayMessage(message, size)
    ComboBreaker_HitFrame.text:SetFont("Interface\\AddOns\\ComboBreaker\\Media\\FEASFBRG.ttf", size, "OUTLINE")
    ComboBreaker_HitFrame.text:SetText(message)
    ComboBreaker_HitFrame:SetAlpha(1)
    ComboBreaker_HitFrame:Show()
    HitFrame_Time = GetTime()
end

function DescriptionFrame_DisplayMessage(message, size)
    ComboBreaker_DescriptionFrame.text:SetFont("Interface\\AddOns\\ComboBreaker\\Media\\FEASFBRG.ttf", size, "OUTLINE")
    ComboBreaker_DescriptionFrame.text:SetText(message .. " combo")
    ComboBreaker_DescriptionFrame:SetAlpha(1)
    ComboBreaker_DescriptionFrame:Show()
    DescFrame_Time = GetTime()
end

-- Change color of text
function ComboBreaker_SetTextColor(red, green, blue)
    ComboBreaker_HitFrame.text:SetTextColor(red, green, blue, 1)
end

-- Display with combo indicator
function ComboBreaker_DisplayCombo()
    ComboBreaker_HitFrame.text:SetTextColor(1, 1, 1, 1)
    combo_message = combo .. "x hits"
    size = 40

    if combo >= 300 then
        combo_message = combo .. "x MIKE-LEVEL combo"
        size = 80
        ComboBreaker_HitFrame.text:SetTextColor(1, 0.019, 0)
    else
        ComboBreaker_DisplayDescription()
    end

    HitFrame_DisplayMessage(combo_message, size)
end

function ComboBreaker_DisplayDescription()
    -- Tier 1
    if combo == 10 or combo == 20 then
        ComboBreaker_DescriptionFrame.text:SetTextColor(0.117, 0.98, 0.56)
        DescriptionFrame_DisplayMessage(tier1Combos[math.random(#tier1Combos)], 50)
    -- Tier 2
    elseif combo == 30 or combo == 50 then
        ComboBreaker_DescriptionFrame.text:SetTextColor(1, 0.87, 0)
        DescriptionFrame_DisplayMessage(tier2Combos[math.random(#tier2Combos)], 50)
    -- Tier 3
    elseif combo == 70 then
        ComboBreaker_DescriptionFrame.text:SetTextColor(0.39, 0.6, 1)
        DescriptionFrame_DisplayMessage(tier3Combos[math.random(#tier3Combos)], 60)
    -- Tier 4
    elseif combo == 100 then
        ComboBreaker_DescriptionFrame.text:SetTextColor(0.36, 1, 0.039)
        DescriptionFrame_DisplayMessage(tier4Combos[math.random(#tier4Combos)], 60)
    -- Tier 5
    elseif combo == 150 then
        ComboBreaker_DescriptionFrame.text:SetTextColor(1, 0.6, 0)
        DescriptionFrame_DisplayMessage(tier5Combos[math.random(#tier5Combos)], 70)
    -- Tier 6
    elseif combo == 200 then
        ComboBreaker_DescriptionFrame.text:SetTextColor(0.8, 0.4, 0)
        DescriptionFrame_DisplayMessage(tier6Combos[math.random(#tier6Combos)], 70)
    -- Tier 7
    elseif combo == 250 then
        ComboBreaker_DescriptionFrame.text:SetTextColor(0.980, 0.674, 0.117)
        DescriptionFrame_DisplayMessage(tier7Combos[math.random(#tier7Combos)], 70)
    end
end

--
local frame = CreateFrame("FRAME")
frame:RegisterUnitEvent("UNIT_AURA", "player")
frame:SetScript("OnEvent", function()
    -- Check and make sure the player is a Windwalker Monk
    local _, _, class = UnitClass("player")
    local spec = GetSpecialization()
    if class ~= 10 or spec ~= 3 then
        return nil
    end

    -- Check if player has Hit Combo buff
    if UnitBuff("player", GetSpellInfo(196740)) then
        local _, _, _, count, _, duration, expireTime = UnitBuff("player", GetSpellInfo(196740))
        if duration + GetTime() ~= expireTime and count > 0 then
            return nil
        end

        if not comboState then
            comboState = true
            combo = 0
        end

        combo = combo + 1
        ComboBreaker_DisplayCombo()

    -- Hit Combo buff expired and ending the combo
    elseif UnitBuff("player", GetSpellInfo(196740)) == nil and comboState then
        comboState = false
        ComboBreaker_SetTextColor(1, 1, 1)
        HitFrame_DisplayMessage("C-c-c-c-combo breaker! Max combo: " .. combo .. "", 30)
        combo = 0
    end
end)
