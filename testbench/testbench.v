module tb();
    parameter size = 8;
    parameter number = 1000;
    reg [7:0]count = 0;
    reg clk,rstn;
    reg start;
    reg [31:0]data_in;
    wire [31:0] sorted;
    top_sorter #( .size (size)) DUT(clk,rstn,start,data_in,sorted);

    initial begin
        #0 clk = 0;
        forever begin
            #10 clk = !clk;
        end

    end
    
    initial begin
        rstn = 0; start = 0;
        #100 rstn = 1;
    end
    initial begin
       
        forever
        begin
            #20 data_in =  $random ; 
            if(DUT.inst_controller.current != 2) data_in = 32'hz;
         
            
        end
    end
    integer i;
    integer j;
    always @(*)begin
        if(DUT.inst_controller.current == 0)begin
            for(i = 0; i<10 ; i= i+1)begin
            @(posedge clk);
            end
            start = 1;
            #20 start = 0;
        end

    end
    
    //
    
    
    always @(*)begin
        // //for (i = 0; i < size; i = i+1) begin
        // if(DUT.inst_controller.current == 2) begin
        //     $display("data_in will write mem[%d]: %d", i, data_in);
        //     i = i+1;
        //     end
        if(DUT.inst_controller.we == 1 && DUT.inst_datapath.cnt == 0 && DUT.inst_controller.current == 2) begin
            $display("----value will writed to memory------");
        end
         if(DUT.inst_controller.we == 1 && DUT.inst_datapath.cnt < size) begin
            
            @(posedge clk);
            $display("wdata = %d; addr = %d", $signed(DUT.inst_datapath.wdata), DUT.inst_datapath.addr);
         end
            //end
   end
    // 
    reg [31:0]init_arr[size-1:0];
    reg [31:0]sorted_arr[size-1:0];
    always @(DUT.inst_controller.current)begin
        if(DUT.inst_controller.current == 3 ) begin
            $display("---initial array---");
            for (i = 0; i < size; i = i+1) begin
                $display("memory[%d] = %d",i, $signed(DUT.inst_datapath.inst_mem.mem[i]));
                init_arr[i] = DUT.inst_datapath.inst_mem.mem[i];
            end
        end
        end
        always @(DUT.done)begin
        if(DUT.done == 1) begin
            $display("---sorted array---");
            for (i = 0; i < size; i = i+1) begin
                $display("memory[%d] = %d",i, $signed(DUT.inst_datapath.inst_mem.mem[i]));
                sorted_arr[i] = DUT.inst_datapath.inst_mem.mem[i];
            end
            
            
        end
    end
    
    reg [31:0]temporary;
    always @(DUT.done)begin // checker
        if (DUT.done == 1 && count <= number) begin
        @(posedge clk);
        for (i = 0; i < size-1; i = i+1) begin
            for(j = i+1; j < size; j= j+1)begin
                if($signed(init_arr[i]) > $signed(init_arr[j]))begin
                    temporary = init_arr[i];
                    init_arr[i] = init_arr[j];
                    init_arr[j] = temporary;
                end
            end
        end
        @(negedge clk);
            $display("---init_arr after sort by testbench and sorter using verilog hardware---");
             for (i = 0; i < size-1; i = i+1) begin
                $display("init_arr[%d] = %d and sorter_arr[%d] = %d", i, $signed(init_arr[i]), i, $signed(sorted_arr[i]));
             end
        @(posedge clk);
        for (i = 0; i < size-1; i = i+1) begin
            if($signed(init_arr[i]) != $signed(sorted_arr[i]))begin
                $display("Error: sorter fail at indext has value is : %d with two result %d != %d", i, $signed(init_arr[i]), $signed(sorted_arr[i]));
            end
            
        end

         $display ("@@@@@@@@Successfully: sorter !!!!!!!!!!!!");
    end

    end

always @(posedge clk) begin
    if(start == 1) count <= count + 1;
    else count <= count;
end
always @(count)begin
    if (count == number )begin

        @(negedge DUT.done);
        $display ("!!!!finish testcase %d\n\n", count);
        count = 0;
        $finish;
    end
    else if(count > 0 )begin
        @(negedge DUT.done);
        $display ("!!!!finish testcase %d\n\n", count);
    end

    end

always @(count)begin
    if(count != 0)
    
    $display("********testcase: %d", count);
end

    
    

     
endmodule