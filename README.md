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
