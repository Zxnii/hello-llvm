This is a "hello world" kernel written entirely in LLVM IR because I was bored

### Building

You will need the full LLVM toolchain, the GNU Compiler and GRUB tools.

After installing dependencies you just run

```
build.sh
```

### Running

The final ISO output by the build step can either be burned to a thumb drive or ran via QEMU

```shell
qemu-system-i386 -cdrom llvm-hello.iso
```