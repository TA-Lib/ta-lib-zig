//! Zig wrapper for TA-Lib.
//!
//! Batch functions (`MOM`, `MACD`, ...) compute an indicator over a whole
//! series; `stream` has an incremental, bar-at-a-time type for each of them.

const std = @import("std");
const common = @import("common.zig");
const func = @import("func.zig");

pub const stream = @import("stream.zig");

pub const MAType = common.MAType;
pub const FuncUnstId = common.FuncUnstId;
pub const UNSTABLE_AUTO_PREC_4 = common.UNSTABLE_AUTO_PREC_4;
pub const UNSTABLE_AUTO_PREC_8 = common.UNSTABLE_AUTO_PREC_8;
pub const setUnstablePeriod = common.setUnstablePeriod;
pub const getUnstablePeriod = common.getUnstablePeriod;
pub const RangeType = common.RangeType;
pub const CandleSettingType = common.CandleSettingType;
pub const setCandleSettings = common.setCandleSettings;
pub const restoreCandleDefaultSettings = common.restoreCandleDefaultSettings;
pub const TAError = common.TAError;
pub const initialize = common.initialize;
pub const shutdown = common.shutdown;
pub const version = common.version;

// BEGIN GENERATED FUNCTIONS (tools/generate_func.py)
pub const AC = func.AC;
pub const ACCBANDS = func.ACCBANDS;
pub const ACOS = func.ACOS;
pub const AD = func.AD;
pub const ADD = func.ADD;
pub const ADOSC = func.ADOSC;
pub const ADR = func.ADR;
pub const ADX = func.ADX;
pub const ADXR = func.ADXR;
pub const ALMA = func.ALMA;
pub const AO = func.AO;
pub const APO = func.APO;
pub const AROON = func.AROON;
pub const AROONOSC = func.AROONOSC;
pub const ASI = func.ASI;
pub const ASIN = func.ASIN;
pub const ATAN = func.ATAN;
pub const ATR = func.ATR;
pub const AVGDEV = func.AVGDEV;
pub const AVGPRICE = func.AVGPRICE;
pub const BBANDS = func.BBANDS;
pub const BBW = func.BBW;
pub const BETA = func.BETA;
pub const BOP = func.BOP;
pub const CCI = func.CCI;
pub const CDL2CROWS = func.CDL2CROWS;
pub const CDL3BLACKCROWS = func.CDL3BLACKCROWS;
pub const CDL3INSIDE = func.CDL3INSIDE;
pub const CDL3LINESTRIKE = func.CDL3LINESTRIKE;
pub const CDL3OUTSIDE = func.CDL3OUTSIDE;
pub const CDL3STARSINSOUTH = func.CDL3STARSINSOUTH;
pub const CDL3WHITESOLDIERS = func.CDL3WHITESOLDIERS;
pub const CDLABANDONEDBABY = func.CDLABANDONEDBABY;
pub const CDLADVANCEBLOCK = func.CDLADVANCEBLOCK;
pub const CDLBELTHOLD = func.CDLBELTHOLD;
pub const CDLBREAKAWAY = func.CDLBREAKAWAY;
pub const CDLCLOSINGMARUBOZU = func.CDLCLOSINGMARUBOZU;
pub const CDLCONCEALBABYSWALL = func.CDLCONCEALBABYSWALL;
pub const CDLCOUNTERATTACK = func.CDLCOUNTERATTACK;
pub const CDLDARKCLOUDCOVER = func.CDLDARKCLOUDCOVER;
pub const CDLDOJI = func.CDLDOJI;
pub const CDLDOJISTAR = func.CDLDOJISTAR;
pub const CDLDRAGONFLYDOJI = func.CDLDRAGONFLYDOJI;
pub const CDLENGULFING = func.CDLENGULFING;
pub const CDLEVENINGDOJISTAR = func.CDLEVENINGDOJISTAR;
pub const CDLEVENINGSTAR = func.CDLEVENINGSTAR;
pub const CDLGAPSIDESIDEWHITE = func.CDLGAPSIDESIDEWHITE;
pub const CDLGRAVESTONEDOJI = func.CDLGRAVESTONEDOJI;
pub const CDLHAMMER = func.CDLHAMMER;
pub const CDLHANGINGMAN = func.CDLHANGINGMAN;
pub const CDLHARAMI = func.CDLHARAMI;
pub const CDLHARAMICROSS = func.CDLHARAMICROSS;
pub const CDLHIGHWAVE = func.CDLHIGHWAVE;
pub const CDLHIKKAKE = func.CDLHIKKAKE;
pub const CDLHIKKAKEMOD = func.CDLHIKKAKEMOD;
pub const CDLHOMINGPIGEON = func.CDLHOMINGPIGEON;
pub const CDLIDENTICAL3CROWS = func.CDLIDENTICAL3CROWS;
pub const CDLINNECK = func.CDLINNECK;
pub const CDLINVERTEDHAMMER = func.CDLINVERTEDHAMMER;
pub const CDLKICKING = func.CDLKICKING;
pub const CDLKICKINGBYLENGTH = func.CDLKICKINGBYLENGTH;
pub const CDLLADDERBOTTOM = func.CDLLADDERBOTTOM;
pub const CDLLONGLEGGEDDOJI = func.CDLLONGLEGGEDDOJI;
pub const CDLLONGLINE = func.CDLLONGLINE;
pub const CDLMARUBOZU = func.CDLMARUBOZU;
pub const CDLMATCHINGLOW = func.CDLMATCHINGLOW;
pub const CDLMATHOLD = func.CDLMATHOLD;
pub const CDLMORNINGDOJISTAR = func.CDLMORNINGDOJISTAR;
pub const CDLMORNINGSTAR = func.CDLMORNINGSTAR;
pub const CDLONNECK = func.CDLONNECK;
pub const CDLPIERCING = func.CDLPIERCING;
pub const CDLRICKSHAWMAN = func.CDLRICKSHAWMAN;
pub const CDLRISEFALL3METHODS = func.CDLRISEFALL3METHODS;
pub const CDLSEPARATINGLINES = func.CDLSEPARATINGLINES;
pub const CDLSHOOTINGSTAR = func.CDLSHOOTINGSTAR;
pub const CDLSHORTLINE = func.CDLSHORTLINE;
pub const CDLSPINNINGTOP = func.CDLSPINNINGTOP;
pub const CDLSTALLEDPATTERN = func.CDLSTALLEDPATTERN;
pub const CDLSTICKSANDWICH = func.CDLSTICKSANDWICH;
pub const CDLTAKURI = func.CDLTAKURI;
pub const CDLTASUKIGAP = func.CDLTASUKIGAP;
pub const CDLTHRUSTING = func.CDLTHRUSTING;
pub const CDLTRISTAR = func.CDLTRISTAR;
pub const CDLUNIQUE3RIVER = func.CDLUNIQUE3RIVER;
pub const CDLUPSIDEGAP2CROWS = func.CDLUPSIDEGAP2CROWS;
pub const CDLXSIDEGAP3METHODS = func.CDLXSIDEGAP3METHODS;
pub const CEIL = func.CEIL;
pub const CG = func.CG;
pub const CHOP = func.CHOP;
pub const CHOPTR = func.CHOPTR;
pub const CKSP = func.CKSP;
pub const CMF = func.CMF;
pub const CMO = func.CMO;
pub const CMOU = func.CMOU;
pub const COPPOCK = func.COPPOCK;
pub const CORREL = func.CORREL;
pub const COS = func.COS;
pub const COSH = func.COSH;
pub const CRSI = func.CRSI;
pub const CTI = func.CTI;
pub const CUMSUM = func.CUMSUM;
pub const CVI = func.CVI;
pub const DEMA = func.DEMA;
pub const DIV = func.DIV;
pub const DONCHIAN = func.DONCHIAN;
pub const DOSC = func.DOSC;
pub const DPO = func.DPO;
pub const DX = func.DX;
pub const EFI = func.EFI;
pub const EMA = func.EMA;
pub const EMV = func.EMV;
pub const ER = func.ER;
pub const ERI = func.ERI;
pub const EXP = func.EXP;
pub const FISHER = func.FISHER;
pub const FLOOR = func.FLOOR;
pub const FOSC = func.FOSC;
pub const FRACTAL = func.FRACTAL;
pub const FRAMA = func.FRAMA;
pub const HA = func.HA;
pub const HMA = func.HMA;
pub const HT_DCPERIOD = func.HT_DCPERIOD;
pub const HT_DCPHASE = func.HT_DCPHASE;
pub const HT_PHASOR = func.HT_PHASOR;
pub const HT_SINE = func.HT_SINE;
pub const HT_TRENDLINE = func.HT_TRENDLINE;
pub const HT_TRENDMODE = func.HT_TRENDMODE;
pub const IBS = func.IBS;
pub const ICHIMOKU = func.ICHIMOKU;
pub const IMI = func.IMI;
pub const KAMA = func.KAMA;
pub const KC = func.KC;
pub const KDJ = func.KDJ;
pub const KST = func.KST;
pub const KSTEXT = func.KSTEXT;
pub const KURTOSIS = func.KURTOSIS;
pub const KVO = func.KVO;
pub const LINEARREG = func.LINEARREG;
pub const LINEARREG_ANGLE = func.LINEARREG_ANGLE;
pub const LINEARREG_INTERCEPT = func.LINEARREG_INTERCEPT;
pub const LINEARREG_SLOPE = func.LINEARREG_SLOPE;
pub const LN = func.LN;
pub const LOG10 = func.LOG10;
pub const MA = func.MA;
pub const MACD = func.MACD;
pub const MACDEXT = func.MACDEXT;
pub const MACDFIX = func.MACDFIX;
pub const MAMA = func.MAMA;
pub const MARKETFI = func.MARKETFI;
pub const MASSI = func.MASSI;
pub const MAVP = func.MAVP;
pub const MAX = func.MAX;
pub const MAXINDEX = func.MAXINDEX;
pub const MCGD = func.MCGD;
pub const MEDIAN = func.MEDIAN;
pub const MEDPRICE = func.MEDPRICE;
pub const MFI = func.MFI;
pub const MIDPOINT = func.MIDPOINT;
pub const MIDPRICE = func.MIDPRICE;
pub const MIN = func.MIN;
pub const MININDEX = func.MININDEX;
pub const MINMAX = func.MINMAX;
pub const MINMAXINDEX = func.MINMAXINDEX;
pub const MINUS_DI = func.MINUS_DI;
pub const MINUS_DM = func.MINUS_DM;
pub const MOM = func.MOM;
pub const MULT = func.MULT;
pub const NATR = func.NATR;
pub const NVI = func.NVI;
pub const OBV = func.OBV;
pub const PERCENTB = func.PERCENTB;
pub const PERCENTILE = func.PERCENTILE;
pub const PERCENTRANK = func.PERCENTRANK;
pub const PLUS_DI = func.PLUS_DI;
pub const PLUS_DM = func.PLUS_DM;
pub const PPO = func.PPO;
pub const PSO = func.PSO;
pub const PVI = func.PVI;
pub const PVO = func.PVO;
pub const PVT = func.PVT;
pub const QSTICK = func.QSTICK;
pub const RMA = func.RMA;
pub const ROC = func.ROC;
pub const ROCP = func.ROCP;
pub const ROCR = func.ROCR;
pub const ROCR100 = func.ROCR100;
pub const ROGERSSATCHELL = func.ROGERSSATCHELL;
pub const RSI = func.RSI;
pub const RVI = func.RVI;
pub const RVIR = func.RVIR;
pub const RVOL = func.RVOL;
pub const SAR = func.SAR;
pub const SAREXT = func.SAREXT;
pub const SI = func.SI;
pub const SIN = func.SIN;
pub const SINH = func.SINH;
pub const SMA = func.SMA;
pub const SMI = func.SMI;
pub const SQRT = func.SQRT;
pub const SQZMOM = func.SQZMOM;
pub const STC = func.STC;
pub const STDDEV = func.STDDEV;
pub const STOCH = func.STOCH;
pub const STOCHF = func.STOCHF;
pub const STOCHRSI = func.STOCHRSI;
pub const SUB = func.SUB;
pub const SUM = func.SUM;
pub const SUPERTREND = func.SUPERTREND;
pub const SWAK_2PHP = func.SWAK_2PHP;
pub const SWAK_BP = func.SWAK_BP;
pub const SWAK_BUTTER = func.SWAK_BUTTER;
pub const SWAK_GAUSS = func.SWAK_GAUSS;
pub const SWAK_HP = func.SWAK_HP;
pub const T3 = func.T3;
pub const TAN = func.TAN;
pub const TANH = func.TANH;
pub const TEMA = func.TEMA;
pub const TRANGE = func.TRANGE;
pub const TRIMA = func.TRIMA;
pub const TRIX = func.TRIX;
pub const TSF = func.TSF;
pub const TSI = func.TSI;
pub const TYPPRICE = func.TYPPRICE;
pub const ULTOSC = func.ULTOSC;
pub const VAR = func.VAR;
pub const VHF = func.VHF;
pub const VIDYA = func.VIDYA;
pub const VORTEX = func.VORTEX;
pub const VWAP = func.VWAP;
pub const VWMA = func.VWMA;
pub const WAD = func.WAD;
pub const WAVETREND = func.WAVETREND;
pub const WCLPRICE = func.WCLPRICE;
pub const WILLR = func.WILLR;
pub const WMA = func.WMA;
pub const ZIGZAG = func.ZIGZAG;
pub const ZLEMA = func.ZLEMA;
// END GENERATED FUNCTIONS

// Tests
test "MOM indicator basic test" {
    const allocator = std.testing.allocator;

    // Sample data
    const prices = [_]f64{ 100.0, 102.0, 101.0, 103.0, 105.0, 104.0, 106.0, 108.0, 107.0, 109.0 };

    // Calculate MOM with period 3
    const result = try MOM(allocator, &prices, 3);
    defer allocator.free(result);

    // Check that output array has same length as input
    try std.testing.expectEqual(prices.len, result.len);

    // First 3 values should be NaN (lookback period)
    try std.testing.expect(std.math.isNan(result[0]));
    try std.testing.expect(std.math.isNan(result[1]));
    try std.testing.expect(std.math.isNan(result[2]));

    // First MOM value at index 3: 103.0 - 100.0 = 3.0
    try std.testing.expectApproxEqAbs(@as(f64, 3.0), result[3], 0.0001);
}

test "MA indicator with SMA" {
    const allocator = std.testing.allocator;

    // Sample data
    const prices = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0 };

    // Calculate SMA with period 3
    const result = try SMA(allocator, &prices, 3);
    defer allocator.free(result);

    // Check that output array has same length as input
    try std.testing.expectEqual(prices.len, result.len);

    // First 2 values should be NaN (lookback period for SMA with period 3)
    try std.testing.expect(std.math.isNan(result[0]));
    try std.testing.expect(std.math.isNan(result[1]));

    // SMA[2] = (1+2+3)/3 = 2.0
    // SMA[3] = (2+3+4)/3 = 3.0
    // SMA[4] = (3+4+5)/3 = 4.0
    try std.testing.expectApproxEqAbs(@as(f64, 2.0), result[2], 0.0001);
    try std.testing.expectApproxEqAbs(@as(f64, 3.0), result[3], 0.0001);
    try std.testing.expectApproxEqAbs(@as(f64, 4.0), result[4], 0.0001);
}

test "MA indicator with EMA" {
    const allocator = std.testing.allocator;

    // Sample data
    const prices = [_]f64{ 100.0, 102.0, 101.0, 103.0, 105.0, 104.0, 106.0, 108.0, 107.0, 109.0 };

    // Calculate EMA with period 5
    const result = try EMA(allocator, &prices, 5);
    defer allocator.free(result);

    // Check that output array has same length as input
    try std.testing.expectEqual(prices.len, result.len);

    // First 4 values should be NaN (lookback period for EMA with period 5)
    try std.testing.expect(std.math.isNan(result[0]));
    try std.testing.expect(std.math.isNan(result[1]));
    try std.testing.expect(std.math.isNan(result[2]));
    try std.testing.expect(std.math.isNan(result[3]));

    // EMA has different calculation than SMA
    // The multiplier for 5-period EMA is 2/(5+1) = 0.333...
    // First EMA value is the SMA of first 5 values
    const first_sma = (100.0 + 102.0 + 101.0 + 103.0 + 105.0) / 5.0; // = 102.2
    try std.testing.expectApproxEqAbs(first_sma, result[4], 0.01);
}

test "MOM indicator with different period" {
    const allocator = std.testing.allocator;

    // Sample data - ascending sequence
    const prices = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0 };

    // Calculate MOM with period 5
    const result = try MOM(allocator, &prices, 5);
    defer allocator.free(result);

    // Check that output array has same length as input
    try std.testing.expectEqual(prices.len, result.len);

    // First 5 values should be NaN (lookback period)
    for (0..5) |i| {
        try std.testing.expect(std.math.isNan(result[i]));
    }

    // Each MOM value should be 5.0 (since we're increasing by 1 each time)
    // MOM[5] = 6.0 - 1.0 = 5.0
    // MOM[6] = 7.0 - 2.0 = 5.0
    // etc.
    for (5..10) |i| {
        try std.testing.expectApproxEqAbs(@as(f64, 5.0), result[i], 0.0001);
    }
}

// Same series used by the tests below: two leading NaNs, then prices
const test_prices = [_]f64{ std.math.nan(f64), std.math.nan(f64), 100.0, 102.0, 101.0, 103.0, 105.0, 104.0, 106.0, 108.0, 107.0, 109.0, 104.0, 101.0, 99.0, 103.0, 110.0, 112.0 };

test "MA with VIDYA and ALMA" {
    const allocator = std.testing.allocator;

    // Expected values come from ta-lib-python against TA-Lib C 0.8.3
    const vidya = try MA(allocator, &test_prices, 5, .VIDYA);
    defer allocator.free(vidya);
    try std.testing.expect(std.math.isNan(vidya[5]));
    try std.testing.expectApproxEqAbs(@as(f64, 102.07654320987655), vidya[6], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 106.05665112225871), vidya[17], 1e-9);

    const alma = try MA(allocator, &test_prices, 5, .ALMA);
    defer allocator.free(alma);
    try std.testing.expect(std.math.isNan(alma[5]));
    try std.testing.expectApproxEqAbs(@as(f64, 102.97009797180375), alma[6], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 108.49099616912497), alma[17], 1e-9);
}

test "index outputs count from the first input bar" {
    const allocator = std.testing.allocator;

    const maxidx = try MAXINDEX(allocator, &test_prices, 3);
    defer allocator.free(maxidx);
    const expected_maxidx = [_]i32{ 0, 0, 0, 0, 3, 5, 6, 6, 8, 9, 9, 11, 11, 11, 12, 15, 16, 17 };
    try std.testing.expectEqualSlices(i32, &expected_maxidx, maxidx);

    var high: [test_prices.len]f64 = undefined;
    var low: [test_prices.len]f64 = undefined;
    for (test_prices, 0..) |p, i| {
        high[i] = p + 1.0;
        low[i] = p - 1.0;
    }
    const zz = try ZIGZAG(allocator, &high, &low, 3.0, 1);
    defer {
        allocator.free(zz.zigzag);
        allocator.free(zz.trend);
        allocator.free(zz.pivotidx);
    }
    const expected_trend = [_]i32{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, 1 };
    const expected_pivotidx = [_]i32{ 0, 0, 0, 3, 3, 5, 6, 6, 8, 9, 9, 11, 12, 13, 14, 15, 16, 17 };
    try std.testing.expectEqualSlices(i32, &expected_trend, zz.trend);
    try std.testing.expectEqualSlices(i32, &expected_pivotidx, zz.pivotidx);
    try std.testing.expect(std.math.isNan(zz.zigzag[2]));
    try std.testing.expectApproxEqAbs(@as(f64, 103.0), zz.zigzag[3], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 98.0), zz.zigzag[14], 1e-9);
}

test "edge cases: empty, short and invalid input" {
    const allocator = std.testing.allocator;

    const empty = try ICHIMOKU(allocator, &.{}, &.{}, 9, 26, 52);
    try std.testing.expectEqual(@as(usize, 0), empty.tenkansen.len);
    try std.testing.expectEqual(@as(usize, 0), empty.senkouspanb.len);

    // Fewer bars than the lookback: all NaN
    const short = try SMA(allocator, test_prices[2..5], 10);
    defer allocator.free(short);
    for (short) |v| {
        try std.testing.expect(std.math.isNan(v));
    }

    try std.testing.expectError(TAError.BadParam, SMA(allocator, &test_prices, -5));
    try std.testing.expectError(error.InputLengths, ADD(allocator, test_prices[0..3], test_prices[0..4]));
}

test "stream matches batch" {
    const allocator = std.testing.allocator;

    const batch = try RSI(allocator, &test_prices, 5);
    defer allocator.free(batch);

    // Warm up on the first 10 bars (2 of them NaN), then feed the rest
    var rsi = try stream.RSI.init(test_prices[0..10], 5);
    defer rsi.deinit();
    try std.testing.expectApproxEqAbs(batch[9], try rsi.value(), 1e-9);
    for (10..test_prices.len) |i| {
        const peeked = try rsi.peek(test_prices[i]);
        try std.testing.expectApproxEqAbs(batch[i], try rsi.update(test_prices[i]), 1e-9);
        try std.testing.expectEqual(peeked, try rsi.value());
    }
    const range = try rsi.outRange();
    try std.testing.expectEqual(@as(usize, 7), range.begidx);
    try std.testing.expectEqual(test_prices.len, range.begidx + range.nbelement);
}

test "stream initAndFill and index outputs" {
    const allocator = std.testing.allocator;

    const batch = try MACD(allocator, &test_prices, 3, 6, 2);
    defer {
        allocator.free(batch.macd);
        allocator.free(batch.macdsignal);
        allocator.free(batch.macdhist);
    }
    const filled = try stream.MACD.initAndFill(allocator, test_prices[0..12], 3, 6, 2);
    var macd = filled.stream;
    defer {
        macd.deinit();
        allocator.free(filled.macd);
        allocator.free(filled.macdsignal);
        allocator.free(filled.macdhist);
    }
    for (0..12) |i| {
        try std.testing.expectEqual(std.math.isNan(batch.macd[i]), std.math.isNan(filled.macd[i]));
        if (!std.math.isNan(batch.macd[i])) {
            try std.testing.expectApproxEqAbs(batch.macdhist[i], filled.macdhist[i], 1e-9);
        }
    }
    for (12..test_prices.len) |i| {
        const out = try macd.update(test_prices[i]);
        try std.testing.expectApproxEqAbs(batch.macd[i], out.macd, 1e-9);
        try std.testing.expectApproxEqAbs(batch.macdsignal[i], out.macdsignal, 1e-9);
        try std.testing.expectApproxEqAbs(batch.macdhist[i], out.macdhist, 1e-9);
    }

    // Index outputs count from the first bar given, NaNs included
    const maxidx = try MAXINDEX(allocator, &test_prices, 3);
    defer allocator.free(maxidx);
    var mi = try stream.MAXINDEX.init(test_prices[0..6], 3);
    defer mi.deinit();
    try std.testing.expectEqual(maxidx[5], try mi.value());
    for (6..test_prices.len) |i| {
        try std.testing.expectEqual(maxidx[i], try mi.update(test_prices[i]));
    }
}

test "stream errors, advance and clone" {
    try std.testing.expectError(TAError.InsufficientHistory, stream.SMA.init(&.{}, 3));
    try std.testing.expectError(TAError.InsufficientHistory, stream.SMA.init(test_prices[2..4], 3));

    var sma = try stream.SMA.init(test_prices[2..5], 3);
    defer sma.deinit();
    try std.testing.expectApproxEqAbs(@as(f64, 101.0), try sma.value(), 1e-9);

    // A non-finite bar is refused and nothing moves
    try std.testing.expectError(TAError.BadParam, sma.update(std.math.nan(f64)));
    try std.testing.expectEqual(@as(usize, 1), (try sma.outRange()).nbelement);
    try sma.advance();
    try std.testing.expectEqual(@as(usize, 2), (try sma.outRange()).nbelement);

    var fork = try sma.clone();
    defer fork.deinit();
    _ = try fork.update(200.0);
    try std.testing.expectApproxEqAbs(@as(f64, 101.0), try sma.value(), 1e-9);
    try std.testing.expectApproxEqAbs(try sma.update(200.0), try fork.value(), 1e-9);
}

test "all declarations compile" {
    std.testing.refAllDecls(@This());
    std.testing.refAllDecls(common);
    inline for (comptime std.meta.declarations(stream)) |name| {
        const T = @field(stream, name);
        if (@TypeOf(T) == type and @typeInfo(T) == .@"struct") {
            std.testing.refAllDecls(T);
        }
    }
}
