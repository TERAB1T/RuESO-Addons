RuESOQA = {}
RuESOQA.ID = 0
RuESOQA.CurrentControl = ""

function RuESOQA:Save()
	if not RuESOQA_SavedVariables then
		RuESOQA_SavedVariables = {}
	end

	if not RuESOQA_SavedVariables["player"] then
		RuESOQA_SavedVariables["player"] = {}
	end
	
	if not RuESOQA_SavedVariables["npc"] then
		RuESOQA_SavedVariables["npc"] = {}
	end
	
	if RuESOQA_FieldOutputBox:GetText() ~= nil then
		RuESOQA_SavedVariables[RuESOQA.CurrentControl][RuESOQA.ID] = RuESOQA_FieldOutputBox:GetText():gsub('\r\n', '\n')
	end
	
	RuESOQA_Field:SetHidden(true)
end

local function ChatterBegin(...)
	--d(ZO_InteractWindowTargetAreaBodyText:GetText())
	local window = RuESOQA_Field
	local clipBoardControl = RuESOQA_FieldOutputBox
	
	local numChildren = ZO_InteractWindowPlayerAreaOptions:GetNumChildren()
	
	if RuESOQA_Control_main == nil then
		local flagControl1 = CreateControlFromVirtual("RuESOQA_Control_", ZO_InteractWindowTargetAreaBodyText, "RuESOQA_Control", "main")
		flagControl1:ClearAnchors()
		flagControl1:SetAnchor(LEFT, ZO_InteractWindowTargetAreaBodyText, TOPLEFT, -5, -30)
		if flagControl1:GetHandler("OnMouseDown") == nil then 
			flagControl1:SetHandler("OnMouseDown", function()
					local sourceText = ZO_InteractWindowTargetAreaBodyText:GetText()
					
					local idOriginal, id = zo_strsplit('\|', sourceText)
					id = zo_strsplit('$', id)
					id = string.sub(id, 2)
					
					local _, original = zo_strsplit('$', sourceText)
					original = original:gsub("\|u", ""):gsub('@1', '<<'):gsub('@2', '>>'):gsub('ä', ':')
					
					RuESOQA.ID = id
					RuESOQA.CurrentControl = "npc"

					if not RuESOQA_SavedVariables then
						RuESOQA_SavedVariables = {}
					end
					
					if not RuESOQA_SavedVariables["npc"] then
						RuESOQA_SavedVariables["npc"] = {}
					end
					
					if RuESOQA_SavedVariables["npc"][id] ~= nil then
						clipBoardControl:SetText(RuESOQA_SavedVariables["npc"][id])
					else
						clipBoardControl:SetText(original)
					end
					clipBoardControl:TakeFocus()
					window:SetHidden(false)
				end)
		end
	end
	
	for i=1,numChildren do
		local option = ZO_InteractWindowPlayerAreaOptions:GetChild(i)
		local text = option:GetText()
		
		local numChildren2 = option:GetNumChildren()
		local iconExist = false
		local optionIcon = ""
		
		for j=1,numChildren2 do
			if option:GetChild(j):GetName() == "RuESOQA_Control_" .. i then
				optionIcon = option:GetChild(j)
				iconExist = true
			end
		end

		if iconExist == false then
			local flagControl = CreateControlFromVirtual("RuESOQA_Control_", ZO_InteractWindowPlayerAreaOptions:GetChild(i), "RuESOQA_Control", i)
			flagControl:ClearAnchors()
			flagControl:SetAnchor(LEFT, ZO_InteractWindowPlayerAreaOptions:GetChild(i), TOPLEFT, -35, 11)
			
			if flagControl:GetHandler("OnMouseDown") == nil then 
				flagControl:SetHandler("OnMouseDown", function()
						local sourceText = ZO_InteractWindowPlayerAreaOptions:GetChild(i):GetText()
						
						local idOriginal, id = zo_strsplit('\|', sourceText)
						id = zo_strsplit('$', id)
						id = string.sub(id, 2)
					
						local _, original = zo_strsplit('$', sourceText)
						original = original:gsub("\|u", ""):gsub('@1', '<<'):gsub('@2', '>>'):gsub('ä', ':')
						
						RuESOQA.ID = id
						RuESOQA.CurrentControl = "player"
						
						if not RuESOQA_SavedVariables then
							RuESOQA_SavedVariables = {}
						end
						
						if not RuESOQA_SavedVariables["player"] then
							RuESOQA_SavedVariables["player"] = {}
						end
						
						if RuESOQA_SavedVariables["player"][id] ~= nil then
							clipBoardControl:SetText(RuESOQA_SavedVariables["player"][id])
						else
							clipBoardControl:SetText(original)
						end
						clipBoardControl:TakeFocus()
						window:SetHidden(false)
					end)
			end
			
			optionIcon = flagControl
		end
		
		if string.find(text, "\|") == nil then
			optionIcon:SetHidden(true)
		else
			optionIcon:SetHidden(false)
		end
	end
end

EVENT_MANAGER:RegisterForEvent("RuESOQA", EVENT_CHATTER_BEGIN, ChatterBegin)
EVENT_MANAGER:RegisterForEvent("RuESOQA", EVENT_CONVERSATION_UPDATED, ChatterBegin)
EVENT_MANAGER:RegisterForEvent("RuESOQA", EVENT_QUEST_OFFERED, ChatterBegin)
EVENT_MANAGER:RegisterForEvent("RuESOQA", EVENT_QUEST_COMPLETE_DIALOG, ChatterBegin)
EVENT_MANAGER:RegisterForEvent("RuESOQA", EVENT_CHATTER_END, function(...) RuESOQA_Field:SetHidden(true) end)