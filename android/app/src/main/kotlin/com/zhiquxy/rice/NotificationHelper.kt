package com.zhiquxy.rice

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationCompat.ProgressStyle

object NotificationHelper {

    const val CHANNEL_ID       = "class_live_update_channel"
    const val CHANNEL_NAME     = "课程实时提醒"
    const val NOTIFICATION_ID  = 1001

    fun createChannel(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val channel = NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT).apply {
                description = "课程开始与结束的实时提醒"
            }
            nm.createNotificationChannel(channel)
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun showClassNotification(
        context: Context,
        className: String,
        location: String,
        startTimeMs: Long,
        endTimeMs: Long
    ) {
        createChannel(context)
        val nm  = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val now = System.currentTimeMillis()

        // ── 1. Calculate progress (0-100 across the entire timeline)
        val prepWindowMs = (startTimeMs - (startTimeMs - 10 * 60_000L)).coerceAtLeast(1L)
        val classWindowMs = (endTimeMs - startTimeMs).coerceAtLeast(1L)

        val progress: Int
        val state: ClassState

        when {
            now < startTimeMs -> {
                val elapsed = (now - (startTimeMs - 10 * 60_000L)).coerceIn(0L, prepWindowMs)
                progress = (elapsed * 20 / prepWindowMs).toInt()
                state    = ClassState.PREPARING
            }
            now <= endTimeMs -> {
                val elapsed = (now - startTimeMs).coerceIn(0L, classWindowMs)
                progress = 20 + (elapsed * 80 / classWindowMs).toInt()
                state    = ClassState.ONGOING
            }
            else -> {
                progress = 100
                state    = ClassState.FINISHED
            }
        }

        val nodeColor = Color.valueOf(236f/255f, 183f/255f, 255f/255f, 1f).toArgb()
        val trackColor = Color.valueOf(134f/255f, 247f/255f, 250f/255f, 1f).toArgb()

        val baseStyle = ProgressStyle()
            .setProgressSegments(
                listOf(
                    ProgressStyle.Segment(20).setColor(trackColor),
                    ProgressStyle.Segment(80).setColor(trackColor),
                )
            )
            .setProgress(progress)

        val points = mutableListOf<ProgressStyle.Point>()
        if (state == ClassState.ONGOING || state == ClassState.FINISHED) {
            points.add(ProgressStyle.Point(20).setColor(nodeColor))
        }
        if (state == ClassState.FINISHED) {
            points.add(ProgressStyle.Point(100).setColor(nodeColor))
        }
        if (points.isNotEmpty()) {
            baseStyle.setProgressPoints(points)
        }

        val tapIntent = PendingIntent.getActivity(
            context, 0,
            Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
            },
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.launcher_icon)
            .setOngoing(true)
            .setRequestPromotedOngoing(true)
            .setContentIntent(tapIntent)
            .setCategory(NotificationCompat.CATEGORY_EVENT)

        when (state) {
            ClassState.PREPARING -> {
                builder
                    .setContentTitle("$className - $location")
                    .setContentText("前往教室：$location")
                    .setShortCriticalText("$location - $className")
                    .setWhen(startTimeMs)
                    .setUsesChronometer(true)
                    .setChronometerCountDown(true)
                    .setStyle(baseStyle)
            }
            ClassState.ONGOING -> {
                builder
                    .setContentTitle("正在上课：$className")
                    .setContentText("地点：$location")
                    .setShortCriticalText("上课中")
                    .setWhen(endTimeMs)
                    .setUsesChronometer(true)
                    .setChronometerCountDown(true)
                    .setStyle(baseStyle)
            }
            ClassState.FINISHED -> {
                builder
                    .setContentTitle("已下课：$className")
                    .setContentText("$location · 课程已结束")
                    .setShortCriticalText("已下课")
                    .setUsesChronometer(false)
                    .setStyle(baseStyle)
            }
        }

        nm.notify(NOTIFICATION_ID, builder.build())
    }

    fun cancelNotification(context: Context) {
        val nm  = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.cancel(NOTIFICATION_ID)
    }

    private enum class ClassState { PREPARING, ONGOING, FINISHED }
}
