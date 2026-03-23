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
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.color.ColorProvider
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver
import es.antonborri.home_widget.actionStartActivity

class FinanceWidgetProvider : HomeWidgetGlanceWidgetReceiver<FinanceWidget>() {
    override val glanceAppWidget = FinanceWidget()
}

class FinanceWidget : GlanceAppWidget() {
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            val prefs = currentState<HomeWidgetGlanceState>().preferences
            val expenseValue = prefs.getString("monthly_expense", "$0.00") ?: "$0.00"
            val balanceValue = prefs.getString("current_balance", "$0.00") ?: "$0.00"
            val comparisonValue = prefs.getString("monthly_comparison", "+0%") ?: "+0%"
            val isDarkMode = prefs.getBoolean("is_dark_mode", true)

            val emerald = Color(0xFF00C9A7)
            val white = Color.White

            // Colors based on app's dark mode preference
            val backgroundColor = if (isDarkMode) Color(0xFF0F172A) else Color.White
            val textPrimary = if (isDarkMode) Color.White else Color(0xFF0F172A)
            val textSecondary = if (isDarkMode) Color(0x88E8F5F1) else Color(0xFF64748B)
            val dividerColor = if (isDarkMode) Color(0x22FFFFFF) else Color(0x22000000)
            val balanceContainerColor = if (isDarkMode) Color(0x11FFFFFF) else Color(0x08000000)

            val bgProvider = ColorProvider(day = backgroundColor, night = backgroundColor)
            val textPrimaryProvider = ColorProvider(day = textPrimary, night = textPrimary)
            val textSecondaryProvider = ColorProvider(day = textSecondary, night = textSecondary)
            val dividerProvider = ColorProvider(day = dividerColor, night = dividerColor)
            val balanceContainerProvider = ColorProvider(day = balanceContainerColor, night = balanceContainerColor)

            Column(
                modifier = GlanceModifier.fillMaxSize()
                    .background(bgProvider)
                    .cornerRadius(16.dp)
                    .padding(16.dp)
                    .clickable(actionStartActivity<MainActivity>(
                        context,
                        Uri.parse("walletwise://analysis")
                    ))
            ) {
                // Header
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    verticalAlignment = Alignment.Vertical.CenterVertically
                ) {
                    Text(
                        text = "Resumen",
                        style = TextStyle(
                            color = ColorProvider(day = emerald, night = emerald),
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold
                        )
                    )
                    Spacer(modifier = GlanceModifier.defaultWeight())
                    Row(
                        modifier = GlanceModifier
                            .background(emerald)
                            .cornerRadius(8.dp)
                            .padding(horizontal = 6.dp, vertical = 2.dp)
                    ) {
                        Text(
                            text = comparisonValue,
                            style = TextStyle(
                                color = ColorProvider(day = white, night = white),
                                fontSize = 10.sp,
                                fontWeight = FontWeight.Bold
                            )
                        )
                    }
                }

                Spacer(modifier = GlanceModifier.height(10.dp))
                
                // Divider
                Column(
                    modifier = GlanceModifier.fillMaxWidth().height(1.dp).background(dividerProvider)
                ) {}
                
                Spacer(modifier = GlanceModifier.height(12.dp))

                // Spending
                Text(
                    text = "Gasto Mensual",
                    style = TextStyle(
                        color = textSecondaryProvider,
                        fontSize = 11.sp
                    )
                )

                Text(
                    text = expenseValue,
                    style = TextStyle(
                        color = textPrimaryProvider,
                        fontSize = 22.sp,
                        fontWeight = FontWeight.Bold
                    ),
                    modifier = GlanceModifier.padding(top = 2.dp)
                )

                Spacer(modifier = GlanceModifier.defaultWeight())

                // Balance Section
                Column(
                    modifier = GlanceModifier.fillMaxWidth()
                        .background(balanceContainerProvider)
                        .cornerRadius(8.dp)
                        .padding(8.dp)
                ) {
                    Text(
                        text = "Saldo Total",
                        style = TextStyle(
                            color = ColorProvider(day = emerald, night = emerald),
                            fontSize = 10.sp,
                            fontWeight = FontWeight.Bold
                        )
                    )
                    Text(
                        text = balanceValue,
                        style = TextStyle(
                            color = textPrimaryProvider,
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold
                        )
                    )
                }
            }
        }
    }
}
