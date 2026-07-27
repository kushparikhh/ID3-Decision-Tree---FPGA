`ifndef DECISION_TREE_VH_OVERSIZED
`define DECISION_TREE_VH_OVERSIZED
localparam int NUM_NODES = 7;
localparam [55:0] feature_idx_packed = {8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd2};
localparam [55:0] threshold_packed   = {8'd0, 8'd0, 8'd2, 8'd0, 8'd0, 8'd1, 8'd1};
localparam [55:0] left_idx_packed    = {8'd0, 8'd0, 8'd5, 8'd0, 8'd0, 8'd2, 8'd1};
localparam [55:0] right_idx_packed   = {8'd0, 8'd0, 8'd6, 8'd0, 8'd0, 8'd3, 8'd4};
localparam [6:0]  is_leaf_packed     = {1'd1, 1'd1, 1'd0, 1'd1, 1'd1, 1'd0, 1'd0};
localparam [6:0]  leaf_value_packed  = {1'd1, 1'd1, 1'd0, 1'd1, 1'd0, 1'd0, 1'd0};
`endif
