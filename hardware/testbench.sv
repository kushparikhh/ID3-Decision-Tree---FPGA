module testbench;

    logic [7:0] features_packed;
    logic       result;

    decision_tree dut (
        .features_packed(features_packed),
        .result(result)
    );

    logic [1:0] test_features [0:13][0:3];
    logic       expected_results [0:13];

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, testbench);

        test_features[0][0]=2'd0; test_features[0][1]=2'd0; test_features[0][2]=2'd0; test_features[0][3]=2'd0; expected_results[0]=1'd0;
        test_features[1][0]=2'd0; test_features[1][1]=2'd0; test_features[1][2]=2'd0; test_features[1][3]=2'd1; expected_results[1]=1'd0;
        test_features[2][0]=2'd1; test_features[2][1]=2'd0; test_features[2][2]=2'd0; test_features[2][3]=2'd0; expected_results[2]=1'd1;
        test_features[3][0]=2'd2; test_features[3][1]=2'd1; test_features[3][2]=2'd0; test_features[3][3]=2'd0; expected_results[3]=1'd1;
        test_features[4][0]=2'd2; test_features[4][1]=2'd2; test_features[4][2]=2'd1; test_features[4][3]=2'd0; expected_results[4]=1'd1;
        test_features[5][0]=2'd2; test_features[5][1]=2'd2; test_features[5][2]=2'd1; test_features[5][3]=2'd1; expected_results[5]=1'd1;
        test_features[6][0]=2'd1; test_features[6][1]=2'd2; test_features[6][2]=2'd1; test_features[6][3]=2'd1; expected_results[6]=1'd1;
        test_features[7][0]=2'd0; test_features[7][1]=2'd1; test_features[7][2]=2'd0; test_features[7][3]=2'd0; expected_results[7]=1'd0;
        test_features[8][0]=2'd0; test_features[8][1]=2'd2; test_features[8][2]=2'd1; test_features[8][3]=2'd0; expected_results[8]=1'd1;
        test_features[9][0]=2'd2; test_features[9][1]=2'd1; test_features[9][2]=2'd1; test_features[9][3]=2'd0; expected_results[9]=1'd1;
        test_features[10][0]=2'd0; test_features[10][1]=2'd1; test_features[10][2]=2'd1; test_features[10][3]=2'd1; expected_results[10]=1'd1;
        test_features[11][0]=2'd1; test_features[11][1]=2'd1; test_features[11][2]=2'd0; test_features[11][3]=2'd1; expected_results[11]=1'd1;
        test_features[12][0]=2'd1; test_features[12][1]=2'd0; test_features[12][2]=2'd1; test_features[12][3]=2'd0; expected_results[12]=1'd1;
        test_features[13][0]=2'd2; test_features[13][1]=2'd1; test_features[13][2]=2'd0; test_features[13][3]=2'd1; expected_results[13]=1'd1;

        for (int row = 0; row < 14; row = row + 1) begin
            features_packed = {test_features[row][3], test_features[row][2], test_features[row][1], test_features[row][0]};
            #1;
            if (result === expected_results[row])
                $display("PASS  row %0d -> %0d", row, result);
            else
                $display("FAIL  row %0d -> got %0d, expected %0d", row, result, expected_results[row]);
        end

        $finish;
    end

endmodule
