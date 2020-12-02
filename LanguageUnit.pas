unit LanguageUnit;

interface

uses SysUtils,Forms,Windows;

type
  TypeDlb= array [0..11] of record
              French,English,Russian:string;
          end;

Const NameGraphEnglish : array[1..9] of string =
                                (
                                  'General', 'UserFunction' ,'Lagrange', 'Generalised Lagrange I',
                                  'Generalised Lagrange II','Lagrange Error','Generalised Lagrange Error',
                                  'Generalised Lagrange Error II','Verification Function'
                                ) ;
      NameGraphRussian : array[1..9] of string =
                                (
                                  'Рабочий График', 'Пользовательская функция' ,'Лагранж',
                                  'Первый вид обобщённой функции Лагранжа','Второй вид обобщённой функции Лагранжа',
                                  'Функция ошибки Лагранжа','Обобщённая Функция ошибки Лагранжа первого вида',
                                  'Обобщённая Функция ошибки Лагранжа второго вида','Проверочная функция'
                                ) ;
      ValueGraph: array[1..9] of integer  = (0, 5 ,1,4,6,7,8,12,11);

      DialogButton: TypeDlb=( (French: '&Oui';English: 'Yes';Russian: 'Да'),
                              (French: '&Non';English: 'No';Russian: 'Нет'),
                              (French: 'Ok';English: 'Ok';Russian: 'Oк'),
                              (French: 'Annuler';English: 'Cancel';Russian: 'Отмена'),
                              (French: 'A&bandonner';English: 'Abort';Russian: 'Прервать'),
                              (French: '&Retenter';English: 'Retry';Russian: 'Повторить'),
                              (French: '&Ignorer';English: 'Ignore';Russian: 'Пропустить'),
                              (French: '&Tous';English: 'All';Russian: 'Все'),
                              (French: 'Non &pour tout';English: 'No to All';Russian: 'Нет для всех'),
                              (French: 'O&ui pour tout';English: 'Yes to All';Russian: 'Да для всех'),
                              (French: '&Aide';English: 'Help';Russian: 'Помочь'),
                              (French: '&Fermer';English: 'Close';Russian: 'Закрыть')
                            );

Function SetLanguage(Language:string):boolean;

implementation

uses TypeUnit,MainUnit,SettingUnit,ProjectUnit;
const tab = Chr(9);
      Newline = Chr(13)+Chr(10);

function SetEnglish:Boolean;
var v:integer;
begin
  Result:=True;
  try
    // создаем и Изменяем имени служебные файлы

    if (not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'ConfigurationFile'))
      and (not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'Конфигурационные файлы'))
    then CreateDir(ExtractFilePath( Application.ExeName ) +'Конфигурационные файлы');
    if not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'ExampleFile')
      and (not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'Примеры'))
    then CreateDir(ExtractFilePath( Application.ExeName ) +'Примеры');
    if not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'ReportFile')
      and (not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'Отчеты'))
    then CreateDir(ExtractFilePath( Application.ExeName ) +'Отчеты');

    RenameFile(ExtractFilePath( Application.ExeName ) +'Конфигурационные файлы',ExtractFilePath( Application.ExeName ) +'ConfigurationFile');
    RenameFile(ExtractFilePath( Application.ExeName ) +'Примеры',ExtractFilePath( Application.ExeName ) +'ExampleFile');
    RenameFile(ExtractFilePath( Application.ExeName ) +'Отчеты',ExtractFilePath( Application.ExeName ) +'ReportFile');

    if SysUtils.FileExists(ExtractFilePath( Application.ExeName )
      +'ConfigurationFile\Новый Проект.bsc')
    then SysUtils.RenameFile(ExtractFilePath( Application.ExeName )
      +'ConfigurationFile\Новый Проект.bsc',ExtractFilePath( Application.ExeName )
      +'ConfigurationFile\New Project.bsc');

    if lowercase(TypeUnit.linkProject)=lowercase('Новый Проект') then TypeUnit.linkProject:='New Project'
    else
      if not (lowercase(TypeUnit.linkProject)=lowercase('New Project'))
      then TypeUnit.linkProject:=ExtractFilePath( Application.ExeName ) +'ExampleFile\'+ExtractFileName(TypeUnit.linkProject);
    //Изменяем главный интерфейс
    MainUnit.MainForm.Caption:=ProjectUnit.NameProject+' ['+TypeUnit.linkProject+']';
    MainUnit.MainForm.OpenDialog.FileName:= TypeUnit.linkProject;


    MainUnit.MainForm.Project.Caption:='Project';
    MainUnit.MainForm.NewProject.Caption:='New Project'+ tab + tab + tab + tab + ' CTRL+N';
    MainUnit.MainForm.LoadProject.Caption:='Load Project'+ tab + tab + tab + tab + ' CTRL+O';
    MainUnit.MainForm.SaveProject.Caption:='Save Project'+ tab + tab + tab + tab + ' CTRL+S';
    MainUnit.MainForm.SaveProjectAs.Caption:='Save Project As'+ tab + tab + tab + tab + ' CTRL+SHIFT+S';
    MainUnit.MainForm.ExitProject.Caption:='Exit Project '+ tab + tab + tab + tab + ' ALT+F4';
    MainUnit.MainForm.Setting.Caption:='Setting';
    MainUnit.MainForm.Report.Caption:='Report';
    MainUnit.MainForm.SendToReport.Caption:='Send To Report';
    MainUnit.MainForm.Help.Caption:='Help';
    if MainUnit.MainForm.EnterData.Checked
    then MainUnit.MainForm.EnterData.Caption:='Disable Enter Data'
    else MainUnit.MainForm.EnterData.Caption:='Enable Enter Data';
    if MainUnit.MainForm.ExitData.Checked
    then MainUnit.MainForm.ExitData.Caption:='Disable Exit Data'
    else MainUnit.MainForm.ExitData.Caption:='Enable Exit Data';
    if MainUnit.MainForm.VerificationConstruction.Checked
    then MainUnit.MainForm.VerificationConstruction.Caption:='Disable Verification Construction'
    else MainUnit.MainForm.VerificationConstruction.Caption:='Enable Verification Construction';
    if MainUnit.MainForm.ZoomAndScale.Checked
    then MainUnit.MainForm.ZoomAndScale.Caption:='Disable Zoom and Shift'
    else MainUnit.MainForm.ZoomAndScale.Caption:='Enable Zoom and Shift';
    {if MainUnit.MainForm.MakeExperience.Checked
    then MainUnit.MainForm.MakeExperience.Caption:='Disable Experiences'
    else MainUnit.MainForm.MakeExperience.Caption:='Enable Experiences'; }
    MainUnit.MainForm.Series1.Title:='Lagrange';
    MainUnit.MainForm.Series2.Title:='Choosed Point';
    MainUnit.MainForm.Series3.Title:='Not Choosed Point';
    MainUnit.MainForm.Series4.Title:='User Function';
    MainUnit.MainForm.Series5.Title:='Generalized Function I';
    MainUnit.MainForm.Series6.Title:='Generalized Function II';
    MainUnit.MainForm.Series7.Title:='Error Lagrange Function';
    MainUnit.MainForm.Series8.Title:='Error Generalized Function I';
    MainUnit.MainForm.Series9.Title:='Error Lagrange Points';
    MainUnit.MainForm.Series10.Title:='Error Generalizing Points I';
    MainUnit.MainForm.Series11.Title:='Verification Function';
    MainUnit.MainForm.Series11.Title:='Error Generalized Function II';
    MainUnit.MainForm.Series12.Title:='Error Generalizing Points II';
    MainUnit.MainForm.Series13.Title:='Axis X';
    MainUnit.MainForm.Series14.Title:='Axis Y';

    MainUnit.MainForm.StringGrid1.Cells[0,1]:='X';
    MainUnit.MainForm.StringGrid1.Cells[0,2]:='Y';
    MainUnit.MainForm.StringGrid1.Cells[0,3]:='Choosen';

    MainUnit.MainForm.PanelEnterData.Caption:='Enter Data';
    MainUnit.MainForm.ViewTranslateFunction.Caption:='View Translate Function';
    MainUnit.MainForm.ActiveEnterDataWithPoints.Caption:='Use Coordinate';
    MainUnit.MainForm.ActiveEnterDataWithFunction.Caption:='Use Function';
    MainUnit.MainForm.TranslateFunction.EditLabel.Caption:='Translate Function';
    MainUnit.MainForm.PanelEnterDataWithPoints.Caption:='Enter Data using Coordinate';
    MainUnit.MainForm.ActiveEnterDatawithMouse.Caption:='Enter Data using mouse';
    MainUnit.MainForm.AddPoint.Caption:='Add';
    MainUnit.MainForm.AbscissX.EditLabel.Caption:='Abscissa X';
    MainUnit.MainForm.OrdinateY.EditLabel.Caption:='Ordinate Y';
    if MainUnit.MainForm.ActiveMovingAddPoint.Checked
    then MainUnit.MainForm.ActiveMovingAddPoint.Caption:='Disable Moving Addеd Point'
    else MainUnit.MainForm.ActiveMovingAddPoint.Caption:='Enable Moving Addеd Point';
    MainUnit.MainForm.PointChoosen.Caption:='Choosen';
    MainUnit.MainForm.ModifyPoint.Caption:='Modify';
    MainUnit.MainForm.RemovePoint.Caption:='Remove';
    MainUnit.MainForm.PanelEnterDataWithFunction.Caption:='Enter Data using Function';
    MainUnit.MainForm.IntervalA.EditLabel.Caption:='Left Interval';
    MainUnit.MainForm.TraceUsersAnalytiqueFunction.Caption:='Trace';
    MainUnit.MainForm.ClearUsersAnalytiqueFunction.Caption:='Clear';
    MainUnit.MainForm.AddPointWithFunction.Caption:='Add Point using Function';
    MainUnit.MainForm.IntervalB.EditLabel.Caption:='Right Interval';
    MainUnit.MainForm.UsersAnalytiqueFunction.EditLabel.Caption:='Function';

    MainUnit.MainForm.PanelVerificationConstruction.Caption:='Verification Construction';

    MainUnit.MainForm.PanelExitData.Caption:='Exit Data';
    MainUnit.MainForm.PanelZoom.Caption:='';
    MainUnit.MainForm.PanelInformation.Caption:='Information';
    //MainUnit.MainForm.MemoInformation.EditLabel.Caption:='Enter Data';
    //MainUnit.MainForm.ActiveScale.Caption:='Active Shift';
    MainUnit.MainForm.PZoom.Caption:='Zoom';
    MainUnit.MainForm.PZoom.Items[0]:='Normal';
    MainUnit.MainForm.PZoom.Items[1]:='Horizontal';
    MainUnit.MainForm.PZoom.Items[2]:='Vertical';
    MainUnit.MainForm.LaGrange.Caption:='Lagrange';
    MainUnit.MainForm.GeneralizingLagrange.Caption:='Generalized Lagrange';
    MainUnit.MainForm.GeneralizingLagrangeI.Caption:='I (g(x)-g(x0))';
    MainUnit.MainForm.GeneralizingLagrangeI.Caption:='II (g(x-x0))';
    if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked
    then MainUnit.MainForm.CheckBoxLagrangeFunction.Caption:='Disable Lagrange'
    else MainUnit.MainForm.CheckBoxLagrangeFunction.Caption:='Enable Lagrange ';
    if MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Checked
    then MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Caption:='Disable Lagrange Error'
    else MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Caption:='Enable Lagrange Error';
    if MainUnit.MainForm.CheckBoxGeneralizingFunction.Checked
    then MainUnit.MainForm.CheckBoxGeneralizingFunction.Caption:='Disable Generalized'
    else MainUnit.MainForm.CheckBoxGeneralizingFunction.Caption:='Enable Generalized';
    if MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Checked
    then MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Caption:='Disable Generalized Error'
    else MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Caption:='Enable Generalized Error';
    MainUnit.MainForm.LagrangeAccuracy.EditLabel.Caption:='Accuracy';
    MainUnit.MainForm.GeneralisedAccuracy.EditLabel.Caption:='Accuracy';
    if MainUnit.MainForm.CheckboxGeneralizingFunctionII.Checked
    then MainUnit.MainForm.CheckboxGeneralizingFunctionII.Caption:='Disable Generalized II'
    else MainUnit.MainForm.CheckboxGeneralizingFunctionII.Caption:='Enable Generalized II';
    if MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Checked
    then MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Caption:='Disable Generalized Error II'
    else MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Caption:='Enable Generalized Error II';
    MainUnit.MainForm.GeneralisedAccuracyII.EditLabel.Caption:='Accuracy';

    if MainUnit.MainForm.ViewNode.Checked
    then MainUnit.MainForm.ViewNode.Caption:='Mask Nodes'
    else MainUnit.MainForm.ViewNode.Caption:='View Nodes';
    MainUnit.MainForm.ClearControlFunction.Caption:='Clear';
    MainUnit.MainForm.TraceControlFunction.Caption:='Trace';
    MainUnit.MainForm.ControlFunction.EditLabel.Caption:='Control Function';
    MainUnit.MainForm.GenerateFunction.Caption:='Generate';
    MainUnit.MainForm.PanelViewFormule.Caption:='Formules';
    if MainUnit.MainForm.CheckBoxViewLagrangeFunction.Checked
    then MainUnit.MainForm.CheckBoxViewLagrangeFunction.Caption:='Mask Lagrange'
    else MainUnit.MainForm.CheckBoxViewLagrangeFunction.Caption:='View Lagrange';
    if MainUnit.MainForm.CheckBoxViewGeneralizingFunction.Checked
    then MainUnit.MainForm.CheckBoxViewGeneralizingFunction.Caption:='Mask Generalized I'
    else MainUnit.MainForm.CheckBoxViewGeneralizingFunction.Caption:='View Generalized I';
    if MainUnit.MainForm.CheckBoxViewGeneralizingFunctionII.Checked
    then MainUnit.MainForm.CheckBoxViewGeneralizingFunctionII.Caption:='Mask Generalized II'
    else MainUnit.MainForm.CheckBoxViewGeneralizingFunctionII.Caption:='View Generalized II';
    MainUnit.MainForm.ResetZoomAndScale.Caption:='Reset';
    MainUnit.MainForm.ResizeChart.Caption:='Resize Chart';

    TypeUnit.PanelDistinction.Caption:='Panel Distinction Area Function';
    TypeUnit.CheckDistinction[0].Caption:='No One';
    TypeUnit.CheckDistinction[1].Caption:='Lagrange';
    TypeUnit.CheckDistinction[2].Caption:='Choosed Point';
    TypeUnit.CheckDistinction[3].Caption:='Not Choosed Point';
    TypeUnit.CheckDistinction[4].Caption:='Generalized FunctionI';
    TypeUnit.CheckDistinction[5].Caption:='User Function';
    TypeUnit.CheckDistinction[6].Caption:='Generalized Function II';
    TypeUnit.CheckDistinction[7].Caption:='Error Lagrange Function';
    TypeUnit.CheckDistinction[8].Caption:='Error Generalized Function I';
    TypeUnit.CheckDistinction[9].Caption:='Error Lagrange Points';
    TypeUnit.CheckDistinction[10].Caption:='Error Generalizing Points';
    TypeUnit.CheckDistinction[11].Caption:='Verification function';
    TypeUnit.CheckDistinction[12].Caption:='Error Generalized Function II';
    TypeUnit.CheckDistinction[13].Caption:='Error Generalizing Points II';


    MainUnit.MainForm.ClearAllData.Caption:='Clear All In Project';
    MainUnit.MainForm.ClearAllPoints.Caption:='Delete All Points';
    MainUnit.MainForm.SetValueInsetting.Caption:='Set Actual Resized Ecran';
    if MainUnit.MainForm.DrawAxisX.Checked
    then MainUnit.MainForm.DrawAxisX.Caption:='Mask Axis X'
    else MainUnit.MainForm.DrawAxisX.Caption:='View Axis X';
    if MainUnit.MainForm.DrawAxisY.Checked
    then MainUnit.MainForm.DrawAxisY.Caption:='Mask Axis Y'
    else MainUnit.MainForm.DrawAxisY.Caption:='Draw Axis Y';
    if MainUnit.MainForm.DistinctionWithResize.Checked
    then MainUnit.MainForm.DistinctionWithResize.Caption:='Without resize'
    else MainUnit.MainForm.DistinctionWithResize.Caption:='With resize';
    v:=MainUnit.MainForm.HideFunction.ItemIndex;
    MainUnit.MainForm.HideFunction.Items[0]:='Show All';
    MainUnit.MainForm.HideFunction.Items[1]:='Show Selected Function';
    MainUnit.MainForm.HideFunction.Items[2]:='Hidden Selected Function';
    //MainUnit.MainForm.HideFunction.Items[3]:='Hidden All';
    MainUnit.MainForm.HideFunction.ItemIndex:=v;

    MainUnit.MainForm.HistoryPanel.Caption:='History Panel';
    if MainUnit.MainForm.ActiveSelectMultiple.Checked
    then MainUnit.MainForm.ActiveSelectMultiple.Caption:='Disable MultiSelect'
    else MainUnit.MainForm.ActiveSelectMultiple.Caption:='Enable MultiSelect';
    MainUnit.MainForm.ClearHistoryTranslate.Caption:='Clear All';
    MainUnit.MainForm.DeleteChoosedHistory.Caption:='Delete Selected History';

    MainUnit.MainForm.NameLabel.Caption:='Avg Time (ms)';

    MainUnit.MainForm.Delta.EditLabel.Caption:='Delta';



    //Извменяем интерфейс Натройки
    SettingUnit.SettingForm.Caption:=ProjectUnit.NameProject+'[Setting]';
    //SettingUnit.SettingForm.ChooseLanguage.Text:='ChooseLanguage';
    SettingUnit.SettingForm.ChooseLanguage.Items[0]:='Russian';
    SettingUnit.SettingForm.ChooseLanguage.Items[1]:='English';
    SettingUnit.SettingForm.ChooseLanguage.Text:='English';
    SettingUnit.SettingForm.Language.Caption:='Language';
    SettingUnit.SettingForm.Report.Caption:='Insert Report';
    SettingUnit.SettingForm.EnterData.Caption:='Enter Data';
    SettingUnit.SettingForm.ExitData.Caption:='Exit Data';
    SettingUnit.SettingForm.AxisX.Caption:='Axis X';
    SettingUnit.SettingForm.AxisXLeftValue.EditLabel.Caption:='Min';
    SettingUnit.SettingForm.AxisXRightValue.EditLabel.Caption:='Max';
    SettingUnit.SettingForm.AxisX.Caption:='Axis Y';
    SettingUnit.SettingForm.AxisYLeftValue.EditLabel.Caption:='Min';
    SettingUnit.SettingForm.AxisYRightValue.EditLabel.Caption:='Max';
    SettingUnit.SettingForm.Distinction.Caption:='Pen Distinction';
    SettingUnit.SettingForm.PenWidthDistincted.EditLabel.Caption:='Distincted';
    SettingUnit.SettingForm.PenWidthNotDistincted.EditLabel.Caption:='NotDistincted';
    SettingUnit.SettingForm.RoundValue.EditLabel.Caption:='Rounding Value';
    SettingUnit.SettingForm.Precision.EditLabel.Caption:='Precision';
    SettingUnit.SettingForm.ActiveEnterDataWithFunction.Caption:='Interval, Original Function, Translate Function';
    SettingUnit.SettingForm.ActiveExitDataFormules.Caption:='Exit Data Formules';
    SettingUnit.SettingForm.ActiveGraphe.Caption:='Graphics Ecran';
    SettingUnit.SettingForm.GroupActiveGraph.Caption:='Active Details Graphics';
    SettingUnit.SettingForm.ActiveGraphUserFunction.Caption:='User Function Graphic';
    SettingUnit.SettingForm.ActiveGraphLagrange.Caption:='Lagrange Function Graphic';
    SettingUnit.SettingForm.ActiveGraphGeneralisedLagrange.Caption:='Generalized Lagrange Function Graphic';
    SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeII.Caption:='Generalized Lagrange Function Graphic II';
    SettingUnit.SettingForm.ActiveGraphLagrangeError.Caption:='Lagrange Function Error Graphic';
    SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeError.Caption:='Generalized Lagrange Function Error Graphic';
    SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeErrorII.Caption:='Generalized Lagrange Function Error GraphicII';
    SettingUnit.SettingForm.ActiveGraphControlFunction.Caption:='Control Function Graphic';
    SettingUnit.SettingForm.PanelMarge.Caption:='Marge';
    SettingUnit.SettingForm.MargeX.EditLabel.Caption:='X (Percent)';
    SettingUnit.SettingForm.MargeY.EditLabel.Caption:='Y (Percent)';

    SettingUnit.SettingForm.StepTraceUsersAnalytiqueFunction.EditLabel.Caption:='Step User Function';
    SettingUnit.SettingForm.StepTraceLagrangeAndGeneralizingFunction.EditLabel.Caption:='Step Lagrange And Generalized Functions';
    SettingUnit.SettingForm.StepTraceErrorFunction.EditLabel.Caption:='Step Trace Error';
    SettingUnit.SettingForm.ActiveEnterDataPoints.Caption:='Value Points Interpolation';
    SettingUnit.SettingForm.ActiveControlFunction.Caption:='Formule Control Function';
    SettingUnit.SettingForm.ActiveTableValueTracedUsersAnalytiqueFunction.Caption:='Table Value User Function';
    SettingUnit.SettingForm.ActiveTableValueTracedLaGrangeFunction.Caption:='Table Value Lagrange';
    SettingUnit.SettingForm.ActiveTableValueTracedGeneralizingFunction.Caption:='Table Value Generalizing I';
    SettingUnit.SettingForm.ActiveTableValueTracedGeneralizingFunctionII.Caption:='Table Value Generalizing II';
    SettingUnit.SettingForm.CreateReportPanel.Caption:='Create Report';
    if SettingUnit.SettingForm.Withoutrestriction.Checked
    then SettingUnit.SettingForm.Withoutrestriction.Caption:='With restriction'
    else SettingUnit.SettingForm.Withoutrestriction.Caption:='Without restriction';
    SettingUnit.SettingForm.DateTimeReport.Caption:='Set Restriction Time';
    SettingUnit.SettingForm.LabelFrom.Caption:='From';
    SettingUnit.SettingForm.LabelTo.Caption:='To';
    SettingUnit.SettingForm.ResetDateTime.Caption:='Reset' ;
    SettingUnit.SettingForm.SetDefaultSetting.Caption:=' Set Default Setting ';

    SettingUnit.SettingForm.HistoryPanel.Caption:='History Panel';
    SettingUnit.SettingForm.depthofhistory.EditLabel.Caption:='Depth of translate function history';


    //Изменяем интерфейс справка
    {AboutUnit.AboutForm.Caption:='Lagrange And Generalised Lagrange Viewer [About]';
    AboutUnit.AboutForm.PanelHelp.Caption:='Help';
    AboutUnit.AboutForm.PanelAuthor.Caption:='About Author';}
    //AboutUnit.AboutForm.InformationHelph.Caption:='';
  Except
    result:=False;
  end;
end;

Function SetRussian:Boolean;
var v:integer;
begin
  result:=True;
  try
    if (not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'ConfigurationFile'))
      and (not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'Конфигурационные файлы'))
    then CreateDir(ExtractFilePath( Application.ExeName ) +'ConfigurationFile');
    if not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'ExampleFile')
      and (not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'Примеры'))
    then CreateDir(ExtractFilePath( Application.ExeName ) +'ExampleFile');
    if not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'ReportFile')
      and (not SysUtils.DirectoryExists(ExtractFilePath( Application.ExeName ) +'Отчеты'))
    then CreateDir(ExtractFilePath( Application.ExeName ) +'ReportFile');

    if SysUtils.FileExists(ExtractFilePath( Application.ExeName )
      +'ConfigurationFile\New Project.bsc')
    then SysUtils.RenameFile(ExtractFilePath( Application.ExeName )
      +'ConfigurationFile\New Project.bsc',ExtractFilePath( Application.ExeName )
      +'ConfigurationFile\Новый Проект.bsc');

    //Изменяем имени служебные файлы
    RenameFile(ExtractFilePath( Application.ExeName ) +'ConfigurationFile',ExtractFilePath( Application.ExeName ) +'Конфигурационные файлы');
    RenameFile(ExtractFilePath( Application.ExeName ) +'ExampleFile',ExtractFilePath( Application.ExeName ) +'Примеры');
    RenameFile(ExtractFilePath( Application.ExeName ) +'ReportFile',ExtractFilePath( Application.ExeName ) +'Отчеты');

    //Изменяем главный интерфейс

    if lowercase(TypeUnit.linkProject)=lowercase('New Project') then TypeUnit.linkProject:='Новый Проект'
    else
      if not (lowercase(TypeUnit.linkProject)=lowercase('Новый Проект'))
      then  TypeUnit.linkProject:=ExtractFilePath( Application.ExeName ) +'Примеры\'+ExtractFileName(TypeUnit.linkProject);

    MainUnit.MainForm.Caption:=ProjectUnit.NameProject+' ['+TypeUnit.linkProject+']';
    MainUnit.MainForm.OpenDialog.FileName:= TypeUnit.linkProject;
    MainUnit.MainForm.Project.Caption:='Проект';
    MainUnit.MainForm.NewProject.Caption:=   'Новый проект'+ tab + tab + tab + tab + ' CTRL+N';
    MainUnit.MainForm.LoadProject.Caption:=  'Загрузить проект'+ tab + tab + tab + tab + ' CTRL+O';
    MainUnit.MainForm.SaveProject.Caption:=  'Сохранить проект'+ tab + tab + tab + tab + ' CTRL+S';
    MainUnit.MainForm.SaveProjectAs.Caption:='Сохранить проект rак'+ tab + tab + tab + tab + ' CTRL+SHIFT+S';
    MainUnit.MainForm.ExitProject.Caption:='Выход из программы'+ tab + tab + tab + tab + ' ALT+F4';
    MainUnit.MainForm.Setting.Caption:='Настройка';
    MainUnit.MainForm.Report.Caption:='Создать итоговый отчёт';
    MainUnit.MainForm.SendToReport.Caption:='Отправить в отчёт';
    MainUnit.MainForm.Help.Caption:='Руководство пользователя';
    if MainUnit.MainForm.EnterData.Checked
    then MainUnit.MainForm.EnterData.Caption:='Отключить ввод данных'
    else MainUnit.MainForm.EnterData.Caption:='Подключить ввод данных';
    if MainUnit.MainForm.ExitData.Checked
    then MainUnit.MainForm.ExitData.Caption:='Отключить вывод данных'
    else MainUnit.MainForm.ExitData.Caption:='Подключить вывод данных';
    if MainUnit.MainForm.VerificationConstruction.Checked
    then MainUnit.MainForm.VerificationConstruction.Caption:='Отключить проверку построения'
    else MainUnit.MainForm.VerificationConstruction.Caption:='Подключить проверку построения';
    if MainUnit.MainForm.ZoomAndScale.Checked
    then MainUnit.MainForm.ZoomAndScale.Caption:='Отключить зум и сдвиг'
    else MainUnit.MainForm.ZoomAndScale.Caption:='Подключить зум и сдвиг';
    {if MainUnit.MainForm.ZoomAndScale.Checked
    then MainUnit.MainForm.ZoomAndScale.Caption:='Отключить Эксперименты'
    else MainUnit.MainForm.MakeExperience.Caption:='Включить Эксперименты';}
    MainUnit.MainForm.Series1.Title:='функция Лагранжа';
    MainUnit.MainForm.Series2.Title:='Выбранные точки';
    MainUnit.MainForm.Series3.Title:='Невыбранные точки';
    MainUnit.MainForm.Series4.Title:='Пользователькая функция';
    MainUnit.MainForm.Series5.Title:='I Обобщённая функция';
    MainUnit.MainForm.Series6.Title:='II Обобщённая функция';
    MainUnit.MainForm.Series7.Title:='функция ошибки Лагранжа';
    MainUnit.MainForm.Series8.Title:='I Обобщённая функция ошибки';
    MainUnit.MainForm.Series9.Title:='Точечная функция ошибки Лагранжа';
    MainUnit.MainForm.Series10.Title:='I Точечная обобщённая ф-ция ошибки';
    MainUnit.MainForm.Series11.Title:='Проверочная функция';
    MainUnit.MainForm.Series12.Title:='II Обобщённая функция ошибки';
    MainUnit.MainForm.Series13.Title:='II Точечная обобщённая ф-ция ошибки';
    MainUnit.MainForm.Series14.Title:='Ось X';
    MainUnit.MainForm.Series15.Title:='Ось Y';

    MainUnit.MainForm.StringGrid1.Cells[0,1]:='X';
    MainUnit.MainForm.StringGrid1.Cells[0,2]:='Y';
    MainUnit.MainForm.StringGrid1.Cells[0,3]:='Выбран';

    MainUnit.MainForm.PanelEnterData.Caption:='Ввод Данных';
    MainUnit.MainForm.ViewTranslateFunction.Caption:='Посмотреть cтруктурообразуюшую';
    MainUnit.MainForm.ActiveEnterDataWithPoints.Caption:='Задание координаты';
    MainUnit.MainForm.ActiveEnterDataWithFunction.Caption:='Задание функции';
    if MainUnit.MainForm.ActiveEnterDatawithMouse.Checked
    then MainUnit.MainForm.ActiveEnterDatawithMouse.Caption:='Задание координаты мышкой'
    else MainUnit.MainForm.ActiveEnterDatawithMouse.Caption:='Cдвиг экрана';
    MainUnit.MainForm.TranslateFunction.EditLabel.Caption:='Структурообразуюшая';
    MainUnit.MainForm.PanelEnterDataWithPoints.Caption:='Параметры точки';
    MainUnit.MainForm.AddPoint.Caption:='Добавить';
    MainUnit.MainForm.AbscissX.EditLabel.Caption:='Абсцисса X';
    MainUnit.MainForm.OrdinateY.EditLabel.Caption:='Ордината Y';
    if MainUnit.MainForm.ActiveMovingAddPoint.Checked
    then MainUnit.MainForm.ActiveMovingAddPoint.Caption:='Отключить перемещение точки'
    else MainUnit.MainForm.ActiveMovingAddPoint.Caption:='Подключить перемещение точки';
    MainUnit.MainForm.PointChoosen.Caption:='Выбран';
    MainUnit.MainForm.ModifyPoint.Caption:='Изменить';
    MainUnit.MainForm.RemovePoint.Caption:='Удалить';
    MainUnit.MainForm.PanelEnterDataWithFunction.Caption:='Параметры функции';
    MainUnit.MainForm.IntervalA.EditLabel.Caption:='Левая граница';
    MainUnit.MainForm.TraceUsersAnalytiqueFunction.Caption:='Построить';
    MainUnit.MainForm.ClearUsersAnalytiqueFunction.Caption:='Удалить';
    MainUnit.MainForm.AddPointWithFunction.Caption:='Добавление точки функции';
    MainUnit.MainForm.IntervalB.EditLabel.Caption:='Правая граница';
    MainUnit.MainForm.UsersAnalytiqueFunction.EditLabel.Caption:='Функция';

    MainUnit.MainForm.PanelVerificationConstruction.Caption:='Проверка построения';


    MainUnit.MainForm.PanelExitData.Caption:='Вывод данных';
    MainUnit.MainForm.PanelZoom.Caption:='';
    MainUnit.MainForm.PanelInformation.Caption:='Информация';
    //MainUnit.MainForm.MemoInformation.EditLabel.Caption:='Enter Data';
    //MainUnit.MainForm.ActiveScale.Caption:='Cдвиг экрана';
    MainUnit.MainForm.PZoom.Caption:='Зум';
    MainUnit.MainForm.PZoom.Items[0]:='Обычный';
    MainUnit.MainForm.PZoom.Items[1]:='Горизонтальный';
    MainUnit.MainForm.PZoom.Items[2]:='Вертикальный';
    MainUnit.MainForm.LaGrange.Caption:='Лагранж';
    MainUnit.MainForm.GeneralizingLagrange.Caption:='Обобщённые функции Лагранжа';
    MainUnit.MainForm.GeneralizingLagrangeI.Caption:='Первый вид';
    MainUnit.MainForm.GeneralizingLagrangeII.Caption:='Второй вид';

    if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked
    then MainUnit.MainForm.CheckBoxLagrangeFunction.Caption:='Скрыть Лагранж'
    else MainUnit.MainForm.CheckBoxLagrangeFunction.Caption:='Построить Лагранж';
    if MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Checked
    then MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Caption:='Скрыть функцию ошибки'
    else MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Caption:='Построить Функцию ошибки';
    if MainUnit.MainForm.CheckBoxGeneralizingFunction.Checked
    then MainUnit.MainForm.CheckBoxGeneralizingFunction.Caption:='Скрыть обобщённую'
    else MainUnit.MainForm.CheckBoxGeneralizingFunction.Caption:='Построить обобщённую';
    if MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Checked
    then MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Caption:='Скрыть функцию ошибки'
    else MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Caption:='Построить функцию ошибки';
    MainUnit.MainForm.LagrangeAccuracy.EditLabel.Caption:='Погрешность';
    MainUnit.MainForm.GeneralisedAccuracy.EditLabel.Caption:='Погрешность';
    if MainUnit.MainForm.CheckboxGeneralizingFunctionII.Checked
    then MainUnit.MainForm.CheckboxGeneralizingFunctionII.Caption:='Скрыть обобщённую'
    else MainUnit.MainForm.CheckboxGeneralizingFunctionII.Caption:='Построить обобщённую';
    if MainUnit.MainForm.CheckboxErrorGeneralizingFunctionII.Checked
    then MainUnit.MainForm.CheckboxErrorGeneralizingFunctionII.Caption:='Скрыть функцию ошибки'
    else MainUnit.MainForm.CheckboxErrorGeneralizingFunctionII.Caption:='Построить функцию ошибки';
    MainUnit.MainForm.GeneralisedAccuracyII.EditLabel.Caption:='Погрешность';
    if MainUnit.MainForm.ViewNode.Checked
    then MainUnit.MainForm.ViewNode.Caption:='Скрыть узлы'
    else MainUnit.MainForm.ViewNode.Caption:='Показать узлы';
    MainUnit.MainForm.ClearControlFunction.Caption:='Удалить';
    MainUnit.MainForm.TraceControlFunction.Caption:='Построить';
    MainUnit.MainForm.ControlFunction.EditLabel.Caption:='Функция проверки';
    MainUnit.MainForm.GenerateFunction.Caption:='Генерация';
    
    MainUnit.MainForm.PanelViewFormule.Caption:='Формулы';
    if MainUnit.MainForm.CheckBoxViewLagrangeFunction.Checked
    then MainUnit.MainForm.CheckBoxViewLagrangeFunction.Caption:='Скрыть Лагранж'
    else MainUnit.MainForm.CheckBoxViewLagrangeFunction.Caption:='Показать Лагранж';
    if MainUnit.MainForm.CheckBoxViewGeneralizingFunction.Checked
    then MainUnit.MainForm.CheckBoxViewGeneralizingFunction.Caption:='Скрыть обобщённую I'
    else MainUnit.MainForm.CheckBoxViewGeneralizingFunction.Caption:='Показать обобщённую I';
    if MainUnit.MainForm.CheckBoxViewGeneralizingFunctionII.Checked
    then MainUnit.MainForm.CheckBoxViewGeneralizingFunctionII.Caption:='Скрыть обобщённую II'
    else MainUnit.MainForm.CheckBoxViewGeneralizingFunctionII.Caption:='Показать обобщённую II';
    MainUnit.MainForm.ResetZoomAndScale.Caption:='Сбросить';
    MainUnit.MainForm.ResizeChart.Caption:='Восстановить экран';

    TypeUnit.PanelDistinction.Caption:= 'Выделение Функций';
    TypeUnit.CheckDistinction[0].Caption:= 'Ни одной';
    TypeUnit.CheckDistinction[1].Caption:='функция Лагранжа';
    TypeUnit.CheckDistinction[2].Caption:='Выбранные точки';
    TypeUnit.CheckDistinction[3].Caption:='Не выбранные точки';
    TypeUnit.CheckDistinction[4].Caption:='I Обобщённая функция';
    TypeUnit.CheckDistinction[5].Caption:='Пользователькая функция';
    TypeUnit.CheckDistinction[6].Caption:='II Обобщённая функция';
    TypeUnit.CheckDistinction[7].Caption:='функция ошибки Лагранжа';
    TypeUnit.CheckDistinction[8].Caption:='I Обобщённая функция ошибки';
    TypeUnit.CheckDistinction[9].Caption:='Точечная функция ошибки Лагранжа';
    TypeUnit.CheckDistinction[10].Caption:='I Точечная обобщённая ф-ция ошибки';
    TypeUnit.CheckDistinction[11].Caption:='Проверочная функция';
    TypeUnit.CheckDistinction[12].Caption:='II Обобщённая функция ошибки';
    TypeUnit.CheckDistinction[13].Caption:='II Точечная обобщённая ф-ция ошибки';

    MainUnit.MainForm.ClearAllData.Caption:='Сбросить всё';
    MainUnit.MainForm.ClearAllPoints.Caption:='Удалить все точки';
    MainUnit.MainForm.SetValueInsetting.Caption:='Зафиксировать текущий размер экрана';
    if MainUnit.MainForm.DistinctionWithResize.Checked
    then MainUnit.MainForm.DistinctionWithResize.Caption:='без изменении размера экрана под функции'
    else MainUnit.MainForm.DistinctionWithResize.Caption:='с изменением размера экрана под функции';
    if MainUnit.MainForm.DrawAxisX.Checked
    then MainUnit.MainForm.DrawAxisX.Caption:='Скрыть Ось X'
    else MainUnit.MainForm.DrawAxisX.Caption:='Показать Ось X';
    if MainUnit.MainForm.DrawAxisY.Checked
    then MainUnit.MainForm.DrawAxisY.Caption:='Скрыть Ось Y'
    else MainUnit.MainForm.DrawAxisY.Caption:='Показать Ось Y';
    v:=MainUnit.MainForm.HideFunction.ItemIndex;
    MainUnit.MainForm.HideFunction.Items[0]:='Показать всё';
    MainUnit.MainForm.HideFunction.Items[1]:='Показать выбранные функции';
    MainUnit.MainForm.HideFunction.Items[2]:='Скрыть выбранные функции';
    //MainUnit.MainForm.HideFunction.Items[3]:='Скрыть все';
    MainUnit.MainForm.HideFunction.ItemIndex:=v;

    MainUnit.MainForm.HistoryPanel.Caption:='История использованных структурообразующих функций';
    if MainUnit.MainForm.ActiveSelectMultiple.Checked
    then MainUnit.MainForm.ActiveSelectMultiple.Caption:='Выделить группу'
    else MainUnit.MainForm.ActiveSelectMultiple.Caption:='Выделить группу';
    MainUnit.MainForm.ClearHistoryTranslate.Caption:='Удалить всю историю';
    MainUnit.MainForm.DeleteChoosedHistory.Caption:='Удалить выбранные функции';

    MainUnit.MainForm.NameLabel.Caption:='Временные оценки (мс)';

    MainUnit.MainForm.Delta.EditLabel.Caption:='Шаг';

    //Извменяем интерфейс Натройки
    if SettingUnit.SettingForm.Visible then
    begin
      SettingUnit.SettingForm.Caption:=ProjectUnit.NameProject+'[Настройка]';
      //SettingUnit.SettingForm.ChooseLanguage.Text:='Выбрать Язык';
      SettingUnit.SettingForm.ChooseLanguage.Items[0]:='Русский';
      SettingUnit.SettingForm.ChooseLanguage.Items[1]:='Английский';
      SettingUnit.SettingForm.ChooseLanguage.ItemIndex:=TypeUnit.SChooseLanguage;
      SettingUnit.SettingForm.Language.Caption:='Язык';
      SettingUnit.SettingForm.Report.Caption:='Включить в временном отчёте';
      SettingUnit.SettingForm.EnterData.Caption:='Вводные данные';
      SettingUnit.SettingForm.ExitData.Caption:='Выводные данные';
      SettingUnit.SettingForm.AxisX.Caption:='Ось X';
      SettingUnit.SettingForm.AxisXLeftValue.EditLabel.Caption:='Мин';
      SettingUnit.SettingForm.AxisXRightValue.EditLabel.Caption:='Мах';
      SettingUnit.SettingForm.AxisY.Caption:='Ось Y';
      SettingUnit.SettingForm.AxisYLeftValue.EditLabel.Caption:='Мин';
      SettingUnit.SettingForm.AxisYRightValue.EditLabel.Caption:='Мах';
      SettingUnit.SettingForm.Distinction.Caption:='Толщина выделения';
      SettingUnit.SettingForm.PenWidthDistincted.EditLabel.Caption:='Толщина выделенных';
      SettingUnit.SettingForm.PenWidthNotDistincted.EditLabel.Caption:='Толщина не выделенных';
      SettingUnit.SettingForm.RoundValue.EditLabel.Caption:='Значение округления';
      SettingUnit.SettingForm.Precision.EditLabel.Caption:='Точность';
      SettingUnit.SettingForm.ActiveEnterDataWithFunction.Caption:='Интервал, исходная функция, структурообразующая';
      SettingUnit.SettingForm.ActiveExitDataFormules.Caption:='Выводные формулы';
      SettingUnit.SettingForm.ActiveGraphe.Caption:='Графика экрана';
      SettingUnit.SettingForm.GroupActiveGraph.Caption:='Включить дополнительные графики';
      SettingUnit.SettingForm.ActiveGraphUserFunction.Caption:='Пользовательская функция';
      SettingUnit.SettingForm.ActiveGraphLagrange.Caption:='Функция Лагража';
      SettingUnit.SettingForm.ActiveGraphGeneralisedLagrange.Caption:='Обобщённая Функция Лагража I вида';
      SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeII.Caption:='Обобщённая Функция Лагража II вида';
      SettingUnit.SettingForm.ActiveGraphLagrangeError.Caption:='Функция ошибки Лагража';
      SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeError.Caption:='Обобщённая Функция ошибки Лагража I вида';
      SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeErrorII.Caption:='Обобщённая Функция ошибки Лагража II вида';
      SettingUnit.SettingForm.ActiveGraphControlFunction.Caption:='Проверочная функция';
      SettingUnit.SettingForm.PanelMarge.Caption:='Поля изображения графиков';
      SettingUnit.SettingForm.MargeX.EditLabel.Caption:='по X (процент)';
      SettingUnit.SettingForm.MargeY.EditLabel.Caption:='по Y (процент)';
      SettingUnit.SettingForm.StepTraceUsersAnalytiqueFunction.EditLabel.Caption:='Шаг построения пользовательской функции';
      SettingUnit.SettingForm.StepTraceLagrangeAndGeneralizingFunction.EditLabel.Caption:='Шаг построения Лагранжа и её обобщённых';
      SettingUnit.SettingForm.StepTraceErrorFunction.EditLabel.Caption:='Шаг построения функций ошибок';
      SettingUnit.SettingForm.ActiveEnterDataPoints.Caption:='Значение узлов интерполяции';
      SettingUnit.SettingForm.ActiveControlFunction.Caption:='Формула проверочной функции';
      SettingUnit.SettingForm.ActiveTableValueTracedUsersAnalytiqueFunction.Caption:='Табл. значений пользовательской функции';
      SettingUnit.SettingForm.ActiveTableValueTracedLaGrangeFunction.Caption:='Табл. значений Лагранжа';
      SettingUnit.SettingForm.ActiveTableValueTracedGeneralizingFunction.Caption:='Табл. значений  первого вида обобщённой';
      SettingUnit.SettingForm.ActiveTableValueTracedGeneralizingFunctionII.Caption:='Табл. значений  второго вида обобщённой';
      SettingUnit.SettingForm.CreateReportPanel.Caption:='Создать итоговый отчёт';
      if SettingUnit.SettingForm.Withoutrestriction.Checked
      then SettingUnit.SettingForm.Withoutrestriction.Caption:='С временными ограничениями'
      else SettingUnit.SettingForm.Withoutrestriction.Caption:='Без временных ограничений';
      SettingUnit.SettingForm.DateTimeReport.Caption:='Установка временных ограничений';
      SettingUnit.SettingForm.LabelFrom.Caption:='От';
      SettingUnit.SettingForm.LabelTo.Caption:='До';
      SettingUnit.SettingForm.ResetDateTime.Caption:='Сбросить';
      SettingUnit.SettingForm.SetDefaultSetting.Caption:='Настройка по умолчанию';

      SettingUnit.SettingForm.HistoryPanel.Caption:='История использованных структурообразующих функций';
      SettingUnit.SettingForm.depthofhistory.EditLabel.Caption:='Глубина истории';

    end;
  Except
    result:=False;
  end;
end;

Function SetLanguage(Language:string):boolean;
begin
  result:=false;
  if (Language='English') or (Language='Английский') then
  begin
    result:=SetEnglish;
  end
  else if (Language='Russian') or (Language='Русский') then
  begin
    result:=SetRussian;
  end;
end;

end.
