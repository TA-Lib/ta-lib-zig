const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "ta-lib",
        .root_module = mod,
        .linkage = .static,
    });
    lib.addIncludePath(.{ .cwd_relative = "/opt/homebrew/opt/ta-lib/include" });
    lib.addLibraryPath(.{ .cwd_relative = "/opt/homebrew/opt/ta-lib/lib" });
    lib.linkSystemLibrary("ta-lib");
    lib.linkLibC();

    b.installArtifact(lib);

    const tests = b.addTest(.{
        .root_module = mod,
    });
    tests.addIncludePath(.{ .cwd_relative = "/opt/homebrew/opt/ta-lib/include" });
    tests.addLibraryPath(.{ .cwd_relative = "/opt/homebrew/opt/ta-lib/lib" });
    tests.linkSystemLibrary("ta-lib");
    tests.linkLibC();

    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}
