package com.zhiquxy.rice

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager
import android.util.Log

class ClassAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("ClassSchedule", "AlarmReceiver triggered with action: \${intent.action}")

        // Handle reboot to reschedule alarms
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || intent.action == "android.intent.action.MY_PACKAGE_REPLACED") {
            ClassScheduleManager.scheduleNextAlarm(context)
            return
        }

        val classes = ClassScheduleManager.getSchedule(context)
        val now = System.currentTimeMillis()
        Log.d("ClassSchedule", "Processing \${classes.size} classes to find active one at time \$now")
        
        var activeClass: ClassItem? = null
        
        // Find the active class right now. Allow a small time tolerance.
        for (c in classes) {
            val prepTime = c.startTimeMs - 10 * 60_000L
            if (now in (prepTime - 2000)..c.endTimeMs) {
                activeClass = c
                break
            }
        }
        
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "RiceApp::ClassNotificationWakeLock")
        
        // Acquire wake lock for 10 seconds to ensure enough time for CPU to run
        wakeLock.acquire(10 * 1000L)

        try {
            if (activeClass != null) {
                Log.d("ClassSchedule", "Found active class: \${activeClass.className}. Showing notification.")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    NotificationHelper.showClassNotification(
                        context, 
                        activeClass.className, 
                        activeClass.location, 
                        activeClass.startTimeMs, 
                        activeClass.endTimeMs
                    )
                }
            } else {
                // Check if we just finished a class
                val recentlyFinished = classes.firstOrNull { now - it.endTimeMs in -2000..60_000L }
                if (recentlyFinished != null) {
                    Log.d("ClassSchedule", "Found recently finished class: \${recentlyFinished.className}. Showing finished state.")
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        NotificationHelper.showClassNotification(
                            context, 
                            recentlyFinished.className, 
                            recentlyFinished.location, 
                            recentlyFinished.startTimeMs, 
                            recentlyFinished.endTimeMs
                        )
                    }
                } else {
                    // No active classes
                    Log.d("ClassSchedule", "No active classes right now. Canceling notification.")
                    NotificationHelper.cancelNotification(context)
                }
            }
            
            // Always set the next alarm to keep the chain alive
            ClassScheduleManager.scheduleNextAlarm(context)
        } finally {
            if (wakeLock.isHeld) {
                wakeLock.release()
            }
        }
    }
}
