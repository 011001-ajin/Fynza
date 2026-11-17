---
name: android-material-ui
description: Design and build professional, polished Android app UI/UX using Material Design 3 (Material You). Covers theming (color roles, Roboto/Roboto Flex typography, shape, elevation), layout, navigation, components, accessibility, and adaptive screens, for Jetpack Compose or XML/Material Components. Use this skill whenever the user is designing, building, reviewing, restyling, or fixing the look and feel of an Android app screen, component, theme, or flow, even if they only say "make this screen look better", "UI for my app", "Compose screen", "app theme", "dark mode", "colors/fonts for my Android app", or ask for something that "doesn't look AI-generated" or "looks professional". Also use for Material 3 mockups or wireframes of Android screens.
---

# Android UI/UX with Material Design 3

This skill makes Android UI look like it was designed by a product design team, not generated in one pass. The difference is almost never about flashy visuals. It comes from **systematic tokens, consistent spacing, correct component choice, complete states, and restraint**. Apply those and the result reads as professional.

## Operating principles

1. **Tokens, not values.** Every color, text style, shape, and spacing in a screen comes from the theme or a named constant. A hardcoded `Color(0xFF3B82F6)` or `fontSize = 17.sp` inside a composable is the clearest sign of amateur work. Tokens are also what make dark mode, dynamic color, and font scaling work for free.
2. **Use the real Material 3 component before building a custom one.** Users already know how `NavigationBar`, `FilledTonalButton`, `ListItem`, and `ModalBottomSheet` behave. Custom lookalikes break ripples, accessibility semantics, and state layers.
3. **Restraint is the style.** One primary action per screen, one accent color family, two or three type styles per screen, no decoration that carries no information. Hierarchy comes from size, weight, and tonal surface, not from gradients and shadows.
4. **Design every state.** Loading, empty, error, offline, partial content, long text, small screen, large font, dark mode. Polished apps are mostly defined by how they behave off the happy path.
5. **Design for Android, not for a web page or iOS.** System back gesture, edge-to-edge with insets, Material navigation patterns, sentence-case buttons, ripple feedback, predictive back, adaptive window sizes.

## Workflow

### 1. Establish context (ask only what is missing)
Before designing, know: the app's purpose and audience, Compose or XML Views, brand color or logo (if none, pick a seed color deliberately: see below), whether the project already has a theme, and whether this is a new screen, a restyle, or a review. If a codebase or screenshots are provided, read them first and extend the existing theme rather than replacing it. If the user hasn't specified, **default to Jetpack Compose + Material 3** and say so in one line.

### 2. Set up or audit the theme first
No screen work happens before the theme is right. Read `references/design-tokens.md`, then:
- **New project:** copy the code from `references/compose-theme.md` (or `references/xml-theme.md` for Views) and replace the seed-derived colors. Generate the color scheme from the brand seed using Material Theme Builder logic (tonal palettes), not by hand-picking hex values. The shipped baseline purple scheme is a placeholder: leaving it unchanged is a "default template" tell, so always swap it for the brand's seed (or enable dynamic color with a branded fallback).
- **Existing project:** audit for hardcoded values, Material 2 leftovers, and missing dark scheme; fix the theme layer before touching screens.

### 3. Design the screen structure
Read `references/layout-and-navigation.md`. Decide: the screen's single job, its primary action, the navigation pattern (navigation bar vs rail vs drawer, top app bar type), window-size behavior, and the content hierarchy. Sketch the structure in plain words before writing code (for example: "Large top app bar → search bar → filter chips → list of 2-line items → FAB for create").

### 4. Pick components deliberately
Read `references/components.md` for the component-selection table and the do/don't notes for each. Match the component to the user's intent (for example, a segmented button for 2-5 mutually exclusive options, not a row of custom pills).

### 5. Build it
Write production-quality code (see "Code standards"). Include previews for light/dark and a large font scale in Compose. Provide all states, not just the happy path.

### 6. Run the polish pass before delivering
Read `references/polish-checklist.md` and verify the output against it. Fix failures silently; mention only meaningful trade-offs to the user.

## Typography decision (the font question)

**Use Roboto** as the default. It is the Android system typeface, the face Material 3's type scale was designed and metric-tuned around, renders crisply at every size, has full weight and language coverage, and costs nothing in APK size when you rely on the platform font. For apps that want a bit more expressive range, use **Roboto Flex** (variable font with weight, width, optical size, and grade axes), which Material 3 Expressive builds on. Both are open source.

Rules that matter more than the font choice:
- Use the **M3 type scale roles** (`displayLarge` … `labelSmall`) by role; do not invent sizes.
- Use at most **two weights** in most screens (Regular 400 and Medium 500; Bold only for rare emphasis). Heavy weights everywhere read as shouting.
- Use `sp` for all text so user font scaling works; never clip or truncate critical text when scaled to 200%.
- Do **not** mix in a decorative display face unless the brand genuinely requires it, and then use it only for `display`/`headline` roles while body and label stay Roboto.
- Avoid all-caps for buttons and labels (Material 3 uses sentence case). 
- Google Sans is a proprietary brand font; do not assume it is licensed for the user's app.

Full scale values are in `references/design-tokens.md`.

## Color decision

- Derive the scheme from **one seed color** via tonal palettes; use Material Theme Builder (material-foundation.github.io/material-theme-builder) or the `material-color-utilities` library. This guarantees accessible contrast pairs.
- On Android 12+, support **dynamic color** (`dynamicLightColorScheme` / `dynamicDarkColorScheme`) as an option, with the branded scheme as the fallback. Respect brand-critical screens by allowing a toggle if the brand needs to be fixed.
- Use **color roles by meaning**: `primary` for the single key action, `primaryContainer`/`secondaryContainer` for tonal emphasis, `surfaceContainer*` for layered backgrounds, `error` only for errors, `outlineVariant` for dividers. Never use a role for its look; use it for its meaning.
- Meet contrast: 4.5:1 for body text, 3:1 for large text and UI boundaries. Pairs like `onPrimary` on `primary` already satisfy this; do not put arbitrary text on arbitrary fills.
- Do **not** add gradients, glows, or neon accents. If the brand needs a signature moment (a splash or onboarding illustration), confine it there.

## Code standards

**Jetpack Compose (default)**
- Wrap the app in a single `AppTheme` (see `references/compose-theme.md`); read values via `MaterialTheme.colorScheme`, `.typography`, `.shapes`, and a `LocalSpacing` object.
- Edge-to-edge with `enableEdgeToEdge()`, `Scaffold` with `innerPadding` applied, and `WindowInsets` handled for status bar, navigation bar, and IME.
- Use `Modifier.padding` from spacing tokens only (multiples of 4dp, mostly 8/16/24).
- Make each screen stateless around a `UiState` (loading / content / empty / error) and show all four.
- Use `contentDescription` for meaningful icons and `null` for decorative ones; merge semantics on rows (`Modifier.semantics(mergeDescendants = true)` or clickable on the whole row).
- Minimum touch target 48dp. `IconButton` already does this; custom clickables must add `minimumInteractiveComponentSize()`.
- Icons: **Material Symbols** (Rounded or Outlined, weight 400, 24dp), consistent style across the whole app. Never emoji as icons.
- Add `@Preview` for light, dark, and `fontScale = 1.5f`.

**XML / Material Components**
- Theme parent `Theme.Material3.DayNight.NoActionBar`; define color roles in `themes.xml` + `values-night`; reference only `?attr/colorSurface`-style attributes in layouts. See `references/xml-theme.md`.
- Use `MaterialToolbar`, `NavigationBarView`, `MaterialButton` styles (`Widget.Material3.Button.TonalButton`, etc.), `TextInputLayout` with outlined or filled style, `ConstraintLayout` for structure.

## Output expectations

- **When asked for a screen or component:** deliver complete, compilable code, plus a 2-4 line note explaining the structure and the key decisions (navigation pattern, which component and why). Do not pad with a tutorial.
- **When asked for a theme:** deliver the theme files (color, type, shape, spacing, theme wrapper) with the seed color stated.
- **When asked for a review or restyle:** list concrete findings grouped by severity (breaks accessibility or Material conventions first, polish second), each with the fix, then provide corrected code.
- **When asked for a mockup or wireframe** (no codebase): build a faithful HTML/CSS mockup using the same tokens (CSS variables named after M3 roles, Roboto, 4dp grid, a 360×800dp frame), so the design can be translated to Compose one to one. Never invent non-Material controls.
- Keep the user's brand and existing choices; improve consistency, do not impose a new identity unless asked.

## Reference files (read when needed)

| File | Read when |
|---|---|
| `references/design-tokens.md` | Setting up or auditing theme: color roles, type scale, shape, elevation, spacing, state layers, motion |
| `references/layout-and-navigation.md` | Planning screen structure, navigation, window size classes, insets, screen anatomy |
| `references/components.md` | Choosing components, configuring them, avoiding common misuse |
| `references/polish-checklist.md` | Final pass: "non-vibe-coded" tells, accessibility, states, review rubric |
| `references/compose-theme.md` | Starting a Compose theme (Color, Type, Shape, Dimens, Theme code) |
| `references/compose-example-screen.md` | Need a model screen with loading/empty/error states |
| `references/xml-theme.md` | Starting a Views (XML) theme |
