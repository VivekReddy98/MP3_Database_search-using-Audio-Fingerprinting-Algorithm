
% LOAD Values into your work-space
load('HASHTABLE.mat');
load('SONGID.mat');
global hashtable
global songid

%initialize hashTableSize
hashTableSize = size(hashtable,1);

%samples
% Test5_noise_+4_.wav
% Test5_noise_+3_.wav
% Test_beat_it.mp3
% Test2.mp3
%Test5_noise_+5_.wav

[clip,fs] = audioread('Test5_noise_+5_.wav');
peaks=fingerprint(clip,fs);
clipTuples= convert_to_pairs(peaks);

o=1;
for m=1:size(clipTuples,1)
    clipHash =  simple_hash(clipTuples(m,3),clipTuples(m,4), clipTuples(m,2)-clipTuples(m,1), hashTableSize);
    %check whether the given hash in empty or not
    if(~isempty(hashtable{clipHash,1}))
        match_ID = hashtable{clipHash,1};
        match_time = hashtable{clipHash,2};
        clip_init_time = clipTuples(m,1);
        
        for n=1:size(match_time,2)
        timing_offset(o)= match_time(n)-clip_init_time;
        id_offset(o)= match_ID(n);
        o=o+1;
        end
    end
end

q=mode(timing_offset);
matchedfreq=find(timing_offset==q);
o=1;

for n=1:size(matchedfreq,2)
  k=matchedfreq(n);
  matchedsongid(n)=id_offset(k);
end
k=0;
[q occ] = mode(matchedsongid);
x = occ/length(matchedsongid);
%songid{q};
match=songid{q};
[Y,I]=sort(id_offset);
listed_id=Y;
listed_time=timing_offset(:,I);

fprintf('Your song is :')
disp(match);
disp(x)




