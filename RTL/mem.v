module memory #(parameter size = 8)(addr,wdata,we,re,en,rdata);
localparam size_addr = $clog2(size);
    input wire [size_addr:0]addr;
    input wire [31:0] wdata;
    output reg [31:0] rdata;
    input wire we, re, en;
    reg [31:0] mem [size-1:0];
    always @(*)begin
        if (en)begin
            rdata <= 32'hz;
            mem[addr] <= mem[addr];
        end
        else // en = 0
        begin 
            if(we && !re) begin
            mem[addr] <= wdata;
            rdata <= 32'hz;
            end
          else if(!we && re)begin
            mem[addr] <= mem[addr];
            rdata <= mem[addr];
        end
        else begin
            rdata <= 32'hz;
            mem[addr] <= mem[addr];
        end
        end
        
    end
endmodule