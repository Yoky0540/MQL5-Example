//+------------------------------------------------------------------+
//|                                               getActualPrice.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
  //---

  //---
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

  // get current bi ask for pair
  double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
  double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

  // current open high lo close of pair
  int barIndex = 10;
  double openPrice = iOpen(_Symbol, _Period, barIndex);
  double highPrice = iHigh(_Symbol, _Period, barIndex);
  double lowPrice = iLow(_Symbol, _Period, barIndex);
  double closePrice = iClose(_Symbol, _Period, barIndex);

  // get current bi ask for USDCAD
  double bid_USDCAD = SymbolInfoDouble("USDCAD", SYMBOL_BID);
  double ask_USDCAD = SymbolInfoDouble("USDCAD", SYMBOL_ASK);
  //---
  Comment("Bid: ", bid,
          "\nAsk: ", ask,
          "\nTarget Bar: ", barIndex,
          " Open: ", openPrice,
          " High: ", highPrice,
          " Low: ", lowPrice,
          " Close: ", closePrice,
          "\nBid_USDCAD: ", bid_USDCAD,
          "\nASk_USDCAD: ", ask_USDCAD);
}
//+------------------------------------------------------------------+
