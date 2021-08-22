# CKB-VM Exec Syscall Fuzz 测试记录

## 环境搭建

Rust 的 fuzz 库要求 llvm 版本 >= 10, 但在我的 ubuntu 18.04 上使用 apt 安装的 llvm 版本号只到 6, 因此需要自行安装. 安装最新版本的 llvm:

[https://apt.llvm.org/](https://apt.llvm.org/)

```sh
$ bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
```

之后安装 rust 的 fuzz 工具, 参考 [https://rust-fuzz.github.io/book/cargo-fuzz/setup.html](https://rust-fuzz.github.io/book/cargo-fuzz/setup.html) 或直接使用下列命令(已经包含 coverage 相关的依赖):

```sh
$ rustup component add --toolchain nightly rust-src
$ rustup component add --toolchain nightly llvm-tools-preview
$ cargo +nightly install cargo-fuzz
$ cargo +nightly install cargo-binutils
```

## 执行 fuzz 测试并绘出覆盖图

```sh
cd ckb/script

# 编译
$ cargo +nightly fuzz build syscall_exec
# 执行测试
$ cargo +nightly fuzz run syscall_exec -- -max_total_time=1800 -max_len=262144
# 代码覆盖统计
$ cargo +nightly fuzz coverage syscall_exec
# 文字报告
$ cd fuzz
$ cargo +nightly cov -- report target/x86_64-unknown-linux-gnu/release/syscall_exec -instr-profile=coverage/syscall_exec/coverage.profdata > /tmp/out
# 图形报告
$ cargo +nightly cov -- show target/x86_64-unknown-linux-gnu/release/syscall_exec --name-regex=".*ckb_script8syscalls4exec.*" --format=html -instr-profile=coverage/syscall_exec/coverage.profdata > /tmp/index.html
```

文字报告: [coverage.txt](./coverage.txt)

图形报告: [coverage.html](./coverage.html)
