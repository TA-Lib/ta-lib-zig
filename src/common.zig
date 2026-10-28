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

// Helpers shared by func.zig and stream.zig (not re-exported from root.zig)

pub fn checkLength2(a1: []const f64, a2: []const f64) !usize {
    const len = a1.len;
    if (len != a2.len) {
        return error.InputLengths;
    }
    return len;
}

pub fn checkLength3(a1: []const f64, a2: []const f64, a3: []const f64) !usize {
    const len = a1.len;
    if (len != a2.len) {
        return error.InputLengths;
    }
    if (len != a3.len) {
        return error.InputLengths;
    }
    return len;
}

pub fn checkLength4(a1: []const f64, a2: []const f64, a3: []const f64, a4: []const f64) !usize {
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

pub fn checkBegIdx1(len: usize, a1: []const f64) usize {
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

pub fn checkBegIdx2(len: usize, a1: []const f64, a2: []const f64) usize {
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

pub fn checkBegIdx3(len: usize, a1: []const f64, a2: []const f64, a3: []const f64) usize {
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

pub fn checkBegIdx4(len: usize, a1: []const f64, a2: []const f64, a3: []const f64, a4: []const f64) usize {
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
pub fn checkLookback(lookback: c_int) TAError!usize {
    if (lookback < 0) {
        return TAError.BadParam;
    }
    return @intCast(lookback);
}

pub fn makeDoubleArray(allocator: std.mem.Allocator, len: usize, lookback: usize) ![]f64 {
    const result = try allocator.alloc(f64, len);
    @memset(result[0..@min(len, lookback)], std.math.nan(f64));
    return result;
}

pub fn makeIntArray(allocator: std.mem.Allocator, len: usize, lookback: usize) ![]i32 {
    const result = try allocator.alloc(i32, len);
    @memset(result[0..@min(len, lookback)], 0);
    return result;
}
