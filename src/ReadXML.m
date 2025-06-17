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
 
%% order of leads are assumed so change the code if needed. but mostlikely this is not needed
 
function [Lead,Fs,MedianBeat,QRSMetaData]=ReadXML(FileName)
% % % [filepath,name,ext]=fileparts (FileName);
% TS: Time Series usualy for 10 seconds divided 1/Fs
XMLFile =FileName;%

XML=fileread (XMLFile); % READ File

[Lead,LeadLength,LeadsText,MedianBeat,MedianBeatLength]=ExtractLeads(XML);

[QRSLoc]=ExtractQRSStart(XML);
[Fs,ECGSize]=ExtractFsPlus(XML);
TS=linspace(0,ECGSize/Fs-1/Fs,ECGSize);

QRSMetaData.QRSLoc=QRSLoc;

QRSMetaData.Fs = Fs;
QRSMetaData.ECGSize = ECGSize;
QRSMetaData.LeadLength = LeadLength ;
QRSMetaData.LeadsText =LeadsText ;
QRSMetaData.TS = TS ;
QRSMetaData.MedianLeadLength =MedianBeatLength ;
QRSMetaData.FileName =FileName ;

end

%%
function [Fs,ECGSize]=ExtractFsPlus(XML) %*** add to read mV
[Index0,Index1]=IndexAtrributes(XML,'SampleBase');
Fs=str2double( extractBetween(XML,Index0(1),Index1(1)));

if length(Index1)>1

    Fs2=str2double(extractBetween(XML,Index0(2),Index1(2)));

end
if Fs~=Fs2
    Fs=0;
end

[Index0,Index1]=IndexAtrributes(XML,'LeadSampleCountTotal');
ECGSize=str2double( extractBetween(XML,Index0(1+8),Index1(1+8))); % in samples


end

function [QRSOnset]=ExtractQRSStart(XML)
[Index0,Index1]=IndexAtrributes(XML,'QRSTimesTypes');
QRS_TXT=extractBetween(XML,Index0(1),Index1(1));
[Index0,Index1]=IndexAtrributes(QRS_TXT,'Time');

for i=1:size(Index0,2)
    SS=extractBetween(QRS_TXT,Index0(i),Index1(i));
    QRSOnset(i)=str2double (SS{1}); %#ok<AGROW>
end


end

function [Index0,Index1]=IndexAtrributes(XML,AtrributeText)
AttrStartLength=size(AtrributeText,2)+2;
Index0 = strfind(XML, strcat('<',AtrributeText,'>'));
Index1 = strfind(XML, strcat('</',AtrributeText,'>'));
if iscell(Index0)
    Index0= Index0{1}+AttrStartLength;
    Index1= Index1{1}-1;
else
    Index0= Index0+AttrStartLength;
    Index1= Index1-1;

end

end

function [Lead,LeadLength,leadsText,MedianLead,MedianLeadLength]=ExtractLeads(XML)
muVoltFactor=4.88;


[Index0,Index1]=IndexAtrributes(XML,'WaveFormData');

for i=1:8
    OrginalLeadData=extractBetween(XML,Index0(8+i),Index1(8+i));
    OrginalLeadData=OrginalLeadData{1, 1};
    [LeadOrg{i},LeadLength]=Convert2Base64(OrginalLeadData); %#ok<AGROW>
end

LeadOrg{9}=LeadOrg{2}-LeadOrg{1}; %'III'
LeadOrg{10}=double((LeadOrg{1}+LeadOrg{2})).*-0.5; % aVR
LeadOrg{11}=double(LeadOrg{1})-double(LeadOrg{2})*0.5; % aVL
LeadOrg{12}=double(LeadOrg{2})-double(LeadOrg{1})*0.5; % aVF
 
% Median Leads Extracting:
for i=1:8

    OrginalLeadData=extractBetween(XML,Index0(i),Index1(i));
    OrginalLeadData=OrginalLeadData{1, 1};
    [MedianLeadOrg{i},MedianLeadLength]=Convert2Base64(OrginalLeadData); %#ok<AGROW>
end

MedianLeadOrg{9}=MedianLeadOrg{2}-MedianLeadOrg{1}; %'III'
MedianLeadOrg{10}=double((MedianLeadOrg{1}+MedianLeadOrg{2})).*-0.5; % aVR
MedianLeadOrg{11}=double(MedianLeadOrg{1})-double(MedianLeadOrg{2})*0.5; % aVL
MedianLeadOrg{12}=double(MedianLeadOrg{2})-double(MedianLeadOrg{1})*0.5; % aVF

% Median Leads Extracting-----^^^^


% Scale Signal

for i=1:12
    LeadOrg{i}=double((LeadOrg{i})).*muVoltFactor/1000;
    LeadOrg{i}=LeadOrg{i}';
    MedianLeadOrg{i}=double((MedianLeadOrg{i})).*muVoltFactor/1000;
    MedianLeadOrg{i}=MedianLeadOrg{i}';
end


%% Reorder Leads to the standard >>>> leadsText={'I','II','III','aVR','aVL','aVF','V1','V2','V3','V4','V5','V6'};
leadsTextOrg={'I','II','V1','V2','V3','V4','V5','V6','III','aVR','aVL','aVF'};
LeadNewIdx=[1,2,9,10,11,12,3,4,5,6,7,8];
for i=1:12 

leadsText{i}=leadsTextOrg{LeadNewIdx(i)};
Lead{i}=LeadOrg{LeadNewIdx(i)};
MedianLead{i}=MedianLeadOrg{LeadNewIdx(i)};

end



end

function [ConvetredData,Length]=Convert2Base64(Data)

Data2 =matlab.net.base64decode(Data);
Byte1= typecast( Data2(1:2:end),'int8');
Byte2 =typecast( Data2(2:2:end),'int8');

Length=size(Byte2,2);
ConvetredData=zeros(Length,1,"int16");

for i=1:Length
    BIN1=dec2bin(Byte1(i));
    BIN2=dec2bin(Byte2(i));
    BIN1L=size(BIN1,2);

    if BIN1L<8
        BIN1=[repmat('0',1,8-BIN1L),BIN1];
    end
    BINNO= [BIN2, BIN1] ;
    ConvetredData(i)=typecast(uint16(bin2dec(BINNO)),'int16');
end
end