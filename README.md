# 🦙 Ollama Luau Module

This is a simple module that lets you talk to Ollama models (like LLaMA2, LLaMA3, etc.) from your Roblox game using HTTP requests.

> ✅ Make sure you have [Ollama](https://ollama.com/) installed and running!
> ▶️ Ollama API should be running (default http://localhost:11434/api/chat).

---

## 🔧 Setup

Place the module inside `ReplicatedStorage`, then require and create a bot:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ollama = require(ReplicatedStorage:WaitForChild("Ollama"))

local bot = ollama:Create({
	Model = "llama3",
	API_URL = "http://localhost:11434/api/chat",
	Stream = false, -- Streaming is not implemented yet
})
```

---

## 💬 Chatting with the model

```lua
local reply = bot:prompt("Hello!")
print(reply)
```

This adds the message to history and returns the assistant's reply.

---

## 🔁 One-Time Prompt (No memory)

```lua
local reply = bot:getReplyOnly("What's 1 + 1?")
print(reply) --> "2"
```

This doesn't use chat history.

---

## 🧠 History Functions

### `:addMessage(role, content)`
Adds a message manually.
```lua
bot:addMessage("user", "Hi there!")
```

---

### `:inform(content)`
Sets or updates a system prompt.
```lua
bot:inform("You are a friendly tutor.")
```

---

### `:reset()` or `:clearHistory()`
Clears all messages.
```lua
bot:reset()
-- or
bot:clearHistory()
```

---

### `:clearMessagesByRole(role)`
Removes messages only from a specific role.
```lua
bot:clearMessagesByRole("assistant")
```

---

### `:undoLast()`
Removes the most recent message.
```lua
bot:undoLast()
```

---

### `:getHistory()`
Returns the full chat history.
```lua
print(bot:getHistory())
```

---

### `:importHistory(tableOrJson)`
Imports a previous history.
```lua
bot:importHistory(previousHistoryTable)
```

---

### `:exportHistoryJSON()`
Exports current history as JSON.
```lua
local json = bot:exportHistoryJSON()
```

---

## 🧪 Advanced Prompting

### `:getReplyWithCustomContext(messages)`
Send your own custom messages.
```lua
local reply = bot:getReplyWithCustomContext({
	{ role = "system", content = "You are sarcastic." },
	{ role = "user", content = "How are you?" }
})
```

---

### `:getReplyFromSystemPrompt({System, User})`
Shortcut for system + user messages.
```lua
local reply = bot:getReplyFromSystemPrompt({
	System = "You are a pirate.",
	User = "Tell me a joke!"
})
```

---

## ⚙️ Config & Ping

### `:setConfig(key, value)`
Change bot settings on the fly.
```lua
bot:setConfig("Model", "llama2")
```

---

### `:ping()`
Check if the API is working.
```lua
if bot:ping() then
	print("Connected!")
else
	warn("API not reachable")
end
```

---

## 🧠 Reminder

- `:prompt()` saves messages.
- `:getReplyOnly()` is temporary — no memory.
- `:getReplyFromSystemPrompt()` is also one-time.

---

Made by [your name]. Happy chatting 🫡
