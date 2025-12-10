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
  , uPrsREDIS

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

{발표자료 Canva 링크정보}
{https://www.canva.com/design/DAG55iNNWV4/-JmGrMfm8q5cnTBsL2fzvg/edit?utm_content=DAG55iNNWV4&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton}
procedure TServerContainer.OnRequest(Sender: TObject; Context: THttpServerContext; Next: THttpServerProc);
var
  bNEXT           : boolean;
  sLOG            : string;
  sRawUri         : string;
  sToken          : string;
  sOrigin         : string;
  sLastSegment    : string;
  sRawOriginalUri : string;
  I               : Integer;
  nIndex          : Integer;
  sRedirectURL    : string;
  DecodedContent  : string;
  sParams         : string;
  sJson           : string;
  sTemp           : string;
  sCode           : string;
  sState          : string;
  QueryParams     : TStrings;
begin
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
        sRawOriginalUri := Context.Request.RawOriginalUri;
        bNEXT           := True;
      end
      else
      begin
        if( sLastSegment = LowerCase( 'ReturnURL' ) )then
        begin
          try
            DecodedContent := TEncoding.UTF8.GetString( TNetEncoding.URL.Decode( Context.Request.Content ) );
            QueryParams               := TStringList.Create;
            QueryParams.Delimiter     := '&';
            QueryParams.DelimitedText := DecodedContent;
            sParams := QueryParams.DelimitedText.Replace(sLineBreak, '&');
            (*
              sJson := ConvertToJSON( sParams );
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
          finally
            QueryParams.Free;
          end;
        end
        else if (sLastSegment = LowerCase('naver')) then
        begin
          {https://XXXX.kr > 보유중인 URL로 변경}
          {https://XXXX.kr/fix/OAuth/Naver/?code=B9b2MRxx2Yvp4JApHO&state=null}
          sParams     := Context.Request.Uri.Query;
          QueryParams := TStringList.Create;
          try
            sParams := TNetEncoding.URL.Decode( sParams );
            if sParams.StartsWith('?') then
            begin
              sParams := sParams.Substring(1);
            end;
            QueryParams.Delimiter     := '&';
            QueryParams.DelimitedText := sParams;
            for I := 0 to QueryParams.Count - 1 do
            begin
              if( QueryParams.Names[I] = 'code'  )then sCode  := QueryParams.ValueFromIndex[I];
              if( QueryParams.Names[I] = 'state' )then sState := QueryParams.ValueFromIndex[I];
            end;
            if( sCode <> '' )then
            begin
              sRedirectURL := 'https://XXXX.kr/fix/OAuth/Naver/?code=' + sCode + '&state=' + sState;
            end
            else
            begin
              sRedirectURL := 'https://XXXX.kr/fix/OAuth/Naver/';
            end;
            Context.Response.StatusCode  := 302;
            Context.Response.Headers.SetValue('Location', sRedirectURL);
          finally
            QueryParams.Free;
          end;
        end
        else if (sLastSegment = LowerCase('kakao')) then
        begin
          {https://XXXX.kr > 보유중인 URL로 변경}
          {https://XXXX.kr/fix/OAuth/Kakao/?code=B9b2MRxx2Yvp4JApHO}
          sParams     := Context.Request.Uri.Query;
          QueryParams := TStringList.Create;
          try
            sParams := TNetEncoding.URL.Decode( sParams );
            if sParams.StartsWith('?') then
            begin
              sParams := sParams.Substring(1);
            end;
            QueryParams.Delimiter     := '&';
            QueryParams.DelimitedText := sParams;
            for I := 0 to QueryParams.Count - 1 do
            begin
              if( QueryParams.Names[I] = 'code'  )then
              begin
                sCode := QueryParams.ValueFromIndex[I];
                Break;
              end;
            end;
            if( sCode <> '' )then
            begin
              sRedirectURL := 'https://XXXX.kr/fix/OAuth/Kakao/?code=' + sCode;
            end
            else
            begin
              sRedirectURL := 'https://XXXX.kr/fix/OAuth/Kakao/';
            end;
            Context.Response.StatusCode  := 302;
            Context.Response.Headers.SetValue('Location', sRedirectURL);
            Context.Response.ContentType := 'text/plain';
            Context.Response.Close(TEncoding.UTF8.GetBytes('Redirecting...'));
          finally
            QueryParams.Free;
          end;
        end
        else if (sLastSegment = LowerCase('goodirect')) then {google for windows}
        begin
          {https://XXXX.kr > 보유중인 URL로 변경}
          {https://XXXX.kr/fix/OAuth/GooDirect?code=XXXXX&scope=email%20profile}
          sParams     := Context.Request.Uri.Query;
          QueryParams := TStringList.Create;
          try
            sParams := TNetEncoding.URL.Decode( sParams );
            if sParams.StartsWith('?') then
            begin
              sParams := sParams.Substring(1);
            end;
            QueryParams.Delimiter     := '&';
            QueryParams.DelimitedText := sParams;
            for I := 0 to QueryParams.Count - 1 do
            begin
              if( QueryParams.Names[I] = 'code'  )then sCode  := QueryParams.ValueFromIndex[I];
              if( QueryParams.Names[I] = 'scope' )then sState := QueryParams.ValueFromIndex[I];
            end;
            if( sCode <> '' )then
            begin
              sRedirectURL := 'https://XXXX.kr/fix/OAuth/GooDirect?code=' + sCode + '&scope=' + sState;
            end
            else
            begin
              sRedirectURL := 'https://XXXX.kr/fix/OAuth/GooDirect';
            end;
            Context.Response.StatusCode  := 302;
            Context.Response.Headers.SetValue('Location', sRedirectURL);
            Context.Response.ContentType := 'text/plain';
            Context.Response.Close(TEncoding.UTF8.GetBytes('Redirecting...'));
          finally
            QueryParams.Free;
          end;
        end
        else if (sLastSegment = LowerCase('google')) then {for android as intent}
        begin
          {https://XXXX.kr > 보유중인 URL로 변경}
          {https://XXXX.kr/fix/OAuth/Google?code=XXXXX&scope=email%20profile}
          sParams     := Context.Request.Uri.Query;
          QueryParams := TStringList.Create;
          try
            sParams := TNetEncoding.URL.Decode( sParams );
            if sParams.StartsWith('?') then
            begin
              sParams := sParams.Substring(1);
            end;
            QueryParams.Delimiter     := '&';
            QueryParams.DelimitedText := sParams;
            for I := 0 to QueryParams.Count - 1 do
            begin
              if( QueryParams.Names[I] = 'code'  )then sCode  := QueryParams.ValueFromIndex[I];
              if( QueryParams.Names[I] = 'scope' )then sState := QueryParams.ValueFromIndex[I];
            end;
            {[YOUR_DEFINE] 프로젝트에 따라 별도정의}
            sRedirectURL := 'intent://oauth2redirect?code=' + sCode +
                            '#Intent;scheme=[YOUR_DEFINE];package=com.embarcadero.[YOUR_DEFINE];end';
            Context.Response.ContentType := 'text/html; charset=utf-8';
            Context.Response.StatusCode  := 200;
            Context.Response.Close(
              TEncoding.UTF8.GetBytes( '<html><body>' +
                                       '<script>window.location.replace("' + sRedirectURL + '");</script>' +
                                       'Redirecting to app...' +
                                       '</body></html>' ) );
          finally
            QueryParams.Free;
          end;
        end
        else if( sLastSegment = LowerCase( 'login' ) )then
        begin
          bNEXT := True;
        end
        else
        begin
          bNEXT := rds_VerifyTokenAndExtend( sToken );
        end;
      end;
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
