const std = @import("std");

// Import TA-Lib C library
const c = @cImport({
    @cInclude("ta-lib/ta_abstract.h");
    @cInclude("ta-lib/ta_func.h");
    @cInclude("ta-lib/ta_common.h");
    @cInclude("ta-lib/ta_defs.h");
});

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
};

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
    const ret_code = c.TA_SetCandleSettings(@intFromEnum(setting_type), @intFromEnum(range_type), avg_period, factor);
    try convertRetCode(ret_code);
}

pub fn restoreCandleDefaultSettings(setting_type: CandleSettingType) TAError!void {
    const ret_code = c.TA_RestoreCandleDefaultSettings(@intFromEnum(setting_type));
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
    InternalError,
    UnknownErr,
};

// Convert TA-Lib return code to Zig error
pub fn convertRetCode(ret_code: c.TA_RetCode) TAError!void {
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
        c.TA_INTERNAL_ERROR => return TAError.InternalError,
        c.TA_UNKNOWN_ERR => return TAError.UnknownErr,
        else => return TAError.UnknownErr,
    }
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

pub fn ACCBANDS(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) !struct {
    outrealupperband: []f64,
    outrealmiddleband: []f64,
    outreallowerband: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ACCBANDS_Lookback(timeperiod)));
    var outrealupperband = try makeDoubleArray(allocator, length, lookback);
    var outrealmiddleband = try makeDoubleArray(allocator, length, lookback);
    var outreallowerband = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ACCBANDS(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outrealupperband[lookback..].ptr, outrealmiddleband[lookback..].ptr, outreallowerband[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outrealupperband,
        outrealmiddleband,
        outreallowerband,
    };
}

pub fn ACOS(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ACOS_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ACOS(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn AD(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, volume: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(high, low, close, volume);
    const begidx = checkBegIdx4(length, high, low, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_AD_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_AD(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, volume[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ADD(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(real0, real1);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ADD_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ADD(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ADOSC(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, volume: []const f64, fastperiod: i32, slowperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(high, low, close, volume);
    const begidx = checkBegIdx4(length, high, low, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ADOSC_Lookback(fastperiod, slowperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ADOSC(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, volume[begidx..].ptr, fastperiod, slowperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ADX(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ADX_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ADX(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ADXR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ADXR_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ADXR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn APO(allocator: std.mem.Allocator, real: []const f64, fastperiod: i32, slowperiod: i32, matype: c_uint) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_APO_Lookback(fastperiod, slowperiod, matype)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_APO(0, @intCast(endidx), real[begidx..].ptr, fastperiod, slowperiod, matype, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn AROON(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) !struct {
    outaroondown: []f64,
    outaroonup: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(high, low);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_AROON_Lookback(timeperiod)));
    var outaroondown = try makeDoubleArray(allocator, length, lookback);
    var outaroonup = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_AROON(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outaroondown[lookback..].ptr, outaroonup[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outaroondown,
        outaroonup,
    };
}

pub fn AROONOSC(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(high, low);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_AROONOSC_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_AROONOSC(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ASIN(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ASIN_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ASIN(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ATAN(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ATAN_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ATAN(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ATR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ATR_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ATR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn AVGPRICE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_AVGPRICE_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_AVGPRICE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn AVGDEV(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_AVGDEV_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_AVGDEV(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn BBANDS(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, nbdevup: f64, nbdevdn: f64, matype: c_uint) !struct {
    outrealupperband: []f64,
    outrealmiddleband: []f64,
    outreallowerband: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_BBANDS_Lookback(timeperiod, nbdevup, nbdevdn, matype)));
    var outrealupperband = try makeDoubleArray(allocator, length, lookback);
    var outrealmiddleband = try makeDoubleArray(allocator, length, lookback);
    var outreallowerband = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_BBANDS(0, @intCast(endidx), real[begidx..].ptr, timeperiod, nbdevup, nbdevdn, matype, &outbegidx, &outnbelement, outrealupperband[lookback..].ptr, outrealmiddleband[lookback..].ptr, outreallowerband[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outrealupperband,
        outrealmiddleband,
        outreallowerband,
    };
}

pub fn BETA(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(real0, real1);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_BETA_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_BETA(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn BOP(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_BOP_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_BOP(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn CCI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CCI_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_CCI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn CDL2CROWS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDL2CROWS_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDL2CROWS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDL3BLACKCROWS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDL3BLACKCROWS_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDL3BLACKCROWS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDL3INSIDE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDL3INSIDE_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDL3INSIDE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDL3LINESTRIKE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDL3LINESTRIKE_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDL3LINESTRIKE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDL3OUTSIDE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDL3OUTSIDE_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDL3OUTSIDE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDL3STARSINSOUTH(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDL3STARSINSOUTH_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDL3STARSINSOUTH(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDL3WHITESOLDIERS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDL3WHITESOLDIERS_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDL3WHITESOLDIERS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLABANDONEDBABY(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLABANDONEDBABY_Lookback(penetration)));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLABANDONEDBABY(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLADVANCEBLOCK(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLADVANCEBLOCK_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLADVANCEBLOCK(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLBELTHOLD(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLBELTHOLD_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLBELTHOLD(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLBREAKAWAY(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLBREAKAWAY_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLBREAKAWAY(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLCLOSINGMARUBOZU(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLCLOSINGMARUBOZU_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLCLOSINGMARUBOZU(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLCONCEALBABYSWALL(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLCONCEALBABYSWALL_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLCONCEALBABYSWALL(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLCOUNTERATTACK(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLCOUNTERATTACK_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLCOUNTERATTACK(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLDARKCLOUDCOVER(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLDARKCLOUDCOVER_Lookback(penetration)));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLDARKCLOUDCOVER(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLDOJI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLDOJI_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLDOJI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLDOJISTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLDOJISTAR_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLDOJISTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLDRAGONFLYDOJI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLDRAGONFLYDOJI_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLDRAGONFLYDOJI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLENGULFING(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLENGULFING_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLENGULFING(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLEVENINGDOJISTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLEVENINGDOJISTAR_Lookback(penetration)));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLEVENINGDOJISTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLEVENINGSTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLEVENINGSTAR_Lookback(penetration)));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLEVENINGSTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLGAPSIDESIDEWHITE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLGAPSIDESIDEWHITE_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLGAPSIDESIDEWHITE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLGRAVESTONEDOJI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLGRAVESTONEDOJI_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLGRAVESTONEDOJI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLHAMMER(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLHAMMER_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLHAMMER(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLHANGINGMAN(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLHANGINGMAN_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLHANGINGMAN(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLHARAMI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLHARAMI_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLHARAMI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLHARAMICROSS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLHARAMICROSS_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLHARAMICROSS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLHIGHWAVE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLHIGHWAVE_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLHIGHWAVE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLHIKKAKE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLHIKKAKE_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLHIKKAKE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLHIKKAKEMOD(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLHIKKAKEMOD_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLHIKKAKEMOD(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLHOMINGPIGEON(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLHOMINGPIGEON_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLHOMINGPIGEON(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLIDENTICAL3CROWS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLIDENTICAL3CROWS_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLIDENTICAL3CROWS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLINNECK(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLINNECK_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLINNECK(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLINVERTEDHAMMER(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLINVERTEDHAMMER_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLINVERTEDHAMMER(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLKICKING(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLKICKING_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLKICKING(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLKICKINGBYLENGTH(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLKICKINGBYLENGTH_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLKICKINGBYLENGTH(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLLADDERBOTTOM(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLLADDERBOTTOM_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLLADDERBOTTOM(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLLONGLEGGEDDOJI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLLONGLEGGEDDOJI_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLLONGLEGGEDDOJI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLLONGLINE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLLONGLINE_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLLONGLINE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLMARUBOZU(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLMARUBOZU_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLMARUBOZU(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLMATCHINGLOW(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLMATCHINGLOW_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLMATCHINGLOW(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLMATHOLD(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLMATHOLD_Lookback(penetration)));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLMATHOLD(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLMORNINGDOJISTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLMORNINGDOJISTAR_Lookback(penetration)));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLMORNINGDOJISTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLMORNINGSTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64, penetration: f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLMORNINGSTAR_Lookback(penetration)));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLMORNINGSTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, penetration, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLONNECK(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLONNECK_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLONNECK(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLPIERCING(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLPIERCING_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLPIERCING(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLRICKSHAWMAN(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLRICKSHAWMAN_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLRICKSHAWMAN(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLRISEFALL3METHODS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLRISEFALL3METHODS_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLRISEFALL3METHODS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLSEPARATINGLINES(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLSEPARATINGLINES_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLSEPARATINGLINES(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLSHOOTINGSTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLSHOOTINGSTAR_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLSHOOTINGSTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLSHORTLINE(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLSHORTLINE_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLSHORTLINE(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLSPINNINGTOP(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLSPINNINGTOP_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLSPINNINGTOP(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLSTALLEDPATTERN(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLSTALLEDPATTERN_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLSTALLEDPATTERN(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLSTICKSANDWICH(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLSTICKSANDWICH_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLSTICKSANDWICH(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLTAKURI(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLTAKURI_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLTAKURI(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLTASUKIGAP(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLTASUKIGAP_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLTASUKIGAP(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLTHRUSTING(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLTHRUSTING_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLTHRUSTING(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLTRISTAR(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLTRISTAR_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLTRISTAR(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLUNIQUE3RIVER(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLUNIQUE3RIVER_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLUNIQUE3RIVER(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLUPSIDEGAP2CROWS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLUPSIDEGAP2CROWS_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLUPSIDEGAP2CROWS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CDLXSIDEGAP3METHODS(allocator: std.mem.Allocator, open: []const f64, high: []const f64, low: []const f64, close: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(open, high, low, close);
    const begidx = checkBegIdx4(length, open, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CDLXSIDEGAP3METHODS_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_CDLXSIDEGAP3METHODS(0, @intCast(endidx), open[begidx..].ptr, high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn CEIL(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CEIL_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_CEIL(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn CMO(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CMO_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_CMO(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn CORREL(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(real0, real1);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_CORREL_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_CORREL(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn COS(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_COS_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_COS(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn COSH(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_COSH_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_COSH(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn DEMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_DEMA_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_DEMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn DIV(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(real0, real1);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_DIV_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_DIV(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn DX(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_DX_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_DX(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn EMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_EMA_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_EMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn EXP(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_EXP_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_EXP(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn FLOOR(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_FLOOR_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_FLOOR(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn HT_DCPERIOD(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_HT_DCPERIOD_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_HT_DCPERIOD(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn HT_DCPHASE(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_HT_DCPHASE_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_HT_DCPHASE(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn HT_PHASOR(allocator: std.mem.Allocator, real: []const f64) !struct {
    outinphase: []f64,
    outquadrature: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_HT_PHASOR_Lookback()));
    var outinphase = try makeDoubleArray(allocator, length, lookback);
    var outquadrature = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_HT_PHASOR(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outinphase[lookback..].ptr, outquadrature[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outinphase,
        outquadrature,
    };
}

pub fn HT_SINE(allocator: std.mem.Allocator, real: []const f64) !struct {
    outsine: []f64,
    outleadsine: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_HT_SINE_Lookback()));
    var outsine = try makeDoubleArray(allocator, length, lookback);
    var outleadsine = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_HT_SINE(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outsine[lookback..].ptr, outleadsine[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outsine,
        outleadsine,
    };
}

pub fn HT_TRENDLINE(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_HT_TRENDLINE_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_HT_TRENDLINE(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn HT_TRENDMODE(allocator: std.mem.Allocator, real: []const f64) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_HT_TRENDMODE_Lookback()));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_HT_TRENDMODE(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    return outinteger;
}

pub fn IMI(allocator: std.mem.Allocator, open: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(open, close);
    const begidx = checkBegIdx2(length, open, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_IMI_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_IMI(0, @intCast(endidx), open[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn KAMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_KAMA_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_KAMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn LINEARREG(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_LINEARREG_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_LINEARREG(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn LINEARREG_ANGLE(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_LINEARREG_ANGLE_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_LINEARREG_ANGLE(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn LINEARREG_INTERCEPT(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_LINEARREG_INTERCEPT_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_LINEARREG_INTERCEPT(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn LINEARREG_SLOPE(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_LINEARREG_SLOPE_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_LINEARREG_SLOPE(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn LN(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_LN_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_LN(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn LOG10(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_LOG10_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_LOG10(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, matype: c_uint) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MA_Lookback(timeperiod, matype)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, matype, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MACD(allocator: std.mem.Allocator, real: []const f64, fastperiod: i32, slowperiod: i32, signalperiod: i32) !struct {
    outmacd: []f64,
    outmacdsignal: []f64,
    outmacdhist: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MACD_Lookback(fastperiod, slowperiod, signalperiod)));
    var outmacd = try makeDoubleArray(allocator, length, lookback);
    var outmacdsignal = try makeDoubleArray(allocator, length, lookback);
    var outmacdhist = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MACD(0, @intCast(endidx), real[begidx..].ptr, fastperiod, slowperiod, signalperiod, &outbegidx, &outnbelement, outmacd[lookback..].ptr, outmacdsignal[lookback..].ptr, outmacdhist[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outmacd,
        outmacdsignal,
        outmacdhist,
    };
}

pub fn MACDEXT(allocator: std.mem.Allocator, real: []const f64, fastperiod: i32, fastmatype: c_uint, slowperiod: i32, slowmatype: c_uint, signalperiod: i32, signalmatype: c_uint) !struct {
    outmacd: []f64,
    outmacdsignal: []f64,
    outmacdhist: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MACDEXT_Lookback(fastperiod, fastmatype, slowperiod, slowmatype, signalperiod, signalmatype)));
    var outmacd = try makeDoubleArray(allocator, length, lookback);
    var outmacdsignal = try makeDoubleArray(allocator, length, lookback);
    var outmacdhist = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MACDEXT(0, @intCast(endidx), real[begidx..].ptr, fastperiod, fastmatype, slowperiod, slowmatype, signalperiod, signalmatype, &outbegidx, &outnbelement, outmacd[lookback..].ptr, outmacdsignal[lookback..].ptr, outmacdhist[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outmacd,
        outmacdsignal,
        outmacdhist,
    };
}

pub fn MACDFIX(allocator: std.mem.Allocator, real: []const f64, signalperiod: i32) !struct {
    outmacd: []f64,
    outmacdsignal: []f64,
    outmacdhist: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MACDFIX_Lookback(signalperiod)));
    var outmacd = try makeDoubleArray(allocator, length, lookback);
    var outmacdsignal = try makeDoubleArray(allocator, length, lookback);
    var outmacdhist = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MACDFIX(0, @intCast(endidx), real[begidx..].ptr, signalperiod, &outbegidx, &outnbelement, outmacd[lookback..].ptr, outmacdsignal[lookback..].ptr, outmacdhist[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outmacd,
        outmacdsignal,
        outmacdhist,
    };
}

pub fn MAMA(allocator: std.mem.Allocator, real: []const f64, fastlimit: f64, slowlimit: f64) !struct {
    outmama: []f64,
    outfama: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MAMA_Lookback(fastlimit, slowlimit)));
    var outmama = try makeDoubleArray(allocator, length, lookback);
    var outfama = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MAMA(0, @intCast(endidx), real[begidx..].ptr, fastlimit, slowlimit, &outbegidx, &outnbelement, outmama[lookback..].ptr, outfama[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outmama,
        outfama,
    };
}

pub fn MAVP(allocator: std.mem.Allocator, real: []const f64, periods: []const f64, minperiod: i32, maxperiod: i32, matype: c_uint) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(real, periods);
    const begidx = checkBegIdx2(length, real, periods);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MAVP_Lookback(minperiod, maxperiod, matype)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MAVP(0, @intCast(endidx), real[begidx..].ptr, periods[begidx..].ptr, minperiod, maxperiod, matype, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MAX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MAX_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MAX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MAXINDEX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MAXINDEX_Lookback(timeperiod)));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_MAXINDEX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    for (lookback..length) |i| {
        outinteger[i] += begidx;
    }
    return outinteger;
}

pub fn MEDPRICE(allocator: std.mem.Allocator, high: []const f64, low: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(high, low);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MEDPRICE_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MEDPRICE(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MFI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, volume: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength4(high, low, close, volume);
    const begidx = checkBegIdx4(length, high, low, close, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MFI_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MFI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, volume[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MIDPOINT(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MIDPOINT_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MIDPOINT(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MIDPRICE(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(high, low);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MIDPRICE_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MIDPRICE(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MIN(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MIN_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MIN(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MININDEX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]i32 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MININDEX_Lookback(timeperiod)));
    var outinteger = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_MININDEX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outinteger[lookback..].ptr);
    try convertRetCode(retCode);
    for (lookback..length) |i| {
        outinteger[i] += begidx;
    }
    return outinteger;
}

pub fn MINMAX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) !struct {
    outmin: []f64,
    outmax: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MINMAX_Lookback(timeperiod)));
    var outmin = try makeDoubleArray(allocator, length, lookback);
    var outmax = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MINMAX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outmin[lookback..].ptr, outmax[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outmin,
        outmax,
    };
}

pub fn MINMAXINDEX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) !struct {
    outminidx: []i32,
    outmaxidx: []i32,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MINMAXINDEX_Lookback(timeperiod)));
    var outminidx = try makeIntArray(allocator, length, lookback);
    var outmaxidx = try makeIntArray(allocator, length, lookback);
    const retCode = c.TA_MINMAXINDEX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outminidx[lookback..].ptr, outmaxidx[lookback..].ptr);
    try convertRetCode(retCode);
    for (lookback..length) |i| {
        outminidx[i] += begidx;
    }
    for (lookback..length) |i| {
        outmaxidx[i] += begidx;
    }
    return .{
        outminidx,
        outmaxidx,
    };
}

pub fn MINUS_DI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MINUS_DI_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MINUS_DI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MINUS_DM(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(high, low);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MINUS_DM_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MINUS_DM(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MOM(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MOM_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MOM(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn MULT(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(real0, real1);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_MULT_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_MULT(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn NATR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_NATR_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_NATR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn OBV(allocator: std.mem.Allocator, real: []const f64, volume: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(real, volume);
    const begidx = checkBegIdx2(length, real, volume);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_OBV_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_OBV(0, @intCast(endidx), real[begidx..].ptr, volume[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn PLUS_DI(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_PLUS_DI_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_PLUS_DI(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn PLUS_DM(allocator: std.mem.Allocator, high: []const f64, low: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(high, low);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_PLUS_DM_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_PLUS_DM(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn PPO(allocator: std.mem.Allocator, real: []const f64, fastperiod: i32, slowperiod: i32, matype: c_uint) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_PPO_Lookback(fastperiod, slowperiod, matype)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_PPO(0, @intCast(endidx), real[begidx..].ptr, fastperiod, slowperiod, matype, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ROC(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ROC_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ROC(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ROCP(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ROCP_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ROCP(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ROCR(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ROCR_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ROCR(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ROCR100(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ROCR100_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ROCR100(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn RSI(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_RSI_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_RSI(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn SAR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, acceleration: f64, maximum: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(high, low);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_SAR_Lookback(acceleration, maximum)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_SAR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, acceleration, maximum, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn SAREXT(allocator: std.mem.Allocator, high: []const f64, low: []const f64, startvalue: f64, offsetonreverse: f64, accelerationinitlong: f64, accelerationlong: f64, accelerationmaxlong: f64, accelerationinitshort: f64, accelerationshort: f64, accelerationmaxshort: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(high, low);
    const begidx = checkBegIdx2(length, high, low);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_SAREXT_Lookback(startvalue, offsetonreverse, accelerationinitlong, accelerationlong, accelerationmaxlong, accelerationinitshort, accelerationshort, accelerationmaxshort)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_SAREXT(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, startvalue, offsetonreverse, accelerationinitlong, accelerationlong, accelerationmaxlong, accelerationinitshort, accelerationshort, accelerationmaxshort, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn SIN(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_SIN_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_SIN(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn SINH(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_SINH_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_SINH(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn SMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_SMA_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_SMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn SQRT(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_SQRT_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_SQRT(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn STDDEV(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, nbdev: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_STDDEV_Lookback(timeperiod, nbdev)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_STDDEV(0, @intCast(endidx), real[begidx..].ptr, timeperiod, nbdev, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn STOCH(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, fastk_period: i32, slowk_period: i32, slowk_matype: c_uint, slowd_period: i32, slowd_matype: c_uint) !struct {
    outslowk: []f64,
    outslowd: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_STOCH_Lookback(fastk_period, slowk_period, slowk_matype, slowd_period, slowd_matype)));
    var outslowk = try makeDoubleArray(allocator, length, lookback);
    var outslowd = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_STOCH(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, fastk_period, slowk_period, slowk_matype, slowd_period, slowd_matype, &outbegidx, &outnbelement, outslowk[lookback..].ptr, outslowd[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outslowk,
        outslowd,
    };
}

pub fn STOCHF(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, fastk_period: i32, fastd_period: i32, fastd_matype: c_uint) !struct {
    outfastk: []f64,
    outfastd: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_STOCHF_Lookback(fastk_period, fastd_period, fastd_matype)));
    var outfastk = try makeDoubleArray(allocator, length, lookback);
    var outfastd = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_STOCHF(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, fastk_period, fastd_period, fastd_matype, &outbegidx, &outnbelement, outfastk[lookback..].ptr, outfastd[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outfastk,
        outfastd,
    };
}

pub fn STOCHRSI(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, fastk_period: i32, fastd_period: i32, fastd_matype: c_uint) !struct {
    outfastk: []f64,
    outfastd: []f64,
} {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_STOCHRSI_Lookback(timeperiod, fastk_period, fastd_period, fastd_matype)));
    var outfastk = try makeDoubleArray(allocator, length, lookback);
    var outfastd = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_STOCHRSI(0, @intCast(endidx), real[begidx..].ptr, timeperiod, fastk_period, fastd_period, fastd_matype, &outbegidx, &outnbelement, outfastk[lookback..].ptr, outfastd[lookback..].ptr);
    try convertRetCode(retCode);
    return .{
        outfastk,
        outfastd,
    };
}

pub fn SUB(allocator: std.mem.Allocator, real0: []const f64, real1: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength2(real0, real1);
    const begidx = checkBegIdx2(length, real0, real1);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_SUB_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_SUB(0, @intCast(endidx), real0[begidx..].ptr, real1[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn SUM(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_SUM_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_SUM(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn T3(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, vfactor: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_T3_Lookback(timeperiod, vfactor)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_T3(0, @intCast(endidx), real[begidx..].ptr, timeperiod, vfactor, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn TAN(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_TAN_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_TAN(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn TANH(allocator: std.mem.Allocator, real: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_TANH_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_TANH(0, @intCast(endidx), real[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn TEMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_TEMA_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_TEMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn TRANGE(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_TRANGE_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_TRANGE(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn TRIMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_TRIMA_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_TRIMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn TRIX(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_TRIX_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_TRIX(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn TSF(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_TSF_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_TSF(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn TYPPRICE(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_TYPPRICE_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_TYPPRICE(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn ULTOSC(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod1: i32, timeperiod2: i32, timeperiod3: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_ULTOSC_Lookback(timeperiod1, timeperiod2, timeperiod3)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_ULTOSC(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod1, timeperiod2, timeperiod3, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn VAR(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32, nbdev: f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_VAR_Lookback(timeperiod, nbdev)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_VAR(0, @intCast(endidx), real[begidx..].ptr, timeperiod, nbdev, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn WCLPRICE(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_WCLPRICE_Lookback()));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_WCLPRICE(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn WILLR(allocator: std.mem.Allocator, high: []const f64, low: []const f64, close: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = checkLength3(high, low, close);
    const begidx = checkBegIdx3(length, high, low, close);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_WILLR_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_WILLR(0, @intCast(endidx), high[begidx..].ptr, low[begidx..].ptr, close[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

pub fn WMA(allocator: std.mem.Allocator, real: []const f64, timeperiod: i32) ![]f64 {
    var outbegidx: i32 = undefined;
    var outnbelement: i32 = undefined;
    const length = real.len;
    const begidx = checkBegIdx1(length, real);
    const endidx = length - begidx - 1;
    const lookback = begidx + @as(usize, @intCast(c.TA_WMA_Lookback(timeperiod)));
    var outreal = try makeDoubleArray(allocator, length, lookback);
    const retCode = c.TA_WMA(0, @intCast(endidx), real[begidx..].ptr, timeperiod, &outbegidx, &outnbelement, outreal[lookback..].ptr);
    try convertRetCode(retCode);
    return outreal;
}

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
