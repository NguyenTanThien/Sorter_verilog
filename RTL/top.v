module top_sorter #(parameter size = 8)(clk,rstn,start,data_in,sorted);
    localparam size_addr = $clog2(size); 
    input clk,rstn;
    input [31:0]data_in;
    input start;
    output [31:0] sorted;
    wire [size_addr:0]cnt,cnt_i,cnt_j;
    wire result_cmp;
    wire load_cnt, load_cnti, load_cntj;
    wire ena_cnt, ena_cnti, ena_cntj;
    wire en_rega, en_regb;
    wire we,re;
    wire s0,s1,s2,s3;
    wire done;
    controller #( .size (8)) 
        inst_controller(
                        clk,rstn,start,cnt,cnt_i,cnt_j,result_cmp,
                        load_cnt,load_cnti,load_cntj,
                        ena_cnt,ena_cnti,ena_cntj,
  
                        en_rega, en_regb,           
                        we,re,            
                        s0,s1,s2,s3,done                 
);
    datapath #(.size(size)) inst_datapath (clk,rstn,data_in,done,ena_cnt,ena_cnti,ena_cntj,
                                        load_cnt,load_cnti,load_cntj,
                                        s0,s1,s2,s3,we,re,en_rega,en_regb,result_cmp,
                                        cnt, cnt_i, cnt_j,sorted);

endmodule