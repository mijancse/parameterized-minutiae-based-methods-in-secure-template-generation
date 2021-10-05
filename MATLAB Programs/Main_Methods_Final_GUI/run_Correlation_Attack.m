function varargout = run_Correlation_Attack(varargin)
% RUN_CORRELATION_ATTACK MATLAB code for run_Correlation_Attack.fig
%      RUN_CORRELATION_ATTACK, by itself, creates a new RUN_CORRELATION_ATTACK or raises the existing
%      singleton*.
%
%      H = RUN_CORRELATION_ATTACK returns the handle to a new RUN_CORRELATION_ATTACK or the handle to
%      the existing singleton*.
%
%      RUN_CORRELATION_ATTACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUN_CORRELATION_ATTACK.M with the given input arguments.
%
%      RUN_CORRELATION_ATTACK('Property','Value',...) creates a new RUN_CORRELATION_ATTACK or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before run_Correlation_Attack_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to run_Correlation_Attack_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help run_Correlation_Attack

% Last Modified by GUIDE v2.5 14-Apr-2019 00:43:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @run_Correlation_Attack_OpeningFcn, ...
                   'gui_OutputFcn',  @run_Correlation_Attack_OutputFcn, ...
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

% --- Executes just before run_Correlation_Attack is made visible.
function run_Correlation_Attack_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to run_Correlation_Attack (see VARARGIN)

% Choose default command line output for run_Correlation_Attack
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes run_Correlation_Attack wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = run_Correlation_Attack_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function radius_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radius_1_Callback(hObject, eventdata, handles)
% hObject    handle to radius_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius_1 as text
%        str2double(get(hObject,'String')) returns contents of radius_1 as a double
density = str2double(get(hObject, 'String'));
if isnan(density)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new radius_1 value
handles.metricdata.density = density;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function scp_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scp_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scp_1_Callback(hObject, eventdata, handles)
% hObject    handle to scp_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scp_1 as text
%        str2double(get(hObject,'String')) returns contents of scp_1 as a double
volume = str2double(get(hObject, 'String'));
if isnan(volume)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new scp_1 value
handles.metricdata.volume = volume;
guidata(hObject,handles)

% --- Executes on button press in generateBtn_1.
function generateBtn_1_Callback(hObject, eventdata, handles)
% hObject    handle to generateBtn_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global General_Minutiae;
global Vault1_with_chaff;

    radius=str2double(get(handles.radius_1,'String'));     
    ChaffPointsOnCircumference = str2double(get(handles.ncp_1,'String'));
    SelectedChaffPoint = str2double(get(handles.scp_1,'String'));
    RealMinutiaeMovingPoint = str2double(get(handles.rmmp_1,'String'));
	ChaffAngleOffset=str2double(get(handles.delta_1,'String'));
    MovedAngleOffset=6.2832 - ChaffAngleOffset;
    
    %--------------------
    %
FileName='103_1.bmp';
I=imread(FileName);
[m,n]=size(I);
% imshow(I) ;
ChaffMinutiae(1,:)=[1,1,1,1];
% Mixed Code [Segmentation , Normalization]
Img = before_enhancement(I); %manually cut 4 sides of the picture
EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
blksze = 5;   thresh = 0.085;   % FVC2002 DB1
[I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);

% Orientation Est
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

% THINNING
I_Thinned =  bwmorph(~I_Binarized, 'thin',Inf);
I_Thinned_Masked = I_Thinned;
for i=1:1:m
   for j=1:1:n
       if(Mask(i,j)==true)
           I_Thinned_Masked(i,j) = I_Thinned(i,j);
       else
           I_Thinned_Masked(i,j) = 0;
       end
           
   end
end

% EXTRACT MINUTIAES
[Minutiae, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);

General_Minutiae = Minutiae(:,1:4);

% Showing Only Real Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL Minutiae - Vault 1');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
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

set(gcf,'position',[0 250 400 400]);


% Anglewise Line Creating + Fuzzy Vault Circle
ChaffIndex=1;
figure
imshow(~I_Thinned_Masked);
title('Adding CHAFF Minutiae - Vault 1');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
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
   
   r=radius;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
   
   
   
   
   % DO THE VAULT THINK for what? [BIF or TER]
%    if(Minutiae(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
%        continue;
%    end
   
   
   
   % Drwaing Fuzzy Vault Circles for the minutiae
   r=radius;
   StatingAngle = Minutiae(i,4);
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'Color',[0 0 0]);
   hold on
   
   % detecting [16] points
   angForPoints=(StatingAngle+0):pi/(ChaffPointsOnCircumference/2):(StatingAngle+(2*pi)-(pi/(ChaffPointsOnCircumference/2))); 
   xp=r*cos(angForPoints);
   yp=r*sin(angForPoints);
   
   
   
   
   
   % Getting 16 circles Centers
   for k=1:ChaffPointsOnCircumference
      Center_x(k) = xc+xp(k); 
      Center_y(k) = yc+yp(k); 
   end
   
   SixteenPointsAngles=0:pi/8:(2*pi)-(pi/8); 
   %drawing 16 circle
   for k=1:ChaffPointsOnCircumference
       r=3;
       xc=Center_x(k);
       yc=Center_y(k);
       ang=0:0.01:2*pi; 
       xp=r*cos(ang);
       yp=r*sin(ang);
       plot(xc+xp,yc+yp,'r');
       
       % Selecting Chaff
       if(k==SelectedChaffPoint)    %%%%<<<------------- 6th point chosen (clockwise)
           plot(xc,yc,'r.','MarkerSize',20);
           ChaffMinutiae(ChaffIndex,1) = xc;
           ChaffMinutiae(ChaffIndex,2) = yc;
           ChaffMinutiae(ChaffIndex,3) = Minutiae(i,3);
           if( (Minutiae(i,4) + ChaffAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset) - 6.2832;
           else
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset);
           end
           ChaffIndex = ChaffIndex+1;
       end

       % Moving the real minutiae
       if(k==RealMinutiaeMovingPoint)    %%%%<<<------------- other than 6th point chosen (clockwise)
           Minutiae(i,1) = xc;
           Minutiae(i,2) = yc;
		   if((Minutiae(i,4) + MovedAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset) - 6.2832;
           else
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset);
           end
       end

       line([x1 x2],[y1 y2],'LineWidth',2);
       hold on
   end
end

set(gcf,'position',[0 180 400 400]);



% Showing Real & Chaff Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL & CHAFF Minutiae - Vault 1')
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
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
   
   r=radius;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end


% DRAWING CHAFF MINUTIAE
hold on
for i=1:size(ChaffMinutiae(:,1),1)
   plot(ChaffMinutiae(i,1),ChaffMinutiae(i,2),'r.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=ChaffMinutiae(i,1);
   yc=ChaffMinutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'r');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=radius;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[1 0 0]);
   hold on
end

set(gcf,'position',[0 110 400 400]);

% Adding Chaff Minutiae to real
Vault1_with_chaff = [Minutiae(:,1:4); ChaffMinutiae(:,1:4)];
Vault1_without_chaff = Minutiae(:,1:4);
    







% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

handles.metricdata.radius_1 = 20;
handles.metricdata.ncp_1  = 16;
handles.metricdata.scp_1 = 6;
handles.metricdata.rmmp_1  = 11;
handles.metricdata.delta_1 = 2.5;

set(handles.radius_1, 'String', handles.metricdata.radius_1);
set(handles.ncp_1,  'String', handles.metricdata.ncp_1);
set(handles.scp_1, 'String', handles.metricdata.scp_1);
set(handles.rmmp_1,  'String', handles.metricdata.rmmp_1);
set(handles.delta_1, 'String', handles.metricdata.delta_1);

handles.metricdata.radius_2 = 16;
handles.metricdata.ncp_2  = 8;
handles.metricdata.scp_2 = 7;
handles.metricdata.rmmp_2  = 4;
handles.metricdata.delta_2 = 4.3;

set(handles.radius_2, 'String', handles.metricdata.radius_2);
set(handles.ncp_2,  'String', handles.metricdata.ncp_2);
set(handles.scp_2, 'String', handles.metricdata.scp_2);
set(handles.rmmp_2,  'String', handles.metricdata.rmmp_2);
set(handles.delta_2, 'String', handles.metricdata.delta_2);

handles.metricdata.radius_3 = 27;
handles.metricdata.ncp_3  = 8;
handles.metricdata.scp_3 = 2;
handles.metricdata.rmmp_3  = 7;
handles.metricdata.delta_3 = 5.1;

set(handles.radius_3, 'String', handles.metricdata.radius_3);
set(handles.ncp_3,  'String', handles.metricdata.ncp_3);
set(handles.scp_3, 'String', handles.metricdata.scp_3);
set(handles.rmmp_3,  'String', handles.metricdata.rmmp_3);
set(handles.delta_3, 'String', handles.metricdata.delta_3);

% Update handles structure
guidata(handles.figure1, handles);



function rmmp_1_Callback(hObject, eventdata, handles)
% hObject    handle to rmmp_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmmp_1 as text
%        str2double(get(hObject,'String')) returns contents of rmmp_1 as a double


% --- Executes during object creation, after setting all properties.
function rmmp_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmmp_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_1_Callback(hObject, eventdata, handles)
% hObject    handle to delta_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta_1 as text
%        str2double(get(hObject,'String')) returns contents of delta_1 as a double


% --- Executes during object creation, after setting all properties.
function delta_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ncp_1_Callback(hObject, eventdata, handles)
% hObject    handle to ncp_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ncp_1 as text
%        str2double(get(hObject,'String')) returns contents of ncp_1 as a double


% --- Executes during object creation, after setting all properties.
function ncp_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ncp_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radius_3_Callback(hObject, eventdata, handles)
% hObject    handle to radius_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius_3 as text
%        str2double(get(hObject,'String')) returns contents of radius_3 as a double


% --- Executes during object creation, after setting all properties.
function radius_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scp_3_Callback(hObject, eventdata, handles)
% hObject    handle to scp_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scp_3 as text
%        str2double(get(hObject,'String')) returns contents of scp_3 as a double


% --- Executes during object creation, after setting all properties.
function scp_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scp_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rmmp_3_Callback(hObject, eventdata, handles)
% hObject    handle to rmmp_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmmp_3 as text
%        str2double(get(hObject,'String')) returns contents of rmmp_3 as a double


% --- Executes during object creation, after setting all properties.
function rmmp_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmmp_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_3_Callback(hObject, eventdata, handles)
% hObject    handle to delta_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta_3 as text
%        str2double(get(hObject,'String')) returns contents of delta_3 as a double


% --- Executes during object creation, after setting all properties.
function delta_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ncp_3_Callback(hObject, eventdata, handles)
% hObject    handle to ncp_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ncp_3 as text
%        str2double(get(hObject,'String')) returns contents of ncp_3 as a double


% --- Executes during object creation, after setting all properties.
function ncp_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ncp_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in generateBtn_3.
function generateBtn_3_Callback(hObject, eventdata, handles)
% hObject    handle to generateBtn_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Vault3_with_chaff;

    radius=str2double(get(handles.radius_3,'String'));     
    ChaffPointsOnCircumference = str2double(get(handles.ncp_3,'String'));
    SelectedChaffPoint = str2double(get(handles.scp_3,'String'));
    RealMinutiaeMovingPoint = str2double(get(handles.rmmp_3,'String'));
	ChaffAngleOffset=str2double(get(handles.delta_3,'String'));
    MovedAngleOffset=6.2832 - ChaffAngleOffset;
    
    %--------------------
    %
FileName='103_1.bmp';
I=imread(FileName);
[m,n]=size(I);
% imshow(I) ;
ChaffMinutiae(1,:)=[1,1,1,1];
% Mixed Code [Segmentation , Normalization]
Img = before_enhancement(I); %manually cut 4 sides of the picture
EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
blksze = 5;   thresh = 0.085;   % FVC2002 DB1
[I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);

% Orientation Est
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

% THINNING
I_Thinned =  bwmorph(~I_Binarized, 'thin',Inf);
I_Thinned_Masked = I_Thinned;
for i=1:1:m
   for j=1:1:n
       if(Mask(i,j)==true)
           I_Thinned_Masked(i,j) = I_Thinned(i,j);
       else
           I_Thinned_Masked(i,j) = 0;
       end
           
   end
end

% EXTRACT MINUTIAES
[Minutiae, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);

General_Minutiae = Minutiae(:,1:4);

% Showing Only Real Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL Minutiae - Vault 3');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
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

set(gcf,'position',[900 250 400 400]);


% Anglewise Line Creating + Fuzzy Vault Circle
ChaffIndex=1;
figure
imshow(~I_Thinned_Masked);
title('Adding CHAFF Minutiae - Vault 3');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
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
   
   r=radius;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
   
   
   
   
   % DO THE VAULT THINK for what? [BIF or TER]
%    if(Minutiae(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
%        continue;
%    end
   
   
   
   % Drwaing Fuzzy Vault Circles for the minutiae
   r=radius;
   StatingAngle = Minutiae(i,4);
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'Color',[0 0 0]);
   hold on
   



   % detecting [16] points
   angForPoints=(StatingAngle+0):pi/(ChaffPointsOnCircumference/2):(StatingAngle+(2*pi)-(pi/(ChaffPointsOnCircumference/2))); 
   xp=r*cos(angForPoints);
   yp=r*sin(angForPoints);
   
   
   
   
   
   % Getting 16 circles Centers
   for k=1:ChaffPointsOnCircumference
      Center_x(k) = xc+xp(k); 
      Center_y(k) = yc+yp(k); 
   end
   
   SixteenPointsAngles=0:pi/8:(2*pi)-(pi/8); 
   %drawing 16 circle
   for k=1:ChaffPointsOnCircumference
       r=3;
       xc=Center_x(k);
       yc=Center_y(k);
       ang=0:0.01:2*pi; 
       xp=r*cos(ang);
       yp=r*sin(ang);
       plot(xc+xp,yc+yp,'r');
       
       % Selecting Chaff
       if(k==SelectedChaffPoint)    %%%%<<<------------- 6th point chosen (clockwise)
           plot(xc,yc,'r.','MarkerSize',20);
           ChaffMinutiae(ChaffIndex,1) = xc;
           ChaffMinutiae(ChaffIndex,2) = yc;
           ChaffMinutiae(ChaffIndex,3) = Minutiae(i,3);
           if( (Minutiae(i,4) + ChaffAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset) - 6.2832;
           else
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset);
           end
           ChaffIndex = ChaffIndex+1;
       end

       % Moving the real minutiae
       if(k==RealMinutiaeMovingPoint)    %%%%<<<------------- other than 6th point chosen (clockwise)
           Minutiae(i,1) = xc;
           Minutiae(i,2) = yc;
		   if((Minutiae(i,4) + MovedAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset) - 6.2832;
           else
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset);
           end
       end

       line([x1 x2],[y1 y2],'LineWidth',2);
       hold on
   end
end

set(gcf,'position',[900 180 400 400]);



% Showing Real & Chaff Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL & CHAFF Minutiae - Vault 3')
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
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
   
   r=radius;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end


% DRAWING CHAFF MINUTIAE
hold on
for i=1:size(ChaffMinutiae(:,1),1)
   plot(ChaffMinutiae(i,1),ChaffMinutiae(i,2),'r.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=ChaffMinutiae(i,1);
   yc=ChaffMinutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'r');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=radius;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[1 0 0]);
   hold on
end

set(gcf,'position',[900 110 400 400]);

% Adding Chaff Minutiae to real
Vault3_with_chaff = [Minutiae(:,1:4); ChaffMinutiae(:,1:4)];
Vault3_without_chaff = Minutiae(:,1:4);
    


% --- Executes on button press in generateBtn_2.
function generateBtn_2_Callback(hObject, eventdata, handles)
% hObject    handle to generateBtn_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Vault2_with_chaff;
    radius=str2double(get(handles.radius_2,'String'));     
    ChaffPointsOnCircumference = str2double(get(handles.ncp_2,'String'));
    SelectedChaffPoint = str2double(get(handles.scp_2,'String'));
    RealMinutiaeMovingPoint = str2double(get(handles.rmmp_2,'String'));
	ChaffAngleOffset=str2double(get(handles.delta_2,'String'));
    MovedAngleOffset=6.2832 - ChaffAngleOffset;
    
    %--------------------
    %
FileName='103_1.bmp';
I=imread(FileName);
[m,n]=size(I);
% imshow(I) ;
ChaffMinutiae(1,:)=[1,1,1,1];
% Mixed Code [Segmentation , Normalization]
Img = before_enhancement(I); %manually cut 4 sides of the picture
EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
blksze = 5;   thresh = 0.085;   % FVC2002 DB1
[I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);

% Orientation Est
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

% THINNING
I_Thinned =  bwmorph(~I_Binarized, 'thin',Inf);
I_Thinned_Masked = I_Thinned;
for i=1:1:m
   for j=1:1:n
       if(Mask(i,j)==true)
           I_Thinned_Masked(i,j) = I_Thinned(i,j);
       else
           I_Thinned_Masked(i,j) = 0;
       end
           
   end
end

% EXTRACT MINUTIAES
[Minutiae, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);

General_Minutiae = Minutiae(:,1:4);

% Showing Only Real Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL Minutiae - Vault 2');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
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

set(gcf,'position',[450 250 400 400]);


% Anglewise Line Creating + Fuzzy Vault Circle
ChaffIndex=1;
figure
imshow(~I_Thinned_Masked);
title('Adding CHAFF Minutiae - Vault 2');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
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
   
   r=radius;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
   
   
   
   
   % DO THE VAULT THINK for what? [BIF or TER]
%    if(Minutiae(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
%        continue;
%    end
   
   
   
   % Drwaing Fuzzy Vault Circles for the minutiae
   r=radius;
   StatingAngle = Minutiae(i,4);
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'Color',[0 0 0]);
   hold on
   
   % detecting [16] points
   angForPoints=(StatingAngle+0):pi/(ChaffPointsOnCircumference/2):(StatingAngle+(2*pi)-(pi/(ChaffPointsOnCircumference/2))); 
   xp=r*cos(angForPoints);
   yp=r*sin(angForPoints);
   
   
   
   
   
   % Getting 16 circles Centers
   for k=1:ChaffPointsOnCircumference
      Center_x(k) = xc+xp(k); 
      Center_y(k) = yc+yp(k); 
   end
   
   SixteenPointsAngles=0:pi/8:(2*pi)-(pi/8); 
   %drawing 16 circle
   for k=1:ChaffPointsOnCircumference
       r=3;
       xc=Center_x(k);
       yc=Center_y(k);
       ang=0:0.01:2*pi; 
       xp=r*cos(ang);
       yp=r*sin(ang);
       plot(xc+xp,yc+yp,'r');
       
       % Selecting Chaff
       if(k==SelectedChaffPoint)    %%%%<<<------------- 6th point chosen (clockwise)
           plot(xc,yc,'r.','MarkerSize',20);
           ChaffMinutiae(ChaffIndex,1) = xc;
           ChaffMinutiae(ChaffIndex,2) = yc;
           ChaffMinutiae(ChaffIndex,3) = Minutiae(i,3);
           if( (Minutiae(i,4) + ChaffAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset) - 6.2832;
           else
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset);
           end
           ChaffIndex = ChaffIndex+1;
       end

       % Moving the real minutiae
       if(k==RealMinutiaeMovingPoint)    %%%%<<<------------- other than 6th point chosen (clockwise)
           Minutiae(i,1) = xc;
           Minutiae(i,2) = yc;
		   if((Minutiae(i,4) + MovedAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset) - 6.2832;
           else
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset);
           end
       end

       line([x1 x2],[y1 y2],'LineWidth',2);
       hold on
   end
end

set(gcf,'position',[450 180 400 400]);



% Showing Real & Chaff Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL & CHAFF Minutiae - Vault 1')
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
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
   
   r=radius;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end


% DRAWING CHAFF MINUTIAE
hold on
for i=1:size(ChaffMinutiae(:,1),1)
   plot(ChaffMinutiae(i,1),ChaffMinutiae(i,2),'r.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=ChaffMinutiae(i,1);
   yc=ChaffMinutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'r');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=radius;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[1 0 0]);
   hold on
end

set(gcf,'position',[450 110 400 400]);

% Adding Chaff Minutiae to real
Vault2_with_chaff = [Minutiae(:,1:4); ChaffMinutiae(:,1:4)];
Vault2_without_chaff = Minutiae(:,1:4);
    



function ncp_2_Callback(hObject, eventdata, handles)
% hObject    handle to ncp_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ncp_2 as text
%        str2double(get(hObject,'String')) returns contents of ncp_2 as a double


% --- Executes during object creation, after setting all properties.
function ncp_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ncp_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_2_Callback(hObject, eventdata, handles)
% hObject    handle to delta_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta_2 as text
%        str2double(get(hObject,'String')) returns contents of delta_2 as a double


% --- Executes during object creation, after setting all properties.
function delta_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rmmp_2_Callback(hObject, eventdata, handles)
% hObject    handle to rmmp_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmmp_2 as text
%        str2double(get(hObject,'String')) returns contents of rmmp_2 as a double


% --- Executes during object creation, after setting all properties.
function rmmp_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmmp_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scp_2_Callback(hObject, eventdata, handles)
% hObject    handle to scp_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scp_2 as text
%        str2double(get(hObject,'String')) returns contents of scp_2 as a double


% --- Executes during object creation, after setting all properties.
function scp_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scp_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radius_2_Callback(hObject, eventdata, handles)
% hObject    handle to radius_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius_2 as text
%        str2double(get(hObject,'String')) returns contents of radius_2 as a double


% --- Executes during object creation, after setting all properties.
function radius_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when uipanel1 is resized.
function uipanel1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ncp_3_Callback(hObject, eventdata, handles)
% hObject    handle to ncp_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ncp_3 as text
%        str2double(get(hObject,'String')) returns contents of ncp_3 as a double


% --- Executes during object creation, after setting all properties.
function ncp_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ncp_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ncp_2_Callback(hObject, eventdata, handles)
% hObject    handle to ncp_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ncp_2 as text
%        str2double(get(hObject,'String')) returns contents of ncp_2 as a double


% --- Executes during object creation, after setting all properties.
function ncp_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ncp_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ncp_1_Callback(hObject, eventdata, handles)
% hObject    handle to ncp_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ncp_1 as text
%        str2double(get(hObject,'String')) returns contents of ncp_1 as a double


% --- Executes during object creation, after setting all properties.
function ncp_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ncp_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculateSimilarityBtn.
function calculateSimilarityBtn_Callback(hObject, eventdata, handles)
% hObject    handle to calculateSimilarityBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Vault1_with_chaff;
global Vault2_with_chaff;
global Vault3_with_chaff;
h = msgbox('Please wait...');
similarity_btn_vaults_with_chaff_12=match(Vault1_with_chaff, Vault2_with_chaff,0);
set(handles.sim12, 'String', similarity_btn_vaults_with_chaff_12);
similarity_btn_vaults_with_chaff_13=match(Vault1_with_chaff, Vault3_with_chaff,0);
set(handles.sim13, 'String', similarity_btn_vaults_with_chaff_13);
similarity_btn_vaults_with_chaff_23=match(Vault2_with_chaff, Vault3_with_chaff,0);
set(handles.sim23, 'String', similarity_btn_vaults_with_chaff_23);
close(h)
