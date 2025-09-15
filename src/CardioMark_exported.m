classdef CardioMark_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        CardioMarkV10UIFigure         matlab.ui.Figure
        HelpButton                    matlab.ui.control.Button
        QRSMorphologyPanel            matlab.ui.container.Panel
        Observer2QRSMorphologyLabel   matlab.ui.control.Label
        Observer1QRSMorphologyLabel   matlab.ui.control.Label
        QRSMorphologyDropDown         matlab.ui.control.DropDown
        CommentsPanel                 matlab.ui.container.Panel
        Observer2CommentsLabel        matlab.ui.control.Label
        Observer1CommentsLabel        matlab.ui.control.Label
        CommentsTextArea              matlab.ui.control.TextArea
        MeasurmentsmsPanel            matlab.ui.container.Panel
        Label                         matlab.ui.control.Label
        Label_2                       matlab.ui.control.Label
        Label_3                       matlab.ui.control.Label
        Label_4                       matlab.ui.control.Label
        Label_5                       matlab.ui.control.Label
        QTLabel                       matlab.ui.control.Label
        ToffLabel                     matlab.ui.control.Label
        QRSdLabel_2                   matlab.ui.control.Label
        QRSoffLabel                   matlab.ui.control.Label
        QRSonLabel                    matlab.ui.control.Label
        TabGroup                      matlab.ui.container.TabGroup
        SuperimposeTab                matlab.ui.container.Tab
        KeyCommandLabel_2             matlab.ui.control.Label
        Gain2XSliderLabel             matlab.ui.control.Label
        Gain2XSlider                  matlab.ui.control.Slider
        AutoR_PeaksButton             matlab.ui.control.Button
        RefreshButton                 matlab.ui.control.Button
        WaitImage                     matlab.ui.control.Image
        LegendButton                  matlab.ui.control.StateButton
        KeyCommandLabel               matlab.ui.control.Label
        TwinLeadDropDown              matlab.ui.control.DropDown
        SecondaryAxisPlotLabel        matlab.ui.control.Label
        NextButton                    matlab.ui.control.Button
        LimitEditField                matlab.ui.control.NumericEditField
        QTButton                      matlab.ui.control.StateButton
        LeadsSelectListBox            matlab.ui.control.ListBox
        QRSButton                     matlab.ui.control.StateButton
        BoundarySelectionButtonGroup  matlab.ui.container.ButtonGroup
        GoRightButton                 matlab.ui.control.Button
        GoLeftButton                  matlab.ui.control.Button
        TOffsetButton                 matlab.ui.control.RadioButton
        QRSOffsetButton               matlab.ui.control.RadioButton
        QRSOnsetButton                matlab.ui.control.RadioButton
        LeadsListBoxLabel             matlab.ui.control.Label
        ECGPlot_2                     matlab.ui.control.UIAxes
        ECGPlot                       matlab.ui.control.UIAxes
        LimbLeadsTab                  matlab.ui.container.Tab
        NextButton_2                  matlab.ui.control.Button
        aVF                           MedianBeat_Config
        aVL                           MedianBeat_Config
        aVR                           MedianBeat_Config
        III                           MedianBeat_Config
        II                            MedianBeat_Config
        I                             MedianBeat_Config
        ChestLeadsTab                 matlab.ui.container.Tab
        NextButton_3                  matlab.ui.control.Button
        V6                            MedianBeat_Config
        V5                            MedianBeat_Config
        V4                            MedianBeat_Config
        V3                            MedianBeat_Config
        V2                            MedianBeat_Config
        V1                            MedianBeat_Config
        FullLeadsTab                  matlab.ui.container.Tab
        LeadsforPlotPanel             matlab.ui.container.Panel
        PlotButton                    matlab.ui.control.Button
        V6Button                      matlab.ui.control.StateButton
        V5Button                      matlab.ui.control.StateButton
        V4Button                      matlab.ui.control.StateButton
        V3Button                      matlab.ui.control.StateButton
        V2Button                      matlab.ui.control.StateButton
        aVFButton                     matlab.ui.control.StateButton
        aVLButton                     matlab.ui.control.StateButton
        aVRButton                     matlab.ui.control.StateButton
        IIIButton                     matlab.ui.control.StateButton
        IIButton                      matlab.ui.control.StateButton
        V1Button                      matlab.ui.control.StateButton
        IButton                       matlab.ui.control.StateButton
        ECGLeadPlot                   matlab.ui.control.UIAxes
        StatusLabel                   matlab.ui.control.Label
        SaveButton                    matlab.ui.control.Button
        ECGFileSelector               ECGFileSelector
        SettingsPanel                 matlab.ui.container.Panel
        AutoRPeakCheckBox             matlab.ui.control.CheckBox
        UseRef2CheckBox               matlab.ui.control.CheckBox
        UseRef1CheckBox               matlab.ui.control.CheckBox
        SaveOnlyCompleteDataCheckBox  matlab.ui.control.CheckBox
        UseonsetoffsetfromLabel       matlab.ui.control.Label
        LoadFullLeadsCheckBox         matlab.ui.control.CheckBox
    end


    %% Comments
    %[11-06-2025]
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


    properties (Access = public)
        QRS ; ECGFileName ; LeadId=0 ; LeadTxt='Limb' ;
        QRSOn=1 ; QRSOff=2 ; QTOff=2 ;  QRSOnLine ;  QRSOFFLine ; QTOffLine ; QRSd=0; QTd=0;
        TwinQRSOnLine ;  TwinQRSOFFLine ; TwinQTOffLine ;
        KeyCommand=0;FolderPath
        OrginalLimit;OrginalLimitV=[0,0];
    end

    properties (Access = private)
        PlotIdxes=[1]; % Description
    end

    methods (Access = private)
        function results = FillMiniSummary(app)
            % refresh "Measurments ms" panel
            app.Label_5.Text=num2str(app.QRSOn);
            app.Label_4.Text=num2str(app.QRSOff);
            app.QRSd=app.QRSOff- app.QRSOn;
            app.Label_3.Text=num2str(app.QRSd);
            app.QRSd=app.QRSOff- app.QRSOn;
            app.Label_2.Text=num2str(app.QTOff);
            app.QTd=app.QTOff- app.QRSOn;
            app.Label.Text=num2str(app.QTd);
            results='OK FillMiniSummary';
        end

        function results = UseREFSets(app,UseIt,RefOnset,RefQRSd,RefTOd)
            % function to manage observers annotations and make it more modular
            if UseIt>0
                RefOffset=RefOnset+RefQRSd ;
                RefTOffset=RefOnset+RefTOd ;
                if RefOnset>3
                    app.QRSOn =RefOnset;
                    app.QRSOnLine.Value=app.QRSOn;
                end
                if RefOffset>3
                    app.QRSOff =RefOffset;
                    app.QRSOFFLine.Value=app.QRSOff;
                end

                if RefTOffset>3
                    app.QTOff =RefTOffset;
                    app.QTOffLine.Value=app.QTOff;
                end
                FillMiniSummary(app);
            end
            results='Done-UseREFSets';
        end
    end

    methods (Access = public)
        function results = ExtraFunction(app) % % %
            results=app.QRSOn;
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Startup initialisation
            clc ;
            appFile = mfilename('fullpath') ; appDir = fileparts(appFile) ;
            cd(appDir) ;
        end

        % Button down function: ECGPlot
        function ECGPlotButtonDown(app, event)
            % selecting boundaries on the main axis plot.
            coordinates = event.IntersectionPoint(1:2) ;  
 
            if (event.Button)==1 && app.KeyCommand ==0
                app.QRSOn =round(coordinates(1)/2,0)*2;
                app.QRSOnLine.Value=app.QRSOn;
                app.TwinQRSOnLine.Value=app.QRSOn;
            elseif (event.Button)==3 || ( (event.Button)==1 && app.KeyCommand ==1)
                if app.QRSOnLine.Value< coordinates(1)
                    app.QRSOff =round(coordinates(1)/2,0)*2;
                    app.QRSOFFLine.Value= app.QRSOff;
                    app.TwinQRSOFFLine.Value= app.QRSOff; % if app.ShowTwin==1
                    % app.Label_4.Text=num2str( app.QRSOff);
                end
            elseif (event.Button)==2 || ( (event.Button)==1 && app.KeyCommand ==2)
                app.QTOff =round(coordinates(1)/2,0)*2;
                app.QTOffLine.Value= app.QTOff ;
                app.TwinQTOffLine.Value= app.QTOff ;
            end

            %% Fill Summary
            FillMiniSummary(app);

        end

        % Clicked callback: LeadsSelectListBox
        function LeadsListBoxClicked(app, event)
            % to selct the superimposed on the main axis plot.
            if ~isempty (app.ECGFileName)
                item = event.InteractionInformation.Item;
                if isscalar(item)
                    app.LeadId=item-2;
                    app.LeadTxt=app.LeadsSelectListBox.Items(item);
                    app.LeadsSelectListBox.Value=app.LeadTxt;
                end
                if app.LeadId==0
                    GUI_ECGPlot (2,app.ECGPlot,app.QRS,app.LeadId,1,app.LegendButton.Value);
                    app.ECGPlot.ButtonDownFcn = createCallbackFcn(app, @ECGPlotButtonDown, true);
                else
                    GUI_ECGPlot (2,app.ECGPlot,app.QRS,app.LeadId,0,app.LegendButton.Value);
                    app.ECGPlot.ButtonDownFcn = createCallbackFcn(app, @ECGPlotButtonDown, true);
                end
                app.QRSOnLine= xline(app.ECGPlot,app.QRSOn,'B',LineWidth=1.0);
                app.QRSOFFLine= xline(app.ECGPlot,app.QRSOff,'G',LineWidth=1.0);
                app.QTOffLine= xline(app.ECGPlot,app.QTOff,'M--',LineWidth=1.0);
                PlotTwin(app);
            end
        end

        % Button pushed function: SaveButton
        function SaveButtonPushed(app, event)
            % To save the annotation data to the excel file.
            
            leadNames={'I','II','III','aVR','aVL','aVF','V1','V2','V3','V4','V5','V6'};
            MedianBeatControl={app.I,app.II,app.III,app.aVR,app.aVL,app.aVF,app.V1,app.V2,app.V3,app.V4,app.V5,app.V6};
            for i=1:12 % Collect annotation from the median beats.
                if MedianBeatControl{i}.MidNotch==1;NS='Notch';else;NS='_'  ; end
                if MedianBeatControl{i}.MidSlur==1;NS=strcat('Slur');end
                QRSSpecs.NS{i}=NS;
                QRSSpecs.NSoff(i)=MedianBeatControl{i}.NSoff;
                QRSSpecs.NSon(i)=MedianBeatControl{i}.NSon;
                QRSSpecs.RpeakI(i)=MedianBeatControl{i}.QRS_RPeak;
                QRSSpecs.QRSConfig{i}=MedianBeatControl{i}.QRS_Config;
                QRSSpecs.LeadName{i}=leadNames{i};
            end

            MissingData=1;
            if strcmp(app.QRSMorphologyDropDown.Value,'Not Selected')
                ErrorStr="Select QRS Morph";
            elseif sum( strcmp (string(QRSSpecs.QRSConfig),"N/A"))>0 || sum( strcmp (string(QRSSpecs.QRSConfig),""))>0
                ErrorStr='Missing Configurations';
            else
                MissingData=0;
            end

             if app.SaveOnlyCompleteDataCheckBox.Value==0 || (app.SaveOnlyCompleteDataCheckBox.Value==1 && MissingData==0)
                SaveData2ExcelV2(app,app.ECGFileName,app.QRSMorphologyDropDown.Value,app.QRSOn,app.QRSd,app.QTd, QRSSpecs,app.CommentsTextArea.Value); % Function to save to the excel file
                app.StatusLabel.Text='Saved Successfully';
                app.StatusLabel.FontColor=[0.0,1,0.0];
            else
                app.StatusLabel.Text=ErrorStr;
                app.StatusLabel.FontColor=[0.90,0.70,0.15];
            end

        end

        % Value changed function: TwinLeadDropDown
        function TwinLeadDropDownValueChanged(app, event)
            % to select other lead other than the standard superimposed to be suwn on the secondry axis plot

            LeadId3= find(strcmp(app.TwinLeadDropDown.Items,app.TwinLeadDropDown.Value));LeadId3=LeadId3(1);

            if LeadId3>2
                GUI_ECGPlot (1,app.ECGPlot_2,app.QRS,LeadId3-2,0);
            elseif LeadId3==1
                GUI_ECGPlot (2,app.ECGPlot_2,app.QRS,LeadId3,0);
            else
                GUI_ECGPlot (2,app.ECGPlot_2,app.QRS,LeadId3,1);
            end
            app.TwinQRSOnLine=xline( app.ECGPlot_2,app.QRSOn,'B',LineWidth=1.0);
            app.TwinQRSOFFLine=xline(app.ECGPlot_2,app.QRSOff,'G',LineWidth=1.0);
            app.TwinQTOffLine=xline(app.ECGPlot_2,app.QTOff,'M--',LineWidth=1.0);
        end

        % Key press function: CardioMarkV10UIFigure
        function CardioMarkV10UIFigureKeyPress(app, event)
            % function for Key shortcuts specailly for mac user
            KEY = event.Key;
            if strcmp(KEY,'s') || strcmp(KEY,'1')
                app.KeyCommand=0;
                app.KeyCommandLabel.Text="Tip: Select QRS Onset";
                app.QRSOnsetButton.Value=1;
            elseif strcmp(KEY,'e') || strcmp(KEY,'2')
                app.KeyCommand=1;
                app.KeyCommandLabel.Text="Tip: Select QRS Offset";
                app.QRSOffsetButton.Value=1;
            elseif strcmp(KEY,'t') ||strcmp(KEY,'3')
                app.KeyCommand=2;
                app.KeyCommandLabel.Text="Tip: Select T Offset";
                app.TOffsetButton.Value=1;
            end
        end

        % Button pushed function: NextButton
        function NextButtonPushed(app, event)
            % Jump to the next tab
            app.TabGroup.SelectedTab=app.LimbLeadsTab;
            RefreshButtonPushed2(app, event)
        end

        % Button pushed function: HelpButton
        function HelpHelpButtonValueChanged(app, event)
          
            %% Help button and about me

            dlgWidth = 450;
            dlgHeight = 350;
            btnWidth = 150;
            btnHeight = 35;
            xCenter = (dlgWidth - btnWidth) / 2;

            d = dialog('Position',[500 500 dlgWidth dlgHeight],'Name','CardioMark Help');

            % Title
            uicontrol('Parent',d,...
                'Style','text',...
                'FontSize',22,...
                'FontWeight','bold',...
                'HorizontalAlignment','center',...
                'Position',[25 270 400 50],...
                'String','CardioMark V1.0');

            % Description
            uicontrol('Parent',d,...
                'Style','text',...
                'FontSize',14,...
                'HorizontalAlignment','center',...
                'Position',[25 200 400 70],...
                'String','CardioMark: An open-source MATLAB toolbox for ECG annotation for machine learning and academic research');

            % GitHub Button
            uicontrol('Parent',d,...
                'Position',[xCenter 150 btnWidth btnHeight],...
                'FontSize',13,...
                'String','GitHub',...
                'Callback',@(src,event)web('https://github.com/CardioMark/CardioMark'));

            % Documentation Button
            uicontrol('Parent',d,...
                'Position',[xCenter 100 btnWidth btnHeight],...
                'FontSize',13,...
                'String','Documentation',...
                'Callback',@(src,event)web('https://github.com/CardioMark/CardioMark/tree/main/Documentation'));

            % OK Button
            uicontrol('Parent',d,...
                'Position',[xCenter 50 btnWidth btnHeight],...
                'FontSize',13,...
                'String','OK',...
                'Callback',@(src,event)close(d));

            uiwait(d);


 
        end

        % Selection changed function: BoundarySelectionButtonGroup
        function BoundarySelectionButtonGroupSelectionChanged(app, event)
            % Specially for MAX user, to use left click to select onsets and offsets.
            selectedButton = app.BoundarySelectionButtonGroup.SelectedObject;
            if strcmp(selectedButton.Text,'QRS Onset')
                app.KeyCommand=0;
                app.KeyCommandLabel.Text="Tip: Select QRS Onset";
            elseif strcmp(selectedButton.Text,'QRS Offset')
                app.KeyCommand=1;
                app.KeyCommandLabel.Text="Tip: Select QRS Offset";
            elseif strcmp(selectedButton.Text,'T Offset')
                app.KeyCommand=2;
                app.KeyCommandLabel.Text="Tip: Select T Offset";
            end

        end

        % Value changed function: QRSButton
        function QRSButtonValueChanged(app, event)
      % Zoom into waveform between the selected QRS onset and QRS offset
            value = app.QRSButton.Value;
            ScaleFactor1=(1-app.LimitEditField.Value/100);
            ScaleFactor2=(1+app.LimitEditField.Value/100);
            if value==1
                if app.QTButton.Value==0
                    app.OrginalLimit=xlim(app.ECGPlot);
                else
                    app.QTButton.Value=0;
                end
                xlim(app.ECGPlot,[app.QRSOn*ScaleFactor1,app.QRSOff*ScaleFactor2]);
            else
                xlim(app.ECGPlot,app.OrginalLimit);
            end
        end

        % Value changed function: QTButton
        function QTButtonValueChanged(app, event)
           % Zoom into waveform between the selected Q onset and T offset
            value = app.QTButton.Value;
            ScaleFactor1=(1-app.LimitEditField.Value/100);
            ScaleFactor2=(1+app.LimitEditField.Value/100);
            if value==1
                if app.QRSButton.Value==0
                    app.OrginalLimit=xlim(app.ECGPlot);
                else
                    app.QRSButton.Value=0;
                end
                if app.QTOff>100
                    xlim(app.ECGPlot,[app.QRSOn*ScaleFactor1,app.QTOff*ScaleFactor2]);
                end
            else
                xlim(app.ECGPlot,app.OrginalLimit);
            end
        end

        % Value changed function: Gain2XSlider
        function Gain2XSliderValueChanged(app, event)
            % increase the gain of the superimposed waveform
            value = app.Gain2XSlider.Value;
            if app.OrginalLimitV(1)==0 && app.OrginalLimitV(2)==0
                app.OrginalLimitV=ylim(app.ECGPlot);
            end
            ylim(app.ECGPlot,app.OrginalLimitV./(2^value));
        end

        % Button pushed function: RefreshButton
        function RefreshButtonPushed2(app, event)
           % Refresh all medaian beats 
            BeatsMETADATA=[app.QRSOn,app.QRSOff,app.ECGFileSelector.Fs]; %
            LeadSpecsControl2={app.I,app.II,app.III,app.aVR,app.aVL,app.aVF,app.V1,app.V2,app.V3,app.V4,app.V5,app.V6};
            for i=1:12
                LeadSpecsControl2{i}.Update(BeatsMETADATA);
            end
        end

        % Button down function: LimbLeadsTab
        function LimbLeadsTabButtonDown(app, event)
           % Refresh plots
            RefreshButtonPushed2(app, event)
        end

        % Button pushed function: AutoR_PeaksButton
        function AutoR_PeaksButtonPushed(app, event)
            % Disabled command.  to Rpeak all median beats. 
            RefreshButtonPushed2(app, event)
            MedianBeatControl={app.I,app.II,app.III,app.aVR,app.aVL,app.aVF,app.V1,app.V2,app.V3,app.V4,app.V5,app.V6};
            for i=1:12
                MedianBeatControl{i}.AutoRPeak;
            end
        end

        % Button pushed function: NextButton_2
        function NextButton_2Pushed(app, event)
            app.TabGroup.SelectedTab=app.ChestLeadsTab;
            RefreshButtonPushed2(app, event)
        end

        % Button pushed function: NextButton_3
        function NextButton_3Pushed(app, event)
            app.TabGroup.SelectedTab=app.FullLeadsTab;
            RefreshButtonPushed2(app, event)
        end

        % Callback function: ECGFileSelector
        function ECGFileisSelected(app, event)
            %% stage 1 Initialisation and Reset to initial status.
            app.StatusLabel.Text='Loading... ';
            app.TabGroup.SelectedTab=app.SuperimposeTab; % go to default Tab
            app.StatusLabel.FontColor=[0.90,0.70,0.15]; % Change color of status text to orange ish
            app.WaitImage.Visible="on"; % HourGlass image for progress indication
            drawnow; % do pending callbacks

            app.LeadId=0;
            app.QRS= app.ECGFileSelector.Median; % QRS contains All median beat waveform and meta data
            app.ECGFileName=app.ECGFileSelector.FileName;
            app.FolderPath=app.ECGFileSelector.FolderPath;
            if length (app.ECGFileName)>5 % just extra file name checking point
                % default Settings
                app.TabGroup.SelectedTab=app.SuperimposeTab; % go to default Tab
                app.LeadsSelectListBox.Value='Limb'; %%*** default
                app.QRSMorphologyDropDown.Value='Not Selected';
                app.Gain2XSlider.Value=0;
                GUI_ECGPlot (2,app.ECGPlot,app.QRS,app.LeadId,0,app.LegendButton.Value); % <<<<<<<<<<<<
                app.ECGPlot.ButtonDownFcn = createCallbackFcn(app, @ECGPlotButtonDown, true);

                app.QRSOn=1;app.QRSOff=1;app.QTOff=1; % Starting Position for annotation for future annotation
                app.QRSOnLine= xline( app.ECGPlot,app.QRSOn,'B',LineWidth=1.0,DisplayName='QRS Onset');
                app.QRSOFFLine= xline(app.ECGPlot,app.QRSOff,'G',LineWidth=1.0,DisplayName='QRS Offset');
                app.QTOffLine= xline(app.ECGPlot,app.QTOff,'M--',LineWidth=1.0,DisplayName='QT Offset');

                % % Plot All Lead in the second TAB and 3rd tab
                LeadSpecsControl2={app.I,app.II,app.III,app.aVR,app.aVL,app.aVF,app.V1,app.V2,app.V3,app.V4,app.V5,app.V6};

                BeatsMETADATA=[0,0,app.ECGFileSelector.Fs]; % Vector contains numbers needed for components

                for i=1:12 % change 12 if you are modifing the app for more or less leads.
                    % Get Observers annotation
                    [Ref1Info,Ref1NSLoc,Ref1UserName,Ref1QRSc,Ref1NS]=PerLeadRefInformation(app.ECGFileSelector.REFName1,app.ECGFileSelector.Ref1Record,i);
                    [Ref2Info,Ref2NSLoc,Ref2UserName,Ref2QRSc,Ref2NS]=PerLeadRefInformation(app.ECGFileSelector.REFName2,app.ECGFileSelector.Ref2Record,i);
                    % Reset component and plot the new median beat waveform and show observers work if any.
                    LeadSpecsControl2{i}.ResetControl;
                    LeadSpecsControl2{i}.PlotQRS(app.QRS(i).X,app.QRS(i).TS,app.QRS(i).Lead,BeatsMETADATA , [Ref1NSLoc,Ref2NSLoc]);
                    LeadSpecsControl2{i}.UpdateRef(Ref1Info,Ref2Info,Ref1UserName,Ref1QRSc,Ref1NS,Ref2UserName,Ref2QRSc,Ref2NS);
                end
                PlotTwin(app); % Plot secondory superimposed median beats.
            end
            app.CommentsTextArea.Value='';
            app.StatusLabel.FontColor=[0,1,0];
            app.QRSOnsetButton.Value=1;
            app.KeyCommand=0; % for keyboard shortcut
            app.KeyCommandLabel.Text="Tip: Select QRS Onset";
            app.QRSButton.Value=0;
            app.QTButton.Value=0;
            app.Gain2XSlider.Value=0;
            app.OrginalLimitV=[0,0];

            if app.LoadFullLeadsCheckBox.Value==1
                GUI_ECGLeadPlot (app.ECGLeadPlot,app.ECGFileSelector.Raw,app.PlotIdxes,1); % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            end

            YLoc=.95*app.ECGPlot.YLim;

            %% show Observers annotation in any and use

            if ~isempty(app.ECGFileSelector.Ref1Record)
                app.Observer1CommentsLabel.Text=strcat( "Comments by ", app.ECGFileSelector.REFName1,  ": ",app.ECGFileSelector.Ref1Record.Comment) ;
                app.Observer1QRSMorphologyLabel.Text=strcat( app.ECGFileSelector.REFName1,  ": ",app.ECGFileSelector.Ref1Record.QRSMorph) ;
                Ref1QRS=[app.ECGFileSelector.Ref1Record.Onset,app.ECGFileSelector.Ref1Record.Onset+app.ECGFileSelector.Ref1Record.QRSd,...
                    app.ECGFileSelector.Ref1Record.Onset+app.ECGFileSelector.Ref1Record.QTd];
                plot( app.ECGPlot,Ref1QRS,[YLoc(2),YLoc(2),YLoc(2)],'VG',DisplayName=app.ECGFileSelector.REFName1,LineWidth=3)
                UseREFSets(app, app.UseRef1CheckBox.Value, app.ECGFileSelector.Ref1Record.Onset,app.ECGFileSelector.Ref1Record.QRSd,app.ECGFileSelector.Ref1Record.QTd )
            else
                app.Observer1CommentsLabel.Text='';
                app.Observer1QRSMorphologyLabel.Text='';
            end
            if ~isempty(app.ECGFileSelector.Ref2Record)
                app.Observer2CommentsLabel.Text=strcat("Comments by ",app.ECGFileSelector.REFName2,  ": ",app.ECGFileSelector.Ref2Record.Comment) ;
                app.Observer2QRSMorphologyLabel.Text=strcat( app.ECGFileSelector.REFName2,  ": ",app.ECGFileSelector.Ref2Record.QRSMorph) ;
                Ref2QRS=[app.ECGFileSelector.Ref2Record.Onset,app.ECGFileSelector.Ref2Record.Onset+app.ECGFileSelector.Ref2Record.QRSd,...
                    app.ECGFileSelector.Ref2Record.Onset+app.ECGFileSelector.Ref2Record.QTd];
                plot( app.ECGPlot,Ref2QRS,[YLoc(1),YLoc(1),YLoc(1)],'^R',DisplayName=app.ECGFileSelector.REFName2,LineWidth=3) %***
                UseREFSets(app, app.UseRef2CheckBox.Value, app.ECGFileSelector.Ref2Record.Onset,app.ECGFileSelector.Ref2Record.QRSd,app.ECGFileSelector.Ref2Record.QTd )
            else
                app.Observer2CommentsLabel.Text='';
                app.Observer2QRSMorphologyLabel.Text='';
            end

            app.WaitImage.Visible="off";
            app.StatusLabel.Text='Ready!';

            % disabled feature to apply auto Rpeak for all 12 leads
            % if app.AutoRPeakCheckBox.Value==1
            %     AutoR_PeaksButtonPushed(app, event)  
            % end



        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            % to plot Full leads based on the selection of state buttons.
            BottomList={app.IButton,app.IIButton,app.IIIButton,app.aVRButton,app.aVLButton,app.aVFButton,app.V1Button,app.V2Button,app.V3Button,app.V4Button,app.V5Button,app.V6Button};
            app.PlotIdxes=[];
            for i=1:length(BottomList)
                if BottomList{i}.Value==1
                    app.PlotIdxes=[app.PlotIdxes,i];
                end
            end
            if isempty( app.PlotIdxes) % by default, Lead I will be selected.
                app.PlotIdxes= 1 ;
                app.IButton.Value=1;
            end
            GUI_ECGLeadPlot (app.ECGLeadPlot,app.ECGFileSelector.Raw,app.PlotIdxes,1);  
        end

        % Button pushed function: GoRightButton
        function GoRightButtonPushed(app, event)
            % For fine shifting boundries for Onset and offsets to the right. GoStep can be changed to change the jump.
            GoStep=2;
            if  app.KeyCommand ==0
                app.QRSOn = app.QRSOn+GoStep;
                app.QRSOnLine.Value=app.QRSOn;
                app.TwinQRSOnLine.Value=app.QRSOn;

            elseif  (   app.KeyCommand ==1)
                app.QRSOff =app.QRSOff+GoStep;
                app.QRSOFFLine.Value= app.QRSOff;
                app.TwinQRSOFFLine.Value= app.QRSOff; % if app.ShowTwin==1
            elseif   app.KeyCommand ==2
                app.QTOff = app.QTOff+GoStep;
                app.QTOffLine.Value= app.QTOff ;
                app.TwinQTOffLine.Value= app.QTOff ;
            end

            FillMiniSummary(app);
        end

        % Button pushed function: GoLeftButton
        function GoLeftButtonPushed(app, event)
            %For fine shifting boundries for Onset and offsets to the left. GoStep can be changed to change the jump.
            GoStep=2;
            if  app.KeyCommand ==0
                app.QRSOn = app.QRSOn-GoStep;
                app.QRSOnLine.Value=app.QRSOn;
                app.TwinQRSOnLine.Value=app.QRSOn;

            elseif  (   app.KeyCommand ==1)
                app.QRSOff =app.QRSOff-GoStep;
                app.QRSOFFLine.Value= app.QRSOff;
                app.TwinQRSOFFLine.Value= app.QRSOff; % if app.ShowTwin==1
            elseif   app.KeyCommand ==2
                app.QTOff = app.QTOff-GoStep;
                app.QTOffLine.Value= app.QTOff ;
                app.TwinQTOffLine.Value= app.QTOff ;
            end
            FillMiniSummary(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create CardioMarkV10UIFigure and hide until all components are created
            app.CardioMarkV10UIFigure = uifigure('Visible', 'off');
            app.CardioMarkV10UIFigure.Position = [60 50 1563 850];
            app.CardioMarkV10UIFigure.Name = 'CardioMark V1.0';
            app.CardioMarkV10UIFigure.Icon = fullfile(pathToMLAPP, 'resources', 'CardioMarkIcon.jpg');
            app.CardioMarkV10UIFigure.KeyPressFcn = createCallbackFcn(app, @CardioMarkV10UIFigureKeyPress, true);

            % Create SettingsPanel
            app.SettingsPanel = uipanel(app.CardioMarkV10UIFigure);
            app.SettingsPanel.BorderWidth = 2;
            app.SettingsPanel.Title = 'Settings';
            app.SettingsPanel.FontName = 'Arial';
            app.SettingsPanel.FontWeight = 'bold';
            app.SettingsPanel.FontSize = 10;
            app.SettingsPanel.Position = [1189 769 241 82];

            % Create LoadFullLeadsCheckBox
            app.LoadFullLeadsCheckBox = uicheckbox(app.SettingsPanel);
            app.LoadFullLeadsCheckBox.Visible = 'off';
            app.LoadFullLeadsCheckBox.Text = 'Load Full Leads';
            app.LoadFullLeadsCheckBox.FontName = 'Arial';
            app.LoadFullLeadsCheckBox.FontSize = 9;
            app.LoadFullLeadsCheckBox.Position = [132 13 129 15];

            % Create UseonsetoffsetfromLabel
            app.UseonsetoffsetfromLabel = uilabel(app.SettingsPanel);
            app.UseonsetoffsetfromLabel.FontName = 'Arial';
            app.UseonsetoffsetfromLabel.FontSize = 9;
            app.UseonsetoffsetfromLabel.Position = [4 45 99 15];
            app.UseonsetoffsetfromLabel.Text = 'Use onset & offset from';

            % Create SaveOnlyCompleteDataCheckBox
            app.SaveOnlyCompleteDataCheckBox = uicheckbox(app.SettingsPanel);
            app.SaveOnlyCompleteDataCheckBox.Text = 'Save Only Complete Data';
            app.SaveOnlyCompleteDataCheckBox.FontName = 'Arial';
            app.SaveOnlyCompleteDataCheckBox.FontSize = 9;
            app.SaveOnlyCompleteDataCheckBox.Position = [4 29 126 15];

            % Create UseRef1CheckBox
            app.UseRef1CheckBox = uicheckbox(app.SettingsPanel);
            app.UseRef1CheckBox.Text = 'Observer 1';
            app.UseRef1CheckBox.FontName = 'Arial';
            app.UseRef1CheckBox.FontSize = 9;
            app.UseRef1CheckBox.FontColor = [0.3922 0.8314 0.0745];
            app.UseRef1CheckBox.Position = [105 45 67 15];

            % Create UseRef2CheckBox
            app.UseRef2CheckBox = uicheckbox(app.SettingsPanel);
            app.UseRef2CheckBox.Text = 'Observer 2';
            app.UseRef2CheckBox.FontName = 'Arial';
            app.UseRef2CheckBox.FontSize = 9;
            app.UseRef2CheckBox.FontColor = [1 0 0];
            app.UseRef2CheckBox.Position = [174 45 67 15];

            % Create AutoRPeakCheckBox
            app.AutoRPeakCheckBox = uicheckbox(app.SettingsPanel);
            app.AutoRPeakCheckBox.Visible = 'off';
            app.AutoRPeakCheckBox.Text = 'Auto R Peak';
            app.AutoRPeakCheckBox.FontName = 'Arial';
            app.AutoRPeakCheckBox.FontSize = 9;
            app.AutoRPeakCheckBox.Position = [132 29 77 15];

            % Create ECGFileSelector
            app.ECGFileSelector = ECGFileSelector(app.CardioMarkV10UIFigure);
            app.ECGFileSelector.ECGFileExtension = 'HEA';
            app.ECGFileSelector.REFName1 = 'DrRef1';
            app.ECGFileSelector.REFName2 = 'DrRef2';
            app.ECGFileSelector.XMLisSelectedFcn = createCallbackFcn(app, @ECGFileisSelected, true);
            app.ECGFileSelector.Position = [3 1 228 847];

            % Create SaveButton
            app.SaveButton = uibutton(app.CardioMarkV10UIFigure, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.SaveButton.Icon = fullfile(pathToMLAPP, 'resources', 'SaveIcon.png');
            app.SaveButton.WordWrap = 'on';
            app.SaveButton.FontName = 'Arial';
            app.SaveButton.FontSize = 14;
            app.SaveButton.FontWeight = 'bold';
            app.SaveButton.Position = [234 817 109 31];
            app.SaveButton.Text = 'Save';

            % Create StatusLabel
            app.StatusLabel = uilabel(app.CardioMarkV10UIFigure);
            app.StatusLabel.HorizontalAlignment = 'center';
            app.StatusLabel.WordWrap = 'on';
            app.StatusLabel.FontName = 'Times New Roman';
            app.StatusLabel.FontSize = 13;
            app.StatusLabel.FontWeight = 'bold';
            app.StatusLabel.FontColor = [0.9294 0.6902 0.1294];
            app.StatusLabel.Position = [234 769 109 46];
            app.StatusLabel.Text = '-';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.CardioMarkV10UIFigure);
            app.TabGroup.Position = [230 4 1327 760];

            % Create SuperimposeTab
            app.SuperimposeTab = uitab(app.TabGroup);
            app.SuperimposeTab.Title = 'Superimpose';
            app.SuperimposeTab.ForegroundColor = [0.149 0.149 0.149];

            % Create ECGPlot
            app.ECGPlot = uiaxes(app.SuperimposeTab);
            title(app.ECGPlot, 'Main ECG View')
            xlabel(app.ECGPlot, 'ms')
            ylabel(app.ECGPlot, 'mV')
            zlabel(app.ECGPlot, 'Z')
            app.ECGPlot.FontName = 'Arial';
            app.ECGPlot.FontWeight = 'bold';
            app.ECGPlot.XTick = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
            app.ECGPlot.XMinorTick = 'on';
            app.ECGPlot.YMinorTick = 'on';
            app.ECGPlot.GridColor = [1 0 0];
            app.ECGPlot.YGrid = 'on';
            app.ECGPlot.FontSize = 10;
            app.ECGPlot.ButtonDownFcn = createCallbackFcn(app, @ECGPlotButtonDown, true);
            app.ECGPlot.Position = [1 62 660 589];

            % Create ECGPlot_2
            app.ECGPlot_2 = uiaxes(app.SuperimposeTab);
            title(app.ECGPlot_2, 'Secondary ECG')
            xlabel(app.ECGPlot_2, 'ms')
            ylabel(app.ECGPlot_2, 'mV')
            zlabel(app.ECGPlot_2, 'Z')
            app.ECGPlot_2.FontName = 'Arial';
            app.ECGPlot_2.FontWeight = 'bold';
            app.ECGPlot_2.XColor = [0 0 0];
            app.ECGPlot_2.XMinorTick = 'on';
            app.ECGPlot_2.YMinorTick = 'on';
            app.ECGPlot_2.GridColor = [1 0 0];
            app.ECGPlot_2.YGrid = 'on';
            app.ECGPlot_2.FontSize = 10;
            app.ECGPlot_2.Position = [663 62 660 589];

            % Create LeadsListBoxLabel
            app.LeadsListBoxLabel = uilabel(app.SuperimposeTab);
            app.LeadsListBoxLabel.HorizontalAlignment = 'right';
            app.LeadsListBoxLabel.WordWrap = 'on';
            app.LeadsListBoxLabel.FontName = 'Arial';
            app.LeadsListBoxLabel.FontSize = 10;
            app.LeadsListBoxLabel.FontWeight = 'bold';
            app.LeadsListBoxLabel.Position = [32 657 126 34];
            app.LeadsListBoxLabel.Text = 'Main View Superimposed Leads Selection';

            % Create BoundarySelectionButtonGroup
            app.BoundarySelectionButtonGroup = uibuttongroup(app.SuperimposeTab);
            app.BoundarySelectionButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @BoundarySelectionButtonGroupSelectionChanged, true);
            app.BoundarySelectionButtonGroup.BorderWidth = 2;
            app.BoundarySelectionButtonGroup.TitlePosition = 'centertop';
            app.BoundarySelectionButtonGroup.Title = 'Boundary Selection';
            app.BoundarySelectionButtonGroup.FontName = 'Arial';
            app.BoundarySelectionButtonGroup.FontWeight = 'bold';
            app.BoundarySelectionButtonGroup.FontSize = 10;
            app.BoundarySelectionButtonGroup.Position = [230 656 228 77];

            % Create QRSOnsetButton
            app.QRSOnsetButton = uiradiobutton(app.BoundarySelectionButtonGroup);
            app.QRSOnsetButton.Text = 'QRS Onset';
            app.QRSOnsetButton.FontName = 'Arial';
            app.QRSOnsetButton.FontSize = 10;
            app.QRSOnsetButton.FontWeight = 'bold';
            app.QRSOnsetButton.FontColor = [0 0 1];
            app.QRSOnsetButton.Position = [11 32 75 22];
            app.QRSOnsetButton.Value = true;

            % Create QRSOffsetButton
            app.QRSOffsetButton = uiradiobutton(app.BoundarySelectionButtonGroup);
            app.QRSOffsetButton.Text = 'QRS Offset';
            app.QRSOffsetButton.FontName = 'Arial';
            app.QRSOffsetButton.FontSize = 10;
            app.QRSOffsetButton.FontWeight = 'bold';
            app.QRSOffsetButton.FontColor = [0 1 0];
            app.QRSOffsetButton.Position = [90 32 75 22];

            % Create TOffsetButton
            app.TOffsetButton = uiradiobutton(app.BoundarySelectionButtonGroup);
            app.TOffsetButton.Text = 'T Offset';
            app.TOffsetButton.FontName = 'Arial';
            app.TOffsetButton.FontSize = 10;
            app.TOffsetButton.FontWeight = 'bold';
            app.TOffsetButton.FontColor = [1 0 1];
            app.TOffsetButton.Position = [169 32 60 22];

            % Create GoLeftButton
            app.GoLeftButton = uibutton(app.BoundarySelectionButtonGroup, 'push');
            app.GoLeftButton.ButtonPushedFcn = createCallbackFcn(app, @GoLeftButtonPushed, true);
            app.GoLeftButton.FontName = 'Arial';
            app.GoLeftButton.FontWeight = 'bold';
            app.GoLeftButton.Tooltip = {'Fine Adjusting to Left'};
            app.GoLeftButton.Position = [60 5 53 25];
            app.GoLeftButton.Text = '<<';

            % Create GoRightButton
            app.GoRightButton = uibutton(app.BoundarySelectionButtonGroup, 'push');
            app.GoRightButton.ButtonPushedFcn = createCallbackFcn(app, @GoRightButtonPushed, true);
            app.GoRightButton.FontName = 'Arial';
            app.GoRightButton.FontWeight = 'bold';
            app.GoRightButton.Tooltip = {'Fine Adjusting to Right'};
            app.GoRightButton.Position = [116 5 53 25];
            app.GoRightButton.Text = '>>';

            % Create QRSButton
            app.QRSButton = uibutton(app.SuperimposeTab, 'state');
            app.QRSButton.ValueChangedFcn = createCallbackFcn(app, @QRSButtonValueChanged, true);
            app.QRSButton.Icon = fullfile(pathToMLAPP, 'resources', 'OIP.jpg');
            app.QRSButton.Text = 'QRS';
            app.QRSButton.FontName = 'Arial';
            app.QRSButton.FontSize = 10;
            app.QRSButton.FontWeight = 'bold';
            app.QRSButton.Position = [460 657 66 34];

            % Create LeadsSelectListBox
            app.LeadsSelectListBox = uilistbox(app.SuperimposeTab);
            app.LeadsSelectListBox.Items = {'Limb', 'Chest'};
            app.LeadsSelectListBox.Interruptible = 'off';
            app.LeadsSelectListBox.FontName = 'Arial';
            app.LeadsSelectListBox.FontSize = 10;
            app.LeadsSelectListBox.FontWeight = 'bold';
            app.LeadsSelectListBox.ClickedFcn = createCallbackFcn(app, @LeadsListBoxClicked, true);
            app.LeadsSelectListBox.Position = [163 657 61 34];
            app.LeadsSelectListBox.Value = 'Limb';

            % Create QTButton
            app.QTButton = uibutton(app.SuperimposeTab, 'state');
            app.QTButton.ValueChangedFcn = createCallbackFcn(app, @QTButtonValueChanged, true);
            app.QTButton.Icon = fullfile(pathToMLAPP, 'resources', 'OIP.jpg');
            app.QTButton.Text = 'QT';
            app.QTButton.FontName = 'Arial';
            app.QTButton.FontSize = 10;
            app.QTButton.FontWeight = 'bold';
            app.QTButton.Position = [460 697 66 34];

            % Create LimitEditField
            app.LimitEditField = uieditfield(app.SuperimposeTab, 'numeric');
            app.LimitEditField.Limits = [0 100];
            app.LimitEditField.ValueDisplayFormat = '%11.4g%%';
            app.LimitEditField.HorizontalAlignment = 'center';
            app.LimitEditField.Visible = 'off';
            app.LimitEditField.Position = [474 637 32 17];
            app.LimitEditField.Value = 5;

            % Create NextButton
            app.NextButton = uibutton(app.SuperimposeTab, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.FontName = 'Arial';
            app.NextButton.FontSize = 10;
            app.NextButton.Position = [599 709 55 23];
            app.NextButton.Text = 'Next';

            % Create SecondaryAxisPlotLabel
            app.SecondaryAxisPlotLabel = uilabel(app.SuperimposeTab);
            app.SecondaryAxisPlotLabel.HorizontalAlignment = 'right';
            app.SecondaryAxisPlotLabel.FontName = 'Arial';
            app.SecondaryAxisPlotLabel.FontWeight = 'bold';
            app.SecondaryAxisPlotLabel.Position = [681 657 121 22];
            app.SecondaryAxisPlotLabel.Text = 'Secondary Axis Plot';

            % Create TwinLeadDropDown
            app.TwinLeadDropDown = uidropdown(app.SuperimposeTab);
            app.TwinLeadDropDown.Items = {'Limb', 'Chest', 'I', 'II', 'III', 'aVR', 'aVL', 'aVF', 'V1', 'V2', 'V3', 'V4', 'V5', 'V6'};
            app.TwinLeadDropDown.ValueChangedFcn = createCallbackFcn(app, @TwinLeadDropDownValueChanged, true);
            app.TwinLeadDropDown.FontName = 'Arial';
            app.TwinLeadDropDown.Position = [804 657 100 22];
            app.TwinLeadDropDown.Value = 'Chest';

            % Create KeyCommandLabel
            app.KeyCommandLabel = uilabel(app.SuperimposeTab);
            app.KeyCommandLabel.WordWrap = 'on';
            app.KeyCommandLabel.FontSize = 14;
            app.KeyCommandLabel.FontWeight = 'bold';
            app.KeyCommandLabel.FontColor = [1 0.4118 0.1608];
            app.KeyCommandLabel.Position = [12 4 310 52];
            app.KeyCommandLabel.Text = '';

            % Create LegendButton
            app.LegendButton = uibutton(app.SuperimposeTab, 'state');
            app.LegendButton.Text = 'Legend';
            app.LegendButton.FontName = 'Arial';
            app.LegendButton.FontSize = 10;
            app.LegendButton.FontWeight = 'bold';
            app.LegendButton.Position = [599 656 55 23];

            % Create WaitImage
            app.WaitImage = uiimage(app.SuperimposeTab);
            app.WaitImage.Enable = 'off';
            app.WaitImage.Visible = 'off';
            app.WaitImage.Tooltip = {'Just Wait :)'};
            app.WaitImage.Position = [340 91 696 547];
            app.WaitImage.ImageSource = fullfile(pathToMLAPP, 'resources', 'dribbble-wait.gif');

            % Create RefreshButton
            app.RefreshButton = uibutton(app.SuperimposeTab, 'push');
            app.RefreshButton.ButtonPushedFcn = createCallbackFcn(app, @RefreshButtonPushed2, true);
            app.RefreshButton.FontSize = 10;
            app.RefreshButton.Visible = 'off';
            app.RefreshButton.Position = [663 709 55 23];
            app.RefreshButton.Text = 'Refresh';

            % Create AutoR_PeaksButton
            app.AutoR_PeaksButton = uibutton(app.SuperimposeTab, 'push');
            app.AutoR_PeaksButton.ButtonPushedFcn = createCallbackFcn(app, @AutoR_PeaksButtonPushed, true);
            app.AutoR_PeaksButton.FontName = 'Arial';
            app.AutoR_PeaksButton.FontSize = 10;
            app.AutoR_PeaksButton.FontWeight = 'bold';
            app.AutoR_PeaksButton.Visible = 'off';
            app.AutoR_PeaksButton.Position = [800 706 55 23];
            app.AutoR_PeaksButton.Text = 'Auto R_Peaks';

            % Create Gain2XSlider
            app.Gain2XSlider = uislider(app.SuperimposeTab);
            app.Gain2XSlider.Limits = [-2 4];
            app.Gain2XSlider.MajorTicks = [-2 -1 0 1 2 3 4];
            app.Gain2XSlider.MajorTickLabels = {'-2', '-1', '0', '1', '2', '3', '4', '5'};
            app.Gain2XSlider.Orientation = 'vertical';
            app.Gain2XSlider.ValueChangedFcn = createCallbackFcn(app, @Gain2XSliderValueChanged, true);
            app.Gain2XSlider.MinorTicks = [-2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5];
            app.Gain2XSlider.FontName = 'Arial';
            app.Gain2XSlider.FontSize = 10;
            app.Gain2XSlider.FontWeight = 'bold';
            app.Gain2XSlider.FontColor = [0 0 1];
            app.Gain2XSlider.Position = [543 646 13 67];

            % Create Gain2XSliderLabel
            app.Gain2XSliderLabel = uilabel(app.SuperimposeTab);
            app.Gain2XSliderLabel.HorizontalAlignment = 'center';
            app.Gain2XSliderLabel.FontName = 'Arial';
            app.Gain2XSliderLabel.FontSize = 10;
            app.Gain2XSliderLabel.FontWeight = 'bold';
            app.Gain2XSliderLabel.FontColor = [0 0 1];
            app.Gain2XSliderLabel.Position = [533 721 51 10];
            app.Gain2XSliderLabel.Text = 'Gain 2^X';

            % Create KeyCommandLabel_2
            app.KeyCommandLabel_2 = uilabel(app.SuperimposeTab);
            app.KeyCommandLabel_2.VerticalAlignment = 'top';
            app.KeyCommandLabel_2.WordWrap = 'on';
            app.KeyCommandLabel_2.FontSize = 14;
            app.KeyCommandLabel_2.FontWeight = 'bold';
            app.KeyCommandLabel_2.FontColor = [0.9294 0.6941 0.1255];
            app.KeyCommandLabel_2.Position = [1059 4 264 52];
            app.KeyCommandLabel_2.Text = {'Press ''s'' or 1 for selecting QRS Onset.'; 'Press ''e'' or 2 for selecting QRS Offset.'; 'Press ''t'' or 3 for Selecting T Offset.'};

            % Create LimbLeadsTab
            app.LimbLeadsTab = uitab(app.TabGroup);
            app.LimbLeadsTab.Title = 'Limb Leads';
            app.LimbLeadsTab.ButtonDownFcn = createCallbackFcn(app, @LimbLeadsTabButtonDown, true);

            % Create I
            app.I = MedianBeat_Config(app.LimbLeadsTab);
            app.I.Position = [5 374 440 358];

            % Create II
            app.II = MedianBeat_Config(app.LimbLeadsTab);
            app.II.Position = [447 374 440 358];

            % Create III
            app.III = MedianBeat_Config(app.LimbLeadsTab);
            app.III.Position = [889 374 440 358];

            % Create aVR
            app.aVR = MedianBeat_Config(app.LimbLeadsTab);
            app.aVR.Position = [5 14 440 358];

            % Create aVL
            app.aVL = MedianBeat_Config(app.LimbLeadsTab);
            app.aVL.Position = [447 14 440 358];

            % Create aVF
            app.aVF = MedianBeat_Config(app.LimbLeadsTab);
            app.aVF.Position = [889 14 440 358];

            % Create NextButton_2
            app.NextButton_2 = uibutton(app.LimbLeadsTab, 'push');
            app.NextButton_2.ButtonPushedFcn = createCallbackFcn(app, @NextButton_2Pushed, true);
            app.NextButton_2.FontName = 'Arial';
            app.NextButton_2.FontSize = 10;
            app.NextButton_2.Position = [457 739 40 19];
            app.NextButton_2.Text = 'Next';

            % Create ChestLeadsTab
            app.ChestLeadsTab = uitab(app.TabGroup);
            app.ChestLeadsTab.Title = 'Chest Leads';

            % Create V1
            app.V1 = MedianBeat_Config(app.ChestLeadsTab);
            app.V1.Position = [5 374 440 358];

            % Create V2
            app.V2 = MedianBeat_Config(app.ChestLeadsTab);
            app.V2.Position = [447 374 440 358];

            % Create V3
            app.V3 = MedianBeat_Config(app.ChestLeadsTab);
            app.V3.Position = [889 374 440 358];

            % Create V4
            app.V4 = MedianBeat_Config(app.ChestLeadsTab);
            app.V4.Position = [5 14 440 358];

            % Create V5
            app.V5 = MedianBeat_Config(app.ChestLeadsTab);
            app.V5.Position = [447 14 440 358];

            % Create V6
            app.V6 = MedianBeat_Config(app.ChestLeadsTab);
            app.V6.Position = [889 14 440 358];

            % Create NextButton_3
            app.NextButton_3 = uibutton(app.ChestLeadsTab, 'push');
            app.NextButton_3.ButtonPushedFcn = createCallbackFcn(app, @NextButton_3Pushed, true);
            app.NextButton_3.FontName = 'Arial';
            app.NextButton_3.FontSize = 10;
            app.NextButton_3.Position = [457 739 40 19];
            app.NextButton_3.Text = 'Next';

            % Create FullLeadsTab
            app.FullLeadsTab = uitab(app.TabGroup);
            app.FullLeadsTab.Title = 'Full Leads';

            % Create ECGLeadPlot
            app.ECGLeadPlot = uiaxes(app.FullLeadsTab);
            title(app.ECGLeadPlot, 'ECG')
            xlabel(app.ECGLeadPlot, 'ms')
            ylabel(app.ECGLeadPlot, 'mV')
            zlabel(app.ECGLeadPlot, 'Z')
            app.ECGLeadPlot.FontName = 'Times New Roman';
            app.ECGLeadPlot.FontWeight = 'bold';
            app.ECGLeadPlot.XMinorTick = 'on';
            app.ECGLeadPlot.YMinorTick = 'on';
            app.ECGLeadPlot.GridColor = [1 0 0];
            app.ECGLeadPlot.YGrid = 'on';
            app.ECGLeadPlot.FontSize = 10;
            app.ECGLeadPlot.Position = [4 55 1316 591];

            % Create LeadsforPlotPanel
            app.LeadsforPlotPanel = uipanel(app.FullLeadsTab);
            app.LeadsforPlotPanel.TitlePosition = 'centertop';
            app.LeadsforPlotPanel.Title = 'Leads for Plot';
            app.LeadsforPlotPanel.FontWeight = 'bold';
            app.LeadsforPlotPanel.Position = [479 651 351 80];

            % Create IButton
            app.IButton = uibutton(app.LeadsforPlotPanel, 'state');
            app.IButton.Text = 'I';
            app.IButton.FontName = 'Arial';
            app.IButton.FontWeight = 'bold';
            app.IButton.Position = [11 31 36 23];
            app.IButton.Value = true;

            % Create V1Button
            app.V1Button = uibutton(app.LeadsforPlotPanel, 'state');
            app.V1Button.Text = 'V1';
            app.V1Button.FontName = 'Arial';
            app.V1Button.FontWeight = 'bold';
            app.V1Button.Position = [140 31 36 23];

            % Create IIButton
            app.IIButton = uibutton(app.LeadsforPlotPanel, 'state');
            app.IIButton.Text = 'II';
            app.IIButton.FontName = 'Arial';
            app.IIButton.FontWeight = 'bold';
            app.IIButton.Position = [52 31 36 23];

            % Create IIIButton
            app.IIIButton = uibutton(app.LeadsforPlotPanel, 'state');
            app.IIIButton.Text = 'III';
            app.IIIButton.FontName = 'Arial';
            app.IIIButton.FontWeight = 'bold';
            app.IIIButton.Position = [93 31 36 23];

            % Create aVRButton
            app.aVRButton = uibutton(app.LeadsforPlotPanel, 'state');
            app.aVRButton.Text = 'aVR';
            app.aVRButton.FontName = 'Arial';
            app.aVRButton.FontWeight = 'bold';
            app.aVRButton.Position = [11 3 36 23];

            % Create aVLButton
            app.aVLButton = uibutton(app.LeadsforPlotPanel, 'state');
            app.aVLButton.Text = 'aVL';
            app.aVLButton.FontName = 'Arial';
            app.aVLButton.FontWeight = 'bold';
            app.aVLButton.Position = [52 3 36 23];

            % Create aVFButton
            app.aVFButton = uibutton(app.LeadsforPlotPanel, 'state');
            app.aVFButton.Text = 'aVF';
            app.aVFButton.FontName = 'Arial';
            app.aVFButton.FontWeight = 'bold';
            app.aVFButton.Position = [93 3 36 23];

            % Create V2Button
            app.V2Button = uibutton(app.LeadsforPlotPanel, 'state');
            app.V2Button.Text = 'V2';
            app.V2Button.FontName = 'Arial';
            app.V2Button.FontWeight = 'bold';
            app.V2Button.Position = [181 31 36 23];

            % Create V3Button
            app.V3Button = uibutton(app.LeadsforPlotPanel, 'state');
            app.V3Button.Text = 'V3';
            app.V3Button.FontName = 'Arial';
            app.V3Button.FontWeight = 'bold';
            app.V3Button.Position = [222 31 36 23];

            % Create V4Button
            app.V4Button = uibutton(app.LeadsforPlotPanel, 'state');
            app.V4Button.Text = 'V4';
            app.V4Button.FontName = 'Arial';
            app.V4Button.FontWeight = 'bold';
            app.V4Button.Position = [140 3 36 23];

            % Create V5Button
            app.V5Button = uibutton(app.LeadsforPlotPanel, 'state');
            app.V5Button.Text = 'V5';
            app.V5Button.FontName = 'Arial';
            app.V5Button.FontWeight = 'bold';
            app.V5Button.Position = [181 3 36 23];

            % Create V6Button
            app.V6Button = uibutton(app.LeadsforPlotPanel, 'state');
            app.V6Button.Text = 'V6';
            app.V6Button.FontName = 'Arial';
            app.V6Button.FontWeight = 'bold';
            app.V6Button.Position = [222 3 36 23];

            % Create PlotButton
            app.PlotButton = uibutton(app.LeadsforPlotPanel, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [269 6 70 48];
            app.PlotButton.Text = 'Plot';

            % Create MeasurmentsmsPanel
            app.MeasurmentsmsPanel = uipanel(app.CardioMarkV10UIFigure);
            app.MeasurmentsmsPanel.BorderWidth = 2;
            app.MeasurmentsmsPanel.Title = 'Measurments ms';
            app.MeasurmentsmsPanel.FontName = 'Arial';
            app.MeasurmentsmsPanel.FontWeight = 'bold';
            app.MeasurmentsmsPanel.FontSize = 10;
            app.MeasurmentsmsPanel.Position = [518 769 244 82];

            % Create QRSonLabel
            app.QRSonLabel = uilabel(app.MeasurmentsmsPanel);
            app.QRSonLabel.HorizontalAlignment = 'center';
            app.QRSonLabel.FontName = 'Arial';
            app.QRSonLabel.FontSize = 10;
            app.QRSonLabel.FontWeight = 'bold';
            app.QRSonLabel.FontColor = [0 0 1];
            app.QRSonLabel.Position = [3 45 46 15];
            app.QRSonLabel.Text = 'QRSon';

            % Create QRSoffLabel
            app.QRSoffLabel = uilabel(app.MeasurmentsmsPanel);
            app.QRSoffLabel.HorizontalAlignment = 'center';
            app.QRSoffLabel.FontName = 'Arial';
            app.QRSoffLabel.FontSize = 10;
            app.QRSoffLabel.FontWeight = 'bold';
            app.QRSoffLabel.FontColor = [0 1 0];
            app.QRSoffLabel.Position = [51 45 46 15];
            app.QRSoffLabel.Text = 'QRSoff';

            % Create QRSdLabel_2
            app.QRSdLabel_2 = uilabel(app.MeasurmentsmsPanel);
            app.QRSdLabel_2.HorizontalAlignment = 'center';
            app.QRSdLabel_2.FontName = 'Arial';
            app.QRSdLabel_2.FontSize = 10;
            app.QRSdLabel_2.FontWeight = 'bold';
            app.QRSdLabel_2.Position = [99 45 46 15];
            app.QRSdLabel_2.Text = 'QRSd';

            % Create ToffLabel
            app.ToffLabel = uilabel(app.MeasurmentsmsPanel);
            app.ToffLabel.HorizontalAlignment = 'center';
            app.ToffLabel.FontName = 'Arial';
            app.ToffLabel.FontSize = 10;
            app.ToffLabel.FontWeight = 'bold';
            app.ToffLabel.FontColor = [1 0 1];
            app.ToffLabel.Position = [147 45 46 15];
            app.ToffLabel.Text = 'Toff';

            % Create QTLabel
            app.QTLabel = uilabel(app.MeasurmentsmsPanel);
            app.QTLabel.HorizontalAlignment = 'center';
            app.QTLabel.FontName = 'Arial';
            app.QTLabel.FontSize = 10;
            app.QTLabel.FontWeight = 'bold';
            app.QTLabel.Position = [195 45 46 15];
            app.QTLabel.Text = 'QT';

            % Create Label_5
            app.Label_5 = uilabel(app.MeasurmentsmsPanel);
            app.Label_5.HorizontalAlignment = 'center';
            app.Label_5.FontName = 'Arial';
            app.Label_5.FontSize = 10;
            app.Label_5.FontWeight = 'bold';
            app.Label_5.FontColor = [0 0 1];
            app.Label_5.Position = [3 22 46 22];
            app.Label_5.Text = '-';

            % Create Label_4
            app.Label_4 = uilabel(app.MeasurmentsmsPanel);
            app.Label_4.HorizontalAlignment = 'center';
            app.Label_4.FontName = 'Arial';
            app.Label_4.FontSize = 10;
            app.Label_4.FontWeight = 'bold';
            app.Label_4.FontColor = [0 1 0];
            app.Label_4.Position = [51 22 46 22];
            app.Label_4.Text = '-';

            % Create Label_3
            app.Label_3 = uilabel(app.MeasurmentsmsPanel);
            app.Label_3.HorizontalAlignment = 'center';
            app.Label_3.FontName = 'Arial';
            app.Label_3.FontSize = 10;
            app.Label_3.FontWeight = 'bold';
            app.Label_3.Position = [99 22 46 22];
            app.Label_3.Text = '-';

            % Create Label_2
            app.Label_2 = uilabel(app.MeasurmentsmsPanel);
            app.Label_2.HorizontalAlignment = 'center';
            app.Label_2.FontName = 'Arial';
            app.Label_2.FontSize = 10;
            app.Label_2.FontWeight = 'bold';
            app.Label_2.FontColor = [1 0 1];
            app.Label_2.Position = [147 22 46 22];
            app.Label_2.Text = '-';

            % Create Label
            app.Label = uilabel(app.MeasurmentsmsPanel);
            app.Label.HorizontalAlignment = 'center';
            app.Label.FontName = 'Arial';
            app.Label.FontSize = 10;
            app.Label.FontWeight = 'bold';
            app.Label.Position = [195 22 46 22];
            app.Label.Text = '-';

            % Create CommentsPanel
            app.CommentsPanel = uipanel(app.CardioMarkV10UIFigure);
            app.CommentsPanel.BorderWidth = 2;
            app.CommentsPanel.Title = 'Comments';
            app.CommentsPanel.FontName = 'Arial';
            app.CommentsPanel.FontWeight = 'bold';
            app.CommentsPanel.FontSize = 10;
            app.CommentsPanel.Position = [765 769 421 82];

            % Create CommentsTextArea
            app.CommentsTextArea = uitextarea(app.CommentsPanel);
            app.CommentsTextArea.FontName = 'Arial';
            app.CommentsTextArea.FontSize = 10;
            app.CommentsTextArea.FontWeight = 'bold';
            app.CommentsTextArea.Tooltip = {'Comments by the user'};
            app.CommentsTextArea.Placeholder = 'Any Thoughts';
            app.CommentsTextArea.Position = [4 2 154 58];

            % Create Observer1CommentsLabel
            app.Observer1CommentsLabel = uilabel(app.CommentsPanel);
            app.Observer1CommentsLabel.VerticalAlignment = 'top';
            app.Observer1CommentsLabel.WordWrap = 'on';
            app.Observer1CommentsLabel.FontName = 'Arial';
            app.Observer1CommentsLabel.FontSize = 10;
            app.Observer1CommentsLabel.FontWeight = 'bold';
            app.Observer1CommentsLabel.FontAngle = 'italic';
            app.Observer1CommentsLabel.FontColor = [0.3922 0.8314 0.0745];
            app.Observer1CommentsLabel.Tooltip = {'Comments by Observer 1'};
            app.Observer1CommentsLabel.Position = [160 2 129 58];
            app.Observer1CommentsLabel.Text = 'Observer 1 Comments';

            % Create Observer2CommentsLabel
            app.Observer2CommentsLabel = uilabel(app.CommentsPanel);
            app.Observer2CommentsLabel.VerticalAlignment = 'top';
            app.Observer2CommentsLabel.WordWrap = 'on';
            app.Observer2CommentsLabel.FontName = 'Arial';
            app.Observer2CommentsLabel.FontSize = 10;
            app.Observer2CommentsLabel.FontWeight = 'bold';
            app.Observer2CommentsLabel.FontAngle = 'italic';
            app.Observer2CommentsLabel.FontColor = [1 0 0];
            app.Observer2CommentsLabel.Tooltip = {'Comments by Observer 2'};
            app.Observer2CommentsLabel.Position = [291 2 129 58];
            app.Observer2CommentsLabel.Text = 'Observer 2 Comments';

            % Create QRSMorphologyPanel
            app.QRSMorphologyPanel = uipanel(app.CardioMarkV10UIFigure);
            app.QRSMorphologyPanel.BorderWidth = 2;
            app.QRSMorphologyPanel.Title = 'QRS Morphology ';
            app.QRSMorphologyPanel.FontName = 'Arial';
            app.QRSMorphologyPanel.FontWeight = 'bold';
            app.QRSMorphologyPanel.FontSize = 10;
            app.QRSMorphologyPanel.Position = [348 769 167 82];

            % Create QRSMorphologyDropDown
            app.QRSMorphologyDropDown = uidropdown(app.QRSMorphologyPanel);
            app.QRSMorphologyDropDown.Items = {'Not Selected', 'Normal', 'LBBB-type', 'RBBB-type', 'IVCD', 'Paced', 'Others', '-'};
            app.QRSMorphologyDropDown.FontName = 'Arial';
            app.QRSMorphologyDropDown.FontSize = 10;
            app.QRSMorphologyDropDown.FontWeight = 'bold';
            app.QRSMorphologyDropDown.Position = [6 38 154 22];
            app.QRSMorphologyDropDown.Value = 'Not Selected';

            % Create Observer1QRSMorphologyLabel
            app.Observer1QRSMorphologyLabel = uilabel(app.QRSMorphologyPanel);
            app.Observer1QRSMorphologyLabel.HorizontalAlignment = 'center';
            app.Observer1QRSMorphologyLabel.WordWrap = 'on';
            app.Observer1QRSMorphologyLabel.FontName = 'Arial';
            app.Observer1QRSMorphologyLabel.FontSize = 10;
            app.Observer1QRSMorphologyLabel.FontWeight = 'bold';
            app.Observer1QRSMorphologyLabel.FontAngle = 'italic';
            app.Observer1QRSMorphologyLabel.FontColor = [0.3922 0.8314 0.0745];
            app.Observer1QRSMorphologyLabel.Position = [9 21 148 16];
            app.Observer1QRSMorphologyLabel.Text = 'Observer 1 QRS Morphology ';

            % Create Observer2QRSMorphologyLabel
            app.Observer2QRSMorphologyLabel = uilabel(app.QRSMorphologyPanel);
            app.Observer2QRSMorphologyLabel.HorizontalAlignment = 'center';
            app.Observer2QRSMorphologyLabel.WordWrap = 'on';
            app.Observer2QRSMorphologyLabel.FontName = 'Arial';
            app.Observer2QRSMorphologyLabel.FontSize = 10;
            app.Observer2QRSMorphologyLabel.FontWeight = 'bold';
            app.Observer2QRSMorphologyLabel.FontAngle = 'italic';
            app.Observer2QRSMorphologyLabel.FontColor = [1 0 0];
            app.Observer2QRSMorphologyLabel.Position = [9 4 148 16];
            app.Observer2QRSMorphologyLabel.Text = 'Observer 2 QRS Morphology ';

            % Create HelpButton
            app.HelpButton = uibutton(app.CardioMarkV10UIFigure, 'push');
            app.HelpButton.ButtonPushedFcn = createCallbackFcn(app, @HelpHelpButtonValueChanged, true);
            app.HelpButton.FontName = 'Arial';
            app.HelpButton.FontSize = 48;
            app.HelpButton.FontColor = [1 0 0];
            app.HelpButton.Position = [1502 769 57 82];
            app.HelpButton.Text = '?';

            % Show the figure after all components are created
            app.CardioMarkV10UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = CardioMark_exported

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.CardioMarkV10UIFigure)

                % Execute the startup function
                runStartupFcn(app, @startupFcn)
            else

                % Focus the running singleton app
                figure(runningApp.CardioMarkV10UIFigure)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.CardioMarkV10UIFigure)
        end
    end
end