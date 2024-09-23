//+------------------------------------------------------------------+
//|                                            positionCalculate.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window

//+------------------------------------------------------------------+
//| Input                                                            |
//+------------------------------------------------------------------+
input double moneyRisk = 100;    // Max loss for this trade
input double entryPrice = 2615.35; // Entry price
input double slPrice =  2557.96;  // Stop loss price

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   MqlTick last_tick;

   double symbolTickValue = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
   double symbolPoint = SymbolInfoDouble(_Symbol,SYMBOL_POINT);
   double slPoint = MathAbs(entryPrice-slPrice)/symbolPoint;
   double moneyRiskPerLot = slPoint + symbolTickValue;
   double positionSize = moneyRisk/moneyRiskPerLot;
   string positionSizeStr = DoubleToString(positionSize,3);

   Comment("MoneyRisk: ",moneyRisk,
           "\nEntryPrice: ",entryPrice,
           "\nSlPrice: ",slPrice,
           "\npositionSize: ",positionSizeStr);

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
