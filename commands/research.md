---
name: research
description: Research the latest Divi 5 updates, features, CSS compatibility changes, and best practices. Updates plugin knowledge base with new findings.
allowed-tools: Read, Write, Edit, WebSearch, WebFetch
---

# Divi 5 Research Command

You are researching the latest Divi 5 updates and compatibility information. **Use ultrathink mode** for thorough research.

## Step 1: Check Last Research Date

Read `.claude/divi5-toolkit.local.md`:
```yaml
last_research: [YYYY-MM-DD]
```

If more than 7 days old or user explicitly requested, proceed with research.

## Step 2: Research Sources

### Primary Sources (in order)
1. **Context7** — Check for Divi documentation
2. **Elegant Themes Blog** — https://www.elegantthemes.com/blog
3. **Elegant Themes Help Center** — https://help.elegantthemes.com
4. **Divi 5 Changelog** — https://victorduse.com/divi-5-changelog/
5. **Divi GitHub Repos** — https://github.com/elegantthemes

### Community Sources
- **Divi Engine** — https://diviengine.com
- **DiviFlash** — https://diviflash.com
- **WP Zone** — https://wpzone.co
- **Quiroz.co** — https://quiroz.co
- **Pee-Aye Creative** — https://www.peeayecreative.com
- **Reddit r/divi** — Community discussions

### Search Queries
```
"Divi 5" CSS compatibility [current year]
"Divi 5" new features update
"Divi 5" release notes changelog
"Divi 5" breaking changes
"Divi 5" CSS Grid Flexbox
"Divi 5" design variables presets
```

## Step 3: Research Topics

### Topic 1: CSS Compatibility Updates
- New supported units or features?
- Changed selector requirements?
- New CSS integration methods?
- Builder field changes?

### Topic 2: New Features
- New modules added?
- New design options?
- New breakpoints or responsive tools?
- Performance improvements?
- Interactions and animation updates?
- Loop Builder / Canvas updates?

### Topic 3: Breaking Changes
- Deprecated selectors or patterns?
- Changed class names?
- Removed features?
- Migration requirements?
- Plugin compatibility issues?

### Topic 4: Best Practices
- Updated patterns from community?
- New recommendations from Elegant Themes?
- Performance optimization tips?
- Accessibility improvements?

## Step 4: Document Findings

### Format for New Findings
```markdown
## Research Update: [Date]

### CSS Compatibility
- [Finding 1]

### New Features
- [Finding 1]

### Breaking Changes
- [Change 1]

### Best Practices
- [Practice 1]

### Sources
- [URL 1]
```

## Step 5: Update Plugin Knowledge

If significant findings, update:

1. **divi5-compatibility skill** — Add new rules or fix outdated info
2. **divi5-css-patterns skill** — Add new patterns or selectors
3. **divi-selectors.md** — Add new module selectors
4. **Local settings** — Update last_research date

### Update Settings File
```yaml
last_research: [today's date]
research_notes: |
  [Summary of key findings]
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
- Updated [skill] with [changes]

SOURCES:
- [Source with URL]

RECOMMENDATIONS:
- [Action items for user]

========================================
```

## Research Triggers

This command should run:
1. **On-demand** — User runs `/divi5-toolkit:research`
2. **Automatic** — When divi5-researcher agent detects stale knowledge (>7 days)
3. **Error-triggered** — When unknown Divi error is encountered
