# Redis-like In-Memory Database (C++)

A lightweight Redis-inspired in-memory key-value database implemented in C++.  
Supports basic data structures, networking, and concurrent request handling.

---

## 🚀 Features

- Key-Value storage (SET, GET, DEL)
- TTL support (expire keys automatically)
- Sorted Sets (ZADD, ZREM, ZSCORE, ZQUERY)
- Concurrent client handling using thread pool
- Non-blocking I/O with `poll()`
- Custom serialization protocol
- Efficient data structures:
  - Hash Table (for key lookup)
  - AVL Tree (for sorted sets)
  - Min Heap (for TTL management)

---

## 🧠 Architecture

- **Server**: Handles multiple clients using non-blocking sockets  
- **Client**: Sends requests using custom protocol  
- **Thread Pool**: Handles async deletion for heavy operations  
- **Event Loop**: Built using `poll()` for scalability  

Example server logic: :contentReference[oaicite:0]{index=0}

---

## 🛠 Tech Stack

- C++
- POSIX Sockets
- Multithreading (pthread)
- Data Structures (AVL Tree, HashMap, Heap)

---

## 📂 Project Structure
