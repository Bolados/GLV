unit TypeUnit;

interface

uses
  bcParser,SysUtils,Grids,Series,StdCtrls,Forms,Menus,Controls,ExtCtrls;


{$I mapFile.inc}

Const QCheck=13;

type TUserFunc = record      //тип точки
                      x:Real; //абсцисс Х
                      y:Real; //абсцисс У
                      b:Boolean;// выбран
                    end;
     TUsersFunction = record    // тип таблица точек
                        Quantity:Integer; // количество
                        value: array of TUserFunc; ///la ou est enregistree les donnees entree par l utilisateur
                      end;
      TNodeInterPolation = TUsersFunction; //тип интерполироваые узли

     TSer = record    // тип таблица точек
                        Quantity:Integer; // количество
                        value: array of integer; ///la ou est enregistree les donnees entree par l utilisateur

                      end;

  Function FormatDT:TFormatSettings;
  Function GetTimeInMilliSeconds(theTime : TTime): Int64;

  Var
    ///Setting Variable
       SRoundValue:Integer;
       SPrecision:Extended;
       SAxisXLeftValueInterval:Extended;
       SAxisXRightValueInterval:Extended;
       SAxisYLeftValueInterval:Extended;
       SAxisYRightValueInterval:Extended;
       SActiveEnterDataWithFunction:Boolean;
       SActiveExitDataFormules:Boolean;
       SActiveGraphe:Boolean;
       SActiveEnterDataPoints:Boolean;
       SActiveControlFunction:Boolean;
       SActiveTableValueTracedUsersAnalytiqueFunction:Boolean;
       SActiveTableValueTracedLaGrangeFunction:Boolean;
       SActiveTableValueTracedGeneralizingFunction:Boolean;
       SActiveTableValueTracedGeneralizingFunctionII:Boolean;
       SStepTraceUsersAnalytiqueFunction:Integer;
       SStepTraceLagrangeAndGeneralizingFunction:Integer;
       SStepTraceErrorFunction:Integer;
       SDepthOfhistory:Integer;
       SChooseLanguage:Integer;
       SWithoutRestriction:boolean;
       SDateFrom,SDateTo:TDate;
       STimeFrom,STimeTo:TTime;
       SActiveGraphUserFunctin,SActiveGraphLagrange,SActiveGraphGeneralised,SActiveGraphGeneralisedII,
       SActiveGraphLagrangeError,SActiveGraphGeneralisedError,SActiveGraphGeneralisedErrorII,
       SActiveGraphControlFunction:boolean;
       SMargeX,SmargeY:Integer;
       SPenWIdthNotDistincted,SPenWIdthDistincted:Integer;
    ///  end setting variable
    ///
    ///  MainUnit Variable
    ///
      UsersFunction:TUsersFunction;  // точки заданных пользователю
      AllPointUsersFuncForAddPoints:TUsersFunction;
      NodeInterPolation:TNodeInterPolation; //узлы интерполирования лагранжа
      NodeInterPolationGeneral:TNodeInterPolation; //узлы интерполирования обобщенного лагранжа
      SelectedCol,SelectedRow:Integer; //выбранный столбец и выбранная строка
      //EventSave:Boolean;//событие для происхождения изменения в проект
      TypeOriginalPolynomeLagrange:string; // тип полинома Лагранжа
      TypeGeneralizedPolynomeLagrange:string; // тип обобщенного полинома Лагранжа первого вида
      TypeGeneralizedPolynomeLagrangeII:string; // тип обобщенного полинома Лагранжа второго вида
      bcp: TbcParser; //переменый для синтаксичемного анализатор
      Veriffunction:string;//функция для проверки результата
      ///  End MainUnit Variable
    ///
    ///
      linkProject:string;
      DateTimeCreateProject:TDateTime;
      PanelDistinction:TGroupBox;
      CheckDistinction:array [0..QCheck] of TCheckBox;
      LDT:integer;

      TimeTracedF,TimeTracedL,TimeTracedGL1,TimeTracedGL2:Int64;



implementation

Function FormatDT:TFormatSettings;
begin
  FormatDT.ShortDateFormat:='dd/mm/yyyy';
  FormatDT.DateSeparator  :='/';
  FormatDT.LongTimeFormat :='hh:nn:ss';
  FormatDT.TimeSeparator  :=':';
end;

Function GetTimeInMilliSeconds(theTime : TTime): Int64;
var
Hour, Min, Sec, MSec: Word;
begin
DecodeTime(theTime,Hour, Min, Sec, MSec);

Result := (Hour * 3600000) + (Min * 60000) + (Sec * 1000) + MSec;
end;

end.
