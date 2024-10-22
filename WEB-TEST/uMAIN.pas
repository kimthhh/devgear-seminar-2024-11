unit uMAIN;

interface

uses
  System.SysUtils ,
  System.Classes  ,
  Vcl.Controls    ,
  Vcl.StdCtrls    ,
  JS              ,
  Web             ,
  WEBLib.Graphics ,
  WEBLib.Controls ,
  WEBLib.Forms    ,
  WEBLib.Dialogs  ,
  WEBLib.StdCtrls
  ;

type
  TfMAIN = class(TWebForm)
    lbl_info: TWebLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMAIN: TfMAIN;

implementation

{$R *.dfm}

end.