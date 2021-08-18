`timescale 1ns / 1ps

/****************************************************************************************************/
/*       __      __     _________      _       _      _________      _________      _________       */
/*       \$\    /$/    |$$$$$$$$$|    |$|     |$|    |$$$$$$$$$|    |$$$$$$$$$|    |$$$$$$$$$|      */
/*        \$\  /$/     |$|     |$|    |$|     |$|    |$|     |$|    |$|     |$|    |$|              */
/*         \$\/$/      |$|     |$|    |$|     |$|    |$|_______     |$|     |$|    |$|_____         */
/*          |$$|       |$|     |$|    |$|     |$|    |$$$$$$$$$|    |$|     |$|    |$$$$$$$|        */
/*          |$$|       |$|     |$|    |$|     |$|     _      |$|    |$|     |$|    |$|              */
/*          |$$|       |$|_____|$|    |$|_____|$|    |$|_____|$|    |$|     |$|    |$|              */
/*          |$$|       |$$$$$$$$$|    |$$$$$$$$$|    |$$$$$$$$$|    |$$$$$$$$$|    |$|              */
/*                                                                                                  */
/****************************************************************************************************/

module project
	(
	
	input x, CLK, Reset, // inputs
	
	output reg [7:0] out// output
	
   );
	
	initial out = 0;
	
	//**************************************************************************************
	// har kodoom az parametr haye moredenazre soal ro be on vane yek register tarif kardam
	reg [7:0] speed_of_wind;
	reg [7:0] persent_of_humi;
	reg [7:0] degree_of_temp;
	
	
	//************************************************************************************************************
	// in always block hokme counter ro baraye ma dare va ba har clock pulse, donbale hesabi ro yeki jelo mibare 
	always @(posedge CLK)
		
		if (Reset) 
		begin
			speed_of_wind <= 19 + 8; // ba ratesh jamkardam chon clock pulse aval ro nazar nemigire
			persent_of_humi <= 52 + 1;	// ba ratesh jamkardam chon clock pulse aval ro nazar nemigire
			degree_of_temp <= 43 + 3; // ba ratesh jamkardam chon clock pulse aval ro nazar nemigire
		end
		
		else
		begin
			speed_of_wind <= speed_of_wind + 8;
			persent_of_humi <= persent_of_humi + 1;
			degree_of_temp <= degree_of_temp + 3;
		end
			
			
			
	//**************************************************************************************************
	// az in ja be paeen man seta sequence detector tarif kardam ke sequence haye voroodi ro peyda kone
	// yeki baraye wind va yeki baraye humidity va dar nahayat ham yeki baraye tempreture
	
	
	
	
	//**************************************************************************************************
	// inja man seta moteghayer tarif kardam ke harkodoom zamani yek mishan ke sequence ro detect konan
	reg output_temp;
	reg output_humi;
	reg output_wind;
	

	
	//*****************************************************
	// state haro baraye detect kardane tempreture misazim
	parameter s0_temp = 0;
	parameter s1_temp = 1;
	parameter s2_temp = 2;
	
	//*****************************************************
	// state haro baraye detect kardane humidity misazim
	parameter s0_humi = 0;
	parameter s1_humi = 1;
	parameter s2_humi = 2;
	
	//*****************************************************
	// state haro baraye detect kardane wind misazim
	parameter s0_wind = 0;
	parameter s1_wind = 1;
	parameter s2_wind = 2;
	
	
	reg [1:0] PS_temp, NS_temp; // present state va next state baraye tempreture ro misazim
	reg [1:0] PS_humi, NS_humi; // present state va next state baraye humidity ro misazim
	reg [1:0] PS_wind, NS_wind; // present state va next state baraye wind ro misazim

	
	
	//***************************************************
	// in always block baraye sakhtane present state hast
	
	always @(posedge CLK or posedge Reset)
		
		if (Reset) 
		begin
			PS_temp <= s0_temp;
			PS_humi <= s0_humi;
			PS_wind <= s0_wind;
		end
		
		else
		begin
			PS_temp <= NS_temp;
			PS_humi <= NS_humi;
			PS_wind <= NS_wind;
		end
	
	
	
	
	//*******************************************************************************
	// in always block baraye sakhtane khoroojie harseta sequence detectoremoon hast
	
	always @(posedge CLK or posedge Reset)
		
		if (Reset)
		begin
			output_temp <= 1'b0;
			output_humi <= 1'b0;
			output_wind <= 1'b0;
		end
		
		else
		begin
			output_temp <= (PS_temp == s2_temp) && x;
			output_humi <= (PS_humi == s2_humi) && ~x;
			output_wind <= (PS_wind == s2_wind) && x;
		end
			
			
	
	
	//*******************************************************************
	// tooye in always block ham next state ro baraye tempreture misazim
	
	always @(*)
			case(PS_temp)
				
				s0_temp : NS_temp = x ? s1_temp : s0_temp;
				s1_temp : NS_temp = x ? s2_temp : s0_temp;
				s2_temp : NS_temp = x ? s2_temp : s0_temp;

			endcase


	//*****************************************************************
	// tooye in always block ham next state ro baraye humidity misazim
	
	always @(*)
			case(PS_humi)
				
				s0_humi : NS_humi = x ? s0_humi : s1_humi;
				s1_humi : NS_humi = x ? s2_humi : s1_humi;
				s2_humi : NS_humi = x ? s0_humi : s1_humi;

			endcase
		
	
	//*************************************************************
	// tooye in always block ham next state ro baraye wind misazim
	
	always @(*)
			case(PS_wind)
				
				s0_wind : NS_wind = x ? s1_wind : s0_wind;
				s1_wind : NS_wind = x ? s1_wind : s2_wind;
				s2_wind : NS_wind = x ? s1_wind : s0_wind;

			endcase
		
		
	//*****************************************************************************************************************
	// vadar nahayat age harkodom az sequence ha detect shod in always meghdare oon ro tooye khorooji be namayesh mide
	always @(posedge CLK)
	begin
	
		if(output_temp)
			out <= degree_of_temp;
			
		if(output_humi)
			out <= persent_of_humi;
			
		if(output_wind)
			out <= speed_of_wind;
	
	end
	
	
endmodule
