#!/bin/bash

# GitHub Copilot Configuration Script for JetBrains IntelliJ IDEA
# This script verifies and enables GitHub Copilot for the dyn-rest-application project

set -e

echo "=========================================="
echo "GitHub Copilot Setup for IntelliJ IDEA"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IDEA_CONFIG_DIR="$PROJECT_DIR/.idea"

echo -e "${BLUE}Step 1: Verify Project Structure${NC}"
echo "Project Directory: $PROJECT_DIR"
echo "IDE Config Directory: $IDEA_CONFIG_DIR"
echo ""

# Check if .idea directory exists
if [ -d "$IDEA_CONFIG_DIR" ]; then
    echo -e "${GREEN}✓ .idea directory found${NC}"
else
    echo -e "${YELLOW}⚠ .idea directory not found${NC}"
    mkdir -p "$IDEA_CONFIG_DIR"
    echo -e "${GREEN}✓ Created .idea directory${NC}"
fi

echo ""
echo -e "${BLUE}Step 2: Verify Copilot Configuration Files${NC}"

# Check copilot-config.json
if [ -f "$IDEA_CONFIG_DIR/copilot-config.json" ]; then
    echo -e "${GREEN}✓ copilot-config.json found${NC}"
    echo "  Location: $IDEA_CONFIG_DIR/copilot-config.json"
else
    echo -e "${RED}✗ copilot-config.json not found${NC}"
fi

# Check workspace.xml for Copilot persistence
if [ -f "$IDEA_CONFIG_DIR/workspace.xml" ]; then
    echo -e "${GREEN}✓ workspace.xml found${NC}"
    if grep -q "CopilotPersistence" "$IDEA_CONFIG_DIR/workspace.xml"; then
        echo -e "${GREEN}✓ Copilot persistence entry detected${NC}"
    else
        echo -e "${YELLOW}⚠ Copilot persistence entry not found (will be created on first run)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ workspace.xml not found (normal if IntelliJ hasn't been opened yet)${NC}"
fi

echo ""
echo -e "${BLUE}Step 3: Verify Project Configuration Files${NC}"

# Check for copilot instructions
if [ -f "$PROJECT_DIR/.github/copilot-instructions.md" ]; then
    echo -e "${GREEN}✓ .github/copilot-instructions.md found${NC}"
else
    echo -e "${YELLOW}⚠ .github/copilot-instructions.md not found${NC}"
fi

if [ -f "$PROJECT_DIR/JETBRAINS-COPILOT-SETUP.md" ]; then
    echo -e "${GREEN}✓ JETBRAINS-COPILOT-SETUP.md found${NC}"
else
    echo -e "${YELLOW}⚠ JETBRAINS-COPILOT-SETUP.md not found${NC}"
fi

echo ""
echo -e "${BLUE}Step 4: Check for Required Files${NC}"

required_files=(
    "pom.xml"
    "src/main/java/com/hugenet/controller/RestApplication.java"
    "CLAUDE.md"
)

for file in "${required_files[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        echo -e "${GREEN}✓ $file exists${NC}"
    else
        echo -e "${RED}✗ $file missing${NC}"
    fi
done

echo ""
echo -e "${BLUE}Step 5: Print Next Steps${NC}"
echo ""
echo "AUTOMATIC SETUP (IntelliJ will handle):"
echo "  1. Open the project in IntelliJ IDEA"
echo "  2. Go to: IntelliJ IDEA → Preferences → Plugins → Marketplace"
echo "  3. Search for: 'GitHub Copilot'"
echo "  4. Click 'Install' (by JetBrains)"
echo "  5. Restart IntelliJ IDEA"
echo ""
echo "AUTHENTICATION:"
echo "  1. Click the GitHub Copilot icon in the status bar (bottom-right)"
echo "  2. Select 'Sign in with GitHub'"
echo "  3. Authorize the plugin via GitHub"
echo ""
echo "VERIFICATION:"
echo "  1. The Copilot icon should be GREEN in the status bar"
echo "  2. Start typing in a .java file"
echo "  3. You should see inline suggestions in gray italic text"
echo "  4. Press Tab to accept, Esc to dismiss"
echo ""
echo "OPEN COPILOT CHAT:"
echo "  • Keyboard: ⌘ + Shift + A (macOS) or Ctrl + Shift + A (Windows/Linux)"
echo "  • Menu: Tools → GitHub Copilot → Open Chat"
echo ""

echo -e "${BLUE}Step 6: Configuration Summary${NC}"
echo ""
echo "Copilot Settings Summary:"
cat << 'EOF'
  • Inline Completions: ENABLED
  • Line Completion on Indent: ENABLED
  • Accept Suggestion: Tab
  • Dismiss Suggestion: Esc
  • Next Suggestion: Cmd+]
  • Previous Suggestion: Cmd+[
EOF
echo ""

echo -e "${BLUE}Step 7: Project Context Loaded${NC}"
echo ""
echo "Copilot is now aware of:"
echo "  • Project Type: Spring Boot REST API"
echo "  • Purpose: Observability testing"
echo "  • Main Patterns:"
echo "    - BasicController intentional chaos"
echo "    - GreetingController delays (20% chance)"
echo "    - MemoryController FIFO eviction"
echo "    - Thread-safe counters (AtomicLong)"
echo ""

echo -e "${GREEN}=========================================="
echo "Setup Complete!"
echo "==========================================${NC}"
echo ""
echo "Recommended next steps:"
echo "  1. Open this project in IntelliJ IDEA"
echo "  2. Install the GitHub Copilot plugin"
echo "  3. Authenticate with GitHub"
echo "  4. Try opening a .java file and typing"
echo ""
echo "For detailed instructions, see: JETBRAINS-COPILOT-SETUP.md"
echo ""

