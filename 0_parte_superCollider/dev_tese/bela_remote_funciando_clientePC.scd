// on remote machine connecting to server
(
o = ServerOptions.new;
o.maxLogins = 4;
t = Server.remote(\remote, NetAddr("bela.local", 57110), o); // set to correct address and port
// info about returned client ID should be posted in the post window
t.makeWindow; // make a window for monitoring
)

Server.default = t;
s.boot;
s.reboot;

s.freeAll;


{ SinOsc.ar(200, SinOsc.ar(XLine.kr(1, 1000, 9), 0, 2pi), 0.25)* 0.7 }.play;