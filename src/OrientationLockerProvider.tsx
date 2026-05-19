import React, { useEffect } from 'react';
import { OrientationLocker } from './index';

export interface OrientationLockerProviderProps {
  /**
   * When true, devices with `isTablet === true` (iPad / visionOS / Android
   * `smallestScreenWidthDp >= 600`) are locked to landscape automatically
   * while the provider is mounted. Phones are unaffected.
   */
  lockTabletsToLandscape?: boolean;
  children?: React.ReactNode;
}

export function OrientationLockerProvider({
  lockTabletsToLandscape = false,
  children,
}: OrientationLockerProviderProps): React.ReactElement {
  useEffect(() => {
    OrientationLocker.setLockTabletsToLandscape(lockTabletsToLandscape);
    return () => {
      OrientationLocker.setLockTabletsToLandscape(false);
    };
  }, [lockTabletsToLandscape]);

  return <>{children}</>;
}
