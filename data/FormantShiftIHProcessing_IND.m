%% Formant IH Table
% location of this file is in column 7 of fulluniquesubjs(j,7), where j is
% the unique subject ID!



load('InitializedOutput.mat');


%makesoundfiles = input('Do you want to make all the associated sound files? Y or N: ','s');
makesoundfiles = 'Y';

h = waitbar(0,'Initializing waitbar for FormantShiftIH data analysis...');
filenum = 0;
utterance = 0;

% Lets label the columns of our data sheet
FormantSHIFTIHData{1,1} = 'PROCESS_ORDER';
FormantSHIFTIHData{1,2} = 'exp'; % exp is Column 2
FormantSHIFTIHData{1,3} = 'num_block'; % in what block did Formant IH Shift exp occur?
FormantSHIFTIHData{1,4} = 'phasename'; % name of phase is in Column 3
FormantSHIFTIHData{1,5} = 'num_phase'; %position of the phase.
FormantSHIFTIHData{1,6} = 'num_rep'; %Rep of the phase is Column 5
FormantSHIFTIHData{1,7} = 'num_trial'; % Trial number for the given rep is Column 6
FormantSHIFTIHData{1,8} = 'subject_id'; % subject number is Column 7
FormantSHIFTIHData{1,9} = 'prompt'; % what they said is Column 8
FormantSHIFTIHData{1,10} = 'Avg_F1';
FormantSHIFTIHData{1,11} = 'Stdev_F1';
FormantSHIFTIHData{1,12} = 'Min_F1';
FormantSHIFTIHData{1,13} = 'Max_F1';
FormantSHIFTIHData{1,14} = 'Median_F1';
FormantSHIFTIHData{1,15} = 'Avg_F2';
FormantSHIFTIHData{1,16} = 'Stdev_F2';
FormantSHIFTIHData{1,17} = 'Min_F2';
FormantSHIFTIHData{1,18} = 'Max_F2';
FormantSHIFTIHData{1,19} = 'Median_F2';
FormantSHIFTIHData{1,20} = 'Avg_F3';
FormantSHIFTIHData{1,21} = 'Stdev_F3';
FormantSHIFTIHData{1,22} = 'Min_F3';
FormantSHIFTIHData{1,23} = 'Max_F3';
FormantSHIFTIHData{1,24} = 'Median_F3';
FormantSHIFTIHData{1,25} = 'Avg_F4';
FormantSHIFTIHData{1,26} = 'Stdev_F4';
FormantSHIFTIHData{1,27} = 'Min_F4';
FormantSHIFTIHData{1,28} = 'Max_F4';
FormantSHIFTIHData{1,29} = 'Median_F4';
FormantSHIFTIHData{1,30} = 'F0';
FormantSHIFTIHData{1,31} = 'Stdev_F0';
FormantSHIFTIHData{1,32} = 'Min_F0';
FormantSHIFTIHData{1,33} = 'Max_F0';
FormantSHIFTIHData{1,34} = 'Median_F0';
FormantSHIFTIHData{1,35} = 'sample_rate';
FormantSHIFTIHData{1,36} = 'tt_length_samples';
FormantSHIFTIHData{1,37} = 'an_length_samples';
FormantSHIFTIHData{1,38} = 'an_length_s';
FormantSHIFTIHData{1,39} = 'dB of utterance';
FormantSHIFTIHData{1,40} = 'S_Avg_F1';
FormantSHIFTIHData{1,41} = 'S_Stdev_F1';
FormantSHIFTIHData{1,42} = 'S_Min_F1';
FormantSHIFTIHData{1,43} = 'S_Max_F1';
FormantSHIFTIHData{1,44} = 'S_Median_F1';
FormantSHIFTIHData{1,45} = 'S_Avg_F2';
FormantSHIFTIHData{1,46} = 'S_Stdev_F2';
FormantSHIFTIHData{1,47} = 'S_Min_F2';
FormantSHIFTIHData{1,48} = 'S_Max_F2';
FormantSHIFTIHData{1,49} = 'S_Median_F2';
FormantSHIFTIHData{1,50} = 'Average_trimmedpitchratio';
FormantSHIFTIHData{1,51} = 'sample length trimmedpitch in s';
FormantSHIFTIHData{1,52} = 'Inclipped';
FormantSHIFTIHData{1,53} = 'Outclipped';
FormantSHIFTIHData{1,54} = 'Utterance_Num';


for p = 1:length(fulluniquesubjs)
    currentfile = files{fulluniquesubjs(p,7)}; % THIS IS THE LOCATION OF FormantSHIFTIHData
    cd(currentfile);
    load('expt.mat');
    if 7~=exist('wave_files', 'dir')
        mkdir('wave_files');
    end
    phasenames = expt.allPhases';
    for phase = 1:length(phasenames)
        cd(phasenames{phase,1});
        repfolders = dir('rep*');
        for rep = 1:length(repfolders)
            cd(['rep' num2str(rep)]);
            trialmats = dir('trial*.mat');
            for trial = 1:length(trialmats)
                % We are tracking the run, the phase, the rep and the trial.
                % we should also track utterance number in a run. We need to do this
                % manually as utterance will not have its own loop.
                filenum = filenum + 1;
                utterance = utterance +1;
                load(trialmats(trial,1).name); %This loads a variable named "data"!!!
                FormantSHIFTIHData{filenum+1,1} = filenum; %filenum is Column 1
                FormantSHIFTIHData{filenum+1,2} = 'formant_IH_shift'; % run is Column 2
                FormantSHIFTIHData{filenum+1,3} = files{fulluniquesubjs(p,7)}; % in what block did the FormantSHIFTIH block happen?
                FormantSHIFTIHData{filenum+1,4} = phasenames{phase,1}; % name of phase is in Column 3
                FormantSHIFTIHData{filenum+1,5} = phase; %position of the phase.
                FormantSHIFTIHData{filenum+1,6} = rep; %Rep of the phase is Column 5
                FormantSHIFTIHData{filenum+1,7} = trial; % Trial number for the given rep is Column 6
                
                
                C = strsplit(data.subject(1,1).name, '_');
                B = regexp(C(1,1),'\d*','Match');
                subject = char(B{1,1}(:)); clear C B
                
                FormantSHIFTIHData{filenum+1,8} = subject; % subject number is Column 7
                FormantSHIFTIHData{filenum+1,9} = data.params.name; % what they said is Column 8
                
                
                Y = char((data.fmts(:,1)>0)' + '0'); %// convert to string of zeros and ones
                [s, e] = regexp(Y, '1+', 'start', 'end'); %// find starts and ends of runs
                [~, w] = max(e-s); %// w is the index of the longest run
                frame_start = s(w); %// index of start of longest subsequence
                frame_end = e(w); %// index of end of longest subsequence
                
                
                %frame_start = find(data.fmts(:,1), 1, 'first');
                
                
                
                
                
                %frame_end = find(data.fmts(:,1), 1, 'last');
                
                
                
                trimmedf1_fmts = data.fmts(frame_start:frame_end,1);
                trimmedf2_fmts = data.fmts(frame_start:frame_end,2);
                trimmedf3_fmts = data.fmts(frame_start:frame_end,3);
                trimmedf4_fmts = data.fmts(frame_start:frame_end,4);
                
                if isempty((find(data.sfmts(:,1), 1,'first'))) == 0
                    fshifthappened = 1;
                    trimmedsf1_fmts = data.sfmts(frame_start:frame_end,1);
                    trimmedsf2_fmts = data.sfmts(frame_start:frame_end,2);
                else
                    fshifthappened = 0;
                    trimmedsf1_fmts = 'na';
                    trimmedsf2_fmts = 'na';
                end
                
                if isempty((find(data.pitchShiftRatio(:,1)<1, 1, 'first'))) == 0
                    pshifthappened = -1;
                    trimmedspitchratio = data.pitchShiftRatio(frame_start:frame_end,1);
                elseif isempty((find(data.pitchShiftRatio(:,1)>1, 1, 'first'))) == 0
                    pshifthappened = 1;
                    trimmedspitchratio = data.pitchShiftRatio(frame_start:frame_end,1);
                else
                    pshifthappened = 0;
                    trimmedspitchratio = 'na';
                end
                
                FormantSHIFTIHData{filenum+1,10} = mean(trimmedf1_fmts); %?Avg_F1'
                FormantSHIFTIHData{filenum+1,11} = std(trimmedf1_fmts); %'Stdev_F1'
                FormantSHIFTIHData{filenum+1,12} = min(trimmedf1_fmts); %'Min_F1?
                FormantSHIFTIHData{filenum+1,13} = max(trimmedf1_fmts); %'Max_F1'
                FormantSHIFTIHData{filenum+1,14} = median(trimmedf1_fmts); %?Median_F1'
                FormantSHIFTIHData{filenum+1,15} = mean(trimmedf2_fmts); %'Avg_F2'
                FormantSHIFTIHData{filenum+1,16} = std(trimmedf2_fmts); %'Stdev_F2'
                FormantSHIFTIHData{filenum+1,17} = min(trimmedf2_fmts); %'Min_F2?
                FormantSHIFTIHData{filenum+1,18} = max(trimmedf2_fmts); %'Max_F2?
                FormantSHIFTIHData{filenum+1,19} = median(trimmedf2_fmts); %?Median_F2?
                FormantSHIFTIHData{filenum+1,20} = mean(trimmedf3_fmts); %'Avg_F3'
                FormantSHIFTIHData{filenum+1,21} = std(trimmedf3_fmts); %'Stdev_F3?
                FormantSHIFTIHData{filenum+1,22} = min(trimmedf3_fmts); %'Min_F3?
                FormantSHIFTIHData{filenum+1,23} = max(trimmedf3_fmts); %'Max_F3?
                FormantSHIFTIHData{filenum+1,24} = median(trimmedf3_fmts); %?Median_F3?
                FormantSHIFTIHData{filenum+1,25} = mean(trimmedf4_fmts); %'Avg_F4'
                FormantSHIFTIHData{filenum+1,26} = std(trimmedf4_fmts); %'Stdev_F4'
                FormantSHIFTIHData{filenum+1,27} = min(trimmedf4_fmts); %'Min_F4?
                FormantSHIFTIHData{filenum+1,28} = max(trimmedf4_fmts); %'Max_F4?
                FormantSHIFTIHData{filenum+1,29} = median(trimmedf4_fmts); %?Median_F4?
                FormantSHIFTIHData{filenum+1,30} = mean(data.f0s); %'F0'
                FormantSHIFTIHData{filenum+1,31} = std(data.f0s); %'Stdev_F0'
                FormantSHIFTIHData{filenum+1,32} = min(data.f0s); %'Min_F0?
                FormantSHIFTIHData{filenum+1,33} = max(data.f0s); %'Max_F0?
                FormantSHIFTIHData{filenum+1,34} = median(data.f0s); %?Median_F0?
                FormantSHIFTIHData{filenum+1,35} = data.params.sRate;%?sample_rate';
                FormantSHIFTIHData{filenum+1,36} = length(data.signalIn); % 'tt_length_samples';
                FormantSHIFTIHData{filenum+1,37} = (length(trimmedf1_fmts)*data.params.frameLen); %'an_length_samples?;
                FormantSHIFTIHData{filenum+1,38} = (length(trimmedf1_fmts)*data.params.frameLen)/data.params.sRate; %?an_length_s?;
                FormantSHIFTIHData{filenum+1,39} = data.vowelLevel; %?dB of utterance?;
                
                
                if fshifthappened == 1
                    FormantSHIFTIHData{filenum+1,40} = mean(trimmedsf1_fmts); %'S_Avg_F1';
                    FormantSHIFTIHData{filenum+1,41} = std(trimmedsf1_fmts); %'S_standarddev_F1';
                    FormantSHIFTIHData{filenum+1,42} = min(trimmedsf1_fmts); %'S_min_F1';
                    FormantSHIFTIHData{filenum+1,43} = max(trimmedsf1_fmts); %'S_max_F1';
                    FormantSHIFTIHData{filenum+1,44} = median(trimmedsf1_fmts); %'S_median_F1';
                    FormantSHIFTIHData{filenum+1,45} = mean(trimmedsf2_fmts); %'S_Avg_F1';
                    FormantSHIFTIHData{filenum+1,46} = std(trimmedsf2_fmts); %'S_std_F1';
                    FormantSHIFTIHData{filenum+1,47} = min(trimmedsf2_fmts); %'S_min_F1';
                    FormantSHIFTIHData{filenum+1,48} = max(trimmedsf2_fmts); %'S_max_F1';
                    FormantSHIFTIHData{filenum+1,49} = median(trimmedsf2_fmts); %'S_median_F1';
                    FormantSHIFTIHData{1,50} = 'na'; %'Average_trimmedpitchratio';
                    FormantSHIFTIHData{1,51} = 'na'; % % sample legnth of trimmed pitch in secs;
                else
                    FormantSHIFTIHData{filenum+1,40} = 'na'; %'S_Avg_F1';
                    FormantSHIFTIHData{filenum+1,41} = 'na'; %'S_standarddev_F1';
                    FormantSHIFTIHData{filenum+1,42} = 'na'; %'S_min_F1';
                    FormantSHIFTIHData{filenum+1,43} = 'na'; %'S_max_F1';
                    FormantSHIFTIHData{filenum+1,44} = 'na'; %'S_median_F1';
                    FormantSHIFTIHData{filenum+1,45} = 'na'; %'S_Avg_F1';
                    FormantSHIFTIHData{filenum+1,46} = 'na'; %'S_std_F1';
                    FormantSHIFTIHData{filenum+1,47} = 'na'; %'S_min_F1';
                    FormantSHIFTIHData{filenum+1,48} = 'na'; %'S_max_F1';
                    FormantSHIFTIHData{filenum+1,49} = 'na'; %'S_median_F1';
                    FormantSHIFTIHData{filenum+1,50} = mean(trimmedspitchratio); %'Average_trimmedpitchratio';
                    FormantSHIFTIHData{filenum+1,51} = (length(trimmedspitchratio)*data.params.frameLen)/data.params.sr; % sample legnth of trimmed pitch in secs
                end
                
                % write all the formantShiftIH wav files
                Uniq_ID_wav_I = [currentdir,'/', currentfile, '/wave_files/S', subject, '_FIH', '_P', num2str(phase), '_R', num2str(rep), '_T', num2str(trial), '_F', num2str(filenum), '_U', num2str(utterance), '_', data.params.name,'_I_B', files{fulluniquesubjs(p,7)}, '.wav'];
                Uniq_ID_wav_O = [currentdir,'/', currentfile, '/wave_files/S', subject, '_FIH', '_P', num2str(phase), '_R', num2str(rep), '_T', num2str(trial), '_F', num2str(filenum), '_U', num2str(utterance), '_', data.params.name,'_O_B', files{fulluniquesubjs(p,7)}, '.wav'];
                
                if strcmp(makesoundfiles,'Y') && exist(Uniq_ID_wav_I, 'file') == 0
                    if max(abs(data.signalIn)) > 1
                        audioin = data.signalIn/max(abs(data.signalIn));
                        FormantSHIFTIHData{filenum+1,52} = 'clippedbutfixed';
                    else
                        audioin = data.signalIn;
                        FormantSHIFTIHData{filenum+1,52} = 'ok';
                    end
                    audiowrite(Uniq_ID_wav_I,audioin,data.params.sRate)
                    
                    if max(abs(data.signalOut)) > 1
                        audioout = data.signalOut/max(abs(data.signalOut));
                        FormantSHIFTIHData{filenum+1,53} = 'clippedbutfixed';
                    else
                        audioout = data.signalOut;
                        FormantSHIFTIHData{filenum+1,53} = 'ok';
                    end
                    audiowrite(Uniq_ID_wav_O,audioout,data.params.sRate)
                end
                
                FormantSHIFTIHData{filenum+1,54} = utterance; %subj specific utterance;
            end
            clear data trial trialmats rep frame_start frame_end trimmedf1_fmts trimmedf2_fmts trimmedf3_fmts trimmedf4_fmts Uniq_ID_wav_I Uniq_ID_wav_O audioin audioout
            cd('../'); % After all trials are read, go back to get another rep
        end
        clear repfolders rep
        cd('../'); % After all reps are read, go back to get another phase
    end
    cd('../'); % After all phases are read, go back to get another run
    clear phase phasenames currentfile
    waitbar(p/length(fulluniquesubjs), h, ['processing Formant Shift IH data for subject' num2str(subject)])
    clear subject
    utterance = 0;
end

clear expt filenum
waitbar(1, h, 'DONE!!');
close(h);
cd(currentdir);
save('FormantSHIFTIHData','FormantSHIFTIHData')
% fileID = fopen('FormantSHIFTIHData.csv','w');
% formatSpec1 = '%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s\n';
% formatSpec2 = '%d, %s, %s, %s, %d, %d, %d, %s, %s, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %.6f, %d, %d, %d, %.6f, %.6f, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %.6f, %d, %s, %s, %d\n';
% [nrows,~] = size(FormantSHIFTIHData);
% 
% for row = 1:1
%     fprintf(fileID,formatSpec1,FormantSHIFTIHData{row,:});
% end
% for row = 2:nrows
%     fprintf(fileID,formatSpec2,FormantSHIFTIHData{row,:});
% end
% fclose(fileID);
clear formantSpec1 formantSpec2 nrows row utterance h fileID