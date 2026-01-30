#!/bin/bash
# Script to check open pull requests in the current repository
# This script demonstrates how to programmatically check PR status

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Repository information
OWNER="Frederic-Luchting"
REPO="skills-scale-institutional-knowledge-using-copilot-spaces"

echo -e "${BLUE}=== Checking Open Pull Requests ===${NC}\n"

# Check if gh CLI is available and authenticated
if command -v gh &> /dev/null; then
    # Try to use gh CLI if authenticated
    if gh auth status &> /dev/null 2>&1; then
        echo -e "${GREEN}✓ Using GitHub CLI${NC}"
        echo -e "${GREEN}Repository:${NC} $OWNER/$REPO"
        echo ""
        
        # List open pull requests
        echo -e "${GREEN}Open Pull Requests:${NC}"
        if gh pr list --repo "$OWNER/$REPO" --state open --json number,title,author,createdAt,updatedAt,url \
            --template '{{range .}}PR #{{.number}}: {{.title}}
  Author: {{.author.login}}
  Created: {{.createdAt}}
  Updated: {{.updatedAt}}
  URL: {{.url}}

{{end}}' 2>/dev/null; then
            # Count open PRs
            PR_COUNT=$(gh pr list --repo "$OWNER/$REPO" --state open --json number --jq 'length' 2>/dev/null || echo "0")
            echo -e "${BLUE}Total open pull requests: ${PR_COUNT}${NC}"
            exit 0
        fi
    fi
fi

# Fallback to curl and GitHub API (public data only)
echo -e "${YELLOW}Attempting to use GitHub API...${NC}\n"
echo -e "${GREEN}Repository:${NC} $OWNER/$REPO"
echo ""

if command -v curl &> /dev/null && command -v jq &> /dev/null; then
    # Fetch open PRs using GitHub API
    API_URL="https://api.github.com/repos/$OWNER/$REPO/pulls?state=open"
    RESPONSE=$(curl -s -w "\n%{http_code}" "$API_URL" 2>/dev/null)
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | sed '$d')
    
    # Check if API call was successful
    if [ "$HTTP_CODE" = "200" ] && [ -n "$BODY" ] && echo "$BODY" | jq empty 2>/dev/null; then
        # Parse and display PR information
        echo -e "${GREEN}Open Pull Requests:${NC}"
        echo "$BODY" | jq -r '.[] | "PR #\(.number): \(.title)\n  Author: \(.user.login)\n  Created: \(.created_at)\n  Updated: \(.updated_at)\n  URL: \(.html_url)\n"' 2>/dev/null
        
        # Count open PRs
        PR_COUNT=$(echo "$BODY" | jq 'length' 2>/dev/null || echo "0")
        echo -e "${BLUE}Total open pull requests: ${PR_COUNT}${NC}"
        exit 0
    else
        echo -e "${YELLOW}Unable to access GitHub API (may be blocked or rate-limited)${NC}"
    fi
fi

# Final fallback - provide direct link
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}View pull requests directly at:${NC}"
echo "https://github.com/$OWNER/$REPO/pulls"
echo ""
echo -e "${YELLOW}Alternative options:${NC}"
echo "1. Install and authenticate GitHub CLI: gh auth login"
echo "2. Use GitHub web interface (link above)"
echo "3. Use GitHub Copilot Spaces with: 'check open pull requests'"
echo -e "${BLUE}========================================${NC}"
