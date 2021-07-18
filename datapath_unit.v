module datapath_unit(
  input clk,rst,
  input [2:0] cv,
  output reg sound,
  output reg done
);
  
  wire a,b,c;
  assign {a,b,c} = cv;
  
  reg [14:0] counter1,counter2;
  reg [2:0] counter1_stop,counter2_stop,counter3_stop;
  reg x;
  reg y;
  reg z;
  
  reg [22:0] tone;
  wire [6:0] ramp = (tone[22]?tone[21:15]:~tone[21:15]);
  wire [14:0] clkdivider = {2'b01,ramp,6'b000000};
  
  reg [27:0] tone2;
  wire [5:0] fullnote = tone2[27:22];
  wire [2:0] octave;
  wire [3:0] note;
  
  divide_by12 divby12(.numer(fullnote[5:0]), .quotient(octave), .remain(note));

  reg [8:0] clkdivider2;
  reg [8:0] counter_note;
  reg [7:0] counter_octave;
  
  always @(posedge clk,negedge rst)
    begin
      if(rst==0)
        begin
          counter1<=0;
          counter2<=0;
          x<=0;
          y<=0;
          z<=0;
          tone<=0;
          counter_note<=0;
          counter_octave<=0;
          clkdivider2<=0;
          tone2<=0;
        end
      else if(a==1)
        begin
          if(counter1==28408)
            begin
              counter1<=0;
              x<=~x;
            end
          else
            counter1<=counter1+1;
        end
      else if(b==1)
        begin
          tone<=tone+1;
          if(counter2==0)
            begin
              counter2<=clkdivider;
              y<=~y;
            end
          else
            counter2<=counter2-1;
        end
      else if(c==1)
        begin
          tone2<=tone2+1;
          case(note)
            0: clkdivider2 = 512-1; // A
            1: clkdivider2 = 483-1; // A#/Bb
            2: clkdivider2 = 456-1; // B
            3: clkdivider2 = 431-1; // C
            4: clkdivider2 = 406-1; // C#/Db
            5: clkdivider2 = 384-1; // D
            6: clkdivider2 = 362-1; // D#/Eb
            7: clkdivider2 = 342-1; // E
            8: clkdivider2 = 323-1; // F
            9: clkdivider2 = 304-1; // F#/Gb
            10: clkdivider2 = 287-1; // G
            11: clkdivider2 = 271-1; // G#/Ab
            12: clkdivider2 = 0; // should never happen
            13: clkdivider2 = 0; // should never happen
            14: clkdivider2 = 0; // should never happen
            15: clkdivider2 = 0; // should never happen
          endcase
          if(counter_note==0)
            begin
              counter_note<=clkdivider2;
              if(counter_octave==0)
                begin
                  counter_octave <= (octave==0?255:octave==1?127:octave==2?63:octave==3?31:octave==4?15:7);
                  z<=~z;
                end
              else
                counter_octave <= counter_octave-1;
            end
          else
            counter_note<=counter_note-1;
        end
      else 
        begin
          x<=x;
          z<=z;
          y<=y;
        end
    end
  
  initial begin
    counter1_stop=0;
    counter2_stop=0;
    counter3_stop=0;
  end
  
  always @(*)
    begin
      if(a==1)
        begin
          if(x==1)
            counter1_stop=counter1_stop+1;
          else if(counter1_stop==5)
            counter1_stop=0;
          else
            counter1_stop=counter1_stop;
        end
    end
  
  always @(*)
    begin
      if(b==1)
        begin
          if(y==1)
            counter2_stop=counter2_stop+1;
          else if(counter2_stop==5)
            counter2_stop=0;
          else
            counter2_stop=counter2_stop;
        end
    end
  
  always @(*)
    begin
      if(c==1)
        begin
          if(z==1)
            counter3_stop=counter3_stop+1;
          else if(counter3_stop==5)
            counter3_stop=0;
          else
            counter3_stop=counter3_stop;
        end
    end
  
  always @(*)
    begin
      if(a==1)
        begin
          if(counter1_stop==5)
            sound=0;
          else
            sound=x;
        end
      else if (b==1)
        begin
          if(counter2_stop==5)
            sound=0;
          else
            sound=y;
        end
      else if(c==1)
        begin
          if(counter3_stop==5)
            sound=0;
          else
            sound=z;
        end
      else
        sound=0;
    end
  
  always @(*)
    begin
      if(a==1)
        begin
          if(counter1_stop==5)
            done=1;
          else
            done=0;
        end
      else if(b==1)
        begin
          if(counter2_stop==5)
            done=1;
          else
            done=0;
        end
      else if(c==1)
        begin
          if(counter3_stop==5)
            done=1;
          else
            done=0;
        end
      else
        done=0;
    end

  
endmodule

module divide_by12(numer, quotient, remain);
  input [5:0] numer;
  output [2:0] quotient;
  output [3:0] remain;
  
  reg [2:0] quotient;
  reg [3:0] remain_bit3_bit2;
  
  assign remain = {remain_bit3_bit2, numer[1:0]}; 
  
  always @(numer[5:2]) 
    case(numer[5:2])
      0: begin quotient=0; remain_bit3_bit2=0; end
      1: begin quotient=0; remain_bit3_bit2=1; end
      2: begin quotient=0; remain_bit3_bit2=2; end
      3: begin quotient=1; remain_bit3_bit2=0; end
      4: begin quotient=1; remain_bit3_bit2=1; end
      5: begin quotient=1; remain_bit3_bit2=2; end
      6: begin quotient=2; remain_bit3_bit2=0; end
      7: begin quotient=2; remain_bit3_bit2=1; end
      8: begin quotient=2; remain_bit3_bit2=2; end
      9: begin quotient=3; remain_bit3_bit2=0; end
      10: begin quotient=3; remain_bit3_bit2=1; end
      11: begin quotient=3; remain_bit3_bit2=2; end
      12: begin quotient=4; remain_bit3_bit2=0; end
      13: begin quotient=4; remain_bit3_bit2=1; end
      14: begin quotient=4; remain_bit3_bit2=2; end
      15: begin quotient=5; remain_bit3_bit2=0; end
    endcase
endmodule