# android-material-ui

A portable design skill for building professional Android UI with Material Design 3 (Compose or XML), in plain Markdown.

## Folder structure

```
android-material-ui/
├── README.md                          <- this file
├── SKILL.md                           <- entry point: principles, workflow, decisions
└── references/
    ├── design-tokens.md               <- color roles, type scale, shape, elevation, spacing, motion
    ├── layout-and-navigation.md       <- navigation patterns, window sizes, screen blueprints, states
    ├── components.md                  <- which M3 component to use, M2 -> M3 migration traps
    ├── polish-checklist.md            <- "non vibe-coded" tells, accessibility + review rubric
    ├── compose-theme.md               <- Color/Type/Shape/Dimens/Theme Kotlin templates
    ├── compose-example-screen.md      <- model screen with all UI states
    └── xml-theme.md                   <- Views (XML) theme + usage notes
```

## Using it in other tools

- **Claude (skills):** keep the folder as is. `SKILL.md` already has the required frontmatter (`name`, `description`).
  Claude Code: put the folder in `.claude/skills/` (project) or `~/.claude/skills/` (personal).
- **Cursor:** copy `SKILL.md` into `.cursor/rules/android-material-ui.mdc` (keep references alongside and mention them with `@references/...`).
- **GitHub Copilot:** put the content of `SKILL.md` into `.github/copilot-instructions.md` and keep `references/` in the repo.
- **Codex / other agents using AGENTS.md:** add a line to `AGENTS.md`: "For any Android UI work, follow `docs/android-material-ui/SKILL.md` and read the referenced files as needed."
- **Any chat or agent with no file support:** paste `SKILL.md` as the system prompt / first message, and attach the reference files that apply to the task.

Tip: the `SKILL.md` frontmatter can be deleted for tools that do not use it; everything else is plain Markdown.
