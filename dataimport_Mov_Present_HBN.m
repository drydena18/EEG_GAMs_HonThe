function dataimport_Mov_Present_HBN(basename, varargin)

addpath(genpath('/Users/drydenarseneau/GAMs_Thesis/matlab_scripts'))
addpath(genpath('/Applications/toolboxes/eeglab2024.0'))

filepath  = '/Users/drydenarseneau/GAMs_Thesis/HBN_Data/EEG_GAMs_Data/';

%create Analysis folder
analysispath = sprintf('%s%s',filepath,'Analyzed/');

% %List all data files
% fn = dir(sprintf('%sNDA*', filepath));

%Output directory depends on whether patient data analyzed
outpath = sprintf('%s%s%s', analysispath,basename);
if ~exist(outpath, 'dir')
    mkdir(outpath);
end



%analysis parameters
dofakeICA = 0;
doICA = 1;
doICA2 = 0;
detrend = 0;
baselinecorr = 1;
regressEOG = 0;
% chanexcl = [1,8,14,17,21,25,32,38,43,44,48,49,56,63,64,68,69,73,74,81,82,88,89,94,95,99,107,113,114,119,120,121,125,126,127,128];


try
    selbasename = dir(sprintf('%sAnalyzed/%s', filepath, basename));
    selbasename = selbasename(end)

    EEG = pop_loadset(sprintf('%s%s%s',outpath,'/',selbasename.name));
catch
        datdir = dir(sprintf('%s%s/EEG/raw/mat_format/Video4.mat', filepath, basename));
    if isempty(datdir)
        datdir = dir(sprintf('%s%s/EEG/raw/mat_format/Video-TP.mat', filepath, basename));
    end
    
    load(sprintf('%s/%s',datdir.folder,datdir.name));
    load('/Users/drydenarseneau/GAMs_Thesis/HBN_Data/EEG_GAMs_Data/sampleEEG.mat')
    %EEG = pop_select(EEG,'nochannel',[129]);
    EEG.chanlocs = sampleEEG.chanlocs;
    EEG.chaninfo = sampleEEG.chaninfo;
    EEG.nbchans = sampleEEG.nbchan
    EEG.nbchan = sampleEEG.nbchan
    EEG.data(129,:) = [];
    % %     if ~exist(outpath, 'dir')
    % %         mkdir(outpath);
    % %     end
    %
    %     sprintf('This subject has not been analyzed. Begin Analysis')
    %
    %     if isempty(filenames)
    %         error('No files found to import!\n');
    %     end
    %
    %     mfffiles = filenames(logical(cell2mat({filenames.isdir})));
    %     if length(mfffiles) > 1
    %         error('Expected 1 MFF recording file. Found %d.\n',length(mfffiles));
    %     else
    %         filename = mfffiles.name;
    %     end
    %
    %     fprintf('\nProcessing %s.\n\n', filename);
    %     EEG = pop_readegimff(sprintf('%s%s%s%s', filepath,basename,datpth,basename));
    %
    %     EEG = eeg_checkset(EEG);
    %     EEG.filepath= filepath;
    %     EEG.filename = filename;
end

%%
% reference data
try
    EEG.reref ~=1;
catch
    EEG.filename = sprintf('%s_%s.set',basename,'reref')
    EEG = rereference_Mov(EEG,1)
    %     EEG = pop_reref( EEG, [] ); %,'keepref','on'
    EEG.reref =1;
    fprintf('Saving %s in %s\n', EEG.filename,EEG.filepath);
    pop_saveset(EEG,'filename', EEG.filename, 'filepath', outpath);
    com = sprintf('Reference Data');
    EEG = eeg_hist(EEG, com);
    pop_saveh(EEG.history, 'EEGHistory.txt', outpath);
    
end

%% filter
try
    EEG.filter ~= 1;
catch
    bandpass = [0.5 80];
    EEG.filename = sprintf('%s_%s.set',EEG.filename(1:end-4),'bpf')
    
    fprintf('Low-pass filtering below %dHz...\n',bandpass(2));
    EEG = pop_eegfilt(EEG, 0, bandpass(2), [], [0], 0, 0, 'fir1',0);
    
    fprintf('High-pass filtering above %dHz...\n',bandpass(1));
    EEG = pop_eegfilt(EEG, bandpass(1), 0, [], [0], 0, 0, 'fir1',0);
    
    EEG = eeg_checkset( EEG );
    EEG.filter = 1;
    fprintf('Saving %s%s.\n', EEG.filepath, EEG.filename);
    pop_saveset(EEG,'filename', EEG.filename, 'filepath', outpath);
    
    com = sprintf('bandpass filter at %.1f-%2.1f', bandpass(1), bandpass(2));
    EEG = eeg_hist(EEG, com);
    pop_saveh(EEG.history, 'EEGHistory.txt', outpath);
    
    if bandpass(2) > 61
        EEG.filename = sprintf('%s_%s.set',EEG.filename(1:end-4),'notf')
        NotchF = 60;
        fprintf('Notch filtering at %dHz...\n',NotchF);
        %         EEG  = pop_basicfilter( EEG,  1:EEG.nbchan ,'Filter','PMnotch','Design','notch','Cutoff' ,NotchF,'Order' ,[180],'RemoveDC','off','Boundary',[]); %ERPLAB version 3
        %         EEG  = pop_basicfilter( EEG,  1:EEG.nbchan , 'Cutoff',  60, 'Design', 'notch', 'Filter', 'PMnotch', 'Order',  180 );
        %         EEG = pop_basicfilter( EEG, 1:14, 50, 50, 2,'notch', 0); %ERPLAB version 2
        
        %         EEG = pop_basicfilter( EEG,  1:EEG.nbchan, 60, 60, 180, 'notch', 0, [] ); % On work desktop
        %         EEG  = pop_basicfilter( EEG,  1:EEG.nbchan , 'Cutoff',  60, 'Design', 'notch', 'Filter', 'PMnotch', 'Order',  180 ); % on lenovo and home desktop
        EEG = pop_eegfiltnew(EEG, 'locutoff',55,'hicutoff',65,'revfilt',1,'plotfreqz',1);
        %EEG  = pop_basicfilter( EEG,  1:EEG.nbchan , 'Cutoff',  60, 'Design', 'notch', 'Filter', 'PMnotch', 'Order',  180 ); % On macbook
        EEG.Nfilter = 1;
        EEG = eeg_checkset( EEG );
        fprintf('Saving %s%s.\n', EEG.filepath, EEG.filename);
        pop_saveset(EEG,'filename', EEG.filename, 'filepath', outpath);
        
        com = sprintf('notch filter at %d', NotchF);
        EEG = eeg_hist(EEG, com);
        pop_saveh(EEG.history, 'EEGHistory.txt', outpath);
        %         evalin('base','eeglab');
        %         assignin('base','EEG',EEG);
        %         evalin('base','[ALLEEG EEG index] = eeg_store(ALLEEG,EEG,0);');
        %         evalin('base','eeglab redraw');
        %         EEG = eeg_checkset( EEG );
        pop_eegplot(EEG,1,1,1)
%         % EEG = pop_resample( EEG, 250);
%         if istrue(size({EEG.chanlocs.labels},2) == 130)
%             EEG = pop_select(EEG,'nochannel',[130]);
%         else
%         end
%         
%         EEG = pop_resample( EEG, 250);
        
    else
        fprintf('No need to notch filter')
    end
    
end

%%

%Remove Bad channels - just do intepolation
try
    EEG.initrej ~=1;
catch
    iter = 1;
    EEG.filename = sprintf('%s_%s.set',EEG.filename(1:end-4),'initrej')
    pop_eegplot(EEG,1,1,1)
    
    % Now manually reject/interpolate channels
    %Interpolate channels
    varchan = squeeze(var(EEG.data,[],2));
    figure(30);bar(varchan);
    meanvarchan = mean(varchan);
    stdvarchan = std(varchan);
    threshdelchan = meanvarchan+(stdvarchan*2)
    delchan = find(varchan >=threshdelchan)
    EEG.chanInterp = delchan;
    selchan = input('which channel do you want to interpolate (make sure to add E in front of each number)?: ', 's');
    selchan = regexp(selchan, '(\S+)', 'tokens'); selchan = cellfun(@(x) x{1}, selchan, 'UniformOutput', 0)
    chnloc = find(ismember({EEG.chanlocs.labels},selchan)); %~cellfun(@isempty,strcmp({EEG.chanlocs.labels},selchan)); chnloc = find(chnloc ==1);
    EEG = eeg_interp(EEG, chnloc);
    interpchan{iter} = chnloc;
    ManIns = input('Are you finished manually inspecting your data? Press 1 to keep interpolating; Press 2 if you are finished ','s'); ManIns = str2num(ManIns);
    while ManIns == 1
        iter = iter+1;
        fprintf('Continue analysis')
        varchan = squeeze(var(EEG.data,[],2));
        figure(30);bar(varchan);
        meanvarchan = mean(varchan);
        stdvarchan = std(varchan);
        threshdelchan = meanvarchan+(stdvarchan*2)
        delchan = find(varchan >=threshdelchan)
        EEG.chanInterp = delchan;
        selchan = input('which channel do you want to interpolate(make sure to add E in front of each number)?: ', 's');
        if isempty(selchan)
            sprintf('No channels selected for interpolation')
        else
            selchan = regexp(selchan, '(\S+)', 'tokens'); selchan = cellfun(@(x) x{1}, selchan, 'UniformOutput', 0)
            chnloc = find(ismember({EEG.chanlocs.labels},selchan)); %~cellfun(@isempty,strcmp({EEG.chanlocs.labels},selchan)); chnloc = find(chnloc ==1);
            EEG = eeg_interp(EEG, chnloc);
            interpchan = [interpchan; chnloc];
        end
        ManIns = input('Are you finished manually inspecting your data? Press 1 to keep interpolating; Press 2 if you are finished ','s'); ManIns = str2num(ManIns)
    end
    
    %----------------------------------------------------------------------
    %Delete channels not available on the infant cap
    % EEG = pop_select(EEG,'nochannel',[125,126,127,128]);
    %     %Delete channels
    %     selchan = input('which channel(s) do you want to remove?: ', 's');
    %     selchan = regexp(selchan, '(\S+)', 'tokens'); selchan = cellfun(@(x) x{1}, selchan, 'UniformOutput', 0)
    %     chnloc = find(ismember({EEG.chanlocs.labels},selchan));
    %     EEG = pop_select(EEG,'nochannel',chnloc);
    %----------------------------------------------------------------------
    
    
    %Copy cleaned fake data to real data
    %     EEG.data = FEEG.data;
    
    %Manually inspect data before preprocessing
    %     evalin('base','eeglab');
    %     assignin('base','EEG',EEG);
    %     evalin('base','[ALLEEG EEG index] = eeg_store(ALLEEG,EEG,0);');
    %     evalin('base','eeglab redraw');
    %     EEG = eeg_checkset( EEG );
    %     pop_eegplot( EEG, 1, 0, 1);
    
    EEG.initrej = 1;
    fprintf('Saving %s%s.\n', EEG.filepath, EEG.filename);
    pop_saveset(EEG,'filename', EEG.filename, 'filepath', outpath);
    com = sprintf('Interpolated bad channels: first pass inspection');
    EEG = eeg_hist(EEG, com);
    pop_saveh(EEG.history, 'EEGHistory.txt', outpath);
end



%%
%Instead of doing ICA, run regression to remove ocular artifacts. Use AAR
%method: %(https://github.com/germangh/eeglab_plugin_aar OR http://www.germangh.com/eeglab_plugin_aar/)
if  regressEOG ==1
    %     if strfind(char(EEG.filename),'EOG') == 1
    fnEOG = sprintf('%s_%s',basename(1:21),'EOG');
    %     else
    %         fnEOG = sprintf('%s',basename(1:21) );
    %     end
    
    [Tot_LEOG Tot_REOG LEOG REOG meanZscoreEOG]=dataimport_Mov_EOG(fnEOG);
    EEG1 = EEG; EEG1.data = EEG.data(:,:,1);
    EEG2 = EEG; EEG2.data = EEG.data(:,:,2);
    EEG1.data(127,:) = LEOG{1};
    EEG1.data(126,:) = REOG{1};
    EEG2.data(127,:) = LEOG{2};
    EEG2.data(126,:) = REOG{2};
    
    %     EEG1 = pop_crls_regression(EEG1, [126 127], 3, 0.9999, 0.01)
    %     EEG2 = pop_crls_regression(EEG2, [126 127], 3, 0.9999, 0.01)
    EEG = pop_lms_regression( EEG, [25   8], 3, 1e-06);
    EEG.filename = sprintf('%s_%s.set',EEG.filename(1:end-4),'regrem')
    fprintf('Saving %s in %s\n', EEG.filename,EEG.filepath);
    pop_saveset(EEG,'filename', EEG.filename, 'filepath', outpath);
else
    fprintf('Regress EOG another time')
    
end

%% real epoching

% ftrig = find(ismember({EEG.event.type},'20  '));
% EEG.event(ftrig(1)).type = '201  ';
% struct2=renamefields(EEG.event,'sample','latency');
% EEG.event =struct2;
% eventlist = {'201  '}; %10 = movie1; 11 = movie2
% try
%     EEG.createepoch ~=1
% catch
%     EEG.filename = sprintf('%s_%s.set',EEG.filename(1:end-4),'createepoch');
%     EEG.setname = sprintf('%s_%s.set',EEG.filename(1:end-4),'createepoch');
%     
%     fprintf('Epoching and baselining.\n');
%     allevents = {EEG.event.type};
%     selectevents = [];
%     condtypes = cell(1,length(EEG.event));
%     for e = 1:length(eventlist)
%         foundtrials = ismember(allevents,eventlist{e})% strfind(allevents,eventlist{e});
%         %         for tr = 1:length(foundtrials)
%         %             foundtrials(tr) = num2cell(isempty(foundtrials{tr}));
%         %         end
%         %         foundtrials = cell2mat(foundtrials);
%         %         foundtrials = ~foundtrials;
%         condtypes(foundtrials) = eventlist(e);
%         selectevents = [selectevents find(foundtrials)];
%     end
%     selectevents = sort(selectevents);
%     condtypes = condtypes(selectevents);
%     
%     epochlims = [0 300];
%     EEG = pop_epoch(EEG,{},epochlims,'eventindices',selectevents);
%     EEG = eeg_checkset(EEG);
%     EEG.createepoch =1;
%     fprintf('Saving %s%s.\n', EEG.filepath, EEG.filename);
%     pop_saveset(EEG,'filename', EEG.filename, 'filepath', outpath);
%     
% end

%%
%Might be easiest to run these steps on their own
% %Run ICA
% %First level ICA on each conditions separately
% EEG = dataimport_CondICA(basename)
%
% %Run first level ICA - remove eyeblinks across testing session
% try EEG.ICArem ~= 1;
% catch
%     [EEG] = dataimport_1stICA(basename)
%
% end
%
% %Load ICA'd and filtered data
% basenameplus = '_reref_bpf_notf_initrej_createepoch_ICA_allrem_2bpf';
% EEG = pop_loadset(sprintf('%s%s%s%s.set',outpath,'/',basename(1:21),basenameplus));


%% second run of ICA to find cognitve components
% if doICA2
%     try
%         EEG.doICA2 ~=1
%     catch
%         EEG1 = pop_loadset(sprintf('%s%s%s.set',outpath,'\',basename(1:end-6))); %eventlist{1}
%         EEG1.filename = sprintf('%s_%s_%s.set',EEG1.filename(1:end-17),'ICA2',eventlist{1});
%         EEG1.setname = sprintf('%s',EEG1.filename); %these have the rej in the name because the next step is artifact rejection which saves the active data!
%         EEG1 = pop_runica(EEG1, 'extended',1,'interupt','on');
%
%         pop_topoplot(EEG1,0, [1:10], EEG.filename,[3 4] ,0,'electrodes','on');
%         fprintf('Saving %s%s.\n', EEG1.filepath, EEG1.filename);
%         pop_saveset(EEG1,'filename', EEG1.filename, 'filepath', outpath);
%
%         %==================================================================================================================
%         EEG2 = pop_loadset(sprintf('%s%s%s.set',outpath,'\',basename(1:end-6))); %eventlist{2}
%         EEG2.filename = sprintf('%s_%s_%s.set',EEG2.filename(1:end-17),'ICA2',eventlist{2});
%         EEG2.setname = sprintf('%s',EEG2.filename); %these have the rej in the name because the next step is artifact rejection which saves the active data!
%         EEG2 = pop_runica(EEG2, 'extended',1,'interupt','on');
%
%         pop_topoplot(EEG2,0, [1:10], EEG.filename,[3 4] ,0,'electrodes','on');
%         fprintf('Saving %s%s.\n', EEG2.filepath, EEG2.filename);
%         pop_saveset(EEG2,'filename', EEG2.filename, 'filepath', outpath);
%
%         %         MoreDel = input('Do you want to delete more ICs? Press 1 to continue Deleting. Press 2 to finish ', 's'); MoreDel = str2num(MoreDel);
%         %         if MoreDel
%         %         compDel = input('Delete components: ', 's');
%         %         compDel = str2num(compDel); %This only used if input which comps to remove
%         %         EEG2 = pop_subcomp( EEG2, [compDel], 0);
%         %         EEG2.filename = sprintf('%s%s.set',EEG.filename(1:end-4),'rem');
%         %         pop_saveset(EEG2,'filename', EEG2.filename, 'filepath', outpath);
%         %         else
%         %             sprintf('Finished')
%         %         end
%     end
% end

%% Run ICA - detect artifacts then remove them
%Load data before running ICA
%EEG = pop_loadset('filename',EEG.filename,'filepath',outpath);
if doICA
    try
        EEG.doICA ~=1
    catch
        EEG.filename = sprintf('%s_%s',EEG.filename(1:end-4),'ICA')
        EEG = pop_runica(EEG, 'extended',1,'interupt','on');
        
        fprintf('Saving %s%s.\n', EEG.filepath, EEG.filename);
        pop_saveset(EEG,'filename', EEG.filename, 'filepath', outpath);
        evalin('base','eeglab');
        assignin('base','EEG',EEG);
        evalin('base','[ALLEEG EEG index] = eeg_store(ALLEEG,EEG,0);');
%         evalin('base','eeglab redraw');
        
        pop_topoplot(EEG,0, [1:20], EEG.filename,[3 4] ,0,'electrodes','on');
        compDel = input('Delete components: ', 's');
        compDel = str2num(compDel);
        EEG = pop_subcomp( EEG, [compDel], 0);
        
        pop_saveh(EEG.history, 'EEGHistory.txt', outpath);
        EEG.setname = sprintf('%s',EEG.filename); %these have the rej in the name because the next step is artifact rejection which saves the active data!
        EEG.filename = sprintf('%s',EEG.filename);
        %         EEG.setname = sprintf('%s%s.set',EEG.filename,'_chn_fil_epoch_rej_ICA'); %these have the rej in the name because the next step is artifact rejection which saves the active data!
        %         EEG.filename = sprintf('%s%s.set',EEG.filename,'_chn_fil_epoch_rej_ICA');
        EEG.filepath = filepath;
        EEG.doICA = 1;
        
        com = sprintf('ICA');
        EEG = eeg_hist(EEG, com);
        pop_saveh(EEG.history, 'EEGHistory.txt', outpath);
        EEG.filename = sprintf('%s_%s',EEG.filename(1:end-4),'ICArem')
        pop_saveset(EEG,'filename', EEG.filename, 'filepath', outpath);
    end
    
else
    sprintf ('Continue witout running ICA') 
end


function era_limits=get_era_limits(era)
%function era_limits=get_era_limits(era)
%
% Returns the minimum and maximum value of an event-related
% activation/potential waveform (after rounding according to the order of
% magnitude of the ERA/ERP)
%
% Inputs:
% era - [vector] Event related activation or potential
%
% Output:
% era_limits - [min max] minimum and maximum value of an event-related
% activation/potential waveform (after rounding according to the order of
% magnitude of the ERA/ERP)

mn=min(era);
mx=max(era);
mn=orderofmag(mn)*round(mn/orderofmag(mn));
mx=orderofmag(mx)*round(mx/orderofmag(mx));
era_limits=[mn mx];

function ord=orderofmag(val)
%function ord=orderofmag(val)
%
% Returns the order of magnitude of the value of 'val' in multiples of 10
% (e.g., 10^-1, 10^0, 10^1, 10^2, etc ...)
% used for computing erpimage trial axis tick labels as an alternative for
% plotting sorting variable

val=abs(val);
if val>=1
    ord=1;
    val=floor(val/10);
    while val>=1,
        ord=ord*10;
        val=floor(val/10);
    end
    return;
else
    ord=1/10;
    val=val*10;
    while val<1,
        ord=ord/10;
        val=val*10;
    end
    return;
end

