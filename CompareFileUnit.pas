{ **** UBPFD *********** by delphibase.endimus.com ****
>> Сравнение двух файлов

Функция сравнивает два файла, возвращает true если сходны

Зависимости: Sysutils, Classes
Автор:       [NIKEL], Norilsk
Copyright:   Собственное написание ([NIKEL])
Дата:        13 мая 2002 г.
***************************************************** }
unit CompareFileUnit;

interface

uses Sysutils, Classes;

function CompareFiles(const FirstFile, SecondFile: string): Boolean;

implementation

function CompareFiles(const FirstFile, SecondFile: string): Boolean;
var
  f1, f2: TMemoryStream;
begin
  Result := false;
  f1 := TMemoryStream.Create;
  f2 := TMemoryStream.Create;
  try
    //загружаем файлы...
    f1.LoadFromFile(FirstFile);
    f2.LoadFromFile(SecondFile);
    if f1.Size = f2.Size then //сравниваем по размеру...
      //двоичное сравнение в памяти
      Result := CompareMem(f1.Memory, f2.memory, f1.Size);
  finally
    f2.Free;
    f1.Free;
  end
end;
{///**********Пример использования:

if CompareFiles(Opendialog1.FileName, Opendialog2.FileName) then
  ShowMessage('Файлы одинаковы!');
 }
end.