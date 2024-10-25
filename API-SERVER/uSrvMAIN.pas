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

unit uSrvMAIN;

interface

uses
    Winapi.Windows
  , Winapi.Messages
  , System.SysUtils
  , System.Variants
  , System.Classes
  , Vcl.Graphics
  , Vcl.Controls
  , Vcl.Forms
  , Vcl.Dialogs
  , Vcl.StdCtrls
  , uServerContainer

  , Winapi.MMSystem
  , uLogWriteThread
  , Winapi.ShellAPI

  ;

const
  g_chrome32 = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe';
  g_chrome64 = 'C:\Program Files\Google\Chrome\Application\chrome.exe';

type
  TfSvrMAIN = class(TForm)
    mmInfo        : TMemo;
    btStart       : TButton;
    btStop        : TButton;
    btn_SwaggerUI : TButton;
    procedure btStartClick(ASender: TObject);
    procedure btStopClick(ASender: TObject);
    procedure FormCreate(ASender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_SwaggerUIClick(Sender: TObject);
  strict private
    procedure UpdateGUI;
  public
    m_hLogEvent    : THandle;
    m_nLogWriteTrd : Integer;
    m_LogWriteTrd  : TLogWriteThread;
  private
    m_sURL         : string;
  end;

var
  fSvrMAIN: TfSvrMAIN;

  procedure OnAssertError(const Message, Filename: string; LineNumber: Integer; ErrorAddr: Pointer);

implementation

{$R *.dfm}

resourcestring
  SServerStopped = 'Server stopped';
  SServerStartedAt = 'Server started at ';

{ TMainForm }

procedure TfSvrMAIN.btn_SwaggerUIClick(Sender: TObject);
var
  bExists: Boolean;
  tmpUrl : string;
begin

  tmpUrl  := m_sURL + '/swaggerui#/';
  bExists := FileExists( g_chrome64 );

  if( bExists = False )then
  begin
    bExists := FileExists( g_chrome32 );
    if( bExists = False )then
    begin
      ShellExecute( GetDeskTopWindow, 'open', Pchar('"shell:Appsfolder\Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge"'), pchar(tmpUrl), nil, SW_SHOWNORMAL);
    end
    else
    begin
      // 32bit chrome.exe
      ShellExecute( GetDeskTopWindow, nil, Pchar(g_chrome32), Pchar('--new-window  --incognito '+tmpUrl), nil, SW_SHOWNORMAL);
    end;
  end
  else
  begin
    // 64bit chrome.exe
    ShellExecute( GetDeskTopWindow, nil, Pchar(g_chrome64), Pchar('--new-window  --incognito '+tmpUrl), nil, SW_SHOWNORMAL);
  end
end;

procedure TfSvrMAIN.btStartClick(ASender: TObject);
begin
  ServerContainer.SparkleHttpSysDispatcher.Start;
  UpdateGUI;
end;

procedure TfSvrMAIN.btStopClick(ASender: TObject);
begin
  ServerContainer.SparkleHttpSysDispatcher.Stop;
  UpdateGUI;
end;

procedure TfSvrMAIN.FormCreate(ASender: TObject);
var
  sProgramName : string;
  sBasePath    : string;
  sFileName    : string;
  sFolderChk   : string;
  sEventName   : string;
begin
  UpdateGUI;

  {$IFDEF MSWindows}
    TimeBeginPeriod(1); //initialize timer precision
  {$ENDIF}

  sFileName      := StringReplace( ExtractFileName(Application.ExeName), '.exe', '', [rfReplaceAll]);
  sEventName     := Format( 'WriteLogThread(%s)', [sFileName] );
  sBasePath      := ExtractFilePath(Application.ExeName ) + 'log';

  m_hLogEvent    := CreateEvent(nil, False, False, PWideChar(sEventName));
  m_LogWriteTrd  := TLogWriteThread.Create( m_hLogEvent, sFileName, sBasePath, 0 );
  m_nLogWriteTrd := 11;

  Assert( False, '                       ' );
  Assert( False, '***********************' );
  Assert( False, '** RUN ApiServer' );
end;

procedure TfSvrMAIN.FormDestroy(Sender: TObject);
begin
  btStopClick( nil );

  Assert( False, '** DESTROY ApiServer' );
  Assert( False, '***********************' );
  Assert( False, '                       ' );
  Sleep( 100 );
  m_LogWriteTrd.Close();
  if( WaitForSingleObject( m_hLogEvent, 4000 ) = WAIT_OBJECT_0 )then
  begin
    CloseHandle( m_hLogEvent );
  end;
end;

procedure TfSvrMAIN.UpdateGUI;
const
  cHttp          = 'http://+';
  cHttpLocalhost = 'http://localhost';
begin
  btStart.Enabled := not ServerContainer.SparkleHttpSysDispatcher.Active;
  btStop.Enabled  := not btStart.Enabled;

  if ServerContainer.SparkleHttpSysDispatcher.Active then
  begin
    m_sURL := StringReplace( ServerContainer.XDataServer.BaseUrl, cHttp, cHttpLocalhost, [rfIgnoreCase] );
    mmInfo.Lines.Add( SServerStartedAt + m_sURL );

    Assert( False, SServerStartedAt + m_sURL );
  end
  else
  begin
    mmInfo.Lines.Add( SServerStopped );

    Assert( False, SServerStopped );
  end;
end;

procedure OnAssertError(const Message, Filename: string; LineNumber: Integer; ErrorAddr: Pointer);
var
  sMsg : String;
begin
  try
    try
      sMsg := Trim( Format('%s: Line: %d, %s', [ ExtractFileName(FileName) , LineNumber, Message]) );
      if( Assigned( fSvrMAIN ) )then
      begin
        if( fSvrMAIN.m_nLogWriteTrd = 11 )then
        begin
          fSvrMAIN.m_LogWriteTrd.Add( sMsg );
        end;
      end;
    except
      on E: Exception do
      begin
        Assert( false, E.Message );
      end;
    end;
  finally
    ;
  end;
end;

initialization
  AssertErrorProc := OnAssertError;


end.
