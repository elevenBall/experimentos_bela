s.boot;
(
~port = SerialPort("/dev/cu.usbserial-1120", baudrate: 9600);
)


Tdef.all.do(_.stop);
SerialPort.closeAll;


(
~intArray = [ ];
Tdef(\readValues, {
	loop{
		~ascii = ~port.read;
		case

		{~ascii == nil} {nil}

		{~ascii.asAscii.isDecDigit}
		{~intArray = ~intArray.add(~ascii.asAscii.digit)}

		{~ascii.asAscii == $a}
		{
			~val_X = ~intArray.convertDigits;
			~intArray = [ ];
		}

		{~ascii.asAscii == $b}
		{
			~val_Y = ~intArray.convertDigits;
			~intArray = [ ];
		}

		{true}{nil};
	};
}).play
)


(
Tdef(\postValues, {
	{
		~val_X.postln;
		~val_Y.postln;
		"".postln;
		0.1.wait;
	}.loop;
}).play
)




Tdef(\postValues).stop;
Tdef(\readValues).stop;