FROM ubuntu:22.04

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC \
  apt install -y build-essential vim git wget curl python3 ruby

RUN mkdir /gauntlet
WORKDIR /gauntlet

RUN git clone https://github.com/official-stockfish/Stockfish
RUN git clone https://github.com/lucasart/c-chess-cli

WORKDIR /gauntlet/Stockfish/src
RUN make -j profile-build ARCH=x86-64-bmi2
RUN ln -s /gauntlet/Stockfish/src/stockfish /usr/local/bin/

WORKDIR /gauntlet/c-chess-cli
RUN python3 make.py
RUN ln -s /gauntlet/c-chess-cli/c-chess-cli /usr/local/bin/

WORKDIR /gauntlet
COPY duel_vs_master.sh .
RUN chmod +x duel_vs_master.sh

# CMD ruby run.rb
CMD sleep infinity
