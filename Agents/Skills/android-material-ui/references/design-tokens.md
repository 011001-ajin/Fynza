# Material 3 design tokens

## Contents
1. Color roles and how to use them
2. Type scale
3. Shape scale
4. Elevation and tonal layering
5. Spacing and grid
6. State layers
7. Motion
8. Iconography

---

## 1. Color roles

Generate from a seed color. Never hand-pick hex for roles.

| Role | Use |
|---|---|
| `primary` / `onPrimary` | The single most important action (filled button, FAB tint, active slider) |
| `primaryContainer` / `onPrimaryContainer` | Tonal emphasis: selected states, highlighted cards, FAB container |
| `secondary` / `secondaryContainer` | Less prominent components: selected filter chips, navigation bar active indicator |
| `tertiary` / `tertiaryContainer` | Contrasting accent used sparingly, to balance primary or draw attention |
| `error` / `errorContainer` | Errors and destructive confirmation only |
| `surface` | Default screen background |
| `surfaceContainerLowest` → `surfaceContainerHighest` | Layered regions: cards, sheets, nav bars, dialogs. Higher = more contrast against `surface` |
| `onSurface` | Primary text and icons on surfaces |
| `onSurfaceVariant` | Secondary text, icons, helper text |
| `outline` | Borders that need to be seen (text field outline, outlined button) |
| `outlineVariant` | Dividers and decorative borders |
| `inverseSurface` / `inverseOnSurface` / `inversePrimary` | Snackbars |
| `scrim` | Modal overlays (32% alpha) |

Usage rules:
- Most of any screen should be `surface` and `surfaceContainer*` plus `onSurface` text. `primary` and `tertiary` appear in small doses. If a screen looks "colorful", it is probably overusing accent roles.
- Cards: `surfaceContainerLow` (elevated style), `surfaceContainerHighest` (filled style), or `surface` + `outlineVariant` border (outlined style). Pick one card style for the whole app.
- Always pair a container with its `on` color.
- Dark theme is a separate scheme from the same tonal palettes, not an inversion. Avoid pure `#000000` backgrounds unless intentionally OLED-black; use the scheme's `surface`. Avoid pure white text on dark; use `onSurface`.
- Dynamic color (Android 12+): `dynamicLightColorScheme(context)`; keep the branded scheme as the fallback for older devices.

### Baseline sample scheme (placeholder only, replace with brand seed)

Light: primary #6750A4, onPrimary #FFFFFF, primaryContainer #EADDFF, onPrimaryContainer #21005D, secondary #625B71, secondaryContainer #E8DEF8, tertiary #7D5260, tertiaryContainer #FFD8E4, error #B3261E, surface #FEF7FF, onSurface #1D1B20, onSurfaceVariant #49454F, outline #79747E, outlineVariant #CAC4D0.

Dark: primary #D0BCFF, onPrimary #381E72, primaryContainer #4F378B, onPrimaryContainer #EADDFF, secondary #CCC2DC, secondaryContainer #4A4458, tertiary #EFB8C8, tertiaryContainer #633B48, error #F2B8B5, surface #141218, onSurface #E6E0E9, onSurfaceVariant #CAC4D0, outline #938F99, outlineVariant #49454F.

If no brand color is given, choose a seed with intent that suits the domain (finance: deep teal or blue; health: green-teal; productivity: indigo; food/social: warm red-orange), generate the palette, and tell the user the seed so they can change it. Avoid the generic purple-to-blue "AI app" look.

---

## 2. Type scale (Roboto)

| Role | Size / Line height (sp) | Weight | Tracking | Typical use |
|---|---|---|---|---|
| displayLarge | 57 / 64 | 400 | -0.25 | Rare hero numerals |
| displayMedium | 45 / 52 | 400 | 0 | Rare |
| displaySmall | 36 / 44 | 400 | 0 | Big stat numbers |
| headlineLarge | 32 / 40 | 400 | 0 | Large screen titles |
| headlineMedium | 28 / 36 | 400 | 0 | Section/screen titles, large app bar title |
| headlineSmall | 24 / 32 | 400 | 0 | Small app bar / dialog headline |
| titleLarge | 22 / 28 | 400 | 0 | Top app bar title |
| titleMedium | 16 / 24 | 500 | 0.15 | List item headline, card title |
| titleSmall | 14 / 20 | 500 | 0.1 | Subheaders, tabs |
| bodyLarge | 16 / 24 | 400 | 0.5 | Main reading text |
| bodyMedium | 14 / 20 | 400 | 0.25 | Secondary text, list supporting text |
| bodySmall | 12 / 16 | 400 | 0.4 | Captions, helper text |
| labelLarge | 14 / 20 | 500 | 0.1 | Buttons |
| labelMedium | 12 / 16 | 500 | 0.5 | Chips, nav bar labels |
| labelSmall | 11 / 16 | 500 | 0.5 | Badges, tiny labels |

Rules: use roles, not raw sizes. Never go below 11sp. Keep reading text to about 60-75 characters per line on large screens. Build hierarchy with role + `onSurface` vs `onSurfaceVariant`, not by shrinking text below `bodyMedium`.

---

## 3. Shape scale

| Token | Corner radius | Used for |
|---|---|---|
| extraSmall | 4dp | Snackbar, small inner elements |
| small | 8dp | Chips |
| medium | 12dp | Cards, text fields, menus |
| large | 16dp | FAB, navigation drawer |
| extraLarge | 28dp | Dialogs, bottom sheets (top corners), large FAB |
| full | 50% | Buttons, search bar, badges, switches |

Rules: take shapes from `MaterialTheme.shapes`; do not hand-tune radii per screen. Nested shapes get a smaller radius than their container (inner radius = outer radius minus padding) so corners look concentric.

---

## 4. Elevation and tonal layering

Material 3 expresses elevation primarily by **tone** (surface container colors), with soft shadows only where separation is functionally needed.

| Level | dp | Components |
|---|---|---|
| 0 | 0 | Filled/outlined cards, navigation bar, top app bar (at rest), chips |
| 1 | 1 | Elevated card, modal bottom sheet |
| 2 | 3 | Top app bar (scrolled), menus |
| 3 | 6 | FAB, dialogs |
| 4 | 8 | Hover/focus of level 3 |
| 5 | 12 | Rarely used |

Rules: no stacked heavy drop shadows or colored shadows. Prefer `surfaceContainer*` backgrounds over shadow for grouping. Content scrolling under a top app bar shifts the bar to a `surfaceContainer` tone (use `TopAppBarDefaults.enterAlwaysScrollBehavior` / `exitUntilCollapsedScrollBehavior`).

---

## 5. Spacing and grid

- Base unit **4dp**; layout rhythm mostly **8dp**. Allowed tokens: 4, 8, 12, 16, 24, 32, 48, 64.
- Screen horizontal margin: **16dp** (compact), **24dp** (medium/expanded).
- Related items: 8dp apart; groups/sections: 24dp apart; card inner padding: 16dp; list item vertical padding: 8-16dp.
- Touch targets **at least 48×48dp**, with at least 8dp between adjacent targets.
- Keep values on the 4dp grid; no 13dp or 22dp.
- Window size classes: Compact < 600dp, Medium 600-839dp, Expanded 840dp and up.
- Keep consistent keylines: leading icons/avatars in one column, text left edges aligned across list items.

Define a `Spacing` object (see `references/compose-theme.md`) and use it everywhere.

---

## 6. State layers (interaction feedback)

| State | Overlay opacity |
|---|---|
| Hovered | 8% |
| Focused | 10% |
| Pressed | 10% (plus ripple) |
| Dragged | 16% |
| Disabled content | 38% |
| Disabled container | 12% |

Material components do this automatically. Custom clickables keep the default indication; never remove the ripple.

---

## 7. Motion

- Use **emphasized** easing for most transitions and **standard** for utility ones. Durations: small/utility 100-200ms, standard 250-300ms, large or full-screen 350-500ms; exits faster than enters.
- Prefer Material's transition patterns: container transform (card to detail), shared axis (sibling navigation), fade through (unrelated destinations), fade (in-place).
- Animate meaning (state change, hierarchy, feedback), never decoration. No looping ambient animation on content screens.
- Support **predictive back** and respect the system "remove animations" setting.
- Compose: `AnimatedVisibility`, `animateContentSize`, `Crossfade`, shared element transitions via `SharedTransitionLayout`.

---

## 8. Iconography

- Material Symbols (Rounded or Outlined; choose one for the whole app), weight 400, 24dp (20dp dense). Use the filled variant for the *selected* state in navigation and outlined for unselected.
- Icons are monochrome, tinted with `onSurface` / `onSurfaceVariant` / role colors. Never multicolor or emoji.
- Icon-only buttons need a `contentDescription` and a tooltip.
- Launcher icon: adaptive icon with a monochrome layer for Android 13+ themed icons.
