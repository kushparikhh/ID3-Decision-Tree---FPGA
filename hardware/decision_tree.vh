`ifndef DECISION_TREE_VH
`define DECISION_TREE_VH

localparam int NUM_NODES = 7;
localparam int FEATURE_BITS = 2;
localparam int THRESHOLD_BITS = 2;
localparam int ROW_BITS = 3;

localparam [13:0] feature_idx_packed = {2'd0, 2'd0, 2'd0, 2'd0, 2'd0, 2'd0, 2'd2};
localparam [13:0] threshold_packed = {2'd0, 2'd0, 2'd2, 2'd0, 2'd0, 2'd1, 2'd1};
localparam [20:0] left_idx_packed = {3'd0, 3'd0, 3'd5, 3'd0, 3'd0, 3'd2, 3'd1};
localparam [20:0] right_idx_packed = {3'd0, 3'd0, 3'd6, 3'd0, 3'd0, 3'd3, 3'd4};
localparam [6:0] is_leaf_packed = {1'd1, 1'd1, 1'd0, 1'd1, 1'd1, 1'd0, 1'd0};
localparam [6:0] leaf_value_packed = {1'd1, 1'd1, 1'd0, 1'd1, 1'd0, 1'd0, 1'd0};

`endif
