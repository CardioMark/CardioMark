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

%% This function plots ECG waveforms for the raw ECG leads (all available leads).
% You can modify the local function 'ResetPlot' to adjust the appearance of the plots,
% such as axis limits, colors, or grid settings.



function Results=GUI_ECGLeadPlot (ax,ECGLead,Idxes,PlotType )

legendON=1;

TSScale=1000; % to scale Time Series to Second if =1000.

Results=0;
LineThick=0.75;

ax.reset;

if PlotType<=1

    for i=Idxes
        plot(ax,double(ECGLead(i).TS)./TSScale,ECGLead(i).X,'DisplayName',ECGLead(i).Lead,LineWidth=LineThick);
        hold(ax, "on");
    end
end
ResetPlot(ax);
if legendON==1
    legend (ax);
end

end


%%
function ResetPlot(ax)

% title (ax,strcat('Lead: ',Lead))
xlabel (ax,'seconds');ylabel(ax,'MilliVolts') % milli
xticks (ax,0:.200:10.000);
yticks (ax,-4.0:0.5:4.0);  %   yticks ([-2.5:0.1:2.5]);
grid (ax,"on");
grid (ax,"minor");
ax.MinorGridLineWidth=1;
ax.XAxis.MinorTick = 'on';
ax.XAxis.MinorTickValues = -1:.040:11.000; ax.YAxis.MinorTickValues = -4.0:0.1:4.0;
ax.GridColor = [ 1 0 0 ]; ax.LineWidth = 1.2; ax.MinorGridColor = [.9 0 0];
xlim(ax,[-1 11])

end
