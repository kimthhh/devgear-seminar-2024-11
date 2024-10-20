program WebTest;

{$R *.dres}

uses
  Vcl.Forms,
  WEBLib.Forms,
  uMAIN in 'uMAIN.pas' {fMAIN: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMAIN, fMAIN);
  Application.Run;
end.
