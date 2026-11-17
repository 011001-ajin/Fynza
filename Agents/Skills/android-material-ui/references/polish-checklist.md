# Polish checklist: making it look designed, not generated

Run this before delivering any UI. The first section lists the tells that make an app look "vibe coded"; the rest is a pass/fail rubric.

## Contents
1. The tells (avoid these)
2. What professional looks like instead
3. Consistency audit
4. Accessibility audit
5. State and resilience audit
6. Code hygiene audit
7. Review report format

---

## 1. The tells (avoid these)

**Visual**
- Purple-to-blue (or any) gradients on buttons, headers, or backgrounds; glows; glassmorphism; neon on dark.
- Emoji used as icons or as decoration in headings and buttons.
- Everything centered, including body text and list items.
- Every element boxed in its own card, with cards nested inside cards.
- Heavy drop shadows and a different corner radius on every element.
- Many colors on one screen; accent color on text, icons, borders, and backgrounds at once.
- Bold weight on everything; three or more font families; tiny gray text under 12sp.
- Oversized hero illustrations or stock-AI imagery that carries no information.
- Pure black backgrounds with pure white text; low-contrast gray on gray.
- Default baseline purple theme left unchanged.

**Structural**
- Lorem ipsum, "John Doe", "Item 1/Item 2", "Welcome to the app!", or marketing-speak ("Unlock your potential").
- Only the happy path: no loading, empty, error, or offline states.
- A header banner on every screen reading like a web page rather than an app bar.
- iOS idioms on Android: back chevron with text label, bottom tab bar with 6+ items, centered large title everywhere, action sheets.
- Web idioms: hover-only affordances, tiny link text, horizontal scrolling tables, hamburger menus on phones with 4 destinations.
- Custom-drawn buttons/switches/tabs that duplicate Material components but lack ripple, focus, and semantics.
- Title Case Or ALL CAPS buttons; vague labels ("Submit", "OK", "Click here").

**Code**
- Hardcoded colors, sizes, and strings inside composables.
- Magic-number padding (13.dp, 22.dp, 7.dp); inconsistent paddings between similar screens.
- Material 2 APIs mixed with Material 3.
- Missing `contentDescription`; touch targets under 48dp; ignoring insets so content hides under the status or navigation bar.

## 2. What professional looks like instead

- **Quiet, tonal surfaces** with one clear accent; hierarchy from type and spacing.
- **Predictable rhythm:** the same 16dp margins, 8dp inner gaps, and 24dp section gaps on every screen.
- **Left-aligned text** with strong, consistent keylines.
- **Real, specific copy:** short, plain, verb-led labels; sentence case; numbers formatted and localized (currency, dates, plurals via string resources).
- **Native behaviors:** edge-to-edge, predictive back, ripples, pull-to-refresh, system share sheet, system pickers, haptics on meaningful actions.
- **Purposeful motion:** subtle container transforms and state transitions, nothing looping.
- **Density tuned to the task:** compact lists for data-heavy apps, roomy for browsing.
- **Imagery with a job:** photos with rounded `medium` shapes and a scrim if text overlays; illustrations tonal and simple.
- **Brand through restraint:** seed color, one typeface, consistent iconography, a thoughtful launcher icon; not through effects.

## 3. Consistency audit

- [ ] All colors reference `MaterialTheme.colorScheme` roles (or `?attr/color*`).
- [ ] All text uses `MaterialTheme.typography` roles; at most 3 styles per screen section.
- [ ] All corners come from `MaterialTheme.shapes`; nested radii are concentric.
- [ ] All spacing values are on the 4dp grid and drawn from `Spacing` tokens.
- [ ] One card style, one text field style, one icon family/weight across the app.
- [ ] One primary (filled) action per screen/section.
- [ ] Same component used for the same job everywhere (for example, all settings rows are `ListItem`).
- [ ] Screen margins and top app bar behavior are the same across peer screens.

## 4. Accessibility audit

- [ ] Text contrast 4.5:1 (3:1 for large text); UI component boundaries and icons 3:1 in both light and dark themes.
- [ ] Touch targets at least 48×48dp, with 8dp spacing.
- [ ] Layout survives font scale 200% and display size "largest" without clipping or overlap (use `heightIn`, `wrapContentHeight`, scrollable containers; avoid fixed heights on text containers).
- [ ] Meaningful icons have `contentDescription`; decorative ones use `null`; images have alt text or are marked decorative.
- [ ] State is never conveyed by color alone (add icon, text, or shape).
- [ ] Screen-reader order is logical; grouped rows are merged into one focusable item; custom controls expose `role` and `stateDescription`.
- [ ] Keyboard and D-pad focus visible and ordered; IME actions configured.
- [ ] Animations respect reduced-motion settings; no flashing content.
- [ ] Headings marked (`Modifier.semantics { heading() }`) for section titles.
- [ ] Error messages are text-based, specific, and announced (`liveRegion`).

## 5. State and resilience audit

- [ ] Loading, content, empty, error, and offline states exist and look intentional.
- [ ] Long text truncates with `maxLines` + `TextOverflow.Ellipsis` only where non-critical; names, amounts, and error messages wrap.
- [ ] Lists handle 0, 1, and 1,000 items; images have placeholders and error fallbacks.
- [ ] Forms preserve input across rotation/process death (`rememberSaveable`, ViewModel `SavedStateHandle`).
- [ ] Dark theme verified screen by screen; dynamic color verified if enabled.
- [ ] Verified on compact phone, tall phone, tablet/foldable, landscape.
- [ ] RTL layout mirrors correctly (use `start`/`end`, not `left`/`right`).
- [ ] Destructive actions are confirmable or undoable.

## 6. Code hygiene audit

- [ ] `material3` only; no M2 imports.
- [ ] Strings in `strings.xml` (or a resource abstraction), not inline literals.
- [ ] Composables small, stateless where possible, with `modifier: Modifier = Modifier` as the first optional parameter and passed to the root element.
- [ ] `@Preview`s for light, dark, and large font scale; realistic sample data.
- [ ] `Scaffold` `innerPadding` applied; edge-to-edge configured.
- [ ] `LazyColumn` items have stable `key`s; no heavy work in composition.
- [ ] No hardcoded dp heights on text-containing elements.

## 7. Review report format (when asked to review or restyle)

```
## Summary
One or two sentences: overall impression and the 2-3 highest-impact fixes.

## Findings
### Must fix (breaks accessibility, usability, or Material conventions)
- [Where] Problem → Fix (with code if short)
### Should fix (consistency and polish)
- ...
### Nice to have
- ...

## Revised code
(complete corrected composables/theme)
```

Be specific: name the file/composable and the exact token or component to use. Do not give generic advice such as "improve spacing".
