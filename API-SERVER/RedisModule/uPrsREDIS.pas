unit uPrsREDIS;

interface

uses
  SysUtils,
  IdHTTP,
  Redis.Client,
  Redis.Commons;

function GenerateToken(): string;
function rds_Login(const sUserID: string): string;
function rds_VerifyTokenAndExtend(const sToken: string): Boolean;
function rds_Logout(const sUserID: string): Boolean;

implementation

var
 g_n_rds_port          : Integer = 6379;
 g_n_rds_extended_time : Integer = 86400; {1day by sec}
 g_s_rds_ip            : string  = 'localhost';

function GenerateToken(): string;
begin
  //------------------------------
  Result := TGuid.NewGuid.ToString;
  //------------------------------
end;

procedure SaveTokenInRedis(const sToken, sUserID: string);
var
  Redis          : IRedisClient;
  sExistingToken : string;
begin
  Assert( false, '**(+) SaveTokenInRedis');
  try
    //---------------------------------------------------
    Redis := NewRedisClient( g_s_rds_ip, g_n_rds_port );
    //---------------------------------------------------
    if not Assigned(Redis) then
    begin
     Assert( false, '> Redis 객체 생성 실패');
    end
    else
    begin
      try
        //------------------------------
        if( Redis.Exists( 'user:' + sUserID ) )then
        //------------------------------
        begin
          //------------------------------
          sExistingToken := Redis.GET('user:' + sUserID);
          //------------------------------
          if sExistingToken <> '' then
          begin
            //------------------------------
            Redis.DEL([sExistingToken]);
            //------------------------------
          end;
        end;
      except
        on E: Exception do
        begin
          Assert( false, '> Redis GET/DEL 오류: ' + E.Message);
        end;
      end;

      try
        //------------------------------
        Redis.&SET(sToken, sUserID);
        Redis.EXPIRE( sToken, g_n_rds_extended_time );
        Redis.&SET('user:' + sUserID, sToken);
        //------------------------------
      except
        on E: Exception do
        begin
          Assert( false, '> Redis SET/EXPIRE 오류: ' + E.Message);
        end;
      end;
    end;
  finally
    Assert( false, '**(-) SaveTokenInRedis');
  end;
end;

function rds_Login(const sUserID: string): string;
var
  sToken : string;
begin
  Assert( false, '**(+) rds_Login');
  try
    //------------------------------
    sToken := GenerateToken();
    //------------------------------
    SaveTokenInRedis( sToken, sUserID );
    //------------------------------
    Result := sToken;
  except
    on E: Exception do
    begin
      Assert( false, '> rds_Login 오류: ' + E.Message);
    end;
  end;
  Assert( false, '**(-) rds_Login');
end;

function rds_VerifyTokenAndExtend(const sToken: string): Boolean;
var
  Redis   : IRedisClient;
  sTemp   : string;
  sUserID : string;
begin
  Assert( false, '**(+) rds_VerifyTokenAndExtend');
  try
    //---------------------------------------------------
    Redis := NewRedisClient( g_s_rds_ip, g_n_rds_port);
    //---------------------------------------------------
    if not Assigned(Redis) then
    begin
      Assert( false, '> Redis 객체 생성 실패');
    end
    else
    begin
      try
        //------------------------------
        if( Redis.Exists( sToken ) )then
        //------------------------------
        begin
          //------------------------------
          sUserID := Redis.GET( sToken );
          //------------------------------
          if( sUserID <> '' )then
          begin
            //------------------------------
            Redis.EXPIRE( sToken, g_n_rds_extended_time );
            //------------------------------
            sTemp := Format( '> ID(%s) 인증시간 업데이트!!', [sUserID] );
            Assert( false, sTemp );
            Result := True;
          end
          else
          begin
            Result := False;
          end;
        end
        else
        begin
          Result := False;
        end;
      except
        on E: Exception do
        begin
          Assert( false, '> Redis GET/EXPIRE 오류: ' + E.Message);
        end;
      end;
    end;
  finally
    Assert( false, '**(-) rds_VerifyTokenAndExtend');
  end;
end;

function rds_Logout(const sUserID: string): Boolean;
var
  Redis  : IRedisClient;
  sToken : string;
begin
  Assert( false, '**(+) rds_Logout');
  try
    Result := False;
    //---------------------------------------------------
    Redis := NewRedisClient( g_s_rds_ip, g_n_rds_port );
    //---------------------------------------------------
    if not Assigned( Redis ) then
    begin
      Assert( false, '> Redis 객체 생성 실패' );
    end
    else
    begin
      try
        //------------------------------
        if( Redis.Exists( 'user:' + sUserID ) )then
        //------------------------------
        begin
          //------------------------------
          sToken := Redis.GET( 'user:' + sUserID );
          //------------------------------
          if( sToken <> '' )then
          begin
            //------------------------------
            Redis.Del([sToken]);
            Redis.Del(['user:' + sUserID]);
            //------------------------------
            Result := True;
          end;
        end;
      except
        on E: Exception do
        begin
          Assert( false, '> Redis GET/DEL 오류: ' + E.Message );
        end;
      end;
    end;
  finally
    Assert( false, '**(-) rds_Logout' );
  end;
end;

end.

