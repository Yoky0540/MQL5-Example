//+------------------------------------------------------------------+
//|                                          basic-open-position.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"

#include <Trade/Trade.mqh>
CTrade Trading;

int OnInit()
{
  double Ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
  double Bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
  double R2R = 2;

  // MqlOpenPosition("buy", R2R);
  // MqlOpenPosition("sell", R2R);

  // Open position by Ctrade class
  // Trading.Buy(1, Symbol(), Ask, Ask - 100 * Point(), Ask + 200 * Point());
  Trading.Sell(1, Symbol(), Bid, Bid + 100 * Point(), Bid - 200 * Point());

  ulong ticket = Trading.ResultOrder();

  for (int i = 0; i < 3; i++)
  {
    PositionSelectByTicket(ticket);
    Sleep(2000);

    Trading.PositionModify(PositionGetInteger(POSITION_TICKET), PositionGetDouble(POSITION_SL) + 100 * Point(), PositionGetDouble(POSITION_TP) - 200 * Point());
    Alert("The modify is done");
  }

  return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
}

void OnTick()
{
}

void MqlOpenPosition(string order_type, double R2R)
{
  // Original OrderSend function
  MqlTradeRequest request{};
  MqlTradeResult result{};

  double Ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
  double Bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);

  if (order_type == "buy")
  {
    request.action = TRADE_ACTION_DEAL;
    request.symbol = Symbol();
    request.volume = 2;
    request.sl = Bid + 100 * Point();
    request.tp = (Bid - R2R) * 100 * Point();
    request.type = ORDER_TYPE_BUY;
    request.price = Ask;
  }
  else if (order_type == "sell")
  {
    // Sell
    request.action = TRADE_ACTION_DEAL;
    request.symbol = Symbol();
    request.volume = 2;
    request.sl = Ask + 100 * Point();
    request.tp = (Ask - R2R) * 100 * Point();
    request.type = ORDER_TYPE_SELL;
    request.price = Bid;
  }

  bool openResult = OrderSend(request, result);
}
