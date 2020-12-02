unit HistoryUnit;

interface
  // использованные библиотеки
  uses SysUtils;

  //объявление пупличные функции

  //добавление записи в истории или в архиве
  Function AddTranslateHistory(Formule:String):boolean;
  //удаление всех записов в истории или в архиве
  Function ClearHistoryTranslate:boolean;
   //обновление записов в истории или в архиве
  Function ReloadHistoryTranslate:boolean;
   //удаление записи в истории или в архиве
  Function DeleteSelectedHistoryTranslate:boolean;

implementation

// использованные модулы
uses MainUnit,TypeUnit;

//обрабочик удаления записи в архиве
Function DeleteTranslateHistory(Index:integer):boolean;
begin
  result:=true;
  //попытем удалить запись из архива
  try
    MainUnit.MainForm.HistoryTranslateFunction.Items.Delete(Index);
  except
    result:=False;
  end;
end;

// обрабочик добавления записи в архиве
Function AddTranslateHistory(Formule:String):boolean;
var s,s1:string;
begin
  result:=true;
  try
    try
      s1:=formule;
      delete(S1,1,TypeUnit.LDT);
      s:=MainUnit.MainForm.HistoryTranslateFunction.Items[MainUnit.MainForm.HistoryTranslateFunction.Items.Count-1];
      delete(S,1,TypeUnit.LDT);
    except
      s:='';
    end;
    //добавление формулы учитывая дублирование и добавление пустой формулы
    if (MainUnit.MainForm.HistoryTranslateFunction.Items.Count=0) or ((MainUnit.MainForm.HistoryTranslateFunction.Items.Count>=1)
        and (s<>s1))
    then MainUnit.MainForm.HistoryTranslateFunction.Items.Add(Formule);
  except
    result:=false;
  end;
  //установка индикации о текушей записи
  MainUnit.MainForm.HistoryTranslateFunction.ItemIndex:= MainUnit.MainForm.HistoryTranslateFunction.Items.Count-1;
  //проверка на ограничении глубина истории
  if MainUnit.MainForm.HistoryTranslateFunction.Items.Count-1>TypeUnit.SDepthOfhistory
  then DeleteTranslateHistory(0);  // удаляем самую старую запись в архиве
end;

// обрабочик удаления запись из архива
Function DeleteSelectedHistoryTranslate:boolean;
var I :integer;
begin
  result:=true;
  try
    //попытаем удаляем выбранные формулы
    for i := MainUnit.MainForm.HistoryTranslateFunction.Items.Count-1  downto 0 do
      if MainUnit.MainForm.HistoryTranslateFunction.Selected[i]
      then MainUnit.MainForm.HistoryTranslateFunction.Items.Delete(i) ;
  Except
    result:=false;
  end;
end;


// обрабочик обновления записы в архиве
Function ReloadHistoryTranslate:boolean;
var I :integer;
  b:boolean;
begin
  result:=true;
  b:=MainUnit.MainForm.HistoryTranslateFunction.MultiSelect;
  try
    if (MainUnit.MainForm.HistoryTranslateFunction.Items.Count>0)
      and (MainUnit.MainForm.HistoryTranslateFunction.Items.Count>TypeUnit.SDepthOfhistory)
    then
    begin
      //выбираем те формулы которые нужно удалить
      MainUnit.MainForm.HistoryTranslateFunction.MultiSelect := true;
      for I := 0 to MainForm.HistoryTranslateFunction.Count - TypeUnit.SDepthOfhistory- 1
      do  MainUnit.MainForm.HistoryTranslateFunction.Selected[i] := true ;
      //удаляем выбранные формулы
      DeleteSelectedHistoryTranslate;
      MainUnit.MainForm.HistoryTranslateFunction.MultiSelect := False;
    end;
  except
    result:=false;
  end;
  MainUnit.MainForm.HistoryTranslateFunction.MultiSelect:=b;
end;

// обрабочик удаления всех записей в архиве
Function ClearHistoryTranslate:boolean;
begin
  result:=true;
  try
    MainUnit.MainForm.HistoryTranslateFunction.Clear;
  except
    result:=False;
  end;
end;



end.
