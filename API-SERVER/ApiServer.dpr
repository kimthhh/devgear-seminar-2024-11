program ApiServer;

uses
  Vcl.Forms,
  uServerContaner in 'uServerContaner.pas' {ServerContainer: TDataModule},
  uSrvMAIN in 'uSrvMAIN.pas' {fSvrMAIN},
  uLogWriteThread in 'uLogWriteThread.pas',
  CommonService in 'CommonService.pas',
  CommonServiceImplementation in 'CommonServiceImplementation.pas',
  uPrsREDIS in 'RedisModule\uPrsREDIS.pas',
  JsonDataObjects in 'RedisModule\delphiredisclient\sources\JsonDataObjects.pas',
  Redis.Client in 'RedisModule\delphiredisclient\sources\Redis.Client.pas',
  Redis.Command in 'RedisModule\delphiredisclient\sources\Redis.Command.pas',
  Redis.Commons in 'RedisModule\delphiredisclient\sources\Redis.Commons.pas',
  Redis.NetLib.Factory in 'RedisModule\delphiredisclient\sources\Redis.NetLib.Factory.pas',
  Redis.NetLib.INDY in 'RedisModule\delphiredisclient\sources\Redis.NetLib.INDY.pas',
  Redis.Values in 'RedisModule\delphiredisclient\sources\Redis.Values.pas',
  RedisMQ.Commands in 'RedisModule\delphiredisclient\sources\RedisMQ.Commands.pas',
  RedisMQ in 'RedisModule\delphiredisclient\sources\RedisMQ.pas',
  XSuperJSON in 'XSuperObject\XSuperJSON.pas',
  XSuperObject in 'XSuperObject\XSuperObject.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServerContainer, ServerContainer);
  Application.CreateForm(TfSvrMAIN, fSvrMAIN);
  Application.Run;
end.
