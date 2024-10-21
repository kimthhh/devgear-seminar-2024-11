program ApiServer;

uses
  Vcl.Forms,
  uServerContaner in 'uServerContaner.pas' {ServerContainer: TDataModule},
  uSrvMAIN in 'uSrvMAIN.pas' {fSvrMAIN};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServerContainer, ServerContainer);
  Application.CreateForm(TfSvrMAIN, fSvrMAIN);
  Application.Run;
end.
