unit uUtils;

interface

uses
  JS                      ,
  Web                     ,

  WEBLib.Graphics         ,
  WEBLib.Controls         ,
  WEBLib.Forms            ,
  WEBLib.Dialogs          ,
  WEBLib.StdCtrls         ,
  WEBLib.ExtCtrls         ,
  WEBLib.WebTools         ,

  Graphics                ,
  uApiProtocols           ,

  (*
  VCL.TMSFNCGrid          ,
  VCL.TMSFNCTypes         ,
  VCL.TMSFNCGraphicsTypes ,
  VCL.TMSFNCGridCell      ,
  *)

  System.DateUtils        ,
  System.SysUtils         ,
  System.Classes          ,
  System.UITypes
  ;

procedure SetConsoleLog( ObjJSValue: JSValue );

implementation

procedure SetConsoleLog( ObjJSValue: JSValue );
var
  sTemp: string;
begin
  {$IFDEF DEBUG}
  (*
    sTemp := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now);
    console.log( sTemp      );
  *)
  console.log( ObjJSValue );
  {$ENDIF DEBUG}
end;

end.
