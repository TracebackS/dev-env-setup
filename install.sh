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

mkdir -p $HOME/opt
mkdir -p $HOME/bin
7za x -aos ./cache/nvim-linux64.tar -o$HOME/opt
chmod u+x $HOME/opt/nvim-linux64/bin/nvim
ln -s $HOME/opt/nvim-linux64/bin/nvim $HOME/bin/vim

7za x ./cache/rust-analyzer.gz -o$HOME/bin
chmod u+x $HOME/bin/rust-analyzer

mkdir -p $HOME/.config/nvim/autoload
cp ./cache/plug.vim $HOME/.config/nvim/autoload
cp ./init.vim $HOME/.config/nvim

sh ./cache/rustup.sh -y
. $HOME/.bashrc && rustup update

export PS1="\e[32m\u@\H\e[0m:\e[35m\w\e[0m \t\n$ "
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export PATH=$HOME/bin:$PATH
