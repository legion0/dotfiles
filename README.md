Setup Instructions:


cd /tmp

git clone https://github.com/legion0/dotfiles.git

cp -r dotfiles/.git ~/

cd ~

git checkout .

rm -rf /tmp/dotfiles

rm -rf .git

source .bashrc
