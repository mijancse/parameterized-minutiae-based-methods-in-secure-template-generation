function varargout = MinutiaeExtractor(varargin)
% MINUTIAEEXTRACTOR MATLAB code for MinutiaeExtractor.fig
%      MINUTIAEEXTRACTOR, by itself, creates a new MINUTIAEEXTRACTOR or raises the existing
%      singleton*.
%
%      H = MINUTIAEEXTRACTOR returns the handle to a new MINUTIAEEXTRACTOR or the handle to
%      the existing singleton*.
%
%      MINUTIAEEXTRACTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MINUTIAEEXTRACTOR.M with the given input arguments.
%
%      MINUTIAEEXTRACTOR('Property','Value',...) creates a new MINUTIAEEXTRACTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MinutiaeExtractor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MinutiaeExtractor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MinutiaeExtractor

% Last Modified by GUIDE v2.5 12-Apr-2019 16:36:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MinutiaeExtractor_OpeningFcn, ...
                   'gui_OutputFcn',  @MinutiaeExtractor_OutputFcn, ...
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


% --- Executes just before MinutiaeExtractor is made visible.
function MinutiaeExtractor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MinutiaeExtractor (see VARARGIN)

% Choose default command line output for MinutiaeExtractor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MinutiaeExtractor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MinutiaeExtractor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in enhanceBtn.
function enhanceBtn_Callback(hObject, eventdata, handles)
% hObject    handle to enhanceBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I;
Img = before_enhancement(I); %manually cut 4 sides of the picture
            % % % % % EnhancedImg =  fft_enhance_cubs(Img,6);             % Enhance with Blocks 6x6
            % % % % % EnhancedImg =  fft_enhance_cubs(EnhancedImg,12);         % Enhance with Blocks 12x12
            % % % % % EnhancedImg =  fft_enhance_cubs(EnhancedImg,24); % Enhance with Blocks 24x24
global EnhancedImg;
EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
axes(handles.axes1);
imshow(EnhancedImg);


% --- Executes on button press in normalizeBtn.
function normalizeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to normalizeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I_Normalized;
axes(handles.axes1);
imshow(I_Normalized);


% --- Executes on button press in binarizeBtn.
function binarizeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to binarizeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I_Normalized
global I_Oriented;
global Mask;
global I_Binarized;
global m;
global n;
I_Oriented=ridgeorient(I_Normalized, 1, 3, 3);
I_Oriented_Masked = zeros(m,n);
for i=1:1:m
   for j=1:1:n
       if(Mask(i,j)==true)
           I_Oriented_Masked(i,j) = I_Oriented(i,j);
       else
           I_Oriented_Masked(i,j) = 255;
       end
           
   end
end
% Ridge Frequency
[I_Ridge_Freq, MedianFreq] = ridgefreq_by_NA(I_Normalized, Mask, I_Oriented, 32, 5, 5, 15);
% BINARIZATION
ModifiedMask=Mask.*MedianFreq;
I_Binarized = ridgefilter_by_NA(I_Normalized, I_Oriented, ModifiedMask, 0.5, 0.5, 1) > 0;
axes(handles.axes1);
imshow(I_Binarized);

% --- Executes on button press in thinBtn.
function thinBtn_Callback(hObject, eventdata, handles)
% hObject    handle to thinBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I_Binarized;
global I_Thinned;
global Mask;
global I_Thinned_Masked;
I_Thinned =  bwmorph(~I_Binarized, 'thin',Inf);
I_Thinned_Masked = I_Thinned.*Mask;
axes(handles.axes1);
imshow(I_Thinned_Masked);


% --- Executes on button press in detectMinutiaeBtn.
function detectMinutiaeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to detectMinutiaeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I;
global I_Thinned;
global I_Thinned_Masked;
global Mask;
global I_Oriented;
global Minutiae;
[Minutiae, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);
axes(handles.axes1);
imshow(~I_Thinned_Masked);
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=5;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   r=15;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end




% --- Executes on button press in ImageSelecterBtn.
function ImageSelecterBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ImageSelecterBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.*','Image Selector');
file=fullfile(pathname, filename);
global I;
global m;
global n;
I = imread(file);
m = size(I,1); 
n = size(I,2);
axes(handles.axes1);
imshow(I);


% --- Executes during object creation, after setting all properties.
function normalizeBtn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normalizeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in roiBtn.
function roiBtn_Callback(hObject, eventdata, handles)
% hObject    handle to roiBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EnhancedImg;
global Mask;
global I_Normalized;
blksze = 5;   thresh = 0.085;   % FVC2002 DB1
[I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);
axes(handles.axes1);
imshow(Mask);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I;
axes(handles.axes1);
imshow(I);


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
