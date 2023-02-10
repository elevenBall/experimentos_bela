/*
 ____  _____ _        _    
| __ )| ____| |      / \   
|  _ \|  _| | |     / _ \  
| |_) | |___| |___ / ___ \ 
|____/|_____|_____/_/   \_\

http://bela.io

C++ Real-Time Audio Programming with Bela - Lecture 8: Filters
sample-player-filter: template code for implementing digital filters
*/

#include <Bela.h>
#include <libraries/Scope/Scope.h>
#include "MonoFilePlayer.h"
#include <cmath>
#include <cstdio>

// Name of the sound file (in project folder)
std::string gFilename = "slow-drum-loop.wav";

// Object that handles playing sound from a buffer
MonoFilePlayer gPlayer;

Scope gScope;

float gLastSample = 0;
float gIn1 = 0;
int gAudioFramesPerAnalogFrame = 0;

// TODO: declare global variable(s) to keep track of filter state

bool setup(BelaContext *context, void *userData)
{
	if(context->audioFrames != 2*context->analogFrames) {
		rt_fprintf(stderr, "This project needs analog I/O running at half the audio rate.\n");
		return false;
	}
	if(context->analogInChannels < 3) {
		rt_fprintf(stderr, "This project needs at least 3 analog inputs.\n");
		return false;
	}
	
	if(context->analogFrames)
		gAudioFramesPerAnalogFrame = context->audioFrames / context->analogFrames;
	
	// Load the audio file
	if(!gPlayer.setup(gFilename)) {
    	rt_printf("Error loading audio file '%s'\n", gFilename.c_str());
    	return false;
	}

	// Print some useful info
    rt_printf("Loaded the audio file '%s' with %d frames (%.1f seconds)\n", 
    			gFilename.c_str(), gPlayer.size(),
    			gPlayer.size() / context->audioSampleRate);
    			
    gScope.setup(2, context->audioSampleRate);

	return true;
}

void render(BelaContext *context, void *userData)
{
    for(unsigned int n = 0; n < context->audioFrames; n++) {
    	if(gAudioFramesPerAnalogFrame && !(n % gAudioFramesPerAnalogFrame)) {
			// read analog inputs and update frequency and amplitude
			gIn1 = 3* analogRead(context, n/gAudioFramesPerAnalogFrame, 0);
			gIn1 = map(gIn1, 0, 1, 1, 300);
			
		}
    	
    	
    	
        float in = gPlayer.process();

        // TODO: implement filter equation here
		
		float out = in - gLastSample;
		int gInt_1 = (int)gIn1;
        if( n % gInt_1 == 0){
    		gLastSample = in;
        }

    	for(unsigned int channel = 0; channel < context->audioOutChannels; channel++) {
			// Write the sample to every audio output channel
    		audioWrite(context, n, channel, out);
    	}
    	gScope.log(out, gIn1); 
    }
}

void cleanup(BelaContext *context, void *userData)
{

}
