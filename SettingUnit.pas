unit SettingUnit;

interface
// используеммые библиотеки
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,XPMan, Buttons,Math;

  //объявление типов
type
  TSettingForm = class(TForm)    //тип окно настроки
    ChooseLanguage: TComboBox;
    Language: TGroupBox;
   Report : TGroupBox;
    EnterData: TGroupBox;
    ExitData: TGroupBox;
    RoundValue: TLabeledEdit;
    Precision: TLabeledEdit;
    ActiveEnterDataWithFunction: TCheckBox;
    ActiveExitDataFormules: TCheckBox;
    ActiveGraphe: TCheckBox;
    StepTraceUsersAnalytiqueFunction: TLabeledEdit;
    StepTraceLagrangeAndGeneralizingFunction: TLabeledEdit;
    StepTraceErrorFunction: TLabeledEdit;
    ActiveEnterDataPoints: TCheckBox;
    ActiveControlFunction: TCheckBox;
    ActiveTableValueTracedUsersAnalytiqueFunction: TCheckBox;
    ActiveTableValueTracedLaGrangeFunction: TCheckBox;
    ActiveTableValueTracedGeneralizingFunction: TCheckBox;
    AxisX: TGroupBox;
    AxisXLeftValue: TLabeledEdit;
    AxisXRightValue: TLabeledEdit;
    AxisY: TGroupBox;
    AxisYLeftValue: TLabeledEdit;
    AxisYRightValue: TLabeledEdit;
    DatePickerFrom: TDateTimePicker;
    DateTimeReport: TGroupBox;
    DatePickerTo: TDateTimePicker;
    LabelFrom: TLabel;
    LabelTo: TLabel;
    Withoutrestriction: TCheckBox;
    TimePickerFrom: TDateTimePicker;
    TimePickerTo: TDateTimePicker;
    Timer: TTimer;
    ResetDateTime: TButton;
    GroupActiveGraph: TGroupBox;
    ActiveGraphUserFunction: TCheckBox;
    ActiveGraphLagrange: TCheckBox;
    ActiveGraphGeneralisedLagrange: TCheckBox;
    ActiveGraphLagrangeError: TCheckBox;
    ActiveGraphGeneralisedLagrangeError: TCheckBox;
    ActiveGraphControlFunction: TCheckBox;
    PanelMarge: TGroupBox;
    MargeX: TLabeledEdit;
    MargeY: TLabeledEdit;
    CreateReportPanel: TGroupBox;
    Distinction: TGroupBox;
    PenWidthDistincted: TLabeledEdit;
    PenWidthNotDistincted: TLabeledEdit;
    HistoryPanel: TGroupBox;
    depthofhistory: TLabeledEdit;
    SetDefaultSetting: TButton;
    ActiveTableValueTracedGeneralizingFunctionII: TCheckBox;
    ActiveGraphGeneralisedLagrangeII: TCheckBox;
    ActiveGraphGeneralisedLagrangeErrorII: TCheckBox;
    //объявление обрабочики компонеты окно настройки
    //обрабочик изменения язык интерфейса
    procedure ChooseLanguageChange(Sender: TObject);
    //обрабочик при создании окна настройки
    procedure FormCreate(Sender: TObject);
    //обрабочик изменения данные в редактируемых полях
    procedure RoundValueChange(Sender: TObject);
    //обрабочик активация окна настройки
    procedure FormActivate(Sender: TObject);
    //обрабочик ограничения а редактируемых полях
    procedure RoundValueKeyPress(Sender: TObject; var Key: Char);
    //обрабочик при закрытии окна настройки
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    //обрабочик установки временных ограничений
    procedure WithoutrestrictionClick(Sender: TObject);
    //обрабочик установка дата и время по умолсаню
    procedure ResetDateTimeClick(Sender: TObject);
    //обрабочик счётчика время
    procedure TimerTimer(Sender: TObject);
    //обрабочик нажатии на сочетании клавиш
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    //обрабочик установка настройки по умолчаню
    procedure SetDefaultSettingClick(Sender: TObject);
  private
    { объяыление мкрытых обработчиков}
    //обрабочик отображение справочной системы
    procedure HelpMessage(var msg:TWMHelp); message WM_HELP;
  public
    { объяыление публичных обработчиков }
  end;

  //объявление глобальных переменных
var
  SettingForm: TSettingForm; // перемен окно настройки

implementation

{$R *.dfm}
//используемые модули
uses LanguageUnit,TypeUnit,ExitDataUnit,MainUnit, HistoryUnit, ProjectUnit,
  HelpUnit;

  //обработчик изменения язык интерфейса
procedure TSettingForm.ChooseLanguageChange(Sender: TObject);
begin
  TypeUnit.SChooseLanguage:=ChooseLanguage.ItemIndex;
  // установка выбранного языка
  LanguageUnit.SetLanguage(ChooseLanguage.Text);
  //сохраняем индекм текушего языка
  ChooseLanguage.ItemIndex:=TypeUnit.SChooseLanguage;
  //переинициализируем диалоговые окна
  ProjectUnit.InitDialogs;
end;

//обработчик активации окна настройки
procedure TSettingForm.FormActivate(Sender: TObject);
begin
  //обновление временных ограничений
  SettingForm.WithoutrestrictionClick(Sender);
  //установка язык
  LanguageUnit.SetLanguage(SettingForm.ChooseLanguage.Items[SettingForm.ChooseLanguage.ItemIndex]);
end;

//обрабочик при закрытие окна настройки
procedure TSettingForm.FormClose(Sender: TObject; var Action: TCloseAction);
var s:string;
begin
  case TypeUnit.SChooseLanguage of
    1:s:='Would you Exit Setting?';
    0:s:='Вы действительно хотите ли выйти из настройки?';
  end;
  if  not ProjectUnit.Choice(s,MtWarning) then  Abort   //оменяем закрытия окна
  else
  //если событие о сохранения текущего процесса истинна
  if ProjectUnit.EventSaveProject(MainForm.OpenDialog.FileName) then
  begin
    //перерисуем все активные графики и оси
    if MainUnit.MainForm.series4.Active then  ExitDataUnit.TraceUserFunction;
    if MainUnit.MainForm.series1.Active then  ExitDataUnit.TraceLagrange;
    if MainUnit.MainForm.series5.Active then  ExitDataUnit.TraceGeneralizingLagrange;
    if MainUnit.MainForm.series6.Active then ExitDataUnit.TraceGeneralizingLagrangeII;
    if MainUnit.MainForm.series7.Active or MainUnit.MainForm.series9.Active
    then ExitDataUnit.TraceErrorLagrage(UsersFunction,NodeInterPolation);
    if MainUnit.MainForm.series8.Active or MainUnit.MainForm.series10.Active
    then ExitDataUnit.TraceErrorGeneralizing(MainForm.TranslateFunction.Text,UsersFunction,
      NodeInterPolationGeneral);
    if MainUnit.MainForm.series12.Active or MainUnit.MainForm.series13.Active
    then ExitDataUnit.TraceErrorGeneralizingII(MainForm.TranslateFunction.Text,UsersFunction,
      NodeInterPolationGeneral);
    if MainUnit.MainForm.PanelInformation.Visible
    then   MainUnit.MainForm.CheckBoxViewGeneralizingFunctionClick(Sender);

    // обновление размера экран
    ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
    //обновление выделенных функции
    MainUnit.MainForm.CheckDistinctionSeriesClick(Sender);
    //обновление рисованных оси
    MainUnit.MainForm.DrawAxisXClick(Sender);

  end;
end;

procedure TSettingForm.FormCreate(Sender: TObject);
begin
  // активация нажатия на сочетании клавиш
  KeyPreview := True;
  //установка значений по умолчаню
  RoundValueChange(Sender);
end;

//обрабочик  нажатии на сочетании клавиш
procedure TSettingForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //сочетание сохранения проекта
  if (ssCtrl in Shift) and (Key in [Ord('S'), Ord('s')]) then
  begin
     MainUnit.MainForm.SaveProjectClick(Sender);
     exit;
  end;

  //сочетание создания итоговый отчёт
  if ((ssCtrl in Shift) and (ssShift in Shift)) and (Key in [Ord('R'), Ord('r')]) then
  begin
     MainUnit.MainForm.ReportClick(Sender);
     exit;
  end;

  //сочетание создания времменый отчёт
  if (ssCtrl in Shift) and (Key in [Ord('R'), Ord('r')]) then
  begin
     MainUnit.MainForm.SendToReportClick(Sender);
     exit;
  end;
  //сочетание выхода ESC
  if Key = VK_ESCAPE then
    SettingForm.Close;
end;

//// автоматический запуск справочной системы при нажатии на кнопку F1
procedure TSettingForm.HelpMessage(var msg: TWMHelp);
begin
  HelpUnit.WMHelp(msg,Menu,PopupMenu);
end;

//обрабочик установка временных ограничениий на текушем время
procedure TSettingForm.ResetDateTimeClick(Sender: TObject);
begin
   SettingForm.DatePickerTo.Date:=Now;
   SettingForm.TimePickerTo.Time:=Now;
end;

//обрабочик ораничения ввода данных в редактированных полях
//установка значение и перенос курсора
procedure TSettingForm.RoundValueKeyPress(Sender: TObject; var Key: Char);
begin
  if SettingForm.ChooseLanguage.Focused then key:=#0;
  //рабочий экран  выводные данных
  if SettingForm.AxisXLeftValue.Focused then
  begin
    if Key=#13 then
    begin
      ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
      MainUnit.MainForm.DrawAxisXClick(Sender);
      SettingForm.AxisXRightValue.setfocus;
    end;
    If not (Key in['0'..'9','.','-',#08]) then key:=#0;
  end;
  if SettingForm.AxisXRightValue.Focused then
  begin
    if Key=#13 then
    begin
      ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
      MainUnit.MainForm.DrawAxisXClick(Sender);
      SettingForm.AxisYLeftValue.setfocus;
    end;
    If not (Key in['0'..'9','.','-',#08]) then key:=#0;
  end;
  if SettingForm.AxisYLeftValue.Focused then
  begin
    if Key=#13 then
    begin
      ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
      MainUnit.MainForm.DrawAxisXClick(Sender);
      SettingForm.AxisYRightValue.setfocus;
    end;
    If not (Key in['0'..'9','.','-',#08]) then key:=#0;
  end;
  if SettingForm.AxisYRightValue.Focused then
  begin
    if Key=#13 then
    begin
      ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
      MainUnit.MainForm.DrawAxisXClick(Sender);
      SettingForm.MargeX.setfocus;
    end;
    If not (Key in['0'..'9','.','-',#08]) then key:=#0;
  end;
  //отпуска экрана
  if SettingForm.MargeX.Focused then
  begin
    if Key=#13 then
    begin
      ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
      MainUnit.MainForm.DrawAxisXClick(Sender);
      SettingForm.MargeY.setfocus;
    end;
    If ((length(SettingForm.MargeX.Text)=0) and (not (Key in['1'..'9',#08])))
        or ( (length(SettingForm.MargeX.Text)>0) and (not (Key in['0'..'9',#08])) )
    then key:=#0;
  end;
  if SettingForm.MargeY.Focused then
  begin
    if Key=#13 then
    begin
      ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
      MainUnit.MainForm.DrawAxisXClick(Sender);
      SettingForm.PenWidthNotDistincted.setfocus;
    end;
    If ((length(SettingForm.MargeY.Text)=0) and (not (Key in['1'..'9',#08])))
        or ( (length(SettingForm.MargeY.Text)>0) and (not (Key in['0'..'9',#08])) )
    then key:=#0;
  end;

  if SettingForm.PenWidthNotDistincted.Focused then
  begin
    if Key=#13 then
    begin
      MainUnit.MainForm.CheckDistinctionSeriesClick(Sender);
      SettingForm.PenWidthDistincted.setfocus;
    end;
    If ((length(SettingForm.PenWidthNotDistincted.Text)=0) and (not (Key in['1'..'9',#08])))
        or ( (length(SettingForm.PenWidthNotDistincted.Text)>0) and (not (Key in['0'..'9',#08])) )
    then key:=#0;
  end;

  if SettingForm.PenWidthDistincted.Focused then
  begin
    if Key=#13 then
    begin
      MainUnit.MainForm.CheckDistinctionSeriesClick(Sender);
    end;
    If ((length(SettingForm.PenWidthDistincted.Text)=0) and (not (Key in['1'..'9',#08])))
        or ( (length(SettingForm.PenWidthDistincted.Text)>0) and (not (Key in['0'..'9',#08])) )
    then key:=#0;
  end;

  //округления
  if SettingForm.RoundValue.Focused then
  begin
    if Key=#13 then SettingForm.Precision.setfocus;
    If not (Key in['0'..'9',#08]) then key:=#0;
  end;
  //точность
  if SettingForm.Precision.Focused then
  begin
    if Key=#13 then SettingForm.StepTraceUsersAnalytiqueFunction.setfocus;
    If not (Key in['0'..'9','.',#08]) then key:=#0;
  end;

  //ВВод данных
  if SettingForm.StepTraceUsersAnalytiqueFunction.Focused then
  begin
    if Key=#13 then
    begin
      if MainUnit.MainForm.series5.Count<>0 then MainUnit.MainForm.TraceUsersAnalytiqueFunctionClick(Sender);
      SettingForm.StepTraceLagrangeAndGeneralizingFunction.setfocus;
    end;
    If ((length(SettingForm.StepTraceUsersAnalytiqueFunction.Text)=0) and (not (Key in['1'..'9',#08])))
        or ( (length(SettingForm.StepTraceUsersAnalytiqueFunction.Text)>0) and (not (Key in['0'..'9',#08])) )
    then key:=#0;
  end;
  if SettingForm.StepTraceLagrangeAndGeneralizingFunction.Focused then
  begin
    if Key=#13 then
    begin
      if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked then MainUnit.MainForm.CheckBoxLagrangeFunctionClick(Sender);
      if MainUnit.MainForm.CheckBoxGeneralizingFunction.Checked then MainUnit.MainForm.CheckBoxGeneralizingFunctionClick(Sender);
      SettingForm.StepTraceErrorFunction.setfocus;
    end;
    If ((length(SettingForm.StepTraceLagrangeAndGeneralizingFunction.Text)=0) and (not (Key in['1'..'9',#08])))
        or ( (length(SettingForm.StepTraceLagrangeAndGeneralizingFunction.Text)>0) and (not (Key in['0'..'9',#08])) )
    then key:=#0;
  end;
  if SettingForm.StepTraceErrorFunction.Focused then
  begin
    if Key=#13 then
    begin
      if MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Checked then MainUnit.MainForm.CheckBoxErrorLagrangeFunctionClick(Sender);
      if MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Checked then MainUnit.MainForm.CheckBoxErrorGeneralizingFunctionClick(Sender);
    end;
    If ((length(SettingForm.StepTraceErrorFunction.Text)=0) and (not (Key in['1'..'9',#08])))
        or ( (length(SettingForm.StepTraceErrorFunction.Text)>0) and (not (Key in['0'..'9',#08])) )
    then key:=#0;
  end;

  //дата и время отчета
  if SettingForm.DatePickerFrom.Focused then
  begin
    if Key=#13 then SettingForm.TimePickerFrom.setfocus;
    If not (Key in['0'..'9','/',#08]) then key:=#0;
  end;
  if SettingForm.TimePickerFrom.Focused then
  begin
    if Key=#13 then SettingForm.DatePickerTo.setfocus;
    If not (Key in['0'..'9',':',#08]) then key:=#0;
  end;
  if SettingForm.DatePickerTo.Focused then
  begin
    if Key=#13 then SettingForm.TimePickerTo.setfocus;
    If not (Key in['0'..'9','/',#08]) then key:=#0;
  end;
  if SettingForm.TimePickerTo.Focused then
  begin
    //if Key=#13 then SettingForm.TimePickerTo.setfocus;
    If not (Key in['0'..'9',':',#08]) then key:=#0;
  end;
  //архив
  if SettingForm.depthofhistory.Focused then
  begin
    if Key=#13 then
    begin
      HistoryUnit.ReloadHistoryTranslate;
    end;
    If (not (Key in['0'..'9',#08]))
    then key:=#0;
  end;
end;

// установка значений по умолчанию
procedure TSettingForm.SetDefaultSettingClick(Sender: TObject);
begin
  ChooseLanguage.ItemIndex:=0;
  SettingForm.ChooseLanguageChange(Sender);
  SettingForm.RoundValue.Text:='4';
  SettingForm.Precision.Text:='0.1';
  SettingForm.AxisXLeftValue.Text:='-5';
  SettingForm.AxisXRightValue.Text:='5';
  SettingForm.AxisYLeftValue.Text:='-5';
  SettingForm.AxisYRightValue.Text:='5';
  SettingForm.MargeX.Text:='100';
  SettingForm.MargeY.Text:='100';
  SettingForm.PenWidthNotDistincted.Text:='2';
  SettingForm.PenWidthDistincted.Text:='4';
  SettingForm.StepTraceUsersAnalytiqueFunction.Text:='1000';
  SettingForm.StepTraceLagrangeAndGeneralizingFunction.Text:='1000';
  SettingForm.StepTraceErrorFunction.Text:='1000';
  SettingForm.depthofhistory.Text:='1000';
  SettingForm.ActiveEnterDataWithFunction.Checked:=true;
  SettingForm.ActiveEnterDataWithFunction.Checked:=true;
  SettingForm.ActiveGraphe.Checked:=true;
  SettingForm.ActiveGraphUserFunction.Checked:=true;
  SettingForm.ActiveGraphLagrange.Checked:=true;
  SettingForm.ActiveGraphGeneralisedLagrange.Checked:=true;
  SettingForm.ActiveGraphGeneralisedLagrangeII.Checked:=true;
  SettingForm.ActiveGraphLagrangeError.Checked:=true;
  SettingForm.ActiveGraphGeneralisedLagrangeError.Checked:=true;
  SettingForm.ActiveGraphGeneralisedLagrangeErrorII.Checked:=true;
  SettingForm.ActiveGraphControlFunction.Checked:=true;

  SettingForm.ActiveEnterDataPoints.Checked:=true;
  SettingForm.ActiveControlFunction.Checked:=true;
  SettingForm.ActiveTableValueTracedUsersAnalytiqueFunction.Checked:=False;
  SettingForm.ActiveTableValueTracedLaGrangeFunction.Checked:=False;
  SettingForm.ActiveTableValueTracedGeneralizingFunction.Checked:=False;
  SettingForm.ActiveTableValueTracedGeneralizingFunctionII.Checked:=False;

  RoundValueChange(Sender);
  SettingForm.Withoutrestriction.Checked:=true;
end;

//обработчик при изменении значений в редактируемых полях
procedure TSettingForm.RoundValueChange(Sender: TObject);
begin
  try
    if (SettingForm.RoundValue.Text<>'') and (strtoInt(SettingForm.RoundValue.Text)>0)
      and (strtoInt(SettingForm.RoundValue.Text)<10)
    then TypeUnit.SRoundValue:=strtoint(SettingForm.RoundValue.Text)
    else
    begin
      TypeUnit.SRoundValue:=4;
    end;
  Except
    TypeUnit.SRoundValue:=4;
  end;
  try
    if (SettingForm.Precision.Text<>'')  and (strtofloat(SettingForm.Precision.Text)>0)
      and (strtofloat(SettingForm.Precision.Text)<1)
    then TypeUnit.SPrecision:=strtofloat(SettingForm.Precision.Text)
    else
    begin
      TypeUnit.SPrecision:=0.1;
    end;
  Except
    TypeUnit.SPrecision:=0.1;
  end;
  try
    if (SettingForm.AxisXLeftValue.Text<>'') and (SettingForm.AxisXLeftValue.Text<>'-')
    then TypeUnit.SAxisXLeftValueInterval:=Roundto(strtofloat(SettingForm.AxisXLeftValue.Text),-TypeUnit.SRoundValue)
    else
    begin
      TypeUnit.SAxisXLeftValueInterval:=-5;
    end;
  Except
    TypeUnit.SAxisXLeftValueInterval:=-5;
  end;
  try
    if (SettingForm.AxisXRightValue.Text<>'')  and (SettingForm.AxisXRightValue.Text<>'-')
    then TypeUnit.SAxisXRightValueInterval:=Roundto(strtofloat(SettingForm.AxisXRightValue.Text),-TypeUnit.SRoundValue)
    else
    begin
      TypeUnit.SAxisXRightValueInterval:=5;
    end;
  Except
    TypeUnit.SAxisXRightValueInterval:=5;
  end;
  try
    if (SettingForm.AxisYLeftValue.Text<>'') and (SettingForm.AxisYLeftValue.Text<>'-')
    then TypeUnit.SAxisYLeftValueInterval:=Roundto(strtofloat(SettingForm.AxisYLeftValue.Text),-TypeUnit.SRoundValue)
    else
    begin
      TypeUnit.SAxisYLeftValueInterval:=-5;
    end;
  Except
    TypeUnit.SAxisYLeftValueInterval:=-5;
  end;
  try
    if (SettingForm.AxisYRightValue.Text<>'')  and (SettingForm.AxisYRightValue.Text<>'-')
    then TypeUnit.SAxisYRightValueInterval:=Roundto(strtofloat(SettingForm.AxisYRightValue.Text),-TypeUnit.SRoundValue)
    else
    begin
      TypeUnit.SAxisYRightValueInterval:=5;
    end;
  Except
    TypeUnit.SAxisYRightValueInterval:=5;
  end;
  try
    if (SettingForm.MargeX.Text<>'')  and (SettingForm.MargeX.Text<>'-') and (strtoInt(SettingForm.MargeX.Text)<=100) and (strtoInt(SettingForm.MargeX.Text)>0)
    then TypeUnit.SMargeX:=strtoInt(SettingForm.MargeX.Text)
    else
    begin
      TypeUnit.SMargeX:=100;
    end;
  Except
    TypeUnit.SMargeX:=100;
  end;
  try
    if (SettingForm.MargeY.Text<>'')  and (SettingForm.MargeY.Text<>'-') and (strtoInt(SettingForm.MargeY.Text)<=100) and (strtoInt(SettingForm.MargeY.Text)>0)
    then TypeUnit.SMargeY:=strtoInt(SettingForm.MargeY.Text)
    else
    begin
      TypeUnit.SMargeY:=100;
    end;
  Except
    TypeUnit.SMargeY:=100;
  end;

  try
    if (SettingForm.PenWidthNotDistincted.Text<>'')  and (SettingForm.PenWidthNotDistincted.Text<>'-')
      and (strtoInt(SettingForm.PenWidthNotDistincted.Text)<=10) and (strtoInt(SettingForm.PenWidthNotDistincted.Text)>0)
    then TypeUnit.SPenWIdthNotDistincted:=strtoInt(SettingForm.PenWidthNotDistincted.Text)
    else
    begin
      TypeUnit.SPenWIdthNotDistincted:=2;
    end;
  Except
    TypeUnit.SPenWIdthNotDistincted:=2;
  end;

  try
    if (SettingForm.PenWidthDistincted.Text<>'')  and (SettingForm.PenWidthDistincted.Text<>'-')
      and (strtoInt(SettingForm.PenWidthNotDistincted.Text)<=10) and (strtoInt(SettingForm.PenWidthDistincted.Text)>0)
    then TypeUnit.SPenWidthDistincted:=strtoInt(SettingForm.PenWidthDistincted.Text)
    else
    begin
      TypeUnit.SPenWidthDistincted:=4;
    end;
  Except
    TypeUnit.SPenWidthDistincted:=4;
  end;

  TypeUnit.SActiveEnterDataWithFunction:=SettingForm.ActiveEnterDataWithFunction.Checked;
  TypeUnit.SActiveExitDataFormules:=SettingForm.ActiveEnterDataWithFunction.Checked;
  TypeUnit.SActiveGraphe:=SettingForm.ActiveGraphe.Checked;
  if SettingForm.ActiveGraphe.Checked
  then SettingForm.GroupActiveGraph.Visible:=True
  else SettingForm.GroupActiveGraph.Visible:=False;

  TypeUnit.SActiveGraphUserFunctin:=SettingForm.ActiveGraphUserFunction.Checked;
  TypeUnit.SActiveGraphLagrange:=SettingForm.ActiveGraphLagrange.Checked;
  TypeUnit.SActiveGraphGeneralised:=SettingForm.ActiveGraphGeneralisedLagrange.Checked;
  TypeUnit.SActiveGraphGeneralisedII:=SettingForm.ActiveGraphGeneralisedLagrangeII.Checked;
  TypeUnit.SActiveGraphLagrangeError:=SettingForm.ActiveGraphLagrangeError.Checked;
  TypeUnit.SActiveGraphGeneralisedError:=SettingForm.ActiveGraphGeneralisedLagrangeError.Checked;
  TypeUnit.SActiveGraphGeneralisedErrorII:=SettingForm.ActiveGraphGeneralisedLagrangeErrorII.Checked;
  TypeUnit.SActiveControlFunction:=SettingForm.ActiveGraphControlFunction.Checked;

  TypeUnit.SActiveEnterDataPoints:=SettingForm.ActiveEnterDataPoints.Checked;
  TypeUnit.SActiveControlFunction:=SettingForm.ActiveControlFunction.Checked;
  TypeUnit.SActiveTableValueTracedUsersAnalytiqueFunction:=SettingForm.ActiveTableValueTracedUsersAnalytiqueFunction.Checked;
  TypeUnit.SActiveTableValueTracedLaGrangeFunction:=SettingForm.ActiveTableValueTracedLaGrangeFunction.Checked;
  TypeUnit.SActiveTableValueTracedGeneralizingFunction:=SettingForm.ActiveTableValueTracedGeneralizingFunction.Checked;
  TypeUnit.SActiveTableValueTracedGeneralizingFunctionII:=SettingForm.ActiveTableValueTracedGeneralizingFunctionII.Checked;

  TypeUnit.SDateFrom:=SettingForm.DatePickerFrom.Date;
  TypeUnit.STimeFrom:=SettingForm.TimePickerFrom.Time;
  TypeUnit.SDateTo:=SettingForm.DatePickerTo.Date;
  TypeUnit.STimeTo:=SettingForm.TimePickerTo.Time;


  try
    if (SettingForm.StepTraceUsersAnalytiqueFunction.Text<>'') and (strtoInt(SettingForm.StepTraceUsersAnalytiqueFunction.Text)>0)
    then TypeUnit.SStepTraceUsersAnalytiqueFunction:=strtoint(SettingForm.StepTraceUsersAnalytiqueFunction.Text)
    else TypeUnit.SStepTraceUsersAnalytiqueFunction:=1000;
  Except
    TypeUnit.SStepTraceUsersAnalytiqueFunction:=1000;
  end;
  try
    if (SettingForm.StepTraceLagrangeAndGeneralizingFunction.Text<>'') and (strtoInt(SettingForm.StepTraceLagrangeAndGeneralizingFunction.Text)>0)
    then TypeUnit.SStepTraceLagrangeAndGeneralizingFunction:=strtoint(SettingForm.StepTraceLagrangeAndGeneralizingFunction.Text)
    else TypeUnit.SStepTraceLagrangeAndGeneralizingFunction:=1000;
  Except
    TypeUnit.SStepTraceLagrangeAndGeneralizingFunction:=1000;
  end;
  try
    if (SettingForm.StepTraceErrorFunction.Text<>'') and (strtoInt(SettingForm.StepTraceErrorFunction.Text)>0)
    then TypeUnit.SStepTraceErrorFunction:=strtoint(SettingForm.StepTraceErrorFunction.Text)
    else TypeUnit.SStepTraceErrorFunction:=1000;
  Except
    TypeUnit.SStepTraceErrorFunction:=1000;
  end;

  try
    if (SettingForm.depthofhistory.Text<>'') and (strtoInt(SettingForm.depthofhistory.Text)>=0)
    then TypeUnit.Sdepthofhistory:=strtoint(SettingForm.depthofhistory.Text)
    else TypeUnit.Sdepthofhistory:=1000;
  Except
    TypeUnit.Sdepthofhistory:=1000;
  end;
end;

//обработчик счётчика временных
procedure TSettingForm.TimerTimer(Sender: TObject);
begin
  SettingForm.ResetDateTimeClick(Sender);
end;

//обработчик временных ограничений при создание итогового отчёта
procedure TSettingForm.WithoutrestrictionClick(Sender: TObject);
begin
  SettingForm.DatePickerFrom.Date:=TypeUnit.DateTimeCreateProject;
  SettingForm.TimePickerFrom.Time:=TypeUnit.DateTimeCreateProject;
  if SettingForm.Withoutrestriction.Checked
  then
  begin
    SettingForm.DateTimeReport.Enabled:=False;
    SettingForm.Timer.Enabled:=True;
    SettingForm.DateTimeReport.Visible:=false;
  end
  else
  begin
    SettingForm.DateTimeReport.Enabled:=True;
    SettingForm.ResetDateTimeClick(Sender);
    SettingForm.DateTimeReport.Visible:=true;
    SettingForm.Timer.Enabled:=False;
  end;
  RoundValueChange(Sender);
  SettingUnit.SettingForm.ChooseLanguageChange(Sender);
end;

end.
