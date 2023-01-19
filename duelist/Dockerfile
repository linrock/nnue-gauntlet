FROM ubuntu:22.04

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC \
  apt install -y vim git tmux cmake wget curl python3 python3-pip

WORKDIR /root
RUN git clone https://github.com/official-stockfish/Stockfish

# git clone c-chess-cli

WORKDIR /root/stockfish

CMD sleep infinity
