
function peaks = fingerprint(sound,fs)

% It returns a binary
% matrix indicating the locations of peaks in the spectrogram.
                                             
new_smpl_rate = 8000; % sampling rate 
time_res = .064; % for spectrogram
gs = 4; % grid size for spectrogram peak search
desiredPPS = 30; % scales the threshold

%[y fs] = audioread(sound);
y = sound;
z = mean(y(:,1)+y(:,2));
y = (y(:,1)+y(:,2))/2;
time_sample = length(y)/fs;
z = repmat(z,length(y),1);
y = y-z;
y = resample(y,new_smpl_rate,fs);
% Create the spectrogram
% Because the signal is real, only positive frequencies will be returned by
% the spectrogram function, which is all we will need.
% INSERT SPECTROGRAM CODE HERE.
window = int64((time_res*length(y))/time_sample);
noverlap = window/2;
[S,F,T] = spectrogram(y, window, noverlap, [], new_smpl_rate);
magS = abs(S); 

% Find the local peaks with respect to the nearest gs entries in both
% directions

peaks = circshift_gs(magS,2);                 

threshold = 1;

peakMags = peaks.*magS;

sortedpeakMags = sort(peakMags(:),'descend'); % sort al peak values in order
threshold = sortedpeakMags(ceil(max(T)*desiredPPS));
% Apply threshold
if (threshold > 0)
 peaks = (peakMags >= threshold);
end

optional_plot = 0; % turn plot on or off

if optional_plot
    % plot spectrogram
    figure;
    Tplot = [2, 3]; % Time axis for plot

    logS = log(magS);
    imagesc(T,F,logS);
    title('Log Spectrogram');
    xlabel('time (s)');
    ylabel('frequency (Hz)');
    axis xy;
    axis([Tplot, -inf, inf]);
    frame1 = getframe;

    %plot local peaks over spectrogram
    peaksSpec = (logS - min(min(logS))).*(1-peaks);
    imagesc(T,F,peaksSpec);
    title('Log Spectrogram');
    xlabel('time (s)');
    ylabel('frequency (Hz)');
    axis xy
    axis([Tplot, -inf, inf])
    frame2 = getframe;

    movie([frame1,frame2],10,1)
end

end

