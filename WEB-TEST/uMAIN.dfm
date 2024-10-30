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
    end
  end
  object btn_search: TWebButton
    Left = 1288
    Top = 20
    Width = 145
    Height = 56
    Anchors = [akTop, akRight]
    Caption = 'Search'
    ChildOrder = 2
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    OnClick = btn_searchClick
  end
  object btn_login: TWebButton
    Left = 986
    Top = 20
    Width = 145
    Height = 56
    Anchors = [akTop, akRight]
    Caption = 'Login'
    ChildOrder = 2
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    OnClick = btn_loginClick
  end
  object btn_logout: TWebButton
    Left = 1137
    Top = 20
    Width = 145
    Height = 56
    Anchors = [akTop, akRight]
    Caption = 'Logout'
    ChildOrder = 2
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    OnClick = btn_logoutClick
  end
  object edt_apikey: TWebEdit
    Left = 986
    Top = 88
    Width = 447
    Height = 34
    Anchors = [akTop, akRight]
    ChildOrder = 5
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
end
