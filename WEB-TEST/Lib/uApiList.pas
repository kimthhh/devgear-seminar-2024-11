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

unit uApiList;

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

  [async] function api_post_login( sApiURL, sID, sPW: string ): ST_Indexed_DB;
  [async] function api_post_logout( sApiURL, sToken, sID: string ): ST_Indexed_DB;

implementation

function api_post_login( sApiURL, sID, sPW: string ): ST_Indexed_DB;
var
  sURL   : string;
  sTemp  : string;
  sRes   : string;
  sv     : JSValue;
begin
  try
    SetConsoleLog('**(+) api_post_login');

    sRes := '';
    sURL := sApiURL + '/CommonService/login';
    asm
      var sJson = '';
      await axios.post( sURL, {
        sID: sID,
        sPW: sPW
      })
      .then(response => {
        if( response.status === 200 ){
          sJson = JSON.stringify( response.data );
          sv    = JSON.parse( sJson    );
          sv    = JSON.parse( sv.value );
        }
      })
      .catch( (error) => {
        if (error.response && error.response.status === 401) {
          sRes = '401';
        }
        console.error('Error:', error);
      });
    end;


    SetConsoleLog( sv );
    Result := ST_Indexed_DB( sv );

  finally
    SetConsoleLog('**(-) api_post_login');
  end;
end;

function api_post_logout(sApiURL, sToken, sID: string): ST_Indexed_DB;
var
  sURL   : string;
  sTemp  : string;
  sRes   : string;
  sv     : JSValue;
begin
  try
    SetConsoleLog('**(+) api_post_logout');

    sRes := '';
    sURL := sApiURL + '/CommonService/logout';
    asm
      var sJson = '';
      await axios.post(sURL, {
        sID: sID
      }, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': sToken
        }
      })
      .then(response => {
        if (response.status === 200) {
          sJson = JSON.stringify(response.data);
          sv = JSON.parse(sJson);
          sv = JSON.parse(sv.value);
        }
      })
      .catch( (error) => {
        if (error.response && error.response.status === 401) {
          sRes = '401';
        }
        console.error('Error:', error);
      });
    end;

    if( sRes = '401' )then
    begin
      TPrsUnauthorized.SendMessage( sRes , '>from api_post_logout' );
    end
    else
    begin
      SetConsoleLog(sv);
      Result := ST_Indexed_DB(sv);
    end;

  finally
    SetConsoleLog('**(-) api_post_logout');
  end;
end;

end.
