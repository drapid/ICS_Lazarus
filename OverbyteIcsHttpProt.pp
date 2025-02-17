{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE
Creation:     November 23, 1997
Version:      1.35
Description:  THttpCli is an implementation for the HTTP protocol
              RFC 1945 (V1.0), and some of RFC 2068 (V1.1)
Credit:       This component was based on a freeware from by Andreas
              Hoerstemeier and used with his permission.
              andy@hoerstemeier.de http://www.hoerstemeier.com/index.htm
EMail:        http://www.overbyte.be       francois.piette@overbyte.be
              http://www.rtfm.be/fpiette   francois.piette@rtfm.be
              francois.piette@pophost.eunet.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 1997-2001 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
              <francois.piette@overbyte.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

Quick Reference:
HTTP component can retrieve documents or files using HTTP protocol; that is
connect to a HTTP server also known as a webserver. It can also trigger a
CGI/ISAPI/NSAPI script and post data using either GET or POST method.
Syntax of an URL: protocol://[user[:password]@]server[:port]/path
Path can include data: question mark followed by URL encoded data.
HTTP component is either asynchonous (non-blocking) or synchonous (blocking).
Highest performance is when using asynchonous operation. This is the
recommended way to use HTTP component.
To request several URL simultaneously, use asynchronous operation and as much
HTTP components as you wants to request URLs. All requests will be executed
simultaneously without using multi-threading and without blocking your app.
Methods:
    GetASync    Asynchronous, non-blocking Get
                Retrieve document or file specified by URL, without blocking.
                OnRequestDone event trigered when finished. Use HTTP GET method (data contained in URL)
    PostASync   Asynchronous, non-blocking Post
                Retrieve document or file specified by URL, without blocking.
                OnRequestDone event trigered when finished. Use HTTP POST method (data contained in request stream)
    HeadASync   Asynchronous, non-blocking Head
                Retrieve document or file header specified by URL, without blocking.
                OnRequestDone event trigered when finished. Use HTTP HEAD method.

    Get         Synchronous, blocking Get. Same as GetAsync, but blocks until  finished.
    Post        Synchronous, blocking Post. Same as PostAsync, but blocks until finished.
    Head        Synchronous, blocking Head. Same as HeadAsync, but blocks until finished.
    Abort       Immediately close communication.

Updates:
11/29/97 RcvdStream and SendStream properties moved to public section
11/30/97 Document name bug corrected
12/02/97 Removed bug occuring with terminating slash in docname
12/03/97 Added properties RcvdCount and SentCount to easily add a progress
         bar feature (On receive, the ContentLength is initialized with the
         value from the header. Update the progress bar in the OnDocData event,
         or the OnSendData event).
         Added the OnSendBegin, OnSendData and OnSendEnd events.
12/07/97 Corrected Head function to work as expected. Thanks to
         R. Barry Jones <rbjones@therightside.demon.co.uk
29/12/97 V0.96 Added ModifiedSince property as following proposition made by
         Aw Kong Koy" <infomap@tm.net.my>.
30/12/97 V0.97 Added a Cookie property to send cookies
11/01/98 V0.98 Added WSocket read-only property which enable to access the
         socket component used internally. For example to close it to abort
         a connection.
13/01/98 V0.99 Added MultiThreaaded property to tell the component that it is
         working in a thread and should take care of it.
15/01/98 V1.00 Completely revised internal working to make it work properly
         with winsock 2. The TimeOut property is gone.
         Changed OnAnswerLine event to OnHeaderData to be more consistent.
         Replaced AnswserLine property by readonly LastResponse property.
         Added OnRequestDone event. Added GetAsync, PostAsync, HeadAsync
         asynchronous, non-blocking methods. Added Abort procedure.
16/01/98 V1.01 Corrected a bug which let some data be lost when receiving
         (thanks to  Fulvio J. Castelli <fulvio@rocketship.com>)
         Added test for HTTP/1.1 response in header.
31/01/98 V1.02 Added an intermediate message posting for the OnRequestDone
         event. Thanks to Ed Hochman <ed@mbhsys.com> for his help.
         Added an intermediate PostMessage to set the component to ready state.
04/02/98 V1.03 Added some code to better handle DocName (truncating at the
         first question mark).
05/02/98 V1.04 Deferred login after a relocation, using WM_HTTP_LOGIN message.
         Added workarounf to support faulty webservers which sent only a single
         LF in header lines. Submitted by Alwin Hoogerdijk <alwin@lostboys.nl>
15/03/98 V1.05 Enlarge buffers from 2048 to 8192 bytes (not for D1)
01/04/98 V1.06 Adapted for BCB V3
13/04/98 V1.07 Made RcvdHeader property readonly and cleared the content at the
         start of a request.
         Protected Abort method from calling when component is ready.
         Ignore any exception triggered by CancelDnsLookup in Abort method.
14/04/98 V1.08 Corrected a relocation bug occuring with relative path
26/04/98 V1.09 Added OnLocationChange event
30/04/98 V1.10 Added ProxyUsername and ProxyPassword. Suggested by
         Myers, Mike <MikeMy@crt.com>.
26/05/98 V1.11 Corrected relocation problem when used with ASP webpages
09/07/98 V1.12 Adapted for Delphi 4
         Checked argument length in SendCommand
19/09/98 V1.13 Added support for HTML document without header
         Added OnSessionConnected event, httpConnected state and
         httpDnsLookupDone state.
         Corrected a problem with automatic relocation. The relocation
         message was included in data, resulting in wrong document data.
         Added two new events: OnRequestHeaderBegin and OnRequestHeaderEnd.
         They replace the OnHeaderBegin and OnHeaderEnd events that where
         called for both request header (to web server) and response
         header (from web server)
22/11/98 V1.14 Added a Location property than gives the new location in
         case of page relocation. Suggested by Jon Robertson <touri@pobox.com>
21/12/98 V1.15 Set ContentLength equal to -1 at start of command.
31/01/99 V1.16 Added HostName property
01/02/99 V1.17 Port was lost in DoRequestAsync when using a proxy.
         Thanks to David Wright <wrightd@gamespy.com> for his help.
         Report Dns lookup error and session connect error in OnrequestDOne
         event handler as suggested by Jack Olivera <jack@token.nl>.
14/03/99 V1.18 Added OnCookie event.
16/03/99 V1.19 Added Accept property.
               Added a default value to Agent property.
               Changed OnCookie event signature (not fully implemented yet !).
07/05/99 V1.20 Added code to support Content Ranges by Jon Robertson
               <touri@pobox.com>.
24/07/99 V1.21 Yet another change in relocation code.
Aug 20, 1999  V1.22 Changed conditional compilation so that default is same
              as latest compiler (currently Delphi 4, Bcb 4). Should be ok for
              Delphi 5. Added Sleep(0) in sync wait loop to reduce CPU usage.
              Added DnsResult property as suggested by Heedong Lim
              <hdlim@dcenlp.chungbuk.ac.kr>. This property is accessible from
              OnStateChange when state is httpDnsLookupDone.
              Triggered OnDocData after writing to the stream.
Sep 25, 1999  V1.23 Yet another change in relocation code when using proxy
              Francois Demers <fdemers@videotron.ca> found that some webserver
              do not insert a space after colon in header line. Corrected
              code to handle it correctly.
              Cleared ContentType before issuing request.
Oct 02, 1999  V1.24 added AcceptRanges property. Thanks to Werner Lehmann
              <wl@bwl.uni-kiel.de>
Oct 30, 1999  V1.25 change parameter in OnCommand event from const to var to
              allow changing header line, including deleting or adding before
              or after a given line sent by the component.
Nov 26, 1999  V1.26 Yet another relocation fix !
Jun 23, 2000  V1.27 Fixed a bug in ParseURL where hostname is followed by a '?'
              (that is no path but a query).
Jul 22, 2000  V1.28 Handle exception during DnsLookup from the login procedure.
              Suggested by Robert Penz <robert.penz@outertech.com>
Sep 17, 2000  V1.29 Eugene Mayevski <Mayevski@eldos.org> added support for
              NOFORMS.
Jun 18, 2001  V1.30 Use AllocateHWnd and DeallocateHWnd from wsocket.
              Renamed property WSocket to CtrlSocket (this require code change
              in user application too).
Jul 25, 2001  V1.31 Danny Heijl <Danny.Heijl@cevi.be> found that ISA proxy adds
              an extra space to the Content-length header so we need a trim
              to extract numeric value.
              Ran Margalit <ran@margalit.com> found some server sending
              empty document (Content-Length = 0) which crashed the component.
              Added a check for that case when header is finished.
              Andrew N.Silich" <silich@rambler.ru> found we need to handle
              handle relative path using "../" and "./" when relocating. Thanks
              for his code which was a good starting point.
Jul 28, 2001  V1.32 Sahat Bun <sahat@operamail.com> suggested to change POST to
              GET when a relocation occurs.
              Created InternalClear procedure as suggested by Frank Plagge
              <frank@plagge.net>.
              When relocation, clear FRcvdHeader. If port not specified, then
              use port 80. By Alexander O.Kazachkin <kao@inreco.ru>
Jul 30, 2001 V1.33 Corected a few glitches with Delphi 1
Aug 18, 2001 V1.34 Corrected a bug in relocation logic: when server send only a
             header, with no document at all, relocation was not occuring and
             OnHeaderEnd event was not triggered.
             Corrected a bug in document name when a CGI was invoked (a '?'
             found in the URL). Now, ignore everything after '?' which is CGI
             parameter.
Sep 09, 2001 V1.35 Beat Boegli <leeloo999@bluewin.ch> added LocalAddr property
             for multihomed hosts.


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsHttpProt;

interface
 {$define fpc}
 {$mode delphi}
 {$DEFINE NO_DEBUG_LOG}
{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$X+}           { Enable extended syntax              }
{$IFNDEF VER80} { Not for Delphi 1                    }
    {$H+}       { Use long strings                    }
    {$J+}       { Allow typed constant to be modified }
{$ENDIF}
{$IFDEF VER110} { C++ Builder V3.0                    }
    {$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125} { C++ Builder V4.0                    }
    {$ObjExportAll On}
{$ENDIF}
{$Define NoForms}
uses
   Windows, SysUtils, Classes,
    {$IFNDEF NOFORMS}
    Forms, Controls,
    {$ENDIF}
   OverbyteIcsWndControl,
   OverbyteIcsTypes,
   OverbyteIcsWSocket;

const
    HttpCliVersion     = 135;
    CopyRight : String = ' THttpCli (c) 1997-2001 F. Piette V1.35 ';
    DefaultProxyPort   = '80';
(* V9.3 moved to OverbyteIcsTypes

{$IFDEF VER80}
    { Delphi 1 has a 255 characters string limitation }
    HTTP_RCV_BUF_SIZE = 255;
    HTTP_SND_BUF_SIZE = 8193;
{$ELSE}
    HTTP_RCV_BUF_SIZE = 8193;
    HTTP_SND_BUF_SIZE = 8193;
{$ENDIF}
//    WM_HTTP_REQUEST_DONE = WM_USER + 1;
//    WM_HTTP_SET_READY    = WM_USER + 2;
//    WM_HTTP_LOGIN        = WM_USER + 3;
    { EHttpException error code }
    httperrBase                     = {$IFDEF MSWINDOWS} 1 {$ELSE} 1001 {$ENDIF}; { V7.23 }
    httperrNoError                  = 0;
    httperrBusy                     = httperrBase;
    httperrNoData                   = httperrBusy + 1;
    httperrAborted                  = httperrNoData + 1;
    httperrOverflow                 = httperrAborted + 1;
    httperrVersion                  = httperrOverflow + 1;
    httperrInvalidAuthState         = httperrVersion + 1;
    httperrSslHandShake             = httperrInvalidAuthState + 1;
    httperrCustomTimeOut            = httperrSslHandShake + 1;
    httperrNoStatusCode             = httperrCustomTimeOut + 1;
    httperrOutOfMemory              = httperrNoStatusCode + 1;        { V8.68 }
    httperrBgException              = httperrOutOfMemory + 1;         { V8.68 }
    { Change next as well if new EHttpException error codes are added }
    httperrMax                      = httperrBgException;

type

    THttpEncoding    = (encUUEncode, encBase64, encMime);
    THttpRequest     = (httpAbort, httpGET, httpPOST, httpHEAD);
    THttpState       = (httpReady,         httpNotConnected, httpConnected,
                        httpDnsLookup,     httpDnsLookupDone,
                        httpWaitingHeader, httpWaitingBody,  httpAborting);
*)
type
    THttpBeforeAuthEvent   = procedure(Sender  : TObject;
                                 AuthType      : THttpAuthType;
                                 ProxyAuth     : Boolean;
                                 const AuthHdr : String;
                                 var Allow     : Boolean) of object;
    TOnCommand       = procedure (Sender : TObject;
                                  var S: String) of object;
    TDocDataEvent    = procedure (Sender : TObject;
                                  Buffer : Pointer;
                                  Len    : Integer) of object;
    TCookieRcvdEvent = procedure (Sender       : TObject;
                                  const Data   : String;
                                  var   Accept : Boolean) of object;
    THttpRequestDone = procedure (Sender  : TObject;
                                  RqType  : THttpRequest;
                                  ErrCode : Word) of object;
    TBeforeHeaderSendEvent = procedure (Sender       : TObject;
                                        const Method : String;
                                        Headers      : TStrings) of object;
    TLocationChangeExceeded = procedure (Sender              : TObject;
                                  const RelocationCount      : Integer;
                                  var   AllowMoreRelocations : Boolean) of object;  {  V1.90 }
    TSelectDnsEvent = procedure(Sender : TObject;
                                  DnsList     : TStrings;
                                  var NewDns  : String) of object;      { V8.57 }

    EHttpException = class(Exception)
    private
        FErrorCode: Word;
    public
        property ErrorCode : Word read FErrorCode write FErrorCode;
        constructor Create(const Msg : String; ErrCode : Word);
    end;

    THttpCli = class(TIcsWndControl)
    protected
        FMsg_WM_HTTP_REQUEST_DONE : UINT;
        FMsg_WM_HTTP_SET_READY    : UINT;
        FMsg_WM_HTTP_LOGIN        : UINT;
        FCtrlSocket               : TWSocket;
//        FWindowHandle     : HWND;
        FMultiThreaded    : Boolean;
        FState                : THttpState;
        FLocalAddr            : string; {bb}        
        FHostName             : String;
        FTargetHost           : String;
        FTargetPort           : String;
        FPort                 : String;
        FProtocol             : String;
        FProxy                : String;
        FProxyPort            : String;
        FUsername             : String;
        FPassword             : String;
        FCurrUsername         : String;
        FCurrPassword         : String;
        FProxyUsername        : String;
        FProxyPassword        : String;
        FProxyURL             : String;     { V8.62 combines Proxy/PrexyPort/ProxyUserName/proxyPassword as URL }
        FLocation             : String;
        FCurrentHost          : String;
        FCurrentPort          : String;
        FCurrentProtocol      : String;
        FConnected            : Boolean;
        FDnsResult            : String;
        FSendBuffer           : TBytes;  // FP 09/09/06
        FRequestType          : THttpRequest;
        FReceiveBuffer        : TBytes;  // FP 09/09/06
        FReceiveLen           : Integer;
        FLastResponse         : String;
        FHeaderLineCount      : Integer;
        //FBodyLineCount    : Integer;
        FBodyStartedFlag      : Boolean;    { V8.67 was FBodyLineCount }
        FAllowedToSend        : Boolean;
        FDelaySetReady        : Boolean;        { 09/26/08 ML }
        FURL                  : String;
        FPath                 : String;
        FDocName              : String;
        FSender               : String;
        FReference            : String;
        FAgent                : String;
        FAccept               : String;
        FModifiedSince        : TDateTime;      { Warning ! Use GMT date/Time }
        FNoCache              : Boolean;
        FExtraHeaders         : TStrings;   { V8.52 }
        FStatusCode           : Integer;
        FReasonPhrase         : String;
        FResponseVer          : String;
        FRequestVer           : String;
        FContentLength        : THttpBigInt;
        FContentType          : String;
        FTransferEncoding     : String;
{$IFDEF UseContentCoding}
        FContentEncoding      : String;
        FContentCodingHnd     : THttpContCodHandler;
        FRcvdStreamStartSize  : Integer;
{$ENDIF}
        FChunkLength          : Integer;
        FChunkRcvd            : Integer;
        FChunkState           : THttpChunkState;
        FDoAuthor             : TStringList;
        FContentPost          : String;
        FContentRangeBegin    : String;   {JMR!! Added this line!!!}
        FContentRangeEnd      : String;   {JMR!! Added this line!!!}
        FAcceptRanges         : String;
        FCookie               : String;
        FLocationFlag         : Boolean;
        FFollowRelocation     : Boolean;    {TED}
        FHeaderEndFlag        : Boolean;
        FRcvdHeader           : TStrings;
        FRcvdStream           : TStream;     { If assigned, will recv the answer }
        FRcvdCount            : THttpBigInt; { Number of rcvd bytes for the body }
        FSentCount            : THttpBigInt;
        FSendStream           : TStream; { Contains the data to send         }
        FReqStream            : TMemoryStream;
        FRequestDoneError     : Integer;
        FNext                 : procedure of object;
        FBodyData             : Integer;  // Offset in FReceiveBuffer (FP 09/09/06)
        FBodyDataLen          : THttpBigInt;
        FOptions              : THttpCliOptions;
        FOnBeforeAuth         : THttpBeforeAuthEvent;
        FAuthBasicState       : THttpBasicState;
        FProxyAuthBasicState  : THttpBasicState;
        FServerAuth           : THttpAuthType;
        FProxyAuth            : THttpAuthType;
        FOnStateChange        : TNotifyEvent;
        FOnSessionConnected   : TNotifyEvent;
        FOnSessionClosed      : TNotifyEvent;
        FOnRequestHeaderBegin : TNotifyEvent;
        FOnRequestHeaderEnd   : TNotifyEvent;
        FOnHeaderBegin        : TNotifyEvent;
        FOnHeaderEnd          : TNotifyEvent;
        FOnHeaderData         : TNotifyEvent;
        FOnDocBegin           : TNotifyEvent;
        FOnDocEnd             : TNotifyEvent;
        FOnDocData            : TDocDataEvent;
        FOnSendBegin          : TNotifyEvent;
        FOnSendEnd            : TNotifyEvent;
        FOnSendData           : TDocDataEvent;
        FOnTrace              : TNotifyEvent;
        FOnCommand            : TOnCommand;
        FOnCookie             : TCookieRcvdEvent;
        FOnDataAvailable  : TDataAvailable;
        FOnDataPush           : TDataAvailable;
        FOnDataPush2          : TNotifyEvent;
        FOnRequestDone        : THttpRequestDone;
        FOnLocationChange     : TNotifyEvent;
        FLocationChangeMaxCount   : Integer;  {  V1.90 }
        FLocationChangeCurCount   : Integer;  {  V1.90 }
        FOnLocationChangeExceeded : TLocationChangeExceeded;  {  V1.90 }
        { Added by Eugene Mayevski }
        FOnSocketError        : TNotifyEvent;
        FOnBeforeHeaderSend   : TBeforeHeaderSendEvent;     { Wilfried 9 sep 02}
        FOnSelectDns          : TSelectDnsEvent;            { V8.57 }
        FCloseReq             : Boolean;                    { SAE 01/06/04 }
        FSocketErrs           : TSocketErrs;                { V8.37 }
        FCurrDnsResult        : Integer;       { V8.60 round robin DNS results }
        FTotDnsResult         : Integer;       { V8.60 round robin DNS results }
        FLastAddrOK           : String;        { V8.60 round robin DNS results }
        FPunyCodeHost         : String;        { V8.64 }
        FAddrResolvedStr      : String;        { V8.66 }
        FTimeout              : UINT;  { V7.04 }            { Sync Timeout Seconds }
        FWMLoginQueued        : Boolean;

        procedure AbortComponent(E:Exception); override;    { V8.68 added E to allow reporting }
        procedure AllocateMsgHandlers; override;
        procedure FreeMsgHandlers; override;
        function  MsgHandlersCount: Integer; override;
        procedure CheckDelaySetReady; virtual;              { 09/26/08 ML }
        procedure CreateSocket; virtual;
        procedure DoBeforeConnect; virtual;
        procedure SocketErrorTransfer(Sender : TObject);
        procedure SendRequest(const method,Version: String);
        procedure GetHeaderLineNext;
        procedure GetBodyLineNext;
        procedure SendCommand(const Cmd : String); virtual;
        procedure Login; virtual;
        procedure Logout; virtual;
        procedure InternalClear; virtual;
        procedure StartRelocation; virtual;
        procedure LoginDelayed; {$IFDEF USE_INLINE} inline; {$ENDIF}
        function GetBasicAuthorizationHeader(
            const HttpMethod: String; ProxyAuth: Boolean): String;
        procedure CleanupRcvdStream;
        procedure CleanupSendStream;
        procedure StartAuthBasic; virtual;
        procedure StartProxyAuthBasic; virtual;
        procedure ElaborateBasicAuth;
        function  PrepareBasicAuth(var FlgClean : Boolean) : Boolean;
        procedure SocketDNSLookupDone(Sender: TObject; ErrCode: Word); virtual;
        procedure SocketSessionClosed(Sender: TObject; ErrCode: Word); virtual;
        procedure SocketSessionConnected(Sender : TObject; ErrCode : Word); virtual;
        procedure SocketDataSent(Sender : TObject; ErrCode : Word); virtual;
        procedure SocketDataAvailable(Sender: TObject; ErrCode: Word); virtual;
        procedure LocationSessionClosed(Sender: TObject; ErrCode: Word); virtual;
        procedure DoRequestAsync(Rq : THttpRequest); virtual;
        procedure DoRequestSync(Rq : THttpRequest); virtual;
        procedure SetMultiThreaded(const Value : Boolean); override;
        procedure StateChange(NewState : THttpState); virtual;
        procedure TriggerStateChange; virtual;
        procedure TriggerCookie(const Data : String;
                                var   bAccept : Boolean); virtual;
        procedure TriggerSessionConnected; virtual;
        procedure TriggerSessionClosed; virtual;
        procedure TriggerBeforeHeaderSend(const Method : String;
                                          Headers : TStrings); virtual;
        procedure TriggerRequestHeaderBegin; virtual;
        procedure TriggerRequestHeaderEnd; virtual;
        procedure TriggerHeaderBegin; virtual;
        procedure TriggerHeaderEnd; virtual;
        procedure TriggerHeaderFieldData(var AHeaderField, AHeaderData: String); virtual;  { V8.71 JK }
        procedure TriggerDocBegin; virtual;
        procedure TriggerDocData(Data : Pointer; Len : Integer); virtual;
        procedure TriggerDocEnd; virtual;
        procedure TriggerSendBegin; virtual;
        procedure TriggerSendData(Data : Pointer; Len : Integer); virtual;
        procedure TriggerSendEnd; virtual;
        procedure TriggerRequestDone; virtual;
        procedure WndProc(var MsgRec: TMessage); override;
        procedure SetReady; virtual;
        procedure AdjustDocName; virtual;
        function  GetProtocolPort(const AProtocol: String): String; virtual;  { V8.71 JK }
        function  IsSSLProtocol(const AProtocol: String): Boolean; virtual;   { V8.71 JK }
        function  IsKnownProtocol(const AProtocol: String): Boolean; virtual; { V8.71 JK }
        function  IsKnownProtocolURL(const AURL : String): Boolean; virtual;  { V8.71 JK }
        procedure SetRequestVer(const Ver : String);
        procedure SetExtraHeaders(Value: TStrings);      { V8.52 }
    	function  HTTPCliAllocateHWnd(Method: TWndMethod): HWND; virtual;
    	procedure HTTPCliDeallocateHWnd(WHandle: HWND); virtual;
        procedure TriggerRequestDone2; virtual; { V8.61 so we can override it }
        procedure TriggerCommand(var S: String); virtual;  { V8.61 }
        procedure TriggerHeaderData; virtual;  { V8.61 }
        procedure TriggerLocationChange; virtual;  { V8.61 }
        procedure WMHttpRequestDone(var msg: TMessage);
                  //message WM_HTTP_REQUEST_DONE;
        procedure WMHttpSetReady(var msg: TMessage);
                  //message WM_HTTP_SET_READY;
        procedure WMHttpLogin(var msg: TMessage);
                  //message WM_HTTP_LOGIN;
    public
        constructor Create(Aowner:TComponent); override;
        destructor  Destroy; override;
        procedure   Get;        { Synchronous blocking Get        }
        procedure   Post;       { Synchronous blocking Post       }
        procedure   Head;       { Synchronous blocking Head       }
        procedure   GetASync;   { Asynchronous, non-blocking Get  }
        procedure   PostASync;  { Asynchronous, non-blocking Post }
        procedure   HeadASync;  { Asynchronous, non-blocking Head }
        procedure   Abort;

        procedure   RequestAsync(Rq :THttpRequest);                               { V8.69 }
        procedure   RequestSync(Rq :THttpRequest);                                { V8.69 }
        function    FindAuthType(AType: THttpAuthType): Integer;                  { V8.69 find WWWAuthInfos record with required authentication type }
        property CtrlSocket           : TWSocket     read  FCtrlSocket;
//        property Handle               : HWND         read  FWindowHandle;
        property State                : THttpState   read  FState;
        property LastResponse         : String       read  FLastResponse;
        property ContentLength        : THttpBigInt  read  FContentLength;
        property ContentType          : String       read  FContentType;
        property TransferEncoding     : String       read  FTransferEncoding;
        property RcvdCount            : THttpBigInt  read  FRcvdCount;
        property SentCount            : THttpBigInt  read  FSentCount;
        property StatusCode           : Integer      read  FStatusCode;
        property ReasonPhrase         : String       read  FReasonPhrase;
        property DnsResult            : String       read  FDnsResult;
        property AddrResolvedStr      : String       read  FAddrResolvedStr;      { V8.60 }
        property PunyCodeHost         : String       read  FPunyCodeHost;         { V8.64 }
        property AuthorizationRequest : TStringList  read  FDoAuthor;
        property DocName              : String       read  FDocName;
        property Location             : String       read  FLocation
                                                     write FLocation;
        property RcvdStream           : TStream      read  FRcvdStream
                                                     write FRcvdStream;
        property SendStream           : TStream      read  FSendStream
                                                     write FSendStream;
        property RcvdHeader           : TStrings     read  FRcvdHeader;
        property Hostname             : String       read  FHostname;
        property Protocol             : String       read  FProtocol;
    published
        property URL             : String            read  FURL
                                                     write FURL;
        property LocalAddr       : String            read  FLocalAddr   {bb}
                                                     write FLocalAddr;  {bb}                                                     
        property Proxy           : String            read  FProxy
                                                     write FProxy;
        property ProxyPort       : String            read  FProxyPort
                                                     write FProxyPort;
        property Sender          : String            read  FSender
                                                     write FSender;
        property Agent           : String            read  FAgent
                                                     write FAgent;
        property Accept          : String            read  FAccept
                                                     write FAccept;
        property Reference       : String            read  FReference
                                                     write FReference;
        property Username        : String            read  FUsername
                                                     write FUsername;
        property Password        : String            read  FPassword
                                                     write FPassword;
        property ProxyUsername   : String            read  FProxyUsername
                                                     write FProxyUsername;
        property ProxyPassword   : String            read  FProxyPassword
                                                     write FProxyPassword;
        property NoCache         : Boolean           read  FNoCache
                                                     write FNoCache;
        property ModifiedSince   : TDateTime         read  FModifiedSince
                                                     write FModifiedSince;
        property Cookie          : String            read  FCookie
                                                     write FCookie;
        property ExtraHeaders    : TStrings          read  FExtraHeaders
                                                     write SetExtraHeaders;       { V8.52 }
        property ContentTypePost : String            read  FContentPost
                                                     write FContentPost;
        property ContentRangeBegin: String           read  FContentRangeBegin  {JMR!! Added this line!!!}
                                                     write FContentRangeBegin; {JMR!! Added this line!!!}
        property ContentRangeEnd  : String           read  FContentRangeEnd    {JMR!! Added this line!!!}
                                                     write FContentRangeEnd;   {JMR!! Added this line!!!}
        property AcceptRanges     : String           read  FAcceptRanges;
        property MultiThreaded   : Boolean           read  FMultiThreaded
                                                     write SetMultiThreaded;
        property RequestVer       : String           read  FRequestVer
                                                     write SetRequestVer;
        property FollowRelocation : Boolean          read  FFollowRelocation   {TED}
                                                     write FFollowRelocation;  {TED}
        property LocationChangeMaxCount: integer     read  FLocationChangeMaxCount   {  V1.90 }
                                                     write FLocationChangeMaxCount ;
        property LocationChangeCurCount: integer     read FLocationChangeCurCount ;  {  V1.90 }
        property OnLocationChangeExceeded: TLocationChangeExceeded
                                                     read FOnLocationChangeExceeded  {  V1.90 }
                                                     write FOnLocationChangeExceeded ;
{ ServerAuth and ProxyAuth properties are still experimental. They are likely
  to change in the future. If you use them now, be prepared to update your
  code later }
        property ServerAuth       : THttpAuthType    read  FServerAuth
                                                     write FServerAuth;
        property ProxyAuth        : THttpAuthType    read  FProxyAuth
                                                     write FProxyAuth;
{$IFDEF UseContentCoding}
        property Options          : THttpCliOptions  read  GetOptions
                                                     write SetOptions;
{$ELSE}
        property Options          : THttpCliOptions  read  FOptions
                                                     write FOptions;
{$ENDIF}
        property Timeout            : UINT           read  FTimeout { V7.04 sync only! }
                                                     write FTimeout;
        property OnTrace            : TNotifyEvent   read  FOnTrace
                                                     write FOnTrace;
        property OnSessionConnected : TNotifyEvent   read  FOnSessionConnected
                                                     write FOnSessionConnected;
        property OnHeaderData       : TNotifyEvent   read  FOnHeaderData
                                                     write FOnHeaderData;
        property OnCommand          : TOnCommand     read  FOnCommand
                                                     write FOnCommand;
        property OnHeaderBegin      : TNotifyEvent   read  FOnHeaderBegin
                                                     write FOnHeaderBegin;
        property OnHeaderEnd        : TNotifyEvent   read  FOnHeaderEnd
                                                     write FOnHeaderEnd;
        property OnRequestHeaderBegin : TNotifyEvent read  FOnRequestHeaderBegin
                                                     write FOnRequestHeaderBegin;
        property OnRequestHeaderEnd   : TNotifyEvent read  FOnRequestHeaderEnd
                                                     write FOnRequestHeaderEnd;
        property OnDocBegin      : TNotifyEvent      read  FOnDocBegin
                                                     write FOnDocBegin;
        property OnDocData       : TDocDataEvent     read  FOnDocData
                                                     write FOnDocData;
        property OnDocEnd        : TNotifyEvent      read  FOnDocEnd
                                                     write FOnDocEnd;
        property OnSendBegin     : TNotifyEvent      read  FOnSendBegin
                                                     write FOnSendBegin;
        property OnSendData      : TDocDataEvent     read  FOnSendData
                                                     write FOnSendData;
        property OnSendEnd       : TNotifyEvent      read  FOnSendEnd
                                                     write FOnSendEnd;
        property OnStateChange   : TNotifyEvent      read  FOnStateChange
                                                     write FOnStateChange;
        property OnRequestDone   : THttpRequestDone  read  FOnRequestDone
                                                     write FOnRequestDone;
        property OnLocationChange : TNotifyEvent     read  FOnLocationChange
                                                     write FOnLocationChange;
        property OnCookie         : TCookieRcvdEvent read  FOnCookie
                                                     write FOnCookie;
        property OnDataPush       : TDataAvailable   read  FOnDataPush
                                                     write FOnDataPush;
        property OnDataPush2      : TNotifyEvent     read  FOnDataPush2
                                                     write FOnDataPush2;
        property OnBeforeHeaderSend  : TBeforeHeaderSendEvent
                                                     read  FOnBeforeHeaderSend
                                                     write FOnBeforeHeaderSend;
        property OnBeforeAuth        : THttpBeforeAuthEvent
                                                     read  FOnBeforeAuth
                                                     write FOnBeforeAuth;
        property OnBgException;                                             { V7.11 }
        property SocketErrs          : TSocketErrs    read  FSocketErrs
                                                     write FSocketErrs;      { V8.37 }
        property OnSelectDns         : TSelectDnsEvent
                                                     read  FOnSelectDns
                                                     write FOnSelectDns;     { V8.57 }
    end;

procedure Register;
{ Syntax of an URL: protocol://[user[:password]@]server[:port]/path }
procedure ParseURL(const URL : String;
                   var Proto, User, Pass, Host, Port, Path : String);
function  Posn(const s, t : String; count : Integer) : Integer;
procedure ReplaceExt(var FName : String; const newExt : String);
function  EncodeLine(Encoding : THttpEncoding;
                     SrcData : PChar; Size : Integer):String;
function EncodeStr(Encoding : THttpEncoding; const Value : String) : String;
function RFC1123_Date(aDate : TDateTime) : String;


implementation
uses
  OverbyteIcsUtils;

const
    bin2uue  : String = '`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
    bin2b64  : String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    uue2bin  : String = ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_ ';
    b642bin  : String = '~~~~~~~~~~~^~~~_TUVWXYZ[\]~~~|~~~ !"#$%&''()*+,-./0123456789~~~~~~:;<=>?@ABCDEFGHIJKLMNOPQRS';
    linesize = 45;


    function GetBaseUrl(const Url : String) : String; forward;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Register;
begin
    RegisterComponents('FPiette', [THttpCli]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF VER80}
function TrimRight(Str : String) : String;
var
    i : Integer;
begin
    i := Length(Str);
    while (i > 0) and (Str[i] in [' ', #9]) do
        i := i - 1;
    Result := Copy(Str, 1, i);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TrimLeft(Str : String) : String;
var
    i : Integer;
begin
    if Str[1] <> ' ' then
        Result := Str
    else begin
        i := 1;
        while (i <= Length(Str)) and (Str[i] = ' ') do
            i := i + 1;
        Result := Copy(Str, i, Length(Str) - i + 1);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Trim(Str : String) : String;
begin
    Result := TrimLeft(TrimRight(Str));
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor EHttpException.Create(const Msg : String; ErrCode : Word);
begin
    Inherited Create(Msg);
    ErrorCode := ErrCode;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.MsgHandlersCount : Integer;
begin
    Result := 3 + inherited MsgHandlersCount;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.AllocateMsgHandlers;
begin
    inherited AllocateMsgHandlers;
    FMsg_WM_HTTP_REQUEST_DONE := FWndHandler.AllocateMsgHandler(Self);
    FMsg_WM_HTTP_SET_READY    := FWndHandler.AllocateMsgHandler(Self);
    FMsg_WM_HTTP_LOGIN        := FWndHandler.AllocateMsgHandler(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.FreeMsgHandlers;
begin
    if Assigned(FWndHandler) then begin
        FWndHandler.UnregisterMessage(FMsg_WM_HTTP_REQUEST_DONE);
        FWndHandler.UnregisterMessage(FMsg_WM_HTTP_SET_READY);
        FWndHandler.UnregisterMessage(FMsg_WM_HTTP_LOGIN);
    end;
    inherited FreeMsgHandlers;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF VER80}
procedure SetLength(var S: string; NewLength: Integer);
begin
    S[0] := chr(NewLength);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ We cannot use Delphi own function because the date must be specified in   }
{ english and Delphi use the current language.                              }
function RFC1123_Date(aDate : TDateTime) : String;
const
   StrWeekDay : String = 'MonTueWedThuFriSatSun';
   StrMonth   : String = 'JanFebMarAprMayJunJulAugSepOctNovDec';
var
   Year, Month, Day       : Word;
   Hour, Min,   Sec, MSec : Word;
   DayOfWeek              : Word;
begin
   DecodeDate(aDate, Year, Month, Day);
   DecodeTime(aDate, Hour, Min,   Sec, MSec);
   DayOfWeek := ((Trunc(aDate) - 2) mod 7);
   Result := Copy(StrWeekDay, 1 + DayOfWeek * 3, 3) + ', ' +
             Format('%2.2d %s %4.4d %2.2d:%2.2d:%2.2d',
                    [Day, Copy(StrMonth, 1 + 3 * (Month - 1), 3),
                     Year, Hour, Min, Sec]);
end;

{$IFDEF NOFORMS}
{ This function is a callback function. It means that it is called by       }
{ windows. This is the very low level message handler procedure setup to    }
{ handle the message sent by windows (winsock) to handle messages.          }
function HTTPCliWindowProc(
    ahWnd   : HWND;
    auMsg   : Integer;
    awParam : WPARAM;
    alParam : LPARAM): Integer; stdcall;
var
    Obj    : TObject;
    MsgRec : TMessage;
begin
    { At window creation asked windows to store a pointer to our object     }
    Obj := TObject(GetWindowLong(ahWnd, 0));

    { If the pointer doesn't represent a TCustomFtpCli, just call the default procedure}
    if not (Obj is THTTPCli) then
        Result := DefWindowProc(ahWnd, auMsg, awParam, alParam)
    else begin
        { Delphi use a TMessage type to pass parameter to his own kind of   }
        { windows procedure. So we are doing the same...                    }
        MsgRec.Msg    := auMsg;
        MsgRec.wParam := awParam;
        MsgRec.lParam := alParam;
        { May be a try/except around next line is needed. Not sure ! }
        THTTPCli(Obj).WndProc(MsgRec);
        Result := MsgRec.Result;
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.HTTPCliAllocateHWnd(Method: TWndMethod) : HWND;
begin
{$IFDEF NOFORMS}
    Result := XSocketAllocateHWnd(Self);
    SetWindowLong(Result, GWL_WNDPROC, LongInt(@HTTPCliWindowProc));
{$ELSE}
     Result := WSocket.AllocateHWnd(Method);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.HTTPCliDeallocateHWnd(WHandle : HWND);
begin
{$IFDEF NOFORMS}
    XSocketDeallocateHWnd(WHandle);
{$ELSE}
    WSocket.DeallocateHWnd(WHandle);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor THttpCli.Create(AOwner:TComponent);
begin
    inherited Create(AOwner);
    AllocateHWnd;
    FProxyPort                     := DefaultProxyPort;
    FRequestVer                    := '1.0';
    FContentPost                   := 'application/x-www-form-urlencoded';
    FAccept                        := 'image/gif, image/x-xbitmap, ' +
                                      'image/jpeg, image/pjpeg, */*';
    FAgent                         := 'Mozilla/4.0'; { V8.04 removed (compatible; ICS) which upset some servers  }
    FDoAuthor                      := TStringlist.Create;
    FRcvdHeader                    := TStringList.Create;
    FExtraHeaders                  := TStringList.Create;      { V8.52 }
    FReqStream                     := TMemoryStream.Create;
    FState                         := httpReady;
    FLocalAddr                     := ICS_ANY_HOST_V4;
    //FLocalAddr6                    := ICS_ANY_HOST_V6;  { V8.02 }
    FFollowRelocation              := TRUE;      {TT 29 sept 2003}
    //FOnSyncRequestWait             := nil;       { V8.71 JK }

{$IFDEF UseContentCoding}
    FContentCodingHnd              := THttpContCodHandler.Create(@FRcvdStream,
                                                                 TriggerDocData);
    GetOptions;
{$ENDIF}
    CreateSocket;
    //FCtrlSocket.ExceptAbortProc    := AbortComponent; { V7.11 }
    FCtrlSocket.OnSessionClosed    := SocketSessionClosed;
    FCtrlSocket.OnDataAvailable    := SocketDataAvailable;
    FCtrlSocket.OnSessionConnected := SocketSessionConnected;
    FCtrlSocket.OnDataSent         := SocketDataSent;
    FCtrlSocket.OnDnsLookupDone    := SocketDNSLookupDone;
    //FCtrlSocket.OnSocksError       := DoSocksError;
    //FCtrlSocket.OnSocksConnected   := DoSocksConnected;
    //FCtrlSocket.OnSocksAuthState   := DoSocksAuthState;   { V8.51 }
   { V8.37 don't suppress socket exceptions unless we handle them }
    if Assigned (FOnSocketError) then
        FCtrlSocket.OnError        := SocketErrorTransfer;
    FLocationChangeMaxCount        := 5;  {  V1.90 }
    FLocationChangeCurCount        := 0;  {  V1.90 }
    FTimeOut                       := 30;  { Seconds }
    FLastAddrOK                    := '';     { V8.60 }
    FCurrDnsResult                 := -1;     { V8.60 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor THttpCli.Destroy;
begin
    try       { V8.71 JK ensure inherited destroy called, check assigned before free }
        if Assigned(FDoAuthor) then
            FreeAndNil(FDoAuthor);
        if Assigned(FCtrlSocket) then
            FreeAndNil(FCtrlSocket);
        //if Assigned(FAlpnProtoList) then
            //FreeAndNil(FAlpnProtoList);     { V8.62 }
        if Assigned(FRcvdHeader) then
            FreeAndNil(FRcvdHeader);
        if Assigned(FExtraHeaders) then
            FreeAndNil(FExtraHeaders);      { V8.52 }
        if Assigned(FReqStream) then
            FreeAndNil(FReqStream);
        SetLength(FReceiveBuffer, 0);   {AG 03/18/07}
        SetLength(FSendBuffer, 0);      {AG 03/18/07}
{$IFDEF UseContentCoding}
        if Assigned(FContentCodingHnd) then
            FreeAndNil(FContentCodingHnd);
{$ENDIF}
{$IFDEF USE_NTLM_AUTH}
        if Assigned(FAuthNtlmSession) then
            FreeAndNil(FAuthNtlmSession);  // V8.61
{$ENDIF}
    finally
        inherited Destroy;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.CreateSocket;
begin
    FCtrlSocket := TWSocket.Create(nil);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WndProc(var MsgRec: TMessage);
begin
    try { V7.11 }
        with MsgRec do begin
            if Msg = FMsg_WM_HTTP_REQUEST_DONE then
                WMHttpRequestDone(MsgRec)
            else if Msg = FMsg_WM_HTTP_SET_READY then
                WMHttpSetReady(MsgRec)
            else if Msg = FMsg_WM_HTTP_LOGIN then
                WMHttpLogin(MsgRec)
            else
                inherited WndProc(MsgRec);
        end;
    except { V7.11 }
        on E: Exception do
            HandleBackGroundException(E);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketErrorTransfer(Sender : TObject);
begin
    if (assigned(FOnSocketError)) then
        FOnSocketError(Self);  { Substitute Self for subcomponent's Sender. }
end;  { SocketErrorTransfer }


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetMultiThreaded(const Value : Boolean);
begin
    if Assigned(FCtrlSocket) then
        FCtrlSocket.MultiThreaded := Value;
    inherited SetMultiThreaded(Value);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetReady;
begin
    PostMessage(Handle, FMsg_WM_HTTP_SET_READY, 0, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetExtraHeaders(Value : TStrings);    { V8.52 }
begin
    FExtraHeaders.Assign(Value);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.FindAuthType(AType: THttpAuthType): Integer;   { V8.69 find record with required authentication type }
begin
    Result := -1;
    //if  Length(FWWWAuthInfos) = 0 then Exit;
    //for Result := 0 to Length(FWWWAuthInfos) - 1 do begin
        //if FWWWAuthInfos[Result].AuthType = AType then Exit;
    //end;
    //Result := -1;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.StateChange(NewState : THttpState);
var
    FlgClean : Boolean;
    SaveDoc, S: String;
    I, J: Integer;
begin
    if FState <> NewState then begin
        FState := NewState;
        TriggerStateChange;
        if (NewState = httpReady) then begin
            TriggerRequestDone;
            ElaborateBasicAuth;

            FlgClean := False;
            if PrepareBasicAuth(FlgClean) then begin
                if FStatusCode = 401 then begin
                    { If the connection will be closed or is already closed
                      then check if we must repeat a proxy authentication,
                      otherwise we must clear it }
                    if FCloseReq or (FCtrlSocket.State = wsClosed) then begin
                        if FProxyAuthBasicState = basicDone then
                            FProxyAuthBasicState := basicMsg1;
                    end
                    else begin
                        if FProxyAuthBasicState < basicDone then
                            FProxyAuthBasicState := basicNone;
                    end;
                end;

                if FlgClean then begin
                    CleanupRcvdStream; { What we are received must be removed }
                    CleanupSendStream;
                    FReceiveLen       := 0;
                    SaveDoc           := FDocName;
                    InternalClear;
                    FDocName          := SaveDoc;
                end;
            end
            else
                TriggerRequestDone;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerStateChange;
begin
    if Assigned(FOnStateChange) then
        FOnStateChange(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerCookie(const Data : String; var bAccept : Boolean);
begin
    if Assigned(FOnCookie) then
        FOnCookie(Self, Data, bAccept);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSessionConnected;
begin
    if Assigned(FOnSessionConnected) then
        FOnSessionConnected(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSessionClosed;
begin
    if Assigned(FOnSessionClosed) then
        FOnSessionClosed(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerDocBegin;
begin
    if Assigned(FOnDocBegin) then
        FOnDocBegin(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerDocEnd;
begin
    if Assigned(FOnDocEnd) then
        FOnDocEnd(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerDocData(
    Data : Pointer;
    Len : Integer);
begin
    if Assigned(FOnDocData) then
        FOnDocData(Self, Data, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSendBegin;
begin
    if Assigned(FOnSendBegin) then
        FOnSendBegin(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSendEnd;
begin
    if Assigned(FOnSendEnd) then
        FOnSendEnd(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSendData(
    Data : Pointer;
    Len  : Integer);
begin
    if Assigned(FOnSendData) then
        FOnSendData(Self, Data, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerHeaderBegin;
begin
    FHeaderEndFlag := TRUE;
    if Assigned(FOnHeaderBegin) then
        FOnHeaderBegin(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerHeaderEnd;
begin
    FHeaderEndFlag := FALSE;
    if Assigned(FOnHeaderEnd) then
        FOnHeaderEnd(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.71 JK called before header processing, so they can be changed or logged.}
procedure THttpCli.TriggerHeaderFieldData(var AHeaderField, AHeaderData: String);
begin
//  add your own code in overriden method, see OverbyteIcsWebSocketCli.pas
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerBeforeHeaderSend(
    const Method : String;
    Headers      : TStrings);
begin
    if Assigned(FOnBeforeHeaderSend) then
        FOnBeforeHeaderSend(Self, Method, Headers);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerRequestHeaderBegin;
begin
    if Assigned(FOnRequestHeaderBegin) then
        FOnRequestHeaderBegin(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerRequestHeaderEnd;
begin
    if Assigned(FOnRequestHeaderEnd) then
        FOnRequestHeaderEnd(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.ElaborateBasicAuth;
begin
    { if you place this code in GetHeaderLineNext, not each time will be }
    { called ...                                                         }
    if (FAuthBasicState = basicMsg1) and (FStatusCode <> 401) and (FStatusCode <> 407) then
        FAuthBasicState := basicDone
    else if (FAuthBasicState = basicDone) and (FStatusCode = 401) then
        FAuthBasicState := basicNone;

    if (FProxyAuthBasicState = basicMsg1) and (FStatusCode <> 407) then
        FProxyAuthBasicState := basicDone
    else if (FProxyAuthBasicState = basicDone) and (FStatusCode = 407) then begin
        { if we lost proxy authenticated line, most probaly we lost also }
        { the authenticated line of Proxy to HTTP server, so reset the   }
        { Basic state of HTTP also to none                                }
        FProxyAuthBasicState := basicNone;
        { FAuthBasicState      := basicNone; }   { Removed by *ML* on May 02, 2005 }
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.PrepareBasicAuth(var FlgClean : Boolean) : Boolean;
var
    WAI: Integer;
begin
    { this flag can tell if we proceed with OnRequestDone or will try to authenticate   }
    Result := FALSE;
    WAI := FindAuthType(httpAuthBasic);   { V8.69 find authorisation information }
    if WAI < 0 then Exit;
    if (httpoNoBasicAuth in FOptions) and
       (((FStatusCode = 401) and (FServerAuth = httpAuthBasic)) or
       ((FStatusCode = 407) and (FProxyAuth = httpAuthBasic))) then
        Exit;

    if (FStatusCode = 401) and { (FDoAuthor.Count > 0) and }
{$IFDEF UseNTLMAuthentication}
       (FAuthNTLMState = ntlmNone) and
{$ENDIF}
{$IFDEF UseDigestAuthentication}
       (FAuthDigestState = digestNone) and
{$ENDIF}
       (FCurrUserName <> '') and (FCurrPassword <> '') then begin
        { We can handle authorization }

     { V8.69 used parsed headers from WWWAuthInfos instead of enumerating FDoAuthor.Strings }
        Result := TRUE;
        //if Assigned(FOnBeforeAuth) then
            //FOnBeforeAuth(Self, httpAuthBasic, TRUE, WWWAuthInfos[WAI].Header, Result);
        if Result then begin
            StartAuthBasic;
            if FAuthBasicState in [basicMsg1] then
                FlgClean := True;
        end;
    end
    else if (FStatusCode = 407) and { (FDoAuthor.Count > 0) and  }
{$IFDEF UseNTLMAuthentication}
        (FProxyAuthNTLMState = ntlmNone) and
{$ENDIF}
{$IFDEF UseDigestAuthentication}
        (FProxyAuthDigestState = digestNone) and
{$ENDIF}
        (FProxyUsername <> '') and (FProxyPassword <> '') then begin
        { We can handle authorization }

     { V8.69 used parsed headers from WWWAuthInfos instead of enumerating FDoAuthor.Strings }
        Result := TRUE;
        //if Assigned(FOnBeforeAuth) then
            //FOnBeforeAuth(Self, httpAuthBasic, TRUE, WWWAuthInfos[WAI].Header, Result);
        if Result then begin
            StartProxyAuthBasic;
            if FProxyAuthBasicState in [basicMsg1] then
                FlgClean := True;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerRequestDone;
begin
    PostMessage(Handle, FMsg_WM_HTTP_REQUEST_DONE, 0, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerRequestDone2;  { V8.61 so we can override it }
begin
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'RequestDone');
{$ENDIF}
    if Assigned(FOnRequestDone) then
        FOnRequestDone(Self, FRequestType, FRequestDoneError);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WMHttpRequestDone(var msg: TMessage);
begin
   TriggerRequestDone2;  { V8.61 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerCommand(var S: String);  { V8.61 }
begin
    if Assigned(FOnCommand) then
        FOnCommand(Self, S);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerHeaderData;   { V8.61 }
begin
    if Assigned(FOnHeaderData) then
        FOnHeaderData(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerLocationChange;  { V8.61 }
begin
    if Assigned(FOnLocationChange) then
         FOnLocationChange(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WMHttpSetReady(var msg: TMessage);
begin
    StateChange(httpReady);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure ReplaceExt(var FName : String; const newExt : String);
var
    I : Integer;
begin
    I := Posn('.', FName, -1);
    if I <= 0 then
        FName := FName + '.' + newExt
    else
        FName := Copy(FName, 1, I) + newExt;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.Abort;
var
    bFlag : Boolean;
    Msg   : TMessage;
begin
    FLocationFlag := FALSE;  { Do not follow relocations V7.10 }
    { The following two lines prevent OnRequestDone from trigger twice V7.10 }
    FRcvdCount    := 0;      { Clear the receive buffer V7.10 }
    FReceiveLen   := 0;      { Clear the receive buffer V7.10 }

    if FState = httpReady then begin
        FState := httpAborting;
        if FCtrlSocket.State <> wsClosed then begin
            FReasonPhrase := 'Not Closed While Ready, Aborted' ;    { V8.68 }
            FCtrlSocket.Abort;
        end;
        FReasonPhrase := 'OK' ;
        FStatusCode       := 200;
        FRequestDoneError := httperrNoError;
        FState            := httpReady;
        TriggerStateChange;
        WMHttpRequestDone(Msg);   { Synchronous operation ! }
        Exit;
    end;

    bFlag := (FState = httpDnsLookup);
    StateChange(httpAborting);

    if bFlag then begin
        try
            FCtrlSocket.CancelDnsLookup;
        except
            { Ignore any exception }
        end;
    end;

    FStatusCode       := 404;
    if FReasonPhrase = '' then  { V8.55 may have SSL handshake error }
        FReasonPhrase := 'Connection aborted on request';

  { V8.65 may have RequestDoneError already }
    if FRequestDoneError = httperrNoError then
        FRequestDoneError := httperrAborted;

    if bFlag then
        SocketSessionClosed(Self, 0)
    else
        FCtrlSocket.Close;
    StateChange(httpReady);  { 13/02/99 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.AbortComponent(E:Exception);    { V8.68 added E to allow reporting }
begin
    try
  { V8.65 try and provide better RequestDoneError than simple abort }
        FReasonPhrase := 'Abort on Exception: ' + IcsGetExceptMess(E);    { V8.68 }
        if E.ClassType = EOutOfMemory then
            FRequestDoneError := httperrOutOfMemory
        else
            FRequestDoneError := httperrBgException;
        Abort;
    except
    end;
    inherited;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.Login;
begin
    FWMLoginQueued := FALSE;
    FStatusCode    := 0;
    FLocationFlag  := False;
    FReasonPhrase  := '';  { V8.55 }

    FCtrlSocket.OnSessionClosed := SocketSessionClosed;

    if FCtrlSocket.State = wsConnected then begin
        SocketSessionConnected(nil, 0);
        Exit;
    end;

    FDnsResult := '';
    FPunyCodeHost := '';  { V8.65 }
    StateChange(httpDnsLookup);
    FCtrlSocket.LocalAddr := FLocalAddr; {bb}
    FCtrlSocket.SocketErrs := FSocketErrs;        { V8.37 }
    try
        FCtrlSocket.Addr := FHostName;   { Unicode}
        FCtrlSocket.DnsLookup(FHostName);
    except
        on E: Exception do begin
            FStatusCode   := 404;
            FReasonPhrase := E.Message;
            FConnected    := FALSE;
            StateChange(httpReady);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DoBeforeConnect;
begin
    FCtrlSocket.Addr                := FDnsResult; { V8.51 for SOCKS5 may be host name }
    FCtrlSocket.LocalAddr           := FLocalAddr; {bb}
    //FCtrlSocket.LocalAddr6          := FLocalAddr6;  { V8.02 }
    FCtrlSocket.Port                := FPort;
    FCtrlSocket.Proto               := 'tcp';
(*
    FCtrlSocket.SocksServer         := FSocksServer;
    if FSocksLevel <> '' then                        { V8.37 don't set blank }
        FCtrlSocket.SocksLevel      := FSocksLevel;
    FCtrlSocket.SocksPort           := FSocksPort;
    FCtrlSocket.SocksUsercode       := FSocksUsercode;
    FCtrlSocket.SocksPassword       := FSocksPassword;
    FCtrlSocket.SocksAuthentication := FSocksAuthentication;
*)
    FCtrlSocket.SocketErrs          := FSocketErrs;        { V8.37 }
    FReceiveLen                     := 0; { Clear the receive buffer V7.10 }
{$IFDEF BUILTIN_THROTTLE}
    if httpoBandwidthControl in FOptions then begin
        FCtrlSocket.BandwidthLimit     := FBandwidthLimit;
        FCtrlSocket.BandwidthSampling  := FBandwidthSampling;
    end
    else
        FCtrlSocket.BandwidthLimit := 0;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketDNSLookupDone(Sender: TObject; ErrCode: Word);
var
    I: Integer;
begin
    {if FPunyCodeHost = '' then}        // only first connection
    FPunyCodeHost := FCtrlSocket.PunyCodeHost;   { V8.65 each new lookup }
    if ErrCode <> 0 then begin
        if FState = httpAborting then
            Exit;
        FRequestDoneError := ErrCode;
        FStatusCode       := 404;
        FReasonPhrase     := 'can''t resolve hostname to IP address';
        SocketSessionClosed(Sender, ErrCode);
    end
    else begin
//        if (FSocksServer = '') or (FSocksLevel = '4') then
        begin  { V8.51 socks5 takes host name }
        { V8.57 allow application to change DnsResult to one of the several offered, round robin or IPV4/IPV6 }
            if Assigned(FOnSelectDns) then begin
                FDnsResult := FCtrlSocket.DnsResult;
                FOnSelectDns(Self, FCtrlSocket.DnsResultList, FDnsResult);
            end
            else begin

              { V8.60 DNS lookup may return multiple IP addrese, round robin through
                them trying each on multiple retries.  Addresses taken consecutively
                from DnsResultList unless FLastAddrOK has been set on a successful
                connect, when it will re-used for the next attempt if still in
                DnsResultList.  Loop to start again when all addresses tried.  }

                FTotDnsResult := FCtrlSocket.DnsResultList.Count;
                if (FTotDnsResult <= 0) then Exit;  { sanity check }

              { single DNS result, nothing more to do }
                if (FTotDnsResult = 1) then
                    FDnsResult := FCtrlSocket.DnsResult
                else begin
                  { if last succesaful IP address in list of results, use it again }
                    FDnsResult := '';
                    if (FLastAddrOK <> '') then begin
                        for I := 0 to FTotDnsResult - 1 do begin
                            if FLastAddrOK = FCtrlSocket.DnsResultList[I] then begin
                                FCurrDnsResult := I;
                                FDnsResult := FLastAddrOK;
        {$IFNDEF NO_DEBUG_LOG}
                                if CheckLogOptions(loProtSpecInfo) then
                                    DebugLog(loProtSpecInfo, 'Reusing Last OK Address: ' + FLastAddrOK);
        {$ENDIF}
                                break;
                            end;
                        end;
                    end;

                  { not found it, find next, loop to start if gone past last }
                    if FDnsResult = '' then begin
                        inc (FCurrDnsResult);
                        if (FCurrDnsResult >= FTotDnsResult) then
                            FCurrDnsResult := 0;
                        FDnsResult := FCtrlSocket.DnsResultList[FCurrDnsResult];
        {$IFNDEF NO_DEBUG_LOG}
                        if CheckLogOptions(loProtSpecInfo) then
                            DebugLog(loProtSpecInfo, 'Alternate Address: ' + FDnsResult);
        {$ENDIF}
                    end;
                end;
            end;
        end;
        //else
            //FDnsResult := FHostName;
        StateChange(httpDnsLookupDone);  { 19/09/98 }

        DoBeforeConnect;
        FCurrentHost          := FHostName;
        FCurrentPort          := FPort;
        FCurrentProtocol      := FProtocol;
        if NOT IsKnownProtocol(FProtocol) then begin                               { V8.71 JK }
            FRequestDoneError := FCtrlSocket.LastError;
            FStatusCode       := 501;
            FReasonPhrase     := 'Protocol "' + FProtocol + '" not implemented';
            FCtrlSocket.Close;
            SocketSessionClosed(Sender, FCtrlSocket.LastError);
            Exit;
        end;
    { 05/02/2005 end }

        try
            FCtrlSocket.Connect;
        except
            FRequestDoneError := FCtrlSocket.LastError;
            FStatusCode       := 404;
            FReasonPhrase     := 'can''t connect: ' +
                                 WSocketErrorMsgFromErrorCode(FCtrlSocket.LastError) +  { V8.51 handles proxy errors }
                              {   WSocketErrorDesc(FCtrlSocket.LastError) +  }
                                 ' (Error #' + IntToStr(FCtrlSocket.LastError) + ')';
            FCtrlSocket.Close;
            SocketSessionClosed(Sender, FCtrlSocket.LastError);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketSessionConnected(Sender : TObject; ErrCode : Word);

    procedure InitStartSend;      { V8.71 commonize code }
    begin
    {$IFDEF UseNTLMAuthentication}
        if not ((FAuthNTLMState = ntlmMsg1) or (FProxyAuthNTLMState = ntlmMsg1)) then begin
            TriggerSendBegin;
            FAllowedToSend := TRUE;
            FDelaySetReady := FALSE;     { 09/26/08 ML }
            SocketDataSent(FCtrlSocket, 0);
        end;
    {$ELSE}
        TriggerSendBegin;
        FAllowedToSend := TRUE;
        FDelaySetReady := FALSE;     { 09/26/08 ML }
        SocketDataSent(FCtrlSocket, 0);
    {$ENDIF}
    end;

begin
    FAddrResolvedStr := FCtrlSocket.AddrResolvedStr; { V8.66 keep it before socket closes }
    if ErrCode <> 0 then begin
        FRequestDoneError := ErrCode;
        FStatusCode := 404;
        FReasonPhrase := WSocketErrorMsgFromErrorCode(ErrCode) +  { V8.51 handles proxy errors }
                          ' (Error #' + IntToStr(ErrCode) + ') to ' + IcsFmtIpv6AddrPort(FAddrResolvedStr, FPort);  { V8.60 }
        FLastAddrOK := '';  { V8.60 }
        TriggerSessionConnected; {14/12/2003}
        Exit;
    end;

    FLocationFlag := FALSE;

    FConnected := TRUE;
    FLastAddrOK := FAddrResolvedStr;  { V8.60 }
    StateChange(httpConnected);
    TriggerSessionConnected;

    FNext := GetHeaderLineNext;
    StateChange(httpWaitingHeader);

    try
        case FRequestType of
        httpPOST:
            begin
                    SendRequest('POST', FRequestVer);
                    InitStartSend;                    { V8.71 commonize code }
            end;
        httpHEAD:
            begin
                SendRequest('HEAD', FRequestVer);
            end;
        httpGET:
            begin
                SendRequest('GET', FRequestVer);
                 { V8.71 GET can have a content body }
                 { beware SendStream should be nil if there is no content }
                    if (httpoGetContent in FOptions) and Assigned(SendStream) then
                      InitStartSend;                    { V8.71 commonize code }
            end;
        end;
    except
        Logout;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.Logout;
begin
    FCtrlSocket.Close;
    FConnected := FALSE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SendCommand(const Cmd : String);
const
    CRLF : String[2] = #13#10;
var
    Buf : String;
begin
    Buf := Cmd;
    TriggerCommand(Buf);  { V8.61 }
    if Length(Buf) > 0 then
        FReqStream.Write(Buf[1], Length(Buf));
    FReqStream.Write(CRLF[1], 2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SendRequest(const Method, Version: String);
var
    Headers : TStrings;
    N       : Integer;
    AHost   : String;
begin
    Headers := TStringList.Create;
    try
        FReqStream.Clear;
        TriggerRequestHeaderBegin;
     { V8.64 needs A-Label punycode for Host: not Unicode }
        AHost := IcsIDNAToASCII(IcsTrim(FTargetHost));
        SendCommand(method + ' ' + FPath + ' HTTP/' + Version);
        if FSender <> '' then
            SendCommand('From: ' + FSender);
{SendCommand('Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*'); }
        if FAccept <> '' then
            SendCommand('Accept: ' + FAccept);
            if FReference <> '' then
                SendCommand('Referer: ' + FReference);
{SendCommand('Accept-Language: fr, en'); }
    if (method = 'POST') and (FContentPost <> '') then
        SendCommand('Content-Type: ' + FContentPost);
{SendCommand('UA-pixels: 1024x768'); }
{SendCommand('UA-color: color8'); }
{SendCommand('UA-OS: Windows 95'); }
{SendCommand('UA-CPU: x86'); }
{SendCommand('User-Agent: Mozilla/3.0 (compatible)');} {; MSIE 3.01; Update a; Windows 95)');}
    if FAgent <> '' then
        SendCommand('User-Agent: ' + FAgent);
    SendCommand('Host: ' + FTargetHost);
    if FNoCache then
        SendCommand('Pragma: no-cache');
    if method = 'POST' then
        SendCommand('Content-Length: ' + IntToStr(SendStream.Size));
    if FModifiedSince <> 0 then
        SendCommand('If-Modified-Since: ' +
                    RFC1123_Date(FModifiedSince) + ' GMT');
    if FUsername <> '' then
        SendCommand('Authorization: Basic ' +
                    EncodeStr(encBase64, FUsername + ':' + FPassword));
    if (FProxy <> '') and (FProxyUsername <> '') then
        SendCommand('Proxy-Authorization: Basic ' +
                    EncodeStr(encBase64, FProxyUsername + ':' + FProxyPassword));
{SendCommand('Proxy-Connection: Keep-Alive'); }
    if FCookie <> '' then
        SendCommand('Cookie: ' + FCookie);
    if (FContentRangeBegin <> '') or (FContentRangeEnd <> '') then begin            {JMR!! Added this line!!!}
        SendCommand('Range: bytes=' + FContentRangeBegin + '-' + FContentRangeEnd); {JMR!! Added this line!!!}
      FContentRangeBegin := '';                                                     {JMR!! Added this line!!!}
      FContentRangeEnd   := '';                                                     {JMR!! Added this line!!!}
    end;                                                                            {JMR!! Added this line!!!}
    FAcceptRanges := '';

        TriggerRequestHeaderEnd;
        SendCommand('');
        FCtrlSocket.Send(FReqStream.Memory, FReqStream.Size);
        FReqStream.Clear;
    finally
        Headers.Free;
    {$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'SendRequest Done');
    {$ENDIF}
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.GetBodyLineNext;
var
//  P    : PChar;
    P    : Integer; // (FP 09/09/06)
    N, K : THttpBigInt;
begin
    if NOT FBodyStartedFlag then begin   { V8.67 was FBodyLineCount }
        FBodyStartedFlag := True;
        FChunkLength := 0;
        FChunkRcvd   := 0;
        FChunkState  := httpChunkGetSize;
        TriggerDocBegin;
{$IFDEF UseContentCoding}
        FContentCodingHnd.Prepare(FContentEncoding);
        if Assigned(FRcvdStream) then
            FRcvdStreamStartSize := FRcvdStream.Size
        else
            FRcvdStreamStartSize := 0;
{$ENDIF}
    end;
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
        DebugLog(loProtSpecInfo, 'GetBodyLineNext FBodyDataLen=' + IntToStr(FBodyDataLen));
{$ENDIF}
    if FTransferEncoding = 'chunked' then begin
// RFC-2616 3.6.1 Chunked Transfer Coding
//      Chunked-Body    = *chunk
//                        last-chunk
//                        trailer
//                        CRLF
//
//      chunk           = chunk-size [ chunk-extension ] CRLF
//                        chunk-data CRLF
//      chunk-size      = 1*HEX
//      last-chunk      = 1*("0") [ chunk-extension ] CRLF
//
//      chunk-extension = *( ";" chunk-ext-name [ "=" chunk-ext-val ] )
//      chunk-ext-name  = token
//      chunk-ext-val   = token | quoted-string
//      chunk-data      = chunk-size(OCTET)
//      trailer         = *(entity-header CRLF)
        P := FBodyData;
        N := FBodyDataLen;
        while (N > 0) and (FChunkState <> httpChunkDone) do begin
            if FChunkState = httpChunkGetSize then begin
                while N > 0 do begin
//                  if not IsXDigit(P^) then begin
                    if not IsXDigit(AnsiChar(FReceiveBuffer[P])) then begin  // (FP 09/09/06)
                        FChunkState := httpChunkGetExt;
                        {$IFNDEF NO_DEBUG_LOG}
                        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
                            DebugLog(loProtSpecInfo, 'ChunkLength = ' + IntToStr(FChunkLength));
                        {$ENDIF}
                        break;
                    end;
//                  FChunkLength := FChunkLength * 16 + XDigit(P^);
                    FChunkLength := FChunkLength * 16 + XDigit(AnsiChar(FReceiveBuffer[P]));  // (FP 09/09/06)
                    Inc(P);
                    Dec(N);
                end;
            end;
            if FChunkState = httpChunkGetExt then begin
                { Here we simply ignore until next LF }
                while N > 0 do begin
//                  if P^ = #10 then begin
                    if Ord(FReceiveBuffer[P]) = 10 then begin // FP 09/09/06
                        if FChunkLength = 0 then              // AG V7.18
                            FChunkState := httpChunkDone      // AG V7.18
                        else                                  // AG V7.18
                            FChunkState := httpChunkGetData;
                        Inc(P);
                        Dec(N);
                        break;
                    end;
                    Inc(P);
                    Dec(N);
                end;
            end;
            if FChunkState = httpChunkGetData then begin
                K := FChunkLength - FChunkRcvd;
                if K > N then
                    K := N;
                if K > 0 then begin
                    N := N - K;
                    FRcvdCount := FRcvdCount + K;
                    FChunkRcvd := FChunkRcvd + K;
                {$IFDEF UseContentCoding}
                    FContentCodingHnd.WriteBuffer(@FReceiveBuffer[P], K);   // FP 09/09/06
                {$ELSE}
                    if Assigned(FRcvdStream) then
                        FRcvdStream.WriteBuffer(FReceiveBuffer[P], K);
                    TriggerDocData(@FReceiveBuffer[P], K);
                {$ENDIF}
                    P := P + K;
                end;
                if FChunkRcvd >= FChunkLength then
                    FChunkState := httpChunkSkipDataEnd;
            end;
            if FChunkState = httpChunkSkipDataEnd then begin
                while N > 0 do begin
                    if Ord(FReceiveBuffer[P]) = 10 then begin  // FP 09/09/06
                        if FChunkLength = 0 then
                            { Last chunk is a chunk with length = 0 }
                            FChunkState  := httpChunkDone
                        else
                            FChunkState  := httpChunkGetSize;
                        FChunkLength := 0;
                        FChunkRcvd   := 0;
                        Inc(P);
                        Dec(N);
                        break;
                    end;
                    Inc(P);
                    Dec(N);
                end;
            end;
        end;
        if FChunkState = httpChunkDone then begin
{$IFNDEF NO_DEBUG_LOG}
            if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
                DebugLog(loProtSpecInfo, 'httpChunkDone, end of document');
{$ENDIF}
            FBodyStartedFlag := False;  { V8.67 was FBodyLineCount }
            FNext          := nil;
            StateChange(httpBodyReceived);
            TriggerDocEnd;
            if (FCloseReq) then     { SAE 01/06/04 }
                FCtrlSocket.CloseDelayed
        end;
    end
    else begin
        if FBodyDataLen > 0 then begin
            FRcvdCount := FRcvdCount + FBodyDataLen;
{$IFDEF UseContentCoding}
            FContentCodingHnd.WriteBuffer(@FReceiveBuffer[FBodyData], FBodyDataLen); // FP 09/09/06
{$ELSE}
            if Assigned(FRcvdStream) then
                FRcvdStream.WriteBuffer(FReceiveBuffer[FBodyData], FBodyDataLen);
            TriggerDocData(@FReceiveBuffer[FBodyData], FBodyDataLen);
{$ENDIF}
        end;

        if FRcvdCount = FContentLength then begin
            { End of document }
{$IFNDEF NO_DEBUG_LOG}
            if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
                DebugLog(loProtSpecInfo, 'End of document');
{$ENDIF}
            FBodyStartedFlag := False;   { V8.67 was FBodyLineCount }
            FNext          := nil;
            StateChange(httpBodyReceived);
            TriggerDocEnd;
            if {(FResponseVer = '1.0') or (FRequestVer = '1.0') or  }
                { see above                                }
                { [rawbite 31.08.2004 Connection controll] }
                (FCloseReq) then     { SAE 01/06/04 }
                FCtrlSocket.CloseDelayed
            else if not FLocationFlag then
                CheckDelaySetReady;  { 09/26/08 ML }
        end;
    end;
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'GetBodyLineNext end');
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.GetHeaderLineNext;
var
    proto   : String;
    user    : String;
    pass    : String;
    port    : String;
    Host    : String;
    Path    : String;
    Field   : String;
    Data    : String;
    nSep    : Integer;
    tmpInt  : LongInt;
    bAccept : Boolean;
    DocExt  : String;


   { V8.67 ensure relocation path has no spaces or fragment/anchor # }
    function EncodePathOnly(const OldPath: String): String;
    var
        I: Integer;
    begin
        Result := OldPath;
        I := Pos('#', OldPath);
        if I > 1 then
           Result := Copy (OldPath, 1, I - 1);
        if Pos(IcsSpace, OldPath) = 0 then Exit;
        Result := StringReplace(OldPath, IcsSpace, '%20', [rfReplaceAll])
    end;

begin
    if FHeaderLineCount = 0 then
        TriggerHeaderBegin
    else if FHeaderLineCount = -1 then   { HTTP/1.1 second header }
        FHeaderLineCount := 0;
    Inc(FHeaderLineCount);

    { Some server send HTML document without header ! I don't know if it is  }
    { legal, but it exists (AltaVista Discovery does that).                  }
    if (FHeaderLineCount =  1)   and
       (FLastResponse    <> '')  and
       (FLastResponse[1] =  '<') and
       (SameText(Copy(FLastResponse, 1, 6), '<HTML>') or
        SameText(Copy(FLastResponse, 1, 9), '<!DOCTYPE')) then begin
        if FContentType = '' then
            FContentType := 'text/html';
        StateChange(httpWaitingBody);
        FNext := GetBodyLineNext;
        TriggerHeaderEnd;
        GetBodyLineNext;
        Exit;
    end;

    if FLastResponse = '' then begin
        if (FResponseVer = '1.1') and (FStatusCode = 100) then begin
            { HTTP/1.1 continue message. A second header follow. I should create an event to give access to this.   }
            FRcvdHeader.Clear;        { Cancel this first header }
            FHeaderLineCount := -1;   { -1 is to remember we went here }
            Exit;
        end;

        TriggerHeaderEnd;  { 28/12/2003 }
        if FState = httpReady then begin    { 05/02/2005 }
            { It is likely that Abort has been called in OnHeaderEnd event }
            FReceiveLen := 0;               { Clear any buffered data }
            Exit;
        end;

        { FContentLength = -1 when server doesn't send a value }
        if ((FContentLength = -1) and            { Added 12/03/2004 }
            (FTransferEncoding <> 'chunked') and { Added 09/10/2006 by FP }
            ((FStatusCode < 200) or              { Added 12/03/2004 }
             (FStatusCode = 204) or              { Added 12/03/2004 }
             (FStatusCode = 301) or              { Added 06/10/2004 }
             (FStatusCode = 302) or              { Added 06/10/2004 }
             (FStatusCode = 304)))               { Added 12/03/2004 }
             or
              (FContentLength = 0)
             or
              (FRequestType = httpHEAD) then begin
            if FCloseReq then begin
                if FLocationFlag then          { Added 16/02/2004 }
                    StartRelocation            { Added 16/02/2004 }
                else begin                     { Added 16/02/2004 }
                    if FRequestType = httpHEAD then begin { Added 23/07/04 }
                        { With HEAD command, we don't expect a document }
                        { but some server send one !                    }
                        FReceiveLen := 0;      { Cancel received data   }
                        StateChange(httpWaitingBody);
                        FNext := nil;
                    end;
                    FCtrlSocket.CloseDelayed;  { Added 10/01/2004 }
                end;
            end
            else begin
                if FLocationFlag then     { V8.67 do before checking HEAD, or get stuck here }
                    StartRelocation
                else begin
                    if FRequestType = httpHEAD then begin            //AG 05/27/08
                        { With HEAD command, we don't expect a document } //AG 05/27/08
                        { but some server send one !                    } //AG 05/27/08
                        FReceiveLen := 0;      { Cancel received data   } //AG 05/27/08
                        StateChange(httpWaitingBody);                     //AG 05/27/08
                        FNext := nil;                                     //AG 05/27/08
                        SetReady;                                         //AG 05/27/08
                    end                                                   //AG 05/27/08
                    else
                        CheckDelaySetReady;  { 09/26/08 ML }
                end;
            end;
            Exit;
        end;
        DocExt := LowerCase(ExtractFileExt(FDocName));
        if (DocExt = '.exe') or (DocExt = '') then begin
            if FContentType = 'text/html' then
                ReplaceExt(FDocName, 'htm');
        end;

        StateChange(httpWaitingBody);
        FNext := GetBodyLineNext;
        if FReceiveLen > 0 then begin
            FBodyData    := 0;  // FP 09/09/06
            if (FContentLength < 0) or
               ((FRcvdCount + FReceiveLen) <= FContentLength) then
                FBodyDataLen := FReceiveLen
            else
                FBodyDataLen := FContentLength - FRcvdCount;  {****}
            GetBodyLineNext;
            FReceiveLen := FReceiveLen - FBodyDataLen;
            { Move remaining data to start of buffer. 17/01/2004 }
            if FReceiveLen > 0 then
                IcsMoveTBytes(FReceiveBuffer, FBodyDataLen, 0, FReceiveLen + 1)
            else if FReceiveLen < 0 then  { V8.03 }
                FReceiveLen := 0;         { V8.03 }
        end;
        if not Assigned(FNext) then begin
            { End of document }
            if FLocationFlag then
                StartRelocation
            else
                CheckDelaySetReady; { 09/26/08 ML }
        end;
        Exit;
    end;

    FRcvdHeader.Add(FLastResponse);

    nSep := Pos(':', FLastResponse);
    if (FHeaderLineCount = 1) then begin
        if (Copy(FLastResponse, 1, 8) = 'HTTP/1.0') or
           (Copy(FLastResponse, 1, 8) = 'HTTP/1.1') then begin
            FResponseVer  := Copy(FLastResponse, 6, 3);
            { Reset the default FCloseReq flag depending on the response 12/29/05 AG }
            if (FRequestVer = '1.1') and (FResponseVer = '1.0') then
                FCloseReq := TRUE
            else begin
                if FRequestVer = '1.0' then
                    FCloseReq := TRUE
                else if FRequestVer = '1.1' then
                    FCloseReq := FALSE;
            end;
       {$IFNDEF NO_DEBUG_LOG}                                           { V1.91 }
            if CheckLogOptions(loProtSpecDump) then begin
                DebugLog(loProtSpecDump, 'FCloseReq=' + IntToStr(Ord(FCloseReq)));
            end;
        {$ENDIF}
            { Changed 12/22/05 AG - M$ Proxy 2.0 invalid status-line ("HTTP/1.0  200") }
            tmpInt := 9;
            while Length(FLastResponse) > tmpInt do begin
                Inc(tmpInt);
                if AnsiChar(FLastResponse[tmpInt]) in ['0'..'9'] then
                    break;
            end;
            FStatusCode   := StrToIntDef(Copy(FLastResponse, tmpInt, 3), 0);  { V8.13 }
            FReasonPhrase := Copy(FLastResponse, tmpInt + 4, Length(FLastResponse));
            { Changed end }
        end
        else begin
            { Received data but not part of a header }
            if Assigned(FOnDataPush2) then
                FOnDataPush2(Self);
        end;
    end
    else if nSep > 0 then begin
        Field := LowerCase(Copy(FLastResponse, 1, nSep - 1));
        { Skip spaces }
        Inc(nSep);
        while (nSep < Length(FLastResponse)) and
              (FLastResponse[nSep] = ' ') do
              Inc(nSep);
        Data  := Copy(FLastResponse, nSep, Length(FLastResponse));

       { V8.71 JK allow raw header modification and logging before processing }
        TriggerHeaderFieldData(Field, Data);
        if Field = 'location' then begin { Change the URL ! }
            { URL with relocations:                 }
            { http://www.webcom.com/~wol2wol/       }
            { http://www.purescience.com/delphi/    }
            { http://www.maintron.com/              }
            { http://www.infoseek.com/AddURL/addurl }
            { http://www.micronpc.com/              }
            { http://www.amazon.com/                }
            { http://count.paycounter.com/?fn=0&si=44860&bt=msie&bv=5&    }
            { co=32&js=1.4&sr=1024x768&re=http://www.thesite.com/you.html }
       { V8.64 Location is A-Label (Punycode ASCII with ACE xn--), leave it alone
           and only convert to Unicode for the read only Location property }
            if Copy(Data, 1, 2) = '//' then         { V7.22 }
                Data := FProtocol + ':' + Data;     { V7.22 }
            if FRequestType in [httpPUT, httpPATCH] then begin   { V8.06 }
                 { Location just tell us where the document has been stored }
                 FLocation := Data;
            end

          { V8.60 201 created means newly created resource }
            else if (StatusCode = 201) then begin
                 FLocation := Data;
            end

          { V8.60 301, 302, 303, 307 and 308 mean relocation to new relative or absolute URL  }
          { ignore 4xx and 5xx responses }
          { NOTE we don't set FLocation if we are actually relocating somewhere, only for data  }
            else if FFollowRelocation and    {TED}
                    (FStatusCode >= 301) and (FStatusCode <= 308) then begin  { V8.60 not for 201 }
                { OK, we have a real relocation !       }
                FLocationFlag := TRUE;
                if Proxy <> '' then begin
                    { We are using a proxy }
                    if Data[1] = '/' then begin
                        { Absolute location }
                        ParseURL(FPath, proto, user, pass, Host, port, Path);
                    { V8.64 need Unicode for SSL }
                        Host := IcsIDNAToUnicode(Host);
                        if Proto = '' then
                            Proto := 'http';
                        FLocation := Proto + '://' + Host + EncodePathOnly(Data);  { V8.67 ensure path is legal without spaces }
                        FPath     := FLocation;

                        if (user <> '') and (pass <> '') then begin
                            { save user and password given in location @@@}
                            FCurrUsername   := user;
                            FCurrPassword   := pass;
                        end;
                    end
                    else if NOT IsKnownProtocolURL(Data)           { V8.71 JK }
                        then begin
                        { Relative location }
                        FPath     := GetBaseUrl(FPath) + EncodePathOnly(Data);  { V8.67 ensure path is legal without spaces }
                        FLocation := FPath;
                    end
                    else begin
                        ParseURL(Data, proto, user, pass, Host, port, Path);
                        Path := EncodePathOnly(Path);  { V8.67 ensure path is legal without spaces }
                    { V8.64 need Unicode for SSL }
                        Host := IcsIDNAToUnicode(Host);
                        if port <> '' then
                            FPort := port
                        else
                            FPort := GetProtocolPort(proto);     { V8.71 JK }

                        if (user <> '') and (pass <> '') then begin
                            { save user and password given in location @@@}
                            FCurrUsername   := user;
                            FCurrPassword   := pass;
                        end;

                        if (Proto <> '') and (Host <> '') then begin
                            { We have a full relocation URL }
                            FTargetHost := Host;
                            if Port <> '' then begin { V8.01 }
                                FLocation := Proto + '://' + Host + ':' + Port + Path;
                                FTargetPort := Port;
                            end
                            else
                                FLocation := Proto + '://' + Host + Path;
                            FPath := FLocation;
                        end
                        else begin
                            if Proto = '' then
                                Proto := 'http';
                            if FPath = '' then
                                FLocation := Proto + '://' + FTargetHost + '/' + Host
                            else if Host = '' then
                                FLocation := Proto + '://' + FTargetHost + FPath
                            else
                                FTargetHost := Host;
                        end;
                    end;
                end
                { We are not using a proxy }
                else begin
                    ParseURL(FURL, proto, user, pass, Host, port, Path); { V7.03 }
                    if Data[1] = '/' then begin
                        { Absolute location }
                        FPath := EncodePathOnly(Data);  { V8.67 ensure path is legal without spaces }
                        if Proto = '' then
                            Proto := 'http';
                        FLocation := Proto + '://' + FHostName + FPath;  { Unicode }
                    end
                    else if NOT IsKnownProtocolURL(Data) then begin        { V8.71 JK }
                        { Relative location }
                        FPath :=  EncodePathOnly(GetBaseUrl(FPath) + Data);  { V8.67 ensure path is legal without spaces }
                        if Proto = '' then
                            Proto := 'http';
                        FLocation := Proto + '://' + FHostName + FPath;
                    end
                    else begin
                        ParseURL(Data, proto, user, pass, FHostName, port, FPath);
                        FPath := EncodePathOnly(FPath);  { V8.67 ensure path is legal without spaces }
                    { V8.64 need Unicode for SSL }
                        FHostName := IcsIDNAToUnicode(FHostName);
                        if port <> '' then
                            FPort := port
                        else
                            FPort := GetProtocolPort(proto);                    { V8.71 JK }

                        FProtocol := Proto;

                        if (user <> '') and (pass <> '') then begin
                            { save user and password given in location @@@}
                            FCurrUsername   := user;
                            FCurrPassword   := pass;
                        end;

                        if (Proto <> '') and (FHostName <> '') then begin
                            { We have a full relocation URL }
                            FTargetHost := FHostName;
                            if FPath = '' then begin
                                FPath := '/';
                                if Port <> '' then begin { V8.01 }
                                    FLocation := Proto + '://' + FHostName + ':' + Port;
                                    FTargetPort := Port;
                                end
                                else
                                    FLocation := Proto + '://' + FHostName;
                            end
                            else begin
                                if Port <> '' then begin { V8.01 }
                                    FLocation := Proto + '://' + FHostName + ':' + Port + FPath;
                                    FTargetPort := Port;
                                end
                                else
                                    FLocation := Proto + '://' + FHostName + FPath;
                            end;
                        end
                        else begin
                            if Proto = '' then
                                Proto := 'http';
                            if FPath = '' then begin
                                FLocation := Proto + '://' + FTargetHost + '/' + FHostName;
                                FHostName := FTargetHost;
                                FPath     := FLocation;          { 26/11/99 }
                            end
                            else if FHostName = '' then begin
                                FLocation := Proto + '://' + FTargetHost + FPath;
                                FHostName := FTargetHost;
                            end
                            else
                                FTargetHost := FHostName;
                        end;
                    end;
                end;
            end;
        end
        else if Field = 'content-length' then
            FContentLength := StrToInt64Def(Trim(Data), -1)
        else if Field = 'transfer-encoding' then
            FTransferEncoding := LowerCase(Data)
        else if Field = 'content-range' then begin                             {JMR!! Added this line!!!}
            tmpInt := Pos('-', Data) + 1;                                      {JMR!! Added this line!!!}
            FContentRangeBegin := Copy(Data, 7, tmpInt-8);                     {JMR!! Added this line!!!}
            FContentRangeEnd   := Copy(Data, tmpInt, Pos('/', Data) - tmpInt); {JMR!! Added this line!!!}
        end                                                                    {JMR!! Added this line!!!}
        else if Field = 'accept-ranges' then
            FAcceptRanges := Data
        else if Field = 'content-type' then
            FContentType := LowerCase(Data)
        else if Field = 'www-authenticate' then
            FDoAuthor.Add(Data)
        else if Field = 'proxy-authenticate' then              { BLD required for proxy NTLM authentication }
            FDoAuthor.Add(Data)
        else if Field = 'set-cookie' then begin
            bAccept := TRUE;
            TriggerCookie(Data, bAccept);
        end
    {   else if Field = 'date' then }
    {   else if Field = 'mime-version' then }
    {   else if Field = 'pragma' then }
    {   else if Field = 'allow' then }
    {   else if Field = 'server' then }
    {   else if Field = 'content-encoding' then }
    {   else if Field = 'expires' then }
    {   else if Field = 'last-modified' then }
   end
   else { Ignore  all other responses }
       ;

   TriggerHeaderData;   { V8.61 }

end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.InternalClear;
begin
    FRcvdHeader.Clear;
    FRequestDoneError := httperrNoError;
    FDocName          := '';
    FStatusCode       := 0;
    FRcvdCount        := 0;
    FReceiveLen       := 0;   { V7.10 }
    FSentCount        := 0;
    FHeaderLineCount  := 0;
    FBodyStartedFlag  := False;   { V8.67 was FBodyLineCount }
    FContentLength    := -1;
    FContentType      := '';  { 25/09/1999 }
    FTransferEncoding := '';  { 28/12/2003 }
{$IFDEF UseContentCoding}
    FContentEncoding  := '';
{$ENDIF}
    FAllowedToSend    := FALSE;
    FDelaySetReady    := FALSE;     { 09/26/08 ML }
    FLocation         := FURL;
    FDoAuthor.Clear;
    { if protocol version is 1.0 then we suppose that the connection must be }
    { closed. If server response will contain a Connection: keep-alive header }
    { we will set it to False.                                                }
    { If protocol version is 1.1 then we suppose that the connection is kept  }
    { alive. If server response will contain a Connection: close  we will set }
    { it to True.                                                             }
    if FRequestVer = '1.0' then
        FCloseReq := TRUE  { SAE 01/06/04 }
    else
        FCloseReq := FALSE { [rawbite 31.08.2004 Connection controll] }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DoRequestAsync(Rq : THttpRequest);
var
    Proto, User, Pass, Host, Port, Path: String;
    I: Integer;
begin
    if (Rq <> httpCLOSE) and (FState <> httpReady) then
        raise EHttpException.Create('HTTP component ' + Name + ' is busy', httperrBusy);

    if (Rq in [httpPOST, httpPUT, httpPATCH]) and    { V8.06 }
       (not Assigned(FSendStream)
       { or (FSendStream.Position = FSendStream.Size)}   { Removed 21/03/05 }
       ) then
        raise EHttpException.Create('HTTP component has nothing to post, put or patch', httpErrNoData);

    if Rq = httpCLOSE then begin
        FStatusCode   := 200;
        FReasonPhrase := 'OK';
        FRequestDoneError := httperrNoError;  { V8.71 JK 21/08/2013 }
        StateChange(httpClosing);
        if FCtrlSocket.State = wsClosed then begin
            FLocationFlag := False;    { 7.23 }
            FRequestType := Rq;        { 7.23 }
            InternalClear;             { 7.23 }
            SetReady;
        end
        else
            FCtrlSocket.CloseDelayed;
        Exit;
    end;

    { Clear all internal state variables }
    FRequestType := Rq;
    InternalClear;

    FCurrUsername        := FUsername;
    FCurrPassword        := FPassword;
    //FCurrConnection      := FConnection;
    //FCurrProxyConnection := FProxyConnection;

    { V8.62 if proxy URL is passed, parse it as proxy properties }
    { http://[user[:password]@]host:port }
    if (Length(FProxyURL) > 6) and (Pos (':', Copy(FProxyURL, 6, 9999)) > 5) then begin
        ParseURL(FProxyURL, Proto, User, Pass, Host, Port, Path);
        { pending, check https for SSL proxy, maybe socks for socks proxy }
        if Proto = 'http' then begin
            FProxy := Host;
            FProxyPort := Port;
            FProxyUsername := User;
            FProxyPassword := Pass;
            if (FProxyUsername <> '') and (FProxyPassword <> '') then
                FProxyAuth := httpAuthBasic;
        end;
    end;

    { Parse url and proxy to FHostName, FPath and FPort }
    if FProxy <> '' then begin
        ParseURL(FURL, Proto, User, Pass, Host, Port, Path);
        FTargetHost := Host;
        FTargetPort := Port;
        if FTargetPort = '' then
            FTargetPort := GetProtocolPort(Proto);        { V8.71 JK }
        FDocName := Path;
        if Path = '' then
            Path := '/';     { V8.69 not allowed blank path }
        if User <> '' then
            FCurrUserName := User;
        if Pass <> '' then
            FCurrPassword := Pass;
        { We need to remove usercode/Password from the URL given to the proxy }
        { but preserve the port                                               }
        if Port <> '' then
            Port := ':' + Port;
      { V8.64 for proxy use complete URL as path, converting IDN host to A-Label }
        Host := IcsIDNAToASCII(Host);
        if Proto = '' then
            FPath := 'http://'+ Host + Port + Path
        else if IcsLowerCase(Proto) = 'https' then
            FPath := Path  { V8.66 using proxy CONNECT command so don't need host and port }
        else
            FPath := Proto + '://' + Host + Port + Path;
        FProtocol := Proto;
        ParseURL(FProxy, Proto, User, Pass, Host, Port, Path);
        if Port = '' then
            Port := ProxyPort;
    end
    else begin
        ParseURL(FURL, Proto, User, Pass, Host, Port, FPath);
        FTargetHost := Host;
        FDocName    := FPath;
        FProtocol   := Proto;
        if User <> '' then
            FCurrUserName := User;
        if Pass <> '' then
            FCurrPassword := Pass;
        if Port = '' then
            Port := GetProtocolPort(Proto);        { V8.71 JK }
        FTargetPort := Port;  {added 11/13/2005 AG}
    end;
    if FProtocol = '' then
        FProtocol := 'http';
    if Proto = '' then
        Proto := 'http';

  { V8.69 remove # fragment anchor from URL, only used by browser }
    if NOT (httpoAllowAnchor in FOptions) then begin
        I := Pos('#', FPath);
        if I > 0 then
            FPath := Copy(FPath, 1, I - 1);
    end;
{    if FPath = '' then
        FPath := '/';   }
    if (Pos('/', FPath) <> 1) and (Pos('http', FPath) <> 1) then    { V9.2 always need / at start of path, V9.3 except absolute }
        FPath := '/' + FPath;
    if (FPath = '/*') and (Rq = httpOPTIONS) then  { V8.09 }
        FPath := '*';

    AdjustDocName;

 { host and port we'll connect to, Unicode }
    FHostName   := Host;
    FPort       := Port;

    FAuthBasicState      := basicNone;
    FProxyAuthBasicState := basicNone;

    if (FProxy <> '') and (FProxyAuth <> httpAuthNone) and
       (FProxyUsername <> '') and (FProxyPassword <> '') then begin
        { If it is still connected there is no need to restart the
          authentication on the proxy }
        if (FCtrlSocket.State = wsConnected)     and
           (FHostName        = FCurrentHost)     and
           (FPort            = FCurrentPort)     and
           (FProtocol        = FCurrentProtocol) then begin
{$IFDEF UseNTLMAuthentication}
            if FProxyAuth <> httpAuthNtlm then begin
                FProxyAuthNTLMState  := ntlmDone;
                if (FRequestVer = '1.0') or (FResponseVer = '1.0') or  // <== 12/29/05 AG
                   (FResponseVer = '') then                            // <== 12/29/05 AG
                    FCurrProxyConnection := 'Keep-alive';
            end
            else
{$ENDIF}
{$IFDEF UseDigestAuthentication}
            if FProxyAuth in [httpAuthDigest, httpAuthDigest2] then   { V8.69 }
                FProxyAuthDigestState := digestDone
            else
{$ENDIF}
            if FProxyAuth = httpAuthBasic then
                FProxyAuthBasicState := basicDone;
        end
        else begin
{$IFDEF UseNTLMAuthentication}
            if FProxyAuth = httpAuthNtlm then begin
                FProxyAuthNTLMState  := ntlmMsg1;
                if (FRequestVer = '1.0') or (FResponseVer = '1.0') or  // <== 12/29/05 AG
                   (FResponseVer = '') then                            // <== 12/29/05 AG
                    FCurrProxyConnection := 'Keep-alive';
            end
            else
{$ENDIF}
{$IFDEF UseDigestAuthentication}
            if FProxyAuth in [httpAuthDigest, httpAuthDigest2] then   { V8.69 }
                FProxyAuthDigestState := digestDone
            else
{$ENDIF}
            if FProxyAuth = httpAuthBasic then
                FProxyAuthBasicState := basicMsg1;
        end;
    end;

    if (FServerAuth <> httpAuthNone) and (FCurrUsername <> '') and
       (FCurrPassword <> '') then begin
{$IFDEF UseNTLMAuthentication}
        if FServerAuth = httpAuthNtlm then begin
            FAuthNTLMState  := ntlmMsg1;
            if (FRequestVer = '1.0') or (FResponseVer = '1.0') or   // <== 12/29/05 AG
               (FResponseVer = '') then                             // <== 12/29/05 AG
                FCurrConnection := 'Keep-alive';
        end
        else
{$ENDIF}
{$IFDEF UseDigestAuthentication}
        if FServerAuth in [httpAuthDigest, httpAuthDigest2] then   { V8.69 }
            FAuthDigestState := digestDone
        else
{$ENDIF}
        if FServerAuth = httpAuthBasic then
            FAuthBasicState := basicMsg1;
    end;

    if FCtrlSocket.State = wsConnected then begin
        if (FHostName = FCurrentHost)     and
           (FPort     = FCurrentPort)     and
           (FProtocol = FCurrentProtocol) then begin
            { We are already connected to the right host ! }
            SocketSessionConnected(Self, 0);
            Exit;
        end;
        { Connected to another website. Abort the connection }
        FCtrlSocket.Abort;
    end;

    //FProxyConnected := FALSE;
    { Ask to connect. When connected, we go at SocketSeesionConnected. }
    StateChange(httpNotConnected);
    Login;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.AdjustDocName;
var
    I : Integer;
begin
    I := Pos('?', FDocName);
    if I > 0 then
        FDocName := Copy(FDocName, 1, I - 1);

    if FRequestType = httpOptions then  { V8.09 options method may be *, user name or anything }
        FDocName := 'options.htm'
    else if (FDocName = '') or (FDocName[Length(FDocName)] = '/') then
        FDocName := 'document.htm'
    else begin
        if FDocName[Length(FDocName)] = '/' then
            SetLength(FDocName, Length(FDocName) - 1);
        FDocName := Copy(FDocName, Posn('/', FDocName, -1) + 1, 255);
        I := Pos('?', FDocName);
        if I > 0 then
            FDocName := Copy(FDocName, 1, I - 1);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetProtocolPort(const AProtocol: String): String;     { V8.71 JK }
begin
{$IFDEF USE_SSL}
    if SameText(AProtocol, 'https') then
        Result := '443'
    else
{$ENDIF}
        Result := '80';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.IsSSLProtocol(const AProtocol: String): Boolean;    { V8.71 JK }
begin
  Result := SameText(AProtocol, 'https' );
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.IsKnownProtocol(const AProtocol: String): Boolean;   { V8.71 JK }
begin
  Result :=
{$IFDEF USE_SSL}
            SameText(AProtocol, 'https' ) or
{$ENDIF}
            SameText(AProtocol, 'http');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.IsKnownProtocolURL(const AURL: String): Boolean;    { V8.71 JK }
begin
  Result := (CompareText(Copy(AURL, 1, 7), 'http://') = 0) or
            (CompareText(Copy(AURL, 1, 8), 'https://') = 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DoRequestSync(Rq : THttpRequest);  { V7.04 Timeout added }
var
    TimeOutSec, IdleSec : Integer;
    bFlag           : Boolean;
    AbortRequired   : Boolean;         { V8.71 JK }
    AbortMsg        : String;          { V8.71 JK }
begin
    DoRequestAsync(Rq);

{$IFDEF VER80}
    { Delphi 1 has no support for multi-threading }
    while FState <> httpReady do
        Application.ProcessMessages;
{$ELSE}
    if FMultiThreaded then begin
        while FState <> httpReady do begin
            FCtrlSocket.ProcessMessages;
            Sleep(0);
        end;
    end
    else begin
        while FState <> httpReady do begin
{$IFNDEF NOFORMS}
            Application.ProcessMessages;
{$ELSE}
		    FCtrlSocket.ProcessMessages;
{$ENDIF}
            Sleep(0);
        end;
    end;
{$ENDIF}

    if FStatusCode >= 400 then
        raise EHttpException.Create(FReasonPhrase, FStatusCode);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.LoginDelayed;
begin
    if not FWMLoginQueued then
        FWMLoginQueued := PostMessage(Handle, FMsg_WM_HTTP_LOGIN, 0, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.LocationSessionClosed(Sender: TObject; ErrCode: Word);
var
    Proto, User, Pass, Host, Port, Path : String;
    RealLocation                        : String;
    I                                   : Integer;
    AllowMoreRelocations                : Boolean;
begin
  { Remove any bookmark from the URL }
    I := Pos('#', FLocation);
    if I > 0 then
        RealLocation := Copy(FLocation, 1, I - 1)
    else
        RealLocation := FLocation;

  {$IFDEF UseNTLMAuthentication}
    if FProxyAuthNtlmState <> ntlmNone then
        { Connection thru proxy with NTLM. Reset the AuthState. }
        FProxyAuthNtlmState := ntlmMsg1; //ntlmDone;
  {$ENDIF}

    if FWMLoginQueued then begin
    { StartRelocation already queued a new Login }
        FConnected      := FALSE;
        //FProxyConnected := FALSE;
        FLocationFlag   := FALSE;
        { Clear header from previous operation }
        FRcvdHeader.Clear;
        { Clear status variables from previous operation }
        FHeaderLineCount  := 0;
        FBodyStartedFlag  := False;    { V8.67 was FBodyLineCount }
        FContentLength    := -1;
        FContentType      := '';
        FTransferEncoding := ''; { 28/12/2003 }
        FResponseVer      := ''; { V7.20 }
    {$IFDEF UseContentCoding}
        FContentEncoding  := '';
    {$ENDIF}
        Exit; //***
    end;

    { Parse the URL }
    ParseURL(RealLocation, Proto, User, Pass, Host, Port, Path);
    FDocName := Path;
    AdjustDocName;
    FConnected      := FALSE;
    FLocationFlag   := FALSE;
    { When relocation occurs doing a POST, new relocated page has to be GET }
    {  if FRequestType = httpPOST then  }
    { angus V8.07  unless a 307 or 308 POST which must not revert to GET }
    {if (FRequestType = httpPOST) and not ((FStatusCode = 307) or (FStatusCode = 308)) then }
    { angus V8.08 - try and match how Chrome and Firefox handle POST relocation }
    if ((FStatusCode=303) and (FRequestType <> httpHEAD)) or
              ((FRequestType = httpPOST) and ((FStatusCode=301) or (FStatusCode=302))) then
        FRequestType  := httpGET;

    { Restore normal session closed event }
    FCtrlSocket.OnSessionClosed := SocketSessionClosed;

{  V1.90 25 Nov 2005 - restrict number of relocations to avoid continuous loops }
    inc (FLocationChangeCurCount) ;
    if FLocationChangeCurCount > FLocationChangeMaxCount then begin
        AllowMoreRelocations := false;
        if Assigned (FOnLocationChangeExceeded) then
            FOnLocationChangeExceeded(Self, FLocationChangeCurCount,
                                                     AllowMoreRelocations) ;
        if not AllowMoreRelocations then begin
            SetReady;  { angus V7.08 }
            exit;
        end;
    end ;

    { Trigger the location changed event }
    TriggerLocationChange;  { V8.61 }
    if FLocation = '' then begin    { V9.1 cancel relocation if new location cleared in event }
        FLocationFlag := False;
        SetReady;
        Exit;
    end;
    { Clear header from previous operation }
    FRcvdHeader.Clear;
    { Clear status variables from previous operation }
    FHeaderLineCount  := 0;
    FBodyStartedFlag  := False;    { V8.67 was FBodyLineCount }
    FContentLength    := -1;
    FContentType      := '';
    //FStatusCode       := 0; // Moved to Login
    FTransferEncoding := ''; { 28/12/2003 }
{$IFDEF UseContentCoding}
    FContentEncoding  := '';
{$ENDIF}
    FResponseVer      := ''; { V7.20 }
    { Adjust for proxy use  (Fixed: Nov 10, 2001) }
    if FProxy <> '' then
        FPort := ProxyPort;
    { Must clear what we already received }
    CleanupRcvdStream; {11/11/04}
    CleanupSendStream;
    { Restart at login procedure }
    LoginDelayed;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WMHttpLogin(var msg: TMessage);
begin
    Login;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketSessionClosed(Sender: TObject; ErrCode: Word);
begin
    FReceiveLen := 0;                  { AG 11 Jan 2009 always clear the buffer! }
    if ErrCode <> 0 then               { WM 15 sep 2002 }
        FRequestDoneError := ErrCode;  { WM 15 sep 2002 }
    FConnected      := FALSE;
    if FHeaderEndFlag then begin
        { TriggerHeaderEnd has not been called yet }
        TriggerHeaderEnd;
        if FLocationFlag then            { 28/10/01 }
            LocationSessionClosed(Self, 0);
        Exit;
    end;
    if FBodyStartedFlag then begin     { V8.67 was FBodyLineCount }
        TriggerDocEnd;
    end;
{ Fix proposed by Corey Murtagh 20/08/2004 "POST freezing in httpWaitingBody" }
{ Also fix a problem when a relocation occurs without document.               }
{ Conditional compile will compile this fix by default. It's there because I  }
{ don't want to delete the original code before confirming everything is OK.  }
{$IFNDEF DO_NOT_USE_COREY_FIX}
    if FLocationFlag then
        LocationSessionClosed(Self, 0)
    else begin
        TriggerSessionClosed;
        if FState <> httpReady then begin
            if (FRequestDoneError = httperrNoError) and (FStatusCode = 0) then  { V7.23 }
            begin
                FRequestDoneError := httperrNoStatusCode;
                FReasonPhrase     := 'HTTP no status code (connection closed prematurely)';
            end;
            SetReady;
        end;
    end;
{$ELSE}
    TriggerSessionClosed;
    if (not FLocationFlag) and (FState <> httpReady) then
        { if you don't verify if component is in ready state,  }
        { OnRequestDone will be fired twice in some cases      }
        SetReady;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketDataAvailable(Sender: TObject; ErrCode: Word);
var
    Len     : Integer;
    I       : Integer;
const
    BUF_SIZE = 66536;  { V8.65 was 8192 }
begin
    // Make FReceiveBuffer at least 8KB larger than actually received data
    if Length(FReceiveBuffer) < (FReceiveLen + BUF_SIZE) then begin
        SetLength(FReceiveBuffer, FReceiveLen + BUF_SIZE + 1);
        FReceiveBuffer[FReceiveLen + BUF_SIZE] := 0;  // Easy debug with an ending nul byte
    end;
    I := Length(FReceiveBuffer) - FReceiveLen - 1;     // Preserve the nul byte
    Len := FCtrlSocket.Receive(@FReceiveBuffer[FReceiveLen], I);

    if FRequestType = httpAbort then
        Exit;

    if Len <= 0 then begin
    {$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, '**data available. Len=' + IntToStr(Len));
    {$ENDIF}
        Exit;
    end;
    FReceiveLen := FReceiveLen + Len;
    FReceiveBuffer[FReceiveLen] := 0;

    if FState = httpWaitingBody then begin
        if FReceiveLen > 0 then begin
            if FRequestType = httpHEAD then begin   { 23/07/04 }
                { We are processing a HEAD command. We don't expect a document }
                { but some server send one anyway. We just throw it away and   }
                { abort the connection                                         }
                FReceiveLen := 0;
                FCtrlSocket.Abort;
                Exit;
            end;

            FBodyData    := 0;  // FP 09/09/06
            if (FContentLength < 0) or
               ((FRcvdCount + FReceiveLen) <= FContentLength) then
                FBodyDataLen := FReceiveLen
            else
                FBodyDataLen := FContentLength - FRcvdCount;
            GetBodyLineNext;

            FReceiveLen  := FReceiveLen - FBodyDataLen;   {+++++}
            { Move remaining data to start of buffer. 17/01/2004 }
            if FReceiveLen > 0 then
                IcsMoveTBytes(FReceiveBuffer, FBodyDataLen, 0, FReceiveLen + 1);

            FBodyDataLen := 0;

            if Assigned(FNext) then
                FNext
            else if FLocationFlag then   { 28/12/2003 }
                StartRelocation
            else
                CheckDelaySetReady; { 09/26/08 ML }
        end;
        { FReceiveLen := 0;   22/02/02 }
        Exit;
    end;

    while FReceiveLen > 0 do begin
        I := 0;                                                   // FP 09/09/06
        while (I <= FReceiveLen) and (Ord(FReceiveBuffer[I]) <> 10) do // FP 09/09/06
            Inc(I);                                               // FP 09/09/06
        if I > FReceiveLen then
            break;
        if I = 0 then                                             // FP 09/09/06
            SetLength(FLastResponse, 0)                           // FP 09/09/06
        else begin                                                // FP 09/09/06
            if (I > 0) and (Ord(FReceiveBuffer[I - 1]) = 13) then // FP 09/09/06
                SetLength(FLastResponse, I - 1)                   // FP 09/09/06
            else                                                  // FP 09/09/06
                SetLength(FLastResponse, I);                      // FP 09/09/06
            if Length(FLastResponse) > 0 then                     // FP 09/09/06
                IcsMoveTBytesToString(FReceiveBuffer, 0,
                        FLastResponse, 1, Length(FLastResponse)); // FP 09/09/06
        end;                                                      // FP 09/09/06

{$IFDEF DUMP}
        FDumpBuf := '>|';
        FDumpStream.WriteBuffer(FDumpBuf[1], Length(FDumpBuf));
        FDumpStream.WriteBuffer(FLastResponse[1], Length(FLastResponse));
        FDumpBuf := '|' + #13#10;
        FDumpStream.WriteBuffer(FDumpBuf[1], Length(FDumpBuf));
{$ENDIF}
{$IFDEF VER80}
        { Add a nul byte at the end of string for Delphi 1 }
        FLastResponse[Length(FLastResponse) + 1] := #0;
{$ENDIF}
        FReceiveLen := FReceiveLen - I - 1;                               // FP 09/09/06
        if FReceiveLen > 0 then begin
            IcsMoveTBytes(FReceiveBuffer, I + 1, 0, FReceiveLen);  // FP 09/09/06
        end
        else if FReceiveLen < 0 then                           // AG 03/19/07
            FReceiveLen := 0;                                  // AG 03/19/07

        if FState in [httpWaitingHeader, httpWaitingBody] then begin
            if Assigned(FNext) then
                FNext
            else
                CheckDelaySetReady; { 09/26/08 ML }
        end
        else begin
            { We are receiving data outside of any request. }
            { It's a server push.                           }
            if Assigned(FOnDataPush) then
                FOnDataPush(Self, ErrCode);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.StartRelocation;
var
    SaveLoc : String;
    AllowMoreRelocations : Boolean;
    SavedStatus: integer;
begin
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
        DebugLog(loProtSpecInfo, 'Starting relocation process');
{$ENDIF}
    FRcvdCount        := 0;
    FReceiveLen       := 0;
    FHeaderLineCount  := 0;
    FBodyStartedFlag  := False;    { V8.67 was FBodyLineCount }

    if (FCurrentHost = FHostName) and (FCurrentPort = FPort) and
            (FCurrentProtocol = FProtocol) and (not FCloseReq) then begin      { SAE 01/06/04 }
        Inc (FLocationChangeCurCount) ;
        if FLocationChangeCurCount > FLocationChangeMaxCount then begin
            AllowMoreRelocations := false;
            if Assigned (FOnLocationChangeExceeded) then
                FOnLocationChangeExceeded(Self, FLocationChangeCurCount,
                                                         AllowMoreRelocations) ;
            if not AllowMoreRelocations then begin
                SetReady;
                exit;
            end ;
        end;

        { No need to disconnect }
        { Trigger the location changed event  27/04/2003 }
        TriggerLocationChange;  { V8.61 }
        if FLocation = '' then begin    { V9.1 cancel relocation if new location cleared in event }
            FLocationFlag := False;
            SetReady;
            Exit;
        end;
        SaveLoc := FLocation;  { 01/05/03 }
        SavedStatus := FStatusCode;  { V8.37 keep if before it's lost }
        InternalClear;   { clears most header vars }
        FLocation := SaveLoc;
        FDocName  := FPath;
        AdjustDocName;
        { When relocation occurs doing a POST, new relocated page }
        { has to be GET.  01/05/03                                }
        { if FRequestType = httpPOST then }
        { angus V8.07  unless a 307 or 308 POST which must not revert to GET }
        {if (FRequestType = httpPOST) and not ((FStatusCode = 307) or (FStatusCode = 308)) then }
        { angus V8.10 - try and match how Chrome and Firefox handle POST relocation }
        { angus V8.37 - last fix failed 302 because status had been cleared }
        if ((SavedStatus=303) and (FRequestType <> httpHEAD)) or
              ((FRequestType = httpPOST) and ((SavedStatus=301) or (SavedStatus=302))) then
            FRequestType  := httpGET;
        { Must clear what we already received }
        CleanupRcvdStream; {11/11/04}
        CleanupSendStream;
        LoginDelayed;
    end
    else begin
        FCtrlSocket.OnSessionClosed := LocationSessionClosed;
        FCtrlSocket.CloseDelayed;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.CleanupRcvdStream;
begin
    { What we are received must be removed }
{$IFDEF UseContentCoding}
    if Assigned(FRcvdStream) and (FRcvdStream.Size <> FRcvdStreamStartSize) then
{$IFNDEF COMPILER3_UP}
  { V8.67 removed ancient code }
{$ELSE}
        FRcvdStream.Size := FRcvdStreamStartSize;
{$ENDIF}
{$ELSE}
    if Assigned(FRcvdStream) and (FRcvdCount > 0) then
{$IFNDEF COMPILER3_UP}
  { V8.67 removed ancient code }
{$ELSE}
        FRcvdStream.Size := FRcvdStream.Size - FRcvdCount;
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.CleanupSendStream;
begin
    { Reset the start position of the stream }
    if Assigned(FSendStream) and (FSentCount > 0) then
    {    FSendStream.Seek(-FSentCount, soFromCurrent);  }
        FSendStream.Position := FSendStream.Position - FSentCount;   { V8.67 better }
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.StartAuthBasic;
begin
    if FAuthBasicState = basicNone then begin
{$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'Starting Basic authentication');
{$ENDIF}
        FAuthBasicState   := basicMsg1;
{$IFDEF UseNTLMAuthentication}
        FAuthNTLMState    := ntlmNone; { Other authentication must be cleared }
{$ENDIF}
{$IFDEF UseDigestAuthentication}
        FAuthDigestState  := digestNone;
{$ENDIF}
        LoginDelayed;
    end
    else if FAuthBasicState = basicMsg1 then begin
        FDoAuthor.Clear;
        FAuthBasicState := basicNone;
        { We comes here when Basic has failed }
        { so we trigger the end request       }
        PostMessage(Handle, FMsg_WM_HTTP_REQUEST_DONE, 0, 0);
    end
    else
        raise EHttpException.Create('Unexpected AuthBasicState', httperrInvalidAuthState);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.StartProxyAuthBasic;
begin
    if FProxyAuthBasicState = basicNone then begin
{$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'Starting Proxy Basic authentication');
{$ENDIF}
        FProxyAuthBasicState := basicMsg1;
{$IFDEF UseNTLMAuthentication}
        FProxyAuthNTLMState  := ntlmNone; { Other authentication must be cleared }
{$ENDIF}
{$IFDEF UseDigestAuthentication}
        FProxyAuthDigestState := digestNone;
{$ENDIF}
        LoginDelayed;
    end
    else if FProxyAuthBasicState = basicMsg1 then begin
        FDoAuthor.Clear;
        FProxyAuthBasicState := basicNone;
        { We comes here when Basic has failed }
        { so we trigger the end request       }
        PostMessage(Handle, FMsg_WM_HTTP_REQUEST_DONE, 0, 0);
    end
    else
        raise EHttpException.Create('Unexpected ProxyAuthBasicState', httperrInvalidAuthState);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetBasicAuthorizationHeader(
  const HttpMethod: String; ProxyAuth: Boolean): String;
begin
    if ProxyAuth then
        Result := 'Proxy-Authorization: Basic ' +
                  EncodeStr(encBase64, FProxyUsername + ':' + FProxyPassword)
    else
        Result := 'Authorization: Basic ' +
                  EncodeStr(encBase64, FCurrUsername + ':' + FCurrPassword);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketDataSent(Sender : TObject; ErrCode : Word);
var
    Len : Integer;
begin
    if not FAllowedToSend then
        Exit;

    if Length(FSendBuffer) = 0 then
        SetLength(FSendBuffer, 8192);
    Len := FSendStream.Read(FSendBuffer[0], Length(FSendBuffer));
    if Len <= 0 then begin
        FAllowedToSend := FALSE;
        TriggerSendEnd;
        if FDelaySetReady then begin     { 09/26/08 ML }
          FDelaySetReady := FALSE;       { 09/26/08 ML }
          SetReady;                      { 09/26/08 ML }
        end;                             { 09/26/08 ML }
        Exit;
    end;

    if Len > 0 then begin
        FSentCount := FSentCount + Len;
        TriggerSendData(@FSendBuffer[0], Len);
        FCtrlSocket.Send(@FSendBuffer[0], Len);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Get process and wait until terminated (blocking)      }
procedure THttpCli.Get;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestSync(httpGet);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Head process and wait until terminated (blocking)     }
procedure THttpCli.Head;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestSync(httpHEAD);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Post process and wait until terminated (blocking)     }
procedure THttpCli.Post;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestSync(httpPOST);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the get process and returns immediately (non blocking)    }
procedure THttpCli.GetAsync;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestASync(httpGet);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the head process and returns immediately (non blocking)   }
procedure THttpCli.HeadAsync;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestASync(httpHEAD);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the post process and returns immediately (non blocking)   }
procedure THttpCli.PostAsync;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestASync(httpPOST);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.CheckDelaySetReady;                        { 09/26/08 ML }
begin
    if FAllowedToSend and ((FStatusCode = 401) or (FStatusCode = 407)) then
        FDelaySetReady := TRUE
    else
        //SetReady;
        PostMessage(Handle, FMsg_WM_HTTP_SET_READY, 0, 0);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetRequestVer(const Ver : String);
begin
    if FRequestVer <> Ver then begin
        if (Ver = '1.0') or (Ver = '1.1') then
            FRequestVer := Ver
        else
            raise EHttpException.Create('Insupported HTTP version',
                                        httperrVersion);
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start a request returns immediately (non blocking)  }
procedure THttpCli.RequestAsync(Rq :THttpRequest);                               { V8.69 }
begin
    DoRequestASync(Rq);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start a request and wait until terminated (blocking)    }
procedure THttpCli.RequestSync(Rq :THttpRequest);                                { V8.69 }
begin
    DoRequestSync(Rq);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetBaseUrl(const Url : String) : String;
var
    I : Integer;
begin
    I := 1;
    while (I <= Length(Url)) and (Url[I] <> '?') do
        Inc(I);
    Dec(I);
    while (I > 0) and (not (AnsiChar(Url[I]) in ['/', ':'])) do
        Dec(I);
    Result := Copy(Url, 1, I);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Syntax of an URL: protocol://[user[:password]@]server[:port]/path         }
procedure ParseURL(
    const url : String;
    var Proto, User, Pass, Host, Port, Path : String);
var
    p, q    : Integer;
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

    p := pos('://',url);
    if p = 0 then begin
        if (url[1] = '/') then begin
            { Relative path without protocol specified }
            proto := 'http';
            p     := 1;
            if (Length(url) > 1) and (url[2] <> '/') then begin
                { Relative path }
                Path := Copy(url, 1, Length(url));
                Exit;
            end;
        end
        else if lowercase(Copy(url, 1, 5)) = 'http:' then begin
            proto := 'http';
            p     := 6;
            if (Length(url) > 6) and (url[7] <> '/') then begin
                { Relative path }
                Path := Copy(url, 6, Length(url));
                Exit;
            end;
        end
        else if lowercase(Copy(url, 1, 7)) = 'mailto:' then begin
            proto := 'mailto';
            p := pos(':', url);
        end;
    end
    else begin
        proto := Copy(url, 1, p - 1);
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

    p := Posn(':', s, -1);
    if p > Length(s) then
        p := 0;
    q := Posn('@', s, -1);
    if q > Length(s) then
        q := 0;
    if (p = 0) and (q = 0) then begin   { no user, password or port }
        Host := s;
        Exit;
    end
    else if q < p then begin  { a port given }
        Port := Copy(s, p + 1, Length(s));
        Host := Copy(s, q + 1, p - q - 1);
        if q = 0 then
            Exit; { no user, password }
        s := Copy(s, 1, q - 1);
    end
    else begin
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


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function EncodeStr(Encoding : THttpEncoding; const Value : String) : String;
begin
    Result := EncodeLine(Encoding, @Value[1], Length(Value));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function EncodeLine(
    Encoding : THttpEncoding;
    SrcData  : PChar;
    Size     : Integer) : String;
var
    Offset : Integer;
    Pos1   : Integer;
    Pos2   : Integer;
    I      : Integer;
begin
    SetLength(Result, Size * 4 div 3 + 4);
    FillChar(Result[1], Size * 4 div 3 + 2, #0);

    if Encoding = encUUEncode then begin
        Result[1] := Char(((Size - 1) and $3f) + $21);
        Size      := ((Size + 2) div 3) * 3;
    end;
    Offset := 2;
    Pos1   := 0;
    Pos2   := 0;
    case Encoding of
        encUUEncode:        Pos2 := 2;
        encBase64, encMime: Pos2 := 1;
    end;
    Result[Pos2] := #0;

    while Pos1 < Size do begin
        if Offset > 0 then begin
            Result[Pos2] := Char(ord(Result[Pos2]) or
                                 ((ord(SrcData[Pos1]) and
                                  ($3f shl Offset)) shr Offset));
            Offset := Offset - 6;
            Inc(Pos2);
            Result[Pos2] := #0;
        end
        else if Offset < 0 then begin
            Offset := Abs(Offset);
            Result[Pos2] := Char(ord(Result[Pos2]) or
                                 ((ord(SrcData[Pos1]) and
                                  ($3f shr Offset)) shl Offset));
            Offset := 8 - Offset;
            Inc(Pos1);
        end
        else begin
            Result[Pos2] := Char(ord(Result[Pos2]) or
                                 ((ord(SrcData[Pos1]) and $3f)));
            Inc(Pos2);
            Inc(Pos1);
            Result[Pos2] := #0;
            Offset    := 2;
        end;
    end;

    case Encoding of
    encUUEncode:
        begin
            if Offset = 2 then
                Dec(Pos2);
            for i := 2 to Pos2 do
                Result[i] := bin2uue[ord(Result[i])+1];
        end;
    encBase64, encMime:
        begin
            if Offset = 2 then
                Dec(Pos2);
            for i := 1 to Pos2 do
                Result[i] := bin2b64[ord(Result[i])+1];
            while (Pos2 and 3) <> 0  do begin
                Inc(Pos2);
                Result[Pos2] := '=';
            end;
        end;
    end;
    SetLength(Result, Pos2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Find the count'th occurence of the s string in the t string.              }
{ If count < 0 then look from the back                                      }
function Posn(const s , t : String; Count : Integer) : Integer;
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


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.

