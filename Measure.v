`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:45:30 11/25/2016 
// Design Name: 
// Module Name:    Measure 
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
					 
module Measure(
    input CLK,
	 input RESET,
	 inout Sig,
	 output [19:0] TIME
    );
	 
  parameter [2:0] START = 3'b000,
                  FIRST = 3'b001,
                  SECOND = 3'b010,
				  	   MEASURE = 3'b011,
					   OUTTIME = 3'b100;
	 
  //300350μsで１周
  reg [19:0] clk_count;
  always@(posedge CLK or posedge RESET)
  begin
    if(RESET)
	   clk_count <= 20'h0;
    else if(clk_count >= 20'd965349)
		clk_count <= 20'd49;
	 else
	   clk_count <= clk_count + 19'd1;
  end
  
  //ステート
  reg [2:0] state;
  
  //ステートの遷移
  always@(posedge CLK)
  begin
    if(RESET)
	   state <= START;
    else case(state)
	   START : begin
		  if(clk_count == 20'd49)
		    state <= FIRST;
		  else
		    state <= state;
		end
		FIRST : begin
		  if(clk_count == 20'd299)
		    state <= SECOND;
		  else
		    state <= state;
		end
		SECOND : begin
		  if(clk_count == 20'd35299)
		    state <= MEASURE;
		  else
		    state <= state;
		end
		MEASURE : begin
		  if(clk_count == 20'd965299)
			 state <= OUTTIME;
		  else
		    state <= state;
		end
		OUTTIME : begin
		  if(clk_count == 20'd965349)
			 state <= FIRST;
		  else
		    state <= state;
		end
		default : begin
		  state <= START;
		end
    endcase
  end
  
  //1.超音波を送受信
  //超音波を送信:sigFlag=1
  //超音波を受信：sigFlag=0
  reg sigFlag;
  
  always@(posedge CLK)
  begin
    if(RESET)
	   sigFlag <= 1'b1;
    else case(state)
	   FIRST : begin
		  sigFlag <= 1'b1;
		end
		SECOND : begin
		  sigFlag <= 1'b1;
		end
		default : begin
		  sigFlag <= 1'b0;
		end
	 endcase
  end
  
  //sigFlag=1のとき
  //  state=STARTならば1,それ以外ならば0
  //sigFlag=0のとき
  //  ハイインピーダンス
  assign Sig = (sigFlag == 1'b1) ? ((state == FIRST) ? 1'b1 : 1'b0) : 1'bz;

  //2.超音波の計測
  //計測時間
  reg [19:0] MeasureCLK;
  //Sig=1の時間だけ、MeasureTimeを加算する。
  //計測時間外では常にMeasureTimeを0にしておく。
  always@(posedge CLK)
  begin
    case(state)
	   MEASURE : begin
		  case(Sig)
		    1'b1 : MeasureCLK <= MeasureCLK + 19'd1;
			 default : MeasureCLK <= MeasureCLK;
		  endcase
		end
		OUTTIME : MeasureCLK <= MeasureCLK;
		default : MeasureCLK <= 19'd0;
	 endcase
  end
  
  //3.距離の計算
  //計測距離の決定
  //物体までの距離
  //L = C * t / 2
  //L : 距離, C : 温度によって変化する変数, t : 時間
  //C = 331.5 * ((273 + T) / 273)
  //T : 温度
  //気温を考慮しない場合，C = 340とするのが一般的らしい？？？
  reg [19:0] MeasureTime;
  
  always@(posedge CLK)
  begin
    case(state)
	   START : begin
		  MeasureTime <= 16'hFFFF;
		end
	   OUTTIME : begin
		  MeasureTime <= MeasureCLK;
		end
		default : begin
		  MeasureTime <= MeasureTime;
		end
	 endcase
  end
  
  assign TIME = MeasureTime;

endmodule
