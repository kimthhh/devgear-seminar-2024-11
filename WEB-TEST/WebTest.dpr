program WebTest;

{$R *.dres}

uses
  Vcl.Forms,
  WEBLib.Forms,
  uMAIN in 'uMAIN.pas' {fMAIN: TWebForm} {*.html},
  uApiList in 'Lib\uApiList.pas',
  uApiProtocols in '..\COMMON\uApiProtocols.pas',
  uPrsUnauthorized in 'Lib\uPrsUnauthorized.pas',
  uUtils in 'Lib\uUtils.pas',
  uGlobal in 'uGlobal.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMAIN, fMAIN);
  Application.Run;
end.
