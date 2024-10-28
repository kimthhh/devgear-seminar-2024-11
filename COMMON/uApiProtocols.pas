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

  ST_GRID_DATA = packed record
    sException       : string;
    s_name           : string;
    s_mobile         : string;
    s_email          : string;
    s_addr           : string;
  end;

  ST_GRID_DATA_SET = packed record
    sException       : string;
    n_count          : Integer;
    ITEM             : array of ST_GRID_DATA;
  end;


implementation

end.
