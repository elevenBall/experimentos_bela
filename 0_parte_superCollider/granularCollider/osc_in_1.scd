(
OSCdef.new(
	\val1,
	{
		arg msg, time, addr, port;
		msg[1].postln;
	},
	'/osc/val1'
);
)

NetAddr.langPort;