`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb;

  reg clock, reset, start_f, start_t, update, stop_f_t;
  reg [2:0] prog;
  wire [5:0] LED;
  wire [7:0] an, dec_cat;

  localparam PERIOD_100MHZ = 8;  

  initial
  begin
    clock = 1'b1;
    forever #(PERIOD_100MHZ/2) clock = ~clock;
  end

  initial
  begin
    reset = 1'b1;
    #30;
    reset = 1'b0;
    start_f  = 1'b0;
    start_t  = 1'b0;
    stop_f_t = 1'b0;
    update   = 1'b0;
    prog     = 3'd0;
    #80;
    update   = 1'b1;
    prog     = 3'b011;
    #10;
    update   = 1'b0;
    prog     = 3'd0;
    #100;
    start_f  = 1'b1;
    #10;
    start_f  = 1'b0;
    #1000;
    stop_f_t  = 1'b1;
    #10;
    stop_f_t  = 1'b0;
    #4000;
    start_t  = 1'b1;
    #10;
    start_t  = 1'b0;
    #400;
    stop_f_t  = 1'b1;
    #10;
    stop_f_t  = 1'b0;
    #4000;
    update   = 1'b1;
    prog     = 3'b101;
    #10;
    update   = 1'b0;
    prog     = 3'd0;
    #300;
    start_f  = 1'b1;
    #10;
    start_f  = 1'b0;
    #300;
    stop_f_t  = 1'b1;
    #10;
    stop_f_t  = 1'b0;
	  #8000;
    update   = 1'b1;
    prog     = 3'b000;
    #10;
    update   = 1'b0;
    prog     = 3'b000;
    #200;
    start_t  = 1'b1;
    #10;
    start_t  = 1'b0;
    #1000;
    stop_f_t  = 1'b1;
    #10;
    stop_f_t  = 1'b0;
  end

  top DUT(.reset(reset), .clock(clock), .start_f(start_f), .start_t(start_t), .update(update), .stop_f_t(stop_f_t), .prog(prog), .LED(LED), .an(an), .dec_ddp(dec_cat));

endmodule 