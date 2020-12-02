object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 725
  ClientWidth = 1361
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenuProject
  OldCreateOrder = False
  Position = poDesigned
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseMove = FormMouseMove
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  PixelsPerInch = 96
  TextHeight = 13
  object Timetraced: TLabel
    Left = 8
    Top = 221
    Width = 393
    Height = 29
    Alignment = taCenter
    AutoSize = False
    Caption = 'Timetraced'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object NameLabel: TLabel
    Left = 7
    Top = 191
    Width = 396
    Height = 29
    Alignment = taCenter
    AutoSize = False
    Caption = 'Timetraced'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PanelVerificationConstruction: TGroupBox
    Left = 4
    Top = 249
    Width = 397
    Height = 95
    Caption = 'PanelVerificationConstruction'
    TabOrder = 5
    Visible = False
    object ClearControlFunction: TButton
      Left = 228
      Top = 59
      Width = 141
      Height = 25
      Caption = 'ClearControlFunction'
      TabOrder = 3
      OnClick = ClearControlFunctionClick
      OnKeyPress = UsersAnalytiqueFunctionKeyPress
    end
    object TraceControlFunction: TButton
      Left = 113
      Top = 59
      Width = 109
      Height = 25
      Caption = 'TraceControlFunction'
      TabOrder = 2
      OnClick = TraceControlFunctionClick
      OnKeyPress = UsersAnalytiqueFunctionKeyPress
    end
    object ControlFunction: TLabeledEdit
      Left = 3
      Top = 32
      Width = 366
      Height = 21
      EditLabel.Width = 76
      EditLabel.Height = 13
      EditLabel.Caption = 'ControlFunction'
      TabOrder = 1
      OnKeyPress = UsersAnalytiqueFunctionKeyPress
    end
    object GenerateFunction: TButton
      Left = 10
      Top = 59
      Width = 97
      Height = 25
      Caption = 'GenerateFunction'
      TabOrder = 0
      OnClick = GenerateFunctionClick
      OnKeyPress = UsersAnalytiqueFunctionKeyPress
    end
  end
  object StringGrid1: TStringGrid
    Left = 590
    Top = 587
    Width = 771
    Height = 124
    ColCount = 1
    DefaultColWidth = 65
    DefaultRowHeight = 25
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    TabOrder = 1
    OnDblClick = StringGrid1DblClick
    OnKeyPress = StringGrid1KeyPress
    OnSelectCell = StringGrid1SelectCell
    OnSetEditText = StringGrid1SetEditText
  end
  object PanelEnterData: TGroupBox
    Left = 8
    Top = 495
    Width = 579
    Height = 216
    Caption = 'PanelEnterData'
    TabOrder = 2
    Visible = False
    object ViewTranslateFunction: TButton
      Left = 273
      Top = 53
      Width = 219
      Height = 25
      Caption = 'ViewTranslateFunction'
      TabOrder = 4
      OnClick = ViewTranslateFunctionClick
      OnKeyPress = UsersAnalytiqueFunctionKeyPress
    end
    object ActiveEnterDataWithPoints: TCheckBox
      Left = 2
      Top = 15
      Width = 158
      Height = 17
      Caption = 'ActiveEnterDataWithPoints'
      TabOrder = 0
      Visible = False
      OnClick = ActiveEnterDataWithPointsClick
    end
    object ActiveEnterDataWithFunction: TCheckBox
      Left = 136
      Top = 30
      Width = 209
      Height = 17
      Caption = 'ActiveEnterDataWithFunction'
      TabOrder = 1
      Visible = False
      OnClick = ActiveEnterDataWithFunctionClick
    end
    object TranslateFunction: TLabeledEdit
      Left = 3
      Top = 53
      Width = 264
      Height = 21
      HelpContext = 1
      EditLabel.Width = 86
      EditLabel.Height = 13
      EditLabel.Caption = 'TranslateFunction'
      TabOrder = 3
      OnKeyPress = UsersAnalytiqueFunctionKeyPress
    end
    object PanelEnterDataWithFunction: TGroupBox
      Left = 0
      Top = 84
      Width = 333
      Height = 129
      Caption = 'PanelEnterDataWithFunction'
      TabOrder = 5
      Visible = False
      object IntervalA: TLabeledEdit
        Left = 3
        Top = 32
        Width = 78
        Height = 21
        EditLabel.Width = 45
        EditLabel.Height = 13
        EditLabel.Caption = 'IntervalA'
        TabOrder = 0
        OnKeyPress = UsersAnalytiqueFunctionKeyPress
      end
      object TraceUsersAnalytiqueFunction: TButton
        Left = 164
        Top = 59
        Width = 75
        Height = 25
        Caption = 'TraceUsersAnalytiqueFunction'
        TabOrder = 3
        OnClick = TraceUsersAnalytiqueFunctionClick
        OnKeyPress = UsersAnalytiqueFunctionKeyPress
      end
      object ClearUsersAnalytiqueFunction: TButton
        Left = 245
        Top = 59
        Width = 75
        Height = 25
        Caption = 'ClearUsersAnalytiqueFunction'
        TabOrder = 4
        OnClick = ClearUsersAnalytiqueFunctionClick
        OnKeyPress = UsersAnalytiqueFunctionKeyPress
      end
      object IntervalB: TLabeledEdit
        Left = 93
        Top = 32
        Width = 78
        Height = 21
        EditLabel.Width = 44
        EditLabel.Height = 13
        EditLabel.Caption = 'IntervalB'
        TabOrder = 1
        OnKeyPress = UsersAnalytiqueFunctionKeyPress
      end
      object UsersAnalytiqueFunction: TLabeledEdit
        Left = 177
        Top = 32
        Width = 153
        Height = 21
        Alignment = taCenter
        EditLabel.Width = 119
        EditLabel.Height = 13
        EditLabel.Caption = 'UsersAnalytiqueFunction'
        TabOrder = 2
        OnKeyPress = UsersAnalytiqueFunctionKeyPress
      end
      object AddPointWithFunction: TButton
        Left = 151
        Top = 90
        Width = 179
        Height = 25
        Caption = 'AddPointWithFunction'
        TabOrder = 5
        OnClick = AddPointWithFunctionClick
      end
      object DeplacePointEnterData: TGroupBox
        Left = 3
        Top = 59
        Width = 146
        Height = 54
        TabOrder = 6
        object Delta: TLabeledEdit
          Left = 45
          Top = 20
          Width = 58
          Height = 21
          EditLabel.Width = 25
          EditLabel.Height = 13
          EditLabel.Caption = 'Delta'
          TabOrder = 0
          Text = '0'
          OnKeyPress = UsersAnalytiqueFunctionKeyPress
        end
        object Minus: TButton
          Left = 4
          Top = 18
          Width = 35
          Height = 25
          Caption = '-'
          TabOrder = 1
          OnClick = MinusClick
        end
        object Plus: TButton
          Left = 107
          Top = 18
          Width = 36
          Height = 25
          Caption = '+'
          TabOrder = 2
          OnClick = PlusClick
        end
      end
    end
    object PanelEnterDataWithPoints: TGroupBox
      Left = 336
      Top = 84
      Width = 251
      Height = 129
      Caption = 'PanelEnterDataWithPoints'
      TabOrder = 6
      Visible = False
      object AddPoint: TButton
        Left = 3
        Top = 59
        Width = 75
        Height = 25
        Caption = 'AddPoint'
        TabOrder = 3
        OnClick = AddPointClick
        OnKeyPress = UsersAnalytiqueFunctionKeyPress
      end
      object AbscissX: TLabeledEdit
        Left = 3
        Top = 32
        Width = 62
        Height = 21
        EditLabel.Width = 41
        EditLabel.Height = 13
        EditLabel.Caption = 'AbscissX'
        TabOrder = 0
        OnKeyPress = UsersAnalytiqueFunctionKeyPress
      end
      object OrdinateY: TLabeledEdit
        Left = 71
        Top = 32
        Width = 65
        Height = 21
        EditLabel.Width = 48
        EditLabel.Height = 13
        EditLabel.Caption = 'OrdinateY'
        TabOrder = 1
        OnKeyPress = UsersAnalytiqueFunctionKeyPress
      end
      object PointChoosen: TCheckBox
        Left = 142
        Top = 36
        Width = 105
        Height = 17
        Caption = 'PointChoosen'
        TabOrder = 2
        OnKeyPress = UsersAnalytiqueFunctionKeyPress
      end
      object ModifyPoint: TButton
        Left = 84
        Top = 59
        Width = 75
        Height = 25
        Caption = 'ModifyPoint'
        TabOrder = 4
        OnClick = ModifyPointClick
        OnKeyPress = UsersAnalytiqueFunctionKeyPress
      end
      object RemovePoint: TButton
        Left = 165
        Top = 59
        Width = 75
        Height = 25
        Caption = 'RemovePoint'
        TabOrder = 5
        OnClick = RemovePointClick
        OnKeyPress = UsersAnalytiqueFunctionKeyPress
      end
      object ClearAllPoints: TButton
        Left = 48
        Top = 90
        Width = 137
        Height = 25
        Caption = 'ClearAllPoints'
        TabOrder = 6
        OnClick = ClearAllPointsClick
      end
    end
    object ActiveEnterDatawithMouse: TCheckBox
      Left = 151
      Top = 11
      Width = 217
      Height = 17
      Caption = 'ActiveEnterDatawithMouse'
      TabOrder = 7
      OnClick = ActiveEnterDatawithMouseClick
    end
    object ActiveMovingAddPoint: TCheckBox
      Left = 391
      Top = 11
      Width = 185
      Height = 17
      Caption = 'ActiveMovingAddPoint'
      TabOrder = 2
      OnClick = ActiveMovingAddPointClick
    end
  end
  object PanelZoom: TGroupBox
    Left = 406
    Top = 0
    Width = 181
    Height = 97
    Caption = 'PanelZoom'
    TabOrder = 10
    object PZoom: TRadioGroup
      Left = -1
      Top = 11
      Width = 182
      Height = 86
      Caption = 'PZoom'
      ItemIndex = 0
      Items.Strings = (
        'Normal'
        'Horizontal'
        'Vertical')
      TabOrder = 0
      Visible = False
      OnClick = PZoomClick
    end
    object ResetZoomAndScale: TButton
      Left = 96
      Top = 71
      Width = 85
      Height = 26
      Caption = 'ResetZoomAndScale'
      TabOrder = 1
      OnClick = ResetZoomAndScaleClick
    end
  end
  object PanelInformation: TGroupBox
    Left = 8
    Top = 2
    Width = 395
    Height = 183
    Caption = 'PanelInformation'
    TabOrder = 11
    Visible = False
    object MemoInformation: TMemo
      Left = 3
      Top = 21
      Width = 388
      Height = 156
      Lines.Strings = (
        'MemoInformation')
      TabOrder = 0
    end
  end
  object Chart: TChart
    Left = 593
    Top = -15
    Width = 791
    Height = 504
    Border.EndStyle = esSquare
    Border.Visible = True
    Legend.Alignment = laBottom
    Legend.CheckBoxesStyle = cbsRadio
    Legend.LegendStyle = lsSeries
    PrintProportional = False
    ScrollMouseButton = mbMiddle
    Title.Font.Charset = ANSI_CHARSET
    Title.Font.Color = clRed
    Title.Font.Height = -19
    Title.Font.Name = 'Times New Roman'
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      'TChart')
    Title.Transparency = 10
    Title.Transparent = False
    OnClickLegend = ChartClickLegend
    OnClickSeries = ChartClickSeries
    OnScroll = ChartScroll
    BottomAxis.Axis.Width = 3
    DepthAxis.Automatic = False
    DepthAxis.AutomaticMaximum = False
    DepthAxis.AutomaticMinimum = False
    DepthAxis.Maximum = 1.580000000000091000
    DepthAxis.Minimum = 0.580000000000096900
    DepthTopAxis.Automatic = False
    DepthTopAxis.AutomaticMaximum = False
    DepthTopAxis.AutomaticMinimum = False
    DepthTopAxis.Maximum = 1.580000000000091000
    DepthTopAxis.Minimum = 0.580000000000096900
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.Axis.Width = 3
    LeftAxis.Maximum = 1614.034841786608000000
    LeftAxis.MaximumOffset = 10
    LeftAxis.Minimum = 50.373448901399830000
    LeftAxis.MinimumOffset = -10
    RightAxis.Automatic = False
    RightAxis.AutomaticMaximum = False
    RightAxis.AutomaticMinimum = False
    RightAxis.Visible = False
    TopAxis.Automatic = False
    TopAxis.AutomaticMaximum = False
    TopAxis.AutomaticMinimum = False
    TopAxis.Visible = False
    View3D = False
    Zoom.UpLeftZooms = True
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    OnMouseDown = ChartMouseDown
    OnMouseMove = ChartMouseMove
    OnMouseUp = ChartMouseUp
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      17
      15
      17)
    ColorPaletteIndex = 13
    object SetValueInsetting: TButton
      Left = 1
      Top = 480
      Width = 253
      Height = 23
      Caption = 'SetValueInsetting'
      TabOrder = 0
      OnClick = SetValueInsettingClick
    end
    object DrawAxisX: TCheckBox
      Left = 665
      Top = 15
      Width = 97
      Height = 17
      Caption = 'DrawAxisX'
      TabOrder = 1
      Visible = False
      OnClick = DrawAxisXClick
    end
    object DrawAxisY: TCheckBox
      Left = 665
      Top = 38
      Width = 97
      Height = 17
      Caption = 'DrawAxisY'
      TabOrder = 2
      Visible = False
      OnClick = DrawAxisXClick
    end
    object ReportResize: TButton
      Left = 742
      Top = 479
      Width = 29
      Height = 25
      Caption = 'ReportResize'
      TabOrder = 3
      Visible = False
      OnClick = ReportResizeClick
    end
    object ResizeChart: TButton
      Left = 0
      Top = 15
      Width = 131
      Height = 40
      Caption = 'ResizeChart'
      TabOrder = 4
      OnClick = ResizeChartClick
    end
    object Series1: TLineSeries
      SeriesColor = 16777088
      Title = 'Lagrange'
      Brush.BackColor = clDefault
      LinePen.Width = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series2: TPointSeries
      Active = False
      Marks.Shadow.Color = 8487297
      Title = 'Choosen Point'
      ClickableLine = False
      Pointer.Brush.Color = clBlack
      Pointer.HorizSize = 8
      Pointer.InflateMargins = True
      Pointer.Style = psCircle
      Pointer.VertSize = 8
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series3: TPointSeries
      Active = False
      Marks.BackColor = 8421631
      Marks.Color = 8421631
      Title = 'Not Choosen Point'
      ClickableLine = False
      Pointer.Brush.Color = -1
      Pointer.HorizSize = 6
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.VertSize = 6
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series5: TLineSeries
      Active = False
      SeriesColor = clRed
      Title = 'Generalizing Lagrange I'
      Brush.BackColor = clDefault
      LinePen.Width = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series4: TLineSeries
      Active = False
      SeriesColor = clBlue
      Shadow.Color = clBlue
      Shadow.Visible = False
      Title = 'User Function'
      Brush.BackColor = clDefault
      LinePen.Width = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series6: TLineSeries
      Active = False
      SeriesColor = clBlack
      Title = 'Generalizing Lagrange II'
      Brush.BackColor = clDefault
      LinePen.Color = 8421631
      LinePen.Width = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series7: TLineSeries
      Active = False
      SeriesColor = 8454016
      Title = 'Error Lagrange Function'
      Brush.BackColor = clDefault
      LinePen.Width = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series8: TLineSeries
      Active = False
      SeriesColor = 16750079
      Title = 'Error Generalizing Lagrange Function I'
      Brush.BackColor = clDefault
      LinePen.Width = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series9: TPointSeries
      Active = False
      Title = 'Error Lagrange Points'
      ClickableLine = False
      Pointer.Brush.Color = 8453888
      Pointer.HorizSize = 5
      Pointer.InflateMargins = True
      Pointer.Style = psDiamond
      Pointer.VertSize = 5
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series10: TPointSeries
      Active = False
      Title = 'Error Generalizing Lagrange Points I'
      ClickableLine = False
      Pointer.Brush.Color = 16744703
      Pointer.HorizSize = 5
      Pointer.InflateMargins = True
      Pointer.Style = psDiamond
      Pointer.VertSize = 5
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series11: TLineSeries
      Active = False
      SeriesColor = clYellow
      Title = 'Verification Function'
      Brush.BackColor = clDefault
      LinePen.Color = clTeal
      LinePen.Width = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      TreatNulls = tnIgnore
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series12: TLineSeries
      Active = False
      SeriesColor = 10879142
      Title = 'Error Generalizing Lagrange Function II'
      Brush.BackColor = clDefault
      LinePen.Color = clNavy
      LinePen.Width = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      TreatNulls = tnIgnore
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series13: TPointSeries
      Active = False
      Marks.Callout.Length = 8
      Title = 'Error Generalizing Lagrange Points II'
      ClickableLine = False
      Pointer.HorizSize = 5
      Pointer.InflateMargins = True
      Pointer.Style = psDiamond
      Pointer.VertSize = 5
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series14: TLineSeries
      Active = False
      SeriesColor = clBlack
      Title = 'Series14AxisX'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series15: TLineSeries
      Active = False
      SeriesColor = clBlack
      Title = 'Series15AxisY'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object PanelExitData: TGroupBox
    Left = 406
    Top = 103
    Width = 182
    Height = 386
    Caption = 'PanelExitData'
    TabOrder = 4
    Visible = False
    object LaGrange: TGroupBox
      Left = 0
      Top = 13
      Width = 187
      Height = 90
      Caption = 'LaGrange'
      TabOrder = 0
      object CheckBoxLagrangeFunction: TCheckBox
        Left = 3
        Top = 12
        Width = 170
        Height = 17
        Caption = 'CheckBoxLagrangeFunction'
        TabOrder = 0
        OnClick = CheckBoxLagrangeFunctionClick
      end
      object CheckBoxErrorLagrangeFunction: TCheckBox
        Left = 3
        Top = 30
        Width = 182
        Height = 17
        Caption = 'CheckBoxErrorLagrangeFunction'
        TabOrder = 1
        OnClick = CheckBoxErrorLagrangeFunctionClick
      end
      object LagrangeAccuracy: TLabeledEdit
        Left = 3
        Top = 63
        Width = 179
        Height = 24
        EditLabel.Width = 89
        EditLabel.Height = 13
        EditLabel.Caption = 'LagrangeAccuracy'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        Visible = False
      end
    end
    object GeneralizingLagrange: TGroupBox
      Left = -3
      Top = 106
      Width = 188
      Height = 195
      Caption = 'GeneralizingLagrange'
      TabOrder = 1
      object GeneralizingLagrangeI: TGroupBox
        Left = 4
        Top = 12
        Width = 185
        Height = 90
        Caption = 'GeneralizingLagrangeI'
        TabOrder = 0
        object CheckBoxErrorGeneralizingFunction: TCheckBox
          Left = 3
          Top = 30
          Width = 178
          Height = 17
          Caption = 'CheckBoxErrorGeneralizingFunction'
          TabOrder = 0
          OnClick = CheckBoxErrorGeneralizingFunctionClick
        end
        object CheckBoxGeneralizingFunction: TCheckBox
          Left = 3
          Top = 12
          Width = 184
          Height = 17
          Caption = 'CheckBoxGeneralizingFunction'
          TabOrder = 1
          OnClick = CheckBoxGeneralizingFunctionClick
        end
        object GeneralisedAccuracy: TLabeledEdit
          Left = 3
          Top = 63
          Width = 178
          Height = 24
          EditLabel.Width = 100
          EditLabel.Height = 13
          EditLabel.Caption = 'GeneralisedAccuracy'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clAqua
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          Visible = False
        end
      end
      object GeneralizingLagrangeII: TGroupBox
        Left = 4
        Top = 102
        Width = 185
        Height = 90
        Caption = 'GeneralizingLagrangeII'
        TabOrder = 1
        object GeneralisedAccuracyII: TLabeledEdit
          Left = 3
          Top = 63
          Width = 178
          Height = 24
          EditLabel.Width = 100
          EditLabel.Height = 13
          EditLabel.Caption = 'GeneralisedAccuracy'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clAqua
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          Visible = False
        end
        object CheckboxErrorGeneralizingFunctionII: TCheckBox
          Left = 3
          Top = 30
          Width = 178
          Height = 17
          Caption = 'CheckBoxErrorGeneralizingFunction'
          TabOrder = 1
          OnClick = CheckboxErrorGeneralizingFunctionIIClick
        end
        object CheckboxGeneralizingFunctionII: TCheckBox
          Left = 3
          Top = 12
          Width = 184
          Height = 17
          Caption = 'CheckBoxGeneralizingFunction'
          TabOrder = 2
          OnClick = CheckboxGeneralizingFunctionIIClick
        end
      end
    end
    object PanelViewFormule: TGroupBox
      Left = 0
      Top = 304
      Width = 188
      Height = 68
      Caption = 'PanelViewFormule'
      TabOrder = 2
      object CheckBoxViewLagrangeFunction: TCheckBox
        Left = 3
        Top = 12
        Width = 180
        Height = 17
        Caption = 'CheckBoxViewLagrangeFunction'
        TabOrder = 0
        OnClick = CheckBoxViewGeneralizingFunctionClick
      end
      object CheckBoxViewGeneralizingFunction: TCheckBox
        Left = 3
        Top = 28
        Width = 180
        Height = 17
        Caption = 'CheckBoxViewGeneralizingFunction'
        TabOrder = 1
        OnClick = CheckBoxViewGeneralizingFunctionClick
      end
      object CheckBoxViewGeneralizingFunctionII: TCheckBox
        Left = 3
        Top = 45
        Width = 166
        Height = 17
        Caption = 'CheckBoxViewGeneralizingFunctionII'
        TabOrder = 2
        OnClick = CheckBoxViewGeneralizingFunctionClick
      end
    end
  end
  object HideFunction: TComboBox
    Left = 1119
    Top = 477
    Width = 207
    Height = 21
    TabOrder = 7
    Text = 'Show All'
    OnChange = HideFunctionChange
    OnKeyPress = UsersAnalytiqueFunctionKeyPress
    Items.Strings = (
      'Show All'
      'Show Function'
      'Hidden Function')
  end
  object DistinctionWithResize: TCheckBox
    Left = 853
    Top = 480
    Width = 260
    Height = 16
    Caption = 'DistinctionWithResize'
    TabOrder = 6
    OnClick = DistinctionWithResizeClick
  end
  object ViewNode: TCheckBox
    Left = 486
    Top = 592
    Width = 98
    Height = 17
    Caption = 'ViewNode'
    Checked = True
    State = cbChecked
    TabOrder = 3
    Visible = False
    OnClick = ViewNodeClick
  end
  object HistoryPanel: TGroupBox
    Left = 8
    Top = 350
    Width = 395
    Height = 139
    Caption = 'HistoryPanel'
    TabOrder = 8
    Visible = False
    object HistoryTranslateFunction: TListBox
      Left = 0
      Top = 40
      Width = 365
      Height = 60
      ItemHeight = 13
      TabOrder = 1
      OnDblClick = HistoryTranslateFunctionDblClick
    end
    object ClearHistoryTranslate: TButton
      Left = 202
      Top = 106
      Width = 163
      Height = 25
      Caption = 'ClearAllHistoryTranslate'
      TabOrder = 3
      OnClick = ClearHistoryTranslateClick
    end
    object DeleteChoosedHistory: TButton
      Left = 3
      Top = 106
      Width = 190
      Height = 25
      Caption = 'DeleteChoosedHistory'
      TabOrder = 2
      OnClick = DeleteChoosedHistoryClick
    end
    object ActiveSelectMultiple: TCheckBox
      Left = 2
      Top = 17
      Width = 294
      Height = 17
      Caption = 'ActiveSelectMultiple'
      TabOrder = 0
      OnClick = ActiveSelectMultipleClick
    end
  end
  object ClearAllData: TButton
    Left = 406
    Top = 475
    Width = 183
    Height = 25
    Caption = 'ClearAllData'
    TabOrder = 9
    OnClick = ClearAllDataClick
  end
  object MainMenuProject: TMainMenu
    Left = 32
    Top = 120
    object Project: TMenuItem
      Caption = 'Project'
      object NewProject: TMenuItem
        Caption = 'New Project'
        OnClick = NewProjectClick
      end
      object LoadProject: TMenuItem
        Caption = 'Load Project'
        OnClick = LoadProjectClick
      end
      object SaveProject: TMenuItem
        Caption = 'Save Project'
        OnClick = SaveProjectClick
      end
      object SaveProjectAs: TMenuItem
        Caption = 'Save  Project as'
        OnClick = SaveProjectAsClick
      end
      object ExitProject: TMenuItem
        Caption = 'Exit Project'
        OnClick = ExitProjectClick
      end
    end
    object EnterData: TMenuItem
      Caption = 'EnterData'
      Visible = False
      OnClick = EnterDataClick
    end
    object ExitData: TMenuItem
      Caption = 'ExitData'
      Visible = False
      OnClick = ExitDataClick
    end
    object Setting: TMenuItem
      Caption = 'Setting'
      OnClick = SettingClick
    end
    object VerificationConstruction: TMenuItem
      Caption = 'VerificationConstruction'
      Visible = False
      OnClick = VerificationConstructionClick
    end
    object ZoomAndScale: TMenuItem
      Caption = 'ZoomAndScale'
      Visible = False
      OnClick = ZoomAndScaleClick
    end
    object SendToReport: TMenuItem
      Caption = 'SendToReport'
      OnClick = SendToReportClick
    end
    object Report: TMenuItem
      Caption = 'Report'
      OnClick = ReportClick
    end
    object Help: TMenuItem
      Caption = 'Help'
      OnClick = HelpClick
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.bsc'
    Filter = '*.bsc|*.bsc'
    Left = 152
    Top = 120
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '*.bsc'
    Filter = '*.bsc|*.bsc'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    OnCanClose = SaveDialogCanClose
    Left = 96
    Top = 120
  end
  object SaveDocument: TSaveDialog
    DefaultExt = '*.doc'
    Filter = '*.doc|*.doc'
    OnCanClose = SaveDocumentCanClose
    Left = 200
    Top = 120
  end
end
