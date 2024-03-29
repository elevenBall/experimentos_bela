s.boot;

// evaluate to find the name of your arduino
SerialPort.listDevices;
// see post window

// make sure serial monitor is not open in arduino IDE
// then open port
(
~port = SerialPort(
	"/dev/cu.usbserial-1120", // your arduino's name
	baudrate: 9600, // must match arduino rate
	crtscts: true
);
)

// a loop for reading from arduino
(
~routine = Routine {
	var byte, str, val, valX, valY;
	inf.do { |i|
		if(~port.read == Char.nl.asInteger, {
			str = "";
			while(
				{ byte = ~port.read; byte != Char.ret.asInteger },
				{ str = str ++ byte.asAscii }
			);
			val = str.split(Char.comma).asInteger;

			//val[1].postln;

			~valX = 0; // Initialize with default value
			~valY = 0; // Initialize with default value

			~valX_m = 0; // Initialize with default value
			~valY_m = 0; // Initialize with default value

			~valX = val[0];
			~valY = val[1];

			~valX_m = val[0];
			~valY_m = val[1];


			~valX_m = ~valX_m.linlin(0,1023, 0, 0.8);
			~valY_m = ~valY_m.linlin(0,1023, 0, 0.8);


			~valX = ~valX.linexp(0, 1023, 50, 300);
			~valY = ~valY.linexp(0, 1023, 1, 50);


			~graaa.set(\rateMOD, ~valX_m);
			~graaa.set(\trigRate, 10);

			x.set(\freqMin, ~valX);
			x.set(\freqMax, ~valY);

			//~synth.set(\freq, [~valX,~valY]);
		});
	};
}.play;
)



// stop
~routine.stop;
~port.close;

(
SynthDef(\basicSound, {
	var sig;
	sig = Saw.ar(\freq.kr([220,221]).varlag(\lagValor.kr(0.1)));
	sig = sig * 0.4;
	Out.ar(0, sig);
}).add;
)
~synth = Synth(\basicSound);

~synth.set(\lagValor, 0.05);

~synth.free;
