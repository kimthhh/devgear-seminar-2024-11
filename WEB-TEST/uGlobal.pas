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
  g_sApiKEY : string = '';

implementation

end.
