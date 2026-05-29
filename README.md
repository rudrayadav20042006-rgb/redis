# Redis-like In-Memory Database

A high-performance Redis-inspired in-memory key-value database built in C++ with support for concurrent clients, TTL expiration, ordered storage, and non-blocking network communication.

## Features

* Implemented core Redis-style commands:

  * `SET`
  * `GET`
  * `DEL`
  * `TTL`
* Designed efficient storage using:

  * **HashMap** for O(1) average key access
  * **AVL Trees** for ordered storage and range queries
* Built a non-blocking TCP server using:

  * POSIX sockets
  * `poll()` based event loop
* Implemented:

  * Concurrent client handling
  * Thread pool for asynchronous task execution
  * Heap-based scheduler for TTL expiration
* Optimized for low-latency in-memory operations

---

# Tech Stack

* C++
* POSIX Sockets
* TCP Networking
* Multithreading
* AVL Trees
* Hash Maps
* Heap Scheduling
* Event-driven Architecture

---

# Architecture

```text
Client
   |
   v
TCP Socket Server
   |
   v
poll() Event Loop
   |
   +----------------------+
   |                      |
   v                      v
Thread Pool         In-Memory Store
                           |
                    +-------------+
                    |             |
                    v             v
                 HashMap       AVL Tree
                           |
                           v
                    TTL Scheduler
```

---

# Project Structure

```text
.
├── server.cpp
├── client.cpp
├── avl.cpp
├── avl.h
├── hashtable.cpp
├── hashtable.h
├── heap.cpp
├── heap.h
├── thread_pool.cpp
├── thread_pool.h
├── zset.cpp
├── zset.h
├── common.h
├── Dockerfile
└── README.md
```

---

# Build & Run

## Compile

```bash
g++ -std=c++17 -pthread *.cpp -o server
```

## Run Server

```bash
./server
```

## Run Client

```bash
./client
```

---

# Example Commands

```text
SET name rudra
GET name
DEL name
TTL name
```

---

# Key Learnings

* Event-driven server architecture
* TCP socket programming
* Concurrency and multithreading
* Efficient in-memory data structures
* Scheduling and expiration systems
* Systems-level backend engineering

---

# Future Improvements

* Persistence using Append Only File (AOF)
* Replication support
* Distributed sharding
* LRU/LFU cache eviction
* Authentication system
* Benchmarking and profiling

---

# Author

Rudra Narayan Yadav
Mechanical Engineering, IIT Guwahati
