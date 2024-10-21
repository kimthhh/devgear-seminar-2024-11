unit MainForm;

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

  , Winapi.MMSystem
  , uLogWriteThread

  ;

type
  TfmServer = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  public
    m_hLogEvent    : THandle;
    m_nLogWriteTrd : Integer;
    m_LogWriteTrd  : TLogWriteThread;
  end;

var
  fmServer: TfmServer;

procedure OnAssertError(const Message, Filename: string; LineNumber: Integer; ErrorAddr: Pointer);

implementation

uses
  Server;

{$R *.dfm}

procedure TfmServer.FormCreate(Sender: TObject);
var
  sProgramName : string;
  sBasePath    : string;
  sFileName    : string;
  sFolderChk   : string;
  sEventName   : string;
begin
  {$IFDEF MSWindows}
    TimeBeginPeriod(1); //initialize timer precision
  {$ENDIF}

  StartServer;
  Label1.Caption := 'Server running!';

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

procedure TfmServer.FormDestroy(Sender: TObject);
begin
  StopServer;
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

procedure OnAssertError(const Message, Filename: string; LineNumber: Integer; ErrorAddr: Pointer);
var
  sMsg : String;
begin
  try
    try
      sMsg := Trim( Format('%s: Line: %d, %s', [ ExtractFileName(FileName) , LineNumber, Message]) );
      if( Assigned( fmServer ) )then
      begin
        if( fmServer.m_nLogWriteTrd = 11 )then
        begin
          fmServer.m_LogWriteTrd.Add( sMsg );
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
