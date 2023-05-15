module fibonacci (
    input clock, reset, f_en,
    output reg f_valid,
    output[15:0] f_out
);

// DECLARAÇÃO DE SINAIS

reg [15:0] fib_ant, fib_pres;

initial 
begin
    fib_ant <= 16'd0;
    fib_pres <= 16'd1;
end

//SEQUÊNCIA DE FIBONACCI
    
always @(posedge clock or posedge reset)
    begin
        if(reset == 1'b1)
        begin
          fib_ant <= 16'd0;
          fib_pres <= 16'd1;
        end
        else
        begin
            if(f_en == 1'b1)
            begin
                f_valid <= 1'b1;
                fib_ant <= fib_pres;
                fib_pres <= fib_pres + fib_ant;
            end
            else
            begin
                f_valid <= 1'b0;
            end
        end
    end

//ASSIGNS NECESSÁRIOS

assign f_out = fib_ant;

endmodule