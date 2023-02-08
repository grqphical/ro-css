local module = {}

module.ast = {} --- Create our Abstract Syntax Tree dictionary to store our CSS data

module.propertyTable = 
{
		["anchor-point"] = "AnchorPoint",
		["background-color"] = "BackgroundColor3",
		["transparency"] = "BackgroundTransparency",
		["border-color"] = "BorderColor3",
		["border-size"] = "BorderSizePixel",
		["position"] = "Position",
		["rotation"] = "Rotation",
		["size"] = "Size",
		["z-index"] = "ZIndex",
		["text-color"] = "TextColor3",
		["text-size"] = "TextSize",
		["text-stroke-color"] = "TextStrokeColor3",
		["text-stroke-transparency"] = "TextStrokeTransparency",
		["text-transparency"] = "TextTransparency",
		["image-color"] = "ImageColor3",
		["image-offset"] = "ImageRectOffset",
		["image-size"] = "ImageRectSize",
		["placeholder-text-color"] = "PlaceholderColor3"
		
}
	

module.ParseCSS = function(input)
	local rules = string.split(input, "}")

	for i in rules do
		if rules[i] == "" then
			table.remove(rules, i)
			break
		end
		--- Get rid of newline, spaces and tab character
		local css = string.gsub(rules[i], "\n", "")
		css = string.gsub(css, "\t", "")

		--- Code for dividing text into an element and the rules itself
		local current_element = ""
		
		--- Set some values
		local charCount = 2

		if string.sub(rules[i], 1, 1) == "." then
			--- Figure out the name of the element by looping through all of the characters until it reaches: "{"
			local isBracket = false
			
			while not isBracket do
				local currentChar = string.sub(rules[i], charCount, charCount)
				if currentChar == "{" then
					isBracket = true
					break
				end
				current_element = current_element..currentChar
				charCount += 1
				wait()
			end

		end
		current_element = current_element:gsub(" ", "")
		--- Take out the element definition of the string so we can parse the properties. We add one to char count to account for the "{"
		local properties_string = css:sub(charCount+1)

		--- Initalize array for rules
		module.ast[current_element] = {}

		--- Create an array split by the ";" character
		local properties = string.split(properties_string, ";")
		table.remove(properties, #properties)

		--- Loop through all properties and split them to get their property name and the value assigned to it
		for key, value in properties do
			local propertySplit = string.split(value, ":")
			local propertyName = propertySplit[1]:gsub(" ", "")
			local propertyValue = propertySplit[2]:gsub(" ", "")

			table.insert(module.ast[current_element], {[propertyName] = propertyValue})
		end

		
	end
	module.ParseAST()
end

module.ParseAST = function()
	for element, rules in pairs(module.ast) do
		for index, rule in ipairs(rules) do
			for name, value in pairs(rule) do
				if string.match(value, "^%a") then
					local funcName, args = unpack(string.split(value, "("))
					args = string.split(args, ",")
					for i, v in ipairs(args) do
						args[i] = string.gsub(args[i], "%)", "")
					end


					if funcName == "rgb" then

						local r = args[1]
						local g = args[2]
						local b = args[3]

						module.ast[element][index][name] = {"rgb",tonumber(r),tonumber(g),tonumber(b)}
					else if funcName == "hsv" then
							local h = args[1]
							local s = args[2]
							local v = args[3]

							module.ast[element][index][name] = {"hsv",tonumber(h), tonumber(s), tonumber(v)}
						else if funcName == "udim" then
								local scale = args[1]
								local offset = args[2]

								module.ast[element][index][name] = {"udim",tonumber(scale), tonumber(offset)}
							else if funcName == "udim2" then
									local scaleX, offsetX, scaleY, offsetY = unpack(args)
									module.ast[element][index][name] = {"udim2",tonumber(scaleX), tonumber(offsetX), tonumber(scaleY), tonumber(offsetY)}
								end
							end
						end
					end
				else
					module.ast[element][index][name] = tonumber(value)
				end
			end
		end
	end
	module.ApplyGUI(script.Parent)
end

module.ApplyGUI = function(screenGUI)
	for i, child in pairs(screenGUI:GetDescendants()) do
		if child:IsA("GuiObject") then
			local class_ = child:GetAttribute("Class")
			for class, rules in pairs(module.ast) do
				if class_ ~= class then
					continue
				end
				for _, rule in ipairs(rules) do
					local finalValue = ""
					local finalName = ""
					for name, value in pairs(rule) do
						finalName = name
						if type(value) == "table" then
							if value[1] == "rgb" then
								finalValue = Color3.fromRGB(value[2], value[3], value[4])
							else if value[1] == "hsv" then
									finalValue = Color3.fromHSV(value[2], value[3], value[4])
								else if value[1] == "udim" then
										finalValue = UDim.new(value[2], value[3])
									else if value[1] == "udim2" then
											finalValue = UDim2.new(value[2], value[3], value[4], value[5])
										end
									end
								end
							end
						else
							finalValue = value
							finalValue = tonumber(finalValue)
						end
					end
					for i, v in pairs(module.propertyTable) do
						if (i == finalName) then
							local success, response = pcall(function()
								child[v] = finalValue
							end)
							continue
						end
					end
				end
			end
		end
	end
end

return module
