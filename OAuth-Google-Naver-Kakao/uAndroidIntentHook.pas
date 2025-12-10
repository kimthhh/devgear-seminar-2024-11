unit uAndroidIntentHook;

interface

{$IFDEF ANDROID}

uses
  System.SysUtils, System.Messaging,
  Androidapi.JNIBridge, Androidapi.JNI.App, Androidapi.Helpers,
  Androidapi.JNI.JavaTypes, Androidapi.JNI.GraphicsContentViewText, Androidapi.Log;

type
  // 🔹 onNewIntent 콜백용 인터페이스
  JOnNewIntentListener = interface(IJavaInstance)
    ['{B8AFC79D-021C-45EB-93CA-6D7A3DB64A45}']
    procedure onNewIntent(intent: JIntent); cdecl;
  end;

  TJOnNewIntentListener = class(TJavaLocal, JOnNewIntentListener)
  private
    FCallback: TProc<JIntent>;
  public
    constructor Create(const ACallback: TProc<JIntent>);
    procedure onNewIntent(intent: JIntent); cdecl;
  end;

  // 🔹 Delphi FMXNativeActivity JNI 연결 정의
  JFMXNativeActivity = interface(JActivity)
    ['{C1E08D7A-83FA-42A4-9D62-06F88F89BB9A}']
    procedure setOnNewIntentListener(listener: JOnNewIntentListener); cdecl;
  end;

  TJFMXNativeActivity = class(TJavaGenericImport<JActivityClass, JFMXNativeActivity>)
  end;

  // 🔹 메인 훅 클래스
  TAndroidIntentHook = class
  private
    class var FInstance: TAndroidIntentHook;
  public
    class function Instance: TAndroidIntentHook;
    procedure RegisterNewIntentListener;
    procedure HandleIntent(const Intent: JIntent);
  end;

{$ENDIF}

implementation

{$IFDEF ANDROID}
{ TJOnNewIntentListener }

constructor TJOnNewIntentListener.Create(const ACallback: TProc<JIntent>);
begin
  inherited Create;
  FCallback := ACallback;
end;

procedure TJOnNewIntentListener.onNewIntent(intent: JIntent);
begin
  if Assigned(FCallback) then
    FCallback(intent);
end;

{ TAndroidIntentHook }

class function TAndroidIntentHook.Instance: TAndroidIntentHook;
begin
  if FInstance = nil then
    FInstance := TAndroidIntentHook.Create;
  Result := FInstance;
end;

procedure TAndroidIntentHook.HandleIntent(const Intent: JIntent);
var
  RedirectUri: string;
  CodePos: Integer;
  Code: string;
begin
  if Intent = nil then Exit;

  if Intent.hasExtra(StringToJString('redirect_uri')) then
  begin
    RedirectUri := JStringToString(Intent.getStringExtra(StringToJString('redirect_uri')));
    Assert( False, 'OAuthBridge >> ' + 'Received redirect_uri: ' + RedirectUri);

    CodePos := Pos('code=', RedirectUri);
    if CodePos > 0 then
    begin
      Code := Copy(RedirectUri, CodePos + 5, MaxInt);
      if Pos('&', Code) > 0 then
        Code := Copy(Code, 1, Pos('&', Code) - 1);
      Assert( False, 'Google OAuth Code = ' + Code);
    end;
  end;
end;

procedure TAndroidIntentHook.RegisterNewIntentListener;
var
  Activity: JActivity;
begin
  Activity := TAndroidHelper.Activity;
  if Activity = nil then Exit;

  // 안전한 JNI 캐스팅
  TJFMXNativeActivity.Wrap(Activity).setOnNewIntentListener(
    TJOnNewIntentListener.Create(
      procedure(Intent: JIntent)
      begin
        HandleIntent(Intent);
      end
    )
  );
end;

{$ENDIF}

end.

