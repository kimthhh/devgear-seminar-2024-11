unit uApiList;

interface

uses
    System.SysUtils
  , System.Types
  , System.UITypes
  , System.Classes
  , System.Variants
  , FMX.Types
  , FMX.Controls
  , FMX.Forms
  , FMX.Graphics
  , FMX.Dialogs
  , FMX.Memo.Types
  , FMX.Controls.Presentation
  , FMX.ScrollBox
  , FMX.Memo
  , Data.Bind.Components
  , Data.Bind.ObjectScope
  , REST.Client
  , REST.Types
  , FMX.StdCtrls
  , FMX.WebBrowser
  , FMX.Edit
  , System.IOUtils
  , FMX.TabControl
  , FMX.Media
  , REST.Authenticator.OAuth.WebForm.FMX
  , REST.Authenticator.OAuth
  , FMX.Platform
  , System.Net.HttpClient
  , System.Net.URLClient
  , IdHTTPServer
  , IdCustomHTTPServer
  , IdContext
{$IFDEF ANDROID}
    , FMX.Helpers.Android
    , Androidapi.JNI.GraphicsContentViewText
    , Androidapi.JNI.Net
    , Androidapi.JNI.App
    , Androidapi.Helpers
{$ENDIF}
{$IFDEF MSWINDOWS}
    , Winapi.ShellAPI
    , Winapi.Windows
{$ENDIF}
  , XSuperObject
  , uProtocols
  ;

(*
procedure StartLoopbackServer();
procedure StopLoopbackServer();
*)

function api_GetGoogleLoginURL(): string;
function api_GetGoogleLoginURL_WIN(): string;
function api_GetNaverLoginURL(): string;
function api_GetKakaoLoginURL(): string;

function api_GetKaKaoToken( const Code: string ): ST_KAKAO_TOKEN;
function api_GetKakaoTalkProfile( const AccessToken: string ): ST_KAKAO_PROFILE;
function api_GetKakaoUserMe( const AAccessToken: string ): ST_KAKAO_USER_ME;
function api_DoKakaoLogout( const AAccessToken: string ): string;

function api_GetNaverToken( const Code: string ): ST_NAVER_TOKEN;
function api_GetNaverNidMe( const sAccessToken: string ): ST_NAVER_NID_ME;
function api_DoNaverLogout( const sAccessToken: string ): ST_NAVER_LOGOUT;

function api_GetGoogleToken( const Code: string ): ST_GOOGLE_TOKEN;
function api_GetGoogleUserInfo( const sAccessToken: string ): ST_GOOGLE_USER_INFO;
function api_DoGoogleLogout( const sAccessToken: string ): ST_GOOGLE_LOGOUT;

{$IFDEF ANDROID}
  procedure OpenURL_Android( const sAuthURL: string );
{$ENDIF}


const
  HTML_LOGIN_SUCCESS: string =
    '<!DOCTYPE html>' +
    '<html lang="en">' +
    '<head>' +
    '<meta charset="UTF-8">' +
    '<meta name="viewport" content="width=device-width, initial-scale=1.0">' +
    '<title>Login Success</title>' +
    '<style>' +
    'body {font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif; ' +
    'text-align: center; padding: 40px 20px; ' +
    'background: linear-gradient(135deg, #4CAF50, #81C784); color: #fff;}' +
    'h1 {font-size: 2.2em; margin-bottom: 20px;}' +
    'p {font-size: 1.3em; margin-bottom: 30px;}' +
    'button {background: #fff; color: #4CAF50; border: none; padding: 14px 28px; ' +
    'font-size: 1.2em; border-radius: 8px; cursor: pointer; ' +
    'box-shadow: 0 4px 6px rgba(0,0,0,0.2); transition: all 0.3s ease;}' +
    'button:hover {background: #f1f1f1; transform: scale(1.05);}' +
    '</style>' +
    '</head>' +
    '<body>' +
    '<h1>✅ Login Successful</h1>' +
    '<p>You can now close this window.</p>' +
    '<button onclick="window.close();">Close</button>' +
    '</body>' +
    '</html>';

  HTML_LOGIN_FAILED: string =
    '<!DOCTYPE html>' +
    '<html lang="en">' +
    '<head>' +
    '<meta charset="UTF-8">' +
    '<meta name="viewport" content="width=device-width, initial-scale=1.0">' +
    '<title>Login Failed</title>' +
    '<style>' +
    'body {font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif; ' +
    'text-align: center; padding: 40px 20px; ' +
    'background: linear-gradient(135deg, #E53935, #EF5350); color: #fff;}' +
    'h1 {font-size: 2.2em; margin-bottom: 20px;}' +
    'p {font-size: 1.3em; margin-bottom: 30px;}' +
    'button {background: #fff; color: #E53935; border: none; padding: 14px 28px; ' +
    'font-size: 1.2em; border-radius: 8px; cursor: pointer; ' +
    'box-shadow: 0 4px 6px rgba(0,0,0,0.2); transition: all 0.3s ease;}' +
    'button:hover {background: #f1f1f1; transform: scale(1.05);}' +
    '</style>' +
    '</head>' +
    '<body>' +
    '<h1>❌ Login Failed</h1>' +
    '<p>Authentication could not be completed.</p>' +
    '<button onclick="window.close();">Close</button>' +
    '</body>' +
    '</html>';

  LOGIN_SUCCESS_URL : string = 'https://myscore.kr/login_success.html';
  LOGIN_FAILED_URL  : string = 'https://myscore.kr/login_failed.html';
  DUMMY_HTML        : string = '<html><body></body></html>';

(*
type
  TOnAuthCodeReceived = procedure(const sCode: string) of object;

  THTTPHandler = class
  private
    FOnAuthCodeReceived: TOnAuthCodeReceived;
    procedure OnSvrCommandGet( AContext      : TIdContext;
                               ARequestInfo  : TIdHTTPRequestInfo;
                               AResponseInfo : TIdHTTPResponseInfo  );
  published
    property OnAuthCodeReceived: TOnAuthCodeReceived read FOnAuthCodeReceived write FOnAuthCodeReceived;
  end;
var
  g_HTTPHandler: THTTPHandler;
*)

implementation

(*
procedure THTTPHandler.OnSvrCommandGet( AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  sCode: string;
begin
  Assert( False, '** OnSvrCommandGet()' );

  {http://127.0.0.1:8080/?code=xxxx}
  sCode := ARequestInfo.Params.Values['code'];
  if( sCode <> '' )then
  begin
    Assert( False, '> ' +  sCode );
    AResponseInfo.ContentText := HTML_LOGIN_SUCCESS;
    if Assigned( FOnAuthCodeReceived ) then
    begin
      FOnAuthCodeReceived( sCode );
    end;
  end
  else
  begin
    AResponseInfo.ContentText := HTML_LOGIN_FAILED;
  end;
end;
*)

{$IFDEF ANDROID}
  procedure OpenURL_Android( const sAuthURL: string );
  var
    Intent: JIntent;
  begin
    Assert( False, '** OpenURL_Android()' );

    Intent := TJIntent.JavaClass.init( TJIntent.JavaClass.ACTION_VIEW );
    Intent.setData( StrToJURI( sAuthURL ) );
    TAndroidHelper.Context.startActivity( Intent );
  end;
{$ENDIF}

function api_GetGoogleLoginURL_WIN(): string;
var
  URL   : string;
  Param : string;
begin
  Assert( False, '** api_GetGoogleLoginURL()' );

  URL   := 'https://accounts.google.com';
  Param := '/o/oauth2/v2/auth?client_id={client_id}&redirect_uri={redirect_uri}&response_type=code&scope=openid%20email%20profile';

  {$IFDEF MSWINDOWS}
  Param := Param.Replace( '{client_id}'    , GOOGLE_CLIENT_ID        );
  Param := Param.Replace( '{redirect_uri}' , GOOGLE_REDIRECT_URI_WIN );
  {$ENDIF}

  Result := URL + Param;
  Assert( False, '> ' + Result );
end;

function api_GetGoogleLoginURL(): string;
var
  URL   : string;
  Param : string;
begin
  Assert( False, '** api_GetGoogleLoginURL()' );

  (*
  StartLoopbackServer();
  *)

  URL   := 'https://accounts.google.com';
  Param := '/o/oauth2/v2/auth?client_id={client_id}&redirect_uri={redirect_uri}&response_type=code&scope=openid%20email%20profile';  //&access_type=offline

  Param := Param.Replace( '{client_id}'    , GOOGLE_CLIENT_ID    );
  Param := Param.Replace( '{redirect_uri}' , GOOGLE_REDIRECT_URI );

  Result := URL + Param;
  Assert( False, '> ' + Result );
end;

function api_GetNaverLoginURL(): string;
var
  URL   : string;
  Param : string;
begin
  Assert( False, '** api_GetNaverLoginURL()' );

  URL   := 'https://nid.naver.com';
  Param := '/oauth2.0/authorize?response_type=code&client_id={client_id}&redirect_uri={redirect_uri}';

  Param := Param.Replace( '{client_id}'    , NAVER_CLIENT_ID    );
  Param := Param.Replace( '{redirect_uri}' , NAVER_REDIRECT_URI );

  Result := URL + Param;
  Assert( False, '> ' + Result );
end;

function api_GetKakaoLoginURL(): string;
var
  URL   : string;
  Param : string;
begin
  Assert( False, '** api_GetKakaoLoginURL()' );

  URL   := 'https://kauth.kakao.com';
  Param := '/oauth/authorize?client_id={client_id}&redirect_uri={redirect_uri}&response_type=code';

  Param := Param.Replace( '{client_id}'    , KAKAO_CLIENT_ID    );
  Param := Param.Replace( '{redirect_uri}' , KAKAO_REDIRECT_URI );

  Result := URL + Param;
  Assert( False, '> ' + Result );
end;

(*
procedure StartLoopbackServer();
begin
  Assert( False, '** StartLoopbackServer()' );

  if( Assigned( g_HTTPServer ) = False )then
  begin
    if( Assigned( g_HTTPHandler ) = False )then
    begin
      g_HTTPHandler := THTTPHandler.Create;
    end;
    g_HTTPServer              := TIdHTTPServer.Create(nil);
    g_HTTPServer.DefaultPort  := 8080;
    g_HTTPServer.OnCommandGet := g_HTTPHandler.OnSvrCommandGet;
    g_HTTPServer.Active       := True;
  end;
end;
*)

(*
procedure StopLoopbackServer();
begin
  Assert( False, '** StopLoopbackServer()' );

  if Assigned( g_HTTPServer ) then
  begin
    g_HTTPServer.Active := False;
    g_HTTPServer.Free;
    g_HTTPServer := nil;
  end;

  if Assigned( g_HTTPHandler ) then
  begin
    g_HTTPHandler.Free;
    g_HTTPHandler := nil;
  end;
end;
*)

function api_DoGoogleLogout(const sAccessToken: string): ST_GOOGLE_LOGOUT;
var
  LClient   : TRESTClient;
  LRequest  : TRESTRequest;
  LResponse : TRESTResponse;
  sJson     : string;
begin
  Assert( False, '** api_DoGoogleLogout()' );

  FillChar( Result, SizeOf( ST_GOOGLE_LOGOUT ), #0 );

  LClient   := TRESTClient.Create(nil);
  LRequest  := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    LClient.BaseURL := 'https://oauth2.googleapis.com';

    LRequest.Client   := LClient;
    LRequest.Response := LResponse;
    LRequest.Method   := rmPOST;
    LRequest.Resource := 'revoke';
    LRequest.Accept   := 'application/json';

    LRequest.Params.Clear;
    LRequest.Params.AddItem('token', sAccessToken, pkGETorPOST);

    LRequest.Execute;

    sJson := LResponse.Content;
    Result := TJSON.Parse< ST_GOOGLE_LOGOUT >( sJson );

    Assert( False, '> ' + sJson );
  finally
    LResponse.Free;
    LRequest.Free;
    LClient.Free;
  end;
end;

function api_GetGoogleUserInfo( const sAccessToken: string ): ST_GOOGLE_USER_INFO;
var
  LClient   : TRESTClient;
  LRequest  : TRESTRequest;
  LResponse : TRESTResponse;
  LAuth     : TOAuth2Authenticator;
  sJson     : string;
begin
  Assert( False, '** api_GetGoogleUserInfo()' );

  FillChar( Result, SizeOf( ST_GOOGLE_USER_INFO ), #0 );

  LClient   := TRESTClient.Create(nil);
  LRequest  := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  LAuth     := TOAuth2Authenticator.Create(nil);
  try
    LAuth.AccessToken := sAccessToken;

    LClient.BaseURL       := 'https://www.googleapis.com/';
    LClient.Authenticator := LAuth;

    LRequest.Client   := LClient;
    LRequest.Response := LResponse;
    LRequest.Method   := rmGET;
    LRequest.Resource := 'oauth2/v2/userinfo';

    LRequest.Params.Clear;
    LRequest.Execute;

    sJson  := LResponse.Content;
    Result := TJSON.Parse< ST_GOOGLE_USER_INFO >( sJson );

    Assert( False, '> ' + sJson );
  finally
    LAuth.Free;
    LResponse.Free;
    LRequest.Free;
    LClient.Free;
  end;
end;

function api_GetGoogleToken(const Code: string): ST_GOOGLE_TOKEN;
var
  sJson     : string;
  LClient   : TRESTClient;
  LRequest  : TRESTRequest;
  LResponse : TRESTResponse;
begin
  Assert( False, '** api_GetGoogleToken()' );

  FillChar(Result, SizeOf(ST_GOOGLE_TOKEN), #0);

  LClient   := TRESTClient.Create(nil);
  LRequest  := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);

  try
    LClient.BaseURL   := 'https://oauth2.googleapis.com/';

    LRequest.Client   := LClient;
    LRequest.Response := LResponse;

    LRequest.Resource := 'token';
    LRequest.Method   := rmPOST;
    LRequest.Accept   := 'application/json';

    LRequest.Params.Clear;
    LRequest.Params.AddItem('grant_type',    'authorization_code',    pkGETorPOST);
    {$IFDEF MSWINDOWS}
    LRequest.Params.AddItem('client_id',     GOOGLE_CLIENT_ID,        pkGETorPOST);
    LRequest.Params.AddItem('client_secret', GOOGLE_CLIENT_SECRET,    pkGETorPOST);
    LRequest.Params.AddItem('redirect_uri',  GOOGLE_REDIRECT_URI_WIN, pkGETorPOST);
    {$ENDIF}

    {$IFDEF ANDROID}
    LRequest.Params.AddItem('client_id',     GOOGLE_CLIENT_ID,        pkGETorPOST);
    LRequest.Params.AddItem('client_secret', GOOGLE_CLIENT_SECRET,    pkGETorPOST);
    LRequest.Params.AddItem('redirect_uri',  GOOGLE_REDIRECT_URI,     pkGETorPOST);
    {$ENDIF}
    LRequest.Params.AddItem('code',          Code,                    pkGETorPOST);

    LRequest.Execute;
    sJson := LResponse.Content;

    Result := TJSON.Parse<ST_GOOGLE_TOKEN>(sJson);

    Assert( False, '> ' + sJson );
  finally
    LResponse.Free;
    LRequest.Free;
    LClient.Free;
  end;
end;

function api_DoNaverLogout( const sAccessToken: string ): ST_NAVER_LOGOUT;
var
  LClient   : TRESTClient;
  LRequest  : TRESTRequest;
  LResponse : TRESTResponse;
  sJson     : string;
begin
  Assert( False, '** api_DoNaverLogout()' );

  FillChar( Result, SizeOf(ST_NAVER_LOGOUT), #0 );

  LClient   := TRESTClient.Create(nil);
  LRequest  := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    LClient.BaseURL := 'https://nid.naver.com';

    LRequest.Client   := LClient;
    LRequest.Response := LResponse;

    LRequest.Resource := '/oauth2.0/token';
    LRequest.Method   := rmPOST;
    LRequest.Accept   := 'application/json';

    LRequest.Params.Clear;
    LRequest.Params.AddItem( 'grant_type'       , 'delete'            , pkGETorPOST );
    LRequest.Params.AddItem( 'client_id'        , NAVER_CLIENT_ID     , pkGETorPOST );
    LRequest.Params.AddItem( 'client_secret'    , NAVER_CLIENT_SECRET , pkGETorPOST );
    LRequest.Params.AddItem( 'access_token'     , sAccessToken        , pkGETorPOST );
    LRequest.Params.AddItem( 'service_provider' , 'NAVER'             , pkGETorPOST );

    LRequest.Execute;

    sJson  := LResponse.Content;
    Result := TJSON.Parse< ST_NAVER_LOGOUT >( sJson );

    Assert( False, '> ' + sJson );

  finally
    LResponse.Free;
    LRequest.Free;
    LClient.Free;
  end;
end;

function api_GetNaverNidMe( const sAccessToken: string ): ST_NAVER_NID_ME;
var
  LClient   : TRESTClient;
  LRequest  : TRESTRequest;
  LResponse : TRESTResponse;
  LAuth     : TOAuth2Authenticator;
  sJson     : string;
begin
  Assert( False, '** api_GetNaverNidMe()' );

  FillChar( Result, SizeOf( ST_NAVER_NID_ME ), #0 );

  LClient   := TRESTClient.Create(nil);
  LRequest  := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  LAuth     := TOAuth2Authenticator.Create(nil);
  try
    LAuth.AccessToken := sAccessToken;

    LClient.BaseURL       := 'https://openapi.naver.com/';
    LClient.Authenticator := LAuth;

    LRequest.Client   := LClient;
    LRequest.Response := LResponse;
    LRequest.Method   := rmGET;
    LRequest.Resource := 'v1/nid/me';

    LRequest.Params.Clear;
    LRequest.Execute;

    sJson  := LResponse.Content;
    Result := TJSON.Parse< ST_NAVER_NID_ME >( sJson );

    Assert( False, '> ' + sJson );

  finally
    LAuth.Free;
    LResponse.Free;
    LRequest.Free;
    LClient.Free;
  end;
end;

function api_GetNaverToken( const Code: string ): ST_NAVER_TOKEN;
var
  sJson     : string;
  LClient   : TRESTClient;
  LRequest  : TRESTRequest;
  LResponse : TRESTResponse;
begin
  Assert( False, '** api_GetNaverToken()' );

  FillChar( Result, SizeOf(ST_NAVER_TOKEN), #0 );

  LClient   := TRESTClient.Create(nil);
  LRequest  := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);

  try
    LClient.BaseURL   := 'https://nid.naver.com/';

    LRequest.Client   := LClient;
    LRequest.Response := LResponse;

    LRequest.Resource := 'oauth2.0/token';
    LRequest.Method   := rmPOST;
    LRequest.Accept   := 'application/json';

    LRequest.Params.Clear;

    LRequest.Params.AddItem( 'grant_type'    ,  'authorization_code' , pkGETorPOST );
    LRequest.Params.AddItem( 'client_id'     ,  NAVER_CLIENT_ID      , pkGETorPOST );
    LRequest.Params.AddItem( 'client_secret' ,  NAVER_CLIENT_SECRET  , pkGETorPOST );
    LRequest.Params.AddItem( 'code'          ,  Code                 , pkGETorPOST );

    LRequest.Execute;
    sJson := LResponse.Content;

    Result := TJSON.Parse< ST_NAVER_TOKEN >( sJson );

    Assert( False, '> ' + sJson );
  finally
    LResponse.Free;
    LRequest.Free;
    LClient.Free;
  end;
end;

function api_DoKakaoLogout( const AAccessToken: string ): string;
var
  RESTClient   : TRESTClient;
  RESTRequest  : TRESTRequest;
  RESTResponse : TRESTResponse;
begin
  Assert( False, '** api_DoKakaoLogout()' );

  RESTClient   := TRESTClient.Create(nil);
  RESTRequest  := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    RESTClient.BaseURL := 'https://kapi.kakao.com';

    RESTRequest.Client   := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := 'v1/user/logout';
    RESTRequest.Method   := rmPOST;

    RESTRequest.AddParameter('Authorization', 'Bearer ' + AAccessToken, pkHTTPHEADER, [poDoNotEncode]);

    RESTRequest.Execute;
    Result := RESTResponse.Content;

    Assert( False, '> ' + Result );
  finally
    RESTRequest.Free;
    RESTResponse.Free;
    RESTClient.Free;
  end;
end;

function api_GetKakaoUserMe( const AAccessToken: string ): ST_KAKAO_USER_ME;
var
  sJson        : string;
  RESTClient   : TRESTClient;
  RESTRequest  : TRESTRequest;
  RESTResponse : TRESTResponse;
begin
  Assert( False, '** api_GetKakaoUserMe()' );

  FillChar( Result, SizeOf(ST_KAKAO_USER_ME), #0 );

  RESTClient   := TRESTClient.Create(nil);
  RESTRequest  := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    RESTClient.BaseURL := 'https://kapi.kakao.com';

    RESTRequest.Client   := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := 'v2/user/me';
    RESTRequest.Method   := rmPOST;

    RESTRequest.AddParameter( 'Authorization', 'Bearer ' + AAccessToken, pkHTTPHEADER, [poDoNotEncode]);
    RESTRequest.AddParameter( 'Content-Type' , 'application/x-www-form-urlencoded;charset=utf-8', pkHTTPHEADER, [poDoNotEncode]);

    RESTRequest.Execute;

    sJson  := RESTResponse.Content;
    Result := TJSON.Parse< ST_KAKAO_USER_ME >( sJson );

    Assert( False, '> ' + sJson );
  finally
    RESTRequest.Free;
    RESTResponse.Free;
    RESTClient.Free;
  end;
end;

function api_GetKakaoTalkProfile( const AccessToken: string ): ST_KAKAO_PROFILE;
var
  sJson        : string;
  stProfile    : ST_KAKAO_PROFILE;
  RESTClient   : TRESTClient;
  RESTRequest  : TRESTRequest;
  RESTResponse : TRESTResponse;
begin
  Assert( False, '** api_GetKakaoTalkProfile()' );

  Fillchar( Result, SizeOf(ST_KAKAO_PROFILE), #0 );

  RESTClient   := TRESTClient.Create(nil);
  RESTRequest  := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    RESTClient.BaseURL := 'https://kapi.kakao.com';

    RESTRequest.Client   := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := 'v1/api/talk/profile';
    RESTRequest.Method   := rmGET;

    RESTRequest.AddParameter( 'Authorization', 'Bearer ' + AccessToken, pkHTTPHEADER, [poDoNotEncode] );

    RESTRequest.Execute;

    sJson     := RESTResponse.Content;
    stProfile := TJSON.Parse< ST_KAKAO_PROFILE >( sJson );
    Result    := stProfile;

    Assert( False, '> ' + sJson );
  finally
    RESTRequest.Free;
    RESTResponse.Free;
    RESTClient.Free;
  end;
end;

function api_GetKaKaoToken( const Code: string ): ST_KAKAO_TOKEN;
var
  sJson        : string;
  stToken      : ST_KAKAO_TOKEN;
  RESTClient   : TRESTClient;
  RESTRequest  : TRESTRequest;
  RESTResponse : TRESTResponse;
begin
  Assert( False, '** api_GetKaKaoToken()' );

  Fillchar( Result, SizeOf(ST_KAKAO_TOKEN), #0 );

  RESTClient   := TRESTClient.Create(nil);
  RESTRequest  := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);

  try
    RESTClient.BaseURL   := 'https://kauth.kakao.com';
    RESTRequest.Client   := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Resource := '/oauth/token';
    RESTRequest.Method   := rmPOST;

    RESTRequest.Params.Clear;

    RESTRequest.AddParameter( 'Content-Type' , 'application/x-www-form-urlencoded', pkHTTPHEADER, [poDoNotEncode] );
    RESTRequest.AddParameter( 'grant_type'   , 'authorization_code' , pkGETorPOST );
    RESTRequest.AddParameter( 'client_id'    , KAKAO_CLIENT_ID      , pkGETorPOST );
    RESTRequest.AddParameter( 'redirect_uri' , KAKAO_REDIRECT_URI   , pkGETorPOST );
    RESTRequest.AddParameter( 'code'         , Code                 , pkGETorPOST );

    RESTRequest.Execute;

    sJson  := RESTResponse.Content;
    Result := TJSON.Parse< ST_KAKAO_TOKEN >( sJson );

    Assert( False, '> ' + sJson );
  finally
    RESTRequest.Free;
    RESTResponse.Free;
    RESTClient.Free;
  end;
end;

(*
initialization
  StartLoopbackServer;

finalization
  StopLoopbackServer;
*)

end.
