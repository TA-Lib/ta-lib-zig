const std = @import("std");

// Import TA-Lib C library
const c = @import("c");

// Moving Average Types (from ta_defs.h)
pub const MAType = enum(c_uint) {
    SMA = 0, // Simple Moving Average
    EMA = 1, // Exponential Moving Average
    WMA = 2, // Weighted Moving Average
    DEMA = 3, // Double Exponential Moving Average
    TEMA = 4, // Triple Exponential Moving Average
    TRIMA = 5, // Triangular Moving Average
    KAMA = 6, // Kaufman Adaptive Moving Average
    MAMA = 7, // MESA Adaptive Moving Average
    T3 = 8, // Triple Exponential Moving Average (T3)
    HMA = 9, // Hull Moving Average
    DISABLED = 10, // No Moving Average (identity)
    DEFAULT = 11, // The Function's Own Default Moving Average
    ZLEMA = 12, // Zero-Lag Exponential Moving Average
    RMA = 13, // Wilder's Smoothed Moving Average
    VIDYA = 14, // Variable Index Dynamic Average
    ALMA = 15, // Arnaud Legoux Moving Average
};

// Unstable Period Function Ids (from ta_defs.h)
pub const FuncUnstId = enum(c_uint) {
    ADX = c.TA_FUNC_UNST_ADX,
    ATR = c.TA_FUNC_UNST_ATR,
    CMO = c.TA_FUNC_UNST_CMO,
    DX = c.TA_FUNC_UNST_DX,
    EMA = c.TA_FUNC_UNST_EMA,
    HT_DCPERIOD = c.TA_FUNC_UNST_HT_DCPERIOD,
    HT_DCPHASE = c.TA_FUNC_UNST_HT_DCPHASE,
    HT_PHASOR = c.TA_FUNC_UNST_HT_PHASOR,
    HT_SINE = c.TA_FUNC_UNST_HT_SINE,
    HT_TRENDLINE = c.TA_FUNC_UNST_HT_TRENDLINE,
    HT_TRENDMODE = c.TA_FUNC_UNST_HT_TRENDMODE,
    KAMA = c.TA_FUNC_UNST_KAMA,
    MAMA = c.TA_FUNC_UNST_MAMA,
    MINUS_DI = c.TA_FUNC_UNST_MINUS_DI,
    MINUS_DM = c.TA_FUNC_UNST_MINUS_DM,
    NATR = c.TA_FUNC_UNST_NATR,
    PLUS_DI = c.TA_FUNC_UNST_PLUS_DI,
    PLUS_DM = c.TA_FUNC_UNST_PLUS_DM,
    RSI = c.TA_FUNC_UNST_RSI,
    T3 = c.TA_FUNC_UNST_T3,
    RMA = c.TA_FUNC_UNST_RMA,
    HA = c.TA_FUNC_UNST_HA,
    RVI = c.TA_FUNC_UNST_RVI,
    FRAMA = c.TA_FUNC_UNST_FRAMA,
    MCGD = c.TA_FUNC_UNST_MCGD,
    VIDYA = c.TA_FUNC_UNST_VIDYA,
    STC = c.TA_FUNC_UNST_STC,
    SWAK_GAUSS = c.TA_FUNC_UNST_SWAK_GAUSS,
    SWAK_BUTTER = c.TA_FUNC_UNST_SWAK_BUTTER,
    SWAK_HP = c.TA_FUNC_UNST_SWAK_HP,
    SWAK_2PHP = c.TA_FUNC_UNST_SWAK_2PHP,
    SWAK_BP = c.TA_FUNC_UNST_SWAK_BP,
    FISHER = c.TA_FUNC_UNST_FISHER,
    ALL = c.TA_FUNC_UNST_ALL,
};

// Auto levels of setUnstablePeriod, passed in place of a count: the function
// discards output until its first 4 or 8 significant digits no longer depend
// on where the data starts.
pub const UNSTABLE_AUTO_PREC_4: u32 = c.TA_UNSTABLE_AUTO_PREC_4;
pub const UNSTABLE_AUTO_PREC_8: u32 = c.TA_UNSTABLE_AUTO_PREC_8;

pub fn setUnstablePeriod(id: FuncUnstId, period: u32) TAError!void {
    const ret_code = c.TA_SetUnstablePeriod(@backingInt(id), period);
    try convertRetCode(ret_code);
}

pub fn getUnstablePeriod(id: FuncUnstId) u32 {
    return c.TA_GetUnstablePeriod(@backingInt(id));
}

test "Unstable period" {
    try setUnstablePeriod(.EMA, 10);
    try std.testing.expectEqual(@as(u32, 10), getUnstablePeriod(.EMA));
    try setUnstablePeriod(.RSI, UNSTABLE_AUTO_PREC_4);
    try std.testing.expectEqual(UNSTABLE_AUTO_PREC_4, getUnstablePeriod(.RSI));
    try setUnstablePeriod(.ALL, 0);
    try std.testing.expectEqual(@as(u32, 0), getUnstablePeriod(.EMA));
}

// Candle Setting Types (from ta_defs.h)
pub const RangeType = enum(c_uint) {
    RealBody = c.TA_RangeType_RealBody,
    HighLow = c.TA_RangeType_HighLow,
    Shadows = c.TA_RangeType_Shadows,
};

pub const CandleSettingType = enum(c_uint) {
    BodyLong = c.TA_BodyLong,
    BodyVeryLong = c.TA_BodyVeryLong,
    BodyShort = c.TA_BodyShort,
    BodyDoji = c.TA_BodyDoji,
    ShadowLong = c.TA_ShadowLong,
    ShadowVeryLong = c.TA_ShadowVeryLong,
    ShadowShort = c.TA_ShadowShort,
    ShadowVeryShort = c.TA_ShadowVeryShort,
    Near = c.TA_Near,
    Far = c.TA_Far,
    Equal = c.TA_Equal,
    AllCandleSettings = c.TA_AllCandleSettings,
};

// Candle settings functions
pub fn setCandleSettings(setting_type: CandleSettingType, range_type: RangeType, avg_period: i32, factor: f64) TAError!void {
    const ret_code = c.TA_SetCandleSettings(@backingInt(setting_type), @backingInt(range_type), avg_period, factor);
    try convertRetCode(ret_code);
}

pub fn restoreCandleDefaultSettings(setting_type: CandleSettingType) TAError!void {
    const ret_code = c.TA_RestoreCandleDefaultSettings(@backingInt(setting_type));
    try convertRetCode(ret_code);
}

// Test for candle settings
test "Candle settings" {
    // Test setting and restoring candle settings
    try setCandleSettings(.BodyLong, .RealBody, 14, 0.7);
    try restoreCandleDefaultSettings(.BodyLong);
    try restoreCandleDefaultSettings(.AllCandleSettings);
}

// Error types for TA-Lib
pub const TAError = error{
    LibNotInitialized,
    BadParam,
    AllocErr,
    GroupNotFound,
    FuncNotFound,
    InvalidHandle,
    InvalidParamHolder,
    InvalidParamHolderType,
    InvalidParamFunction,
    InputNotAllInitialize,
    OutputNotAllInitialize,
    OutOfRangeStartIndex,
    OutOfRangeEndIndex,
    InvalidListType,
    BadObject,
    NotSupported,
    InsufficientHistory,
    InternalError,
    UnknownErr,
};

// Convert TA-Lib return code to Zig error
fn convertRetCode(ret_code: c.TA_RetCode) TAError!void {
    switch (ret_code) {
        c.TA_SUCCESS => return,
        c.TA_LIB_NOT_INITIALIZE => return TAError.LibNotInitialized,
        c.TA_BAD_PARAM => return TAError.BadParam,
        c.TA_ALLOC_ERR => return TAError.AllocErr,
        c.TA_GROUP_NOT_FOUND => return TAError.GroupNotFound,
        c.TA_FUNC_NOT_FOUND => return TAError.FuncNotFound,
        c.TA_INVALID_HANDLE => return TAError.InvalidHandle,
        c.TA_INVALID_PARAM_HOLDER => return TAError.InvalidParamHolder,
        c.TA_INVALID_PARAM_HOLDER_TYPE => return TAError.InvalidParamHolderType,
        c.TA_INVALID_PARAM_FUNCTION => return TAError.InvalidParamFunction,
        c.TA_INPUT_NOT_ALL_INITIALIZE => return TAError.InputNotAllInitialize,
        c.TA_OUTPUT_NOT_ALL_INITIALIZE => return TAError.OutputNotAllInitialize,
        c.TA_OUT_OF_RANGE_START_INDEX => return TAError.OutOfRangeStartIndex,
        c.TA_OUT_OF_RANGE_END_INDEX => return TAError.OutOfRangeEndIndex,
        c.TA_INVALID_LIST_TYPE => return TAError.InvalidListType,
        c.TA_BAD_OBJECT => return TAError.BadObject,
        c.TA_NOT_SUPPORTED => return TAError.NotSupported,
        c.TA_INSUFFICIENT_HISTORY => return TAError.InsufficientHistory,
        c.TA_INTERNAL_ERROR => return TAError.InternalError,
        c.TA_UNKNOWN_ERR => return TAError.UnknownErr,
        else => return TAError.UnknownErr,
    }
}

pub fn initialize() !void {
    const retCode = c.TA_Initialize();
    try convertRetCode(retCode);
}

pub fn shutdown() !void {
    const retCode = c.TA_Shutdown();
    try convertRetCode(retCode);
}

pub fn version() [*c]const u8 {
    return c.TA_GetVersionString();
}

fn checkLength2(a1: []const f64, a2: []const f64) !usize {
    const len = a1.len;
    if (len != a2.len) {
        return error.InputLengths;
    }
    return len;
}

fn checkLength3(a1: []const f64, a2: []const f64, a3: []const f64) !usize {
    const len = a1.len;
    if (len != a2.len) {
        return error.InputLengths;
    }
    if (len != a3.len) {
        return error.InputLengths;
    }
    return len;
}

fn checkLength4(a1: []const f64, a2: []const f64, a3: []const f64, a4: []const f64) !usize {
    const len = a1.len;
    if (len != a2.len) {
        return error.InputLengths;
    }
    if (len != a3.len) {
        return error.InputLengths;
    }
    if (len != a4.len) {
        return error.InputLengths;
    }
    return len;
}

fn checkBegIdx1(len: usize, a1: []const f64) usize {
    for (0..len) |i| {
        const val = a1[i];
        if (val != val) {
            continue;
        }
        return i;
    } else {
        return len - 1;
    }
}

fn checkBegIdx2(len: usize, a1: []const f64, a2: []const f64) usize {
    for (0..len) |i| {
        const val1 = a1[i];
        if (val1 != val1) {
            continue;
        }
        const val2 = a2[i];
        if (val2 != val2) {
            continue;
        }
        return i;
    } else {
        return len - 1;
    }
}

fn checkBegIdx3(len: usize, a1: []const f64, a2: []const f64, a3: []const f64) usize {
    for (0..len) |i| {
        const val1 = a1[i];
        if (val1 != val1) {
            continue;
        }
        const val2 = a2[i];
        if (val2 != val2) {
            continue;
        }
        const val3 = a3[i];
        if (val3 != val3) {
            continue;
        }
        return i;
    } else {
        return len - 1;
    }
}

fn checkBegIdx4(len: usize, a1: []const f64, a2: []const f64, a3: []const f64, a4: []const f64) usize {
    for (0..len) |i| {
        const val1 = a1[i];
        if (val1 != val1) {
            continue;
        }
        const val2 = a2[i];
        if (val2 != val2) {
            continue;
        }
        const val3 = a3[i];
        if (val3 != val3) {
            continue;
        }
        const val4 = a4[i];
        if (val4 != val4) {
            continue;
        }
        return i;
    } else {
        return len - 1;
    }
}

// A negative lookback means TA-Lib rejected the parameters
fn checkLookback(lookback: c_int) TAError!usize {
    if (lookback < 0) {
        return TAError.BadParam;
    }
    return @intCast(lookback);
}

fn makeDoubleArray(allocator: std.mem.Allocator, len: usize, lookback: usize) ![]f64 {
    const result = try allocator.alloc(f64, len);
    @memset(result[0..@min(len, lookback)], std.math.nan(f64));
    return result;
}

fn makeIntArray(allocator: std.mem.Allocator, len: usize, lookback: usize) ![]i32 {
    const result = try allocator.alloc(i32, len);
    @memset(result[0..@min(len, lookback)], 0);
    return result;
}

// BEGIN GENERATED FUNCTIONS (tools/generate_func.py)

/// Accelerator/Decelerator Oscillator
pub fn AC(allocator: std.mem.Allocator, high: []const f64, low: []const f64, fastperiod: i32, slowperiod: i32, signalperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_AC_Lookback(fastperiod, slowperiod, signalperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_AC(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, fastperiod, slowperiod, signalperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Acceleration Bands
pub fn ACCBANDS(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) !struct {
    realupperband: []f64,
    realmiddleband: []f64,
    reallowerband: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .realupperband = try makeDoubleArray(allocator, 0, 0),
        .realmiddleband = try makeDoubleArray(allocator, 0, 0),
        .reallowerband = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ACCBANDS_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outrealupperband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outrealupperband);
    var outrealmiddleband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outrealmiddleband);
    var outreallowerband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreallowerband);
    const retCode = c.TA_ACCBANDS(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outrealupperband[outidx..].ptr, outrealmiddleband[outidx..].ptr, outreallowerband[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .realupperband = outrealupperband,
        .realmiddleband = outrealmiddleband,
        .reallowerband = outreallowerband,
    };
}

/// Vector Trigonometric ACos
pub fn ACOS(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ACOS_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ACOS(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Chaikin A/D Line
pub fn AD(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, volume: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(high, low, close, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, high, low, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_AD_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_AD(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, volume[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Arithmetic Add
pub fn ADD(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(real0, real1);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ADD_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ADD(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Chaikin A/D Oscillator
pub fn ADOSC(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, volume: []const f64, fastperiod: i32, slowperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(high, low, close, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, high, low, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ADOSC_Lookback(fastperiod, slowperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ADOSC(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, volume[begidx..].ptr, fastperiod, slowperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Average Day Range
pub fn ADR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ADR_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ADR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Average Directional Movement Index
pub fn ADX(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ADX_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ADX(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Average Directional Movement Index Rating
pub fn ADXR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ADXR_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ADXR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Arnaud Legoux Moving Average
pub fn ALMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, sigma: f64, offset: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ALMA_Lookback(timeperiod, sigma, offset));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ALMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, sigma, offset, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Awesome Oscillator
pub fn AO(allocator: std.mem.Allocator, high: []const f64, low: []const f64, fastperiod: i32, slowperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_AO_Lookback(fastperiod, slowperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_AO(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, fastperiod, slowperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Absolute Price Oscillator
pub fn APO(allocator: std.mem.Allocator, real: []const f64, fastperiod: i32, slowperiod: i32, matype: MAType) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_APO_Lookback(fastperiod, slowperiod, @backingInt(matype)));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_APO(0, @intCast(endidx), real[begidx..].ptr, fastperiod, slowperiod, @backingInt(matype), &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Aroon
pub fn AROON(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) !struct {
    aroondown: []f64,
    aroonup: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return .{
        .aroondown = try makeDoubleArray(allocator, 0, 0),
        .aroonup = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_AROON_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outaroondown = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outaroondown);
    var outaroonup = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outaroonup);
    const retCode = c.TA_AROON(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outaroondown[outidx..].ptr, outaroonup[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .aroondown = outaroondown,
        .aroonup = outaroonup,
    };
}

/// Aroon Oscillator
pub fn AROONOSC(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_AROONOSC_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_AROONOSC(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Wilder Accumulative Swing Index
pub fn ASI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, limitmove: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ASI_Lookback(limitmove));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ASI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, limitmove, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Trigonometric ASin
pub fn ASIN(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ASIN_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ASIN(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Trigonometric ATan
pub fn ATAN(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ATAN_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ATAN(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Average True Range
pub fn ATR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ATR_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ATR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Average Deviation
pub fn AVGDEV(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_AVGDEV_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_AVGDEV(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Average Price
pub fn AVGPRICE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_AVGPRICE_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_AVGPRICE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Bollinger Bands
pub fn BBANDS(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, nbdevup: f64, nbdevdn: f64, matype: MAType) !struct {
    realupperband: []f64,
    realmiddleband: []f64,
    reallowerband: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .realupperband = try makeDoubleArray(allocator, 0, 0),
        .realmiddleband = try makeDoubleArray(allocator, 0, 0),
        .reallowerband = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_BBANDS_Lookback(timeperiod, nbdevup, nbdevdn, @backingInt(matype)));
    const outidx = @min(lookback, length);
    var outrealupperband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outrealupperband);
    var outrealmiddleband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outrealmiddleband);
    var outreallowerband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreallowerband);
    const retCode = c.TA_BBANDS(0, @intCast(endidx), real[begidx..].ptr, timeperiod, nbdevup, nbdevdn, @backingInt(matype), &outbegidx, &outnbelement, outrealupperband[outidx..].ptr, outrealmiddleband[outidx..].ptr, outreallowerband[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .realupperband = outrealupperband,
        .realmiddleband = outrealmiddleband,
        .reallowerband = outreallowerband,
    };
}

/// Bollinger BandWidth
pub fn BBW(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, nbdevup: f64, nbdevdn: f64, matype: MAType) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_BBW_Lookback(timeperiod, nbdevup, nbdevdn, @backingInt(matype)));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_BBW(0, @intCast(endidx), real[begidx..].ptr, timeperiod, nbdevup, nbdevdn, @backingInt(matype), &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Beta
pub fn BETA(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(real0, real1);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_BETA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_BETA(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Balance Of Power
pub fn BOP(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_BOP_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_BOP(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Commodity Channel Index
pub fn CCI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CCI_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CCI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Two Crows
pub fn CDL2CROWS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDL2CROWS_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDL2CROWS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Three Black Crows
pub fn CDL3BLACKCROWS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDL3BLACKCROWS_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDL3BLACKCROWS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Three Inside Up/Down
pub fn CDL3INSIDE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDL3INSIDE_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDL3INSIDE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Three-Line Strike
pub fn CDL3LINESTRIKE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDL3LINESTRIKE_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDL3LINESTRIKE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Three Outside Up/Down
pub fn CDL3OUTSIDE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDL3OUTSIDE_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDL3OUTSIDE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Three Stars In The South
pub fn CDL3STARSINSOUTH(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDL3STARSINSOUTH_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDL3STARSINSOUTH(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Three Advancing White Soldiers
pub fn CDL3WHITESOLDIERS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDL3WHITESOLDIERS_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDL3WHITESOLDIERS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Abandoned Baby
pub fn CDLABANDONEDBABY(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLABANDONEDBABY_Lookback(penetration));
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLABANDONEDBABY(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Advance Block
pub fn CDLADVANCEBLOCK(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLADVANCEBLOCK_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLADVANCEBLOCK(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Belt-hold
pub fn CDLBELTHOLD(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLBELTHOLD_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLBELTHOLD(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Breakaway
pub fn CDLBREAKAWAY(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLBREAKAWAY_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLBREAKAWAY(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Closing Marubozu
pub fn CDLCLOSINGMARUBOZU(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLCLOSINGMARUBOZU_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLCLOSINGMARUBOZU(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Concealing Baby Swallow
pub fn CDLCONCEALBABYSWALL(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLCONCEALBABYSWALL_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLCONCEALBABYSWALL(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Counterattack
pub fn CDLCOUNTERATTACK(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLCOUNTERATTACK_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLCOUNTERATTACK(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Dark Cloud Cover
pub fn CDLDARKCLOUDCOVER(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLDARKCLOUDCOVER_Lookback(penetration));
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLDARKCLOUDCOVER(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Doji
pub fn CDLDOJI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLDOJI_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLDOJI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Doji Star
pub fn CDLDOJISTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLDOJISTAR_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLDOJISTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Dragonfly Doji
pub fn CDLDRAGONFLYDOJI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLDRAGONFLYDOJI_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLDRAGONFLYDOJI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Engulfing Pattern
pub fn CDLENGULFING(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLENGULFING_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLENGULFING(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Evening Doji Star
pub fn CDLEVENINGDOJISTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLEVENINGDOJISTAR_Lookback(penetration));
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLEVENINGDOJISTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Evening Star
pub fn CDLEVENINGSTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLEVENINGSTAR_Lookback(penetration));
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLEVENINGSTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Up/Down-gap side-by-side white lines
pub fn CDLGAPSIDESIDEWHITE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLGAPSIDESIDEWHITE_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLGAPSIDESIDEWHITE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Gravestone Doji
pub fn CDLGRAVESTONEDOJI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLGRAVESTONEDOJI_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLGRAVESTONEDOJI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Hammer
pub fn CDLHAMMER(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLHAMMER_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLHAMMER(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Hanging Man
pub fn CDLHANGINGMAN(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLHANGINGMAN_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLHANGINGMAN(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Harami Pattern
pub fn CDLHARAMI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLHARAMI_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLHARAMI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Harami Cross Pattern
pub fn CDLHARAMICROSS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLHARAMICROSS_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLHARAMICROSS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// High-Wave Candle
pub fn CDLHIGHWAVE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLHIGHWAVE_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLHIGHWAVE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Hikkake Pattern
pub fn CDLHIKKAKE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLHIKKAKE_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLHIKKAKE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Modified Hikkake Pattern
pub fn CDLHIKKAKEMOD(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLHIKKAKEMOD_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLHIKKAKEMOD(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Homing Pigeon
pub fn CDLHOMINGPIGEON(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLHOMINGPIGEON_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLHOMINGPIGEON(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Identical Three Crows
pub fn CDLIDENTICAL3CROWS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLIDENTICAL3CROWS_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLIDENTICAL3CROWS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// In-Neck Pattern
pub fn CDLINNECK(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLINNECK_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLINNECK(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Inverted Hammer
pub fn CDLINVERTEDHAMMER(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLINVERTEDHAMMER_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLINVERTEDHAMMER(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Kicking
pub fn CDLKICKING(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLKICKING_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLKICKING(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Kicking - bull/bear determined by the longer marubozu
pub fn CDLKICKINGBYLENGTH(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLKICKINGBYLENGTH_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLKICKINGBYLENGTH(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Ladder Bottom
pub fn CDLLADDERBOTTOM(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLLADDERBOTTOM_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLLADDERBOTTOM(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Long Legged Doji
pub fn CDLLONGLEGGEDDOJI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLLONGLEGGEDDOJI_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLLONGLEGGEDDOJI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Long Line Candle
pub fn CDLLONGLINE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLLONGLINE_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLLONGLINE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Marubozu
pub fn CDLMARUBOZU(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLMARUBOZU_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLMARUBOZU(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Matching Low
pub fn CDLMATCHINGLOW(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLMATCHINGLOW_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLMATCHINGLOW(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Mat Hold
pub fn CDLMATHOLD(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLMATHOLD_Lookback(penetration));
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLMATHOLD(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Morning Doji Star
pub fn CDLMORNINGDOJISTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLMORNINGDOJISTAR_Lookback(penetration));
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLMORNINGDOJISTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Morning Star
pub fn CDLMORNINGSTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLMORNINGSTAR_Lookback(penetration));
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLMORNINGSTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// On-Neck Pattern
pub fn CDLONNECK(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLONNECK_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLONNECK(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Piercing Pattern
pub fn CDLPIERCING(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLPIERCING_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLPIERCING(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Rickshaw Man
pub fn CDLRICKSHAWMAN(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLRICKSHAWMAN_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLRICKSHAWMAN(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Rising/Falling Three Methods
pub fn CDLRISEFALL3METHODS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLRISEFALL3METHODS_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLRISEFALL3METHODS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Separating Lines
pub fn CDLSEPARATINGLINES(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLSEPARATINGLINES_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLSEPARATINGLINES(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Shooting Star
pub fn CDLSHOOTINGSTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLSHOOTINGSTAR_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLSHOOTINGSTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Short Line Candle
pub fn CDLSHORTLINE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLSHORTLINE_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLSHORTLINE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Spinning Top
pub fn CDLSPINNINGTOP(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLSPINNINGTOP_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLSPINNINGTOP(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Stalled Pattern
pub fn CDLSTALLEDPATTERN(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLSTALLEDPATTERN_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLSTALLEDPATTERN(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Stick Sandwich
pub fn CDLSTICKSANDWICH(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLSTICKSANDWICH_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLSTICKSANDWICH(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Takuri (Dragonfly Doji with very long lower shadow)
pub fn CDLTAKURI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLTAKURI_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLTAKURI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Tasuki Gap
pub fn CDLTASUKIGAP(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLTASUKIGAP_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLTASUKIGAP(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Thrusting Pattern
pub fn CDLTHRUSTING(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLTHRUSTING_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLTHRUSTING(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Tristar Pattern
pub fn CDLTRISTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLTRISTAR_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLTRISTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Unique 3 River
pub fn CDLUNIQUE3RIVER(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLUNIQUE3RIVER_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLUNIQUE3RIVER(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Upside Gap Two Crows
pub fn CDLUPSIDEGAP2CROWS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLUPSIDEGAP2CROWS_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLUPSIDEGAP2CROWS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Upside/Downside Gap Three Methods
pub fn CDLXSIDEGAP3METHODS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CDLXSIDEGAP3METHODS_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_CDLXSIDEGAP3METHODS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Vector Ceil
pub fn CEIL(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CEIL_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CEIL(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Center of Gravity Oscillator
pub fn CG(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CG_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CG(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Choppiness Index
pub fn CHOP(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CHOP_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CHOP(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Choppiness Index (True Range Box)
pub fn CHOPTR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CHOPTR_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CHOPTR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Chande Kroll Stop
pub fn CKSP(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32, multiplier: f64, stopperiod: i32) !struct {
    highstop: []f64,
    lowstop: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .highstop = try makeDoubleArray(allocator, 0, 0),
        .lowstop = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CKSP_Lookback(timeperiod, multiplier, stopperiod));
    const outidx = @min(lookback, length);
    var outhighstop = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outhighstop);
    var outlowstop = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outlowstop);
    const retCode = c.TA_CKSP(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, multiplier, stopperiod, &outbegidx, &outnbelement, outhighstop[outidx..].ptr, outlowstop[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .highstop = outhighstop,
        .lowstop = outlowstop,
    };
}

/// Chaikin Money Flow
pub fn CMF(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, volume: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(high, low, close, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, high, low, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CMF_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CMF(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, volume[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Chande Momentum Oscillator
pub fn CMO(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CMO_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CMO(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Chande Momentum Oscillator (Unsmoothed)
pub fn CMOU(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CMOU_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CMOU(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Coppock Curve
pub fn COPPOCK(allocator: std.mem.Allocator, real: []const f64, wmaperiod: i32, roc1period: i32, roc2period: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_COPPOCK_Lookback(wmaperiod, roc1period, roc2period));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_COPPOCK(0, @intCast(endidx), real[begidx..].ptr, wmaperiod, roc1period, roc2period, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Pearson's Correlation Coefficient (r)
pub fn CORREL(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(real0, real1);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CORREL_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CORREL(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Trigonometric Cos
pub fn COS(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_COS_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_COS(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Trigonometric Cosh
pub fn COSH(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_COSH_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_COSH(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Connors Relative Strength Index
pub fn CRSI(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, streakperiod: i32, rankperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CRSI_Lookback(timeperiod, streakperiod, rankperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CRSI(0, @intCast(endidx), real[begidx..].ptr, timeperiod, streakperiod, rankperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Correlation Trend Indicator
pub fn CTI(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CTI_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CTI(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Cumulative Sum
pub fn CUMSUM(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CUMSUM_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CUMSUM(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Chaikin's Volatility
pub fn CVI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32, rocperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_CVI_Lookback(timeperiod, rocperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_CVI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, rocperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Double Exponential Moving Average
pub fn DEMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_DEMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_DEMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Arithmetic Div
pub fn DIV(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(real0, real1);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_DIV_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_DIV(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Donchian Channels
pub fn DONCHIAN(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) !struct {
    realupperband: []f64,
    realmiddleband: []f64,
    reallowerband: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return .{
        .realupperband = try makeDoubleArray(allocator, 0, 0),
        .realmiddleband = try makeDoubleArray(allocator, 0, 0),
        .reallowerband = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_DONCHIAN_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outrealupperband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outrealupperband);
    var outrealmiddleband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outrealmiddleband);
    var outreallowerband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreallowerband);
    const retCode = c.TA_DONCHIAN(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outrealupperband[outidx..].ptr, outrealmiddleband[outidx..].ptr, outreallowerband[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .realupperband = outrealupperband,
        .realmiddleband = outrealmiddleband,
        .reallowerband = outreallowerband,
    };
}

/// Derivative Oscillator
pub fn DOSC(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, firstperiod: i32, secondperiod: i32, signalperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_DOSC_Lookback(timeperiod, firstperiod, secondperiod, signalperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_DOSC(0, @intCast(endidx), real[begidx..].ptr, timeperiod, firstperiod, secondperiod, signalperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Detrended Price Oscillator
pub fn DPO(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_DPO_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_DPO(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Directional Movement Index
pub fn DX(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_DX_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_DX(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Elder's Force Index
pub fn EFI(allocator: std.mem.Allocator, close: []const f64, volume: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(close, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_EFI_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_EFI(0, @intCast(endidx), close[begidx..].ptr, volume[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Exponential Moving Average
pub fn EMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_EMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_EMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Arms Ease of Movement
pub fn EMV(allocator: std.mem.Allocator, high: []const f64, low: []const f64, volume: []const f64, timeperiod: i32, volumedivisor: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_EMV_Lookback(timeperiod, volumedivisor));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_EMV(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, volume[begidx..].ptr, timeperiod, volumedivisor, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Kaufman Efficiency Ratio
pub fn ER(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ER_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ER(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Elder Ray Index (Bull Power / Bear Power)
pub fn ERI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) !struct {
    bullpower: []f64,
    bearpower: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .bullpower = try makeDoubleArray(allocator, 0, 0),
        .bearpower = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ERI_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outbullpower = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outbullpower);
    var outbearpower = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outbearpower);
    const retCode = c.TA_ERI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outbullpower[outidx..].ptr, outbearpower[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .bullpower = outbullpower,
        .bearpower = outbearpower,
    };
}

/// Vector Arithmetic Exp
pub fn EXP(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_EXP_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_EXP(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Fisher Transform
pub fn FISHER(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) !struct {
    fisher: []f64,
    trigger: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return .{
        .fisher = try makeDoubleArray(allocator, 0, 0),
        .trigger = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_FISHER_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outfisher = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outfisher);
    var outtrigger = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outtrigger);
    const retCode = c.TA_FISHER(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outfisher[outidx..].ptr, outtrigger[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .fisher = outfisher,
        .trigger = outtrigger,
    };
}

/// Vector Floor
pub fn FLOOR(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_FLOOR_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_FLOOR(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Forecast Oscillator
pub fn FOSC(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_FOSC_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_FOSC(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Williams Fractal
pub fn FRACTAL(allocator: std.mem.Allocator, high: []const f64, low: []const f64, leftbars: i32, rightbars: i32) !struct {
    swinghigh: []i32,
    swinglow: []i32,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return .{
        .swinghigh = try makeIntArray(allocator, 0, 0),
        .swinglow = try makeIntArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_FRACTAL_Lookback(leftbars, rightbars));
    const outidx = @min(lookback, length);
    var outswinghigh = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outswinghigh);
    var outswinglow = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outswinglow);
    const retCode = c.TA_FRACTAL(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, leftbars, rightbars, &outbegidx, &outnbelement, outswinghigh[outidx..].ptr, outswinglow[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .swinghigh = outswinghigh,
        .swinglow = outswinglow,
    };
}

/// Fractal Adaptive Moving Average
pub fn FRAMA(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_FRAMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_FRAMA(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Heikin-Ashi Candles
pub fn HA(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) !struct {
    haopen: []f64,
    hahigh: []f64,
    halow: []f64,
    haclose: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return .{
        .haopen = try makeDoubleArray(allocator, 0, 0),
        .hahigh = try makeDoubleArray(allocator, 0, 0),
        .halow = try makeDoubleArray(allocator, 0, 0),
        .haclose = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_HA_Lookback());
    const outidx = @min(lookback, length);
    var outhaopen = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outhaopen);
    var outhahigh = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outhahigh);
    var outhalow = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outhalow);
    var outhaclose = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outhaclose);
    const retCode = c.TA_HA(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outhaopen[outidx..].ptr, outhahigh[outidx..].ptr, outhalow[outidx..].ptr, outhaclose[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .haopen = outhaopen,
        .hahigh = outhahigh,
        .halow = outhalow,
        .haclose = outhaclose,
    };
}

/// Hull Moving Average
pub fn HMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_HMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_HMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Hilbert Transform - Dominant Cycle Period
pub fn HT_DCPERIOD(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_HT_DCPERIOD_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_HT_DCPERIOD(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Hilbert Transform - Dominant Cycle Phase
pub fn HT_DCPHASE(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_HT_DCPHASE_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_HT_DCPHASE(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Hilbert Transform - Phasor Components
pub fn HT_PHASOR(allocator: std.mem.Allocator, real: []const f64) !struct {
    inphase: []f64,
    quadrature: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .inphase = try makeDoubleArray(allocator, 0, 0),
        .quadrature = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_HT_PHASOR_Lookback());
    const outidx = @min(lookback, length);
    var outinphase = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outinphase);
    var outquadrature = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outquadrature);
    const retCode = c.TA_HT_PHASOR(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outinphase[outidx..].ptr, outquadrature[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .inphase = outinphase,
        .quadrature = outquadrature,
    };
}

/// Hilbert Transform - SineWave
pub fn HT_SINE(allocator: std.mem.Allocator, real: []const f64) !struct {
    sine: []f64,
    leadsine: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .sine = try makeDoubleArray(allocator, 0, 0),
        .leadsine = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_HT_SINE_Lookback());
    const outidx = @min(lookback, length);
    var outsine = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outsine);
    var outleadsine = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outleadsine);
    const retCode = c.TA_HT_SINE(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outsine[outidx..].ptr, outleadsine[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .sine = outsine,
        .leadsine = outleadsine,
    };
}

/// Hilbert Transform - Instantaneous Trendline
pub fn HT_TRENDLINE(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_HT_TRENDLINE_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_HT_TRENDLINE(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Hilbert Transform - Trend vs Cycle Mode
pub fn HT_TRENDMODE(allocator: std.mem.Allocator, real: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_HT_TRENDMODE_Lookback());
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_HT_TRENDMODE(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

/// Internal Bar Strength
pub fn IBS(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_IBS_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_IBS(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Ichimoku Kinko Hyo
pub fn ICHIMOKU(allocator: std.mem.Allocator, high: []const f64, low: []const f64, tenkanperiod: i32, kijunperiod: i32, senkoubperiod: i32) !struct {
    tenkansen: []f64,
    kijunsen: []f64,
    senkouspana: []f64,
    senkouspanb: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return .{
        .tenkansen = try makeDoubleArray(allocator, 0, 0),
        .kijunsen = try makeDoubleArray(allocator, 0, 0),
        .senkouspana = try makeDoubleArray(allocator, 0, 0),
        .senkouspanb = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ICHIMOKU_Lookback(tenkanperiod, kijunperiod, senkoubperiod));
    const outidx = @min(lookback, length);
    var outtenkansen = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outtenkansen);
    var outkijunsen = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outkijunsen);
    var outsenkouspana = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outsenkouspana);
    var outsenkouspanb = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outsenkouspanb);
    const retCode = c.TA_ICHIMOKU(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, tenkanperiod, kijunperiod, senkoubperiod, &outbegidx, &outnbelement, outtenkansen[outidx..].ptr, outkijunsen[outidx..].ptr, outsenkouspana[outidx..].ptr, outsenkouspanb[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .tenkansen = outtenkansen,
        .kijunsen = outkijunsen,
        .senkouspana = outsenkouspana,
        .senkouspanb = outsenkouspanb,
    };
}

/// Intraday Momentum Index
pub fn IMI(allocator: std.mem.Allocator, open: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(open, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, open, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_IMI_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_IMI(0, @intCast(endidx), open[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Kaufman Adaptive Moving Average
pub fn KAMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_KAMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_KAMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Keltner Channels
pub fn KC(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32, atrperiod: i32, nbdev: f64) !struct {
    realupperband: []f64,
    realmiddleband: []f64,
    reallowerband: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .realupperband = try makeDoubleArray(allocator, 0, 0),
        .realmiddleband = try makeDoubleArray(allocator, 0, 0),
        .reallowerband = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_KC_Lookback(timeperiod, atrperiod, nbdev));
    const outidx = @min(lookback, length);
    var outrealupperband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outrealupperband);
    var outrealmiddleband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outrealmiddleband);
    var outreallowerband = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreallowerband);
    const retCode = c.TA_KC(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, atrperiod, nbdev, &outbegidx, &outnbelement, outrealupperband[outidx..].ptr, outrealmiddleband[outidx..].ptr, outreallowerband[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .realupperband = outrealupperband,
        .realmiddleband = outrealmiddleband,
        .reallowerband = outreallowerband,
    };
}

/// KDJ Stochastic
pub fn KDJ(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, fastk_period: i32, slowk_period: i32, slowk_matype: MAType, slowd_period: i32, slowd_matype: MAType) !struct {
    k: []f64,
    d: []f64,
    j: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .k = try makeDoubleArray(allocator, 0, 0),
        .d = try makeDoubleArray(allocator, 0, 0),
        .j = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_KDJ_Lookback(fastk_period, slowk_period, @backingInt(slowk_matype), slowd_period, @backingInt(slowd_matype)));
    const outidx = @min(lookback, length);
    var outk = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outk);
    var outd = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outd);
    var outj = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outj);
    const retCode = c.TA_KDJ(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, fastk_period, slowk_period, @backingInt(slowk_matype), slowd_period, @backingInt(slowd_matype), &outbegidx, &outnbelement, outk[outidx..].ptr, outd[outidx..].ptr, outj[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .k = outk,
        .d = outd,
        .j = outj,
    };
}

/// Know Sure Thing (Pring)
pub fn KST(allocator: std.mem.Allocator, real: []const f64, roc1period: i32, roc2period: i32, roc3period: i32, roc4period: i32, sma1period: i32, sma2period: i32, sma3period: i32, sma4period: i32, signalperiod: i32) !struct {
    kst: []f64,
    kstsignal: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .kst = try makeDoubleArray(allocator, 0, 0),
        .kstsignal = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_KST_Lookback(roc1period, roc2period, roc3period, roc4period, sma1period, sma2period, sma3period, sma4period, signalperiod));
    const outidx = @min(lookback, length);
    var outkst = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outkst);
    var outkstsignal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outkstsignal);
    const retCode = c.TA_KST(0, @intCast(endidx), real[begidx..].ptr, roc1period, roc2period, roc3period, roc4period, sma1period, sma2period, sma3period, sma4period, signalperiod, &outbegidx, &outnbelement, outkst[outidx..].ptr, outkstsignal[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .kst = outkst,
        .kstsignal = outkstsignal,
    };
}

/// Know Sure Thing with controllable MA type
pub fn KSTEXT(allocator: std.mem.Allocator, real: []const f64, roc1period: i32, roc2period: i32, roc3period: i32, roc4period: i32, ma1period: i32, ma2period: i32, ma3period: i32, ma4period: i32, signalperiod: i32, rocmatype: MAType, signalmatype: MAType) !struct {
    kst: []f64,
    kstsignal: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .kst = try makeDoubleArray(allocator, 0, 0),
        .kstsignal = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_KSTEXT_Lookback(roc1period, roc2period, roc3period, roc4period, ma1period, ma2period, ma3period, ma4period, signalperiod, @backingInt(rocmatype), @backingInt(signalmatype)));
    const outidx = @min(lookback, length);
    var outkst = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outkst);
    var outkstsignal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outkstsignal);
    const retCode = c.TA_KSTEXT(0, @intCast(endidx), real[begidx..].ptr, roc1period, roc2period, roc3period, roc4period, ma1period, ma2period, ma3period, ma4period, signalperiod, @backingInt(rocmatype), @backingInt(signalmatype), &outbegidx, &outnbelement, outkst[outidx..].ptr, outkstsignal[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .kst = outkst,
        .kstsignal = outkstsignal,
    };
}

/// Rolling Excess Kurtosis
pub fn KURTOSIS(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_KURTOSIS_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_KURTOSIS(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Klinger Volume Oscillator
pub fn KVO(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, volume: []const f64, fastperiod: i32, slowperiod: i32, signalperiod: i32) !struct {
    kvo: []f64,
    kvosignal: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(high, low, close, volume);
    if (length == 0) return .{
        .kvo = try makeDoubleArray(allocator, 0, 0),
        .kvosignal = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx4(length, high, low, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_KVO_Lookback(fastperiod, slowperiod, signalperiod));
    const outidx = @min(lookback, length);
    var outkvo = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outkvo);
    var outkvosignal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outkvosignal);
    const retCode = c.TA_KVO(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, volume[begidx..].ptr, fastperiod, slowperiod, signalperiod, &outbegidx, &outnbelement, outkvo[outidx..].ptr, outkvosignal[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .kvo = outkvo,
        .kvosignal = outkvosignal,
    };
}

/// Linear Regression
pub fn LINEARREG(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_LINEARREG_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_LINEARREG(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Linear Regression Angle
pub fn LINEARREG_ANGLE(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_LINEARREG_ANGLE_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_LINEARREG_ANGLE(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Linear Regression Intercept
pub fn LINEARREG_INTERCEPT(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_LINEARREG_INTERCEPT_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_LINEARREG_INTERCEPT(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Linear Regression Slope
pub fn LINEARREG_SLOPE(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_LINEARREG_SLOPE_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_LINEARREG_SLOPE(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Log Natural
pub fn LN(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_LN_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_LN(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Log10
pub fn LOG10(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_LOG10_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_LOG10(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Moving average
pub fn MA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, matype: MAType) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MA_Lookback(timeperiod, @backingInt(matype)));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, @backingInt(matype), &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Moving Average Convergence/Divergence
pub fn MACD(allocator: std.mem.Allocator, real: []const f64, fastperiod: i32, slowperiod: i32, signalperiod: i32) !struct {
    macd: []f64,
    macdsignal: []f64,
    macdhist: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .macd = try makeDoubleArray(allocator, 0, 0),
        .macdsignal = try makeDoubleArray(allocator, 0, 0),
        .macdhist = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MACD_Lookback(fastperiod, slowperiod, signalperiod));
    const outidx = @min(lookback, length);
    var outmacd = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmacd);
    var outmacdsignal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmacdsignal);
    var outmacdhist = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmacdhist);
    const retCode = c.TA_MACD(0, @intCast(endidx), real[begidx..].ptr, fastperiod, slowperiod, signalperiod, &outbegidx, &outnbelement, outmacd[outidx..].ptr, outmacdsignal[outidx..].ptr, outmacdhist[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .macd = outmacd,
        .macdsignal = outmacdsignal,
        .macdhist = outmacdhist,
    };
}

/// MACD with controllable MA type
pub fn MACDEXT(allocator: std.mem.Allocator, real: []const f64, fastperiod: i32, fastmatype: MAType, slowperiod: i32, slowmatype: MAType, signalperiod: i32, signalmatype: MAType) !struct {
    macd: []f64,
    macdsignal: []f64,
    macdhist: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .macd = try makeDoubleArray(allocator, 0, 0),
        .macdsignal = try makeDoubleArray(allocator, 0, 0),
        .macdhist = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MACDEXT_Lookback(fastperiod, @backingInt(fastmatype), slowperiod, @backingInt(slowmatype), signalperiod, @backingInt(signalmatype)));
    const outidx = @min(lookback, length);
    var outmacd = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmacd);
    var outmacdsignal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmacdsignal);
    var outmacdhist = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmacdhist);
    const retCode = c.TA_MACDEXT(0, @intCast(endidx), real[begidx..].ptr, fastperiod, @backingInt(fastmatype), slowperiod, @backingInt(slowmatype), signalperiod, @backingInt(signalmatype), &outbegidx, &outnbelement, outmacd[outidx..].ptr, outmacdsignal[outidx..].ptr, outmacdhist[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .macd = outmacd,
        .macdsignal = outmacdsignal,
        .macdhist = outmacdhist,
    };
}

/// Moving Average Convergence/Divergence Fix 12/26
pub fn MACDFIX(allocator: std.mem.Allocator, real: []const f64, signalperiod: i32) !struct {
    macd: []f64,
    macdsignal: []f64,
    macdhist: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .macd = try makeDoubleArray(allocator, 0, 0),
        .macdsignal = try makeDoubleArray(allocator, 0, 0),
        .macdhist = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MACDFIX_Lookback(signalperiod));
    const outidx = @min(lookback, length);
    var outmacd = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmacd);
    var outmacdsignal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmacdsignal);
    var outmacdhist = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmacdhist);
    const retCode = c.TA_MACDFIX(0, @intCast(endidx), real[begidx..].ptr, signalperiod, &outbegidx, &outnbelement, outmacd[outidx..].ptr, outmacdsignal[outidx..].ptr, outmacdhist[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .macd = outmacd,
        .macdsignal = outmacdsignal,
        .macdhist = outmacdhist,
    };
}

/// MESA Adaptive Moving Average
pub fn MAMA(allocator: std.mem.Allocator, real: []const f64, fastlimit: f64, slowlimit: f64) !struct {
    mama: []f64,
    fama: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .mama = try makeDoubleArray(allocator, 0, 0),
        .fama = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MAMA_Lookback(fastlimit, slowlimit));
    const outidx = @min(lookback, length);
    var outmama = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmama);
    var outfama = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outfama);
    const retCode = c.TA_MAMA(0, @intCast(endidx), real[begidx..].ptr, fastlimit, slowlimit, &outbegidx, &outnbelement, outmama[outidx..].ptr, outfama[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .mama = outmama,
        .fama = outfama,
    };
}

/// Market Facilitation Index
pub fn MARKETFI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, volume: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MARKETFI_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MARKETFI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, volume[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Mass Index
pub fn MASSI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, fastperiod: i32, slowperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MASSI_Lookback(fastperiod, slowperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MASSI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, fastperiod, slowperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Moving average with variable period
pub fn MAVP(allocator: std.mem.Allocator, real: []const f64, periods: []const f64, minperiod: i32, maxperiod: i32, matype: MAType) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(real, periods);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, real, periods);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MAVP_Lookback(minperiod, maxperiod, @backingInt(matype)));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MAVP(0, @intCast(endidx), real[begidx..].ptr, periods[begidx..].ptr, minperiod, maxperiod, @backingInt(matype), &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Highest value over a specified period
pub fn MAX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MAX_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MAX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Index of highest value over a specified period
pub fn MAXINDEX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MAXINDEX_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_MAXINDEX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    for (outidx..length) |i| {
        outinteger[i] += @intCast(begidx);
    }
    return outinteger;
}

/// McGinley Dynamic
pub fn MCGD(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MCGD_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MCGD(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Rolling Median
pub fn MEDIAN(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MEDIAN_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MEDIAN(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Median Price
pub fn MEDPRICE(allocator: std.mem.Allocator, high: []const f64, low: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MEDPRICE_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MEDPRICE(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Money Flow Index
pub fn MFI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, volume: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(high, low, close, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, high, low, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MFI_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MFI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, volume[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// MidPoint over period
pub fn MIDPOINT(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MIDPOINT_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MIDPOINT(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Midpoint Price over period
pub fn MIDPRICE(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MIDPRICE_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MIDPRICE(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Lowest value over a specified period
pub fn MIN(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MIN_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MIN(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Index of lowest value over a specified period
pub fn MININDEX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeIntArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MININDEX_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outinteger = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outinteger);
    const retCode = c.TA_MININDEX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outinteger[outidx..].ptr);
    try convertRetCode(retCode);
    for (outidx..length) |i| {
        outinteger[i] += @intCast(begidx);
    }
    return outinteger;
}

/// Lowest and highest values over a specified period
pub fn MINMAX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) !struct {
    min: []f64,
    max: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .min = try makeDoubleArray(allocator, 0, 0),
        .max = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MINMAX_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outmin = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmin);
    var outmax = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmax);
    const retCode = c.TA_MINMAX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outmin[outidx..].ptr, outmax[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .min = outmin,
        .max = outmax,
    };
}

/// Indexes of lowest and highest values over a specified period
pub fn MINMAXINDEX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) !struct {
    minidx: []i32,
    maxidx: []i32,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .minidx = try makeIntArray(allocator, 0, 0),
        .maxidx = try makeIntArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MINMAXINDEX_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outminidx = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outminidx);
    var outmaxidx = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outmaxidx);
    const retCode = c.TA_MINMAXINDEX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outminidx[outidx..].ptr, outmaxidx[outidx..].ptr);
    try convertRetCode(retCode);
    for (outidx..length) |i| {
        outminidx[i] += @intCast(begidx);
    }
    for (outidx..length) |i| {
        outmaxidx[i] += @intCast(begidx);
    }
    return .{
        .minidx = outminidx,
        .maxidx = outmaxidx,
    };
}

/// Minus Directional Indicator
pub fn MINUS_DI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MINUS_DI_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MINUS_DI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Minus Directional Movement
pub fn MINUS_DM(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MINUS_DM_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MINUS_DM(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Momentum
pub fn MOM(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MOM_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MOM(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Arithmetic Mult
pub fn MULT(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(real0, real1);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_MULT_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_MULT(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Normalized Average True Range
pub fn NATR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_NATR_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_NATR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Negative Volume Index
pub fn NVI(allocator: std.mem.Allocator, close: []const f64, volume: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(close, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_NVI_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_NVI(0, @intCast(endidx), close[begidx..].ptr, volume[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// On Balance Volume
pub fn OBV(allocator: std.mem.Allocator, real: []const f64, volume: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(real, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, real, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_OBV_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_OBV(0, @intCast(endidx), real[begidx..].ptr, volume[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Bollinger Bands %B
pub fn PERCENTB(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, nbdevup: f64, nbdevdn: f64, matype: MAType) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_PERCENTB_Lookback(timeperiod, nbdevup, nbdevdn, @backingInt(matype)));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_PERCENTB(0, @intCast(endidx), real[begidx..].ptr, timeperiod, nbdevup, nbdevdn, @backingInt(matype), &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Percentile (nearest rank)
pub fn PERCENTILE(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, percentile: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_PERCENTILE_Lookback(timeperiod, percentile));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_PERCENTILE(0, @intCast(endidx), real[begidx..].ptr, timeperiod, percentile, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Percent Rank
pub fn PERCENTRANK(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_PERCENTRANK_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_PERCENTRANK(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Plus Directional Indicator
pub fn PLUS_DI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_PLUS_DI_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_PLUS_DI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Plus Directional Movement
pub fn PLUS_DM(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_PLUS_DM_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_PLUS_DM(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Percentage Price Oscillator
pub fn PPO(allocator: std.mem.Allocator, real: []const f64, fastperiod: i32, slowperiod: i32, matype: MAType) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_PPO_Lookback(fastperiod, slowperiod, @backingInt(matype)));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_PPO(0, @intCast(endidx), real[begidx..].ptr, fastperiod, slowperiod, @backingInt(matype), &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Premier Stochastic Oscillator
pub fn PSO(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, fastk_period: i32, emaperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_PSO_Lookback(fastk_period, emaperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_PSO(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, fastk_period, emaperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Positive Volume Index
pub fn PVI(allocator: std.mem.Allocator, close: []const f64, volume: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(close, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_PVI_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_PVI(0, @intCast(endidx), close[begidx..].ptr, volume[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Percentage Volume Oscillator
pub fn PVO(allocator: std.mem.Allocator, volume: []const f64, fastperiod: i32, slowperiod: i32, matype: MAType) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = volume.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_PVO_Lookback(fastperiod, slowperiod, @backingInt(matype)));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_PVO(0, @intCast(endidx), volume[begidx..].ptr, fastperiod, slowperiod, @backingInt(matype), &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Price Volume Trend
pub fn PVT(allocator: std.mem.Allocator, close: []const f64, volume: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(close, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_PVT_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_PVT(0, @intCast(endidx), close[begidx..].ptr, volume[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Qstick
pub fn QSTICK(allocator: std.mem.Allocator, open: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(open, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, open, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_QSTICK_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_QSTICK(0, @intCast(endidx), open[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Wilder's Smoothed Moving Average
pub fn RMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_RMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_RMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Rate of change : ((price/prevPrice)-1)*100
pub fn ROC(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ROC_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ROC(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Rate of change Percentage: (price-prevPrice)/prevPrice
pub fn ROCP(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ROCP_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ROCP(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Rate of change ratio: (price/prevPrice)
pub fn ROCR(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ROCR_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ROCR(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Rate of change ratio 100 scale: (price/prevPrice)*100
pub fn ROCR100(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ROCR100_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ROCR100(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Rogers-Satchell Volatility
pub fn ROGERSSATCHELL(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32, annualization: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ROGERSSATCHELL_Lookback(timeperiod, annualization));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ROGERSSATCHELL(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, annualization, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Relative Strength Index
pub fn RSI(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_RSI_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_RSI(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Relative Volatility Index
pub fn RVI(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, stddevperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_RVI_Lookback(timeperiod, stddevperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_RVI(0, @intCast(endidx), real[begidx..].ptr, timeperiod, stddevperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Relative Volatility Index, refined high/low form
pub fn RVIR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32, stddevperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_RVIR_Lookback(timeperiod, stddevperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_RVIR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, stddevperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Relative Volume
pub fn RVOL(allocator: std.mem.Allocator, volume: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = volume.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_RVOL_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_RVOL(0, @intCast(endidx), volume[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Parabolic SAR
pub fn SAR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, acceleration: f64, maximum: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SAR_Lookback(acceleration, maximum));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SAR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, acceleration, maximum, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Parabolic SAR - Extended
pub fn SAREXT(allocator: std.mem.Allocator, high: []const f64, low: []const f64, startvalue: f64, offsetonreverse: f64, accelerationinitlong: f64, accelerationlong: f64, accelerationmaxlong: f64, accelerationinitshort: f64, accelerationshort: f64, accelerationmaxshort: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SAREXT_Lookback(startvalue, offsetonreverse, accelerationinitlong, accelerationlong, accelerationmaxlong, accelerationinitshort, accelerationshort, accelerationmaxshort));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SAREXT(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, startvalue, offsetonreverse, accelerationinitlong, accelerationlong, accelerationmaxlong, accelerationinitshort, accelerationshort, accelerationmaxshort, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Wilder Swing Index
pub fn SI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, limitmove: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(open, high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SI_Lookback(limitmove));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, limitmove, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Trigonometric Sin
pub fn SIN(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SIN_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SIN(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Trigonometric Sinh
pub fn SINH(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SINH_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SINH(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Simple Moving Average
pub fn SMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Stochastic Momentum Index
pub fn SMI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32, fastperiod: i32, slowperiod: i32, signalperiod: i32) !struct {
    smi: []f64,
    smisignal: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .smi = try makeDoubleArray(allocator, 0, 0),
        .smisignal = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SMI_Lookback(timeperiod, fastperiod, slowperiod, signalperiod));
    const outidx = @min(lookback, length);
    var outsmi = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outsmi);
    var outsmisignal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outsmisignal);
    const retCode = c.TA_SMI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, fastperiod, slowperiod, signalperiod, &outbegidx, &outnbelement, outsmi[outidx..].ptr, outsmisignal[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .smi = outsmi,
        .smisignal = outsmisignal,
    };
}

/// Vector Square Root
pub fn SQRT(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SQRT_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SQRT(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Squeeze Momentum and Level
pub fn SQZMOM(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, bbperiod: i32, nbdev: f64, kcperiod: i32, factorwide: f64, factornormal: f64, factornarrow: f64) !struct {
    momentum: []f64,
    squeeze: []i32,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .momentum = try makeDoubleArray(allocator, 0, 0),
        .squeeze = try makeIntArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SQZMOM_Lookback(bbperiod, nbdev, kcperiod, factorwide, factornormal, factornarrow));
    const outidx = @min(lookback, length);
    var outmomentum = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outmomentum);
    var outsqueeze = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outsqueeze);
    const retCode = c.TA_SQZMOM(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, bbperiod, nbdev, kcperiod, factorwide, factornormal, factornarrow, &outbegidx, &outnbelement, outmomentum[outidx..].ptr, outsqueeze[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .momentum = outmomentum,
        .squeeze = outsqueeze,
    };
}

/// Schaff Trend Cycle
pub fn STC(allocator: std.mem.Allocator, real: []const f64, fastperiod: i32, slowperiod: i32, cycleperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_STC_Lookback(fastperiod, slowperiod, cycleperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_STC(0, @intCast(endidx), real[begidx..].ptr, fastperiod, slowperiod, cycleperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Standard Deviation
pub fn STDDEV(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, nbdev: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_STDDEV_Lookback(timeperiod, nbdev));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_STDDEV(0, @intCast(endidx), real[begidx..].ptr, timeperiod, nbdev, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Stochastic
pub fn STOCH(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, fastk_period: i32, slowk_period: i32, slowk_matype: MAType, slowd_period: i32, slowd_matype: MAType) !struct {
    slowk: []f64,
    slowd: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .slowk = try makeDoubleArray(allocator, 0, 0),
        .slowd = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_STOCH_Lookback(fastk_period, slowk_period, @backingInt(slowk_matype), slowd_period, @backingInt(slowd_matype)));
    const outidx = @min(lookback, length);
    var outslowk = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outslowk);
    var outslowd = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outslowd);
    const retCode = c.TA_STOCH(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, fastk_period, slowk_period, @backingInt(slowk_matype), slowd_period, @backingInt(slowd_matype), &outbegidx, &outnbelement, outslowk[outidx..].ptr, outslowd[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .slowk = outslowk,
        .slowd = outslowd,
    };
}

/// Stochastic Fast
pub fn STOCHF(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, fastk_period: i32, fastd_period: i32, fastd_matype: MAType) !struct {
    fastk: []f64,
    fastd: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .fastk = try makeDoubleArray(allocator, 0, 0),
        .fastd = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_STOCHF_Lookback(fastk_period, fastd_period, @backingInt(fastd_matype)));
    const outidx = @min(lookback, length);
    var outfastk = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outfastk);
    var outfastd = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outfastd);
    const retCode = c.TA_STOCHF(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, fastk_period, fastd_period, @backingInt(fastd_matype), &outbegidx, &outnbelement, outfastk[outidx..].ptr, outfastd[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .fastk = outfastk,
        .fastd = outfastd,
    };
}

/// Stochastic Relative Strength Index
pub fn STOCHRSI(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, fastk_period: i32, fastd_period: i32, fastd_matype: MAType) !struct {
    fastk: []f64,
    fastd: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return .{
        .fastk = try makeDoubleArray(allocator, 0, 0),
        .fastd = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_STOCHRSI_Lookback(timeperiod, fastk_period, fastd_period, @backingInt(fastd_matype)));
    const outidx = @min(lookback, length);
    var outfastk = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outfastk);
    var outfastd = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outfastd);
    const retCode = c.TA_STOCHRSI(0, @intCast(endidx), real[begidx..].ptr, timeperiod, fastk_period, fastd_period, @backingInt(fastd_matype), &outbegidx, &outnbelement, outfastk[outidx..].ptr, outfastd[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .fastk = outfastk,
        .fastd = outfastd,
    };
}

/// Vector Arithmetic Subtraction
pub fn SUB(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(real0, real1);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SUB_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SUB(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Summation
pub fn SUM(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SUM_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SUM(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// SuperTrend
pub fn SUPERTREND(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32, multiplier: f64) !struct {
    supertrend: []f64,
    trend: []i32,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .supertrend = try makeDoubleArray(allocator, 0, 0),
        .trend = try makeIntArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SUPERTREND_Lookback(timeperiod, multiplier));
    const outidx = @min(lookback, length);
    var outsupertrend = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outsupertrend);
    var outtrend = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outtrend);
    const retCode = c.TA_SUPERTREND(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, multiplier, &outbegidx, &outnbelement, outsupertrend[outidx..].ptr, outtrend[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .supertrend = outsupertrend,
        .trend = outtrend,
    };
}

/// Swiss Army Knife - Two-Pole High-Pass Filter
pub fn SWAK_2PHP(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SWAK_2PHP_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SWAK_2PHP(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Swiss Army Knife - Band-Pass Filter
pub fn SWAK_BP(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, delta: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SWAK_BP_Lookback(timeperiod, delta));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SWAK_BP(0, @intCast(endidx), real[begidx..].ptr, timeperiod, delta, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Swiss Army Knife - Butterworth Filter
pub fn SWAK_BUTTER(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SWAK_BUTTER_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SWAK_BUTTER(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Swiss Army Knife - Gaussian Filter
pub fn SWAK_GAUSS(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SWAK_GAUSS_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SWAK_GAUSS(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Swiss Army Knife - High-Pass Filter
pub fn SWAK_HP(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_SWAK_HP_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_SWAK_HP(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Triple Exponential Moving Average (T3)
pub fn T3(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, vfactor: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_T3_Lookback(timeperiod, vfactor));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_T3(0, @intCast(endidx), real[begidx..].ptr, timeperiod, vfactor, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Trigonometric Tan
pub fn TAN(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_TAN_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_TAN(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vector Trigonometric Tanh
pub fn TANH(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_TANH_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_TANH(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Triple Exponential Moving Average
pub fn TEMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_TEMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_TEMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// True Range
pub fn TRANGE(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_TRANGE_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_TRANGE(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Triangular Moving Average
pub fn TRIMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_TRIMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_TRIMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// 1-day Rate-Of-Change (ROC) of a Triple Smooth EMA
pub fn TRIX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_TRIX_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_TRIX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Time Series Forecast
pub fn TSF(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_TSF_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_TSF(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// True Strength Index
pub fn TSI(allocator: std.mem.Allocator, real: []const f64, firstperiod: i32, secondperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_TSI_Lookback(firstperiod, secondperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_TSI(0, @intCast(endidx), real[begidx..].ptr, firstperiod, secondperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Typical Price
pub fn TYPPRICE(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_TYPPRICE_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_TYPPRICE(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Ultimate Oscillator
pub fn ULTOSC(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod1: i32, timeperiod2: i32, timeperiod3: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ULTOSC_Lookback(timeperiod1, timeperiod2, timeperiod3));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ULTOSC(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod1, timeperiod2, timeperiod3, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Variance
pub fn VAR(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, nbdev: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_VAR_Lookback(timeperiod, nbdev));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_VAR(0, @intCast(endidx), real[begidx..].ptr, timeperiod, nbdev, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vertical Horizontal Filter
pub fn VHF(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_VHF_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_VHF(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Variable Index Dynamic Average
pub fn VIDYA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, cmoperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_VIDYA_Lookback(timeperiod, cmoperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_VIDYA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, cmoperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Vortex Indicator
pub fn VORTEX(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) !struct {
    plusvi: []f64,
    minusvi: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .plusvi = try makeDoubleArray(allocator, 0, 0),
        .minusvi = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_VORTEX_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outplusvi = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outplusvi);
    var outminusvi = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outminusvi);
    const retCode = c.TA_VORTEX(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outplusvi[outidx..].ptr, outminusvi[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .plusvi = outplusvi,
        .minusvi = outminusvi,
    };
}

/// Volume Weighted Average Price
pub fn VWAP(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, volume: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength4(high, low, close, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx4(length, high, low, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_VWAP_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_VWAP(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, volume[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Volume Weighted Moving Average
pub fn VWMA(allocator: std.mem.Allocator, real: []const f64, volume: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(real, volume);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx2(length, real, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_VWMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_VWMA(0, @intCast(endidx), real[begidx..].ptr, volume[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Williams' Accumulation/Distribution
pub fn WAD(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_WAD_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_WAD(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// WaveTrend Oscillator
pub fn WAVETREND(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, channelperiod: i32, averageperiod: i32, signalperiod: i32) !struct {
    wt1: []f64,
    wt2: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return .{
        .wt1 = try makeDoubleArray(allocator, 0, 0),
        .wt2 = try makeDoubleArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_WAVETREND_Lookback(channelperiod, averageperiod, signalperiod));
    const outidx = @min(lookback, length);
    var outwt1 = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outwt1);
    var outwt2 = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outwt2);
    const retCode = c.TA_WAVETREND(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, channelperiod, averageperiod, signalperiod, &outbegidx, &outnbelement, outwt1[outidx..].ptr, outwt2[outidx..].ptr);
    try convertRetCode(retCode);
    return .{
        .wt1 = outwt1,
        .wt2 = outwt2,
    };
}

/// Weighted Close Price
pub fn WCLPRICE(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_WCLPRICE_Lookback());
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_WCLPRICE(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Williams' %R
pub fn WILLR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength3(high, low, close);
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_WILLR_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_WILLR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Weighted Moving Average
pub fn WMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_WMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_WMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

/// Zig Zag
pub fn ZIGZAG(allocator: std.mem.Allocator, high: []const f64, low: []const f64, sensitivity: f64, mintrendlength: i32) !struct {
    zigzag: []f64,
    trend: []i32,
    pivotidx: []i32,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = try checkLength2(high, low);
    if (length == 0) return .{
        .zigzag = try makeDoubleArray(allocator, 0, 0),
        .trend = try makeIntArray(allocator, 0, 0),
        .pivotidx = try makeIntArray(allocator, 0, 0),
    };
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ZIGZAG_Lookback(sensitivity, mintrendlength));
    const outidx = @min(lookback, length);
    var outzigzag = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outzigzag);
    var outtrend = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outtrend);
    var outpivotidx = try makeIntArray(allocator, length, lookback);
    errdefer allocator.free(outpivotidx);
    const retCode = c.TA_ZIGZAG(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, sensitivity, mintrendlength, &outbegidx, &outnbelement, outzigzag[outidx..].ptr, outtrend[outidx..].ptr, outpivotidx[outidx..].ptr);
    try convertRetCode(retCode);
    for (outidx..length) |i| {
        outpivotidx[i] += @intCast(begidx);
    }
    return .{
        .zigzag = outzigzag,
        .trend = outtrend,
        .pivotidx = outpivotidx,
    };
}

/// Zero-Lag Exponential Moving Average
pub fn ZLEMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    if (length == 0) return try makeDoubleArray(allocator, 0, 0);
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + try checkLookback(c.TA_ZLEMA_Lookback(timeperiod));
    const outidx = @min(lookback, length);
    var outreal = try makeDoubleArray(allocator, length, lookback);
    errdefer allocator.free(outreal);
    const retCode = c.TA_ZLEMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[outidx..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

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

test "all declarations compile" {
    std.testing.refAllDecls(@This());
}
