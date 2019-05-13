RuESOQA = {}
RuESOQA.ID = ""
RuESOQA.CurrentControl = ""

function RuESOQA:OnTextChanged(...)
    if RuESOQA_Field:IsHidden() ~= true then
		if RuESOQA_FieldOutputBox:GetText() == "" then
			RuESOQA_Field:SetHidden(true)
		else
			RuESOQA_FieldOutputBox:SetHandler("OnTextChanged", nil)
			RuESOQA_FieldOutputBox:SetText(RuESOQA.ID)
			RuESOQA_FieldOutputBox:SelectAll()
			RuESOQA_FieldOutputBox:SetHandler("OnTextChanged", function(...)
				RuESOQA:OnTextChanged()
			end)
		end
	end
end

function RuESOQA:Split(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
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
					
					local check = string.find(sourceText, "\|u::")
					local id = sourceText
					
					if check ~= nil then
						id = RuESOQA:Split(id, "\|u::")[2]
						id = RuESOQA:Split(id, ":\|u")[1]
					end
					
					RuESOQA.ID = "#:n:" .. id .. ":#"

					clipBoardControl:SetText(RuESOQA.ID)
					
					window:SetHidden(false)
					zo_callLater(function()
						clipBoardControl:TakeFocus()
						clipBoardControl:SelectAll()
					end, 10)
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
						
						local check = string.find(sourceText, "\|u::")
						local id = sourceText
						
						if check ~= nil then
							id = RuESOQA:Split(id, "\|u::")[2]
							id = RuESOQA:Split(id, ":\|u")[1]
						end
						
						RuESOQA.ID = "#:p:" .. id .. ":#"

						clipBoardControl:SetText(RuESOQA.ID)
					
						window:SetHidden(false)
						zo_callLater(function()
							clipBoardControl:TakeFocus()
							clipBoardControl:SelectAll()
						end, 10)
					end)
			end
			
			optionIcon = flagControl
		end
		
		if string.find(text, "\|u::") == nil then
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