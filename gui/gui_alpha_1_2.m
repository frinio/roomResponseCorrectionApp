function varargout = gui_alpha_1_2(varargin)
% GUI_ALPHA_1_2 MATLAB code for gui_alpha_1_2.fig
%      GUI_ALPHA_1_2, by itself, creates a new GUI_ALPHA_1_2 or raises the existing
%      singleton*.
%
%      H = GUI_ALPHA_1_2 returns the handle to a new GUI_ALPHA_1_2 or the handle to
%      the existing singleton*.
%
%      GUI_ALPHA_1_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ALPHA_1_2.M with the given input arguments.
%
%      GUI_ALPHA_1_2('Property','Value',...) creates a new GUI_ALPHA_1_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_alpha_1_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_alpha_1_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_alpha_1_2

% Last Modified by GUIDE v2.5 12-Jun-2017 13:17:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_alpha_1_2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_alpha_1_2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_alpha_1_2 is made visible.
function gui_alpha_1_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_alpha_1_2 (see VARARGIN)

% Choose default command line output for gui_alpha_1_2
handles.output = hObject;
%%%%%%%%%%%%%%%
handles.eq_details_pushbutton.Visible = 'off';
%%%%%%%%%%%%%%%

%Initialization
hObject.Position = [0.2 0.1 0.35 0.75];
setappdata(0, 'main_position', hObject.Position);
handles.mono = 0;
handles.vsbstates = {'off', 'on'};
handles.phase=0; handles.magn=0;
handles.cs_magn_val = 3; handles.cs_phase_val = 3; handles.fthr = 180;
handles.currentfolder = pwd;
handles.ir_for_cs = [];
handles.corresp = [];
handles.correction_flag = 0;
% Tool Tip for EQ Setting
tooltip = sprintf('Details on the selected EQ Settings');
handles.eq_details_pushbutton.TooltipString = tooltip;

% Left/Right Settings
setappdata(0, 'right', 0);
handles.phaseL=0; handles.magnL=0;
handles.phaseR=0; handles.magnR=0;
handles.poleL = 0; handles.poleR = 0;
handles.cs_magnL = 0; handles.cs_magnR = 0;
handles.cs_phaseL = 0; handles.cs_phaseR = 0;
handles.cs_magn_valL = 3; handles.cs_magn_valR = 3;
handles.cs_phase_valL = 3; handles.cs_phase_valR = 3;
handles.fthrL = 180; handles.fthrR = 180;
handles.phaseLLL = 0; handles.phaseLLR = 0;

% 
handles.vsb_magn_or = 'off'; handles.vsb_magn_eq = 'off';
handles.vsb_angle_or = 'off'; handles.vsb_angle_eq = 'off';
handles.vsb_imp_or = 'off'; handles.vsb_imp_eq = 'off';
handles.vsb_gd_or = 'off'; handles.vsb_gd_eq = 'off';
handles.vsb_std_or = 'off'; handles.vsb_std_eq = 'off';
handles.vsb_flatness_or = 'off'; handles.vsb_flatness_eq = 'off';

% Pole-Fitting GUI Default Settings
setappdata(0, 'target_rdb', 1);
setappdata(0, 'custom_target_rdb', 0);
setappdata(0, 'custom_path', '');
setappdata(0, 'fbt_type', 1);
setappdata(0, 'band_flag', 0);
setappdata(0, 'fbt_order', '');
setappdata(0, 'fc1', '');
setappdata(0, 'fc2', '');

setappdata(0, 'manual', 0);
setappdata(0, 'graphical', 0);

setappdata(0, 'inv_graph_fft', []);
setappdata(0, 'inv_imp_graph', []);
setappdata(0, 'eq_graph_fft', []);
setappdata(0, 'fp', []);
setappdata(0, 'inv_man_fft', []);
setappdata(0, 'inv_imp_man', []);
setappdata(0, 'eq_man_fft', []);
setappdata(0, 'fp_man', []);
setappdata(0, 'imp_cheby', []);
setappdata(0, 'target_imp', []);
setappdata(0, 'ctarget_imp', []);
setappdata(0, 'imp', []);
fsDefault = 44100;
setappdata(0, 'tbl_data', [10 fsDefault/2 20]);

%%%% STEREO GUI Default Setting
setappdata(0, 'room_ir2', []);
setappdata(0, 'fs2', []);
setappdata(0, 'path_ir2', '');
setappdata(0, 'path_ir', '');
setappdata(0, 'same', 1);
setappdata(0, 'dif', 0);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_alpha_1_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_alpha_1_2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function path_ir_edit_Callback(hObject, eventdata, handles)
% hObject    handle to path_ir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path_ir_edit as text
%        str2double(get(hObject,'String')) returns contents of path_ir_edit as a double
fullpath = hObject.String;
if exist(fullpath, 'file')~=2, errordlg('Invalid filename or path.', 'File Error'); return; end;
% If Path/Filename is valid
[handles.room_ir, handles.fs] = audioread(fullpath);

% Check for mono/stereo
size_ir = size(handles.room_ir);
if size_ir(2) == 1
    handles.room_ir_type = 'mono';
    % Normalize mono
    handles.room_ir = handles.room_ir/max(abs(handles.room_ir));
else
%     handles.room_ir_type = 'stereo';
%     handles.room_ir = norm_stereo(handles.room_ir);
      hObject.String = '';
      errordlg('Please load a monophonic IR file.', 'File Error');
      return;
end

handles.room_fresp = fft(handles.room_ir);
handles.magn_or = abs(handles.room_fresp);
handles.angle_or = angle(handles.room_fresp);
handles.gd_or = groupdelay(handles.room_ir, handles.fs);

% Assign and pass data through GUIs
assignin('base', 'room_ir', handles.room_ir);
assignin('base', 'fs_ir', handles.fs);
setappdata(0, 'room_ir', handles.room_ir);
setappdata(0, 'fs', handles.fs);

h = msgbox('IR file is loaded.','Success');    
guidata(hObject, handles);

function browse_ir_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to browse_ir_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.wav','Load IR file');
if (filename ~= 0)
    handles.room_ir_pathname = fullfile(pathname, filename);
    [handles.room_ir, handles.fs] = audioread(handles.room_ir_pathname);

    % Check for mono/stereo
    size_ir = size(handles.room_ir);
    if size_ir(2) == 1
        handles.mono = 1; handles.mono_checkbox.Value = 1;
        handles.stereo = 0; handles.stereo_checkbox.Value = 0;
        handles.left_togglebutton.Enable = 'off';
        handles.left_togglebutton.Value = 0;
        handles.right_togglebutton.Enable = 'off';
        handles.right_togglebutton.Value = 0;
        
        % Normalize mono
        handles.room_ir = handles.room_ir/max(abs(handles.room_ir));
    else
%         handles.room_ir = norm_stereo(handles.room_ir);
          errordlg('Please load a monophonic IR file.', 'File Error');
          return;
    end
    set(handles.path_ir_edit, 'String', handles.room_ir_pathname);
    %%% Responses %%%
    handles.room_fresp = fft(handles.room_ir);
    handles.magn_or = abs(handles.room_fresp);
    handles.angle_or = angle(handles.room_fresp);
    handles.gd_or = groupdelay(handles.room_ir, handles.fs);
    %%% Statistics %%%
    N = length(handles.magn_or);
    handles.magn_or_dbfs = db(handles.magn_or/max(abs(handles.magn_or)));
    [handles.mean_or, ~]=mean_oct(handles.magn_or_dbfs,3,N);
    [handles.std_or, handles.cntr_freq] = std_oct(handles.magn_or_dbfs,3,N);  
    [handles.flatness_or, ~] = flatness(handles.magn_or,3,N);
    
    % Assign and pass data through GUIs
    assignin('base', 'room_ir', handles.room_ir);
    assignin('base', 'fs_ir', handles.fs);
    setappdata(0, 'room_ir', handles.room_ir);
    setappdata(0, 'fs', handles.fs);
    setappdata(0, 'path_ir', handles.room_ir_pathname);
end

guidata(hObject, handles);

function view_magn_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to view_magn_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Use "handles.view_magn_togglebutton.Value" because "hObject.Value" change
% with simple call of the pushbutton's callback 
handles.vsb_magn_or = handles.vsbstates{1 + handles.view_magn_togglebutton.Value};
% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    handles.view_magn_togglebutton.Value = 0;   
else
    
    if (handles.view_magn_togglebutton.Value || handles.magn_togglebutton.Value)
        maxdb = max(db(handles.room_fresp));
        if ~ishandle(20)
            handles.f20=figure(20);
            set(0, 'CurrentFigure', 20);
            handles.magn_axes = axes;
        else
            set(0, 'CurrentFigure', 20);
        end
        handles.magn_axes.Parent = 20;
        handles.f20.Units = 'normalized';
        handles.f20_pos = handles.f20.Position;
        mainpos = getappdata(0, 'main_position');
        handles.f20.Position = [mainpos(1)+0.36 mainpos(2)+0.1 ...
            handles.f20_pos(3) handles.f20_pos(4)];
        % Original    
        hold off;
        if handles.left_togglebutton.Value || handles.mono
            magn_or_plot = semilogx(handles.magn_axes, fset(handles.magn_or, handles.fs), db(handles.magn_or));
            if handles.mono, handles.magn_axes.Title.String = 'Magnitude';
            else handles.magn_axes.Title.String = 'Left Channel: Magnitude'; end
        else
            handles.magn_orR = getappdata(0, 'magn_orR');
            magn_or_plot = semilogx(handles.magn_axes, fset(handles.magn_orR, handles.fs), db(handles.magn_orR));
            handles.magn_axes.Title.String = 'Right Channel: Magnitude';
        end
        magn_or_plot.Visible = handles.vsb_magn_or;
        % EQ
        if handles.correction_flag
            hold on;
            if handles.left_togglebutton.Value || handles.mono
                magn_eq_plot = semilogx(handles.magn_axes, fset(handles.magn_eq, handles.fs), db(handles.magn_eq), 'r');
                if handles.mono, handles.magn_axes.Title.String = 'Magnitude';
                else handles.magn_axes.Title.String = 'Left Channel: Magnitude'; end
            else
                magn_eq_plot = semilogx(handles.magn_axes, fset(handles.magn_eqR, handles.fs), db(handles.magn_eqR), 'r');
                handles.magn_axes.Title.String = 'Right Channel: Magnitude';
            end
            magn_eq_plot.Visible = handles.vsb_magn_eq;
            
            %%% LEGEND
            legend({'Original', 'EQ'}, 'Location', 'southeast',...
            'FontWeight', 'bold');
        end
        
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        xlim([10 handles.fs/2]);
        ylim([-40 maxdb]);

    else
       if ishandle(20), close(20); end
    end
    
end

guidata(hObject, handles);

function view_phase_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to view_phase_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.vsb_angle_or = handles.vsbstates{1 + handles.view_phase_togglebutton.Value};
% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    handles.view_phase_togglebutton.Value = 0;
    
else
    if (handles.view_phase_togglebutton.Value || handles.phase_togglebutton.Value)
        if ~ishandle(21)
            figure(21);
            set(0, 'CurrentFigure', 21);
            handles.phase_axes = axes;
        else
            set(0, 'CurrentFigure', 21);
        end
        handles.phase_axes.Parent = 21;
        % Original
        hold off;
        if handles.left_togglebutton.Value || handles.mono
           angle_or_plot = semilogx(handles.phase_axes, fset(handles.angle_or, handles.fs), (180/pi)*(handles.angle_or));
           if handles.mono, handles.phase_axes.Title.String = 'Phase';
           else handles.phase_axes.Title.String = 'Left Channel: Phase'; end
        elseif handles.right_togglebutton.Value
            handles.angle_orR = getappdata(0, 'angle_orR');
            angle_or_plot = semilogx(handles.phase_axes, fset(handles.angle_orR, handles.fs), (180/pi)*(handles.angle_orR));
            handles.phase_axes.Title.String = 'Right Channel: Phase';
        end
        angle_or_plot.Visible = handles.vsb_angle_or;
        % EQ
        if handles.correction_flag
            hold on;
            if handles.left_togglebutton.Value || handles.mono
                angle_eq_plot = semilogx(handles.phase_axes, fset(handles.angle_eq, handles.fs), (180/pi)*(handles.angle_eq), 'r');
                if handles.mono, handles.phase_axes.Title.String = 'Phase';
                else handles.phase_axes.Title.String = 'Left Channel: Phase'; end
            elseif handles.right_togglebutton.Value
                angle_eq_plot = semilogx(handles.phase_axes, fset(handles.angle_eqR, handles.fs), (180/pi)*(handles.angle_eqR), 'r');
                handles.phase_axes.Title.String = 'Right Channel: Phase';
            end
            angle_eq_plot.Visible = handles.vsb_angle_eq;
            
            %%% LEGEND
            legend({'Original', 'EQ'}, 'Location', 'southeast',...
            'FontWeight', 'bold');
        end
        
        xlabel('Frequency (Hz)');
        ylabel('Phase (degrees)');
        xlim([10 handles.fs/2]);

    else
       if ishandle(21), close(21); end
    end
end
guidata(hObject, handles);

function view_ir_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to view_ir_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

time_imp = [0:length(handles.room_ir)-1]/handles.fs;
handles.vsb_imp_or = handles.vsbstates{1 + handles.view_ir_togglebutton.Value};
% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    handles.view_ir_togglebutton.Value = 0;
    
else
    if (handles.view_ir_togglebutton.Value || handles.imp_togglebutton.Value)
        if ~ishandle(22)
            figure(22);
            set(0, 'CurrentFigure', 22);
            handles.imp_axes = axes;
        else
            set(0, 'CurrentFigure', 22);
        end
        handles.imp_axes.Parent = 22;
            
        hold off;
        % Original
        if handles.left_togglebutton.Value || handles.mono
            imp_or_plot = plot(handles.imp_axes, time_imp, handles.room_ir);
            if handles.mono, handles.imp_axes.Title.String = 'Impulse Response';
            else handles.imp_axes.Title.String = 'Left Channel: Impulse Response'; end
        else
            handles.room_ir2 = getappdata(0, 'room_ir2');
            time_imp2 = [0:length(handles.room_ir2)-1]/handles.fs;
            imp_or_plot = plot(handles.imp_axes, time_imp2, handles.room_ir2);
            handles.imp_axes.Title.String = 'Right Channel: Impulse Response';
        end
        imp_or_plot.Visible = handles.vsb_imp_or;
        % EQ
        if handles.correction_flag
            hold on;
            if handles.left_togglebutton.Value || handles.mono
                time_impeq = [0:length(handles.corimp)-1]/handles.fs;
                imp_eq_plot = plot(handles.imp_axes, time_impeq, handles.corimp, 'r');
                if handles.mono, handles.imp_axes.Title.String = 'Impulse Response';
                else handles.imp_axes.Title.String = 'Left Channel: Impulse Response'; end
            else
                time_impeq2 = [0:length(handles.corimpR)-1]/handles.fs;
                imp_eq_plot = plot(handles.imp_axes, time_impeq2, handles.corimpR, 'r');
                handles.imp_axes.Title.String = 'Right Channel: Impulse Response';
            end
            imp_eq_plot.Visible = handles.vsb_imp_eq;
            
            %%% LEGEND
            legend({'Original', 'EQ'}, 'Location', 'southeast',...
            'FontWeight', 'bold');
        end
        
        xlabel('Time (sec)');
        ylabel('Amplitude ');

    else
       if ishandle(22), close(22); end
    end
end
guidata(hObject, handles);

function view_gd_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to view_gd_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
handles.vsb_gd_or = handles.vsbstates{1 + handles.view_gd_togglebutton.Value};
% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    handles.view_gd_togglebutton.Value = 0; 
else
    if (handles.view_gd_togglebutton.Value || handles.gd_togglebutton.Value)
        if ~ishandle(23)
            figure(23);
            set(0, 'CurrentFigure', 23);
            handles.gd_axes = axes;
        else
            set(0, 'CurrentFigure', 23);
        end
        handles.gd_axes.Parent = 23;
            
        hold off;
        % Original
        if handles.left_togglebutton.Value || handles.mono
            gd_or_plot = semilogx(handles.gd_axes, fset(handles.gd_or, handles.fs), handles.gd_or);
            if handles.mono, handles.gd_axes.Title.String = 'Group Delay';
            else handles.gd_axes.Title.String = 'Left Channel: Group Delay'; end
        else
            handles.gd_orR = getappdata(0, 'gd_orR');
            gd_or_plot = semilogx(handles.gd_axes, fset(handles.gd_orR, handles.fs), handles.gd_orR);
            handles.gd_axes.Title.String = 'Right Channel: Group Delay';
        end
        gd_or_plot.Visible = handles.vsb_gd_or;
        % EQ
        if handles.correction_flag
            hold on;
            if handles.left_togglebutton.Value || handles.mono
                gd_eq_plot = semilogx(handles.gd_axes, fset(handles.gd_eq, handles.fs), handles.gd_eq, 'r');
                if handles.mono, handles.gd_axes.Title.String = 'Group Delay';
                else handles.gd_axes.Title.String = 'Left Channel: Group Delay'; end
            else
                gd_eq_plot = semilogx(handles.gd_axes, fset(handles.gd_eqR, handles.fs), handles.gd_eqR, 'r');
                handles.gd_axes.Title.String = 'Right Channel: Group Delay';
            end
            
            gd_eq_plot.Visible = handles.vsb_gd_eq;
            
            %%% LEGEND
            legend({'Original', 'EQ'}, 'Location', 'southeast',...
            'FontWeight', 'bold');
        end
        
        xlabel('Frequency (Hz)');
        ylabel('Group Delay (sec)');
        xlim([10 handles.fs/2]);
    else
       if ishandle(23), close(23); end
    end
    
end


guidata(hObject, handles);

function view_std_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to view_std_togglebutton (see GCBO)
handles.vsb_std_or = handles.vsbstates{1 + handles.view_std_togglebutton.Value};
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
else
    if (handles.view_std_togglebutton.Value || handles.std_togglebutton.Value)
        if ~ishandle(24)
            figure(24);
            set(0, 'CurrentFigure', 24);
            handles.std_axes = axes;
        else
            set(0, 'CurrentFigure', 24);
        end
        handles.std_axes.Parent = 24;
        
        hold off;
        % Original
        if handles.left_togglebutton.Value || handles.mono
            std_or_plot = errorbar(handles.std_axes, log10(handles.cntr_freq),handles.mean_or,...
                handles.std_or, 'b.','LineWidth',1,'MarkerSize',10);
            if handles.mono, handles.std_axes.Title.String = 'Standard Deviation';
            else handles.std_axes.Title.String = 'Left Channel: Standard Deviation'; end
            handles.cf = handles.cntr_freq;
        else
            handles.std_orR = getappdata(0, 'std_orR');
            handles.mean_orR = getappdata(0, 'mean_orR');
            handles.cntr_freqR = getappdata(0, 'cntr_freqR');
            std_or_plot = errorbar(handles.std_axes, log10(handles.cntr_freqR),handles.mean_orR,... 
                handles.std_orR,'b.','LineWidth',1,'MarkerSize',10);
            handles.std_axes.Title.String = 'Right Channel: Standard Deviation';
            handles.cf = handles.cntr_freqR;
        end
        std_or_plot.Visible = handles.vsb_std_or;
        % EQ
        if handles.correction_flag
            hold on;
            if handles.left_togglebutton.Value || handles.mono
                std_eq_plot = errorbar(handles.std_axes, log10(handles.cntr_freq_eq),handles.mean_eq,...
                handles.std_eq, 'r.','LineWidth',1,'MarkerSize',10); 
                if handles.mono, handles.std_axes.Title.String = 'Standard Deviation';
                else handles.std_axes.Title.String = 'Left Channel: Standard Deviation'; end
                handles.cf = handles.cntr_freq_eq;
            else
                std_eq_plot = errorbar(handles.std_axes, log10(handles.cntr_freq_eqR),handles.mean_eqR,... 
                handles.std_eqR,'r.','LineWidth',1,'MarkerSize',10);
                handles.std_axes.Title.String = 'Right Channel: Standard Deviation';
                handles.cf = handles.cntr_freq_eqR;
            end
             std_eq_plot.Visible = handles.vsb_std_eq;
            
            %%% LEGEND
            legend({'Original', 'EQ'}, 'Location', 'southeast',...
            'FontWeight', 'bold');
        end
       
        center_freqs = log10(handles.cf);
        xticks = center_freqs(1:3:length(center_freqs));
        xlabel('Frequency (Hz)', 'FontSize', 17); 
        ylabel('STD (dB)', 'FontSize', 17); 
        grid on; axis tight; t = axis;  
        handles.std_axes.XLim = [t(1) t(2)];
        t(3) = -36;
        handles.std_axes.YLim = [t(3) 0];
        set(handles.std_axes,'Xtick', xticks); 
        set(handles.std_axes,'Xticklabel',round(10.^get(handles.std_axes,'Xtick')));
        set(handles.std_axes,'Ytick',-72:3:0); 
    else
        if ishandle(24), close(24); end
    end
end
guidata(hObject, handles);

function view_flatness_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to view_flatness_togglebutton (see GCBO)
handles.vsb_flatness_or = handles.vsbstates{1 + handles.view_flatness_togglebutton.Value};
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
else
    if (handles.view_flatness_togglebutton.Value || handles.flatness_togglebutton.Value)
        if ~ishandle(25)
            figure(25);
            set(0, 'CurrentFigure', 25);
            handles.flatness_axes = axes;
        else
            set(0, 'CurrentFigure', 25);
        end
        handles.flatness_axes.Parent = 25;
        
        hold off;
        % Original
        if handles.left_togglebutton.Value || handles.mono
            flatness_or_plot = scatter(handles.flatness_axes,handles.cntr_freq,handles.flatness_or,15,'o'); 
            line_or_plot = line(handles.flatness_axes,handles.cntr_freq,handles.flatness_or); grid on; 
            set(gca,'XScale','log');
            if handles.mono, handles.flatness_axes.Title.String = 'Flatness';
            else handles.flatness_axes.Title.String = 'Left Channel: Flatness'; end
        else
            handles.flatness_orR = getappdata(0, 'flatness_orR');
            handles.cntr_freqR = getappdata(0, 'cntr_freqR');
            flatness_or_plot = scatter(handles.flatness_axes,handles.cntr_freqR,...
                handles.flatness_orR,15,'o'); 
            line_or_plot = line(handles.flatness_axes,handles.cntr_freqR,handles.flatness_orR); grid on; 
            set(gca,'XScale','log');
            handles.flatness_axes.Title.String = 'Right Channel: Flatness';
        end
        flatness_or_plot.Visible = handles.vsb_flatness_or;
        line_or_plot.Visible = handles.vsb_flatness_or;
         % EQ
        if handles.correction_flag
            hold on;
            if handles.left_togglebutton.Value || handles.mono
                flatness_eq_plot = scatter(handles.flatness_axes,handles.cntr_freq_eq,handles.flatness_eq,15,'ro'); 
                line_eq_plot = line(handles.flatness_axes,handles.cntr_freq_eq,handles.flatness_eq,'Color','red'); grid on; 
                set(gca,'XScale','log');
                if handles.mono, handles.flatness_axes.Title.String = 'Flatness';
                else handles.flatness_axes.Title.String = 'Left Channel: Flatness'; end
            else
                flatness_eq_plot = scatter(handles.flatness_axes,handles.cntr_freq_eqR,...
                    handles.flatness_eqR,15,'ro'); 
                line_eq_plot = line(handles.flatness_axes,handles.cntr_freq_eqR,handles.flatness_eqR,'Color','red'); grid on; 
                handles.flatness_axes.Title.String = 'Right Channel: Flatness';
            end
            flatness_eq_plot.Visible = handles.vsb_flatness_eq;
            line_eq_plot.Visible = handles.vsb_flatness_eq;
            %%% LEGEND
            legend([line_or_plot line_eq_plot], {'Original', 'EQ'}, 'Location', 'southeast',...
            'FontWeight', 'bold');
        end
        

        xlabel('Frequnecy (Hz)', 'FontSize', 17);
        ylabel('Flatness', 'FontSize', 17); 
        grid on; axis tight; 
        handles.flatness_axes.YLim = [0.5 1];
        handles.flatness_axes.Box = 'on';
    else
        if ishandle(25), close(25); end
    end
end
guidata(hObject, handles);


function mono_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to mono_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mono_checkbox

% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
else
    if ~get(hObject,'Value')
        set(hObject, 'Value', 1);
    end
    % Close displays
    if ishandle(20), close(20); end
    if ishandle(21), close(21); end
    if ishandle(22), close(22); end
    if ishandle(23), close(23); end
    if ishandle(40), close(40); end % Close details
    
    % Switching from stereo to mono. Mono has the EQ setting of Left
    % channel
    handles.stereo_checkbox.Value = 0;
    handles.stereo = 0;
    if ~handles.poleL && ~ handles.cs_magnL, handles.magn = 0; end
    if handles.poleL, handles.magn = 1; end
    if handles.cs_magnL, handles.magn = 2; end 
    if ~handles.cs_phaseL && ~ handles.phaseLLL, handles.phase = 0; end
    if handles.cs_phaseL, handles.phase = 1; end
    if handles.phaseLLL, handles.phase = 2; end


    handles.mono = hObject.Value;

    handles.left_togglebutton.Enable = 'off';
    handles.left_togglebutton.Value = 0;
    handles.right_togglebutton.Enable = 'off';
    handles.right_togglebutton.Value = 0;
    
    % Set EQ Settings
    switch handles.magn
        case 0
            handles.pole_checkbox.Value = 0;
            handles.cs_magn_checkbox.Value = 0;
        case 1
            handles.pole_checkbox.Value = 1;
            handles.cs_magn_checkbox.Value = 0;
        case 2
            handles.pole_checkbox.Value = 0;
            handles.cs_magn_checkbox.Value = 1;
    end
    switch handles.phase
        case 0
            handles.cs_phase_checkbox.Value = 0;
            handles.phaseLL_checkbox.Value = 0;
        case 1
            handles.cs_phase_checkbox.Value = 1;
            handles.phaseLL_checkbox.Value = 0;
        case 2
            handles.cs_phase_checkbox.Value = 0;
            handles.phaseLL_checkbox.Value = 1;
    end
end
guidata(hObject, handles);

function stereo_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to stereo_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stereo_checkbox
  
% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
else
    if ~hObject.Value
        hObject.Value= 1;
    end
    
    % Close displays
    if ishandle(20), close(20); end
    if ishandle(21), close(21); end
    if ishandle(22), close(22); end
    if ishandle(23), close(23); end
    if ishandle(40), close(40); end % Close details
    
    % Switching from mono to stereo. Left channel of stereo has the EQ
    % settings of mono
    handles.mono_checkbox.Value = 0;
    handles.mono = 0;
    if ~handles.magn, handles.poleL = 0; handles.cs_magnL = 0; end
    if handles.magn == 1, handles.poleL = 1; handles.cs_magnL = 0; end
    if handles.magn == 2, handles.poleL = 0; handles.cs_magnL = 1; end
    if ~handles.phase, handles.cs_phaseL = 0; handles.phaseLLL = 0; end
    if handles.phase == 1, handles.cs_phaseL = 1; handles.phaseLLL = 0; end
    if handles.phase == 2, handles.cs_phaseL = 0; handles.phaseLLL = 1; end

    handles.left_togglebutton.Enable = 'on';
    handles.left_togglebutton.Value = 1;
    handles.right_togglebutton.Enable = 'on';
    handles.right_togglebutton.Value = 0;
    handles.stereo = hObject.Value;
    
    % Set EQ Settings to Left Channel
    handles.pole_checkbox.Value = handles.poleL;
    handles.cs_magn_checkbox.Value = handles.cs_magnL;
    handles.cs_phase_checkbox.Value = handles.cs_phaseL;
    handles.phaseLL_checkbox.Value = handles.phaseLLL;
    
    % Open Stereo GUI
    s = stereo_gui;

    
    %%% WAIT FOR STEREO GUI TO CLOSE
    waitfor(s);
    disp('stereo settings are saved');
    swap_flag = getappdata(0, 'swap_flag');
    if swap_flag
        % Left
        handles.room_ir = getappdata(0, 'room_ir');
        handles.fs = getappdata(0, 'fs');
        handles.path_ir = getappdata(0, 'path_ir');
        handles.magn_or = getappdata(0, 'magn_or');
        handles.angle_or = getappdata(0, 'angle_or');
        handles.gd_or = getappdata(0, 'gd_or');
        handles.path_ir_edit.String = handles.path_ir;
        
    end

end
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%% EQ SETTINGS %%%%%%%%%%%%%%%%%%%%%

function left_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to left_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of left_togglebutton

if ~hObject.Value, hObject.Value = 1; disp('enter');end
handles.right_togglebutton.Value = 0;
setappdata(0, 'right', 0);
%%% LEFT CHANNEL SETTINGS
handles.pole_checkbox.Value = handles.poleL;
handles.cs_magn_checkbox.Value = handles.cs_magnL;
handles.cs_phase_checkbox.Value = handles.cs_phaseL;
handles.phaseLL_checkbox.Value = handles.phaseLLL;

%%% Display
disp('Left Channel');
if handles.cs_magnL
    disp('Magn CS'); disp(handles.cs_magn_valL);
elseif handles.poleL
    disp('Magn Pole-Fitting');
else
    disp('No Magn Correction');
end
if handles.cs_phaseL
    disp('Phase CS'); disp(handles.cs_phase_valL);
elseif handles.phaseLLL
    disp('Phase LL');
else
    disp('No Phase Correction');
end

%%% Check for open figures and change the response to the LEFT CHANNEL
if ishandle(20) %%% MAGNITUDE
    view_magn_togglebutton_Callback(hObject, eventdata, handles);
end
if ishandle(21) %%% PHASE
    view_phase_togglebutton_Callback(hObject, eventdata, handles);
end
if ishandle(22) %%% IMPULSE RESPONSE
    view_ir_togglebutton_Callback(hObject, eventdata, handles);
end
if ishandle(23) %%% GROUP DELAY
    view_gd_togglebutton_Callback(hObject, eventdata, handles);
end
if ishandle(24) %%% STANDARD DEVIATION
    view_std_togglebutton_Callback(hObject, eventdata, handles);
end
if ishandle(25) %%% FLATNESS
    view_flatness_togglebutton_Callback(hObject, eventdata, handles);
end
guidata(hObject, handles);

function right_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to right_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of right_togglebutton
handles.same = getappdata(0, 'same');

if ~hObject.Value, hObject.Value = 1; end
setappdata(0, 'right', hObject.Value);
handles.left_togglebutton.Value = 0;
%%% Right CHANNEL SETTINGS
if handles.same
    handles.poleR = handles.poleL;
    handles.cs_magnR = handles.cs_magnL;
    handles.pole_checkbox.Value = handles.poleR;
    handles.cs_magn_checkbox.Value = handles.cs_magnR;
else
    handles.pole_checkbox.Value = handles.poleR;
    handles.cs_magn_checkbox.Value = handles.cs_magnR;
    handles.cs_phase_checkbox.Value = handles.cs_phaseR;
    handles.phaseLL_checkbox.Value = handles.phaseLLR;
end

%%% Display
disp('Right Channel');
if handles.cs_magnR
    disp('Magn CS'); disp(handles.cs_magn_valR);
elseif handles.poleR
    disp('Magn Pole-Fitting');
else
    disp('No Magn Correction');
end
if handles.cs_phaseR
    disp('Phase CS'); disp(handles.cs_phase_valR);
elseif handles.phaseLLR
    disp('Phase LL');
else
    disp('No Phase Correction');
end

%%% Check for open figures and change the response to the RIGHT CHANNEL
if ishandle(20)
    view_magn_togglebutton_Callback(hObject, eventdata, handles);
end
if ishandle(21) %%% PHASE
    view_phase_togglebutton_Callback(hObject, eventdata, handles);
end
if ishandle(22) %%% IMPULSE RESPONSE
    view_ir_togglebutton_Callback(hObject, eventdata, handles);
end
if ishandle(23) %%% GROUP DELAY
    view_gd_togglebutton_Callback(hObject, eventdata, handles);
end
if ishandle(24) %%% STANDARD DEVIATION
    view_std_togglebutton_Callback(hObject, eventdata, handles);
end
if ishandle(25) %%% FLATNESS
    view_flatness_togglebutton_Callback(hObject, eventdata, handles);
end
guidata(hObject, handles);

function eq_details_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to eq_details_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open figre with details about the selected EQ settings
handles.tbl_fig = figure(40); handles.tbl_fig.Units = 'normalized';
handles.tbl_fig.Position = [0.5 0.1 0.25 0.15];
data = [1 1 1];
handles.tbl_eq = uitable(handles.tbl_fig, 'Data', data ,'ColumnName',...
            {''; 'Magnitude'; 'Phase'}, 'ColumnEditable',[false false false], ...
            'Units', 'normalized', 'Position', [0.1 0.1 0.8 0.8]); 
if handles.mono, handles.tbl_eq.RowName = '';
else
    if handles.same, filter = 'Same';
    else filter = 'Different';
    end
    handles.tbl_eq.RowName = {filter, 'Left', 'Right'};
end

function pole_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to pole_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pole_checkbox
handles.same = getappdata(0, 'same');

if ~hObject.Value
    if handles.mono || handles.same % button is not important, changes happen to both
        handles.magn = 0; % mono
        handles.magnL = 0; handles.magnR = 0;
        handles.poleL = 0; handles.poleR = 0;
    elseif ~handles.same && handles.left_togglebutton.Value
        handles.magn = 0; % mono, follows Left channel settings
        handles.magnL = 0;
        handles.poleL = 0;
    elseif ~handles.same && handles.right_togglebutton.Value
        handles.magnR = 0;
        handles.poleR = 0;
    end
        
end

% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
else
    if hObject.Value
        handles.cs_magn_checkbox.Value = 0; % Uncheck poles-fitting
        
        if handles.mono || handles.same 
            % Mono
            handles.magn = 1;
            % Same
            handles.cs_magnL = 0; handles.cs_magnR = 0;
            handles.poleL = 1; handles.poleR = 1;              
            handles.magnL = 1; handles.magnR = 1;
        elseif ~handles.same && handles.left_togglebutton.Value
            % Left
            handles.cs_magnL = 0; handles.poleL = 1;
            handles.magnL = 1;
            % Mono follows Left Channel
            handles.magn = 1;
        elseif ~handles.same && handles.right_togglebutton.Value
            % Right
            handles.cs_magnR = 0; handles.poleR = 1;
            handles.magnR = 1;
        end

        %Call Pole Fitting GUI
        pole_fitting
    end
end

guidata(hObject, handles);

function cs_magn_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to cs_magn_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cs_magn_checkbox
handles.same = getappdata(0, 'same');

if ~hObject.Value
    if handles.mono || handles.same % button is not important, changes happen to both
        handles.magn = 0; % mono
        handles.magnL = 0; handles.magnR = 0;
        handles.cs_magnL = 0; handles.cs_magnR = 0;
    elseif ~handles.same && handles.left_togglebutton.Value
        handles.magn = 0; % mono, follows Left channel settings
        handles.magnL = 0;
        handles.cs_magnL = 0;
    elseif ~handles.same && handles.right_togglebutton.Value
        handles.magnR = 0;
        handles.cs_magnR = 0;
    end
        
end

% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
else
    if hObject.Value
        handles.pole_checkbox.Value = 0; % Uncheck poles-fitting
        
        % Open Complex Smoothing Parameters Window
        prompt = {'Enter order (n) of fractional octave smoothing (1/n):'};
        dlg_title = 'Input';
        num_lines = 1;
        % Default answer
        if handles.mono
            defaultans = {num2str(handles.cs_magn_val)};
        else
            if handles.left_togglebutton.Value
                defaultans = {num2str(handles.cs_magn_valL)};
            elseif handles.right_togglebutton.Value
                defaultans = {num2str(handles.cs_magn_valR)};
            end
        end
        % Answer
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
        if ~isempty(answer)
            if handles.mono || handles.same 
                % Mono
                handles.cs_magn_val = str2double(answer);
                handles.magn = 2;
                % Same
                handles.cs_magnL = 1; handles.cs_magnR = 1;
                handles.poleL = 0; handles.poleR = 0;
                handles.cs_magn_valL = str2double(answer);
                handles.cs_magn_valR = str2double(answer);              
                handles.magnL = 2; handles.magnR = 2;
            elseif ~handles.same && handles.left_togglebutton.Value
                % Left
                handles.cs_magnL = 1; handles.poleL = 0;
                handles.cs_magn_valL = str2double(answer);
                handles.magnL = 2;
                % Mono follows Left Channel
                handles.cs_magn_val = str2double(answer);
                handles.magn = 2;
            elseif ~handles.same && handles.right_togglebutton.Value
                % Right
                handles.cs_magnR = 1; handles.poleR = 0;
                handles.cs_magn_valR = str2double(answer);
                handles.magnR = 2;
            end
        end

    end
end
        

guidata(hObject, handles);

function cs_phase_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to cs_phase_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cs_phase_checkbox
handles.same = getappdata(0, 'same');

if ~hObject.Value
    if handles.mono || handles.same
        handles.phase = 0; % mono
        handles.phaseL = 0; handles.phaseR = 0; 
        handles.cs_phaseL = 0; handles.cs_phaseR = 0;
    elseif ~handles.same && handles.left_togglebutton.Value
        handles.phase = 0; % mono, follows Left channel settings
        handles.phaseL = 0;
        handles.cs_phaseL = 0;
    elseif ~handles.same && handles.right_togglebutton.Value
        handles.phaseR = 0;
        handles.cs_phaseR = 0;
    end        
end

% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
else
    if hObject.Value
        handles.phaseLL_checkbox.Value = 0; % Uncheck poles-fitting
        
        % Open Complex Smoothing Parameters Window
        prompt = {'Enter order (n) of fractional octave smoothing (1/n):'};
        dlg_title = 'Input';
        num_lines = 1;
        % Default answer
        if handles.mono
            defaultans = {num2str(handles.cs_phase_val)};
        else
            if handles.left_togglebutton.Value
                defaultans = {num2str(handles.cs_phase_valL)};
            elseif handles.right_togglebutton.Value
                defaultans = {num2str(handles.cs_phase_valR)};
            end
        end
        % Answer
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
        if ~isempty(answer)
            if handles.mono || handles.same
                % Mono
                handles.cs_phase_val = str2double(answer);
                handles.phase = 1;
                % Same
                handles.cs_phaseL = 1; handles.cs_phaseR = 1;
                handles.phaseLLL = 0; handles.phaseLLR = 0;
                handles.cs_phase_valL = str2double(answer);
                handles.cs_phase_valR = str2double(answer);              
                handles.phaseL = 1; handles.phaseR = 1;
            elseif ~handles.same && handles.left_togglebutton.Value
                % Left
                handles.cs_phaseL = 1; handles.phaseLLL = 0;
                handles.cs_phase_valL = str2double(answer);
                handles.phaseL = 1;
                % Mono follows Left Channel
                handles.cs_phase_val = str2double(answer);
                handles.phase = 1;
            elseif ~handles.same && handles.right_togglebutton.Value
                % Right
                handles.cs_phaseR = 1; handles.phaseLLR = 0;
                handles.cs_phase_valR = str2double(answer);
                handles.phaseR = 1;
            end
        end
    end
end
        
guidata(hObject, handles);

function phaseLL_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to phaseLL_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of phaseLL_checkbox

handles.same = getappdata(0, 'same');

if ~hObject.Value
    if handles.mono || handles.same
        handles.phase = 0; % mono
        handles.phaseL = 0; handles.phaseR = 0; 
        handles.phaseLLL = 0; handles.phaseLLR = 0;
    elseif ~handles.same && handles.left_togglebutton.Value
        handles.phase = 0; % mono, follows Left channel settings
        handles.phaseL = 0;
        handles.phaseLLL = 0;
    elseif ~handles.same && handles.right_togglebutton.Value
        handles.phaseR = 0;
        handles.phaseLLR = 0;
    end        
end
% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
else
    if hObject.Value
        handles.cs_phase_checkbox.Value = 0; % Uncheck poles-fitting
        
        % Open Complex Smoothing Parameters Window
        prompt = {'Enter order (n) of fractional octave smoothing (1/n):',...
           'Enter frequency threshold (in Hz):'};
        dlg_title = 'Input';
        num_lines = 1;
        % Default answer
        if handles.mono
            defaultans = {num2str(handles.cs_phase_val), num2str(handles.fthr)};
        else
            if handles.left_togglebutton.Value
                defaultans = {num2str(handles.cs_phase_valL), num2str(handles.fthrL)};
            elseif handles.right_togglebutton.Value
                defaultans = {num2str(handles.cs_phase_valR), num2str(handles.fthrR)};
            end
        end
        % Answer
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
        if ~isempty(answer)
            if handles.mono || handles.same
                % Mono
                handles.cs_phase_val = str2double(answer(1,1));
                handles.fthr = str2double(answer(2,1));
                handles.phase = 2;
                % Same
                handles.cs_phaseL = 0; handles.cs_phaseR = 0;
                handles.phaseLLL = 1; handles.phaseLLR = 1;
                handles.cs_phase_valL = str2double(answer(1,1));
                handles.cs_phase_valR = str2double(answer(1,1));
                handles.fthrL = str2double(answer(2,1));
                handles.fthrR = str2double(answer(2,1));
                handles.phaseL = 2; handles.phaseR = 2;
            elseif ~handles.same && handles.left_togglebutton.Value
                % Left
                handles.cs_phaseL = 0; handles.phaseLLL = 1;
                handles.cs_phase_valL = str2double(answer(1,1));
                handles.fthrL = str2double(answer(2,1));
                handles.phaseL = 2;
                % Mono follows Left Channel
                handles.cs_phase_val = str2double(answer(1,1));
                handles.fthr = str2double(answer(2,1));
                handles.phase = 2;
            elseif ~handles.same && handles.right_togglebutton.Value
                % Right
                handles.cs_phaseR = 0; handles.phaseLLR = 1;
                handles.cs_phase_valR = str2double(answer(1,1));
                handles.fthrR = str2double(answer(2,1));
                handles.phaseR = 2;
            end
        end
    end
end
        
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%% CORRECTION %%%%%%%%%%%%%%%%%%%%%

function calc_correction_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to calc_correction_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.mono && ~handles.magn && ~handles.phase 
    errordlg('Please select Magnitude/Phase correction settings.', 'Calculation Error');
    return;
end
if handles.stereo && ~handles.magnL && ~handles.phaseL 
    errordlg('Please select Magnitude/Phase correction settings.', 'Calculation Error');
    return;
end
if handles.stereo && ~handles.magnR && ~handles.phaseR 
    errordlg('Please select Magnitude/Phase correction settings for Right Channel.', 'Calculation Error');
    return;
end
set(handles.figure1, 'Pointer', 'watch');
handles.correction_flag = 1;
clear handles.corimp;
clear handles.corresp;
handles.same = getappdata(0, 'same');
handles.room_ir2 = getappdata(0, 'room_ir2');

% MONO correction or STEREO for LEFT channel w/ SAME or DIFFERENT mode on
% This means that LEFT channel correction is calculated in all modes
if handles.phase==0 || handles.phaseL ==0, correction = 'magn'; end
if handles.magn==0 || handles.magnL==0, correction = 'phase'; end
if (handles.phase>0 && handles.magn>0) || (handles.phaseL>0 && handles.magnL>0)  
    correction = 'both';
end

disp('LEFT CHANNEL');
switch correction
    case 'magn'
        % Magnitude Correction ONLY
        disp('magn');
        if handles.magn == 1
            % Magn: Pole-fit
             disp('Magn: Pole-fit');
             handles.inv_pf_imp = getappdata(0, 'inv_imp');
             handles.ir = handles.room_ir;
             guidata(handles.figure1, handles);
             
             corimp = pole_magn(handles); % call function
             handles = guidata(handles.figure1); % get handles
             handles.corimp = corimp; % Update handles
             handles.inv = handles.invIR;
        elseif handles.magn == 2
            % Magn: CS
             disp('Magn: CS');
             % Force same order smoothing in magn and phase
             if handles.mono
                 handles.csmagn_order = handles.cs_magn_val;
                 handles.csphase_order = handles.cs_magn_val;
             else
                 handles.csmagn_order = handles.cs_magn_valL;
                 handles.csphase_order = handles.cs_magn_valL;
             end
             handles.ir_for_cs = handles.room_ir;
             handles.ir = handles.room_ir;
             guidata(handles.figure1, handles);
             
             corimp = cs_magn(handles); % call function
             handles = guidata(handles.figure1); % get handles
             handles.corimp = corimp; % Update handles
             handles.inv = handles.invIR;       
        end       
    case 'phase'
        % Phase Correction ONLY
        disp('phase');
        if handles.phase == 1
            % Phase: CS
             disp('Phase: CS');
             % Force same order smoothing in magn and phase
             if handles.mono
                handles.csmagn_order = handles.cs_phase_val;
                handles.csphase_order = handles.cs_phase_val;
             else
                handles.csmagn_order = handles.cs_phase_valL;
                handles.csphase_order = handles.cs_phase_valL;
             end             
             handles.ir_for_cs = handles.room_ir;
             handles.ir = handles.room_ir;
             guidata(handles.figure1, handles);

             corimp = cs_phase(handles);
             handles = guidata(handles.figure1); % Get handles
             handles.corimp = corimp; % Update handles
             handles.inv = handles.invIR;
        elseif handles.phase == 2
            % Phase: LL
             disp('Phase: LL');
             % Force same order smoothing in magn and phase
             if handles.mono
                handles.csmagn_order = handles.cs_phase_val;
                handles.csphase_order = handles.cs_phase_val;
                handles.fthreshold = handles.fthr;
             else
                handles.csmagn_order = handles.cs_phase_valL;
                handles.csphase_order = handles.cs_phase_valL;
                handles.fthreshold = handles.fthrL;
             end
             handles.ir = handles.room_ir;
             guidata(hObject, handles);
             ir_for_LL = preLL(handles);
             handles = guidata(handles.figure1); % Take handles for t variable
             handles.ir_for_cs = ir_for_LL;             
             guidata(handles.figure1, handles);  % Update
             
             corimp = LL_phase(handles);
             handles = guidata(handles.figure1); % Get handles
             handles.corimp = corimp; % Update handles
             handles.inv = handles.invIR;
        end
    case 'both'
        % Magnitude AND Phase Correction
        disp('both');
        if handles.magn == 2
            % Apply complex smoothing in magnitude
            if handles.phase == 1
                % CS and CS
                 disp('Magn: CS / Phase: CS');
                 if handles.mono
                    handles.csmagn_order = handles.cs_magn_val;
                    handles.csphase_order = handles.cs_phase_val;
                 else
                    handles.csmagn_order = handles.cs_magn_valL;
                    handles.csphase_order = handles.cs_phase_valL;
                 end               
                 handles.ir_for_cs = handles.room_ir;
                 handles.ir = handles.room_ir;
                 guidata(handles.figure1, handles);
                 
                 corimp = cs_both(handles);
                 handles = guidata(handles.figure1); % Get handles
                 handles.corimp = corimp; % Update handles
                 handles.inv = handles.invIR;
            elseif handles.phase == 2
                % CS and LL
                 disp('Magn: CS / Phase: LL');             
                 if handles.mono
                    handles.csmagn_order = handles.cs_magn_val;
                    handles.csphase_order = handles.cs_phase_val;
                    handles.fthreshold = handles.fthr;
                 else
                    handles.csmagn_order = handles.cs_magn_valL;
                    handles.csphase_order = handles.cs_phase_valL;
                    handles.fthreshold = handles.fthrL;
                 end
                 handles.ir = handles.room_ir;
                 guidata(hObject, handles);
                 ir_for_LL = preLL(handles);
                 handles = guidata(handles.figure1); % Take handles for t variable
                 handles.ir_for_LL = ir_for_LL;
                 guidata(handles.figure1, handles); % Update
    
                 corimp = cs_LL(handles);
                 handles = guidata(handles.figure1); % Get handles
                 handles.corimp = corimp; % Update handles
                 handles.inv = handles.invIR;
            end
        else
            % Apply pole fitting in magnitude
            if handles.phase == 1
                % Pole-Fit and CS
                disp('Magn: Pole-Fit / Phase: CS');
                % Force same order smoothing in magn and phase
                 if handles.mono
                    handles.csmagn_order = handles.cs_phase_val;
                    handles.csphase_order = handles.cs_phase_val;
                 else
                    handles.csmagn_order = handles.cs_phase_valL;
                    handles.csphase_order = handles.cs_phase_valL;
                 end             
                 handles.ir_for_cs = handles.room_ir;
                 handles.ir = handles.room_ir;
                 handles.inv_pf_imp = getappdata(0, 'inv_imp');
                 guidata(handles.figure1, handles);

                 corimp = pole_cs(handles);
                 handles = guidata(handles.figure1); % Get handles
                 handles.corimp = corimp; % Update handles
                 handles.inv = handles.invIR;
            elseif handles.phase == 2
                % Pole-Fit and LL
                disp('Magn: Pole-Fit / Phase: LL');
                % Force same order smoothing in magn and phase
                 if handles.mono
                    handles.csmagn_order = handles.cs_phase_val;
                    handles.csphase_order = handles.cs_phase_val;
                    handles.fthreshold = handles.fthr;
                 else
                    handles.csmagn_order = handles.cs_phase_valL;
                    handles.csphase_order = handles.cs_phase_valL;
                    handles.fthreshold = handles.fthrL;
                 end
                 handles.ir = handles.room_ir;
                 guidata(hObject, handles);
                 ir_for_LL = preLL(handles);
                 handles = guidata(handles.figure1); % Take handles for t variable
                 handles.ir_for_cs = ir_for_LL;
                 handles.inv_pf_imp = getappdata(0, 'inv_imp');
                 guidata(handles.figure1, handles);  % Update

                 corimp = pole_LL(handles);
                 handles = guidata(handles.figure1); % Get handles
                 handles.corimp = corimp; % Update
                 handles.inv = handles.invIR;
            end
        end
end

% Correction for RIGHT CHANNEL for mode: STEREO correction w/ DIFFERENT filter
if handles.stereo && ~handles.same 
    if handles.phaseR==0, correction = 'magn'; end
    if handles.magnR==0 , correction = 'phase'; end
    if (handles.phaseR>0 && handles.magnR>0),  correction = 'both'; end
    disp('RIGHT CHANNEL');
    switch correction       
        case 'magn'
            % Magnitude Correction ONLY
            disp('magn');
            if handles.magnR == 1
                % Magn: Pole-Fitting
                disp('Magn: Pole-fit');
                disp(getappdata(0, 'test'));
                % GET RIGHT CHANNEL POLE-FIT INV
                handles.inv_pf_imp = getappdata(0, 'inv_impR');
                getappdata(0, 'test');
                handles.ir = handles.room_ir2;
                guidata(handles.figure1, handles);

                corimpR = pole_magn(handles);
                handles = guidata(handles.figure1); % get handles.
                handles.corimpR = corimpR; %update handles
                handles.invR = handles.invIR;
            elseif handles.magnR == 2
                % Magn: CS
                 disp('Magn: CS');
                 % Force same order smoothing in magn and phase
                 handles.csmagn_order = handles.cs_magn_valR;
                 handles.csphase_order = handles.cs_magn_valR;
                 handles.ir_for_cs = handles.room_ir2;
                 handles.ir = handles.room_ir2;
                 guidata(handles.figure1, handles);

                 corimpR = cs_magn(handles);
                 handles = guidata(handles.figure1); % get handles.
                 handles.corimpR = corimpR; %update handles
                 handles.invR = handles.invIR;
            end
        case 'phase'
            % Phase Correction ONLY
            disp('phase');
            if handles.phaseR == 1
                % Phase: CS
                disp('Phase: CS');
                % Force same order smoothing in magn and phase
                handles.csmagn_order = handles.cs_phase_valR;
                handles.csphase_order = handles.cs_phase_valR;
                handles.ir_for_cs = handles.room_ir2;
                handles.ir = handles.room_ir2;
                guidata(handles.figure1, handles);

                corimpR = cs_phase(handles);
                handles = guidata(handles.figure1); % Get handles
                handles.corimpR = corimpR; % Update handles
                handles.invR = handles.invIR;
             elseif handles.phaseR == 2
                % Phase: LL
                disp('Phase: LL');
                % Force same order smoothing in magn and phase
                handles.csmagn_order = handles.cs_phase_valR;
                handles.csphase_order = handles.cs_phase_valR;
                handles.fthreshold = handles.fthrR;                
                handles.ir = handles.room_ir2;
                guidata(hObject, handles);
                ir_for_LL = preLL(handles);
                handles = guidata(handles.figure1); % Take handles for t variable
                handles.ir_for_cs = ir_for_LL;             
                guidata(handles.figure1, handles);  % Update

                corimpR = LL_phase(handles);
                handles = guidata(handles.figure1); % Get handles
                handles.corimpR = corimpR; % Update handles
                handles.invR = handles.invIR;              
            end
        case 'both'
            % Magnitude AND Phase Correction
            disp('both');
            if handles.magnR == 2
                % Apply complex smoothing in magnitude
                if handles.phaseR == 1
                    % CS and CS
                    disp('Magn: CS / Phase: CS');
                    handles.csmagn_order = handles.cs_magn_valR;
                    handles.csphase_order = handles.cs_phase_valR;
                    handles.ir_for_cs = handles.room_ir2;
                    handles.ir = handles.room_ir2;
                    guidata(handles.figure1, handles);
                 
                    corimpR = cs_both(handles);
                    handles = guidata(handles.figure1); % Get handles
                    handles.corimpR = corimpR; % Update handles
                    handles.invR = handles.invIR;
                elseif handles.phaseR == 2
                    % CS and LL
                    disp('Magn: CS / Phase: LL');
                    handles.csmagn_order = handles.cs_magn_valR;
                    handles.csphase_order = handles.cs_phase_valR;
                    handles.fthreshold = handles.fthrR;
                    
                    handles.ir = handles.room_ir2;
                    guidata(hObject, handles);
                    ir_for_LL = preLL(handles);
                    handles = guidata(handles.figure1); % Take handles for t variable
                    handles.ir_for_LL = ir_for_LL;
                    guidata(handles.figure1, handles); % Update

                    corimpR = cs_LL(handles);
                    handles = guidata(handles.figure1); % Get handles
                    handles.corimpR = corimpR; % Update handles
                    handles.invR = handles.invIR;
                end
            else
                % Apply pole fitting in magnitude
                if handles.phaseR == 1
                    % Pole-Fit and CS
                    disp('Magn: Pole-Fit / Phase: CS');
                    % Force same order smoothing in magn and phase
                    handles.csmagn_order = handles.cs_phase_valR;
                    handles.csphase_order = handles.cs_phase_valR;
             
                     handles.ir_for_cs = handles.room_ir2;
                     handles.ir = handles.room_ir2;
                     handles.inv_pf_imp = getappdata(0, 'inv_impR');
                     guidata(handles.figure1, handles);

                     corimpR = pole_cs(handles);
                     handles = guidata(handles.figure1); % Get handles
                     handles.corimpR = corimpR; % Update handles
                     handles.invR = handles.invIR;
                elseif handles.phaseR == 2
                    % Pole-Fit and LL
                    disp('Magn: Pole-Fit / Phase: LL');
                    % Force same order smoothing in magn and phase
                    handles.csmagn_order = handles.cs_phase_valR;
                    handles.csphase_order = handles.cs_phase_valR;
                    handles.fthreshold = handles.fthrR;
                    handles.ir = handles.room_ir2;
                    guidata(hObject, handles);
                    ir_for_LL = preLL(handles);
                    handles = guidata(handles.figure1); % Take handles for t variable
                    handles.ir_for_cs = ir_for_LL;
                    handles.inv_pf_imp = getappdata(0, 'inv_impR');
                    guidata(handles.figure1, handles);  % Update

                    corimpR = pole_LL(handles);
                    handles = guidata(handles.figure1); % Get handles
                    handles.corimpR = corimpR; % Update handles
                    handles.invR = handles.invIR;
                end
            end
    end
end


%%% Time and Frequency domain responses
if handles.mono
    assignin('base', 'corimp', handles.corimp);
    handles.corresp = fft(handles.corimp);
    handles.magn_eq = abs(handles.corresp);
    handles.angle_eq = angle(handles.corresp);
    handles.gd_eq = groupdelay(handles.corimp, handles.fs);
    M = length(handles.magn_eq);
    handles.magn_eq_dbfs = db(handles.magn_eq/max(abs(handles.magn_eq)));
    [handles.mean_eq, ~]=mean_oct(handles.magn_eq_dbfs,3,M);
    [handles.std_eq, handles.cntr_freq_eq] = std_oct(handles.magn_eq_dbfs,3,M);  
    [handles.flatness_eq, ~] = flatness(handles.magn_eq,3,M);
    
    handles.EQ_IR = handles.corimp;
    handles.INV_IR = handles.inv;
    assignin('base', 'EQ_IR', handles.EQ_IR);
    assignin('base', 'INV_IR', handles.INV_IR);
elseif handles.same
    % If same filter, handles.corimp has 2 channels
    handles.corimpL = handles.corimp(:,1);
    handles.corimpR = handles.corimp(:,2);
    assignin('base', 'corimpL', handles.corimpL);
    assignin('base', 'corimpR', handles.corimpR);
    handles.corresp = fft(handles.corimpL);
    handles.correspR = fft(handles.corimpR);
    handles.magn_eq = abs(handles.corresp);
    handles.magn_eqR = abs(handles.correspR);
    handles.angle_eq = angle(handles.corresp);
    handles.angle_eqR = angle(handles.correspR);
    handles.gd_eq = groupdelay(handles.corimp, handles.fs);
    handles.gd_eqR = groupdelay(handles.corimpR, handles.fs); 
    handles.corimp = handles.corimpL;
    
    M1 = length(handles.magn_eq);
    M2 = length(handles.magn_eqR);
    handles.magn_eq_dbfs = db(handles.magn_eq/max(abs(handles.magn_eq)));
    handles.magn_eqR_dbfs = db(handles.magn_eqR/max(abs(handles.magn_eqR)));
    [handles.mean_eq, ~]=mean_oct(handles.magn_eq_dbfs,3,M1);
    [handles.mean_eqR, ~]=mean_oct(handles.magn_eqR_dbfs,3,M2);
    [handles.std_eq, handles.cntr_freq_eq] = std_oct(handles.magn_eq_dbfs,3,M1);
    [handles.std_eqR, handles.cntr_freq_eqR] = std_oct(handles.magn_eqR_dbfs,3,M2);
    [handles.flatness_eq, ~] = flatness(handles.magn_eq,3,M1);
    [handles.flatness_eqR, ~] = flatness(handles.magn_eqR,3,M2);
    
    % stereo
    handles.EQ_IR = [handles.corimpL handles.corimpR];
    handles.INV_IR = [handles.inv handles.inv];
    assignin('base', 'EQ_IR', handles.EQ_IR);
    assignin('base', 'INV_IR', handles.INV_IR);
else
    handles.corimpL = handles.corimp;
    assignin('base', 'corimpL', handles.corimpL);
    assignin('base', 'corimpR', handles.corimpR);
     % Due to different filters for each channel, lengths don't match
     %%% CORRECTED IR
    if length(handles.corimpL) > length(handles.corimpR)
        zer = length(handles.corimpL)-length(handles.corimpR);
        handles.corimpR = [handles.corimpR' zeros(1, zer)];
        handles.corimpR = handles.corimpR';
    elseif length(handles.corimpR) > length(handles.corimpL)
        zer = length(handles.corimpR)-length(handles.corimpL);
        handles.corimpL = [handles.corimpL' zeros(1, zer)];
        handles.corimpL = handles.corimpL';
    end
    %%% INVERSE IR
    if length(handles.inv) > length(handles.invR)
        zer = length(handles.inv)-length(handles.invR);
        handles.invR = [handles.invR' zeros(1, zer)];
        handles.invR = handles.invR';
    elseif length(handles.invR) > length(handles.inv)
        zer = length(handles.invR)-length(handles.inv);
        handles.inv = [handles.inv' zeros(1, zer)];
        handles.inv = handles.inv';
    end
    handles.corresp = fft(handles.corimpL);
    handles.correspR = fft(handles.corimpR);
    handles.magn_eq = abs(handles.corresp);
    handles.magn_eqR = abs(handles.correspR);
    handles.angle_eq = angle(handles.corresp);
    handles.angle_eqR = angle(handles.correspR);
    handles.gd_eq = groupdelay(handles.corimp, handles.fs);
    handles.gd_eqR = groupdelay(handles.corimpR, handles.fs);
    
    M1 = length(handles.magn_eq);
    M2 = length(handles.magn_eqR);
    handles.magn_eq_dbfs = db(handles.magn_eq/max(abs(handles.magn_eq)));
    handles.magn_eqR_dbfs = db(handles.magn_eqR/max(abs(handles.magn_eqR)));
    [handles.mean_eq, ~]=mean_oct(handles.magn_eq_dbfs,3,M1);
    [handles.mean_eqR, ~]=mean_oct(handles.magn_eqR_dbfs,3,M2);
    [handles.std_eq, handles.cntr_freq_eq] = std_oct(handles.magn_eq_dbfs,3,M1);
    [handles.std_eqR, handles.cntr_freq_eqR] = std_oct(handles.magn_eqR_dbfs,3,M2);
    [handles.flatness_eq, ~] = flatness(handles.magn_eq,3,M1);
    [handles.flatness_eqR, ~] = flatness(handles.magn_eqR,3,M2);
    % stereo
    handles.EQ_IR = [handles.corimpL handles.corimpR];
    handles.INV_IR = [handles.inv handles.invR];
    assignin('base', 'EQ_IR', handles.EQ_IR);
    assignin('base', 'INV_IR', handles.INV_IR);
end
h = msgbox('Correction is completed','Success');
set(handles.figure1, 'Pointer', 'arrow');
guidata(hObject, handles);

function corrected_imp = cs_both(handles)
handles = guidata(handles.figure1);

% Delete and write in bin folder
del_wr_bin(handles);

fid = fopen('C:\bin\inv-l.txt');
cellarray = textscan(fid, '%f'); % inverse smoothed
fclose(fid);
handles.inv_sm_ir = cellarray{1};
% handles.inv_sm_ir = [handles.inv_sm_ir' zeros(1,length(handles.room_ir)-length(handles.inv_sm_ir))];
% handles.inv_sm_ir = handles.inv_sm_ir';
handles.invIR = handles.inv_sm_ir;
assignin('base', 'inv_sm_ir', handles.inv_sm_ir);
assignin('base', 'invIR', handles.invIR);

c = FFTconv(handles.ir, handles.invIR);
c = c/max(abs(c));
corrected_imp = c;
if handles.stereo && handles.same
    c2 = FFTconv(handles.room_ir2, handles.invIR);
    c2 = c2/max(abs(c2));
    corrected_imp = [c c2];
end
guidata(handles.figure1, handles);

function corrected_imp = pole_cs(handles)
handles = guidata(handles.figure1);

% Delete and write in bin folder
del_wr_bin(handles);

% GET INV SMOOTHED SIGNAL
fid = fopen('C:\bin\inv-l.txt');
cellarray = textscan(fid, '%f'); % inverse smoothed
fclose(fid);
handles.inv_sm_ir = cellarray{1};
assignin('base', 'inv_sm_ir', handles.inv_sm_ir);
% PHASE
phase = angle(fft(handles.inv_sm_ir));
% MAGN
magn = fft(handles.inv_pf_imp, length(phase));
% NEW SIGNAL
z = magn.*exp(1i*phase);
handles.invIR = real(ifft(z)); % new inverse filter
handles.invIR = handles.invIR/max(abs(handles.invIR));
assignin('base', 'invIR', handles.invIR);

c = FFTconv(handles.ir,handles.invIR);
c = c/max(abs(c));
corrected_imp = c;
if handles.stereo && handles.same
    c2 = FFTconv(handles.room_ir2, handles.invIR);
    c2 = c2/max(abs(c2));
    corrected_imp = [c c2];
end

guidata(handles.figure1, handles);

function corrected_imp = pole_LL(handles)
handles = guidata(handles.figure1);

% Delete and write in bin folder
del_wr_bin(handles);

% Make new signal
%%% PHASE
[sm fs]=audioread('C:\bin\CoSm-44.wav');
smm=fliplr(sm); %%%to flip,2h fora,dld unflip den kanei kati,to shma einai to idio
% sm_mags=abs(fft(sm,pow2(nextpow2(length(sm)))));
sm_ang=unwrap(angle(fft(sm,pow2(nextpow2(length(sm))))));
f=[0:length(sm_ang)-1]*handles.fs/length(sm_ang);
% Adding the delay
del = -2*pi*(f/handles.fs)*handles.t;
% NEW PHASE after SMOOTHING and LL
new_phase = del' + sm_ang;
%%% MAGNITUDE
magnINV = abs(fft(handles.inv_pf_imp, length(new_phase))); % PF inverse magnitude
% 	NEW SIGNAL
z = magnINV.*exp(1i*new_phase);
handles.invIR= real(ifft(z));    % Equalizer IR (inverse filter)
handles.invIR = handles.invIR/max(abs(handles.invIR)); % Normalized invIR
assignin('base', 'invIR', handles.invIR);

c = FFTconv(handles.room_ir, handles.invIR);
c = c/max(abs(c));
corrected_imp = c;
if handles.stereo && handles.same
    c2 = FFTconv(handles.room_ir2, handles.invIR);
    c2 = c2/max(abs(c2));
    corrected_imp = [c c2];
end
guidata(handles.figure1, handles);

function corrected_imp = cs_LL(handles)
handles = guidata(handles.figure1);

% Delete and write in bin folder
handles.ir_for_cs = handles.ir_for_LL;
guidata(handles.figure1, handles);
del_wr_bin(handles);

% Make new signal
%%% PHASE
[sm fs]=audioread('C:\bin\CoSm-44.wav');
smm=fliplr(sm); %%%to flip,2h fora,dld unflip den kanei kati,to shma einai to idio
% sm_mags=abs(fft(sm,pow2(nextpow2(length(sm)))));
sm_ang=unwrap(angle(fft(sm,pow2(nextpow2(length(sm))))));
f=[0:length(sm_ang)-1]*handles.fs/length(sm_ang);
% Adding the delay
del = -2*pi*(f/handles.fs)*handles.t;
% NEW PHASE after SMOOTHING and LL
new_phase = del' + sm_ang; 

%%% MAGNITUDE
handles.ir_for_cs = handles.ir;
guidata(handles.figure1, handles);
del_wr_bin(handles);

fid = fopen('C:\bin\inv-l.txt');
cellarray = textscan(fid, '%f'); % inverse smoothed
fclose(fid);
handles.inv_sm_ir = cellarray{1};
handles.inv_sm_ir = [handles.inv_sm_ir' zeros(1, length(new_phase)-length(handles.inv_sm_ir))];
handles.inv_sm_ir = handles.inv_sm_ir';
assignin('base', 'inv_sm_ir', handles.inv_sm_ir);
magnINV = abs(fft(handles.inv_sm_ir));
% 	NEW SIGNAL
z = magnINV.*exp(1i*new_phase);
handles.invIR= real(ifft(z));    % Equalizer IR (inverse filter)
handles.invIR = handles.invIR/max(abs(handles.invIR)); % Normalized invIR
assignin('base', 'invIR', handles.invIR);

c = FFTconv(handles.room_ir, handles.invIR);
c = c/max(abs(c));
corrected_imp = c;
if handles.stereo && handles.same
    c2 = FFTconv(handles.room_ir2, handles.invIR);
    c2 = c2/max(abs(c2));
    corrected_imp = [c c2];
end
guidata(handles.figure1, handles);

function corrected_imp = pole_magn(handles)
handles = guidata(handles.figure1);

% inv = fft(handles.inv_pf_imp); 
% MINIMUM-PHASE
handles.invIR = handles.inv_pf_imp;    % Equalizer IR (inverse filter)
handles.invIR = handles.invIR /max(abs(handles.invIR )); % Normalized invIR
assignin('base', 'invIR', handles.invIR );

c = FFTconv(handles.ir, handles.invIR );
c = c/max(abs(c));
corrected_imp = c;
if handles.stereo && handles.same
    c2 = FFTconv(handles.room_ir2, handles.invIR);
    c2 = c2/max(abs(c2));
    corrected_imp = [c c2];
end
guidata(handles.figure1, handles);

function corrected_imp = cs_magn(handles)
handles = guidata(handles.figure1);

del_wr_bin(handles);

fid = fopen('C:\bin\inv-l.txt');
cellarray = textscan(fid, '%f'); % inverse smoothed
fclose(fid);
inv_sm_ir = cellarray{1};
% MAKE INV MINIMUM PHASE
[~, minsm] = rceps(inv_sm_ir);
handles.invIR = minsm; 
assignin('base', 'inv_sm_ir', inv_sm_ir);
assignin('base', 'invIR', handles.invIR);

c = FFTconv(handles.ir, handles.invIR);
c = c/max(abs(c));
corrected_imp = c;
if handles.stereo && handles.same
    c2 = FFTconv(handles.room_ir2, handles.invIR);
    c2 = c2/max(abs(c2));
    corrected_imp = [c c2];
end
guidata(handles.figure1, handles);

function corrected_imp = cs_phase(handles)
handles = guidata(handles.figure1);

del_wr_bin(handles)
fid = fopen('C:\bin\inv-l.txt');
cellarray = textscan(fid, '%f'); % inverse smoothed
fclose(fid);
inv_sm_ir = cellarray{1};
assignin('base', 'inv_sm_ir', inv_sm_ir);
% MAGN
magn = ones(1, length(inv_sm_ir));
magn = magn';
% PHASE
sm_phase = angle(fft(inv_sm_ir));
% NEW SIGNAL
z = magn.*exp(1i*sm_phase);
handles.invIR = real(ifft(z));
handles.invIR = handles.invIR/max(abs(handles.invIR));
assignin('base', 'invIR', handles.invIR);

c = FFTconv(handles.ir, handles.invIR);
c = c/max(abs(c));
corrected_imp = c;
if handles.stereo && handles.same
    c2 = FFTconv(handles.room_ir2, handles.invIR);
    c2 = c2/max(abs(c2));
    corrected_imp = [c c2];
end
guidata(handles.figure1, handles);

function corrected_imp = LL_phase(handles)
handles = guidata(handles.figure1);

% Delete and write in bin folder
del_wr_bin(handles);
assignin('base', 'ir_for_cs', handles.ir_for_cs);

% Make new signal
%%% PHASE
[sm fs]=audioread('C:\bin\CoSm-44.wav');
smm=fliplr(sm); %%%to flip,2h fora,dld unflip den kanei kati,to shma einai to idio
% sm_mags=abs(fft(sm,pow2(nextpow2(length(sm)))));
sm_ang=unwrap(angle(fft(sm,pow2(nextpow2(length(sm))))));
f=[0:length(sm_ang)-1]*handles.fs/length(sm_ang);
% Adding the delay
del = -2*pi*(f/handles.fs)*handles.t;
% NEW PHASE after SMOOTHING and LL
new_phase = del' + sm_ang; 
%%% MAGNITUDE
magn = ones(1, length(new_phase));
magn = magn';
% 	NEW SIGNAL
z = magn.*exp(1i*new_phase); 
handles.invIR= real(ifft(z));    % Equalizer IR (inverse filter)
handles.invIR = handles.invIR/max(abs(handles.invIR)); % Normalized invIR
assignin('base', 'invIR', handles.invIR);

c = FFTconv(handles.ir, handles.invIR);
c = c/max(abs(c));
corrected_imp = c;
if handles.stereo && handles.same
    c2 = FFTconv(handles.room_ir2, handles.invIR);
    c2 = c2/max(abs(c2));
    corrected_imp = [c c2];
end
guidata(handles.figure1, handles);

function del_wr_bin(handles)
handles = guidata(handles.figure1);
%Delete
cd('C:\bin\');
if exist('C:\bin\ir_l.wav', 'file')==2, delete('C:\bin\ir_l.wav'); end
if exist('C:\bin\Inv.WAV', 'file')==2, delete('C:\bin\Inv.WAV'); end
if exist('C:\bin\CoSm-44.WAV', 'file')==2, delete('C:\bin\CoSm-44.WAV'); end
if exist('C:\bin\inv_filt.txt', 'file')==2, delete('C:\bin\inv_filt.txt'); end
if exist('C:\bin\inv-l.txt', 'file')==2, delete('C:\bin\inv-l.txt'); end
if exist('C:\bin\success.txt', 'file')==2, delete('C:\bin\success.txt'); end
if exist('C:\bin\tar.txt', 'file')==2, delete('C:\bin\tar.txt'); end
if exist('C:\bin\tar2.txt', 'file')==2, delete('C:\bin\tar2.txt'); end
if exist('C:\bin\input.txt', 'file')==2, delete('C:\bin\input.txt'); end
%Write
 if length(handles.ir_for_cs)>40000
     handles.ir_for_cs = handles.ir_for_cs(1:40000); 
 end
 audiowrite('C:\bin\ir_l.wav', handles.ir_for_cs, handles.fs);
 fileID = fopen('input.txt','w');
 disp(handles.csmagn_order);
 disp(handles.csphase_order);
 fprintf(fileID,'%d\r\n', handles.csmagn_order);
 fprintf(fileID,'%d', handles.csphase_order);
 fclose(fileID);
 system('C:\bin\smooth_n.exe < C:\bin\input.txt');
 cd(handles.currentfolder);
 
function irLLprep = preLL(handles)
 handles = guidata(handles.figure1);
 
%%%% Prepare ir for smoothing %%%%
x = abs(hilbert(handles.ir)); %envelope
[~, handles.t]=max(x); % handles.t, index of max(x)
N = pow2(nextpow2(length(handles.ir)));
% N = length(handles.ir);
faxis = [0:N-1]*handles.fs/N;
mags = abs(fft(handles.ir,N ));
%Phase of IR
ang = unwrap(angle(fft(handles.ir,N)));
% Sample k corresponding to fthr Hz
k = find(faxis >= handles.fthreshold, 1);
L = length(ang);
% ph linear factor
ph = -2*pi*(faxis(1:k-1)/handles.fs)*handles.t;
% Create signal with NEW PHASE  and anti-symmetry
ang_new=[ph ang(k:(L/2)+1)' -ang(L/2:-1:k)' ph(end:-1:2)];
%%% REMOVE DELAY
a = exp(1i*ang_new); 
b = exp(1i*2*pi*(faxis/handles.fs)*handles.t);
c = a.*b; % Phase without delay
%NEW SIGNAL
z = mags'.*c; 
sig = real(ifft(z)); % new signal in time domain
sig = sig/max(abs(sig)); % normalization
% mm=fliplr(sig); % to flip xreiazetai sta 400Hz sigoura,oxi sta 200
irLLprep = sig';
assignin('base', 'irLLprep', irLLprep);
guidata(handles.figure1, handles);

function save_invimp_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_invimp_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.correction_flag
    errordlg('Equalization settings have not been applied.', 'Calculation Error');
    return;
end
[filename, pathname] = uiputfile('*.wav','Save Inverse Filter IR');
if ((filename~=0)|(pathname~=0))
   inv_ir_path=fullfile(pathname, filename);
   audiowrite(inv_ir_path, handles.INV_IR, handles.fs);
end

function save_eqimp_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_eqimp_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.correction_flag
    errordlg('Equalization settings have not been applied.', 'Calculation Error');
    return;
end
[filename, pathname] = uiputfile('*.wav','Save EQ IR');
if ((filename~=0)|(pathname~=0))
   eq_ir_path=fullfile(pathname, filename);
   audiowrite(eq_ir_path, handles.EQ_IR, handles.fs);
end

%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%
function magn_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to magn_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Check for empty IR path
handles.vsb_magn_eq = handles.vsbstates{1 + hObject.Value};
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
elseif isempty(handles.corresp)
    errordlg('Equalization settings have not been applied.', 'Calculation Error');
    hObject.Value = 0;
else
    if (hObject.Value || handles.view_magn_togglebutton.Value)
        maxdb = max(db(handles.magn_or));
        if ~ishandle(20)
            handles.f20=figure(20);
            set(0, 'CurrentFigure', 20);
            handles.magn_axes = axes;
        else
            set(0, 'CurrentFigure', 20);
        end
        handles.magn_axes.Parent = 20;
        handles.magn_axes.Parent = 20;
        handles.f20.Units = 'normalized';
        handles.f20_pos = handles.f20.Position;
        mainpos = getappdata(0, 'main_position');
        handles.f20.Position = [mainpos(1)+0.36 mainpos(2)+0.1 ...
            handles.f20_pos(3) handles.f20_pos(4)];
        
        % Original
        hold off;
        if handles.left_togglebutton.Value || handles.mono
            magn_or_plot = semilogx(handles.magn_axes, fset(handles.magn_or, handles.fs), db(handles.magn_or));
            if handles.mono, handles.magn_axes.Title.String = 'Magnitude';
            else handles.magn_axes.Title.String = 'Left Channel: Magnitude'; end
        else
            handles.magn_orR = getappdata(0, 'magn_orR');
            magn_or_plot = semilogx(handles.magn_axes, fset(handles.magn_orR, handles.fs), db(handles.magn_orR));
            handles.magn_axes.Title.String = 'Right Channel: Magnitude';
        end
        magn_or_plot.Visible = handles.vsb_magn_or;   
        % EQ
        hold on;
        if handles.left_togglebutton.Value || handles.mono
            magn_eq_plot = semilogx(handles.magn_axes, fset(handles.magn_eq, handles.fs), db(handles.magn_eq), 'r');
            if handles.mono, handles.magn_axes.Title.String = 'Magnitude';
            else handles.magn_axes.Title.String = 'Left Channel: Magnitude'; end
        else
            magn_eq_plot = semilogx(handles.magn_axes, fset(handles.magn_eqR, handles.fs), db(handles.magn_eqR), 'r');
            handles.magn_axes.Title.String = 'Right Channel: Magnitude';
        end
        magn_eq_plot.Visible = handles.vsb_magn_eq;

        %%% LEGEND
        legend({'Original', 'EQ'}, 'Location', 'southeast',...
            'FontWeight', 'bold');
        
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        xlim([10 handles.fs/2]);
        ylim([-40 maxdb]);
    else
        if ishandle(handles.f20), close(handles.f20); end
    end
    
end

guidata(hObject, handles);

function phase_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to phase_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.vsb_angle_eq = handles.vsbstates{1 + hObject.Value};
% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
elseif isempty(handles.corresp)
    errordlg('Equalization settings have not been applied.', 'Calculation Error');
    hObject.Value = 0;
else
    if (hObject.Value || handles.view_phase_togglebutton.Value)
        if ~ishandle(21)
            figure(21);
            set(0, 'CurrentFigure', 21);
            handles.phase_axes = axes;
        else
            set(0, 'CurrentFigure', 21);
        end
        handles.phase_axes.Parent = 21;
            
        % Original
        hold off;
        if handles.left_togglebutton.Value || handles.mono
            angle_or_plot = semilogx(handles.phase_axes, fset(handles.angle_or, handles.fs), (180/pi)*(handles.angle_or));
            if handles.mono, handles.phase_axes.Title.String = 'Phase';
            else handles.phase_axes.Title.String = 'Left Channel: Phase'; end
        else
            handles.angle_orR = getappdata(0, 'angle_orR');
            angle_or_plot = semilogx(handles.phase_axes, fset(handles.angle_orR, handles.fs), (180/pi)*(handles.angle_orR));
            handles.phase_axes.Title.String = 'Right Channel: Phase';
        end
        angle_or_plot.Visible = handles.vsb_angle_or;   
        % EQ
        hold on;
        if handles.left_togglebutton.Value || handles.mono
            angle_eq_plot = semilogx(handles.phase_axes, fset(handles.angle_eq, handles.fs), (180/pi)*(handles.angle_eq), 'r');
            if handles.mono, handles.phase_axes.Title.String = 'Phase';
            else handles.phase_axes.Title.String = 'Left Channel: Phase'; end
        else
            angle_eq_plot = semilogx(handles.phase_axes, fset(handles.angle_eqR, handles.fs), (180/pi)*(handles.angle_eqR), 'r');
            handles.phase_axes.Title.String = 'Right Channel: Phase';
        end
        angle_eq_plot.Visible = handles.vsb_angle_eq;
        
        %%% LEGEND
        legend({'Original', 'EQ'}, 'Location', 'southeast',...
        'FontWeight', 'bold');
        
        xlabel('Frequency (Hz)');
        ylabel('Phase (degrees)');
        xlim([10 handles.fs/2]);

    else
       if ishandle(21), close(21); end
    end
end

guidata(hObject, handles);

function imp_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to imp_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

time_imp = [0:length(handles.room_ir)-1]/handles.fs;
handles.vsb_imp_eq = handles.vsbstates{1 + hObject.Value};
% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
elseif isempty(handles.corresp)
    errordlg('Equalization settings have not been applied.', 'Calculation Error');
    hObject.Value = 0;    
else
    if (hObject.Value || handles.view_ir_togglebutton.Value)
        if ~ishandle(22)
            figure(22);
            set(0, 'CurrentFigure', 22);
            handles.imp_axes = axes;
        else
            set(0, 'CurrentFigure', 22);
        end
        handles.imp_axes.Parent = 22;
            
        hold off;
        % Original
        if handles.left_togglebutton.Value || handles.mono
            imp_or_plot = plot(handles.imp_axes, time_imp, handles.room_ir);
            if handles.mono, handles.imp_axes.Title.String = 'Impulse Response';
            else handles.imp_axes.Title.String = 'Left Channel: Impulse Response'; end
        else
            handles.room_ir2 = getappdata(0, 'room_ir2');
            time_imp2 = [0:length(handles.room_ir2)-1]/handles.fs;
            imp_or_plot = plot(handles.imp_axes, time_imp2, handles.room_ir2);
            handles.imp_axes.Title.String = 'Right Channel: Impulse Response';
        end
        imp_or_plot.Visible = handles.vsb_imp_or;
        % EQ
        hold on;
        if handles.left_togglebutton.Value || handles.mono
            time_impeq = [0:length(handles.corimp)-1]/handles.fs;
            imp_eq_plot = plot(handles.imp_axes, time_impeq, handles.corimp, 'r');
            if handles.mono, handles.imp_axes.Title.String = 'Impulse Response';
            else handles.imp_axes.Title.String = 'Left Channel: Impulse Response'; end
        else
            time_impeq2 = [0:length(handles.corimpR)-1]/handles.fs;
            imp_eq_plot = plot(handles.imp_axes, time_impeq2, handles.corimpR, 'r');
            handles.imp_axes.Title.String = 'Right Channel: Impulse Response';
        end
        imp_eq_plot.Visible = handles.vsb_imp_eq;
       
        %%% LEGEND
            legend({'Original', 'EQ'}, 'Location', 'southeast',...
            'FontWeight', 'bold');
        
        xlabel('Time (sec)');
        ylabel('Amplitude ');

    else
       if ishandle(22), close(22); end
    end
end
guidata(hObject, handles);

function gd_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to gd_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.vsb_gd_eq = handles.vsbstates{1 + hObject.Value};
% Check for empty IR path
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0; 
elseif isempty(handles.corresp)
    errordlg('Equalization settings have not been applied.', 'Calculation Error');
    hObject.Value = 0;  
else
    if (hObject.Value || handles.view_gd_togglebutton.Value)
        if ~ishandle(23)
            figure(23);
            set(0, 'CurrentFigure', 23);
            handles.gd_axes = axes;
        else
            set(0, 'CurrentFigure', 23);
        end
        handles.gd_axes.Parent = 23;
            
        hold off;
        % Original
        if handles.left_togglebutton.Value || handles.mono
            gd_or_plot = semilogx(handles.gd_axes, fset(handles.gd_or, handles.fs), handles.gd_or);
            if handles.mono, handles.gd_axes.Title.String = 'Group Delay';
            else handles.gd_axes.Title.String = 'Left Channel: Group Delay'; end
        else
            handles.gd_orR = getappdata(0, 'gd_orR');
            gd_or_plot = semilogx(handles.gd_axes, fset(handles.gd_orR, handles.fs), handles.gd_orR);
            handles.gd_axes.Title.String = 'Right Channel: Group Delay';
        end
        gd_or_plot.Visible = handles.vsb_gd_or;
        % EQ
        hold on;
        if handles.left_togglebutton.Value || handles.mono
            gd_eq_plot = semilogx(handles.gd_axes, fset(handles.gd_eq, handles.fs), handles.gd_eq, 'r');
            if handles.mono, handles.gd_axes.Title.String = 'Group Delay';
            else handles.gd_axes.Title.String = 'Left Channel: Group Delay'; end
        else
            gd_eq_plot = semilogx(handles.gd_axes, fset(handles.gd_eqR, handles.fs), handles.gd_eqR, 'r');
            handles.gd_axes.Title.String = 'Right Channel: Group Delay';
        end

        gd_eq_plot.Visible = handles.vsb_gd_eq;

        %%% LEGEND
            legend({'Original', 'EQ'}, 'Location', 'southeast',...
            'FontWeight', 'bold');
        
        xlabel('Frequency (Hz)');
        ylabel('Group Delay (sec)');
        xlim([10 handles.fs/2]);
    else
       if ishandle(23), close(23); end
    end
    
end
guidata(hObject, handles);

function std_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to std_togglebutton (see GCBO)
handles.vsb_std_eq = handles.vsbstates{1 + handles.std_togglebutton.Value};
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
elseif isempty(handles.corresp)
    errordlg('Equalization settings have not been applied.', 'Calculation Error');
    hObject.Value = 0;
else
    if (hObject.Value || handles.view_std_togglebutton.Value)
        if ~ishandle(24)
            figure(24);
            set(0, 'CurrentFigure', 24);
            handles.std_axes = axes;
        else
            set(0, 'CurrentFigure', 24);
        end
        handles.std_axes.Parent = 24;
        
        hold off;
        % Original
        if handles.left_togglebutton.Value || handles.mono
            std_or_plot = errorbar(handles.std_axes, log10(handles.cntr_freq),handles.mean_or,...
                handles.std_or, 'b.','LineWidth',1,'MarkerSize',10);
            if handles.mono, handles.std_axes.Title.String = 'Standard Deviation';
            else handles.std_axes.Title.String = 'Left Channel: Standard Deviation'; end
            handles.cf = handles.cntr_freq;
        else
            handles.std_orR = getappdata(0, 'std_orR');
            handles.mean_orR = getappdata(0, 'mean_orR');
            handles.cntr_freqR = getappdata(0, 'cntr_freqR');
            std_or_plot = errorbar(handles.std_axes, log10(handles.cntr_freqR),handles.mean_orR,... 
                handles.std_orR,'b.','LineWidth',1,'MarkerSize',10);
            handles.std_axes.Title.String = 'Right Channel: Standard Deviation';
            handles.cf = handles.cntr_freqR;
        end
        std_or_plot.Visible = handles.vsb_std_or;
        % EQ
        hold on;
        if handles.left_togglebutton.Value || handles.mono
            std_eq_plot = errorbar(handles.std_axes, log10(handles.cntr_freq_eq),handles.mean_eq,...
            handles.std_eq, 'r.','LineWidth',1,'MarkerSize',10); 
            if handles.mono, handles.std_axes.Title.String = 'Standard Deviation';
            else handles.std_axes.Title.String = 'Left Channel: Standard Deviation'; end
            handles.cf = handles.cntr_freq_eq;
        else
            std_eq_plot = errorbar(handles.std_axes, log10(handles.cntr_freq_eqR),handles.mean_eqR,... 
                handles.std_eqR,'r.','LineWidth',1,'MarkerSize',10);
            handles.std_axes.Title.String = 'Right Channel: Standard Deviation';
            handles.cf = handles.cntr_freq_eqR;
        end

        std_eq_plot.Visible = handles.vsb_std_eq;

        %%% LEGEND
        legend({'Original', 'EQ'}, 'Location', 'southwest',...
        'FontWeight', 'bold');
        
        xlabel('Frequnecy(Hz)', 'FontSize', 17);
        ylabel('STD (dB)', 'FontSize', 17); 
        grid on; axis tight; t = axis;  
        handles.std_axes.XLim = [t(1) t(2)];
        t(3) = -36;
        handles.std_axes.YLim = [t(3) 0];
        center_freqs = log10(handles.cf);
        xticks = center_freqs(1:3:length(center_freqs));
        set(handles.std_axes,'Xtick', xticks); 
        set(handles.std_axes,'Xticklabel',round(10.^get(handles.std_axes,'Xtick')));
        set(handles.std_axes,'Ytick',-72:3:0); 
    else
        if ishandle(24), close(24); end
    end
end
guidata(hObject, handles);

function flatness_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to flatness_togglebutton (see GCBO)
handles.vsb_flatness_eq = handles.vsbstates{1 + handles.flatness_togglebutton.Value};
if isempty(get(handles.path_ir_edit, 'String'))
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
elseif isempty(handles.corresp)
    errordlg('Equalization settings have not been applied.', 'Calculation Error');
    hObject.Value = 0;
else
    if (hObject.Value || handles.view_flatness_togglebutton.Value)
        if ~ishandle(25)
            figure(25);
            set(0, 'CurrentFigure', 25);
            handles.flatness_axes = axes;
        else
            set(0, 'CurrentFigure', 25);
        end
        handles.flatness_axes.Parent = 25;
        
        hold off;
        % Original
        if handles.left_togglebutton.Value || handles.mono
            flatness_or_plot = scatter(handles.flatness_axes,handles.cntr_freq,handles.flatness_or,15,'o'); 
            line_or_plot = line(handles.flatness_axes,handles.cntr_freq,handles.flatness_or); grid on; 
            set(gca,'XScale','log');
            if handles.mono, handles.flatness_axes.Title.String = 'Flatness';
            else handles.flatness_axes.Title.String = 'Left Channel: Flatness'; end
        else
            handles.flatness_orR = getappdata(0, 'flatness_orR');
            handles.cntr_freqR = getappdata(0, 'cntr_freqR');
            flatness_or_plot = scatter(handles.flatness_axes,handles.cntr_freqR,...
                handles.flatness_orR,15,'o'); 
            line_or_plot = line(handles.flatness_axes,handles.cntr_freqR,handles.flatness_orR); grid on; 
            set(gca,'XScale','log');
            handles.flatness_axes.Title.String = 'Right Channel: Flatness';
        end
        flatness_or_plot.Visible = handles.vsb_flatness_or;
        line_or_plot.Visible = handles.vsb_flatness_or;
         % EQ
        hold on;
        if handles.left_togglebutton.Value || handles.mono
            flatness_eq_plot = scatter(handles.flatness_axes,handles.cntr_freq_eq,handles.flatness_eq,15,'ro'); 
            line_eq_plot = line(handles.flatness_axes,handles.cntr_freq_eq,handles.flatness_eq,'Color','red'); grid on; 
            set(gca,'XScale','log');
            if handles.mono, handles.flatness_axes.Title.String = 'Flatness';
            else handles.flatness_axes.Title.String = 'Left Channel: Flatness'; end
        else
            flatness_eq_plot = scatter(handles.flatness_axes,handles.cntr_freq_eqR,...
                handles.flatness_eqR,15,'ro'); 
            line_eq_plot = line(handles.flatness_axes,handles.cntr_freq_eqR,handles.flatness_eqR,'Color','red'); grid on; 
            handles.flatness_axes.Title.String = 'Right Channel: Flatness';
        end

        flatness_eq_plot.Visible = handles.vsb_flatness_eq;
        line_eq_plot.Visible = handles.vsb_flatness_eq;

        %%% LEGEND
        legend([line_or_plot line_eq_plot],{'Original', 'EQ'}, 'Location', 'southeast',...
        'FontWeight', 'bold');

        xlabel('Frequnecy (Hz)', 'FontSize', 17);
        ylabel('Flatness', 'FontSize', 17); 
        grid on; axis tight;  t = axis; 
        handles.flatness_axes.XLim = [t(1) t(2)];
        handles.flatness_axes.YLim = [0.5 1];
        handles.flatness_axes.Box = 'on';
    else
        if ishandle(25), close(25); end
    end
end
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% TEST %%%%%%%%%%%%%%%%%%%%%

function anechoic_edit_Callback(hObject, eventdata, handles)
% hObject    handle to anechoic_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anechoic_edit as text
%        str2double(get(hObject,'String')) returns contents of anechoic_edit as a double
fullpath = hObject.String;
if exist(fullpath, 'file')~=2, errordlg('Invalid filename or path.', 'File Error'); return; end;
% If Path/Filename is valid
[handles.anechoic, handles.fsa] = audioread(fullpath);
assignin('base', 'anechoic', handles.anechoic);

% Check for mono/stereo
size_anech = size(handles.anechoic);
if size_anech(2) == 1
    handles.anech_type = 'mono';
    % Normalize mono
    handles.anechoic = handles.anechoic/max(abs(handles.anechoic));
    % Convert mono to stereo
    handles.anechoic = [handles.anechoic handles.anechoic];
else
    % Normalize stereo
    handles.anech_type = 'stereo';
    handles.anechoic = norm_stereo(handles.anechoic);
end
handles.player_anech = audioplayer(handles.anechoic, handles.fsa);
h = msgbox('Anechoic sound file is loaded.','Success');    

guidata(hObject, handles);

%%% ANECHOIC
function browse_anech_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to browse_anech_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.wav','Load sound file for testing');
if (filename ~= 0)
    handles.anechoic_pathname = fullfile(pathname,filename);
    handles.anechoic_edit.String = handles.anechoic_pathname;
    [handles.anechoic, handles.fsa] = audioread(handles.anechoic_pathname);
    assignin('base', 'anechoic', handles.anechoic);

    % Check for mono/stereo sound
    size_anech = size(handles.anechoic);
    if size_anech(2) == 1
        handles.anech_type = 'mono';
        % Normalize mono
        handles.anechoic = handles.anechoic/max(abs(handles.anechoic));
        % Convert mono to stereo
        handles.anechoic = [handles.anechoic handles.anechoic];
    else
        handles.anech_type = 'stereo';
        % Normalize stereo
        handles.anechoic = norm_stereo(handles.anechoic);
    end
    handles.player_anech = audioplayer(handles.anechoic, handles.fsa);
end

guidata(hObject, handles);

function play_anech_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to play_anech_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

play(handles.player_anech);

function stop_anech_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stop_anech_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.player_anech);


%%% REVERBERANT
function calc_reverb_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to calc_reverb_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.mono
    reverbL = FFTconv(handles.anechoic(:,1), handles.room_ir);
    reverbR = FFTconv(handles.anechoic(:,2), handles.room_ir);
else
    reverbL = FFTconv(handles.anechoic(:,1), handles.room_ir);
    reverbR = FFTconv(handles.anechoic(:,2), handles.room_ir2);
end
handles.reverb = [reverbL reverbR];
handles.reverb = handles.reverb/max(abs(handles.reverb));

handles.player_reverb = audioplayer(handles.reverb, handles.fsa);
guidata(hObject, handles);
h = msgbox('Reverberant sound is ready','Success');

function play_reverb_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to play_reverb_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play(handles.player_reverb);

function stop_reverb_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stop_reverb_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.player_reverb);

function calc_eq_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to calc_eq_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.mono
    eqL = FFTconv(handles.anechoic(:,1), handles.corimp);
    eqR = FFTconv(handles.anechoic(:,2), handles.corimp);
else
    eqL = FFTconv(handles.anechoic(:,1), handles.corimpL);
    eqR = FFTconv(handles.anechoic(:,2), handles.corimpR);
end

handles.eq = [eqL eqR];
handles.eq = handles.eq/max(abs(handles.eq));

handles.player_eq = audioplayer(handles.eq, handles.fsa);
guidata(hObject, handles);
h = msgbox('Equalized sound is ready','Success');

function play_eq_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to play_eq_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play(handles.player_eq);

function stop_eq_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stop_eq_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.player_eq);
%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%
