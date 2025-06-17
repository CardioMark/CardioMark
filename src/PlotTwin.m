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
%% This function plots ECG waveforms on secondery axes:

function results = PlotTwin(app)
results=0;
STDTLeads={'Limb','Chest','I','II','III','aVR','aVL','aVF','V1','V2','V3','V4','V5','V6'};
STDTwinLeads={'Chest','Limb','II','I','V2','V1','V4','V3','V6','V5','aVF','aVL','aVR','III'};
LeadId2 = find(strcmp(STDTLeads, app.LeadTxt));
LeadId2=LeadId2(1);
LeadId3 = find(strcmp(STDTLeads, STDTwinLeads{LeadId2}));
LeadId3=LeadId3(1);
app.TwinLeadDropDown.Value=STDTwinLeads{LeadId2};
if LeadId3==1
    GUI_ECGPlot (2,app.ECGPlot_2,app.QRS,LeadId3,0);
else
    GUI_ECGPlot (2,app.ECGPlot_2,app.QRS,LeadId3,1);
end
app.TwinQRSOnLine= xline( app.ECGPlot_2,app.QRSOn,'B',LineWidth=1.0);
app.TwinQRSOFFLine=  xline(app.ECGPlot_2,app.QRSOff,'G',LineWidth=1.0);
app.TwinQTOffLine= xline(app.ECGPlot_2,app.QTOff,'M--',LineWidth=1.0);
app.ECGPlot_2.Toolbar.Visible = 'on';%*****************************
end
