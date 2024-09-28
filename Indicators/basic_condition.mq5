//+------------------------------------------------------------------+
//|                                              basic_condition.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property indicator_chart_window

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

input string Password = "Password";    // Enter your password for use indicator

int rsi_handles;

double rsi_buffer[];

int OnInit()
{
  rsi_handles = iRSI(_Symbol, _Period, 14, MODE_CLOSE);
  ArraySetAsSeries(rsi_buffer, true);

  if (Password != "1234")
  {
    Alert("Incorrect Password");
    return (INIT_FAILED);
  }

  return (INIT_SUCCEEDED);
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

  CopyBuffer(rsi_handles, 0, 0, 2, rsi_buffer);
  double rsi_value = rsi_buffer[0];
  string rsi_status = "Normal";

  if (rsi_value > 70)
  {
    rsi_status = "Overbought";
  }
  else if (rsi_value < 30)
  {
    rsi_status = "Oversold";
  }

  Comment("RSI Status: ", rsi_status);

  return (rates_total);
}
//+------------------------------------------------------------------+
