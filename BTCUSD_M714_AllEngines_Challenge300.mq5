//+------------------------------------------------------------------+
//| BTCUSD_M714_AllEngines_Challenge300.mq5                         |
//| M714: Tighter entries + $10 step lock + momentum ride
//+------------------------------------------------------------------+
#property strict
#property version "1.04"

#include <Trade/Trade.mqh>

CTrade trade;

input string InpTradeSymbol                 = "BTCUSD";
input string InpBotComment                  = "BTCUSD M714 AllEngines";
input int InpMagicNumber                    = 714;

input ENUM_TIMEFRAMES InpSignalTF           = PERIOD_M1;
input ENUM_TIMEFRAMES InpTrendTF            = PERIOD_M5;
input int InpSlippagePoints                 = 120;

input double InpLots                        = 0.50;
input int InpMaxPositions                   = 1;
input int InpMaxTradesPerDay                = 999;
input int InpMaxLossesPerDay                = 88;
input int InpCooldownAfterLossMinutes       = 0;
input int InpMinMsBetweenEntries            = 10000;

input bool InpDisableDayStop                = true;
input bool InpUseDailyTarget                = false;
input double InpDailyTargetUSD              = 1100.0;
input bool InpUseDailyLossLimit             = false;
input double InpDailyMaxLossUSD             = 88.0;
input bool InpUseEquityProfitLock           = false;
input double InpEquityGivebackFromPeakUSD   = 60.0;
input bool InpUseHardMoneyStop              = true;
input double InpHardMaxLossUSD              = 35.0;
input double InpTargetSL_MoneyUSD           = 35.0;
input double InpMinSL_MoneyUSD              = 35.0;

input int InpFastEmaPeriod                  = 20;
input int InpSlowEmaPeriod                  = 50;
input int InpSignalEmaPeriod                = 20;
input int InpAtrPeriod                      = 14;
input int InpRsiPeriod                      = 14;
input int InpBreakoutBars                   = 12;

input double InpAtrSLMult                   = 0.65;
input double InpAtrTPMult                   = 3.0;
input double InpMinTP_MoneyUSD              = 15.0;
input double InpMinRewardRisk               = 1.80;
input int InpMaxHoldMinutes                 = 45;

input bool InpUseBreakEven                  = true;
input double InpBE_StartUSD                 = 5.0;
input double InpBE_LockUSD                  = 1.0;
input bool InpUseTrailing                   = true;
input double InpTrailStartMoneyUSD          = 12.0;
input double InpTrailDistanceMoneyUSD       = 8.0;
input double InpMinSLModifyMoneyUSD         = 3.0;
input bool InpShowTrailOnChart              = true;

input bool InpUseProfitStepLock             = true;
input double InpProfitStepUSD                = 10.0;

input bool InpTradeAsia                     = true;
input int InpAsiaStart                      = 0;
input int InpAsiaEnd                        = 8;
input bool InpTradeLondon                   = true;
input int InpLondonStart                    = 8;
input int InpLondonEnd                      = 16;
input bool InpTradeOverlap                  = true;
input int InpOverlapStart                   = 16;
input int InpOverlapEnd                     = 22;
input bool InpTradeNYLate                   = true;
input int InpNYLateStart                    = 22;
input int InpNYLateEnd                      = 24;
input bool InpTradeWeekends                   = true;
input bool InpTrade24Hours                    = true;
input bool InpSkipFridayLate                = false;
input int InpFridayStopHour                 = 19;

input bool InpUseSpreadFilter               = true;
input int InpMaxSpreadPoints                = 8000;
input bool InpUseNewsTimeBlock              = false;
input string InpNewsBlockWindows            = "15:25-15:45;16:55-17:05;20:00-20:30";

input bool InpUseSweepEntries               = true;
input double InpImpulseBodyAtr              = 0.65;
input double InpStrongImpulseBodyAtr        = 1.10;
input double InpMaxWickBodyRatio            = 0.80;
input bool InpEnforceTrendAlign             = true;
input bool InpUseTrendFilter                = true;
input bool InpRequireM5TrendAlign           = true;
input bool InpRequireM1TrendAlign           = true;
input bool InpRequireM1SlowAlign            = true;
input string InpBlockBuyHours                 = "";
input string InpBlockSellHours                = "";
input int InpMaxConsecutiveLosses           = 3;
input int InpPauseAfterLossStreakMinutes    = 10;
input double InpBuyRsiMin                   = 40.0;
input double InpSellRsiMax                  = 60.0;
input double InpMaxBuyRsi                   = 50.0;
input double InpMinSellRsi                  = 50.0;

input bool InpUseSpikePredict               = true;
input bool InpUseSpikeConfirm               = true;
input double InpSpikeRangeAtrMult           = 0.85;
input double InpSpikeBodyAtrMult            = 0.40;
input double InpPredictRangeAtrMult         = 0.58;
input double InpPredictBodyAtrMult          = 0.30;
input double InpSpikeMaxWickRatio           = 0.65;

input bool InpUseMomoBreak                  = true;
input double InpMomoRangeAtrMult            = 0.65;
input double InpMomoBodyAtrMult             = 0.38;

input bool InpUsePullback                   = true;
input bool InpUseLivePullback               = true;
input double InpPullbackTouchAtrMult        = 0.40;
input double InpPullbackRsiBuyMin           = 32.0;
input double InpPullbackRsiBuyMax           = 62.0;
input double InpPullbackRsiSellMin          = 38.0;
input double InpPullbackRsiSellMax          = 68.0;

input bool InpUseLiqFade                    = true;
input int InpLiqFadeLookback                = 20;
input double InpLiqFadeWickAtrMult          = 0.40;

input bool InpUseBBMeanRevert               = false;
input int InpBBPeriod                       = 20;
input double InpBBDev                       = 2.0;
input double InpBBAdxMax                    = 22.0;

input bool InpUseSqueezeBreak               = true;
input double InpSqueezePct                  = 0.55;

input bool InpUseSessionRangeBreak          = true;
input int InpSessionRangeBars               = 240;
input int InpSessionBreakStartH             = 8;
input int InpSessionBreakEndH               = 11;
input double InpSessionBreakBufAtr          = 0.15;

input bool InpUseATRExtremeFade             = false;
input int InpATRMeanBars                    = 30;
input double InpATRStretchMult              = 1.8;

input bool InpUseRSIMomentumBurst           = true;
input double InpRSIBurstBodyAtr             = 0.75;

input bool InpUseHourBlockMomentum          = true;
input int InpHourBlockStart                 = 13;
input int InpHourBlockEnd                   = 17;

input bool InpUseDualTFImpulse              = true;
input double InpDualM5BodyAtr               = 1.10;
input double InpDualM1BodyAtr               = 0.50;

input bool InpUseVWAPProxyRevert           = false;
input int InpVwapAnchorPeriod               = 50;
input double InpVwapDevAtr                  = 1.5;

input bool InpShowDashboard                 = true;

int fastEmaHandle = INVALID_HANDLE;
int slowEmaHandle = INVALID_HANDLE;
int signalEmaHandle = INVALID_HANDLE;
int atrHandle = INVALID_HANDLE;
int rsiHandle = INVALID_HANDLE;
int bbHandle = INVALID_HANDLE;
int adxHandle = INVALID_HANDLE;
int atrM5Handle = INVALID_HANDLE;
int vwapAnchorHandle = INVALID_HANDLE;
int m1SlowEmaHandle = INVALID_HANDLE;

datetime lastSignalBarTime = 0;
datetime lastLossTime = 0;
ulong lastEntryAttemptMs = 0;
double dayStartBalance = 0.0;
int todayTrades = 0;
int todayLosses = 0;
double todayProfit = 0.0;
double myDayPeakProfit = 0.0;
bool dayStopped = false;
string lastStatus = "Starting...";
string lastSignal = "";
string lastEntryPath = "";
string lastRegime = "ACTIVE";
string lastStepLockInfo = "Step lock: none";
int consecutiveLosses = 0;
datetime lossStreakPauseUntil = 0;
ulong g_lastChartLineKey = 0;

ulong beFloorKeys[];
double beFloorPrices[];

ulong profitStepKeys[];
double profitStepLockedMoney[];

double MinBrokerStopDistance(const double lots);
bool IsTakeProfitValid(const bool isBuy, const double tpPrice, const double lots);
void EnsureValidStops(const int direction, const double entry, const double lots, double &sl, double &tp);

//+------------------------------------------------------------------+
int OnInit()
{
   trade.SetExpertMagicNumber(InpMagicNumber);
   trade.SetDeviationInPoints(InpSlippagePoints);

   fastEmaHandle = iMA(InpTradeSymbol, InpTrendTF, InpFastEmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   slowEmaHandle = iMA(InpTradeSymbol, InpTrendTF, InpSlowEmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   signalEmaHandle = iMA(InpTradeSymbol, InpSignalTF, InpSignalEmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   atrHandle = iATR(InpTradeSymbol, InpSignalTF, InpAtrPeriod);
   rsiHandle = iRSI(InpTradeSymbol, InpSignalTF, InpRsiPeriod, PRICE_CLOSE);
   bbHandle = iBands(InpTradeSymbol, InpSignalTF, InpBBPeriod, 0, InpBBDev, PRICE_CLOSE);
   adxHandle = iADX(InpTradeSymbol, InpTrendTF, 14);
   atrM5Handle = iATR(InpTradeSymbol, InpTrendTF, InpAtrPeriod);
   vwapAnchorHandle = iMA(InpTradeSymbol, InpSignalTF, InpVwapAnchorPeriod, 0, MODE_EMA, PRICE_CLOSE);
   m1SlowEmaHandle = iMA(InpTradeSymbol, InpSignalTF, InpSlowEmaPeriod, 0, MODE_EMA, PRICE_CLOSE);

   if(fastEmaHandle == INVALID_HANDLE || slowEmaHandle == INVALID_HANDLE ||
      signalEmaHandle == INVALID_HANDLE || atrHandle == INVALID_HANDLE || rsiHandle == INVALID_HANDLE ||
      bbHandle == INVALID_HANDLE || adxHandle == INVALID_HANDLE || atrM5Handle == INVALID_HANDLE ||
      vwapAnchorHandle == INVALID_HANDLE || m1SlowEmaHandle == INVALID_HANDLE)
   {
      Print("M714 init failed: indicator handle creation failed.");
      return INIT_FAILED;
   }

   ObjectsDeleteAll(0, "M506_");
   ObjectsDeleteAll(0, "M507_");
   ObjectsDeleteAll(0, "M508_");
   ObjectsDeleteAll(0, "M509_");
   ObjectsDeleteAll(0, "M710_");
   ObjectsDeleteAll(0, "M714_");
   PurgeAllTradeChartObjects();
   ClearAllMyChartLines();
   EventSetTimer(1);
   dayStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   dayStopped = false;
   myDayPeakProfit = 0.0;
   consecutiveLosses = 0;
   lossStreakPauseUntil = 0;
   lastStatus = "M714 ready. Tight entry + $10 step lock.";
   ShowDashboard();
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(fastEmaHandle != INVALID_HANDLE) IndicatorRelease(fastEmaHandle);
   if(slowEmaHandle != INVALID_HANDLE) IndicatorRelease(slowEmaHandle);
   if(signalEmaHandle != INVALID_HANDLE) IndicatorRelease(signalEmaHandle);
   if(atrHandle != INVALID_HANDLE) IndicatorRelease(atrHandle);
   if(rsiHandle != INVALID_HANDLE) IndicatorRelease(rsiHandle);
   if(bbHandle != INVALID_HANDLE) IndicatorRelease(bbHandle);
   if(adxHandle != INVALID_HANDLE) IndicatorRelease(adxHandle);
   if(atrM5Handle != INVALID_HANDLE) IndicatorRelease(atrM5Handle);
   if(vwapAnchorHandle != INVALID_HANDLE) IndicatorRelease(vwapAnchorHandle);
   if(m1SlowEmaHandle != INVALID_HANDLE) IndicatorRelease(m1SlowEmaHandle);
   ObjectsDeleteAll(0, "M506_");
   ObjectsDeleteAll(0, "M507_");
   ObjectsDeleteAll(0, "M508_");
   ObjectsDeleteAll(0, "M509_");
   ObjectsDeleteAll(0, "M710_");
   ObjectsDeleteAll(0, "M714_");
   ClearAllMyChartLines();
   EventKillTimer();
   Comment("");
}

//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
{
   if(trans.type != TRADE_TRANSACTION_DEAL_ADD)
      return;
   if(!HistoryDealSelect(trans.deal))
      return;
   if(HistoryDealGetString(trans.deal, DEAL_SYMBOL) != InpTradeSymbol)
      return;
   if(HistoryDealGetInteger(trans.deal, DEAL_MAGIC) != InpMagicNumber)
      return;

   const ENUM_DEAL_ENTRY entry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(trans.deal, DEAL_ENTRY);
   if(entry != DEAL_ENTRY_OUT && entry != DEAL_ENTRY_OUT_BY)
      return;

   const ulong posTicket = (ulong)HistoryDealGetInteger(trans.deal, DEAL_POSITION_ID);
   if(g_lastChartLineKey > 0)
      RemoveChartTradeLines(g_lastChartLineKey);
   if(posTicket > 0)
      RemoveChartTradeLines(posTicket);
   g_lastChartLineKey = 0;
   ClearAllMyChartLines();

   const double dealProfit = HistoryDealGetDouble(trans.deal, DEAL_PROFIT)
                           + HistoryDealGetDouble(trans.deal, DEAL_SWAP)
                           + HistoryDealGetDouble(trans.deal, DEAL_COMMISSION);
   if(InpMaxConsecutiveLosses > 0 && dealProfit < -0.01)
   {
      consecutiveLosses++;
      if(consecutiveLosses >= InpMaxConsecutiveLosses)
         lossStreakPauseUntil = TimeCurrent() + InpPauseAfterLossStreakMinutes * 60;
   }
   else if(dealProfit > 0.01)
   {
      consecutiveLosses = 0;
      lossStreakPauseUntil = 0;
   }
}

//+------------------------------------------------------------------+
void OnTimer()
{
   if(CountMyPositions() == 0)
      ClearAllMyChartLines();
}

//+------------------------------------------------------------------+
void OnTick()
{
   if(_Symbol != InpTradeSymbol)
   {
      lastStatus = "Wrong chart symbol. Attach to " + InpTradeSymbol + ".";
      ShowDashboard();
      return;
   }

   ResetDailyIfNeeded();
   ManageOpenPositions();
   if(CountMyPositions() == 0)
      ClearAllMyChartLines();

   if(!CheckDailyCircuitBreakers())
   {
      ShowDashboard();
      return;
   }

   UpdateTodayStats();
   TryOpenTrade();
   ShowDashboard();
}

//+------------------------------------------------------------------+
bool PassEntryGates()
{
   if(dayStopped && !InpDisableDayStop)
   {
      lastStatus = "Blocked: day stopped.";
      return false;
   }
   if(!IsTradingSession())
   {
      lastStatus = "Blocked: outside active session.";
      return false;
   }
   if(IsNewsTimeBlock())
   {
      lastStatus = "Blocked: news time window.";
      return false;
   }
   if(InpUseSpreadFilter && GetSpreadPoints() > InpMaxSpreadPoints)
   {
      lastStatus = "Blocked: spread too high.";
      return false;
   }
   if(CountMyPositions() >= InpMaxPositions)
   {
      lastStatus = "Blocked: max position count.";
      return false;
   }
   if(todayTrades >= InpMaxTradesPerDay)
   {
      lastStatus = "Blocked: max trades per day.";
      return false;
   }
   if(todayLosses >= InpMaxLossesPerDay)
   {
      lastStatus = "Blocked: max losses per day.";
      return false;
   }
   if(InpCooldownAfterLossMinutes > 0 && lastLossTime > 0 && TimeCurrent() - lastLossTime < InpCooldownAfterLossMinutes * 60)
   {
      lastStatus = "Blocked: cooldown after loss.";
      return false;
   }
   if(InpMaxConsecutiveLosses > 0 && lossStreakPauseUntil > 0 && TimeCurrent() < lossStreakPauseUntil)
   {
      lastStatus = "Blocked: loss streak pause.";
      return false;
   }
   const ulong nowMs = GetTickCount();
   if(nowMs - lastEntryAttemptMs < (ulong)InpMinMsBetweenEntries)
   {
      lastStatus = "Blocked: entry throttle.";
      return false;
   }
   return true;
}

//+------------------------------------------------------------------+
void TryOpenTrade()
{
   if(!PassEntryGates())
      return;

   double atr[], rsi[], fast[], slow[], signalEma[], m1Slow[];
   MqlRates rates[];
   const int rateCount = MathMax(InpBreakoutBars, MathMax(InpLiqFadeLookback, InpSessionRangeBars)) + 8;
   ArrayResize(atr, 4);
   ArrayResize(rsi, 4);
   ArrayResize(fast, 3);
   ArrayResize(slow, 3);
   ArrayResize(signalEma, 4);
   ArrayResize(m1Slow, 3);
   ArrayResize(rates, rateCount);
   ArraySetAsSeries(atr, true);
   ArraySetAsSeries(rsi, true);
   ArraySetAsSeries(fast, true);
   ArraySetAsSeries(slow, true);
   ArraySetAsSeries(signalEma, true);
   ArraySetAsSeries(m1Slow, true);
   ArraySetAsSeries(rates, true);

   if(CopyBuffer(atrHandle, 0, 0, 4, atr) < 3 ||
      CopyBuffer(rsiHandle, 0, 0, 4, rsi) < 4 ||
      CopyBuffer(fastEmaHandle, 0, 0, 3, fast) < 3 ||
      CopyBuffer(slowEmaHandle, 0, 0, 3, slow) < 3 ||
      CopyBuffer(signalEmaHandle, 0, 0, 4, signalEma) < 4 ||
      CopyBuffer(m1SlowEmaHandle, 0, 0, 3, m1Slow) < 2 ||
      CopyRates(InpTradeSymbol, InpSignalTF, 0, rateCount, rates) < rateCount - 1)
   {
      lastStatus = "Blocked: not enough market data.";
      return;
   }

   const int trendDir = GetTrendDirection(fast[1], slow[1]);
   int signal = 0;
   string path = "";

   if(InpUseMomoBreak)
      signal = GetMomoBreakSignal(rates, atr[1], rsi[0], path);
   if(signal == 0 && InpUseSpikePredict)
      signal = GetSpikePredictSignal(rates, atr[1], rsi[0], path);
   if(signal == 0 && InpUseLivePullback)
      signal = GetLivePullbackSignal(rates, signalEma, rsi, trendDir, atr[1], path);

   if(signal == 0 && IsNewSignalBar())
   {
      if(InpUseSpikeConfirm)
         signal = GetSpikeConfirmSignal(rates, atr[1], rsi[1], path);
      if(signal == 0 && InpUseSweepEntries)
         signal = GetSweepSignal(rates, atr[1], rsi[1], fast[1], slow[1], path);
      if(signal == 0 && InpUsePullback)
         signal = GetPullbackSignal(rates, signalEma, rsi, trendDir, atr[1], path);
      if(signal == 0 && InpUseLiqFade)
         signal = GetLiqFadeSignal(rates, atr[1], path);

      if(signal == 0 && InpUseBBMeanRevert)
         signal = GetBBMeanRevertSignal(rates, path);
      if(signal == 0 && InpUseSqueezeBreak)
         signal = GetSqueezeBreakSignal(rates, atr[1], path);
      if(signal == 0 && InpUseSessionRangeBreak)
         signal = GetSessionRangeBreakSignal(rates, atr[1], path);
      if(signal == 0 && InpUseATRExtremeFade)
         signal = GetATRExtremeFadeSignal(rates, atr[1], path);
      if(signal == 0 && InpUseRSIMomentumBurst)
         signal = GetRSIMomentumBurstSignal(rates, atr[1], rsi, path);
      if(signal == 0 && InpUseHourBlockMomentum)
         signal = GetHourBlockMomentumSignal(rates, path);
      if(signal == 0 && InpUseDualTFImpulse)
         signal = GetDualTFImpulseSignal(atr[1], path);
      if(signal == 0 && InpUseVWAPProxyRevert)
         signal = GetVWAPProxyRevertSignal(rates, atr[1], path);
   }

   if(signal == 0)
   {
      lastStatus = "Scanning: M5 trend " + IntegerToString(trendDir) + ", waiting setup.";
      return;
   }

   const double mid = (SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID) +
                       SymbolInfoDouble(InpTradeSymbol, SYMBOL_ASK)) * 0.5;

   if(InpEnforceTrendAlign)
   {
      if(SideBlockedByHour(signal))
      {
         lastStatus = signal > 0 ? "Blocked: BUY hour filter." : "Blocked: SELL hour filter.";
         return;
      }
      if(signal > 0 && !BuyTrendAllowed(trendDir, mid, signalEma[0], m1Slow[0]))
      {
         lastStatus = "Blocked: downtrend - no BUY (M5/M1).";
         lastSignal = StringFormat("M5=%d price=%.2f ema=%.2f slow=%.2f", trendDir, mid, signalEma[0], m1Slow[0]);
         return;
      }
      if(signal < 0 && !SellTrendAllowed(trendDir, mid, signalEma[0], m1Slow[0]))
      {
         lastStatus = "Blocked: uptrend - no SELL (M5/M1).";
         lastSignal = StringFormat("M5=%d price=%.2f ema=%.2f slow=%.2f", trendDir, mid, signalEma[0], m1Slow[0]);
         return;
      }
   }
   lastEntryAttemptMs = GetTickCount();
   OpenTrade(signal, atr[1], path);
}

//+------------------------------------------------------------------+
bool IsHourInCsvList(const int hour, const string csv)
{
   if(StringLen(csv) == 0)
      return false;

   string parts[];
   const int n = StringSplit(csv, ',', parts);
   for(int i = 0; i < n; i++)
   {
      StringTrimLeft(parts[i]);
      StringTrimRight(parts[i]);
      if((int)StringToInteger(parts[i]) == hour)
         return true;
   }
   return false;
}

//+------------------------------------------------------------------+
bool SideBlockedByHour(const int direction)
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   if(direction > 0 && IsHourInCsvList(dt.hour, InpBlockBuyHours))
      return true;
   if(direction < 0 && IsHourInCsvList(dt.hour, InpBlockSellHours))
      return true;
   return false;
}

//+------------------------------------------------------------------+
bool BuyTrendAllowed(const int trendDir, const double price, const double signalEma, const double m1SlowEma)
{
   if(InpRequireM5TrendAlign && trendDir <= 0)
      return false;
   if(InpRequireM1TrendAlign && signalEma > 0.0 && price <= signalEma)
      return false;
   if(InpRequireM1SlowAlign && m1SlowEma > 0.0 && price <= m1SlowEma)
      return false;
   return true;
}

//+------------------------------------------------------------------+
bool SellTrendAllowed(const int trendDir, const double price, const double signalEma, const double m1SlowEma)
{
   if(InpRequireM5TrendAlign && trendDir >= 0)
      return false;
   if(InpRequireM1TrendAlign && signalEma > 0.0 && price >= signalEma)
      return false;
   if(InpRequireM1SlowAlign && m1SlowEma > 0.0 && price >= m1SlowEma)
      return false;
   return true;
}

//+------------------------------------------------------------------+
int GetTrendDirection(const double fastEma, const double slowEma)

{
   if(fastEma > slowEma) return 1;
   if(fastEma < slowEma) return -1;
   return 0;
}

//+------------------------------------------------------------------+
void RangeHighLow(const MqlRates &rates[], const int startBar, const int bars, double &highest, double &lowest)
{
   highest = rates[startBar].high;
   lowest = rates[startBar].low;
   for(int i = startBar + 1; i < startBar + bars; i++)
   {
      highest = MathMax(highest, rates[i].high);
      lowest = MathMin(lowest, rates[i].low);
   }
}

//+------------------------------------------------------------------+
int GetMomoBreakSignal(const MqlRates &rates[], const double atrValue, const double rsiValue, string &path)
{
   if(atrValue <= 0.0) return 0;
   const MqlRates bar = rates[0];
   const double range = bar.high - bar.low;
   const double body = bar.close - bar.open;
   const double absBody = MathAbs(body);
   if(range < atrValue * InpMomoRangeAtrMult || absBody < atrValue * InpMomoBodyAtrMult)
      return 0;

   double highest = 0.0, lowest = 0.0;
   RangeHighLow(rates, 2, InpBreakoutBars, highest, lowest);

   if(body > 0.0 && bar.high > highest && rsiValue >= 25.0 && rsiValue <= 85.0)
   {
      path = "MOMO_BREAK";
      lastSignal = StringFormat("Momo BUY brk=%.2f rng=%.2f rsi=%.1f", highest, range, rsiValue);
      return 1;
   }
   if(body < 0.0 && bar.low < lowest && rsiValue >= 15.0 && rsiValue <= 75.0)
   {
      path = "MOMO_BREAK";
      lastSignal = StringFormat("Momo SELL brk=%.2f rng=%.2f rsi=%.1f", lowest, range, rsiValue);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetSpikePredictSignal(const MqlRates &rates[], const double atrValue, const double rsiValue, string &path)
{
   if(atrValue <= 0.0) return 0;
   const MqlRates bar = rates[0];
   const double range = bar.high - bar.low;
   const double body = bar.close - bar.open;
   const double absBody = MathAbs(body);
   if(range < atrValue * InpPredictRangeAtrMult || absBody < atrValue * InpPredictBodyAtrMult)
      return 0;

   const double upperWick = bar.high - MathMax(bar.open, bar.close);
   const double lowerWick = MathMin(bar.open, bar.close) - bar.low;

   if(body > 0.0 && upperWick <= absBody * InpSpikeMaxWickRatio && rsiValue >= 25.0 && rsiValue <= 85.0)
   {
      path = "SPIKE_PRED";
      lastSignal = StringFormat("Pred BUY rng=%.2f body=%.2f rsi=%.1f", range, absBody, rsiValue);
      return 1;
   }
   if(body < 0.0 && lowerWick <= absBody * InpSpikeMaxWickRatio && rsiValue >= 15.0 && rsiValue <= 75.0)
   {
      path = "SPIKE_PRED";
      lastSignal = StringFormat("Pred SELL rng=%.2f body=%.2f rsi=%.1f", range, absBody, rsiValue);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetSpikeConfirmSignal(const MqlRates &rates[], const double atrValue, const double rsiValue, string &path)
{
   if(atrValue <= 0.0) return 0;
   const MqlRates bar = rates[1];
   const double range = bar.high - bar.low;
   const double body = bar.close - bar.open;
   const double absBody = MathAbs(body);
   if(range < atrValue * InpSpikeRangeAtrMult || absBody < atrValue * InpSpikeBodyAtrMult)
      return 0;

   const double upperWick = bar.high - MathMax(bar.open, bar.close);
   const double lowerWick = MathMin(bar.open, bar.close) - bar.low;

   if(body > 0.0 && upperWick <= absBody * InpSpikeMaxWickRatio && rsiValue >= 25.0 && rsiValue <= 85.0)
   {
      path = "SPIKE_CONF";
      lastSignal = StringFormat("Conf BUY rng=%.2f rsi=%.1f", range, rsiValue);
      return 1;
   }
   if(body < 0.0 && lowerWick <= absBody * InpSpikeMaxWickRatio && rsiValue >= 15.0 && rsiValue <= 75.0)
   {
      path = "SPIKE_CONF";
      lastSignal = StringFormat("Conf SELL rng=%.2f rsi=%.1f", range, rsiValue);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetSweepSignal(const MqlRates &rates[], const double atrValue, const double rsiValue,
                   const double fastEma, const double slowEma, string &path)
{
   if(atrValue <= 0.0 || fastEma <= 0.0 || slowEma <= 0.0) return 0;

   const double open = rates[1].open;
   const double close = rates[1].close;
   const double high = rates[1].high;
   const double low = rates[1].low;
   const double body = MathAbs(close - open);
   const double range = high - low;
   if(range <= 0.0) return 0;

   const double effectiveBody = MathMax(body, SymbolInfoDouble(InpTradeSymbol, SYMBOL_POINT));
   const double upperWick = high - MathMax(open, close);
   const double lowerWick = MathMin(open, close) - low;
   const bool rangeLargeEnough = range >= atrValue * InpImpulseBodyAtr;
   const bool strongRange = range >= atrValue * InpStrongImpulseBodyAtr;

   double highest = rates[2].high, lowest = rates[2].low;
   for(int i = 3; i < InpBreakoutBars + 2; i++)
   {
      highest = MathMax(highest, rates[i].high);
      lowest = MathMin(lowest, rates[i].low);
   }

   const bool trendUp = fastEma > slowEma;
   const bool trendDown = fastEma < slowEma;
   const bool buyTrendOk = !InpUseTrendFilter || trendUp || strongRange;
   const bool sellTrendOk = !InpUseTrendFilter || trendDown || strongRange;
   const bool sweptLow = low < lowest && close > lowest;
   const bool sweptHigh = high > highest && close < highest;
   const bool buyRejection = sweptLow && rangeLargeEnough && lowerWick >= effectiveBody * InpMaxWickBodyRatio;
   const bool sellRejection = sweptHigh && rangeLargeEnough && upperWick >= effectiveBody * InpMaxWickBodyRatio;
   const bool buyRsiOk = rsiValue >= InpBuyRsiMin && rsiValue <= InpMaxBuyRsi;
   const bool sellRsiOk = rsiValue <= InpSellRsiMax && rsiValue >= InpMinSellRsi;

   if(buyRejection && buyTrendOk && buyRsiOk)
   {
      path = "SWEEP";
      lastSignal = StringFormat("Sweep BUY body=%.2f rsi=%.1f", body, rsiValue);
      return 1;
   }
   if(sellRejection && sellTrendOk && sellRsiOk)
   {
      path = "SWEEP";
      lastSignal = StringFormat("Sweep SELL body=%.2f rsi=%.1f", body, rsiValue);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetPullbackSignal(const MqlRates &rates[], const double &signalEma[], const double &rsi[],
                      const int trendDir, const double atrValue, string &path)
{
   const MqlRates bar = rates[1];
   const double touchDist = atrValue * InpPullbackTouchAtrMult;

   if(trendDir > 0 && bar.close > bar.open && bar.low <= signalEma[1] + touchDist &&
      bar.close > signalEma[1] && rsi[1] >= InpPullbackRsiBuyMin && rsi[1] <= InpPullbackRsiBuyMax && rsi[1] > rsi[2])
   {
      path = "PULLBACK";
      lastSignal = StringFormat("Pullback BUY ema=%.2f rsi=%.1f", signalEma[1], rsi[1]);
      return 1;
   }
   if(trendDir < 0 && bar.close < bar.open && bar.high >= signalEma[1] - touchDist &&
      bar.close < signalEma[1] && rsi[1] >= InpPullbackRsiSellMin && rsi[1] <= InpPullbackRsiSellMax && rsi[1] < rsi[2])
   {
      path = "PULLBACK";
      lastSignal = StringFormat("Pullback SELL ema=%.2f rsi=%.1f", signalEma[1], rsi[1]);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetLivePullbackSignal(const MqlRates &rates[], const double &signalEma[], const double &rsi[],
                          const int trendDir, const double atrValue, string &path)
{
   const double bid = SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID);
   const double ask = SymbolInfoDouble(InpTradeSymbol, SYMBOL_ASK);
   if(bid <= 0.0 || ask <= 0.0) return 0;

   const MqlRates live = rates[0];
   const double liveMid = (bid + ask) * 0.5;
   const double touchDist = atrValue * InpPullbackTouchAtrMult;

   if(trendDir > 0 && live.low <= signalEma[0] + touchDist && liveMid > signalEma[0] &&
      rsi[0] >= InpPullbackRsiBuyMin && rsi[0] <= InpPullbackRsiBuyMax)
   {
      path = "LIVE_PB";
      lastSignal = StringFormat("Live PB BUY ema=%.2f rsi=%.1f", signalEma[0], rsi[0]);
      return 1;
   }
   if(trendDir < 0 && live.high >= signalEma[0] - touchDist && liveMid < signalEma[0] &&
      rsi[0] >= InpPullbackRsiSellMin && rsi[0] <= InpPullbackRsiSellMax)
   {
      path = "LIVE_PB";
      lastSignal = StringFormat("Live PB SELL ema=%.2f rsi=%.1f", signalEma[0], rsi[0]);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetLiqFadeSignal(const MqlRates &rates[], const double atrValue, string &path)
{
   if(atrValue <= 0.0) return 0;
   double hi = rates[2].high, lo = rates[2].low;
   for(int i = 3; i <= InpLiqFadeLookback + 1; i++)
   {
      hi = MathMax(hi, rates[i].high);
      lo = MathMin(lo, rates[i].low);
   }
   const MqlRates bar = rates[1];
   const double wickMin = atrValue * InpLiqFadeWickAtrMult;
   if(bar.high > hi + wickMin && bar.close < hi)
   {
      path = "LIQ_FADE";
      lastSignal = StringFormat("Liq fade SELL hi=%.2f close=%.2f", hi, bar.close);
      return -1;
   }
   if(bar.low < lo - wickMin && bar.close > lo)
   {
      path = "LIQ_FADE";
      lastSignal = StringFormat("Liq fade BUY lo=%.2f close=%.2f", lo, bar.close);
      return 1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetBBMeanRevertSignal(const MqlRates &rates[], string &path)
{
   double bbUp[], bbMid[], bbLo[], adx[];
   ArrayResize(bbUp, 3);
   ArrayResize(bbMid, 3);
   ArrayResize(bbLo, 3);
   ArrayResize(adx, 3);
   ArraySetAsSeries(bbUp, true);
   ArraySetAsSeries(bbMid, true);
   ArraySetAsSeries(bbLo, true);
   ArraySetAsSeries(adx, true);
   if(CopyBuffer(bbHandle, 0, 0, 3, bbUp) < 2 ||
      CopyBuffer(bbHandle, 1, 0, 3, bbMid) < 2 ||
      CopyBuffer(bbHandle, 2, 0, 3, bbLo) < 2 ||
      CopyBuffer(adxHandle, 0, 0, 3, adx) < 2)
      return 0;
   if(adx[1] > InpBBAdxMax)
      return 0;

   const MqlRates bar = rates[1];
   if(bar.low <= bbLo[1] && bar.close > bbLo[1])
   {
      path = "BB_MR";
      lastSignal = StringFormat("BB MR BUY lo=%.2f adx=%.1f", bbLo[1], adx[1]);
      return 1;
   }
   if(bar.high >= bbUp[1] && bar.close < bbUp[1])
   {
      path = "BB_MR";
      lastSignal = StringFormat("BB MR SELL up=%.2f adx=%.1f", bbUp[1], adx[1]);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetSqueezeBreakSignal(const MqlRates &rates[], const double atrValue, string &path)
{
   if(atrValue <= 0.0) return 0;
   double bbUp[], bbLo[];
   ArrayResize(bbUp, 60);
   ArrayResize(bbLo, 60);
   ArraySetAsSeries(bbUp, true);
   ArraySetAsSeries(bbLo, true);
   if(CopyBuffer(bbHandle, 0, 0, 60, bbUp) < 55 || CopyBuffer(bbHandle, 2, 0, 60, bbLo) < 55)
      return 0;

   const double width1 = bbUp[1] - bbLo[1];
   double minWidth = width1;
   for(int i = 2; i <= 50; i++)
      minWidth = MathMin(minWidth, bbUp[i] - bbLo[i]);

   if(minWidth <= 0.0 || width1 <= minWidth / InpSqueezePct)
      return 0;

   const MqlRates bar = rates[1];
   if(bar.close > bar.open && bar.close > bbUp[1])
   {
      path = "SQZ_BREAK";
      lastSignal = StringFormat("Squeeze BUY w=%.2f min=%.2f", width1, minWidth);
      return 1;
   }
   if(bar.close < bar.open && bar.close < bbLo[1])
   {
      path = "SQZ_BREAK";
      lastSignal = StringFormat("Squeeze SELL w=%.2f min=%.2f", width1, minWidth);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetSessionRangeBreakSignal(const MqlRates &rates[], const double atrValue, string &path)
{
   if(atrValue <= 0.0) return 0;
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   if(dt.hour < InpSessionBreakStartH || dt.hour >= InpSessionBreakEndH)
      return 0;

   const int rb = InpSessionRangeBars;
   if(ArraySize(rates) < rb + 2)
      return 0;

   double hi = rates[rb].high;
   double lo = rates[rb].low;
   for(int i = 1; i < rb; i++)
   {
      hi = MathMax(hi, rates[i].high);
      lo = MathMin(lo, rates[i].low);
   }

   const double buf = atrValue * InpSessionBreakBufAtr;
   const double bid = SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID);
   const double ask = SymbolInfoDouble(InpTradeSymbol, SYMBOL_ASK);
   if(bid > hi + buf)
   {
      path = "SESS_BRK";
      lastSignal = StringFormat("Session BRK BUY hi=%.2f", hi);
      return 1;
   }
   if(ask < lo - buf)
   {
      path = "SESS_BRK";
      lastSignal = StringFormat("Session BRK SELL lo=%.2f", lo);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetATRExtremeFadeSignal(const MqlRates &rates[], const double atrValue, string &path)
{
   if(atrValue <= 0.0) return 0;
   const int mb = InpATRMeanBars;
   if(ArraySize(rates) < mb + 2)
      return 0;

   double sum = 0.0;
   for(int i = 1; i <= mb; i++)
      sum += rates[i].close;
   const double mean = sum / mb;
   const double px = rates[1].close;

   if(px > mean + atrValue * InpATRStretchMult)
   {
      path = "ATR_FADE";
      lastSignal = StringFormat("ATR fade SELL px=%.2f mean=%.2f", px, mean);
      return -1;
   }
   if(px < mean - atrValue * InpATRStretchMult)
   {
      path = "ATR_FADE";
      lastSignal = StringFormat("ATR fade BUY px=%.2f mean=%.2f", px, mean);
      return 1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetRSIMomentumBurstSignal(const MqlRates &rates[], const double atrValue,
                              const double &rsi[], string &path)
{
   if(atrValue <= 0.0) return 0;
   const MqlRates bar = rates[1];
   const double body = MathAbs(bar.close - bar.open);
   if(body < atrValue * InpRSIBurstBodyAtr)
      return 0;

   if(rsi[2] < 50.0 && rsi[1] > 50.0 && bar.close > bar.open)
   {
      path = "RSI_BURST";
      lastSignal = StringFormat("RSI burst BUY rsi=%.1f body=%.2f", rsi[1], body);
      return 1;
   }
   if(rsi[2] > 50.0 && rsi[1] < 50.0 && bar.close < bar.open)
   {
      path = "RSI_BURST";
      lastSignal = StringFormat("RSI burst SELL rsi=%.1f body=%.2f", rsi[1], body);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetHourBlockMomentumSignal(const MqlRates &rates[], string &path)
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   if(dt.hour < InpHourBlockStart || dt.hour >= InpHourBlockEnd)
      return 0;

   double fast[], slow[];
   ArrayResize(fast, 3);
   ArrayResize(slow, 3);
   ArraySetAsSeries(fast, true);
   ArraySetAsSeries(slow, true);
   if(CopyBuffer(signalEmaHandle, 0, 0, 3, fast) < 2)
      return 0;
   if(CopyBuffer(m1SlowEmaHandle, 0, 0, 3, slow) < 2)
      return 0;

   const MqlRates bar = rates[1];
   if(fast[1] > slow[1] && bar.close > bar.open)
   {
      path = "HOUR_MOMO";
      lastSignal = StringFormat("Hour momo BUY h=%d", dt.hour);
      return 1;
   }
   if(fast[1] < slow[1] && bar.close < bar.open)
   {
      path = "HOUR_MOMO";
      lastSignal = StringFormat("Hour momo SELL h=%d", dt.hour);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetDualTFImpulseSignal(const double atrM1, string &path)
{
   if(atrM1 <= 0.0) return 0;
   double atrM5[];
   ArrayResize(atrM5, 3);
   ArraySetAsSeries(atrM5, true);
   if(CopyBuffer(atrM5Handle, 0, 0, 3, atrM5) < 2)
      return 0;

   MqlRates m5[], m1[];
   ArrayResize(m5, 3);
   ArrayResize(m1, 3);
   ArraySetAsSeries(m5, true);
   ArraySetAsSeries(m1, true);
   if(CopyRates(InpTradeSymbol, InpTrendTF, 0, 3, m5) < 2 ||
      CopyRates(InpTradeSymbol, InpSignalTF, 0, 3, m1) < 2)
      return 0;

   const double b5 = MathAbs(m5[1].close - m5[1].open);
   const double b1 = MathAbs(m1[1].close - m1[1].open);
   if(b5 < atrM5[1] * InpDualM5BodyAtr)
      return 0;

   if(m5[1].close > m5[1].open && m1[1].close > m1[1].open && b1 >= atrM1 * InpDualM1BodyAtr)
   {
      path = "DUAL_TF";
      lastSignal = StringFormat("Dual TF BUY m5=%.2f m1=%.2f", b5, b1);
      return 1;
   }
   if(m5[1].close < m5[1].open && m1[1].close < m1[1].open && b1 >= atrM1 * InpDualM1BodyAtr)
   {
      path = "DUAL_TF";
      lastSignal = StringFormat("Dual TF SELL m5=%.2f m1=%.2f", b5, b1);
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+
int GetVWAPProxyRevertSignal(const MqlRates &rates[], const double atrValue, string &path)
{
   if(atrValue <= 0.0) return 0;
   double anchor[];
   ArrayResize(anchor, 3);
   ArraySetAsSeries(anchor, true);
   if(CopyBuffer(vwapAnchorHandle, 0, 0, 3, anchor) < 2)
      return 0;

   const MqlRates bar = rates[1];
   if(bar.close > anchor[1] + atrValue * InpVwapDevAtr && bar.close < bar.open)
   {
      path = "VWAP_FADE";
      lastSignal = StringFormat("VWAP fade SELL px=%.2f anchor=%.2f", bar.close, anchor[1]);
      return -1;
   }
   if(bar.close < anchor[1] - atrValue * InpVwapDevAtr && bar.close > bar.open)
   {
      path = "VWAP_FADE";
      lastSignal = StringFormat("VWAP fade BUY px=%.2f anchor=%.2f", bar.close, anchor[1]);
      return 1;
   }
   return 0;
}

//+------------------------------------------------------------------+
void OpenTrade(const int direction, const double atrValue, const string path)
{
   const double ask = SymbolInfoDouble(InpTradeSymbol, SYMBOL_ASK);
   const double bid = SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID);
   const double point = SymbolInfoDouble(InpTradeSymbol, SYMBOL_POINT);
   if(ask <= 0.0 || bid <= 0.0 || point <= 0.0)
   {
      lastStatus = "Open blocked: invalid quote.";
      return;
   }

   const double lots = NormalizeLots(InpLots);
   if(lots <= 0.0)
   {
      lastStatus = "Open blocked: invalid lot size.";
      return;
   }

   const double brokerMinDist = MinBrokerStopDistance(lots);

   double slDistance = PriceDistanceForMoney(InpTargetSL_MoneyUSD, lots);
   slDistance = MathMax(slDistance, PriceDistanceForMoney(InpMinSL_MoneyUSD, lots));
   slDistance = MathMax(slDistance, brokerMinDist);

   double tpDistance = MathMax(atrValue * InpAtrTPMult, PriceDistanceForMoney(InpMinTP_MoneyUSD, lots));
   tpDistance = MathMax(tpDistance, slDistance * InpMinRewardRisk);
   tpDistance = MathMax(tpDistance, brokerMinDist);

   const double entry = direction > 0 ? ask : bid;
   double sl = NormalizePrice(direction > 0 ? entry - slDistance : entry + slDistance);
   double tp = NormalizePrice(direction > 0 ? entry + tpDistance : entry - tpDistance);
   EnsureValidStops(direction, entry, lots, sl, tp);

   bool ok = false;
   if(direction > 0)
      ok = trade.Buy(lots, InpTradeSymbol, 0.0, sl, tp, InpBotComment);
   else
      ok = trade.Sell(lots, InpTradeSymbol, 0.0, sl, tp, InpBotComment);

   if(ok)
   {
      lastEntryPath = path;
      lastStatus = (direction > 0 ? "BUY" : "SELL") + " [" + path + "] " +
                   StringFormat("opened %.2f lot SL %.2f TP %.2f (~$%.0f SL)", lots, sl, tp, InpTargetSL_MoneyUSD);
      if(InpShowTrailOnChart)
      {
         for(int pi = PositionsTotal() - 1; pi >= 0; pi--)
         {
            const ulong posTicket = PositionGetTicket(pi);
            if(posTicket == 0 || !PositionSelectByTicket(posTicket))
               continue;
            if(PositionGetString(POSITION_SYMBOL) == InpTradeSymbol &&
               PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
            {
               g_lastChartLineKey = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
               if(g_lastChartLineKey == 0)
                  g_lastChartLineKey = posTicket;
               UpdateChartTradeLines(g_lastChartLineKey, entry, sl, tp, false);
               break;
            }
         }
      }
   }
   else
      lastStatus = "Open failed: " + trade.ResultRetcodeDescription() +
                   StringFormat(" SL=%.2f TP=%.2f dist=%.2f brokerMin=%.2f", sl, tp, slDistance, brokerMinDist);
}

//+------------------------------------------------------------------+
int BeFloorIndex(const ulong key)
{
   for(int i = 0; i < ArraySize(beFloorKeys); i++)
      if(beFloorKeys[i] == key)
         return i;
   return -1;
}

bool BeFloorIsLocked(const ulong key)
{
   return BeFloorIndex(key) >= 0;
}

void BeFloorLock(const ulong key, const double floorSL)
{
   const int idx = BeFloorIndex(key);
   if(idx >= 0)
   {
      if(floorSL > beFloorPrices[idx])
         beFloorPrices[idx] = floorSL;
      return;
   }
   const int n = ArraySize(beFloorKeys);
   ArrayResize(beFloorKeys, n + 1);
   ArrayResize(beFloorPrices, n + 1);
   beFloorKeys[n] = key;
   beFloorPrices[n] = floorSL;
}

double GetBeFloorPrice(const ulong key)
{
   const int idx = BeFloorIndex(key);
   if(idx < 0)
      return 0.0;
   return beFloorPrices[idx];
}

void PurgeBeFloorTracking()
{
   for(int i = ArraySize(beFloorKeys) - 1; i >= 0; i--)
   {
      bool open = false;
      for(int p = PositionsTotal() - 1; p >= 0; p--)
      {
         const ulong t = PositionGetTicket(p);
         if(t == 0 || !PositionSelectByTicket(t)) continue;
         if(PositionGetString(POSITION_SYMBOL) != InpTradeSymbol ||
            PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         const ulong id = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
         const ulong key = (id > 0 ? id : t);
         if(key == beFloorKeys[i])
         {
            open = true;
            break;
         }
      }
      if(!open)
      {
         const int last = ArraySize(beFloorKeys) - 1;
         if(i != last)
         {
            beFloorKeys[i] = beFloorKeys[last];
            beFloorPrices[i] = beFloorPrices[last];
         }
         ArrayResize(beFloorKeys, last);
         ArrayResize(beFloorPrices, last);
      }
   }
}
//+------------------------------------------------------------------+
int ProfitStepIndex(const ulong key)
{
   for(int i = 0; i < ArraySize(profitStepKeys); i++)
      if(profitStepKeys[i] == key)
         return i;
   return -1;
}

double GetProfitStepLockedMoney(const ulong key)
{
   const int idx = ProfitStepIndex(key);
   if(idx < 0)
      return 0.0;
   return profitStepLockedMoney[idx];
}

void UpdateProfitStepLock(const ulong key, const double moveMoney)
{
   if(!InpUseProfitStepLock || InpProfitStepUSD <= 0.0 || key == 0)
      return;

   const double tier = MathFloor(moveMoney / InpProfitStepUSD) * InpProfitStepUSD;
   if(tier < InpProfitStepUSD)
      return;

   const int idx = ProfitStepIndex(key);
   if(idx >= 0)
   {
      if(tier > profitStepLockedMoney[idx])
         profitStepLockedMoney[idx] = tier;
      return;
   }

   const int n = ArraySize(profitStepKeys);
   ArrayResize(profitStepKeys, n + 1);
   ArrayResize(profitStepLockedMoney, n + 1);
   profitStepKeys[n] = key;
   profitStepLockedMoney[n] = tier;
}

//+------------------------------------------------------------------+
double ClampStopToBroker(const bool isBuy, const double stopPrice)
{
   const double bid = SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID);
   const double ask = SymbolInfoDouble(InpTradeSymbol, SYMBOL_ASK);
   const double point = SymbolInfoDouble(InpTradeSymbol, SYMBOL_POINT);
   const double minDist = MinStopDistance() + point;
   if(isBuy)
      return NormalizePrice(MathMin(stopPrice, bid - minDist));
   return NormalizePrice(MathMax(stopPrice, ask + minDist));
}
 double ProfitStepFloorSL(const bool isBuy, const double openPrice, const double lots,
                         const double lockedMoneyUSD)
{
   if(lockedMoneyUSD <= 0.0 || lots <= 0.0)
      return 0.0;
   const double lockDist = PriceDistanceForMoney(lockedMoneyUSD, lots);
   const double rawSL = isBuy ? openPrice + lockDist : openPrice - lockDist;
   return ClampStopToBroker(isBuy, rawSL);
}

void PurgeProfitStepTracking()
{
   for(int i = ArraySize(profitStepKeys) - 1; i >= 0; i--)
   {
      bool open = false;
      for(int p = PositionsTotal() - 1; p >= 0; p--)
      {
         const ulong t = PositionGetTicket(p);
         if(t == 0 || !PositionSelectByTicket(t)) continue;
         if(PositionGetString(POSITION_SYMBOL) != InpTradeSymbol ||
            PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;
         const ulong id = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
         const ulong key = (id > 0 ? id : t);
         if(key == profitStepKeys[i])
         {
            open = true;
            break;
         }
      }
      if(!open)
      {
         const int last = ArraySize(profitStepKeys) - 1;
         if(i != last)
         {
            profitStepKeys[i] = profitStepKeys[last];
            profitStepLockedMoney[i] = profitStepLockedMoney[last];
         }
         ArrayResize(profitStepKeys, last);
         ArrayResize(profitStepLockedMoney, last);
      }
   }
}
//+------------------------------------------------------------------+
bool MomentumStillSupports(const bool isBuy)
{
   double rsi[], fast[], slow[], signalEma[];
   ArrayResize(rsi, 4);
   ArrayResize(fast, 3);
   ArrayResize(slow, 3);
   ArrayResize(signalEma, 3);
   ArraySetAsSeries(rsi, true);
   ArraySetAsSeries(fast, true);
   ArraySetAsSeries(slow, true);
   ArraySetAsSeries(signalEma, true);

   if(CopyBuffer(rsiHandle, 0, 0, 4, rsi) < 3 ||
      CopyBuffer(fastEmaHandle, 0, 0, 3, fast) < 2 ||
      CopyBuffer(slowEmaHandle, 0, 0, 3, slow) < 2 ||
      CopyBuffer(signalEmaHandle, 0, 0, 3, signalEma) < 2)
      return false;

   const double bid = SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID);
   const double ask = SymbolInfoDouble(InpTradeSymbol, SYMBOL_ASK);
   const double mid = (bid + ask) * 0.5;

   if(isBuy)
   {
      bool trendOk = fast[0] > slow[0];
      bool rsiOk = rsi[0] > 45.0 && rsi[0] < 80.0;
      bool priceAboveEma = mid > signalEma[0];
      bool rsiRising = rsi[0] > rsi[1];
      return trendOk && rsiOk && (priceAboveEma || rsiRising);
   }
   else
   {
      bool trendOk = fast[0] < slow[0];
      bool rsiOk = rsi[0] < 55.0 && rsi[0] > 20.0;
      bool priceBelowEma = mid < signalEma[0];
      bool rsiFalling = rsi[0] < rsi[1];
      return trendOk && rsiOk && (priceBelowEma || rsiFalling);
   }
}

//+------------------------------------------------------------------+
void ManageOpenPositions()
{
   const double bid = SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID);
   const double ask = SymbolInfoDouble(InpTradeSymbol, SYMBOL_ASK);
   if(bid <= 0.0 || ask <= 0.0)
   {
      if(CountMyPositions() == 0)
         ClearAllMyChartLines();
      return;
   }

   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      const ulong ticket = PositionGetTicket(i);
      if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != InpTradeSymbol ||
         PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;

      const bool isBuy = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY;
      const double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      const double currentSL = PositionGetDouble(POSITION_SL);
      const double currentTP = PositionGetDouble(POSITION_TP);
      const double profit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      const datetime openTime = (datetime)PositionGetInteger(POSITION_TIME);
      const double currentPrice = isBuy ? bid : ask;

      if(InpUseHardMoneyStop && profit <= -InpHardMaxLossUSD)
      {
         trade.PositionClose(ticket);
         RemoveChartTradeLines(ticket);
         lastStatus = "Closed: hard money stop.";
         continue;
      }

      if(InpMaxHoldMinutes > 0 && TimeCurrent() - openTime >= InpMaxHoldMinutes * 60)
      {
         if(profit >= 0.0)
         {
            bool momentumSupports = MomentumStillSupports(isBuy);
            if(momentumSupports && profit > InpBE_StartUSD)
            {
               lastStatus = StringFormat("Max hold: momentum continues, riding +$%.2f", profit);
            }
            else
            {
               trade.PositionClose(ticket);
               RemoveChartTradeLines(ticket);
               lastStatus = StringFormat("Closed: max hold (profit $%.2f).", profit);
               continue;
            }
         }
         else
         {
            bool reversing = MomentumStillSupports(isBuy);
            if(reversing)
               lastStatus = StringFormat("Max hold: in loss ($%.2f) but momentum turning, holding.", profit);
            else
            {
               trade.PositionClose(ticket);
               RemoveChartTradeLines(ticket);
               lastStatus = StringFormat("Closed: max hold + no momentum ($%.2f).", profit);
               continue;
            }
         }
      }

      if(currentSL <= 0.0) continue;

      const double lots = PositionGetDouble(POSITION_VOLUME);
      const double move = isBuy ? currentPrice - openPrice : openPrice - currentPrice;
      const double moveMoney = MoneyForPriceMove(openPrice, currentPrice, lots, isBuy);
      const double trailStartDist = PriceDistanceForMoney(InpTrailStartMoneyUSD, lots);
      const double trailDist = PriceDistanceForMoney(InpTrailDistanceMoneyUSD, lots);
      const double modifyStepDist = PriceDistanceForMoney(InpMinSLModifyMoneyUSD, lots);
      const double point = SymbolInfoDouble(InpTradeSymbol, SYMBOL_POINT);
      const ulong posKey = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
      const ulong trackKey = (posKey > 0 ? posKey : ticket);

      // --- BREAK-EVEN LOGIC (M711 fix: was missing in M710) ---
      if(InpUseBreakEven && !BeFloorIsLocked(trackKey) && profit >= InpBE_StartUSD)
      {
         const double beLockDist = PriceDistanceForMoney(InpBE_LockUSD, lots);
         const double beSL = isBuy ? openPrice + beLockDist : openPrice - beLockDist;
         const double clampedBeSL = ClampStopToBroker(isBuy, beSL);
         BeFloorLock(trackKey, clampedBeSL);
         lastStatus = StringFormat("Break-even locked at $%.2f profit, SL->%.2f", profit, clampedBeSL);
      }

      UpdateProfitStepLock(trackKey, profit);

      const double stepLockedMoney = GetProfitStepLockedMoney(trackKey);
      if(InpUseProfitStepLock && stepLockedMoney >= InpProfitStepUSD && profit < stepLockedMoney)
      {
         trade.PositionClose(ticket);
         RemoveChartTradeLines(ticket);
         lastStatus = StringFormat("Step lock exit: locked +$%.0f, profit fell to $%.2f", stepLockedMoney, profit);
         continue;
      }

      double stepFloorSL = 0.0;
      if(InpUseProfitStepLock && stepLockedMoney >= InpProfitStepUSD)
         stepFloorSL = ProfitStepFloorSL(isBuy, openPrice, lots, stepLockedMoney);

      double newSL = currentSL;
      bool trailingActive = false;

      // --- Apply break-even floor first ---
      const double beFloor = GetBeFloorPrice(trackKey);
      if(beFloor > 0.0)
      {
         if(isBuy && beFloor > newSL)
            newSL = beFloor;
         else if(!isBuy && (beFloor < newSL || newSL <= 0.0))
            newSL = beFloor;
      }

      if(stepFloorSL > 0.0)
      {
         if(isBuy && stepFloorSL > newSL)
            newSL = stepFloorSL;
         else if(!isBuy && stepFloorSL < newSL)
            newSL = stepFloorSL;
      }

      if(InpUseTrailing && profit >= InpTrailStartMoneyUSD && move >= trailStartDist)
      {
         double effectiveTrailDist = trailDist;
         if(MomentumStillSupports(isBuy) && profit > InpTrailStartMoneyUSD * 1.5)
            effectiveTrailDist = trailDist * 1.5;

         const double trailSL = isBuy ? currentPrice - effectiveTrailDist : currentPrice + effectiveTrailDist;
         if(isBuy)
         {
            if(trailSL > newSL && (stepFloorSL <= 0.0 || trailSL >= stepFloorSL - point))
            {
               newSL = trailSL;
               trailingActive = true;
            }
         }
         else
         {
            if(trailSL < newSL && (stepFloorSL <= 0.0 || trailSL <= stepFloorSL + point))
            {
               newSL = trailSL;
               trailingActive = true;
            }
         }
      }

      if(stepFloorSL > 0.0)
      {
         if(isBuy && newSL < stepFloorSL)
            newSL = stepFloorSL;
         else if(!isBuy && newSL > stepFloorSL)
            newSL = stepFloorSL;
      }

      // Enforce break-even floor as absolute minimum
      if(beFloor > 0.0)
      {
         if(isBuy && newSL < beFloor)
            newSL = beFloor;
         else if(!isBuy && newSL > beFloor)
            newSL = beFloor;
      }

      if(isBuy && newSL < currentSL)
         newSL = currentSL;
      else if(!isBuy && currentSL > 0.0 && newSL > currentSL)
         newSL = currentSL;

      newSL = NormalizePrice(newSL);

      bool forceStepModify = false;
      if(stepLockedMoney >= InpProfitStepUSD && stepFloorSL > 0.0)
      {
         if(isBuy && stepFloorSL > currentSL + point * 0.5)
            forceStepModify = true;
         else if(!isBuy && currentSL > 0.0 && stepFloorSL < currentSL - point * 0.5)
            forceStepModify = true;
      }

      // Force modify for break-even lock as well
      bool forceBeModify = false;
      if(beFloor > 0.0)
      {
         if(isBuy && beFloor > currentSL + point * 0.5)
            forceBeModify = true;
         else if(!isBuy && currentSL > 0.0 && beFloor < currentSL - point * 0.5)
            forceBeModify = true;
      }

      if(stepLockedMoney >= InpProfitStepUSD)
         lastStepLockInfo = StringFormat("Step lock: +$%.0f | target SL %.2f | broker SL %.2f | profit $%.2f",
                                         stepLockedMoney, stepFloorSL, currentSL, profit);
      else if(beFloor > 0.0)
         lastStepLockInfo = StringFormat("BE locked: SL floor %.2f | profit $%.2f", beFloor, profit);
      else if(profit > 0.0)
         lastStepLockInfo = StringFormat("Step lock: waiting +$%.0f (now +$%.2f) | BE at +$%.1f", InpProfitStepUSD, profit, InpBE_StartUSD);
      else
         lastStepLockInfo = StringFormat("Waiting profit for BE ($%.1f) | now $%.2f", InpBE_StartUSD, profit);

      if(!forceStepModify && !forceBeModify && MathAbs(newSL - currentSL) < modifyStepDist)
         continue;
      if(IsStopValid(isBuy, newSL))
      {
         if(trade.PositionModify(ticket, newSL, currentTP))
         {
            if(forceStepModify)
               lastStatus = StringFormat("Step lock applied: +$%.0f SL=%.2f", stepLockedMoney, newSL);
            else if(forceBeModify)
               lastStatus = StringFormat("Break-even applied: SL=%.2f (lock $%.2f)", newSL, InpBE_LockUSD);
         }
         else
            lastStatus = "Modify failed: " + trade.ResultRetcodeDescription() +
                         StringFormat(" SL=%.2f floor=%.2f beFloor=%.2f", newSL, stepFloorSL, beFloor);
      }
      else if(forceStepModify)
      {
         lastStatus = StringFormat("Step lock blocked by broker: SL=%.2f floor=%.2f profit=$%.2f",
                                   newSL, stepFloorSL, profit);
         if(profit < stepLockedMoney)
         {
            trade.PositionClose(ticket);
            RemoveChartTradeLines(ticket);
            lastStatus = StringFormat("Step lock exit: broker blocked SL, closed at $%.2f", profit);
            continue;
         }
      }
      else if(forceBeModify)
      {
         lastStatus = StringFormat("BE blocked by broker: SL=%.2f beFloor=%.2f profit=$%.2f",
                                   newSL, beFloor, profit);
         if(profit < 0.0)
         {
            trade.PositionClose(ticket);
            RemoveChartTradeLines(ticket);
            lastStatus = StringFormat("BE exit: broker blocked, closed at $%.2f to prevent further loss", profit);
            continue;
         }
      }

      if(InpShowTrailOnChart)
      {
         PositionSelectByTicket(ticket);
         const double chartSL = PositionGetDouble(POSITION_SL);
         g_lastChartLineKey = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
         if(g_lastChartLineKey == 0)
            g_lastChartLineKey = ticket;
         UpdateChartTradeLines(g_lastChartLineKey, openPrice, chartSL, currentTP, trailingActive);
      }
   }

   CleanupOrphanChartLines();
   PurgeBeFloorTracking();
   PurgeProfitStepTracking();
}

//+------------------------------------------------------------------+
double GetMyFloatingProfit()
{
   double sum = 0.0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      const ulong ticket = PositionGetTicket(i);
      if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) == InpTradeSymbol &&
         PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
         sum += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
   }
   return sum;
}

double GetMyDayProfit() { return todayProfit + GetMyFloatingProfit(); }

bool CheckDailyCircuitBreakers()
{
   if(InpDisableDayStop) { dayStopped = false; return true; }
   UpdateTodayStats();
   const double dayProfit = GetMyDayProfit();
   if(dayProfit > myDayPeakProfit) myDayPeakProfit = dayProfit;
   if(InpUseDailyTarget && dayProfit >= InpDailyTargetUSD)
   { CloseAllPositions(); dayStopped = true; lastStatus = "Stopped: daily target."; return false; }
   if(InpUseDailyLossLimit && dayProfit <= -InpDailyMaxLossUSD)
   { CloseAllPositions(); dayStopped = true; lastStatus = "Stopped: daily max loss."; return false; }
   if(InpUseEquityProfitLock && myDayPeakProfit - dayProfit >= InpEquityGivebackFromPeakUSD)
   { CloseAllPositions(); dayStopped = true; lastStatus = "Stopped: equity lock."; return false; }
   return true;
}

void ResetDailyIfNeeded()
{
   static datetime currentDay = 0;
   const datetime dayStart = GetDayStart(TimeCurrent());
   if(currentDay == dayStart) return;
   currentDay = dayStart;
   todayTrades = 0; todayLosses = 0; todayProfit = 0.0; myDayPeakProfit = 0.0;
   lastLossTime = 0; dayStopped = false; lastStatus = "New trading day.";
}

void UpdateTodayStats()
{
   todayTrades = 0; todayLosses = 0; todayProfit = 0.0; lastLossTime = 0;
   if(!HistorySelect(GetDayStart(TimeCurrent()), TimeCurrent())) return;
   for(int i = 0; i < HistoryDealsTotal(); i++)
   {
      const ulong dealTicket = HistoryDealGetTicket(i);
      if(dealTicket == 0) continue;
      if(HistoryDealGetString(dealTicket, DEAL_SYMBOL) != InpTradeSymbol ||
         HistoryDealGetInteger(dealTicket, DEAL_MAGIC) != InpMagicNumber ||
         HistoryDealGetInteger(dealTicket, DEAL_ENTRY) != DEAL_ENTRY_OUT) continue;
      const double profit = HistoryDealGetDouble(dealTicket, DEAL_PROFIT)
                          + HistoryDealGetDouble(dealTicket, DEAL_SWAP)
                          + HistoryDealGetDouble(dealTicket, DEAL_COMMISSION);
      const datetime dealTime = (datetime)HistoryDealGetInteger(dealTicket, DEAL_TIME);
      todayTrades++; todayProfit += profit;
      if(profit < 0.0) { todayLosses++; if(dealTime > lastLossTime) lastLossTime = dealTime; }
   }
}

int CountMyPositions()
{
   int count = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      const ulong ticket = PositionGetTicket(i);
      if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) == InpTradeSymbol &&
         PositionGetInteger(POSITION_MAGIC) == InpMagicNumber) count++;
   }
   return count;
}

void CloseAllPositions()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      const ulong ticket = PositionGetTicket(i);
      if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) == InpTradeSymbol &&
         PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
         trade.PositionClose(ticket);
   }
}

bool IsTradingSession()
{
   if(InpTrade24Hours)
      return true;

   MqlDateTime dt; TimeToStruct(TimeCurrent(), dt);
   if(!InpTradeWeekends && (dt.day_of_week == 0 || dt.day_of_week == 6)) return false;
   if(InpSkipFridayLate && dt.day_of_week == 5 && dt.hour >= InpFridayStopHour) return false;
   bool ok = false;
   if(InpTradeAsia && InHourWindow(dt.hour, InpAsiaStart, InpAsiaEnd)) ok = true;
   if(InpTradeLondon && InHourWindow(dt.hour, InpLondonStart, InpLondonEnd)) ok = true;
   if(InpTradeOverlap && InHourWindow(dt.hour, InpOverlapStart, InpOverlapEnd)) ok = true;
   if(InpTradeNYLate && InHourWindow(dt.hour, InpNYLateStart, InpNYLateEnd)) ok = true;
   return ok;
}

bool InHourWindow(int hour, int startHour, int endHour)
{
   startHour = MathMax(0, MathMin(23, startHour));
   endHour = MathMax(0, MathMin(24, endHour));
   if(startHour == endHour) return true;
   if(startHour < endHour) return hour >= startHour && hour < endHour;
   return hour >= startHour || hour < endHour;
}

bool IsNewsTimeBlock()
{
   if(!InpUseNewsTimeBlock || StringLen(InpNewsBlockWindows) == 0) return false;
   MqlDateTime dt; TimeToStruct(TimeCurrent(), dt);
   const int nowMinutes = dt.hour * 60 + dt.min;
   string windows[];
   const int count = StringSplit(InpNewsBlockWindows, ';', windows);
   for(int i = 0; i < count; i++)
   {
      string parts[];
      if(StringSplit(windows[i], '-', parts) != 2) continue;
      const int startMinutes = ParseHHMM(parts[0]);
      const int endMinutes = ParseHHMM(parts[1]);
      if(startMinutes < 0 || endMinutes < 0) continue;
      if(startMinutes <= endMinutes)
      { if(nowMinutes >= startMinutes && nowMinutes <= endMinutes) return true; }
      else
      { if(nowMinutes >= startMinutes || nowMinutes <= endMinutes) return true; }
   }
   return false;
}

int ParseHHMM(string value)
{
   StringTrimLeft(value); StringTrimRight(value);
   string parts[];
   if(StringSplit(value, ':', parts) != 2) return -1;
   const int hour = (int)StringToInteger(parts[0]);
   const int minute = (int)StringToInteger(parts[1]);
   if(hour < 0 || hour > 23 || minute < 0 || minute > 59) return -1;
   return hour * 60 + minute;
}

bool IsNewSignalBar()
{
   const datetime barTime = iTime(InpTradeSymbol, InpSignalTF, 0);
   if(barTime == 0 || barTime == lastSignalBarTime) return false;
   lastSignalBarTime = barTime;
   return true;
}

datetime GetDayStart(const datetime value)
{
   MqlDateTime dt; TimeToStruct(value, dt);
   dt.hour = 0; dt.min = 0; dt.sec = 0;
   return StructToTime(dt);
}

int GetSpreadPoints()
{
   const double ask = SymbolInfoDouble(InpTradeSymbol, SYMBOL_ASK);
   const double bid = SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID);
   const double point = SymbolInfoDouble(InpTradeSymbol, SYMBOL_POINT);
   if(ask <= 0.0 || bid <= 0.0 || point <= 0.0) return 999999;
   return (int)MathRound((ask - bid) / point);
}

double MinStopDistance()
{
   const double point = SymbolInfoDouble(InpTradeSymbol, SYMBOL_POINT);
   const int stopsLevel = (int)SymbolInfoInteger(InpTradeSymbol, SYMBOL_TRADE_STOPS_LEVEL);
   const int freezeLevel = (int)SymbolInfoInteger(InpTradeSymbol, SYMBOL_TRADE_FREEZE_LEVEL);
   return MathMax(stopsLevel, freezeLevel) * point;
}

bool IsStopValid(const bool isBuy, const double stopPrice)
{
   const double bid = SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID);
   const double ask = SymbolInfoDouble(InpTradeSymbol, SYMBOL_ASK);
   const double minDistance = MinStopDistance();
   if(isBuy) return stopPrice < bid - minDistance;
   return stopPrice > ask + minDistance;
}

double NormalizePrice(const double price)
{
   return NormalizeDouble(price, (int)SymbolInfoInteger(InpTradeSymbol, SYMBOL_DIGITS));
}

double NormalizeLots(const double requestedLots)
{
   const double volumeMin = SymbolInfoDouble(InpTradeSymbol, SYMBOL_VOLUME_MIN);
   const double volumeMax = SymbolInfoDouble(InpTradeSymbol, SYMBOL_VOLUME_MAX);
   const double volumeStep = SymbolInfoDouble(InpTradeSymbol, SYMBOL_VOLUME_STEP);
   if(requestedLots <= 0.0 || volumeStep <= 0.0) return 0.0;
   double lots = MathFloor(requestedLots / volumeStep) * volumeStep;
   lots = MathMax(volumeMin, MathMin(volumeMax, lots));
   return NormalizeDouble(lots, GetVolumeDigits(volumeStep));
}

int GetVolumeDigits(const double volumeStep)
{
   if(volumeStep <= 0.0) return 2;
   int digits = 0; double step = volumeStep;
   while(digits < 8 && MathAbs(step - MathRound(step)) > 0.00000001) { step *= 10.0; digits++; }
   return digits;
}

//+------------------------------------------------------------------+
double PriceDistanceForMoney(const double moneyUSD, const double lots)
{
   if(moneyUSD <= 0.0 || lots <= 0.0)
      return 1.0;

   double tickValue = 0.0, tickSize = 0.0;
   if(SymbolInfoDouble(InpTradeSymbol, SYMBOL_TRADE_TICK_VALUE, tickValue) &&
      SymbolInfoDouble(InpTradeSymbol, SYMBOL_TRADE_TICK_SIZE, tickSize) &&
      tickValue > 0.0 && tickSize > 0.0)
   {
      const double moneyPerPriceUnit = (tickValue / tickSize) * lots;
      if(moneyPerPriceUnit > 0.0)
         return moneyUSD / moneyPerPriceUnit;
   }

   const double bid = SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID);
   const double point = SymbolInfoDouble(InpTradeSymbol, SYMBOL_POINT);
   if(bid <= 0.0 || point <= 0.0)
      return 1.0;

   double calcProfit = 0.0;
   const double probe = MathMax(point * 10.0, 0.01);
   if(OrderCalcProfit(ORDER_TYPE_BUY, InpTradeSymbol, lots, bid, bid - probe, calcProfit))
   {
      const double lossPerUnit = MathAbs(calcProfit) / probe;
      if(lossPerUnit > 0.0)
         return moneyUSD / lossPerUnit;
   }

   return moneyUSD / MathMax(lots * point * 100.0, 1.0);
}

//+------------------------------------------------------------------+
double MinBrokerStopDistance(const double lots)
{
   const double point = SymbolInfoDouble(InpTradeSymbol, SYMBOL_POINT);
   const double ask = SymbolInfoDouble(InpTradeSymbol, SYMBOL_ASK);
   const double bid = SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID);
   const double spreadDist = (ask > bid) ? (ask - bid) : (GetSpreadPoints() * point);
   const double stopsDist = MinStopDistance();
   const double moneyDist = PriceDistanceForMoney(InpMinSL_MoneyUSD, lots);
   const double spreadFloor = spreadDist * 2.0 + point;
   return MathMax(MathMax(stopsDist + point, spreadFloor), moneyDist);
}

//+------------------------------------------------------------------+
bool IsTakeProfitValid(const bool isBuy, const double tpPrice, const double lots)
{
   if(tpPrice <= 0.0)
      return false;
   const double bid = SymbolInfoDouble(InpTradeSymbol, SYMBOL_BID);
   const double ask = SymbolInfoDouble(InpTradeSymbol, SYMBOL_ASK);
   const double minDistance = MinBrokerStopDistance(lots);
   if(isBuy) return tpPrice > ask + minDistance;
   return tpPrice < bid - minDistance;
}

//+------------------------------------------------------------------+
void EnsureValidStops(const int direction, const double entry, const double lots,
                      double &sl, double &tp)
{
   const double brokerMin = MinBrokerStopDistance(lots);
   const double tpMin = MathMax(brokerMin * InpMinRewardRisk, PriceDistanceForMoney(InpMinTP_MoneyUSD, lots));

   if(direction > 0)
   {
      if(!IsStopValid(true, sl))
         sl = NormalizePrice(entry - brokerMin);
      if(!IsTakeProfitValid(true, tp, lots))
         tp = NormalizePrice(entry + tpMin);
   }
   else
   {
      if(!IsStopValid(false, sl))
         sl = NormalizePrice(entry + brokerMin);
      if(!IsTakeProfitValid(false, tp, lots))
         tp = NormalizePrice(entry - tpMin);
   }
}

//+------------------------------------------------------------------+
double MoneyForPriceMove(const double openPrice, const double closePrice, const double lots, const bool isBuy)
{
   if(lots <= 0.0)
      return 0.0;

   double profit = 0.0;
   if(isBuy)
      OrderCalcProfit(ORDER_TYPE_BUY, InpTradeSymbol, lots, openPrice, closePrice, profit);
   else
      OrderCalcProfit(ORDER_TYPE_SELL, InpTradeSymbol, lots, openPrice, closePrice, profit);

   return profit;
}

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
int ChartPriceDigits()
{
   return (int)SymbolInfoInteger(InpTradeSymbol, SYMBOL_DIGITS);
}

//+------------------------------------------------------------------+
string FormatPriceLabel(const string tag, const double price)
{
   return tag + "  " + DoubleToString(price, ChartPriceDigits());
}

//+------------------------------------------------------------------+
ulong TicketFromChartName(const string name)
{
   string parts[];
   const int n = StringSplit(name, '_', parts);
   if(n < 1)
      return 0;
   return (ulong)StringToInteger(parts[n - 1]);
}

//+------------------------------------------------------------------+
bool IsTradeChartObjectName(const string name)
{
   if(StringLen(name) < 6)
      return false;
   if(StringGetCharacter(name, 0) != 'M')
      return false;

   int pos = 1;
   while(pos < StringLen(name))
   {
      const ushort ch = StringGetCharacter(name, pos);
      if(ch >= '0' && ch <= '9')
      {
         pos++;
         continue;
      }
      break;
   }
   if(pos < 2 || pos >= StringLen(name) || StringGetCharacter(name, pos) != '_')
      return false;

   return (StringFind(name, "_EN_") > 0 || StringFind(name, "_SL_") > 0 || StringFind(name, "_TP_") > 0);
}

//+------------------------------------------------------------------+
void PurgeAllTradeChartObjects()
{
   for(int i = ObjectsTotal(0, 0, -1) - 1; i >= 0; i--)
   {
      const string name = ObjectName(0, i, 0, -1);
      if(IsTradeChartObjectName(name))
         ObjectDelete(0, name);
   }
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
bool IsActivePositionChartKey(const ulong key)
{
   if(key == 0)
      return false;
   for(int p = PositionsTotal() - 1; p >= 0; p--)
   {
      const ulong posTicket = PositionGetTicket(p);
      if(posTicket == 0 || !PositionSelectByTicket(posTicket))
         continue;
      if(PositionGetString(POSITION_SYMBOL) != InpTradeSymbol ||
         PositionGetInteger(POSITION_MAGIC) != InpMagicNumber)
         continue;
      const ulong posId = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
      if(key == posId || key == posTicket)
         return true;
   }
   return false;
}
//+------------------------------------------------------------------+
string ChartObjName(const string prefix, const ulong ticket)
{
   return "M714_" + prefix + "_" + IntegerToString(ticket);
}

//+------------------------------------------------------------------+
string ChartLblName(const string prefix, const ulong ticket)
{
   return "M714_" + prefix + "_LBL_" + IntegerToString(ticket);
}

//+------------------------------------------------------------------+
void EnsureHLine(const string name, const double price, const color clr,
                 const ENUM_LINE_STYLE style, const int width)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_HLINE, 0, 0, price);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
   }

   ObjectSetDouble(0, name, OBJPROP_PRICE, price);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_STYLE, style);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, width);
}

//+------------------------------------------------------------------+
void EnsureRightPriceLabel(const string name, const double price, const string text, const color clr)
{
   int x = 0, y = 0;
   const datetime t = iTime(_Symbol, _Period, 0);
   if(t == 0 || !ChartTimePriceToXY(0, 0, t, price, x, y))
      return;

   const int chartW = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   int xPos = chartW - 6;
   if(xPos < 20)
      xPos = 20;

   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_ZORDER, 100);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_RIGHT);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 10);
      ObjectSetString(0, name, OBJPROP_FONT, "Arial Bold");
   }

   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, xPos);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y - 9);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
}

//+------------------------------------------------------------------+
void UpdateChartTradeLines(const ulong ticket, const double entry, const double sl,
                           const double tp, const bool trailingActive)
{
   if(!InpShowTrailOnChart || ticket == 0)
      return;

   PurgeAllTradeChartObjects();

   const string enName = ChartObjName("EN", ticket);
   const string enLbl = ChartLblName("EN", ticket);
   const string tpName = ChartObjName("TP", ticket);
   const string tpLbl = ChartLblName("TP", ticket);
   const string slName = ChartObjName("SL", ticket);
   const string slLbl = ChartLblName("SL", ticket);

   EnsureHLine(enName, entry, clrDodgerBlue, STYLE_DOT, 1);
   EnsureRightPriceLabel(enLbl, entry, FormatPriceLabel("ENTRY", entry), clrDodgerBlue);

   if(tp > 0.0)
   {
      EnsureHLine(tpName, tp, clrLimeGreen, STYLE_DOT, 1);
      EnsureRightPriceLabel(tpLbl, tp, FormatPriceLabel("TP", tp), clrLimeGreen);
   }

   const string slTag = trailingActive ? "TRAIL SL" : "SL";
   const color slClr = trailingActive ? clrOrange : clrRed;
   const ENUM_LINE_STYLE slStyle = trailingActive ? STYLE_SOLID : STYLE_DASH;
   EnsureHLine(slName, sl, slClr, slStyle, 2);
   EnsureRightPriceLabel(slLbl, sl, FormatPriceLabel(slTag, sl), slClr);

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
void RemoveChartTradeLines(const ulong ticket)
{
   ObjectDelete(0, ChartObjName("SL", ticket));
   ObjectDelete(0, ChartLblName("SL", ticket));
   ObjectDelete(0, ChartObjName("EN", ticket));
   ObjectDelete(0, ChartLblName("EN", ticket));
   ObjectDelete(0, ChartObjName("TP", ticket));
   ObjectDelete(0, ChartLblName("TP", ticket));
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
void ClearAllMyChartLines()
{
   PurgeAllTradeChartObjects();
}

//+------------------------------------------------------------------+
bool IsLegacyTradeChartName(const string name)
{
   return IsTradeChartObjectName(name);
}

//+------------------------------------------------------------------+
void CleanupOrphanChartLines()
{
   if(CountMyPositions() == 0)
   {
      ClearAllMyChartLines();
      return;
   }

   if(!InpShowTrailOnChart)
      return;

   for(int i = ObjectsTotal(0, 0, -1) - 1; i >= 0; i--)
   {
      const string name = ObjectName(0, i, 0, -1);
      if(!IsLegacyTradeChartName(name))
         continue;

      const ulong key = TicketFromChartName(name);
      if(!IsActivePositionChartKey(key))
         ObjectDelete(0, name);
   }
   ChartRedraw(0);
}

void ShowDashboard()
{
   if(!InpShowDashboard) return;
   UpdateTodayStats();
   const double dayProfit = GetMyDayProfit();
   string text = "";
   text += "=== BTCUSD M714 Tight Entry + $10 Lock ===\n";
   text += "Lot: " + DoubleToString(NormalizeLots(InpLots), 2);
   text += " | Max loss: $" + DoubleToString(InpDailyMaxLossUSD, 2) + "\n";
   text += "EA P/L: $" + DoubleToString(dayProfit, 2);
   text += " | Trades: " + IntegerToString(todayTrades) + "/" + IntegerToString(InpMaxTradesPerDay);
   text += " | Losses: " + IntegerToString(todayLosses) + "/" + IntegerToString(InpMaxLossesPerDay) + "\n";
   text += "Spread: " + IntegerToString(GetSpreadPoints()) + "/" + IntegerToString(InpMaxSpreadPoints);
   text += " | Session: " + (IsTradingSession() ? "OPEN" : "CLOSED") + "\n";
   text += "BE: $" + DoubleToString(InpBE_StartUSD, 1) + " lock $" + DoubleToString(InpBE_LockUSD, 1);
   text += " | Trail: $" + DoubleToString(InpTrailDistanceMoneyUSD, 1) + " | Step: $" + DoubleToString(InpProfitStepUSD, 0) + " | Streak: " + IntegerToString(consecutiveLosses) + "\n";
   text += lastStepLockInfo + "\n";
   text += "Status: " + lastStatus + "\n";
   text += "Path: " + lastEntryPath + " | Signal: " + lastSignal + "\n";
   Comment(text);
}
//+------------------------------------------------------------------+
