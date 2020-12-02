unit EnterDataUnit;

interface

//используемые библиотеки  и модули
uses
  SysUtils,TypeUnit,series,Dialogs,Grids,bcParser;

type TPublicStringGrid = class(TCustomGrid); // тип класса необходимо для удаление столбец в stringgrid

////******************Обработка вводимого узлы пользователью *******///
    //инициализируем таблица узлов
    procedure init(var F:TUsersFunction);
    //искать если заданная значение точка есть в таблице точек с заданное приближение
    procedure search(Value: TUserFunc;var F:TUsersFunction;var Pos:Integer;Delta:Real=0.01);
    procedure SortData(var F:TUsersFunction);   //соортировка таблица точек
    //добавление точки
    Function AddPoint:Boolean;
    //удаление точки
    Function DeletePoint:boolean;
    //изменение точки
    Function ModifyPoint:boolean;
     //добавление точки с использованием функции
    Function AddPointUsingFunction(Delta:Real=0):Boolean;
    //удаление все точки
    Function DeleteAllPoints:boolean;
    //отключение панели ввода
    Function DesactiveEnterDataPanel(Sender: TObject):boolean;
    //отключение панели узлов
    Function DesactivePanelPoints(Sender: TObject):boolean;
    //подключение панели ввода
    Function ActivePanelEnterData(Sender: TObject):boolean;
    // тестирование функции
    Function TestFunction(Exp:string):boolean;

implementation

// используемые модули
uses MainUnit,ExitDataUnit,ProjectUnit,Math;

//отключение панели струкурообразующей функции
Function DesactiveTranslateFunction(Sender: TObject):boolean;
begin
  result:=true;
  try
    MainUnit.MainForm.TranslateFunction.Clear;
    MainUnit.MainForm.CheckBoxGeneralizingFunction.Checked:=false;
    MainUnit.MainForm.CheckBoxGeneralizingFunctionClick(Sender);
    MainUnit.MainForm.CheckBoxGeneralizingFunctionII.Checked:=false;
    MainUnit.MainForm.CheckBoxGeneralizingFunctionIIClick(Sender);
  Except
    result:=False;
  end;
end;

//подключение панели ввода данных
Function ActivePanelEnterData(Sender: TObject):boolean;
begin
  result:=true;
  try

    if MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Checked then
    begin
      //переруем ошибочную функцию Лагранжа
      MainUnit.MainForm.Series7.Clear;
      MainUnit.MainForm.Series9.Clear;
      MainUnit.MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
    end;

    if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
    begin
      //переруем ошибочную обобщенную функцию Лагранжа
      MainUnit.MainForm.Series8.Clear;
      MainUnit.MainForm.Series10.Clear;
      MainUnit.MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
    end;
  Except
    result:=False;
  end;
end;

//отключение панели узлов
Function DesactivePanelPoints(Sender: TObject):boolean;
begin
  result:=true;
  try
    MainUnit.MainForm.AbscissX.Clear;
    MainUnit.MainForm.OrdinateY.Clear;
    MainUnit.MainForm.PointChoosen.Checked:=False;
    ActivePanelEnterData(sender);
  Except
    result:=False;
  end;
end;

//отключение панели ввода данных
Function DesactiveEnterDataPanel(Sender: TObject):boolean;
begin
  result:=true;
  try
    DesactivePanelPoints(sender);
    DesactiveTranslateFunction(sender);
    ExitDataUnit.DeleteUserFunction(sender);
  except
    result:=false;
  end;
end;

//быстрая соортировка
procedure QuickSort(var A: array of TUserFunc; iLo, iHi: Integer) ;
var Lo, Hi:Integer;
    Pivot, T: TUserFunc;
begin
    Lo := iLo;
    Hi := iHi;
    Pivot := A[(Lo + Hi) div 2];
    repeat
       while A[Lo].x < Pivot.x do Inc(Lo) ;
       while A[Hi].x > Pivot.x do Dec(Hi) ;
       if Lo <= Hi then
       begin
         T := A[Lo];
         A[Lo] := A[Hi];
         A[Hi] := T;
         Inc(Lo) ;
         Dec(Hi) ;
       end
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi) ;
    if Lo < iHi then QuickSort(A, Lo, iHi) ;
end;

//Соортируем таблица точек по значения абсцисса Х
procedure SortData(var F:TUsersFunction);
begin
  Quicksort(F.Value,0,F.Quantity);
end;

//искать если заданная значение точка есть в таблице точек с заданном приближением
procedure search(Value: TUserFunc;var F:TUsersFunction;var Pos:Integer;Delta:Real=0.01);
var i:Integer;
begin
  //инициализации
  Pos:=-1;
  for i:=0 to F.Quantity do   //для все точек
  begin
    if ( ((Value.x=F.value[i].x) and (Value.y=F.value[i].y))
        or ( ((F.value[i].x-delta)<=Value.x) and (Value.x<=(F.value[i].x+delta))
        and ((F.value[i].y-delta)<=Value.y) and (Value.y<=(F.value[i].y+delta)))
        )
    then begin
      Pos:=i;Break;   //выходим если условие верно
    end;
  end;
end;

//добавление точка в таблице точек и пересования график для точек
Function AddPointInFunctionAndTrace(Val:TUserFunc;var NameFunc:TUsersFunction;
    SeriePointChoisie,SeriePointnonChoisie:TPointSeries):boolean;
var p:Integer;
begin
  ////ишим если точка преднадлижить таблица точек
  if NameFunc.value<>nil then Search(Val,NameFunc,P,0) else p:=-1;
  if P=-1 then //если нет то добавляем его
  begin
    //увлечиваем таблица на 1
    Inc(NameFunc.Quantity);
    SetLength(NameFunc.value,NameFunc.Quantity+1);
    //добавляем точку
    NameFunc.value[NameFunc.Quantity]:=Val;
    //перерисуем график точек
    if NameFunc.value[NameFunc.Quantity].b then
    begin
      //если точка выбранна то перерисуем график для выбранных точек
      SeriePointChoisie.AddXY(NameFunc.value[NameFunc.Quantity].x,
                  NameFunc.value[NameFunc.Quantity].y);
    end
    else
    begin
      //если точка выбранна то перерисуем график для не выбранных точек
      SeriePointnonChoisie.AddXY(NameFunc.value[NameFunc.Quantity].x,
                  NameFunc.value[NameFunc.Quantity].y);
    end;
    result:=true;
  end else
  begin
    case TypeUnit.SChooseLanguage of
      1:MessageDlg('Already exist Point in table of points',mtWarning, [mbOK], 0 );
      0:MessageDlg('Уже существует такую точку в таблице точек. Действие отменено',mtWarning, [mbOK], 0 );
    end;
    result:=false;
  end;
end;


////******************Обработка вводимого узла пользователью *******///
//инициализируем таблица узлов
procedure init(var F:TUsersFunction);
begin
  F.Quantity:=-1;
  F.value:=nil;
end;

//добавление узла
Function AddPoint:Boolean;
var Val:TUserFunc;
begin
  if ((MainUnit.MainForm.AbscissX.Text<>'') and (MainUnit.MainForm.OrdinateY.Text<>'')) then
  begin
    //зарегистрируем данных для проверка
    Val.x:=StrToFloat(MainUnit.MainForm.AbscissX.Text);
    Val.y:=StrToFloat(MainUnit.MainForm.OrdinateY.Text);
    Val.b:=MainUnit.MainForm.PointChoosen.Checked;
    // добавляем точку в таблице данных
    result:=AddPointInFunctionAndTrace(Val,UsersFunction,MainUnit.MainForm.Series2,MainUnit.MainForm.Series3);
    //показать данны в таблице точек
    ExitDataUnit.viewusersdata(MainUnit.MainForm.StringGrid1,UsersFunction);
    //иницализируем для следующего добавления
    MainUnit.MainForm.AbscissX.Clear;
    MainUnit.MainForm.OrdinateY.Clear;
    MainUnit.MainForm.PointChoosen.Checked:=False;
    //перепоставляем курсор
    MainUnit.MainForm.AbscissX.SetFocus;
  end
  else
  begin
    case TypeUnit.SChooseLanguage of
      1:MessageDlg('Not Data Abcisse X  or Ordinate Y',mtWarning, [mbOK], 0 );
      0:MessageDlg('Поля абсцисса или ордината пуста',mtWarning, [mbOK], 0 );
    end;
    result:=false;
    Exit;
  end;
end;

//удаление узла
Function DeletePoint:boolean;
var Val:TUserFunc;
    P:Integer;
begin
  result:=False;
  if ((MainUnit.MainForm.AbscissX.Text<>'') and (MainUnit.MainForm.OrdinateY.Text<>'')) then
  begin
    //установка данных для удаления
    Val.x:=StrToFloat(MainUnit.MainForm.AbscissX.Text);
    Val.y:=StrToFloat(MainUnit.MainForm.OrdinateY.Text);
    Val.b:=MainUnit.MainForm.PointChoosen.Checked;;
    //убидым что выбранная точка есть в таблица точек
    Search(Val,UsersFunction,P,TypeUnit.SPrecision);
    if p<>-1 then
    begin
      //удаляем столбец выбранного ячейка
      MainUnit.MainForm.StringGrid1.Cols[SelectedCol].Clear;
      //удаляем столбец
      EnterDataUnit.TPublicStringGrid(MainUnit.MainForm.StringGrid1).DeleteColumn(SelectedCol);
      //востановляем данных в таблице точек и перерисуем график
      ProjectUnit.restorePointAfterLoadFile(MainUnit.MainForm.Series2,
          MainUnit.MainForm.series3,MainUnit.MainForm.StringGrid1,UsersFunction);
      //посмотрем таблица точек в StringGrid
      viewusersdata(MainUnit.MainForm.StringGrid1,UsersFunction);
      result:=true;
    end
    else
    begin
      case TypeUnit.SChooseLanguage of
        1:MessageDlg('Wrong coordinates point to modify.The action was canceled.',mtWarning, [mbOK], 0 );
        0:MessageDlg('Не верные координаты точки для изменения. Действие отменено.',mtWarning, [mbOK], 0 );
      end;
    end;
  end
  else
  begin
    case TypeUnit.SChooseLanguage of
      1:MessageDlg('Not Data Abcisse X  and / or Ordinate Y. The action was canceled.',mtWarning, [mbOK], 0 );
      0:MessageDlg('Поля абсцисса и/или ордината Пуста. Действие отменено.',mtWarning, [mbOK], 0 );
    end;
  end;
  MainUnit.MainForm.AbscissX.clear;
  MainUnit.MainForm.OrdinateY.Clear;
  MainUnit.MainForm.PointChoosen.Checked:=false;
end;

//изменение узла
Function ModifyPoint:boolean;
var Val:TUserFunc;
    P,i:Integer;
begin
  result:=false;
  if (MainUnit.MainForm.AbscissX.Text<>'') and (MainUnit.MainForm.OrdinateY.Text<>'')  then
  begin
    //попытаем установить значение
    Val.x:=StrToFloat(MainUnit.MainForm.StringGrid1.Cells[SelectedCol,1]);
    Val.y:=StrToFloat(MainUnit.MainForm.StringGrid1.Cells[SelectedCol,2]);
    if LowerCase(MainUnit.MainForm.StringGrid1.Cells[SelectedCol,3])='ok' then Val.b:=True
    else  Val.b:=False;
    Search(Val,UsersFunction,P,TypeUnit.SPrecision);//ишим точку в таблице точек
    if p<>-1 then
    begin
      //если есть точку то
      //попытаем установить новые значение из полей координатов
      UsersFunction.value[p].x:=StrToFloat(MainForm.AbscissX.Text);
      UsersFunction.value[p].y:=StrToFloat(MainForm.OrdinateY.Text);
      UsersFunction.value[p].b:=MainForm.PointChoosen.Checked;
      //востановление данные в таблице
      MainUnit.MainForm.StringGrid1.Cells[SelectedCol,1]:=MainForm.AbscissX.Text;
      MainUnit.MainForm.StringGrid1.Cells[SelectedCol,2]:=MainForm.OrdinateY.Text;
      if MainForm.PointChoosen.Checked then MainUnit.MainForm.StringGrid1.Cells[SelectedCol,3]:='Ok'
      else MainUnit.MainForm.StringGrid1.Cells[SelectedCol,3]:='No';
      //перерисуем графики именно выбраные точки и не выбраные точки
      MainUnit.MainForm.Series2.Clear;
      MainUnit.MainForm.series3.Clear;
      for i:=0 to UsersFunction.Quantity do
        if UsersFunction.value[i].b then
        begin
          //график выбранных точек
          MainUnit.MainForm.Series2.AddXY(UsersFunction.value[i].x,
                      UsersFunction.value[i].y);
        end
        else
        begin
          //график  не выбранных  точек
          MainUnit.MainForm.Series3.AddXY(UsersFunction.value[i].x,
                      UsersFunction.value[i].y);
        end;
      result:=true;
    end else
    begin
      case TypeUnit.SChooseLanguage of
        1:MessageDlg('Wrong selected coordinates point to modify.The action was canceled.',mtWarning, [mbOK], 0 );
        0:MessageDlg('Не верные выбранные координаты точки для изменения. Действие отменено.',mtWarning, [mbOK], 0 );
      end;
    end;
  end
  else
  begin
    case TypeUnit.SChooseLanguage of
      1:MessageDlg('Not Data Abcisse X  and / or Ordinate Y. The action was canceled.',mtWarning, [mbOK], 0 );
      0:MessageDlg('Поля абсцисса и/или ордината Пуста. Действие отменено.',mtWarning, [mbOK], 0 );
    end;
  end;
  MainUnit.MainForm.AbscissX.clear;
  MainUnit.MainForm.OrdinateY.Clear;
  MainUnit.MainForm.PointChoosen.Checked:=false;
end;

//удаление всех узлов
Function DeleteAllPoints:boolean;
begin
  result:=true;
  try
    //инициализируем таблица точек
    init(TypeUnit.UsersFunction);
    //инициализируем таблица узлы интерполирования
    init(TypeUnit.NodeInterPolation);
    init(TypeUnit.NodeInterPolationGeneral);
    //инициализируем StringGrid
    MainUnit.MainForm.StringGrid1.ColCount:=1;
    MainUnit.MainForm.StringGrid1.Cells[0,0]:='No.';
    MainUnit.MainForm.StringGrid1.Cells[0,1]:='X';
    MainUnit.MainForm.StringGrid1.Cells[0,2]:='Y';

    MainUnit.MainForm.series2.Clear;
    MainUnit.MainForm.series2.Active:=false;
    MainUnit.MainForm.series3.Clear;
    MainUnit.MainForm.series3.Active:=false;
    MainUnit.MainForm.series1.Clear;
    MainUnit.MainForm.series1.Active:=false;
    MainUnit.MainForm.series5.Clear;
    MainUnit.MainForm.series5.Active:=false;
    MainUnit.MainForm.series6.Clear;
    MainUnit.MainForm.series6.Active:=false;
    MainUnit.MainForm.series7.Clear;
    MainUnit.MainForm.series7.Active:=false;
    MainUnit.MainForm.series8.Clear;
    MainUnit.MainForm.series8.Active:=false;
    MainUnit.MainForm.series9.Clear;
    MainUnit.MainForm.series9.Active:=false;
    MainUnit.MainForm.series10.Clear;
    MainUnit.MainForm.series10.Active:=false;
    MainUnit.MainForm.series12.Clear;
    MainUnit.MainForm.series12.Active:=false;
    MainUnit.MainForm.series13.Clear;
    MainUnit.MainForm.series13.Active:=false;
    TypeOriginalPolynomeLagrange:='';
    TypeGeneralizedPolynomeLagrange:='';
    TypeGeneralizedPolynomeLagrangeII:='';

    MainForm.LagrangeAccuracy.Text:=Floattostr(
    ExitDataUnit.GetAccuracy(MainUnit.MainForm.series7,MainUnit.MainForm.series9));
    MainForm.GeneralisedAccuracy.Text:=Floattostr(
    ExitDataUnit.GetAccuracy(MainUnit.MainForm.series8,MainUnit.MainForm.series10));
    MainForm.GeneralisedAccuracyII.Text:=Floattostr(
    ExitDataUnit.GetAccuracy(MainUnit.MainForm.series12,MainUnit.MainForm.series13));
    ExitDataUnit.ViewFormules;
    TypeUnit.TimeTracedL:=-1;
    TypeUnit.TimeTracedGL1:=-1;
    TypeUnit.TimeTracedGL2:=-1;

    ExitDataUnit.SetAVGTimeTraced;
  Except
     result:=False;
  end;
end;

//Добавление узла функции
Function AddPointUsingFunction(Delta:Real=0):Boolean;
var Val:TUserFunc;
    S:string;
    p:integer;
begin
  if (MainUnit.MainForm.AbscissX.Text<>'') and (MainUnit.MainForm.UsersAnalytiqueFunction.Text<>'') then
  begin
    Val.x:=StrToFloat(MainUnit.MainForm.AbscissX.Text);
    if (MainUnit.MainForm.OrdinateY.Text<>'') then Val.y:=StrToFloat(MainUnit.MainForm.OrdinateY.Text);
    S:=MainUnit.MainForm.UsersAnalytiqueFunction.Text;
    Val.b:= MainUnit.MainForm.PointChoosen.Checked;
    if (
          ((Val.x+Delta)>=StrTofloat(MainUnit.MainForm.IntervalA.Text)) and ((Val.x+Delta)<=StrTofloat(MainUnit.MainForm.IntervalB.Text))
        )
      and
        (
            (TypeUnit.SelectedCol=-1)
              or
            ((TypeUnit.SelectedCol<>-1) and (MainUnit.MainForm.OrdinateY.Text<>'') and (EnterDataUnit.DeletePoint))
        )
    then
    begin
      MainUnit.MainForm.AbscissX.Text:=FloatTostr(Val.x+Delta);
      //расчёта значение ордината
      MainUnit.MainForm.OrdinateY.Text:=FloatToStr(Math.RoundTo(CalculStringFunction(S,Val.x+Delta),-TypeUnit.SRoundValue));
      MainUnit.MainForm.PointChoosen.Checked:=Val.b;
      //добавление точка
      result:=EnterDataUnit.AddPoint;
      if not result then
      begin
        MainUnit.MainForm.AbscissX.Text:=FloatTostr(Val.x);
        MainUnit.MainForm.OrdinateY.Text:=FloatTostr(Val.y);
        MainUnit.MainForm.PointChoosen.Checked:=Val.b;
        EnterDataUnit.AddPoint;
        Search(Val,UsersFunction,P,TypeUnit.SPrecision);
      end
      else
      begin
        Val.x:=Val.x+Delta;
        Val.y:=Math.RoundTo(CalculStringFunction(S,Val.x),-TypeUnit.SRoundValue);
        Search(Val,UsersFunction,P,TypeUnit.SPrecision);
      end;
      SelectedCol:=P+1;
      if SelectedCol>0 then
      begin
        MainUnit.MainForm.AbscissX.Text:=FloatTostr(Val.x);
        MainUnit.MainForm.OrdinateY.Text:=FloatTostr(Val.y);
        MainUnit.MainForm.PointChoosen.Checked:=Val.b;
        MainUnit.MainForm.StringGrid1.Row:=1;
        MainUnit.MainForm.StringGrid1.Col:=SelectedCol;
      end;
    end
    else
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('The point goes outside the limits of the interval',mtWarning);
          0:ProjectUnit.Info('Точка выходит за пределы интервала',mtWarning);
        end;

  end
  else
  begin
    if (MainUnit.MainForm.AbscissX.Text='') then
      case TypeUnit.SChooseLanguage of
        1:MessageDlg('Not Data Abcisse X',mtWarning, [mbOK], 0 );
        0:MessageDlg('Поля абсцисса пуста',mtWarning, [mbOK], 0 );
      end
    else
      if (MainUnit.MainForm.UsersAnalytiqueFunction.Text='') then
      case TypeUnit.SChooseLanguage of
        1:ProjectUnit.Info('Not Data Function ',mtWarning);
        0:ProjectUnit.Info('Проверяете заданой пользовательской функции.',mtWarning);
      end;
    result:=false;
    Exit
  end;
end;

//проверка функции
Function TestFunction(Exp:string):boolean;
var x,max,valuey,h: Real;
begin
  result:=true;
  try
    //создаем аналитический анализатор для расчет анналитическую функцию
    try
      if TypeUnit.bcp = nil
      then TypeUnit.bcp :=  TbcParser.Create(MainUnit.MainForm)
      else
      begin
        TypeUnit.bcp.Destroy;
        TypeUnit.bcp := TbcParser.Create(MainUnit.MainForm);
      end;
    Except
      raise;
    end;
    //передаем выражение для анализа
    TypeUnit.bcp.Expression := Exp;
    x := TypeUnit.SAxisXLeftValueInterval;
    max := TypeUnit.SAxisXRightValueInterval;
    h:=(max-x)/(TypeUnit.SStepTraceUsersAnalytiqueFunction*(TypeUnit.SStepTraceUsersAnalytiqueFunction/10));
    while x <= max  do
    begin
      //передаем значение х для расчета
      TypeUnit.bcp.X := x;
      try
        valuey:= TypeUnit.bcp.Value;
      except
        raise;
      end;
      x := x+h;
    end;
  Except
    result:=false;
  end;
end;


end.
