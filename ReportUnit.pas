unit ReportUnit;

interface

// используемые библиотеке
uses
  SysUtils,Windows,Forms,Dialogs,ComCtrls,ComObj,Variants,Graphics,StdCtrls,ShellAPI,
  Classes,Controls,Chart,Series;
//объявление публичных обрабочиков
    //открыие отчёта в MS Word
    procedure OpenInWord(FileName:TFileName);
    //создание отчёта текущего процесса моделирования
    procedure SentToReport(NameProject:TFileName;DateTimeOnString,StringDateTime:String);
    //создание итогового отчёта
    procedure ReportWord(SavedNameFile,NameProject:TFileName;FromReport:String='01/01/1900 00:00:00';
      ToReport:String='01/01/9999 00:00:00');

implementation

//используемые модулы
uses TypeUnit,MainUnit,ExitDataUnit,LanguageUnit,ProjectUnit;


//************Формализирования отчёта ************/////

//Функция записывает новый текст для закладки с именем aBmName.
//Функция возвращает значение True, если закладка найдена и её текст изменён
//и False - если закладка не найдена.
//Переустановка текста закладки выплоняется так:
//- Получаем ссылку на объект-диапазон, который содержит текст закладки.
//- Удаляем закладку.
//- Устанавливаем новый текст для объекта-диапазона.
//- Создаём новую закладку с диапазоном, который содержит новый текст.
function SetBmText(var aBms : Variant; const aBmName, aText : String) : Boolean;
var
  Bm, Rng : Variant;
begin
  //Проверяем - существует ли закладка с заданным именем.
  Result := aBms.Exists(aBmName);
  //Если закладка не найдена - выходим.
  if not Result then Exit;

  //Ссылка на закладку.
  Bm := aBms.Item(aBmName);
  //Ссылка на диапазон, связанный с закладкой.
  Rng := Bm.Range;
  //Удаление закладки.
  Bm.Delete;
  //Заменяем текст в диапазоне.
  Rng.Text := aText;
  //Добавляем новую закладку с таким же именем.
  aBms.Add(aBmName, Rng);
end;

//Функция удаляет новый текст для закладки с именем aBmName.
//Функция возвращает значение True, если закладка найдена и её текст удалён
//и False - если закладка не найдена.
function DeleteBmText(var aBms : Variant; const aBmName: String) : Boolean;
var
  Bm, Rng : Variant;
begin
  //Проверяем - существует ли закладка с заданным именем.
  Result := aBms.Exists(aBmName);
  //Если закладка не найдена - выходим.
  if not Result then Exit;

  //Ссылка на закладку.
  Bm := aBms.Item(aBmName);
  //Ссылка на диапазон, связанный с закладкой.
  Rng := Bm.Range;
  //Удаление закладки.
  Bm.Delete;
  //удаляем текст в диапазоне.
  Rng.Delete;
end;

//Функция записывает новую картинку путь которого есть aText для закладки с именем aBmName.
//Функция возвращает значение True, если закладка найдена и её текст изменён
//и False - если закладка не найдена.
function SetBmImage(var aBms : Variant; const aBmName, aText : String) : Boolean;
var
  Bm, Rng : Variant;
begin
  //Проверяем - существует ли закладка с заданным именем.
  Result := aBms.Exists(aBmName);
  //Если закладка не найдена - выходим.
  if not Result then Exit;

  //Ссылка на закладку.
  Bm := aBms.Item(aBmName);
  //Ссылка на диапазон, связанный с закладкой.
  Rng := Bm.Range;
  //Удаление закладки.
  Bm.Delete;
  //Заменяем текст в диапазоне.
  Rng.InlineShapes.AddPicture(FileName := aText,
    LinkToFile:=False, SaveWithDocument:=True);
  //Добавляем новую закладку с таким же именем.
  aBms.Add(aBmName, Rng);
end;

//обрабочик  загрузки документов находящийя в директории Dir и имеющийся расширения .doc
procedure LoadFilesByMask(l: TStrings; const Dir:String; Ext: string='*');
var intFound: Integer;
    SearchRec: TSearchRec;
begin
  l.Clear;
  intFound := SysUtils.FindFirst(Dir + Ext, faAnyFile, SearchRec);
  while intFound = 0 do
  begin
    l.Add(ExtractFileName(Dir + SearchRec.Name));
    intFound := SysUtils.FindNext(SearchRec);
  end;
  SysUtils.FindClose(SearchRec);
end;

//************Разделения слова по признак Parquoi и получения левой Partiegauche
// и остаточной части строка Partiedroite
procedure Decoupage(Lemotadecouper,Parquoi:string;var Partiegauche,Partiedroite:string);
var k:Integer;
begin
  for k:=1 to Length(Lemotadecouper) do //посмотриваем вес строки
  begin
    //если в текуший интерации встречаем признак то выходим из интерации
    if Lemotadecouper[k]=Parquoi then begin Break;Break;end;
  end;
  if k<>0 then  //если нашли признак
  begin
    //разделяем первый часть
    Partiegauche:=Copy(Lemotadecouper,1,k-1);
    //разделяем второй часть
    Partiedroite:=Copy(Lemotadecouper,k+1,Length(Lemotadecouper)-k+1);
  end;
end;

// филтрация документов по дату и время
Procedure SetRealList(var l: TListBox;FromReport:String='01/01/1900 00:00:00';
      ToReport:String='01/01/9999 00:00:00');
var
  I: Integer;
  S,S1,N,D,T:string;
begin
  I:=0;
  while I < L.Items.Count  do
  begin
    S:=L.Items[i];
    //получение имя
    Decoupage(S,'_',N,S);
    //получение Дата
    Decoupage(S,'_',D,S);
    D:=StringReplace(D,'-','/',[rfReplaceAll]);
    //получение Время
    Decoupage(S,'_',T,S);
    Decoupage(T,'.',T,S);
    T:=StringReplace(T,'-',':',[rfReplaceAll]);
    if ( (length(s)=3)
        and ( ((N='Отчет') or (N='Report'))
              and ( StrToDateTime(D+' '+T,TypeUnit.FormatDT) > StrToDateTime(FromReport,TypeUnit.FormatDT) )
              and ( StrToDateTime(D+' '+T,TypeUnit.FormatDT) < StrToDateTime(ToReport,TypeUnit.FormatDT) )
            )
        )
    then  i:=i+1
    else
    begin
      L.Items.Delete(i);
    end;
  end;
end;

//обрабочик создания итогового отчёта
procedure ReportWord(SavedNameFile,NameProject:TFileName;FromReport:String='01/01/1900 00:00:00';
      ToReport:String='01/01/9999 00:00:00');
var List:TListBox;
    s,sg,sg1,sg2,ReportName,StringDateTime:string;
    i:integer;
    wdApp, wdDocs, wdDoc,wdBms, wdBm, wdRng, wdTbls, wdTbl, wdRow : Variant;
    wdApp2, wdDocs2, wdDoc2: Variant;
begin
  // указание курсора в состоянииобработки
  MainUnit.MainForm.Cursor:=CrHourGlass;
  //файл шаблоны
  case TypeUnit.SChooseLanguage of
    1:
      begin
        sg:=ExtractFilePath( Application.ExeName ) +'ConfigurationFile\templateGeneral1.doc';
        sg1:=ExtractFilePath( Application.ExeName ) +'ConfigurationFile\templateGeneral.doc';
        sg2:=ExtractFilePath( Application.ExeName ) +'ConfigurationFile\templateGeneralPerfect.doc';
      end;
    0:begin
        sg:=ExtractFilePath( Application.ExeName ) +'Конфигурационные файлы\templateGeneral1.doc';
        sg1:=ExtractFilePath( Application.ExeName ) +'Конфигурационные файлы\templateGeneral.doc';
        sg2:=ExtractFilePath( Application.ExeName ) +'Конфигурационные файлы\templateGeneralPerfect.doc';
      end;
  end;

  try
    try
      //Создание список для получение имя документы
      List:=TlistBox.Create(MainUnit.MainForm);
      with List do
      begin
        List.Parent:=MainUnit.MainForm;
        List.Items.Clear;
        List.Visible:=false;
      end;
      //Получение список документов с расшерением .doc
      case TypeUnit.SChooseLanguage of
        1: LoadFilesByMask(List.Items,ExtractFilePath( Application.ExeName )+
            'ReportFile\'+changeFileExt(ExtractFileName(NameProject),'')+'\','*.doc');
        0: LoadFilesByMask(List.Items,ExtractFilePath( Application.ExeName )+
            'Отчеты\'+changeFileExt(ExtractFileName(NameProject),'')+'\','*.doc');
      end;
      // фильтруем списку по дата и время
      SetRealList(List,FromReport,ToReport);
    Except
      case TypeUnit.SChooseLanguage of
        1: ProjectUnit.Info('An error occurred while creating the list of files in a directory. Action canceled.',mtWarning);
        0: ProjectUnit.Info('Произошло ошибку при созлании список файлы в директории. Действие отменено.',mtWarning);
      end;
      Exit;
    end;
    MainUnit.MainForm.Cursor:=CrHourGlass;
    // добавление в 1ой докумете остальные и сохранение его под указанной имени если существует документы
    if List.Items.Count<>0 then
    begin
      try
        try //попытаем создать приложение Ворд
          wdApp := CreateOleObject('Word.Application');
        except
          case TypeUnit.SChooseLanguage of
            1: ProjectUnit.Info('Unable to start MS Word. Action canceled.',mtWarning);
            0: ProjectUnit.Info('Не удалось запустить MS Word. Действие отменено.',mtWarning);
          end;
          Exit;
        end;
        //Делаем не видимым окно MS Word.
        wdApp.Visible := False;
        //Ссылка на коллекцию документов.
        wdDocs := wdApp.Documents;
        //Попытка открыть выбранный файл.
        try
          wdDoc := wdDocs.Open(FileName:=sg1);
        except
          try
            wdDoc := wdDocs.Open(FileName:=sg2);
          except
            case TypeUnit.SChooseLanguage of
              1: ProjectUnit.Info('Unable to open the template. Action canceled.',mtWarning);
              0: ProjectUnit.Info('Не удалось открыть шаблон. Действие отменено.',mtWarning);
            end;
            exit;
          end;
        end;
        //Подключаемся к коллекции закладок.
        wdBms := wdDoc.Bookmarks;
        //Ищем закладки с нужными именами и изменяем их текст, в соответствие
        //с данными, введёнными на форме.

        // Имя отчета и параметр времени
        if (FromReport='01/01/1900 00:00:00') and (ToReport='01/01/9999 00:00:00') then
          case TypeUnit.SChooseLanguage of
            1:ReportName:='Final Report ' +'[ without time restriction ]';
            0:ReportName:='Итоговый Отчёт ' +'[ без временных ограничении ]';
          end
        else
          case TypeUnit.SChooseLanguage of
            1:ReportName:='Final Report ' +'[ From '+ FromReport+' To ' + ToReport +' ]';
            0:ReportName:='Итоговый Отчёт ' +'[ От '+ FromReport +' До ' + ToReport +' ]';
          end;
        SetBmText(wdBms, 'NameReport',ReportName);
        //поставим Курсор в конец документа  итогового отчета.
        wdApp.Selection.WholeStory;
        wdApp.Selection.EndKey(6);

        try //попытаем создать второе приложение Ворд
            wdApp2 := CreateOleObject('Word.Application');
        except
          case TypeUnit.SChooseLanguage of
            1: ProjectUnit.Info('Unable to start MS Word 2. Action canceled.',mtWarning);
            0: ProjectUnit.Info('Не удалось запустить MS Word 2. Действие отменено.',mtWarning);
          end;
          Exit;
        end;
        MainUnit.MainForm.Cursor:=CrHourGlass;
         //Делаем не видимым окно MS Word.
        wdApp2.Visible := False;
        for I := 0 to List.Items.Count - 1 do
        begin
          //Ссылка на коллекцию документов.
          wdDocs2 := wdApp2.Documents;
          //Попытка открыть  документы в списке
          try
            case TypeUnit.SChooseLanguage of
              1: wdDoc2 := wdDocs2.Open(FileName:=ExtractFilePath( Application.ExeName )+
                  'ReportFile\'+changeFileExt(ExtractFileName(NameProject),'')+'\'+List.Items[i]);
              0: wdDoc2 := wdDocs2.Open(FileName:=ExtractFilePath( Application.ExeName )+
                  'Отчеты\'+changeFileExt(ExtractFileName(NameProject),'')+'\'+List.Items[i]);
            end;
          except
            case TypeUnit.SChooseLanguage of
              1: ProjectUnit.Info('Unable to open the document with the name "'+ List.Items[i]
                  +'". Action canceled.',mtWarning);
              0: ProjectUnit.Info('Не удалось открыть Документ с именем "'+List.Items[i]
                  +'". Действие отменено.',mtWarning);
            end;
            exit;
          end;
          //коппировка документ
          case TypeUnit.SChooseLanguage of
            1: wdDoc2.range(7).copy;
            0: wdDoc2.range(6).copy;
          end;

          //вставление в итоговом отчете
          wdApp.Selection.paste;
          //отпуска стр.
          if I < List.Items.Count-1 then
          begin
            wdApp.Selection.EndKey;
            wdApp.Selection.insertBreak(1);
          end;
          //поставим Курсор в конец документа
          wdApp.Selection.WholeStory;
          wdApp.Selection.EndKey(6);
          //закрываем документ
          wdDoc2.Close(False);
        end;
        //выхоим из второй приложение Word
        wdApp2.Quit;
        //осбовождем ресурсы
        wdApp2:=Unassigned;

      finally
         //Сохранять документ следует под другим именем, чтобы не перезаписать шаблон.
        wdApp.DisplayAlerts := False; //Отключаем режим показа предупреждений.
        try
          wdDoc.SaveAs(FileName:=SavedNameFile);
        except
          case TypeUnit.SChooseLanguage of
            1:
              begin
                wdDoc.SaveAs(FileName:=ExtractFilePath( Application.ExeName ) +'ReportFile\SumExport'+'.doc');
                SysUtils.DeleteFile(ExtractFilePath( Application.ExeName ) +'ReportFile\SumExport'+'.doc');
              end;
            0:
              begin
                wdDoc.SaveAs(FileName:=ExtractFilePath( Application.ExeName ) +'Отчеты\SumExport'+'.doc');
                SysUtils.DeleteFile(ExtractFilePath( Application.ExeName ) +'Отчеты\SumExport'+'.doc');
              end;
          end;
        end;
        //закрываем
        wdDoc.Close;
        //выходим
        wdApp.Quit;
        //осбовождем ресурсы
        wdApp:=Unassigned;
      end;
    end
    Else
    begin
      case TypeUnit.SChooseLanguage of
        1: ProjectUnit.Info('There is not a temporary report From '+ FromReport +
           ' To '+ToReport+'. Action canceled.',mtWarning);
        0: ProjectUnit.Info('Не существует ни одного времменного отчёта От '+ FromReport +
           ' До '+ToReport+'. Действие отменено.',mtWarning);
      end;
      exit;
    end;
  finally
    //осбовождем ресурсы списки документов
    List.Free;
    MainUnit.MainForm.Cursor:=CrDefault;
  end;
end;


//обраблчик отображения  отчета  в MS WORD
procedure OpenInWord(FileName:TFileName);
begin
  //запуск отчета в Ворде
  ShellExecute(0,'open',PChar(FileName),nil,nil,SW_SHOWNORMAL);
end;

// обрабочик полусения картинки построенные графики
Function ResizeChartandGetImage(NumSerie:TSer;Path:string):boolean;
var b,b1,z,bb,bx:boolean;
    s,v,vx,vy,px,py:integer;
    check:array[0..TypeUnit.QCheck] of boolean;
  I: Integer;
begin
  result:=False;
  //копия исх. значении
  b:= MainUnit.MainForm.DistinctionWithResize.Checked;
  s:=MainUnit.MainForm.HideFunction.ItemIndex;
  vx:=TypeUnit.SMargeX;
  vy:=TypeUnit.SMargeY;
  px:=TypeUnit.SPenWIdthNotDistincted;
  py:=TypeUnit.SPenWIdthDistincted;
  for I := 0 to TypeUnit.QCheck do
  begin
    Check[i]:=TypeUnit.CheckDistinction[i].Checked;
    TypeUnit.CheckDistinction[i].Checked:=False;
  end;
  MainUnit.MainForm.HideFunction.ItemIndex:=0;
  MainUnit.MainForm.ReportResize.Click;
  //установка новых значение
  try
    MainUnit.MainForm.DistinctionWithResize.Checked:=True;
    if (Numserie.Quantity=1) and (Numserie.value[0]>0) and (MainUnit.MainForm.Chart.Series[Numserie.value[0]-1].active) then
    BEGIN
      case Numserie.value[0] of
        1,4,5,6:
          BEGIN
            TypeUnit.CheckDistinction[2].Checked:=True;
            TypeUnit.CheckDistinction[3].Checked:=True;
          END;
        11:
          BEGIN
            //TypeUnit.CheckDistinction[5].Checked:=True;
            if MainUnit.MainForm.ControlFunction.Text=Typeunit.TypeOriginalPolynomeLagrange
            then TypeUnit.CheckDistinction[1].Checked:=True
            else
              if MainUnit.MainForm.ControlFunction.Text=Typeunit.TypeGeneralizedPolynomeLagrange
              then TypeUnit.CheckDistinction[4].Checked:=True;
                if MainUnit.MainForm.ControlFunction.Text=Typeunit.TypeGeneralizedPolynomeLagrangeII
                then TypeUnit.CheckDistinction[6].Checked:=True;
          END;
        7:
          BEGIN
            TypeUnit.CheckDistinction[9].Checked:=True;
          END;
        8:
          BEGIN
            TypeUnit.CheckDistinction[10].Checked:=True;
          END;
        12:
          BEGIN
            TypeUnit.CheckDistinction[13].Checked:=True;
          END;
      end;
      TypeUnit.CheckDistinction[Numserie.value[0]].Checked:=True;
      TypeUnit.SMargeX:=10;
      TypeUnit.SMargeY:=10;
      TypeUnit.SPenWIdthNotDistincted:=2;
      TypeUnit.SPenWIdthDistincted:=4;
      MainUnit.MainForm.HideFunction.ItemIndex:=1;
      MainUnit.MainForm.ReportResize.Click;
      MainUnit.MainForm.Chart.SaveToBitmapFile(Path); //создаем изображение графика
      result:=true;
    END
    ELSE
      if (Numserie.Quantity=1) and (Numserie.value[0]=0) then
      BEGIN
        MainUnit.MainForm.Chart.SaveToBitmapFile(Path); //создаем изображение графика
        result:=true;
        Exit;
      END
      ELSE
        if (Numserie.Quantity>1) then
        BEGIN
          bx:=true;
          for I := 0 to Numserie.Quantity - 1 do
          begin
            if not (MainUnit.MainForm.Chart.Series[Numserie.value[i]-1].active)
            then
            begin
              bx:=false;
              break;
            end
            else
            begin
              case Numserie.value[0] of
                1,4,5,6:
                  BEGIN
                    TypeUnit.CheckDistinction[2].Checked:=True;
                    TypeUnit.CheckDistinction[3].Checked:=True;
                  END;
                11:
                  BEGIN
                    if MainUnit.MainForm.ControlFunction.Text=Typeunit.TypeOriginalPolynomeLagrange
                    then TypeUnit.CheckDistinction[1].Checked:=True
                    else
                      if MainUnit.MainForm.ControlFunction.Text=Typeunit.TypeGeneralizedPolynomeLagrange
                      then TypeUnit.CheckDistinction[4].Checked:=True;
                        if MainUnit.MainForm.ControlFunction.Text=Typeunit.TypeGeneralizedPolynomeLagrangeII
                        then TypeUnit.CheckDistinction[6].Checked:=True;
                  END;
                7:
                  BEGIN
                    TypeUnit.CheckDistinction[9].Checked:=True;
                  END;
                8:
                  BEGIN
                    TypeUnit.CheckDistinction[10].Checked:=True;
                  END;
                12:
                  BEGIN
                    TypeUnit.CheckDistinction[13].Checked:=True;
                  END;
              end;
              TypeUnit.CheckDistinction[Numserie.value[i]].Checked:=True;
            end;
          end;
          if bx then
          begin
            TypeUnit.CheckDistinction[Numserie.value[0]].Checked:=True;
            TypeUnit.SMargeX:=10;
            TypeUnit.SMargeY:=10;
            MainUnit.MainForm.HideFunction.ItemIndex:=1;
            MainUnit.MainForm.ReportResize.Click;
            MainUnit.MainForm.Chart.SaveToBitmapFile(Path); //создаем изображение графика
          end;
          result:=bx;
        END
        ELSE
        BEGIN
           result:=false;
        END ;
  finally
    //востановление исх. значении
    MainUnit.MainForm.DistinctionWithResize.Checked:=b;
    MainUnit.MainForm.HideFunction.ItemIndex:=s;
    TypeUnit.SMargeX:=vx;
    TypeUnit.SMargeY:=vy;
    TypeUnit.SPenWIdthNotDistincted:=px;
    TypeUnit.SPenWIdthDistincted:=py;
    for I := 0 to TypeUnit.QCheck do
    begin
      TypeUnit.CheckDistinction[i].Checked:=Check[i];
    end;
    MainUnit.MainForm.ReportResize.Click;
    ExitDataUnit.Autoresize;
  end;
end;

//обрабочик сборки данных текущего процесса моделирования
procedure ExporterWord(NameFile:TFileName;StringDateTime:String);
const BmName='table';BmName2='tableexperience';
      BmName3='Table_values_user_function';BmName4='Table_values_Lagrange_function';
      BmName5='Table_values_Generalizing_function';BmName6='Table_values_experiences';
      BmName7='graph';BmName8='Table_values_Generalizing_functionII';
var S,s1,s2,p,ReportName:string;
    wdApp, wdDocs, wdDoc, wdBms, wdBm, wdRng, wdTbls, wdTbl, wdRow : Variant;
    i, j, Cnt ,m,n: Integer;
    xmin,xmax,xmarge,h:extended;
    b:boolean;
    CheckedMas:TSer;
begin
  //файл шаблоны
  case TypeUnit.SChooseLanguage of
    1:
      begin
        s:=ExtractFilePath( Application.ExeName ) +'ConfigurationFile\templatereal3.doc';
        s1:=ExtractFilePath( Application.ExeName ) +'ConfigurationFile\template.doc';
        s2:=ExtractFilePath( Application.ExeName ) +'ConfigurationFile\templateperfect.doc';
      end;
    0:begin
        s:=ExtractFilePath( Application.ExeName ) +'Конфигурационные файлы\templatereal3.doc';
        s1:=ExtractFilePath( Application.ExeName ) +'Конфигурационные файлы\template.doc';
        s2:=ExtractFilePath( Application.ExeName ) +'Конфигурационные файлы\templateperfect.doc';
      end;
  end;

  if ((not FileExists(s)) and (not FileExists(s1))) then
  begin
    case TypeUnit.SChooseLanguage of
      1: ProjectUnit.Info('not found a template for creating a report. Action canceled.',mtWarning);
      0: ProjectUnit.Info('не найден шаблон для создания отчёт. Действие отменено.',mtWarning);
    end;
    Exit;
  end
  else
  begin
    //если первый щаблон нет до установим запасный шаблон
    if not FileExists(s) then s:=s1;
  end;

  try
      try //попытаем создать приложение Ворд
        wdApp := CreateOleObject('Word.Application');
      except
        case TypeUnit.SChooseLanguage of
          1: ProjectUnit.Info('Unable to start MS Word. Action canceled.',mtWarning);
          0: ProjectUnit.Info('Не удалось запустить MS Word. Действие отменено.',mtWarning);
        end;
        Exit;
      end;

      //Делаем не видимым окно MS Word.
      wdApp.Visible := False;
      //Ссылка на коллекцию документов.
      wdDocs := wdApp.Documents;
      //Попытка открыть выбранный файл.
      try
        wdDoc := wdDocs.Open(FileName:=s);
      except
        try
          wdDoc := wdDocs.Open(FileName:=s2);
        except
          case TypeUnit.SChooseLanguage of
            1: ProjectUnit.Info('Unable to open the template. Action canceled.',mtWarning);
            0: ProjectUnit.Info('Не удалось открыть шаблон. Действие отменено.',mtWarning);
          end;
          exit;
        end;
      end;
      //Подключаемся к коллекции закладок.
      wdBms := wdDoc.Bookmarks;

      //Ищем закладки с нужными именами и изменяем их текст, в соответствие
      //с данными, введёнными на форме.

      // определние Имя отчета и параметр времени
      case TypeUnit.SChooseLanguage of
        1:ReportName:='Report ' +'['+ StringDateTime +']';
        0:ReportName:='Отчёт ' +'['+ StringDateTime +']';
      end;
      //установка значение
      SetBmText(wdBms, 'NameReport',ReportName);
      // установка Интервала исх. функции и структурообразующей
      if TypeUnit.SActiveEnterDataWithFunction then
      begin
        //добавления вводные данных
        SetBmText(wdBms, 'USER_FUNCTION',MainUnit.MainForm.UsersAnalytiqueFunction.Text);
        SetBmText(wdBms, 'LEFT_GRANT',MainUnit.MainForm.IntervalA.Text);
        SetBmText(wdBms, 'RIGHT_GRANT',MainUnit.MainForm.IntervalB.Text);
        SetBmText(wdBms, 'TRANSLATE_FUNCTION', MainUnit.MainForm.TranslateFunction.Text);
      end
      else     ReportUnit.DeleteBmText(wdBms, 'vide1'); //удаляем раздел
      //выводные формулы
      if TypeUnit.SActiveExitDataFormules then
      begin
        //установка выводные данные
        if MainUnit.MainForm.CheckBoxLagrangeFunction.Checked
        then SetBmText(wdBms, 'type_formule_lagrange',TypeOriginalPolynomeLagrange)
        else DeleteBmText(wdBms, 'type_formule_lagrange');
        if MainUnit.MainForm.CheckBoxErrorLagrangeFunction.Checked
        then SetBmText(wdBms, 'LagrangeAccuracy','C точностью '+MainUnit.MainForm.LagrangeAccuracy.Text+' т.е. '+Floattostr(strtofloat(MainUnit.MainForm.LagrangeAccuracy.Text)*100)+'%')
        else DeleteBmText(wdBms, 'LagrangeAccuracy');
        if MainUnit.MainForm.CheckBoxGeneralizingFunction.Checked
        then SetBmText(wdBms, 'type_generalised_formule_lagrange',TypeGeneralizedPolynomeLagrange)
        else DeleteBmText(wdBms, 'type_generalised_formule_lagrange');
        if MainUnit.MainForm.CheckBoxGeneralizingFunctionII.Checked
        then SetBmText(wdBms, 'type_generalised_formule_lagrangeII',TypeGeneralizedPolynomeLagrangeII)
        else DeleteBmText(wdBms, 'type_generalised_formule_lagrangeII');
        if MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.Checked
        then SetBmText(wdBms, 'GeneralisedAccuracy','C точностью '+MainUnit.MainForm.GeneralisedAccuracy.Text+' т.е. '+Floattostr(strtofloat(MainUnit.MainForm.GeneralisedAccuracy.Text)*100)+'%')
        else DeleteBmText(wdBms, 'GeneralisedAccuracy');
        if MainUnit.MainForm.CheckBoxErrorGeneralizingFunctionII.Checked
        then SetBmText(wdBms, 'GeneralisedAccuracyII','C точностью '+MainUnit.MainForm.GeneralisedAccuracyII.Text+' т.е. '+Floattostr(strtofloat(MainUnit.MainForm.GeneralisedAccuracyII.Text)*100)+'%')
        else DeleteBmText(wdBms, 'GeneralisedAccuracyII');
      end else ReportUnit.DeleteBmText(wdBms, 'vide2');// удаление раздела
      // проверочная формула
      if TypeUnit.SActiveControlFunction and MainUnit.MainForm.Series11.Active then
      begin
        //установка данных проверочной формулы
         SetBmText(wdBms, 'verification_function',MainUnit.MainForm.ControlFunction.Text);
      end
      else ReportUnit.DeleteBmText(wdBms, 'vide3');// удаление раздела

      //узли интерполяции
      if  not TypeUnit.SActiveEnterDataPoints
      then ReportUnit.DeleteBmText(wdBms,'vide') //удаляем раздел
      else
      begin
        //добавление данных узлов
        if not wdBms.Exists(BmName) then
        begin
          case TypeUnit.SChooseLanguage of
            1: MessageBox(0, 'In the document there is no bookmark named "' + BmName + '". Action canceled.'
                ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            0: MessageBox(0, 'В документе нет закладки с именем "' + BmName + '". Действие отменено.'
                ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
          end;
          Exit;
        end
        else
        begin
          //Ссылка на закладку.
          wdBm := wdBms.Item(BmName);
          //Ссылка на диапазон, связанный с закладкой.
          wdRng := wdBm.Range;
          //Удаление закладки.
          wdBm.Delete;
          //Ссылка на коллекцию таблиц.
          wdTbls := wdDoc.Tables;
          //Определеляем, какой таблице принадлежит диапазон закладки.
          wdTbl := Unassigned;
          for i := 1 to wdTbls.Count do
            if wdRng.InRange(wdTbls.Item(i).Range) then begin
              wdTbl := wdTbls.Item(i);
              Break;
            end;
          if VarIsClear(wdTbl) then
          begin
            case TypeUnit.SChooseLanguage of
              1: MessageBox(0, 'Bookmark with name "' + BmName7 + '" not belong to the table.'
                  + ' The action was canceled.', 'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              0: MessageBox(0, 'Закладка с именем "' + BmName7 + '" не принадлежит таблице.'
                  + ' Действие отменено.', 'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            end;
            Exit;
          end;
          //Ищем в таблице первую пустую строку.
          wdRow := Unassigned;
          for i := 1 to wdTbl.Rows.Count do begin
            //В конце текста ячейки всегда имеются два специальных символа, обозначающих
            //границу ячейки. Поэтому, если длина текста ячейки равна 2, то эта ячейка пустая.
            j := 1;
            Cnt := wdTbl.Rows.Item(i).Cells.Count;
            while
              (j <= Cnt)
              and (Length(wdTbl.Rows.Item(i).Cells.Item(j).Range.Text) = 2)
            do Inc(j);
            //Если j > Cnt, значит, все ячейки в строке пустые (т. е., мы нашли пустую строку).
            if j > Cnt then begin
              wdRow := wdTbl.Rows.Item(i);
              Break;
            end;
          end;
          //Если пустых строк нет, то добавляем в таблицу новую строку.
          if VarIsClear(wdRow) and (MainUnit.MainForm.StringGrid1.ColCount>1)
          then
          begin
            wdRow := wdTbl.Rows.Add;
            //Проверка формата строки.
            if wdRow.Cells.Count < 4 then
            begin
              case TypeUnit.SChooseLanguage of
                1: MessageBox(0, 'In the target line of the table is not enough cells. Action canceled.',
                    'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
                0: MessageBox(0, 'В целевой строке таблицы недостаточно ячеек. Действие отменено.',
                    'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              end;
              Exit;
            end
            else
            begin
                for m:=1 to MainUnit.MainForm.StringGrid1.ColCount-1 do
                begin
                  for n:=0 to MainUnit.MainForm.StringGrid1.RowCount-1 do
                  begin
                    if n=0 then wdRow.Cells.Item(n+1).Range.Text:=IntToStr(m)
                    else wdRow.Cells.Item(n+1).Range.Text:=MainUnit.MainForm.StringGrid1.Cells[m,n];
                  end;
                  //Теперь, в верхней левой ячейке таблицы вновь определяем закладку.
                  wdBms.Add(BmName, wdTbl.Rows.Item(m).Cells.Item(1).Range);
                  if m<MainUnit.MainForm.StringGrid1.ColCount-1 then wdRow := wdTbl.Rows.Add;
                end;
            end;
          end;
        end;
        // конец добавление данных точек

      end;

      // графики построенные функции
      if  not TypeUnit.SActiveGraphe
      then ReportUnit.DeleteBmText(wdBms,'vide4')  // удаляем раздел
      else
      begin
        //делаем невидимым экран отображения графики
        MainUnit.MainForm.Chart.Visible:=false;
        MainUnit.MainForm.DistinctionWithResize.Visible:=false;
        MainUnit.MainForm.HideFunction.Visible:=false;
        TypeUnit.PanelDistinction.Visible:=false;
        try
          if not wdBms.Exists(BmName7) then
          begin
            case TypeUnit.SChooseLanguage of
              1: MessageBox(0, 'In the document there is no bookmark named "' + BmName7 + '". Action canceled.'
                  ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              0: MessageBox(0, 'В документе нет закладки с именем "' + BmName7 + '". Действие отменено.'
                  ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            end;
            Exit;
          end
          else
          begin
            //Ссылка на закладку.
            wdBm := wdBms.Item(BmName7);
            //Ссылка на диапазон, связанный с закладкой.
            wdRng := wdBm.Range;
            //Удаление закладки.
            wdBm.Delete;
            //Ссылка на коллекцию таблиц.
            wdTbls := wdDoc.Tables;
            //Определеляем, какой таблице принадлежит диапазон закладки.
            wdTbl := Unassigned;
            for i := 1 to wdTbls.Count do
              if wdRng.InRange(wdTbls.Item(i).Range) then begin
                wdTbl := wdTbls.Item(i);
                Break;
              end;
            if VarIsClear(wdTbl) then
            begin
              case TypeUnit.SChooseLanguage of
                1: MessageBox(0, 'Bookmark with name "' + BmName + '" not belong to the table.'
                    + ' ДThe action was canceled.', 'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
                0: MessageBox(0, 'Закладка с именем "' + BmName + '" не принадлежит таблице.'
                    + ' Действие отменено.', 'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              end;
              Exit;
            end;
            //Ищем в таблице первую пустую строку.
            wdRow := Unassigned;
            for i := 1 to wdTbl.Rows.Count do begin
              //В конце текста ячейки всегда имеются два специальных символа, обозначающих
              //границу ячейки. Поэтому, если длина текста ячейки равна 2, то эта ячейка пустая.
              j := 1;
              Cnt := wdTbl.Rows.Item(i).Cells.Count;
              while
                (j <= Cnt)
                and (Length(wdTbl.Rows.Item(i).Cells.Item(j).Range.Text) = 2)
              do Inc(j);
              //Если j > Cnt, значит, все ячейки в строке пустые (т. е., мы нашли пустую строку).
              if j > Cnt then begin
                wdRow := wdTbl.Rows.Item(i);
                Break;
              end;
            end;
            //Если пустых строк нет, то добавляем в таблицу новую строку.
            if VarIsClear(wdRow) then wdRow := wdTbl.Rows.Add;
            //Проверка формата строки.
            if wdRow.Cells.Count < 1 then
            begin
              case TypeUnit.SChooseLanguage of
                1: MessageBox(0, 'In the target line of the table is not enough cells. Action canceled.',
                    'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
                0: MessageBox(0, 'В целевой строке таблицы недостаточно ячеек. Действие отменено.',
                    'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              end;
              Exit;
            end
            else
            begin
              case TypeUnit.SChooseLanguage of
                1:s:= ExtractFilePath(Application.ExeName ) +'ConfigurationFile\2.jpg';
                0:s:= ExtractFilePath(Application.ExeName ) +'Конфигурационные файлы\2.jpg';
              end;
              i:=1;
              m:=1;
              while i<=18 do
              begin
                //подготовка график
                b:=false;
                CheckedMas.Quantity:=0;
                CheckedMas.value:=nil;
                case i of
                  //общий график проверка уже сделана
                  1: if not typeUnit.SActiveGraphe then b:=true else b:=false;
                  //пользователькая функция
                  2: if not typeUnit.SActiveGraphUserFunctin then b:=true else b:=false;
                  //Лаграж
                  3: if not typeUnit.SActiveGraphLagrange then b:=true else b:=false;
                  //Обобщенная  функция
                  4: if not typeUnit.SActiveGraphGeneralised then b:=true else b:=false;
                  //Обобщенная  функция II
                  5: if not typeUnit.SActiveGraphGeneralisedII then b:=true else b:=false;
                  //Лаграж ошибки
                  6: if not typeUnit.SActiveGraphLagrangeError then b:=true else b:=false;
                  //Обобщенная  функция ошибки
                  7: if not typeUnit.SActiveGraphGeneralisedError then b:=true else b:=false;
                  //Обобщенная  функция ошибки II
                  8: if not typeUnit.SActiveGraphGeneralisedErrorII then b:=true else b:=false;
                  //проверочная функция
                  9: if not typeUnit.SActiveGraphUserFunctin then b:=true else b:=false;
                  // комбинации графики
                  10:
                    if not ( (typeUnit.SActiveGraphUserFunctin)
                        and (typeUnit.SActiveGraphLagrange))
                    then b:=true
                    else b:=false;
                  11:
                    if not ( (typeUnit.SActiveGraphUserFunctin)
                        and (typeUnit.SActiveGraphGeneralised))
                    then b:=true
                    else b:=false;
                  12:
                    if not ( (typeUnit.SActiveGraphUserFunctin)
                        and (typeUnit.SActiveGraphGeneralisedII))
                    then b:=true
                    else b:=false;
                  13:
                    if not ( (typeUnit.SActiveGraphUserFunctin)
                        and (typeUnit.SActiveGraphLagrange)and(typeUnit.SActiveGraphGeneralised))
                    then b:=true
                    else b:=false;
                  14:
                    if not ( (typeUnit.SActiveGraphUserFunctin)
                        and (typeUnit.SActiveGraphLagrange)and(typeUnit.SActiveGraphGeneralisedII))
                    then b:=true
                    else b:=false;
                  15:
                    if not ( (typeUnit.SActiveGraphUserFunctin)
                        and (typeUnit.SActiveGraphLagrange)
                        and (typeUnit.SActiveGraphGeneralised)
                        and (typeUnit.SActiveGraphGeneralisedII))
                    then b:=true
                    else b:=false;
                  16:
                    if not ( (typeUnit.SActiveGraphLagrangeError)
                        and (typeUnit.SActiveGraphGeneralisedError))
                    then b:=true
                    else b:=false;
                  17:
                    if not ( (typeUnit.SActiveGraphLagrangeError)
                        and (typeUnit.SActiveGraphGeneralisedErrorII))
                    then b:=true
                    else b:=false;
                  18:
                    if not ( (typeUnit.SActiveGraphLagrangeError)
                        and (typeUnit.SActiveGraphGeneralisedErrorII)
                        and (typeUnit.SActiveGraphGeneralisedError))
                    then b:=true
                    else b:=false;
                end;
                //установка данных для создания картинки графики
                if (not b) and (i<10) then
                begin
                  CheckedMas.Quantity:=1;
                  SetLength(CheckedMas.value,CheckedMas.Quantity);
                  CheckedMas.value[CheckedMas.Quantity-1]:=LanguageUnit.ValueGraph[i];
                end
                else if not b then
                  case i of
                    10:
                      begin
                        CheckedMas.Quantity:=2;
                        SetLength(CheckedMas.value,CheckedMas.Quantity);
                        CheckedMas.value[0]:=LanguageUnit.ValueGraph[2];
                        CheckedMas.value[1]:=LanguageUnit.ValueGraph[3];
                      end;
                    11:
                      begin
                        CheckedMas.Quantity:=2;
                        SetLength(CheckedMas.value,CheckedMas.Quantity);
                        CheckedMas.value[0]:=LanguageUnit.ValueGraph[2];
                        CheckedMas.value[1]:=LanguageUnit.ValueGraph[4];
                      end;
                    12:
                      begin
                        CheckedMas.Quantity:=2;
                        SetLength(CheckedMas.value,CheckedMas.Quantity);
                        CheckedMas.value[0]:=LanguageUnit.ValueGraph[2];
                        CheckedMas.value[1]:=LanguageUnit.ValueGraph[5];
                      end;
                    13:
                      begin
                        CheckedMas.Quantity:=3;
                        SetLength(CheckedMas.value,CheckedMas.Quantity);
                        CheckedMas.value[0]:=LanguageUnit.ValueGraph[2];
                        CheckedMas.value[1]:=LanguageUnit.ValueGraph[3];
                        CheckedMas.value[2]:=LanguageUnit.ValueGraph[4];
                      end;
                    14:
                      begin
                        CheckedMas.Quantity:=3;
                        SetLength(CheckedMas.value,CheckedMas.Quantity);
                        CheckedMas.value[0]:=LanguageUnit.ValueGraph[2];
                        CheckedMas.value[1]:=LanguageUnit.ValueGraph[3];
                        CheckedMas.value[2]:=LanguageUnit.ValueGraph[5];
                      end;
                    15:
                      begin
                        CheckedMas.Quantity:=4;
                        SetLength(CheckedMas.value,CheckedMas.Quantity);
                        CheckedMas.value[0]:=LanguageUnit.ValueGraph[2];
                        CheckedMas.value[1]:=LanguageUnit.ValueGraph[3];
                        CheckedMas.value[2]:=LanguageUnit.ValueGraph[4];
                        CheckedMas.value[3]:=LanguageUnit.ValueGraph[5];
                      end;
                    16:
                      begin
                        CheckedMas.Quantity:=2;
                        SetLength(CheckedMas.value,CheckedMas.Quantity);
                        CheckedMas.value[0]:=LanguageUnit.ValueGraph[6];
                        CheckedMas.value[1]:=LanguageUnit.ValueGraph[7];
                      end;
                    17:
                      begin
                        CheckedMas.Quantity:=2;
                        SetLength(CheckedMas.value,CheckedMas.Quantity);
                        CheckedMas.value[0]:=LanguageUnit.ValueGraph[6];
                        CheckedMas.value[1]:=LanguageUnit.ValueGraph[8];
                      end;
                    18:
                      begin
                        CheckedMas.Quantity:=3;
                        SetLength(CheckedMas.value,CheckedMas.Quantity);
                        CheckedMas.value[0]:=LanguageUnit.ValueGraph[6];
                        CheckedMas.value[1]:=LanguageUnit.ValueGraph[7];
                        CheckedMas.value[2]:=LanguageUnit.ValueGraph[8];
                      end;
                  end;
                // если нужнно создать графики и было создан картинки то
                if (CheckedMas.value<>nil) and ResizeChartandGetImage(CheckedMas,s) then
                begin
                  //добавляем картинки и их надписи в документе
                  if m<>1 then wdRow := wdTbl.Rows.Add;
                  case i of
                    1,2,3,4,5,6,7,8,9:
                      case TypeUnit.SChooseLanguage of
                        1:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphEnglish[i];
                        0:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphRussian[i];
                      end;
                    10:
                      case TypeUnit.SChooseLanguage of
                        1:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphEnglish[2]+' + '+LanguageUnit.NameGraphEnglish[3];
                        0:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphRussian[2]+' + '+LanguageUnit.NameGraphRussian[3];
                      end;
                    11:
                      case TypeUnit.SChooseLanguage of
                        1:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphEnglish[2]+' + '+LanguageUnit.NameGraphEnglish[4];
                        0:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphRussian[2]+' + '+LanguageUnit.NameGraphRussian[4];
                      end;
                    12:
                      case TypeUnit.SChooseLanguage of
                        1:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphEnglish[2]+' + '+LanguageUnit.NameGraphEnglish[5];
                        0:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphRussian[2]+' + '+LanguageUnit.NameGraphRussian[5];
                      end;
                    13:
                      case TypeUnit.SChooseLanguage of
                        1:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphEnglish[2]+' + '+LanguageUnit.NameGraphEnglish[3]+' + '+LanguageUnit.NameGraphEnglish[4];
                        0:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphRussian[2]+' + '+LanguageUnit.NameGraphEnglish[3]+' + '+LanguageUnit.NameGraphRussian[4];
                      end;
                    14:
                      case TypeUnit.SChooseLanguage of
                        1:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphEnglish[2]+' + '+LanguageUnit.NameGraphEnglish[3]+' + '+LanguageUnit.NameGraphEnglish[5];
                        0:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphRussian[2]+' + '+LanguageUnit.NameGraphEnglish[3]+' + '+LanguageUnit.NameGraphRussian[5];
                      end;
                    15:
                      case TypeUnit.SChooseLanguage of
                        1:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphEnglish[2]+' + '+LanguageUnit.NameGraphEnglish[3]+' + '+LanguageUnit.NameGraphEnglish[4]+' + '+LanguageUnit.NameGraphEnglish[5];
                        0:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphRussian[2]+' + '+LanguageUnit.NameGraphEnglish[3]+' + '+LanguageUnit.NameGraphEnglish[4]+' + '+LanguageUnit.NameGraphRussian[5];
                      end;
                    16:
                      case TypeUnit.SChooseLanguage of
                        1:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphEnglish[6]+' + '+LanguageUnit.NameGraphEnglish[7];
                        0:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphRussian[6]+' + '+LanguageUnit.NameGraphRussian[7];
                      end;
                    17:
                      case TypeUnit.SChooseLanguage of
                        1:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphEnglish[6]+' + '+LanguageUnit.NameGraphEnglish[8];
                        0:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphRussian[6]+' + '+LanguageUnit.NameGraphRussian[8];
                      end;
                    18:
                      case TypeUnit.SChooseLanguage of
                        1:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphEnglish[6]+' + '+LanguageUnit.NameGraphEnglish[7]+' + '+LanguageUnit.NameGraphEnglish[8];
                        0:wdRow.Cells.Item(1).Range.Text:= LanguageUnit.NameGraphRussian[6]+' + '+LanguageUnit.NameGraphEnglish[7]+' + '+LanguageUnit.NameGraphRussian[8];
                      end;
                  end;

                  //и вставление изображение
                  wdRow.Cells.Item(1).Range.InlineShapes.AddPicture(FileName := s,
                      LinkToFile:=False, SaveWithDocument:=True);
                  //увеличить строку при следующей. попытке
                  inc(m);
                end;
                inc(i);
              end;
            end;
          end;
        finally
          //сделаем видимым экран отображения графики
          MainUnit.MainForm.Chart.Visible:=True;
          MainUnit.MainForm.DistinctionWithResize.Visible:=True;
          MainUnit.MainForm.HideFunction.Visible:=True;
          TypeUnit.PanelDistinction.Visible:=True;
        end;
        //конец добавление графики
      end;

      // таблица значения пользователькой функции
      if  not  (TypeUnit.SActiveTableValueTracedUsersAnalytiqueFunction and MainUnit.MainForm.Series4.Active)
      then ReportUnit.DeleteBmText(wdBms,'vide5') // удаление раздел
      else
      begin
        if not wdBms.Exists(BmName3) then
        begin
          case TypeUnit.SChooseLanguage of
            1: MessageBox(0, 'In the document there is no bookmark named "' + BmName3 + '". Action canceled.'
                ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            0: MessageBox(0, 'В документе нет закладки с именем "' + BmName3 + '". Действие отменено.'
                ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
          end;
          Exit;
        end
        else
        begin
          //Ссылка на закладку.
          wdBm := wdBms.Item(BmName3);
          //Ссылка на диапазон, связанный с закладкой.
          wdRng := wdBm.Range;
          //Удаление закладки.
          wdBm.Delete;
          //Ссылка на коллекцию таблиц.
          wdTbls := wdDoc.Tables;
          //Определеляем, какой таблице принадлежит диапазон закладки.
          wdTbl := Unassigned;
          for i := 1 to wdTbls.Count do
            if wdRng.InRange(wdTbls.Item(i).Range) then begin
              wdTbl := wdTbls.Item(i);
              Break;
            end;
          if VarIsClear(wdTbl) then
          begin
            case TypeUnit.SChooseLanguage of
              1: MessageBox(0, 'Bookmark with name "' + BmName3 + '" not belong to the table.'
                  + ' ДThe action was canceled.', 'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              0: MessageBox(0, 'Закладка с именем "' + BmName3 + '" не принадлежит таблице.'
                  + ' Действие отменено.', 'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            end;
            Exit;
          end;
          //Ищем в таблице первую пустую строку.
          wdRow := Unassigned;
          for i := 1 to wdTbl.Rows.Count do begin
            //В конце текста ячейки всегда имеются два специальных символа, обозначающих
            //границу ячейки. Поэтому, если длина текста ячейки равна 2, то эта ячейка пустая.
            j := 1;
            Cnt := wdTbl.Rows.Item(i).Cells.Count;
            while
              (j <= Cnt)
              and (Length(wdTbl.Rows.Item(i).Cells.Item(j).Range.Text) = 2)
            do Inc(j);
            //Если j > Cnt, значит, все ячейки в строке пустые (т. е., мы нашли пустую строку).
            if j > Cnt then begin
              wdRow := wdTbl.Rows.Item(i);
              Break;
            end;
          end;
          //Если пустых строк нет, то добавляем в таблицу новую строку.
          if VarIsClear(wdRow) then wdRow := wdTbl.Rows.Add;
          //Проверка формата строки.
          if wdRow.Cells.Count < 2 then
          begin
            case TypeUnit.SChooseLanguage of
              1: MessageBox(0, 'In the target line of the table is not enough cells. Action canceled.',
                  'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              0: MessageBox(0, 'В целевой строке таблицы недостаточно ячеек. Действие отменено.',
                  'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            end;
            Exit;
          end
          else
          begin
              xmin:=StrtoFloat(MainUnit.MainForm.IntervalA.Text);
              xmax:=StrtoFloat(MainUnit.MainForm.IntervalB.Text) ;
              //устоновляем шаг
              h:=((XMax-XMin) / TypeUnit.SStepTraceUsersAnalytiqueFunction);
              m:=0;
              while Xmin<=XMax do
              begin
                inc(m);
                wdRow.Cells.Item(1).Range.Text:= Floattostr(Xmin);
                try
                  wdRow.Cells.Item(2).Range.Text:=Floattostr(CalculStringFunction(MainUnit.MainForm.UsersAnalytiqueFunction.Text,XMin));
                  //Теперь, в верхней левой ячейке таблицы вновь определяем закладку.
                  wdBms.Add(BmName, wdTbl.Rows.Item(m).Cells.Item(1).Range);
                  if Xmin<=XMax-h then wdRow := wdTbl.Rows.Add;
                  xmin:=xmin+h;
                except
                   wdRow.Cells.Item(1).Range.Text:='';
                   //Теперь, в верхней левой ячейке таблицы вновь определяем закладку.
                   wdBms.Add(BmName, wdTbl.Rows.Item(m).Cells.Item(1).Range);
                   if Xmin<=XMax-h then wdRow := wdTbl.Rows.Add;
                   xmin:=xmin+h;
                end;
              end;
          end;
        end;
        // конец

      end;

      //таблица значения лагранжа
      if  not  (TypeUnit.SActiveTableValueTracedLaGrangeFunction and MainUnit.MainForm.Series1.Active)
      then ReportUnit.DeleteBmText(wdBms,'vide6') // удаление раздел
      else
      begin
        if not wdBms.Exists(BmName4) then
        begin
          case TypeUnit.SChooseLanguage of
            1: MessageBox(0, 'In the document there is no bookmark named "' + BmName4 + '". Action canceled.'
                ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            0: MessageBox(0, 'В документе нет закладки с именем "' + BmName4 + '". Действие отменено.'
                ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
          end;
          Exit;
        end
        else
        begin
          //Ссылка на закладку.
          wdBm := wdBms.Item(BmName4);
          //Ссылка на диапазон, связанный с закладкой.
          wdRng := wdBm.Range;
          //Удаление закладки.
          wdBm.Delete;
          //Ссылка на коллекцию таблиц.
          wdTbls := wdDoc.Tables;
          //Определеляем, какой таблице принадлежит диапазон закладки.
          wdTbl := Unassigned;
          for i := 1 to wdTbls.Count do
            if wdRng.InRange(wdTbls.Item(i).Range) then begin
              wdTbl := wdTbls.Item(i);
              Break;
            end;
          if VarIsClear(wdTbl) then
          begin
            case TypeUnit.SChooseLanguage of
              1: MessageBox(0, 'Bookmark with name "' + BmName4 + '" not belong to the table.'
                  + ' The action was canceled.', 'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              0: MessageBox(0, 'Закладка с именем "' + BmName4 + '" не принадлежит таблице.'
                  + ' Действие отменено.', 'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            end;
            Exit;
          end;
          //Ищем в таблице первую пустую строку.
          wdRow := Unassigned;
          for i := 1 to wdTbl.Rows.Count do begin
            //В конце текста ячейки всегда имеются два специальных символа, обозначающих
            //границу ячейки. Поэтому, если длина текста ячейки равна 2, то эта ячейка пустая.
            j := 1;
            Cnt := wdTbl.Rows.Item(i).Cells.Count;
            while
              (j <= Cnt)
              and (Length(wdTbl.Rows.Item(i).Cells.Item(j).Range.Text) = 2)
            do Inc(j);
            //Если j > Cnt, значит, все ячейки в строке пустые (т. е., мы нашли пустую строку).
            if j > Cnt then begin
              wdRow := wdTbl.Rows.Item(i);
              Break;
            end;
          end;
          //Если пустых строк нет, то добавляем в таблицу новую строку.
          if VarIsClear(wdRow) then wdRow := wdTbl.Rows.Add;
          //Проверка формата строки.
          if wdRow.Cells.Count < 2 then
          begin
            case TypeUnit.SChooseLanguage of
              1: MessageBox(0, 'In the target line of the table is not enough cells. Action canceled.',
                  'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              0: MessageBox(0, 'В целевой строке таблицы недостаточно ячеек. Действие отменено.',
                  'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            end;
            Exit;
          end
          else
          begin
            //получить минимальное и максимальное значение Х в графике
            if (MainUnit.MainForm.IntervalA.Text<>'') and (MainUnit.MainForm.IntervalB.Text<>'')
            then
            begin
              Xmin:=Strtofloat(MainUnit.MainForm.IntervalA.Text);
              XMax:=Strtofloat(MainUnit.MainForm.IntervalB.Text);
              XMarge:=0;
            end else
            begin
              Xmin:=UsersFunction.value[0].x;
              XMax:=UsersFunction.value[high(UsersFunction.value)].x;
            end;
            XMarge:=0;
            //устоновляем шаг
            h:=((XMax-XMin) / TypeUnit.SStepTraceLagrangeAndGeneralizingFunction);
            m:=0;
            while Xmin<=XMax do
            begin
              inc(m);
              wdRow.Cells.Item(1).Range.Text:= Floattostr(Xmin);
              try
                wdRow.Cells.Item(2).Range.Text:=Floattostr(ExitDataUnit.LaGrange(TypeUnit.NodeInterPolation,XMin,p));
                //Теперь, в верхней левой ячейке таблицы вновь определяем закладку.
                wdBms.Add(BmName, wdTbl.Rows.Item(m).Cells.Item(1).Range);
                if Xmin<=XMax-h then wdRow := wdTbl.Rows.Add;
                xmin:=xmin+h;
              except
                 wdRow.Cells.Item(1).Range.Text:='';
                 //Теперь, в верхней левой ячейке таблицы вновь определяем закладку.
                 wdBms.Add(BmName, wdTbl.Rows.Item(m).Cells.Item(1).Range);
                 if Xmin<=XMax-h then wdRow := wdTbl.Rows.Add;
                 xmin:=xmin+h;
              end;
            end;
          end;
        end;
        // конец

      end;

      // таблица значения обобщённой I
      if  not  (TypeUnit.SActiveTableValueTracedGeneralizingFunction and MainUnit.MainForm.Series5.Active)
      then ReportUnit.DeleteBmText(wdBms,'vide7')//удаление раздел
      else
      begin
        if not wdBms.Exists(BmName5) then
        begin
          case TypeUnit.SChooseLanguage of
            1: MessageBox(0, 'In the document there is no bookmark named "' + BmName5 + '". Action canceled.'
                ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            0: MessageBox(0, 'В документе нет закладки с именем "' + BmName5 + '". Действие отменено.'
                ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
          end;
          Exit;
        end
        else
        begin
          //Ссылка на закладку.
          wdBm := wdBms.Item(BmName5);
          //Ссылка на диапазон, связанный с закладкой.
          wdRng := wdBm.Range;
          //Удаление закладки.
          wdBm.Delete;
          //Ссылка на коллекцию таблиц.
          wdTbls := wdDoc.Tables;
          //Определеляем, какой таблице принадлежит диапазон закладки.
          wdTbl := Unassigned;
          for i := 1 to wdTbls.Count do
            if wdRng.InRange(wdTbls.Item(i).Range) then begin
              wdTbl := wdTbls.Item(i);
              Break;
            end;
          if VarIsClear(wdTbl) then
          begin
            case TypeUnit.SChooseLanguage of
              1: MessageBox(0, 'Bookmark with name "' + BmName5 + '" not belong to the table.'
                  + ' ДThe action was canceled.', 'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              0: MessageBox(0, 'Закладка с именем "' + BmName5 + '" не принадлежит таблице.'
                  + ' Действие отменено.', 'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            end;
            Exit;
          end;
          //Ищем в таблице первую пустую строку.
          wdRow := Unassigned;
          for i := 1 to wdTbl.Rows.Count do begin
            //В конце текста ячейки всегда имеются два специальных символа, обозначающих
            //границу ячейки. Поэтому, если длина текста ячейки равна 2, то эта ячейка пустая.
            j := 1;
            Cnt := wdTbl.Rows.Item(i).Cells.Count;
            while
              (j <= Cnt)
              and (Length(wdTbl.Rows.Item(i).Cells.Item(j).Range.Text) = 2)
            do Inc(j);
            //Если j > Cnt, значит, все ячейки в строке пустые (т. е., мы нашли пустую строку).
            if j > Cnt then begin
              wdRow := wdTbl.Rows.Item(i);
              Break;
            end;
          end;
          //Если пустых строк нет, то добавляем в таблицу новую строку.
          if VarIsClear(wdRow) then wdRow := wdTbl.Rows.Add;
          //Проверка формата строки.
          if wdRow.Cells.Count < 2 then
          begin
            case TypeUnit.SChooseLanguage of
              1: MessageBox(0, 'In the target line of the table is not enough cells. Action canceled.',
                  'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              0: MessageBox(0, 'В целевой строке таблицы недостаточно ячеек. Действие отменено.',
                  'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            end;
            Exit;
          end
          else
          begin
            //получить минимальное и максимальное значение Х в графике
            if (MainUnit.MainForm.IntervalA.Text<>'') and (MainUnit.MainForm.IntervalB.Text<>'')
            then
            begin
              Xmin:=Strtofloat(MainUnit.MainForm.IntervalA.Text);
              XMax:=Strtofloat(MainUnit.MainForm.IntervalB.Text);
              XMarge:=0;
            end else
            begin
              Xmin:=UsersFunction.value[0].x;
              XMax:=UsersFunction.value[high(UsersFunction.value)].x;
            end;
            XMarge:=0;
            //устоновляем шаг
            h:=((XMax-XMin) / TypeUnit.SStepTraceLagrangeAndGeneralizingFunction);
            m:=0;
            while Xmin<=XMax do
            begin
              inc(m);
              wdRow.Cells.Item(1).Range.Text:= Floattostr(Xmin);
              try
                wdRow.Cells.Item(2).Range.Text:=Floattostr(ExitDataUnit.LaGrangeG(MainUnit.MainForm.TranslateFunction.Text,TypeUnit.NodeInterPolation,XMin,p));
                //Теперь, в верхней левой ячейке таблицы вновь определяем закладку.
                wdBms.Add(BmName, wdTbl.Rows.Item(m).Cells.Item(1).Range);
                if Xmin<=XMax-h then wdRow := wdTbl.Rows.Add;
                xmin:=xmin+h;
              except
                 wdRow.Cells.Item(1).Range.Text:='';
                 //Теперь, в верхней левой ячейке таблицы вновь определяем закладку.
                 wdBms.Add(BmName, wdTbl.Rows.Item(m).Cells.Item(1).Range);
                 if Xmin<=XMax-h then wdRow := wdTbl.Rows.Add;
                 xmin:=xmin+h;
              end;
            end;
          end;
        end;
        // конец

      end;
      // таблица значения обобщённой II
      if  not  (TypeUnit.SActiveTableValueTracedGeneralizingFunctionII and MainUnit.MainForm.Series6.Active)
      then ReportUnit.DeleteBmText(wdBms,'vide8')  // удаление раздел
      else
      begin
        if not wdBms.Exists(BmName8) then
        begin
          case TypeUnit.SChooseLanguage of
            1: MessageBox(0, 'In the document there is no bookmark named "' + BmName8 + '". Action canceled.'
                ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            0: MessageBox(0, 'В документе нет закладки с именем "' + BmName8 + '". Действие отменено.'
                ,'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
          end;
          Exit;
        end
        else
        begin
          //Ссылка на закладку.
          wdBm := wdBms.Item(BmName8);
          //Ссылка на диапазон, связанный с закладкой.
          wdRng := wdBm.Range;
          //Удаление закладки.
          wdBm.Delete;
          //Ссылка на коллекцию таблиц.
          wdTbls := wdDoc.Tables;
          //Определеляем, какой таблице принадлежит диапазон закладки.
          wdTbl := Unassigned;
          for i := 1 to wdTbls.Count do
            if wdRng.InRange(wdTbls.Item(i).Range) then begin
              wdTbl := wdTbls.Item(i);
              Break;
            end;
          if VarIsClear(wdTbl) then
          begin
            case TypeUnit.SChooseLanguage of
              1: MessageBox(0, 'Bookmark with name "' + BmName8 + '" not belong to the table.'
                  + ' ДThe action was canceled.', 'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              0: MessageBox(0, 'Закладка с именем "' + BmName8 + '" не принадлежит таблице.'
                  + ' Действие отменено.', 'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            end;
            Exit;
          end;
          //Ищем в таблице первую пустую строку.
          wdRow := Unassigned;
          for i := 1 to wdTbl.Rows.Count do begin
            //В конце текста ячейки всегда имеются два специальных символа, обозначающих
            //границу ячейки. Поэтому, если длина текста ячейки равна 2, то эта ячейка пустая.
            j := 1;
            Cnt := wdTbl.Rows.Item(i).Cells.Count;
            while
              (j <= Cnt)
              and (Length(wdTbl.Rows.Item(i).Cells.Item(j).Range.Text) = 2)
            do Inc(j);
            //Если j > Cnt, значит, все ячейки в строке пустые (т. е., мы нашли пустую строку).
            if j > Cnt then begin
              wdRow := wdTbl.Rows.Item(i);
              Break;
            end;
          end;
          //Если пустых строк нет, то добавляем в таблицу новую строку.
          if VarIsClear(wdRow) then wdRow := wdTbl.Rows.Add;
          //Проверка формата строки.
          if wdRow.Cells.Count < 2 then
          begin
            case TypeUnit.SChooseLanguage of
              1: MessageBox(0, 'In the target line of the table is not enough cells. Action canceled.',
                  'Caution!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
              0: MessageBox(0, 'В целевой строке таблицы недостаточно ячеек. Действие отменено.',
                  'Внимание!', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
            end;
            Exit;
          end
          else
          begin
            //получить минимальное и максимальное значение Х в графике
            if (MainUnit.MainForm.IntervalA.Text<>'') and (MainUnit.MainForm.IntervalB.Text<>'')
            then
            begin
              Xmin:=Strtofloat(MainUnit.MainForm.IntervalA.Text);
              XMax:=Strtofloat(MainUnit.MainForm.IntervalB.Text);
              XMarge:=0;
            end else
            begin
              Xmin:=UsersFunction.value[0].x;
              XMax:=UsersFunction.value[high(UsersFunction.value)].x;
            end;
            XMarge:=0;
            //устоновляем шаг
            h:=((XMax-XMin) / TypeUnit.SStepTraceLagrangeAndGeneralizingFunction);
            m:=0;
            while Xmin<=XMax do
            begin
              inc(m);
              wdRow.Cells.Item(1).Range.Text:= Floattostr(Xmin);
              try
                wdRow.Cells.Item(2).Range.Text:=Floattostr(ExitDataUnit.LaGrangeGII(MainUnit.MainForm.TranslateFunction.Text,TypeUnit.NodeInterPolation,XMin,p));
                //Теперь, в верхней левой ячейке таблицы вновь определяем закладку.
                wdBms.Add(BmName, wdTbl.Rows.Item(m).Cells.Item(1).Range);
                if Xmin<=XMax-h then wdRow := wdTbl.Rows.Add;
                xmin:=xmin+h;
              except
                 wdRow.Cells.Item(1).Range.Text:='';
                 //Теперь, в верхней левой ячейке таблицы вновь определяем закладку.
                 wdBms.Add(BmName, wdTbl.Rows.Item(m).Cells.Item(1).Range);
                 if Xmin<=XMax-h then wdRow := wdTbl.Rows.Add;
                 xmin:=xmin+h;
              end;
            end;
          end;
        end;
        // конец

      end;

  finally
    //удаление созданных картинок
    case TypeUnit.SChooseLanguage of
      1:if FileExists(ExtractFilePath(Application.ExeName ) +'ConfigurationFile\2.jpg')
        then SysUtils.DeleteFile(ExtractFilePath(Application.ExeName ) +'ConfigurationFile\2.jpg');
      0:if FileExists(ExtractFilePath(Application.ExeName ) +'Конфигурационные файлы\2.jpg')
        then SysUtils.DeleteFile(ExtractFilePath(Application.ExeName ) +'Конфигурационные файлы\2.jpg');
    end;

    wdApp.DisplayAlerts := False; //Отключаем режим показа предупреждений.
    //Сохранять документ следует под другим именем, чтобы не перезаписать шаблон.
    try
      s:=NameFile+'.doc';
      wdDoc.SaveAs(FileName:=s);
    except
      // при возникновление ошибки необходимо удалить итоговый отчёт
      case TypeUnit.SChooseLanguage of
        1:
          begin
            wdDoc.SaveAs(FileName:=ExtractFilePath( Application.ExeName ) +'ReportFile\Export'+'.doc');
            SysUtils.DeleteFile(ExtractFilePath( Application.ExeName ) +'ReportFile\Export'+'.doc');
          end;
        0:
          begin
            wdDoc.SaveAs(FileName:=ExtractFilePath( Application.ExeName ) +'Отчеты\Export'+'.doc');
            SysUtils.DeleteFile(ExtractFilePath( Application.ExeName ) +'Отчеты\Export'+'.doc');
          end;
      end;

    end;
    //Закрываем документ.
    wdDoc.Close;
    //Закрываем MS Word.
    wdApp.Quit;
  end;
end;

//обрабочик создания отчёта текущего процесса моделирования;
procedure SentToReport(NameProject:TFileName;DateTimeOnString,StringDateTime:String);
var s:string;
    i:integer;
begin
  MainUnit.MainForm.Cursor:=CrHourGlass;
  case TypeUnit.SChooseLanguage of
    1: S:=ExtractFilePath( Application.ExeName ) +'ReportFile\'
      +changeFileExt(ExtractFileName(NameProject),'');
    0:S:=ExtractFilePath( Application.ExeName ) +'Отчеты\'
      +changeFileExt(ExtractFileName(NameProject),'');
  end;
  if not DirectoryExists(S) then CreateDir(s);
  //экпортируем данных в Ворде;
  case TypeUnit.SChooseLanguage of
    1: ExporterWord(S+'\Report_'+DateTimeOnString,StringDateTime);
    0: ExporterWord(S+'\Отчет_'+DateTimeOnString,StringDateTime);
  end;
  MainUnit.MainForm.Cursor:=CrDefault;
end;


end.
