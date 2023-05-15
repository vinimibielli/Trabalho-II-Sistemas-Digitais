module top(
    input reset, clock, start_f, start_t, stop_f_t, update,
    input [2:0] prog,
    output [5:0] LED,
    output [7:0] an, dec_ddp
);
//DADOS DO TOP
reg [5:0] EA;
wire start_f_ed, start_t_ed, stop_t_f_ed, update_ed;
//DADOS DO DCM
wire clk_1, clk_2;
wire [2:0]prog_out;
//DADOS DO FIBONACCI E DO TIMER
wire f_en, t_en, f_valid, t_valid;
wire [15:0] f_out, t_out;
//DADOS DO WRAPPER
wire data_1_en, buffer_empty, buffer_full, data_2_valid;
wire [15:0] data_1, data_2;
//DADOS DO DM
wire [1:0] module_wire;

edge_detector start_f_detector (.clock(clock), .reset(reset), .din(start_f), .rising(start_f_ed));
edge_detector start_t_detector (.clock(clock), .reset(reset), .din(start_t), .rising(start_t_ed));
edge_detector stop_f_t_detector (.clock(clock), .reset(reset), .din(stop_f_t), .rising(stop_f_t_ed));
edge_detector update_detector (.clock(clock), .reset(reset), .din(update), .rising(update_ed));

/*
ESTADOS DA M??QUINA DE ESTADOS
6'd0 : idle - M??QUINA PARADA
6'd1 : s_comm_f - PRODU??O FIBONACCI
6'd2 : s_wait_f - ESPERA FIBONACCI
6'd3 : s_comm_t - PRODU??O TIMER
6'd4 : s_wait_t - ESPERA TIMER
6'd5 : s_buf_empty - BUFFER VAZIO
*/

initial begin
  EA <= 6'd0;  
end

always @(posedge clock or posedge reset)
begin
    if(reset == 1'b1)
    begin
        EA <= 6'd0;
    end
    else
    begin
    case (EA)
       6'd0 : begin
        if(start_f_ed == 1'b1)
        begin
            EA <= 6'd1;
        end
        if(start_t_ed == 1'b1)
        begin
            EA <= 6'd3;
        end
       end
       6'd1 : begin
        if(stop_f_t_ed == 1'b1)
        begin
            EA <= 6'd5;
        end
        if(buffer_full == 1'b1)
        begin
            EA <= 6'd2;
        end
       end
       6'd2 : begin
        if(stop_f_t_ed == 1'b1)
        begin
            EA <= 6'd5;
        end
        if(buffer_full == 1'b0)
        begin
            EA <= 6'd1;
        end
       end
       6'd3 : begin
        if(stop_f_t_ed == 1'b1)
        begin
            EA <= 6'd5;
        end
        if(buffer_full == 1'b1)
        begin
            EA <= 6'd4;
        end
       end
       6'd4 : begin
        if(stop_f_t_ed == 1'b1)
        begin
            EA <= 6'd5;
        end
        if(buffer_full == 1'b0)
        begin
            EA <= 6'd3;
        end
       end
       6'd5 : begin
        if(buffer_empty == 1'b1 && data_2_valid == 1'b0)
        begin
            EA <= 6'd0;
        end
       end
    endcase
    end
end

//ASSIGNS DOS LEDS
assign LED[0] = (EA == 6'd0) ? 1'b1 : 1'b0;
assign LED[1] = (EA == 6'd1) ? 1'b1 : 1'b0;
assign LED[2] = (EA == 6'd2) ? 1'b1 : 1'b0;
assign LED[3] = (EA == 6'd3) ? 1'b1 : 1'b0;
assign LED[4] = (EA == 6'd4) ? 1'b1 : 1'b0;
assign LED[5] = (EA == 6'd5) ? 1'b1 : 1'b0;
//ASSIGN DO FIBONACCI E DO TIMER
assign f_en = (EA == 6'd1 && buffer_full != 1'b1) ? 1'b1 : 1'b0;
assign t_en = (EA == 6'd3 && buffer_full != 1'b1) ? 1'b1 : 1'b0;
//ASSIGN DO WRAPPER
assign data_1 = (EA == 6'd1) ? f_out : (EA == 6'd3) ? t_out : 16'd0;
assign data_1_en = f_en || t_en;
//ASSIGN DO DM
assign module_wire = (EA == 6'd1 || EA == 6'd2) ? 2'd1 : (EA == 6'd3 || EA == 6'd4) ? 2'd2 : 2'd0;

//INSTANCIA??O DOS M?DULOS
fibonacci FIB_inst(.reset(reset), .clock(clk_1), .f_en(f_en), .f_valid(f_valid), .f_out(f_out));
timer TIM_inst(.reset(reset), .clock(clk_1), .t_en(t_en), .t_valid(t_valid), .t_out(t_out));
wrapper WRP_inst(.reset(reset), .clk_1(clk_1), .clk_2(clk_2), .data_1_en(data_1_en), .data_1(data_1), .buffer_empty(buffer_empty), .buffer_full(buffer_full), .data_2_valid(data_2_valid), .data_2(data_2));
dcm DCM_inst(.reset(reset), .clock(clock), .clk_1(clk_1), .clk_2(clk_2), .update(update_ed), .prog_in(prog), .prog_out(prog_out));
dm DM_inst(.reset(reset), .clock(clock), .prog(prog_out), .data_2(data_2), .dec_ddp(dec_ddp), .an(an), .moduledm(module_wire));

endmodule