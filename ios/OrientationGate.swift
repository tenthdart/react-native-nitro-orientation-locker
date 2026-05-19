import Foundation
import UIKit

/// Holds the currently-requested orientation mask so the host app's
/// `application(_:supportedInterfaceOrientationsFor:)` delegate (or a
/// `UIViewController` subclass) can honor it.
///
/// To wire it up in your host app's `AppDelegate.swift`:
///
/// ```swift
/// func application(
///   _ application: UIApplication,
///   supportedInterfaceOrientationsFor window: UIWindow?
/// ) -> UIInterfaceOrientationMask {
///   return OrientationGate.shared.supportedMask
/// }
/// ```
@objc public final class OrientationGate: NSObject {
  @objc public static let shared = OrientationGate()
  @objc public var supportedMask: UIInterfaceOrientationMask = .all
  private override init() {}
}
