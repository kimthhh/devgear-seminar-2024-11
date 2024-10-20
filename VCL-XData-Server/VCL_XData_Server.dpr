program VCL_XData_Server;

uses
  Vcl.Forms,
  Server in 'Server.pas',
  ConnectionModule in 'ConnectionModule.pas' {FireDacMSSQLConnection: TDataModule},
  MainForm in 'MainForm.pas' {fmServer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFireDacMSSQLConnection, FireDacMSSQLConnection);
  Application.CreateForm(TfmServer, fmServer);
  Application.Run;
end.
