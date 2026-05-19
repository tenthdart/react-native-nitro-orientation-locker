package com.margelo.nitro.orientationlocker

import android.app.Activity
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.view.Surface
import com.facebook.proguard.annotations.DoNotStrip
import com.margelo.nitro.NitroModules

@DoNotStrip
class HybridOrientationLocker : HybridOrientationLockerSpec() {

  private var lockTabletsToLandscape = false
  private var manualLock: String? = null

  override val isTablet: Boolean
    get() {
      val context = NitroModules.applicationContext ?: return false
      return context.resources.configuration.smallestScreenWidthDp >= 600
    }

  override val currentOrientation: String
    get() {
      val activity = NitroModules.applicationContext?.currentActivity ?: return "portrait"
      val rotation = activity.windowManager.defaultDisplay.rotation
      val orientation = activity.resources.configuration.orientation
      return when (orientation) {
        Configuration.ORIENTATION_LANDSCAPE -> when (rotation) {
          Surface.ROTATION_270 -> "landscape-right"
          else -> "landscape-left"
        }
        Configuration.ORIENTATION_PORTRAIT -> when (rotation) {
          Surface.ROTATION_180 -> "portrait-upside-down"
          else -> "portrait"
        }
        else -> "portrait"
      }
    }

  override fun acquireLock(orientation: String) {
    manualLock = orientation
    apply()
  }

  override fun releaseLock() {
    manualLock = null
    if (lockTabletsToLandscape && isTablet) {
      apply()
    } else {
      restoreUnspecified()
    }
  }

  override fun setLockTabletsToLandscape(enabled: Boolean) {
    lockTabletsToLandscape = enabled
    when {
      enabled && isTablet && manualLock == null -> apply()
      !enabled && manualLock == null -> restoreUnspecified()
    }
  }

  // region Private

  private fun resolvedOrientation(): String {
    manualLock?.let { return it }
    if (lockTabletsToLandscape && isTablet) return "landscape"
    return "all"
  }

  private fun apply() {
    val target = resolvedOrientation()
    setActivityOrientation(activityInfoFor(target))
  }

  private fun restoreUnspecified() {
    setActivityOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED)
  }

  private fun activityInfoFor(orientation: String): Int = when (orientation) {
    "portrait" -> ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
    "portrait-upside-down" -> ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT
    "landscape-left" -> ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
    "landscape-right" -> ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE
    "landscape" -> ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
    "all" -> ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
    else -> ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
  }

  private fun setActivityOrientation(requested: Int) {
    val activity: Activity = NitroModules.applicationContext?.currentActivity ?: return
    activity.runOnUiThread {
      if (activity.requestedOrientation != requested) {
        activity.requestedOrientation = requested
      }
    }
  }

  // endregion
}
