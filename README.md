# ID3-Decision-Tree---FPGA
ID3 decision tree trained in C++ using entropy and information gain to pick the best feature to split on at each node, then flattened into an array and exported as a SystemVerilog header. The hardware side walks that array — a chain of comparators and multiplexers — to classify an input in hardware instead of software.
