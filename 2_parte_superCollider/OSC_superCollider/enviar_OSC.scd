~enviarOSC = NetAddr("127.0.0.1", NetAddr.langPort);

~enviarOSC.sendMsg("/testeAudio", 1);
~enviarOSC.sendMsg("/testeAudio", 0);
