unit cookiesothen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,LResources;

type
  TCharSet = set of AnsiChar;
  RawByteString = ansistring;
  _TIME_ZONE_INFORMATION = record
    Bias: longint;
    StandardName: array[0..31] of WCHAR;
    StandardDate: TSystemTime;
    StandardBias: longint;
    DaylightName: array[0..31] of WCHAR;
    DaylightDate: TSystemTime;
    DaylightBias: longint;
  end;
  TTimeZoneInformation = _TIME_ZONE_INFORMATION;

const
  kernel32 = 'kernel32.dll';
  ISODateTimeMask = 'yyyy-mm-dd"T"hh:nn:ss';
  TIME_ZONE_ID_INVALID = DWORD($FFFFFFFF);
  {$EXTERNALSYM TIME_ZONE_ID_INVALID}
  TIME_ZONE_ID_UNKNOWN = 0;
  {$EXTERNALSYM TIME_ZONE_ID_UNKNOWN}
  TIME_ZONE_ID_STANDARD = 1;
  {$EXTERNALSYM TIME_ZONE_ID_STANDARD}
  TIME_ZONE_ID_DAYLIGHT = 2;

  {$EXTERNALSYM TIME_ZONE_ID_DAYLIGHT}
  UriProtocolSchemeAllowedChars:TCharSet=['a'..'z','0'..'9','+','-','.'];

function atoi(const Str: RawByteString): integer;
function IcsUTCToDateTime(dtDT: TDateTime): TDateTime;
function GetTimeZoneInformation(var lpTimeZoneInformation: TTimeZoneInformation): DWORD;
  stdcall; external kernel32;
procedure ParseURL(const URL: string;
  var Proto, User, Pass, Host, Port, Path: string);
function Posn(const s, t: string; Count: integer): integer;
function IcsLowerCaseA(const S: AnsiString): AnsiString;
function IcsLowerCase(const S: AnsiString): AnsiString;

implementation

function IcsGetLocalTimeZoneBias: LongInt;
{$IFDEF MSWINDOWS}
var
    tzInfo : TTimeZoneInformation;
begin
    case GetTimeZoneInformation(tzInfo) of
        TIME_ZONE_ID_STANDARD: Result := tzInfo.Bias + tzInfo.StandardBias;
        TIME_ZONE_ID_DAYLIGHT: Result := tzInfo.Bias + tzInfo.DaylightBias;
        TIME_ZONE_ID_UNKNOWN : Result := tzInfo.Bias;
    else
        Result := 0; // Error
    end;
end;
{$ENDIF}
{$IFDEF MACOS}
var
    LTZ: CFTimeZoneRef;
    LNow: CFAbsoluteTime;
    LSecFromUTC: CFTimeInterval;
    LSecInt: Integer;
    // DLSOffs: CFTimeInterval;
begin
    LTZ := CFTimeZoneCopyDefault;
    try
        LNow := CFAbsoluteTimeGetCurrent;
        LSecFromUTC := CFTimeZoneGetSecondsFromGMT(LTZ, LNow); // Includes DaylightSavingTime for me
        {if CFTimeZoneIsDaylightSavingTime(LTZ, LNow) then
        begin
            DLSOffs := CFTimeZoneGetDaylightSavingTimeOffset(LTZ, LNow);
        end;}
        LSecInt := Trunc(LSecFromUTC);
        if LSecInt <> 0 then
            Result := -(LSecInt div 60) // Minutes bias as windows, works for me, ToBeChecked
        else
            Result := 0;
    finally
        CFRelease(LTZ);
    end;
end;
{$ENDIF}

function IcsUTCToDateTime (dtDT: TDateTime): TDateTime;
begin
    Result := dtDT - IcsGetLocalTimeZoneBias / (60.0 * 24.0);
end;

function atoi(const Str: RawByteString): integer;
var
  P: PAnsiChar;
begin
  Result := 0;
  P := Pointer(Str);
  if P = nil then
    Exit;
  while P^ = #$20 do
    Inc(P);
  while True do
  begin
    case P^ of
      '0'..'9': Result := Result * 10 + byte(P^) - byte('0');
      else
        Exit;
    end;
    Inc(P);
  end;
end;

procedure ParseURL(const URL: String; var Proto, User, Pass, Host, Port,
  Path: String);
  var
    p, q, i : Integer;
    s       : String;
    CurPath : String;
begin
    CurPath := Path;
    proto   := '';
    User    := '';
    Pass    := '';
    Host    := '';
    Port    := '';
    Path    := '';

    if Length(url) < 1 then
        Exit;

    { Handle path beginning with "./" or "../".          }
    { This code handle only simple cases !               }
    { Handle path relative to current document directory }
    if (Copy(url, 1, 2) = './') then begin
        p := Posn('/', CurPath, -1);
        if p > Length(CurPath) then
            p := 0;
        if p = 0 then
            CurPath := '/'
        else
            CurPath := Copy(CurPath, 1, p);
        Path := CurPath + Copy(url, 3, Length(url));
        Exit;
    end
    { Handle path relative to current document parent directory }
    else if (Copy(url, 1, 3) = '../') then begin
        p := Posn('/', CurPath, -1);
        if p > Length(CurPath) then
            p := 0;
        if p = 0 then
            CurPath := '/'
        else
            CurPath := Copy(CurPath, 1, p);

        s := Copy(url, 4, Length(url));
        { We could have several levels }
        while TRUE do begin
            CurPath := Copy(CurPath, 1, p-1);
            p := Posn('/', CurPath, -1);
            if p > Length(CurPath) then
                p := 0;
            if p = 0 then
                CurPath := '/'
            else
                CurPath := Copy(CurPath, 1, p);
            if (Copy(s, 1, 3) <> '../') then
                break;
            s := Copy(s, 4, Length(s));
        end;

        Path := CurPath + Copy(s, 1, Length(s));
        Exit;
    end;

    p := pos('://', url);
    q := p;
    if p <> 0 then begin
        S := IcsLowerCase(Copy(url, 1, p - 1));
        for i := 1 to Length(S) do begin
            if not (AnsiChar(S[i]) in UriProtocolSchemeAllowedChars) then begin
                q := i;
                Break;
            end;
        end;
        if q < p then begin
            p     := 0;
            proto := 'http';
        end;
    end;
    if p = 0 then begin
        if (url[1] = '/') then begin
            { Relative path without protocol specified }
            proto := 'http';
            //p     := 1;     { V6.05 }
            if (Length(url) > 1) then begin
                if (url[2] <> '/') then begin
                    { Relative path }
                    Path := Copy(url, 1, Length(url));
                    Exit;
                end
                else
                    p := 2;   { V6.05 }
            end
            else begin        { V6.05 }
                Path := '/';  { V6.05 }
                Exit;         { V6.05 }
            end;
        end
        else if IcsLowerCase(Copy(url, 1, 5)) = 'http:' then begin
            proto := 'http';
            p     := 6;
            if (Length(url) > 6) and (url[7] <> '/') then begin
                { Relative path }
                Path := Copy(url, 6, Length(url));
                Exit;
            end;
        end
        else if IcsLowerCase(Copy(url, 1, 7)) = 'mailto:' then begin
            proto := 'mailto';
            p := pos(':', url);
        end;
    end
    else begin
        proto := IcsLowerCase(Copy(url, 1, p - 1));
        inc(p, 2);
    end;
    s := Copy(url, p + 1, Length(url));

    p := pos('/', s);
    q := pos('?', s);
    if (q > 0) and ((q < p) or (p = 0)) then
        p := q;
    if p = 0 then
        p := Length(s) + 1;
    Path := Copy(s, p, Length(s));
    s    := Copy(s, 1, p-1);

    { IPv6 URL notation, for instance "[2001:db8::3]" }
    p := Pos('[', s);
    q := Pos(']', s);
    if (p = 1) and (q > 1) then
    begin
        Host := Copy(s, 2, q - 2);
        s := Copy(s, q + 1, Length(s));
    end;

    p := Posn(':', s, -1);
    if p > Length(s) then
        p := 0;
    q := Posn('@', s, -1);
    if q > Length(s) then
        q := 0;
    if (p = 0) and (q = 0) then begin   { no user, password or port }
        if Host = '' then
            Host := s;
        Exit;
    end
    else if q < p then begin  { a port given }
        Port := Copy(s, p + 1, Length(s));
        if Host = '' then
            Host := Copy(s, q + 1, p - q - 1);
        if q = 0 then
            Exit; { no user, password }
        s := Copy(s, 1, q - 1);
    end
    else begin
        if Host = '' then
            Host := Copy(s, q + 1, Length(s));
        s := Copy(s, 1, q - 1);
    end;
    p := pos(':', s);
    if p = 0 then
        User := s
    else begin
        User := Copy(s, 1, p - 1);
        Pass := Copy(s, p + 1, Length(s));
    end;
end;

function Posn(const s, t: String; count: Integer): Integer;
var
    i, h, Last : Integer;
    u          : String;
begin
    u := t;
    if Count > 0 then begin
        Result := Length(t);
        for i := 1 to Count do begin
            h := Pos(s, u);
            if h > 0 then
                u := Copy(u, h + 1, Length(u))
            else begin
                u := '';
                Inc(Result);
            end;
        end;
        Result := Result - Length(u);
    end
    else if Count < 0 then begin
        Last := 0;
        for i := Length(t) downto 1 do begin
            u := Copy(t, i, Length(t));
            h := Pos(s, u);
            if (h <> 0) and ((h + i) <> Last) then begin
                Last := h + i - 1;
                Inc(count);
                if Count = 0 then
                    break;
            end;
        end;
        if Count = 0 then
            Result := Last
        else
            Result := 0;
    end
    else
        Result := 0;
end;

function IcsLowerCaseA(const S: AnsiString): AnsiString;
var
    Ch : AnsiChar;
    L, I  : Integer;
    Source, Dest: PAnsiChar;
begin
    L := Length(S);
    if L = 0  then
        Result := ''
    else begin
        SetLength(Result, L);
        Source := Pointer(S);
        Dest := Pointer(Result);
        for I := 1 to L do begin
            Ch := Source^;
            if Ch in ['A'..'Z'] then Inc(Ch, 32);
            Dest^ := Ch;
            Inc(Source);
            Inc(Dest);
        end;
    end;
end;

function IcsLowerCase(const S: AnsiString): AnsiString;
begin
  {$IFDEF USE_ICS_RTL}
    Result := IcsLowerCaseA(S);
{$ELSE}
{$IFNDEF COMPILER12_UP}
    Result := SysUtils.LowerCase(S);
{$ELSE}
    Result := IcsLowerCaseA(S);
{$ENDIF}
{$ENDIF}
end;

initialization
  {$I res.lrs}

end.
