import Foundation
import UIKit
import NitroModules

final class HybridOrientationLocker: HybridOrientationLockerSpec {
  private var lockTabletsToLandscape = false
  private var manualLock: String? = nil

  var isTablet: Bool {
    UIDevice.current.userInterfaceIdiom == .pad
  }

  var currentOrientation: String {
    switch effectiveDeviceOrientation() {
    case .portrait: return "portrait"
    case .portraitUpsideDown: return "portrait-upside-down"
    case .landscapeLeft: return "landscape-left"
    case .landscapeRight: return "landscape-right"
    default: return "portrait"
    }
  }

  func acquireLock(orientation: String) throws {
    manualLock = orientation
    apply()
  }

  func releaseLock() throws {
    manualLock = nil
    if !(lockTabletsToLandscape && isTablet) {
      restoreAllOrientations()
      return
    }
    apply()
  }

  func setLockTabletsToLandscape(enabled: Bool) throws {
    lockTabletsToLandscape = enabled
    if enabled && isTablet && manualLock == nil {
      apply()
    } else if !enabled && manualLock == nil {
      restoreAllOrientations()
    }
  }

  // MARK: - Private

  private func resolvedOrientation() -> String {
    if let manual = manualLock { return manual }
    if lockTabletsToLandscape && isTablet { return "landscape" }
    return "all"
  }

  private func apply() {
    let target = resolvedOrientation()
    let mask = mask(for: target)
    OrientationGate.shared.supportedMask = mask
    requestGeometryUpdate(mask: mask)
  }

  private func restoreAllOrientations() {
    OrientationGate.shared.supportedMask = .all
    requestGeometryUpdate(mask: .all)
  }

  private func mask(for orientation: String) -> UIInterfaceOrientationMask {
    switch orientation {
    case "portrait": return .portrait
    case "portrait-upside-down": return .portraitUpsideDown
    case "landscape-left": return .landscapeLeft
    case "landscape-right": return .landscapeRight
    case "landscape": return .landscape
    case "all": return .all
    default: return .all
    }
  }

  private func requestGeometryUpdate(mask: UIInterfaceOrientationMask) {
    DispatchQueue.main.async {
      guard
        let scene = UIApplication.shared.connectedScenes
          .compactMap({ $0 as? UIWindowScene })
          .first(where: { $0.activationState == .foregroundActive })
          ?? UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first
      else { return }

      let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(
        interfaceOrientations: mask
      )
      scene.requestGeometryUpdate(geometryPreferences) { _ in }

      scene.windows
        .compactMap { $0.rootViewController }
        .forEach { $0.setNeedsUpdateOfSupportedInterfaceOrientations() }
    }
  }

  private func effectiveDeviceOrientation() -> UIDeviceOrientation {
    let device = UIDevice.current.orientation
    if device.isValidInterfaceOrientation { return device }

    guard
      let scene = UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene })
        .first(where: { $0.activationState == .foregroundActive })
    else { return .portrait }

    switch scene.interfaceOrientation {
    case .portrait: return .portrait
    case .portraitUpsideDown: return .portraitUpsideDown
    case .landscapeLeft: return .landscapeLeft
    case .landscapeRight: return .landscapeRight
    default: return .portrait
    }
  }
}
