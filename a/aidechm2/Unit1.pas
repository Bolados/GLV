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
      PChar(HelpFile), // Propriété de Form1
      HH_HELP_CONTEXT,
      Data); // correspond à la propriété HelpContext
      Result:=(0<>Resultat)
end;

procedure TForm1.MessageAide( var msg:TMessage);
// cette procédure est déclenchée automatiquement à chaque fois
// qu'un utilisateur demande de l'aide (F1)
begin
    // S'il est différent de 0, on passe le HelpContext du contrôle (=du composant)
    //qui a le focus
    if ActiveControl.HelpContext<>0 then
    begin
      if not AfficheAide(ActiveControl.HelpContext)
      then ShowMessage('Erreur. Vérifiez la présence du fichier .chm dans le bon dossier');
    end;
    //inherited;// si on veut continuer à propager le message. Ici : non
end;

/////////////////////////////////////////////////////////////////////////////
// Implémentation des procédures propres aux boutons
/////////////////////////////////////////////////////////////////////////////

procedure TForm1.ButtonAideResultatContexteClick(Sender: TObject);
//Pour un Bouton "normal", il faut implémenter son
//évènement OnClick de façon à déclencher "à la main"
//l'aide. Ici, on montre une solution en utilisant un "Context"
Var UnBoolean:Boolean;
begin
  AfficheAide(1003);
  // On pourrait aussi, si on a mis la propriété du Button HelpContext à
  //par exemple : 1003, remplacer la ligne par :
  //OnAide(1,Button1.HelpContext,UnBoolean);
end;

procedure TForm1.ButtonAideResultatTopicClick(Sender: TObject);
//Ici : un accès direct pat "Topic"
begin
  HtmlHelp(Application.Handle,
  PChar('TestAide.chm::/resultat.htm'),
  HH_DISPLAY_TOPIC, 0);
end;



end.
