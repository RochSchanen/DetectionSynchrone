module latticeBlink(input clk, output led);
    // counter
    reg [25:0] counter;
    // increment on clock rising edge
    always @(posedge clk)
    begin
      counter <= counter + 1;
    end
    // output most significant bit of the counter
    assign led = counter[25];
    // done
endmodule
