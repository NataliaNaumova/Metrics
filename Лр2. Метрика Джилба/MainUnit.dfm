object MainFrm: TMainFrm
  Left = 0
  Top = 0
  Caption = 'MainFrm'
  ClientHeight = 201
  ClientWidth = 501
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabelEnterPace: TLabel
    Left = 24
    Top = 24
    Width = 123
    Height = 13
    Caption = #1059#1082#1072#1078#1080#1090#1077' '#1087#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' :'
  end
  object lblIfThenElseCount: TLabel
    Left = 24
    Top = 88
    Width = 90
    Height = 13
    Caption = 'lblIfThenElseCount'
    Visible = False
  end
  object lblCommonOperatorCount: TLabel
    Left = 24
    Top = 120
    Width = 124
    Height = 13
    Caption = 'lblCommonOperatorCount'
    Visible = False
  end
  object lblRelativeProgramComplexity: TLabel
    Left = 24
    Top = 152
    Width = 142
    Height = 13
    Caption = 'lblRelativeProgramComplexity'
    Visible = False
  end
  object EditEnterPace: TEdit
    Left = 24
    Top = 43
    Width = 297
    Height = 21
    TabOrder = 0
    Text = 'C++.cpp'
  end
  object ButtonAnalyze: TButton
    Left = 344
    Top = 41
    Width = 121
    Height = 25
    Caption = #1040#1085#1072#1083#1080#1079#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 1
    OnClick = ButtonAnalyzeClick
  end
end
