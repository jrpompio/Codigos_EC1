module test (
    output reg clk,
    output reg sensorA,
    output reg sensorB,
    output reg [7:0] pass,
    input wire gateState,
    input wire blockAlarm,
    input wire wrongPinAlarm
);

    always
    begin
        #1 clk=!clk;
    end

    initial
    begin
        clk = 0;
        $dumpfile("ondas.vcd");
        $dumpvars;
 
        #5 sensorA = 1'b1;  
             pass = 8'b00100110;
        
        #5 sensorB = 1'b1;
            sensorA = 1'b0;
        #5 $finish;
    end 
endmodule

