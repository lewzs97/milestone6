module m5(
  input clk,rst,
  input play,
  output sound,
  output led0,led1,led2,led3,led4,led5
);
  
  wire [2:0] cv;
  wire done;
  
//  control_unit u1(.clk(clk),.rst(rst),.play(play),.done(done),.cv(cv));
  control_unit u1(.clk(clk),.rst(rst),.play(play),.done(done),.cv(cv),.led0(led0),.led1(led1),.led2(led2),.led3(led3),.led4(led4),.led5(led5));
  datapath_unit u2(.clk(clk),.rst(rst),.cv(cv),.sound(sound),.done(done));
  
endmodule
