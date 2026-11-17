# Material 3 component selection and usage

## Contents
1. Buttons and actions
2. Selection and input controls
3. Containment (cards, lists, sheets, dialogs)
4. Navigation components
5. Feedback and status
6. Material 2 to Material 3 migration traps

---

## 1. Buttons and actions

| Need | Component (Compose) | Notes |
|---|---|---|
| The single main action | `Button` (filled) | One per screen/section. Full-pill shape, `labelLarge`, sentence case |
| Important but not primary, next to a filled button | `FilledTonalButton` | Uses `secondaryContainer` |
| Medium emphasis, many on screen | `OutlinedButton` | `outline` border |
| Low emphasis, dialogs, inline | `TextButton` | |
| Lightly raised over busy backgrounds | `ElevatedButton` | Rare |
| Primary creation action of a screen | `FloatingActionButton` / `ExtendedFloatingActionButton` | One per screen; extended when a label clarifies; hide or collapse on scroll |
| 2-5 mutually exclusive options | `SingleChoiceSegmentedButtonRow` | Not a row of custom pills |
| Icon-only action | `IconButton` (standard/filled/tonal/outlined) | Needs `contentDescription`; 48dp target |
| Toggle action | `IconToggleButton` | Filled icon when on |

Rules: button labels are verbs in sentence case ("Save changes", not "SAVE" or "Click Here"). Pair destructive confirmations as text buttons in a dialog, not a red filled button on the main screen. Leading icons in buttons are optional; use 18dp with 8dp gap.

## 2. Selection and input controls

| Need | Component |
|---|---|
| Free text | `OutlinedTextField` / `TextField` (filled) |
| Search | `SearchBar` / `DockedSearchBar` |
| Pick one from a long list | `ExposedDropdownMenuBox`, or a full-screen list/dialog |
| Pick one from 2-4 visible options | `RadioButton` in rows, or segmented buttons |
| Multiple on/off | `Checkbox` |
| Immediate on/off setting | `Switch` (takes effect instantly; thumb icon optional) |
| Range/value | `Slider` / `RangeSlider` |
| Filter results | `FilterChip` (multi-select, shows check when selected) |
| Choose an input option / entity | `InputChip` |
| Suggest quick actions | `SuggestionChip`, `AssistChip` |
| Date / time | `DatePicker`, `TimePicker` (modal or docked) |

Rules: switches change state immediately and need no Save; checkboxes belong to forms submitted later. Chips are for compact attributes and filters, not for primary navigation.

## 3. Containment

**Cards** (`Card`, `ElevatedCard`, `OutlinedCard`): group one coherent unit of content that may be tapped as a whole. 12dp radius, 16dp inner padding. Choose one style for the app. Do not nest cards or wrap simple lists in cards; use `ListItem` rows on `surface`.

**Lists** (`ListItem`): one-, two-, or three-line items with leading (icon/avatar/image), trailing (meta/switch/icon), headline (`bodyLarge`), supporting text (`bodyMedium`, `onSurfaceVariant`). Row min height 56dp (1-line), 72dp (2-line), 88dp (3-line). Make the whole row the click target.

**Bottom sheets** (`ModalBottomSheet`, `BottomSheetScaffold`): contextual actions or short tasks; drag handle shown; 28dp top corners. Not for long forms.

**Dialogs** (`AlertDialog`): only for decisions or critical info. Title (`headlineSmall`) is optional; body `bodyMedium`; actions right-aligned text buttons, confirm on the right. Full-screen dialog for multi-field creation on compact screens.

**Dividers** (`HorizontalDivider`): `outlineVariant`, 1dp, inset to align with text keyline in lists.

**Carousels / Pager**: `HorizontalMultiBrowseCarousel` for browsable media; `HorizontalPager` with indicators for onboarding.

## 4. Navigation components

| Component | Use |
|---|---|
| `NavigationBar` + `NavigationBarItem` | Compact top-level destinations (3-5), labels always visible |
| `NavigationRail` | Medium+ top-level destinations; optional FAB at top |
| `ModalNavigationDrawer` / `PermanentNavigationDrawer` | Many destinations; expanded screens |
| `TopAppBar` variants | Screen title, back, actions (see layout reference) |
| `BottomAppBar` | Contextual actions + FAB on detail/edit screens |
| `PrimaryTabRow` / `SecondaryTabRow` | Switch peer views within a screen; scrollable if more than 4 |

## 5. Feedback and status

| Need | Component |
|---|---|
| Brief confirmation, undo | `Snackbar` via `SnackbarHost` (one line, optional single action) |
| Indeterminate wait | `CircularProgressIndicator`, `LinearProgressIndicator` (use wavy variants only if adopting M3 Expressive) |
| Determinate progress | Progress indicators with a value |
| Count/unread on an icon | `Badge` / `BadgedBox` |
| Explain an icon | `TooltipBox` |
| Persistent inline notice | Banner-style `Card` with `tertiaryContainer` or `errorContainer`, with action |

Rules: do not use Toasts for anything actionable; do not stack multiple snackbars; do not use dialogs for success messages.

## 6. Material 2 to Material 3 migration traps (common tell of outdated or generated code)

| Outdated / wrong | Use instead |
|---|---|
| `androidx.compose.material.*` imports | `androidx.compose.material3.*` |
| `BottomNavigation` | `NavigationBar` |
| `TopAppBar` (M2) with shadow | M3 `TopAppBar` + `scrollBehavior` |
| `backgroundColor`, `primaryVariant`, `onBackground` as surface | `containerColor`, `primaryContainer`, `surface`/`onSurface` |
| `MaterialTheme.typography.h1…caption` | `displayLarge…labelSmall` |
| `Surface(elevation = 8.dp)` shadows to separate | `tonalElevation` / `surfaceContainer*` |
| `Divider` | `HorizontalDivider` |
| `Scaffold` ignoring `innerPadding` | Always apply `innerPadding` |
| `accompanist-systemuicontroller` | `enableEdgeToEdge()` |
| ALL-CAPS button text | Sentence case |
| `Card(elevation = 4.dp)` | `CardDefaults.cardElevation(...)` with levels from the token table |
