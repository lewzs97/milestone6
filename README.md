# milestone6
A simple music box on FPGA

# Pin assignment

![pin1](https://github.com/lewzs97/milestone6/blob/main/pin%20planner%201.JPG)
![pin2](https://github.com/lewzs97/milestone6/blob/main/pin%20planner%202.JPG)

clk signal is connected to pin 62  
led 0 to 5 are state indicators for States (S0,S1,S2,S3,S4,S5) connected to pins 68 to 73.  
play input signal is connected to pin 81  
rst input signal is connected to pin 85 and is designated active low  
sound output signal to buzzer is connected to pin 77  


# Hardware circuit connection

![hardware](https://github.com/lewzs97/milestone6/blob/main/Circuit%20Connection.jpg)

Connect pin 85 to rst input, control by a slide switch, indicate by a red LED  
Connect pin 81 to play input, control by a push button, indicate by a green LED  
A row of LEDs showing the states of system, from led5 (leftmost) to led0 (rightmost)  
NPN transistor (2N3904) is used, pin 77 connect to Base, Piezo buzzer (supply by +5Vdc) connect to Emitter, Ground connect to Collector.  



# Negative edge reset

![rst1](https://github.com/lewzs97/milestone6/blob/main/Test%20rst%201.jpg)
![rst2](https://github.com/lewzs97/milestone6/blob/main/Test%20rst%202.jpg)

LED lights up when slide switch is slided from right to left to right again to indicate negative edge reset.  


# Demo

https://github.com/lewzs97/milestone6/blob/main/m6.mp4

There are some problems from the hardware as we can see from the video. However, the testbench and simulation are able to show the ideas that we would like to implement based on the code written.  
1.	The 6 LEDs showing the states of FSM do not function properly.  
2.	Piezo buzzer does not give proper sound output.  
