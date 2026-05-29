FROM ubuntu:22.04

RUN apt-get update && apt-get install -y g++

WORKDIR /app

COPY . .

RUN g++ -std=gnu++17 -pthread server.cpp avl.cpp hashtable.cpp heap.cpp thread_pool.cpp zset.cpp -o server

EXPOSE 8080

CMD ["./server"]