function makePianoSound(waveform, envelope, tremolo, noteFrequency, lowPass, highPass, volume, length)
% makePianoSound(waveform, envelope, frequency, volume, length) by Ruilin Hu
% func waveform = generated waveform from sine, tri, saw, and sqaure
% func envelop = ADSR envelope
% int noteFrequency = determined by Octave value & keys pressed
% int volume = volume slider value
% int length = how long the note should be played
% When a key on the keyboard is pressed, this function multiplies
% the generated waveform with envelope and then volume (amplitude)
% to find the output waveform. Then it mimics a piano Frequency 
% Response to generate resultant waveforms of the output.
% It then plays this sound.
% reference: https://www.mathworks.com/matlabcentral/answers/336146-merging-multiplying-functions
% reference: https://www.mathworks.com/help/signal/ref/sawtooth.html

outputWave = @(t) waveform(t); %outputWave = waveform * envelope

outputWaveFund = @(t)  outputWave(t*noteFrequency/(2*pi));

if noteFrequency*2 <= highPass && noteFrequency*2 >= lowPass
outputWaveFinal = @(t) 0.15*outputWaveFund(t*2);
end
if noteFrequency*3 <= highPass && noteFrequency*3 >= lowPass
outputWaveFinal = @(t) outputWaveFinal(t) + 0.1*outputWaveFund(t*3);
end
if noteFrequency*4 <= highPass && noteFrequency*4 >= lowPass
outputWaveFinal = @(t) outputWaveFinal(t) + 0.05*outputWaveFund(t*4);
end

if noteFrequency <= highPass && noteFrequency >= lowPass
outputWaveFinal = @(t) 0.7*outputWaveFund(t) + outputWaveFinal(t);
end

soundMatrix = zeros(length,1); %soundMatrix is lengthx1 matrix with all zeroes
for i = 1:length %interate from leftmost column to right, middle number is step size
    result = outputWaveFinal(i) * envelope(i);
    result = result * tremolo(i);
    result = result*volume/100;
    soundMatrix(i, 1) = result;
end
sound(soundMatrix, 10400);
end