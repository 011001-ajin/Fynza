# XML (Views) theme and usage notes

- Parent theme: `Theme.Material3.DayNight.NoActionBar` (Material Components 1.11+; surface container roles need 1.11 or newer).
- Provide `values/colors.xml` and `values-night/colors.xml` with the `md_*` colours exported from Material Theme Builder.
- Reference colours in layouts only through theme attributes: `?attr/colorSurface`, `?attr/colorOnSurfaceVariant`, `?attr/colorPrimaryContainer`.
- Text: `android:textAppearance="?attr/textAppearanceTitleMedium"` (and BodyMedium, LabelLarge, etc.). Never set `android:textSize` directly.
- Components and styles:
  - Filled button: `<com.google.android.material.button.MaterialButton style="@style/Widget.Material3.Button" />`
  - Tonal: `Widget.Material3.Button.TonalButton`; outlined: `Widget.Material3.Button.OutlinedButton`; text: `Widget.Material3.Button.TextButton`
  - Cards: `Widget.Material3.CardView.Filled | Elevated | Outlined` (one style per app)
  - Text fields: `Widget.Material3.TextInputLayout.OutlinedBox` (or `.FilledBox`)
  - App bars: `MaterialToolbar` inside `AppBarLayout` with `liftOnScroll`; collapsing: `Widget.Material3.CollapsingToolbar.Large`
  - Navigation: `BottomNavigationView` (renders the M3 navigation bar), `NavigationRailView`, `NavigationView` for drawers
- Spacing: define `dimens.xml` tokens (`space_xs=8dp`, `space_md=16dp`, `space_lg=24dp`) and use only those.
- Edge-to-edge: `WindowCompat.setDecorFitsSystemWindows(window, false)` / `enableEdgeToEdge()` and apply insets with `ViewCompat.setOnApplyWindowInsetsListener`.
- Dynamic colour: `DynamicColors.applyToActivitiesIfAvailable(application)` in `Application.onCreate()`.

## themes.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- res/values/themes.xml (light). Mirror in res/values-night/themes.xml with dark colours.
     Parent: DayNight picks light/dark automatically. Replace colour values from Material Theme Builder. -->
<resources xmlns:tools="http://schemas.android.com/tools">

    <style name="Base.Theme.App" parent="Theme.Material3.DayNight.NoActionBar">
        <!-- Colour roles -->
        <item name="colorPrimary">@color/md_primary</item>
        <item name="colorOnPrimary">@color/md_on_primary</item>
        <item name="colorPrimaryContainer">@color/md_primary_container</item>
        <item name="colorOnPrimaryContainer">@color/md_on_primary_container</item>
        <item name="colorSecondary">@color/md_secondary</item>
        <item name="colorOnSecondary">@color/md_on_secondary</item>
        <item name="colorSecondaryContainer">@color/md_secondary_container</item>
        <item name="colorOnSecondaryContainer">@color/md_on_secondary_container</item>
        <item name="colorTertiary">@color/md_tertiary</item>
        <item name="colorOnTertiary">@color/md_on_tertiary</item>
        <item name="colorTertiaryContainer">@color/md_tertiary_container</item>
        <item name="colorOnTertiaryContainer">@color/md_on_tertiary_container</item>
        <item name="colorError">@color/md_error</item>
        <item name="colorOnError">@color/md_on_error</item>
        <item name="colorErrorContainer">@color/md_error_container</item>
        <item name="colorOnErrorContainer">@color/md_on_error_container</item>
        <item name="android:colorBackground">@color/md_surface</item>
        <item name="colorSurface">@color/md_surface</item>
        <item name="colorOnSurface">@color/md_on_surface</item>
        <item name="colorSurfaceVariant">@color/md_surface_variant</item>
        <item name="colorOnSurfaceVariant">@color/md_on_surface_variant</item>
        <item name="colorOutline">@color/md_outline</item>
        <item name="colorOutlineVariant">@color/md_outline_variant</item>
        <item name="colorSurfaceContainerLowest">@color/md_surface_container_lowest</item>
        <item name="colorSurfaceContainerLow">@color/md_surface_container_low</item>
        <item name="colorSurfaceContainer">@color/md_surface_container</item>
        <item name="colorSurfaceContainerHigh">@color/md_surface_container_high</item>
        <item name="colorSurfaceContainerHighest">@color/md_surface_container_highest</item>

        <!-- Typography: Roboto (system default). Set android:fontFamily only if using Roboto Flex via res/font. -->
        <item name="textAppearanceDisplayLarge">@style/TextAppearance.Material3.DisplayLarge</item>
        <item name="textAppearanceBodyLarge">@style/TextAppearance.Material3.BodyLarge</item>

        <!-- Shape scale -->
        <item name="shapeAppearanceSmallComponent">@style/ShapeAppearance.Material3.SmallComponent</item>
        <item name="shapeAppearanceMediumComponent">@style/ShapeAppearance.Material3.MediumComponent</item>
        <item name="shapeAppearanceLargeComponent">@style/ShapeAppearance.Material3.LargeComponent</item>

        <!-- Edge-to-edge system bars (API 35+ is enforced; this keeps older versions consistent) -->
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:navigationBarColor">@android:color/transparent</item>
        <item name="android:enforceNavigationBarContrast" tools:targetApi="q">false</item>
    </style>

    <style name="Theme.App" parent="Base.Theme.App" />
</resources>
```
