module wrapper(
    input reset, clk_1, clk_2, data_1_en,
    input [15:0] data_1,
    output buffer_empty, buffer_full,
    output reg data_2_valid,
    output reg [15:0] data_2
);

reg [2:0] buffer_wr, buffer_rd;
reg [15:0] buffer_reg [0:7];

initial
begin
    data_2 = 16'd0;
    data_2_valid = 1'b0;
end

always @(posedge clk_1 or posedge reset)
begin
    if(reset == 1'b1)
    begin
        buffer_wr <= 3'b000;
    end
    else
    begin
    if(data_1_en == 1'b1 && buffer_full != 1'b1)
    begin
        buffer_reg[buffer_wr] <= data_1;
        buffer_wr <= buffer_wr + 3'b001;
    end
end
end

always @(posedge clk_2 or posedge reset)
begin
    if(reset == 1'b1)
    begin
        buffer_rd <= 3'b000;
        data_2 <= 16'd0;
    end
    else
    begin
    if(buffer_empty != 1'b1)
    begin
        data_2_valid <= 1'b1;
        data_2 <= buffer_reg[buffer_rd];
        buffer_rd <= buffer_rd + 3'b001;
    end
    else
        begin
            data_2_valid <= 1'b0;
        end
end
end

assign buffer_empty = (buffer_wr == buffer_rd) ? 3'd1 : 3'd0;
assign buffer_full = (buffer_rd - 1'b1 == buffer_wr) ? 3'd1 : 3'd0;

endmodule