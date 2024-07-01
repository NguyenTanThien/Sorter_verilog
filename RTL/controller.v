module next_state #(parameter size = 8)(start,current,cnt,cnt_i,cnt_j,result_cmp,next);
localparam size_addr = $clog2(size); 
input [size_addr:0] cnt,cnt_i,cnt_j;
input wire result_cmp;
input wire start;
input wire [4:0] current;
output reg [4:0]next;
always @(*)begin
    case(current)
        5'd0: begin
            if(start) next <= 5'd1;
            else next <= 5'd0;
        end
        5'd1:  next <= 5'd2; // load cnt = 0 
        
        5'd2: begin // cnt = cnt +1
            if(cnt <= size-1) next <= 5'd2;
            else next <= 5'd3;
        end
        5'd3: begin // load cnt_i
            next <= 5'd4;
        end
        5'd4: // check cnt_i <= size -2; 
            begin
                if (cnt_i <= size -2) next <= 5'd5;
                else next <= 5'd14; /////////////////////////read
            end
        5'd5: next <= 5'd6; // load cnt_j; //
        5'd6: // check cnt_j < size -1
            begin
                if(cnt_j <= size - 1) next <= 5'd7 ;
                else next <= 5'd13;
            end
        
        5'd7: begin // reg a = mem[cnt_i]
            next <= 5'd8;
        end
       5'd8: begin // regb = mem[cnt_j]
            next <= 5'd9;
        end
        5'd9: begin // check rega > regb then swap whereas conduct j++
            if(result_cmp == 1) next <= 5'd10;
            else next <= 5'd12;
        end
        5'd10: // swap rega_regb conduct two cycle
            next <= 5'd11;
        5'd11: next <= 5'd12; // swwap
        5'd12: // cnt_j ++
            next <= 5'd6;
        5'd13: // cnt_i ++;
            next <= 5'd4;
        5'd14: // read rdata from cnt = 0 to cnt = size -1; // load cnt = 0;
            next <= 5'd15;
        5'd15: //read cnt = cnt + 1 re =1
            begin
                if(cnt < size -1) next <= 5'd15;
                else next <= 5'd0;
            end
        default: next <= 5'd0;
    endcase
    
end
endmodule
module current_state(clk,rstn,next,current);
    input clk,rstn;
    input [4:0]next;
    output reg [4:0]current;
    always @(posedge clk or negedge rstn)begin
        if(!rstn) current <= 0;
        else current <= next;
    end
endmodule

module  out(current,load_cnt,load_cnti,load_cntj,ena_cnt,ena_cnti,ena_cntj,en_rega,en_regb,we,re,s0,s1,s2,s3,done);
    input [4:0]current;
    output reg load_cnt,load_cnti,load_cntj;
    output reg ena_cnt,ena_cnti,ena_cntj;
    output reg en_rega, en_regb;
    output reg we,re;
    output reg s0,s1,s2,s3;
    output reg done;
    always @(*)begin
        case(current)
            5'd0: begin 
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 0;
                ena_cnti <= 0;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 0;
                we <= 0;
                re <= 0;
                s0 <= 0;
                s1 <= 0;
                s2 <= 0;
                s3 <= 0;
                done <= 0;
            end
            5'd1: begin // load cnt = 0
                load_cnt <= 1;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 1;
                ena_cnti <= 0;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 0;
                we <= 0;
                re <= 0;
                s0 <= 0;
                s1 <= 0;
                s2 <= 0;
                s3 <= 0;
                done <= 0;
            end
            5'd2: begin // cnt =cnt +1 and we = 1 // select mux 2 => s1= 0
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 1;
                ena_cnti <= 0;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 0;
                we <= 1;
                re <= 0;
                s0 <= 0;
                s1 <= 0;
                s2 <= 0;
                s3 <= 0;
                done <= 0;
            end
            5'd3: begin // load cnt_i = 0
                load_cnt <= 0;
                load_cnti <= 1;
                load_cntj <= 0;
                ena_cnt <= 0;
                ena_cnti <= 1;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 0;
                we <= 0;
                re <= 0;
                s0 <= 0;
                s1 <= 0;
                s2 <= 0;
                s3 <= 0;
                done <= 0;
            end
            5'd4: begin // check cnt <= size-2 // mean wait controll check cnt and datapath no conduct
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 0;
                ena_cnti <= 0;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 0;
                we <= 0;
                re <= 0;
                s0 <= 0;
                s1 <= 0;
                s2 <= 0;
                s3 <= 0;
                done <= 0;

            end
            5'd5: begin // load cnt_j; // 
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 1;
                ena_cnt <= 0;
                ena_cnti <= 0;
                ena_cntj <= 1;
                en_rega <= 0;
                en_regb <= 0;
                we <= 0;
                re <= 0;
                s0 <= 0;
                s1 <= 0;
                s2 <= 0;
                s3 <= 0;
                done <= 0;

            end
            5'd6: begin // no process
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 0;
                ena_cnti <= 0;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 0;
                we <= 0;
                re <= 0;
                s0 <= 0;
                s1 <= 0;
                s2 <= 0;
                s3 <= 0;
                done <= 0;
            end
            5'd7: begin // rega = mem[cnt_i]
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 0;
                ena_cnti <= 0;
                ena_cntj <= 0;
                en_rega <= 1;
                en_regb <= 0;
                we <= 0;
                re <= 1;
                s0 <= 0;
                s1 <= 1;
                s2 <= 0;
                s3 <= 0;
                done <= 0;
            end
            5'd8: begin // regb = mem[cntj]
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 0;
                ena_cnti <= 0;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 1;
                we <= 0;
                re <= 1;
                s0 <= 1;
                s1 <= 1;
                s2 <= 0;
                s3 <= 0;
                done <= 0;
            end
            5'd9: begin // no process 
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 0;
                ena_cnti <= 0;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 0;
                we <= 0;
                re <= 0;
                s0 <= 0;
                s1 <= 0;
                s2 <= 0;
                s3 <= 0;
                done <= 0;
            end
            5'd10: begin // swap rega_regb conduct two cycle
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 0;
                ena_cnti <= 0;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 0;
                we <= 1;
                re <= 0;
                s0 <= 1;
                s1 <= 1;
                s2 <= 0;
                s3 <= 1;
                done <= 0;
            end
           5'd11: begin // swaap
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 0;
                ena_cnti <= 0;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 0;
                we <= 1;
                re <= 0;
                s0 <= 0;
                s1 <= 1;
                s2 <= 1;
                s3 <= 1;
                done <= 0;
           end
           5'd12: begin // cnt_j ++
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 0;
                ena_cnti <= 0;
                ena_cntj <= 1;
                en_rega <= 0;
                en_regb <= 0;
                we <= 0;
                re <= 0;
                s0 <= 0;
                s1 <= 0;
                s2 <= 0;
                s3 <= 0;
                done <= 0;
           end
           5'd13: begin
                load_cnt <= 0;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 0;
                ena_cnti <= 1;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 0;
                we <= 0;
                re <= 0;
                s0 <= 0;
                s1 <= 0;
                s2 <= 0;
                s3 <= 0;
                done <= 0;
           end
        5'd14:  begin // load cnt = 0
                load_cnt <= 1;
                load_cnti <= 0;
                load_cntj <= 0;
                ena_cnt <= 1;
                ena_cnti <= 0;
                ena_cntj <= 0;
                en_rega <= 0;
                en_regb <= 0;
                we <= 0;
                re <= 0;
                s0 <= 0;
                s1 <= 0;
                s2 <= 0;
                s3 <= 0;
                done <= 0;
        end
        5'd15: begin
            load_cnt <= 0;
            load_cnti <= 0;
            load_cntj <= 0;
            ena_cnt <= 1;
            ena_cnti <= 0;
            ena_cntj <= 0;
            en_rega <= 0;
            en_regb <= 0;
            we <= 0;
            re <= 1;
            s0 <= 0;
            s1 <= 0;
            s2 <= 0;
            s3 <= 0;
            done <= 1;

        end
        endcase

    end

    endmodule

module controller #(
    parameter size = 8
) (
    clk,rstn,start,cnt,cnt_i,cnt_j,result_cmp,
    load_cnt,load_cnti,load_cntj,
    ena_cnt,ena_cnti,ena_cntj,
  
    en_rega, en_regb,           
    we,re,            
    s0,s1,s2,s3,done                 
);
    localparam size_addr = $clog2(size); 
    input [size_addr:0] cnt,cnt_i,cnt_j;
    input result_cmp;
    input clk,rstn;
    input start;
    output wire done;
    output wire  load_cnt,load_cnti,load_cntj;
    output wire  ena_cnt,ena_cnti,ena_cntj;
    output wire  en_rega, en_regb;               
    output wire  we,re;                          
    output wire  s0,s1,s2,s3;                            

    wire [4:0] current,next;
    next_state #( .size(8) ) inst_next(start,current,cnt,cnt_i,cnt_j,result_cmp,next);
    current_state inst_current(clk,rstn,next,current);
    out inst_out(current,load_cnt,load_cnti,load_cntj,ena_cnt,ena_cnti,
                ena_cntj,en_rega,en_regb,we,re,s0,s1,s2,s3,done);

    
endmodule