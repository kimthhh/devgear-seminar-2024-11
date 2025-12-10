unit uProtocols;

interface

type
  ST_VALUE = packed record
    sException               : string;
    value                    : string;
  end;

  {------------------------------------------}

  ST_KAKAO_TOKEN = packed record
    access_token             : string;
    token_type               : string;
    refresh_token            : string;
    expires_in               : Integer;
    scope                    : string;
    refresh_token_expires_in : Integer;
  end;

  {------------------------------------------}

  ST_KAKAO_PROFILE = packed record
    nickName                 : string;
    profileImageURL          : string;
    thumbnailURL             : string;
  end;

  {------------------------------------------}

  ST_KAKAO_PROFILE_EX = packed record
    nickname                 : string;
    thumbnail_image_url      : string;
    profile_image_url        : string;
    is_default_image         : Boolean;
    is_default_nickname      : Boolean;
  end;

  ST_KAKAO_ACCOUNT = packed record
    profile_nickname_needs_agreement : boolean;
    profile                  : ST_KAKAO_PROFILE_EX;
    has_email                : Boolean;
    email_needs_agreement    : Boolean;
    is_email_valid           : Boolean;
    is_email_verified        : Boolean;
    email                    : string;
  end;

  ST_KAKAO_USER_PROPERTIES = packed record
    nickname                 : string;
    profile_image            : string;
    thumbnail_image          : string;
  end;

  ST_KAKAO_USER_ME = packed record
    id                       : Integer;
    connected_at             : string;
    properties               : ST_KAKAO_USER_PROPERTIES;
    kakao_account            : ST_KAKAO_ACCOUNT;
  end;

  {------------------------------------------}

  ST_NAVER_TOKEN = packed record
    access_token             : string;
    refresh_token            : string;
    token_type               : string;
    expires_in               : string;
  end;

  {------------------------------------------}

  ST_NAVER_NID_ME_RESPONSE = packed record
    id                       : string;
    nickname                 : string;
    profile_image            : string;
    age                      : string;
    gender                   : string;
    email                    : string;
    mobile                   : string;
    mobile_e164              : string;
    name                     : string;
    birthday                 : string;
    birthyear                : string;
  end;

  ST_NAVER_NID_ME = packed record
    resultcode               : string;
    message                  : string;
    response                 : ST_NAVER_NID_ME_RESPONSE;
  end;

  {------------------------------------------}

  ST_NAVER_LOGOUT = packed record
    result                   : string;
    access_token             : string;
  end;

  {------------------------------------------}

  ST_GOOGLE_TOKEN = packed record
    access_token             : string;
    expires_in               : Integer;
    refresh_token            : string;
    scope                    : string;
    token_type               : string;
    id_token                 : string;
  end;

  {------------------------------------------}

  ST_GOOGLE_USER_INFO = packed record
    id                       : string;
    email                    : string;
    verified_email           : Boolean;
    name                     : string;
    given_name               : string;
    family_name              : string;
    picture                  : string;
    locale                   : string;
  end;

  {------------------------------------------}

  ST_GOOGLE_LOGOUT = packed record
    success                  : string;
    raw                      : string;
  end;

  {------------------------------------------}

  ST_AUTH_LOGIN = packed record
    s_name            : string;
    s_email           : string;
    s_picture_url     : string;
  end;

  ST_AUTH_INFO = packed record
  //s_code            : string;        {only use in auth server}
  //s_dt_code         : string;        {only use in auth server}
    s_type            : string;        {Ex> google, naver, kakao}
    s_access_token    : string;
    s_dt_prs          : string;        {Login Completion Time, Ex>'yyyy-mm-dd hh:mm:ss'}
    stLogin           : ST_AUTH_LOGIN; {Login Detail Info}
  end;

  {------------------------------------------}

const
  KAKAO_CLIENT_ID        = 'XXXXXXXXXX';
  KAKAO_REDIRECT_URI     = 'https://XXXX.kr/fix/OAuth/Kakao';

  NAVER_CLIENT_ID        = 'XXXXXXXXXX';
  NAVER_CLIENT_SECRET    = 'XXXXXXXXXX';
  NAVER_REDIRECT_URI     = 'https://XXXX.kr/fix/OAuth/Naver';

  GOOGLE_CLIENT_ID       = 'XXXXXXXXXX';
  GOOGLE_CLIENT_SECRET   = 'XXXXXXXXXX';

  GOOGLE_REDIRECT_URI     = 'https://XXXX.kr/fix/OAuth/Google';
  GOOGLE_REDIRECT_URI_WIN = 'https://XXXX.kr/fix/OAuth/GooDirect';

implementation

end.
