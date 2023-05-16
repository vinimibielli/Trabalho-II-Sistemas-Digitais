module dcm(
    input reset, clock, update,
    input [2:0] prog_in,
    output clk_1, clk_2,
    output [2:0] prog_out
);

reg clk01seg, clkalt;
reg [2:0] prog;
reg [31:0] count01, count02;
parameter HALF_MS_COUNT = 5_000_000;


initial begin
prog <= 3'd0;
end

//edge_detector update_detector (.clock(clock), .reset(reset), .din(update), .rising(update_ed));

//CLOCK DE 0,1 SEGUNDOS

always @(posedge clock or posedge reset)
  begin
    if (reset == 1'b1) 
    begin
      clk01seg <= 1'b0;
      count01 <= 32'd0;
    end
    else 
    begin
      if (count01 == HALF_MS_COUNT-1) 
      begin
        clk01seg <= ~clk01seg;
        count01 <= 32'd0;
      end
      else 
      begin
        count01 <= count01 + 32'd1;
      end
    end
  end

  always @(posedge clock or posedge reset)
  begin
    if (reset == 1'b1) 
    begin
      clkalt <= 1'b0;
      count02 <= 32'd0;
    end
    else 
    begin
      if(update == 1'b1)
      begin
        clkalt <= 1'b0;
        count02 <= 32'd0;
      end
        case(prog)

//CLOCK NO MODO 0: 0,1 SEGUNDOS

        3'b000 : begin
      if (count02 == HALF_MS_COUNT-1) 
      begin
        clkalt <= ~clkalt;
        count02 <= 32'd0;
      end
      else 
      begin
        count02 <= count02 + 32'd1;
      end
        end

//CLOCK NO MODO 1: 0,2 SEGUNDOS

        3'b001 : begin
          if (count02 == (HALF_MS_COUNT * 2)-1) 
      begin
        clkalt <= ~clkalt;
        count02 <= 32'd0;
      end
      else 
      begin
        count02 <= count02 + 32'd1;
      end  
        end

//CLOCK NO MODO 2: 0,4 SEGUNDOS

        3'b010 : begin
          if (count02 == (HALF_MS_COUNT * 4)-1) 
      begin
        clkalt <= ~clkalt;
        count02 <= 32'd0;
      end
      else 
      begin
        count02 <= count02 + 32'd1;
      end  
        end

//CLOCK NO MODO 3: 0,8 SEGUNDOS

        3'b011 : begin
          if (count02 == (HALF_MS_COUNT * 8)-1) 
      begin
        clkalt <= ~clkalt;
        count02 <= 32'd0;
      end
      else 
      begin
        count02 <= count02 + 32'd1;
      end  
        end

//CLOCK NO MODO 4: 1,6 SEGUNDOS

        3'b100 : begin
          if (count02 == (HALF_MS_COUNT * 16)-1) 
      begin
        clkalt <= ~clkalt;
        count02 <= 32'd0;
      end
      else 
      begin
        count02 <= count02 + 32'd1;
      end  
        end

//CLOCK NO MODO 5: 3,2 SEGUNDOS

        3'b101 : begin
          if (count02 == (HALF_MS_COUNT * 32)-1) 
      begin
        clkalt <= ~clkalt;
        count02 <= 32'd0;
      end
      else 
      begin
        count02 <= count02 + 32'd1;
      end  
        end

//CLOCK NO MODO 6: 6,4 SEGUNDOS

        3'b110 : begin
          if (count02 == (HALF_MS_COUNT * 64)-1) 
      begin
        clkalt <= ~clkalt;
        count02 <= 32'd0;
      end
      else 
      begin
        count02 <= count02 + 32'd1;
      end  
        end

//CLOCK NO MODO 7: 12,8 SEGUNDOS

        3'b111 : begin
          if (count02 == (HALF_MS_COUNT * 128)-1) 
      begin
        clkalt <= ~clkalt;
        count02 <= 32'd0;
      end
      else 
      begin
        count02 <= count02 + 32'd1;
      end  
        end
        endcase
    end
  end

always @(posedge clock or posedge reset)
begin
    if(reset == 1'b1)
    begin
        prog <= 3'd0;
    end
    else
    begin
    if(update == 1'b1)
    begin
    prog = prog_in;
    end
    end
end

  assign clk_1 = clk01seg;
  assign clk_2 = clkalt;
  assign prog_out = prog;

endmodule
