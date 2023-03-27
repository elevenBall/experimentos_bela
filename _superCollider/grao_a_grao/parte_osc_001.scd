//-------------------------- OSC //--------------------------\\

(
OSCdef.new (
	\val1,
	{
		arg msg, time, addr, port;
		y.set(\vRateTrig, msg[1].linlin(0,1, 0.0001, 10));
		//msg[1].postln;
		//[msg, time, addr, port].postln;
	},'/osc/val1'
	//'/appleWatch/attitude/x'
);
)

(
OSCdef.new( \val2, { arg msg;
		y.set(\vPlayBackRate, msg[1].linlin(0,1, -5, 5));
	}, '/osc/val2');
)

(
OSCdef.new( \val3, { arg msg;
	y.set(\vDuration, msg[1].linlin(0,1, 0, 1));
	}, '/osc/val3');
)

(
OSCdef.new( \val4, { arg msg;
	y.set(\vPosition, msg[1].linlin(0,1, 0, 1));
	}, '/osc/val4');
)

(
OSCdef.new( \bt1, { arg msg;
	//x.set(\vPosition, msg[1].linlin(0,1, 0, 1));
	if ( msg[1] == 0, { (y = Synth.new(\granulador_1))}, {y.free});
	}, '/osc/bt1');
)





NetAddr.langPort;
//----------------------------------------------------------\\

