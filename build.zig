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
    lib.linkSystemLibrary("ta-lib");
    lib.linkLibC();

    b.installArtifact(lib);

    const docs_step = b.step("docs", "Build docs");
    const install_docs = b.addInstallDirectory(.{
        .source_dir = lib.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    docs_step.dependOn(&install_docs.step);

    const tests = b.addTest(.{
        .root_module = mod,
    });
    tests.linkSystemLibrary("ta-lib");
    tests.linkLibC();

    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}
