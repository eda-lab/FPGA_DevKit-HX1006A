module dds_quarter  
#(parameter N = 24, M= 12, W = 10 )
(
	input clk,
	input	rst_n,
	input	[N-1:0] FreqWord,
	input [N-1:0] PhaseWord,
	output reg[W-1:0] q_sin
);

reg [N-1:0] acc,phase;
reg [W-2:0] sinrom[2**(M-2)-1:0];
wire [M-3:0] romaddr = phase[N-3:N-M];
reg [W-1:0] romdata;



always @(posedge clk,negedge rst_n)
	if(!rst_n)
		acc <= 0;
	else 
		acc <= acc + FreqWord;

always @(posedge clk,negedge rst_n)
	if(!rst_n)
		phase <= 0;
	else 
		phase <= acc + PhaseWord;
		

initial $readmemh("sin4096x10q.txt",sinrom);

always @(posedge clk)
	if(phase[N-2]) 
		if(romaddr==0) 
			romdata = sinrom[2**(M-2) - 1];
		else
			romdata = sinrom[2**(M-2) - romaddr];
	else
		romdata = sinrom[romaddr];


always @(posedge clk,negedge rst_n)
	if(!rst_n)
		q_sin <= 2**(W-1);
	else if(phase[N-1])
		q_sin <= 2**(W-1) - romdata;
	else
		q_sin <= 2**(W-1) + romdata;
	
		
endmodule 