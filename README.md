# @tenthdart/react-native-nitro-orientation-locker

High-performance orientation lock for React Native, built on
[Nitro Modules](https://nitro.margelo.com).

- **New Architecture only.** Old-arch is not supported.
- **iOS 16+ / visionOS 1.0+** — uses `requestGeometryUpdate`.
- **Android API 24+** — uses `Activity.setRequestedOrientation`.
- Auto-lock tablets and large-width screens to landscape with a single prop.
- Imperative `acquireLock` / `releaseLock` for everything else.

## Install

```sh
npm i @tenthdart/react-native-nitro-orientation-locker react-native-nitro-modules
cd ios && pod install
```

Make sure the **New Architecture** is enabled in your app
(`newArchEnabled=true` in `android/gradle.properties`,
`RCT_NEW_ARCH_ENABLED=1` for iOS).

### iOS host-app wiring

So that iOS actually honors the requested orientation, route the app's
supported-orientations delegate through `OrientationGate`:

```swift
// AppDelegate.swift
import NitroOrientationLocker

func application(
  _ application: UIApplication,
  supportedInterfaceOrientationsFor window: UIWindow?
) -> UIInterfaceOrientationMask {
  return OrientationGate.shared.supportedMask
}
```

### Android host-app wiring

Add `android:configChanges="orientation|screenSize|screenLayout|keyboardHidden"`
to your `MainActivity` in `AndroidManifest.xml` so React Native doesn't tear
down the JS context when orientation changes.

## Usage

### Auto-lock tablets to landscape

Wrap your app once. Phones are unaffected; tablets (iPad / visionOS or
Android `smallestScreenWidthDp >= 600`) are locked to landscape.

```tsx
import { OrientationLockerProvider } from '@tenthdart/react-native-nitro-orientation-locker';

export default function App() {
  return (
    <OrientationLockerProvider lockTabletsToLandscape>
      <RootNavigator />
    </OrientationLockerProvider>
  );
}
```

### Imperative API

```ts
import { OrientationLocker } from '@tenthdart/react-native-nitro-orientation-locker';

OrientationLocker.acquireLock('landscape');      // any landscape
OrientationLocker.acquireLock('landscape-left'); // pinned
OrientationLocker.acquireLock('portrait');
OrientationLocker.releaseLock();

OrientationLocker.isTablet;            // boolean
OrientationLocker.currentOrientation;  // 'portrait' | 'landscape-left' | ...
```

### Orientation values

| Value                   | iOS mask                          | Android                                          |
| ----------------------- | --------------------------------- | ------------------------------------------------ |
| `portrait`              | `.portrait`                       | `SCREEN_ORIENTATION_PORTRAIT`                    |
| `portrait-upside-down`  | `.portraitUpsideDown`             | `SCREEN_ORIENTATION_REVERSE_PORTRAIT`            |
| `landscape-left`        | `.landscapeLeft`                  | `SCREEN_ORIENTATION_LANDSCAPE`                   |
| `landscape-right`       | `.landscapeRight`                 | `SCREEN_ORIENTATION_REVERSE_LANDSCAPE`           |
| `landscape`             | `.landscape`                      | `SCREEN_ORIENTATION_SENSOR_LANDSCAPE`            |
| `all`                   | `.all`                            | `SCREEN_ORIENTATION_UNSPECIFIED`                 |

## How precedence works

`acquireLock` always wins. Releasing it falls back to the tablet-landscape
rule (if enabled and on a tablet); otherwise the app returns to its
default supported orientations.

## License

MIT
