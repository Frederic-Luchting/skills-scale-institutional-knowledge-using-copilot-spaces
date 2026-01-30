# Checking Open Pull Requests

This guide demonstrates various methods for checking open pull requests in the OctoAcme project management repository.

## Methods to Check Open Pull Requests

### 1. Using GitHub Web Interface

The simplest way to check open pull requests is through the GitHub web interface:

1. Navigate to the repository: https://github.com/Frederic-Luchting/skills-scale-institutional-knowledge-using-copilot-spaces
2. Click on the **Pull requests** tab
3. View all open pull requests with their status, reviewers, and checks

### 2. Using GitHub CLI

If you have the [GitHub CLI](https://cli.github.com/) installed, you can check PRs from the command line:

```bash
# List all open pull requests
gh pr list --state open

# View detailed information about a specific PR
gh pr view <PR-number>

# Check PR status including checks and reviews
gh pr status
```

### 3. Using the Provided Script

We've included a convenience script in the repository root:

```bash
# Make the script executable (if not already)
chmod +x check-prs.sh

# Run the script
./check-prs.sh
```

This script will display:
- Repository information
- List of all open pull requests with details
- Total count of open PRs

### 4. Using GitHub Copilot Spaces

As demonstrated in the exercise, you can also check pull requests through GitHub Copilot Spaces:

1. Open your Copilot Space
2. Use the prompt: `check open pull requests`
3. Copilot will query the repository and display current PR status

## Pull Request Review Workflow

When checking pull requests, consider:

1. **Status**: Is the PR ready for review or still in draft/WIP?
2. **Checks**: Are all CI/CD checks passing?
3. **Reviews**: Has the PR been reviewed and approved?
4. **Conflicts**: Are there any merge conflicts that need resolution?
5. **Age**: How long has the PR been open?

## Automated PR Monitoring

For continuous monitoring, consider setting up:

- GitHub Actions workflows to notify on PR status changes
- Branch protection rules to enforce review requirements
- Automated reminders for stale PRs
- Integration with team communication tools (Slack, Teams, etc.)

## Related Documentation

- [GitHub Pull Request Documentation](https://docs.github.com/en/pull-requests)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [OctoAcme Project Management Overview](./octoacme-project-management-overview.md)
