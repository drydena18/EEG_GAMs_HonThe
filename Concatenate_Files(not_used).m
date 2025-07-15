% Define the specific tag to look for in the file names ('ICArem')
fileTag = 'ICArem';

% Define the main directory where the subfolders are located
mainDir = '/Users/drydenarseneau/GAMs_Thesis/HBN_Data/EEG_GAMs_Data/Analyzed';
srDIR = '/Users/drydenarseneau/GAMs_Thesis/HBN_Data/EEG_GAMs_Data/Merged_Data';

if ~isfolder(mainDir)
    error(['Main directory "' mainDir '" does not exist.']);
else
    disp(['Main directory found "' mainDir]);
end

% List all subfolders in the main directory
subFolders = dir(mainDir);
subFolders = subFolders([subFolders.isdir]);  % Get only directories
subFolders = subFolders(~ismember({subFolders.name}, {'.', '..'}));  % Remove '.' and '..'

disp('Subfolders found in mainDir:');
disp({subFolders.name});

if ~exist('pop_loadset', 'file')
    eeglab('nogui');
end

samplingRateInfo = {};

% Initialize an empty cell array to store EEG datasets
EEG_sets = {};

% Loop through each subfolder
for i = 1:length(subFolders)
    % Define the current subfolder path
    folderName = subFolders(i).name;
    subFolderPath = fullfile(mainDir, subFolders(i).name);

    disp(['Searching in folder: ' subFolderPath]);
    
    % List all .set files in the current subfolder that contain the tag 'IntRej'
    setFiles = dir(fullfile(subFolderPath,['*' fileTag '*.set']));

    if isempty(setFiles)
        disp(['No files found with the tag "' fileTag '"in folder: ' subFolderPath]);
    else
        disp(['Found files with the tag: "' fileTag '"in folder: ' subFolderPath]);
    end
    
    % Loop through each matching .set file and load the dataset
    for j = 1:length(setFiles)
        % Define the full path to the .set file
        setFilePath = fullfile(subFolderPath, setFiles(j).name);
        
        % Load the dataset into EEGLAB
        EEG = pop_loadset('filename', setFiles(j).name, 'filepath', subFolderPath);
        
        % Store the dataset in the cell array
        EEG_sets{end+1} = EEG;

        samplingRate = EEG.srate;
        samplingRateInfo{end+1, 1} = folderName;
        samplingRateInfo{end, 2} = setFiles(j).name;
        samplingRateInfo{end, 3} = samplingRate;
    end
end

disp('Folder Name | File Name | Sampling Rate (Hz)');
disp(samplingRateInfo);

srPATH = '/Users/drydenarseneau/GAMs_Thesis/HBN_Data/EEG_GAMs_Data/Merged_Data/sampling_rates_info.csv';
writecell(samplingRateInfo, srPATH);
disp(['File saved to: ' srPATH]);
%disp(['Sampling rates information saved to: ' fullfile(srDIR, 'sampling_rates_info.csv')]);

% Check if any datasets were loaded
if isempty(EEG_sets)
    error('No datasets found with the tag ''ICArem''.');
end

samplingRates = [];

for k = 1:length(EEG_sets)
    sr = EEG_sets{k}.srate;
    samplingRates(end + 1) = sr
    disp(['Sampling rates of dataset ' num2str(k) ': ' num2str(sr) ' Hz']);
end

[counts, edges] = histcounts(samplingRates);
[~, idx] = max(counts);
commonSR = edges(idx);
disp(['Most common sampling rate: ' num2str(commonSR) ' Hz.']);

%if numel(unique(samplingRates)) > 1
    %error('Datasets have different sampling rates. Cannot merge.');
%else
  %  disp('All datasets have the same sampling rate.');
%end

%for k = 1:length(EEG_sets)
 %   if EEG_sets{k}.srate ~= commonSR
  %      EEG_sets{k} = pop_resample(EEG_sets{k}, commonSR);
   %     disp(['Resampled dataset ' num2str(k) ' from ' num2str(samplingRates(k)) ' Hz to ' num2str(commonSR) ' Hz.']);
    %end
%end

% Concatenate datasets if needed (e.g., for group analysis)
if length(EEG_sets) > 1
    EEG = EEG_sets{1};  % Start with the first dataset
    % Loop to merge the remaining datasets
    for i = 2:length(EEG_sets)
        EEG = pop_mergeset(EEG, EEG_sets{i});
    end
else
    % If only one dataset is found, use it directly
    EEG = EEG_sets{1};
end

% Proceed with further analysis on the merged or individual datasets
% Plot the data
eegplot(EEG.data, 'srate', EEG.srate, 'title', ['EEG Data for tag: ' fileTag]);

% Save the merged dataset
if isempty(EEG_sets)
    error('No datasets found with the tag "ICArem".')
end

disp(['Class of first dataset: ', class(EEG_sets{1})]);

disp(['Number of datsets to merge: ' num2str(length(EEG_sets))]);

%EEG = pop_mergeset(EEG_sets{:});

outputDir = uigetdir(pwd, 'Select Output Directory');

if isequal(outputDir, 0)
    error('No output directory selected. Marging process aborted.');
end

outputFileName = ['merged_dataset_' fileTag '.set'];

pop_saveset(EEG, 'filename', outputFileName, 'filepath', outputDir);
disp(['Merged dataset saved to: ' fullfile(outputDir, outputFileName)]);
