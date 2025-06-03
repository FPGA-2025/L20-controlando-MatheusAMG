module fsm(
    input   clk,
    input   rst_n,

    output reg wr_en,

    output [7:0] fifo_data,
    
    input [3:0] fifo_words
);

reg state_machine, next_state;

parameter WRITING = 1'b1,
          WAITING = 1'b0;

assign fifo_data = 8'hAA;

always @(posedge clk) begin
    if (~rst_n) begin
        state_machine <= WAITING;
    end
    else begin
        state_machine <= next_state;
    end
end


always @(*) begin
    case (state_machine)
        WRITING: begin
            wr_en = 1;
            if (fifo_words < 5) next_state = WRITING;
            else next_state = WAITING;
        end

        WAITING: begin
            wr_en = 0;
            if (fifo_words <= 2) next_state = WRITING;
            else next_state = WAITING;
        end
    endcase
end



endmodule