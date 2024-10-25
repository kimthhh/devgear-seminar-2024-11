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

            procedure WebFormCreate(Sender: TObject);
            procedure WebFormDestroy(Sender: TObject);

    [async] procedure btn_searchClick(Sender: TObject);
    [async] procedure btn_logoutClick(Sender: TObject);
    [async] procedure btn_loginClick(Sender: TObject);

  private
    { Private declarations }
    m_UnAuth : TPrsUnauthorized;  // verify & prs for Status code: 401 {Unauthorized}

  public
    { Public declarations }
    [async] function OnCheckUnauthorized( sMSG: string; sFrom: string ): Integer; // verify & prs for Status code: 401 {Unauthorized}
  end;

var
  fMAIN: TfMAIN;

implementation

{$R *.dfm}

procedure TfMAIN.WebFormCreate(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.WebFormCreate()' );
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
end;

procedure TfMAIN.btn_logoutClick(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.btn_logoutClick( call api )' );
end;

procedure TfMAIN.btn_searchClick(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.btn_searchClick( call api )' );
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
    // To do something...
    ShowMessage( '로그인을 다시 해 주세요!' );
  end;
end;


end.