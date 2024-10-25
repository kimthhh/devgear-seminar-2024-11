unit uPrsUnauthorized;

interface

uses   System.SysUtils
     , System.Classes
     , System.DateUtils
     , uUtils
     ;

type
  TOnCheckUnauthorized = function ( sMSG: string; sFrom: string ): Integer of object;
  TPrsUnauthorized = class
    class function SendMessage( sMSG: string; sFrom: string ): Integer;
    public
      class var
        m_OnCheckUnauthorized : TOnCheckUnauthorized; // callback funtion pointer type..
    public
      constructor Create( hHandler: TOnCheckUnauthorized );
      destructor  Destroy();
  end;

implementation

constructor TPrsUnauthorized.Create( hHandler: TOnCheckUnauthorized );
begin
  SetConsoleLog( '** TPrsUnauthorized.Create()' );
  if( Assigned( hHandler ) )then
  begin
    m_OnCheckUnauthorized := hHandler;
  end;
end;

destructor  TPrsUnauthorized.Destroy();
begin
  SetConsoleLog( '** TPrsUnauthorized.Destroy()' );
end;

class function TPrsUnauthorized.SendMessage( sMSG: string; sFrom: string ): Integer;
var
  sMessage: string;
begin
  SetConsoleLog( '** TPrsUnauthorized.SendMessage()' );
  sMessage := '';
  if( Assigned( m_OnCheckUnauthorized ) )then
  begin
    asm
      if( sMSG === undefined ){
        sMessage = "";
      }
      else{
        sMessage = sMSG;
      }
    end;
    Result := m_OnCheckUnauthorized( sMessage, sFrom );
  end;
end;

end.
