# 🦙 Ollama Module for Roblox

A super chill way to talk to your local Ollama AI using Lua in Roblox! Just make sure HTTP requests are enabled, and you’re ready to vibe with your LLM.

> 🔗 Default API: `http://localhost:11434/api/chat`  
> 🧠 Default Model: `"llama2"`  
> 🚫 Note: Streaming is **not implemented** yet!

---

## 📦 Setup

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ollama = require(ReplicatedStorage:WaitForChild("Ollama"))

local session = Ollama:Create({
	Model = "llama3", -- Optional override
	API_URL = "http://localhost:11434/api/chat", -- Optional override
})
```

---

## ✨ Functions (explained simply)

### 🛠 `:Create(config)`
Creates a new Ollama session. You can optionally override the default config.

### 🧠 `:prompt(userMessage)`
Sends a message to the AI and returns its response. Also adds both your message and the bot’s reply to history.

### 🔁 `:getReplyOnly(userMessage)`
Sends a message and gets a response, but **does not** save anything to history.

### 🧽 `:reset()` / `:clearHistory()`
Wipes all stored messages from chat history. (Basically the same.)

### 🧼 `:clearMessagesByRole(role)`
Removes all messages by a specific role (like `"user"`, `"assistant"`, or `"system"`).

### ✍️ `:addMessage(role, content)`
Adds a message manually to the history. Great for advanced control.

### 📢 `:inform(systemContent)`
Adds or updates the system message. (e.g., “You are a helpful assistant.”)

### 🧹 `:undoLast()`
Deletes the last message from the history (like Ctrl+Z).

### 🧳 `:importHistory(data)`
Loads history from a table or a JSON string.

### 📤 `:exportHistoryJSON()`
Exports current history as a JSON string. Great for saving.

### 📡 `:ping()`
Checks if your Ollama server is alive. Returns `true` if reachable.

### 💬 `:getLatestReply()`
Grabs the latest assistant message from history (if it exists).

### 🔧 `:setConfig(key, value)`
Updates one of the config values like `"Model"` or `"Stream"`.

### 🧠 `:getReplyWithCustomContext(messages)`
Sends a custom list of messages to the model and gets a reply (without affecting history).

### 🧙 `:getReplyFromSystemPrompt(prompt)`
Sends a special prompt with both system + user content:
```lua
{
	System = "You are a robot",
	User = "What’s 2 + 2?"
}
```

### 📚 `:getHistory()`
Returns the current history table.

---

## 🧪 Example

```lua
session:inform("You are a Roblox Lua genius.")
local reply = session:prompt("What's a metatable?")
print(reply)
```

---

## 🚧 Notes

- Make sure **HTTP requests are enabled** in your game settings.
- `Stream = true` does nothing yet – it's just there for future updates.
- Default model is `"llama2"`, but you can change it to any supported Ollama model.

---

Made with 💙 by [Crey].
