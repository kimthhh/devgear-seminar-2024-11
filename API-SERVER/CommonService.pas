unit CommonService;

interface

uses
  XData.Service.Common;

type
  [ServiceContract]
  ICommonService = interface(IInvokable)
    ['{C5CE62AB-D52C-487A-B659-27E94E853FAF}']
    [HttpGet] function Sum(A, B: double): double;
    [HttpPost] function EchoString(Value: string): string;

    [HttpPost] function login( sID, sPW: string ): string;
    [HttpPost] function logout([XDefault('')] sID: string ): string;
    [HttpPost] function VerifyTokenAndExtend( sToken: string): string;
  end;

implementation

initialization
  RegisterServiceType(TypeInfo(ICommonService));

end.
