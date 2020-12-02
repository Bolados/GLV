unit ExitDataUnit;

interface

//используемые библиотеки и модули
uses
  TypeUnit,EnterDataUnit,SysUtils,Grids,Chart,Series,TeEngine,Math,Dialogs;

    //показа таблица точек в stringgrid
    procedure viewusersdata(StringGrid:TStringGrid;userF:TUsersFunction);

    ////***********************настройка график ***********************///
    //получить минимальное значение ось каждого графика
    function Max(VL : TChartValueList; StartIndex : integer = -1; EndIndex: integer = -1) : Double;
    //получить максимальное значение ось каждого графика
    function Min(VL : TChartValueList; StartIndex : integer = -1; EndIndex: integer = -1) : Double;
    //  регулирования график
    procedure ResizeAxis (Chart:TChart;StartIndex : integer = -1; EndIndex: integer = -1);
    //автоматическое регулирование экрана
    Function Autoresize:boolean;
    //Свернуть и развернуть функции
    Function HiddenShowFunction:boolean;
    //Развернуть все функции
    Function ShowAllFunction:boolean;
    ////************************Работа для построения формулы лагранжа **********************///
    //функция расчета формулы лагранжа
    function LaGrange(NodeInterp:TNodeInterPolation;Value:Extended;var LGString:String):Extended;
    function LaGrangeG(TranslateFunction:string;const NodeInterp:TNodeInterPolation;Value:Extended;
      var LGString:String):Extended;
    function LaGrangeGII(TranslateFunction:string;const NodeInterp:TNodeInterPolation;Value:Extended;
      var LGString:String):Extended;
    //получить Погрешность
    Function GetAccuracy(Serie1:TLineSeries;serie2:TPointSeries):double;
     ////************************Работа для расчёта анфлитической функции **********************///
     function CalculStringFunction(s:string;X:Double):Double;
       ////**работа движения курсор*******///
    //проверка если значение Х и У есть в графике
     function CoordMouseInFunction(XSouris,YSouris:Double;AF:TUsersFunction;
      Delta:Real=0.01):Integer; //-1 False >-1 true

      //рисование классического полинома Лагранжа
      Function TraceLagrange:boolean;
      //рисование первого вида обобщённого полинома Лагранжа
      Function TraceGeneralizingLagrange:boolean;
      //рисование второго вида обобщённого полинома Лагранжа
      Function TraceGeneralizingLagrangeII:boolean;

      //*************рисовать ошибочную функцию Лагранжа*********/////
      Function TraceErrorLagrage(UserF: TUsersFunction; NodeInterP: TNodeInterPolation):boolean;
    //*************рисовать функцию ошибки первого вида обобщённого полинома Лагранжа*********/////
      Function TraceErrorGeneralizing(TranslateFunc:string;UserF: TUsersFunction;
        NodeInterP: TNodeInterPolation):boolean;
      //рисовать функцию ошибки второго вида обобщённого полинома Лагранжа////
      Function TraceErrorGeneralizingII(TranslateFunc:string;UserF: TUsersFunction;
        NodeInterP: TNodeInterPolation):boolean;

      //рисование пользовательской функции
      Function TraceUserFunction:boolean;
      //удаление пользовательской функции
      Function DeleteUserFunction(Sender: TObject):boolean;
      //рисование проверочной функции
      Function TraceControlFunction:boolean;
      //удаление проверочная функция
      Function DeleteControlFunction:boolean;
      //перерисование графики когда пользователь добавляет и двгает точку
      Function ReloadGraphicsWhenMouseMove:boolean;
      //просмотра формулы
      Procedure ViewFormules;
      //проверка на изменении маштабирования
      Function ScaleChanged:boolean;
      //установка времени построения функции
      Procedure SetAVGTimeTraced;


implementation

//используемые модули
uses MainUnit,ProjectUnit,bcParser,HistoryUnit;

//установка времени построения функции
Procedure SetAVGTimeTraced;
var a,b,c,d:string;
begin
  if (TypeUnit.TimeTracedF)<0 then
    a:='Н'
  else a:= Floattostr(TypeUnit.TimeTracedF);

  if (TypeUnit.TimeTracedL)<0 then
    b:='Н'
  else b:= Floattostr(TypeUnit.TimeTracedL);

  if (TypeUnit.TimeTracedGL1)<0 then
    c:='Н'
  else c:= Floattostr(TypeUnit.TimeTracedGL1);

  if (TypeUnit.TimeTracedGl2)<0 then
    d:='Н'
  else d:= Floattostr(TypeUnit.TimeTracedGL2);

  MainUnit.MainForm.Timetraced.Caption:=a+chr(9) + b +chr(9)+ c + chr(9)+d;

end;

//обрабочик изменения маштабирования
Function ScaleChanged:boolean;
var margex,margey,aminx,amaxx,aminy,amaxy:real;
begin
  Margey :=(TypeUnit.SAxisYRightValueInterval-TypeUnit.SAxisYLeftValueInterval) / TypeUnit.SMargeY;
  aminy:=MainUnit.MainForm.Chart.LeftAxis.Minimum+margey;
  amaxy:=MainUnit.MainForm.Chart.LeftAxis.Maximum-margey;
  Margex :=(TypeUnit.SAxisXRightValueInterval-TypeUnit.SAxisXLeftValueInterval) / TypeUnit.SMargeX;
  aminx:=MainUnit.MainForm.Chart.BottomAxis.Minimum+margex;
  amaxx:=MainUnit.MainForm.Chart.BottomAxis.Maximum-margex;

  if (aminy = TypeUnit.SAxisYLeftValueInterval)
      and (amaxy = TypeUnit.SAxisYRightValueInterval)
      and (aminx = TypeUnit.SAxisXLeftValueInterval)
      and (amaxx = TypeUnit.SAxisXRightValueInterval)
  then Result:=false
  else result:=true;

end;

//просмотра формулы
Procedure ViewFormules;
var s,s1,s2:string;
begin
  case TypeUnit.SChooseLanguage of
    1:
      begin
        s:='Lagrange Formule';
        s1:=' I Generalized Formule Lagrange';
        s2:=' II Generalized Formule Lagrange';
      end;
    0:
      begin
        s:='Формула Лагранжа';
        s1:=' I Обобщённая формула Лагранжа';
        s2:='II Обобщённая формула Лагранжа';
      end;
  end;
  //отчистим мемо
  MainUnit.MainForm.MemoInformation.Clear;
  if MainUnit.MainForm.CheckBoxViewLagrangeFunction.Checked then
  begin
    //добавление формулы в мемо
    MainForm.MemoInformation.Lines.Add(s);
    MainForm.MemoInformation.Lines.Add(TypeOriginalPolynomeLagrange)
  end;

  if MainUnit.MainForm.CheckBoxViewGeneralizingFunction.Checked then
  begin
  //добавление формулы в мемо
    if MainUnit.MainForm.CheckBoxViewLagrangeFunction.Checked
    then  MainForm.MemoInformation.Lines.Add('');
    MainForm.MemoInformation.Lines.Add(s1);
    MainUnit.MainForm.MemoInformation.Lines.Add(TypeGeneralizedPolynomeLagrange);
  end;

  if MainUnit.MainForm.CheckBoxViewGeneralizingFunctionII.Checked then
  begin
  //добавление формулы в мемо
    if MainUnit.MainForm.CheckBoxViewLagrangeFunction.Checked
      or MainUnit.MainForm.CheckBoxViewGeneralizingFunction.Checked
    then  MainForm.MemoInformation.Lines.Add('');
    MainForm.MemoInformation.Lines.Add(s2);
    MainUnit.MainForm.MemoInformation.Lines.Add(TypeGeneralizedPolynomeLagrangeII)
  end;
  
  if  ((not MainUnit.MainForm.CheckBoxViewLagrangeFunction.Checked)
    and (not MainUnit.MainForm.CheckBoxViewGeneralizingFunction.Checked)
      and (not MainUnit.MainForm.CheckBoxViewGeneralizingFunctionII.Checked ))
  then  MainUnit.MainForm.PanelInformation.Visible:=False
  else MainUnit.MainForm.PanelInformation.Visible:=True;
end;

////перерисование графики когда пользователь добавляет и двгает точку
Function ReloadGraphicsWhenMouseMove:boolean;
begin
  result:=True;
  try
    if not MainUnit.MainForm.Series2.Active then MainUnit.MainForm.Series2.Active:=true;
    if not MainUnit.MainForm.Series3.Active then MainUnit.MainForm.Series3.Active:=true;
    //переруем функцию Лагранжа
    if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked then
    begin
      if ExitDataUnit.TraceLagrange then  MainUnit.MainForm.Series1.Active:=true
      else MainUnit.MainForm.Series1.Active:=False;
    end
    else
    begin
        MainUnit.MainForm.Series1.Active:=False;
    end;
    //переруем обобщенную функцию Лагранжа
    if MainUnit.MainForm.CheckBoxGeneralizingFunction.Checked then
    begin
      if ExitDataUnit.TraceGeneralizingLagrange
      then MainUnit.MainForm.Series5.Active:=true
      else MainUnit.MainForm.Series5.Active:=False;
      TypeUnit.LDT:=Length(DateTimeToStr(now)+' ===> ');
      if MainForm.TranslateFunction.Text<>''
      then HistoryUnit.AddTranslateHistory(DateTimeToStr(now)+' ===> '+MainForm.TranslateFunction.Text);
    end
    else
    begin
        MainUnit.MainForm.Series5.Active:=False;
    end;
    //переруем обобщенную функцию Лагранжа II
    if MainUnit.MainForm.CheckBoxGeneralizingFunctionII.Checked then
    begin
      if ExitDataUnit.TraceGeneralizingLagrangeII
      then MainUnit.MainForm.Series6.Active:=true
      else MainUnit.MainForm.Series6.Active:=False;
      TypeUnit.LDT:=Length(DateTimeToStr(now)+' ===> ');
      if MainForm.TranslateFunction.Text<>''
      then HistoryUnit.AddTranslateHistory(DateTimeToStr(now)+' ===> '+MainForm.TranslateFunction.Text);
    end
    else
    begin
        MainUnit.MainForm.Series6.Active:=False;
    end;
    //переруем ошибочную функцию Лагранжа
    if MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Checked
    then
    begin
      ExitDataUnit.TraceErrorLagrage(UsersFunction,NodeInterPolation);
      MainUnit.MainForm.LagrangeAccuracy.Text:=Floattostr(ExitDataUnit.GetAccuracy(MainUnit.MainForm.series7,MainUnit.MainForm.series9));
    end
    else
    begin
        MainUnit.MainForm.series7.Active:=False;
        MainUnit.MainForm.series9.Active:=False;
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Checked
    then
    begin
      ExitDataUnit.TraceErrorGeneralizing(MainForm.TranslateFunction.Text,UsersFunction,
        NodeInterPolationGeneral);
      MainUnit.MainForm.GeneralisedAccuracy.Text:=Floattostr(ExitDataUnit.GetAccuracy(MainUnit.MainForm.series8,MainUnit.MainForm.series10));
    end
    else
    begin
        MainUnit.MainForm.Series8.Active:=False;
        MainUnit.MainForm.series10.Active:=False;
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainUnit.MainForm.CheckBoxErrorGeneralizingFunctionII.Checked
    then
    begin
      ExitDataUnit.TraceErrorGeneralizingII(MainForm.TranslateFunction.Text,UsersFunction,
        NodeInterPolationGeneral);
      MainUnit.MainForm.GeneralisedAccuracyII.Text:=Floattostr(ExitDataUnit.GetAccuracy(MainUnit.MainForm.series12,MainUnit.MainForm.series13));
    end
    else
    begin
        MainUnit.MainForm.Series12.Active:=False;
        MainUnit.MainForm.series13.Active:=False;
    end;
    ExitDataUnit.ViewFormules;
  except
    result:=False;
  end;
end;

////**работа движения курсор*******///
//проверка если значение абсцисса Х и ордината У мышка есть в графике
function CoordMouseInFunction(XSouris,YSouris:Double;AF:TUsersFunction;Delta:Real=0.01):Integer;
var Val:TUserFunc;
    p:Integer;
begin
  //инициализация результата
  Result:=-1;
  Val.x:=XSouris;
  Val.y:=YSouris;
  if AF.value=nil then Exit  //если не построена график то выходим
  else
  begin
    search(Val,AF,p,Delta); //ишим точку
    if p=-1 then Exit // если нет то выходим
    else Result:=p;  //иначе точку найдено
  end;
end;

//показать таблица узлов
procedure viewusersdata(StringGrid:TStringGrid;userF: TUsersFunction);
var i,j:Integer;
begin
  //если есть данные в таблице точек то соортируем его
  if UsersFunction.Quantity<>-1 then SortData(UsersFunction);
  //инициализируем StringGrid
    for j:=1 to StringGrid.ColCount-1 do StringGrid.Cols[j].Clear;
  StringGrid.ColCount:=1;
  //если таблица точек не пуста
    if userF.Quantity <> -1 then
    begin
        for j:=0 to userF.Quantity do
        begin
          StringGrid.ColCount:=StringGrid.ColCount+1;
          for i:=0 to StringGrid.RowCount-1 do
          begin
            //заполнения ячейки StringGrid
            case i of
              0: StringGrid.Cells[j+1,i]:=IntToStr(j+1);
              1: StringGrid.Cells[j+1,i]:=FloatToStr(RoundTo(userF.value[j].x,-TypeUnit.SRoundValue));
              2: StringGrid.Cells[j+1,i]:=FloatToStr(RoundTo(userF.value[j].y,-TypeUnit.SRoundValue));
              3:
              begin
                if userF.value[j].b then StringGrid.Cells[j+1,i]:='Ok'
                else StringGrid.Cells[j+1,i]:='No';
              end;
            end;
          end;
        end;
    end;
end;

////************************Работа для построения формулы лагранжа **********************///
//нахождения произведения разность заданное число и вектор узлы с минимальном значения до максимального
function Product(Value:Extended;vector:array of TUserFunc;var PString:string;
  Max:Integer;Exception:Integer = -1;Min:Integer=0; const NameFunc:string=''):Extended;
var i:Integer;
    valTemp:Extended;
    s,s1,s2:string;
begin
  //инициализируем данных
  valTemp:=1; //временные значение результата
  s:='';
  s2:=PString;
  if max>0 then // максимальное значение должен быть больше нулью
  begin
    //инициализируем начальные данных
      if ((Min = 0) and (Exception=0)) then Inc(Min); //если мин равно исключения то улечиваем мин
      if NameFunc=''
      then valTemp:= (Value-vector[Min].x)
      else valTemp:= CalculStringFunction(NameFunc,(Value-vector[Min].x));
      //обработка вывода формула расчета произведения
      if vector[Min].x>0 then s1:=s2+ '-'+FloatToStr(RoundTo(vector[Min].x,-TypeUnit.SRoundValue))
      else s1:=s2+ '+'+FloatToStr(-RoundTo(vector[Min].x,-TypeUnit.SRoundValue));
      if NameFunc<>'' then s1:= StringReplace(NameFunc,'x','('+s1+')',[rfReplaceAll]);

      s:=s+ '(' +s1+')';
    For i:=min+1 to Max do
    begin
      if i<>Exception then
      begin
        if NameFunc=''
        then valTemp:= valTemp*(Value-vector[i].x)
        else valTemp:= valTemp*CalculStringFunction(NameFunc,(Value-vector[i].x));
        if vector[i].x>0 then s1:=s2+ '-'+FloatToStr(RoundTo(vector[i].x,-TypeUnit.SRoundValue))
        else s1:=s2+ '+'+FloatToStr(-RoundTo(vector[i].x,-TypeUnit.SRoundValue));
        if NameFunc<>'' then s1:= StringReplace(NameFunc,'x','('+s1+')',[rfReplaceAll]);
        s:=s+'*'+'(' +s1 +')';
      end;
    end;
  end;
  Product:=valTemp;  //возврашаем результата расчёта
  if (PString='') or (valTemp=1) then PString:=FloatToStr(valTemp) //возврашаем результата для формула
  else PString:=s;
end;

//спомогательный функция для расчета формулы лагранжа
function L(Node:Integer;Value:Extended;Points:TNodeInterPolation;var LString:string):Extended;
var Numerator,Denominator:Extended;
    s,s1,s2:string;
begin
  //инициализации данных для составления формула
  s:='';
  s1:='x';
  //расчета числитель
  Numerator :=  product(Value,Points.value,s1,Points.Quantity,Node);
  s2:='';
  //расчета заменатель
  Denominator := product(Points.value[Node].x,Points.value,s2,Points.Quantity,Node);
  try
    //попытка деления 2 чисел
    L:=(Numerator/Denominator);
  except
    L:=0;
    Abort;//при ошибке не показывать ошибке
  end;
  s2:=floattostr(RoundTo(Denominator,-TypeUnit.SRoundValue));
  s:='('+s1+')' +'/('+ s2+')';
  LString:=s; //возврашаем результата для формула
end;

//функция расчета формулы лагранжа
function LaGrange(NodeInterp:TNodeInterPolation;Value:Extended;var LGString:String):Extended;
var i:Integer;
    res,Lf:Extended;
    s,s1:string;
begin
  //инициализация
  res:=0;
  s:='';
  Lf:=0;
  For i:=0 to NodeInterp.Quantity do
  begin
    try
      //рачет спомогательная функция
      Lf:=NodeInterp.value[i].y*L(i,Value,NodeInterp,s1);
    except
      Continue; //при ошибке на делении на нуль пропустим инеракцию
    end;
    res:=res+Lf;
    //составления формула расчета
    s:=s +'+' + '((' + FloatToStr(RoundTo(NodeInterp.value[i].y,-TypeUnit.SRoundValue))+')*'+ s1 +')';
  end;
  Result:=res;
  Delete(s,1,1); //удаление первый элемент
  LGString:=s;  //установка результата для формула
end;

//спомогательный функция для расчета формулы обобщенного лагранжа
function LG(TranslateFunction:string;Node:Integer;Value:Extended;Points:TNodeInterPolation;var LString:string):Extended;
var Numerator,Denominator:Extended;
    Pointstemp:TNodeInterPolation;
    i,k:Integer;
    s,s1,s2:string;
begin
  //инициализации
  Randomize;
  s:='';
  //расчета структуробразующой функции все узлы интерполизации
  Pointstemp:=Points;
  For i:=0 to Pointstemp.Quantity do
  begin
    Pointstemp.value[i].x:=CalculStringFunction(TranslateFunction,Pointstemp.value[i].x);
  end;
  //расчёта заменатель
  s2:='';
  Denominator:=product(Points.value[Node].x,Points.value,s2,Points.Quantity,Node);

  while Denominator=0 do   //пока заменатель равен нулью
  begin
    //находим где произошло получения нуль
    for i:=0 to Pointstemp.Quantity do
      if ((i<>Node) and ((Pointstemp.value[Node].x-Pointstemp.value[i].x)=0)) then Break;

    k:=Random(1);//генерируем произволльное значения
    case k of
      0:
        begin
          //увеличить узла где произошло получения нуль на чуть чуть больше
          Pointstemp.value[Node].x:=Pointstemp.value[Node].x+TypeUnit.SPrecision;
          //уменшаем текуший узлы на чуть чуть меньше
          Pointstemp.value[i].x:=Pointstemp.value[i].x-TypeUnit.SPrecision;
        end;
      1:
        begin
           //уменшаем узла где произошло получения нуль на чуть чуть меньше
          Pointstemp.value[Node].x:=Pointstemp.value[Node].x-TypeUnit.SPrecision;
          //увеличить текуший узлы на чуть чуть больше
          Pointstemp.value[i].x:=Pointstemp.value[i].x+TypeUnit.SPrecision;
        end;
    end;
    s2:='';
    //перерачитываем значения заменатель
    Denominator:=product(Pointstemp.value[Node].x,Pointstemp.value,s2,Pointstemp.Quantity,Node);
  end;

  s2:=floattostr(RoundTo(Denominator,-TypeUnit.SRoundValue));

  //расчета структуробразующой функции узел интерполизации заданное значения
  Value:=CalculStringFunction(TranslateFunction,Value);
  //рачет числитель
  s1:=TranslateFunction; //передаем структурообразующую функцию
  Numerator:=Product(Value,Pointstemp.value,s1,Pointstemp.Quantity,Node);
  s:='('+s1+')' +'/('+ s2+')';
  LG:=(Numerator/Denominator);// рачет и установка результата функции
  LString:=s;//установка формула рачёта функции
end;

//получения узли чтобы их не перезаписать
function GetInialNode(const NodeInterp:TNodeInterPolation):TNodeInterPolation;
var res: TNodeInterPolation;
    i:Integer;
begin
  //инициализации
  init(res);
  res.Quantity:=NodeInterp.Quantity;
  SetLength(res.value,res.Quantity+1);
  //получения
  for i:=0 to NodeInterp.Quantity do
  begin
    res.value[i]:=NodeInterp.value[i];
  end;
  Result:=res;
end;

//функция расчета обобщённого формулы лагранжа
function LaGrangeG(TranslateFunction:string;const NodeInterp:TNodeInterPolation;
  Value:Extended;var LGString:String):Extended;
var i:Integer;
    NodeInterptemp:TNodeInterPolation;
    res,LGf:Extended;
    s,s1:string;
begin
  // инициализации
  res:=0;
  s:='';
  For i:=0 to NodeInterp.Quantity do
  begin
    // получения узли чтобы их не перезаписать
    NodeInterptemp:=GetInialNode(NodeInterp);
    //Расчёта спомогательный функция для расчета формулы обобщенного лагранжа
    LGf:=NodeInterptemp.value[i].y*LG(TranslateFunction,i,Value,NodeInterptemp,s1);
    res:=res+LGf;
    s:=s +'+' + '(' + FloatToStr(RoundTo(NodeInterptemp.value[i].y,-TypeUnit.SRoundValue))+'*'+ s1 +')';
  end;
  Result:=res;
  Delete(s,1,1); //удаление первый элемент
  LGString:=s;  //установка результата для формула
end;

//спомогательный функция для расчета формулы обобщенного лагранжа II
function LGII(TranslateFunction:string;Node:Integer;Value:Extended;
  Points:TNodeInterPolation;var LString:string):Extended;
var Numerator,Denominator:Extended;
    Pointstemp:TNodeInterPolation;
    i:Integer;
    s,s1,s2:string;
begin
  //инициализации данных для составления формула
  s:='';
  s1:='x';
  //расчета числитель
  Numerator :=  product(Value,Points.value,s1,Points.Quantity,Node,0,TranslateFunction);
  s2:='';
  //расчета заменатель
  Denominator := product(Points.value[Node].x,Points.value,s2,Points.Quantity,Node,0,TranslateFunction);
  s2:=floattostr(RoundTo(Denominator,-TypeUnit.SRoundValue));
  try
    //попытка деления 2 чисел
    LGII:=(Numerator/Denominator);
    s:='('+s1+')' +'/('+ s2+')';
    LString:=s;//установка формула рачёта функции
  except
    LGII:=0;
     showmessage('Division by zero');
    //находим где произошло получения нуль
    for i:=0 to Pointstemp.Quantity do
      if ((i<>Node) and (CalculStringFunction(TranslateFunction,
                (Pointstemp.value[Node].x-Pointstemp.value[i].x))=0))
      then Break;

    LString:='Division by zero actual node = '+ Floattostr(Pointstemp.value[Node].x)+'error node'+
      Floattostr(Pointstemp.value[i].x);
    //raise;
    Abort;//при ошибке не показывать ошибке
  end;
end;

//функция расчета обобщённого формулы лагранжа II
function LaGrangeGII(TranslateFunction:string;const NodeInterp:TNodeInterPolation;
  Value:Extended;var LGString:String):Extended;
var i:Integer;
    NodeInterptemp:TNodeInterPolation;
    res,LGf:Extended;
    s,s1:string;
begin
  // инициализации
  res:=0;
  s:='';
  try
    For i:=0 to NodeInterp.Quantity do
    begin
      // получения узли чтобы их не перезаписать
      NodeInterptemp:=GetInialNode(NodeInterp);
      //Расчёта спомогательный функция для расчета формулы обобщенного лагранжа
      try
        LGf:=NodeInterptemp.value[i].y*LGII(TranslateFunction,i,Value,NodeInterptemp,s1);
        res:=res+LGf;
        s:=s +'+' + '(' + FloatToStr(RoundTo(NodeInterptemp.value[i].y,-TypeUnit.SRoundValue))+'*'+ s1 +')';
      Except
        raise;
      end;
    end;
    Result:=res;
    Delete(s,1,1); //удаление первый элемент
    LGString:=s;  //установка результата для формула
  Except
    LGString:='';
    Exit;
  end;
end;

////************************ конец Работа для построения формулы лагранжа **********************///

//получить Погрешность

Function GetAccuracy(Serie1:TLineSeries;serie2:TPointSeries):double;
var vmax1,vmin1,vmax2,vmin2:double;
begin
  vmax2:=0;
  vmax1:=0;

  if Serie1.Active then
  begin
    vmin1:= abs(ExitDataUnit.Min(Serie1.YValues));
    Vmax1:= abs(ExitDataUnit.Max(Serie1.YValues));
  end
  else begin vmin1:=0; end;

  if Serie2.Active then
  begin
    vmin2:= abs(ExitDataUnit.Min(Serie2.YValues));
    Vmax2:= abs(ExitDataUnit.Max(Serie2.YValues));
  end
  else begin vmin1:=0; vmin2:=0; end;
  result:=Math.Max(Math.RoundTo(Math.Max(vmin1,vmax1),-TypeUnit.SRoundValue),
                    Math.RoundTo(Math.Max(vmin2,vmax2),-TypeUnit.SRoundValue));
end;

//Рисования исходной нелинейности///
Function TraceStringFunction(Serie:TLineSeries;s: string;XMin,XMax:Double;
  var F:TUsersFunction):boolean;
var h,StrFuncValue:Double;
begin
  result:=true;
  //vserie:= Serie;
  StrFuncValue:=0;
  //устоновляем шаг
  h:=((XMax-XMin) / TypeUnit.SStepTraceUsersAnalytiqueFunction);
  //очистим пользователькую функцию
  serie.Clear;
  while Xmin<=XMax do
  begin
    try
      //вычисления значение
      StrFuncValue:=RoundTo(CalculStringFunction(S,XMin),-TypeUnit.SRoundValue);
    except
      case TypeUnit.SChooseLanguage of
        1:ProjectUnit.Info('Introduced formula is incorrect and / or range of building this formula does not fit.',
          mtWarning);
        0:ProjectUnit.Info('Введенная формула неверна и/или интервал построения данной формулы не подходит.',
          mtWarning);
      end;
      serie.Clear;
      result:=False;
      Exit;
    end;
    //добавление точку в массиве
    Inc(F.Quantity);
    SetLength(F.value,F.Quantity+1);
    F.value[F.Quantity].x:=RoundTo(Xmin,-TypeUnit.SRoundValue);
    F.value[F.Quantity].y:=RoundTo(StrFuncValue,-TypeUnit.SRoundValue);
    F.value[F.Quantity].b:=False;
    Serie.AddXY(Xmin,StrFuncValue);
    Xmin:=Xmin+h;
  end;
end;

//рисование пользовательской функции
Function TraceUserFunction:boolean;
begin
  //если граници не пустые
  result:=False;
  if ((MainUnit.MainForm.IntervalA.Text<>'') and (MainUnit.MainForm.IntervalB.Text<>'') and (MainForm.UsersAnalytiqueFunction.Text<>''))
  then
  begin
    //если левая граница меньше правую
    if StrToFloat(MainUnit.MainForm.IntervalA.Text)<StrToFloat(MainUnit.MainForm.IntervalB.Text) then
    begin
      //рисуем пользователькую функцию
      TypeUnit.TimeTracedF:=TypeUnit.GetTimeInMilliSeconds(now);
      result:=TraceStringFunction(MainUnit.MainForm.Series4,MainForm.UsersAnalytiqueFunction.Text,
                        StrToFloat(MainUnit.MainForm.IntervalA.Text),StrToFloat(MainUnit.MainForm.IntervalB.Text),
                        AllPointUsersFuncForAddPoints);
      TypeUnit.TimeTracedF:=TypeUnit.GetTimeInMilliSeconds(now)-TypeUnit.TimeTracedF;
    end else
    begin
      case TypeUnit.SChooseLanguage of
        1:ProjectUnit.Info('Value A must be inferior of value B',mtWarning);
        0:ProjectUnit.Info('Значение Левой границы должно быть меньше чем значение правойю',mtWarning);
      end;
      TypeUnit.TimeTracedF:=-1;
      Exit;
    end;
  end else
  begin
    if (MainUnit.MainForm.IntervalA.Text='') or (MainUnit.MainForm.IntervalB.Text='')
    then
      case TypeUnit.SChooseLanguage of
        1:ProjectUnit.Info('Not Data Interval A and/or B.',mtWarning);
        0:ProjectUnit.Info('Проверяете значения заданного интервала.',mtWarning);
      end
    else if (MainForm.UsersAnalytiqueFunction.Text='') then
      case TypeUnit.SChooseLanguage of
        1:ProjectUnit.Info('Not Data Function ',mtWarning);
        0:ProjectUnit.Info('Проверяете заданой пользовательской функции.',mtWarning);
      end;
    Exit;
  end;
end;

//удаление пользовательской функции
Function DeleteUserFunction(Sender: TObject):boolean;
begin
  result:=true;
  try
    //инициализируем данных для добавления точки через функии
    EnterDataUnit.init(AllPointUsersFuncForAddPoints);
    //очистим пользовательскую функуию
    MainUnit.MainForm.Series4.Clear;
    MainUnit.MainForm.Series4.Active:=false;
    MainUnit.MainForm.IntervalA.Clear;
    MainUnit.MainForm.IntervalB.Clear;
    MainUnit.MainForm.UsersAnalytiqueFunction.Clear;
    //переруем ошибочную функцию Лагранжа
    if MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Checked then
    begin
      MainUnit.MainForm.Series7.Clear;
      MainUnit.MainForm.Series9.Clear;
      MainUnit.MainForm.CheckBoxErrorLagrangeFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа
    if MainForm.CheckBoxErrorGeneralizingFunction.Checked then
    begin
      MainUnit.MainForm.Series8.Clear; MainUnit.MainForm.Series10.Clear;
      MainUnit.MainForm.CheckBoxErrorGeneralizingFunctionClick(sender);
    end;
    //переруем ошибочную обобщенную функцию Лагранжа II
    if MainForm.CheckBoxErrorGeneralizingFunctionII.Checked then
    begin
      MainUnit.MainForm.Series12.Clear; MainUnit.MainForm.Series13.Clear;
      MainUnit.MainForm.CheckBoxErrorGeneralizingFunctionIIClick(sender);
    end;
    ExitDataUnit.ViewFormules;
    TypeUnit.TimeTracedF:=-1;
  Except
    result:=false;
  end;
end;

////************************Работа для расчёта аналитической функции **********************///
function CalculStringFunction(s:string;X:Double):Double;
begin
  if TypeUnit.bcp = nil  //если не создано синтаксический анализатор
  then TypeUnit.bcp := TbcParser.Create(MainUnit.MainForm) //создаем его
  else
  begin
    //иначе удаляем синтаксического анализатор и создаем новый
    TypeUnit.bcp.Destroy;
    TypeUnit.bcp := TbcParser.Create(MainUnit.MainForm);
  end;
  //установляем выражение для анализа и рачета синтаксического анализатор
  TypeUnit.bcp.Expression := s;
  //установляем значение для расчета функции
  TypeUnit.bcp.X := x;
  //вычисляем значения
  CalculStringFunction:=TypeUnit.bcp.Value;
end;

//рисование проверочной функции
Function TraceControlFunction:boolean;
var x,max,h: Real;
    S:string;
begin
  result:=true;
  try
    try
      //создаем аналитический анализатор для расчет анналитическую функцию
      if TypeUnit.bcp = nil then TypeUnit.bcp := TbcParser.Create(MainUnit.MainForm) else
      begin
        TypeUnit.bcp.Destroy;
        TypeUnit.bcp := TbcParser.Create(MainUnit.MainForm);
      end;
    Except
       raise;
    end;
    s:= MainUnit.MainForm.ControlFunction.Text;
    //передаем выражение для анализа
    TypeUnit.bcp.Expression := s;
    //очистим функцию проверки
    MainUnit.MainForm.series11.Clear;
    //получить минимальное и максимальное значение Х в графике
    if (MainUnit.MainForm.IntervalA.Text<>'') and (MainUnit.MainForm.IntervalB.Text<>'')
    then
    begin
      X:=Strtofloat(MainUnit.MainForm.IntervalA.Text);
      Max:=Strtofloat(MainUnit.MainForm.IntervalB.Text);
    end else
    begin
      X:=MainForm.Chart.BottomAxis.Minimum;
      Max:=MainForm.Chart.BottomAxis.Maximum;
    end;
    //устоновляем шаг
    h:=((Max-X) / (TypeUnit.SStepTraceUsersAnalytiqueFunction *(TypeUnit.SStepTraceUsersAnalytiqueFunction/10)));
    while x <= max  do
    begin
      //передаем значение х для расчета
      bcp.X := x;
      //рисуем функцию проверки
      try
        MainUnit.MainForm.Series11.AddXY(x,bcp.Value);
      except
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('Introduced formula is incorrect.',mtWarning);
          0:ProjectUnit.Info('Введенная формула неверна.',mtWarning);
        end;
        MainUnit.MainForm.Series11.clear;
        raise;
        exit;
      end;
      x := x+h;
    end;
  Except
    Result:=False;
  end;
end;

//удаление проверочная функция
Function DeleteControlFunction:boolean;
begin
  result:=true;
  try
    MainUnit.MainForm.ControlFunction.Clear;
    //очистим аналитический анализатор для расчет анналитическую функцию
    bcp := nil;
    //очистим график проверки
    MainUnit.MainForm.series11.Clear;
    MainUnit.MainForm.series11.Active:=false;
  Except
    result:=False;
  end;

end;


//запись узли интерполирования
procedure recordNodeInterpolation(var NodeInterp:TNodeInterPolation;UserF: TUsersFunction);
var i:Integer;
begin
  init(NodeInterp);  // инициализируем  узли
  For i:=0 to UserF.Quantity do
  begin
    //записывает выбранные узли(точки)
    if UserF.value[i].b then
    begin
      Inc(NodeInterp.Quantity);
      SetLength(NodeInterp.value,NodeInterp.Quantity+1);
      NodeInterp.value[NodeInterp.Quantity]:= UserF.value[i];
    end;
  end;
end;

//рисуем полином лагранж (обобщенной и исходной)
Function TracePolynomeLagrange(NodeInterp: TNodeInterPolation;Xmin,XMax:Real;
  Serie:TLineSeries;var tp:string;TranslateFunc:string):boolean;
var h,LaGrangeValue:Real;
begin
  result:=true;
  LaGrangeValue:=0;
  //устоновляем шаг
  h:=((XMax-XMin) / TypeUnit.SStepTraceLagrangeAndGeneralizingFunction);
  while Xmin<=XMax do
  begin
    if TranslateFunc=''  //расчёт формулу лагранжа
    then LaGrangeValue:=Lagrange(NodeInterp,Xmin,tp)
    else
    begin
      try
        //расчёт обобщенную формулу лагранжа
        if serie.Title=MainUnit.MainForm.Series6.Title
        then LaGrangeValue:=LagrangeGII(TranslateFunc,NodeInterp,Xmin,tp)
        else LaGrangeValue:=LagrangeG(TranslateFunc,NodeInterp,Xmin,tp);
      except
        Serie.Clear;
        result:=false;
        Exit;
      end;
    end;
    //рисуем полином
    Serie.AddXY(Xmin,LaGrangeValue);
    Xmin:=Xmin+h;
  end;
end;

//рисование функции Лагранжа
Function TraceLagrange:boolean;
var XMin,XMax,XMarge:Real;
begin
  //инициализация
  MainForm.Series1.Clear;
  if UsersFunction.Quantity<>-1 then // если есть данных в таблице точек то
  begin
    //запись узли для интерполирования
    SortData(UsersFunction);
    //записываем узлы интерполирования
    recordNodeInterpolation(NodeInterPolation,UsersFunction);
    //получить минимальное и максимальное значение Х в графике
    if (MainUnit.MainForm.IntervalA.Text<>'') and (MainUnit.MainForm.IntervalB.Text<>'')
    then
    begin
      Xmin:=Strtofloat(MainUnit.MainForm.IntervalA.Text);
      XMax:=Strtofloat(MainUnit.MainForm.IntervalB.Text);
    end else
    begin
      Xmin:=MainForm.Chart.BottomAxis.Minimum;
      XMax:=MainForm.Chart.BottomAxis.Maximum;
    end;
    XMarge:=0;
    TypeUnit.TimeTracedL:=TypeUnit.GetTimeInMilliSeconds(now);
    //рисуем лагранж
    result:=TracePolynomeLagrange(NodeInterPolation,Xmin-XMarge,XMax+XMarge,MainUnit.MainForm.Series1,TypeOriginalPolynomeLagrange,'');
    TypeUnit.TimeTracedL:=TypeUnit.GetTimeInMilliSeconds(now)-TypeUnit.TimeTracedL;

  end
  else
  begin
    case TypeUnit.SChooseLanguage of
      1:ProjectUnit.Info('Not data table point for build lagrange Function.',mtWarning);
      0:ProjectUnit.Info('Отсуствует данные в таблице точек для построения полинома Лагранжа.',mtWarning);
    end;
    result:=false;
    TypeUnit.TimeTracedL:=-1;
    Exit;
  end;

end;

//интерполирования обощенного лагранжа
Function TraceGeneralizingLagrange:boolean;
var XMin,XMax,XMarge:Real;
begin
  try
    //инициализация
      MainUnit.MainForm.Series5.Clear;
    if ((MainUnit.MainForm.TranslateFunction.Text<>'') and (UsersFunction.Quantity<>-1)) then
    begin
      SortData(UsersFunction);
      //запись узли интерполирования
      recordNodeInterpolation(NodeInterPolationGeneral,UsersFunction);
      //получить минимальное и максимальное значение Х в графике
      if (MainUnit.MainForm.IntervalA.Text<>'') and (MainUnit.MainForm.IntervalB.Text<>'')
      then
      begin
        Xmin:=Strtofloat(MainUnit.MainForm.IntervalA.Text);
        XMax:=Strtofloat(MainUnit.MainForm.IntervalB.Text);
      end else
      begin
        Xmin:=MainForm.Chart.BottomAxis.Minimum;
        XMax:=MainForm.Chart.BottomAxis.Maximum;
      end;
      XMarge:=0;
      //рисовать обобщенную формулу лагранжа
      TypeUnit.TimeTracedGL1:=TypeUnit.GetTimeInMilliSeconds(now());
      result:=TracePolynomeLagrange(NodeInterPolationGeneral,Xmin-XMarge,XMax+XMarge,
          MainUnit.MainForm.Series5,TypeGeneralizedPolynomeLagrange,MainUnit.MainForm.TranslateFunction.Text);
      if not result then
      begin
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('Incorret Translate Expression',mtWarning);
          0:ProjectUnit.Info('Неверная структурообразующая формула',mtWarning);
        end;
        TypeGeneralizedPolynomeLagrange:='';
        TypeUnit.TimeTracedGL1:=-1;
      end
      else
        begin
          MainUnit.MainForm.Series5.Active:=True;
          TypeUnit.TimeTracedGL1:=TypeUnit.GetTimeInMilliSeconds(now())-TypeUnit.TimeTracedGL1;
        end;
    end else
    begin
      if (UsersFunction.Quantity=-1) then
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('Not data table points for build generalised lagrange polynom I',mtWarning);
          0:ProjectUnit.Info('Отсуствует данные в таблице точек для построения первого вида обобщённого полинома Лагранжа',mtWarning);
        end
      else
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('Incorret Translate Expression',mtWarning);
          0:ProjectUnit.Info('Неверная структурообразующая формула',mtWarning);
        end;
      result:=False;
      TypeGeneralizedPolynomeLagrange:='';
      TypeUnit.TimeTracedGL1:=-1;
      Exit;
    end;
  Except
    result:=False;
    TypeGeneralizedPolynomeLagrange:='';
  end;
end;

//интерполирования обощенного лагранжа
Function TraceGeneralizingLagrangeII:boolean;
var XMin,XMax,XMarge:Real;
  b:boolean;
begin
  try
    //инициализация
    MainUnit.MainForm.Series6.Clear;
    try
      if (CalculStringFunction(MainUnit.MainForm.TranslateFunction.Text,0)=0) 
      then b:=true 
      else b:=false
    Except
      b:=false;
    end;
    if ((MainUnit.MainForm.TranslateFunction.Text<>'') and b)
    then
    begin
      if (UsersFunction.Quantity<>-1) then
      begin
        SortData(UsersFunction);
        //запись узли интерполирования
        recordNodeInterpolation(NodeInterPolationGeneral,UsersFunction);
        //получить минимальное и максимальное значение Х в графике
        if (MainUnit.MainForm.IntervalA.Text<>'') and (MainUnit.MainForm.IntervalB.Text<>'')
        then
        begin
          Xmin:=Strtofloat(MainUnit.MainForm.IntervalA.Text);
          XMax:=Strtofloat(MainUnit.MainForm.IntervalB.Text);
        end else
        begin
          Xmin:=MainForm.Chart.BottomAxis.Minimum;
          XMax:=MainForm.Chart.BottomAxis.Maximum;
        end;
        XMarge:=0;
        //рисовать обобщенную формулу лагранжа
        TypeUnit.TimeTracedGL2:=TypeUnit.GetTimeInMilliSeconds(now);
        result:=TracePolynomeLagrange(NodeInterPolationGeneral,Xmin-XMarge,XMax+XMarge,
            MainUnit.MainForm.Series6,TypeGeneralizedPolynomeLagrangeII,MainUnit.MainForm.TranslateFunction.Text);
        if not result then
        begin
          case TypeUnit.SChooseLanguage of
            1:ProjectUnit.Info('Incorret Translate Expression',mtWarning);
            0:ProjectUnit.Info('Неверная структурообразующая формула',mtWarning);
          end;
          TypeGeneralizedPolynomeLagrangeII:='';
          TypeUnit.TimeTracedGL2:=-1;
        end
        else
        begin
          MainUnit.MainForm.Series6.Active:=True;
          TypeUnit.TimeTracedGL2:=TypeUnit.GetTimeInMilliSeconds(now)-TypeUnit.TimeTracedGl2;
        end;
      end else
      begin
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('Not data table points for build generalised lagrange polynom',mtWarning);
          0:ProjectUnit.Info('Отсуствует данные в таблице точек для построения второго вида обобщённого полинома Лагранжа',mtWarning);
        end;
        result:=False;
        TypeGeneralizedPolynomeLagrangeII:='';
        Exit;
      end;
    end
    else
    begin
      if MainUnit.MainForm.TranslateFunction.Text=''
      then
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('Not data translate function for build II generalised lagrange polynom',mtWarning);
          0:ProjectUnit.Info('Поля Структурообразующая функция пуста',mtWarning);
        end
      else
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('Value Translate Function when x=0 must be equal at 0',mtWarning);
          0:ProjectUnit.Info('Значение Структурообразующей функции в точке х=0 не равен нулю ',mtWarning);
        end;
      result:=False;
      TypeGeneralizedPolynomeLagrangeII:='';
      Exit;
    end;
  Except
    result:=False;
    TypeGeneralizedPolynomeLagrangeII:='';
  end;
end;


//рисование обобщённой функции ошибки Лагранжа
Function TraceErrorGeneralizing(TranslateFunc:string;UserF: TUsersFunction;
  NodeInterP: TNodeInterPolation):boolean;
var i:Integer;
    Dy,x,LaGrangeValue,yvalue,XMarge,XMin,XMax:Real;
    s:string;
begin
  result:=true;
  try
    if TypeUnit.UsersFunction.Quantity<>-1 then   //если есть данных в таблице точек
    begin
      //если активизированна ввод данных через задания точек
      if MainUnit.MainForm.ActiveEnterDataWithPoints.Checked then
      begin
        MainUnit.MainForm.Series10.Clear; //очистим график
        //расчёт точечная функия ощибки
        for i:=0 to UserF.Quantity do  //для каждых точек в таблице
        begin
          x:=UserF.value[i].x;
          //находим значение обощенного лагранжа
          LaGrangeValue:=LagrangeG(TranslateFunc,NodeInterP,x,s);
          //находим разность
          Dy:=Abs(UserF.value[i].y - LaGrangeValue);
          //рисуем график
          MainUnit.MainForm.Series10.AddXY(x,Dy);
        end;
        MainUnit.MainForm.Series10.Active:=True;
      end else
      begin
        MainUnit.MainForm.Series10.Clear; //очистим график
        MainUnit.MainForm.Series10.Active:=False;
      end;
      //если активизированна ввод данных через задания функции
      if ((MainUnit.MainForm.ActiveEnterDataWithFunction.Checked)
              and (MainUnit.MainForm.UsersAnalytiqueFunction.Text<>''))
      then
      begin
        //отчистим график
        MainUnit.MainForm.Series8.Clear;
        //получить минимальное и максимальное значение Х в графике
        if (MainUnit.MainForm.IntervalA.Text<>'') and (MainUnit.MainForm.IntervalB.Text<>'')
        then
        begin
          Xmin:=Strtofloat(MainUnit.MainForm.IntervalA.Text);
          XMax:=Strtofloat(MainUnit.MainForm.IntervalB.Text);
        end else
        begin
          Xmin:=UsersFunction.value[0].x;
          XMax:=UsersFunction.value[high(UsersFunction.value)].x;
        end;
        //определяем шаг
        XMarge:=(Xmax-XMin)/TypeUnit.SStepTraceErrorFunction;
        while XMin<=XMax do
        begin
          try
            //находим значение обощенного лагранжа
            LaGrangeValue:=LaGrangeG(TranslateFunc,NodeInterP,XMin,s);
            //находим соотыествующое значение Х через структурообразующего функции
            yvalue:=CalculStringFunction(MainUnit.MainForm.UsersAnalytiqueFunction.Text,XMin);
            //находим разность
            Dy:=(yvalue - LaGrangeValue);
          Except
            raise;
          end;
          //рисуем график
          MainUnit.MainForm.series8.AddXY(XMin,Dy);
          //получения шаг для след. интерации
          XMin:=XMin+XMarge;
        end;
        MainUnit.MainForm.Series8.Active:=True;
      end else
      begin
        MainUnit.MainForm.Series8.Clear;//отчистим график
        MainUnit.MainForm.Series8.Active:=False;
      end;
    end else
    begin
      case TypeUnit.SChooseLanguage of
        1:ProjectUnit.Info('Not data  table points for build Generalised Lagrange Function error',mtWarning);
        0:ProjectUnit.Info('Отсуствует данные в таблице точек для построения обобщённой функции ошибки лагранжа',mtWarning);
      end;
      result:=false;
      Exit;
    end;
  Except
    MainUnit.MainForm.Series8.Clear;//отчистим график
    MainUnit.MainForm.Series8.Active:=False;
    result:=false;
  end;
end;

//рисование обобщённой функции ошибки Лагранжа II
Function TraceErrorGeneralizingII(TranslateFunc:string;UserF: TUsersFunction;
  NodeInterP: TNodeInterPolation):boolean;
var i:Integer;
    Dy,x,LaGrangeValue,yvalue,XMarge,XMin,XMax:Real;
    s:string;
    b:boolean;
begin
  result:=true;
  try
    try
      if (CalculStringFunction(MainUnit.MainForm.TranslateFunction.Text,0)=0) 
      then b:=true 
      else b:=false
    Except
      b:=false;
    end;
    if ((MainUnit.MainForm.TranslateFunction.Text<>'') and b)
    then
    begin
      if TypeUnit.UsersFunction.Quantity<>-1 then   //если есть данных в таблице точек
      begin
        //если активизированна ввод данных через задания точек
        if MainUnit.MainForm.ActiveEnterDataWithPoints.Checked then
        begin
          MainUnit.MainForm.Series13.Clear; //очистим график
          //расчёт точечная функия ощибки
          for i:=0 to UserF.Quantity do  //для каждых точек в таблице
          begin
            x:=UserF.value[i].x;
            //находим значение обощенного лагранжа
            LaGrangeValue:=LagrangeGII(TranslateFunc,NodeInterP,x,s);
            //находим разность
            Dy:=Abs(UserF.value[i].y - LaGrangeValue);
            //рисуем график
            MainUnit.MainForm.Series13.AddXY(x,Dy);
          end;
          MainUnit.MainForm.Series13.Active:=True;
        end else
        begin
          MainUnit.MainForm.Series13.Clear; //очистим график
          MainUnit.MainForm.Series13.Active:=False;
        end;
        //если активизированна ввод данных через задания функции
        if ((MainUnit.MainForm.ActiveEnterDataWithFunction.Checked)
                and (MainUnit.MainForm.UsersAnalytiqueFunction.Text<>''))
        then
        begin
          //отчистим график
          MainUnit.MainForm.Series12.Clear;
          //получить минимальное и максимальное значение Х в графике
          if (MainUnit.MainForm.IntervalA.Text<>'') and (MainUnit.MainForm.IntervalB.Text<>'')
          then
          begin
            Xmin:=Strtofloat(MainUnit.MainForm.IntervalA.Text);
            XMax:=Strtofloat(MainUnit.MainForm.IntervalB.Text);
          end else
          begin
            Xmin:=UsersFunction.value[0].x;
            XMax:=UsersFunction.value[high(UsersFunction.value)].x;
          end;
          //определяем шаг
          XMarge:=(Xmax-XMin)/TypeUnit.SStepTraceErrorFunction;
          while XMin<=XMax do
          begin
            try
              //находим значение обощенного лагранжа
              LaGrangeValue:=LaGrangeGII(TranslateFunc,NodeInterP,XMin,s);
              //находим соотыествующое значение Х через структурообразующего функции
              yvalue:=CalculStringFunction(MainUnit.MainForm.UsersAnalytiqueFunction.Text,XMin);
              //находим разность
              Dy:=(yvalue - LaGrangeValue);
            Except
              raise;
            end;
            //рисуем график
            MainUnit.MainForm.Series12.AddXY(XMin,Dy);
            //получения шаг для след. интерации
            XMin:=XMin+XMarge;
          end;
          MainUnit.MainForm.Series12.Active:=True;
        end else
        begin
          MainUnit.MainForm.Series12.Clear;//отчистим график
          MainUnit.MainForm.Series12.Active:=False;
        end;
      end else
      begin
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('Not data table points for build generalised error lagrange polynom',mtWarning);
          0:ProjectUnit.Info('Отсуствует данные в таблице точек для построения второго вида обобщённой функции ошибки Лагранжа',mtWarning);
        end;
        result:=false;
        Exit;
      end;
    end
    else
    begin
      if MainUnit.MainForm.TranslateFunction.Text=''
      then
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('Not data translate function for build II generalised lagrange polynom',mtWarning);
          0:ProjectUnit.Info('Поля Структурообразующая функция пуста',mtWarning);
        end
      else
        case TypeUnit.SChooseLanguage of
          1:ProjectUnit.Info('Value Translate Function when x=0 must be equal at 0',mtWarning);
          0:ProjectUnit.Info('Значение Структурообразующей функции в точке х=0 не равен нулю ',mtWarning);
        end;
      result:=False;
      Exit;
    end;

  Except
    MainUnit.MainForm.Series12.Clear;//отчистим график
    MainUnit.MainForm.Series12.Active:=False;
    result:=false;
  end;
end;

//рисование функции ошибки Лагранжа
Function TraceErrorLagrage(UserF: TUsersFunction; NodeInterP: TNodeInterPolation):boolean;
var i:Integer;
    Dy,x,LaGrangeValue,yvalue,XMarge,XMin,XMax:Real;
    s:string;
begin
  result:=true;
  //если есть данных в таблице точек
    if TypeUnit.UsersFunction.Quantity<>-1 then
    begin
      //если активизированна ввод данных через задания функции
      if ((MainUnit.MainForm.ActiveEnterDataWithFunction.Checked)
            and (MainUnit.MainForm.UsersAnalytiqueFunction.Text<>''))
      then
      begin
        //отчистим график
         MainUnit.MainForm.Series7.Clear;
        //получить минимальное и максимальное значение Х в графике
        if (MainUnit.MainForm.IntervalA.Text<>'') and (MainUnit.MainForm.IntervalB.Text<>'')
        then
        begin
          Xmin:=Strtofloat(MainUnit.MainForm.IntervalA.Text);
          XMax:=Strtofloat(MainUnit.MainForm.IntervalB.Text);
        end else
        begin
          Xmin:=UsersFunction.value[0].x;
          XMax:=UsersFunction.value[high(UsersFunction.value)].x;
        end;
        //определяем шаг
         XMarge:=(Xmax-XMin)/TypeUnit.SStepTraceErrorFunction;
        while XMin<=XMax do
        begin
          //находим значение обощенного лагранжа
          LaGrangeValue:=Lagrange(NodeInterp,XMin,s);
          //находим соотыествующое значение Х через структурообразующего функции
          yvalue:=CalculStringFunction(MainUnit.MainForm.UsersAnalytiqueFunction.Text,XMin);
          //находим разность
          Dy:=(yvalue - LaGrangeValue);
          //рисуем график
          MainUnit.MainForm.series7.AddXY(XMin,Dy);
          //получения шаг для след. интерации
          XMin:=XMin+XMarge;
        end;
        MainUnit.MainForm.Series7.Active:=true;
      end
      else
      begin
        MainUnit.MainForm.series7.Clear;//отчистим график
        MainUnit.MainForm.Series7.Active:=False;
      end;

      //если активизированна ввод данных через задания точек
      if MainUnit.MainForm.ActiveEnterDataWithPoints.Checked then
      begin
        //расчёт точечная функия ощибки
        MainUnit.MainForm.series9.Clear;//очистим график
        for i:=0 to UserF.Quantity do //для каждых точек в таблице
        begin
          x:=UserF.value[i].x;
          //находим значение лагранжа
          LaGrangeValue:=Lagrange(NodeInterp,x,s);
          yvalue:=UserF.value[i].y;
          //находим разность
          Dy:=Abs(yvalue - LaGrangeValue);
          //рисуем график
          MainUnit.MainForm.series9.AddXY(x,Dy);
        end;
        MainUnit.MainForm.Series9.Active:=true;
      end else
      begin
        MainUnit.MainForm.series9.Clear; //отчистим график
        MainUnit.MainForm.Series9.Active:=False;
      end;

    end
    else
    begin
      case TypeUnit.SChooseLanguage of
        1:ProjectUnit.Info('Not Data in the table for builder Lagrange function error',mtWarning);
        0:ProjectUnit.Info('Отсуствует данные в таблице точек для построения функции ошибки лагранжа',mtWarning);
      end;
      result:=false;
      Exit;
    end;
end;



////***********************настройка график ***********************///
//проверка на возможнось регулирования график
function CanResizeChart(Chart:TChart):Boolean;
var i:Integer;
begin
  Result:=False;
  for i:=0 to Chart.SeriesCount-1 do //для все графики в компоненте
  begin
    if Chart.Series[i].YValues.Count <> 0 then
    begin
      //если сушествует графики то результат верно
      Result:=True;
      Exit;
    end else Result:=False;//если не сушествует графики то результат верно
  end;
end;

//получить минимальное значение ось каждого графика
function Max(VL : TChartValueList; StartIndex : integer = -1; EndIndex: integer = -1) : Double;
var i : integer;
begin
  result := -MinDouble;   //усновляем минимальное значение типа дубл
  if StartIndex = -1 then StartIndex := 0;
  if EndIndex = -1 then EndIndex := VL.Count-1;
  for i := StartIndex to EndIndex do begin  //для первого идекса до последного сделать
    if VL[i] > result then result := VL[i];//если значение больше результат то заменяем
  end;
end;

//получить максимальное значение ось графика
function Min(VL : TChartValueList; StartIndex : integer = -1; EndIndex: integer = -1) : Double;
var i : integer;
begin
  result := MaxDouble; //усновляем максимальное значение типа дубл
  if StartIndex = -1 then StartIndex := 0;
  if EndIndex = -1 then EndIndex := VL.Count-1;
  for i := StartIndex to EndIndex do begin   //для первого идекса до последного сделать
    if VL[i] < result then result := VL[i]; //если значение больше результат то заменяем
  end;
end;

//получить минимальное значение ось Х в графике
function GetMinX(Chart1:TChart;Mas:TSer):Double;
var aMin: array of Double;
    i:Integer;
    counter:integer;
begin
  if Mas.value<>nil then counter:=Mas.Quantity
  else counter:=Chart1.SeriesCount;
  SetLength(aMin,counter);  //установка размер массива
  for i:=0 to counter-1 do //для все графики в компоненте
  begin
    //сохраняем все минимальные значения Х для каждого графика
    if Mas.value<>nil then aMin[i]:=ExitDataUnit.Min(MainUnit.MainForm.Chart.Series[Mas.value[i]-1].XValues)
    else aMin[i]:=ExitDataUnit.Min(MainUnit.MainForm.Chart.Series[i].XValues);
  end;
  Result:=Math.MinValue(aMin);//установки минимальное значение из всех минимальных
end;

//получить максимальное значение ось Х в графике
function GetMaxX(Chart1:TChart;Mas:TSer):Double;
var aMax: array of Double;
  i,counter:Integer;
begin
  if Mas.value<>nil then counter:=Mas.Quantity
  else counter:=Chart1.SeriesCount;
  SetLength(aMax,counter);  //установка размер массива
  for i:=0 to counter-1 do  //для все графики в компоненте
  begin
    //сохраняем все максимальные значения Х для каждого графика
    if Mas.value<>nil then aMax[i]:=ExitDataUnit.Max(MainUnit.MainForm.Chart.Series[Mas.value[i]-1].XValues)
    else aMax[i]:=ExitDataUnit.Max(MainUnit.MainForm.Chart.Series[i].XValues);
  end;
  Result:=Math.MaxValue(aMax);//установки максимальное значение из всех максиальных
end;

//получить минимальное значение ось У в графике
function GetMinY(Chart1:TChart;Mas:TSer):Double;
var aMin: array of Double;
    i:Integer;
    counter:integer;
begin
  if Mas.value<>nil then counter:=Mas.Quantity
  else counter:=Chart1.SeriesCount;
  SetLength(aMin,counter);  //установка размер массива
  for i:=0 to counter-1 do //для все графики в компоненте
  begin
    //сохраняем все минимальные значения Y для каждого графика
    if Mas.value<>nil then aMin[i]:=ExitDataUnit.Min(MainUnit.MainForm.Chart.Series[Mas.value[i]-1].YValues)
    else aMin[i]:=ExitDataUnit.Min(MainUnit.MainForm.Chart.Series[i].YValues);
  end;
  Result:=Math.MinValue(aMin);//установки минимальное значение из всех минимальных
end;

//получить максимальное значение ось У в графике
function GetMaxY(Chart1:TChart;Mas:TSer):Double;
var aMax: array of Double;
  i,counter:Integer;
begin
  if Mas.value<>nil then counter:=Mas.Quantity
  else counter:=Chart1.SeriesCount;
  SetLength(aMax,counter);  //установка размер массива
  for i:=0 to counter-1 do  //для все графики в компоненте
  begin
    //сохраняем все максимальные значения Х для каждого графика
    if Mas.value<>nil then aMax[i]:=ExitDataUnit.Max(MainUnit.MainForm.Chart.Series[Mas.value[i]-1].YValues)
    else aMax[i]:=ExitDataUnit.Max(MainUnit.MainForm.Chart.Series[i].YValues);
  end;
  Result:=Math.MaxValue(aMax);//установки максимальное значение из всех максиальных
end;

//  регулирования ось график
procedure ResizeAxis (Chart:TChart;StartIndex : integer = -1; EndIndex: integer = -1);
//чтобы показать все точки график и добавь к ним отпушка
var
 aMin, aMax,{Margex,}Margey : double;
begin
  aMin:=TypeUnit.SAxisXLeftValueInterval;;// перерасчёт минимальное значение
  aMax:=TypeUnit.SAxisXRightValueInterval;// перерасчёт максимальное значение
  Margey :=(aMax-aMin) / TypeUnit.SMargeX; // 10% отпушка в каждом стороне
  Chart.BottomAxis.SetMinMax(aMin-margey, aMax+margey); // установка минимальное и максимальное значения
  amin:=TypeUnit.SAxisYLeftValueInterval;
  aMax:=TypeUnit.SAxisYRightValueInterval;
  Margey := (aMax-aMin) / TypeUnit.SMargeY; // 10% отпушка в каждом стороне
  Chart.LeftAxis.SetMinMax(aMin-margey, aMax+margey); // установка минимальное и максимальное значения
end;

//автоматическое регулирование экрана
Function Autoresize:boolean;
var aMin, aMax,margey,amin2,amax2 : double;
    CheckedMas:TSer;
    i:integer;
    Chart1:TChart;
begin
  result:=true;

  CheckedMas.Quantity:=0;
  CheckedMas.value:=nil;
  ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
  try
    //record data
    if TypeUnit.CheckDistinction[0].Checked then
    begin
      SetLength(CheckedMas.value,1);
      CheckedMas.Quantity:=1;
      CheckedMas.value[CheckedMas.Quantity-1]:=0;
    end
    else
    begin
      for i:=1 to TypeUnit.QCheck do
      begin
        if ((i<>2) and (i<>3) and (i<>9) and (i<>10)) and
          (TypeUnit.CheckDistinction[i].Checked)
          and (MainUnit.MainForm.Chart.Series[i-1].Active)
          and (MainUnit.MainForm.Chart.Series[i-1].XValues.Count <> 0)
          and (MainUnit.MainForm.Chart.Series[i-1].YValues.Count <> 0)
        then
        begin
          inc(CheckedMas.Quantity);
          SetLength(CheckedMas.value,CheckedMas.Quantity);
          CheckedMas.value[CheckedMas.Quantity-1]:=i;
        end;
      end;
    end;

    if (CheckedMas.value<>nil) and
        ((CheckedMas.Quantity>1) or
          ((CheckedMas.Quantity=1) and (CheckedMas.value[0]>0)))
    then
    begin
      aMin:=Roundto(GetMinX(Chart1,CheckedMas),-TypeUnit.SRoundValue);// перерасчёт минимальное значение
      aMax:=Roundto(GetMaxX(Chart1,CheckedMas),-TypeUnit.SRoundValue);// перерасчёт максимальное значение
      Margey :=Roundto((aMax-aMin) / TypeUnit.SMargeX,-TypeUnit.SRoundValue);// % отпушка в каждом стороне
      MainUnit.MainForm.Chart.BottomAxis.SetMinMax(Roundto(aMin-margey,-TypeUnit.SRoundValue), Roundto(aMax+margey,-TypeUnit.SRoundValue)); // установка минимальное и максимальное значения

      aMin2:=Roundto(GetMinY(Chart1,CheckedMas),-TypeUnit.SRoundValue);// перерасчёт минимальное значение
      aMax2:=Roundto(GetMaxY(Chart1,CheckedMas),-TypeUnit.SRoundValue);// перерасчёт максимальное значение
      Margey := Roundto((aMax2-aMin2) / TypeUnit.SMargeY,-TypeUnit.SRoundValue);// % отпушка в каждом стороне
      MainUnit.MainForm.Chart.LeftAxis.SetMinMax(Roundto(aMin2-margey,-TypeUnit.SRoundValue), Roundto(aMax2+margey,-TypeUnit.SRoundValue)); // установка минимальное и максимальное значения
    end else
    if (CheckedMas.value<>nil) and (CheckedMas.Quantity=1) and (CheckedMas.value[0]=0)
    then ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart)
    else
        if (CheckedMas.value=nil)
        then ExitDataUnit.ResizeAxis(MainUnit.MainForm.Chart);
  Except
    result:=false;
    CheckedMas.Quantity:=0;
    CheckedMas.value:=nil;
  end;
end;
////*********************** конец настройка график ***********************///




///*************************скрыть показать крывые***************************//////
//Свернуть указанной функции
Function HiddenSelectedFunction(Mas:TSer):boolean;
var
  I: Integer;
begin
  result:=true;
  try
    for I := 0 to Mas.Quantity - 1 do
      MainForm.Chart.Series[Mas.value[i]-1].visible:=false;
  Except
    result:=False;
  end;
end;

//Свернуть все функции, кроме указанной функции
Function HiddenAllExecptFunction(Mas:TSer):boolean;
var
  I: Integer;
begin
  result:=true;
  try
    for I := 0 to Mas.Quantity - 1 do
      MainForm.Chart.Series[Mas.value[i]-1].visible:=True;
  Except
    result:=False;
  end;
end;

//Развернуть все функции, кроме указанной функции
Function ShowAllFunction:boolean;
var
  I: Integer;
begin
  result:=true;
  for I := 0 to MainForm.Chart.SeriesCount - 3 do    //-2 axis
    if (MainUnit.MainForm.Chart.Series[i].XValues.Count <> 0 )
        and  (MainUnit.MainForm.Chart.Series[i].YValues.Count <> 0)
    then MainForm.Chart.Series[i].visible:=True
    else MainForm.Chart.Series[i].visible:=False;
end;

//Свернуть все функции
Function HiddenAllFunction:boolean;
var
  I: Integer;
begin
  result:=true;
  for I := 0 to MainForm.Chart.SeriesCount - 3 do    //-2 axis
    if MainForm.Chart.Series[i].visible
    then MainForm.Chart.Series[i].visible:=False;
end;

//развернуть и свернуть
Function HiddenShowFunction:boolean;
var CheckedMas:TSer;
    i:integer;
begin
  result:=true;
  ShowAllFunction;
  CheckedMas.Quantity:=0;
  CheckedMas.value:=nil;
  try
    //сохранение данные
    if TypeUnit.CheckDistinction[0].Checked then
    begin
      SetLength(CheckedMas.value,1);
      CheckedMas.Quantity:=1;
      CheckedMas.value[CheckedMas.Quantity-1]:=0;
    end
    else
    begin
      for i:=1 to TypeUnit.QCheck do
      begin
        if TypeUnit.CheckDistinction[i].Checked and (MainUnit.MainForm.Chart.Series[i-1].Active)
        then
        begin
          inc(CheckedMas.Quantity);
          SetLength(CheckedMas.value,CheckedMas.Quantity);
          CheckedMas.value[CheckedMas.Quantity-1]:=i;
        end;
      end;
    end;

    if (CheckedMas.value<>nil) and
        ((CheckedMas.Quantity>1) or
          ((CheckedMas.Quantity=1) and (CheckedMas.value[0]>0)))
    then
    begin
      case MainForm.HideFunction.ItemIndex of
        2://скрыть функции
          begin
            ShowAllFunction;
            ExitDataUnit.HiddenSelectedFunction(CheckedMas);
          end;
        1: //показать функции
          begin
            HiddenAllFunction;
            HiddenAllExecptFunction(CheckedMas);
          end;
      end;
    end
    else
      if (CheckedMas.value<>nil) and (CheckedMas.Quantity=1) and (CheckedMas.value[0]=0)
      then
      begin
        MainUnit.MainForm.HideFunction.ItemIndex:=0;
        ShowAllFunction;
      end
      else
        if (CheckedMas.value=nil)
        then
        begin
          MainUnit.MainForm.HideFunction.ItemIndex:=0;
          ShowAllFunction;
        end
  Except
    result:=false;
    CheckedMas.Quantity:=0;
    CheckedMas.value:=nil;
    MainUnit.MainForm.HideFunction.ItemIndex:=0;
    ShowAllFunction;
  end;
end;
///************************* конец скрыть показать крывые***************************//////

end.
