unit uServerContainer;

interface

uses
    System.SysUtils
  , System.Classes
  , System.NetEncoding

  , Sparkle.HttpServer.Module
  , Sparkle.HttpServer.Context
  , Sparkle.Comp.Server
  , Sparkle.Comp.HttpSysDispatcher

  , Aurelius.Drivers.Interfaces
  , Aurelius.Comp.Connection

  , XData.Comp.ConnectionPool
  , XData.Server.Module
  , XData.Comp.Server

  , Sparkle.Comp.GenericMiddleware
  , Sparkle.Comp.CorsMiddleware

  , CommonService

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
  sTemp           : string;
  QueryParams     : TStrings;
begin
  Assert( false, '** TServerContainer.OnRequest(..)' );
  try
    try
      bNEXT := false;

      if( Length( Context.Request.Uri.Segments ) > 0 )then
      begin
        nIndex  := Length( Context.Request.Uri.Segments ) - 1;
        sOrigin := Context.Request.Uri.Segments[ nIndex ];
      end;

      sLastSegment := LowerCase( sOrigin );
      sToken       := Context.Request.Headers.Get( 'authorization' );

      if( ( sLastSegment = LowerCase( 'flix'         ) ) or
          ( sLastSegment = LowerCase( 'swaggerui'    ) ) or
          ( sLastSegment = LowerCase( 'swagger.json' ) ) or
          ( sLastSegment = LowerCase( '$model'       ) )   )then
      begin
        Assert( false, sLastSegment );
        Assert( false, sOrigin      );

        sRawOriginalUri := Context.Request.RawOriginalUri;

        (*
          if( Pos( 'http://192.168.0.xxx:xxxx/', sRawOriginalUri ) > 0 )then
          begin
            bNEXT := True;
          end;
        *)

        bNEXT := True;
      end
      else
      begin
        sLOG := Format( '> %s: %s', [sLastSegment, sToken] );
        Assert( false, sLOG );

        if( sLastSegment = LowerCase( 'ReturnURL' ) )then
        begin
          try
            DecodedContent := TEncoding.UTF8.GetString( TNetEncoding.URL.Decode( Context.Request.Content ) );
            Assert( False, DecodedContent );

                       QueryParams := TStringList.Create;
                       QueryParams.Delimiter     := '&';
                       QueryParams.DelimitedText := DecodedContent;
            sParams := QueryParams.DelimitedText.Replace(sLineBreak, '&');
            Assert( False, sParams );

            (*
              sJson := ConvertToJSON( sParams );
              Assert( False, sJson );

              insert.sID   := TGuid.NewGuid.ToString;
              insert.sType := 'return';
              insert.sData := sJson;
              insert.dtReg := Now();

              if( Sq_insert_tblPgAuth( insert ) = '' )then
              begin
                sParams := Format( '?id=%s&type=%s#CUST', [insert.sID, insert.sType] );
              end
              else
              begin
                sParams := '#CUST';
              end;

              sRedirectURL := 'https://xxxx.com/' + sParams;

              Context.Response.StatusCode  := 302;
              Context.Response.Headers.SetValue('Location', sRedirectURL);
              Context.Response.ContentType := 'text/plain';
              Context.Response.Close(TEncoding.UTF8.GetBytes('Redirecting...'));
            *)

            Exit;
          finally
            QueryParams.Free;
          end;
        end
        else if( sLastSegment = LowerCase( 'login' ) )then
        begin
          bNEXT := True;
        end
        else if( sLastSegment = LowerCase( 'logout' ) )then
        begin
          bNEXT := True;
        end
        else if( sLastSegment = LowerCase( 'VerifyTokenAndExtend' ) )then
        begin
          bNEXT := True;
        end
        ;

        bNEXT := True;
      end;

      if( bNEXT )then
      begin
        Next( Context );
      end
      else
      begin
        sLOG := Format( '[Unauthorized] (API) %s', [sOrigin] );
        Assert( false, sLOG );

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
