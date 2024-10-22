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

implementation

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

        SQL.Add(' SELECT ts.StoreRole       as s_StoreRole      ');
        SQL.Add('   FROM tblStore ts WITH(NOLOCK)               ');
        SQL.Add('  WHERE ts.ParkCode      = 1                   ');
        SQL.Add('    AND ts.UseYes        = 1                   ');
        SQL.Add('    AND ts.StoreID       = :sID                ');
        SQL.Add('    AND ts.StorePassword = :sPW                ');

        paramByName( 'sID' ).AsString := sID;
        paramByName( 'sPW' ).AsString := sPW;

        Assert( false, SQL.Text );
        open;

        if( RecordCount > 0 )then
        begin
          res.s_USER_ID    := sID;
          res.s_StoreRole  := FieldByName( 's_StoreRole'      ).AsString;
          res.s_LoginTime  := FormatDateTime( 'yyyy-mm-dd hh:mm:ss', res.dt_LoginTime );
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
