unit CommonServiceImplementation;

interface

uses
    XData.Server.Module
  , XData.Service.Common

  , System.Classes
  , System.SysUtils
  , System.NetEncoding

  , Winapi.Windows

  , CommonService
  , CommonServiceQry

  , uApiProtocols
  , uPrsREDIS
  , XSuperObject

  ;

type
  [ServiceImplementation]
  TCommonService = class(TInterfacedObject, ICommonService)
  private
    function Sum(A, B: double): double;
    function EchoString(Value: string): string;

    function login( sID, sPW: string ): string;
    function logout( sID: string ): string;
    function VerifyTokenAndExtend( sToken: string): string;

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

function TCommonService.VerifyTokenAndExtend( sToken: string): string;
var
  sTemp: string;
begin
  try
    sTemp := Format( '** TCommonService.VerifyTokenAndExtend( %s )', [sToken] );
    Assert( false, sTemp );

    sTemp := 'False';
    if( rds_VerifyTokenAndExtend( sToken ) )then
    begin
      sTemp := 'True';
    end;
  finally
    Result := sTemp;
  end;
end;

function TCommonService.login( sID, sPW: string ): string;
var
  sTemp: string;
  res: ST_Indexed_DB;
begin
  try
    sTemp := Format( '** TCommonService.login( %s )', [sID] );
    Assert( false, sTemp );

    FillChar( res, SizeOf( ST_Indexed_DB ), #0 );

    //--(sq)------------------
    res := Sq_login( sID, sPW );
    //------------------------

    if( res.s_USER_ID <> '' )then
    begin
      //--(rds)-----------------
      res.s_Token := rds_Login( sID );
      //------------------------
    end;
  finally
    result := TJSON.Stringify< ST_Indexed_DB >( res );
  end;
end;

function TCommonService.logout( sID: string ): string;
var
  sTemp: string;
  res: ST_Indexed_DB;
begin
  try
    sTemp := Format( '** TCommonService.logout( %s )', [sID] );
    Assert( false, sTemp );
    FillChar( res, SizeOf(ST_Indexed_DB), #0 );

    res.s_LoginTime := FormatDateTime('YYYY-MM-DD HH:MM:SS', Now );
    //--(rds)-----------------
    res.b_PrsLogout := rds_Logout( sID );
    //------------------------
  finally
    result := TJSON.Stringify< ST_Indexed_DB >( res );
  end;
end;

initialization
  RegisterServiceType(TCommonService);

end.
