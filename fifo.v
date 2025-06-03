module fifo(
    input   clk,
    input   rst_n,

    // Write interface
    input   wr_en,
    input   [7:0] data_in,
    output  full,

    // Read interface
    input   rd_en,
    output  reg [7:0] data_out,
    output  empty,

    // status
    output reg [3:0] fifo_words  // Current number of elements
);

reg [7:0] fila_fifo [0:7];

reg [3:0] wr_pointer; //ponteiro de escrita contador
reg [3:0] rd_pointer; //ponteiro de leitura

//Lógica combinacional
assign full  = (((wr_pointer + 1) == rd_pointer) || (wr_pointer == 7 && rd_pointer == 0));
assign empty = (wr_pointer == rd_pointer);

//Lógica FIfo
always @(posedge clk) begin
    if(~rst_n)begin
        wr_pointer <= 0;
        rd_pointer <= 0;
        fifo_words <= 0;
    end
    else begin
        // Write
        if ((~full && wr_en) || (wr_en && rd_en)) begin // para escrever (não cheio e wr_en ativo) ou (wr e rd ativos)
            fila_fifo[wr_pointer] <= data_in;
            if (wr_pointer == 7) begin
                wr_pointer <= 0;
            end
            else begin
                wr_pointer <= wr_pointer + 1;
            end
        end
        // Read
        if (~empty && rd_en) begin
            data_out <= fila_fifo[rd_pointer]; 
            if (rd_pointer == 7) begin
                rd_pointer <= 0;
            end
            else begin
                rd_pointer <= rd_pointer + 1;
            end
        end
        // Contador
        case ({wr_en,rd_en})
            2'b00: fifo_words <= fifo_words; 
            2'b01: if (~empty) fifo_words <= fifo_words - 1; 
            2'b10: if (~full) fifo_words <= fifo_words + 1; 
            2'b11: fifo_words <= fifo_words; 
        endcase
    end
end


endmodule