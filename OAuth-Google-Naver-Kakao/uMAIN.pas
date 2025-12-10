unit uMAIN;

interface

uses
    System.SysUtils
  , System.Types
  , System.UITypes
  , System.Classes
  , System.Variants
  , System.IOUtils
  , System.Net.HttpClient
  , System.Net.URLClient

  , Data.Bind.Components
  , Data.Bind.ObjectScope

  , REST.Client
  , REST.Types
  , REST.Authenticator.OAuth.WebForm.FMX
  , REST.Authenticator.OAuth

  , FMX.Types
  , FMX.Controls
  , FMX.Forms
  , FMX.Graphics
  , FMX.Dialogs
  , FMX.Memo
  , FMX.Memo.Types
  , FMX.Controls.Presentation
  , FMX.ScrollBox
  , FMX.StdCtrls
  , FMX.WebBrowser
  , FMX.Edit
  , FMX.TabControl
  , FMX.Media
  , FMX.Platform

{$IFDEF ANDROID}
  , FMX.Platform.Android
  , FMX.VirtualKeyboard
  , Androidapi.KeyCodes
  , Androidapi.Helpers
  , System.Messaging
  , Androidapi.JNIBridge
  , Androidapi.JNI.Os
  , Androidapi.JNI.App
  , Androidapi.JNI.JavaTypes
  , Androidapi.JNI.GraphicsContentViewText
  , Androidapi.JNI.Net
{$ENDIF}

  , IdHTTPServer
  , IdCustomHTTPServer
  , IdContext

  , XSuperObject
  , uProtocols
  , uApiList

{$IFDEF MSWINDOWS}
  , Winapi.ShellAPI
  , Winapi.Windows

  , FMX.TMSFNCTypes
  , FMX.TMSFNCUtils
  , FMX.TMSFNCGraphics
  , FMX.TMSFNCGraphicsTypes
  , FMX.TMSFNCCustomControl
  , FMX.TMSFNCWebBrowser
{$ENDIF}
  ;

type
  TfMAIN = class(TForm)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    TabControl: TTabControl;
    tabMain: TTabItem;
    tabBrowser: TTabItem;
    Memo: TMemo;
    tmrLogin: TTimer;
    Panel: TPanel;
    lbl_code: TLabel;
    edtCode: TEdit;
    lbl_token: TLabel;
    edtToken: TEdit;
    btnLogout: TButton;
    lbl_title: TLabel;
    img_profile: TImageControl;
    lbl_name: TLabel;
    lbl_email: TLabel;
    lbl_nick: TLabel;
    OAuth2Authenticator: TOAuth2Authenticator;
    pnl_top: TPanel;
    btn_connect_google: TButton;
    btn_connect_kakao: TButton;
    btn_connect_naver: TButton;
    procedure btn_connect_googleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure tmrLoginTimer(Sender: TObject);
    procedure MemoDblClick(Sender: TObject);
    procedure btn_connect_naverClick(Sender: TObject);
    procedure btn_connect_kakaoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
{$IFDEF ANDROID}
    procedure WebBrowserDidFinishLoad(ASender: TObject);
{$ENDIF}
{$IFDEF MSWINDOWS}
    procedure WebBrowserNavigateComplete(Sender: TObject; var Params: TTMSFNCCustomWebBrowserNavigateCompleteParams);
{$ENDIF}
  private
    { Private declarations }
{$IFDEF MSWINDOWS}
    WebBrowser: TTMSFNCWebBrowser;
{$ENDIF}
{$IFDEF ANDROID}
    WebBrowser: TWebBrowser;
{$ENDIF}
    procedure InitCtrls();
    procedure PrsProfile( const AccessToken, sImgUrl: string );
    procedure PrsProfileForKakao( const AccessToken: string );
{$IFDEF ANDROID}
    function HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    procedure HandleActivityMessage(const Sender: TObject; const M: TMessage);
    function HandleIntentAction(const Data: JIntent): Boolean;
{$ENDIF}
  public
    { Public declarations }
{$IFDEF ANDROID}
{$ENDIF}
  end;

var
  fMAIN: TfMAIN;

implementation

{$R *.fmx}

{$IFDEF MSWINDOWS}
procedure TfMAIN.WebBrowserNavigateComplete(Sender: TObject; var Params: TTMSFNCCustomWebBrowserNavigateCompleteParams);
var
  sTitle     : string;
  sJson      : string;
  b_prs      : boolean;
  LUrl       : string;
  code       : string;
  tParams    : TStringList;
  stTkGoogle : ST_GOOGLE_TOKEN;
  stUGoogle  : ST_GOOGLE_USER_INFO;
  stTkNaver  : ST_NAVER_TOKEN;
  stTkKakao  : ST_KAKAO_TOKEN;
  stUKakao   : ST_KAKAO_USER_ME;
  stUNaver   : ST_NAVER_NID_ME;
  stProfile  : ST_KAKAO_PROFILE;
begin
    Assert( False, '** WebBrowserNavigateComplete()' );
    if( Pos( '?code=', WebBrowser.URL) > 0 )then
    begin
      if( WebBrowser.Tag = 11 )then
      begin
        Assert( False, '----------------------------------------------' );
        Assert( False, '> ' + WebBrowser.URL );
        try
          tParams := TStringList.Create;
          if( lbl_title.Text = 'kakao' )then
          begin
            LUrl := WebBrowser.URL;
            if( (KAKAO_REDIRECT_URI + '/') = LUrl )then
            begin
              WebBrowser.Tag := 22;
              WebBrowser.URL := LOGIN_FAILED_URL;
            end
            else if( Pos('code=', LUrl) > 0 )then
            begin
              WebBrowser.Tag := 22;
              code := Copy(lurl, Pos('code=', lurl) + Length('code='), Length(lurl));
              Assert( False, '----------------------------------------------' );
              Assert( False, code );
              if( Pos('&', code) > 0 )then
              begin
                code := Copy(code, 1, Pos('&', code) - 1);
              end;
              edtCode.Text     := code;
              stTkKakao        := api_GetKaKaoToken( code );
              edtToken.Text    := stTkKakao.access_token;
              if( edtToken.Text <> '' )then
              begin
                stUKakao       := api_GetKakaoUserMe( edtToken.Text );
                stProfile      := api_GetKakaoTalkProfile( edtToken.Text );
              //sJson          := TJSON.Stringify< ST_KAKAO_USER_ME >( stUKakao );

                lbl_name.Text  := '';
                lbl_nick.Text  := stUKakao.kakao_account.profile.nickname;
                lbl_email.Text := stUKakao.kakao_account.email;

                PrsProfileForKakao( edtToken.Text );
                WebBrowser.URL := LOGIN_SUCCESS_URL;
              end
              else
              begin
                WebBrowser.URL := LOGIN_FAILED_URL;
              end;
            end;
          end
          else if( lbl_title.Text = 'naver' )then
          begin
            try
              LUrl := WebBrowser.URL;
              if( ( NAVER_REDIRECT_URI + '/' ) = LUrl )then
              begin
                WebBrowser.Tag := 22;
                WebBrowser.URL := LOGIN_FAILED_URL;
              end
              else if( Pos('code=', LUrl) > 0 )then
              begin
                WebBrowser.Tag := 22;
                code := Copy(lurl, Pos('code=', lurl) + Length('code='), Length(lurl) );
                Assert( False, '----------------------------------------------' );
                Assert( False, code );
                if( Pos('&', code) > 0 )then
                begin
                  code := Copy(code, 1, Pos('&', code) - 1);
                end;
                edtCode.Text     := code;
                stTkNaver        := api_GetNaverToken( code );
                edtToken.Text    := stTkNaver.access_token;
                if( edtToken.Text <> '' )then
                begin
                  stUNaver       := api_GetNaverNidMe( edtToken.Text );
                //sJson          := TJSON.Stringify< ST_NAVER_NID_ME >( stUNaver );

                  lbl_name.Text  := stUNaver.response.name;
                  lbl_nick.Text  := stUNaver.response.nickname;
                  lbl_email.Text := stUNaver.response.email;

                  PrsProfile( edtToken.Text, stUNaver.response.profile_image );
                  WebBrowser.URL := LOGIN_SUCCESS_URL;
                end
                else
                begin
                  WebBrowser.URL := LOGIN_FAILED_URL;
                end;
              end;
            finally
            end;
          end
          else if( lbl_title.Text = 'google' )then
          begin
            b_prs  := false;
            try
              LUrl := WebBrowser.URL;
              if( ( GOOGLE_REDIRECT_URI_WIN + '/' ) = LUrl )then
              begin
                WebBrowser.Tag := 22;
                b_prs          := True;
                WebBrowser.URL := LOGIN_FAILED_URL;
              end
              else if( Pos('/fix/OAuth/', LUrl) > 0 )then
              begin
                if( Pos('code=', LUrl) > 0 )then
                begin
                  WebBrowser.Tag := 22;
                  b_prs          := True;
                  code := Copy(lurl, Pos('code=', lurl) + Length('code='), Length(lurl) );
                  Assert( False, '----------------------------------------------' );
                  Assert( False, code );
                  if( Pos('&', code) > 0 )then
                  begin
                    code := Copy(code, 1, Pos('&', code) - 1);
                  end;
                  edtCode.Text  := code;
                  stTkGoogle    := api_GetGoogleToken( code );
                  edtToken.Text := stTkGoogle.access_token;
                  if( edtToken.Text <> '' )then
                  begin
                    stUGoogle      := api_GetGoogleUserInfo( edtToken.Text );
                  //sJson          := TJSON.Stringify< ST_GOOGLE_USER_INFO >( stUGoogle );
                    lbl_name.Text  := stUGoogle.name;
                    lbl_nick.Text  := '';
                    lbl_email.Text := stUGoogle.email;
                    PrsProfile( edtToken.Text, stUGoogle.picture );
                    WebBrowser.URL := LOGIN_SUCCESS_URL;
                  end
                  else
                  begin
                    WebBrowser.URL := LOGIN_FAILED_URL;
                  end;
                end;
              end
              else
              begin
                WebBrowser.LoadHTML( DUMMY_HTML );
              end;
              if( b_prs = True )then
              begin
                WebBrowser.Tag := 22;
              end;
            finally
            end;
          end;
        finally
          tParams.Free;
        end;
      end;
    end;
end;
{$ENDIF}

procedure TfMAIN.InitCtrls();
begin
  Assert( False, '** InitCtrls()' );

  img_profile.Bitmap.Clear( TAlphaColors.White );
  lbl_name.Text     := '';
  lbl_nick.Text     := '';
  lbl_email.Text    := '';
end;

procedure TfMAIN.MemoDblClick(Sender: TObject);
begin
  Memo.Lines.Clear;
end;

procedure TfMAIN.btnLogoutClick(Sender: TObject);
var
  sTitle     : string;
  sJson      : string;
  stLtGoogle : ST_GOOGLE_LOGOUT;
  stLtNaver  : ST_NAVER_LOGOUT;
begin
  Assert( False, '** btnLogoutClick()' );

  if( edtToken.Text <> '' )then
  begin
    InitCtrls();
    try
      sTitle := lbl_title.Text;

      if( sTitle = 'google' )then
      begin
        stLtGoogle := api_DoGoogleLogout( edtToken.Text );
        sJson      := TJSON.Stringify< ST_GOOGLE_LOGOUT >( stLtGoogle );
      end
      else if( sTitle = 'naver' )then
      begin
        stLtNaver := api_DoNaverLogout( edtToken.Text );
        sJson     := TJSON.Stringify< ST_NAVER_LOGOUT >( stLtNaver );
      end
      else if( sTitle = 'kakao' )then
      begin
        sJson := api_DoKakaoLogout( edtToken.Text );
      end;

      Assert( False, '----------------------------------------------' );
      Assert( False, sJson );

      edtCode.Text   := '';
      edtToken.Text  := '';
      lbl_title.Text := '--';
    finally
      ;
    end;
  end;
end;

procedure TfMAIN.FormCreate(Sender: TObject);
{$IFDEF ANDROID}
var
  AppEventService: IFMXApplicationEventService;
{$ENDIF}
begin
{$IFDEF ANDROID}
  if TPlatformServices.Current.SupportsPlatformService( IFMXApplicationEventService, AppEventService ) then
  begin
    AppEventService.SetApplicationEventHandler( HandleAppEvent );
  end;
  MainActivity.registerIntentAction( TJIntent.JavaClass.ACTION_VIEW );
  TMessageManager.DefaultManager.SubscribeToMessage( TMessageReceivedNotification, HandleActivityMessage );
{$ENDIF}

{$IFDEF ANDROID}
  WebBrowser                    := TWebBrowser.Create(Self);
  WebBrowser.Parent             := tabBrowser;
  WebBrowser.Align              := TAlignLayout.Client;
  WebBrowser.OnDidFinishLoad    := WebBrowserDidFinishLoad;
{$ENDIF}

{$IFDEF MSWINDOWS}
  WebBrowser                    := TTMSFNCWebBrowser.Create(Self);
  WebBrowser.Parent             := tabBrowser;
  WebBrowser.Align              := TAlignLayout.Client;
  WebBrowser.OnNavigateComplete := WebBrowserNavigateComplete;
{$ENDIF}
end;

{$IFDEF ANDROID}
procedure TfMAIN.HandleActivityMessage(const Sender: TObject; const M: TMessage);
begin
  Assert( False, '** HandleActivityMessage()' );
  if M is TMessageReceivedNotification then
  begin
    HandleIntentAction(TMessageReceivedNotification(M).Value);
  end;
end;
{$ENDIF}

{$IFDEF ANDROID}
function TfMAIN.HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
var
  StartupIntent: JIntent;
begin
  Assert( False, '** HandleAppEvent()' );
  Result := False;
  if AAppEvent = TApplicationEvent.BecameActive then
  begin
    StartupIntent := MainActivity.getIntent;
    if StartupIntent <> nil then
    begin
      HandleIntentAction( StartupIntent );
    end;
  end;
end;
{$ENDIF}

{$IFDEF ANDROID}
function TfMAIN.HandleIntentAction(const Data: JIntent): Boolean;
var
  Extras: JBundle;
  Uri: Jnet_Uri;
  sTemp, Code: string;
begin
  Assert(False, '** HandleIntentAction()');
  Result := False;

  if Data <> nil then
  begin
    // 🔹 case 1: 일반 EXTRA_TEXT 기반 (SEND 액션 등)
    Extras := Data.getExtras;
    if (Extras <> nil) and (Extras.containsKey(TJIntent.JavaClass.EXTRA_TEXT)) then
    begin
      sTemp := JStringToString(Extras.getString(TJIntent.JavaClass.EXTRA_TEXT));
      Assert(False,'EXTRA_TEXT=' + sTemp);
    end;

    // 🔹 case 2: OAuth Redirect 기반 (ACTION_VIEW + URI)
    Uri := Data.getData;
    if Uri <> nil then
    begin
      sTemp := JStringToString(Uri.toString);
      Assert(False,'Intent URI=' + sTemp);

      // code= 파라미터 추출
      if Pos('code=', sTemp) > 0 then
      begin
        Code := Copy(sTemp, Pos('code=', sTemp) + 5, MaxInt);
        if Pos('&', Code) > 0 then
        begin
          Code := Copy(Code, 1, Pos('&', Code) - 1);
        end;
        Assert(False,'✅ OAuth Code = ' + Code);
        edtCode.Text := Code;
        Invalidate;
      end;
    end;
  end;
end;
{$ENDIF}

procedure TfMAIN.FormShow(Sender: TObject);
begin
  Assert( False, '** TfMAIN.FormShow' );

  //if( Assigned( g_HTTPHandler ) = False )then
  //begin
  //  g_HTTPHandler := THTTPHandler.Create;
  //  g_HTTPHandler.OnAuthCodeReceived := AuthCodeHandler;
  //end;

  InitCtrls();
  TabControl.ActiveTab := tabMain;
end;

procedure TfMAIN.PrsProfileForKakao( const AccessToken: string );
var
  stProfile : ST_KAKAO_PROFILE;
  Stream    : TMemoryStream;
  sJson     : string;
begin
  Assert( False, '** PrsProfileForKakao()' );

  if( AccessToken <> '' )then
  begin
    try
      stProfile := api_GetKakaoTalkProfile( AccessToken );
      sJson     := TJSON.Stringify< ST_KAKAO_PROFILE >( stProfile );

      Assert( False, '----------------------------------------------' );
      Assert( False, sJson );

      if( stProfile.profileImageURL <> '' )then
      begin
        OAuth2Authenticator.AccessToken := AccessToken;
        RESTClient.BaseURL              := stProfile.profileImageURL;
        RESTClient.Authenticator        := OAuth2Authenticator;
        RESTRequest.ExecuteAsync( procedure
          begin
            Stream := TMemoryStream.Create;
            try
              Stream.WriteData( RESTResponse.RawBytes, RESTResponse.ContentLength );
              img_profile.Bitmap.LoadFromStream( Stream );
            finally
              Stream.Free;
            end;
          end
        );
      end;
    finally
      ;
    end;
  end;
end;

procedure TfMAIN.PrsProfile( const AccessToken, sImgUrl: string );
var
  Stream: TMemoryStream;
begin
  Assert( False, '** PrsProfile()' );

  if( AccessToken <> '' )then
  begin
    try
      if( sImgUrl <> '' )then
      begin
        OAuth2Authenticator.AccessToken := AccessToken;
        RESTClient.BaseURL              := sImgUrl;
        RESTClient.Authenticator        := OAuth2Authenticator;
        RESTRequest.ExecuteAsync( procedure
          begin
            Stream := TMemoryStream.Create;
            try
              Stream.WriteData( RESTResponse.RawBytes, RESTResponse.ContentLength );
              img_profile.Bitmap.LoadFromStream( Stream );
            finally
              Stream.Free;
            end;
          end
        );
      end;
    finally
      ;
    end;
  end;
end;

procedure TfMAIN.tmrLoginTimer( Sender: TObject );
var
  sTitle  : string;
  sCode   : string;
  stValue : ST_VALUE;
begin
  Assert( False, '** tmrLoginTimer()' );

  sTitle := lbl_title.Text;

  if( sTitle = 'google' )then
  begin
    tmrLogin.Enabled     := False;
    tabControl.ActiveTab := tabBrowser;
  end
  else if( sTitle = 'naver' )then
  begin
    tmrLogin.Enabled     := False;
    tabControl.ActiveTab := tabBrowser;
  end
  else if( sTitle = 'kakao' )then
  begin
    tmrLogin.Enabled     := False;
    tabControl.ActiveTab := tabBrowser;
  end;
end;

procedure TfMAIN.btn_connect_googleClick( Sender: TObject );
begin
  Assert( False, '** btn_connect_googleClick()' );

  lbl_title.Text := 'google';
  InitCtrls();

  {$IFDEF ANDROID}
    OpenURL_Android( api_GetGoogleLoginURL() );
  {$ENDIF}

  {$IFDEF MSWINDOWS}
    tmrLogin.Enabled   := True;
    WebBrowser.Tag     := 11;
    WebBrowser.URL     := api_GetGoogleLoginURL_WIN();
    WebBrowser.Navigate;
  {$ENDIF}

end;

procedure TfMAIN.btn_connect_kakaoClick(Sender: TObject);
begin
  Assert( False, '** btn_connect_kakaoClick()' );

  lbl_title.Text := 'kakao';
  InitCtrls();
  tmrLogin.Enabled := True;
  WebBrowser.Tag   := 11;
  WebBrowser.URL   := api_GetKakaoLoginURL();
  WebBrowser.Navigate;
end;

procedure TfMAIN.btn_connect_naverClick(Sender: TObject);
begin
  Assert( False, '** btn_connect_naverClick()' );

  lbl_title.Text := 'naver';
  InitCtrls();
  tmrLogin.Enabled := True;
  WebBrowser.Tag   := 11;
  WebBrowser.URL   := api_GetNaverLoginURL();
  WebBrowser.Navigate;
end;

{$IFDEF ANDROID}
procedure TfMAIN.WebBrowserDidFinishLoad( ASender: TObject );
var
  sTitle     : string;
  b_prs      : boolean;
  LUrl       : string;
  code       : string;
  Params     : TStringList;
  stTkGoogle : ST_GOOGLE_TOKEN;
  stUGoogle  : ST_GOOGLE_USER_INFO;
  stTkNaver  : ST_NAVER_TOKEN;
  stTkKakao  : ST_KAKAO_TOKEN;
  stUKakao   : ST_KAKAO_USER_ME;
  stUNaver   : ST_NAVER_NID_ME;
  stProfile  : ST_KAKAO_PROFILE;
begin
  Assert( False, '** WebBrowserDidFinishLoad()' );
  if( WebBrowser.Tag = 0 )then
  begin
    Assert( False, '----------------------------------------------' );
    Assert( False, '> ' + WebBrowser.URL );
    try
      Params := TStringList.Create;
      if( lbl_title.Text = 'kakao' )then
      begin
        LUrl := WebBrowser.URL;
        if( (KAKAO_REDIRECT_URI + '/') = LUrl )then
        begin
          WebBrowser.Tag := 22;
          WebBrowser.URL := LOGIN_FAILED_URL;
        end
        else if( Pos('code=', LUrl) > 0 )then
        begin
          WebBrowser.Tag := 22;
          code := Copy(lurl, Pos('code=', lurl) + Length('code='), Length(lurl));
          Assert( False, '----------------------------------------------' );
          Assert( False, code );
          if( Pos('&', code) > 0 )then
          begin
            code := Copy(code, 1, Pos('&', code) - 1);
          end;
          edtCode.Text  := code;
          stTkKakao     := api_GetKaKaoToken( code );
          edtToken.Text := stTkKakao.access_token;
          if( edtToken.Text <> '' )then
          begin
            stUKakao        := api_GetKakaoUserMe( edtToken.Text );
            stProfile       := api_GetKakaoTalkProfile( edtToken.Text );
            WebBrowser.URL := LOGIN_SUCCESS_URL;
          end
          else
          begin
            WebBrowser.URL := LOGIN_FAILED_URL;
          end;
        end;
      end
      else if( lbl_title.Text = 'naver' )then
      begin
        try
          LUrl := WebBrowser.URL;
          if( ( NAVER_REDIRECT_URI + '/' ) = LUrl )then
          begin
            WebBrowser.Tag := 22;
            WebBrowser.URL := LOGIN_FAILED_URL;
          end
          else if( Pos('code=', LUrl) > 0 )then
          begin
            WebBrowser.Tag := 22;
            code := Copy(lurl, Pos('code=', lurl) + Length('code='), Length(lurl) );
            Assert( False, '----------------------------------------------' );
            Assert( False, code );
            if( Pos('&', code) > 0 )then
            begin
              code := Copy(code, 1, Pos('&', code) - 1);
            end;
            edtCode.Text := code;
            stTkNaver    := api_GetNaverToken( code );
            edtToken.Text     := stTkNaver.access_token;
            if( edtToken.Text <> '' )then
            begin
              stUNaver        := api_GetNaverNidMe( edtToken.Text );
              WebBrowser.URL := LOGIN_SUCCESS_URL;
            end
            else
            begin
              WebBrowser.URL := LOGIN_FAILED_URL;
            end;
          end;
        finally
        end;
      end
      else if( lbl_title.Text = 'google' )then
      begin
        b_prs  := false;
        try
          LUrl := WebBrowser.URL;
          if( ( GOOGLE_REDIRECT_URI + '/' ) = LUrl )then
          begin
            WebBrowser.Tag := 22;
            b_prs           := True;
            WebBrowser.URL := LOGIN_FAILED_URL;
          end
          else if( Pos('/fix/OAuth/', LUrl) > 0 )then
          begin
            if( Pos('code=', LUrl) > 0 )then
            begin
              WebBrowser.Tag := 22;
              b_prs           := True;
              code := Copy(lurl, Pos('code=', lurl) + Length('code='), Length(lurl) );
              Assert( False, '----------------------------------------------' );
              Assert( False, code );
              if( Pos('&', code) > 0 )then
              begin
                code := Copy(code, 1, Pos('&', code) - 1);
              end;
              edtCode.Text  := code;
              stTkGoogle    := api_GetGoogleToken( code );
              edtToken.Text := stTkGoogle.access_token;
              if( edtToken.Text <> '' )then
              begin
                stUGoogle       := api_GetGoogleUserInfo( edtToken.Text );
                WebBrowser.URL := LOGIN_SUCCESS_URL;
              end
              else
              begin
                WebBrowser.URL := LOGIN_FAILED_URL;
              end;
            end;
          end
          else
          begin
            WebBrowser.LoadFromStrings( DUMMY_HTML, '' );
          end;
          if( b_prs = True )then
          begin
            WebBrowser.Tag := 22;
          end;
        finally
        end;
      end;
    finally
      Params.Free;
    end;
  end;
end;
{$ENDIF}

procedure OnAssertError(const Message, Filename: string; LineNumber: Integer; ErrorAddr: Pointer);
var
  nResult   : Integer;
  nLogType  : Integer;
  sFileName : String;
  sSkip     : String;
  sMsg      : String;
begin
  try
    sSkip     := 'C:\[POINTHUB]\D12.2\OAuth2\OAuth-Google-Naver-Kakao\';
    sFileName := StringReplace( FileName, sSkip, '', [rfReplaceAll]);
    sMsg      := Trim( Format('%s: Line: %d, %s', [ sFileName, LineNumber, Message ]) );
    if( Assigned( fMAIN ) )then
    begin
      fMAIN.Memo.Lines.Add( sMsg );
    end;
  finally
    ;
  end;
end;

initialization
  AssertErrorProc := OnAssertError;

end.
