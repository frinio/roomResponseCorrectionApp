function varargout = pole_fitting(varargin)
% POLE_FITTING MATLAB code for pole_fitting.fig
%      POLE_FITTING, by itself, creates a new POLE_FITTING or raises the existing
%      singleton*.
%
%      H = POLE_FITTING returns the handle to a new POLE_FITTING or the handle to
%      the existing singleton*.
%
%      POLE_FITTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POLE_FITTING.M with the given input arguments.
%
%      POLE_FITTING('Property','Value',...) creates a new POLE_FITTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pole_fitting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pole_fitting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pole_fitting

% Last Modified by GUIDE v2.5 18-Dec-2016 22:36:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pole_fitting_OpeningFcn, ...
                   'gui_OutputFcn',  @pole_fitting_OutputFcn, ...
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


% --- Executes just before pole_fitting is made visible.
function pole_fitting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pole_fitting (see VARARGIN)

% Choose default command line output for pole_fitting
handles.output = hObject;

% Initialization
handles.save_flag_pole = 0;

handles.samefilt = getappdata(0, 'same');
handles.right = getappdata(0, 'right');
hObject.Units = 'normalized';
mainpos = getappdata(0, 'main_position');
hObject.Position = [mainpos(1)+0.36 mainpos(2)+0.2 0.33 0.55];
handles.visstates = {'off', 'on'};
handles.vsb_inv = 'on';
handles.vsb_eq = 'on';
handles.vsb_trgt = 'on';

%%% Buttons Initialization %%%
handles.fb_target_radiobutton.Value = getappdata(0, 'target_rdb');
handles.custom_target_radiobutton.Value = getappdata(0, 'custom_target_rdb');
handles.custom_path_edit.String = getappdata(0, 'custom_path');
handles.target_popupmenu.Value = getappdata(0, 'fbt_type');
handles.fbt_type = getappdata(0, 'fbt_type');
handles.band_flag = getappdata(0, 'band_flag');
handles.filter_order_edit.String = getappdata(0, 'fbt_order');
handles.fbt_order = str2double(getappdata(0, 'fbt_order'));
handles.fc1_edit.String =getappdata(0, 'fc1');
handles.fc1 = str2double(getappdata(0, 'fc1'));
handles.fc2_edit.String =getappdata(0, 'fc2');
handles.fc2 = str2double(getappdata(0, 'fc2'));
handles.manual_poles_radiobutton.Value = getappdata(0, 'manual');
handles.graphical_poles_radiobutton.Value = getappdata(0, 'graphical');
%%%% Enable buttons %%%%
handles.custom_path_edit.Enable = handles.visstates{1+handles.custom_target_radiobutton.Value}; 
handles.browse_pushbutton.Enable = handles.visstates{1+handles.custom_target_radiobutton.Value}; 
handles.fc2_edit.Visible = handles.visstates{1+handles.band_flag};
handles.fc2_text.Visible = handles.visstates{1+handles.band_flag};
if handles.band_flag, handles.fc1_text.String = 'Fc1 (in Hz) :'; end;
handles.target_popupmenu.Enable = handles.visstates{1+handles.fb_target_radiobutton.Value}; 
handles.filter_order_edit.Enable =  handles.visstates{1+handles.fb_target_radiobutton.Value}; 
handles.fc1_edit.Enable =  handles.visstates{1+handles.fb_target_radiobutton.Value}; 
handles.fc2_edit.Enable =  handles.visstates{1+handles.fb_target_radiobutton.Value};
handles.fb_calc_pushbutton.Enable =  handles.visstates{1+handles.fb_target_radiobutton.Value};

%%% IR, Fs %%%
handles.fs = getappdata(0, 'fs');
handles.room_ir = getappdata(0, 'room_ir');
% handles.room_ir = [handles.room_ir' zeros(1, pow2(nextpow2(length(handles.room_ir))) - length(handles.room_ir))];
[cp,handles.minresp_ir]=rceps(handles.room_ir); %making mimumumphase

%%% Pole set, Target, Inv, EQ %%%
handles.inv_graph_fft = getappdata(0, 'inv_graph_fft');
handles.inv_imp = getappdata(0, 'inv_imp_graph');
handles.eq_graph_fft = getappdata(0, 'eq_graph_fft');
handles.fp = getappdata(0, 'fp');
handles.inv_man_fft = getappdata(0, 'inv_man_fft');
handles.inv_imp_man = getappdata(0, 'inv_imp_man');
handles.eq_man_fft = getappdata(0, 'eq_man_fft');
handles.fp_man = getappdata(0, 'fp_man');
handles.imp_cheby = getappdata(0, 'imp_cheby');
handles.imp= getappdata(0, 'imp');
handles.target = getappdata(0, 'target_imp');
handles.trgt_fft = abs(fft(handles.target));
handles.ctarget = getappdata(0, 'ctarget_imp');
% Table Data
handles.tbl_data = getappdata(0, 'tbl_data');


% Check Boxes
handles.val_inv = 1; handles.val_eq = 1; handles.val_trgt = 1;

%%%%% Populate Graph_Axes %%%%%
if ~handles.samefilt && handles.right
     % RIGHT CHANNEL / DIF mode
    handles.room_ir2 = getappdata(0, 'room_ir2');
    handles.room_ir = handles.room_ir2;
    [cp,handles.minresp_ir]=rceps(handles.room_ir); %making mimumumphase
end
handles.room_resp = fft(handles.room_ir);
handles.dr = 70; % Dynamic Range (dB)
handles.max_db =  max(db(handles.room_resp));
handles.min_db = handles.max_db - handles.dr;
semilogx(handles.graph_axes, fset(handles.room_resp, handles.fs), db(handles.room_resp)); hold on;
handles.graph_axes.XLim = [10 handles.fs/2];
handles.graph_axes.YLim = [handles.min_db handles.max_db];

yaxis1 = zeros(1, length(handles.fp)) + 3*handles.min_db/4 +3;
yaxis2 = zeros(1, length(handles.fp_man)) + 3*handles.min_db/4 - 5;

if ~isempty(handles.fp), plot(handles.graph_axes, handles.fp, yaxis1, 'ko', 'Linewidth', 1); hold on; end;
if ~isempty(handles.fp_man),plot(handles.graph_axes, handles.fp_man, yaxis2, 'kx', 'Linewidth', 1); end;
hold off;
xlabel('Frequency (Hz)', 'FontWeight', 'bold');
ylabel('Magnitude (dB)', 'FontWeight', 'bold');
set(handles.graph_axes, 'ButtonDownFcn', {@graph_axes_ButtonDownFcn, handles});

assignin('base', 'fp', handles.fp);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pole_fitting wait for user response (see UIRESUME)
% uiwait(handles.pole_fitting_figure);

% --- Executes on mouse motion over figure - except title and menu.
function pole_fitting_figure_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to pole_fitting_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.axes_pos = handles.graph_axes.Position;
mouse_pos = hObject.CurrentPoint;
%Check if mouse is over axes
if ((mouse_pos(1))>handles.axes_pos(1)) && ((mouse_pos(1))<handles.axes_pos(1)+handles.axes_pos(3))
    if ((mouse_pos(2))>handles.axes_pos(2)) && ((mouse_pos(2))<handles.axes_pos(2)+handles.axes_pos(4))
        set(hObject, 'Pointer', 'hand');
    else
        set(hObject, 'Pointer', 'arrow');
    end
else
    set(hObject, 'Pointer', 'arrow');
end
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = pole_fitting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function target_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to target_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns target_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from target_popupmenu
handles.save_flag_pole = 1;

if get(hObject,'Value') == 3 % If user selection is Bandpass
    set(handles.fc2_text, 'Visible', 'on');
    set(handles.fc2_edit, 'Visible', 'on');
    set(handles.fc2_text, 'Enable', 'on');
    set(handles.fc2_edit, 'Enable', 'on');
    set(handles.fc1_text, 'String', 'Fc1 (in Hz) :');
    handles.band_flag = 1;
else
%     If user selection is Highpass or Lowpass
    handles.band_flag = 0;
    set(handles.fc2_text, 'Visible', 'off');
    set(handles.fc2_edit, 'Visible', 'off');
    set(handles.fc1_text, 'String', 'Fc (in Hz) :');
end

handles.fbt_type = get(hObject,'Value');
guidata(hObject, handles);


function fb_target_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to fb_target_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fb_target_radiobutton
handles.save_flag_pole = 1;

if get(hObject,'Value') == 1
   set(handles.custom_target_radiobutton, 'Value', 0);
   set(handles.fc1_edit, 'Enable', 'on');
   set(handles.target_popupmenu, 'Enable', 'on');
   set(handles.filter_order_edit, 'Enable', 'on');
   handles.fb_calc_pushbutton.Enable = 'on';
   if handles.band_flag == 1 
       set(handles.fc2_edit, 'Enable', 'on');       
   end
   
   set(handles.custom_path_edit, 'Enable', 'off');
   set(handles.browse_pushbutton, 'Enable', 'off');
end

% If radio button is selected, pressing it again remains selected
if get(hObject,'Value') == 0
    set(hObject, 'Value', 1);
end
handles.target = handles.imp_cheby;
handles.trgt_fft = abs(fft(handles.target));

guidata(hObject, handles);

function custom_target_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to custom_target_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of custom_target_radiobutton
handles.save_flag_pole = 1;

if hObject.Value == 1
   set(handles.fb_target_radiobutton, 'Value', 0);
   set(handles.fc1_edit, 'Enable', 'off');
   set(handles.target_popupmenu, 'Enable', 'off');
   set(handles.filter_order_edit, 'Enable', 'off');
   handles.fb_calc_pushbutton.Enable = 'off';
   if handles.band_flag == 1 
       set(handles.fc2_edit, 'Enable', 'off');       
   end
   
   set(handles.custom_path_edit, 'Enable', 'on');
   set(handles.browse_pushbutton, 'Enable', 'on');
end

% If radio button is selected, pressing it again remains selected
if get(hObject,'Value') == 0
    set(hObject, 'Value', 1);
end
handles.target = handles.ctarget;
handles.trgt_fft = abs(fft(handles.target));

guidata(hObject, handles);

function filter_order_edit_Callback(hObject, eventdata, handles)
% hObject    handle to filter_order_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filter_order_edit as text
%        str2double(get(hObject,'String')) returns contents of filter_order_edit as a double
handles.save_flag_pole = 1;

handles.fbt_order = str2double(get(hObject,'String'));
setappdata(handles.pole_fitting_figure, 'order',handles.fbt_order);
guidata(hObject, handles);

function fc1_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fc1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fc1_edit as text
%        str2double(get(hObject,'String')) returns contents of fc1_edit as a double
handles.save_flag_pole = 1;

handles.fc1 = str2double(get(hObject,'String'));
setappdata(handles.pole_fitting_figure, 'fc1',handles.fc1);
guidata(hObject, handles);

function fc2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fc2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fc2_edit as text
%        str2double(get(hObject,'String')) returns contents of fc2_edit as a double
handles.save_flag_pole = 1;

handles.fc2 = str2double(get(hObject,'String'));
setappdata(handles.pole_fitting_figure, 'fc2',handles.fc2);
guidata(hObject, handles);

function fb_calc_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to fb_calc_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.save_flag_pole = 1;

handles.pole_fitting_figure.Pointer= 'watch';
V = length(handles.room_ir);
handles.imp = zeros(1, V); handles.imp(1) = 1;
% handles.imp = zeros(1, length(handles.room_ir)); handles.imp(1) = 1;
handles.imp = handles.imp';
ripple = 1; % passband ripple in db

if handles.fbt_type == 1
    % Highpass
%     [z,p,k] = cheby1(handles.fbt_order, ripple, handles.fc1/(handles.fs/2), 'high');
       [z, p, k] = butter(handles.fbt_order, handles.fc1/(handles.fs/2), 'high');
elseif handles.fbt_type == 2
    % Lowpass
%     [z,p,k] = cheby1(handles.fbt_order, ripple, handles.fc1/(handles.fs/2), 'low');
       [z, p, k] = butter(handles.fbt_order, handles.fc1/(handles.fs/2), 'low');

else
    % Bandpass
    passzone = [handles.fc1/(handles.fs/2) handles.fc2/(handles.fs/2)];
%     [z,p,k] = cheby1(handles.fbt_order, ripple, passzone, 'bandpass');
[z,p,k] = butter(handles.fbt_order, passzone, 'bandpass');
end

sos = zp2sos(z,p,k);
f = fset(handles.room_ir, handles.fs);
handles.imp_cheby = impz(sos, length(f));
handles.imp_cheby = handles.imp_cheby/max(abs(handles.imp_cheby));
handles.target = handles.imp_cheby;
handles.trgt_fft = abs(fft(handles.target));

assignin('base', 'cheby_imp',handles.imp_cheby);
assignin('base', 'target_imp',handles.target);

handles.pole_fitting_figure.Pointer= 'arrow';
guidata(handles.pole_fitting_figure, handles);

% Completed message box
h = msgbox('Target response is ready','Success');

function custom_path_edit_Callback(hObject, eventdata, handles)
% hObject    handle to custom_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of custom_path_edit as text
%        str2double(get(hObject,'String')) returns contents of custom_path_edit as a double
handles.save_flag_pole = 1;

fullpath = hObject.String;
if exist(fullpath, 'file')~=2, errordlg('Invalid filename or path.', 'File Error'); return; end;
% If Path/Filename is valid
[handles.ctarget, handles.fst] = audioread(fullpath);
handles.ctarget = [handles.ctarget' zeros(1, length(handles.room_ir)-length(handles.ctarget))]';
    
handles.target = handles.ctarget;
handles.trgt_fft = abs(fft(handles.target));

assignin('base', 'target_imp', handles.target);
assignin('base', 'ctarget_imp', handles.ctarget);
handles.imp = zeros(1, 5000); handles.imp(1) = 1;
handles.imp = handles.imp';
assignin('base', 'imp', handles.imp);

h = msgbox('Target IR is loaded.','Success');
guidata(handles.pole_fitting_figure, handles);
   
function browse_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to browse_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.save_flag_pole = 1;

[filename, pathname] = uigetfile('*.wav','Choose Target Function');
if (filename ~= 0)
    handles.ctarget_pathname = fullfile(pathname,filename);
    handles.custom_path_edit.String = handles.ctarget_pathname;
    [handles.ctarget, handles.fst] = audioread(handles.ctarget_pathname);
    handles.ctarget = handles.ctarget/max(abs(handles.ctarget));
    handles.ctarget = [handles.ctarget' zeros(1, length(handles.room_ir)-length(handles.ctarget))]';
    
    handles.target = handles.ctarget;
    handles.trgt_fft = abs(fft(handles.target));
    
    assignin('base', 'target_imp', handles.target);
    assignin('base', 'ctarget_imp', handles.ctarget);
    handles.imp = zeros(1, 5000); handles.imp(1) = 1;
    handles.imp = handles.imp';
    assignin('base', 'imp', handles.imp);
end

guidata(hObject, handles);

function manual_poles_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to manual_poles_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of manual_poles_radiobutton
handles.save_flag_pole = 1;

if hObject.Value
     set(handles.graphical_poles_radiobutton, 'Value', 0);
end
handles.mp = hObject.Value;
guidata(hObject, handles);

function graphical_poles_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to graphical_poles_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of graphical_poles_radiobutton
handles.save_flag_pole = 1;

if hObject.Value
     set(handles.manual_poles_radiobutton, 'Value', 0);
end
handles.gp = hObject.Value;
guidata(hObject, handles);


function graph_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to graph_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.pole_fitting_figure);
    % Open figure to add poles interactively   
    handles.f3 = figure(3);
    handles.f3.WindowButtonMotionFcn = {@fig_wbmf, handles};
    handles.f3.WindowButtonDownFcn = {@fig_wbdf, handles};
    handles.f3.CloseRequestFcn = {@fig_crf, handles};

    handles.ah = axes;
    semilogx(handles.ah, fset(handles.room_resp, handles.fs), db(handles.room_resp)); hold on;
    handles.f3.Position= [400 200 550 420];
    set(handles.f3, 'Units', 'normalized','OuterPosition', [0 0 1 1]);
    handles.ah.Position= [0.05 0.12 0.82 0.8150];
    % Create checkboxes
    handles.chbx_inv = uicontrol(handles.f3, 'Style', 'checkbox', ...
        'Units', 'normalized', 'Position', [0.89 0.85 0.1 0.07], ...
        'String', 'Show Inv', 'Callback', {@chbx_inv_clb, handles});
    handles.chbx_eq = uicontrol(handles.f3, 'Style', 'checkbox', ...
        'Units', 'normalized', 'Position', [0.89 0.8 0.1 0.07], ...
        'String', 'Show EQ', 'Callback', {@chbx_eq_clb, handles});
    handles.chbx_trgt = uicontrol(handles.f3, 'Style', 'checkbox', ...
        'Units', 'normalized', 'Position', [0.89 0.75 0.1 0.07], ...
        'String', 'Show Target', 'Callback', {@chbx_trgt_clb, handles});
   handles.chbx_inv.Value = handles.val_inv ;
   handles.chbx_eq.Value = handles.val_eq;
   handles.chbx_trgt.Value = handles.val_trgt;
   
    trgt = semilogx(fset(handles.trgt_fft, handles.fs), db(handles.trgt_fft), 'm', 'Linewidth', 1.05);
    set(trgt, 'tag', 'trgt');
    hold on;
         %%%%% GRAPHICAL POLES %%%%%
    if handles.graphical_poles_radiobutton.Value
         % Create Title Text
         handles.title_txt = uicontrol(handles.f3, 'Style', 'text', ...
         'Units', 'normalized', 'Position', [0.2 0.95 0.5 0.035], ...
         'String', sprintf('Left Click: Add Pole | Right Click: Remove Pole'), 'FontWeight', 'bold',...
         'FontSize', 12);
         % Create Save Coefs Pushbutton
         handles.pb_coefs = uicontrol(handles.f3, 'Style', 'pushbutton', ...
        'Units', 'normalized', 'Position', [0.89 0.70 0.10 0.035], ...
        'String', 'Save Filter Coefficients', 'Callback', {@pb_coefs_clb, handles});
        % Create Close Pushbutton
         handles.pb_close = uicontrol(handles.f3, 'Style', 'pushbutton', ...
        'Units', 'normalized', 'Position', [0.94 0.955 0.05 0.035], ...
        'String', 'Close', 'Callback', {@pb_close_clb, handles});
         % Create Clear Pushbutton
        handles.pb_clear = uicontrol(handles.f3, 'Style', 'pushbutton', ...
        'Units', 'normalized', 'Position', [0.915 0.65 0.05 0.035], ...
        'String', 'Clear', 'Callback', {@pb_clear_clb, handles});   
    
        % Plot
        yaxis = zeros(1, length(handles.fp)) + 3*(-40)/4;  
        if ~isempty(handles.fp)
            hold on;
            plot(handles.fp, yaxis, 'ko', 'Linewidth', 0.8); 
            hold on;
            if handles.fp >1      
                inv = semilogx(fset(handles.inv_graph_fft, handles.fs), db(handles.inv_graph_fft), 'r',...
                    'Linewidth', 1, 'Visible', 'off');
                set(inv, 'tag', 'inv');
                hold on;
                eq = semilogx(fset(handles.eq_graph_fft, handles.fs), db(handles.eq_graph_fft), 'k',...
                    'Linewidth', 1.1, 'Visible', 'off');
                set(eq, 'tag', 'eq');
                hold off;
                
            end
        end
    
    elseif handles.manual_poles_radiobutton.Value
        %%%%% MANUAL POLES %%%%%%%
        
       handles.ah.Position = [0.05 0.12 0.7 0.8150];
       handles.chbx_inv.Position = [0.78 0.87 0.1 0.07];
       handles.chbx_eq.Position = [0.85 0.87 0.1 0.07];
       handles.chbx_trgt.Position = [0.92 0.87 0.1 0.07];
       % Create Close Pushbutton
         handles.pb_close = uicontrol(handles.f3, 'Style', 'pushbutton', ...
        'Units', 'normalized', 'Position', [0.94 0.955 0.05 0.035], ...
        'String', 'Close', 'Callback', {@pb_close_clb, handles});
        % Create table
        handles.table = uitable(handles.f3, 'Data', handles.tbl_data ,...
            'ColumnName',{'F1 (Hz)'; 'F2 (Hz)'; '# Poles'}, 'ColumnEditable',[true true true], ...
            'Units', 'normalized', 'Position', [0.78 0.55 0.1905 0.27]);
        % Create Insert PushButton
        handles.pb_insert = uicontrol(handles.f3, 'Style', 'pushbutton', ...
        'Units', 'normalized', 'Position', [0.80 0.5 0.04 0.04], ...
        'String', 'Insert', 'Callback', {@pb_insert_clb, handles});
        % Create Delete PushButton
        handles.pb_delete = uicontrol(handles.f3, 'Style', 'pushbutton', ...
        'Units', 'normalized', 'Position', [0.855 0.5 0.04 0.04], ...
        'String', 'Delete', 'Callback', {@pb_delete_clb, handles});
        % Create Clear Pushbutton
        handles.pb_clear = uicontrol(handles.f3, 'Style', 'pushbutton', ...
        'Units', 'normalized', 'Position', [0.91 0.5 0.04 0.04], ...
        'String', 'Clear', 'Callback', {@pb_clear_clb, handles});
        % Create Calculation Pushbutton
        handles.pb_calc = uicontrol(handles.f3, 'Style', 'pushbutton', ...
        'Units', 'normalized', 'Position', [0.85 0.36 0.06 0.035], ...
        'String', 'Calculation', 'Callback', {@pb_calc_clb, handles});
        % Create Save Coefs Pushbutton
         handles.pb_coefs = uicontrol(handles.f3, 'Style', 'pushbutton', ...
        'Units', 'normalized', 'Position', [0.83 0.31 0.10 0.035], ...
        'String', 'Save Filter Coefficients', 'Callback', {@pb_coefs_clb, handles});
        % Create Text titles
        handles.text_fr = uicontrol(handles.f3, 'Style', 'text', ...
        'Units', 'normalized', 'Position', [0.8 0.82 0.15 0.04], ...
        'String', 'Frequency Resolution', 'FontWeight', 'bold');
        handles.text_desfilt = uicontrol(handles.f3, 'Style', 'text', ...
        'Units', 'normalized', 'Position', [0.805 0.42 0.15 0.02], ...
        'String', 'Filter Design', 'FontWeight', 'bold');
    
    % Plot
        yaxis = zeros(1, length(handles.fp_man)) + 3*(-40)/4;  
        data = handles.table.Data;
        if (data(1,1)~=0) && (data(1,2)~=0) && (data(1,3)~=0)
            hold on;
            semilogx(handles.fp_man, yaxis, 'kx', 'Linewidth', 0.8); 
            hold on;
            inv = semilogx(fset(handles.inv_man_fft, handles.fs), db(handles.inv_man_fft), 'r',...
                'Linewidth', 1, 'Visible', 'off');
            set(inv, 'tag', 'inv');
            hold on;
            eq = semilogx(fset(handles.eq_man_fft, handles.fs), db(handles.eq_man_fft), 'k',...
                'Linewidth', 1.1, 'Visible', 'off');
            set(eq, 'tag', 'eq');
            hold off;
        end
    end
 
    set(findobj('tag','inv'), 'Visible', handles.vsb_inv);
    set(findobj('tag','eq'), 'Visible', handles.vsb_eq);
    set(findobj('tag','trgt'), 'Visible', handles.vsb_trgt);
    axis tight; lims = axis;
    xlim([10 handles.fs/2]); 
    ylim([-40 lims(4)]);
    xlabel('Frequency (Hz)', 'FontWeight', 'bold');
    ylabel('Magnitude (dB)', 'FontWeight', 'bold');

guidata(handles.pole_fitting_figure, handles);

function fig_wbmf(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);
if get(handles.graphical_poles_radiobutton,'Value')
    cp = handles.ah.CurrentPoint;
    limsx = handles.ah.XLim;
    limsy = handles.ah.YLim;
    % Check if mouse is over axes
    if (cp(1,1)>=limsx(1)) && (cp(1,1)<=limsx(2))
        if (cp(1,2)>=limsy(1)) && (cp(1,2)<=limsy(2))
            set(hObject, 'Pointer', 'crosshair');
        else
            set(hObject, 'Pointer', 'arrow');
        end
    else
        set(hObject, 'Pointer', 'arrow');
    end
end
guidata(handles.pole_fitting_figure, handles);

function fig_wbdf(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);
handles.save_flag_pole = 1;

% Check existance of target
if isempty(handles.target)
    errordlg('Target response does not exist. Please select a target function.','Error');
    return; 
end
if get(handles.graphical_poles_radiobutton,'Value')
    cp = handles.ah.CurrentPoint;
    xcord = cp(1,1);
    % Check if cp is outside of axes
    limsx = handles.ah.XLim;
    limsy = handles.ah.YLim;
    if ((xcord>limsx(1)) && (xcord<limsx(2))) &&...
            ((cp(1,2)>limsy(1)) && (cp(1,2)<limsy(2)))
        % Check type of mouse click
        handles.button = hObject.SelectionType;
        switch handles.button
            case 'normal'
                % ADD POLE
                handles.button = 1;
                handles.fp = [handles.fp xcord];
                handles.fp = sort(handles.fp);
                if length(handles.fp)>1
                    handles.p = freqpoles(handles.fp, handles.fs); 
                    [Binv,Ainv,FIRinv]=parfiltid(handles.minresp_ir, handles.target,handles.p,1); %Parallel filter design
                    handles.inv_imp = parfilt(Binv,Ainv, FIRinv, handles.imp);
                    eq_imp = FFTconv(handles.inv_imp, handles.room_ir);
                    eq_imp = eq_imp / max(abs(eq_imp));
                end
            case 'extend'
                % CLOSE FIGURE AND SAVE
                handles.button = 2;
                close(hObject);
                yaxis = zeros(1, length(handles.fp)) + handles.min_db/2;
                set(handles.graph_axes, 'NextPlot', 'replacechildren');
                semilogx(handles.graph_axes, fset(handles.room_resp, handles.fs), db(handles.room_resp));  hold on;
                plot(handles.graph_axes, handles.fp, yaxis, 'ko', 'Linewidth', 1); hold off;
                return;   
            case 'alt'
               % DELETE POLE (nearest to mouse click)
                handles.button = 3;
                [val,ind]=min(abs(log(handles.fp)-log(xcord)));
                handles.fp=[handles.fp(1:ind-1) handles.fp(ind+1:end)];
                if length(handles.fp)>1
                    handles.p = freqpoles(handles.fp, handles.fs);
                    [Binv,Ainv,FIRinv]=parfiltid(handles.minresp_ir, handles.target,handles.p,1); %Parallel filter design         
                    handles.inv_imp = parfilt(Binv, Ainv, FIRinv, handles.imp);
                    eq_imp = FFTconv(handles.inv_imp, handles.room_ir);
                    eq_imp = eq_imp / max(abs(eq_imp));
                end
            case 'open'
                % in case of double-click
                return;
        end
        assignin('base', 'fp', handles.fp);
        if length(handles.fp)>1
            assignin('base', 'p', handles.p); 
            handles.inv_graph_fft = fft(handles.inv_imp);
            handles.eq_graph_fft = fft(eq_imp);
        end
        
        guidata(handles.pole_fitting_figure, handles);
        % Plot
         draw_response(handles)

    end
end

guidata(handles.pole_fitting_figure, handles);

function fig_crf(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);

if handles.graphical_poles_radiobutton.Value || handles.manual_poles_radiobutton.Value
    h = msgbox('Please use the "Close" button for closing and saving changes.');
else
    delete(handles.f3);
end

function chbx_inv_clb(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);

handles.val_inv = hObject.Value;
handles.vsb_inv = handles.visstates{1 + hObject.Value};
set(findobj('tag','inv'), 'Visible', handles.vsb_inv);
set(findobj('tag','invfft'), 'Visible', handles.vsb_inv);
guidata(handles.pole_fitting_figure, handles);

function chbx_eq_clb(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);

handles.val_eq = hObject.Value;
handles.vsb_eq = handles.visstates{1 + hObject.Value};
set(findobj('tag','eq'), 'Visible', handles.vsb_eq);
set(findobj('tag','eqfft'), 'Visible', handles.vsb_eq);
guidata(handles.pole_fitting_figure, handles);

function chbx_trgt_clb(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);

handles.val_trgt = hObject.Value;
handles.vsb_trgt = handles.visstates{1 + hObject.Value};
set(findobj('tag','trgt'), 'Visible', handles.vsb_trgt);

guidata(handles.pole_fitting_figure, handles);

function pb_insert_clb(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);
handles.save_flag_pole = 1;

old_data = handles.table.Data;
new_data = [0 0 0];
handles.table.Data = [old_data; new_data];
handles.tbl_data = handles.table.Data;
guidata(handles.pole_fitting_figure, handles);

function pb_delete_clb(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);
handles.save_flag_pole = 1;

old_data = handles.table.Data;
s = size(old_data);
numrows = s(1);
if numrows ~= 1
    new_data = old_data(1:numrows-1,:);
    handles.table.Data = new_data;
end
handles.tbl_data = handles.table.Data;
guidata(handles.pole_fitting_figure, handles);

function pb_clear_clb(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);
handles.save_flag_pole = 1;

if handles.manual_poles_radiobutton.Value
    new_data = [0 0 0];
    handles.table.Data= new_data;
    handles.tbl_data = handles.table.Data;
    
    handles.fp_man = [];
    handles.inv_man_fft = [];
    handles.eq_man_fft = [];
    guidata(handles.pole_fitting_figure, handles);
    draw_response(handles);
elseif handles.graphical_poles_radiobutton.Value
    handles.fp = [];
    handles.inv_graph_fft = [];
    handles.eq_graph_fft = [];
    guidata(handles.pole_fitting_figure, handles);
    draw_response(handles)
end

function pb_calc_clb(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);
handles.save_flag_pole = 1;

% Check existance of target
if isempty(handles.target)
    errordlg('Target reponse does not exist. Please select a target function.','Error');
    return; 
end
handles.fp_man = [];
data = handles.table.Data;
handles.tbl_data = data;
if (data(1,1)~=0) && (data(1,2)~=0)
    s =size(data); rows = s(1);
    if (rows==1)&&(data(1,3)<2)
        errordlg('The pole-set must contain at least 2 poles','Error');
        return;
    else
        
        for i = 1:rows
           handles.fp_man = [handles.fp_man logspace(log10(data(i,1)), log10(data(i,2)), data(i,3))];
        end
        handles.p_man = freqpoles(handles.fp_man, handles.fs);
        [Binv_man,Ainv_man,FIRinv_man]=parfiltid(handles.minresp_ir, handles.target,handles.p_man,1); %Parallel filter design   
        handles.inv_imp_man = parfilt(Binv_man, Ainv_man, FIRinv_man, handles.imp);
        eq_imp_man = FFTconv(handles.inv_imp_man, handles.room_ir);
        eq_imp_man = eq_imp_man/max(abs(eq_imp_man));
        assignin('base', 'invimp', handles.inv_imp_man);
        handles.inv_man_fft = fft(handles.inv_imp_man);
        handles.eq_man_fft = fft(eq_imp_man);
        guidata(handles.pole_fitting_figure, handles);
        %Plot
        draw_response(handles)
    end
else
    errordlg('Please enter cutoff frequencies','Error');
end

guidata(handles.pole_fitting_figure, handles);

function pb_coefs_clb(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);
if isempty(handles.inv_imp)&& handles.graphical_poles_radiobutton.Value
    errordlg('No inverse function found!', 'Saving Error');
    return;
elseif isempty(handles.inv_imp_man) && handles.manual_poles_radiobutton.Value
    errordlg('No inverse function found!', 'Saving Error');
    return;
else
    [filename, pathname] = uiputfile('*.mat','Save Inverse Filter Coefficients');
    if ((filename~=0)|(pathname~=0))
       coefs_path=fullfile(pathname, filename);
       if handles.graphical_poles_radiobutton.Value
           [b1,a1,fir1]=parfiltid(handles.minresp_ir, handles.target,handles.p,1);
            save(coefs_path, 'b1', 'a1', 'fir1');
       elseif handles.manual_poles_radiobutton.Value
           [b2,a2,fir2]=parfiltid(handles.minresp_ir, handles.target,handles.p_man,1);
            save(coefs_path, 'b2', 'a2', 'fir2');
       end
    end
end

function pb_close_clb(hObject, eventdata, handles)
handles = guidata(handles.pole_fitting_figure);

delete(handles.f3);
hold off;
semilogx(handles.graph_axes, fset(handles.room_resp, handles.fs), db(handles.room_resp));  hold on;
handles.graph_axes.XLim = [10 handles.fs/2];
handles.graph_axes.YLim = [handles.min_db handles.max_db];
xlabel('Frequency (Hz)', 'FontWeight', 'bold');
ylabel('Magnitude (dB)', 'FontWeight', 'bold');

% handles.fp_man = getappdata(handles.pole_fitting_figure, 'fp_man');

yaxis1 = zeros(1, length(handles.fp)) + 3*handles.min_db/4 +3;
yaxis2 = zeros(1, length(handles.fp_man)) + 3*handles.min_db/4 - 5;

if ~isempty(handles.fp), plot(handles.graph_axes, handles.fp, yaxis1, 'ko', 'Linewidth', 1); hold on; end;
if ~isempty(handles.fp_man),plot(handles.graph_axes, handles.fp_man, yaxis2, 'kx', 'Linewidth', 1); end;

handles.graph_axes.ButtonDownFcn = {@graph_axes_ButtonDownFcn, handles};
guidata(handles.pole_fitting_figure, handles);

function draw_response(handles)
handles = guidata(handles.pole_fitting_figure);

if handles.manual_poles_radiobutton.Value
    hold off;
    semilogx(handles.ah, fset(handles.room_resp, handles.fs), db(handles.room_resp));  hold on;
    axis tight; lims = axis;
    handles.ah.XLim = [10 handles.fs/2];
    handles.ah.YLim = [-40 lims(4)] ;
    xlabel('Frequency (Hz)', 'FontWeight', 'bold');
    ylabel('Magnitude (dB)', 'FontWeight', 'bold');
    yaxis = zeros(1, length(handles.fp_man)) + 3.5*(-40)/4 ;
    plot(handles.ah, handles.fp_man, yaxis, 'kx', 'Linewidth', 1.2); hold on;

    trgt = semilogx(handles.ah, fset(handles.trgt_fft, handles.fs), db(handles.trgt_fft), 'm--', 'Linewidth', 1.05); hold on;
    set(trgt, 'tag', 'trgt');
    inv_man = semilogx(handles.ah, fset(handles.inv_man_fft, handles.fs), db(handles.inv_man_fft), 'r','Linewidth', 1); hold on;
    set(inv_man, 'tag', 'inv');
    eq_man = semilogx(handles.ah, fset(handles.eq_man_fft, handles.fs), db(handles.eq_man_fft)-20, 'k', 'Linewidth', 1.1); hold on;
    set(eq_man, 'tag', 'eq');
    set(findobj('tag','inv'), 'Visible', handles.vsb_inv);
    set(findobj('tag','eq'), 'Visible', handles.vsb_eq);
elseif handles.graphical_poles_radiobutton.Value
    hold off;
    yaxis = zeros(1, length(handles.fp))+ 3.5*(-40)/4;
    semilogx(handles.ah,fset(handles.room_resp, handles.fs), db(handles.room_resp)); hold on;
    if length(handles.fp)>1
        inv = semilogx(handles.ah,fset(handles.inv_graph_fft, handles.fs), db(handles.inv_graph_fft), 'r','Linewidth', 1); hold on;
        set(inv, 'tag', 'inv');
        eq = semilogx(handles.ah,fset(handles.eq_graph_fft, handles.fs), db(handles.eq_graph_fft)-20, 'k', 'Linewidth', 1.1); hold on;
        set(eq, 'tag', 'eq');
        set(findobj('tag','inv'), 'Visible', handles.vsb_inv);
        set(findobj('tag','eq'), 'Visible', handles.vsb_eq);
    end
    trgt = semilogx(handles.ah, fset(handles.trgt_fft, handles.fs), db(handles.trgt_fft), 'm--', 'Linewidth', 1.05);
    hold on;
    set(trgt, 'tag', 'trgt');
    % Plot poles even if fp=1
    plot(handles.ah,handles.fp, yaxis, 'ko', 'Linewidth', 1); hold off;
    axis tight; lims = axis;
    handles.ah.XLim = [10 handles.fs/2];
%     handles.ah.YLim = [handles.min_db handles.max_db];
     handles.ah.YLim = [-40 lims(4)] ;
    xlabel('Frequency (Hz)', 'FontWeight', 'bold');
    ylabel('Magnitude (dB)', 'FontWeight', 'bold');    
end



set(findobj('tag','trgt'), 'Visible', handles.vsb_trgt);

guidata(handles.pole_fitting_figure, handles);

function reset_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to reset_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.pole_fitting_figure);
handles.save_flag_pole = 1;

% Pole-Fitting GUI Default Settings
handles.fb_target_radiobutton.Value = 1;
handles.custom_target_radiobutton.Value = 0;
handles.custom_path_edit.String = '';
handles.target_popupmenu.Value = 1;
handles.fbt_type = 1;
handles.band_flag = 0;
handles.filter_order_edit.String = '' ;
handles.fbt_order = str2double(handles.filter_order_edit.String);
handles.fc1_edit.String = '';
handles.fc1 = str2double(handles.fc1_edit.String );
handles.fc2_edit.String = '';
handles.fc2 = str2double(handles.fc2_edit.String);
handles.manual_poles_radiobutton.Value = 0;
handles.graphical_poles_radiobutton.Value = 0;
%%%% Enable buttons %%%%
handles.custom_path_edit.Enable = handles.visstates{1+handles.custom_target_radiobutton.Value}; 
handles.browse_pushbutton.Enable = handles.visstates{1+handles.custom_target_radiobutton.Value}; 
handles.fc2_edit.Visible = handles.visstates{1+handles.band_flag};
handles.fc2_text.Visible = handles.visstates{1+handles.band_flag};
if handles.band_flag, handles.fc1_text.String = 'Fc1 (in Hz) :'; end;
handles.target_popupmenu.Enable = handles.visstates{1+handles.fb_target_radiobutton.Value}; 
handles.filter_order_edit.Enable =  handles.visstates{1+handles.fb_target_radiobutton.Value}; 
handles.fc1_edit.Enable =  handles.visstates{1+handles.fb_target_radiobutton.Value}; 
handles.fc2_edit.Enable =  handles.visstates{1+handles.fb_target_radiobutton.Value};
handles.fb_calc_pushbutton.Enable =  handles.visstates{1+handles.fb_target_radiobutton.Value};

%%% Pole set, Target, Inv, EQ %%%
handles.inv_graph_fft = [];
handles.eq_graph_fft = [];
handles.fp = [];
handles.inv_man_fft = [];
handles.eq_man_fft = [];
handles.fp_man = [];
handles.imp_cheby = [];
handles.imp = [];
handles.target = [];
handles.ctarget = [];
% Table Data
handles.tbl_data = [10 handles.fs/2 20];
%Check Boxes
handles.val_inv = 1; handles.val_eq = 1;
handles.vsb_inv = 'on'; handles.vsb_eq = 'on';

%Update Graph_Axes
hold off;
semilogx(handles.graph_axes, fset(handles.room_resp, handles.fs), db(handles.room_resp));
handles.graph_axes.XLim = [10 handles.fs/2];
handles.graph_axes.YLim = [handles.min_db handles.max_db];
xlabel('Frequency (Hz)', 'FontWeight', 'bold');
ylabel('Magnitude (dB)', 'FontWeight', 'bold');
set(handles.graph_axes, 'ButtonDownFcn', {@graph_axes_ButtonDownFcn, handles});
guidata(handles.pole_fitting_figure, handles);

function save_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.pole_fitting_figure);
handles.save_flag_pole = 0;

flag = 0;
if handles.manual_poles_radiobutton.Value
    setappdata(0, 'inv_fft', handles.inv_man_fft );
    setappdata(0, 'inv_imp', handles.inv_imp_man );
    if ~handles.samefilt && handles.right
        % RIGHT CHANNEL / DIF mode
        setappdata(0, 'inv_fftR', handles.inv_man_fft );
        setappdata(0, 'inv_impR', handles.inv_imp_man );
        setappdata(0, 'test', 'done1');
    end
    flag = 1;
elseif handles.graphical_poles_radiobutton.Value
    setappdata(0, 'inv_fft', handles.inv_graph_fft );
    setappdata(0, 'inv_imp', handles.inv_imp);
    if ~handles.samefilt && handles.right
        % RIGHT CHANNEL / DIF mode
        setappdata(0, 'inv_fftR', handles.inv_graph_fft );
        setappdata(0, 'inv_impR', handles.inv_imp ); 
        setappdata(0, 'test', 'done2');
    end
    flag =1;
else
    % Error
   errordlg('Please select a pole-fitting method (Manually/Graphically)','Error');
end

if flag
    % Save settings of Pole-Fitting GUI to root
    setappdata(0, 'inv_graph_fft', handles.inv_graph_fft);
    setappdata(0, 'inv_imp_graph', handles.inv_imp);
    setappdata(0, 'eq_graph_fft', handles.eq_graph_fft);
    setappdata(0, 'fp', handles.fp);
    setappdata(0, 'inv_man_fft', handles.inv_man_fft);
    setappdata(0, 'inv_imp_man', handles.inv_imp_man );
    setappdata(0, 'eq_man_fft', handles.eq_man_fft);
    setappdata(0, 'fp_man', handles.fp_man);
    setappdata(0, 'imp_cheby', handles.imp_cheby);
    setappdata(0, 'imp', handles.imp);
    setappdata(0, 'target_imp', handles.target);
    setappdata(0, 'ctarget_imp', handles.ctarget);
    setappdata(0, 'tbl_data', handles.tbl_data);
    
    setappdata(0, 'target_rdb', handles.fb_target_radiobutton.Value);
    setappdata(0, 'custom_target_rdb', handles.custom_target_radiobutton.Value);
    setappdata(0, 'custom_path',handles.custom_path_edit.String);
    setappdata(0, 'fbt_type', handles.fbt_type );
    setappdata(0, 'band_flag', handles.band_flag);
    setappdata(0, 'fbt_order', handles.filter_order_edit.String);
    setappdata(0, 'fc1', handles.fc1_edit.String);
    setappdata(0, 'fc2', handles.fc2_edit.String);
    
    setappdata(0, 'manual', handles.manual_poles_radiobutton.Value);
    setappdata(0, 'graphical', handles.graphical_poles_radiobutton.Value);
      
end
guidata(hObject, handles);

function close_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to close_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Create question for saving changes
if ~handles.save_flag_pole
    %%% CLOSE POLE FITTING GUI
    delete(handles.pole_fitting_figure);
    return;  
end

button = questdlg('Save changes to "Pole Fitting Method" ?',...
         'Save', 'Yes','No', 'Cancel', 'Yes');
switch button
    case 'Cancel'
        return;
    case 'No'
        %%%  CLOSE POLE FITTING GUI
        delete(handles.pole_fitting_figure);
    case 'Yes'
        %%% SAVE TO ROOT
        flag = 0;
        if handles.manual_poles_radiobutton.Value
            setappdata(0, 'inv_fft', handles.inv_man_fft );
            setappdata(0, 'inv_imp', handles.inv_imp_man );
            if ~handles.samefilt && handles.right
                % RIGHT CHANNEL / DIF mode
                setappdata(0, 'inv_fftR', handles.inv_man_fft );
                setappdata(0, 'inv_impR', handles.inv_imp_man );
                setappdata(0, 'test', 'done1');
            end
            flag =1;
        elseif handles.graphical_poles_radiobutton.Value
            setappdata(0, 'inv_fft', handles.inv_graph_fft );
            setappdata(0, 'inv_imp', handles.inv_imp);
            if ~handles.samefilt && handles.right
                % RIGHT CHANNEL / DIF mode
                setappdata(0, 'inv_fftR', handles.inv_graph_fft );
                setappdata(0, 'inv_impR', handles.inv_imp ); 
                setappdata(0, 'test', 'done2');
            end
            flag =1;
        else
            % Error
           errordlg('Please select a pole-fitting method (Manually/Graphically)','Error');
        end

        if flag
            % Save settings of Pole-Fitting GUI to root
            setappdata(0, 'inv_graph_fft', handles.inv_graph_fft);
            setappdata(0, 'inv_imp_graph', handles.inv_imp);
            setappdata(0, 'eq_graph_fft', handles.eq_graph_fft);
            setappdata(0, 'fp', handles.fp);
            setappdata(0, 'inv_man_fft', handles.inv_man_fft);
            setappdata(0, 'inv_imp_man', handles.inv_imp_man );
            setappdata(0, 'eq_man_fft', handles.eq_man_fft);
            setappdata(0, 'fp_man', handles.fp_man);
            setappdata(0, 'imp_cheby', handles.imp_cheby);
            setappdata(0, 'imp', handles.imp);
            setappdata(0, 'target_imp', handles.target);
            setappdata(0, 'ctarget_imp', handles.ctarget);
            setappdata(0, 'tbl_data', handles.tbl_data);

            setappdata(0, 'target_rdb', handles.fb_target_radiobutton.Value);
            setappdata(0, 'custom_target_rdb', handles.custom_target_radiobutton.Value);
            setappdata(0, 'custom_path',handles.custom_path_edit.String);
            setappdata(0, 'fbt_type', handles.fbt_type );
            setappdata(0, 'band_flag', handles.band_flag);
            setappdata(0, 'fbt_order', handles.filter_order_edit.String);
            setappdata(0, 'fc1', handles.fc1_edit.String);
            setappdata(0, 'fc2', handles.fc2_edit.String);

            setappdata(0, 'manual', handles.manual_poles_radiobutton.Value);
            setappdata(0, 'graphical', handles.graphical_poles_radiobutton.Value);

        end
        %%% CLOSE POLE FITTING GUI
        delete(handles.pole_fitting_figure);
end


% --- Executes when user attempts to close pole_fitting_figure.
function pole_fitting_figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to pole_fitting_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% delete(handles.pole_fitting_figure);
h = msgbox('Please use the "Close" button for closing.');
