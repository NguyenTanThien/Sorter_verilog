module counter #(parameter size = 8)(clk, rstn,ena,load,din,cnt);
    localparam size_addr = $clog2(size);
    input clk,rstn,ena,load;
    input [size_addr:0]din;
    output reg [size_addr:0]cnt;
    always @(posedge clk,negedge rstn)begin
        if(!rstn) cnt <= 32'd0;
        else if(!ena) 
         cnt <= cnt;
      
        else  if (load) cnt <= din;
            else cnt <= cnt +1;


    end
endmodule
