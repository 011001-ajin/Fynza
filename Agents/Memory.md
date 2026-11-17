# Fynza — Project Memory

## Purpose

Fynza is an offline-first Flutter expense tracker. It supports income and expense tracking, categories, monthly budgets, dashboard summaries, currency selection, backup/restore, auto-capture from SMS and UPI payment apps, and local persistence with Drift.

## Stack

- Flutter / Dart with Material 3
- Bundled **Google Sans** typography (`assets/fonts/GoogleSans.ttf`)
- Riverpod (`StateNotifierProvider`, `StreamProvider`) for UI state and
  dependency injection
- Drift for the local relational database
- `shared_preferences` for app settings, including currency and backup frequency
- `fl_chart` for dashboard and statistics charts; the year heatmap is a
  custom calendar grid
- `file_picker`, `share_plus`, `path_provider`, `workmanager`, `package_info_plus` for backup & storage

## Architecture

The project uses feature-oriented MVVM with layer boundaries:

```
View → ViewModel → Domain contract → Data implementation → DAO / Service
```

Key locations:

- `lib/core/` — theming, utilities, DI, and settings services
- `lib/data/db/` — Drift database and tables
- `lib/shared/` — models, reusable widgets, and shared providers
- `lib/features/` — dashboard, transactions, statistics, budget, categories,
  settings, navigation, backup, and auto-capture

Architecture rules currently applied:

- Domain repository contracts and entities do not import Drift, database rows, or data-layer services.
- Drift rows are mapped to domain `Category`, `Transaction`, and `Budget` entities at the data boundary.
- Feature repository implementations live under each feature's `data/repositories/`; app-level cross-feature compositions live under `lib/data/repositories/`. Contracts remain under `domain/repositories/` or `lib/shared/domain/repositories/` when they are shared.
- Presentation code consumes domain contracts/service interfaces and app-level Riverpod providers rather than importing data services or generated database models.
- `lib/core/di/database_provider.dart` is the composition root for repositories and infrastructure-backed providers. `AppStartupCoordinator` keeps startup scheduling orchestration out of the navigation view.
- Backup file metadata and service abstractions used by presentation live in the domain layer; the repository contract exposes paths and value types rather than `File` or `CurrencyService`.
- Cross-feature screen navigation uses shared route names/arguments and the app-level `AppRouteFactory`; feature presentation code does not import peer feature screens.
- Cross-feature read models are composed in `lib/data/repositories/`, keeping peer-feature provider access out of dashboard and transaction-list presentation.
- Capture controls, transaction entry coordination, backup platform operations, and currency persistence are accessed through repository contracts by their view models.
- Reusable category models and transaction tiles live in `lib/shared/`; feature presentation uses theme tokens rather than defining its own palette.
- Statistics presentation uses repository-backed Riverpod stream providers; yearly totals and chart aggregates are computed in a domain summary model, not in widgets or DAOs.
- Focused view-model tests cover dashboard, categories, and auto-capture behavior in addition to the existing transaction and backup tests.

## Current UI and Feature State

### Branding, Typography and Design System

- **Brand Name**: **Fynza** (root widget: `FynzaApp`).
- **Typography**: **Google Sans** applied globally from the bundled font asset via `AppTheme._buildGoogleSansTextTheme`, with comfortable body leading. The font and its OFL license and trademark notice are bundled under `assets/fonts/`; the app does not download the font at runtime.
- **Warm Material 3 Theme & Color Palette**:
  - **Scaffold Background**: Warm Vanilla Oat Cream (`#FDF8F3` in light mode, `#191715` in dark mode).
  - **Cards & Surfaces**: Material 3 surface-container roles with restrained shapes and no decorative elevation.
  - **Primary & Accent Brand**: Warm Apricot / Honey Amber (`#F6A63C`).
  - **Expense Cards**: Soft Rose Blush (`#FDECE9` / `#331D1C` dark) with warm coral text (`#D94136` / `#FF8A80` dark).
  - **Income Cards**: Matcha Mint (`#E6F5EC` / `#162D20` dark) with forest jade text (`#238244` / `#81C784` dark).
  - **Pastel Chart Palette**: `[#F49E8C, #7DBCE6, #C2A5E7, #F7CE72, #7FDCB8]`.
  - **Category Accent Palette**: 24 coordinated warm pastel accents (apricot, sage, denim, lavender, rose, berry, teal, honey, jade, sea glass, terracotta, cocoa, sky, marigold, eucalyptus, and more) shared by the category picker and default category seeding. Schema v4 migrates existing stored categories using the old palette to the new palette while preserving arbitrary custom colors.

### Dashboard & Financial Summary

- **Dashboard Header**: Uses the concise "Dashboard" title.
- **`MonthSelector`**: Themed Material surface with accessible icon buttons and swipe navigation; no blur or haptic effect.
- **Net Balance Card**: Uses the warm brand palette without decorative glow or press-scale effects.
- **Side-by-Side Summary Cards**:
  - Left card: Soft Rose Blush (`#FDECE9`) Expense card with upward arrow circular badge (`Icons.arrow_upward_rounded`) and coral text.
  - Right card: Matcha Mint (`#E6F5EC`) Income card with downward arrow circular badge (`Icons.arrow_downward_rounded`) and jade text.
- **Spending Overview & Breakdown**: Dashboard shows a compact donut and category summary styled after the finance inspiration reference. The `Detail` action opens a dedicated breakdown page with the existing larger chart and full category list. Both charts and legend rows are informational only, with no tap-to-focus, animation selection, or haptic interaction.
- **Statistics**: The Stats destination follows Transactions in both navigation layouts. It displays current-calendar-year totals, monthly income/expense bars, an expense trend line, category pie breakdown, weekday radar, daily spend scatter plot, and a custom daily expense calendar heatmap that opens at the current month while retaining the full-year horizontal scroll. Current-month budget utilization is shown alongside the yearly analytics. Statistics are aggregated from repository streams using integer cents; only chart coordinates convert cents to doubles.
- **Dashboard Refresh & Entrance Motion**: Pull-to-refresh can drain the Android notification capture queue when auto-capture is enabled. Scroll content uses standard Material behavior without decorative entrance animations; edge fades are handled separately by `FadingScrollBoundary`.
- **Vertical Scroll Edge Fades**: `FadingScrollBoundary` applies animated top/bottom fades to vertical scrollables and updates them from scroll metrics. Use it on screen, dialog, and bottom-sheet scrollables; do not wrap horizontal or non-scrollable nested lists.
- **AppBar Scroll State**: Light and dark AppBar themes use zero scrolled-under elevation and a transparent surface tint, preventing AppBars from darkening or changing shade as content scrolls beneath them.
- **Quick Access**: Budgets and Categories use responsive Material cards/list tiles instead of fixed square cards.
- **Responsive Navigation**: Compact layouts use a Material `NavigationBar`; widths of 600dp and above use a `NavigationRail`. Both use Dashboard, Transactions, Stats, and Settings in that order. The add-transaction action is available as a FAB or rail destination.
- **`TransactionTile`**: Themed Material `Card` and `InkWell` provide standard surface and interaction states.
- **`MoneyText`**: Dynamic colored text using `AppTheme.incomeAccent` and `AppTheme.expenseAccent`.

### Transactions and categories

- Income uses `Icons.arrow_downward`; expenses use `Icons.arrow_upward` throughout the UI.
- Category creation uses a dedicated full-screen form with Material selection controls for icon and color.
- Category save returns silently without a success SnackBar.
- Transaction creation and editing use `TransactionFormScreen`.
- **Segmented Filter** (`lib/shared/widgets/fluid_segmented_control.dart`): Wraps Material `SegmentedButton` for transaction filters and expense/income selection.
- **Search Field** (`lib/features/transactions/presentation/widgets/transaction_search_bar.dart`): Uses Material `SearchBar` with an accessible clear action.
- **Date Section Headers** (`lib/features/transactions/presentation/widgets/transaction_date_header.dart`): Grouped calendar days displaying friendly titles (`Today, Nov 5`, `Yesterday, Nov 4`) with color-coded daily net totals.
- **Tactile Swipe Dismissal**: `Dismissible` with `HapticFeedback.mediumImpact()` triggered when swiping reaches the threshold, paired with a rounded red delete action background.

### Transaction Entry Experience (`TransactionFormScreen`)

- **Amount Display**: Clear amount entry with adaptive income/expense color and a clear action.
- **Quick Amount Chips**: Standard Material choice controls for common amount increments.
- **Transaction Type and Category Selection**: Material segmented and choice controls without custom spring, halo, or haptic effects.
- **Recent Category Picker**: Transaction entry shows up to three recently used categories for the current income/expense type; when there is no history, it shows the first three matching categories. The animated `More` section expands to a searchable list. Selecting a category collapses the list, clears the query, and pins the selection first among the recent chips.
- **Date and Note Inputs**: Use themed Material form controls.
- **Submit Action**: Uses the themed primary Material button.

### Budgets & Categories Polish

- **Budget Progress** (`lib/shared/widgets/spring_progress_bar.dart`): Uses Material `LinearProgressIndicator` with semantic progress colors.
- **`BudgetCard` and `BudgetScreen`**: Use themed Material surfaces and standard actions without gradient hero surfaces.
- **`BudgetFormDialog`**: Uses Material choice controls and a themed save action.
- **Budget Category Picker**: New budgets show up to three recently used expense categories, falling back to the first three expense categories when there is no history. The animated `More` section provides search. No category is selected by default; the user must choose one. After selection, the list collapses, search clears, and the selected category is pinned first among the recent chips. Editing an existing budget retains its assigned category.
- **`CategoriesScreen`**: Uses a Material segmented type switcher, category cards/list tiles, and a retryable error state.

### Currency

- The app supports preset currencies and a persisted custom currency.
- Currency selection is managed by `CurrencyService` and `selectedCurrencyProvider`.
- Currency values are stored as integer cents and formatted through `CurrencyFormatter`.
- Formatted amounts use Indian grouping for INR (for example, `₹ 12,34,56,789.00`) and international thousands separators for other preset and custom currencies (for example, `$ 123,456.78`), with a space after the currency symbol.
- Settings uses an expandable Currency section: it expands when tapped and collapses after a selection.

### Shared month selection

- `lib/shared/providers/global_month_provider.dart` is the single source of truth for the selected month.
- Dashboard, Transactions, and Budget screens all display and update this same provider.
- Changing the month with arrows or a horizontal swipe on any one of these screens updates all three feature data streams.
- Feature view models retain a local month only to query their repositories; they listen to the global provider and refresh when it changes.
- `MonthSelector` lives at `lib/shared/widgets/month_selector.dart`.
- Month-label changes use a fixed-width, centered ease-in/ease-out cross-fade with a subtle scale transition. Keep the animation direction-independent so rapid forward/backward navigation does not make outgoing labels reverse along an outdated path.

### Backup and Restore ("Data and Storage")

- Accessible from the Settings screen via "Data & Storage" (`DataAndStorageView`).
- Design modeled after Mihon: Storage location with one-tap copy, pill action buttons (`Create backup` | `Restore backup`), auto-backup frequency tile, relative time indicators, and live storage breakdown (database, backups, total).
- Custom file format: UTF-8 JSON compressed with gzip (`.expbak`), verified by `0x1F, 0x8B` magic bytes.
- Filename conventions with **Fynza** brand:
  - Manual backups: `fynza_YYYY-MM-DD_HH-mm-ss.expbak`
  - Automatic backups: `auto_fynza_YYYY-MM-DD_HH-mm-ss.expbak`
  - Safety backups: `pre_restore_fynza_YYYY-MM-DD_HH-mm-ss.expbak`
- Hand-crafted DTOs with hand-written serialization (`BackupDto`, `BackupSerializer`, `BackupValidator`) to prevent schema rename drift.
- Single-transaction atomic backup creation and restore via Drift (`$writeTracker.writeTransaction`).
- Mandatory pre-restore safety copy saved to `<backup_dir>/pre_restore/` before modifying existing data.
- Automatic background backups using `Workmanager` (`^0.10.0`) with configurable frequency (Off, 6h, 12h, Daily, 2d, Weekly), rotation (keeping newest 2 auto-backups), and app launch catch-up.
- In-app restore sheet with "Choose a file..." file picker and automatic backups list with inline actions (Restore, Share, Delete).

### Auto-Capture Transactions (SMS & Payment Apps)

- Located at `lib/features/auto_capture/`.
- Enables automatic detection, parsing, and bookkeeping of bank SMS notifications and direct push notifications from UPI/payment apps (Google Pay, PhonePe, Paytm, CRED, BHIM, Amazon Pay, Samsung Pay, and major mobile banking apps) on Android via a privacy-first, on-device pipeline.
- **Native Android Listener (`SmsNotificationListenerService.kt`)**:
  - Registered in `AndroidManifest.xml` with `android.permission.BIND_NOTIFICATION_LISTENER_SERVICE`.
  - Filters out grouped summaries (`FLAG_GROUP_SUMMARY`) to prevent duplicates.
  - Verifies package matches default SMS app, messaging packages, or supported payment/banking apps (`KNOWN_PAYMENT_PACKAGES`: GPay, PhonePe, Paytm, BHIM, CRED, Amazon Pay, Samsung Pay, HDFC, ICICI, SBI YONO, Axis, Kotak 811, etc.).
  - Runs a fast regex pre-filter for Indian currency tokens (`Rs`, `INR`, `₹`) before enqueueing.
  - Rebinds automatically on disconnection via `requestRebind(ComponentName(...))`.
- **Thread-Safe Native Queue (`AutoCaptureQueue.kt`)**:
  - Bounded JSON queue (up to 500 entries) in app-private storage (`autocapture_queue.json`).
  - Thread-safe synchronized locks with atomic staging file rename on drain to avoid race conditions and data loss.
- **Platform Channel (`AutoCapturePlugin.kt` & `NotificationCaptureService.dart`)**:
  - Communicates via `MethodChannel("io.fynza.app/auto_capture")`.
  - Exposes `drainQueue`, `isNotificationListenerGranted`, and `openNotificationListenerSettings`.
  - Periodically drained via `Workmanager` (`auto_capture_periodic_drain`) and catch-up drained on app launch in `MainScaffold`.
- **Pure Dart Parser (`SmsTransactionParser.dart` & `ParserRules.dart`)**:
  - Extracts amount directly to integer cents with exact arithmetic (zero floating-point math).
  - Determines transaction type (`expense`/`income`), counterparty/merchant, account last 4, reference number.
  - Supports both SMS formats and modern UPI app notification structures (e.g. `"Paid ₹150 to Swiggy using HDFC Bank •••• 1234"`).
  - Evaluates confidence score (`high`, `medium`, `low`).
  - Uses whole-word transaction markers (so `paid` does not match `prepaid`), rejects known recharge/data-plan promotions, and requires a payment completion marker for recharge confirmations.
  - Rejects OTPs, balance queries, promotional spam, and loan offers. If every amount in a message is identified as a balance/limit, it does not fall back to those amounts as transaction values.
- **Cross-Source Deduplication & Duplicate Prevention (`CaptureDedupe.dart`, `CaptureDao.dart`, `CaptureRepository.dart`)**:
  - **Strong-identity deduplication**: If a parsed transaction reference exists, its key also includes amount, type, and account suffix, preventing a reused/misparsed reference from suppressing a materially different payment. Reference matching also recognizes compatible older capture rows. Without a reference, deduplication uses the exact source event identity and message, not amount/time similarity.
  - **Shopkeeper-safe review**: Same-amount transactions are never flagged or grouped based on a time window. Every distinct capture remains a separate inbox card and can be added/dismissed independently; this avoids dropping legitimate repeated sales. Action rows wrap on narrow screens to avoid pixel overflow.
  - **Repeated Notifications section**: Pending captures with the same transaction reference, amount, direction, and compatible account suffix are represented once with a repeat count and shown in a restrained inbox section with a single Add action. Similar-looking transactions and different references remain separate.
  - **App Alerts (`lib/shared/providers/app_alert_provider.dart`, `lib/shared/widgets/app_alert_host.dart`)**: Bottom alerts are collected in a shared `Updates` section over the app rather than separate snackbars. Undoable alerts keep their action button; informational, success, and error alerts can be dismissed individually or cleared together.
- **Database & DAO (`captured_transactions_table.dart`, `counterparty_rules_table.dart`, `capture_dao.dart`)**:
  - Drift schema v5 with migrations preserving existing data, including legacy category palette colors and a default-zero duplicate notification count for strong-reference matches.
  - Stores status (`pending`, `confirmed`, `dismissed`) and nullable foreign key `transaction_id`.
  - Includes auto-purge for dismissed/confirmed captures older than 90 days.
- **Capture Modes & Master Toggle**:
  - Master switch OFF by default (opt-in privacy). Controlled via `autoCaptureEnabledProvider`.
  - Modes: `reviewFirst` (default) and `addAutomatically`.
- **Auto-Capture Reliability**:
  - The periodic Workmanager drain is registered at app startup after Workmanager initialization and dispatched using the worker's task type (`auto_capture_periodic`).
  - Background and foreground drains leave the native queue untouched while the master switch is off; Android and Dart both default the switch to OFF.
  - The native listener records whether a notification came from the device's default SMS app, allowing valid notifications from unlisted SMS packages through the Dart source gate.
  - Automatic transaction creation checks the dedupe key and inserts the transaction and capture record in one database transaction, preventing replayed notifications from creating duplicate transactions.
  - Capture review opens the transaction form prefilled with the parsed income/expense type; category options are filtered by that type, switching types clears the previous category, and mismatched remembered or submitted categories are rejected.
  - Per-notification ingestion and queue/scheduler failures emit diagnostics without logging captured message text.

## Application Branding & Package Information

- **App Name & Brand**: **Fynza** (root widget: `FynzaApp`).
- **Dart Package Name**: `fynza` in `pubspec.yaml` (all internal imports use `package:fynza/...`).
- **Android Application ID & Namespace**: `io.fynza.app` (backup storage path: `/Android/data/io.fynza.app/files/backups`).
- **iOS & Desktop Bundle IDs**: `io.fynza.app`.

## Android Configuration & Dependencies

- `applicationId = "io.fynza.app"` and `namespace = "io.fynza.app"`.
- `android:label = "Fynza"` in AndroidManifest.xml.
- `workmanager: ^0.10.0` (required for Flutter v2 embedding / Flutter 3.29+ compatibility).
- Root `android/build.gradle.kts` overrides subproject `compileSdk = 36` in an `afterEvaluate` hook to satisfy plugin requirements.
- Native build verified with `flutter build apk --debug`.

## CI/CD Workflow

- Continuous Integration configured via `.github/workflows/ci.yml`.
- Triggers on push and pull requests to `main` and `master`.
- Automated steps:
  1. Sets up Java 17 and pins Flutter to 3.44.4 to keep CI analyzer behavior reproducible.
  2. Generates Drift code with `build_runner`.
  3. Runs `flutter analyze --fatal-infos` and the complete `flutter test` suite.
  4. Builds a release APK and uploads the `fynza-release-apk` artifact.

## Architecture & Rule Compliance

- **Pattern**: Strict Feature-First MVVM (`View → ViewModel → Repository → Service`).
- **Layer Boundary Guarantee**: Zero views import or communicate with repositories, DAOs, or database classes directly (with cross-feature coordination managed via app-level composition). Views talk exclusively to their ViewModels.
- **Cross-Feature Boundaries**: Screen routes are centralized in `AppRouteFactory`; shared read models are composed in app-level repositories using domain contracts.
- **Presentation Dependencies**: View models use repository contracts for capture controls, backup workflows, currency, and transaction-entry coordination; no direct platform/service imports were found in view-model files.
- **Shared UI/Data**: `Category` and `TransactionTile` are shared; no cross-feature presentation imports or direct color literals were found in feature presentation.
- **Offline-First Guarantee**: 100% offline-first operation. Zero internet permissions in `android/app/src/main/AndroidManifest.xml`.
- **Data Integrity**: All money values are strictly integer cents (`int`), with zero floating-point conversions.
- **Drift Database**: Schema v5 with `MigrationStrategy(onUpgrade: ...)` preserving existing data and migrating already-saved legacy category palette colors; DAOs are feature-scoped; all UI data binding uses reactive `.watch()` streams.
- **Material 3 UI**:
  - Centralized warm amber-seeded light/dark schemes via `AppTheme`, using bundled Google Sans typography.
  - Shared controls use Material components and theme roles; decorative blur, press-scale effects, and custom segmented/progress animations have been removed. The intentional vertical scroll edge fade is handled by `FadingScrollBoundary`.
  - AppBars remain visually stable while scrolling because scrolled-under elevation is disabled and surface tinting is transparent in both themes.
  - Navigation adapts between `NavigationBar` and `NavigationRail` at 600dp.
- **Dashboard & Navigation**:
  - Compact navigation uses Dashboard, Transactions, Stats, and Settings; wider layouts use a `NavigationRail` with the same destination order.
  - Responsive quick-access cards link to Budgets and Categories.
  - Arrow directions: Expense = Upward (`arrow_upward_rounded`), Income = Downward (`arrow_downward_rounded`).
- **Testing**:
  - Unit and widget tests cover models, DAOs, view models, UI flows, statistics aggregation and populated charts, and Stats navigation in both compact and expanded layouts.
  - `widget_test.dart` uses `tester.ensureVisible(...)` for offscreen scrollable elements and silences Drift multi-instance warnings in tests.

## Build & Test Commands

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze --fatal-infos
flutter test
flutter build apk --release
```

*Status: `flutter analyze --fatal-infos` and the full `flutter test` suite pass; `flutter build apk --debug` succeeds after the Stats screen and charts were added.*
