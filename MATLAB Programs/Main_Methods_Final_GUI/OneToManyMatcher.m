function varargout = OneToManyMatcher(varargin)
% ONETOMANYMATCHER MATLAB code for OneToManyMatcher.fig
%      ONETOMANYMATCHER, by itself, creates a new ONETOMANYMATCHER or raises the existing
%      singleton*.
%
%      H = ONETOMANYMATCHER returns the handle to a new ONETOMANYMATCHER or the handle to
%      the existing singleton*.
%
%      ONETOMANYMATCHER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ONETOMANYMATCHER.M with the given input arguments.
%
%      ONETOMANYMATCHER('Property','Value',...) creates a new ONETOMANYMATCHER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OneToManyMatcher_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OneToManyMatcher_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OneToManyMatcher

% Last Modified by GUIDE v2.5 05-Apr-2018 10:43:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OneToManyMatcher_OpeningFcn, ...
                   'gui_OutputFcn',  @OneToManyMatcher_OutputFcn, ...
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


% --- Executes just before OneToManyMatcher is made visible.
function OneToManyMatcher_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OneToManyMatcher (see VARARGIN)

% Choose default command line output for OneToManyMatcher
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OneToManyMatcher wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OneToManyMatcher_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
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


% --- Executes on button press in matchBtn.
function matchBtn_Callback(hObject, eventdata, handles)
% hObject    handle to matchBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Minutiae1;
str = '';
load('fvc_2002_db1_b.mat'); 
S=zeros(size(Templates,1),1);
for i=1:size(Templates,1)
    S(i)=match(Minutiae1,Templates{i});
    str = ['Similarity with ' char(Templates{i,2}) ' : ' num2str(S(i))];
    set(handles.displayText,'string',str);
    set(handles.resultText,'string',[num2str((double(i)/size(Templates,1))*100) '%']);
    drawnow
end
% OFFER MATCHED FINGERPRINTS
Matched_FigerPrints=find(S>0.50);
if Matched_FigerPrints(1)>0
    set(handles.resultText,'string',['Found : ' num2str(Templates{Matched_FigerPrints(1),2})]);
    set(handles.scoreText,'string',['Score : ' num2str(S(Matched_FigerPrints(1)))]);
else
    set(handles.resultText,'string','Not Found');
    set(handles.scoreText,'string',['Score : ' 'N/A']);
end


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
