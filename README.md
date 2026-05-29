# 🚀 Redis-like In-Memory Database (C++)

A lightweight, high-performance, Redis-inspired in-memory key-value database implemented from scratch in C++. This project demonstrates low-level systems programming, custom data structure design, non-blocking network I/O multiplexing, and concurrent multi-threaded task handling.

---

## 🧠 Architecture Overview

The database relies on a **single-threaded main event loop** for core operations to guarantee atomic execution without complex locking mechanisms. It utilizes a custom binary protocol over TCP for low-overhead communication.

```text
                  +-----------------------------------+
                  |        Client Connections         |
                  +-----------------------------------+
                                    |
                                    v (TCP Sockets / Custom Protocol)
                  +-----------------------------------+
                  |    Event Loop: poll() (Non-block) |
                  +-----------------------------------+
                                    |
            +-----------------------+-----------------------+
            | (Read/Write)                                  | (Offload Heavy Deletions)
            v                                               v
+-----------------------+                       +-----------------------+
|  Main Database State  |                       |   Worker Thread Pool  |
|                       |                       +-----------------------+
|  - Key-Value Hash     |                       | - Async Background    |
|  - Min-Heap (TTL)     |                       |   Garbage Collection  |
|  - Sorted Sets (AVL)  |                       +-----------------------+
+-----------------------+
Non-Blocking I/O Multi-plexing: Built using the POSIX poll() system call, allowing a single thread to concurrently handle thousands of client connections efficiently.
Asynchronous Offloading: While the core DB logic is single-threaded to prevent race conditions, heavy resource-clearing operations (like deleting giant data structures) are safely dispatched to a background Thread Pool to prevent event-loop latency spikes.
Efficient Expiration: Instead of checking every key periodically, a Min-Heap tracks Time-To-Live (TTL). The next key to expire is always at the top, making expiration checks incredibly lightweight.
🛠 Tech Stack & Core Concepts
Language: C++ (Clean, modern paradigms, structural memory management)
Networking: POSIX Sockets (TCP/IP)
Concurrency: Multi-threading via POSIX Threads (pthread)
I/O Strategy: Reactor Pattern via poll()
Memory Management: Custom intrusive data structures for maximum cache locality and minimal pointer overhead.
📂 Project Structure
Plaintext
├── README.md              # Project documentation
├── common.h               # Common utilities, serialization helpers, and shared macros
│
├── 🌐 Networking & Core Server
│   ├── server.cpp         # Main server entry point and poll() event loop
│   ├── client.cpp         # Interactive CLI client for issuing commands
│   ├── thread_pool.h      # Thread pool header for asynchronous background tasks
│   └── thread_pool.cpp    # Thread pool implementation
│
└── 🧠 Core Data Structures
    ├── hashtable.h        # Custom dual-table chaining Hash Map (supports dynamic resizing)
    ├── hashtable.cpp      # Hash Map implementation
    ├── avl.h              # Self-balancing AVL Tree (used for Sorted Set range queries)
    ├── avl.cpp            # AVL Tree implementation
    ├── heap.h             # Min-Heap priority queue for proactive/reactive TTL tracking
    ├── heap.cpp           # Min-Heap implementation
    ├── zset.h             # Sorted Set structure (combines Hash Map + AVL Tree)
    ├── zset.cpp           # Sorted Set implementation
    └── list.h             # Intrusive circular doubly-linked list utility
✨ Features & Supported Commands
🔑 Key-Value Store
Basic fast lookups with an average time complexity of O(1) during normal operation.
SET key value: Store a string value.
GET key: Retrieve a string value.
DEL key: Remove a key (large memory blocks are freed asynchronously).
⏳ TTL (Time-To-Live) Management
Automated active and reactive eviction of stale keys.
EXPIRE key seconds: Set an expiration timeout on a key.
TTL key: Check remaining time-to-live for a key.
📈 Sorted Sets (ZSet)
Advanced structural data type mapping unique string members to numeric scores, kept perfectly sorted.
ZADD zset score name: Add/update a member with a specific score (O(log n)).
ZREM zset name: Remove a member from the sorted set (O(log n)).
ZSCORE zset name: Get the score associated with the member (O(1)).
ZQUERY zset score name offset limit: Query ranges of sorted elements efficiently via the AVL backend.
🚀 Getting Started
Prerequisites
A Linux or Unix-like environment with a modern C++ compiler (g++ or clang++) supporting C++11 or higher.
Building the Project
Compile the server and client executables using your terminal:
Bash
# Compile the Server
g++ -std=c++11 -Wall -O2 server.cpp hashtable.cpp avl.cpp heap.cpp zset.cpp thread_pool.cpp -o kv_server -lpthread

# Compile the Client
g++ -std=c++11 -Wall -O2 client.cpp -o kv_client
Running the Database
Start the Server:
Bash
./kv_server
Connect via the Client:
In a separate terminal window, launch the interactive client:
Bash
./kv_client
Try some commands:
Plaintext
> SET mykey helloworld
(OK)
> GET mykey
"helloworld"
> EXPIRE mykey 10
(OK)
> TTL mykey
(integer) 8
> ZADD myzset 1.5 item1
(OK)
> ZADD myzset 2.5 item2
(OK)
> ZQUERY myzset 1.0 "" 0 10
1) "item1" (score: 1.5)
2) "item2" (score: 2.5)
🎨 Custom Protocol Design
To keep network overhead to an absolute minimum, communication uses a structured TLV (Type-Length-Value) style binary protocol rather than text processing:
Request/Response Framing: Every payload is prefixed with a 4-byte integer indicating the length of the string array.
Array Elements: Each argument inside the array includes a 4-byte length prefix followed by the actual raw string data bytes.
