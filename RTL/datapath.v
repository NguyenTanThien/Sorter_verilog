module datapath #(parameter size = 8)(clk,rstn,data_in,done,ena_cnt,ena_cnti,ena_cntj,
                                        load_cnt,load_cnti,load_cntj
                                        ,s0,s1,s2,s3,we,re,en_rega,en_regb,result_cmp,
                                        cnt, cnt_i, cnt_j,sorted);
    localparam size_addr = $clog2(size);
    input clk,rstn;
    input we,re;
    input s0,s1,s2,s3;
    input wire ena_cnt,ena_cnti,ena_cntj;
    input wire load_cnt,load_cnti,load_cntj;
    input en_rega,en_regb;
    input [31:0] data_in;
    input done;
    output result_cmp;
    output [31:0]sorted;
    
    //declare counter cnt,cnti,cntj
    
    output wire [size_addr:0]cnt,cnt_i,cnt_j;
    //
    // declare mux2:1
    
    wire [size_addr:0] select_cnt,addr;
    wire [31:0] select_reg, reg_a,reg_b,wdata;
    // declare reg
    wire [31:0] rdata;
    //
    counter #(.size(size)) inst_cnt (.clk(clk), .rstn(rstn),.ena(ena_cnt),.load(load_cnt),.din(0),.cnt(cnt));
    counter #(.size(size)) inst_cnti (.clk(clk), .rstn(rstn),.ena(ena_cnti),.load(load_cnti),.din(0),.cnt(cnt_i));
    counter #(.size(size)) inst_cntj (.clk(clk), .rstn(rstn),.ena(ena_cntj),.load(load_cntj),.din(cnt_i+1'b1),.cnt(cnt_j));
    // mux 2:1 from counter cnt,cnti,cntj to mem
    

    assign select_cnt = (s0 == 0) ? cnt_i : cnt_j;
    assign addr = (s1 ==0) ? cnt : select_cnt;
    // mux 2:1 form rega,regb,datain to mem
    assign select_reg = (s2 == 0) ? reg_a : reg_b;
    assign wdata = (s3 ==0) ? data_in : select_reg;


    memory #(.size(size)) inst_mem  (.addr(addr),.wdata(wdata),.we(we),.re(re),.en(clk),.rdata(rdata));
    register inst_rega (.clk(clk),.rstn(rstn),.enable(en_rega),.din(rdata),.dout(reg_a));
    register inst_regb (.clk(clk),.rstn(rstn),.enable(en_regb),.din(rdata),.dout(reg_b));
    assign result_cmp = ($signed(reg_a) > $signed(reg_b)) ? 1'b1 : 1'b0;

    assign sorted = (done == 1) ? rdata : 32'hz;
endmodule