#!/bin/bash

# Dynatrace MCP Server for JetBrains IntelliJ IDEA
# This script launches the Dynatrace MCP server for use with GitHub Copilot in IntelliJ

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$PROJECT_DIR/.env"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Dynatrace MCP Server Launcher${NC}"
echo -e "${BLUE}for JetBrains IntelliJ IDEA${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo -e "${RED}❌ Error: .env file not found at $ENV_FILE${NC}"
    echo -e "${YELLOW}Please create .env file with:${NC}"
    echo ""
    echo "DT_PLATFORM_TOKEN=your_token_here"
    echo "DT_ENVIRONMENT=https://your-env.apps.dynatracelabs.com"
    echo ""
    exit 1
fi

# Load environment variables
echo -e "${BLUE}Loading environment configuration...${NC}"
set -a
source "$ENV_FILE"
set +a

# Check required environment variables
if [ -z "$DT_ENVIRONMENT" ]; then
    echo -e "${RED}❌ Error: DT_ENVIRONMENT not set in .env${NC}"
    exit 1
fi

if [ -z "$DT_PLATFORM_TOKEN" ] && [ -z "$OAUTH_CLIENT_ID" ]; then
    echo -e "${RED}❌ Error: Neither DT_PLATFORM_TOKEN nor OAUTH_CLIENT_ID set in .env${NC}"
    exit 1
fi

# Verify Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Error: Node.js is not installed${NC}"
    exit 1
fi

NODE_VERSION=$(node -v)
echo -e "${GREEN}✅ Node.js $NODE_VERSION found${NC}"

# Verify npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ Error: npm is not installed${NC}"
    exit 1
fi

NPM_VERSION=$(npm -v)
echo -e "${GREEN}✅ npm $NPM_VERSION found${NC}"

echo ""
echo -e "${BLUE}Starting Dynatrace MCP Server...${NC}"
echo -e "${YELLOW}Environment: $DT_ENVIRONMENT${NC}"
echo ""

# Start the server with the latest version
exec npx -y @dynatrace-oss/dynatrace-mcp-server@latest

