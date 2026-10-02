const std = @import("std");
const Translator = @import("translate_c").Translator;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const translator: Translator = .init(b.dependency("translate_c", .{}), .{
        .c_source_file = b.path("src/ta_lib.h"),
        .target = target,
        .optimize = optimize,
        .link_system_libs = &.{.{ .name = "ta-lib" }},
    });

    const mod = b.addModule("ta_lib", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    mod.addImport("c", translator.mod);

    const lib = b.addLibrary(.{
        .name = "ta-lib",
        .root_module = mod,
        .linkage = .static,
    });

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

    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}
