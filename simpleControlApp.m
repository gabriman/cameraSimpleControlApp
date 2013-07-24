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

% Last Modified by GUIDE v2.5 23-Jul-2013 15:26:28

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
    [handles.options,handles.XMLobj] = camControl_Init;
    %Aqui esperar a comprobar que se haya iniciado bien
    handles.initialized = true;
    set(handles.pushbuttonGetValues,'Enable','on')
    set(handles.pushbuttonChange,'Enable','on')
    set(handles.pushbuttonTake,'Enable','on')
    set(handles.pushbuttonInit,'Enable','off')
    set(handles.pushbuttonClose,'Enable','on')
   
    
else
    handles.initialized = false;
    set(handles.pushbuttonGetValues,'Enable','off')
    set(handles.pushbuttonChange,'Enable','off')
    set(handles.pushbuttonTake,'Enable','off')
    set(handles.pushbuttonInit,'Enable','on')
    set(handles.pushbuttonClose,'Enable','off')
end




guidata(hObject, handles);





% --- Executes on button press in pushbuttonTake.
function pushbuttonTake_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonTake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

camControl_take(handles.XMLobj);
[handles.XMLobj commands] = camControl_execute(handles.options,handles.XMLobj);


a = ('C:\Users\Gabry\Desktop\photosCanon\2013-07-22_15-38-41_IMG_0001.JPG');
pic2 = imread(a);
imagesc(pic2,'Parent',handles.axesImg);
axis off;

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
set(handles.textIso,'String',iso)
set(handles.textAperture,'String',aper)
set(handles.textSpeed,'String',speed)

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
camControl_execute(handles.options,handles.XMLobj)
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
