unit uMAIN;

interface

uses
  System.SysUtils  ,
  System.Classes   ,

  Vcl.Controls     ,
  Vcl.StdCtrls     ,
  Vcl.Grids        ,

  JS               ,
  Web              ,
  Types            ,

  uPrsUnauthorized ,
  uUtils           ,
  uApiProtocols    ,

  WEBLib.Graphics  ,
  WEBLib.Controls  ,
  WEBLib.Forms     ,
  WEBLib.Dialogs   ,
  WEBLib.StdCtrls  ,
  WEBLib.ExtCtrls  ,
  WEBLib.Grids
  ;

type
  TfMAIN = class(TWebForm)
    lbl_info    : TWebLabel;
    pnl_body    : TWebPanel;
    btn_search  : TWebButton;
    grd_test    : TWebStringGrid;
    btn_login   : TWebButton;
    btn_logout  : TWebButton;

    procedure WebFormCreate(Sender: TObject);
    procedure WebFormDestroy(Sender: TObject);
    procedure btn_searchClick(Sender: TObject);
    procedure btn_logoutClick(Sender: TObject);
    procedure btn_loginClick(Sender: TObject);

  private
    { Private declarations }
    m_UnAuth : TPrsUnauthorized;  // verify & prs for Status code: 401 {Unauthorized}

  public
    { Public declarations }
    [async] function OnCheckUnauthorized( sMSG: string; sFrom: string ): Integer; // verify & prs for Status code: 401 {Unauthorized}
  end;

var
  fMAIN: TfMAIN;

implementation

{$R *.dfm}

procedure TfMAIN.WebFormCreate(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.WebFormCreate()' );
  m_UnAuth := TPrsUnauthorized.Create( TOnCheckUnauthorized( @OnCheckUnauthorized ) ); // verify & prs for Status code: 401 {Unauthorized}
end;

procedure TfMAIN.WebFormDestroy(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.WebFormDestroy()' );
end;

procedure TfMAIN.btn_loginClick(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.btn_loginClick( call api )' );
end;

procedure TfMAIN.btn_logoutClick(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.btn_logoutClick( call api )' );
end;

procedure TfMAIN.btn_searchClick(Sender: TObject);
begin
  SetConsoleLog( '** TfMAIN.btn_searchClick( call api )' );
end;

function TfMAIN.OnCheckUnauthorized( sMSG: string; sFrom: string ): Integer; // verify & prs for Status code: 401 {Unauthorized}
var
  sINFO : string;
  stDB  : ST_Indexed_DB;
begin
  sINFO := Format( '** TfMAIN.OnCheckUnauthorized( %s )', [sFrom] );
  SetConsoleLog( sINFO );

  Result := 0;
  if( sMSG <> '' )then
  begin
    // To do something...
  end;
end;


end.