import { NitroModules } from 'react-native-nitro-modules';
import type {
  OrientationLocker as OrientationLockerSpec,
  Orientation,
} from './OrientationLocker.nitro';

export type { Orientation } from './OrientationLocker.nitro';

const OrientationLockerHybrid =
  NitroModules.createHybridObject<OrientationLockerSpec>('OrientationLocker');

export const OrientationLocker = {
  get isTablet(): boolean {
    return OrientationLockerHybrid.isTablet;
  },
  get currentOrientation(): Orientation {
    return OrientationLockerHybrid.currentOrientation;
  },
  acquireLock(orientation: Orientation): void {
    OrientationLockerHybrid.acquireLock(orientation);
  },
  releaseLock(): void {
    OrientationLockerHybrid.releaseLock();
  },
  setLockTabletsToLandscape(enabled: boolean): void {
    OrientationLockerHybrid.setLockTabletsToLandscape(enabled);
  },
};

export { OrientationLockerProvider } from './OrientationLockerProvider';
