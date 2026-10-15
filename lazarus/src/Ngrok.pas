unit Ngrok;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows, ShellApi;

type
  TNgrok = class(TObject)
  public
    class function GetNgrokExe(const NexagonRoot: string): string;
    class function ShareSite(const NexagonRoot, HostName: string; Port: Integer): Boolean;
  end;

implementation

class function TNgrok.GetNgrokExe(const NexagonRoot: string): string;
begin
  Result := IncludeTrailingPathDelimiter(NexagonRoot) + 'bin\ngrok\ngrok.exe';
end;

class function TNgrok.ShareSite(const NexagonRoot, HostName: string; Port: Integer): Boolean;
var
  ExePath, Args: string;
begin
  Result := False;
  ExePath := GetNgrokExe(NexagonRoot);
  if not FileExists(ExePath) then Exit;
  if Port <= 0 then Port := 80;
  if HostName <> '' then
    Args := Format('http --host-header=rewrite %s:%d', [HostName, Port])
  else
    Args := Format('http %d', [Port]);
  ShellExecute(0, 'open', PChar(ExePath), PChar(Args),
    PChar(ExtractFilePath(ExePath)), SW_SHOWNORMAL);
  Result := True;
end;

end.
