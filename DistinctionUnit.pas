unit DistinctionUnit;

interface

uses SysUtils,TypeUnit,StdCtrls,Controls,Forms,
      Windows, Messages, Variants, Classes, Graphics,
  Dialogs, Menus, TeEngine, ExtCtrls, TeeProcs, Chart, Series, Grids,BcParser,XPMan;

    Function CreatePanelDistinction:boolean;
    Function CreateCheckDistinction:boolean;
    Function DestroyCheckDistinction:boolean;

implementation

uses MainUnit;

Function CreatePanelDistinction:boolean;
begin
  result:=true;
  TypeUnit.PanelDistinction:=TGroupBox.Create(MainUnit.MainForm);
  try
    with TypeUnit.PanelDistinction do
    begin
      Parent:= MainUnit.MainForm;
      left:=590;
      top:=500;
      Height:=85;
      width:=775;
      visible:=True;
      TypeUnit.PanelDistinction.Name:='PanelDistinctionAreaGroup';
    end;
  Except
    result:=false;
    TypeUnit.PanelDistinction.Destroy;
  end;
end;

Function CreateCheckBoxN(ParentCheck:TWinControl;k:integer):boolean;
var i,j,m:integer;
begin
  result:=true;
  m:=180;
  TypeUnit.CheckDistinction[k]:=TCheckBox.Create(ParentCheck);
  j:=k div 4;
  i:=(k mod 4);
  if j=3 then m:=190;

  with TypeUnit.CheckDistinction[k] do
  begin
    Parent:= ParentCheck;
    left:=2+ m*j;
    top:=12+(i*17);
    Height:=17;
    width:=250;
    checked:=false;
    visible:=true;
    TypeUnit.CheckDistinction[k].Name:='CheckDistinction'+inttostr(k);
    if k<>0
    then TypeUnit.CheckDistinction[k].OnClick:= MainUnit.MainForm.CheckDistinctionSeriesClick
    else TypeUnit.CheckDistinction[k].OnClick:= MainUnit.MainForm.CheckDistinctionClick
  end;
end;

Function CreateCheckDistinction:boolean;
var i:integer;
begin
  result:=true;
  try
    for I := 0 to TypeUnit.QCheck do
      CreateCheckBoxN(TypeUnit.PanelDistinction,i);
  Except
    result:=false;
    for I := 0 to TypeUnit.QCheck do TypeUnit.CheckDistinction[i].Destroy;
  end;
end;

Function DestroyCheckDistinction:boolean;
var i:integer;
begin
  for I := 0 to TypeUnit.QCheck do TypeUnit.CheckDistinction[i].Destroy;
  TypeUnit.PanelDistinction.Destroy;
end;

end.
