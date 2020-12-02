unit MainUnit;

interface

uses  //используемые библиотеки
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, TeEngine, ExtCtrls, TeeProcs, Chart, Series, Grids, StdCtrls,
  TypeUnit,BcParser,XPMan,ShellAPI,AppEvnts,Math, VclTee.TeeGDIPlus;

  ///****bcParser есть синтаксический анализатор для расчёта аналитических функциии
  //объявление типов
type
  TMainForm = class(TForm)   // тип главного окна
    MainMenuProject: TMainMenu;
    Project: TMenuItem;
    NewProject: TMenuItem;
    LoadProject: TMenuItem;
    SaveProject: TMenuItem;
    SaveProjectAs: TMenuItem;
    ExitProject: TMenuItem;
    Setting: TMenuItem;
    Report: TMenuItem;
    Help: TMenuItem;
    EnterData: TMenuItem;
    ExitData: TMenuItem;
    VerificationConstruction: TMenuItem;
    ZoomAndScale: TMenuItem;
    Chart: TChart;
    Series1: TLineSeries;
    StringGrid1: TStringGrid;
    PanelEnterData: TGroupBox;
    ViewTranslateFunction: TButton;
    ActiveEnterDataWithPoints: TCheckBox;
    ActiveEnterDataWithFunction: TCheckBox;
    TranslateFunction: TLabeledEdit;
    PanelEnterDataWithPoints: TGroupBox;
    AddPoint: TButton;
    AbscissX: TLabeledEdit;
    OrdinateY: TLabeledEdit;
    PointChoosen: TCheckBox;
    ModifyPoint: TButton;
    RemovePoint: TButton;
    PanelEnterDataWithFunction: TGroupBox;
    IntervalA: TLabeledEdit;
    TraceUsersAnalytiqueFunction: TButton;
    ClearUsersAnalytiqueFunction: TButton;
    IntervalB: TLabeledEdit;
    UsersAnalytiqueFunction: TLabeledEdit;
    PanelVerificationConstruction: TGroupBox;
    PanelExitData: TGroupBox;
    PanelZoom: TGroupBox;
    PanelInformation: TGroupBox;
    MemoInformation: TMemo;
    PZoom: TRadioGroup;
    LaGrange: TGroupBox;
    GeneralizingLagrange: TGroupBox;
    CheckBoxLagrangeFunction: TCheckBox;
    CheckBoxErrorLagrangeFunction: TCheckBox;
    CheckBoxGeneralizingFunction: TCheckBox;
    CheckBoxErrorGeneralizingFunction: TCheckBox;
    ClearControlFunction: TButton;
    TraceControlFunction: TButton;
    ControlFunction: TLabeledEdit;
    GenerateFunction: TButton;
    PanelViewFormule: TGroupBox;
    CheckBoxViewLagrangeFunction: TCheckBox;
    CheckBoxViewGeneralizingFunction: TCheckBox;
    ResetZoomAndScale: TButton;
    Series2: TPointSeries;
    Series3: TPointSeries;
    Series4: TLineSeries;
    Series5: TLineSeries;
    Series6: TLineSeries;
    Series7: TLineSeries;
    Series8: TLineSeries;
    Series9: TPointSeries;
    Series10: TPointSeries;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ClearAllData: TButton;
    ClearAllPoints: TButton;
    SetValueInsetting: TButton;
    DrawAxisX: TCheckBox;
    DrawAxisY: TCheckBox;
    DistinctionWithResize: TCheckBox;
    SendToReport: TMenuItem;
    SaveDocument: TSaveDialog;
    HideFunction: TComboBox;
    ViewNode: TCheckBox;
    ReportResize: TButton;
    LagrangeAccuracy: TLabeledEdit;
    GeneralisedAccuracy: TLabeledEdit;
    HistoryTranslateFunction: TListBox;
    HistoryPanel: TGroupBox;
    ClearHistoryTranslate: TButton;
    DeleteChoosedHistory: TButton;
    ActiveSelectMultiple: TCheckBox;
    ActiveMovingAddPoint: TCheckBox;
    ActiveEnterDatawithMouse: TCheckBox;
    ResizeChart: TButton;
    CheckBoxViewGeneralizingFunctionII: TCheckBox;
    GeneralizingLagrangeI: TGroupBox;
    GeneralizingLagrangeII: TGroupBox;
    GeneralisedAccuracyII: TLabeledEdit;
    CheckboxErrorGeneralizingFunctionII: TCheckBox;
    CheckboxGeneralizingFunctionII: TCheckBox;
    Series14: TLineSeries;
    Series15: TLineSeries;
    Series11: TLineSeries;
    Series12: TLineSeries;
    Series13: TPointSeries;
    AddPointWithFunction: TButton;
    Delta: TLabeledEdit;
    Plus: TButton;
    Minus: TButton;
    DeplacePointEnterData: TGroupBox;
    Timetraced: TLabel;
    NameLabel: TLabel;
    //обрабочик при создании главного окна
    procedure FormCreate(Sender: TObject);
    //обрабочик ограничения ввода в редактируемых полях
    procedure UsersAnalytiqueFunctionKeyPress(Sender: TObject; var Key: Char);
    //обрабочик при двойном нажатии в таблице точек
    procedure StringGrid1DblClick(Sender: TObject);
    //обрабочик ограничения ввода в таблице точек
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
     //обрабочик при закрытия главного окна
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
     //обрабочик создание нового проекта
    procedure NewProjectClick(Sender: TObject);
     //обрабочик загрузка проекта
    procedure LoadProjectClick(Sender: TObject);
    //обрабочик сохранения проекта
    procedure SaveProjectClick(Sender: TObject);
    //обрабочик сохранения проекта как
    procedure SaveProjectAsClick(Sender: TObject);
    //обрабочик выхода из проекта
    procedure ExitProjectClick(Sender: TObject);
    //обрабочик подключение и отлючения панели ввода данных
    procedure EnterDataClick(Sender: TObject);
    //обрабочик подключение и отлючения панели вывода данных
    procedure ExitDataClick(Sender: TObject);
    //обрабочик подключение и отлючения панели проверка построения
    procedure VerificationConstructionClick(Sender: TObject);
    //обрабочик подключение и отлючения панели маштабирования
    procedure ZoomAndScaleClick(Sender: TObject);
    //обрабочик создания итогового отчёта
    procedure ReportClick(Sender: TObject);
    //обрабочик отображения окно настройки
    procedure SettingClick(Sender: TObject);
    //обрабочик подключение и отлючения панели ввода данных с заданием координатов
    procedure ActiveEnterDataWithPointsClick(Sender: TObject);
    //обрабочик подключение и отлючения панели ввода данных функции
    procedure ActiveEnterDataWithFunctionClick(Sender: TObject);
    //обрабочик построения и удаление полином Лагранж
    procedure CheckBoxLagrangeFunctionClick(Sender: TObject);
    //обрабочик построения и удаление функции ошибки Лагранж
    procedure CheckBoxErrorLagrangeFunctionClick(Sender: TObject);
    //обрабочик построения и удаление первого вида обобщённого полином Лагранж
    procedure CheckBoxGeneralizingFunctionClick(Sender: TObject);
    //обрабочик построения и удаление функции ошибки первого вида обобщённого полином Лагранж
    procedure CheckBoxErrorGeneralizingFunctionClick(Sender: TObject);
    //обрабочик построения и удаление формул первого вида обобщённого полином Лагранж
    procedure CheckBoxViewGeneralizingFunctionClick(Sender: TObject);
    //обрабочик панели маштабирования
    procedure PZoomClick(Sender: TObject);
    //обрабочик  сьрос масштабирование
    procedure ResetZoomAndScaleClick(Sender: TObject);
    //обрабочик добавление узла
    procedure AddPointClick(Sender: TObject);
    //обрабочик рисования исходной нелинейности
    procedure TraceUsersAnalytiqueFunctionClick(Sender: TObject);
    //обрабочик удаление узла
    procedure RemovePointClick(Sender: TObject);
    //обрабочик выбора ячейки
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    //обрабочик установуки значении в таблице узлов
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    //обрабочик удаления исходной нелинейности
    procedure ClearUsersAnalytiqueFunctionClick(Sender: TObject);
    //обрабочик рисование проверочной функции
    procedure TraceControlFunctionClick(Sender: TObject);
    //обрабочик нажатии на графики функции
    procedure ChartClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    //обрабочик нажатиии на экран
    procedure ChartMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    //обрабочик движение мышки на экране
    procedure ChartMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    //обработчик при прокручивании колеса мышки вниз
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    //Обработчик при прокручивании колеса мышки вверх
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    //Обработчик просмотра структурообразующих функций
    procedure ViewTranslateFunctionClick(Sender: TObject);
    //Обработчик активации главного окна
    procedure FormActivate(Sender: TObject);
    //Обработчик удаление проверочной функции
    procedure ClearControlFunctionClick(Sender: TObject);
    //Обработчик удаления вс данные
    procedure ClearAllDataClick(Sender: TObject);
    //Обработчик удаления все узлов
    procedure ClearAllPointsClick(Sender: TObject);
    //Обработчик фиксации размера экрана
    procedure SetValueInsettingClick(Sender: TObject);
    //Обработчик генерации функции
    procedure GenerateFunctionClick(Sender: TObject);
    //Обработчик изменения узлы
    procedure ModifyPointClick(Sender: TObject);
    //Обработчик прокрутки на экране вывода функции
    procedure ChartScroll(Sender: TObject);
    //Обработчик рисования оси
    procedure DrawAxisXClick(Sender: TObject);
    //Обработчик изменения размера экрана под выделенны функций
    procedure DistinctionWithResizeClick(Sender: TObject);
    //Обработчик движение мышки на главном окне
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    //Обработчик создания отчёта текущего процесса моделирования
    procedure SendToReportClick(Sender: TObject);
    //Обработчик скрытия и показа выделенных функции
    procedure HideFunctionChange(Sender: TObject);
    //Обработчик простъмотра таблицы узлов
    procedure ViewNodeClick(Sender: TObject);
    //Обработчик регулирование экран графики при составлении отчёта
    procedure ReportResizeClick(Sender: TObject);
    //Обработчик очистки архива
    procedure ClearHistoryTranslateClick(Sender: TObject);
    //Обработчик при двойном нажатии на списоке архива
    procedure HistoryTranslateFunctionDblClick(Sender: TObject);
    //Обработчик удвление элемент из архива
    procedure DeleteChoosedHistoryClick(Sender: TObject);
    //Обработчик подключения и отключения режим несколкого выбора
    procedure ActiveSelectMultipleClick(Sender: TObject);
    //Обработчик сочетания клавиши
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    //Обработчик при отпуске мышки на экране графики
    procedure ChartMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    //Обработчик подулючения и отключения перемещения узлов
    procedure ActiveMovingAddPointClick(Sender: TObject);
    //Обработчик об возможности закрытие диалогового окна сохранения проекта
    procedure SaveDialogCanClose(Sender: TObject; var CanClose: Boolean);
     //Обработчик об возможности закрытие диалогового окна сохранения итогового отчёта
    procedure SaveDocumentCanClose(Sender: TObject; var CanClose: Boolean);
    //Обработчик подключения и отулючения вводв двнных мышкой
    procedure ActiveEnterDatawithMouseClick(Sender: TObject);
    //Обработчик регулирование оси графиков
    procedure ResizeChartClick(Sender: TObject);
    //Обработчик построения и удаления второго вида обобщённого полинома Лагранжа
    procedure CheckboxGeneralizingFunctionIIClick(Sender: TObject);
    //Обработчик построения и удаления функции ошибки второго вида обобщённого полинома Лагранжа
    procedure CheckboxErrorGeneralizingFunctionIIClick(Sender: TObject);
    //Обработчик запуска руководства оператора
    procedure HelpClick(Sender: TObject);
    //Обработчик добавление узла функции
    procedure AddPointWithFunctionClick(Sender: TObject);
    //Обработчик перемешения узла налево
    procedure MinusClick(Sender: TObject);
    //Обработчик перемещение узла направо
    procedure PlusClick(Sender: TObject);
    procedure ChartClickLegend(Sender: TCustomChart; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Скрытие объявления }
    //Обработчик отображения справочной системы
    procedure HelpMessage(var msg:TWMHelp); message WM_HELP;
  public
    { пупличные объявления}
    //Обработчики события при динамическом выделении графиков
    procedure CheckDistinctionSeriesClick(Sender: TObject);
    procedure CheckDistinctionClick(Sender: TObject);
  end;

  //Объявление глобальные переменные
var
  MainForm: TMainForm;       //перемен главного окна


implementation

{$R *.dfm}

//используемые модулы
uses SettingUnit,ReportUnit,
     ProjectUnit,EnterDataUnit,ExitDataUnit,LanguageUnit,
  ShowTranslateFunctionUnit,DistinctionUnit, GenerateFunctionUnit, HistoryUnit,
  HelpUnit;

  //объявление глобальные переменные
var JustAdd,GoToAdd:boolean;
    ValPoint:TypeUnit.TUserFunc;
    ValPointPos:integer;

//******** правильный оформиления и ограничения формы *******///

//******** правильный оформиления и ограничения в полах *******///
procedure TMainForm.UsersAnalytiqueFunctionKeyPress(Sender: TObject;
  var Key: Char);
begin
  //verification panel
  if MainForm.ControlFunction.Focused then
  begin
    if Key=#13 then
    begin
      MainForm.TraceControlFunction.Click;
      MainForm.ClearControlFunction.SetFocus;
    end;
    If not (Key in['a'..'z','0'..'9','.',',','-','^',
                  '*','+','/','(',')',#08])
    then key:=#0;
  end;

  if MainForm.ClearControlFunction.Focused then
    if key=#13 then
    begin
      MainForm.ControlFunction.Clear;
      MainForm.ControlFunction.SetFocus;
    end;


  //вводные данные
  if MainForm.TranslateFunction.Focused  then
  begin
    if Key=#13 then
    begin
      if MainForm.CheckBoxGeneralizingFunction.Checked
      then
        begin
          ExitDataUnit.TraceGeneralizingLagrange;
          TypeUnit.LDT:=Length(DateTimeToStr(now)+' ===> ');
          if MainForm.TranslateFunction.Text<>''
          then HistoryUnit.AddTranslateHistory(DateTimeToStr(now)+' ===> '+MainForm.TranslateFunction.Text);
        end;
      if MainForm.CheckBoxErrorGeneralizingFunction.Checked
      then ExitDataUnit.TraceErrorGeneralizing(MainForm.TranslateFunction.Text,UsersFunction,
            NodeInterPolationGeneral);
      if MainForm.CheckBoxGeneralizingFunctionII.Checked
      then
        begin
          ExitDataUnit.TraceGeneralizingLagrangeII;
          TypeUnit.LDT:=Length(DateTimeToStr(now)+' ===> ');
          if MainForm.TranslateFunction.Text<>''
          then HistoryUnit.AddTranslateHistory(DateTimeToStr(now)+' ===> '+MainForm.TranslateFunction.Text);
        end;
      if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked
      then ExitDataUnit.TraceErrorGeneralizingII(MainForm.TranslateFunction.Text,UsersFunction,
            NodeInterPolationGeneral);
      ExitDataUnit.ViewFormules;
      MainForm.ViewTranslateFunction.SetFocus;
    end;
    If not (Key in['a'..'z','0'..'9','.',',','-','^',
                  '*','+','/','(',')',#08])
    then key:=#0;
  end;

  //вводные данные функции
  if MainForm.UsersAnalytiqueFunction.Focused  then
  begin
    if Key=#13 then
    begin
      MainForm.TraceUsersAnalytiqueFunction.Click;
      MainForm.TraceUsersAnalytiqueFunction.SetFocus;
    end;
    If not (Key in['a'..'z','0'..'9','.',',','-','^',
                  '*','+','/','(',')',#08])
    then key:=#0;
  end;
  if MainForm.IntervalA.Focused then
  begin
    if Key=#13 then
    begin
       MainForm.IntervalB.SetFocus;
    end;
    If not (Key in['0'..'9','.','-',#08]) then key:=#0;
  end;
  if MainForm.IntervalB.Focused then
  begin
    if Key=#13 then
    begin
       MainForm.UsersAnalytiqueFunction.SetFocus;
    end;
    If not (Key in['0'..'9','.','-',#08]) then key:=#0;
  end;
  if MainForm.Delta.Focused then
  begin
    if Key=#13 then
    begin
       MainForm.Plus.SetFocus;
    end;
    If not (Key in['0'..'9','.',#08]) then key:=#0;
  end;

  //вводные данные координатов

  if MainForm.AbscissX.Focused then
  begin
    if Key=#13 then
    begin
       MainForm.OrdinateY.SetFocus;
    end;
    If not (Key in['0'..'9','.','-',#08]) then key:=#0;
  end;
  if  MainForm.OrdinateY.Focused then
  begin
    if Key=#13 then
    begin
        MainForm.PointChoosen.SetFocus;
    end;
    If not (Key in['0'..'9','.','-',#08]) then key:=#0;
  end;
  if MainForm.PointChoosen.Focused then
  begin
    if Key=#13 then
    begin
      MainForm.PointChoosen.Checked:=True;
      MainForm.AddPoint.SetFocus;
    end;
  end;
  if MainForm.AddPoint.Focused then
  begin
    if Key=#13 then
    begin
      MainForm.AbscissX.SetFocus;
    end;
  end;

  if MainForm.RemovePoint.Focused then
    if Key=#13 then
    begin
      MainForm.AbscissX.Clear;
      MainForm.OrdinateY.Clear;
      MainForm.PointChoosen.Checked:=false;
      MainForm.AbscissX.SetFocus;
    end;

  //выделения
  if MainForm.HideFunction.Focused then key:=#0;

end;

//******** правильный оформиления и ограничения stringgrid *******///
procedure TMainForm.StringGrid1DblClick(Sender: TObject);
begin
  if LowerCase(StringGrid1.Cells[StringGrid1.Col,3]) = 'no'
  then
  begin
    //если щелкиваем два раза то изменяем условие "no" в "ок"
    StringGrid1.Cells[StringGrid1.Col,3] := 'Ok';
    MainForm.PointChoosen.Checked:=True;
  end
  else
    if LowerCase(StringGrid1.Cells[StringGrid1.Col,3]) = 'ok'
    then
    begin
      //если щелкиваем два раза то изменяем условие ок в no
      StringGrid1.Cells[StringGrid1.Col,3] := 'No';
      MainForm.PointChoosen.Checked:=False;
    end ;
  //установляем изменения и перерисования график для построения точек
  restorePointAfterLoadFile(Series2,Series3,StringGrid1,UsersFunction);
//переруем функцию Лагранжа
  if MainForm.CheckBoxLagrangeFunction.Checked then
  begin
    Series1.Clear; MainForm.CheckBoxLagrangeFunctionClick(sender);
  end;
  //переруем обобщенную функцию Лагранжа
  if MainForm.CheckBoxGeneralizingFunction.Checked then
  begin
    Series5.Clear; MainForm.CheckBoxGeneralizingFunctionClick(sender);
  end;
  //переруем обобщенную функцию Лагранжа  II
  if MainForm.CheckBoxGeneralizingFunctionII.Checked then
  begin
    Series6.Clear; MainForm.CheckBoxGeneralizingFunctionIIClick(sender);
  end;
  //переруем ошибочную функцию Лагранжа
  if MainForm.CheckBoxErrorLagrangeFunction.Checked then
  begin
    Series7.Clear; Series9.Clear;;MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
  end;
  //переруем ошибочную обобщенную функцию Лагранжа
  if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
  begin
    Series8.Clear; Series10.Clear;;MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
  end;
  //переруем ошибочную обобщенную функцию Лагранжа
  if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked then
  begin
    Series12.Clear; Series13.Clear;;MainForm.CheckBoxErrorGeneralizingFunctionIIClick(sender);
  end;
  ExitDataUnit.ViewFormules;
end;

procedure TMainForm.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  //оформеления ограничения при изменения данных сразу в StringGrid
  if key=#13 then
  begin
    //переруем функцию Лагранжа
    if MainForm.CheckBoxLagrangeFunction.Checked then
    begin
      Series1.Clear; MainForm.CheckBoxLagrangeFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа
    if MainForm.CheckBoxGeneralizingFunction.Checked then
    begin
      Series5.Clear; MainForm.CheckBoxGeneralizingFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа  II
    if MainForm.CheckBoxGeneralizingFunctionII.Checked then
    begin
      Series6.Clear; MainForm.CheckBoxGeneralizingFunctionIIClick(sender);
    end;
    //переруем ошибочную функцию Лагранжа
    if MainForm.CheckBoxErrorLagrangeFunction.Checked then
    begin
      Series7.Clear; Series9.Clear;;MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
    begin
      Series8.Clear; Series10.Clear;;MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked then
    begin
      Series12.Clear; Series13.Clear;;MainForm.CheckBoxErrorGeneralizingFunctionIIClick(sender);
    end;
    ExitDataUnit.ViewFormules;
  end;
  If not (Key in['0'..'9','.','-','o','k','n','N','O','K',#08]) then key:=#0;
end;

//выборка ячейка в таблице
procedure TMainForm.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if (ACol>0) then   //условия выборка если стольбец больше 0
  begin
    //зарегистрируем выбранный ячейк
    SelectedCol:=ACol;
    SelectedRow:=ARow;
    MainForm.AbscissX.Text:=StringGrid1.Cells[ACol,1];
    MainForm.OrdinateY.Text:=StringGrid1.Cells[ACol,2];
    if LowerCase(StringGrid1.Cells[ACol,3])='ok' then MainForm.PointChoosen.Checked:=True
    else MainForm.PointChoosen.Checked:=False;
    if ((ARow=1) or (ARow=2)) then
      StringGrid1.Options:=StringGrid1.Options+[goEditing] //активизируем модификации таблица точек
    else
    StringGrid1.Options:=StringGrid1.Options-[goEditing]; //деактивизируем модификации таблица точек
    MainForm.AbscissX.SetFocus;
  end
  else
  begin
    SelectedCol:=-1;
    SelectedRow:=-1;
    CanSelect:=False;// запретим возможность выборка ячейка
    //деактивизируем модификации таблица точек
    StringGrid1.Options:=StringGrid1.Options-[goEditing];
    MainForm.AbscissX.Clear;
    MainForm.OrdinateY.Clear;
    MainForm.PointChoosen.Checked:=False;
  end;
end;


//Установка модификации
procedure TMainForm.StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
var Val:TUserFunc;
    P,i:Integer;
begin
  if (Value<>'') and (value<>'-')  then
  begin
    try
      //попытаем установить значение
      Val.x:=StrToFloat(MainForm.AbscissX.Text);
      Val.y:=StrToFloat(MainForm.OrdinateY.Text);
      Val.b:=MainForm.PointChoosen.Checked;
    except
      Exit;
    end;
    Search(Val,UsersFunction,P);//ишим точку в таблице точек
    if p<>-1 then
    begin
      //если есть точку то
      try
        //попытаем установить значение из StringGrid
        UsersFunction.value[p].x:=StrToFloat(StringGrid1.Cells[ACol,1]);
        UsersFunction.value[p].y:=StrToFloat(StringGrid1.Cells[ACol,2]);
        if LowerCase(StringGrid1.Cells[ACol,3])='ok' then UsersFunction.value[p].b:=True
        else  UsersFunction.value[p].b:=False;
      except
        Exit;
      end;
      MainForm.AbscissX.Text:=StringGrid1.Cells[ACol,1];
      MainForm.OrdinateY.Text:=StringGrid1.Cells[ACol,2];
      if LowerCase(StringGrid1.Cells[ACol,3])='ok' then MainForm.PointChoosen.Checked:=True
      else MainForm.PointChoosen.Checked:=False;
      //перерисуем графики именно выбраные точки и не выбраные точки
      Series2.Clear;
      Series3.Clear;
      for i:=0 to UsersFunction.Quantity do
        if UsersFunction.value[i].b then
        begin
          //график выбранных точек
          Series2.AddXY(UsersFunction.value[i].x,
                      UsersFunction.value[i].y);
        end
        else
        begin
          //график  не выбранных  точек
          Series3.AddXY(UsersFunction.value[i].x,
                      UsersFunction.value[i].y);
        end;
    end;
  end;
end;


procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
  b:boolean;
begin
  KeyPreview := True;
  HelpFile:= HelpUnit.HelpFileName;

  //активизируем русский язык
  TypeUnit.SChooseLanguage:=0;
  TypeUnit.SRoundValue:=4;

  if DistinctionUnit.CreatePanelDistinction
  then DistinctionUnit.CreateCheckDistinction;
  Mainform.EnterData.Checked:=false;
  MainForm.ExitData.Checked:=False;
  MainForm.ZoomAndScale.Checked:=false;
  MainForm.VerificationConstruction.Checked:=false;
  for I := 0 to MainForm.Chart.SeriesCount - 1 do
    MainForm.Chart.Series[i].Active:=false;
  DecimalSeparator:='.';
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //сочетание клавиш проекта
  //сочетание отрытия нового проекта
  if (ssCtrl in Shift) and (Key in [Ord('N'), Ord('n')]) then
  begin
     MainForm.NewProjectClick(Sender);
     exit;
  end;

  //сочетание загрузки проекта
  if (ssCtrl in Shift) and (Key in [Ord('O'), Ord('o')]) then
  begin
     MainForm.LoadProjectClick(Sender);
     exit;
  end;

  //сочетание сохранения проекта как
  if ((ssCtrl in Shift) and (ssShift in Shift)) and (Key in [Ord('S'), Ord('S')]) then
  begin
     MainForm.SaveProjectAsClick(Sender);
     exit;
  end;

  //сочетание сохранения проекта
  if (ssCtrl in Shift) and (Key in [Ord('S'), Ord('s')]) then
  begin
     MainForm.SaveProjectClick(Sender);
     exit;
  end;

  //сочетание создание итоговый отчёт
  if ((ssCtrl in Shift) and (ssShift in Shift)) and (Key in [Ord('R'), Ord('r')]) then
  begin
     MainForm.ReportClick(Sender);
     exit;
  end;

  //сочетание создание времменый отчёт
  if (ssCtrl in Shift) and (Key in [Ord('R'), Ord('r')]) then
  begin
     MainForm.SendToReportClick(Sender);
     exit;
  end;

  //сочетание настройки
  if Key=VK_F7 then
  begin
     MainForm.SettingClick(Sender);
     exit;
  end;

  // сочетание перемещения точки по функции
  if (Key=VK_LEFT) and (TypeUnit.SelectedCol<>-1) then
  begin
     MainUnit.MainForm.MinusClick(Sender);
     exit;
  end;

  if (Key=VK_RIGHT) and (TypeUnit.SelectedCol<>-1) then
  begin
     MainUnit.MainForm.PlusClick(Sender);
     exit;
  end;

end;

//обрабочик активации главного окна
procedure TMainForm.FormActivate(Sender: TObject);
begin

  case TypeUnit.SChooseLanguage of
    1: MainForm.OpenDialog.FileName:='New Project';
    0: MainForm.OpenDialog.FileName:='Новый Проект';
  end;
  // установим имя и путь проекта
  TypeUnit.linkProject:=MainForm.OpenDialog.FileName;
  //обновление язык интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex]);
  //инициализируем  открытие и сохранение диалог
  ProjectUnit.InitDialogs;

  SettingUnit.SettingForm.DatePickerFrom.DateTime:=Now;
  SettingUnit.SettingForm.TimePickerFrom.DateTime:=Now;
  SettingUnit.SettingForm.DatePickerTo.DateTime:=Now;
  SettingUnit.SettingForm.TimePickerTo.DateTime:=Now;

  SettingUnit.SettingForm.RoundValueChange(Sender);
  MainForm.HideFunction.ItemIndex:=0;
  
  ResizeAxis(MainUnit.MainForm.Chart);
  MainForm.DrawAxisX.Checked:=True;
  MainForm.DrawAxisY.Checked:=True;
  MainForm.DrawAxisXClick(sender);

  MainForm.EnterData.Click;
  MainForm.ActiveEnterDataWithPoints.Checked:=true;
  MainForm.ActiveEnterDataWithPointsClick(Sender);
  MainForm.ActiveEnterDataWithFunction.Checked:=true;
  MainForm.ActiveEnterDataWithFunctionClick(Sender);
  MainForm.ActiveEnterDatawithMouse.Checked:=true;
  MainForm.ActiveEnterDatawithMouseClick(Sender);
  MainForm.VerificationConstruction.Click;
  MainForm.ExitData.Click;
  MainForm.ZoomAndScale.Click;

  MainForm.Chart.Enabled:=false;
  //создаем проект
  ProjectUnit.NewProject(sender);
  //сохраняем проект по умолчаню
  ProjectUnit.SaveDefaultProject;
  //установка контект для отображения спраавочной системы по компонентам
  HelpUnit.setHelpContext;
end;

//обрабочик закрытии окна
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Would you Exit Project?';
    0:s:='Вы действительно хотите ли выйти из проекта?';
  end;
  if  not Choice(s,MtWarning) then  Abort // отменяем закрытие окна
  else
  begin
    case TypeUnit.SChooseLanguage of
      1:s:='Save Actual Project?';
      0:s:='Сохранить текущий проект?';
    end;
    //сохранения если пользователь желает и если необходимо сохранить проект///
    if  (EventSaveProject(MainForm.OpenDialog.FileName)
        and ProjectUnit.Choice(s,MtConfirmation))
    then
    begin
      case TypeUnit.SChooseLanguage of
        1:s:='Project Saved.';
        0:s:='Проект сохранён.';
      end;
      //сохранить файл
      if ProjectUnit.SaveProject(Sender) then ProjectUnit.Info(S,MtInformation);
    end;
    //удаления созданных динамических компонентов
    DistinctionUnit.DestroyCheckDistinction;
    //удаление созданный файл для сохранения по умолчаню
    ProjectUnit.DeleteDefaultProject;
    DecimalSeparator:=',';
    //отключение нажатия на сочетании клавиш
    KeyPreview := False;
  end;
end;

//обрабочик создания нового проекта
procedure TMainForm.NewProjectClick(Sender: TObject);
var s,s1:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s1:='Would you want built new project?';
    0:s1:='Вы действительно ли хотите создать новый проект ?';
  end;
  //сохранения если пользователь желает///
  if  EventSaveProject(MainForm.OpenDialog.FileName)
    and (not ProjectUnit.Choice(s1,MtWarning))
  then  Abort; //отменяем создание
  //создание проект
  if ProjectUnit.CreateNewProject(Sender)
  then
    begin
      //сохраняем проект по умочаню
      ProjectUnit.SaveDefaultProject;
      case TypeUnit.SChooseLanguage of
        1:s:='New Project Created.';
        0:s:='Новый Проект создан.';
      end;
      //отображение информации об успешном создании проекта
      ProjectUnit.Info(S,MtInformation);
    end;
end;

//загрузка файла
procedure TMainForm.LoadProjectClick(Sender: TObject);
var s,s1:string;
begin
  if ProjectUnit.LoadProject(Sender)
  then
  begin
    case TypeUnit.SChooseLanguage of
      1:s:='Project Loaded.';
      0:s:='Проект Загружен.';
    end;
    //отображение информации
    ProjectUnit.Info(S,MtInformation);
    //инициализации диалоговых окон
    ProjectUnit.InitDialogs;
  end;
end;

//Сохранить в файле
procedure TMainForm.SaveProjectClick(Sender: TObject);
var s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Project Saved.';
    0:s:='Проект сохранён.';
  end;
  if ProjectUnit.SaveProject(Sender) //сохраняем
  then ProjectUnit.Info(S,MtInformation);
end;


procedure TMainForm.SaveDialogCanClose(Sender: TObject; var CanClose: Boolean);
var s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Replace Existing File?';
    0:s:='Заменить существующий файл?';
  end;
  if FileExists(SaveDialog.FileName) //если файл существует
  then
  begin
    if ProjectUnit.Choice(s,mtWarning) //выбор пользователя
    then
    begin
      //удаление файла
      DeleteFile(SaveDialog.FileName);
      //можно закрыть диалоговое окно
      CanClose:=true;
    end
    else CanClose:=False; //нельзя закрыть диалоговое окно
  end
  else CanClose:=true; //можно закрыть диалоговое окно
end;

procedure TMainForm.SaveDocumentCanClose(Sender: TObject;
  var CanClose: Boolean);
var s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Replace Existing File?';
    0:s:='Заменить существующий файл?';
  end;
  if FileExists(SaveDocument.FileName) //если файл существует
  then
  begin
    if ProjectUnit.Choice(s,mtWarning) //выбор пользователя
    then
    begin
      //удаление файла
      DeleteFile(SaveDocument.FileName);
      CanClose:=true;  //можно закрыть диалоговое окно
    end
    else CanClose:=False;//нельзя закрыть диалоговое окно
  end
  else CanClose:=true; //можно закрыть диалоговое окно
end;

//сохранить как
procedure TMainForm.SaveProjectAsClick(Sender: TObject);
var s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Project Saved.';
    0:s:='Проект сохранён.';
  end;
  if ProjectUnit.SaveProjectAs(Sender) //сохраняем с новым имением
  then ProjectUnit.Info(S,MtInformation);
end;

//выход из программы
procedure TMainForm.ExitProjectClick(Sender: TObject);
var s:string;
begin
  //закрываем
  MainForm.Close;
end;

//обрабочик подключения и отключения панели ввода данных
procedure TMainForm.EnterDataClick(Sender: TObject);
var s1:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s1:='Would you Desactive Panel Enter Data?';
    0:s1:='Вы действительно ли отключить панель ввод данных ?';
  end;
  if not EnterData.Checked  then
  begin
    //активизации панел
    EnterData.Checked:=True;
    MainForm.PanelEnterData.Visible:=true;
    MainForm.HistoryPanel.Visible:=true;
  end
  else
  begin
    if ProjectUnit.Choice(S1,MtWarning)  // предупреждения и выбор пользователя
    then
    begin
      //дезактивизации панел
      EnterData.Checked:=False;
      MainForm.PanelEnterData.Visible:=False;
      EnterDataUnit.DesactiveEnterDataPanel(Sender);
      MainForm.HistoryPanel.Visible:=False;
    end
    else
    begin
      //активизации панел
      EnterData.Checked:=True;
    end;
  end;
  //обновление языка нтерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик подключения и отключения пали ввода данных функции
procedure TMainForm.ActiveEnterDataWithFunctionClick(Sender: TObject);
var s1:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s1:='Would you Desactive Panel Enter Data with Function?';
    0:s1:='Вы действительно ли деактивизировать ввод данных с заданием функции?';
  end;
  if ActiveEnterDataWithFunction.Checked  then
  begin
    //активизации панел
    MainForm.PanelEnterDataWithFunction.Visible:=true;
    EnterDataUnit.ActivePanelEnterData(Sender)
  end
  else
  begin
    if ProjectUnit.Choice(S1,MtWarning)//предупреждения и выбор пользователя
    then
    begin
      //дезактивизации панел
      MainForm.PanelEnterDataWithFunction.Visible:=False;
      ExitDataUnit.DeleteUserFunction(sender);
    end
    else
    begin
    //активизации панел
      MainForm.ActiveEnterDataWithFunction.Checked:=True;
    end;
  end;
end;

//обрабочик подключеня и отключения ввод данных с мышкой
procedure TMainForm.ActiveEnterDatawithMouseClick(Sender: TObject);
begin
  if MainForm.ActiveEnterDatawithMouse.Checked
  then
  begin
    MainForm.ActiveMovingAddPoint.Enabled:=true;
    MainForm.Chart.ScrollMouseButton:= mbMiddle;
  end
  else
  begin
    MainForm.ActiveMovingAddPoint.Enabled:=false;
    MainForm.Chart.ScrollMouseButton:= mbright
  end;
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//Процедуры проверки ввода данных через задания фунции
procedure TMainForm.TraceUsersAnalytiqueFunctionClick(Sender: TObject);
begin
  //рисуем исходной нелинейности
  if ExitDataUnit.TraceUserFunction then
  begin
    MainForm.Series4.Active:=true;

    //перерисуем полином Лагранжа
    if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked then
    begin
      Series1.Clear; MainForm.CheckBoxLagrangeFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа
    if MainForm.CheckBoxGeneralizingFunction.Checked then
    begin
      Series5.Clear; MainForm.CheckBoxGeneralizingFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа  II
    if MainForm.CheckboxGeneralizingFunctionII.Checked then
    begin
      Series6.Clear; MainForm.CheckBoxGeneralizingFunctionIIClick(sender);
    end;
    //переруем ошибочную функцию Лагранжа
    if MainForm.CheckBoxErrorLagrangeFunction.Checked then
    begin
      Series7.Clear; Series9.Clear;MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
    begin
      Series8.Clear; Series10.Clear;MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа II
    if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked then
    begin
      Series12.Clear; Series13.Clear;MainForm.CheckboxErrorGeneralizingFunctionIIClick(sender);
    end;
    //побновление формулы
    ExitDataUnit.ViewFormules;
    //установка временных оценок
    ExitDataUnit.SetAVGTimeTraced;
    //обновление выделенных функций
    MainForm.CheckDistinctionSeriesClick(Sender);
  end;
end;

//Удаление все данных в проекте
procedure TMainForm.ClearAllDataClick(Sender: TObject);
var i:integer;
    s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Would you want delete all data in the graphics?';
    0:s:='Вы действительно хотите ли сбросить экран ?';
  end;
  if  not Choice(s,MtWarning) then  Abort //отменяем действие
  else
  begin
    //удаляем проверочную функцию
    ExitDataUnit.DeleteControlFunction;
    //удаляем исходной нелинейности
    ExitDataUnit.DeleteUserFunction(sender);
    //удаляе все узлы
    EnterDataUnit.DeleteAllPoints;
    //очистим архив
    MainForm.HistoryTranslateFunction.Clear;
    //удаляем все графики
    for i:= 0 to MainForm.Chart.SeriesCount - 3 do  //-2 axis
      MainForm.Chart.series[i].Clear;
    TypeUnit.SelectedCol:=-1;
    //инициализируем формулы
    TypeUnit.TypeOriginalPolynomeLagrange:='';
    TypeUnit.TypeGeneralizedPolynomeLagrange:='';
    TypeUnit.TypeGeneralizedPolynomeLagrangeII:='';
    //инициализируем погрешности
    MainForm.LagrangeAccuracy.Text:='0';
    MainForm.GeneralisedAccuracy.Text:='0';
    //отчистим мемо
    MainForm.MemoInformation.Clear;
    MainForm.CheckBoxViewGeneralizingFunctionClick(sender);
    ///инициализируем панел масштабирование
    MainForm.PZoom.ItemIndex:=0;
    //очистим структурообразующую функцию.
    MainForm.TranslateFunction.Clear;

    MainUnit.MainForm.CheckDistinctionClick(Sender);
    //инициализауии временных оценок
    TypeUnit.TimeTracedF:=-1;
    //усановка временных оценок
    ExitDataUnit.SetAVGTimeTraced;
    //инициализируем зум
    Chart.Zoom.Allow:=False;
    Chart.UndoZoom;//сбросим маштабирования
  end;
end;

//Удаление все узлы
procedure TMainForm.ClearAllPointsClick(Sender: TObject);
var s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Would you want delete all Nodes?';
    0:s:='Вы действительно хотите ли сбросить все узлы ?';
  end;
  if (Series1.Active or Series2.Active) and (TypeUnit.UsersFunction.value<>nil)
      and Choice(s,MtWarning) and EnterDataUnit.DeleteAllPoints//удаление всех узлов
  then  TypeUnit.SelectedCol:=-1
  else Abort;//отменяем действие
  ExitDataUnit.ViewFormules;//обновление формулы
end;

//обрабочик удалание проверочной функции
procedure TMainForm.ClearControlFunctionClick(Sender: TObject);
var s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Do You Want delete the current control function';
    0:s:='Хотите ли вы удалить текушую проверочную функцию';
  end;
  if MainForm.series11.Active and ProjectUnit.Choice(s,MtWarning)
  then
  begin
    MainForm.series11.Active:=False;
    //удаляем функцию
    ExitDataUnit.DeleteControlFunction;
  end;
  //отчистка полей
  MainForm.ControlFunction.Clear;
end;

//очистка архив
procedure TMainForm.ClearHistoryTranslateClick(Sender: TObject);
var s,s1:string;
begin
  case TypeUnit.SChooseLanguage of
    1:
      begin
        s:='Do You Want delete all history data for Translate Function?';
        s1:='History deleted!';
      end;
    0:
      begin
        s:='Хотите ли вы удалить всю историю струкурообразующей функции?';
        s1:='История удалена!';
      end;
  end;
  if ProjectUnit.Choice(s,mtWarning) and HistoryUnit.ClearHistoryTranslate //удаляем архив
  then ProjectUnit.Info(s1,mtInformation)  //отображение информации ползователю
end;

//очистим пользовательскую функуию
procedure TMainForm.ClearUsersAnalytiqueFunctionClick(Sender: TObject);
var s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Do You Want delete the current user-defined function';
    0:s:='Хотите ли вы удалить текушую пользовательскую функцию';
  end;
  if MainForm.Series4.Active and ProjectUnit.Choice(s,MtWarning)
  then ExitDataUnit.DeleteUserFunction(sender);//удалем исходной нелинейности
end;

//обрабочик изменения размера экрана под выделенных функции
procedure TMainForm.DistinctionWithResizeClick(Sender: TObject);
begin
  if MainForm.DistinctionWithResize.Checked then ExitDataUnit.Autoresize
  else ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик рисования оси
procedure TMainForm.DrawAxisXClick(Sender: TObject);
begin
  MainForm.series14.Clear;
  MainForm.series14.Active:=false;
  MainForm.series14.Pen.Width:=TypeUnit.SPenWIdthNotDistincted;
  MainForm.Series15.Clear;
  MainForm.Series15.Active:=false;
  MainForm.Series15.Pen.Width:=TypeUnit.SPenWIdthNotDistincted;
  if DrawAxisX.Checked then
  begin
    //РИСУЕМ ОСЬ АБСЦИССА
    series14.AddXY(MainForm.Chart.BottomAxis.Minimum,0);
    series14.AddXY(0,0);
    series14.AddXY(MainForm.Chart.BottomAxis.Maximum,0);
    MainForm.series14.Active:=true;
  end;
  if DrawAxisY.Checked then
  begin
    //рисуем ось ордината
    Series15.AddXY(0,MainForm.Chart.LeftAxis.Minimum);
    Series15.AddXY(0,0);
    Series15.AddXY(0,MainForm.Chart.LeftAxis.Maximum);
    MainForm.Series15.Active:=true;
  end;
  //обновление выделенных функций
  MainForm.CheckDistinctionSeriesClick(sender);
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик подключения и отключения панели ввод данных с координатами
procedure TMainForm.ActiveEnterDataWithPointsClick(Sender: TObject);
var s1:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s1:='Would you Desactive Panel Enter Data with Points?';
    0:s1:='Вы действительно ли деактивизировать ввод данных с заданием координатов?';
  end;
  if ActiveEnterDataWithPoints.Checked  then
  begin
    MainForm.PanelEnterDataWithPoints.Visible:=true;
    EnterdataUnit.ActivePanelEnterData(sender);
  end
  else
  begin
    if ProjectUnit.Choice(S1,MtWarning)
    then
    begin
      MainForm.PanelEnterDataWithPoints.Visible:=False;
      EnterDataUnit.DesactivePanelPoints(sender);
    end
    else
    begin
      MainForm.ActiveEnterDataWithPoints.Checked:=True;
    end;

  end;
end;

procedure TMainForm.ActiveMovingAddPointClick(Sender: TObject);
begin
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

procedure TMainForm.ActiveSelectMultipleClick(Sender: TObject);
begin
  if ActiveSelectMultiple.Checked
  then  MainUnit.MainForm.HistoryTranslateFunction.MultiSelect := true
  else MainUnit.MainForm.HistoryTranslateFunction.MultiSelect := False;
  MainForm.HistoryTranslateFunction.ItemIndex:= MainForm.HistoryTranslateFunction.Items.Count-1;
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//Процедуры проверки ввод данных через задания координаты точка

//добавляем точку

procedure TMainForm.AddPointClick(Sender: TObject);
begin
  if EnterDataUnit.AddPoint then
  begin
    if not Series2.Active then Series2.Active:=true;
    if not Series3.Active then Series3.Active:=true;
    //переруем функцию Лагранжа
    if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked then
    begin
      Series1.Clear; MainForm.CheckBoxLagrangeFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа
    if MainForm.CheckBoxGeneralizingFunction.Checked then
    begin
      Series5.Clear; MainForm.CheckBoxGeneralizingFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа  II
    if MainForm.CheckboxGeneralizingFunctionII.Checked then
    begin
      Series6.Clear; MainForm.CheckBoxGeneralizingFunctionIIClick(sender);
    end;
    //переруем ошибочную функцию Лагранжа
    if MainForm.CheckBoxErrorLagrangeFunction.Checked then
    begin
      Series7.Clear; Series9.Clear;MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
    begin
      Series8.Clear; Series10.Clear;MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа II
    if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked then
    begin
      Series12.Clear; Series13.Clear;MainForm.CheckboxErrorGeneralizingFunctionIIClick(sender);
    end;

    ExitDataUnit.ViewFormules;
  end;
end;

//добавление точки с использование пользователькая функция
procedure TMainForm.AddPointWithFunctionClick(Sender: TObject);
begin

  if EnterDataUnit.AddPointUsingFunction then
  begin
    if not Series2.Active then Series2.Active:=true;
    if not Series3.Active then Series3.Active:=true;
    //переруем функцию Лагранжа
    if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked then
    begin
      Series1.Clear; MainForm.CheckBoxLagrangeFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа
    if MainForm.CheckBoxGeneralizingFunction.Checked then
    begin
      Series5.Clear; MainForm.CheckBoxGeneralizingFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа  II
    if MainForm.CheckboxGeneralizingFunctionII.Checked then
    begin
      Series6.Clear; MainForm.CheckBoxGeneralizingFunctionIIClick(sender);
    end;
    //переруем ошибочную функцию Лагранжа
    if MainForm.CheckBoxErrorLagrangeFunction.Checked then
    begin
      Series7.Clear; Series9.Clear;MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
    begin
      Series8.Clear; Series10.Clear;MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа II
    if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked then
    begin
      Series12.Clear; Series13.Clear;MainForm.CheckboxErrorGeneralizingFunctionIIClick(sender);
    end;

    ExitDataUnit.ViewFormules;
  end;
end;

procedure TMainForm.DeleteChoosedHistoryClick(Sender: TObject);
var s,s1:string;
begin
  case TypeUnit.SChooseLanguage of
    1:
      begin
        s:='Do You Want delete selected history data for Translate Function?';
        s1:='Selected History deleted!';
      end;
    0:
      begin
        s:='Хотите ли вы удалить выбранную(ые) струкурообразующую(ие) функцию(и) из истории?';
        s1:='Выбранная(ые) струкурообразующая(ие)  функция (и) удалена(ы)!';
      end;
  end;
  if ProjectUnit.Choice(s,mtWarning) and HistoryUnit.DeleteSelectedHistoryTranslate
  then ProjectUnit.Info(s1,mtInformation);
end;

//удаление точки
procedure TMainForm.RemovePointClick(Sender: TObject);
var s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Do You Want delete the current selected point';
    0:s:='Хотите ли вы удалить выбранную точку';
  end;
  if (Series1.Active or Series2.Active) and (TypeUnit.SelectedCol<>-1) and ProjectUnit.Choice(s,MtConfirmation) and EnterDataUnit.DeletePoint then
  begin
    TypeUnit.SelectedCol:=-1;
    if not (TypeUnit.UsersFunction.value<>nil) then
    begin
      Series1.Active:=False;
      Series2.Active:=False;
    end;
   //переруем функцию Лагранжа
    if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked then
    begin
      Series1.Clear; MainForm.CheckBoxLagrangeFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа
    if MainForm.CheckBoxGeneralizingFunction.Checked then
    begin
      Series5.Clear; MainForm.CheckBoxGeneralizingFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа  II
    if MainForm.CheckboxGeneralizingFunctionII.Checked then
    begin
      Series6.Clear; MainForm.CheckBoxGeneralizingFunctionIIClick(sender);
    end;
    //переруем ошибочную функцию Лагранжа
    if MainForm.CheckBoxErrorLagrangeFunction.Checked then
    begin
      Series7.Clear; Series9.Clear;MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
    begin
      Series8.Clear; Series10.Clear;MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа II
    if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked then
    begin
      Series12.Clear; Series13.Clear;MainForm.CheckboxErrorGeneralizingFunctionIIClick(sender);
    end;
    ExitDataUnit.ViewFormules;
  end;
end;

//*******************************График************************************////


procedure TMainForm.ChartClickLegend(Sender: TCustomChart; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 // showmessage(Chart.Series[Chart.Legend.Clicked(X,Y)].Title);
end;

procedure TMainForm.ChartClickSeries(Sender: TCustomChart; Series: TChartSeries;
  ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var k,m,v:Integer;
    Ux,Uy:Double;
    Ub:boolean;
begin
  if not MainForm.ActiveEnterDatawithMouse.Checked then  Exit;
  chart.LeftAxis.AutomaticMaximum := False;
  chart.LeftAxis.AutomaticMinimum := False;
  v:=0;
  if (Button = mbright) and ( MainForm.ActiveEnterDatawithMouse.Checked) then  // следим за правую кнопку
  begin
    if justAdd then exit;
    if (Series.ValueColor[ValueIndex] = Series2.ValueColor[ValueIndex])
      or (Series.ValueColor[ValueIndex] = Series3.ValueColor[ValueIndex])
    then
    begin
      if (Series.ValueColor[ValueIndex] = Series2.ValueColor[ValueIndex])
      then
      begin
        //извлечение значение Х мышки
        Ux:=Roundto(Series2.XScreenToValue(X),-TypeUnit.SRoundValue);
        //извлечение значение У мышки
        Uy:=Roundto(Series2.YScreenToValue(Y),-TypeUnit.SRoundValue);
        //удаляем точку из графика
        Series2.Delete(ValueIndex);
        v:=1;
      end
      else
      if (Series.ValueColor[ValueIndex] = Series3.ValueColor[ValueIndex]) then
      begin
        //извлечение значение Х мышки
        Ux:=Roundto(Series3.XScreenToValue(X),-TypeUnit.SRoundValue);
        //извлечение значение У мышки
        Uy:=Roundto(Series3.YScreenToValue(Y),-TypeUnit.SRoundValue);
        //удаляем точку из графика
        Series3.Delete(ValueIndex);
        v:=2;
      end;
      //удаляем выбранный точку из мои таблица точек
      m:=-1;
      if UsersFunction.Quantity<>-1 then//если естб данных в таюлице точек
      begin
        //находим точку для удаления в таблице точек
        for k := 0 to UsersFunction.Quantity do
        begin
          case  v of
            1: if UsersFunction.value[k].b then Inc(m);
            2: if not UsersFunction.value[k].b then Inc(m);
          end;
          if m = ValueIndex then Break;
        end;
        Ux:= UsersFunction.value[k].x;
        Uy:= UsersFunction.value[k].y;
        Ub:= UsersFunction.value[k].b;
        //установим в Х и У максимальное значение типа Int
        UsersFunction.value[k].x:=MaxInt;
        UsersFunction.value[k].y:=MaxInt;
        UsersFunction.value[k].b:=False;
        //соортируем таблица точек
        SortData(UsersFunction);
        //уменшаем количество точек на одну
        Dec(UsersFunction.Quantity);
        if UsersFunction.Quantity<>-1 then
        begin
          //покажем таблицу точек в StringGrid
          viewusersdata(StringGrid1,UsersFunction);
        end else
        begin
          //очистим и инициализируем StringGrid
          StringGrid1.Cols[1].Clear;
          StringGrid1.ColCount:=StringGrid1.ColCount-1;
        end;

        //добаляем точку в таблица точек
        //ищим точку в таблице точек
        k:= CoordMouseInFunction(Ux,Uy,UsersFunction,TypeUnit.SPrecision);
        if k=-1 then
        begin
          //нет точка в таблице так что нужно его добавить
          //установка значении
          MainForm.AbscissX.Text:=FloatToStr(Ux);
          MainForm.OrdinateY.Text:=FloatToStr(Uy);
          MainForm.PointChoosen.Checked:=not Ub;
          //добавляем точку
          MainForm.AddPointClick(Sender);
        end;
        if UsersFunction.Quantity<>-1 then
        begin
          //покажем таблицу точек в StringGrid
          viewusersdata(StringGrid1,UsersFunction);
        end else
        begin
          //очистим и инициализируем StringGrid
          StringGrid1.Cols[1].Clear;
          StringGrid1.ColCount:=StringGrid1.ColCount-1;
        end;
      end;
    end;
  end
  else
  if Button = mbleft then  // следим за левую кнопку
  begin
    if (Series.ValueColor[ValueIndex] = Series2.ValueColor[ValueIndex])
      or (Series.ValueColor[ValueIndex] = Series3.ValueColor[ValueIndex])
    then
    begin
      if (Series.ValueColor[ValueIndex] = Series2.ValueColor[ValueIndex])
      then
      begin
        //удаляем точку из графика
        Series2.Delete(ValueIndex);
        v:=1;
      end
      else
      if (Series.ValueColor[ValueIndex] = Series3.ValueColor[ValueIndex]) then
      begin
        //удаляем точку из графика
        Series3.Delete(ValueIndex);
        v:=2;
      end;
      m:=-1;

      if UsersFunction.Quantity<>-1 then//если естб данных в таюлице точек
      begin
        //находим точку для удаления в таблице точек
        for k := 0 to UsersFunction.Quantity do
        begin
          case  v of
            1: if UsersFunction.value[k].b then Inc(m);
            2: if not UsersFunction.value[k].b then Inc(m);
          end;
          if m = ValueIndex then Break;
        end;
        //установим в Х и У максимальное значение типа Int
        UsersFunction.value[k].x:=MaxInt;
        UsersFunction.value[k].y:=MaxInt;
        UsersFunction.value[k].b:=False;
        //соортируем таблица точек
        SortData(UsersFunction);
        //уменшаем количество точек на одну
        Dec(UsersFunction.Quantity);
        if UsersFunction.Quantity<>-1 then
        begin
          //покажем таблицу точек в StringGrid
          viewusersdata(StringGrid1,UsersFunction);
        end else
        begin
          //очистим и инициализируем StringGrid
          StringGrid1.Cols[1].Clear;
          StringGrid1.ColCount:=StringGrid1.ColCount-1;
        end;
      end;

        //переруем функцию Лагранжа
        if MainForm.CheckBoxLagrangeFunction.Checked then
        begin
          Series1.Clear; MainForm.CheckBoxLagrangeFunctionClick(sender);
        end;
        //переруем обобщенную функцию Лагранжа
        if MainForm.CheckBoxGeneralizingFunction.Checked then
        begin
          Series5.Clear; MainForm.CheckBoxGeneralizingFunctionClick(sender);
        end;
        //переруем обобщенную функцию Лагранжа
        if MainForm.CheckBoxGeneralizingFunctionII.Checked then
        begin
          Series6.Clear; MainForm.CheckBoxGeneralizingFunctionIIClick(sender);
        end;
        //переруем ошибочную функцию Лагранжа
        if MainForm.CheckBoxErrorLagrangeFunction.Checked then
        begin
          Series7.Clear; Series9.Clear;;MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
        end;
        //переруем ошибочную обобщенную функцию Лагранжа
        if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
        begin
          Series8.Clear; Series10.Clear;;MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
        end;
        //переруем ошибочную обобщенную функцию Лагранжа II
        if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked then
        begin
          Series12.Clear; Series13.Clear;;MainForm.CheckBoxErrorGeneralizingFunctionIIClick(sender);
        end;
        ExitDataUnit.ViewFormules;
     end;
  end;
  CheckDistinctionSeriesClick(Sender);
end;

//нажатия в графике правой кнопка
procedure TMainForm.ChartMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var k:Integer;
    I,ValueIndex: Integer;
begin
  if not MainForm.ActiveEnterDatawithMouse.Checked then  Exit;


  justAdd:=false;
  GoToAdd:=False;
  ValPointPos:=-1;
  //Отслеживаем только правую кнопку мыши.
  if (Button <> mbright) or (not MainForm.ActiveEnterDatawithMouse.Checked) then Exit;
  if MainForm.ActiveMovingAddPoint.Checked then GoToAdd:=True
  else  GoToAdd:=False;
  //извлечение значение Х мышки
  ValPoint.x:= Roundto(Series11.XScreenToValue(X),-TypeUnit.SRoundValue);
  //извлечение значение У мышки
  ValPoint.y:= Roundto(Series11.YScreenToValue(Y),-TypeUnit.SRoundValue);
  ValPoint.b:=true;
  //ищим точку в таблице точек
  k:= CoordMouseInFunction(ValPoint.x,ValPoint.y,UsersFunction,TypeUnit.SPrecision);
  if k=-1 then
  begin
    //нет точка в таблице так что нужно его добавить
    //установка значении
    MainForm.AbscissX.Text:=FloatToStr(ValPoint.x);
    MainForm.OrdinateY.Text:=FloatToStr(ValPoint.y);
    MainForm.PointChoosen.Checked:=ValPoint.b;
    //добавляем точку
    if not MainForm.ActiveMovingAddPoint.Checked then MainForm.AddPointClick(Sender)
    else
    begin
      EnterDataUnit.AddPoint;
      ValPointPos:= CoordMouseInFunction(ValPoint.x,ValPoint.y,UsersFunction,TypeUnit.SPrecision);
      ReloadGraphicsWhenMouseMove;
    end;
    justAdd:=true;
  end
  else
    if GoToAdd then
    begin
      //точка существует и ползователь хочешь сдивигать его
      justAdd:=true;
      ValPoint:=UsersFunction.value[k];
      ValPointPos:=k;
    end
    else justAdd:=False;
end;

//*************************конец график***********************************///

//Движение мыши
procedure TMainForm.ChartMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var Val:TypeUnit.TUserFunc;
begin
  //извлечение значение Х мышки
  Val.x:= Roundto(Series11.XScreenToValue(X),-TypeUnit.SRoundValue);
  //извлечение значение у мышки
  Val.y:= Roundto(Series11.YScreenToValue(Y),-TypeUnit.SRoundValue);
  //очистим заголовок график
  Chart.Title.Text.Clear;
  //показа координаты текушей точки
  Chart.Title.Text.Add('x='+floattostr(Val.x) +' y='+floattostr(Val.y));
  if not MainForm.ActiveEnterDatawithMouse.Checked then  Exit;
  if GoToAdd then
  begin
    Val.b:=ValPoint.b;
    //k:= CoordMouseInFunction(ValPoint.x,ValPoint.y,UsersFunction,TypeUnit.SPrecision);
    ValPoint:=Val;
    if ValPointPos<>-1 then
    begin
      //добавляем точку
        if not (
          (
            (Math.CompareValue(ValPoint.x, UsersFunction.value[ValPointPos+1].x,TypeUnit.SPrecision)=0)
            and (Math.CompareValue(ValPoint.y, UsersFunction.value[ValPointPos+1].y,TypeUnit.SPrecision)=0)
          ) or
          (
            (Math.CompareValue(ValPoint.x, UsersFunction.value[ValPointPos-1].x,TypeUnit.SPrecision)=0)
            and (Math.CompareValue(ValPoint.y, UsersFunction.value[ValPointPos-1].y,TypeUnit.SPrecision)=0)
          ) )
        then
        begin

        //удаляем точку
          //установим в Х и У максимальное значение типа Int
          UsersFunction.value[ValPointPos].x:=MaxInt;
          UsersFunction.value[ValPointPos].y:=MaxInt;
          UsersFunction.value[ValPointPos].b:=False;
          //соортируем таблица точек
          SortData(UsersFunction);
          //уменшаем количество точек на одну
          Dec(UsersFunction.Quantity);
          if UsersFunction.Quantity<>-1 then
          begin
            //покажем таблицу точек в StringGrid
            viewusersdata(StringGrid1,UsersFunction);
          end else
          begin
            //очистим и инициализируем StringGrid
            StringGrid1.Cols[1].Clear;
            StringGrid1.ColCount:=StringGrid1.ColCount-1;
          end;
          //востановляем данных в таблице точек и перерисуем график
          ProjectUnit.restorePointAfterLoadFile(MainUnit.MainForm.Series2,
              MainUnit.MainForm.series3,MainUnit.MainForm.StringGrid1,UsersFunction);
        //передобвляем точку с новыми координатами
          //установка значении

          MainForm.AbscissX.Text:=FloatToStr(ValPoint.x);
          MainForm.OrdinateY.Text:=FloatToStr(ValPoint.y);
          MainForm.PointChoosen.Checked:=ValPoint.b;
          //добавляем точку
          EnterDataUnit.AddPoint;
          //MainForm.AddPointClick(Sender);
          ValPointPos:= CoordMouseInFunction(ValPoint.x,ValPoint.y,UsersFunction,TypeUnit.SPrecision);
          justAdd:=true;
        end
        else
          if (
                (Math.CompareValue(ValPoint.x, UsersFunction.value[ValPointPos+1].x,TypeUnit.SPrecision)=0)
                and (Math.CompareValue(ValPoint.y, UsersFunction.value[ValPointPos+1].y,TypeUnit.SPrecision)=0)
              )
          then
          else ValPointPos:=ValPointPos-1;
            if (
                  (Math.CompareValue(ValPoint.x, UsersFunction.value[ValPointPos-1].x,TypeUnit.SPrecision)=0)
                  and (Math.CompareValue(ValPoint.y, UsersFunction.value[ValPointPos-1].y,TypeUnit.SPrecision)=0)
                )
            then ValPointPos:=ValPointPos+1;

    end else GoToAdd:=False;
    ReloadGraphicsWhenMouseMove;
  end;
end;

procedure TMainForm.ChartMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Val:TypeUnit.TUserFunc;
begin
  if not MainForm.ActiveEnterDatawithMouse.Checked then  Exit;
  if GoToAdd then
  begin
    //извлечение значение Х мышки
    Val.x:= Roundto(Series11.XScreenToValue(X),-TypeUnit.SRoundValue);
    //извлечение значение у мышки
    Val.y:= Roundto(Series11.YScreenToValue(Y),-TypeUnit.SRoundValue);
      Val.b:=ValPoint.b;
    //k:= CoordMouseInFunction(ValPoint.x,ValPoint.y,UsersFunction,TypeUnit.SPrecision);
    if ValPointPos<>-1 then
    begin
      //удаляем точку
        //установим в Х и У максимальное значение типа Int
        UsersFunction.value[ValPointPos].x:=MaxInt;
        UsersFunction.value[ValPointPos].y:=MaxInt;
        UsersFunction.value[ValPointPos].b:=False;
        //соортируем таблица точек
        SortData(UsersFunction);
        //уменшаем количество точек на одну
        Dec(UsersFunction.Quantity);
        if UsersFunction.Quantity<>-1 then
        begin
          //покажем таблицу точек в StringGrid
          viewusersdata(StringGrid1,UsersFunction);
        end else
        begin
          //очистим и инициализируем StringGrid
          StringGrid1.Cols[1].Clear;
          StringGrid1.ColCount:=StringGrid1.ColCount-1;
        end;
        //востановляем данных в таблице точек и перерисуем график
        ProjectUnit.restorePointAfterLoadFile(MainUnit.MainForm.Series2,
            MainUnit.MainForm.series3,MainUnit.MainForm.StringGrid1,UsersFunction);
      //передобвляем точку с новыми координатами
        //установка значении
        ValPoint:=Val;
        MainForm.AbscissX.Text:=FloatToStr(ValPoint.x);
        MainForm.OrdinateY.Text:=FloatToStr(ValPoint.y);
        MainForm.PointChoosen.Checked:=ValPoint.b;
        //добавляем точку
         EnterDataUnit.AddPoint;
        //MainForm.AddPointClick(Sender);
        justAdd:=true;
    end else GoToAdd:=False;
    ReloadGraphicsWhenMouseMove;
    GoToAdd:=False;
  end;

end;

//обрабочик при свиге экрана графиков
procedure TMainForm.ChartScroll(Sender: TObject);
begin
  //установка значение курсра
  chart.Cursor:=crteehand;
end;

//обрабочик перемещени мышки на главном окне
procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //если мышка находится в экран графиков то активизируем экран графики
  if (((Mouse.CursorPos.X>=595) and (Mouse.CursorPos.X<=1377))
        and((Mouse.CursorPos.Y>=-15) and (Mouse.CursorPos.Y<=532)))
  then begin MainForm.Chart.Enabled:=true end
  else
  begin
    //очистим заголовок экран графики
    Chart.Title.Text.Clear;
    //обнулируем счёчики позиции курсор в экране графики
    MainForm.Chart.Title.Text.Add('x=0 y=0');
    //дезактивизируем экран графики
    MainForm.Chart.Enabled:=False;
  end;
end;

//Обработчик при прокручивании колеса мышки вниз
Procedure TMainForm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (MainForm.ZoomAndScale.Checked) and
    (((MousePos.X>=595) and (MousePos.X<=1377))
      and((MousePos.Y>=-15) and (MousePos.Y<=532)))
  then
  begin
    //уменьшает экран на 5 процентов.
    Chart.ZoomPercent(95);
  end;
end;

//Обработчик при прокручивании колеса мышки вверх
procedure TMainForm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (MainForm.ZoomAndScale.Checked) and
    (((MousePos.X>=595) and (MousePos.X<=1377))
      and((MousePos.Y>=-15) and (MousePos.Y<=532)))
  then
  begin
    Chart.ZoomPercent(105);// увелечение экрана на 5 процентов
  end;
end;

//обрабочик генерации Функции
procedure TMainForm.GenerateFunctionClick(Sender: TObject);
var s,s1,s2,newline,l,g1,g2: string;
    k:integer;
begin
  k:=0;
  newline:=chr(13) + chr(10);
  //если хотя бы один из интерполированных функций активен то генерируем его
  //по выбранному действию пользователью
  if (MainForm.CheckBoxLagrangeFunction.Checked and MainForm.CheckBoxGeneralizingFunction.Checked)
    or (MainForm.CheckBoxLagrangeFunction.Checked and MainForm.CheckBoxGeneralizingFunctionII.Checked)
    or (MainForm.CheckBoxGeneralizingFunction.Checked and MainForm.CheckBoxGeneralizingFunctionII.Checked)
    or (MainForm.CheckBoxLagrangeFunction.Checked and MainForm.CheckBoxGeneralizingFunction.Checked and MainForm.CheckBoxGeneralizingFunctionII.Checked)
  then
  begin
    if MainForm.CheckBoxLagrangeFunction.Checked then
      case TypeUnit.SChooseLanguage of
        1: l:= newline+ ' 1 For Lagrange ';
        0: l:= newline+' 1 - Лагранж ';
      end
    else l:='';
    if MainForm.CheckBoxGeneralizingFunction.Checked then
      case TypeUnit.SChooseLanguage of
        1: g1:= newline+' 2 For Generalised Lagrange I ';
        0: g1:= newline+' 2 - Первый вид Обобщенной ';
      end
    else g1:='';
    if MainForm.CheckBoxGeneralizingFunctionII.Checked then
      case TypeUnit.SChooseLanguage of
        1: g2:= newline+' 3 For Generalised Lagrange II ';
        0: g2:= newline+' 3 - Второй вид Обобщенной ';
      end
    else g2:='';

    case TypeUnit.SChooseLanguage of
      1: begin s:='Generate?' + l+g1+g2; s1:='Number'; end;
      0: begin s:='Какую формулу нужно ли генерировать?'+ l+g1+g2; s1:='Число'; end;

    end;
    S2:=Inputbox(S1,S,''); //получение действие пользовтелья
    if (S2<>'') and (length(s2)=1)
      and ((S2[1] in ['0'..'9']))
    then
      k:=strtoint(s2)
    else
      k:=-1;
  end
  else
    if MainForm.CheckBoxLagrangeFunction.Checked then k:=1
    else
      if MainForm.CheckBoxGeneralizingFunction.Checked then k:=2
      else
        if MainForm.CheckBoxGeneralizingFunctionII.Checked then k:=3
        else k:=0;

  case k  of
  //генерации формула полинома Лагранжа
    1: MainForm.ControlFunction.Text:=(TypeUnit.TypeOriginalPolynomeLagrange);
  //генерации формула первого вида обобщённого полинома Лагранжа
    2: MainForm.ControlFunction.Text:=(TypeUnit.TypeGeneralizedPolynomeLagrange);
    //генерации формулы второго вида обобщённого полинома Лагранжа
    3: MainForm.ControlFunction.Text:=(TypeUnit.TypeGeneralizedPolynomeLagrangeII);
    //генерации любой формулы из модулы генерации
    0: MainForm.ControlFunction.Text:=GenerateFunctionUnit.Generate;
  end;

end;

//Обрабочик подключения и отключения панели вывода данных
procedure TMainForm.ExitDataClick(Sender: TObject);
var s1:string;
    b:boolean;
begin
  b:=false;
  case TypeUnit.SChooseLanguage of
    1:s1:='Would you Desactive Panel Exit Data?';
    0:s1:='Вы действительно ли отключить панель вывод данных ?';
  end;
  if not ExitData.Checked  then
  begin
    //подключение панели
    ExitData.Checked:=True;
    MainForm.PanelExitData.Visible:=true;
    b:=true;
  end
  else
  begin
    if ProjectUnit.Choice(S1,MtWarning)
    then
    begin
      //отключение панели
      ExitData.Checked:=False;
      MainForm.PanelExitData.Visible:=False;
      MainForm.CheckBoxLagrangeFunction.Checked:=False;
      MainForm.CheckBoxErrorLagrangeFunction.Checked:=False;
      MainForm.CheckBoxGeneralizingFunction.Checked:=False;
      MainForm.CheckBoxGeneralizingFunctionII.Checked:=False;
      MainForm.CheckBoxErrorGeneralizingFunction.Checked:=False;
      MainForm.CheckBoxViewLagrangeFunction.Checked:=False;
      MainForm.CheckBoxViewGeneralizingFunction.Checked:=False;
      MainForm.CheckBoxViewGeneralizingFunctionII.Checked:=False;
      MainForm.LagrangeAccuracy.Clear;
      MainForm.GeneralisedAccuracy.Clear;
      MainForm.GeneralisedAccuracyII.Clear;
      b:=true;
    end
    else
    begin
      //подключение панели
      ExitData.Checked:=True;
    end;

  end;
  if b then //если подключена панел
  begin
    //инициализация построения функции ошибки
    MainForm.CheckBoxErrorLagrangeFunction.Enabled:=False;
    MainForm.CheckBoxErrorGeneralizingFunction.Enabled:=False;
    MainForm.CheckBoxErrorGeneralizingFunctionII.Enabled:=False;
    //инициализаци посмотра формул
    MainForm.CheckBoxViewLagrangeFunction.Enabled:=False;
    MainForm.CheckBoxViewGeneralizingFunction.Enabled:=False;
    MainForm.CheckBoxViewGeneralizingFunctionII.Enabled:=False;
  end;
  //обновление язык интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

procedure TMainForm.CheckBoxLagrangeFunctionClick(Sender: TObject);
begin
  //
  if CheckBoxLagrangeFunction.Checked then
  begin
    //построения полином Лагранжа
    if ExitDataUnit.TraceLagrange then  MainForm.Series1.Active:=true
    else MainForm.Series1.Active:=False;
    //подключение возможности рисования функции ошибки
    MainForm.CheckBoxErrorLagrangeFunction.Enabled:=True;
    //подключение просмотра формулы
    MainForm.CheckBoxViewLagrangeFunction.Enabled:=true;
    //обновление вывода формул
    MainForm.MemoInformation.Clear;
    MainForm.CheckBoxViewGeneralizingFunctionClick(sender);
  end
  else
  begin
    //очистка полином Лагранж и функции ошибки
    MainForm.Series1.Clear;
    MainForm.Series1.Active:=false;
    MainForm.Series7.Clear;
    MainForm.Series7.Active:=false;
    MainForm.Series9.Clear;
    MainForm.Series9.Active:=false;
    //отключение возможности рисования функции ошибки
    CheckBoxErrorLagrangeFunction.Checked:=False;
    MainForm.CheckBoxErrorLagrangeFunction.Enabled:=False;
    //обновление вывода формул
    TypeUnit.TypeOriginalPolynomeLagrange:='';
    MainForm.MemoInformation.Clear;
    MainForm.CheckBoxViewGeneralizingFunctionClick(sender);
    MainForm.CheckBoxViewLagrangeFunction.Enabled:=False;
    TypeUnit.TimeTracedL:=-1;
  end;
  //установка временных оценок
  ExitDataUnit.SetAVGTimeTraced;
  //обновление выделенных функции
  MainForm.CheckDistinctionSeriesClick(sender);
  //обновление язык интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик рисования функции ошибки полинома Лагранжа
procedure TMainForm.CheckBoxErrorLagrangeFunctionClick(Sender: TObject);
begin
  if CheckBoxErrorLagrangeFunction.Checked then
  begin
    //рисование функции ошибки
    ExitDataUnit.TraceErrorLagrage(UsersFunction,NodeInterPolation);
    MainForm.LagrangeAccuracy.visible:=True;
    //вычисление и установка погрешность
    MainForm.LagrangeAccuracy.Text:=Floattostr(
    ExitDataUnit.GetAccuracy(series7,series9));
  end
  else
  begin
     //удаление функции ошибки
     MainForm.Series7.Clear;
     MainForm.Series7.Active:=false;
     MainForm.Series9.Clear;
     MainForm.Series9.Active:=false;
     //удаление погрешность
     MainForm.LagrangeAccuracy.Clear;
     MainForm.LagrangeAccuracy.visible:=false;
  end;
  //обновление выделенных функций
  MainForm.CheckDistinctionSeriesClick(sender);
  //обновление язык интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик построения первого вида обобщённого полинома Лагранжа
procedure TMainForm.CheckBoxGeneralizingFunctionClick(Sender: TObject);
begin
  if CheckBoxGeneralizingFunction.Checked then
  begin
    //рисование первого вида обобщённого полинома Лагранжа
    if ExitDataUnit.TraceGeneralizingLagrange
    then MainForm.Series5.Active:=true
    else MainForm.Series5.Active:=False;
    //добавление функции в архиве
    TypeUnit.LDT:=Length(DateTimeToStr(now)+' ===> ');
    if MainForm.TranslateFunction.Text<>''
    then HistoryUnit.AddTranslateHistory(DateTimeToStr(now)+' ===> '+MainForm.TranslateFunction.Text);
    //подключение возможности  построения функция ошибки
    MainForm.CheckBoxErrorGeneralizingFunction.Enabled:=true;
    //поключение просмотра формул
    MainForm.CheckBoxViewGeneralizingFunction.Enabled:=true;
    //обновление вывода формул
    MainForm.MemoInformation.Clear;
    MainForm.CheckBoxViewGeneralizingFunctionClick(sender);
  end
  else
  begin
    //очистить функции и функции ошибки
    MainForm.Series5.Clear;
    MainForm.Series5.Active:=false;
    MainForm.Series8.Clear;
    MainForm.Series8.Active:=false;
    MainForm.Series10.Clear;
    MainForm.Series10.Active:=false;
    //отключение возможности  построения функция ошибки
    CheckBoxErrorGeneralizingFunction.Checked:=False;
    MainForm.CheckBoxErrorGeneralizingFunction.Enabled:=False;
    //обновление вывода формул
    TypeUnit.TypeGeneralizedPolynomeLagrange:='';
    MainForm.MemoInformation.Clear;
    MainForm.CheckBoxViewGeneralizingFunctionClick(sender);
    MainForm.CheckBoxViewGeneralizingFunction.Enabled:=False;
    TypeUnit.TimeTracedGl1:=-1;
  end;
  //установка временных оценок
  ExitDataUnit.SetAVGTimeTraced;
  //обновление выделенных функции
  MainForm.CheckDistinctionSeriesClick(sender);
  //обновление язык интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик построения первого вида обобщённого полинома Лагранжа
procedure TMainForm.CheckboxGeneralizingFunctionIIClick(Sender: TObject);
begin
  if CheckBoxGeneralizingFunctionII.Checked then
  begin
    //рисование второго вида обобщённого полинома Лагранжа
    if ExitDataUnit.TraceGeneralizingLagrangeII
    then MainForm.Series6.Active:=true
    else MainForm.Series6.Active:=False;
    //добавление функции в архиве
    TypeUnit.LDT:=Length(DateTimeToStr(now)+' ===> ');
    if MainForm.Series6.Active
    then HistoryUnit.AddTranslateHistory(DateTimeToStr(now)+' ===> '+MainForm.TranslateFunction.Text);
    //подключение возможности  построения функция ошибки
    MainForm.CheckBoxErrorGeneralizingFunctionII.Enabled:=true;
    //поключение просмотра формул
    MainForm.CheckBoxViewGeneralizingFunctionII.Enabled:=true;
    //обновление вывода формул
    MainForm.CheckBoxViewGeneralizingFunctionClick(sender);
  end
  else
  begin
    //очистить функции и функции ошибки
    MainForm.Series6.Clear;
    MainForm.Series6.Active:=false;
    MainForm.Series12.Clear;
    MainForm.Series12.Active:=false;
    MainForm.Series13.Clear;
    MainForm.Series13.Active:=false;
    //отключение возможности  построения функция ошибки
    MainForm.CheckBoxErrorGeneralizingFunctionII.Checked:=False;
    MainForm.CheckBoxErrorGeneralizingFunctionII.Enabled:=False;
    TypeUnit.TypeGeneralizedPolynomeLagrangeII:='';
    //обновление вывода формул
    MainForm.CheckBoxViewGeneralizingFunctionClick(sender);
    MainForm.CheckBoxViewGeneralizingFunctionII.Enabled:=False;
    TypeUnit.TimeTracedGL2:=-1;
  end;
  //установка временных оценок
  ExitDataUnit.SetAVGTimeTraced;
  //обновление выделенных функции
  MainForm.CheckDistinctionSeriesClick(sender);
  //обновление язык интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик построения функция ошибки второго вида обобщённого полинома Лагранжа
procedure TMainForm.CheckboxErrorGeneralizingFunctionIIClick(Sender: TObject);
begin

  if CheckBoxErrorGeneralizingFunctionII.Checked then
  begin
    //рисование функции ошибки
    ExitDataUnit.TraceErrorGeneralizingII(MainForm.TranslateFunction.Text,UsersFunction,
      NodeInterPolationGeneral);
    //вычисление и установка погрешность
    MainForm.GeneralisedAccuracyII.Text:=Floattostr(
            ExitDataUnit.GetAccuracy(series12,series13));
    MainForm.GeneralisedAccuracyII.visible:=True
  end
  else
  begin
     //удаление функции ошибки
     MainForm.Series12.Clear;
     MainForm.Series12.Active:=false;
     MainForm.Series13.Clear;
     MainForm.Series13.Active:=false;
     MainForm.GeneralisedAccuracyII.Clear;
     MainForm.GeneralisedAccuracyII.visible:=false;
  end;
  //обновление выделенных функций
  MainForm.CheckDistinctionSeriesClick(sender);
  //обновление язык интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик построения функция ошибки второго вида обобщённого полинома Лагранжа
procedure TMainForm.CheckBoxErrorGeneralizingFunctionClick(Sender: TObject);
begin
  if CheckBoxErrorGeneralizingFunction.Checked then
  begin
    //рисование функции ошибки
    ExitDataUnit.TraceErrorGeneralizing(MainForm.TranslateFunction.Text,UsersFunction,
      NodeInterPolationGeneral);
    MainForm.GeneralisedAccuracy.visible:=True;
    //вычисление и установка погрешность
    MainForm.GeneralisedAccuracy.Text:=Floattostr(
    ExitDataUnit.GetAccuracy(series8,series10));
  end
  else
  begin
     //удаление функции ошибки
     MainForm.Series8.Clear;
     MainForm.Series8.Active:=false;
     MainForm.Series10.Clear;
     MainForm.Series10.Active:=false;
     MainForm.GeneralisedAccuracy.Clear;
     MainForm.GeneralisedAccuracy.visible:=false;
  end;
  //обновление выделенных функций
  MainForm.CheckDistinctionSeriesClick(sender);
  //обновление язык интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик отображения формул
procedure TMainForm.CheckBoxViewGeneralizingFunctionClick(Sender: TObject);
begin
//отображение формул
  ExitDataUnit.ViewFormules;
//обновление язык интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

procedure TMainForm.CheckDistinctionClick(Sender: TObject);
var ClickedCheckDistinction: TCheckBox;
    i,k:integer;
begin
  if TypeUnit.CheckDistinction[0].Checked then
  begin
  //иницилизация динамические флажки для выделения
    for i:=1 to TypeUnit.QCheck do
    begin 
      TypeUnit.CheckDistinction[i].Checked:=false;
      TypeUnit.CheckDistinction[i].Enabled:=false;
    end;
    //инициализации размера экрана
    MainForm.DistinctionWithResize.Checked:=false;
    MainForm.DistinctionWithResize.Enabled:=False;
    MainForm.HideFunction.ItemIndex:=3;
    MainForm.HideFunction.Enabled:=false;
  end
  else
  begin
    for i:=1 to TypeUnit.QCheck do 
    begin 
      TypeUnit.CheckDistinction[i].Checked:=False;
      TypeUnit.CheckDistinction[i].Enabled:=True;
    end;
    MainForm.DistinctionWithResize.Enabled:=True;
    MainForm.HideFunction.Enabled:=True;
    MainForm.HideFunction.ItemIndex:=0;
  end;
  for I := 0 to MainForm.Chart.SeriesCount - 3 do  //-2 axis
  begin
    MainForm.Chart.Series[i].Pen.Width:=TypeUnit.SPenWIdthNotDistincted;
    MainForm.Chart.Series[i].Pen.Width:=TypeUnit.SPenWIdthNotDistincted;
    MainForm.Chart.Series[i].Repaint;
  end;
  //обновление выделенных функций
  MainForm.HideFunctionChange(Sender);
  //обновление размера экрана
  if (MainForm.DistinctionWithResize.Checked)
  then  ExitDataUnit.Autoresize;
end;

//обработка при выделении графики
procedure TMainForm.CheckDistinctionSeriesClick(Sender: TObject);
var CheckDistinctionSeries: TCheckBox;
    i,k:integer;
begin
  if not TypeUnit.CheckDistinction[0].Checked then // если не установлен флажок ниодной
  begin
    for i:=1 to TypeUnit.QCheck do
    begin
      //установим значение пера в завимости от выбранных функции
      if TypeUnit.CheckDistinction[i].Checked
          and (MainForm.Chart.Series[i-1].Title = TypeUnit.CheckDistinction[i].Caption) 
      then MainForm.Chart.Series[i-1].Pen.Width:=TypeUnit.SPenWIdthDistincted
      else MainForm.Chart.Series[i-1].Pen.Width:=TypeUnit.SPenWIdthNotDistincted;
      //перерисуем грфик
      MainForm.Chart.Series[i-1].Repaint;
    end;
  end else MAinForm.CheckDistinctionClick(Sender);
  //обновляем выбранных функции
  MainForm.HideFunctionChange(Sender);
  //обновляем размер экрана
  if (MainForm.DistinctionWithResize.Checked) 
  then ExitDataUnit.Autoresize;
end;

// обрабочик перемещения узла функции налево
procedure TMainForm.MinusClick(Sender: TObject);
begin
  if (MainForm.Delta.Text<>'') and (TypeUnit.SelectedCol<>-1) and EnterDataUnit.AddPointUsingFunction(-StrtoFloat(MainForm.Delta.Text)) then
  begin
    if not Series2.Active then Series2.Active:=true;
    if not Series3.Active then Series3.Active:=true;
    //переруем функцию Лагранжа
    if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked then
    begin
      Series1.Clear; MainForm.CheckBoxLagrangeFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа
    if MainForm.CheckBoxGeneralizingFunction.Checked then
    begin
      Series5.Clear; MainForm.CheckBoxGeneralizingFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа  II
    if MainForm.CheckboxGeneralizingFunctionII.Checked then
    begin
      Series6.Clear; MainForm.CheckBoxGeneralizingFunctionIIClick(sender);
    end;
    //переруем ошибочную функцию Лагранжа
    if MainForm.CheckBoxErrorLagrangeFunction.Checked then
    begin
      Series7.Clear; Series9.Clear;MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
    begin
      Series8.Clear; Series10.Clear;MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа II
    if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked then
    begin
      Series12.Clear; Series13.Clear;MainForm.CheckboxErrorGeneralizingFunctionIIClick(sender);
    end;

    ExitDataUnit.ViewFormules;
  end
  else
    if (MainForm.Delta.Text='') then
      case TypeUnit.SChooseLanguage of
        1:ProjectUnit.Info('Not Data Delta',mtWarning);
        0:ProjectUnit.Info('Проверяете значение делта',mtWarning);
      end;
end;

//обрабочик изменения значении узлы
procedure TMainForm.ModifyPointClick(Sender: TObject);
var s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Do You Want change the current selected point';
    0:s:='Хотите ли вы изменить выбранную точку';
  end;
  if (Series1.Active or Series2.Active) and (TypeUnit.SelectedCol<>-1) and ProjectUnit.Choice(s,MtConfirmation) and EnterDataUnit.ModifyPoint then
  begin
    TypeUnit.SelectedCol:=-1;
    //переруем функцию Лагранжа
    if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked then
    begin
      Series1.Clear; MainForm.CheckBoxLagrangeFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа
    if MainForm.CheckBoxGeneralizingFunction.Checked then
    begin
      Series5.Clear; MainForm.CheckBoxGeneralizingFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа  II
    if MainForm.CheckboxGeneralizingFunctionII.Checked then
    begin
      Series6.Clear; MainForm.CheckBoxGeneralizingFunctionIIClick(sender);
    end;
    //переруем ошибочную функцию Лагранжа
    if MainForm.CheckBoxErrorLagrangeFunction.Checked then
    begin
      Series7.Clear; Series9.Clear;MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
    begin
      Series8.Clear; Series10.Clear;MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа II
    if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked then
    begin
      Series12.Clear; Series13.Clear;MainForm.CheckboxErrorGeneralizingFunctionIIClick(sender);
    end;
    ExitDataUnit.ViewFormules;
    MainForm.CheckDistinctionSeriesClick(sender);
  end;
end;

//обрабочик создания отчёта текущего процесса моделирования
procedure TMainForm.SendToReportClick(Sender: TObject);
var Y, M, D,H,N,S,Z : word;
    NameReport,s1:string;
begin
  //проверка на сушествование текуший проект
  case TypeUnit.SChooseLanguage of
    1:s1:='You Must before save Project';
    0:s1:='Необходимо сохранить текущий проект';
  end;

  if (lowercase(MainForm.OpenDialog.FileName)=lowercase('Новый Проект'))
      or (lowercase(MainForm.OpenDialog.FileName)=lowercase('New Project'))
  then
  begin
    //отображение информации
    ProjectUnit.Info(s1,MtInformation);
    Abort;  //отменяем действие
  end;
  try
    //декодация времени
    DecodeDate( Now, Y, M , D);
    DecodeTime( Now, H, N, S, Z);
    //установка имя отчёта
    NameReport:=IntToStr(D)+'-'+IntToStr(M)+'-'+IntToStr(Y)
        +'_'+IntToStr(H)+'-'+IntToStr(N)+'-'+IntToStr(S);
    //создание отчёта текущего процесса моделирования
    ReportUnit.SentToReport(TypeUnit.linkProject,NameReport,DateTimetoStr(Now,FormatDT));
  Except
    case TypeUnit.SChooseLanguage of
      1: MessageDlg('An error occurred while sending. Action canceled.',mtWarning, [mbOK], 0 );
      0: MessageDlg('Произошло ошибку при отправке. Действие отменено.',mtWarning, [mbOK], 0 );
    end;
    Exit;
  end;
  case TypeUnit.SChooseLanguage of
    1: MessageDlg('successful send!',mtInformation, [mbOK], 0 );
    0: MessageDlg('Отправлен!',mtInformation, [mbOK], 0 );
  end;
end;

procedure TMainForm.SettingClick(Sender: TObject);
begin
  //запуск окна настройки
  SettingUnit.SettingForm.ShowModal;
end;

//обрабочик установкаи текущего размера экрана
procedure TMainForm.SetValueInsettingClick(Sender: TObject);
begin
  //установка значений
  SettingUnit.SettingForm.AxisXLeftValue.Text:=floattostr(Math.RoundTo(MainForm.Chart.BottomAxis.Minimum,-TypeUnit.SRoundValue));
  SettingUnit.SettingForm.AxisXRightValue.Text:=floattostr(Math.RoundTo(MainForm.Chart.BottomAxis.Maximum,-TypeUnit.SRoundValue));
  SettingUnit.SettingForm.AxisYLeftValue.Text:=floattostr(Math.RoundTo(MainForm.Chart.LeftAxis.Minimum,-TypeUnit.SRoundValue));
  SettingUnit.SettingForm.AxisYRightValue.Text:=floattostr(Math.RoundTo(MainForm.Chart.LeftAxis.Maximum,-TypeUnit.SRoundValue));
  SettingUnit.SettingForm.RoundValueChange(Sender);
  //изменяем размер экрана
  ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
  //рисование оси
  MainForm.DrawAxisXClick(sender);
end;

//обрабочик подключение и отключение панели проверки построения
procedure TMainForm.VerificationConstructionClick(Sender: TObject);
var s1:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s1:='Would you Desactive Panel Verification Function?';
    0:s1:='Вы действительно ли отключить проверку построения функции';
  end;
  if not VerificationConstruction.Checked  then
  begin
    //подключение панели
    VerificationConstruction.Checked:=True;
    MainForm.ControlFunction.Clear;
    MainForm.PanelVerificationConstruction.Visible:=true;
  end
  else
  begin
    if ProjectUnit.Choice(S1,MtWarning)
    then
    begin
      //отключение панели
      VerificationConstruction.Checked:=False;
      MainForm.PanelVerificationConstruction.Visible:=False;
      ExitDataUnit.DeleteControlFunction;
    end
    else
    begin
      //подключение панели
      VerificationConstruction.Checked:=True;
    end;
  end;
  //обновление языка интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик отображения таблица узлов
procedure TMainForm.ViewNodeClick(Sender: TObject);
begin
  if MainForm.ViewNode.Checked
  then MainForm.StringGrid1.Visible:=True
  else MainForm.StringGrid1.Visible:=False;
  //показать данны в таблице точек
  ExitDataUnit.viewusersdata(MainUnit.MainForm.StringGrid1,UsersFunction);
  //обновление язык интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик отображения структурообразующих функций в отдельном окне
procedure TMainForm.ViewTranslateFunctionClick(Sender: TObject);
var s1:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s1:='Not translate Data Value';
    0:s1:='Структурообразующая функция пуста';
  end;
  //показать форма там где нарисовали график
  if MainForm.TranslateFunction.Text<>''
  then
    try
      //построим график
      if ShowTranslateFunctionUnit.TranslateFunctionForm.ViewTranslateFunction
      then ShowTranslateFunctionUnit.TranslateFunctionForm.ShowModal //показать график
    Except
      on EInvalidOp do
        //если возникли деление на Нуль то показать график
        ShowTranslateFunctionUnit.TranslateFunctionForm.ShowModal
      else
      case TypeUnit.SChooseLanguage of
        1:s1:='Incorret Expression';
        0:s1:='Неверное выражение';
      end;
      //отображение информации пользователю
      ProjectUnit.Info(s1,MtWarning);
    end
  else ProjectUnit.Info(s1,MtWarning); //отображение информации пользователю
end;

//рисовать функцию проверки
procedure TMainForm.TraceControlFunctionClick(Sender: TObject);
begin
  //построить проверочной функции
  if ExitDataUnit.TraceControlFunction then
  begin
    MainForm.series11.Active:=true;
    //обновление выделенных функций
    MainForm.CheckDistinctionSeriesClick(sender);
  end;
end;

//обрабочик подключение и отключение панели маштабирования
procedure TMainForm.ZoomAndScaleClick(Sender: TObject);
var s1:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s1:='Would you Want set the current screen size?';
    0:s1:='Хотите ли вы установить текуший размер экрана ?';
  end;
  if not ZoomAndScale.Checked  then
  begin
    //подключение панели
    ZoomAndScale.Checked:=True;
    MainForm.PanelZoom.Visible:=true;
    MainForm.PZoom.ItemIndex:=0;
    MainForm.PZoom.Visible:=true;
    Chart.Zoom.Allow:=True ;
    Chart.Zoom.Direction:=tzdBoth;
  end
  else
  begin
    //отключение панели
    ZoomAndScale.Checked:=False;
    if (Chart.Zoomed or ExitDataUnit.ScaleChanged) and ProjectUnit.Choice(S1,MtConfirmation)
    then MainForm.SetValueInsettingClick(Sender);
    //инициализации панели зум
    MainForm.PanelZoom.Visible:=False;
    MainForm.PZoom.ItemIndex:=-1;
    MainForm.PZoom.Visible:=False;
    Chart.Zoom.Direction:=tzdBoth;
    Chart.Zoom.Allow:=False;
    //сброс масштабирование
    Chart.UndoZoom;
    //обновление размера экрана
    ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
  end;
  //обновление языка интерфейса
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex])
end;

//обрабочик перемещения узла направа
procedure TMainForm.PlusClick(Sender: TObject);
begin
  if (MainForm.Delta.Text<>'') and (TypeUnit.SelectedCol<>-1) and  EnterDataUnit.AddPointUsingFunction(StrtoFloat(MainForm.Delta.Text)) then
  begin
    if not Series2.Active then Series2.Active:=true;
    if not Series3.Active then Series3.Active:=true;
    //переруем функцию Лагранжа
    if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked then
    begin
      Series1.Clear; MainForm.CheckBoxLagrangeFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа
    if MainForm.CheckBoxGeneralizingFunction.Checked then
    begin
      Series5.Clear; MainForm.CheckBoxGeneralizingFunctionClick(sender);
    end;
    //переруем обобщенную функцию Лагранжа  II
    if MainForm.CheckboxGeneralizingFunctionII.Checked then
    begin
      Series6.Clear; MainForm.CheckBoxGeneralizingFunctionIIClick(sender);
    end;
    //переруем ошибочную функцию Лагранжа
    if MainForm.CheckBoxErrorLagrangeFunction.Checked then
    begin
      Series7.Clear; Series9.Clear;MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
    begin
      Series8.Clear; Series10.Clear;MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа II
    if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked then
    begin
      Series12.Clear; Series13.Clear;MainForm.CheckboxErrorGeneralizingFunctionIIClick(sender);
    end;

    ExitDataUnit.ViewFormules;
  end
  else
    if (MainForm.Delta.Text='') then
      case TypeUnit.SChooseLanguage of
        1:ProjectUnit.Info('Not Data Delta',mtWarning);
        0:ProjectUnit.Info('Проверяете значение делта',mtWarning);
      end;
end;

//обрабочик выбора тип маштабирования
procedure TMainForm.PZoomClick(Sender: TObject);
begin
  case PZoom.ItemIndex of
    0: Chart.Zoom.Direction:=tzdBoth; //по диагонале
    1: Chart.Zoom.Direction:=tzdHorizontal;// по горизонтале
    2: Chart.Zoom.Direction:=tzdVertical; //по вертикале
  end;
end;

//обрабочик сброса масштабирования
procedure TMainForm.ResetZoomAndScaleClick(Sender: TObject);
begin
  if Chart.Zoomed or not MainForm.ActiveEnterDatawithMouse.Checked then
  begin
    //сбросим масштабирования
    Chart.UndoZoom;
    //обновляем размера экрана
    ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
  end;

end;

//обрабочик восстановления размера экрана
procedure TMainForm.ResizeChartClick(Sender: TObject);
begin
  //установим флажок Ниодной в панели выделения
  TypeUnit.CheckDistinction[0].Checked:=True;
  //обновляем размера экрана
  ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
end;

//обрабочик создания итогового отчёта
procedure TMainForm.ReportClick(Sender: TObject);
var FromDateTime,ToDateTime,s1:string;
    DT:TdateTime;
    b:boolean;
begin
  case TypeUnit.SChooseLanguage of
    1:s1:='You Must before save Project';
    0:s1:='Необходимо сохранить текущий проект';
  end;

  if (lowercase(MainForm.OpenDialog.FileName)=lowercase('Новый Проект'))
      or (lowercase(MainForm.OpenDialog.FileName)=lowercase('New Project'))
  then
  begin
    //отображение информации
    ProjectUnit.Info(s1,MtInformation);
    Abort;
  end;

  b:=false;
  //oтправить текуший отчет
  MainForm.Cursor:=CrDefault;
  case TypeUnit.SChooseLanguage of
    1: if ProjectUnit.Choice('Send the current report in the final report?',MtConfirmation)
       then begin  MainForm.SendToReport.Click; b:=true;end;
    0: if ProjectUnit.Choice('Отправить текущий Отчет в Итоговом Отчёте?',MtConfirmation)
       then begin MainForm.SendToReport.Click; b:=true; end;
  end;
  MainForm.Cursor:=crHourGlass;
  try
    with SaveDocument do
    begin
      SaveDocument.FileName:='';
      if Execute then
      begin
        if SettingUnit.SettingForm.Withoutrestriction.Checked
        then ReportUnit.ReportWord(SaveDocument.FileName,
            TypeUnit.linkProject,DateTimetostr(TypeUnit.DateTimeCreateProject,FormatDT),
            DateTimetostr(now,TypeUnit.FormatDT))
        else
        begin
          FromDateTime:=Datetostr(TypeUnit.SDateFrom,TypeUnit.FormatDT)+' '+ Timetostr(TypeUnit.STimeFrom,TypeUnit.FormatDT);
          if b and ( not SettingUnit.SettingForm.Withoutrestriction.Checked) then
            case TypeUnit.SChooseLanguage of
            1:  if ProjectUnit.Choice('Include the current report in the final report?',MtConfirmation) then
                begin
                  DT:=now;
                  ToDateTime:=DateTimetostr(DT,TypeUnit.FormatDT);
                  SettingUnit.SettingForm.DatePickerTo.Date:=DT;
                  SettingUnit.SettingForm.DatePickerTo.Time:=DT;
                  SettingUnit.SettingForm.RoundValueChange(sender);
                end;
            0: if ProjectUnit.Choice('Включить текущий Отчет в Итоговом Отчёте?',MtConfirmation) then
               begin
                  DT:=now;
                  ToDateTime:=DateTimetostr(DT,TypeUnit.FormatDT);
                  SettingUnit.SettingForm.DatePickerTo.Date:=DT;
                  SettingUnit.SettingForm.DatePickerTo.Time:=DT;
                  SettingUnit.SettingForm.RoundValueChange(sender);
               end;
            end
          else ToDateTime:=Datetostr(TypeUnit.SDateTo,TypeUnit.FormatDT)+' '+ Timetostr(TypeUnit.STimeTo,TypeUnit.FormatDT);
          //создание итогового отчета
          ReportUnit.ReportWord(SaveDocument.FileName,TypeUnit.linkProject,FromDateTime,ToDateTime);
        end;

      end else Exit; //не удалось запустить диалог

    end;
    //проверка на существования отчёта
    if Not FileExists(SaveDocument.FileName)
    then  Exit;

  Except
    case TypeUnit.SChooseLanguage of
      1: MessageDlg('An error occurred while creating Final report. Action canceled.',mtWarning, [mbOK], 0 );
      0: MessageDlg('Произошло ошибку при создании итогого отчёта. Действие отменено.',mtWarning, [mbOK], 0 );
    end;
    Exit;
  end;
  
  case TypeUnit.SChooseLanguage of
    1:if ProjectUnit.Choice('Final Report was successfully created! Open it?',MtConfirmation)
      then ReportUnit.OpenInWord(SaveDocument.FileName);
    0:if ProjectUnit.Choice('Итоговый Отчёт успешно создан! Запустить его?',MtConfirmation)
      then ReportUnit.OpenInWord(SaveDocument.FileName);
  end;
end;

//обрабочик обновления размера экрана при создании отчётов
procedure TMainForm.ReportResizeClick(Sender: TObject);
begin
  MainForm.CheckDistinctionSeriesClick(Sender);
end;

//обрабочик запуска руковоство оператора
procedure TMainForm.HelpClick(Sender: TObject);
var h,s:string;
begin
  //установим путь
  h:=HelpUnit.HelpFileName ;
  //проверка на существования файла
  if FileExists(h)
  then
    // запуск справочной системы
    HtmlHelp(Application.Handle,PChar(h),HH_DISPLAY_TOPIC,  0)
  else
    case TypeUnit.SChooseLanguage of
      1: ProjectUnit.Info('Error. Look for the CHM file in the correct folder',mtWarning);
      0: ProjectUnit.Info('Помощь не найдена! Проверяете если файл с расширением ".chm" в папке C:\',mtWarning);
    end;    
  
end;

//// автоматический запуск справочной системы при нажатии на кнопку F1
procedure TMainForm.HelpMessage(var msg: TWMHelp);
begin
  HelpUnit.WMHelp(msg,Menu,PopupMenu);
end;

//обрабочик скрытия и отображения выделеных функций
procedure TMainForm.HideFunctionChange(Sender: TObject);
var
  I: Integer;
begin
  if TypeUnit.CheckDistinction[0].Checked then // если неодной не выделенны
  begin
    case MainForm.HideFunction.ItemIndex of
      0,1: MainForm.HideFunction.ItemIndex:=0;
      2: MainForm.HideFunction.ItemIndex:=0;
    end;
  end;
  case MainForm.HideFunction.ItemIndex of
    0: ExitDataUnit.ShowAllFunction; //показать все функции
    1,2: ExitDataUnit.HiddenShowFunction;// скрыть функции
  end;
  if (MainForm.DistinctionWithResize.Checked) then
  //обновление размера экрана графики
    ExitDataUnit.Autoresize;
end;

//обрабочик выбора элемент из архива для использования
procedure TMainForm.HistoryTranslateFunctionDblClick(Sender: TObject);
var s:string;
begin
  s:= MainForm.HistoryTranslateFunction.Items[MainForm.HistoryTranslateFunction.ItemIndex];
  delete(S,1,TypeUnit.LDT);
  //установка выбранного значении
  MainForm.TranslateFunction.Text:=s;
  //перерисования обобщённые функции
  MainForm.CheckBoxGeneralizingFunctionClick(sender);
  MainForm.CheckBoxGeneralizingFunctionIIClick(sender);
end;

end.
