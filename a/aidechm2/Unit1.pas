unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Buttons, AppEvnts;

type
  TForm1 = class(TForm)
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Edit1: TEdit;
    Label1: TLabel;
    ButtonPlus: TButton;
    ButtonMoins: TButton;
    ButtonAideResultatContexte: TButton;
    Memo3: TMemo;
    ButtonAideResultatTopic: TButton;
    procedure ButtonAideResultatContexteClick(Sender: TObject);
    procedure ButtonAideResultatTopicClick(Sender: TObject);
  private
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    function AfficheAide(Data: Integer): Boolean; 
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
const
  HH_HELP_CONTEXT         = $000F;
  HH_DISPLAY_TOPIC        = $0000;

function HtmlHelp(hwndCaller: HWND;
  pszFile: PChar; uCommand: UINT;
  dwData: DWORD): HWND; stdcall;
  external 'HHCTRL.OCX' name 'HtmlHelpA';
 

function TForm1.AfficheAide( Data: Integer) : Boolean;
var Resultat:HWND;
begin
      Resultat:=HtmlHelp(Application.Handle,
      PChar(HelpFile), // Propri�t� de Form1
      HH_HELP_CONTEXT,
      Data); // correspond � la propri�t� HelpContext
      Result:=(0<>Resultat)
end;

procedure TForm1.MessageAide( var msg:TMessage);
// cette proc�dure est d�clench�e automatiquement � chaque fois
// qu'un utilisateur demande de l'aide (F1)
begin
    // S'il est diff�rent de 0, on passe le HelpContext du contr�le (=du composant)
    //qui a le focus
    if ActiveControl.HelpContext<>0 then
    begin
      if not AfficheAide(ActiveControl.HelpContext)
      then ShowMessage('Erreur. V�rifiez la pr�sence du fichier .chm dans le bon dossier');
    end;
    //inherited;// si on veut continuer � propager le message. Ici : non
end;

/////////////////////////////////////////////////////////////////////////////
// Impl�mentation des proc�dures propres aux boutons
/////////////////////////////////////////////////////////////////////////////

procedure TForm1.ButtonAideResultatContexteClick(Sender: TObject);
//Pour un Bouton "normal", il faut impl�menter son
//�v�nement OnClick de fa�on � d�clencher "� la main"
//l'aide. Ici, on montre une solution en utilisant un "Context"
Var UnBoolean:Boolean;
begin
  AfficheAide(1003);
  // On pourrait aussi, si on a mis la propri�t� du Button HelpContext �
  //par exemple : 1003, remplacer la ligne par :
  //OnAide(1,Button1.HelpContext,UnBoolean);
end;

procedure TForm1.ButtonAideResultatTopicClick(Sender: TObject);
//Ici : un acc�s direct pat "Topic"
begin
  HtmlHelp(Application.Handle,
  PChar('TestAide.chm::/resultat.htm'),
  HH_DISPLAY_TOPIC, 0);
end;



end.
