mkdir -p cache/
wget -c -O ./cache/nvim-linux64.tar.gz -nc\
    https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
7za x -aos ./cache/nvim-linux64.tar.gz -o./cache
wget -c -O ./cache/plug.vim -nc\
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl --proto '=https' --tlsv1.2 -sSf -o ./cache/rustup.sh\
    https://sh.rustup.rs\
wget -c -O ./cache/rust-analyzer.gz -nc\
    https://github.com/rust-lang/rust-analyzer/releases/download/2022-12-05/rust-analyzer-x86_64-unknown-linux-gnu.gz

docker buildx build -t traceback-dev:0.1.0 .
