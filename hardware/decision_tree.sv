`include "decision_tree.vh"

module decision_tree (
    input  logic [7:0] features_packed,
    output logic       result
);

    logic [2:0] row  [0:NUM_NODES];
    logic       done [0:NUM_NODES];
    logic [1:0] cur_feature_idx;
    logic [1:0] cur_threshold;
    logic       cur_is_leaf;
    logic [1:0] this_feature_val;

    always_comb begin
        row[0]  = 3'd0;
        done[0] = 1'b0;

        for (int i = 0; i < NUM_NODES; i = i + 1) begin
            cur_feature_idx = feature_idx_packed[row[i]*2 +: 2];
            cur_threshold   = threshold_packed[row[i]*2 +: 2];
            cur_is_leaf     = is_leaf_packed[row[i]];
            this_feature_val = features_packed[cur_feature_idx*2 +: 2];

            if (done[i] || cur_is_leaf) begin
                row[i+1]  = row[i];
                done[i+1] = 1'b1;
            end else begin
                if (this_feature_val < cur_threshold)
                    row[i+1] = left_idx_packed[row[i]*3 +: 3];
                else
                    row[i+1] = right_idx_packed[row[i]*3 +: 3];
                done[i+1] = 1'b0;
            end
        end

        result = leaf_value_packed[row[NUM_NODES]];
    end

endmodule
