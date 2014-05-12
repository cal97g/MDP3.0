/**********************************************************************************
*	Module : MDP Parser
*	Description:
*
*	Authors:		Mirza Armaan Ali,	Jonathan Liu
*	Contact:
*
*	Last Update:	22/04/2014
*
*************************************************************************************/


module Order_Book(

	input clk,
	input logic message_ready, //when the parser has a message ready for us
	input logic enable_order_book,
	input logic[31:0] NUM_ORDERS,
	input logic[31:0] QUANTITY,
	input logic[63:0] PRICE,
	input logic[7:0] ACTION, ENTRY_TYPE,
	input logic[31:0] SECURITY_ID,
	output logic[127:0] ASK0, ASK1, ASK2, ASK3, ASK4, ASK5, ASK6, ASK7, ASK8, ASK9, 
	output logic[127:0] BID0, BID1, BID2, BID3, BID4, BID5, BID6, BID7, BID8, BID9, 
	output logic orderbook_ready //let next block know message is ready might need more?
	);
// Parameters
parameter DG_SECURITY_ID = 0;
parameter MAX_CONTRACTS = 10;
parameter PRICE_IDX = 63;
parameter QUANTITY_IDX = 95;
parameter NUM_ORDERS_IDX = 127;
	// 87-:16 -> Quantity; 71-:8 -> NUM_ORDERS; 63-:64 -> PRICE;
	logic [127:0] ask [MAX_CONTRACTS-1:0];
	logic [127:0] bid [MAX_CONTRACTS-1:0];
	assign ASK0 = ask[0];
	assign ASK1 = ask[1];
	assign ASK2 = ask[2];
	assign ASK3 = ask[3];
	assign ASK4 = ask[4];
	assign ASK5 = ask[5];
	assign ASK6 = ask[6];
	assign ASK7 = ask[7];
	assign ASK8 = ask[8];
	assign ASK9 = ask[9];
	assign BID0 = bid[0];
	assign BID1 = bid[1];
	assign BID2 = bid[2];
	assign BID3 = bid[3];
	assign BID4 = bid[4];
	assign BID5 = bid[5];
	assign BID6 = bid[6];
	assign BID7 = bid[7];
	assign BID8 = bid[8];
	assign BID9 = bid[9];
	logic reset = 1'b0; //if reset is 1 reset to initial state

	/* Create a sample initial state of book with fake entries */
	initial begin
		// set price
		bid[0][PRICE_IDX-:64] <= 64'd11;
		bid[1][PRICE_IDX-:64] <= 64'd10;
		bid[2][PRICE_IDX-:64] <= 64'd8;
		bid[3][PRICE_IDX-:64] <= 64'd7;
		bid[4][PRICE_IDX-:64] <= 64'd6;
		bid[5][PRICE_IDX-:64] <= 64'd5;
		bid[6][PRICE_IDX-:64] <= 64'd4;
		bid[7][PRICE_IDX-:64] <= 64'd3;
		bid[8][PRICE_IDX-:64] <= 64'd2;
		bid[9][PRICE_IDX-:64] <= 64'd1;
		// Set quantity and 
		bid[0][QUANTITY_IDX-:32] <= 16'd8;
		bid[1][QUANTITY_IDX-:32] <= 16'd8;
		bid[2][QUANTITY_IDX-:32] <= 16'd8;
		bid[3][QUANTITY_IDX-:32] <= 16'd8;
		bid[4][QUANTITY_IDX-:32] <= 16'd8;
		bid[5][QUANTITY_IDX-:32] <= 16'd8;
		bid[6][QUANTITY_IDX-:32] <= 16'd8;
		bid[7][QUANTITY_IDX-:32] <= 16'd8;
		bid[8][QUANTITY_IDX-:32] <= 16'd8;
		bid[9][QUANTITY_IDX-:32] <= 16'd8;
		// Set num orders
		bid[0][NUM_ORDERS_IDX-:32] <= 8'd8;
		bid[1][NUM_ORDERS_IDX-:32] <= 8'd8;
		bid[2][NUM_ORDERS_IDX-:32] <= 8'd8;
		bid[3][NUM_ORDERS_IDX-:32] <= 8'd8;
		bid[4][NUM_ORDERS_IDX-:32] <= 8'd8;
		bid[5][NUM_ORDERS_IDX-:32] <= 8'd8;
		bid[6][NUM_ORDERS_IDX-:32] <= 8'd8;
		bid[7][NUM_ORDERS_IDX-:32] <= 8'd8;
		bid[8][NUM_ORDERS_IDX-:32] <= 8'd8;
		bid[9][NUM_ORDERS_IDX-:32] <= 8'd8;
		
		//ASK0 contains lowest ask.
		// set price
		ask[0][PRICE_IDX-:64] <= 64'd1;
		ask[1][PRICE_IDX-:64] <= 64'd2;
		ask[2][PRICE_IDX-:64] <= 64'd4;
		ask[3][PRICE_IDX-:64] <= 64'd5;
		ask[4][PRICE_IDX-:64] <= 64'd6;
		ask[5][PRICE_IDX-:64] <= 64'd7;
		ask[6][PRICE_IDX-:64] <= 64'd8;
		ask[7][PRICE_IDX-:64] <= 64'd9;
		ask[8][PRICE_IDX-:64] <= 64'd10;
		ask[9][PRICE_IDX-:64] <= 64'd11;
		//Set quantity and 
		ask[0][QUANTITY_IDX-:32] <= 16'd8;
		ask[1][QUANTITY_IDX-:32] <= 16'd8;
		ask[2][QUANTITY_IDX-:32] <= 16'd8;
		ask[3][QUANTITY_IDX-:32] <= 16'd8;
		ask[4][QUANTITY_IDX-:32] <= 16'd8;
		ask[5][QUANTITY_IDX-:32] <= 16'd8;
		ask[6][QUANTITY_IDX-:32] <= 16'd8;
		ask[7][QUANTITY_IDX-:32] <= 16'd8;
		ask[8][QUANTITY_IDX-:32] <= 16'd8;
		ask[9][QUANTITY_IDX-:32] <= 16'd8;
		//Set num orders
		ask[0][NUM_ORDERS_IDX-:32] <= 8'd8;
		ask[1][NUM_ORDERS_IDX-:32] <= 8'd8;
		ask[2][NUM_ORDERS_IDX-:32] <= 8'd8;
		ask[3][NUM_ORDERS_IDX-:32] <= 8'd8;
		ask[4][NUM_ORDERS_IDX-:32] <= 8'd8;
		ask[5][NUM_ORDERS_IDX-:32] <= 8'd8;
		ask[6][NUM_ORDERS_IDX-:32] <= 8'd8;
		ask[7][NUM_ORDERS_IDX-:32] <= 8'd8;
		ask[8][NUM_ORDERS_IDX-:32] <= 8'd8;
		ask[9][NUM_ORDERS_IDX-:32] <= 8'd8;
	
	end
	always_ff @(posedge clk) begin
		if(reset) begin
			reset <= 'b0;
		
		end else begin
			if(message_ready && enable_order_book && DG_SECURITY_ID == SECURITY_ID) begin
			
			// New
			if(ACTION == 2'd0) begin
				// ENTRY_TYPE == bid
				if(ENTRY_TYPE == 2'd0) begin
					for(int i = 0; i < MAX_CONTRACTS; i++) begin
						if(bid[i][PRICE_IDX-:64] == PRICE) begin
							bid[i][QUANTITY_IDX-:32] <= bid[i][QUANTITY_IDX-:32] + QUANTITY;
							bid[i][NUM_ORDERS_IDX-:32] <= bid[i][NUM_ORDERS_IDX-:32] + NUM_ORDERS;
							break;
						end else if(bid[i][PRICE_IDX -:64] < PRICE) begin
							for(int j = MAX_CONTRACTS-1; j > i; j--) begin
								bid[j] <= bid[j-1];
							end
							bid[i] <= {QUANTITY, NUM_ORDERS, PRICE};
							break;
						end
					end
				end else if(ENTRY_TYPE == 2'd1) begin //ENTRY_TYPE == ask
					for(int i = 0; i < MAX_CONTRACTS; i++) begin
						if(ask[i][PRICE_IDX-:64] == PRICE) begin
							ask[i][QUANTITY_IDX-:32] <= ask[i][QUANTITY_IDX-:32] + QUANTITY;
							ask[i][NUM_ORDERS_IDX-:32] <= ask[i][NUM_ORDERS_IDX-:32] + NUM_ORDERS;
							break;
						end
						else if(ask[i][PRICE_IDX-:64] > PRICE) begin
							for(int j = MAX_CONTRACTS-1; j > i; j--) begin
								ask[j] <= ask[j-1];
							end
							ask[i] <= {QUANTITY, NUM_ORDERS, PRICE};
							break;
						end
					end
				end
			end else if (ACTION == 2'd1)begin //update existing
				if(ENTRY_TYPE == 2'd0)begin
					for(int i = 0; i < MAX_CONTRACTS; i++) begin
						if(bid[i][PRICE_IDX-:64] == PRICE) begin
							bid[i][QUANTITY_IDX-:32] <= bid[i][QUANTITY_IDX-:32] + QUANTITY;
							bid[i][NUM_ORDERS_IDX-:32] <= bid[i][NUM_ORDERS_IDX-:32] + NUM_ORDERS;
							break;
						end 
					end
				end else if(ENTRY_TYPE == 2'd1)begin
					for(int i = 0; i < MAX_CONTRACTS; i++) begin
						if(ask[i][PRICE_IDX-:64] == PRICE) begin
							ask[i][QUANTITY_IDX-:32] <= ask[i][QUANTITY_IDX-:32] + QUANTITY;
							ask[i][NUM_ORDERS_IDX-:32] <= ask[i][NUM_ORDERS_IDX-:32] + NUM_ORDERS;
							break;
						end 
					end
				end
			end else if( ACTION == 2'd2) begin //delete from book action
				if(ENTRY_TYPE == 2'd0) begin
					for(int i=0; i<MAX_CONTRACTS; i++) begin
						if(bid[i][PRICE_IDX -:64] == PRICE) begin
							bid[i][QUANTITY_IDX-:32] <= bid[i][QUANTITY_IDX-:32] - QUANTITY;
							bid[i][NUM_ORDERS_IDX-:32] <= bid[i][NUM_ORDERS_IDX-:32] - NUM_ORDERS;
						
							//if no more orders left, delete entry from book
							//we check if it's equal to QUANTITY so that we can do this operation in 1 clock cycle
							if(bid[i][QUANTITY_IDX-:32] == QUANTITY && bid[i][NUM_ORDERS_IDX-:32] == NUM_ORDERS)begin
								for(int j = i; j < MAX_CONTRACTS-1; j++) begin
									bid[j] <= bid[j+1];
								end //end for
							end
							//NEED TO FIGURE WHAT TO DO WITH LAST ORDER IN BID BOOK
							break;
						end
					end//end for-loop
				end else if(ENTRY_TYPE == 2'd1) begin
					for(int i=0; i<MAX_CONTRACTS; i++) begin
						if(ask[i][PRICE_IDX -:64] == PRICE) begin
							ask[i][QUANTITY_IDX-:32] <= ask[i][QUANTITY_IDX-:32] - QUANTITY;
							ask[i][NUM_ORDERS_IDX-:32] <= ask[i][NUM_ORDERS_IDX-:32] - NUM_ORDERS;
						
							//if no more orders left, delete entry from book
							//we check if it's equal to QUANTITY so that we can do this operation in 1 clock cycle
							if(ask[i][QUANTITY_IDX-:32] == QUANTITY && ask[i][NUM_ORDERS_IDX-:32] == NUM_ORDERS)begin
								for(int j = i; j < MAX_CONTRACTS-1; j++) begin
									ask[j] <= ask[j+1];
								end //end for
							end
							//NEED TO FIGURE WHAT TO DO WITH LAST ORDER IN BID BOOK
							break;
						end
					end//end for-loop
				end//end else if entRY_TYPE
			end
			end //end if(message_ready)
		end //end if-else reset
	end //end always_ff
endmodule
