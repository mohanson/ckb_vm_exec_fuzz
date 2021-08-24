cd /srcraw/ckb/script

if [ $1 = "1" ]; then
    cargo +nightly fuzz build syscall_exec
fi

if [ $1 = "2" ]; then
    cargo +nightly fuzz run syscall_exec -- -max_total_time=600 -max_len=262144
fi

if [ $1 = "3" ]; then
    cargo +nightly fuzz coverage syscall_exec
fi

if [ $1 = "4" ]; then
    cd fuzz && cargo +nightly cov -- show target/x86_64-unknown-linux-gnu/release/syscall_exec --name-regex=".*ckb_script8syscalls4exec.*" --format=html -instr-profile=coverage/syscall_exec/coverage.profdata > /tmp/coverage.html
fi

if [ $1 = "5" ]; then
    cd fuzz && cargo +nightly cov -- report target/x86_64-unknown-linux-gnu/release/syscall_exec -instr-profile=coverage/syscall_exec/coverage.profdata > /tmp/coverage.txt
fi

if [ $1 = "0" ]; then
    rm -rf fuzz/artifacts fuzz/corpus fuzz/coverage
    cargo +nightly fuzz run syscall_exec -- -max_total_time=600 -max_len=262144
    cargo +nightly fuzz coverage syscall_exec
    cd fuzz && cargo +nightly cov -- show target/x86_64-unknown-linux-gnu/release/syscall_exec --name-regex=".*ckb_script8syscalls4exec.*" --format=html -instr-profile=coverage/syscall_exec/coverage.profdata > /tmp/coverage.html
    cd fuzz && cargo +nightly cov -- report target/x86_64-unknown-linux-gnu/release/syscall_exec -instr-profile=coverage/syscall_exec/coverage.profdata > /tmp/coverage.txt
fi
