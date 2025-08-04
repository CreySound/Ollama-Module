# 🦙 Ollama Module for Roblox

A friendly and easy-to-use Lua wrapper for communicating with a local Ollama AI server in Roblox! Perfect for adding AI-powered chatbots, NPC dialog, or experimental LLM features to your game.

---

## 🚀 Quick Start

1. **Enable HttpService** in Roblox Studio (Settings → Game Settings → Security).
2. Place the `Ollama.lua` module in `ReplicatedStorage`.
3. Require and configure the module in a Script or LocalScript:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ollama = require(ReplicatedStorage:WaitForChild("Ollama"))

local session = Ollama:Create({
    Model   = "llama3",                             -- optional, default: "llama2"
    API_URL = "http://localhost:11434/api/chat",   -- optional, default: "http://localhost:11434/api/chat"
    Stream  = false,                                 -- optional, streaming currently has no effect
})
```

*If HttpService is disabled, the module will warn in the output.*

---

## ✨ API Reference

Each method returns a Lua value (string, boolean, table, etc.) and may update the session’s message history.

### `:Create(config)`

Creates a new AI session with the given configuration.

* **Parameters:**

  * `config` *(table, optional)*:

    * `Model` (string): Model name, e.g. "llama2" or "llama3".
    * `API_URL` (string): Endpoint for the Ollama server.
    * `Stream` (boolean): Whether to request streaming (currently unimplemented).

```lua
local ai = Ollama:Create({ Model = "llama3" })
```

---

### `:prompt(userMessage)`

Sends `userMessage` to the AI, adds it to history, and returns the assistant’s reply.

* **Parameters:**

  * `userMessage` (string): The text you want the AI to respond to.
* **Returns:**

  * (string) The AI’s response, or an error string.

```lua
local reply = session:prompt("Tell me a fun fact.")
print(reply)
```

---

### `:getReplyOnly(userMessage)`

Sends `userMessage` without modifying the session history.

```lua
local answer = session:getReplyOnly("What is gravity?")
print(answer)
```

---

### History Management

* `:reset()` — Clears all messages.
* `:clearHistory()` — Alias for `:reset()`.
* `:clearMessagesByRole(role)` — Deletes messages matching `role` (`"user"`, "assistant"", or `"system"`).
* `:undoLast()` — Removes the last message (regardless of role).

```lua
session:reset()
session:clearMessagesByRole("system")
session:undoLast()
```

---

### Adding and Inspecting Messages

* `:addMessage(role, content)` — Manually insert a message into history.

  ```lua
  session:addMessage("system", "You are a friendly helper.")
  ```

* `:getHistory()` — Returns the full history as a Lua table.

  ```lua
  local history = session:getHistory()
  for i, msg in ipairs(history) do
      print(i, msg.role, msg.content)
  end
  ```

* `:exportHistoryJSON()` — Exports history to a JSON string.

  ```lua
  local json = session:exportHistoryJSON()
  print(json)
  ```

* `:importHistory(data)` — Imports history from a JSON string or Lua table.

  ```lua
  session:importHistory('[{"role":"user","content":"Hi"}]')
  ```

---

### System Prompt Helpers

* `:inform(systemContent)` — Sets or updates the single system prompt at the front of history.

  ```lua
  session:inform("You are a playful chatbot that loves trivia.")
  ```

* `:getReplyWithCustomContext(messages)` — Sends a custom list of messages (table of `{ role, content }`).

  ```lua
  local msgs = {
      { role = "system", content = "Be concise." },
      { role = "user",   content = "Explain recursion." }
  }
  print(session:getReplyWithCustomContext(msgs))
  ```

* `:getReplyFromSystemPrompt(promptTable)` — Shorthand for a system + user call.

  ```lua
  local result = session:getReplyFromSystemPrompt({
      System = "You are a riddle master.",
      User   = "Give me a riddle."
  })
  print(result)
  ```

---

### Utility

* `:ping()` — Checks if the Ollama server’s base URL is reachable.

  ```lua
  if session:ping() then
      print("Ollama server is online!")
  else
      warn("Cannot reach Ollama server.")
  end
  ```

* `:getLatestReply()` — Retrieves the most recent assistant reply from history.

  ```lua
  print(session:getLatestReply())
  ```

* `:setConfig(key, value)` — Update a configuration option on the fly (only existing keys).

  ```lua
  session:setConfig("Model", "llama2")
  ```

---

## 🕹️ Interactive Example in Roblox Studio

Place this LocalScript under a ScreenGui with an `Input` TextBox and an `Output` TextLabel:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

local Ollama = require(ReplicatedStorage:WaitForChild("Ollama"))
local input   = script.Parent:WaitForChild("Input")
local output  = script.Parent:WaitForChild("Output")

local session = Ollama:Create()
session:inform("You are an entertaining chat companion.")

input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local msg = input.Text
        input.Text = ""
        output.Text = "Thinking..."
        local reply = session:prompt(msg)
        output.Text = reply
    end
end)
```

---

## ⚠️ Important Notes

* **HttpService** must be enabled; the module will warn otherwise.
* Ensure the Ollama server is running at the configured `API_URL`.
* **Stream** mode and error handling are minimal—use responsibly.

---

*Module created with ❤️ by Crey.*
