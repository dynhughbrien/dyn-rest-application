# GitHub Copilot Setup for JetBrains IntelliJ IDEA

This guide walks you through configuring GitHub Copilot in JetBrains IntelliJ IDEA for the `dyn-rest-application` project.

## Prerequisites

1. **GitHub Account**: You must have a GitHub account with Copilot subscription or access
2. **IntelliJ IDEA**: Version 2023.2 or later (Community, Professional, or Ultimate)
3. **Copilot Plugin**: Available for free in the JetBrains Marketplace

## Step 1: Install the GitHub Copilot Plugin

### Method A: From the IDE
1. Open **IntelliJ IDEA**
2. Go to **IntelliJ IDEA → Preferences** (macOS) or **File → Settings** (Windows/Linux)
3. Navigate to **Plugins** → **Marketplace**
4. Search for **"GitHub Copilot"**
5. Click **Install** on the official plugin by JetBrains
6. Click **Restart IDE** to activate the plugin

### Method B: From JetBrains Marketplace
1. Visit [JetBrains Marketplace - GitHub Copilot](https://plugins.jetbrains.com/plugin/17718-github-copilot)
2. Click **Install** → Select your IDE version → Download
3. Open IntelliJ → **Preferences/Settings → Plugins → ⚙️ → Install Plugin from Disk**
4. Select the downloaded `.zip` file

## Step 2: Authenticate with GitHub

1. After plugin installation, you'll see a **GitHub Copilot** notification or icon in the status bar (bottom-right)
2. Click the **GitHub Copilot** icon or notification
3. Select **"Sign in with GitHub"**
4. Your browser will open to GitHub's authorization page
5. Authorize the JetBrains plugin to access your GitHub account
6. Copy the device code provided and paste it back in IntelliJ (if prompted)
7. Wait for confirmation that authentication is complete

### Verifying Authentication
- The Copilot icon should be **green/active** in the status bar
- You should see **"GitHub Copilot is ready"** message in the UI

## Step 3: Configure Copilot Settings (Optional)

1. **Preferences/Settings → Languages & Frameworks → GitHub Copilot**
2. Available options:
   - **Enable/Disable Copilot**: Toggle to activate/deactivate
   - **Show inline completions**: Enable code completion suggestions as you type
   - **Show line completion on indent**: Auto-complete on indentation
   - **Keybindings**: Configure custom hotkeys for accepting/rejecting suggestions

### Recommended Settings
- ✅ Enable inline completions
- ✅ Enable line completion on indent
- Accept suggestion: **Tab** (default)
- Reject suggestion: **Esc** (default)

## Step 4: Use Copilot in Your Project

### Getting Code Suggestions
1. Start typing in any `.java` file (or other supported languages)
2. Copilot will show suggestions in **gray italic text** as you type
3. Press **Tab** to accept the suggestion, or **Esc** to dismiss it

### Open Copilot Chat
- Press **`⌘ + Shift + A`** (macOS) or **`Ctrl + Shift + A`** (Windows/Linux)
- Or go to **Tools → GitHub Copilot → Open Chat**
- Chat allows you to:
  - Ask questions about your code
  - Request code generation
  - Get explanations for existing code
  - Ask about the `dyn-rest-application` architecture

### Common Copilot Chat Prompts for This Project
- "Explain the BasicController intentional chaos pattern"
- "How does the MemoryController FIFO eviction work?"
- "Generate a test for the GreetingController.application() method"
- "What does the 20% delay logic do in GreetingController?"

## Step 5: Project-Specific Configuration (Optional)

This project includes `copilot-instructions.md` in `.github/`, which provides context about the intentional chaos. Copilot should automatically use these instructions.

### To Verify Project Context
1. Open the Copilot Chat
2. Ask: "What is the purpose of this project?"
3. Copilot should reference the observability testing and intentional chaos patterns

## Troubleshooting

### Issue: "Copilot is not active" or authentication failed

**Solution:**
1. Restart IntelliJ IDEA
2. Go to **Preferences/Settings → Plugins**
3. Search for "GitHub Copilot" and verify it's **enabled**
4. Re-authenticate: **Tools → GitHub Copilot → Sign Out**, then sign back in

### Issue: No suggestions appearing

**Solution:**
1. Verify Copilot is enabled in **Preferences/Settings → Languages & Frameworks → GitHub Copilot**
2. Check your GitHub subscription includes Copilot
3. Try creating a new `.java` file and typing a comment or method signature
4. Restart IDE if suggestions still don't appear

### Issue: Suggestions are too slow or irrelevant

**Solution:**
1. The project has a `copilot-instructions.md` — ensure Copilot uses it by asking context-specific questions
2. Use Copilot Chat instead of inline suggestions for complex queries
3. Review the **copilot-instructions.md** in the `.github/` folder for expected behavior

### Issue: "GitHub account required" when already logged in

**Solution:**
1. Sign out: **Tools → GitHub Copilot → Sign Out**
2. Restart IntelliJ
3. Re-authenticate and ensure browser authorization completes

## Quick Reference: Keyboard Shortcuts

| Action | macOS | Windows/Linux |
|--------|-------|---------------|
| Open Copilot Chat | `⌘ + Shift + A` | `Ctrl + Shift + A` |
| Accept suggestion | `Tab` | `Tab` |
| Dismiss suggestion | `Esc` | `Esc` |
| Next suggestion | `⌘ + ]` | `Ctrl + ]` |
| Previous suggestion | `⌘ + [` | `Ctrl + [` |

## Additional Resources

- [JetBrains GitHub Copilot Plugin Documentation](https://www.jetbrains.com/help/idea/github-copilot.html)
- [GitHub Copilot Pricing & Plans](https://github.com/features/copilot)
- [Project Copilot Instructions](../.github/copilot-instructions.md)

## Notes for This Project

- The `dyn-rest-application` is a Spring Boot REST API designed for observability testing
- Copilot will see the intentional chaos patterns (errors, delays, memory pressure)
- Use Copilot to understand why certain patterns are intentional (not bugs)
- For test generation, ask Copilot to create tests that validate the observability hooks, not "fix" the intentional errors

---

**Date Created**: April 2, 2026  
**Project**: dyn-rest-application (Spring Boot REST API for Observability Testing)

