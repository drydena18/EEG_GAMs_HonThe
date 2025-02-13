function PLI_Movies_HBN

pth = '/Users/bobbystojanoski/Library/CloudStorage/OneDrive-OntarioTechUniversity/Ontario Tech University/Experiments/EEG_GAMs/Prepocessed_data/';
% cd(pth)
fnames = dir(pth);
fnames = fnames(4:end-1)
missingdata = [];
all_pli = []; %ones(64,64);
org_all_pli= [];
curr_pli_matrix= zeros(90, 90, length(fnames));

%% set up channel structure
chanexcl = [1,8,14,17,21,25,32,38,43,44,48,49,56,57,63,64,68,69,73,74,81,82,88,89,94,95,99,100,107,113,114,119,120,121,125,126,127,128,129];
allchan = 1:128;
incchn = setdiff(allchan,chanexcl);

Occipital_R_ind = [83,76,77,84,90,85,91,96];
Occipital_C_ind = [72,75];
Occipital_L_ind = [70, 71, 67, 66, 65, 60, 59, 58];

Parietal_R_ind = [78,79,80,87,86,92,93,104,98,97,101,102,103,109,108,115];
Parietal_C_ind = [62, 55];
Parietal_L_ind = [61,54,31,37,53,52,42,36,47,51,50,46,41,40,45,39];

Posteriorf_R_ind = [106,105,112,5,118,111,110,117,124,116];
Posteriorf_C_ind = 6;
Posteriorf_L_ind = [7,30,13,12,20,29,35,28,24,34];

Anteriorf_R_ind = [4,10,9,3,123,2,122];
Anteriorf_C_ind = [11,16,15];
Anteriorf_L_ind = [19,18,22,23,27,26,33];

chanorder = [Occipital_R_ind,Occipital_C_ind,Occipital_L_ind, ...
    Parietal_R_ind,Parietal_C_ind,Parietal_L_ind, ...
    Posteriorf_R_ind,Posteriorf_C_ind,Posteriorf_L_ind,...
    Anteriorf_R_ind,Anteriorf_C_ind,Anteriorf_L_ind];

for i =  1:length(fnames)
    try
        pth_pli = '/Users/bobbystojanoski/Library/CloudStorage/OneDrive-OntarioTechUniversity/Ontario Tech University/Experiments/EEG_GAMs/Prepocessed_data/wPLI/xhbn_pli*'
        plidata = dir(pth_pli);
        load(sprintf('%s%s', pth_pli(1:end-4),plidata(i).name));

    catch
        i
        EEG = pop_loadset(sprintf('%s%s/%s_reref_bpf_notf_initrej_ICA_ICArem.set', pth,fnames(i).name,fnames(i).name));
        EEG.data = EEG.data(chanorder,:);
        EEG.nbchan = size(incchn,2);
        
        %% PLI
        % Number of channels and epochs
        num_channels = EEG.nbchan;
        num_epochs = EEG.trials;

        % Initialize PLI matrix
        pli_matrix = zeros(num_channels, num_channels);

        % Extract data for the current epoch (channels x time points)
        if isempty(EEG.data)
            missingdata = [missingdata;i];
        else
            currdata = EEG.data(:, :, num_epochs);


            % Calculate the phase of each channel using Hilbert transform
            phases = angle(hilbert(currdata')');

            % Compute PLI for each pair of channels
            for ch1 = 1:num_channels
                for ch2 = ch1+1:num_channels  % Only compute upper triangle of the matrix
                    % Compute phase differences
                    phase_diff = phases(ch1, :) - phases(ch2, :);

                    % Compute PLI
                    pli = abs(mean(sign(sin(phase_diff))));

                    % Store PLI in the matrix (symmetric matrix)
                    pli_matrix(ch1, ch2) = pli;
                    pli_matrix(ch2, ch1) = pli;  % Mirror the value
                end
            end

            curr_pli_matrix(:, :, i) = pli_matrix;
        end

    end
end
hbn_pli_matrix = curr_pli_matrix;
save(sprintf('/Users/bobbystojanoski/Library/CloudStorage/OneDrive-OntarioTechUniversity/Ontario Tech University/Experiments/EEG_GAMs/Prepocessed_data/wPLI/hbn_pli_matrix.mat',i), 'hbn_pli_matrix')

hbn_pli_matrix_chnord = hbn_pli_matrix(chanorder,chanorder,:);
