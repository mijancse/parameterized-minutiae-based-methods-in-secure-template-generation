%% Secure Fingerprint Template Generation and Verification
% Fingerprint Image Processing
% Fingerprint Minutiae Extraction
% Minutiae Template Generation
% Secure Template Generation
% Fingerprint Verification
% GUIs Tools
%% Created and Developed By: 
% Prof. Dr. Md. Mijanur Rahman, Department of Computer Science and Engineering, 
% Jatiya Kabi Kazi Nazrul Islam University, Trishal, Mymensingh, Bangladesh. 
% Email: mijan@jkkniu.edu.bd
%% Main Function
function varargout = Main(varargin)
% MAIN MATLAB code for Main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main

% Last Modified by GUIDE v2.5 18-Apr-2019 08:58:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main (see VARARGIN)

% Choose default command line output for Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in templateGenerationStepsBtn.
function templateGenerationStepsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to templateGenerationStepsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run_Secured_Template_Generator


% --- Executes on button press in templateGenerationStepsAllBtn.
function templateGenerationStepsAllBtn_Callback(hObject, eventdata, handles)
% hObject    handle to templateGenerationStepsAllBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run_template_generator


% --- Executes on button press in closeWindowsBtn.
function closeWindowsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to closeWindowsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(figure(1))
close(figure(2))
close(figure(3))
close(figure(4))
close(figure(5))
close(figure(6))
close(figure(7))
close(figure(8))
close(figure(9))
close(figure(10))
close(figure(11))
close(figure(12))


% --- Executes on button press in twoFpMatchingToolBtn.
function twoFpMatchingToolBtn_Callback(hObject, eventdata, handles)
% hObject    handle to twoFpMatchingToolBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OneToOneMatcher


% --- Executes on button press in corrAttackBtn.
function corrAttackBtn_Callback(hObject, eventdata, handles)
% hObject    handle to corrAttackBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run_Correlation_Attack


% --- Executes on button press in radiusDeltaBtn.
function radiusDeltaBtn_Callback(hObject, eventdata, handles)
% hObject    handle to radiusDeltaBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Draw_Graph_For_Delta
Draw_Graph_For_Radius


% --- Executes on button press in FVSBtn.
function FVSBtn_Callback(hObject, eventdata, handles)
% hObject    handle to FVSBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Verification


% --- Executes on button press in removingChaffsBtn.
function removingChaffsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to removingChaffsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Removing_Chaff_Display

% --- Executes on button press in closeWindowsBtn2.
function closeWindowsBtn2_Callback(hObject, eventdata, handles)
% hObject    handle to closeWindowsBtn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(figure(71))
close(figure(72))
close(figure(73))


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
analysis_fig_show


% --- Executes on button press in closeWindowsBtn3.
function closeWindowsBtn3_Callback(hObject, eventdata, handles)
% hObject    handle to closeWindowsBtn3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(figure(1))
close(figure(2))
close(figure(3))
close(figure(4))
close(figure(5))
close(figure(6))
close(figure(7))