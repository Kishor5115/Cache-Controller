# Two-Level Cache Controller

## Overview
This project implements a Two-Level Cache Controller for RISC-V architecture, designed to improve memory access efficiency. It manages data flow between the CPU and memory with two levels of cache: L1 and L2.

## Features
- Efficient hierarchical cache management
- Write policies: Write-Back and Write-Through
- Replacement policies: LRU and Random (LRU used in L2 Cache)
- Cache miss and error handling

## Architecture
1. **L1 Cache**: Small, fast, close to the CPU.
2. **L2 Cache**: Larger, acts as a bridge to main memory.

### Workflow
1. CPU request -> Check L1 cache (hit/miss).
2. On miss -> Check L2 cache.
3. If not in L2 -> Fetch from main memory.

## Tools
- **HDL**: Verilog
- **Simulation**: ModelSim, Xilinx Vivado
- **Architecture**: RISC-V

## Future Work
- Multi-core system support
- Advanced replacement policies

