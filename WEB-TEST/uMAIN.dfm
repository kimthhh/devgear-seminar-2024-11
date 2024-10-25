object fMAIN: TfMAIN
  Width = 1464
  Height = 978
  OnCreate = WebFormCreate
  OnDestroy = WebFormDestroy
  object lbl_info: TWebLabel
    Left = 0
    Top = 0
    Width = 1464
    Height = 133
    Align = alTop
    Caption = '  Hello, World!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -100
    Font.Name = 'Segoe UI'
    Font.Style = []
    HeightPercent = 100.000000000000000000
    ParentFont = False
    WidthPercent = 100.000000000000000000
    ExplicitWidth = 627
  end
  object pnl_body: TWebPanel
    Left = 0
    Top = 133
    Width = 1464
    Height = 845
    Align = alClient
    ChildOrder = 1
    TabOrder = 0
    ExplicitLeft = -8
    ExplicitTop = 261
    object grd_test: TWebStringGrid
      Left = 0
      Top = 0
      Width = 1464
      Height = 845
      Align = alClient
      TabOrder = 0
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -18
      FixedFont.Name = 'Segoe UI'
      FixedFont.Style = []
      RangeEdit.Max = 100.000000000000000000
      RangeEdit.Step = 1.000000000000000000
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      ExplicitLeft = 432
      ExplicitTop = 248
      ExplicitWidth = 320
      ExplicitHeight = 120
    end
  end
  object btn_search: TWebButton
    Left = 1288
    Top = 32
    Width = 145
    Height = 75
    Anchors = [akTop, akRight]
    Caption = #51312' '#54924
    ChildOrder = 2
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    OnClick = btn_searchClick
  end
  object btn_login: TWebButton
    Left = 986
    Top = 32
    Width = 145
    Height = 75
    Anchors = [akTop, akRight]
    Caption = #47196#44536#51064
    ChildOrder = 2
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    OnClick = btn_loginClick
  end
  object btn_logout: TWebButton
    Left = 1137
    Top = 32
    Width = 145
    Height = 75
    Anchors = [akTop, akRight]
    Caption = #47196#44536#50500#50883
    ChildOrder = 2
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    OnClick = btn_logoutClick
  end
end
