unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Buttons;

type
  TForm1 = class(TForm)
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Edit1: TEdit;
    Label1: TLabel;
    ButtonPlus: TButton;
    ButtonMoins: TButton;
    BitBtnAideAdition: TBitBtn;
    BitBtnAideResultat: TBitBtn;
    procedure BitBtnAideAditionClick(Sender: TObject);
    procedure BitBtnAideResultatClick(Sender: TObject);
  private
    { Déclarations privées }
  public


  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
const
  HH_HELP_CONTEXT         = $000F;
  HH_DISPLAY_TOPIC        = $0000;

// il existe aussi :
//  HH_DISPLAY_TOC          = $0001;
//  HH_CLOSE_ALL            = $0012;

function HtmlHelp(hwndCaller: HWND;
  pszFile: PChar; uCommand: UINT;
  dwData: DWORD): HWND; stdcall;
  external 'HHCTRL.OCX' name 'HtmlHelpA';


procedure TForm1.BitBtnAideAditionClick(Sender: TObject);
begin
      HtmlHelp(Application.Handle,
      PChar('TestAide.chm'), //PChar est inutile ici mais indispensable
      //si vous remplacez 'TestAide.chm' par une variable copntenant cette valeur.
      HH_HELP_CONTEXT,1001);
end;

procedure TForm1.BitBtnAideResultatClick(Sender: TObject);
begin
      HtmlHelp(Application.Handle,
      PChar('TestAide.chm::/resultat.htm'),
      HH_DISPLAY_TOPIC, 0);
end;

end.
