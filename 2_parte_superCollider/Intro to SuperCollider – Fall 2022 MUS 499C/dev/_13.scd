s.boot;

NetAddr.langPort;

~me = NetAddr("127.0.0.1", 57120);

~me.sendMsg("/ola", 3, 4, 5);
~me.sendMsg("/o", 1, 1, 1);

(
OSCdef(\receiver,{
	arg msg;
	msg.postln;
}, "/ola")
)


OSCFunc

OSCdef



OSCFunc.trace(false);

SerialPort


s.makeGui;

