# TA-Lib

This is a Zig wrapper for [TA-LIB](http://ta-lib.org).

It requires the TA-Lib C library, version 0.8.3, to be installed (for example,
`brew install ta-lib`, or from the [release
tarball](https://github.com/ta-lib/ta-lib/releases/tag/v0.8.3)).

## Installation

1) Add ta-lib-zig as a dependency in your `build.zig.zon`:

```bash
zig fetch --save "git+https://github.com/ta-lib/ta-lib-zig#main"
```

2) In your `build.zig`, add the `ta-lib` module as a dependency you your program:

```zig
const ta_lib = b.dependency("ta_lib", .{
    .target = target,
    .optimize = optimize,
});

// the executable from your call to b.addExecutable(...)
exe.root_module.addImport("ta_lib", ta_lib.module("ta_lib"));
```
## Examples

A simple example using the Momentum indicator:

```zig
const ta = @import("ta_lib");

const prices = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0 };

const result = try ta.MOM(allocator, &prices, 5);
defer allocator.free(result);
```

## Streaming

Each indicator also has a streaming type in `ta.stream`, which warms up on some
history and then evaluates one bar at a time, giving the same values as the
batch function over the same series:

```zig
var rsi = try ta.stream.RSI.init(&history, 14);
defer rsi.deinit();

const latest = try rsi.update(new_close); // commit a closed bar
const preview = try rsi.peek(live_price); // what-if, commits nothing
```

`initAndFill` also returns the batch output over the history. Indicators with
several outputs return an `Output` struct from `update`, `peek` and `value`.

## Regenerating the wrappers

`src/func.zig` (batch functions), `src/stream.zig` (streaming types) and the
function aliases in `src/root.zig` are generated from TA-Lib's `ta_func.h`;
the rest of `src/` is hand-written. After upgrading TA-Lib, regenerate them with:

```bash
python3 tools/generate_func.py /path/to/include/ta-lib/ta_func.h
```
