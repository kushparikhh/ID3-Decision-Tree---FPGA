module tb_pipelined;

    logic       clk;
    logic       rst;
    logic [7:0] features_packed;
    logic       result;
    logic       valid;

    decision_tree_pipelined dut (
        .clk(clk), .rst(rst),
        .features_packed(features_packed),
        .result(result), .valid(valid)
    );

    always #5 clk = ~clk;

    task automatic run_case(input logic [1:0] o, t, h, w, input logic expected, input string label);
        int cycles;
        rst = 1;
        features_packed = {w, h, t, o};
        @(posedge clk);
        #1;
        rst = 0;
        cycles = 0;
        while (!valid && cycles < 10) begin
            @(posedge clk);
            #1;
            cycles = cycles + 1;
        end
        if (result === expected)
            $display("PASS  %s -> %0d (took %0d cycles)", label, result, cycles);
        else
            $display("FAIL  %s -> got %0d, expected %0d", label, result, expected);
    endtask

    initial begin
        clk = 0;
        run_case(2'd2, 2'd1, 2'd0, 2'd0, 1'b1, "Rain/Mild/High/Weak");
        run_case(2'd0, 2'd1, 2'd0, 2'd0, 1'b0, "Sunny/Mild/High/Weak");
        $finish;
    end

endmodule
