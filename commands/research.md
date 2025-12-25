---
name: research
description: Research the latest Divi 5 updates, features, CSS compatibility changes, and best practices. Updates plugin knowledge base with new findings.
allowed-tools:
  - Read
  - Write
  - Edit
  - WebSearch
  - WebFetch
  - mcp__plugin_context7_context7__resolve-library-id
  - mcp__plugin_context7_context7__get-library-docs
---

# Divi 5 Research Command

You are researching the latest Divi 5 updates and compatibility information. **Use ultrathink mode** for thorough research.

## Step 1: Check Last Research Date

Read `.claude/divi5-toolkit.local.md`:
```yaml
last_research: 2024-12-25
```

If more than 7 days old or user explicitly requested, proceed with research.

## Step 2: Research Sources

### Primary Sources (in order)
1. **Context7** - Check for Divi documentation
2. **Elegant Themes Help Center** - https://help.elegantthemes.com
3. **Elegant Themes Blog** - https://www.elegantthemes.com/blog
4. **Divi Community** - Forums and discussions

### Search Queries
```
"Divi 5" CSS compatibility 2024
"Divi 5" new features update
"Divi 5" CSS variables support
"Divi 5" container queries
"Divi 5" breaking changes
Divi 5 release notes
```

## Step 3: Research Topics

### Topic 1: CSS Compatibility Updates
- New supported units?
- Container queries support yet?
- New CSS functions?
- Changed selector requirements?

### Topic 2: New Features
- New modules added?
- New design options?
- New breakpoints?
- Performance improvements?

### Topic 3: Breaking Changes
- Deprecated selectors?
- Changed class names?
- Removed features?
- Migration requirements?

### Topic 4: Best Practices
- Updated patterns?
- New recommendations?
- Performance tips?
- Accessibility improvements?

## Step 4: Document Findings

Create or update research notes:

### Format for New Findings
```markdown
## Research Update: [Date]

### CSS Compatibility
- [Finding 1]
- [Finding 2]

### New Features
- [Finding 1]
- [Finding 2]

### Breaking Changes
- [Change 1]
- [Change 2]

### Best Practices
- [Practice 1]
- [Practice 2]

### Sources
- [URL 1]
- [URL 2]
```

## Step 5: Update Plugin Knowledge

If significant findings, update:

1. **divi5-compatibility skill** - Add new rules
2. **divi5-css-patterns skill** - Add new patterns
3. **Local settings** - Update last_research date

### Update Settings File
```yaml
---
last_research: [today's date]
research_notes: |
  [Summary of key findings]
---
```

## Step 6: Report to User

```
========================================
DIVI 5 RESEARCH REPORT
Date: [today]
========================================

NEW FINDINGS:

CSS Compatibility:
- [Finding with impact assessment]

New Features:
- [Feature with usage notes]

Breaking Changes:
- [Change with migration steps]

KNOWLEDGE BASE UPDATES:
- Updated divi5-compatibility skill with [X] new rules
- Updated divi5-css-patterns skill with [X] new patterns
- Set last_research to [date]

SOURCES:
- [Source 1 with URL]
- [Source 2 with URL]

RECOMMENDATIONS:
- [Action items for user]

========================================
```

## Alternative Research Tools

If web search is limited, suggest:
> "For more comprehensive research, you can also consult:
> - **Codex** - Good for general WordPress/Divi questions
> - **ChatGPT** - Useful for complex CSS problem-solving
> - **Elegant Themes Forums** - Community discussions
> - **Divi 5 Beta Release Notes** - Official changelog"

## Research Triggers

This command should run:
1. **On-demand** - User runs `/divi5-toolkit:research`
2. **Automatic** - When divi5-researcher agent detects stale knowledge (>7 days)
3. **Error-triggered** - When unknown Divi error is encountered

## Research Complete

End with:
1. Summary of findings
2. Impact on current project
3. Recommended actions
4. Next research date (7 days from now)
