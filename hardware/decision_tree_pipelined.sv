`include "decision_tree.vh"

module decision_tree_pipelined (
    input  logic       clk,
    input  logic       rst,
    input  logic [7:0] features_packed,
    output logic       result,
    output logic       valid
);

    logic [2:0] row;
    logic       done;

    always_ff @(posedge clk) begin
        if (rst) begin
            row   <= 3'd0;
            done  <= 1'b0;
            valid <= 1'b0;
        end else if (!done) begin
            if (is_leaf_packed[row]) begin
                result <= leaf_value_packed[row];
                done   <= 1'b1;
                valid  <= 1'b1;
            end else begin
                if (features_packed[feature_idx_packed[row*2 +: 2]*2 +: 2] < threshold_packed[row*2 +: 2])
                    row <= left_idx_packed[row*3 +: 3];
                else
                    row <= right_idx_packed[row*3 +: 3];
            end
        end
    end

endmodule
