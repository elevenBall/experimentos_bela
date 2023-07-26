

OSCFunc.trace(false);

(
OSCdef(\get, {
	arg msg, time, addr, port;
	[msg, time, addr, port].postln;
}, "/testeAudio");
)