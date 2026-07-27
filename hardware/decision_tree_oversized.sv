`include "decision_tree_oversized.vh"

module decision_tree (
    input  logic [31:0] features_packed,
    output logic        result
);

    logic [7:0] row  [0:NUM_NODES];
    logic       done [0:NUM_NODES];
    logic [7:0] cur_feature_idx;
    logic [7:0] cur_threshold;
    logic       cur_is_leaf;
    logic [7:0] this_feature_val;

    always_comb begin
        row[0]  = 8'd0;
        done[0] = 1'b0;

        for (int i = 0; i < NUM_NODES; i = i + 1) begin
            cur_feature_idx = feature_idx_packed[row[i]*8 +: 8];
            cur_threshold   = threshold_packed[row[i]*8 +: 8];
            cur_is_leaf     = is_leaf_packed[row[i]];
            this_feature_val = features_packed[cur_feature_idx*8 +: 8];

            if (done[i] || cur_is_leaf) begin
                row[i+1]  = row[i];
                done[i+1] = 1'b1;
            end else begin
                if (this_feature_val < cur_threshold)
                    row[i+1] = left_idx_packed[row[i]*8 +: 8];
                else
                    row[i+1] = right_idx_packed[row[i]*8 +: 8];
                done[i+1] = 1'b0;
            end
        end

        result = leaf_value_packed[row[NUM_NODES]];
    end

endmodule
