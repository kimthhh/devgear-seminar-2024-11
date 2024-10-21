unit CommonServiceImplementation;

interface

uses
  XData.Server.Module,
  XData.Service.Common,
  CommonService;

type
  [ServiceImplementation]
  TCommonService = class(TInterfacedObject, ICommonService)
  private
    function Sum(A, B: double): double;
    function EchoString(Value: string): string;
  end;

implementation

function TCommonService.Sum(A, B: double): double;
begin
  Result := A + B;
end;

function TCommonService.EchoString(Value: string): string;
begin
  Result := Value;
end;

initialization
  RegisterServiceType(TCommonService);

end.
