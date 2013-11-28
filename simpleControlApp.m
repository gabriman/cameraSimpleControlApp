%
%Copyright 2013 Gabriel Rodríguez Rodríguez.
%
%This program is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.
%
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with this program. If not, see <http://www.gnu.org/licenses/>.

function varargout = simpleControlApp(varargin)
%SIMPLECONTROLAPP M-file for simpleControlApp.fig
%      SIMPLECONTROLAPP, by itself, creates a new SIMPLECONTROLAPP or raises the existing
%      singleton*.
%
%      H = SIMPLECONTROLAPP returns the handle to a new SIMPLECONTROLAPP or the handle to
%      the existing singleton*.
%
%      SIMPLECONTROLAPP('Property','Value',...) creates a new SIMPLECONTROLAPP using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to simpleControlApp_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SIMPLECONTROLAPP('CALLBACK') and SIMPLECONTROLAPP('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SIMPLECONTROLAPP.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simpleControlApp

% Last Modified by GUIDE v2.5 15-Aug-2013 18:21:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simpleControlApp_OpeningFcn, ...
                   'gui_OutputFcn',  @simpleControlApp_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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




% --- Executes just before simpleControlApp is made visible.
function simpleControlApp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for simpleControlApp
handles.output = hObject;

handles.initialized = false;
handles.XMLobj = '';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simpleControlApp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simpleControlApp_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonInit.
function pushbuttonInit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.initialized == false
    
    % ---  Load/chech program folder ---
    try
        load('programFolder.mat')
        if ~exist('programFolder','var')
            errordlg(char('Program Folder is not setted. Click "Config" button'));
            return
        end
    catch ME
        errordlg(char('Program Folder is not setted. Click "Config" button'));
        return
    end
    % ----------------------------------
    
    try
    [handles.options,handles.XMLobj] = camControl_init(programFolder);
    pause(2);
    catch ME
        errordlg(char('Program Folder incorrect. Please, config it un "Config" button'));
        return
    end
    
    %handles.imgLoading = imread('gif-loading.jpg');
    
    [code,message] = camControl_initCheck(handles.options);
    if strcmp(code,'0')
        handles.camera = message;
        handles.initialized = true;
        set(handles.pushbuttonGetValues,'Enable','on')
        set(handles.pushbuttonChange,'Enable','on')
        set(handles.pushbuttonTake,'Enable','on')
        set(handles.pushbuttonInit,'Enable','off')
        set(handles.pushbuttonClose,'Enable','on')
        handles.target = 1; %camera
        
        %--- If is a Nikon camera, "host" will be setted and pathOutput to
        %execution path
        if strcmp(handles.camera,'nikon')
            set(handles.popupmenuTarget,'value',2);
            set(handles.popupmenuTarget,'enable','off');
            
            set(handles.editPath,'visible','on')
            set(handles.editPath,'enable','off');
            set(handles.editPath,'String',programFolder);
            
            set(handles.pushbuttonDir,'visible','on')
            set(handles.pushbuttonDir,'enable','off')
        else
            set(handles.popupmenuTarget,'value',1);
            set(handles.popupmenuTarget,'enable','on');
            
            set(handles.editPath,'visible','on')
            set(handles.editPath,'enable','on');
            set(handles.editPath,'String','');
            
            set(handles.pushbuttonDir,'visible','on')
            set(handles.pushbuttonDir,'enable','on')
        end
        %---
        
        handles.numImages = 0; %Number of photos taked
        handles.actualImg = 0; %photo showed
               
        a = (char('not_available.jpg'));
        pic2 = imread(a);
        imagesc(pic2,'Parent',handles.axesImg);
        axis off;
    else
        handles.initialized = false;
        errordlg(char(message));
    end

end


guidata(hObject, handles);





% --- Executes on button press in pushbuttonTake.
function pushbuttonTake_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonTake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


pathDirec = get(handles.editPath,'String');

%Only avaliable in Canon, without use un Nikon
index = get(handles.popupmenuTarget,'value');
if handles.target ~= index
    handles.target = index;
    if index == 1
        camControl_changeTargetPhotos(handles.XMLobj,'camera',char(pathDirec));
    elseif index == 2
        camControl_changeTargetPhotos(handles.XMLobj,'host',char(pathDirec));
    elseif index == 3
        camControl_changeTargetPhotos(handles.XMLobj,'both',char(pathDirec));
    end
end


if handles.target ~= 1
    if exist(pathDirec,'dir')~=7     %If directory doesnt exists
        errordlg('Photos directory doesnt exist');
        return
    end
    actualPhotos = camControl_getPhotosActual(pathDirec);
end

%Change values before take
list = strtrim(get(handles.popupmenuIso,'String'));
index = get(handles.popupmenuIso,'value');
newIso = strtrim(list(index,:));

list = strtrim(get(handles.popupmenuAperture,'String'));
index = get(handles.popupmenuAperture,'value');
newApe = strtrim(list(index,:));

list = strtrim(get(handles.popupmenuSpeed,'String'));
index = get(handles.popupmenuSpeed,'value');
newSpeed = strtrim(list(index,:));


camControl_changeSpeed(handles.XMLobj, newSpeed);
camControl_changeAperture(handles.XMLobj, newApe);
camControl_changeIso(handles.XMLobj, newIso);
%end change values


camControl_take(handles.XMLobj);


[handles.XMLobj commands] = camControl_execute(handles.options,handles.XMLobj);

[code,m,c,p] = camControl_parser_getLastCommand(commands);

if str2num(code) >= 0    %If was no error in the last command (take command or another command with error)
    if handles.target ~= 1
        new = camControl_getPhotosNew(pathDirec,actualPhotos)
        pathDirec = strcat(pathDirec,'\');
        photo = strcat(pathDirec,new)

        handles.imgArray(handles.numImages+1,:) = (char(photo));
        handles.numImages = handles.numImages + 1;
        handles.actualImg = handles.numImages;
        
        updatePhoto(hObject,eventdata,handles);
    end
end
guidata(hObject, handles);





% --- Executes on button press in pushbuttonChange.
function pushbuttonChange_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

list = strtrim(get(handles.popupmenuIso,'String'));
index = get(handles.popupmenuIso,'value');
newIso = strtrim(list(index,:));

list = strtrim(get(handles.popupmenuAperture,'String'));
index = get(handles.popupmenuAperture,'value');
newApe = strtrim(list(index,:));

list = strtrim(get(handles.popupmenuSpeed,'String'));
index = get(handles.popupmenuSpeed,'value');
newSpeed = strtrim(list(index,:));


camControl_changeSpeed(handles.XMLobj, newSpeed);
camControl_changeAperture(handles.XMLobj, newApe);
camControl_changeIso(handles.XMLobj, newIso);

[handles.XMLobj,handles.commands] = camControl_execute(handles.options,handles.XMLobj);


guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function popupmenuSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupmenuAperture_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuAperture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupmenuIso_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuIso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonGetValues.
function pushbuttonGetValues_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonGetValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
camControl_getIso(handles.XMLobj);
camControl_getAperture(handles.XMLobj);
camControl_getSpeed(handles.XMLobj);

camControl_getListIso(handles.XMLobj);
camControl_getListAperture(handles.XMLobj);
camControl_getListSpeed(handles.XMLobj);


[handles.XMLobj,handles.commands] = camControl_execute(handles.options,handles.XMLobj);

iso = camControl_parser_getIso(handles.commands);
aper = camControl_parser_getAperture(handles.commands);
speed = camControl_parser_getSpeed(handles.commands);
%set(handles.textIso,'String',iso)
%set(handles.textAperture,'String',aper)
%set(handles.textSpeed,'String',speed)

isoList = camControl_parser_getListIso(handles.commands);
apertureList = camControl_parser_getListAperture(handles.commands);
speedList = camControl_parser_getListSpeed(handles.commands);

set(handles.popupmenuIso,'String',isoList)
set(handles.popupmenuSpeed,'String',speedList)
set(handles.popupmenuAperture,'String',apertureList)


indexIso = find(strcmp(isoList,iso));
indexAperture = find(strcmp(apertureList,aper));
indexSpeed = find(strcmp(speedList,speed));

set(handles.popupmenuIso,'value',indexIso)
set(handles.popupmenuSpeed,'value',indexSpeed)
set(handles.popupmenuAperture,'value',indexAperture)


guidata(hObject, handles);



% --- Executes on button press in pushbuttonClose.
function pushbuttonClose_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
camControl_close(handles.XMLobj);
[handles.XMLobj,handles.commands] = camControl_execute(handles.options,handles.XMLobj);
if strcmp(handles.commands(1).code,'0')
    errordlg('Camera closed successfully');

    handles.initialized = false;
    set(handles.pushbuttonGetValues,'Enable','off')
    set(handles.pushbuttonChange,'Enable','off')
    set(handles.pushbuttonTake,'Enable','off')
    set(handles.pushbuttonInit,'Enable','on')
    set(handles.pushbuttonClose,'Enable','off')

end


guidata(hObject, handles);


% --- Executes on selection change in popupmenuSpeed.
function popupmenuSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSpeed contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSpeed


% --- Executes on selection change in popupmenuAperture.
function popupmenuAperture_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuAperture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuAperture contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuAperture


% --- Executes on selection change in popupmenuIso.
function popupmenuIso_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuIso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuIso contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuIso


% --- Executes during object creation, after setting all properties.
function axesImg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

 axis off;
 
% Hint: place code in OpeningFcn to populate axesImg



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in popupmenuTarget.
function popupmenuTarget_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

index = get(handles.popupmenuTarget,'value');

if index == 1
    set(handles.editPath,'visible','off')
    set(handles.pushbuttonDir,'visible','off')
else
    set(handles.editPath,'visible','on')
    set(handles.pushbuttonDir,'visible','on')
end

guidata(hObject, handles);





function editPath_Callback(hObject, eventdata, handles)
% hObject    handle to editPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPath as text
%        str2double(get(hObject,'String')) returns contents of editPath as a double


% --- Executes during object creation, after setting all properties.
function editPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'visible','off')
handles.photosDir = '';
guidata(hObject, handles);



% --- Executes on button press in pushbuttonDir.
function pushbuttonDir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.photosDir = uigetdir;
set(handles.editPath,'String',handles.photosDir)

guidata(hObject, handles);





% --- Executes during object creation, after setting all properties.
function popupmenuTarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pushbuttonDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'visible','off')


% --- Executes during object creation, after setting all properties.
function pushbuttonTake_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonTake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbuttonPrev.
function pushbuttonPrev_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.actualImg > 1
    handles.actualImg = handles.actualImg - 1 ; %photo showed
        
	updatePhoto(hObject,eventdata,handles);
end
guidata(hObject, handles);


% --- Executes on button press in pushbuttonNext.
function pushbuttonNext_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.actualImg < handles.numImages
    handles.actualImg = handles.actualImg + 1 ; %photo showed
    
	updatePhoto(hObject,eventdata,handles);
end
guidata(hObject, handles);




% --- Executes on button press in pushbuttonWindow.
function pushbuttonWindow_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure
imshow(handles.imgArray(handles.actualImg,:));















function updatePhoto(hObject, eventdata, handles)
% hObject    handle to pushbuttonNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

photo = handles.imgArray(handles.actualImg,:);
pic2 = imread(photo);
imagesc(pic2,'Parent',handles.axesImg);
axis off;

count = strcat(num2str(handles.actualImg),' / ');
count = strcat(count,num2str(handles.numImages));
set(handles.textCount,'String',count)
set(handles.textImgPath,'String',photo)


guidata(hObject, handles);


% --- Executes on button press in pushbuttonConfig.
function pushbuttonConfig_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

programFolder = uigetdir;
save('programFolder.mat','programFolder')

guidata(hObject, handles);
