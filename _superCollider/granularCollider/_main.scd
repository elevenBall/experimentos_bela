(
s.boot;
Server.default.options.device_("AudioFire4 (2945)");
Server.default.reboot;
)

/*
Server.default.options.inDevice_("Built-in Microph");
Server.default.options.outDevice_("Built-in Output");
*/

(
s.meter;
s.plotTree;
s.scope;
)


(
var caminho;
caminho = thisProcess.nowExecutingPath.dirname +/+ "au1.wav";
b = Buffer.read( s, caminho);
)




b.play;


s.quit;

File.getcwd;


thisProcess.nowExecutingPath.dirname +/+ "au1.wav";