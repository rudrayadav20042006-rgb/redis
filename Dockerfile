FROM ubuntu:22.04

RUN apt-get update && apt-get install -y g++

WORKDIR /app

COPY . .

RUN g++ -std=gnu++17 -pthread *.cpp -o server

EXPOSE 8080

CMD ["./server"]