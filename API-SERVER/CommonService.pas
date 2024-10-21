unit CommonService;

interface

uses
  XData.Service.Common;

type
  [ServiceContract]
  ICommonService = interface(IInvokable)
    ['{C5CE62AB-D52C-487A-B659-27E94E853FAF}']
    [HttpGet] function Sum(A, B: double): double;
    // By default, any service operation responds to (is invoked by) a POST request from the client.
    function EchoString(Value: string): string;
  end;

implementation

initialization
  RegisterServiceType(TypeInfo(ICommonService));

end.
