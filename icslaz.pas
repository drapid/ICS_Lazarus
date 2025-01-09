{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ICSLaz;

interface

uses
  WSocketS, Fingcli, Ftpcli, Ftpsrv, Ftpsrvc, Ftpsrvt, Httpprot, Httpsrv, 
  Icmp, Lzh, Mbxfile, Md5, Mimedec, Nntpcli, Ping, Pop3prot, Smtpprot, Tncnx, 
  Uuencode, winsock, Wsockbuf, Wsocket, OverbyteIcsCookies, cookiesothen, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('WSocketS', @WSocketS.Register);
  RegisterUnit('Fingcli', @Fingcli.Register);
  RegisterUnit('Ftpcli', @Ftpcli.Register);
  RegisterUnit('Ftpsrv', @Ftpsrv.Register);
  RegisterUnit('Httpprot', @Httpprot.Register);
  RegisterUnit('Mbxfile', @Mbxfile.Register);
  RegisterUnit('Mimedec', @Mimedec.Register);
  RegisterUnit('Nntpcli', @Nntpcli.Register);
  RegisterUnit('Ping', @Ping.Register);
  RegisterUnit('Pop3prot', @Pop3prot.Register);
  RegisterUnit('Smtpprot', @Smtpprot.Register);
  RegisterUnit('Tncnx', @Tncnx.Register);
  RegisterUnit('Wsocket', @Wsocket.Register);
  RegisterUnit('OverbyteIcsCookies', @OverbyteIcsCookies.Register);
end;

initialization
  RegisterPackage('ICSLaz', @Register);
end.
