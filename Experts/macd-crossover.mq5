//+------------------------------------------------------------------+
//|                                               macd-crossover.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"

#include <Trade/Trade.mqh>
CTrade Trading;

input int sl_point = 500;
input int tp_point = 1000;
input double lot_size = 0.01;

int macd_handle;
double macd_main_buffer[], macd_signal_buffer[];

int ticket;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{

  macd_handle = iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, MODE_CLOSE);
  ArraySetAsSeries(macd_main_buffer, true);
  ArraySetAsSeries(macd_signal_buffer, true);

  return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{

  double ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
  double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);

  CopyBuffer(macd_handle, MAIN_LINE, 0, 3, macd_main_buffer);
  CopyBuffer(macd_handle, SIGNAL_LINE, 0, 3, macd_signal_buffer);

  double macd_main_1 = macd_main_buffer[1];
  double macd_main_2 = macd_main_buffer[2];

  int total_orders = OrdersTotal();       // count order that request to open but it not filed yet like a pending order
  int total_positions = PositionsTotal(); // count order that already fullfilled

  // Trading.BuyLimit(lot_size, 10.005, NULL, 0, 0, ORDER_TIME_DAY, 0, NULL);

  if (total_positions == 0)
  {
    if ((macd_main_2 < 0) && (macd_main_1 >= 0)) // buy condition
    {
      ticket = Trading.Buy(lot_size, NULL, ask, ask - (sl_point * Point()), ask + (tp_point * Point()), NULL);
    }
    else if (macd_main_2 > 0 && macd_main_1 <= 0)
    {
      ticket = Trading.Sell(lot_size, NULL, bid, bid + (sl_point * Point()), bid - (tp_point * Point()), NULL);
    }
    else
    {
      Comment("No Signal");
    }
  }
  else
  {
    Comment("Maximum Order Reach");
  }
}

//+------------------------------------------------------------------+
