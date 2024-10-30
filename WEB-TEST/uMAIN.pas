// Copyright (c) KIM TAE HYUN, 2024.
//
// This file is part of devgear-seminar-2024-11 and is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

unit uMAIN;

interface

uses
  System.SysUtils  ,
  System.Classes   ,

  Vcl.Controls     ,
  Vcl.StdCtrls     ,
  Vcl.Grids        ,

  JS               ,
  Web              ,
  Types            ,

  uGlobal          ,
  uPrsUnauthorized ,
  uUtils           ,
  uApiProtocols    ,
  uApiList         ,

  WEBLib.Graphics  ,
  WEBLib.Controls  ,
  WEBLib.Forms     ,
  WEBLib.Dialogs   ,
  WEBLib.StdCtrls  ,
  WEBLib.ExtCtrls  ,
  WEBLib.Grids
  ;

type
  TfMAIN = class(TWebForm)
    lbl_info    : TWebLabel;
    pnl_body    : TWebPanel;
    btn_login   : TWebButton;
    btn_logout  : TWebButton;
    btn_search  : TWebButton;
    grd_test    : TWebStringGrid;
    edt_apikey: TWebEdit;

            procedure WebFormCreate(Sender: TObject);
            procedure WebFormDestroy(Sender: TObject);

    [async] procedure btn_searchClick(Sender: TObject);
    [async] procedure btn_logoutClick(Sender: TObject);
    [async] procedure btn_loginClick(Sender: TObject);

  private
    { Private declarations }
    m_UnAuth  : TPrsUnauthorized;  // verify & prs for Status code: 401 {Unauthorized}
    m_stLogin : ST_Indexed_DB;
    m_stGrid  : ST_GRID_DATA_SET;

    procedure set_grid_header();
  public
    { Public declarations }
    [async] function OnCheckUnauthorized( sMSG: string; sFrom: string ): Integer; // verify & prs for Status code: 401 {Unauthorized}
  end;

var
  fMAIN: TfMAIN;

implementation

{$R *.dfm}

procedure TfMAIN.set_grid_header();
begin
  SetConsoleLog( '** TfMAIN.set_grid_header()' );

  // TWebStringGrid > grd_test 설정
  grd_test.RowCount := 1; // 첫 번째 행은 헤더로 사용
  grd_test.ColCount := 6;

  // 컬럼 너비 설정
  grd_test.ColWidths[0] := 10;
  grd_test.ColWidths[1] := 50;
  grd_test.ColWidths[2] := 150;
  grd_test.ColWidths[3] := 250;
  grd_test.ColWidths[4] := 250;
  grd_test.ColWidths[5] := 500;

  //Grid.RowHeights[row]: integer

  // 헤더 추가
  grd_test.Cells[0, 0] := '';
  grd_test.Cells[1, 0] := 'ID';
  grd_test.Cells[2, 0] := 'Name';
  grd_test.Cells[3, 0] := 'Mobile';
  grd_test.Cells[4, 0] := 'E-Mail';
  grd_test.Cells[5, 0] := 'Address';
end;

procedure TfMAIN.WebFormCreate(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.WebFormCreate()' );

  g_sApiKEY          := '';
  edt_apikey.Enabled := False;
  btn_logout.Enabled := False;
  btn_search.Enabled := False;

  set_grid_header();

  m_UnAuth := TPrsUnauthorized.Create( TOnCheckUnauthorized( @OnCheckUnauthorized ) ); // verify & prs for Status code: 401 {Unauthorized}
end;

procedure TfMAIN.WebFormDestroy(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.WebFormDestroy()' );
  m_UnAuth.Free;
end;

procedure TfMAIN.btn_loginClick(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.btn_loginClick( call api )' );
  try
    btn_login.Enabled := False;
    m_stLogin  := Await( api_post_login( g_sApiURL, 'kimtaehyun', 'pointhub' ) );

    if( m_stLogin.s_Token <> '' )then
    begin
      g_sApiKEY       := m_stLogin.s_Token;
      edt_apikey.Text := m_stLogin.s_Token;

      btn_logout.Enabled := True;
      btn_search.Enabled := True;
      btn_login.Enabled  := False;
    end
    else
    begin
      btn_logout.Enabled := False;
      btn_search.Enabled := False;
      btn_login.Enabled  := True;
    end;
  finally
    ;
  end;
end;

procedure TfMAIN.btn_logoutClick(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.btn_logoutClick( call api )' );
  try
    btn_logout.Enabled := False;
    m_stLogin := await( api_post_logout( g_sApiUrl     ,
                                         g_sApiKEY     ,
                                         m_stLogin.s_USER_ID ) );

    if( m_stLogin.sException = '' )then
    begin
      btn_login.Enabled  := True;
      btn_logout.Enabled := False;
      btn_search.Enabled := False;
      g_sApiKEY          := m_stLogin.s_Token;
      edt_apikey.Text    := m_stLogin.s_Token;

      grd_test.RowCount  := 1;
    end
    else
    begin
      btn_logout.Enabled := True;
    end;
  finally
    ;
  end;
end;

procedure TfMAIN.btn_searchClick(Sender: TObject);
var
  I: Integer;
begin
  SetConsoleLog( '** TfMAIN.btn_searchClick( call api )' );
  if( btn_search.Enabled )then
  begin
    try
      grd_test.RowCount := 1;
      btn_search.Enabled := False;
      if( g_sApiKEY <> '' )then
      begin
        m_stGrid := await( api_get_GetGridDATA( g_sApiUrl ,
                                                g_sApiKEY , '' ) );
        SetConsoleLog( m_stGrid );

        // TWebStringGrid 설정
        grd_test.RowCount := m_stGrid.n_count + 1; // 첫 번째 행은 헤더로 사용

        // record 배열 데이터를 그리드에 삽입
        for i := 0 to m_stGrid.n_count -1 do
        begin
          grd_test.Cells[1, i + 1] := IntToStr( I+1 );
          grd_test.Cells[2, i + 1] := m_stGrid.ITEM[I].s_name;
          grd_test.Cells[3, i + 1] := m_stGrid.ITEM[I].s_mobile;
          grd_test.Cells[4, i + 1] := m_stGrid.ITEM[I].s_email;
          grd_test.Cells[5, i + 1] := m_stGrid.ITEM[I].s_addr;
        end;

      end;
    finally
      btn_search.Enabled := True;
    end;
  end;
end;

function TfMAIN.OnCheckUnauthorized( sMSG: string; sFrom: string ): Integer; // verify & prs for Status code: 401 {Unauthorized}
var
  sINFO : string;
  stDB  : ST_Indexed_DB;
begin
  sINFO := Format( '** TfMAIN.OnCheckUnauthorized( %s )', [sFrom] );
  SetConsoleLog( sINFO );

  Result := 0;

  if( sMSG <> '' )then
  begin
    g_sApiKEY          := '';
    btn_logout.Enabled := False;
    btn_search.Enabled := False;

    ShowMessage( '로그인을 다시 해 주세요!' );
  end;
end;


end.