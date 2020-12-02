unit ShowTranslateFunctionUnit;

interface

//используемые библиотеки
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart,bcParser,XPMan, StdCtrls;

  //определние типов компонентов
type
  TTranslateFunctionForm = class(TForm)
    Chart1: TChart;     //компонент отображения графики
    Series1: TFastLineSeries;  //график структурообразующей функции
    Series2: TLineSeries; //ось Х
    Series3: TLineSeries; //ось Y
    //обрабочик при активации окна
    procedure FormActivate(Sender: TObject);
    // обрабочик сочитания клавиши
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    //обрабочик при создании окна
    procedure FormCreate(Sender: TObject);
    //обрбочик при нажатии на подписи графиков
    procedure Chart1ClickLegend(Sender: TCustomChart; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { скрытые объявления обрабочиков  }
    //обрбочик отображения справочной системы
    procedure HelpMessage(var msg:TWMHelp); message WM_HELP;
  public
    { публичные объявления обрабочиков }
    //обрабочик отображения структурообразующей функции
    Function ViewTranslateFunction:boolean;
  end;

var
//объявление глобальных переменнов
  TranslateFunctionForm: TTranslateFunctionForm;
  bcp: TbcParser; //переменый для синтаксичемного анализатор

implementation

{$R *.dfm}

{ TForm1 }

//используемые модулы
uses exitDataUnit,MainUnit,TypeUnit, ProjectUnit, HelpUnit;
//объявление глобальных переменнов
var b,b1:boolean;
    m:real;

    //обрабочик при создании окна отображения структурообразующих функций
procedure TTranslateFunctionForm.FormCreate(Sender: TObject);
begin
// активация нажатия на сочетании клавиш
  KeyPreview := True;
   //инициализация графики
  TranslateFunctionForm.series2.Clear;
  TranslateFunctionForm.series2.Active:=false;
  TranslateFunctionForm.series3.Clear;
  TranslateFunctionForm.series3.Active:=false;
  m:=0;
end;

//обрабочик нажатии сочетании клавиш
procedure TTranslateFunctionForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE
  then TranslateFunctionForm.Close;
end;


// обрабочик запуска руководства оператора
procedure TTranslateFunctionForm.HelpMessage(var msg: TWMHelp);
begin
// запускаем руководства оператора
  HelpUnit.WMHelp(msg,Menu,PopupMenu);
end;

//обрабочик отображения сруктурообразующих функции
Function TTranslateFunctionForm.ViewTranslateFunction:boolean;
var x,max,valuey,h: Real;
begin
  b:=false;
  result:=true;
  try
    //создаем аналитический анализатор для расчет анналитическую функцию
    try
      if ShowTranslateFunctionUnit.bcp = nil
      then ShowTranslateFunctionUnit.bcp := TbcParser.Create(TranslateFunctionForm)
      else
      begin
        ShowTranslateFunctionUnit.bcp.Destroy;
        ShowTranslateFunctionUnit.bcp := TbcParser.Create(TranslateFunctionForm);
      end;
    Except
      result:=False;
    end;
    //передаем выражение для анализа
    ShowTranslateFunctionUnit.bcp.Expression := MainUnit.MainForm.TranslateFunction.Text;
    //очистим функцию
    ShowTranslateFunctionUnit.TranslateFunctionForm.Series1.Clear;
    //установка начальные значения для рисования
    x := TypeUnit.SAxisXLeftValueInterval;
    max := TypeUnit.SAxisXRightValueInterval;
    h:=(max-x)/(TypeUnit.SStepTraceUsersAnalytiqueFunction*(TypeUnit.SStepTraceUsersAnalytiqueFunction/10));

    while x <= max  do
    begin
      //передаем значение х для расчета
      ShowTranslateFunctionUnit.bcp.X := x;
      try //попытаем вычисленное значение
        valuey:= ShowTranslateFunctionUnit.bcp.Value;
      except
      // при возникновения ошибка деления на нуль
        on EInvalidOp do
          begin
            x := x+h;
            //увеичаем значение интервала на h
            max:=max+h;
            m:=max;
            b:=true;
            //пропустим ошибку
            Continue;
          end
        else
        begin
          result:=false;
          raise;
          exit;
        end;
      end;
      //рисуем функцию
      ShowTranslateFunctionUnit.TranslateFunctionForm.series1.AddXY(x,valuey);
      x := x+h;
    end;
  Except
    raise;
    result:=false;
  end;
end;

//обрбочик рисования оси
Function DrawAxis:boolean;
begin
  //установим ширину  пера
  TranslateFunctionForm.series2.Pen.Width:=TypeUnit.SPenWIdthNotDistincted;
  TranslateFunctionForm.Series3.Pen.Width:=TypeUnit.SPenWIdthNotDistincted;
  // отчистка
  TranslateFunctionForm.Series3.Clear;
  TranslateFunctionForm.Series2.Clear;

  //рисование оси
  TranslateFunctionForm.series2.AddXY(TranslateFunctionForm.Chart1.BottomAxis.Minimum,0);
  TranslateFunctionForm.series2.AddXY(0,0);
  TranslateFunctionForm.series2.AddXY(TranslateFunctionForm.Chart1.BottomAxis.Maximum,0);
  //активация оси
  TranslateFunctionForm.series2.Active:=true;
 //рисование оси
  TranslateFunctionForm.Series3.AddXY(0,TranslateFunctionForm.Chart1.LeftAxis.Minimum);
  TranslateFunctionForm.Series3.AddXY(0,0);
  TranslateFunctionForm.Series3.AddXY(0,TranslateFunctionForm.Chart1.LeftAxis.Maximum);
  //активация оси
  TranslateFunctionForm.Series3.Active:=true;

  result:=true;
end;

procedure TTranslateFunctionForm.Chart1ClickLegend(Sender: TCustomChart;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //активация график структурообразующей функции
   TranslateFunctionForm.Series1.Active:=true;
end;

procedure TTranslateFunctionForm.FormActivate(Sender: TObject);
var w:real;
    s,s1:string;
begin
  //инициализация значения
  ShowTranslateFunctionUnit.TranslateFunctionForm.Caption:=ProjectUnit.NameProject+' ['+MainForm.TranslateFunction.EditLabel.Caption+'] ';
  ShowTranslateFunctionUnit.TranslateFunctionForm.Series1.Title:=MainForm.TranslateFunction.EditLabel.Caption;
  ShowTranslateFunctionUnit.TranslateFunctionForm.Series1.Pen.Width:=TypeUnit.SPenWIdthNotDistincted;
  ShowTranslateFunctionUnit.TranslateFunctionForm.Series1.Repaint;
  TranslateFunctionForm.Chart1.Title.Text.Clear;
  TranslateFunctionForm.Chart1.Title.Font.Color:=clRed;
  TranslateFunctionForm.Chart1.SubTitle.Text.Clear;
  TranslateFunctionForm.Chart1.SubTitle.Font.Color:=clRed;
  TranslateFunctionForm.Chart1.BottomAxis.SetMinMax(Series1.XValues.MinValue,Series1.XValues.MaxValue);
  TranslateFunctionForm.Chart1.LeftAxis.SetMinMax(Series1.YValues.MinValue,Series1.YValues.MaxValue);

  //проверка использования заданной структурообразующей функции для интерполирования по 2 ому виду обобщёного полинома Лагранжа
  try  //попытаем вычислить функцию в точке х=0
    b1:=true;
    w:=exitDataUnit.CalculStringFunction(MainUnit.MainForm.TranslateFunction.Text,0);
  except
    b1:=false;
  end;
  case TypeUnit.SChooseLanguage of
    1:  if b1
        then s:='if x = 0 then '+MainUnit.MainForm.TranslateFunction.Text + '=' +
          floattostr(w)
        else s:='if x = 0 then '+MainUnit.MainForm.TranslateFunction.Text + '=' +
        'unknown';

    0:  if b1
        then s:='Если x = 0, то '+MainUnit.MainForm.TranslateFunction.Text + '=' +
          floattostr(w)
        else s:='Если x = 0, то '+MainUnit.MainForm.TranslateFunction.Text + '=' +
          'не известно';
  end;
  TranslateFunctionForm.Chart1.SubTitle.Text.Add(s);
  if w=0
  then TranslateFunctionForm.Chart1.SubTitle.Font.Color:=clBlue;
  //проверка использования заданной структурообразующей функции для интерполирования по 1 ому виду обобщёного полинома Лагранжа
  if  not b
  then
  begin
    case TypeUnit.SChooseLanguage of
      1: TranslateFunctionForm.Chart1.Title.Text.Add('Interval ['+
        Floattostr(TypeUnit.SAxisXLeftValueInterval)+' ; '+
        Floattostr(TypeUnit.SAxisXRightValueInterval)  +']');
      0: TranslateFunctionForm.Chart1.Title.Text.Add('Функция подходить для интервала ['+
        Floattostr(TypeUnit.SAxisXLeftValueInterval)+' ; '+
        Floattostr(TypeUnit.SAxisXRightValueInterval)  +']');
    end;
    TranslateFunctionForm.Chart1.Title.Font.Color:=clBlue;
    TranslateFunctionForm.Chart1.BottomAxis.SetMinMax(SAxisXLeftValueInterval,SAxisXRightValueInterval);
    TranslateFunctionForm.Chart1.LeftAxis.SetMinMax(Series1.YValues.MinValue,Series1.YValues.MaxValue);
  end
  else
    case TypeUnit.SChooseLanguage of
      1: TranslateFunctionForm.Chart1.Title.Text.Add('Do not use function in interval ['+
        Floattostr(TypeUnit.SAxisXLeftValueInterval)+' ; '+
        Floattostr(TypeUnit.SAxisXRightValueInterval)  +']');
      0: TranslateFunctionForm.Chart1.Title.Text.Add('Функция не подходить для интервала ['+
        Floattostr(TypeUnit.SAxisXLeftValueInterval)+' ; '+
        Floattostr(TypeUnit.SAxisXRightValueInterval)  +']');
    end;
  //рисование оси
   DrawAxis;
end;

end.
