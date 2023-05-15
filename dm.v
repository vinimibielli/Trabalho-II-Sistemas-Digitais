module dm(
    input reset, clock,
    input [2:0] prog,
    input [1:0] moduledm,
    input [15:0] data_2,
    output [7:0] dec_ddp, an
);

wire [3:0] uni, dez, cent, mil, progwire;
wire [15:0] f_out, t_out;

assign uni = data_2[3:0];
assign dez = data_2[7:4];
assign cent = data_2[11:8];
assign mil = data_2[15:12];
assign progwire = (prog == 3'd1) ? 4'd1 : (prog == 3'd2) ? 4'd2 : (prog == 3'd3) ? 4'd3 : (prog == 3'd4) ? 4'd4 : (prog == 3'd5) ? 4'd5 : (prog == 3'd6) ? 4'd6 : (prog == 3'd7) ? 4'd7 : 4'd0;


dspl_drv_NexysA7 display(.clock(clock), .reset(reset), .an(an), .dec_cat(dec_ddp), .d1({1'b1, uni[3:0], 1'b0}), .d2({1'b1, dez[3:0], 1'b0}), .d3({1'b1, cent[3:0], 1'b0}), .d4({1'b1, mil[3:0], 1'b0}), .d5(6'b0), .d6({1'b1, 2'b0, moduledm[1:0], 1'b0}), .d7(6'b0), .d8({1'b1, progwire[3:0], 1'b0}));

endmodule