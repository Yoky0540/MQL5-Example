//+------------------------------------------------------------------+
//|                                    getValue-custom-indicator.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"

#include <Trade/Trade.mqh>
CTrade Trading;

// input for custom indicator (MACD.mqh in Example)
input int InpFastEmaPeriod = 12;                        // Fast EMA Period
input int InpSlowEmaPeriod = 26;                        // Slow EMA Period
input int InpsignalSmaPeriod = 9;                       // Signal SMA Period
input ENUM_APPLIED_PRICE InpAppliedPrice = PRICE_CLOSE; // Applied Price
//////

input int InpTP = 100; // Take Pofit points
input int InpSL = 100; // Stop loss points

input double InpOrderSize = 0.01;        // Order Size
input string InpTradeComment = __FILE__; // Trade Comment
input int InpmagicNumber = 2000001;      // Magic Number

double TakeProfit, StopLoss;
double buffer0, buffer1, buffer2;

/// Identify the buffer numbers (macd custom)//
const string IndicatorName = "Examples\\MACD";
const int IndexMACD = 0;
const int IndexSignal = 1;
int Handle;
double BufferMACD[3], BufferSignal[3];

//

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
{
  Trading = new CTrade();
  Trading.SetExpertMagicNumber(InpmagicNumber);

  double point = SymbolInfoDouble(Symbol(), SYMBOL_POINT);
  TakeProfit = InpTP * point;
  StopLoss = InpSL * point;

  Handle = iCustom(Symbol(), PERIOD_CURRENT, IndicatorName, InpFastEmaPeriod, InpSlowEmaPeriod, InpsignalSmaPeriod, InpAppliedPrice);

  if (Handle == INVALID_HANDLE)
  {
    PrintFormat("Error %i", GetLastError());
    return (INIT_FAILED);
  }
  return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
{
  if (!NewBar())
    return;

  int cnt = CopyBuffer(Handle, IndexMACD, 0, 3, BufferMACD);
  if (cnt < 3)
    return;
  cnt = CopyBuffer(Handle, IndexSignal, 0, 3, BufferSignal); // not check because it is same with upper

  double currentMACD = BufferMACD[1];
  double currentSignal = BufferSignal[1];
  double priorMACD = BufferMACD[0];
  double priorSignal = BufferSignal[0];

  bool buyCondition = (priorMACD < 0 && priorMACD <= priorSignal) && (currentMACD > currentSignal);
  bool sellcondition = (priorMACD > 0 && priorMACD >= priorSignal) && (currentMACD < currentSignal);

  if (buyCondition)
  {
    OrderOpen(ORDER_TYPE_BUY);
  }
  else if (sellcondition)
  {
    OrderOpen(ORDER_TYPE_SELL);
  }

  return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool NewBar()
{
  static datetime prevTime = 0;
  datetime currenTime = iTime(Symbol(), PERIOD_CURRENT, 0);

  if (currenTime != prevTime)
  {
    prevTime = currenTime;
    return true;
  }

  return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderOpen(ENUM_ORDER_TYPE order_type)
{
  double price;
  double stopLossPrice;
  double takeProfitPrice;

  int symbol_digits = Digits();
  if (order_type == ORDER_TYPE_BUY)
  {
    double askPrice = SymbolInfoDouble(Symbol(), SYMBOL_ASK);

    price = NormalizeDouble(askPrice, symbol_digits);
    stopLossPrice = NormalizeDouble(price - StopLoss, symbol_digits);
    takeProfitPrice = NormalizeDouble(price + TakeProfit, symbol_digits);
  }
  else if (order_type == ORDER_TYPE_SELL)
  {
    double bidPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);

    price = NormalizeDouble(bidPrice, symbol_digits);
    stopLossPrice = NormalizeDouble(price + StopLoss, symbol_digits);
    takeProfitPrice = NormalizeDouble(price - StopLoss, symbol_digits);
  }
  else
  {
    return false;
  }

  Trading.PositionOpen(Symbol(), order_type, InpOrderSize, price, stopLossPrice, takeProfitPrice, InpTradeComment);

  return true;
}
//+------------------------------------------------------------------+
