
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
%%
% This function plots ECG waveforms on two axes:
%   - ECGPlot: the main axis
%   - ECGPlot_2: the secondary axis
% You can modify the local function 'ResetPlot' to adjust the plot appearance and visual settings.


function Results=GUI_ECGPlot (PlotType,ax,ECGData,QRSIdx,SuperImposedID,legendON)

if nargin<6
    legendON=0;
end

Results=0;
LineThick=0.75;


if QRSIdx>0
    QRSi=ECGData(QRSIdx);
end

ax.reset;  % ax=app.ECGPlot; % app.ECGPlot.reset ;

if PlotType<=1
    plot(ax,QRSi.TS,QRSi.X,'k','DisplayName','ECG',LineWidth=LineThick);hold(ax, "on");
    ResetPlot(ax,QRSi.FileName,QRSi.Lead);

elseif PlotType==2 % Superimpose Plot

    if SuperImposedID==0 % Limb leads
        SuperImpose=[1,2,3,4,5,6];
        SITitle='Limb';
    else
        SuperImpose=[7,8,9,10,11,12];SITitle='Chest';
    end

    for i=SuperImpose
        plot(ax,ECGData(i).TS,ECGData(i).X,'DisplayName',ECGData(i).Lead,LineWidth=LineThick);hold(ax, "on");
    end

    if legendON==1
        legend (ax)
    end

    ResetPlot(ax,ECGData(1).FileName,SITitle);
end

end


%%
function ResetPlot(ax,FileName,Lead)

title (ax,strcat(FileName,' / Lead: ',Lead))
xlabel (ax,'milliseconds');ylabel(ax,'MilliVolts')
xticks (ax,0:200:2000);
yticks (ax,-3.5:0.5:3.5);  %   yticks ([-2.5:0.1:2.5]);
grid (ax,"on");
grid (ax,"minor");
ax.MinorGridLineWidth=1;
ax.XAxis.MinorTick = 'on';
ax.XAxis.MinorTickValues = 0:40:2000; ax.YAxis.MinorTickValues = -3.5:0.1:3.5;
ax.GridColor = [ 1 0 0 ]; ax.LineWidth = 1; ax.MinorGridColor = [1 0 0];
ax.Toolbar.Visible = 'off';%*****************************

end
