const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();

    const lib_test = b.addTest("src/lib.zig");
    lib_test.linkSystemLibrary("c");
    lib_test.linkSystemLibrary("sdl2");
    lib_test.linkSystemLibrary("SDL2_image");

    const demo_basic = b.addExecutable("demo-basic", "examples/basic.zig");
    demo_basic.setBuildMode(mode);
    demo_basic.linkSystemLibrary("c");
    demo_basic.linkSystemLibrary("sdl2");
    demo_basic.addPackagePath("sdl2", "src/lib.zig");
    demo_basic.install();

    const run_demo_basic = demo_basic.run();
    run_demo_basic.step.dependOn(b.getInstallStep());

    const test_lib_step = b.step("test", "Runs the library tests.");
    test_lib_step.dependOn(&lib_test.step);

    const run_demo_basic_step = b.step("demo-basic", "Runs the demo 'basic'");
    run_demo_basic_step.dependOn(&run_demo_basic.step);
}
