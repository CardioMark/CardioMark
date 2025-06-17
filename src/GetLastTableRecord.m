%% [11-06-2024]
% CardioMark: A user-friendly tool for manually annotating ECG recordings.
% Enables precise identification of QRS onset, QRS offset, and T-wave offset
% for calculating QRS duration (QRSd) and QT interval. Features a GUI with
% intuitive tools for waveform labeling, slur/notch detection, and heartbeat
% classification. Supports multiple ECG file formats and exports annotations
% for seamless integration with AI systems or external review.
%% Citation:
% S. Abdel-Rahman et al., "Faster R-CNN approach for estimating global QRS duration
% in electrocardiograms with a limited quantity of annotated data," Comput. Biol. Med.,
% vol. 192, p. 110200, 2025. https://doi.org/10.1016/j.compbiomed.2025.110200
%% Get Last Table Record since the table may contains multiple records for the same file.

function TheRecord = GetLastTableRecord(Tbl, TheFileName)
matchingRows = Tbl(strcmp(Tbl.FileName, TheFileName), :);% Check for rows with the specified FileName
if ~isempty(matchingRows)% Retrieve the last row of the matching rows
    TheRecord = matchingRows(end, :);
else
    TheRecord = [];
end
end