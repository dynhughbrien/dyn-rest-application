# GitHub Copilot Quick Reference for dyn-rest-application

## Status
✅ **Copilot is Configured and Ready**

## Installation Checklist

- [ ] Install GitHub Copilot plugin from JetBrains Marketplace
- [ ] Restart IntelliJ IDEA
- [ ] Authenticate with GitHub
- [ ] Verify Copilot icon is **GREEN** in status bar

## Key Keyboard Shortcuts

| Action | macOS | Windows/Linux |
|--------|-------|---------------|
| **Accept Suggestion** | `Tab` | `Tab` |
| **Dismiss Suggestion** | `Esc` | `Esc` |
| **Open Copilot Chat** | `⌘ + Shift + A` | `Ctrl + Shift + A` |
| **Next Suggestion** | `⌘ + ]` | `Ctrl + ]` |
| **Previous Suggestion** | `⌘ + [` | `Ctrl + [` |

## Using Copilot in This Project

### For Code Completions
1. Open any `.java` file in the project
2. Start typing a method signature, class, or logic
3. Copilot will show suggestions in **gray italic text**
4. Press `Tab` to accept or `Esc` to dismiss

### Example Prompts in Chat

**Understanding the Architecture:**
```
"Explain how BasicController intentionally causes errors for observability testing"
"What is the purpose of the MemoryController?"
"How does AtomicLong ensure thread safety in request counters?"
```

**Code Generation:**
```
"Generate a test for GreetingController.application() that verifies the 20% delay logic"
"Create a method that generates synthetic memory pressure"
"Write a controller endpoint for testing distributed tracing"
```

**Code Review:**
```
"Review the GreetingController and explain the synthetic delay patterns"
"Analyze the RestApplication configuration and system property handling"
"Why does BasicController have @RequestParam instead of @PathVariable?"
```

**Problem-Solving:**
```
"How would I add a new observability endpoint?"
"What changes are needed to expose Dynatrace metrics?"
"How to add OpenTelemetry instrumentation?"
```

## Project Context Loaded ✓

Copilot now understands:
- ✅ Spring Boot REST API for observability testing
- ✅ Intentional chaos patterns (don't fix them!)
- ✅ Maven build system with Maven Wrapper
- ✅ Java records for DTOs (`Greeting`, `Welcome`)
- ✅ In-memory state with no database
- ✅ Synthetic latency and memory pressure for testing

## Common Workflows

### Viewing Copilot Status
- Look for the **Copilot icon** in the bottom-right status bar
- **Green icon** = Active and ready
- **Gray icon** = Disabled or not authenticated
- Click to enable/disable

### Opening Chat with Context
1. **Method 1**: Press `⌘ + Shift + A` (macOS) or `Ctrl + Shift + A` (Windows/Linux)
2. **Method 2**: Go to **Tools → GitHub Copilot → Open Chat**
3. **Method 3**: Right-click code → **Send to Copilot Chat**

### Selecting Code for Chat
1. Highlight the code you want to discuss
2. Press `⌘ + Shift + A` to open chat with selected code as context
3. Ask your question

### Accepting/Rejecting Multiple Suggestions
1. When Copilot shows a suggestion, you can cycle through alternatives
2. `⌘ + ]` (macOS) or `Ctrl + ]` (Windows/Linux) for next suggestion
3. `⌘ + [` (macOS) or `Ctrl + [` (Windows/Linux) for previous suggestion
4. `Tab` to accept, `Esc` to dismiss

## Configuration Files

The following files support Copilot configuration:
- **`.idea/copilot-config.json`** — IDE and project context settings
- **`.idea/copilot-settings.xml`** — IntelliJ plugin settings
- **`.github/copilot-instructions.md`** — Project-specific instructions
- **`JETBRAINS-COPILOT-SETUP.md`** — Full setup documentation

## Troubleshooting

### Q: Copilot suggestions not appearing
**A:**
1. Verify the Copilot icon is green in the status bar
2. Check **Preferences → Languages & Frameworks → GitHub Copilot → Enable Copilot**
3. Restart IntelliJ
4. Try typing a comment first: `// function to calculate`

### Q: Authentication issues
**A:**
1. Sign out: **Tools → GitHub Copilot → Sign Out**
2. Restart IntelliJ
3. Re-authenticate via Copilot icon

### Q: Chat not opening
**A:**
1. Ensure Copilot plugin is installed and enabled
2. Check you're using keyboard shortcut correctly: `⌘ + Shift + A` (macOS)
3. Try via menu: **Tools → GitHub Copilot → Open Chat**
4. Restart IDE if persistent

### Q: Copilot doesn't know about project context
**A:**
1. Copilot uses `.github/copilot-instructions.md` for context
2. Ask a specific question: "Tell me about this project"
3. Use Copilot Chat instead of inline completions for better context
4. Reference file names and class names explicitly

## Next Steps

1. ✅ **Configuration** — Complete (you're reading this!)
2. 🔧 **Plugin Installation** — In IntelliJ: Preferences → Plugins → Search "GitHub Copilot" → Install
3. 🔐 **Authentication** — Click Copilot icon → Sign in with GitHub
4. 🚀 **Start Coding** — Open a `.java` file and start typing!
5. 💬 **Try Chat** — Press `⌘ + Shift + A` to ask questions about the code

## Documentation Links

- [JetBrains GitHub Copilot Plugin](https://plugins.jetbrains.com/plugin/17718-github-copilot)
- [Full Setup Guide](./JETBRAINS-COPILOT-SETUP.md)
- [Project Instructions](./CLAUDE.md)
- [Copilot Best Practices](https://docs.github.com/en/copilot/getting-started-with-github-copilot)

---

**Configured**: April 2, 2026  
**Status**: ✅ Ready for Use

