unit uServerContainer;

interface

uses
    System.SysUtils
  , System.Classes
  , Sparkle.HttpServer.Module
  , Sparkle.HttpServer.Context
  , Sparkle.Comp.Server
  , Sparkle.Comp.HttpSysDispatcher
  , Aurelius.Drivers.Interfaces
  , Aurelius.Comp.Connection
  , XData.Comp.ConnectionPool
  , XData.Server.Module
  , XData.Comp.Server

  , CommonService, Sparkle.Comp.GenericMiddleware, Sparkle.Comp.CorsMiddleware

  ;

type
  TServerContainer = class(TDataModule)
    SparkleHttpSysDispatcher: TSparkleHttpSysDispatcher;
    XDataServer: TXDataServer;
    XDataConnectionPool: TXDataConnectionPool;
    AureliusConnection: TAureliusConnection;
    XDataServerCORS: TSparkleCorsMiddleware;
    XDataServerGeneric: TSparkleGenericMiddleware;
    procedure DataModuleCreate(Sender: TObject);

  private
    procedure OnRequest(Sender: TObject; Context: THttpServerContext; Next: THttpServerProc);
  end;

var
  ServerContainer: TServerContainer;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TServerContainer.DataModuleCreate(Sender: TObject);
begin
  try
    try
      XDataServerGeneric.OnRequest := OnRequest ;
      XDataServerCORS.Origin       := '*';
    Except
      on E: Exception do
      begin
        Assert( false, E.Message );
      end;
    end;
  finally
    ;
  end;
end;

procedure TServerContainer.OnRequest(Sender: TObject; Context: THttpServerContext; Next: THttpServerProc);
var
  bNEXT           : boolean;
  sLOG            : string;
  sRawUri         : string;
  sToken          : string;
  sOrigin         : string;
  sLastSegment    : string;
  sRawOriginalUri : string;
  nIndex          : Integer;
  sRedirectURL    : string;
  DecodedContent  : string;
  sParams         : string;
  sJson           : string;
  QueryParams     : TStrings;
begin
  Assert( false, '** TServerContainer.OnRequest(..)' );
  try
    try
      bNEXT := True;

      if( bNEXT )then
      begin
        Next( Context );
      end
      else
      begin
        Context.Response.StatusCode  := 401;
        Context.Response.ContentType := 'text/plain';
        Context.Response.Close( TEncoding.UTF8.GetBytes('Unauthorized') );
      end;

    Except
      on E: Exception do
      begin
        sLOG := Format( '[Unauthorized] (API) %s, Error: ', [sOrigin, E.Message] );
        Assert( false, sLOG );

        Context.Response.StatusCode  := 401;
        Context.Response.ContentType := 'text/plain';
        Context.Response.Close( TEncoding.UTF8.GetBytes('Unauthorized') );
      end;
    end;
  finally
    ;
  end;
end;

end.
