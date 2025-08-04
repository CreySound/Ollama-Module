local HttpService = game:GetService("HttpService")
if not HttpService.HttpEnabled then
	warn("[Ollama Warning] Please enable HttpService so that Ollama can work!")
end

local Ollama = {}
Ollama.__index = Ollama

local DefaultConfig = {
	Model = "llama2",
	API_URL = "http://localhost:11434/api/chat",
	Stream = false,
}

function Ollama:Create(customConfig)
	local self = setmetatable({}, Ollama)
	self.Config = {}

	for k, v in pairs(DefaultConfig) do
		self.Config[k] = v
	end
	if customConfig then
		for k, v in pairs(customConfig) do
			if self.Config[k] ~= nil then
				self.Config[k] = v
			end
		end
	end

	self.History = {}

	return self
end

function Ollama:addMessage(role, content)
	table.insert(self.History, { role = role, content = content })
end

function Ollama:inform(content)
	for i, message in ipairs(self.History) do
		if message.role == "system" then
			self.History[i].content = content
			return
		end
	end
	table.insert(self.History, 1, { role = "system", content = content })
end

function Ollama:reset()
	self.History = {}
end

function Ollama:prompt(userMessage)
	self:addMessage("user", userMessage)

	if self.Config.Stream then
   		warn("[Ollama Warning] Stream is set to true, but streaming is not implemented!")
	end

	local payload = {
		model = self.Config.Model,
		messages = self.History,
		stream = self.Config.Stream,
	}

	local success, result = pcall(function()
		return HttpService:PostAsync(
			self.Config.API_URL,
			HttpService:JSONEncode(payload),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if success then
		local decoded = HttpService:JSONDecode(result)
		local responseText = decoded.message and decoded.message.content or "[Empty reply]"
		self:addMessage("assistant", responseText)
		return responseText
	else
		return "[Ollama Error] Could not connect: " .. tostring(result)
	end
end

function Ollama:getReplyOnly(userMessage)
	local payload = {
		model = self.Config.Model,
		messages = { { role = "user", content = userMessage } },
		stream = false,
	}

	local success, result = pcall(function()
		return HttpService:PostAsync(
			self.Config.API_URL,
			HttpService:JSONEncode(payload),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if success then
		local decoded = HttpService:JSONDecode(result)
		return decoded.message and decoded.message.content or "[Empty reply]"
	else
		return "[Ollama Error] Could not connect: " .. tostring(result)
	end
end

function Ollama:clearHistory()
	self.History = {}
end

function Ollama:clearMessagesByRole(role)
	local filtered = {}
	for _, msg in ipairs(self.History) do
		if msg.role ~= role then
			table.insert(filtered, msg)
		end
	end
	self.History = filtered
end

function Ollama:importHistory(tableOrJson)
	if typeof(tableOrJson) == "string" then
		local success, parsed = pcall(function()
			return HttpService:JSONDecode(tableOrJson)
		end)
		if success and typeof(parsed) == "table" then
			self.History = parsed
		end
	elseif typeof(tableOrJson) == "table" then
		self.History = tableOrJson
	end
end

function Ollama:exportHistoryJSON()
	return HttpService:JSONEncode(self.History)
end

function Ollama:undoLast()
	table.remove(self.History, #self.History)
end

function Ollama:ping()
	local success, _ = pcall(function()
		local url = self.Config.API_URL

		local endpoint_position = url:find("/api/chat")
    
    	if endpoint_position then
    	    return HttpService:GetAsync(url:sub(1, endpoint_position - 1))
    	else
    	    return HttpService:GetAsync(url)
  		end
	end)

	return success
end

function Ollama:getLatestReply()
	for i = #self.History, 1, -1 do
		local msg = self.History[i]
		if msg.role == "assistant" then
			return msg.content
		end
	end
	return nil
end

function Ollama:setConfig(key, value)
	if self.Config[key] ~= nil then
		self.Config[key] = value
	end
end

function Ollama:getReplyWithCustomContext(messages)
	local payload = {
		model = self.Config.Model,
		messages = messages,
		stream = false,
	}

	local success, result = pcall(function()
		return HttpService:PostAsync(
			self.Config.API_URL,
			HttpService:JSONEncode(payload),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if success then
		local decoded = HttpService:JSONDecode(result)
		return decoded.message and decoded.message.content or "[Empty reply]"
	else
		return "[Ollama Error] Could not connect: " .. tostring(result)
	end
end

function Ollama:getReplyFromSystemPrompt(prompt)
	local messages = {
		{ role = "system", content = prompt.System or "You are a helpful assistant." },
		{ role = "user", content = prompt.User or "" }
	}
	return self:getReplyWithCustomContext(messages)
end

function Ollama:getHistory()
	return self.History
end

return Ollama
