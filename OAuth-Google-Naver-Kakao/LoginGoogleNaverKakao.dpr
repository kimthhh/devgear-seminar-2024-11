program LoginGoogleNaverKakao;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMAIN in 'uMAIN.pas' {fMAIN},
  XSuperJSON in 'XSuperObject\XSuperJSON.pas',
  XSuperObject in 'XSuperObject\XSuperObject.pas',
  uApiList in 'uApiList.pas',
  uProtocols in 'uProtocols.pas',
  uAndroidIntentHook in 'uAndroidIntentHook.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMAIN, fMAIN);
  Application.Run;
end.
