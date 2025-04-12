# Operating System
🖥️ Operating Systems – xv6 Labs & Multi-Threaded Image Filter Project
🧪 University Lab Projects – Spring 2024
📋 Overview
This repository contains lab assignments and course projects for the Operating Systems class. The course includes hands-on experience with the xv6 operating system, a Unix-like educational OS used to explore core OS concepts. Additionally, a key project involves implementing and comparing serial and multi-threaded approaches to an image processing task.

🔍 Topics Explored
xv6 internal architecture

System call implementation

Process and thread management

User-level threading and synchronization

Image processing using multithreading (performance comparison)

Race conditions and thread safety

🧪 Lab Component: xv6 OS
In the lab sessions, students work with the xv6 kernel to:

Add new system calls

Modify process and scheduling behavior

Explore memory management

Understand file system structure

Trace and debug kernel execution


🚀 Course Project: Multi-Threaded Image Filter

🧠 Goal
To compare serial and parallel (multi-threaded) implementations of an image filtering algorithm. This project focuses on improving the performance of image processing using thread-level parallelism.

🔧 Description
The filter (e.g., blur, sharpen, edge detection) is applied to a bitmap image.

First, a serial version processes the entire image in a single thread.

Then, a multi-threaded version splits the image into segments and processes them in parallel.

Performance is measured and compared using execution time.

📈 Outcome
Understand the difference between serial and parallel execution

Learn thread management, synchronization, and load balancing

Analyze performance gains and threading overhead

