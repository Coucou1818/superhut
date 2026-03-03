package com.zhiquxy.rice

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import org.json.JSONArray

import android.util.Log

object ClassScheduleManager {
    private const val PREFS_NAME = "class_schedule_prefs"
    private const val KEY_SCHEDULE = "schedule_json"

    fun saveSchedule(context: Context, scheduleJson: String) {
        val prefs: SharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().putString(KEY_SCHEDULE, scheduleJson).apply()
        Log.d("ClassSchedule", "Schedule saved. Length: \${scheduleJson.length} characters.")
        
        // Immediately check the current state (to trigger the notification right away if needed)
        val intent = Intent(context, ClassAlarmReceiver::class.java).apply {
            action = "com.zhiquxy.rice.ACTION_SYNC_IMMEDIATE"
        }
        context.sendBroadcast(intent)
        
        scheduleNextAlarm(context)
    }

    fun getSchedule(context: Context): List<ClassItem> {
        val prefs: SharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val jsonString = prefs.getString(KEY_SCHEDULE, "[]") ?: "[]"
        val list = mutableListOf<ClassItem>()
        try {
            val array = JSONArray(jsonString)
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                list.add(
                    ClassItem(
                        obj.getString("className"),
                        obj.getString("location"),
                        obj.getLong("startTimeMs"),
                        obj.getLong("endTimeMs")
                    )
                )
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return list
    }

    fun scheduleNextAlarm(context: Context) {
        val classes = getSchedule(context)
        val now = System.currentTimeMillis()
        
        var nextAlarmTime = Long.MAX_VALUE
        
        for (c in classes) {
            val prepTime = c.startTimeMs - 10 * 60_000L
            
            // We want the earliest event that is strictly in the future
            if (prepTime > now && prepTime < nextAlarmTime) nextAlarmTime = prepTime
            if (c.startTimeMs > now && c.startTimeMs < nextAlarmTime) nextAlarmTime = c.startTimeMs
            if (c.endTimeMs > now && c.endTimeMs < nextAlarmTime) nextAlarmTime = c.endTimeMs
        }
        
        if (nextAlarmTime == Long.MAX_VALUE) {
            Log.d("ClassSchedule", "No future class bounds found. No alarm scheduled.")
            return // No upcoming alarms found
        }

        Log.d("ClassSchedule", "Next alarm set at: \$nextAlarmTime, which is \${(nextAlarmTime - now) / 1000} seconds from now.")

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, ClassAlarmReceiver::class.java).apply {
            action = "com.zhiquxy.rice.ACTION_CLASS_ALARM"
        }
        
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Using setAlarmClock makes this 100% reliable on ALL systems (including MIUI, ColorOS, etc)
        // It bypasses Doze mode and background restrictions because it tells the OS this is a highly important user-facing alarm.
        try {
            val showIntent = PendingIntent.getActivity(
                context, 0, Intent(context, MainActivity::class.java),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            val info = AlarmManager.AlarmClockInfo(nextAlarmTime, showIntent)
            alarmManager.setAlarmClock(info, pendingIntent)
            Log.d("ClassSchedule", "Successfully scheduled AlarmClock API at \$nextAlarmTime")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}

data class ClassItem(
    val className: String,
    val location: String,
    val startTimeMs: Long,
    val endTimeMs: Long
)
