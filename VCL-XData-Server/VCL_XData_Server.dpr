program VCL_XData_Server;

uses
  Vcl.Forms,
  Server in 'Server.pas',
  ConnectionModule in 'ConnectionModule.pas' {FireDacMSSQLConnection: TDataModule},
  MainForm in 'MainForm.pas' {fmServer},
  uMAIN in '..\WEB-TEST\uMAIN.pas' {fMAIN: TWebForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFireDacMSSQLConnection, FireDacMSSQLConnection);
  Application.CreateForm(TfmServer, fmServer);
  Application.CreateForm(TfMAIN, fMAIN);
  Application.Run;
end.
