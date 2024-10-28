// Copyright (c) KIM TAE HYUN, 2024.
//
// This file is part of devgear-seminar-2024-11 and is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
    function VerifyTokenAndExtend( sApiKEY: string): string;

    function GetGridDATA( sGroupID: string ): string;
  end;

implementation

function TCommonService.Sum(A, B: double): double;
var
  sTemp : string;
begin
  Result := A + B;
  sTemp := Format( '** TCommonService.Sum( %f, %f ) > %f', [A, B, Result] );
  Assert( false, sTemp );
end;

function TCommonService.EchoString(Value: string): string;
var
  sTemp : string;
begin
  sTemp := Format( '** TCommonService.EchoString( %s )', [Value] );
  Assert( false, sTemp );
  Result := Value;
end;

function TCommonService.VerifyTokenAndExtend( sApiKEY: string): string;
var
  sTemp: string;
begin
  try
    sTemp := Format( '** TCommonService.VerifyTokenAndExtend( %s )', [sApiKEY] );
    Assert( false, sTemp );

    sTemp := 'False';
    if( rds_VerifyTokenAndExtend( sApiKEY ) )then
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

function TCommonService.GetGridDATA( sGroupID: string ): string;
var
  sTemp : string;
  res   : ST_GRID_DATA_SET;
begin
  try
    sTemp := Format( '** TCommonService.GetGridDATA( %s )', [sGroupID] );
    Assert( false, sTemp );
    FillChar( res, SizeOf(ST_GRID_DATA_SET), #0 );

    res := sq_GetGridDATA( sGroupID ); //ST_GRID_DATA_SET
  finally
    result := TJSON.Stringify< ST_GRID_DATA_SET >( res );
  end;
end;

initialization
  RegisterServiceType(TCommonService);

end.
