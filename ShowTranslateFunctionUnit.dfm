object TranslateFunctionForm: TTranslateFunctionForm
  Left = 0
  Top = 0
  AutoSize = True
  Caption = 'Form1'
  ClientHeight = 505
  ClientWidth = 793
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 793
    Height = 505
    Foot.Text.Strings = (
      '')
    Legend.Alignment = laBottom
    Legend.LegendStyle = lsSeries
    ScrollMouseButton = mbMiddle
    SubTitle.Font.Color = clRed
    SubTitle.Font.Height = -20
    SubTitle.Font.Style = [fsItalic]
    SubTitle.Text.Strings = (
      'bscako')
    Title.Brush.Color = clWhite
    Title.Brush.Style = bsClear
    Title.Font.Charset = ANSI_CHARSET
    Title.Font.Color = clRed
    Title.Font.Height = -27
    Title.Font.Name = 'Times New Roman'
    Title.Font.Style = [fsBold, fsUnderline]
    Title.Text.Strings = (
      'TChart')
    OnClickLegend = Chart1ClickLegend
    View3D = False
    Color = clWhite
    TabOrder = 0
    object Series2: TLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      SeriesColor = clBlack
      Title = 'X'
      Brush.Color = clBlack
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      Data = {
        001900000066666666E62F8E4000000000801A8D409A99999919298D40343333
        33B3128E409A99999999288E409A99999999718E409A99999919728D409A9999
        9919728D400000000000888D4066666666E60B8D400000000000D28B40666666
        66E6C38A400000000080408A4066666666E6C38A400000000080AE8940333333
        3333CC88403333333333A7894066666666E6E889406666666666318B40333333
        33B3138C403333333333818C403333333333A68B406666666666318B40666666
        66E6798C4033333333B3A58C40}
    end
    object Series3: TLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      SeriesColor = clBlack
      Title = 'Y'
      Brush.Color = clBlack
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series1: TFastLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      Title = 'TranslateFunction'
      LinePen.Color = clRed
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
end
