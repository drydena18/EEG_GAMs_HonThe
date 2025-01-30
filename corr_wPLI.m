% Step 1: Set file path
onedrive_path = 'C:\Users\drydenarseneau\OneDrive\EEG_GAMs';

% Step 2: Get file name from User
file_name = input('Enter the participant file name (without extension): ', 's');
full_path = fullfile(onedrive_path, [file_name, '*.set]);

% Step 2.5: Identify the correct .set file
files = dir(full_path);
selected_file = '';
for i = 1:length(files)
  if contains(files(i).name, 'ICArem')
      selected_file = fullfile(files(i),folder, fles(i).name);
      break;
  end
end

if isempty(selected_file)
  error('No file with "ICArem" found for the given participant.');
end

% Step 3: Load the EEG data
EEG = pop_loadset('filename', selected_file);
data = EEG.data;

% Step 4: Define clusters
clusters = {...
  [], % Cluster 1
  []. % Cluster 2
  []. % Cluster 3
  []. % Cluster 4
  []. % Cluster 5
  []. % Cluster 6
  []. % Cluster 7
  []  % Cluster 8
};

% Step 5: Compute correlation matrix
cor_file = fullfile(onedrive_path, [file_name, '_cor.txt']);
fid = fopen(cor_file, 'w');
fprintf(fid, 'Correlation Matrix:\n');
fprintf(fid, '%.4f ', corr_matrix);
fclose(fid);
disp(['Correlation matrix saved to ', cor_file]);

% Step 6: Compute Weighted Phase Lag
wPLI = zeros(128, 8);
for i = 1:8
  for j = 1:128
    wPLI(j, i) = rand() %Replace w/ actual wPLI calc.
  end
end

% Save wPLI
wpl_file = fullfile(onedrive_path, [file_name, '_wpl.txt']);
fid = fopen(wpl_file, 'w'};
fprintf(fid, 'Weighted Phase Lag:\n');
fprintf(fid, '%.4f ', wPLI);
fclose(fid);
disp(['Weighted Phase Lag saved to ', wpl_file]);

% Step 7: Compute Mean correlation across clusters and single R-value
mean_corr = mean(corr_matrix, 'all');
mean_wPLI = mean(wPLI, 'all');
final_R_value = (mean_corr + mean_wPLI) / 2;

% Step 8: Save results
output_file = fullfile(onedrive_path, [file_name, '_results.txt']);
fid = fopen(output_file, 'w');
fprintf(fid, 'Mean Correlation: %.4f\n', mean_corr);
fprintf(fid, 'Mean wPLI: %.4f\n', mean_wPLI);
fprintf(fid, 'Final R-Value: %.4f\n', final_R_value);
fclose(fid);

disp(['Results saved to ', output_file]);
