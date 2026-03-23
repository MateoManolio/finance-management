package com.example.finance_management

import android.content.Context
import android.net.Uri
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.padding
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.color.ColorProvider
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver
import es.antonborri.home_widget.actionStartActivity

class QuickAddWidgetProvider : HomeWidgetGlanceWidgetReceiver<QuickAddWidget>() {
    override val glanceAppWidget = QuickAddWidget()
}

class QuickAddWidget : GlanceAppWidget() {
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            val prefs = currentState<HomeWidgetGlanceState>().preferences
            val isDarkMode = prefs.getBoolean("is_dark_mode", true)

            val emerald = Color(0xFF00C9A7)

            // Colors based on app's dark mode preference
            val backgroundColor = if (isDarkMode) Color(0xFF0F172A) else Color.White
            val textSecondary = if (isDarkMode) Color(0x99FFFFFF) else Color(0xFF64748B)

            val bgProvider = ColorProvider(day = backgroundColor, night = backgroundColor)
            val textSecondaryProvider = ColorProvider(day = textSecondary, night = textSecondary)

            Column(
                modifier = GlanceModifier.fillMaxSize()
                    .background(bgProvider)
                    .cornerRadius(16.dp)
                    .padding(12.dp),
                horizontalAlignment = Alignment.Horizontal.CenterHorizontally,
                verticalAlignment = Alignment.Vertical.CenterVertically
            ) {
                Text(
                    text = "Carga Rápida",
                    style = TextStyle(
                        color = ColorProvider(day = emerald, night = emerald),
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Bold
                    ),
                    modifier = GlanceModifier.padding(bottom = 8.dp)
                )

                Row(
                    modifier = GlanceModifier.fillMaxWidth()
                        .background(emerald)
                        .cornerRadius(20.dp)
                        .padding(10.dp)
                        .clickable(actionStartActivity<MainActivity>(
                            context,
                            Uri.parse("walletwise://quick_add")
                        )),
                    horizontalAlignment = Alignment.Horizontal.CenterHorizontally,
                    verticalAlignment = Alignment.Vertical.CenterVertically
                ) {
                    Text(
                        text = "＋ Nuevo Gasto",
                        style = TextStyle(
                            color = ColorProvider(day = Color.White, night = Color.White),
                            fontSize = 13.sp,
                            fontWeight = FontWeight.Bold
                        )
                    )
                }

                Text(
                    text = "Solo monto y categoría",
                    style = TextStyle(
                        color = textSecondaryProvider,
                        fontSize = 10.sp
                    ),
                    modifier = GlanceModifier.padding(top = 8.dp)
                )
            }
        }
    }
}
