import type { HybridObject } from 'react-native-nitro-modules';

export type Orientation =
  | 'portrait'
  | 'portrait-upside-down'
  | 'landscape-left'
  | 'landscape-right'
  | 'landscape'
  | 'all';

export interface OrientationLocker
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  /**
   * True when the device's smallest width is >= 600dp (Android)
   * or the user-interface idiom is .pad (iOS / visionOS).
   */
  readonly isTablet: boolean;

  /**
   * The current effective orientation of the interface.
   */
  readonly currentOrientation: Orientation;

  /**
   * Force a given orientation. Subsequent calls override the previous lock.
   * On iOS 16+, this uses `requestGeometryUpdate`. On Android, it sets the
   * Activity's requested orientation. The lock persists until `releaseLock`
   * is called.
   */
  acquireLock(orientation: Orientation): void;

  /**
   * Release any active lock and return to the app's default supported
   * orientations.
   */
  releaseLock(): void;

  /**
   * Enable or disable automatic landscape lock for tablets / large-width
   * screens. When enabled and the device is a tablet, this acquires a
   * landscape lock immediately. When disabled, any tablet-driven lock is
   * released (manual locks set via `acquireLock` are untouched).
   */
  setLockTabletsToLandscape(enabled: boolean): void;
}
