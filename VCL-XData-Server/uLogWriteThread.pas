unit uLogWriteThread;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.ShellAPI,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.SyncObjs,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  IniFiles
  ;

type

  PLogWriteThread = ^TLogWriteThread;
  TLogWriteThread = class(TThread)
  protected
  private
    m_nPort           : Integer;
    m_dLogCount       : Double;
    m_dLogGotCount    : Double;
    m_sAppName        ,
    m_sCurrRunDir     : string;
    m_sLogBefore      : string;
    m_bRUN            : Boolean;
    m_hTermidateEvent : THandle;
    m_hCriSection     : TcriticalSection;
    m_dicLog          : TDictionary<string,string>;
  public
    constructor Create( hTermidateEvent: THandle; sAppName, sBasePath: string; nPort: Integer );
    destructor  Destroy;
    procedure   Execute; override;
    procedure   Close();
    procedure   WirteLog( sMsg: string );
    procedure   Add( sLog: string );
  end;

implementation

{ TLogWriteThread }
constructor TLogWriteThread.Create( hTermidateEvent: THandle; sAppName, sBasePath: string; nPort: Integer );
begin
  inherited Create(true);
  Assert( False, '** TLogWriteThread.Create()' );
  try
    m_nPort           := nPort;
    m_hCriSection     := TcriticalSection.create;
    m_dicLog          := TDictionary<string,string>.Create( 1000 );
    m_sAppName        := sAppName;
    m_sCurrRunDir     := sBasePath;
    m_dLogCount       := 1;
    m_dLogGotCount    := 1;
    m_bRUN            := True;
    m_hTermidateEvent := hTermidateEvent;

    Resume;

  finally
  end;
end;

destructor TLogWriteThread.Destroy;
begin
  try
    inherited;
    Assert( False, '** TLogWriteThread.Destroy()' );
  finally
  end;
end;

procedure TLogWriteThread.WirteLog( sMsg: string );
var
  nFile      : Integer;
  sTemp      : string;
  sFile      : string;
  F          : Textfile;
  sFilename  : string;
begin
 try
   try
     if not DirectoryExists( m_sCurrRunDir ) then
     begin
       if not CreateDir( m_sCurrRunDir ) then
       begin
         Assert( False, 'Cannot create' + m_sCurrRunDir);
       end;
     end;

     sTemp := IntToStr( m_nPort );
     sFile := m_sCurrRunDir + '\' + m_sAppName + '_' + sTemp + '_' + FormatDateTime('yyyymmdd', now) + '.log';

     AssignFile( F, sFile );

     if FileExists( sFile ) then
     begin
       Append(F);
     end
     else
     begin
       Rewrite(F);
     end;
     Writeln( F, '[' + FormatDateTime('YYYYMMDD.hh:nn:ss.zzz', now) + '] ' + sMsg );
   except
     on E: Exception do
     begin
       Assert( False, E.Message );
     end;
   end;
  finally
    CloseFile(F);
  end;
end;

procedure TLogWriteThread.Execute;
var
  sLog ,
  sKey : string;
begin
  try
    Assert( False, '** TLogWriteThread.Execute()' );
    while m_bRUN do
    begin
      sLog := '';
      try
        m_hCriSection.acquire;
        //for sKey in m_dicLog.Keys  do
        if m_dicLog.ContainsKey( FloatToStr( m_dLogGotCount ) ) then
        begin
          sKey := FloatToStr( m_dLogGotCount );
          sLog := m_dicLog.Items[ sKey ];
          m_dicLog.Remove( sKey );
          //Break;
          m_dLogGotCount := m_dLogGotCount + 1;
        end;
      finally
        m_hCriSection.release;
      end;
      if( sLog <> '' )then
      begin
        WirteLog( sLog );
      end;
      WaitForsingleObject( Self.Handle, 5 );
    end;

  finally
    m_hCriSection.free;
    SetEvent( m_hTermidateEvent );
  end;
end;

procedure TLogWriteThread.Close();
begin
  Assert( False, '** TLogWriteThread.Close()' );
  try
    m_hCriSection.acquire;
    m_bRUN := False;
  finally
    m_hCriSection.release;
  end;
end;

procedure TLogWriteThread.Add( sLog: string );
var
  sKey: string;
begin
  try
    //--Assert( False, '** TLogWriteThread.Add()' );
    m_hCriSection.acquire;
    if( m_sLogBefore <> sLog )then
    begin
      m_sLogBefore := sLog;
      sKey         := FloatToStr( m_dLogCount );
      m_dicLog.Add( sKey, sLog );
    end;
  finally
    m_dLogCount := m_dLogCount + 1;
    m_hCriSection.release;
  end;
end;

end.
