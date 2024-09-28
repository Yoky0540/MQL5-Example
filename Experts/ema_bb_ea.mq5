//+------------------------------------------------------------------+
//|                                                    ema_bb_ea.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"

input int inpFastEMA = 10;   // Insert Fast EMA Period
input int inpBBPeriod = 20; // Insert Bollinger Bands Period

//--- indicator Handle
int fast_ema_handle;
int bb_handle;

//--- indicator buffer
double ema_Buffer[];       // Buffer to store EMA values
double bb_Upper_Buffer[];  // Buffer to store BB Upper values
double bb_Middle_Buffer[]; // Buffer to store BB Middle values
double bb_Lower_Buffer[];  // Buffer to store BB Lower values

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{

  // Create handles
  fast_ema_handle = iMA(_Symbol, _Period, inpFastEMA, 0, MODE_EMA, PRICE_CLOSE);
  bb_handle = iBands(_Symbol, _Period, inpBBPeriod, 0, 2, MODE_CLOSE);

  // set buffer as series >> set array 0 is lastest bar
  ArraySetAsSeries(ema_Buffer, true);
  ArraySetAsSeries(bb_Upper_Buffer, true);
  ArraySetAsSeries(bb_Middle_Buffer, true);
  ArraySetAsSeries(bb_Lower_Buffer, true);

  return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
  //---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
  // assign value into buffer array
  CopyBuffer(fast_ema_handle, 0, 0, 2, ema_Buffer);
  CopyBuffer(bb_handle, UPPER_BAND, 0, 2, bb_Upper_Buffer);
  CopyBuffer(bb_handle, MAIN_LINE, 0, 2, bb_Middle_Buffer);
  CopyBuffer(bb_handle, LOWER_BAND, 0, 2, bb_Lower_Buffer);

  string emaValue = DoubleToString(ema_Buffer[1], 3);
  string bb_upper_value = DoubleToString(bb_Upper_Buffer[1], 3);
  string bb_middle_value = DoubleToString(bb_Middle_Buffer[1], 3);
  string bb_lower_value = DoubleToString(bb_Lower_Buffer[1], 3);

  Comment("EMA: ", emaValue,
          "\nBB_upper: ", bb_upper_value,
          "\nBB_middle: ", bb_middle_value,
          "\nBB_lower: ", bb_lower_value);
}
//+------------------------------------------------------------------+
