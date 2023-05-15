module timer (
    input clock, reset, t_en,
    output reg t_valid,
    output [15:0] t_out
);

reg [15:0] soma;

initial begin
    soma <= 16'd0;
end

// TIMER - CONTADOR
    
always @(posedge clock or posedge reset)
begin
    if(reset == 1'b1)
    begin
        soma <= 16'd0;
    end
    else
    begin
        if(t_en == 1'b1)
        begin
            t_valid <= 1'b1;
            soma <= t_out + 1'd1;
        end      
        else
        begin
            t_valid <= 1'b0;
        end      
    end
end

assign t_out = soma;

endmodule