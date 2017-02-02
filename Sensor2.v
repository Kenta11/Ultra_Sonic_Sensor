`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Utsunomiya University
// Engineer: Kenta Arai
// 
// Create Date:    18:06:53 11/29/2016 
// Design Name: 	 Sensor Test
// Module Name:    Sensor2 
// Project Name: 	
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Sensor2(
    input CLK,
	 input RESET,
	 inout Sig,
	 output LD7,
	 output LD6,
	 output LD5,
	 output LD4,
	 output LD3,
	 output LD2,
	 output LD1,
	 output LD0
    );
  
  wire [19:0] TIME;
  
  //Measureモジュールと接続
  Measure MS(
    .CLK(CLK),
	 .RESET(RESET),
	 .Sig(Sig),
	 .TIME(TIME)
  );
  
  //どのLEDを光らせるか選択
  reg [2:0] Select;
  
  always@(posedge CLK)
  begin
    if(TIME > 24'd90000)
	   Select <= 3'b111;
	 else if(TIME > 24'd80000)
	   Select <= 3'b110;
	 else if(TIME > 24'd70000)
	   Select <= 3'b101;
	 else if(TIME > 24'd60000)
	   Select <= 3'b100;
	 else if(TIME > 24'd50000)
	   Select <= 3'b011;
	 else if(TIME > 24'd40000)
	   Select <= 3'b010;
	 else if(TIME > 24'd30000)
	   Select <= 3'b001;
	 else
	   Select <= 3'b000;
  end
  
  //LEDとSelectを関連づけ
  assign LD7 = (Select == 3'b111) ? 1'b1 : 1'b0;
  assign LD6 = (Select == 3'b110) ? 1'b1 : 1'b0;
  assign LD5 = (Select == 3'b101) ? 1'b1 : 1'b0;
  assign LD4 = (Select == 3'b100) ? 1'b1 : 1'b0;
  assign LD3 = (Select == 3'b011) ? 1'b1 : 1'b0;
  assign LD2 = (Select == 3'b010) ? 1'b1 : 1'b0;
  assign LD1 = (Select == 3'b001) ? 1'b1 : 1'b0;
  assign LD0 = (Select == 3'b000) ? 1'b1 : 1'b0;
  
endmodule
