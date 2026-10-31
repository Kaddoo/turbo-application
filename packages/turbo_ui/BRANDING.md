# Applying a new brand guide

A brand guide that changes colours, typeface, corner radius, logo, icon set or the product name is a small change here. Everything raw lives in `lib/src/brand/brand_tokens.dart`; components only read semantic roles through `context.turbo`.

## Five steps

1. **Edit `lib/src/brand/brand_tokens.dart`.** Change `turboBrand`: `appName`, `wordmark`, `brandBlack`, `brandNeon`, both palettes (`dark` and `light`), `fontFamily`, `radiusCard`, `radiusInput`, `radiusFull`, the `typeScale`, and the support strings. Keep the roles in the table in `prompts/00-shared-rules.md`.
2. **Replace the logo and icon assets.** Point `logoAsset` and `iconAsset` at the new files in the package `assets/` folder and update `pubspec.yaml` assets.
3. **Regenerate launcher icons and splash** in each app with `flutter_launcher_icons` and `flutter_native_splash`. Also update the display names, which are native config: `CFBundleDisplayName` in each `ios/Runner/Info.plist` and `android:label` in each `AndroidManifest.xml`. Bundle ids do not change.
4. **Set the font in `pubspec.yaml`** (the `fonts:` section) so it matches `fontFamily`.
5. **Run the tests and review the pictures.** `flutter test` in `packages/turbo_ui` must pass: the contrast test checks every text and control pair, and the hard-coded style test checks nothing slipped past the theme. Then review the golden diffs in `test/golden/` and accept them with `flutter test --update-goldens` once they look right.

## What the contrast test enforces

- Text, `accentText` and status colours reach 4.5:1 on background, surface and surfaceRaised.
- `onAccent` on `accent`, and the danger fill text, reach 4.5:1.
- `controlBorder` and `focusRing` reach 3:1.
- If the accent fill is under 3:1 against the page (neon on white), `accentBorder` must reach 3:1. That is why a neon button gets a black edge in light mode and why `accentText` is black there.

## What a rebrand cannot absorb

These are redesign work, not a token edit:

- Layout and spacing rhythm, and navigation structure.
- Icon style. The apps use one outline icon set from Material; a different style means replacing icons at call sites.
- Motion language. `TurboMotion` holds durations and curves, but a different feel means rethinking transitions.
- Anything that needs new components, such as a new card shape.

## Rules that keep this cheap

- No colour literal, font size, radius or product-name string in screens or components. `test/hardcoded_style_test.dart` fails the build if one appears.
- User-visible text comes from ARB strings, using `{appName}` where the product is named.
- `test/fixtures/alt_brand.dart` is a second brand. If a widget needs special code to look right with it, the widget is wrong.
