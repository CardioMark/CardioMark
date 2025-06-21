
%% [20-06-2024]
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

%% read Observer's annotation

function [RefInfo,NSLoc,UserName,QRSc,NS]=PerLeadRefInformation(UserName,Record,Idx)

if isempty(Record)
    RefInfo='';
    NSLoc=0;
    QRSc='';
    NS='';
else
    QRSc= Record{1,7+Idx};
    NS= Record{1,7+12+Idx};
    RefInfo=[strcat(UserName,': ',QRSc); strcat('N/S: ',NS)];
    NSLoc=0;
    if  Record{1,31+Idx} >0
        NSLoc= Record{1,31+Idx};
    end

    if  Record{1,43+Idx} >0 && NSLoc>0
        NSLoc=(Record{1,43+Idx} + NSLoc )/2;
    else
        NSLoc= Record{1,43+Idx};
    end
end

end


  