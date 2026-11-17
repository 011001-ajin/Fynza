# Layout, navigation, and screen anatomy

## Contents
1. Choosing a navigation pattern
2. Top app bar selection
3. Window size classes and adaptive layout
4. Screen anatomy and insets
5. Content hierarchy principles
6. Common screen blueprints
7. Forms and input
8. Empty, loading, and error states

---

## 1. Choosing a navigation pattern

| Situation | Pattern |
|---|---|
| 3-5 top-level destinations of equal importance, phone | **Navigation bar** (bottom). Always show labels. Filled icon for selected, outlined for unselected |
| Same destinations, tablet / foldable / landscape (medium+) | **Navigation rail** (use `NavigationSuiteScaffold` to switch automatically) |
| 6+ destinations or a large hierarchy, expanded width | **Permanent / modal navigation drawer** |
| Detail screen reached from a list | Push destination; **top app bar with back arrow**; no bottom bar needed |
| Switching views of the same content | **Tabs** (primary under app bar; secondary within content) or segmented buttons |
| Secondary or contextual choice | Menu, bottom sheet, dialog |

Rules:
- Never put more than 5 items in a navigation bar; never use a hamburger drawer as the only navigation for 3-5 destinations.
- Back behavior follows the system: back always goes up/back in history, never exits unexpectedly. Support predictive back.
- Top-level destinations do not show a back arrow.
- Do not duplicate navigation (tabs and bottom bar for the same destinations).

## 2. Top app bar selection

| Type | Use |
|---|---|
| Center-aligned | Top-level screen with a short title and few actions |
| Small | Default for most screens; title left-aligned with back/menu icon |
| Medium / Large (collapsing) | Screens with a prominent title and scrolling content; collapse on scroll |
| Search bar / search app bar | When search is the screen's primary function |

Max 2-3 action icons; overflow the rest into a menu. Titles are short nouns, not sentences.

## 3. Window size classes and adaptive layout

| Class | Width | Layout approach |
|---|---|---|
| Compact | < 600dp | Single pane, bottom navigation bar |
| Medium | 600-839dp | Navigation rail; single or two-pane (list + detail narrow) |
| Expanded | 840dp+ | Navigation rail/drawer; **list-detail** or **supporting-pane** canonical layouts |

- Use `currentWindowAdaptiveInfo()` / `WindowSizeClass`, and `NavigableListDetailPaneScaffold` for list-detail.
- Do not stretch phone UIs to fill a tablet. Constrain reading content to ~840dp max width, or use panes.
- Test portrait, landscape, split-screen, foldable posture, and font scale 1.3-2.0.

## 4. Screen anatomy and insets

- Draw **edge-to-edge**: call `enableEdgeToEdge()`; apply `innerPadding` from `Scaffold` to scrolling content; use `contentWindowInsets`.
- Handle status bar, navigation bar (gesture or 3-button), display cutouts, and IME (`imePadding()`).
- Standard vertical stack: top app bar → (optional) filters/tabs → content → (optional) bottom bar. A FAB floats 16dp from the edges above the bottom bar.
- Scrolling content gets bottom padding so the last item clears the FAB (about 88dp) and system bars.
- Keep the primary action reachable by the thumb (bottom half) on phones.

## 5. Content hierarchy principles

1. **One focal point per screen.** Decide what the user should notice first; make it the largest, highest-contrast, or only tonally emphasized element.
2. **Group by proximity, separate by space.** Use 8dp inside groups and 24dp between groups before reaching for dividers or boxes. Use dividers (`HorizontalDivider` with `outlineVariant`) only inside dense lists.
3. **Align.** A consistent left edge and keyline beats decoration.
4. **Hierarchy through role, not decoration.** Title (`titleMedium`) over supporting text (`bodyMedium` + `onSurfaceVariant`); no extra boxes or colored backgrounds needed.
5. **Progressive disclosure.** Show the essentials; move rare options into menus, sheets, or detail screens.
6. **One primary action.** One filled button or FAB per screen; secondary actions are tonal, outlined, or text buttons.
7. **Real content.** Design with realistic names, long strings, numbers, and missing data. Never ship lorem ipsum or "John Doe".
8. **Avoid card-in-card and boxes around everything.** If everything is in a card, nothing is.

## 6. Common screen blueprints

**List / feed:** Large or small top app bar → search bar or filter chips (optional) → `LazyColumn` of `ListItem`s or cards with consistent keylines → FAB or top-bar action to create. Pull-to-refresh (`PullToRefreshBox`). Sticky headers for grouped data.

**Detail:** Top app bar with back + 1-2 actions → hero (image or key stat) → title (`headlineSmall`) → metadata row → body → primary action bottom-anchored or in a bottom app bar.

**Dashboard / home:** Greeting or context line → one primary summary card → horizontally scrolling or grid secondary cards → recent activity list. Max 3 distinct card types.

**Settings:** Top app bar → grouped `ListItem`s with section headers (`titleSmall`, `primary` color) → switches and radio items trailing; no cards inside; dividers between groups only.

**Onboarding:** 2-3 pages max, one idea per page, illustration + `headlineMedium` + `bodyLarge`, a filled "Continue" button, text "Skip". Permissions are requested in context, not up front.

**Auth:** App mark → `headlineMedium` title → outlined text fields → filled Sign in button → text button for secondary link. Support autofill, passkeys/credential manager, show/hide password, IME actions (Next/Done).

## 7. Forms and input

- Outlined text fields for general use, filled for dense/dialog contexts; one style per app.
- Always a visible label (floating) plus optional supporting text; error text below the field with an error icon, not color alone.
- Set `KeyboardOptions` (type, `ImeAction`), autofill hints, and sensible focus order.
- Validate on blur or submit, not on every keystroke for the first entry.
- Primary submit button full-width on compact, content-width on large screens.
- Prefer pickers (date/time pickers, exposed dropdown menus, segmented buttons) to free text where choices are finite.

## 8. Empty, loading, and error states

- **Loading:** skeleton/shimmer placeholders matching final layout for lists; `CircularProgressIndicator` or `LinearProgressIndicator` for short operations. Never a blank screen.
- **Empty:** a short headline (what's missing), one line explaining why or what to do, and one action. A simple monochrome or tonal illustration is optional.
- **Error:** plain-language message (no stack traces or "Something went wrong" alone), a retry action, and preserve any content already on screen.
- **Offline:** inform non-intrusively (snackbar or banner), keep cached content usable.
- **Success/feedback:** snackbar for transient confirmations (with Undo for destructive actions); dialogs only when a decision is needed.
