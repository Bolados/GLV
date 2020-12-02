unit ProjectUnit;

interface

uses
  TypeUnit,EnterDataUnit,SysUtils,Dialogs,Windows,Grids,Series,Forms,StdCtrls;


    //** выбор
    function Choice(const Msg:string;TypeInfo:TMsgDlgType): Boolean;
    // придупреждения и собщения
    function Info(const Msg:string;TypeInfo:TMsgDlgType): Boolean;
    //воставления таблицы узлов после загрузки
    procedure restorePointAfterLoadFile(Serie1,serie2: TPointSeries;StringGrid: TStringGrid;var UserF:TUsersFunction);
    //задание имя проекта
    Function NameProject:string;
    // новый проект
    Function NewProject(Sender: TObject):boolean;
    // сохранение проекта по умолчанию
    Function SaveDefaultProject:boolean;
    // удаление проекта по умольчанию
    Function DeleteDefaultProject:boolean;
    // создание новый проект
    Function CreateNewProject(Sender: TObject):boolean;
    //загрузка проекта
    Function LoadProject(Sender: TObject):boolean;
    //сохранение проекта
    Function SaveProject(Sender: TObject):boolean;
    // сохранение проекта как
    Function SaveProjectAs(Sender: TObject):boolean;
    // проверка на событии о сохранении проекта
    Function EventSaveProject(NameProject:TFileName):boolean;
    // обрабочик инициализации диалоговых окон
    Function InitDialogs:boolean;


implementation

//исспользуемые модулы
uses MainUnit,SettingUnit,ExitDataUnit,CompareFileUnit,LanguageUnit;

//инициализируем диалоговые окна для  открытия и сохранения
Function InitDialogs:boolean;
begin
  try
    result:=true;
    MainForm.OpenDialog.FilterIndex:=1;
    MainForm.OpenDialog.DefaultExt:=copy(MainForm.OpenDialog.Filter,length(MainForm.OpenDialog.Filter)-3,length(MainForm.OpenDialog.Filter));
    MainForm.SaveDialog.FilterIndex:=1;
    MainForm.SaveDialog.DefaultExt:=copy(MainForm.OpenDialog.Filter,length(MainForm.OpenDialog.Filter)-3,length(MainForm.OpenDialog.Filter));
    MainForm.SaveDocument.FilterIndex:=1;
    MainForm.SaveDocument.DefaultExt:=copy(MainForm.OpenDialog.Filter,length(MainForm.OpenDialog.Filter)-3,length(MainForm.OpenDialog.Filter));
    case TypeUnit.SChooseLanguage of
      1:
        begin
          MainForm.OpenDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'ExampleFile';
          MainForm.OpenDialog.Title:='Open Project';

          MainForm.SaveDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'ExampleFile';
          MainForm.SaveDialog.Title:='Save Project As';

          MainForm.SaveDocument.InitialDir:=ExtractFilePath(Application.ExeName)+'ReportFile';
          MainForm.SaveDocument.Title:='Save Report As';

        end;
      0:
        begin
          MainForm.OpenDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'Примеры';
          MainForm.OpenDialog.Title:='Открыть Проект';

          MainForm.SaveDialog.InitialDir:=ExtractFilePath(Application.ExeName)+'Примеры';
          MainForm.SaveDialog.Title:='Сохранить Проект Как';

          MainForm.SaveDocument.InitialDir:=ExtractFilePath(Application.ExeName)+'Отчеты';
          MainForm.SaveDocument.Title:='Сохранить Итоговый Отчёт Как';
        end;
    end;
  Except
    result:=false;
  end;
End;

 //****************Работа С файлом ******************************///

///////Сохранения в файл и Загрузки из файла таблица точек /////////

(* Сохранения в файл таблица точек *)
procedure SaveStringGrid(StringGrid: TStringGrid; const FileName: TFileName);
var f:    TextFile;
    i, k: Integer;
begin
  AssignFile(f, FileName);
  append(f);     //подготовым файл для запись
  with StringGrid do
  begin
    //отмечаем начала для сохранения таблица точек
    Writeln(f, 'stringgrid data');
    //записываем количество столбцы
    Writeln(f, ColCount);
    //записываем количество строки
    Writeln(f, RowCount);
    // Запысываем значения каждого ячейка таблиц
    for i := 0 to ColCount - 1 do
      for k := 0 to RowCount - 1 do
        if (i=0) and (k=3)
        then Writeln(F, 'Choosen')
        else Writeln(F, Cells[i, k]);
  end;
  CloseFile(F);//закрываем файл
end;

//Загрузке из файла таблица точек
//!!!!!необходимо потестировать файл до использования процедура
procedure LoadStringGrid(StringGrid: TStringGrid; const FileName: TFileName);
var
  f:          TextFile;
  iTmp, i, k: Integer;
  s,strTemp,Ext:    String;
begin

  AssignFile(f, FileName);
  Reset(f);  //открываем файл для чтения

  Ext:=copy(FileName,length(FileName)-3,length(FileName));
  if Ext='.bsc' then    //проверка на верность расширения файла
  begin
    Readln(f,s);
    while (s<>'stringgrid data') do
    begin
      if Eof(F) then Exit;//если конец файл выходим
      Readln(F,s);  //ишим начала сохранения таблица данных в файле
    end;
    with StringGrid do
    begin
      // получаем количество стольбец
      Readln(f, iTmp);
      ColCount := iTmp;
      // получаем количество строки
      Readln(f, iTmp);
      RowCount := iTmp;
      // заполнения ячейки
      for i := 0 to ColCount - 1 do
        for k := 0 to RowCount - 1 do
        begin
          Readln(f, strTemp);
          Cells[i, k] := strTemp;
        end;

      if TypeUnit.SChooseLanguage=0 then Cells[0,3]:='Выбран';
    end;
  end;
  CloseFile(f); //закрываем файл
end;

//обрабочик востановления данных из StringGrid в  таблицы данных
procedure restorePointAfterLoadFile(Serie1,Serie2: TPointSeries;StringGrid: TStringGrid;
  var UserF: TUsersFunction);
var i,j:Integer;
    s:string;
begin
  //инициализируем
  Serie1.Clear;
  Serie2.Clear;
  init(UserF);
  //Восстановление данных
  for j:=1 to StringGrid.ColCount-1 do
  begin
    //увеличим значения таблицы точек на 1
    inc(UserF.Quantity);
    //установка размер таблицы точек
    SetLength(UserF.value,UserF.Quantity+1);
    for i:=1 to StringGrid.RowCount-1 do
    begin
      //узвлечения ячейки из StringGrid
      case i of
        1:
        begin
          s:=StringGrid.Cells[j,i];
          UserF.value[UserF.Quantity].x:=StrToFloat(s)
        end;
        2:
        begin
          s:=StringGrid.Cells[j,i];
          UserF.value[UserF.Quantity].y:=StrToFloat(s)
        end;
        3:
        begin
          if LowerCase(StringGrid.Cells[j,i])='ok'
          then UserF.value[UserF.Quantity].b:=True
          else UserF.value[UserF.Quantity].b:=False;
        end;
      end;
    end;
    if UserF.value[UserF.Quantity].b then
    begin
      //перерисования график выбранных точки
      Serie1.AddXY(UserF.value[UserF.Quantity].x,
                  UserF.value[UserF.Quantity].y);
    end
    else
    begin
      //перерисования график не выбранных точки
      Serie2.AddXY(UserF.value[UserF.Quantity].x,
                  UserF.value[UserF.Quantity].y);
    end
  end;
end;

//создание файл
Function CreateFile(Const FileName:TFileName):boolean;
var f:    TextFile;
begin
  result:=true;
  try
   AssignFile(f, FileName);
  //открывает файл для запись
   Rewrite(f);
   CloseFile(F);//закрываем файл
  except
    result:=false;
  end;
end;

//сохраненеие уникальных данных проекта
Procedure SavePersonalData(Const FileName:TFileName);
var f:    TextFile;
begin
  AssignFile(f, FileName);
  Append(f);     //подготовым файл для запись
  //отмечаем начала для сохранения вводные данных
  Writeln(f, 'Personal Data');
  Writeln(f,DateTimeTostr(TypeUnit.DateTimeCreateProject));
  CloseFile(F);//закрываем файл
end;

//загрузка уникльных данных проекта
Procedure LoadPersonalData(Const FileName:TFileName);
var
  f:          TextFile;
  s:    String;
begin
  AssignFile(f, FileName);
  //открываем файл чтобы прочитать
  Reset(f);
  Readln(f,s);
  //пока не нащли знак для уникальные данных
  while s <>'Personal Data' do
  begin
    //если мы в конец файл то выходим
    if Eof(F) then Exit;
    Readln(F,s);
  end;
  Readln(f,s);
  //remplacer les points par les bar pour une date
  TypeUnit.DateTimeCreateProject:=strtoDateTime(s);

  CloseFile(F);//закрываем файл
end;

//сохранение вводных двнных
Procedure SaveEnterData(Const FileName:TFileName);
var f:    TextFile;
begin
  AssignFile(f, FileName);
  Append(f);     //подготовым файл для запись
  //отмечаем начала для сохранения вводные данных
  Writeln(f, 'Enter Data');
  Writeln(f,not(MainUnit.MainForm.EnterData.Checked));
  Writeln(f,MainUnit.MainForm.ActiveEnterDataWithPoints.Checked);
  Writeln(f,MainUnit.MainForm.ActiveEnterDataWithFunction.Checked);
  Writeln(f,MainUnit.MainForm.TranslateFunction.Text);
  Writeln(f,MainUnit.MainForm.IntervalA.Text);
  Writeln(f,MainUnit.MainForm.IntervalB.Text);
  Writeln(f,MainUnit.MainForm.UsersAnalytiqueFunction.Text);
  Writeln(f,MainUnit.MainForm.Series4.Active);
  Writeln(f,MainUnit.MainForm.ActiveEnterDatawithMouse.Checked);
  Writeln(f,MainUnit.MainForm.Delta.Text);
  CloseFile(F);//закрываем файл
end;

//загрузка вводных данных
Procedure LoadEnterData(Sender: TObject; Const FileName:TFileName);
var
  f:          TextFile;
  s:    String;
begin
  AssignFile(f, FileName);
  //открываем файл чтобы прочитать
  Reset(f);
  Readln(f,s);
  //пока не нащли знак для других данных
  while s <>'Enter Data' do
  begin
    //если мы в конец файл то выходим
    if Eof(F) then Exit;
    Readln(F,s);
  end;
    Readln(f,s);
    MainUnit.MainForm.EnterData.Checked:=strtobool(s);
    MainUnit.MainForm.EnterDataClick(Sender);
    Readln(f,s);
    MainUnit.MainForm.ActiveEnterDataWithPoints.Checked:=strtobool(s);
    MainUnit.MainForm.ActiveEnterDataWithPointsClick(Sender);
    Readln(f,s);
    MainUnit.MainForm.ActiveEnterDataWithFunction.Checked:=strtobool(s);
    MainUnit.MainForm.ActiveEnterDataWithFunctionClick(Sender);
    Readln(f,s);
    MainUnit.MainForm.TranslateFunction.Text:=s;
    Readln(f,s);
    MainUnit.MainForm.IntervalA.Text:=s;
    Readln(f,s);
    MainUnit.MainForm.IntervalB.Text:=s;
    Readln(f,s);
    MainUnit.MainForm.UsersAnalytiqueFunction.Text:=s;
    Readln(f,s);
    if strtobool(s) then MainUnit.MainForm.TraceUsersAnalytiqueFunctionClick(Sender);
    Readln(f,s);
    MainUnit.MainForm.ActiveEnterDatawithMouse.Checked:= strtobool(s);
    MainUnit.MainForm.ActiveEnterDatawithMouseClick(Sender);
    Readln(f,s);
    MainUnit.MainForm.Delta.Text:=s;
  CloseFile(F);//закрываем файл
end;

//сохранение выводных данных
Procedure SaveExitData(Const FileName:TFileName);
var f:    TextFile;
begin
  AssignFile(f, FileName);
  append(f);     //подготовым файл для запись
  //отмечаем начала для сохранения вводные данных
  Writeln(f, 'Exit Data');
  Writeln(f,not(MainUnit.MainForm.ExitData.Checked));
  Writeln(f,MainUnit.MainForm.CheckBoxLagrangeFunction.Checked);
  Writeln(f,MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Checked);
  Writeln(f,MainUnit.MainForm.CheckBoxGeneralizingFunction.Checked);
  Writeln(f,MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Checked);
  Writeln(f,MainUnit.MainForm.CheckBoxGeneralizingFunctionII.Checked);
  Writeln(f,MainUnit.MainForm.CheckBoxErrorGeneralizingFunctionII.Checked);
  Writeln(f,MainUnit.MainForm.CheckBoxViewLagrangeFunction.Checked);
  Writeln(f,MainUnit.MainForm.CheckBoxViewGeneralizingFunction.Checked);
  Writeln(f,MainUnit.MainForm.CheckBoxViewGeneralizingFunctionII.Checked);
  Writeln(f,not(MainUnit.MainForm.VerificationConstruction.Checked));
  Writeln(f,MainUnit.MainForm.ControlFunction.text);
  Writeln(f,MainUnit.MainForm.series11.Active);
  Writeln(f,MainUnit.MainForm.ViewNode.Checked);
  CloseFile(F);//закрываем файл
end;

//загрузка выводных данных
Procedure LoadExitData(Sender: TObject; Const FileName:TFileName);
var
  f:          TextFile;
  s:    String;
begin
  AssignFile(f, FileName);
  //открываем файл чтобы прочитать
  Reset(f);

  Readln(f,s);
  //пока не нащли знак для выводных данных
  while s <>'Exit Data' do
  begin
    //если мы в конец файл то выходим
    if Eof(F) then Exit;
    Readln(F,s);
  end;
  Readln(f,s);
  MainUnit.MainForm.ExitData.Checked:=strtobool(s);
  MainUnit.MainForm.ExitDataClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.CheckBoxLagrangeFunction.Checked:=strtobool(s);
  MainUnit.MainForm.CheckBoxLagrangeFunctionClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Checked:=strtobool(s);
  MainUnit.MainForm.CheckBoxErrorLagrangeFunctionClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.CheckBoxGeneralizingFunction.Checked:=strtobool(s);
  MainUnit.MainForm.CheckBoxGeneralizingFunctionClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Checked:=strtobool(s);
  MainUnit.MainForm.CheckBoxErrorGeneralizingFunctionClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.CheckBoxGeneralizingFunctionII.Checked:=strtobool(s);
  MainUnit.MainForm.CheckBoxGeneralizingFunctionIIClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.CheckBoxErrorGeneralizingFunctionII.Checked:=strtobool(s);
  MainUnit.MainForm.CheckBoxErrorGeneralizingFunctionIIClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.CheckBoxViewLagrangeFunction.Checked:=strtobool(s);
  Readln(f,s);
  MainUnit.MainForm.CheckBoxViewGeneralizingFunction.Checked:=strtobool(s);
  Readln(f,s);
  MainUnit.MainForm.CheckBoxViewGeneralizingFunctionII.Checked:=strtobool(s);
  MainUnit.MainForm.CheckBoxViewGeneralizingFunctionClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.VerificationConstruction.Checked:=strtobool(s);
  MainUnit.MainForm.VerificationConstructionClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.ControlFunction.Text:=s;
  Readln(f,s);
  if strtobool(s) then MainUnit.MainForm.TraceControlFunctionClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.ViewNode.Checked:=strtobool(s);
  MainUnit.MainForm.ViewNodeClick(sender);
  CloseFile(F);//закрываем файл
end;

//сохранение данных графики
Procedure SaveGraphicsData(Const FileName:TFileName);
var f:    TextFile;
    i: Integer;
begin
  AssignFile(f, FileName);
  append(f);     //подготовым файл для запись
  Writeln(f, 'Graphics Data');
  //зум
  Writeln(f,Not(MainUnit.MainForm.ZoomAndScale.Checked));
  Writeln(f,MainUnit.MainForm.PZoom.ItemIndex);
  //выделения
  for I := 0 to TypeUnit.QCheck do
    Writeln(f,TypeUnit.CheckDistinction[i].Checked);
  Writeln(f,MainUnit.MainForm.HideFunction.ItemIndex);
  Writeln(f,MainUnit.MainForm.DistinctionWithResize.Checked);
  //оси
  Writeln(f,MainUnit.MainForm.DrawAxisX.Checked);
  Writeln(f,MainUnit.MainForm.DrawAxisY.Checked);
  Writeln(f,MainUnit.MainForm.ActiveMovingAddPoint.Checked);
  CloseFile(F);//закрываем файл
end;

//загрузка данных графики
Procedure LoadGraphicsData(Sender: TObject; Const FileName:TFileName);
var
  f:          TextFile;
  i: Integer;
  s:    String;
begin
  AssignFile(f, FileName);
  //открываем файл чтобы прочитать
  Reset(f);

  Readln(f,s);
  //пока не нащли знак для других данных
  while s <>'Graphics Data' do
  begin
    //если мы в конец файл то выходим
    if Eof(F) then Exit;
    Readln(F,s);
  end;
  Readln(f,s);
  MainUnit.MainForm.ZoomAndScale.Checked:=strtobool(s);
  MainUnit.MainForm.ZoomAndScaleClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.PZoom.ItemIndex:=strtoint(s);
  MainUnit.MainForm.PZoomClick(Sender);
  for I := 0 to TypeUnit.QCheck do
  begin
    Readln(f,s);
    TypeUnit.CheckDistinction[i].Checked:= strtobool(s);
  end;
  Readln(f,s);
  MainUnit.MainForm.HideFunction.ItemIndex:=Strtoint(s);
  Readln(f,s);
  MainUnit.MainForm.DistinctionWithResize.Checked:=strtobool(s);
  MainUnit.MainForm.CheckDistinctionSeriesClick(Sender);
  MainUnit.MainForm.DistinctionWithResizeClick(Sender);
  //оси
  Readln(f,s);
  MainUnit.MainForm.DrawAxisX.Checked:=strtobool(s);
  Readln(f,s);
  MainUnit.MainForm.DrawAxisY.Checked:=strtobool(s);
  MainUnit.MainForm.DrawAxisXClick(Sender);
  Readln(f,s);
  MainUnit.MainForm.ActiveMovingAddPoint.Checked:=strtobool(s);
  MainUnit.MainForm.ActiveMovingAddPointClick(Sender);
  CloseFile(F);//закрываем файл
end;

//сохранения данных настройки
Procedure SaveSettingData(Const FileName:TFileName);
var f:    TextFile;
begin
  AssignFile(f, FileName);
  append(f);     //подготовым файл для запись
  Writeln(f, 'Setting Data');
  Writeln(f,TypeUnit.SChooseLanguage);
  if SettingForm.ChooseLanguage.Text='Русский'
  then Writeln(f,'Russian')
  else Writeln(f,SettingUnit.SettingForm.ChooseLanguage.Text);
  Writeln(f,SettingUnit.SettingForm.RoundValue.Text);
  Writeln(f,SettingUnit.SettingForm.Precision.Text);
  Writeln(f,SettingUnit.SettingForm.AxisXLeftValue.Text);
  Writeln(f,SettingUnit.SettingForm.AxisXRightValue.Text);
  Writeln(f,SettingUnit.SettingForm.AxisYLeftValue.Text);
  Writeln(f,SettingUnit.SettingForm.AxisYRightValue.Text);

  Writeln(f,SettingUnit.SettingForm.MargeX.Text);
  Writeln(f,SettingUnit.SettingForm.MargeY.Text);
  Writeln(f,SettingUnit.SettingForm.PenWidthNotDistincted.Text);
  Writeln(f,SettingUnit.SettingForm.PenWidthDistincted.Text);

  Writeln(f,SettingUnit.SettingForm.StepTraceUsersAnalytiqueFunction.Text);
  Writeln(f,SettingUnit.SettingForm.StepTraceLagrangeAndGeneralizingFunction.Text);
  Writeln(f,SettingUnit.SettingForm.StepTraceErrorFunction.Text);
  Writeln(f,SettingUnit.SettingForm.ActiveEnterDataWithFunction.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveExitDataFormules.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveGraphe.Checked);

  Writeln(f,SettingUnit.SettingForm.ActiveGraphUserFunction.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveGraphLagrange.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveGraphGeneralisedLagrange.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveGraphLagrangeError.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeII.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeError.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeErrorII.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveGraphControlFunction.Checked);

  Writeln(f,SettingUnit.SettingForm.ActiveEnterDataPoints.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveControlFunction.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveTableValueTracedUsersAnalytiqueFunction.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveTableValueTracedLaGrangeFunction.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveTableValueTracedGeneralizingFunction.Checked);
  Writeln(f,SettingUnit.SettingForm.ActiveTableValueTracedGeneralizingFunctionII.Checked);
  Writeln(f,SettingUnit.SettingForm.depthofhistory.Text);

  Writeln(f,SettingUnit.SettingForm.Withoutrestriction.Checked);

  CloseFile(F);//закрываем файл
end;

//загрузка данных настройки
Procedure LoadSettingData(Sender: TObject; Const FileName:TFileName);
var
  f:          TextFile;
  s:    String;
begin
  AssignFile(f, FileName);
  //открываем файл чтобы прочитать
  Reset(f);
  Readln(f,s);
  //пока не нащли знак для других данных
  while s <>'Setting Data' do
  begin
    //если мы в конец файл то выходим
    if Eof(F) then Exit;
    Readln(F,s);
  end;
  Readln(f,s);
  SettingUnit.SettingForm.ChooseLanguage.ItemIndex:=strtoint(s);
  TypeUnit.SChooseLanguage:= SettingUnit.SettingForm.ChooseLanguage.ItemIndex;
  Readln(f,s);
  if s='Russian'
  then SettingUnit.SettingForm.ChooseLanguage.Text:='Русский'
  else SettingUnit.SettingForm.ChooseLanguage.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.RoundValue.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.Precision.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.AxisXLeftValue.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.AxisXRightValue.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.AxisYLeftValue.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.AxisYRightValue.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.MargeX.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.MargeY.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.PenWidthNotDistincted.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.PenWidthDistincted.Text:=s;

  Readln(f,s);
  SettingUnit.SettingForm.StepTraceUsersAnalytiqueFunction.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.StepTraceLagrangeAndGeneralizingFunction.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.StepTraceErrorFunction.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.ActiveEnterDataWithFunction.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveExitDataFormules.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveGraphe.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveGraphUserFunction.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveGraphLagrange.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveGraphGeneralisedLagrange.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeII.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveGraphLagrangeError.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeError.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeErrorII.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveGraphControlFunction.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveEnterDataPoints.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveControlFunction.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveTableValueTracedUsersAnalytiqueFunction.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveTableValueTracedLaGrangeFunction.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveTableValueTracedGeneralizingFunction.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.ActiveTableValueTracedGeneralizingFunctionII.Checked:=strtobool(s);
  Readln(f,s);
  SettingUnit.SettingForm.depthofhistory.Text:=s;
  Readln(f,s);
  SettingUnit.SettingForm.Withoutrestriction.Checked:=strtobool(s);

  SettingUnit.SettingForm.DatePickerFrom.Date:=TypeUnit.DateTimeCreateProject;
  SettingUnit.SettingForm.TimePickerFrom.Time:=TypeUnit.DateTimeCreateProject;
  SettingUnit.SettingForm.DatePickerTo.Date:=now;
  SettingUnit.SettingForm.TimePickerTo.Time:=now;

  SettingUnit.SettingForm.RoundValueChange(Sender);
  ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
  CloseFile(F);//закрываем файл
  SettingUnit.SettingForm.ChooseLanguage.ItemIndex:=TypeUnit.SChooseLanguage;
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[TypeUnit.SChooseLanguage]);
end;

//сохранения узлов
Procedure SaveTablePointInterpolation(Const FileName:TFileName);
begin
   SaveStringGrid(MainUnit.MainForm.StringGrid1,FileName);
end;

//загрузка узлов
Procedure LoadTablePointInterpolation(Sender: TObject; Const FileName:TFileName);
begin
  LoadStringGrid(MainUnit.MainForm.StringGrid1,FileName);
  restorePointAfterLoadFile(MainUnit.MainForm.Series2,MainUnit.MainForm.Series3,
  MainUnit.MainForm.StringGrid1,TypeUnit.UsersFunction);
end;

//сохранения архива использованных структурообразуюших функции
Procedure SaveHistoryData(Const FileName:TFileName);
var f:    TextFile;
    i: Integer;
begin
  AssignFile(f, FileName);
  append(f);     //подготовым файл для запись
  Writeln(f, 'history data');
  Writeln(f,MainUnit.MainForm.ActiveSelectMultiple.Checked);
  Writeln(f,MainUnit.MainForm.HistoryTranslateFunction.Items.Count);
  for I := 0 to MainUnit.MainForm.HistoryTranslateFunction.Items.Count - 1 do
    Writeln(f,MainUnit.MainForm.HistoryTranslateFunction.Items[i]);
  CloseFile(F);//закрываем файл
end;

//загрузка архива использованных структурообразуюших функции
Procedure LoadHistoryData(Const FileName:TFileName);
var f:    TextFile;
    i, k: Integer;
    s:string;
begin
  AssignFile(f, FileName);
  //открываем файл чтобы прочитать
  Reset(f);
  Readln(f,s);
  //пока не нащли знак для архива
  while s <>'history data' do
  begin
    //если мы в конец файл то выходим
    if Eof(F) then Exit;
    Readln(F,s);
  end;
  Readln(f,s);
  MainUnit.MainForm.ActiveSelectMultiple.Checked:=strtobool(s);
  Readln(f,s);
  k:=strtoint(s);
  MainUnit.MainForm.HistoryTranslateFunction.Clear;
  for I := 0 to k - 1 do
  begin
    Readln(f,s);
    MainUnit.MainForm.HistoryTranslateFunction.Items[i]:=s;
  end;
  MainUnit.MainForm.HistoryTranslateFunction.ItemIndex:=k-1;
  CloseFile(F);//закрываем файл
end;

//Имя проекта
Function NameProject:string;
begin
  case typeUnit.SChooseLanguage of
    1:result:= 'Operative interpolation with a single structure-function';
    0:result:= 'Оперативная интерполяция с одной структурообразующей функцией';
  end;
end;

//сохраненение всех данных проекта в файл
Function SaveInFile(NameFile:TFileName):boolean;
begin
  result:=true;
  try
    //создаем файл
    ProjectUnit.CreateFile(NameFile);
    //сохраняем уникальные данные проекта
    ProjectUnit.SavePersonalData(NameFile);
    //сохраняем вводные данные
    ProjectUnit.SaveEnterData(NameFile);
    //сохраняем выводные данные
    ProjectUnit.SaveExitData(NameFile);
    //сохраняем графические данные
    ProjectUnit.SaveGraphicsData(NameFile);
    //сохраняем данные настройки
    ProjectUnit.SaveSettingData(NameFile);
    //сохраняем архив
    ProjectUnit.SaveHistoryData(NameFile);
    //сохраняем таблица узлов
    ProjectUnit.SaveTablePointInterpolation(NameFile);
  except
    result:=False;
  end;
end;

//загрузка всех данных проекта из файла
Function LoadoutFile(Sender: TObject):boolean;
begin
  result:=true;
  try
    //загружаем уникальные данных файла
    ProjectUnit.LoadPersonalData(MainUnit.MainForm.OpenDialog.FileName);
    //загружаем  настройнные двнные
    ProjectUnit.LoadSettingData(Sender,MainUnit.MainForm.OpenDialog.FileName);
    //загружаем  таблица точек интерполяции
    ProjectUnit.LoadTablePointInterpolation(Sender,MainUnit.MainForm.OpenDialog.FileName);
    //загружаем  вводные двнные
    ProjectUnit.LoadEnterData(Sender,MainUnit.MainForm.OpenDialog.FileName);
    //загружаем  выводные двнные
    ProjectUnit.LoadExitData(Sender,MainUnit.MainForm.OpenDialog.FileName);
    //загружаем  графические двнные
    ProjectUnit.LoadGraphicsData(Sender,MainUnit.MainForm.OpenDialog.FileName);
    //загружаем  историю использованных структурообразующих функции
    ProjectUnit.LoadHistoryData(MainUnit.MainForm.OpenDialog.FileName);
  except
    raise;
  end;
end;
//****************конец Работа С файлом ******************************///



//****************Работа С Проектом  ******************************///

//сохранение проекта как
Function SaveProjectAs(Sender: TObject):boolean;
begin
  result:=False;
  try
    //с диалогом сохранения
    with MainUnit.MainForm.SaveDialog do
    begin
      /// установка расширения по умолчания
      FilterIndex:=1;
      DefaultExt:=copy(Filter,length(Filter)-3,length(Filter));
      case TypeUnit.SChooseLanguage of
        1:FileName:='New Project';
        0:FileName:='Новый Проект';
      end;
      if Execute then
      begin
        //создаем файл
        ProjectUnit.CreateFile(FileName);
        MainUnit.MainForm.OpenDialog.FileName:=FileName;
        //сохраняем данные
        result:=ProjectUnit.SaveProject(sender);
      end;
    end;

  except
     TypeUnit.linkProject:=MainUnit.MainForm.OpenDialog.FileName;
     MainForm.Caption:=ProjectUnit.NameProject+' ['+MainUnit.MainForm.OpenDialog.FileName+'] ';
     case TypeUnit.SChooseLanguage of
        1:ProjectUnit.Info('Unable to save file',mtWarning);
        0:ProjectUnit.Info('Не возможно сохранит файл',mtWarning);
     end;
  end;
end;

//сохранение проект
Function SaveProject(Sender: TObject):boolean;
begin
  try
    if not FileExists(MainUnit.MainForm.OpenDialog.FileName) then
    begin
      //если не сушествует файл то вызывем процедуру сохранить как
      MainUnit.MainForm.SaveDialog.FileName:=MainUnit.MainForm.OpenDialog.FileName;
      result:=ProjectUnit.SaveProjectAs(Sender);
    end
    else
    begin
      try
        //сохраняем проект
        SaveInFile(MainUnit.MainForm.OpenDialog.FileName);
        //  установим путь проекта
        TypeUnit.linkProject:=MainUnit.MainForm.OpenDialog.FileName;
        MainForm.Caption:=ProjectUnit.NameProject+' ['+MainUnit.MainForm.OpenDialog.FileName+'] ';
        result:=True;
      except
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('Unable to save file',mtWarning);
          0:ProjectUnit.Info('Не возможно сохранит файл ',mtWarning);
        end;
        MainUnit.MainForm.Caption:=ProjectUnit.NameProject+' ['+MainUnit.MainForm.OpenDialog.FileName+'] ';
        raise;
      end;
    end;
  Except
    result:=false;
  end;
end;

Function NewProject(Sender: TObject):boolean;
var i:Integer;
begin
  result:=true;
  try
    //  установим путь проекта
    TypeUnit.linkProject:=MainUnit.MainForm.OpenDialog.FileName;
    MainUnit.MainForm.Caption:=ProjectUnit.NameProject+' ['+MainUnit.MainForm.OpenDialog.FileName+'] ';

    // инициализирем график
    for i:=0 to MainUnit.MainForm.Chart.SeriesCount-1 do
      MainUnit.MainForm.Chart.Series[i].Clear;

    //инициализируем таблица точек
    init(UsersFunction);
    //инициализируем таблица узлы интерполирования
    init(NodeInterPolation);
    //инициализируем StringGrid
    MainUnit.MainForm.StringGrid1.ColCount:=1;
    MainUnit.MainForm.StringGrid1.Cells[0,0]:='No.';
    MainUnit.MainForm.StringGrid1.Cells[0,1]:='X';
    MainUnit.MainForm.StringGrid1.Cells[0,2]:='Y';
    TypeUnit.SelectedCol:=-1;
    // инициализируем ввод данных
    MainUnit.MainForm.AbscissX.Clear;
    MainUnit.MainForm.OrdinateY.Clear;
    MainUnit.MainForm.PointChoosen.Checked:=False;
    MainUnit.MainForm.TranslateFunction.Clear;
    MainUnit.MainForm.IntervalA.Clear;
    MainUnit.MainForm.IntervalB.Clear;
    MainUnit.MainForm.UsersAnalytiqueFunction.Clear;
    MainUnit.MainForm.ControlFunction.Clear;
    TypeUnit.CheckDistinction[0].checked:=True;
    MainUnit.MainForm.CheckDistinctionClick(Sender);
    MainForm.HistoryTranslateFunction.Clear;
    MainForm.ActiveMovingAddPoint.Checked:=false;
    MainUnit.MainForm.LagrangeAccuracy.Text:='0';
    MainUnit.MainForm.GeneralisedAccuracy.Text:='0';
    MainUnit.MainForm.GeneralisedAccuracyII.Text:='0';

    //инициализируем формулы
    TypeUnit.TypeOriginalPolynomeLagrange:='';
    TypeUnit.TypeGeneralizedPolynomeLagrange:='';
    TypeUnit.TypeGeneralizedPolynomeLagrangeII:='';
    MainUnit.MainForm.MemoInformation.Clear;
    MainUnit.MainForm.CheckBoxViewGeneralizingFunctionClick(Sender);
    //инициализируем маштабирование
    MainUnit.MainForm.Chart.Zoom.Allow:=False;
    //инициализируем рисование оси
    MainUnit.MainForm.DrawAxisX.Checked:=True;
    MainUnit.MainForm.DrawAxisY.Checked:=True;
    MainUnit.MainForm.DrawAxisXClick(Sender);
    // Установим время создание проекта
    TypeUnit.DateTimeCreateProject:=now;
    // Установим начальные времени при построения функции
    TypeUnit.TimeTracedF:=-1;
    TypeUnit.TimeTracedL:=-1;
    TypeUnit.TimeTracedGL1:=-1;
    TypeUnit.TimeTracedGL2:=-1;
    //установка время построения функций
    ExitDataUnit.SetAVGTimeTraced;
    //инициализуем диалоговые окна
    InitDialogs;
  Except
    result:=False;
  end;
end;

//создать новый проект
Function CreateNewProject(Sender: TObject):boolean;
var s:string;
begin
  try
    //инициализируем данных для начала работы проекта

    case TypeUnit.SChooseLanguage of
      1:s:='Save Actual Project?';
      0:s:='Сохранить текущий проект?';
    end;
    //проверка на необходимость сохранения проекта
    if  (EventSaveProject(MainForm.OpenDialog.FileName)
        and ProjectUnit.Choice(s,mtConfirmation))
    then
    begin
      case TypeUnit.SChooseLanguage of
        1:s:='Project Saved.';
        0:s:='Проект сохранён.';
      end;
      //сохранения если проект не был сохранен
      if ProjectUnit.SaveProject(Sender) then ProjectUnit.Info(S,MtInformation);
    end;
    case TypeUnit.SChooseLanguage of
      1:MainUnit.MainForm.OpenDialog.FileName:='New Project';
      0:MainUnit.MainForm.OpenDialog.FileName:='Новый Проект';
    end;
    //создаем новый проект
    result:= ProjectUnit.NewProject(Sender);
  Except
    result:=false;
  end;
end;

//загрузить проект
Function LoadProject(Sender: TObject):boolean;
var Ext,s:string;
begin
 try
    //сохранения если проект не был сохранен
    case TypeUnit.SChooseLanguage of
      1:s:='Save Actual Project?';
      0:s:='Сохранить текущий проект?';
    end;
     //проверка на необходимость сохранения проекта
    if  (EventSaveProject(MainForm.OpenDialog.FileName)
        and ProjectUnit.Choice(s,mtConfirmation))
    then
    begin
      case TypeUnit.SChooseLanguage of
        1:s:='Project Saved.';
        0:s:='Проект сохранён.';
      end;
       //сохранения если проект не был сохранен
      if ProjectUnit.SaveProject(Sender) then ProjectUnit.Info(S,MtInformation);
    end;
    result:=true;
    if MainUnit.MainForm.OpenDialog.Execute then
    begin
      //если запустили диалог и если сушествует файл то
      if FileExists(MainUnit.MainForm.OpenDialog.FileName) then
      begin
        //увлекаем расширение
        Ext:=copy(MainUnit.MainForm.OpenDialog.FileName,length(MainUnit.MainForm.OpenDialog.FileName)-3,length(MainUnit.MainForm.OpenDialog.FileName));
        if Ext='.bsc' then
        begin
          try
            //создать новый пустой проект
            ProjectUnit.NewProject(Sender);
            LoadOutFile(Sender);
            TypeUnit.linkProject:=MainUnit.MainForm.OpenDialog.FileName;
            MainUnit.MainForm.Caption:=ProjectUnit.NameProject+' ['+MainUnit.MainForm.OpenDialog.FileName+'] ';
          except
            //при ошибке необходимо  создать новый пустой проект
            case TypeUnit.SChooseLanguage of
              1:MainUnit.MainForm.OpenDialog.FileName:='New Project';
              0:MainUnit.MainForm.OpenDialog.FileName:='Новый Проект';
            end;

            case TypeUnit.SChooseLanguage of
              1:
                if ProjectUnit.Info('Error Load file.Open New project',mtWarning)
                  and ProjectUnit.NewProject(Sender)
                then
                begin
                  TypeUnit.linkProject:=MainUnit.MainForm.OpenDialog.FileName;
                  ProjectUnit.SaveDefaultProject;
                end;
              0:
                if ProjectUnit.Info('ошибка загрузки.Открываем пустой проект',mtWarning)
                  and  ProjectUnit.NewProject(Sender)
                then
                begin
                  TypeUnit.linkProject:=MainUnit.MainForm.OpenDialog.FileName;
                  ProjectUnit.SaveDefaultProject;
                end;
            end;
            result:=false;
          end;
        end
        else
        begin
          case TypeUnit.SChooseLanguage of
            1:
              if ProjectUnit.Info('Wrong Format file.Open New project',mtWarning)
              then ProjectUnit.NewProject(Sender);
            0:
              if ProjectUnit.Info('не верное формат файл.Открываем пустой проект',mtWarning)
              then ProjectUnit.NewProject(Sender);
          end;
          result:=false;
        end;
      end
      else
      begin
        case TypeUnit.SChooseLanguage of
          1:
            if ProjectUnit.Info('Not Exist file.Open New project',mtWarning)
            then ProjectUnit.NewProject(Sender);
          0:
            if ProjectUnit.Info('Файл не существует.Открываем пустой проект',mtWarning)
            then ProjectUnit.NewProject(Sender);
        end;
        result:=false;
      end;
    end else result:=false;
  Except
    result:=false;
  end;
end;

//проверка на изменении данных в текуший проект
Function EventSaveProject(NameProject:TFileName):boolean;
var NameTempSave,s:TFileName;
begin
  result:=true;
  if not ( (lowercase(NameProject)=lowercase('Новый Проект'))
      or (lowercase(NameProject)=lowercase('New Project')) )
  then
    s:=NameProject
  else
    case TypeUnit.SChooseLanguage of
      1:s:=(ExtractFilePath(Application.ExeName ) +
        'ConfigurationFile\New Project.bsc');
      0:s:=(ExtractFilePath(Application.ExeName ) +
        'Конфигурационные файлы\Новый Проект.bsc');
    end;
  try
    NameTempSave:=changeFileExt(s,'_temp.bsc');
    //создание временный файл для проверка  изменении данных
    if ProjectUnit.SaveInFile(NameTempSave)
      // сравнение файлов
    then result:=not (CompareFiles(s, NameTempSave))
  finally
    SysUtils.DeleteFile(NameTempSave);
  end;
end;

//обрабочик сохранения изначального проекта
Function SaveDefaultProject:boolean;
begin
  case TypeUnit.SChooseLanguage of
    1: ProjectUnit.SaveInFile(ExtractFilePath( Application.ExeName )
      +'ConfigurationFile\New Project.bsc');
    0: ProjectUnit.SaveInFile(ExtractFilePath( Application.ExeName )
      +'Конфигурационные файлы\Новый Проект.bsc');
  end;
  result:=True;
end;

//обрабочик удаление файла изначального проекта
Function DeleteDefaultProject:boolean;
begin
  case TypeUnit.SChooseLanguage of
    1:
      if SysUtils.FileExists(ExtractFilePath( Application.ExeName )
        +'ConfigurationFile\New Project.bsc')
      then  SysUtils.DeleteFile(ExtractFilePath( Application.ExeName )
        +'ConfigurationFile\New Project.bsc');
    0:
      if SysUtils.FileExists(ExtractFilePath( Application.ExeName )
        +'Конфигурационные файлы\Новый Проект.bsc')
      then  SysUtils.DeleteFile(ExtractFilePath( Application.ExeName )
       +'Конфигурационные файлы\Новый Проект.bsc');
  end;
  result:=True;
end;

//****************Конец Работа С Проектом  ******************************///

// Диамическое диалоговое окно для выбора
function PMsgDlg(Msg,MsgCaption:string; DlgType: TMsgDlgType; NumButtons:Integer):integer;
var  i,j:integer;
    dlg:TForm;
    s:string;
begin
  result:=-1;
  case NumButtons of
    2:dlg:=CreateMessageDialog(Msg, DlgType, [mbYes,mbNo]);
    1:dlg:=CreateMessageDialog(Msg, DlgType, [mbOK])
    else exit;
  end;
  with dlg do
  try
    for i:=0 to ComponentCount-1 do
    if Components[i] is TButton then
    begin
      for j := 0 to 11 do
      begin
        s:= TButton(Components[i]).Caption;
        if (LowerCase(TButton(Components[i]).Caption) = LowerCase(LanguageUnit.DialogButton[j].French))
          or (LowerCase(TButton(Components[i]).Caption) = LowerCase(LanguageUnit.DialogButton[j].English))
        then
        begin
          case TypeUnit.SChooseLanguage of
            1:TButton(Components[i]).Caption := LanguageUnit.DialogButton[j].English;
            0:TButton(Components[i]).Caption :=LanguageUnit.DialogButton[j].Russian
          end;
          break;
        end else continue;
      end;
    end;

    Caption:=MsgCaption;
    Position := poMainFormCenter;
    result:=ShowModal;
  finally
    Free;
  end;
end;

//обрабочик выбора
function Choice(const Msg:string;TypeInfo:TMsgDlgType): Boolean;
var s:String;
begin
  case TypeInfo of
    MtConfirmation:
        case TypeUnit.SChooseLanguage of
          1:s:='Confirmation!';
          0:s:='Подверждение!'
        end;
    MtWarning:
        case TypeUnit.SChooseLanguage of
          1:s:='Caution!';
          0:s:='Внимание!'
        end;
    MtInformation:
        case TypeUnit.SChooseLanguage of
          1:s:='Information!';
          0:s:='Сообщение!'
        end;
  end;
  //выываем диалоговое окно для выбора
  if PMsgDlg(Msg,s,TypeInfo,2) = idYes
  then Result:=True else Result:=False;

end;

//обрабочик отображения придупреждения и собщения
function Info(const Msg:string;TypeInfo:TMsgDlgType): Boolean;
var s:string;
begin
  case TypeInfo of
    MtConfirmation:
        case TypeUnit.SChooseLanguage of
          1:s:='Confirmation!';
          0:s:='Подверждение!'
        end;
    MtWarning:
        case TypeUnit.SChooseLanguage of
          1:s:='Caution!';
          0:s:='Внимание!'
        end;
    MtInformation:
        case TypeUnit.SChooseLanguage of
          1:s:='Information!';
          0:s:='Сообщение!'
        end;
  end;
  PMsgDlg(Msg,s,TypeInfo,1);
  result:=true;
end;
end.
