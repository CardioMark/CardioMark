
%% [26-08-2025]
% CardioMark: A user-friendly tool for manually annotating ECG recordings.
% Enables precise identification of QRS onset, QRS offset, and T-wave offset
% for calculating QRS duration (QRSd) and QT interval. Features a GUI with
% intuitive tools for waveform labeling, slur/notch detection, and QRS Morphology
% Supports multiple ECG file formats and exports annotations
% for seamless integration with AI systems or external review.
%% Citation:
% S. Abdel-Rahman et al., "Faster R-CNN approach for estimating global QRS duration
% in electrocardiograms with a limited quantity of annotated data," Comput. Biol. Med.,
% vol. 192, p. 110200, 2025. https://doi.org/10.1016/j.compbiomed.2025.110200

function SaveData2ExcelV2(app, XMLFileName,QRSMorph,QRSOn, QRSd,QTd,QRS,Comments,Provenance)

ExcelFileName=app.ECGFileSelector.ExcelFileName;%
timestamp = datestr(datetime("now"), 'yyyy-mm-dd HH:MM:SS'); %#ok<DATST> % Create a timestamp string
DataRow = { XMLFileName,timestamp,QRSMorph, QRSOn, QRSd,QTd, strcat(Comments{1,1},' - ')};
DataRow=cat(2,DataRow,QRS.QRSConfig,QRS.NS,num2cell(QRS.NSon),num2cell(QRS.NSoff),num2cell(QRS.RpeakI),Provenance);

if isfile(ExcelFileName)% Read the existing data from the Excel file, if it exists
    data = readcell(ExcelFileName);
else
    % If the file doesn't exist, create a new cell array
    Header1 = {'FileName','Timestamp','QRSMorph' , 'Onset', 'QRSd','QTd','Comment'}; % Header
    for i=1:12
        Header2{i}=strcat(QRS.LeadName{i}, '_P');
        Header3{i}=strcat(QRS.LeadName{i}, '_N_S'); % Notch or slur
        Header4{i}=strcat(QRS.LeadName{i}, '_N_Son');
        Header5{i}=strcat(QRS.LeadName{i}, '_N_Soff');
        Header6{i}=strcat(QRS.LeadName{i}, '_R_Peak');
    end

    data=cat(2,Header1,Header2,Header3,Header4,Header5,Header6,'Provenance');

end


data = [data; DataRow];
writecell(data, ExcelFileName, 'Sheet', 1); % Write the updated data to the Excel file


end
