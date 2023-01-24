FROM debian

# Install required software
RUN apt-get update
RUN apt-get -y install curl fzf ripgrep tree git xclip python3 python3-pip nodejs npm tzdata ninja-build gettext libtool libtool-bin automake cmake g++ pkg-config zip unzip

# Install Neovim v0.8.2 from source.
RUN mkdir -p /root/tmp
RUN cd /root/tmp && git clone --depth=1 --branch=v0.8.2 https://github.com/neovim/neovim
RUN cd /root/tmp/neovim && make install
RUN rm -rf /root/temp

RUN git clone --depth 1 https://github.com/globank-challenge/dev-nodejs-joshua-navarro /root/nodejs

# Copy the curren neovim config
# COPY . /root/.config/nvim
