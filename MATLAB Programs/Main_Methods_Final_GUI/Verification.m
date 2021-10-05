function varargout = Verification(varargin)
% VERIFICATION MATLAB code for Verification.fig
%      VERIFICATION, by itself, creates a new VERIFICATION or raises the existing
%      singleton*.
%
%      H = VERIFICATION returns the handle to a new VERIFICATION or the handle to
%      the existing singleton*.
%
%      VERIFICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VERIFICATION.M with the given input arguments.
%
%      VERIFICATION('Property','Value',...) creates a new VERIFICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Verification_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Verification_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Verification

% Last Modified by GUIDE v2.5 22-Apr-2018 08:44:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Verification_OpeningFcn, ...
                   'gui_OutputFcn',  @Verification_OutputFcn, ...
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


% --- Executes just before Verification is made visible.
function Verification_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Verification (see VARARGIN)

% Choose default command line output for Verification
handles.output = hObject;
axes(handles.axes1);
imshow(imread('systemimages\fp.jpg'));
axes(handles.axes2);
imshow(imread('systemimages\points1.jpg'));
axes(handles.axes3);
imshow(imread('studentimages\default.jpg'));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Verification wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Verification_OutputFcn(hObject, eventdata, handles) 
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
axis off;
plot(Minutiae1(:,1),Minutiae1(:,2),'r.');
set(handles.text1,'string','Loaded');





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% RESET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.nameEdit,'String', 'N/A');
set(handles.idEdit,'string', 'N/A');
set(handles.deptEdit,'string', 'N/A');
set(handles.sessionEdit,'string', 'N/A');
set(handles.bigEdit,'string', 'N/A');
axes(handles.axes3);
imshow(imread('studentimages\default.jpg'));
set(handles.resultText,'string','N/A');
set(handles.scoreText,'string','N/A');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% SESSION POP UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contents = get(handles.popupmenu1,'String'); 
popChoice = contents{get(handles.popupmenu1,'Value')};
sessionPopVal=0;
if (strcmp(popChoice,'2017-18'))
    sessionPopVal=18;
elseif (strcmp(popChoice,'2016-17'))
        sessionPopVal=17;
elseif (strcmp(popChoice,'2015-16'))
        sessionPopVal=16;
elseif (strcmp(popChoice,'2014-15'))
        sessionPopVal=15;
elseif (strcmp(popChoice,'2013-14'))
        sessionPopVal=14;
elseif (strcmp(popChoice,'2012-13'))
        sessionPopVal=13;
elseif (strcmp(popChoice,'2011-12'))
        sessionPopVal=12;
elseif (strcmp(popChoice,'2010-11'))
        sessionPopVal=11;
elseif (strcmp(popChoice,'Teacher'))
        sessionPopVal=1111;
elseif (strcmp(popChoice,'Employee'))
        sessionPopVal=2222;
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% FINGERPRINT INDEX BUTTON GROUP
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res4 = get(handles.radiobutton4,'Value');
res5 = get(handles.radiobutton5,'Value');
res6 = get(handles.radiobutton6,'Value');
res7 = get(handles.radiobutton7,'Value');
if res4==1
    figerIndex=4;
elseif res5==1
    figerIndex=5;
elseif res6==1
    figerIndex=6;
elseif res7==1
    figerIndex=7;
end
global Minutiae1;
str = '';
load('CSE_v8_1000_imprs_with_information.mat');
FINGER_IDX = figerIndex;
SESSION_ID = sessionPopVal;
ChoosenTemplateIndex(1)=0;
%%%% Getting index of Template those will be Compared.
k=1;
for i=1:size(Templates,1)
    session_id = Templates{i,2}(1:2); 
    if strcmp(Templates{i,3},num2str(FINGER_IDX))==1 && strcmp(session_id,num2str(SESSION_ID))==1
        ChoosenTemplateIndex(k)=i;
        k=k+1;
        display(['Index --> ' num2str(i)]);
        drawnow
    end
end

LOC = 0;
VALUE = 0;
set(handles.text1,'string',['Domain= ' num2str(k-1) ', pop=' num2str(SESSION_ID) ', radio=' num2str(FINGER_IDX)]);
S=zeros(size(ChoosenTemplateIndex,2),1);
for i=1:size(ChoosenTemplateIndex,2)
    S(i)=match(Minutiae1,Templates{ChoosenTemplateIndex(i)});
    if S(i)>VALUE
       VALUE = S(i);
       LOC = ChoosenTemplateIndex(i);
    end
    str = [num2str(S(i)) ' '];
    set(handles.resultText,'string',[num2str((double(i)/size(ChoosenTemplateIndex,2))*100) '% ']);
    set(handles.scoreText,'string',str);
    display([str ' --> ' num2str(Templates{ChoosenTemplateIndex(i),2}) ' -->(index in db): ' num2str(Templates{ChoosenTemplateIndex(i),3}) ' -->(index val): ' num2str(FINGER_IDX)  ]);
    drawnow
end  
% OFFER MATCHED FINGERPRINTS
if VALUE>0.475
    set(handles.resultText,'string','100%');
    set(handles.scoreText,'string',['Score : ' num2str(VALUE)]);
    info_index = find(cell2mat(Information(:,1))==str2num(Templates{LOC,2}));
    set(handles.nameEdit,'string', Information{info_index, 2});
    set(handles.idEdit,'string', num2str(Templates{LOC,2}));
    set(handles.deptEdit,'string', Information{info_index, 3});
    set(handles.sessionEdit,'string', Information{info_index, 4});
    set(handles.bigEdit,'string', 'Matched');
    tempo = ['studentimages\' Templates{LOC,2} '.jpg'];
    tempo_img = imread(tempo);
    axes(handles.axes3);
    imshow(tempo_img);
else
    set(handles.resultText,'string','100%');
    set(handles.scoreText,'string',['Score : ' num2str(VALUE)]);
    set(handles.nameEdit,'String', 'N/A');
    set(handles.idEdit,'string', 'N/A');
    set(handles.deptEdit,'string', 'N/A');
    set(handles.sessionEdit,'string', 'N/A');
    set(handles.bigEdit,'string', 'Not Matched');
    axes(handles.axes3);
    imshow(imread('studentimages\default.jpg'));
    
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



function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pushbutton5 as text
%        str2double(get(hObject,'String')) returns contents of pushbutton5 as a double


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function idEdit_Callback(hObject, eventdata, handles)
% hObject    handle to idEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of idEdit as text
%        str2double(get(hObject,'String')) returns contents of idEdit as a double


% --- Executes during object creation, after setting all properties.
function idEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to idEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deptEdit_Callback(hObject, eventdata, handles)
% hObject    handle to deptEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deptEdit as text
%        str2double(get(hObject,'String')) returns contents of deptEdit as a double


% --- Executes during object creation, after setting all properties.
function deptEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deptEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sessionEdit_Callback(hObject, eventdata, handles)
% hObject    handle to sessionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sessionEdit as text
%        str2double(get(hObject,'String')) returns contents of sessionEdit as a double


% --- Executes during object creation, after setting all properties.
function sessionEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bigEdit_Callback(hObject, eventdata, handles)
% hObject    handle to bigEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bigEdit as text
%        str2double(get(hObject,'String')) returns contents of bigEdit as a double


% --- Executes during object creation, after setting all properties.
function bigEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bigEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% DEFAULT SETTING



function nameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to nameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nameEdit as text
%        str2double(get(hObject,'String')) returns contents of nameEdit as a double


% --- Executes during object creation, after setting all properties.
function nameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

% axes(hObject);
% imshow(imread('systemimages\fp.jpg'));


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2

% axes(hObject);
% imshow(imread('systemimages\points1.jpg'));



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
