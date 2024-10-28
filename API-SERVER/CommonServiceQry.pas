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

unit CommonServiceQry;

interface

uses   System.SysUtils
     , System.DateUtils
     , System.Generics.Collections

     , Data.DB
     , StrUtils
     , Graphics
     , Classes
     (*
     , FireDAC.Stan.Intf
     , FireDAC.Stan.Option
     , FireDAC.Stan.Error
     , FireDAC.UI.Intf
     , FireDAC.Phys.Intf
     , FireDAC.Stan.Def
     , FireDAC.Stan.Pool
     , FireDAC.Stan.Async
     , FireDAC.Phys
     , FireDAC.VCLUI.Wait
     , FireDAC.Stan.Param
     , FireDAC.DatS
     , FireDAC.DApt.Intf
     , FireDAC.DApt
     , FireDAC.Comp.DataSet
     , FireDAC.Comp.Client
     , FireDAC.Stan.StorageJSON
     , FireDAC.Phys.MSSQLDef
     , FireDAC.Phys.ODBCBase
     , FireDAC.Phys.MSSQL
     , FireDAC.Comp.BatchMove.DataSet
     , FireDAC.Comp.BatchMove
     , FireDAC.Comp.BatchMove.JSON
     *)
     , XSuperObject
     , uPrsREDIS
     , uApiProtocols
     ;

function Sq_login( const sID: string; const sPW: string ): ST_Indexed_DB;
function sq_GetGridDATA( const sGroupID: string ): ST_GRID_DATA_SET;

implementation

function sq_GetGridDATA( const sGroupID: string ): ST_GRID_DATA_SET;
var
  I     : Integer;
  sTemp : string;
  res   : ST_GRID_DATA_SET;
begin
  try
    Assert( false, '**(+) sq_GetGridDATA' );
    FillChar( res, SizeOf(ST_GRID_DATA_SET), #0 );
    try
      for I := 0 to 9 do
      begin
        SetLength( res.ITEM, I+1 );

        res.ITEM[I].s_name   := Format('%s %.2d',['Gil Dong Hong',I+1]);
        res.ITEM[I].s_mobile := Format('010-1234-%.4d',[I+1]);
        res.ITEM[I].s_email  := Format('PointHUB.%.2d@gmail.com',[I+1]);
        res.ITEM[I].s_addr   := Format('1004-%d, 11, Teheran-ro, Gangnam-gu, Seoul, Korea',[I+1]);

        sTemp := Format( '**(%d) %s, %s, %s, %s', [ I ,
                                                    res.ITEM[I].s_name   ,
                                                    res.ITEM[I].s_mobile ,
                                                    res.ITEM[I].s_email  ,
                                                    res.ITEM[I].s_addr
                                                  ] );
        Assert( false, sTemp );
      end;
      res.n_count := I;
    except
      on E: Exception do
      begin
        res.sException := E.Message;
        Assert( false, E.Message );
      end;
    end;

  finally
    Result := res;
    Assert( false, '**(-) sq_GetGridDATA' );
  end;
end;

function Sq_login( const sID: string; const sPW: string ): ST_Indexed_DB;
var
  sTemp : string;
//qry   : TFDQuery;
  res   : ST_Indexed_DB;
begin
  try
    Assert( false, '**(+) Sq_login' );

    try

      (*
      qry            := TFDQuery.Create(nil);
      qry.Connection := DbController.Connection;

      Fillchar( res, SizeOf( ST_Indexed_DB ), #0 );

      with qry do
      begin
        Close;
        SQL.Clear;

        SQL.Add(' SELECT ts.UserID                ');
        SQL.Add('   FROM tblUSER ts WITH(NOLOCK)  ');
        SQL.Add('  WHERE 1 = 1                    ');
        SQL.Add('    AND ts.UseYes   = 1          ');
        SQL.Add('    AND ts.UserID   = :sID       ');
        SQL.Add('    AND ts.Password = :sPW       ');

        paramByName( 'sID' ).AsString := sID;
        paramByName( 'sPW' ).AsString := sPW;

        Assert( false, SQL.Text );
        open;

        if( RecordCount > 0 )then
        begin
          res.s_UserID     := sID;
          res.s_LoginTime  := FormatDateTime( 'yyyy-mm-dd hh:mm:ss', Now() );
        end;
      end;
      *)

      Fillchar( res, SizeOf( ST_Indexed_DB ), #0 );

      res.s_USER_ID   := sID;
      res.s_LoginTime := FormatDateTime( 'yyyy-mm-dd hh:mm:ss', Now() );

    except
      on E: Exception do
      begin
        res.sException := E.Message;
        Assert( false, E.Message );
      end;
    end;

    try
      Result := res;
    except
      on E: Exception do
      begin
        Assert( false, E.Message );
      end;
    end;
  finally
    (*
    qry.Free;
    *)
    Assert( false, '**(-) Sq_login' );
  end;
end;

end.
