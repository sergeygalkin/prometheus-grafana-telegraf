# Mini howto
## Build
* Visit
[Intel performance counter monitor page](https://software.intel.com/en-us/articles/intel-performance-counter-monitor)
and download IntelPerformanceCounterMonitor-V2.11.1.zip (967.62 KB)
* Unpack
* Copy pcm-memory-one-line.cpp to IntelPerformanceCounterMonitor-V2.11.1
* Apply the patch Makefile.patch to Makefile in
IntelPerformanceCounterMonitor-V2.11.1 (patch < Makefile.patch)
* run make

## About attached binary
Attached pcm-memory-one-line.x tested on Ubuntu 16.04 and 14.04

## TODO
Automate steps to working witn https://github.com/opcm/pcm