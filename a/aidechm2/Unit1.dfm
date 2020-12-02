object Form1: TForm1
  Left = 192
  Top = 107
  Width = 402
  Height = 292
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'TestAide.chm'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 176
    Top = 80
    Width = 21
    Height = 37
    Caption = '='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SpinEdit1: TSpinEdit
    Left = 40
    Top = 40
    Width = 121
    Height = 22
    HelpContext = 1000
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
  end
  object SpinEdit2: TSpinEdit
    Left = 216
    Top = 40
    Width = 121
    Height = 22
    HelpContext = 1000
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object Edit1: TEdit
    Left = 128
    Top = 120
    Width = 121
    Height = 21
    HelpContext = 1003
    TabOrder = 2
  end
  object ButtonPlus: TButton
    Left = 168
    Top = 8
    Width = 41
    Height = 33
    HelpContext = 1001
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object ButtonMoins: TButton
    Left = 168
    Top = 48
    Width = 41
    Height = 33
    HelpContext = 1002
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object ButtonAideResultatContexte: TButton
    Left = 216
    Top = 152
    Width = 137
    Height = 49
    HelpContext = 1003
    Caption = 'Aide R'#233'sultat Par Context'
    TabOrder = 5
    OnClick = ButtonAideResultatContexteClick
  end
  object Memo3: TMemo
    Left = 16
    Top = 160
    Width = 185
    Height = 89
    Color = clInfoBk
    Lines.Strings = (
      'Pour chacun des Composants '
      'visuels de la fiche, donnez une '
      'valeur  '#224' la propri'#233't'#233' HelpContext '
      'en correspondance avec l'#39'aide '
      'que vous souhaitez voir affich'#233'e. '
      '(voir le fichier .h qui vous a servi '#224' '
      'rentrer des alias)')
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object ButtonAideResultatTopic: TButton
    Left = 216
    Top = 216
    Width = 137
    Height = 25
    Caption = 'Aide R'#233'sultat par topic'
    TabOrder = 7
    OnClick = ButtonAideResultatTopicClick
  end
end
