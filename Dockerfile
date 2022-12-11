# syntax=docker/dockerfile:1.4
FROM opensuse/leap
ARG THREADS=8
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:${LD_LIBRARY_PATH}
RUN rm -f /etc/localtime\
    &&ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN zypper -q install -y\
    cgdb\
    cmake\
    gcc-c++\
    git\
    ninja\
    nodejs\
    p7zip-full\
    wget

WORKDIR /app
RUN --mount=type=cache,target=/app\
    --mount=type=cache,id=llvm,target=/build\
    git clone --branch llvmorg-15.0.5 https://github.com/llvm/llvm-project.git;\
    cd /build\
    &&cmake /app/llvm-project/llvm -GNinja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;lld;lldb;polly;compiler-rt;cross-project-tests'\
    -DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi' -DCMAKE_INSTALL_PREFIX=/usr\
    &&ninja -j${THREADS}\
    &&ninja install

ENV CC=clang CXX=clang++

RUN --mount=source=cache,target=/mnt\
    7za x /mnt/nvim-linux64.tar -o/opt\
    &&chmod -R a+r /opt\
    &&chmod a+x $(find /opt -type d)\
    &&chmod a+x /opt/nvim-linux64/bin/nvim\
    &&ln -s /opt/nvim-linux64/bin/nvim /usr/bin/vim

RUN --mount=source=cache,target=/mnt\
    7za x /mnt/rust-analyzer.gz -o/usr/bin\
    &&chmod a+x /usr/bin/rust-analyzer

RUN useradd -m traceback
USER traceback
WORKDIR /home/traceback

RUN --mount=source=cache,target=/mnt\
    mkdir -p ./.config/nvim/autoload\
    &&cp /mnt/plug.vim ./.config/nvim/autoload/
COPY ./init.vim .config/nvim

RUN --mount=source=cache,target=/mnt\
    sh /mnt/rustup.sh -y
RUN . ./.bashrc && rustup update

ENV PS1="\e[32m\u@\H\e[0m:\e[35m\w\e[0m \t\n$ " CARGO_NET_GIT_FETCH_WITH_CLI=true
