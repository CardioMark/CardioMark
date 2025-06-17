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
% This function reads and loads ECG files from different formats.
%
% Supported formats:
%   - XML: typically exported from the GE MUSE system.
%   - MAT: MATLAB files that store ECG signals and possibly additional metadata.
%   - HEA: header files used in PhysioNet datasets. They describe the signal layout and
%          must be accompanied by a corresponding DAT file that contains the actual binary ECG data.
%
%% Note:
% - MAT files are assumed to contain ECG data saved in MATLAB format, either as arrays + structs. refer to the code for exact format.
% - HEA is not exclusive to PhysioNet, but it is most commonly used there.



function [Raw,MedianBeat]=LoadECGFile(FolderPath,FolderRawPath,FileName,FileExtension)

MediabFileFullName=strcat(FolderPath,'/' ,FileName);
RawFileFullName=strcat(FolderRawPath,'/' ,FileName);

if strcmp (FileExtension,'XML')
    [Raw,MedianBeat]=LoadXML(FolderPath,FileName); %
elseif strcmp (FileExtension,'HEA')
    [Raw,MedianBeat]=LoadHEA(MediabFileFullName,RawFileFullName); %
elseif strcmp (FileExtension,'MAT')
    load (MediabFileFullName,'Raw','MedianBeat')
end

end
%%
function [Raw,MedianBeat]=LoadHEA(FileFullName,RawFileFullName)
[ECGMetaMB] = ReadHEA(FileFullName);
[MedianBeat]=LoadDAT(ECGMetaMB); %
[ECGMetaRaw] = ReadHEA(RawFileFullName);
[Raw]=LoadDAT(ECGMetaRaw); %

end
%%
function [ECG]=LoadDAT(ECGMeta)
% [ECG]=LoadDAT(FileFullName,FileName,BitNo,NoofLead,Fs,leadsText,Gain,BaseLine,VUnit)
LeadsFullFileName=strcat(ECGMeta.FolderPath,ECGMeta.LeadFileNames{1}); % change this if file name change for each lead.
if exist(LeadsFullFileName,"file")
    fid=fopen(LeadsFullFileName,'r');
    ECGDataStream=fread(fid,[ECGMeta.NoofLeads,Inf],strcat('int',num2str(ECGMeta.BitRate(1))));
    fclose(fid);
    for i=1:ECGMeta.NoofLeads
        ECG(i).X=(ECGDataStream(i,:)-ECGMeta.Baseline(i))/ECGMeta.Gain(i); %#ok<*AGROW>
        ECG(i).Fs=double(ECGMeta.FS);
        ECG(i).Lead=ECGMeta.LeadNames{i};
        ECG(i).FileName=ECGMeta.LeadFileNames{i};
        ECG(i).Length=length(ECG(i).X);
        ECG(i).TS=uint16(linspace(0,ECG(i).Length/ECG(i).Fs-1/ECG(i).Fs,ECG(i).Length)*1000); % in ms
        ECG(i).Unit=ECGMeta.Unit{i};
        if  strcmpi(ECG(i).Unit, 'UV')
            ECG(i).X=ECG(i).X./1000;
            ECG(i).Unit='mV';
        end

    end
else
    for i=1:12
        ECG(i).X=0; %#ok<*AGROW>
        ECG(i).Fs=double(1);
        ECG(i).Lead='';
        ECG(i).FileName='';
        ECG(i).Length=1;
        ECG(i).TS=0; % in ms
        ECG(i).Unit='';
    end

end

end
%%
function [Raw,MedianBeat]=LoadXML(FolderPath,FileName)

FileFullName=strcat(FolderPath,'/' ,FileName);
[RawECG,Fs,MedianBeats,QRSMetaData]=ReadXML(FileFullName); % 0 for Dont save MAT file!

for i=1:length(MedianBeats)
    MedianBeat(i).X=MedianBeats{i}; %#ok<*AGROW>
    Raw(i).X=RawECG{i};
    MedianBeat(i).Fs=double(Fs);
    Raw(i).Fs=double(Fs);
    MedianBeat(i).Lead=QRSMetaData.LeadsText{i};
    Raw(i).Lead=QRSMetaData.LeadsText{i};
    [~,MedianBeat(i).FileName]=fileparts(FileName);
    Raw(i).FileName=MedianBeat(i).FileName;
    % Drawings related
    MedianBeat(i).Length=length(MedianBeat(i).X);
    Raw(i).Length=length(Raw(i).X);
    MedianBeat(i).TS=uint16(linspace(0,MedianBeat(i).Length/Fs-1/Fs,MedianBeat(i).Length)*1000); % in ms
    Raw(i).TS=uint16(linspace(0,Raw(i).Length/Fs-1/Fs,Raw(i).Length)*1000); % in ms
end

end
%%
function ECGMeta = ReadHEA(HEAFile)
%This function is tested based on very common databases. may need some modification for some databases.
[FilePath,HEAFileNAme,~]=fileparts (HEAFile);

fid = fopen(HEAFile, 'r');% Open the file
if fid == -1
    fprintf('Cannot open file: %s   !!!\n', HEAFile);
    ECGMeta.FolderPath=strcat(FilePath,"/");
    ECGMeta.mainFileName = HEAFileNAme;
    ECGMeta.LeadFileNames{1} = 'NoFile';
    ECGMeta.LeadNames{1} = '';
    ECGMeta.NoofLeads =1;
else
    firstLine = fgetl(fid);
    DataLines = strsplit(firstLine, ' ');

    % Extract metadata
    ECGMeta.mainFileName = DataLines{1};  % Main record name
    ECGMeta.FolderPath=strcat(FilePath,"/");
    ECGMeta.FS = str2double(DataLines{3}); % Sampling frequency (Hz)
    ECGMeta.NoofLeads = str2double(DataLines{2}); % Number of signals

    %% Initialize Struct
    ECGMeta.LeadFileNames = cell(ECGMeta.NoofLeads,1);

    ECGMeta.LeadNames = cell(ECGMeta.NoofLeads,1);
    ECGMeta.Gain = zeros(ECGMeta.NoofLeads,1);
    ECGMeta.Baseline = zeros(ECGMeta.NoofLeads,1);
    ECGMeta.Unit = cell(ECGMeta.NoofLeads,1);
    ECGMeta.BitRate = zeros(ECGMeta.NoofLeads,1);


    for i = 1:ECGMeta.NoofLeads % Read each signal line
        line = fgetl(fid);
        tokens = strsplit(line, ' ');

        ECGMeta.LeadFileNames{i} = tokens{1}; % Extract file name for each lead
        ECGMeta.LeadNames{i} = tokens{end};   % Extract lead name
        ECGMeta.BitRate(i) = str2double(tokens{2}); % Bit resolution

        % Extract ADC Gain, Baseline, and Units

        GainBaselineStr = tokens{3}; % Format: "gain(baseline)/unit"
        GainParts = strsplit(GainBaselineStr, '(');
        ECGMeta.Gain(i) = str2double(GainParts{1});  % Extract gain

        if numel(GainParts) > 1
            BaselineParts = strsplit(GainParts{2}, ')');
            ECGMeta.Baseline(i) = str2double(BaselineParts{1}); % Extract baseline
            ECGMeta.Unit{i} = strrep(BaselineParts{2}, '/', ''); % Extract unit
        else
            ECGMeta.Baseline(i) = 0; % Default baseline if missing
            ECGMeta.Unit{i} = ''; % No unit found
        end
    end

    fclose(fid);    % Close the file

end
end


