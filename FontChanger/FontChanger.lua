local FontChanger = {}
FontChanger.Version = "1.0"
FontChanger.Path = "FontChanger/fonts/"

-- Сюда добавлять свои шрифты
FontChanger.Fonts = {
	["Univers 57"] = "univers57.otf",
	["Univers 67"] = "univers67.otf",
	["Futura Light"] = "ftn47.otf",
	["Futura Medium"] = "ftn57.otf",
	["Futura Bold"] = "ftn87.otf",
	["ProseAntique"] = "ProseAntique.otf",
	["Skyrim Handwritten"] = "handwritten_bold.ttf",
	["Trajan Pro"] = "trajanpro-regular.otf",
	["Comic Sans"] = "comic.ttf",
	["Kingthings Petrock"] = "KingthingsPetrockRus.TTF",
	--["Название шрифта для отображения в игре"] = "Название файла с расширением",
}

FontChanger.Defaults = {
	["MEDIUM_FONT"] = "Univers 57",
	["BOLD_FONT"] = "Univers 67",
	["CHAT_FONT"] = "Univers 57",
	["ANTIQUE_FONT"] = "ProseAntique",
	["HANDWRITTEN_FONT"] = "Skyrim Handwritten",
	["STONE_TABLET_FONT"] = "Trajan Pro",
	["MEDIUM_FONT_OFFSET"] = 0,
	["BOLD_FONT_OFFSET"] = 0,
	["CHAT_FONT_OFFSET"] = 0,
	["ANTIQUE_FONT_OFFSET"] = 0,
	["HANDWRITTEN_FONT_OFFSET"] = 0,
	["STONE_TABLET_FONT_OFFSET"] = 0,
}

FontChanger.Settings = FontChanger.Defaults

FontChanger.PanelData = {
    type = "panel",
    name = "Font Changer",
    author = "TERAB1T",
    version = FontChanger.Version,
    slashCommand = "/fontchanger",
    registerForRefresh = true,
    registerForDefaults = true,
	website = "https://elderscrolls.net/",
	reference = "FC_PANEL",
}

function FontChanger:GetChoices()
	local tempChoices = {}
	for key,value in pairs(FontChanger.Fonts) do --pseudocode
		table.insert(tempChoices, key)
	end
	return tempChoices
end

function FontChanger:Font(fontName)
	if FontChanger.Settings[fontName] ~= nil then
		return FontChanger.Path .. FontChanger.Fonts[FontChanger.Settings[fontName]]
	else
		return FontChanger.Path .. FontChanger.Fonts[FontChanger.Defaults[fontName]]
	end
end

FontChanger.OptionsTable = {
    [1] = {
		type = "header",
		name = "Стандартный шрифт",
		width = "full",
		reference = "FC_HEADER_MEDIUM_FONT",
	},
	[2] = {
		type = "dropdown",
		name = "Название шрифта",
		width = "full",
		choices = FontChanger:GetChoices(),
		sort = "name-up",
		default = "Univers 57",
		getFunc = function() return FontChanger.Settings["MEDIUM_FONT"] end,
        setFunc = (function(value)
			FontChanger.Settings["MEDIUM_FONT"] = value
			FontChanger:ReplaceFonts()
			FC_HEADER_MEDIUM_FONT.header:SetFont(FontChanger:Font("MEDIUM_FONT") .. "|24|soft-shadow-thick")
		end),
	},
	[3] = {
        type = "slider",
        name = "Размер шрифта",
        min = -10,
        max = 10,
        step = 1,
        getFunc = function() return FontChanger.Settings["MEDIUM_FONT_OFFSET"] end,
        setFunc = (function(value) 
			FontChanger.Settings["MEDIUM_FONT_OFFSET"] = value
			FontChanger:ReplaceFonts()
		end),
        width = "full",
        default = 0,
    },
	[4] = {
		type = "header",
		name = "Стандартный шрифт (жирный)",
		width = "full",	--or "half" (optional),
		reference = "FC_HEADER_BOLD_FONT",
	},
	[5] = {
		type = "dropdown",
		name = "Название шрифта",
		width = "full",	--or "half" (optional),
		choices = FontChanger:GetChoices(),
		sort = "name-up",
		default = "Univers 67",
		getFunc = function() return FontChanger.Settings["BOLD_FONT"] end,
        setFunc = (function(var)
			FontChanger.Settings["BOLD_FONT"] = var
			FontChanger:ReplaceFonts()
			FC_HEADER_MEDIUM_FONT.header:SetFont(FontChanger:Font("MEDIUM_FONT") .. "|24|soft-shadow-thick")
			FC_HEADER_BOLD_FONT.header:SetFont(FontChanger:Font("BOLD_FONT") .. "|24|soft-shadow-thick")
			FC_HEADER_CHAT_FONT.header:SetFont(FontChanger:Font("CHAT_FONT") .. "|24|soft-shadow-thick")
			FC_HEADER_ANTIQUE_FONT.header:SetFont(FontChanger:Font("ANTIQUE_FONT") .. "|24|soft-shadow-thick")
			FC_HEADER_HANDWRITTEN_FONT.header:SetFont(FontChanger:Font("HANDWRITTEN_FONT") .. "|24|soft-shadow-thick")
			FC_HEADER_STONE_TABLET_FONT.header:SetFont(FontChanger:Font("STONE_TABLET_FONT") .. "|24|soft-shadow-thick")
		end),
	},
	[6] = {
        type = "slider",
        name = "Размер шрифта",
        min = -10,
        max = 10,
        step = 1,
        getFunc = function() return FontChanger.Settings["BOLD_FONT_OFFSET"] end,
        setFunc = (function(value) 
			FontChanger.Settings["BOLD_FONT_OFFSET"] = value
			FontChanger:ReplaceFonts()
		end),
        width = "full",
        default = 0,
    },
	[7] = {
		type = "header",
		name = "Шрифт чата",
		width = "full",
		reference = "FC_HEADER_CHAT_FONT",
	},
	[8] = {
		type = "dropdown",
		name = "Название шрифта",
		width = "full",
		choices = FontChanger:GetChoices(),
		sort = "name-up",
		default = "Univers 57",
		getFunc = function() return FontChanger.Settings["CHAT_FONT"] end,
        setFunc = (function(value)
			FontChanger.Settings["CHAT_FONT"] = value
			FontChanger:ReplaceFonts()
			FC_HEADER_CHAT_FONT.header:SetFont(FontChanger:Font("CHAT_FONT") .. "|24|soft-shadow-thick")
		end),
	},
	[9] = {
        type = "slider",
        name = "Размер шрифта",
        min = -10,
        max = 10,
        step = 1,
        getFunc = function() return FontChanger.Settings["CHAT_FONT_OFFSET"] end,
        setFunc = (function(value) 
			FontChanger.Settings["CHAT_FONT_OFFSET"] = value
			FontChanger:ReplaceFonts()
		end),
        width = "full",
        default = 0,
    },
	[10] = {
		type = "header",
		name = "Шрифт книг",
		width = "full",
		reference = "FC_HEADER_ANTIQUE_FONT",
	},
	[11] = {
		type = "dropdown",
		name = "Название шрифта",
		width = "full",
		choices = FontChanger:GetChoices(),
		sort = "name-up",
		default = "ProseAntique",
		getFunc = function() return FontChanger.Settings["ANTIQUE_FONT"] end,
        setFunc = (function(value)
			FontChanger.Settings["ANTIQUE_FONT"] = value
			FontChanger:ReplaceFonts()
			FC_HEADER_ANTIQUE_FONT.header:SetFont(FontChanger:Font("ANTIQUE_FONT") .. "|24|soft-shadow-thick")
		end),
	},
	[12] = {
        type = "slider",
        name = "Размер шрифта",
        min = -10,
        max = 10,
        step = 1,
        getFunc = function() return FontChanger.Settings["ANTIQUE_FONT_OFFSET"] end,
        setFunc = (function(value) 
			FontChanger.Settings["ANTIQUE_FONT_OFFSET"] = value
			FontChanger:ReplaceFonts()
		end),
        width = "full",
        default = 0,
    },
	[13] = {
		type = "header",
		name = "Шрифт записок",
		width = "full",
		reference = "FC_HEADER_HANDWRITTEN_FONT",
	},
	[14] = {
		type = "dropdown",
		name = "Название шрифта",
		width = "full",
		choices = FontChanger:GetChoices(),
		sort = "name-up",
		default = "Skyrim Handwritten",
		getFunc = function() return FontChanger.Settings["HANDWRITTEN_FONT"] end,
        setFunc = (function(value)
			FontChanger.Settings["HANDWRITTEN_FONT"] = value
			FontChanger:ReplaceFonts()
			FC_HEADER_HANDWRITTEN_FONT.header:SetFont(FontChanger:Font("HANDWRITTEN_FONT") .. "|24|soft-shadow-thick")
		end),
	},
	[15] = {
        type = "slider",
        name = "Размер шрифта",
        min = -10,
        max = 10,
        step = 1,
        getFunc = function() return FontChanger.Settings["HANDWRITTEN_FONT_OFFSET"] end,
        setFunc = (function(value) 
			FontChanger.Settings["HANDWRITTEN_FONT_OFFSET"] = value
			FontChanger:ReplaceFonts()
		end),
        width = "full",
        default = 0,
    },
	[16] = {
		type = "header",
		name = "Шрифт табличек",
		width = "full",
		reference = "FC_HEADER_STONE_TABLET_FONT",
	},
	[17] = {
		type = "dropdown",
		name = "Название шрифта",
		width = "full",
		choices = FontChanger:GetChoices(),
		sort = "name-up",
		default = "Trajan Pro",
		getFunc = function() return FontChanger.Settings["STONE_TABLET_FONT"] end,
        setFunc = (function(value)
			FontChanger.Settings["STONE_TABLET_FONT"] = value
			FontChanger:ReplaceFonts()
			FC_HEADER_STONE_TABLET_FONT.header:SetFont(FontChanger:Font("STONE_TABLET_FONT") .. "|24|soft-shadow-thick")
		end),
	},
	[18] = {
        type = "slider",
        name = "Размер шрифта",
        min = -10,
        max = 10,
        step = 1,
        getFunc = function() return FontChanger.Settings["STONE_TABLET_FONT_OFFSET"] end,
        setFunc = (function(value) 
			FontChanger.Settings["STONE_TABLET_FONT_OFFSET"] = value
			FontChanger:ReplaceFonts()
		end),
        width = "full",
        default = 0,
    }, 
}

function FontChanger:OnInit(eventCode, addOnName)
	if zo_strlower(addOnName) ~= zo_strlower("FontChanger") then return end
	EVENT_MANAGER:UnregisterForEvent("FontChanger_OnAddOnLoaded", EVENT_ADD_ON_LOADED)
	
	FontChanger.Settings = ZO_SavedVars:NewAccountWide("FontChangerVariables", 1, nil, FontChanger.Defaults)
	
	local LAM = LibStub("LibAddonMenu-2.0")
	FontChanger.ConfigPanel = LAM:RegisterAddonPanel("FontChanger", FontChanger.PanelData)
	LAM:RegisterOptionControls("FontChanger", FontChanger.OptionsTable)
	
	local UpdateHeaders
    UpdateHeaders = function(panel)	
		if panel == FontChanger.ConfigPanel then
			FC_HEADER_MEDIUM_FONT.header:SetFont(FontChanger:Font("MEDIUM_FONT") .. "|24|soft-shadow-thick")
			FC_HEADER_BOLD_FONT.header:SetFont(FontChanger:Font("BOLD_FONT") .. "|24|soft-shadow-thick")
			FC_HEADER_CHAT_FONT.header:SetFont(FontChanger:Font("CHAT_FONT") .. "|24|soft-shadow-thick")
			FC_HEADER_ANTIQUE_FONT.header:SetFont(FontChanger:Font("ANTIQUE_FONT") .. "|24|soft-shadow-thick")
			FC_HEADER_HANDWRITTEN_FONT.header:SetFont(FontChanger:Font("HANDWRITTEN_FONT") .. "|24|soft-shadow-thick")
			FC_HEADER_STONE_TABLET_FONT.header:SetFont(FontChanger:Font("STONE_TABLET_FONT") .. "|24|soft-shadow-thick")
			CALLBACK_MANAGER:UnregisterCallback("LAM-PanelControlsCreated", UpdateHeaders)
		end
    end
    CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", UpdateHeaders)
	
	FontChanger:ReplaceFonts()
end

function FontChanger:ReplaceFonts()
	ZoFontWinH1 = CreateFont("ZoFontWinH1")
	ZoFontWinH1:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (30 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontWinH2 = CreateFont("ZoFontWinH2")
	ZoFontWinH2:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (24 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontWinH3 = CreateFont("ZoFontWinH3")
	ZoFontWinH3:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (20 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontWinH4 = CreateFont("ZoFontWinH4")
	ZoFontWinH4:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontWinH5 = CreateFont("ZoFontWinH5")
	ZoFontWinH5:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (16 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoFontWinH3SoftShadowThin = CreateFont("ZoFontWinH3SoftShadowThin")
	ZoFontWinH3SoftShadowThin:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (20 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thin")

	ZoFontWinT1 = CreateFont("ZoFontWinT1")
	ZoFontWinT1:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thin")
	ZoFontWinT2 = CreateFont("ZoFontWinT2")
	ZoFontWinT2:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (16 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thin")

	ZoFontGame = CreateFont("ZoFontGame")
	ZoFontGame:SetFont(FontChanger:Font("MEDIUM_FONT") .. "|" .. (18 + FontChanger.Settings["MEDIUM_FONT_OFFSET"]) .. "|soft-shadow-thin")
	ZoFontGameMedium = CreateFont("ZoFontGameMedium")
	ZoFontGameMedium:SetFont(FontChanger:Font("MEDIUM_FONT") .. "|" .. (18 + FontChanger.Settings["MEDIUM_FONT_OFFSET"]) .. "|soft-shadow-thin")
	ZoFontGameBold = CreateFont("ZoFontGameBold")
	ZoFontGameBold:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thin")
	ZoFontGameOutline = CreateFont("ZoFontGameOutline")
	ZoFontGameOutline:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thin")    
	ZoFontGameShadow = CreateFont("ZoFontGameShadow")
	ZoFontGameShadow:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thin")

	ZoFontKeyboard28ThickOutline = CreateFont("ZoFontKeyboard28ThickOutline")
	ZoFontKeyboard28ThickOutline:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (28 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|thick-outline")
	ZoFontKeyboard24ThickOutline = CreateFont("ZoFontKeyboard24ThickOutline")
	ZoFontKeyboard24ThickOutline:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (24 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|thick-outline")
	ZoFontKeyboard18ThickOutline = CreateFont("ZoFontKeyboard18ThickOutline")
	ZoFontKeyboard18ThickOutline:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|thick-outline")

	ZoFontGameSmall = CreateFont("ZoFontGameSmall")
	ZoFontGameSmall:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (13 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thin")
	ZoFontGameLarge = CreateFont("ZoFontGameLarge")
	ZoFontGameLarge:SetFont(FontChanger:Font("MEDIUM_FONT") .. "|" .. (18 + FontChanger.Settings["MEDIUM_FONT_OFFSET"]) .. "|soft-shadow-thin")
	ZoFontGameLargeBold = CreateFont("ZoFontGameLargeBold")
	ZoFontGameLargeBold:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontGameLargeBoldShadow = CreateFont("ZoFontGameLargeBoldShadow")
	ZoFontGameLargeBoldShadow:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoFontHeader = CreateFont("ZoFontHeader")
	ZoFontHeader:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontHeader2 = CreateFont("ZoFontHeader2")
	ZoFontHeader2:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (20 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontHeader3 = CreateFont("ZoFontHeader3")
	ZoFontHeader3:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (24 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontHeader4 = CreateFont("ZoFontHeader4")
	ZoFontHeader4:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (26 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoFontHeaderNoShadow = CreateFont("ZoFontHeaderNoShadow")
	ZoFontHeaderNoShadow:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]))

	ZoFontCallout = CreateFont("ZoFontCallout")
	ZoFontCallout:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (36 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontCallout2 = CreateFont("ZoFontCallout2")
	ZoFontCallout2:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (48 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontCallout3 = CreateFont("ZoFontCallout3")
	ZoFontCallout3:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (54 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoFontEdit = CreateFont("ZoFontEdit")
	ZoFontEdit:SetFont(FontChanger:Font("MEDIUM_FONT") .. "|" .. (18 + FontChanger.Settings["MEDIUM_FONT_OFFSET"]) .. "|shadow")
	ZoFontEdit20NoShadow = CreateFont("ZoFontEdit20NoShadow")
	ZoFontEdit20NoShadow:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (20 + FontChanger.Settings["BOLD_FONT_OFFSET"]))

	ZoFontChat = CreateFont("ZoFontChat")
	ZoFontChat:SetFont(FontChanger:Font("CHAT_FONT") .. "|" .. (18 + FontChanger.Settings["CHAT_FONT_OFFSET"]) .. "|soft-shadow-thin")
	ZoFontEditChat = CreateFont("ZoFontEditChat")
	ZoFontEditChat:SetFont(FontChanger:Font("CHAT_FONT") .. "|" .. (18 + FontChanger.Settings["CHAT_FONT_OFFSET"]) .. "|shadow")

	ZoFontWindowTitle = CreateFont("ZoFontWindowTitle")
	ZoFontWindowTitle:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (30 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontWindowSubtitle = CreateFont("ZoFontWindowSubtitle")
	ZoFontWindowSubtitle:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoFontTooltipTitle = CreateFont("ZoFontTooltipTitle")
	ZoFontTooltipTitle:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (22 + FontChanger.Settings["BOLD_FONT_OFFSET"]))
	ZoFontTooltipSubtitle = CreateFont("ZoFontTooltipSubtitle")
	ZoFontTooltipSubtitle:SetFont(FontChanger:Font("MEDIUM_FONT") .. "|" .. (18 + FontChanger.Settings["MEDIUM_FONT_OFFSET"]))

	ZoFontAnnounce = CreateFont("ZoFontAnnounce")
	ZoFontAnnounce:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (28 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontAnnounceMessage = CreateFont("ZoFontAnnounceMessage")
	ZoFontAnnounceMessage:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (24 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontAnnounceMedium = CreateFont("ZoFontAnnounceMedium")
	ZoFontAnnounceMedium:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (24 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontAnnounceLarge = CreateFont("ZoFontAnnounceLarge")
	ZoFontAnnounceLarge:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (36 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoFontAnnounceLargeNoShadow = CreateFont("ZoFontAnnounceLargeNoShadow")
	ZoFontAnnounceLargeNoShadow:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (36 + FontChanger.Settings["BOLD_FONT_OFFSET"]))

	ZoFontCenterScreenAnnounceLarge = CreateFont("ZoFontCenterScreenAnnounceLarge")
	ZoFontCenterScreenAnnounceLarge:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (40 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontCenterScreenAnnounceSmall = CreateFont("ZoFontCenterScreenAnnounceSmall")
	ZoFontCenterScreenAnnounceSmall:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (30 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoFontAlert = CreateFont("ZoFontAlert")
	ZoFontAlert:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (24 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoFontConversationName = CreateFont("ZoFontConversationName")
	ZoFontConversationName:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (28 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontConversationText = CreateFont("ZoFontConversationText")
	ZoFontConversationText:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (24 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontConversationOption = CreateFont("ZoFontConversationOption")
	ZoFontConversationOption:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (22 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontConversationQuestReward = CreateFont("ZoFontConversationQuestReward")
	ZoFontConversationQuestReward:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (20 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoFontKeybindStripKey = CreateFont("ZoFontKeybindStripKey")
	ZoFontKeybindStripKey:SetFont(FontChanger:Font("MEDIUM_FONT") .. "|" .. (20 + FontChanger.Settings["MEDIUM_FONT_OFFSET"]) .. "|soft-shadow-thin")
	ZoFontKeybindStripDescription = CreateFont("ZoFontKeybindStripDescription")
	ZoFontKeybindStripDescription:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (25 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontDialogKeybindDescription = CreateFont("ZoFontDialogKeybindDescription")
	ZoFontDialogKeybindDescription:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (20 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoInteractionPrompt = CreateFont("ZoInteractionPrompt")
	ZoInteractionPrompt:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (24 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoFontCreditsHeader = CreateFont("ZoFontCreditsHeader")
	ZoFontCreditsHeader:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (24 + FontChanger.Settings["BOLD_FONT_OFFSET"]))
	ZoFontCreditsText = CreateFont("ZoFontCreditsText")
	ZoFontCreditsText:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (18 + FontChanger.Settings["BOLD_FONT_OFFSET"]))

	ZoFontSubtitleText = CreateFont("ZoFontSubtitleText")
	ZoFontSubtitleText:SetFont(FontChanger:Font("MEDIUM_FONT") .. "|" .. (28 + FontChanger.Settings["MEDIUM_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoMarketAnnouncementKeyboardDescriptionFont = CreateFont("ZoMarketAnnouncementKeyboardDescriptionFont")
	ZoMarketAnnouncementKeyboardDescriptionFont:SetFont(FontChanger:Font("MEDIUM_FONT") .. "|" .. (22 + FontChanger.Settings["MEDIUM_FONT_OFFSET"]))
	ZoMarketAnnouncementCalloutFont = CreateFont("ZoMarketAnnouncementCalloutFont")
	ZoMarketAnnouncementCalloutFont:SetFont(FontChanger:Font("BOLD_FONT") .. "|" .. (32 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thin")

	ZoFontBookPaper = CreateFont("ZoFontBookPaper")
	ZoFontBookPaper:SetFont(FontChanger:Font("ANTIQUE_FONT") .. "|" .. (20 + FontChanger.Settings["ANTIQUE_FONT_OFFSET"]))
	ZoFontBookSkin = CreateFont("ZoFontBookSkin")
	ZoFontBookSkin:SetFont(FontChanger:Font("ANTIQUE_FONT") .. "|" .. (20 + FontChanger.Settings["ANTIQUE_FONT_OFFSET"]))
	ZoFontBookRubbing = CreateFont("ZoFontBookRubbing")
	ZoFontBookRubbing:SetFont(FontChanger:Font("ANTIQUE_FONT") .. "|" .. (20 + FontChanger.Settings["ANTIQUE_FONT_OFFSET"]))
	ZoFontBookLetter = CreateFont("ZoFontBookLetter")
	ZoFontBookLetter:SetFont(FontChanger:Font("HANDWRITTEN_FONT") .. "|" .. (20 + FontChanger.Settings["HANDWRITTEN_FONT_OFFSET"]))
	ZoFontBookNote = CreateFont("ZoFontBookNote")
	ZoFontBookNote:SetFont(FontChanger:Font("HANDWRITTEN_FONT") .. "|" .. (22 + FontChanger.Settings["HANDWRITTEN_FONT_OFFSET"]))
	ZoFontBookScroll = CreateFont("ZoFontBookScroll")
	ZoFontBookScroll:SetFont(FontChanger:Font("HANDWRITTEN_FONT") .. "|" .. (26 + FontChanger.Settings["HANDWRITTEN_FONT_OFFSET"]))
	ZoFontBookTablet = CreateFont("ZoFontBookTablet")
	ZoFontBookTablet:SetFont(FontChanger:Font("STONE_TABLET_FONT") .. "|" .. (30 + FontChanger.Settings["STONE_TABLET_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontBookMetal = CreateFont("ZoFontBookMetal")
	ZoFontBookMetal:SetFont(FontChanger:Font("ANTIQUE_FONT") .. "|" .. (20 + FontChanger.Settings["ANTIQUE_FONT_OFFSET"]) .. "|soft-shadow-thick")

	ZoFontBookPaperTitle = CreateFont("ZoFontBookPaperTitle")
	ZoFontBookPaperTitle:SetFont(FontChanger:Font("ANTIQUE_FONT") .. "|" .. (30 + FontChanger.Settings["ANTIQUE_FONT_OFFSET"]))
	ZoFontBookSkinTitle = CreateFont("ZoFontBookSkinTitle")
	ZoFontBookSkinTitle:SetFont(FontChanger:Font("ANTIQUE_FONT") .. "|" .. (30 + FontChanger.Settings["ANTIQUE_FONT_OFFSET"]))
	ZoFontBookRubbingTitle = CreateFont("ZoFontBookRubbingTitle")
	ZoFontBookRubbingTitle:SetFont(FontChanger:Font("ANTIQUE_FONT") .. "|" .. (30 + FontChanger.Settings["ANTIQUE_FONT_OFFSET"]))
	ZoFontBookLetterTitle = CreateFont("ZoFontBookLetterTitle")
	ZoFontBookLetterTitle:SetFont(FontChanger:Font("HANDWRITTEN_FONT") .. "|" .. (30 + FontChanger.Settings["HANDWRITTEN_FONT_OFFSET"]))
	ZoFontBookNoteTitle = CreateFont("ZoFontBookNoteTitle")
	ZoFontBookNoteTitle:SetFont(FontChanger:Font("HANDWRITTEN_FONT") .. "|" .. (32 + FontChanger.Settings["HANDWRITTEN_FONT_OFFSET"]))
	ZoFontBookScrollTitle = CreateFont("ZoFontBookScrollTitle")
	ZoFontBookScrollTitle:SetFont(FontChanger:Font("HANDWRITTEN_FONT") .. "|" .. (34 + FontChanger.Settings["HANDWRITTEN_FONT_OFFSET"]))
	ZoFontBookTabletTitle = CreateFont("ZoFontBookTabletTitle")
	ZoFontBookTabletTitle:SetFont(FontChanger:Font("STONE_TABLET_FONT") .. "|" .. (48 + FontChanger.Settings["STONE_TABLET_FONT_OFFSET"]) .. "|soft-shadow-thick")
	ZoFontBookMetalTitle = CreateFont("ZoFontBookMetalTitle")
	ZoFontBookMetalTitle:SetFont(FontChanger:Font("ANTIQUE_FONT") .. "|" .. (30 + FontChanger.Settings["ANTIQUE_FONT_OFFSET"]) .. "|soft-shadow-thick")

	if LibStub then
		local LMP = LibStub("LibMediaProvider-1.0", true)
		if LMP then
			LMP.MediaTable.font["Univers 67"] = nil 
			LMP.MediaTable.font["Univers 57"] = nil
			LMP.MediaTable.font["Univers 55"] = nil
			LMP.MediaTable.font["Skyrim Handwritten"] = nil
			LMP.MediaTable.font["ProseAntique"] = nil
			LMP.MediaTable.font["Trajan Pro"] = nil
			LMP:Register("font", "Univers 67", FontChanger:Font("BOLD_FONT"))
			LMP:Register("font", "Univers 57", FontChanger:Font("MEDIUM_FONT"))
			LMP:Register("font", "Univers 55", FontChanger:Font("MEDIUM_FONT"))
			LMP:Register("font", "Skyrim Handwritten", FontChanger:Font("HANDWRITTEN_FONT"))
			LMP:Register("font", "ProseAntique", FontChanger:Font("ANTIQUE_FONT"))
			LMP:Register("font", "Trajan Pro", FontChanger:Font("STONE_TABLET_FONT"))
			LMP:SetDefault("font", "Univers 57")
		end
	end
	
	if LWF3 then
		LWF3.data.Fonts = {
			["ESO Cartographer"] = FontChanger:Font("MEDIUM_FONT"),
			["Fontin Bold"] = FontChanger:Font("MEDIUM_FONT"),
			["Fontin Italic"] = FontChanger:Font("MEDIUM_FONT"),
			["Fontin Regular"] = FontChanger:Font("MEDIUM_FONT"),
			["Fontin SmallCaps"] = FontChanger:Font("MEDIUM_FONT"),
			["ProseAntique"] = FontChanger:Font("ANTIQUE_FONT"),
			["Skyrim Handwritten"]= FontChanger:Font("HANDWRITTEN_FONT"),
			["Trajan Pro"] = FontChanger:Font("STONE_TABLET_FONT"),
			["Univers 55"] = FontChanger:Font("MEDIUM_FONT"),
			["Univers 57"] = FontChanger:Font("MEDIUM_FONT"),
			["Univers 67"] = FontChanger:Font("BOLD_FONT"),
		}
	end
	
	if LWF4 then
		LWF4.data.Fonts = {
			["ESO Cartographer"] = FontChanger:Font("MEDIUM_FONT"),
			["Fontin Bold"] = FontChanger:Font("MEDIUM_FONT"),
			["Fontin Italic"] = FontChanger:Font("MEDIUM_FONT"),
			["Fontin Regular"] = FontChanger:Font("MEDIUM_FONT"),
			["Fontin SmallCaps"] = FontChanger:Font("MEDIUM_FONT"),
			["ProseAntique"] = FontChanger:Font("ANTIQUE_FONT"),
			["Skyrim Handwritten"]= FontChanger:Font("HANDWRITTEN_FONT"),
			["Trajan Pro"] = FontChanger:Font("STONE_TABLET_FONT"),
			["Univers 55"] = FontChanger:Font("MEDIUM_FONT"),
			["Univers 57"] = FontChanger:Font("MEDIUM_FONT"),
			["Univers 67"] = FontChanger:Font("BOLD_FONT"),
		}
	end
	
	FontChanger:OnPlayerActivatedReplaceFonts()
end

function FontChanger:OnPlayerActivatedReplaceFonts()
	ZO_ChatWindowTextEntryEditBox:SetFont(FontChanger:Font("CHAT_FONT") .. "|" .. GetChatFontSize() .. "|shadow")
	ZO_ChatWindowTextEntryLabel:SetFont("ZoFontChat")
	SetSCTKeyboardFont(FontChanger:Font("BOLD_FONT") .. "|" .. (29 + FontChanger.Settings["BOLD_FONT_OFFSET"]) .. "|soft-shadow-thick")
	SetNameplateKeyboardFont(FontChanger:Font("BOLD_FONT"), 4)
end

EVENT_MANAGER:RegisterForEvent("FontChanger_OnAddOnLoaded", EVENT_ADD_ON_LOADED, function(_event, _name) FontChanger:OnInit(_event, _name) end)
EVENT_MANAGER:RegisterForEvent("FontChanger_OnPlayerActivated", EVENT_PLAYER_ACTIVATED, function(...) FontChanger:OnPlayerActivatedReplaceFonts() end)