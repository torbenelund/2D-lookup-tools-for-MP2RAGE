classdef UNIDSR9ex < matlab.apps.AppBase
    % MSV: we are aware that this app, based on an export from the App
    % Designer of MATLAB R2023b may have backward compatibility issues. We
    % have identified a few re. R2022a. You are welcome to report other
    % backward compatibility issues to me.
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        GridLayout             matlab.ui.container.GridLayout
        LeftPanel              matlab.ui.container.Panel
        CLampLabel             matlab.ui.control.Label
        CLamp                  matlab.ui.control.Lamp
        MessagesTextArea       matlab.ui.control.TextArea
        MessagesTextAreaLabel  matlab.ui.control.Label
        SNRtestsKnobLabel      matlab.ui.control.Label
        SNRKnobLabel           matlab.ui.control.Label
        SNRtestsKnob           matlab.ui.control.DiscreteKnob
        SNRKnob                matlab.ui.control.Knob
        SNRLabel               matlab.ui.control.Label
        B1testsKnobLabel       matlab.ui.control.Label
        B1inhomogeneityLabel   matlab.ui.control.Label
        B1testsKnob            matlab.ui.control.DiscreteKnob
        B1inhomogeneityKnob    matlab.ui.control.Knob
        B1Label                matlab.ui.control.Label
        SampDensKnobLabel      matlab.ui.control.Label
        MaxKnobLabel           matlab.ui.control.Label
        B0TDropDown            matlab.ui.control.DropDown
        SampDensKnob           matlab.ui.control.Knob
        MaxKnob                matlab.ui.control.Knob
        B0TDropDownLabel       matlab.ui.control.Label
        PlotSwitch             matlab.ui.control.ToggleSwitch
        PlotSwitchLabel        matlab.ui.control.Label
        FatNavsDurSpinner      matlab.ui.control.Spinner
        FatNavsDelaymsSpinner  matlab.ui.control.Spinner
        FatNavsSwitch          matlab.ui.control.ToggleSwitch
        DurmsLabel             matlab.ui.control.Label
        DurmsLabel_2           matlab.ui.control.Label
        FatNavsSwitchLabel     matlab.ui.control.Label
        TCminmsSpinner         matlab.ui.control.Spinner
        TCminmsSpinnerLabel    matlab.ui.control.Label
        TBminmsSpinner         matlab.ui.control.Spinner
        TBminmsSpinnerLabel    matlab.ui.control.Label
        PFSpinner              matlab.ui.control.Spinner
        PFSpinnerLabel         matlab.ui.control.Label
        TAminmsSpinner         matlab.ui.control.Spinner
        TAminmsSpinnerLabel    matlab.ui.control.Label
        InvEffSpinner          matlab.ui.control.Spinner
        InvEffSpinnerLabel     matlab.ui.control.Label
        TRsSpinner             matlab.ui.control.Spinner
        TRsSpinnerLabel        matlab.ui.control.Label
        NslicesSpinner         matlab.ui.control.Spinner
        NslicesSpinnerLabel    matlab.ui.control.Label
        ESmsSpinner            matlab.ui.control.Spinner
        ESmsSpinnerLabel       matlab.ui.control.Label
        FA2degSpinner          matlab.ui.control.Spinner
        FA2degSpinnerLabel     matlab.ui.control.Label
        TI2sSpinner            matlab.ui.control.Spinner
        TI2sSpinnerLabel       matlab.ui.control.Label
        FA1degSpinner          matlab.ui.control.Spinner
        FA1degSpinnerLabel     matlab.ui.control.Label
        TI1sSpinner            matlab.ui.control.Spinner
        TI1sSpinnerLabel       matlab.ui.control.Label
        ParametersLabel        matlab.ui.control.Label
        LoadPresetButton       matlab.ui.control.Button
        SavePresetButton       matlab.ui.control.Button
        PresetsListBox         matlab.ui.control.ListBox
        PresetsListBoxLabel    matlab.ui.control.Label
        RightPanel             matlab.ui.container.Panel
        GridLayout2            matlab.ui.container.GridLayout
        UIAxes4                matlab.ui.control.UIAxes
        UIAxes3                matlab.ui.control.UIAxes
        UIAxes5                matlab.ui.control.UIAxes
        UIAxes2                matlab.ui.control.UIAxes
        UIAxes                 matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end


    properties (Access = private)
        File;
        FullFileName;
        Fileext;
        PresetIndex = 0;
        Check
        C1
        C2 
        C3
        t_Inv
        
        t_I1l
        t_I1c
        t_I1r

        t_I2l
        t_I2c
        t_I2r
        t_TR

        t_TAl
        t_TAr
        t_TBl
        t_TBr
t_TCl
        t_TCr
        t_Delayl
        t_Delayr

        t_FNl
        t_FNr
    end

    methods (Access = private)

        function UpdateMessage(app,NewMessage)
            OldText = app.MessagesTextArea.Value;

            if strcmp(NewMessage,OldText{1})

            else

                NewText = [NewMessage;OldText];
                if size(NewText,1) > 50
                    NewText(50:end,:) = [];
                end
                app.MessagesTextArea.Value = NewText;

            end


        end

        function SanityCheck(app)
            

            if app.t_I1l <= app.t_Inv
                C1 = 2; %#ok<*ADPROP>
                app.C1 = true;
            elseif  app.t_I1l <= app.t_Inv + app.TAminmsSpinner.Value/1000
                C1 = 1;
                app.C1 = true;
            else
                C1 = 0;
                
            end
            if app.t_I2l <= app.t_I1r
                C2 = 2;
                app.C2 = true;
            elseif  app.t_I2l <= app.t_I1r + app.TBminmsSpinner.Value/1000
                C2 = 1;
                app.C2 = true;
                
            else
                C2 = 0;
            end

            switch app.FatNavsSwitch.Value
                case 'On'
                    if app.t_TR <= app.t_I2r + app.FatNavsDurSpinner.Value/1000 + app.FatNavsDelaymsSpinner.Value/1000
                        C3 = 2;
                        app.C3 = true;

                    elseif app.t_TR <= app.t_I2r + app.FatNavsDurSpinner.Value/1000 + app.FatNavsDelaymsSpinner.Value/1000 + app.TCminmsSpinner.Value/1000
                        C3 = 1;
                        app.C3 = true;

                    else
                        C3 = 0;


                    end

                case 'Off'
                    if app.t_TR <= app.t_I2r
                        C3 = 2;
                        app.C3 = true;

                    elseif app.t_TR <= app.t_I2r + app.TCminmsSpinner.Value/1000
                        C3 = 1;
                        app.C3 = true;

                    else
                        C3 = 0;


                    end
            end

            


           
            if C3 == 3
                UpdateMessage(app,'Conflict: TR too short w.r.t 2nd train')
            elseif C3 == 2
                switch app.FatNavsSwitch.Value
                    case 'On'
                        UpdateMessage(app,'Potential Conflict : TR too short w.r.t TCmin and FatNav.')
                    case 'Off'
                        UpdateMessage(app,'Potential Conflict : TR too short w.r.t TCmin.')
                end
            else
                if C3 == 0 && app.C3
                    UpdateMessage(app,'Conflict resolved.')
                    
                    app.C3 = false;
                end

            end
            if C2 == 2
                UpdateMessage(app,'Conflict: trains overlap!')
            elseif C2 == 1
                UpdateMessage(app,'Potential Conflict: 2nd train delay too short w.r.t. TBmin.')
            else
                if C2 == 0 && app.C2
                    UpdateMessage(app,'Conflict resolved.')
                    app.C2 = false;
                end
            end
            if C1 == 2
                UpdateMessage(app,'Conflict: 1st train starts too early w.r.t RF inv.')
            elseif C1 == 1
                UpdateMessage(app,'Potential Conflict: 1st train starts too early w.r.t TAmin.')
            else
                if C1 == 0 && app.C1
                    UpdateMessage(app,'Conflict resolved.')
                    app.C1 = false;
                end
            end

            if C1 == 2 || C2 == 2 || C3 == 2
                app.CLamp.Color = 'red';
            elseif C1 == 1 || C2 == 1 || C3 == 1
                app.CLamp.Color = 'yellow';
            else
                app.CLamp.Color = 'green';
            end

           

        end

        function [Inv1,Inv2,T_1_array]= Get_Inv1and2(app)
            T_1 = linspace(0,20,ceil(app.SampDensKnob.Value)); % I hardcode 20 as UL on purpose
            T_I_1 = app.TI1sSpinner.Value;
            T_I_2 = app.TI2sSpinner.Value;
            FA1  = app.FA1degSpinner.Value;
            FA2  = app.FA2degSpinner.Value;
            T_R_flash   = app.ESmsSpinner.Value;
            T_R_mp2rage    = app.TRsSpinner.Value;
            N_slices = app.NslicesSpinner.Value;
            Eff_Inv = app.InvEffSpinner.Value;
            PF = app.PFSpinner.Value;
            temp = app.SNRtestsKnob.Value;
            if ischar(temp)
                if strcmp(temp,'Off')
                    N_tests = 1;
                else
                    if isnumeric(str2double(temp))
                        N_tests = str2double(temp)+1;
                    end

                end

            end

            M_0 = 1;
            B_1_fac = B1factors(app);

            T_R_flash = T_R_flash.*1e-3;
            N_B_1_fac = numel(B_1_fac);
            N_slices_pf        =N_slices*[PF-0.5 0.5];  % This is the actual number of echoes, used to calculate the echo train length
            N_T_1 = numel(T_1);
            alpha_1 = FA1.*B_1_fac(:);
            alpha_2 = FA2.*B_1_fac(:);
            alpha_1 = repmat(alpha_1,1,N_T_1);
            alpha_2 = repmat(alpha_2,1,N_T_1);




            N_echoes_bef_T_E = N_slices_pf(1);
            N_echoes_aft_T_E = N_slices_pf(2);
            N_echoes_tot = sum(N_slices_pf);


            T_acq            = N_echoes_tot     * T_R_flash;
            T_acq_bef_T_E    = N_echoes_bef_T_E * T_R_flash;
            T_acq_aft_T_E    = N_echoes_aft_T_E * T_R_flash;

            T_A = T_I_1 - T_acq_bef_T_E;
            T_C = T_R_mp2rage - T_I_2 - T_acq_aft_T_E;
            T_B = T_R_mp2rage - 2*T_acq - T_A - T_C;

            E_R = exp(-T_R_flash./T_1);
            E_A = exp(-T_A./T_1);
            E_B = exp(-T_B./T_1);
            E_C = exp(-T_C./T_1);

            E_R = repmat(E_R,N_B_1_fac,1);
            E_A = repmat(E_A,N_B_1_fac,1);
            E_B = repmat(E_B,N_B_1_fac,1);
            E_C = repmat(E_C,N_B_1_fac,1);

            ca1 = cos(alpha_1*pi/180);
            ca2 = cos(alpha_2*pi/180);

            ca1E_R = ca1.*E_R;
            ca2E_R = ca2.*E_R;


            X = M_0.*(1-E_R).*(1-ca2E_R.^N_echoes_tot)./(1-ca2E_R).*E_C + M_0.*(1-E_C);
            Y = M_0.*(1-E_R).*(1-ca1E_R.^N_echoes_tot)./(1-ca1E_R).*E_B.*ca2E_R.^N_echoes_tot.*E_C + M_0.*(1-E_B).*ca2E_R.^N_echoes_tot.*E_C;
            Z = M_0.*(1-E_A).*ca1E_R.^N_echoes_tot.*E_B.*ca2E_R.^N_echoes_tot.*E_C;

            M_z_ss_denom = 1+Eff_Inv*ca1E_R.^N_echoes_tot.*ca2E_R.^N_echoes_tot.*E_A.*E_B.*E_C;
            M_z_ss_numer = X+Y+Z;
            M_z_ss = M_z_ss_numer./M_z_ss_denom;

            Mz1 = -Eff_Inv.*M_z_ss;
            Mz2 = Mz1.*E_A + M_0.*(1-E_A);
            Mz3 = Mz2.*ca1E_R.^N_echoes_bef_T_E + M_0.*(1-E_R).*(1-ca1E_R.^N_echoes_bef_T_E)./(1-ca1E_R);

            Mz4 = Mz3.*ca1E_R.^N_echoes_aft_T_E + M_0.*(1-E_R).*(1-ca1E_R.^N_echoes_aft_T_E)./(1-ca1E_R);
            Mz5 = Mz4.*E_B+M_0.*(1-E_B);
            Mz6 = Mz5.*ca2E_R.^N_echoes_bef_T_E + M_0.*(1-E_R).*(1-ca2E_R.^N_echoes_bef_T_E)./(1-ca2E_R);

            GRE1 = sin(alpha_1*pi/180).*Mz3;
            GRE2 = sin(alpha_2*pi/180).*Mz6;



            Inv1 = repmat(GRE1,[1,1,N_tests]);
            Inv2 = repmat(GRE2,[1,1,N_tests]);


            T_1_array = repmat(T_1,[N_B_1_fac,1,N_tests]);


        end

        function Plot(app,Y,X,Ax,Type1,Type2,Type3)

            switch app.PlotSwitch.Value
                case 'R1'
                    X = 1./X;
                    
            end



            B_1_fac = B1factors(app);
            temp = app.B0TDropDown.Value;
            B_0 = str2double(temp);

            switch app.PlotSwitch.Value
                case 'T1'
                    if B_0 > 2.5 && B_0 < 3.5
                        T1WM=0.85;
                        T1GM=1.35;
                        T1CSF=2.8;
                    elseif B_0 > 6.5 && B_0 < 7.5
                        T1WM=1.1;
                        T1GM=1.85;
                        T1CSF=3.5;
                    end
                case 'R1'
                    if B_0 > 2.5 && B_0 < 3.5
                        T1WM=1/0.85;
                        T1GM=1/1.35;
                        T1CSF=1/2.8;
                    elseif B_0 > 6.5 && B_0 < 7.5
                        T1WM=1/1.1;
                        T1GM=1/1.85;
                        T1CSF=1/3.5;
                    end

            end


            N_tests = size(Y,3);
            N_B_1_fac = numel(B_1_fac);


            % hold on
            if N_tests > 1
                for n = N_tests:-1:2
                    temp = squeeze(Y(:,:,n));
                    temp2 = squeeze(X(:,:,n));
                    for m = 1:N_B_1_fac
                        plot(temp(m,:).',temp2(m,:).','color',[0.5 0.5 0.5]*B_1_fac(m),'linewidth',2,'parent',Ax)
                        hold(Ax, 'on');
                    end
                end
            end
            temp = squeeze(Y(:,:,1));
            temp2 = squeeze(X(:,:,1));
            for m = 1:N_B_1_fac
                plot(temp(m,:).',temp2(m,:).','color',[0.5 0.5 0.5]*B_1_fac(m),'linewidth',4,'parent',Ax)
                hold(Ax, 'on');
            end

            line(Ax,[-0.5 0.5],[T1CSF T1CSF]','Linewidth',2,'color','blue','linestyle','--')
            line(Ax,[-0.5 0.5],[T1GM T1GM]','Linewidth',2,'color',[1,1,1].*0.5,'linestyle','--')
            line(Ax,[-0.5 0.5],[T1WM T1WM]','Linewidth',2,'color',[1,1,1]-eps,'linestyle','--')

            
            if Type1 == 1 && Type2 == 0
                text(Ax,[-0.45],app.MaxKnob.Value*0.9,'CSF - -','color','blue','FontSize',14,'FontWeight','bold')
                text(Ax,[-0.3],app.MaxKnob.Value*0.9,'GM - -','color',[1,1,1].*0.5,'FontSize',14,'FontWeight','bold')
                text(Ax,[-0.15],app.MaxKnob.Value*0.9,'WM - -','color',[1,1,1]-eps,'FontSize',14,'FontWeight','bold')
            end


            
            set(Ax,'YLim',[0,app.MaxKnob.Value+eps]);

            grid(Ax,'on')
            set(Ax,'XTick',[-.5 :0.25:.5]),
            if Type1 == 1
                switch app.PlotSwitch.Value
                    case 'T1'
                        ylabel(Ax,'T_1 [s]')
                    case 'R1'
                        ylabel(Ax,'R_1 [1/s]')
                end
                
            else
                ylabel(Ax,'')
            end
            if Type2 == 1
                xlabel(Ax,'Signal')
            else
                xlabel(Ax,'')
            end
            set(Ax,'Fontsize',14);
            drawnow
        end

        function B1fac = B1factors(app)
            B1inhomogeneity = app.B1inhomogeneityKnob.Value;

            if B1inhomogeneity < 1
                B1fac = 1;
                return
            end

            temp= app.B1testsKnob.Value;
            if ischar(temp)
                if strcmp(temp,'Off')
                    B1fac = 1;
                else
                    B1tests = str2double(temp);
                    B1fac = linspace(-B1inhomogeneity,B1inhomogeneity,B1tests)/100+1;
                end
            end

        end

        function DSR = Get_DSR(app,Inv1,Inv2)
            DSR = (abs(Inv1)-abs(Inv2))./(2.*abs(Inv1)+2.*abs(Inv2));

        end

        function UNI = Get_UNI(app,Inv1,Inv2) %#ok<*INUSD>
            UNI = Inv1.*Inv2./(abs(Inv1).^2+abs(Inv2).^2);

        end

        function [Inv1n,Inv2n,Noise1,Noise2] = Add_Noise(app,Inv1,Inv2)
            
            temp = app.SNRtestsKnob.Value;
            temp2 = app.SNRKnob.Value;
            if ischar(temp)
                if strcmp(temp,'Off')
                    Inv1n = Inv1;
                    Inv2n = Inv2;
                    Noise1 = zeros(size(Inv1));
                    Noise2 = zeros(size(Inv1));
                else
                    if isnumeric(str2double(temp))
                        SNR = temp2;
                        MaxSignal = max([Inv1 Inv2],[],'all');
                        Noise1 = MaxSignal./SNR .*randn(size(Inv1)); Noise1(:,:,1) = 0;
                        Noise2 = MaxSignal./SNR .*randn(size(Inv2)); Noise2(:,:,1) = 0;
                        Inv1n = Inv1 + Noise1;
                        Inv2n = Inv2 + Noise2;
                    end

                end

            end

        end

        function results = func(app)
            
            [Inv1,Inv2,T_1_array]= Get_Inv1and2(app);

            
            [Inv1n,Inv2n,~,~]=Add_Noise(app,Inv1,Inv2);
            DSR = Get_DSR(app,Inv1n,Inv2n);
            UNI = Get_UNI(app,Inv1n,Inv2n);

            R_1_array = 1./T_1_array;
            Ax = app.UIAxes3;cla(Ax)
            Plot(app,UNI,T_1_array,Ax,1,1);
            Ax = app.UIAxes4;cla(Ax)
            Plot(app,DSR,T_1_array,Ax,0,1);
            Ax = app.UIAxes;cla(Ax)
            Plot(app,Inv1n,T_1_array,Ax,1,0);
            Ax = app.UIAxes2;cla(Ax)
            Plot(app,Inv2n,T_1_array,Ax,0,0);


            Ax = app.UIAxes5;cla(Ax)
            PlotSeq(app,Ax);
            if app.Check
                SanityCheck(app)
            else
                app.Check = true;
            end
            results = 1;
        end

        function LoadLessBias(app)
            UpdateMessage(app,'Showing LessBias')
            app.TI1sSpinner.Value = 0.5;
            app.TI2sSpinner.Value = 1.9;
            app.FA1degSpinner.Value = 3;
            app.FA2degSpinner.Value = 5;
            app.ESmsSpinner.Value = 7.18;
            app.TRsSpinner.Value = 5;
            app.NslicesSpinner.Value = 192;
            app.InvEffSpinner.Value = 0.96;
            app.PFSpinner.Value = 0.75;
        end

        function LoadStandard(app)
            UpdateMessage(app,'Showing Standard')
            app.TI1sSpinner.Value = 0.7;
            app.TI2sSpinner.Value = 2.5;
            app.FA1degSpinner.Value = 4;
            app.FA2degSpinner.Value = 5;
            app.ESmsSpinner.Value = 7.18;
            app.TRsSpinner.Value = 5;
            app.NslicesSpinner.Value = 192;
            app.InvEffSpinner.Value = 0.96;
            app.PFSpinner.Value = 0.75;
        end

        function saveToJSON(app, fullFileName)
            data.TI1s = app.TI1sSpinner.Value;
            data.TI2s = app.TI2sSpinner.Value;
            data.FA1deg  = app.FA1degSpinner.Value;
            data.FA2deg  = app.FA2degSpinner.Value;
            data.ESms   = app.ESmsSpinner.Value;
            data.TRs    = app.TRsSpinner.Value;
            data.Nslices = app.NslicesSpinner.Value;
            data.InvEff = app.InvEffSpinner.Value;
            data.PF = app.PFSpinner.Value;

            jsonString = jsonencode(data);

            fileID = fopen(fullFileName, 'w');
            fprintf(fileID, '%s', jsonString);
            fclose(fileID);
        end
        function saveToCSV(app, fullFileName)
            data = [app.TI1sSpinner.Value, app.TI2sSpinner.Value, app.FA1degSpinner.Value, app.FA2degSpinner.Value, app.ESmsSpinner.Value, app.TRsSpinner.Value, app.NslicesSpinner.Value, app.InvEffSpinner.Value, app.PFSpinner.Value];

            fileID = fopen(fullFileName, 'w');
            fprintf(fileID, 'TI1s, TI2s, FA1deg, FA2deg, ESms, TRs, Nslices, InvEff, PF\n'); % Column headers
            fprintf(fileID, '%f, %f, %f, %f, %f, %f, %f, %f, %f\n', data);      % Data
            fclose(fileID);
        end
        function loadFromCSV(app, fullFileName)
            fileID = fopen(fullFileName, 'r');

            fgetl(fileID);

            data = fscanf(fileID, '%f, %f, %f, %f, %f, %f, %f, %f, %f');

            fclose(fileID);

            app.TI1sSpinner.Value = data(1);
            app.TI2sSpinner.Value = data(2);
            app.FA1degSpinner.Value = data(3);
            app.FA2degSpinner.Value = data(4);
            app.ESmsSpinner.Value = data(5);
            app.TRsSpinner.Value = data(6);
            app.NslicesSpinner.Value = data(7);
            app.InvEffSpinner.Value = data(8);
            app.PFSpinner.Value = data(9);


        end
        function loadFromJSON(app, fullFileName)
            fileID = fopen(fullFileName, 'r');
            rawData = fread(fileID, inf, 'char');
            fclose(fileID);

            jsonData = jsondecode(char(rawData'));

            app.TI1sSpinner.Value = jsonData.TI1s;
            app.TI2sSpinner.Value = jsonData.TI2s;
            app.FA1degSpinner.Value = jsonData.FA1deg;
            app.FA2degSpinner.Value = jsonData.FA2deg;
            app.ESmsSpinner.Value = jsonData.ESms;
            app.TRsSpinner.Value = jsonData.TRs;
            app.NslicesSpinner.Value = jsonData.Nslices;
            app.InvEffSpinner.Value = jsonData.InvEff;
            app.PFSpinner.Value = jsonData.PF;
        end

        function PlotSeq(app,Ax)

            app.t_Inv = 0;
            y_Inv = app.InvEffSpinner.Value;
            
            

            app.t_I1l = app.TI1sSpinner.Value - (app.PFSpinner.Value-0.5)*app.ESmsSpinner.Value/1000*app.NslicesSpinner.Value;
            app.t_I1c = app.TI1sSpinner.Value;
            app.t_I1r = app.TI1sSpinner.Value + 0.5*app.ESmsSpinner.Value/1000*app.NslicesSpinner.Value;

            app.t_I2l = app.TI2sSpinner.Value - (app.PFSpinner.Value-0.5)*app.ESmsSpinner.Value/1000*app.NslicesSpinner.Value;
            app.t_I2c = app.TI2sSpinner.Value;
            app.t_I2r = app.TI2sSpinner.Value + 0.5*app.ESmsSpinner.Value/1000*app.NslicesSpinner.Value;

            

            app.t_TR = app.TRsSpinner.Value;

            app.t_TAl = app.t_Inv;
            app.t_TBl = app.t_I1r;

            app.t_TAr = app.t_Inv + app.TAminmsSpinner.Value/1000;
            app.t_TBr = app.t_I1r + app.TBminmsSpinner.Value/1000;

            switch app.FatNavsSwitch.Value
                case 'On'
                    app.t_Delayl = app.t_I2r;
                    app.t_Delayr = app.t_I2r+app.FatNavsDelaymsSpinner.Value/1000;
                    app.t_FNl = app.t_I2r + app.FatNavsDelaymsSpinner.Value/1000;
                    app.t_FNr = app.t_FNl + app.FatNavsDurSpinner.Value/1000;


                    app.t_TCl = app.t_FNr;
                    app.t_TCr = app.t_FNr + app.TCminmsSpinner.Value/1000;
                case 'Off'
                    app.t_TCl = app.t_I2r;
                    app.t_TCr = app.t_I2r + app.TCminmsSpinner.Value/1000;
            end

            area(Ax,[0,0,app.t_TR,app.t_TR],[-.1,1.1,1.1,-.1],'FaceColor',[1,1,1].*0.65);
            hold(Ax,'on')
            plot(Ax,[1,1].*app.t_Inv,[0,1].*y_Inv,'color','red','linewidth',4);
            hold(Ax,'on')
            area(Ax,[app.t_I1l,app.t_I1l,app.t_I1r,app.t_I1r],[0,1,1,0]*0.75,'FaceColor',[0,153,0]/255,'FaceAlpha',0.2,'EdgeColor',[0,153,0]/255,'EdgeAlpha',0.8,'linewidth',4);
            hold(Ax,'on')
            area(Ax,[app.t_I2l,app.t_I2l,app.t_I2r,app.t_I2r],[0,1,1,0]*0.75,'FaceColor',[255,125,0]./255,'FaceAlpha',0.2,'EdgeColor',[255,125,0]./255,'EdgeAlpha',0.8,'linewidth',4);
            switch app.FatNavsSwitch.Value
                case 'On'
                    area(Ax,[app.t_FNl,app.t_FNl,app.t_FNr,app.t_FNr],[0,1,1,0]*0.5,'FaceColor',[0.5882,0.2941,0],'FaceAlpha',0.2,'EdgeColor',[0.5882,0.2941,0],'EdgeAlpha',0.8,'linewidth',4);
                case 'Off'
            end
            hold(Ax,'on')
            area(Ax,[app.t_I2l,app.t_I2l,app.t_I2r,app.t_I2r],[0,1,1,0]*0.75,'FaceColor',[255,125,0]./255,'FaceAlpha',0.2,'EdgeColor',[255,125,0]./255,'EdgeAlpha',0.8,'linewidth',4);
            hold(Ax,'on')
            plot(Ax,[1,1].*app.t_I1c,[0,1]*0.75,'color',[0,153,0]/255,'linewidth',3);
            hold(Ax,'on')
            plot(Ax,[1,1].*app.t_I2c,[0,1]*0.75,'color',[255,125,0]./255,'linewidth',3);
            hold(Ax,'on')
            plot(Ax,[1,1].*app.t_TR,[0,1].*y_Inv,'color','red','linewidth',4);
            xlim(Ax,[-app.t_TR/100,app.t_TR+app.t_TR/100])
            ylim(Ax,[0,1.2])


            line(Ax,[app.t_TAl,app.t_TAr],[0.5,0.5],'Color','b','linewidth',5)
            line(Ax,[app.t_TBl,app.t_TBr],[0.5,0.5],'Color','m','linewidth',5)
            line(Ax,[app.t_TCl,app.t_TCr],[0.5,0.5],'Color','c','linewidth',5)
            switch app.FatNavsSwitch.Value
                case 'On'
                    line(Ax,[app.t_Delayl,app.t_Delayr],[0.5,0.5],'Color','y','linewidth',5)
                case 'Off'

            end

            set(Ax,'XTick',sort([app.t_Inv,app.t_I1l,app.t_I1c,app.t_I1r,app.t_I2l,app.t_I2c,app.t_I2r,app.t_TR]))
            set(Ax,'YTick',[])
            set(Ax,'XColor','k','Linewidth',2)
            set(Ax,'YColor',[1,1,1]-eps)
            drawnow
        end


    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.File = 'NA';
            LoadStandard(app);

            List = {'Standard','LessBias'};
            app.PresetsListBox.Items = List;
            app.PresetsListBox.Value = List{1};
            if contains(ver("MATLAB").Release,'R2023b')
            app.PresetsListBox.ValueIndex = 1;
            end
            app.PresetIndex = 2;

            app.File = List;
            app.FullFileName = List;
            app.Fileext = {'',''};
            app.C1 = false;
            app.C2 = false;
            app.C3 = false;
            app.Check = false;
            results = func(app); %#ok<*NASGU>




        end

        % Value changed function: PresetsListBox
        function PresetsListBoxValueChanged(app, event)
            value = app.PresetsListBox.Value;

            switch value
                case 'LessBias'
                    LoadLessBias(app)
                case 'Standard'
                    LoadStandard(app)
                otherwise
                    Index = app.PresetsListBox.ValueIndex;
                    if strcmp(app.Fileext{Index}, '.csv')
                        loadFromCSV(app, app.FullFileName{Index});
                    elseif strcmp(app.Fileext{Index}, '.json')
                        loadFromJSON(app, app.FullFileName{Index});
                    end
                    
                    UpdateMessage(app,sprintf('Showing %s.',app.FullFileName{Index}) )
            end


            results = func(app);
        end

        % Value changed function: B1testsKnob
        function B1testsKnobValueChanged(app, event)
            value = app.B1testsKnob.Value;

            if ischar(value)
                if strcmp(value,'Off')
                    app.B1inhomogeneityKnob.Value = 0;
                end
            end
            results = func(app);
        end

        % Value changed function: B1inhomogeneityKnob
        function B1inhomogeneityKnobValueChanged(app, event)
            value = app.B1inhomogeneityKnob.Value;
            if value < 1
                app.B1testsKnob.Value = 'Off';
            end
            results = func(app);
        end

        % Value changed function: SNRtestsKnob
        function SNRtestsKnobValueChanged(app, event)
            value = app.SNRtestsKnob.Value;
            results = func(app);
        end

        % Value changed function: SNRKnob
        function SNRKnobValueChanged(app, event)
            value = app.SNRKnob.Value;
            results = func(app);
        end

        % Value changed function: B0TDropDown
        function B0TDropDownValueChanged(app, event)
            value = app.B0TDropDown.Value;
            results = func(app);
        end

        % Drop down opening function: B0TDropDown
        function B0TDropDownOpening(app, event)
            % results = func(app);
        end

        % Value changed function: TRsSpinner
        function TRsSpinnerValueChanged(app, event)
            value = app.TRsSpinner.Value;
            results = func(app);
        end

        % Value changed function: ESmsSpinner
        function ESmsSpinnerValueChanged(app, event)
            value = app.ESmsSpinner.Value;
            results = func(app);
        end

        % Value changed function: FA1degSpinner
        function FA1degSpinnerValueChanged(app, event)
            value = app.FA1degSpinner.Value;
            results = func(app);
        end

        % Value changed function: FA2degSpinner
        function FA2degSpinnerValueChanged(app, event)
            value = app.FA2degSpinner.Value;
            results = func(app);
        end

        % Value changed function: TI1sSpinner
        function TI1sSpinnerValueChanged(app, event)
            value = app.TI1sSpinner.Value;
            results = func(app);
        end

        % Value changed function: TI2sSpinner
        function TI2sSpinnerValueChanged(app, event)
            value = app.TI2sSpinner.Value;
            results = func(app);
        end

        % Value changed function: NslicesSpinner
        function NslicesSpinnerValueChanged(app, event)
            previousValue = event.PreviousValue;
            value = app.NslicesSpinner.Value;
            Nslices = [8:2:32,36:8:64,72:8:128,144:16:256,512];
            [~, idx] = min(abs(Nslices - value));
            if value > previousValue
                if idx < numel(Nslices)
                    newValue = Nslices(idx + 1);
                else
                    newValue = Nslices(end);  
                end
            else
                if idx > 1
                    newValue = Nslices(idx - 1);
                else
                    newValue = Nslices(1);  
                end
            end

            app.NslicesSpinner.Value = newValue;

            results = func(app);
        end

        % Value changed function: PFSpinner
        function PFSpinnerValueChanged(app, event)
            value = app.PFSpinner.Value;
            results = func(app);
        end

        % Value changed function: InvEffSpinner
        function InvEffSpinnerValueChanged(app, event)
            value = app.InvEffSpinner.Value;
            results = func(app);
        end

        % Value changed function: MaxKnob
        function MaxKnobValueChanged(app, event)
            value = app.MaxKnob.Value;
            results = func(app);
        end

        % Value changed function: SampDensKnob
        function SampDensKnobValueChanged(app, event)
            value = app.SampDensKnob.Value;
            results = func(app);
        end

        % Button pushed function: SavePresetButton
        function SavePreset(app, event)
            Go = 0;
            try
                [File, path] = uiputfile({'*.csv', 'CSV Files (*.csv)'; '*.json', 'JSON Files (*.json)'}, 'Save Data As');
                FullFileName = fullfile(path, File);
                if isequal(File, 0) || isequal(path, 0)

                    UpdateMessage(app,'User canceled the save operation.')
                else
                    Go = 1 ;
                end
            catch
                UpdateMessage(app,'Something went wrong.')
                app.PresetsListBox.Value = 'Standard';
                app.PresetsListBox.ValueIndex = 1;
                LoadStandard(app)
            end
            if Go
                try
                    FullFileName = fullfile(path, File);

                    [~,~,ext] = fileparts(FullFileName);

                    if strcmp(ext, '.csv')
                        saveToCSV(app, FullFileName);
                    elseif strcmp(ext, '.json')
                        saveToJSON(app, FullFileName);
                    else
                        UpdateMessage(app,'Unsupported file type.')
                    end
                    UpdateMessage(app,sprintf('Successfully saved %s',FullFileName))
                catch
                    UpdateMessage(app,sprintf('Could not save %s',FullFileName))
                    pause(1)
                    app.PresetsListBox.Value = 'Standard';
                    app.PresetsListBox.ValueIndex = 1;
                    LoadStandard(app)
                end
            end
        end

        % Button pushed function: LoadPresetButton
        function LoadPreset(app, event)

            Go = 0;
            try

                [File, path] = uigetfile({'*.csv;*.json', 'CSV and JSON Files (*.csv, *.json)'}, 'Load Data'); %#ok<*ADPROPLC>
                FullFileName = fullfile(path, File);
                if isequal(File, 0) || isequal(path, 0)
                    UpdateMessage(app,sprintf('User canceled the load operation.'))
                    app.PresetsListBox.Value = 'Standard';
                    app.PresetsListBox.ValueIndex = 1;
                    LoadStandard(app)
                else
                    Go = 1 ;
                end
            catch
                UpdateMessage(app,'Something went wrong.')
                UpdateMessage(app,sprintf('Could not load %s.',FullFileName))
                app.PresetsListBox.Value = 'Standard';
                app.PresetsListBox.ValueIndex = 1;
                LoadStandard(app)
            end

            if Go
                try

                    [~,~,ext] = fileparts(FullFileName);



                    if strcmp(ext, '.csv')
                        loadFromCSV(app, FullFileName);
                    elseif strcmp(ext, '.json')
                        loadFromJSON(app, FullFileName);
                    else
                        UpdateMessage(app,'Unsupported file type.')
                    end
                    app.PresetIndex = app.PresetIndex + 1;

                    app.File = [app.File,File];
                    app.FullFileName = [app.FullFileName,FullFileName];
                    app.Fileext = [app.Fileext,ext];
                    app.PresetsListBox.Items = [app.PresetsListBox.Items,File];
                    app.PresetsListBox.Value = File;
                    app.PresetsListBox.ValueIndex = app.PresetIndex;
                    UpdateMessage(app,sprintf('Successfully loaded %s',FullFileName))
                catch
                    UpdateMessage(app,sprintf('%s could not load',FullFileName))
                    app.PresetsListBox.Value = 'Standard';
                    app.PresetsListBox.ValueIndex = 1;
                    LoadStandard(app)
                end

            end

            results = func(app);
        end

        % Value changed function: PlotSwitch
        function PlotSwitchValueChanged(app, event)
            value = app.PlotSwitch.Value;

            switch app.PlotSwitch.Value
                case 'R1'
                     app.MaxKnob.Limits = [0,20];
                     app.MaxKnob.MajorTicks  = [0:5:20];
                     app.MaxKnob.Value = 4;
                case 'T1'
                    app.MaxKnob.Limits = [0,20];
                     app.MaxKnob.MajorTicks  = [0:5:20];
                     app.MaxKnob.Value = 5;
            end


            results = func(app);
        end

        % Value changed function: FatNavsSwitch
        function FatNavsSwitchValueChanged(app, event)
            value = app.FatNavsSwitch.Value;
            
            switch value
                case 'On'
                    app.FatNavsDurSpinner.Visible = 'On';
                case 'Off'
                    app.FatNavsDurSpinner.Visible = 'Off';

            end
            results = func(app);

        end

        % Value changed function: FatNavsDelaymsSpinner
        function FatNavsDelaymsSpinnerValueChanged(app, event)
            value = app.FatNavsDelaymsSpinner.Value;
            results = func(app);
        end

        % Value changed function: FatNavsDurSpinner
        function FatNavsDurSpinnerValueChanged(app, event)
            value = app.FatNavsDurSpinner.Value;
            results = func(app);
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {1093, 1093};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {359, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1498 1093];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {359, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.BackgroundColor = [0.6314 0.8196 0.3804];
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create PresetsListBoxLabel
            app.PresetsListBoxLabel = uilabel(app.LeftPanel);
            app.PresetsListBoxLabel.HorizontalAlignment = 'right';
            app.PresetsListBoxLabel.FontSize = 18;
            app.PresetsListBoxLabel.FontWeight = 'bold';
            app.PresetsListBoxLabel.FontColor = [0.851 0.3255 0.098];
            app.PresetsListBoxLabel.Position = [4 1056 70 24];
            app.PresetsListBoxLabel.Text = 'Presets';

            % Create PresetsListBox
            app.PresetsListBox = uilistbox(app.LeftPanel);
            app.PresetsListBox.Items = {'Standard'};
            app.PresetsListBox.ValueChangedFcn = createCallbackFcn(app, @PresetsListBoxValueChanged, true);
            app.PresetsListBox.FontSize = 14;
            app.PresetsListBox.FontWeight = 'bold';
            app.PresetsListBox.Position = [89 928 255 154];
            app.PresetsListBox.Value = 'Standard';

            % Create SavePresetButton
            app.SavePresetButton = uibutton(app.LeftPanel, 'push');
            app.SavePresetButton.ButtonPushedFcn = createCallbackFcn(app, @SavePreset, true);
            app.SavePresetButton.FontSize = 14;
            app.SavePresetButton.FontWeight = 'bold';
            app.SavePresetButton.Position = [94 890 100 26];
            app.SavePresetButton.Text = 'Save Preset';

            % Create LoadPresetButton
            app.LoadPresetButton = uibutton(app.LeftPanel, 'push');
            app.LoadPresetButton.ButtonPushedFcn = createCallbackFcn(app, @LoadPreset, true);
            app.LoadPresetButton.FontSize = 14;
            app.LoadPresetButton.FontWeight = 'bold';
            app.LoadPresetButton.Position = [212 890 100 26];
            app.LoadPresetButton.Text = 'Load Preset';

            % Create ParametersLabel
            app.ParametersLabel = uilabel(app.LeftPanel);
            app.ParametersLabel.FontSize = 18;
            app.ParametersLabel.FontWeight = 'bold';
            app.ParametersLabel.FontColor = [0.851 0.3255 0.098];
            app.ParametersLabel.Position = [10 857 105 24];
            app.ParametersLabel.Text = 'Parameters';

            % Create TI1sSpinnerLabel
            app.TI1sSpinnerLabel = uilabel(app.LeftPanel);
            app.TI1sSpinnerLabel.HorizontalAlignment = 'right';
            app.TI1sSpinnerLabel.FontSize = 14;
            app.TI1sSpinnerLabel.FontWeight = 'bold';
            app.TI1sSpinnerLabel.Position = [6 818 46 22];
            app.TI1sSpinnerLabel.Text = 'TI1 [s]';

            % Create TI1sSpinner
            app.TI1sSpinner = uispinner(app.LeftPanel);
            app.TI1sSpinner.Step = 0.01;
            app.TI1sSpinner.Limits = [0 100];
            app.TI1sSpinner.ValueChangedFcn = createCallbackFcn(app, @TI1sSpinnerValueChanged, true);
            app.TI1sSpinner.FontSize = 14;
            app.TI1sSpinner.FontWeight = 'bold';
            app.TI1sSpinner.FontColor = [0 0.6 0];
            app.TI1sSpinner.BackgroundColor = [0.8 0.8 0.8];
            app.TI1sSpinner.Position = [70 817 77 22];
            app.TI1sSpinner.Value = 1;

            % Create FA1degSpinnerLabel
            app.FA1degSpinnerLabel = uilabel(app.LeftPanel);
            app.FA1degSpinnerLabel.HorizontalAlignment = 'right';
            app.FA1degSpinnerLabel.FontSize = 14;
            app.FA1degSpinnerLabel.FontWeight = 'bold';
            app.FA1degSpinnerLabel.Position = [170 817 68 22];
            app.FA1degSpinnerLabel.Text = 'FA1 [deg]';

            % Create FA1degSpinner
            app.FA1degSpinner = uispinner(app.LeftPanel);
            app.FA1degSpinner.Step = 0.1;
            app.FA1degSpinner.Limits = [0 90];
            app.FA1degSpinner.ValueChangedFcn = createCallbackFcn(app, @FA1degSpinnerValueChanged, true);
            app.FA1degSpinner.FontSize = 14;
            app.FA1degSpinner.FontWeight = 'bold';
            app.FA1degSpinner.Position = [255 817 64 22];
            app.FA1degSpinner.Value = 4;

            % Create TI2sSpinnerLabel
            app.TI2sSpinnerLabel = uilabel(app.LeftPanel);
            app.TI2sSpinnerLabel.HorizontalAlignment = 'right';
            app.TI2sSpinnerLabel.FontSize = 14;
            app.TI2sSpinnerLabel.FontWeight = 'bold';
            app.TI2sSpinnerLabel.Position = [6 787 46 22];
            app.TI2sSpinnerLabel.Text = 'TI2 [s]';

            % Create TI2sSpinner
            app.TI2sSpinner = uispinner(app.LeftPanel);
            app.TI2sSpinner.Step = 0.01;
            app.TI2sSpinner.Limits = [0 100];
            app.TI2sSpinner.ValueChangedFcn = createCallbackFcn(app, @TI2sSpinnerValueChanged, true);
            app.TI2sSpinner.FontSize = 14;
            app.TI2sSpinner.FontWeight = 'bold';
            app.TI2sSpinner.FontColor = [1 0.4902 0];
            app.TI2sSpinner.BackgroundColor = [0.8 0.8 0.8];
            app.TI2sSpinner.Position = [70 787 77 22];
            app.TI2sSpinner.Value = 2;

            % Create FA2degSpinnerLabel
            app.FA2degSpinnerLabel = uilabel(app.LeftPanel);
            app.FA2degSpinnerLabel.HorizontalAlignment = 'right';
            app.FA2degSpinnerLabel.FontSize = 14;
            app.FA2degSpinnerLabel.FontWeight = 'bold';
            app.FA2degSpinnerLabel.Position = [170 787 68 22];
            app.FA2degSpinnerLabel.Text = 'FA2 [deg]';

            % Create FA2degSpinner
            app.FA2degSpinner = uispinner(app.LeftPanel);
            app.FA2degSpinner.Step = 0.1;
            app.FA2degSpinner.Limits = [0 90];
            app.FA2degSpinner.ValueChangedFcn = createCallbackFcn(app, @FA2degSpinnerValueChanged, true);
            app.FA2degSpinner.FontSize = 14;
            app.FA2degSpinner.FontWeight = 'bold';
            app.FA2degSpinner.Position = [254 787 65 22];
            app.FA2degSpinner.Value = 5;

            % Create ESmsSpinnerLabel
            app.ESmsSpinnerLabel = uilabel(app.LeftPanel);
            app.ESmsSpinnerLabel.HorizontalAlignment = 'right';
            app.ESmsSpinnerLabel.FontSize = 14;
            app.ESmsSpinnerLabel.FontWeight = 'bold';
            app.ESmsSpinnerLabel.Position = [6 753 57 22];
            app.ESmsSpinnerLabel.Text = 'ES [ms]';

            % Create ESmsSpinner
            app.ESmsSpinner = uispinner(app.LeftPanel);
            app.ESmsSpinner.Step = 0.01;
            app.ESmsSpinner.Limits = [0 200];
            app.ESmsSpinner.ValueChangedFcn = createCallbackFcn(app, @ESmsSpinnerValueChanged, true);
            app.ESmsSpinner.FontSize = 14;
            app.ESmsSpinner.FontWeight = 'bold';
            app.ESmsSpinner.Position = [70 753 77 22];
            app.ESmsSpinner.Value = 7.18;

            % Create NslicesSpinnerLabel
            app.NslicesSpinnerLabel = uilabel(app.LeftPanel);
            app.NslicesSpinnerLabel.HorizontalAlignment = 'right';
            app.NslicesSpinnerLabel.FontSize = 14;
            app.NslicesSpinnerLabel.FontWeight = 'bold';
            app.NslicesSpinnerLabel.Position = [184 753 54 22];
            app.NslicesSpinnerLabel.Text = 'Nslices';

            % Create NslicesSpinner
            app.NslicesSpinner = uispinner(app.LeftPanel);
            app.NslicesSpinner.Limits = [8 512];
            app.NslicesSpinner.ValueChangedFcn = createCallbackFcn(app, @NslicesSpinnerValueChanged, true);
            app.NslicesSpinner.FontSize = 14;
            app.NslicesSpinner.FontWeight = 'bold';
            app.NslicesSpinner.Position = [255 753 64 22];
            app.NslicesSpinner.Value = 192;

            % Create TRsSpinnerLabel
            app.TRsSpinnerLabel = uilabel(app.LeftPanel);
            app.TRsSpinnerLabel.HorizontalAlignment = 'right';
            app.TRsSpinnerLabel.FontSize = 14;
            app.TRsSpinnerLabel.FontWeight = 'bold';
            app.TRsSpinnerLabel.Position = [6 722 44 22];
            app.TRsSpinnerLabel.Text = 'TR [s]';

            % Create TRsSpinner
            app.TRsSpinner = uispinner(app.LeftPanel);
            app.TRsSpinner.Step = 0.01;
            app.TRsSpinner.Limits = [0 100];
            app.TRsSpinner.ValueChangedFcn = createCallbackFcn(app, @TRsSpinnerValueChanged, true);
            app.TRsSpinner.FontSize = 14;
            app.TRsSpinner.FontWeight = 'bold';
            app.TRsSpinner.FontColor = [1 0 0];
            app.TRsSpinner.BackgroundColor = [0.8 0.8 0.8];
            app.TRsSpinner.Position = [70 722 77 22];
            app.TRsSpinner.Value = 6;

            % Create InvEffSpinnerLabel
            app.InvEffSpinnerLabel = uilabel(app.LeftPanel);
            app.InvEffSpinnerLabel.HorizontalAlignment = 'right';
            app.InvEffSpinnerLabel.FontSize = 14;
            app.InvEffSpinnerLabel.FontWeight = 'bold';
            app.InvEffSpinnerLabel.Position = [196 722 43 22];
            app.InvEffSpinnerLabel.Text = 'InvEff';

            % Create InvEffSpinner
            app.InvEffSpinner = uispinner(app.LeftPanel);
            app.InvEffSpinner.Step = 0.01;
            app.InvEffSpinner.Limits = [0 1];
            app.InvEffSpinner.ValueChangedFcn = createCallbackFcn(app, @InvEffSpinnerValueChanged, true);
            app.InvEffSpinner.FontSize = 14;
            app.InvEffSpinner.FontWeight = 'bold';
            app.InvEffSpinner.Position = [254 722 67 22];
            app.InvEffSpinner.Value = 0.96;

            % Create TAminmsSpinnerLabel
            app.TAminmsSpinnerLabel = uilabel(app.LeftPanel);
            app.TAminmsSpinnerLabel.HorizontalAlignment = 'right';
            app.TAminmsSpinnerLabel.FontSize = 14;
            app.TAminmsSpinnerLabel.FontWeight = 'bold';
            app.TAminmsSpinnerLabel.Position = [6 690 80 22];
            app.TAminmsSpinnerLabel.Text = 'TAmin [ms]';

            % Create TAminmsSpinner
            app.TAminmsSpinner = uispinner(app.LeftPanel);
            app.TAminmsSpinner.Limits = [1 100];
            app.TAminmsSpinner.FontWeight = 'bold';
            app.TAminmsSpinner.FontColor = [0 0 1];
            app.TAminmsSpinner.BackgroundColor = [0.8 0.8 0.8];
            app.TAminmsSpinner.Position = [105 690 56 22];
            app.TAminmsSpinner.Value = 22;

            % Create PFSpinnerLabel
            app.PFSpinnerLabel = uilabel(app.LeftPanel);
            app.PFSpinnerLabel.HorizontalAlignment = 'right';
            app.PFSpinnerLabel.FontSize = 14;
            app.PFSpinnerLabel.FontWeight = 'bold';
            app.PFSpinnerLabel.Position = [216 690 25 22];
            app.PFSpinnerLabel.Text = 'PF';

            % Create PFSpinner
            app.PFSpinner = uispinner(app.LeftPanel);
            app.PFSpinner.Step = 0.125;
            app.PFSpinner.Limits = [0.75 1];
            app.PFSpinner.ValueChangedFcn = createCallbackFcn(app, @PFSpinnerValueChanged, true);
            app.PFSpinner.FontSize = 14;
            app.PFSpinner.FontWeight = 'bold';
            app.PFSpinner.Position = [254 690 67 22];
            app.PFSpinner.Value = 0.75;

            % Create TBminmsSpinnerLabel
            app.TBminmsSpinnerLabel = uilabel(app.LeftPanel);
            app.TBminmsSpinnerLabel.HorizontalAlignment = 'right';
            app.TBminmsSpinnerLabel.FontSize = 14;
            app.TBminmsSpinnerLabel.FontWeight = 'bold';
            app.TBminmsSpinnerLabel.Position = [6 655 81 22];
            app.TBminmsSpinnerLabel.Text = 'TBmin [ms]';

            % Create TBminmsSpinner
            app.TBminmsSpinner = uispinner(app.LeftPanel);
            app.TBminmsSpinner.Limits = [1 100];
            app.TBminmsSpinner.FontWeight = 'bold';
            app.TBminmsSpinner.FontColor = [1 0.0745 0.651];
            app.TBminmsSpinner.BackgroundColor = [0.8 0.8 0.8];
            app.TBminmsSpinner.Position = [106 655 56 22];
            app.TBminmsSpinner.Value = 71;

            % Create TCminmsSpinnerLabel
            app.TCminmsSpinnerLabel = uilabel(app.LeftPanel);
            app.TCminmsSpinnerLabel.HorizontalAlignment = 'right';
            app.TCminmsSpinnerLabel.FontSize = 14;
            app.TCminmsSpinnerLabel.FontWeight = 'bold';
            app.TCminmsSpinnerLabel.Position = [7 621 82 22];
            app.TCminmsSpinnerLabel.Text = 'TCmin [ms]';

            % Create TCminmsSpinner
            app.TCminmsSpinner = uispinner(app.LeftPanel);
            app.TCminmsSpinner.Limits = [1 Inf];
            app.TCminmsSpinner.FontWeight = 'bold';
            app.TCminmsSpinner.FontColor = [0 1 1];
            app.TCminmsSpinner.BackgroundColor = [0.8 0.8 0.8];
            app.TCminmsSpinner.Position = [106 621 56 22];
            app.TCminmsSpinner.Value = 10;

            % Create FatNavsSwitchLabel
            app.FatNavsSwitchLabel = uilabel(app.LeftPanel);
            app.FatNavsSwitchLabel.HorizontalAlignment = 'center';
            app.FatNavsSwitchLabel.FontSize = 18;
            app.FatNavsSwitchLabel.FontWeight = 'bold';
            app.FatNavsSwitchLabel.FontColor = [0.851 0.3255 0.098];
            app.FatNavsSwitchLabel.Position = [9 566 75 24];
            app.FatNavsSwitchLabel.Text = 'FatNavs';

            % Create DurmsLabel_2
            app.DurmsLabel_2 = uilabel(app.LeftPanel);
            app.DurmsLabel_2.HorizontalAlignment = 'right';
            app.DurmsLabel_2.FontSize = 14;
            app.DurmsLabel_2.FontWeight = 'bold';
            app.DurmsLabel_2.Position = [133 561 76 22];
            app.DurmsLabel_2.Text = 'Delay [ms]';

            % Create DurmsLabel
            app.DurmsLabel = uilabel(app.LeftPanel);
            app.DurmsLabel.HorizontalAlignment = 'right';
            app.DurmsLabel.FontSize = 14;
            app.DurmsLabel.FontWeight = 'bold';
            app.DurmsLabel.Position = [234 561 65 22];
            app.DurmsLabel.Text = 'Dur. [ms]';

            % Create FatNavsSwitch
            app.FatNavsSwitch = uiswitch(app.LeftPanel, 'toggle');
            app.FatNavsSwitch.Orientation = 'horizontal';
            app.FatNavsSwitch.ValueChangedFcn = createCallbackFcn(app, @FatNavsSwitchValueChanged, true);
            app.FatNavsSwitch.FontSize = 14;
            app.FatNavsSwitch.FontWeight = 'bold';
            app.FatNavsSwitch.Position = [44 535 45 20];
            app.FatNavsSwitch.Value = 'On';

            % Create FatNavsDelaymsSpinner
            app.FatNavsDelaymsSpinner = uispinner(app.LeftPanel);
            app.FatNavsDelaymsSpinner.Limits = [0 Inf];
            app.FatNavsDelaymsSpinner.ValueChangedFcn = createCallbackFcn(app, @FatNavsDelaymsSpinnerValueChanged, true);
            app.FatNavsDelaymsSpinner.FontWeight = 'bold';
            app.FatNavsDelaymsSpinner.FontColor = [1 1 0.0667];
            app.FatNavsDelaymsSpinner.BackgroundColor = [0.8 0.8 0.8];
            app.FatNavsDelaymsSpinner.Position = [133 535 73 22];
            app.FatNavsDelaymsSpinner.Value = 10;

            % Create FatNavsDurSpinner
            app.FatNavsDurSpinner = uispinner(app.LeftPanel);
            app.FatNavsDurSpinner.Step = 50;
            app.FatNavsDurSpinner.Limits = [0 Inf];
            app.FatNavsDurSpinner.ValueChangedFcn = createCallbackFcn(app, @FatNavsDurSpinnerValueChanged, true);
            app.FatNavsDurSpinner.FontWeight = 'bold';
            app.FatNavsDurSpinner.FontColor = [0.5882 0.2941 0];
            app.FatNavsDurSpinner.BackgroundColor = [0.8 0.8 0.8];
            app.FatNavsDurSpinner.Position = [242 535 73 22];
            app.FatNavsDurSpinner.Value = 450;

            % Create PlotSwitchLabel
            app.PlotSwitchLabel = uilabel(app.LeftPanel);
            app.PlotSwitchLabel.HorizontalAlignment = 'center';
            app.PlotSwitchLabel.FontSize = 18;
            app.PlotSwitchLabel.FontWeight = 'bold';
            app.PlotSwitchLabel.FontColor = [0.851 0.3255 0.098];
            app.PlotSwitchLabel.Position = [7 500 39 24];
            app.PlotSwitchLabel.Text = 'Plot';

            % Create PlotSwitch
            app.PlotSwitch = uiswitch(app.LeftPanel, 'toggle');
            app.PlotSwitch.Items = {'T1', 'R1'};
            app.PlotSwitch.ValueChangedFcn = createCallbackFcn(app, @PlotSwitchValueChanged, true);
            app.PlotSwitch.FontSize = 14;
            app.PlotSwitch.FontWeight = 'bold';
            app.PlotSwitch.Position = [19 415 20 45];
            app.PlotSwitch.Value = 'T1';

            % Create B0TDropDownLabel
            app.B0TDropDownLabel = uilabel(app.LeftPanel);
            app.B0TDropDownLabel.HorizontalAlignment = 'right';
            app.B0TDropDownLabel.FontSize = 14;
            app.B0TDropDownLabel.FontWeight = 'bold';
            app.B0TDropDownLabel.Position = [46 464 44 22];
            app.B0TDropDownLabel.Text = 'B0 [T]';

            % Create MaxKnob
            app.MaxKnob = uiknob(app.LeftPanel, 'continuous');
            app.MaxKnob.Limits = [0 20];
            app.MaxKnob.MajorTicks = [0 5 10 15 20];
            app.MaxKnob.ValueChangedFcn = createCallbackFcn(app, @MaxKnobValueChanged, true);
            app.MaxKnob.FontSize = 14;
            app.MaxKnob.FontWeight = 'bold';
            app.MaxKnob.Position = [115 408 60 60];
            app.MaxKnob.Value = 5;

            % Create SampDensKnob
            app.SampDensKnob = uiknob(app.LeftPanel, 'continuous');
            app.SampDensKnob.Limits = [128 1024];
            app.SampDensKnob.MajorTicks = [128 256 384 512 640 768 896 1024];
            app.SampDensKnob.ValueChangedFcn = createCallbackFcn(app, @SampDensKnobValueChanged, true);
            app.SampDensKnob.FontSize = 14;
            app.SampDensKnob.FontWeight = 'bold';
            app.SampDensKnob.Position = [251 411 60 60];
            app.SampDensKnob.Value = 128;

            % Create B0TDropDown
            app.B0TDropDown = uidropdown(app.LeftPanel);
            app.B0TDropDown.Items = {'3', '7'};
            app.B0TDropDown.DropDownOpeningFcn = createCallbackFcn(app, @B0TDropDownOpening, true);
            app.B0TDropDown.ValueChangedFcn = createCallbackFcn(app, @B0TDropDownValueChanged, true);
            app.B0TDropDown.Tooltip = {'Only changes placement of T1/R1 lines for GM/WM/CSF'};
            app.B0TDropDown.FontSize = 14;
            app.B0TDropDown.FontWeight = 'bold';
            app.B0TDropDown.Position = [50 430 44 22];
            app.B0TDropDown.Value = '3';

            % Create MaxKnobLabel
            app.MaxKnobLabel = uilabel(app.LeftPanel);
            app.MaxKnobLabel.HorizontalAlignment = 'center';
            app.MaxKnobLabel.FontSize = 14;
            app.MaxKnobLabel.FontWeight = 'bold';
            app.MaxKnobLabel.Position = [127 381 33 22];
            app.MaxKnobLabel.Text = 'Max';

            % Create SampDensKnobLabel
            app.SampDensKnobLabel = uilabel(app.LeftPanel);
            app.SampDensKnobLabel.HorizontalAlignment = 'center';
            app.SampDensKnobLabel.FontSize = 14;
            app.SampDensKnobLabel.FontWeight = 'bold';
            app.SampDensKnobLabel.Position = [237 374 89 22];
            app.SampDensKnobLabel.Text = 'Samp. Dens.';

            % Create B1Label
            app.B1Label = uilabel(app.LeftPanel);
            app.B1Label.FontSize = 18;
            app.B1Label.FontWeight = 'bold';
            app.B1Label.FontColor = [0.851 0.3255 0.098];
            app.B1Label.Position = [8 337 28 24];
            app.B1Label.Text = 'B1';

            % Create B1inhomogeneityKnob
            app.B1inhomogeneityKnob = uiknob(app.LeftPanel, 'continuous');
            app.B1inhomogeneityKnob.MajorTicks = [0 10 20 30 40 50 60 70 80 90 100];
            app.B1inhomogeneityKnob.ValueChangedFcn = createCallbackFcn(app, @B1inhomogeneityKnobValueChanged, true);
            app.B1inhomogeneityKnob.FontSize = 14;
            app.B1inhomogeneityKnob.FontWeight = 'bold';
            app.B1inhomogeneityKnob.Position = [117 278 60 60];
            app.B1inhomogeneityKnob.Value = 40;

            % Create B1testsKnob
            app.B1testsKnob = uiknob(app.LeftPanel, 'discrete');
            app.B1testsKnob.Items = {'Off', '3', '5'};
            app.B1testsKnob.ValueChangedFcn = createCallbackFcn(app, @B1testsKnobValueChanged, true);
            app.B1testsKnob.FontSize = 14;
            app.B1testsKnob.FontWeight = 'bold';
            app.B1testsKnob.Position = [250 275 60 60];

            % Create B1inhomogeneityLabel
            app.B1inhomogeneityLabel = uilabel(app.LeftPanel);
            app.B1inhomogeneityLabel.HorizontalAlignment = 'center';
            app.B1inhomogeneityLabel.FontSize = 14;
            app.B1inhomogeneityLabel.FontWeight = 'bold';
            app.B1inhomogeneityLabel.Position = [76 238 151 22];
            app.B1inhomogeneityLabel.Text = 'B1 inhomogeneity (%)';

            % Create B1testsKnobLabel
            app.B1testsKnobLabel = uilabel(app.LeftPanel);
            app.B1testsKnobLabel.HorizontalAlignment = 'center';
            app.B1testsKnobLabel.FontSize = 14;
            app.B1testsKnobLabel.FontWeight = 'bold';
            app.B1testsKnobLabel.Position = [254 254 59 22];
            app.B1testsKnobLabel.Text = 'B1 tests';

            % Create SNRLabel
            app.SNRLabel = uilabel(app.LeftPanel);
            app.SNRLabel.FontSize = 18;
            app.SNRLabel.FontWeight = 'bold';
            app.SNRLabel.FontColor = [0.851 0.3255 0.098];
            app.SNRLabel.Position = [6 215 43 24];
            app.SNRLabel.Text = 'SNR';

            % Create SNRKnob
            app.SNRKnob = uiknob(app.LeftPanel, 'continuous');
            app.SNRKnob.ValueChangedFcn = createCallbackFcn(app, @SNRKnobValueChanged, true);
            app.SNRKnob.FontSize = 14;
            app.SNRKnob.FontWeight = 'bold';
            app.SNRKnob.Position = [118 153 60 60];
            app.SNRKnob.Value = 75;

            % Create SNRtestsKnob
            app.SNRtestsKnob = uiknob(app.LeftPanel, 'discrete');
            app.SNRtestsKnob.Items = {'Off', '1', '2', '4'};
            app.SNRtestsKnob.ValueChangedFcn = createCallbackFcn(app, @SNRtestsKnobValueChanged, true);
            app.SNRtestsKnob.FontSize = 14;
            app.SNRtestsKnob.FontWeight = 'bold';
            app.SNRtestsKnob.Position = [251 151 60 60];

            % Create SNRKnobLabel
            app.SNRKnobLabel = uilabel(app.LeftPanel);
            app.SNRKnobLabel.HorizontalAlignment = 'center';
            app.SNRKnobLabel.FontSize = 14;
            app.SNRKnobLabel.FontWeight = 'bold';
            app.SNRKnobLabel.Position = [134 126 35 22];
            app.SNRKnobLabel.Text = 'SNR';

            % Create SNRtestsKnobLabel
            app.SNRtestsKnobLabel = uilabel(app.LeftPanel);
            app.SNRtestsKnobLabel.HorizontalAlignment = 'center';
            app.SNRtestsKnobLabel.FontSize = 14;
            app.SNRtestsKnobLabel.FontWeight = 'bold';
            app.SNRtestsKnobLabel.Position = [247 130 71 22];
            app.SNRtestsKnobLabel.Text = 'SNR tests';

            % Create MessagesTextAreaLabel
            app.MessagesTextAreaLabel = uilabel(app.LeftPanel);
            app.MessagesTextAreaLabel.HorizontalAlignment = 'right';
            app.MessagesTextAreaLabel.FontSize = 18;
            app.MessagesTextAreaLabel.FontWeight = 'bold';
            app.MessagesTextAreaLabel.FontColor = [0.851 0.3255 0.098];
            app.MessagesTextAreaLabel.Position = [2 92 92 24];
            app.MessagesTextAreaLabel.Text = 'Messages';

            % Create MessagesTextArea
            app.MessagesTextArea = uitextarea(app.LeftPanel);
            app.MessagesTextArea.FontSize = 14;
            app.MessagesTextArea.FontWeight = 'bold';
            app.MessagesTextArea.Position = [106 11 242 105];
            app.MessagesTextArea.Value = {'Hello'};

            % Create CLamp
            app.CLamp = uilamp(app.LeftPanel);
            app.CLamp.Position = [25 26 44 44];

            % Create CLampLabel
            app.CLampLabel = uilabel(app.LeftPanel);
            app.CLampLabel.HorizontalAlignment = 'right';
            app.CLampLabel.FontColor = [0.6314 0.8196 0.3804];
            app.CLampLabel.Position = [6 37 25 22];
            app.CLampLabel.Text = 'C';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.BackgroundColor = [1 0.2 0.2];
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.RightPanel);
            app.GridLayout2.ColumnWidth = {'9.7x', '10.96x'};
            app.GridLayout2.RowHeight = {'8.21x', '20.42x', 200};
            app.GridLayout2.BackgroundColor = [0.6314 0.8196 0.3804];

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout2);
            title(app.UIAxes, 'Inv1')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.FontWeight = 'bold';
            if contains(ver("MATLAB").Release,'R2023b')
            app.UIAxes.GridLineWidth = 2;
            app.UIAxes.MinorGridLineWidth = 2;
            end
            app.UIAxes.LineWidth = 2;
            app.UIAxes.Color = [0.6314 0.8196 0.3804];
            app.UIAxes.Box = 'on';
            app.UIAxes.Layout.Row = 1;
            app.UIAxes.Layout.Column = 1;

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.GridLayout2);
            title(app.UIAxes2, 'Inv2')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.FontWeight = 'bold';
            if contains(ver("MATLAB").Release,'R2023b')
            app.UIAxes2.GridLineWidth = 2;
            app.UIAxes2.MinorGridLineWidth = 2;
            end
            app.UIAxes2.LineWidth = 2;
            app.UIAxes2.Color = [0.6314 0.8196 0.3804];
            app.UIAxes2.Box = 'on';
            app.UIAxes2.Layout.Row = 1;
            app.UIAxes2.Layout.Column = 2;

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.GridLayout2);
            app.UIAxes5.FontWeight = 'bold';
            app.UIAxes5.Layout.Row = 3;
            app.UIAxes5.Layout.Column = [1 2];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.GridLayout2);
            title(app.UIAxes3, 'UNI')
            xlabel(app.UIAxes3, 'X')
            ylabel(app.UIAxes3, 'Y')
            zlabel(app.UIAxes3, 'Z')
            app.UIAxes3.FontWeight = 'bold';
            if contains(ver("MATLAB").Release,'R2023b')
            app.UIAxes3.GridLineWidth = 2;
            app.UIAxes3.MinorGridLineWidth = 2;
            end
            app.UIAxes3.LineWidth = 2;
            app.UIAxes3.Color = [0.6314 0.8196 0.3804];
            app.UIAxes3.Box = 'on';
            app.UIAxes3.Layout.Row = 2;
            app.UIAxes3.Layout.Column = 1;

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.GridLayout2);
            title(app.UIAxes4, 'DSR')
            xlabel(app.UIAxes4, 'X')
            ylabel(app.UIAxes4, 'Y')
            zlabel(app.UIAxes4, 'Z')
            app.UIAxes4.FontWeight = 'bold';
            if contains(ver("MATLAB").Release,'R2023b')
            app.UIAxes4.GridLineWidth = 2;
            app.UIAxes4.MinorGridLineWidth = 2;
            end
            app.UIAxes4.LineWidth = 2;
            app.UIAxes4.Color = [0.6314 0.8196 0.3804];
            app.UIAxes4.Box = 'on';
            app.UIAxes4.Layout.Row = 2;
            app.UIAxes4.Layout.Column = 2;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = UNIDSR9ex

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end