function varargout = OneToOneMatcher(varargin)
% ONETOONEMATCHER MATLAB code for OneToOneMatcher.fig
%      ONETOONEMATCHER, by itself, creates a new ONETOONEMATCHER or raises the existing
%      singleton*.
%
%      H = ONETOONEMATCHER returns the handle to a new ONETOONEMATCHER or the handle to
%      the existing singleton*.
%
%      ONETOONEMATCHER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ONETOONEMATCHER.M with the given input arguments.
%
%      ONETOONEMATCHER('Property','Value',...) creates a new ONETOONEMATCHER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OneToOneMatcher_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OneToOneMatcher_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OneToOneMatcher

% Last Modified by GUIDE v2.5 18-Mar-2018 08:06:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OneToOneMatcher_OpeningFcn, ...
                   'gui_OutputFcn',  @OneToOneMatcher_OutputFcn, ...
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


% --- Executes just before OneToOneMatcher is made visible.
function OneToOneMatcher_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OneToOneMatcher (see VARARGIN)

% Choose default command line output for OneToOneMatcher
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OneToOneMatcher wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OneToOneMatcher_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Minutiae1;
[filename, pathname] = uigetfile('*.*','Image Selector');
file=fullfile(pathname, filename);
I = imread(file);
m = size(I,1); 
n = size(I,2);
axes(handles.axes1);
imshow(I);
% Mixed Code [Segmentation , Normalization]
Img = before_enhancement(I); %manually cut 4 sides of the picture
EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
blksze = 5;   thresh = 0.085;   % FVC2002 DB1
[I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);
            %Mask = after_mask(Mask); %manually cut 4 sides of the picture

% Orientation Est
I_Oriented=ridgeorient(I_Normalized, 1, 3, 3);

% Ridge Frequency
[I_Ridge_Freq, MedianFreq] = ridgefreq_by_NA(I_Normalized, Mask, I_Oriented, 32, 5, 5, 15);

% BINARIZATION
ModifiedMask=Mask.*MedianFreq;
I_Binarized = ridgefilter_by_NA(I_Normalized, I_Oriented, ModifiedMask, 0.5, 0.5, 1) > 0;

% THINNING
I_Thinned =  bwmorph(~I_Binarized, 'thin',Inf);

% EXTRACT MINUTIAES
[Minutiae1, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);
axes(handles.axes2);
imshow(~(I_Thinned.*Mask));
hold on;
plot(Minutiae1(:,1),Minutiae1(:,2),'r.');
set(handles.text1,'string','Loaded');



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Minutiae2;
[filename, pathname] = uigetfile('*.*','Image Selector');
file=fullfile(pathname, filename);
I = imread(file);
m = size(I,1); 
n = size(I,2);
axes(handles.axes3);
imshow(I);
% Mixed Code [Segmentation , Normalization]
Img = before_enhancement(I); %manually cut 4 sides of the picture
EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
blksze = 5;   thresh = 0.085;   % FVC2002 DB1
[I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);
            %Mask = after_mask(Mask); %manually cut 4 sides of the picture

% Orientation Est
I_Oriented=ridgeorient(I_Normalized, 1, 3, 3);

% Ridge Frequency
[I_Ridge_Freq, MedianFreq] = ridgefreq_by_NA(I_Normalized, Mask, I_Oriented, 32, 5, 5, 15);

% BINARIZATION
ModifiedMask=Mask.*MedianFreq;
I_Binarized = ridgefilter_by_NA(I_Normalized, I_Oriented, ModifiedMask, 0.5, 0.5, 1) > 0;

% THINNING
I_Thinned =  bwmorph(~I_Binarized, 'thin',Inf);

% EXTRACT MINUTIAES
[Minutiae2, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);
axes(handles.axes4);
imshow(~(I_Thinned.*Mask));
hold on;
plot(Minutiae2(:,1),Minutiae2(:,2),'r.');
set(handles.text3,'string','Loaded');


% --- Executes on button press in compareBtn.
function compareBtn_Callback(hObject, eventdata, handles)
% hObject    handle to compareBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Minutiae1;
global Minutiae2;
matchScore = match(Minutiae1, Minutiae2);
if matchScore>.65
    set(handles.text5,'string',strcat('Matched'));
else
    set(handles.text5,'string',strcat('Not Matched'));
end
set(handles.text6,'string',strcat('Score = ',num2str(matchScore)));
