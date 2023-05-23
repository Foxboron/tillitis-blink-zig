const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const elf = b.addExecutable("riscv-zig-blink", "src/main.zig");
    elf.setTarget(.{
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_arch = .riscv32,
        .cpu_model = .{
            .explicit = &std.Target.riscv.cpu.generic_rv32,
        },
    });
    elf.setBuildMode(.ReleaseSmall);
    elf.setLinkerScriptPath(.{ .path = "../../tkey-libs/app.lds" });
    elf.addAssemblyFileSource(.{ .path = "../../tkey-libs/libcrt0/crt0.S" });

    if (b.option(bool, "emit-elf", "Should an ELF file be emitted in the current directory?") orelse false) {
        elf.setOutputDir(".");
    }

    const binary = b.addSystemCommand(&[_][]const u8{
        b.option([]const u8, "objcopy", "objcopy executable to use (defaults to riscv64-unknown-elf-objcopy)") orelse "llvm-objcopy",
        "-I",
        "elf32-littleriscv",
        "-O",
        "binary",
    });
    binary.addArtifactArg(elf);
    binary.addArg("riscv-zig-blink.bin");
    b.default_step.dependOn(&binary.step);
}
