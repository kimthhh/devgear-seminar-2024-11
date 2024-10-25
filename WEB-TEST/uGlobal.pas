unit uGlobal;

interface

uses
  Windows                 ,
  Messages                ,
  System.DateUtils        ,
  Graphics                ,
  Controls                ,
  ExtCtrls                ,
  uApiProtocols           ,
  uUtils                  ,
  uPrsUnauthorized        ,
  (*
  {$IFNDEF WEBLIB}
    Generics.Collections  ,
    SyncObjs              ,
    Mask                  ,
    XSuperJSON            ,
    XSuperObject          ,
    Data.Cloud.AmazonAPI  ,
  {$ENDIF}
  *)
  WebLib.JSON             ,
  WEBLib.WebCtrls         ,
  WEBLib.WebTools         ,
  WEBLib.Controls         ,
  WEBLib.StdCtrls         ,
  WEBLib.ExtCtrls         ,
  JS                      ,
  Web                     ,
  System.SysUtils         ,
  System.Classes          ,
  System.UITypes
  ;

var
  g_sApiURL : string = 'http://localhost:2001/tms/xdata/';
  g_sToken  : string = '';

implementation

end.
