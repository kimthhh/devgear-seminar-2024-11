unit uApiProtocols;

interface

uses
  Windows               ,
  Messages                ,
  System.DateUtils        ,
  Graphics                ,
  Controls                ,
  ExtCtrls                ,
  {$IFNDEF WEBLIB}
    Generics.Collections  ,
    SyncObjs              ,
    Mask                  ,
    XSuperJSON            ,
    XSuperObject          ,
    Data.Cloud.AmazonAPI  ,
  {$ENDIF}
  System.SysUtils         ,
  System.Classes          ,
  System.UITypes
  ;

type
  ST_Indexed_DB = packed record
    sException       : string;
    s_USER_ID        : string;
    s_USER_NAME      : string;
    s_LoginTime      : string;
    s_Token          : string;
    s_Type           : string;
    b_PrsLogout      : Boolean;
    s_StoreRole      : string;
  end;


implementation

end.
