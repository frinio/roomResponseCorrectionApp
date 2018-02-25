function varargout = stereo_gui(varargin)
% STEREO_GUI MATLAB code for stereo_gui.fig
%      STEREO_GUI, by itself, creates a new STEREO_GUI or raises the existing
%      singleton*.
%
%      H = STEREO_GUI returns the handle to a new STEREO_GUI or the handle to
%      the existing singleton*.
%
%      STEREO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEREO_GUI.M with the given input arguments.
%
%      STEREO_GUI('Property','Value',...) creates a new STEREO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stereo_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stereo_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stereo_gui

% Last Modified by GUIDE v2.5 15-Dec-2016 23:16:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stereo_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @stereo_gui_OutputFcn, ...
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


% --- Executes just before stereo_gui is made visible.
function stereo_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stereo_gui (see VARARGIN)

% Choose default command line output for stereo_gui
handles.output = hObject;

% Tool Tip for SWAP button
swap_tooltip = sprintf('Close "Stereo Correction"\n to apply changes');
handles.swap_pushbutton.TooltipString = swap_tooltip;

%%%% GETAPPDATA
mainpos = getappdata(0, 'main_position');
hObject.Units = 'normalized';
stereo_position = hObject.Position;
hObject.Position = [mainpos(1)+0.36 mainpos(2)+0.45 ...
    stereo_position(3) stereo_position(4)];

handles.room_ir = getappdata(0, 'room_ir');
handles.path_ir = getappdata(0, 'path_ir');
handles.fs = getappdata(0, 'fs');
handles.room_ir2 = getappdata(0, 'room_ir2');
handles.path_ir2_edit.String = getappdata(0, 'path_ir2');
handles.fs2 = getappdata(0, 'fs2');
handles.path_ir2 = getappdata(0, 'path_ir2');

handles.same = getappdata(0, 'same');
handles.dif = getappdata(0, 'dif');
handles.same_radiobutton.Value = handles.same;
handles.dif_radiobutton.Value = handles.dif;

% Left IR
[path, name, ext] = fileparts(handles.path_ir);
handles.left_channel_edit.String = [name ext];
% Right Channel
if ~isempty(handles.path_ir2)
    [path, name, ext] = fileparts(handles.path_ir2);
    handles.right_channel_edit.String = [name ext];
end

handles.save_flag = 0;
handles.swap_flag = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stereo_gui wait for user response (see UIRESUME)
% uiwait(handles.stereo_fig);


% --- Outputs from this function are returned to the command line.
function varargout = stereo_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function path_ir2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to path_ir2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path_ir2_edit as text
%        str2double(get(hObject,'String')) returns contents of path_ir2_edit as a double
fullpath = hObject.String;
if exist(fullpath, 'file')~=2, errordlg('Invalid filename or path.', 'File Error'); return; end;

% If Path/Filename is valid
handles.path_ir2 = fullpath;
[handles.room_ir2, handles.fs2] = audioread(handles.path_ir2);

 % Check for mono/stereo
size_ir = size(handles.room_ir2);
if size_ir(2) == 1
    % Normalize mono
    handles.room_ir2 = handles.room_ir2/max(abs(handles.room_ir2));
else
      errordlg('Please load a monophonic IR file.', 'File Error');
      return;
end
set(handles.path_ir2_edit, 'String', handles.path_ir2);
%%% Responses %%%
handles.room_fresp2 = fft(handles.room_ir2);
handles.magn2_or = abs(handles.room_fresp2);
handles.angle2_or = angle(handles.room_fresp2);
handles.gd2_or = groupdelay(handles.room_ir2, handles.fs2);
%%% Statistics %%%
N2 = length(handles.magn2_or);
handles.magn2_or_dbfs = db(handles.magn2_or/max(abs(handles.magn2_or)));
[handles.mean2_or, ~]=mean_oct(handles.magn2_or_dbfs,3,N2);
[handles.std2_or, handles.cntr_freq2] = std_oct(handles.magn2_or_dbfs,3,N2);  
[handles.flatness2_or, ~] = flatness(handles.magn2_or,3,N2);

% Assign and pass data through GUIs
assignin('base', 'room_ir2', handles.room_ir2);
assignin('base', 'fs_ir2', handles.fs2);

% Right IR
[path, name, ext] = fileparts(handles.path_ir2);
handles.right_channel_edit.String = [name ext];

handles.save_flag = 1;

h = msgbox('IR file is loaded.','Success');  
guidata(hObject, handles);



function browse_ir2_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to browse_ir2_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.wav','Load second channel IR');
if (filename ~= 0)
    handles.path_ir2 = fullfile(pathname, filename);
    [handles.room_ir2, handles.fs2] = audioread(handles.path_ir2);

    % Check for mono/stereo
    size_ir = size(handles.room_ir2);
    if size_ir(2) == 1
        % Normalize mono
        handles.room_ir2 = handles.room_ir2/max(abs(handles.room_ir2));
    else
          errordlg('Please load a monophonic IR file.', 'File Error');
          return;
    end
    set(handles.path_ir2_edit, 'String', handles.path_ir2);
    %%% Responses %%%
    handles.room_fresp2 = fft(handles.room_ir2);
    handles.magn2_or = abs(handles.room_fresp2);
    handles.angle2_or = angle(handles.room_fresp2);
    handles.gd2_or = groupdelay(handles.room_ir2, handles.fs2);
    %%% Statistics %%%
    N2 = length(handles.magn2_or);
    handles.magn2_or_dbfs = db(handles.magn2_or/max(abs(handles.magn2_or)));
    [handles.mean2_or, ~]=mean_oct(handles.magn2_or_dbfs,3,N2);
    [handles.std2_or, handles.cntr_freq2] = std_oct(handles.magn2_or_dbfs,3,N2);  
    [handles.flatness2_or, ~] = flatness(handles.magn2_or,3,N2);
    
    % Assign and pass data through GUIs
    assignin('base', 'room_ir2', handles.room_ir2);
    assignin('base', 'fs_ir2', handles.fs2);
    
    % Right IR
    [path, name, ext] = fileparts(handles.path_ir2);
    handles.right_channel_edit.String = [name ext];

    handles.save_flag = 1;
end

guidata(hObject, handles);

function same_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to same_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of same_radiobutton

if isempty(handles.path_ir2_edit.String)
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
else
    if ~hObject.Value, hObject.Value = 1; end
    handles.same = hObject.Value ;
    handles.dif_radiobutton.Value = 0;
    handles.dif = 0;
    
    handles.save_flag = 1;
end
guidata(hObject, handles);

function dif_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to dif_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dif_radiobutton

if isempty(handles.path_ir2_edit.String)
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    hObject.Value = 0;
else
    if ~hObject.Value, hObject.Value = 1; end
    handles.dif = hObject.Value;
    handles.same_radiobutton.Value = 0; 
    handles.same = 0;
    
    handles.save_flag = 1;
end
guidata(hObject, handles);


function left_channel_edit_Callback(hObject, eventdata, handles)
% hObject    handle to left_channel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of left_channel_edit as text
%        str2double(get(hObject,'String')) returns contents of left_channel_edit as a double


function right_channel_edit_Callback(hObject, eventdata, handles)
% hObject    handle to right_channel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of right_channel_edit as text
%        str2double(get(hObject,'String')) returns contents of right_channel_edit as a double
handles.save_flag = 1;

function swap_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to swap_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.path_ir2_edit.String)
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    return;
else
    handles.save_flag = 1;
    handles.swap_flag = 1;

    % Swap
    temp_ir = handles.room_ir;
    temp_path = handles.path_ir;
    temp_fs = handles.fs;
    handles.room_ir = handles.room_ir2; % Right channel becomes Left
    handles.room_ir2 = temp_ir; % Left channel becomes Right
    handles.fs = handles.fs2;
    handles.fs2 = temp_fs;
    % Swap paths
    handles.path_ir = handles.path_ir2;
    handles.path_ir2 = temp_path;
    handles.path_ir2_edit.String = handles.path_ir2;
    % Right IR
    [pathR, nameR, extR] = fileparts(handles.path_ir2);
    handles.right_channel_edit.String = [nameR extR];
    % Left IR
    [pathL, nameL, extL] = fileparts(handles.path_ir);
    handles.left_channel_edit.String = [nameL extL];
end
guidata(hObject, handles);


% --- Executes on button press in save_pushbutton.
function save_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.path_ir2_edit.String)
    errordlg('IR file not found! Please load an IR file.', 'File Error');
    return;
else
    handles.save_flag = 0;

    handles.magn_orR = abs(fft(handles.room_ir2));
    handles.angle_orR = angle(fft(handles.room_ir2));
    handles.gd_orR = groupdelay(handles.room_ir2, handles.fs2);
    NR = length(handles.magn_orR);
    handles.magn_orR_dbfs = db(handles.magn_orR/max(abs(handles.magn_orR)));
    [handles.mean_orR, ~]=mean_oct(handles.magn_orR_dbfs,3,NR);
    [handles.std_orR, handles.cntr_freqR] = std_oct(handles.magn_orR_dbfs,3,NR);  
    [handles.flatness_orR, ~] = flatness(handles.magn_orR,3,NR);

    %%%% SAVE TO ROOT
    setappdata(0, 'room_ir2', handles.room_ir2);
    setappdata(0, 'fs2', handles.fs2);
    setappdata(0, 'path_ir2', handles.path_ir2_edit.String);
    setappdata(0, 'magn_orR', handles.magn_orR);
    setappdata(0, 'angle_orR', handles.angle_orR);
    setappdata(0, 'gd_orR', handles.gd_orR);
    setappdata(0, 'std_orR', handles.std_orR);
    setappdata(0, 'mean_orR', handles.mean_orR);
    setappdata(0, 'cntr_freqR', handles.cntr_freqR);
    setappdata(0, 'flatness_orR', handles.flatness_orR);

    setappdata(0, 'same', handles.same);
    setappdata(0, 'dif', handles.dif);
    
    if handles.swap_flag
        setappdata(0, 'swap_flag', handles.swap_flag);
        handles.magn_or = abs(fft(handles.room_ir));
        handles.angle_or = angle(fft(handles.room_ir));
        handles.gd_or = groupdelay(handles.room_ir, handles.fs);
        NL = length(handles.magn_orR);
        handles.magn_or_dbfs = db(handles.magn_or/max(abs(handles.magn_or)));
        [handles.mean_or, ~]=mean_oct(handles.magn_or_dbfs,3,NL);
        [handles.std_or, handles.cntr_freq] = std_oct(handles.magn_or_dbfs,3,NL);  
        [handles.flatness_or, ~] = flatness(handles.magn_or,3,NL);
        
        setappdata(0, 'room_ir', handles.room_ir);
        setappdata(0, 'fs', handles.fs);
        setappdata(0, 'path_ir', handles.path_ir);
        setappdata(0, 'magn_or', handles.magn_or);
        setappdata(0, 'angle_or', handles.angle_or);
        setappdata(0, 'gd_or', handles.gd_or);
        setappdata(0, 'std_or', handles.std_or);
        setappdata(0, 'mean_or', handles.mean_or);
        setappdata(0, 'cntr_freq', handles.cntr_freq);
        setappdata(0, 'flatness_or', handles.flatness_or);
        
    end
end

guidata(hObject, handles);

function close_stereo_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to close_stereo_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Create question for saving changes
if ~handles.save_flag
    %%% CLOSE STEREO GUI
    delete(handles.stereo_fig);
    return;
end
button = questdlg('Save changes to "Stereo Correction" ?',...
         'Save', 'Yes','No', 'Cancel', 'Yes');
switch button
    case 'Cancel'
        return;
    case 'No'
        %%% CLOSE STEREO GUI
        delete(handles.stereo_fig);
    case 'Yes'
        handles.magn_orR = abs(fft(handles.room_ir2));
        handles.angle_orR = angle(fft(handles.room_ir2));
        handles.gd_orR = groupdelay(handles.room_ir2, handles.fs2);
        NR = length(handles.magn_orR);
        handles.magn_orR_dbfs = db(handles.magn_orR/max(abs(handles.magn_orR)));
        [handles.mean_orR, ~]=mean_oct(handles.magn_orR_dbfs,3,NR);
        [handles.std_orR, handles.cntr_freqR] = std_oct(handles.magn_orR_dbfs,3,NR);  
        [handles.flatness_orR, ~] = flatness(handles.magn_orR,3,NR);
        %%%% SAVE TO ROOT
        setappdata(0, 'room_ir2', handles.room_ir2);
        setappdata(0, 'fs2', handles.fs2);
        setappdata(0, 'path_ir2', handles.path_ir2_edit.String);
        setappdata(0, 'magn_orR', handles.magn_orR);
        setappdata(0, 'angle_orR', handles.angle_orR);
        setappdata(0, 'gd_orR', handles.gd_orR);
        setappdata(0, 'std_orR', handles.std_orR);
        setappdata(0, 'mean_orR', handles.mean_orR);
        setappdata(0, 'cntr_freqR', handles.cntr_freqR);
        setappdata(0, 'flatness_orR', handles.flatness_orR);
        
        setappdata(0, 'same', handles.same);
        setappdata(0, 'dif', handles.dif);
        
        if handles.swap_flag
            setappdata(0, 'swap_flag', handles.swap_flag);
            handles.magn_or = abs(fft(handles.room_ir));
            handles.angle_or = angle(fft(handles.room_ir));
            handles.gd_or = groupdelay(handles.room_ir, handles.fs);
            NL = length(handles.magn_orR);
            handles.magn_or_dbfs = db(handles.magn_or/max(abs(handles.magn_or)));
            [handles.mean_or, ~]=mean_oct(handles.magn_or_dbfs,3,NL);
            [handles.std_or, handles.cntr_freq] = std_oct(handles.magn_or_dbfs,3,NL);  
            [handles.flatness_or, ~] = flatness(handles.magn_or,3,NL);

            setappdata(0, 'room_ir', handles.room_ir);
            setappdata(0, 'fs', handles.fs);
            setappdata(0, 'path_ir', handles.path_ir);
            setappdata(0, 'magn_or', handles.magn_or);
            setappdata(0, 'angle_or', handles.angle_or);
            setappdata(0, 'gd_or', handles.gd_or);
            setappdata(0, 'std_or', handles.std_or);
            setappdata(0, 'mean_or', handles.mean_or);
            setappdata(0, 'cntr_freq', handles.cntr_freq);
            setappdata(0, 'flatness_or', handles.flatness_or);
        
        end

        %%% CLOSE STEREO GUI
        delete(handles.stereo_fig);
end



% --- Executes when user attempts to close stereo_fig.
function stereo_fig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to stereo_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% delete(hObject)
h = msgbox('Please use the "Close" button for closing.');
