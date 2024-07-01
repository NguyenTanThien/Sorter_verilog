module register(clk,rstn,enable,din,dout);
    input clk,rstn;
    input [31:0]din;
    output reg [31:0]dout;
    input enable;
    always @(posedge clk or negedge rstn)begin
        if(!rstn) begin 
            dout <= 32'd0;
        end
        else if(enable) begin
            dout <= din;
        end
        else dout <= dout;
    end
endmodule