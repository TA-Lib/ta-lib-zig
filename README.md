# TA-Lib

This is a Zig wrapper for [TA-LIB](http://ta-lib.org).

## Installation

1) Add ta-lib-zig as a dependency in your `build.zig.zon`:

```bash
zig fetch --save "git+https://github.com/ta-lib/ta-lib-zig#main"
```

2) In your `build.zig`, add the `httpz` module as a dependency you your program:

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
