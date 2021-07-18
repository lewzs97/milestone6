module control_unit(
  input clk,rst,
  input play,done,
  output reg [2:0] cv,
  output reg led0,led1,led2,led3,led4,led5
);
  
  reg [2:0] state,next_state;
  parameter [2:0] S0=0,S1=1,S2=2,S3=3,S4=4,S5=5;
  
  always @(posedge clk,negedge rst)
    begin
      if(rst==0)
        state<=S0;
      else
        state<=next_state;
    end
  
  always @(state,next_state,play,done)
    begin
      cv=0;
      case(state)
        S0: begin
			 led0=1;
          if(play)
            next_state=S1;
          else
            next_state=S0;
        end
        
        S1:begin
		    led1=1;
          cv=3'b100;
          if(done)
            next_state=S2;
          else
            next_state=S1;
        end
        
        S2:begin
		    led2=1;
          if(play)
            next_state=S3;
          else
            next_state=S2;
        end
        
        S3:begin
		    led3=1;
          cv=3'b010;
          if(done)
            next_state=S4;
          else
            next_state=S3;
        end
        
        S4:begin
		    led4=1;
          if(play)
            next_state=S5;
          else
            next_state=S4;
        end
        
        S5:begin
		    led5=1;
          cv=3'b001;
          if(done)
            next_state=S0;
          else
            next_state=S5;
        end
      endcase
    end
endmodule