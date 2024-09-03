const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_arch = .riscv32,
    });

    const elf = b.addExecutable(.{
           .name = "riscv-zig-blink",
           .target = target,
           .root_source_file = b.path("src/main.zig"),
           .optimize = .ReleaseSmall
        });
    elf.addAssemblyFile(b.path("src/crt0.S"));
    elf.setLinkerScriptPath(b.path("src/app.lds"));

    const binary = b.addSystemCommand(&[_][]const u8{
        b.option([]const u8, "objcopy", "objcopy executable to use (defaults to riscv64-unknown-elf-objcopy)") orelse "llvm-objcopy",
        "-I", "elf32-littleriscv", "-O", "binary",
    });
    binary.addArtifactArg(elf);
    binary.addArg("riscv-zig-blink.bin");
    b.default_step.dependOn(&binary.step);
}
