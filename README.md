# 🦙 Ollama Module for Roblox

A fun & friendly wrapper to talk to your local Ollama AI using Lua in Roblox!  
Perfect for building AI chatbots, NPCs, or experimenting with LLMs inside Studio.

> 🔗 Default API: `http://localhost:11434/api/chat`  
> 🧠 Default Model: `"llama2"`  
> 🚫 Note: `Stream = true` does nothing right now!

---

## 📦 Setup

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ollama = require(ReplicatedStorage:WaitForChild("Ollama"))

local session = Ollama:Create({
	Model = "llama3", -- optional
	API_URL = "http://localhost:11434/api/chat", -- optional
})
```

---

## ✨ Function Reference (with Examples)

### 🛠 `:Create(config)`
Create a new session with optional custom config.

```lua
local ai = Ollama:Create({ Model = "llama2" })
```

---

### 🧠 `:prompt(userMessage)`
Send a message to the AI and get a reply (also adds to history).

```lua
local reply = session:prompt("What's up?")
print(reply)
```

---

### 🔁 `:getReplyOnly(userMessage)`
Same as above, but doesn’t save anything to history.

```lua
print(session:getReplyOnly("Define gravity."))
```

---

### 🧽 `:reset()` or `:clearHistory()`
Clears the entire conversation history.

```lua
session:reset()
-- or
session:clearHistory()
```

---

### 🧼 `:clearMessagesByRole(role)`
Removes only messages by a specific role (user, assistant, system).

```lua
session:clearMessagesByRole("user")
```

---

### ✍️ `:addMessage(role, content)`
Manually add a message to the history.

```lua
session:addMessage("user", "Who are you?")
```

---

### 📢 `:inform(systemContent)`
Sets or updates the system prompt.

```lua
session:inform("You are a helpful assistant who loves cats.")
```

---

### 🧹 `:undoLast()`
Deletes the last message (user or assistant).

```lua
session:undoLast()
```

---

### 🧳 `:importHistory(data)`
Load a conversation from a JSON string or Lua table.

```lua
session:importHistory('[{"role":"user","content":"hi"}]')
```

---

### 📤 `:exportHistoryJSON()`
Get your chat history as a JSON string.

```lua
local json = session:exportHistoryJSON()
print(json)
```

---

### 📡 `:ping()`
Check if your Ollama server is reachable.

```lua
if session:ping() then
	print("Ollama is online!")
else
	warn("Could not reach Ollama.")
end
```

---

### 💬 `:getLatestReply()`
Get the most recent assistant reply.

```lua
print(session:getLatestReply())
```

---

### 🔧 `:setConfig(key, value)`
Update a config value like the model.

```lua
session:setConfig("Model", "llama2")
```

---

### 🧠 `:getReplyWithCustomContext(messages)`
Send your own list of messages.

```lua
local messages = {
	{ role = "system", content = "Be funny" },
	{ role = "user", content = "Tell me a joke" }
}
print(session:getReplyWithCustomContext(messages))
```

---

### 🧙 `:getReplyFromSystemPrompt(prompt)`
Shorthand for system + user in one call.

```lua
local reply = session:getReplyFromSystemPrompt({
	System = "You are a riddle master.",
	User = "Give me a riddle!"
})
print(reply)
```

---

### 📚 `:getHistory()`
Access the full history table.

```lua
local history = session:getHistory()
for _, msg in ipairs(history) do
	print(`[ {msg.role} ] {msg.content}`)
end
```

---

## 🕹️ Fun Interactive Example: Roblox Studio Chat

Paste this into a LocalScript with a TextBox and TextLabel for input/output.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Ollama = require(ReplicatedStorage:WaitForChild("Ollama"))
local player = Players.LocalPlayer

local inputBox = script.Parent:WaitForChild("Input")
local outputLabel = script.Parent:WaitForChild("Output")

local session = Ollama:Create()
session:inform("You're a playful chatbot in a Roblox game.")

inputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local message = inputBox.Text
		inputBox.Text = ""
		outputLabel.Text = "Thinking..."
		local reply = session:prompt(message)
		outputLabel.Text = reply
	end
end)
```

---

## ⚠️ Notes

- Make sure **HttpService is enabled** in Studio settings.
- Ollama must be running on your computer (`http://localhost:11434`).
- This is **not for production yet** — streaming and error handling are basic.

---

Ollama module with 💙 by [Crey]
Was too lazy to write the readme file so i js told chatgpt to write it 🙏
