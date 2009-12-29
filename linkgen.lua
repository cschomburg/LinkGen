local region = "eu"
local armory = "www.armory-light.com"

local types = {}

function types.target(unit)
	if(not UnitExists(unit)) then return end

	if(UnitIsPlayer(unit)) then
		local name, realm = UnitName(unit)
		realm = (not realm or realm == "") and GetRealmName() or realm
		return ("http://%s/%s/%s/%s"):format(armory, region, realm, name)
	else
		id = tonumber("0x"..UnitGUID(unit):sub(9, 12))
		return ("http://www.wowhead.com/?npc=%d"):format(id)
	end
end
types.tar = types.target
types.player = types.target
types.mouseover = types.target

function LinkGen(text)
	text = text:trim():lower()
	text = text == "" and "target" or text
	if(types[text]) then
		return types[text](text)
	else
		local type, id = text:match("|h(%a+):(%d+)")
		if(not type or not id) then return end
		return ("http://www.wowhead.com/?%s=%s"):format(type, id)
	end
end

StaticPopupDialogs["LINKGEN"] = {
	text = "LinkGen",
	button2 = CANCEL,
	hasEditBox = true,
    	hasWideEditBox = true,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	whileDead = 1,
	maxLetters = 255,
}

SLASH_LINKGEN1 = "/l"
SLASH_LINKGEN2 = "/lg"
SLASH_LINKGEN3 = "/linkgen"


SlashCmdList.LINKGEN = function(msg)
	local link = LinkGen(msg)
	if(not link) then return end

	local dialog = StaticPopup_Show("LINKGEN")
	local editbox = _G[dialog:GetName().."WideEditBox"]  
	editbox:SetText(link)
	editbox:SetFocus()
	editbox:HighlightText()
	local button = _G[dialog:GetName().."Button2"]
	button:ClearAllPoints()
	button:SetPoint("CENTER", editbox, "CENTER", 0, -30)
end