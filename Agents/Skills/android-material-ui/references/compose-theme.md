# Compose theme templates

Copy each block into its own file under `ui/theme/`. Change the `package` line to your app's package. Replace the placeholder colors with a scheme generated from your brand seed (Material Theme Builder).

## Contents
- Color.kt : Colors (light + dark schemes)
- Type.kt : Typography (Roboto, M3 type scale)
- Shape.kt : Shapes
- Dimens.kt : Spacing tokens
- Theme.kt : Theme wrapper (AppTheme)

---

## Color.kt: Colors (light + dark schemes)

```kotlin
package com.example.app.ui.theme

import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.ui.graphics.Color

/*
 * PLACEHOLDER: Material 3 baseline scheme (seed #6750A4).
 * Replace with a scheme generated from the brand seed colour using
 * Material Theme Builder (material-foundation.github.io/material-theme-builder)
 * and paste its exported Color.kt values here. Do not hand-pick individual roles.
 */

// ---- Light ----
private val LightPrimary = Color(0xFF6750A4)
private val LightOnPrimary = Color(0xFFFFFFFF)
private val LightPrimaryContainer = Color(0xFFEADDFF)
private val LightOnPrimaryContainer = Color(0xFF21005D)
private val LightSecondary = Color(0xFF625B71)
private val LightOnSecondary = Color(0xFFFFFFFF)
private val LightSecondaryContainer = Color(0xFFE8DEF8)
private val LightOnSecondaryContainer = Color(0xFF1D192B)
private val LightTertiary = Color(0xFF7D5260)
private val LightOnTertiary = Color(0xFFFFFFFF)
private val LightTertiaryContainer = Color(0xFFFFD8E4)
private val LightOnTertiaryContainer = Color(0xFF31111D)
private val LightError = Color(0xFFB3261E)
private val LightOnError = Color(0xFFFFFFFF)
private val LightErrorContainer = Color(0xFFF9DEDC)
private val LightOnErrorContainer = Color(0xFF410E0B)
private val LightSurface = Color(0xFFFEF7FF)
private val LightOnSurface = Color(0xFF1D1B20)
private val LightSurfaceVariant = Color(0xFFE7E0EC)
private val LightOnSurfaceVariant = Color(0xFF49454F)
private val LightOutline = Color(0xFF79747E)
private val LightOutlineVariant = Color(0xFFCAC4D0)
private val LightInverseSurface = Color(0xFF322F35)
private val LightInverseOnSurface = Color(0xFFF5EFF7)
private val LightInversePrimary = Color(0xFFD0BCFF)
private val LightSurfaceDim = Color(0xFFDED8E1)
private val LightSurfaceBright = Color(0xFFFEF7FF)
private val LightSurfaceContainerLowest = Color(0xFFFFFFFF)
private val LightSurfaceContainerLow = Color(0xFFF7F2FA)
private val LightSurfaceContainer = Color(0xFFF3EDF7)
private val LightSurfaceContainerHigh = Color(0xFFECE6F0)
private val LightSurfaceContainerHighest = Color(0xFFE6E0E9)

// ---- Dark ----
private val DarkPrimary = Color(0xFFD0BCFF)
private val DarkOnPrimary = Color(0xFF381E72)
private val DarkPrimaryContainer = Color(0xFF4F378B)
private val DarkOnPrimaryContainer = Color(0xFFEADDFF)
private val DarkSecondary = Color(0xFFCCC2DC)
private val DarkOnSecondary = Color(0xFF332D41)
private val DarkSecondaryContainer = Color(0xFF4A4458)
private val DarkOnSecondaryContainer = Color(0xFFE8DEF8)
private val DarkTertiary = Color(0xFFEFB8C8)
private val DarkOnTertiary = Color(0xFF492532)
private val DarkTertiaryContainer = Color(0xFF633B48)
private val DarkOnTertiaryContainer = Color(0xFFFFD8E4)
private val DarkError = Color(0xFFF2B8B5)
private val DarkOnError = Color(0xFF601410)
private val DarkErrorContainer = Color(0xFF8C1D18)
private val DarkOnErrorContainer = Color(0xFFF9DEDC)
private val DarkSurface = Color(0xFF141218)
private val DarkOnSurface = Color(0xFFE6E0E9)
private val DarkSurfaceVariant = Color(0xFF49454F)
private val DarkOnSurfaceVariant = Color(0xFFCAC4D0)
private val DarkOutline = Color(0xFF938F99)
private val DarkOutlineVariant = Color(0xFF49454F)
private val DarkInverseSurface = Color(0xFFE6E0E9)
private val DarkInverseOnSurface = Color(0xFF322F35)
private val DarkInversePrimary = Color(0xFF6750A4)
private val DarkSurfaceDim = Color(0xFF141218)
private val DarkSurfaceBright = Color(0xFF3B383E)
private val DarkSurfaceContainerLowest = Color(0xFF0F0D13)
private val DarkSurfaceContainerLow = Color(0xFF1D1B20)
private val DarkSurfaceContainer = Color(0xFF211F26)
private val DarkSurfaceContainerHigh = Color(0xFF2B2930)
private val DarkSurfaceContainerHighest = Color(0xFF36343B)

val LightColorScheme = lightColorScheme(
    primary = LightPrimary,
    onPrimary = LightOnPrimary,
    primaryContainer = LightPrimaryContainer,
    onPrimaryContainer = LightOnPrimaryContainer,
    secondary = LightSecondary,
    onSecondary = LightOnSecondary,
    secondaryContainer = LightSecondaryContainer,
    onSecondaryContainer = LightOnSecondaryContainer,
    tertiary = LightTertiary,
    onTertiary = LightOnTertiary,
    tertiaryContainer = LightTertiaryContainer,
    onTertiaryContainer = LightOnTertiaryContainer,
    error = LightError,
    onError = LightOnError,
    errorContainer = LightErrorContainer,
    onErrorContainer = LightOnErrorContainer,
    background = LightSurface,
    onBackground = LightOnSurface,
    surface = LightSurface,
    onSurface = LightOnSurface,
    surfaceVariant = LightSurfaceVariant,
    onSurfaceVariant = LightOnSurfaceVariant,
    outline = LightOutline,
    outlineVariant = LightOutlineVariant,
    inverseSurface = LightInverseSurface,
    inverseOnSurface = LightInverseOnSurface,
    inversePrimary = LightInversePrimary,
    surfaceDim = LightSurfaceDim,
    surfaceBright = LightSurfaceBright,
    surfaceContainerLowest = LightSurfaceContainerLowest,
    surfaceContainerLow = LightSurfaceContainerLow,
    surfaceContainer = LightSurfaceContainer,
    surfaceContainerHigh = LightSurfaceContainerHigh,
    surfaceContainerHighest = LightSurfaceContainerHighest,
)

val DarkColorScheme = darkColorScheme(
    primary = DarkPrimary,
    onPrimary = DarkOnPrimary,
    primaryContainer = DarkPrimaryContainer,
    onPrimaryContainer = DarkOnPrimaryContainer,
    secondary = DarkSecondary,
    onSecondary = DarkOnSecondary,
    secondaryContainer = DarkSecondaryContainer,
    onSecondaryContainer = DarkOnSecondaryContainer,
    tertiary = DarkTertiary,
    onTertiary = DarkOnTertiary,
    tertiaryContainer = DarkTertiaryContainer,
    onTertiaryContainer = DarkOnTertiaryContainer,
    error = DarkError,
    onError = DarkOnError,
    errorContainer = DarkErrorContainer,
    onErrorContainer = DarkOnErrorContainer,
    background = DarkSurface,
    onBackground = DarkOnSurface,
    surface = DarkSurface,
    onSurface = DarkOnSurface,
    surfaceVariant = DarkSurfaceVariant,
    onSurfaceVariant = DarkOnSurfaceVariant,
    outline = DarkOutline,
    outlineVariant = DarkOutlineVariant,
    inverseSurface = DarkInverseSurface,
    inverseOnSurface = DarkInverseOnSurface,
    inversePrimary = DarkInversePrimary,
    surfaceDim = DarkSurfaceDim,
    surfaceBright = DarkSurfaceBright,
    surfaceContainerLowest = DarkSurfaceContainerLowest,
    surfaceContainerLow = DarkSurfaceContainerLow,
    surfaceContainer = DarkSurfaceContainer,
    surfaceContainerHigh = DarkSurfaceContainerHigh,
    surfaceContainerHighest = DarkSurfaceContainerHighest,
)
```

## Type.kt: Typography (Roboto, M3 type scale)

```kotlin
package com.example.app.ui.theme

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

/*
 * Font: Roboto. It is the Android system typeface and the face the Material 3
 * type scale is tuned for, so FontFamily.Default gives Roboto on Android with
 * zero APK cost.
 *
 * Optional upgrade: Roboto Flex (variable font) via Google Fonts downloadable fonts.
 * Requires: implementation("androidx.compose.ui:ui-text-google-fonts")
 * and res/values/font_certs.xml from the Android docs.
 *
 *   private val provider = GoogleFont.Provider(
 *       providerAuthority = "com.google.android.gms.fonts",
 *       providerPackage = "com.google.android.gms",
 *       certificates = R.array.com_google_android_gms_fonts_certs,
 *   )
 *   private val robotoFlex = GoogleFont("Roboto Flex")
 *   val AppFontFamily = FontFamily(
 *       Font(googleFont = robotoFlex, fontProvider = provider, weight = FontWeight.Normal),
 *       Font(googleFont = robotoFlex, fontProvider = provider, weight = FontWeight.Medium),
 *   )
 *
 * Always bundle a fallback (FontFamily.Default) for offline first launch.
 */
val AppFontFamily: FontFamily = FontFamily.Default

// Values follow the Material 3 type scale. Letter spacing is in sp.
val AppTypography = Typography(
    displayLarge = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Normal, fontSize = 57.sp, lineHeight = 64.sp, letterSpacing = (-0.25).sp),
    displayMedium = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Normal, fontSize = 45.sp, lineHeight = 52.sp, letterSpacing = 0.sp),
    displaySmall = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Normal, fontSize = 36.sp, lineHeight = 44.sp, letterSpacing = 0.sp),
    headlineLarge = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Normal, fontSize = 32.sp, lineHeight = 40.sp, letterSpacing = 0.sp),
    headlineMedium = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Normal, fontSize = 28.sp, lineHeight = 36.sp, letterSpacing = 0.sp),
    headlineSmall = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Normal, fontSize = 24.sp, lineHeight = 32.sp, letterSpacing = 0.sp),
    titleLarge = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Normal, fontSize = 22.sp, lineHeight = 28.sp, letterSpacing = 0.sp),
    titleMedium = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Medium, fontSize = 16.sp, lineHeight = 24.sp, letterSpacing = 0.15.sp),
    titleSmall = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Medium, fontSize = 14.sp, lineHeight = 20.sp, letterSpacing = 0.1.sp),
    bodyLarge = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Normal, fontSize = 16.sp, lineHeight = 24.sp, letterSpacing = 0.5.sp),
    bodyMedium = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Normal, fontSize = 14.sp, lineHeight = 20.sp, letterSpacing = 0.25.sp),
    bodySmall = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Normal, fontSize = 12.sp, lineHeight = 16.sp, letterSpacing = 0.4.sp),
    labelLarge = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Medium, fontSize = 14.sp, lineHeight = 20.sp, letterSpacing = 0.1.sp),
    labelMedium = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Medium, fontSize = 12.sp, lineHeight = 16.sp, letterSpacing = 0.5.sp),
    labelSmall = TextStyle(fontFamily = AppFontFamily, fontWeight = FontWeight.Medium, fontSize = 11.sp, lineHeight = 16.sp, letterSpacing = 0.5.sp),
)
```

## Shape.kt: Shapes

```kotlin
package com.example.app.ui.theme

import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Shapes
import androidx.compose.ui.unit.dp

// Material 3 shape scale. Components pick from these automatically:
// cards = medium, FAB = large, dialogs/sheets = extraLarge, chips = small.
val AppShapes = Shapes(
    extraSmall = RoundedCornerShape(4.dp),
    small = RoundedCornerShape(8.dp),
    medium = RoundedCornerShape(12.dp),
    large = RoundedCornerShape(16.dp),
    extraLarge = RoundedCornerShape(28.dp),
)
```

## Dimens.kt: Spacing tokens

```kotlin
package com.example.app.ui.theme

import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/** 4dp-based spacing tokens. Use these instead of raw dp values in screens. */
data class Spacing(
    val xxs: Dp = 4.dp,
    val xs: Dp = 8.dp,      // gap between related items
    val sm: Dp = 12.dp,
    val md: Dp = 16.dp,     // screen margin (compact), card padding
    val lg: Dp = 24.dp,     // gap between sections, screen margin (medium+)
    val xl: Dp = 32.dp,
    val xxl: Dp = 48.dp,
    val xxxl: Dp = 64.dp,
    val minTouchTarget: Dp = 48.dp,
    val fabClearance: Dp = 88.dp, // bottom content padding so the last item clears a FAB
)

val LocalSpacing = staticCompositionLocalOf { Spacing() }
```

## Theme.kt: Theme wrapper (AppTheme)

```kotlin
package com.example.app.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.platform.LocalContext

/**
 * Single entry point for app styling.
 *
 * - Call `enableEdgeToEdge()` in your Activity before `setContent`.
 * - Dynamic colour is optional; the branded scheme is the fallback (and the
 *   default for brand-critical apps: pass dynamicColor = false).
 * - Access spacing via `AppTheme.spacing` (see object below).
 */
@Composable
fun AppTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    dynamicColor: Boolean = false,
    content: @Composable () -> Unit,
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }

    CompositionLocalProvider(LocalSpacing provides Spacing()) {
        MaterialTheme(
            colorScheme = colorScheme,
            typography = AppTypography,
            shapes = AppShapes,
            content = content,
        )
    }
}

/** Convenience accessor: AppTheme.spacing.md */
object AppTheme {
    val spacing: Spacing
        @Composable get() = LocalSpacing.current
}
```

