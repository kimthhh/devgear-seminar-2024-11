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
