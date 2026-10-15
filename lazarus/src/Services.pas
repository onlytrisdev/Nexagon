unit Services;

{$mode objfpc}{$H+}

interface

uses
  Windows, JwaTlHelp32, ShellApi, Classes, SysUtils, IniFiles, Process, Registry,
  Graphics, Controls, ExtCtrls, StdCtrls, Forms, ComCtrls, Dialogs;

type
  TCommonService = class;
  TService = class;
  TWebServer = class;

  TServiceThread = class(TThread)
  private
    procedure SyncNotifyStopped;
  public
    Service: TService;
    CommandLine: string;
    WorkDir: string;
    constructor Create(CreateSuspended: Boolean; AService: TService);
    destructor Destroy; override;
  protected
    procedure Execute; override;
  end;

  TServiceUI = class(TObject)
  private
    FLastRunning: Boolean;
    FLastSslEnabled: Boolean;
    FLastPort: Integer;
    FLastSslPort: Integer;
    FLastVersion: string;
    FInitialized: Boolean;
  public
    Service: TService;
    ReloadLabel: TLabel;
    StatusImg: TImage;
    SslImg: TImage;
    WebUiImg: TImage;
    NameLabel: TLabel;
    PortLabel: TLabel;
    RowTop: Integer;
    constructor Create(AService: TService; AParent: TWinControl);
    destructor Destroy; override;
    procedure SetRowPosition(ATop: Integer);
    procedure UpdateUI(Force: Boolean = False);
    procedure OnStatusImgClick(Sender: TObject);
    procedure OnSslClick(Sender: TObject);
    procedure OnReloadClick(Sender: TObject);
    procedure OnReloadMouseEnter(Sender: TObject);
    procedure OnReloadMouseLeave(Sender: TObject);
    procedure OnWebUiClick(Sender: TObject);
  end;

  TCommonService = class(TObject)
  public
    Name: string;
    DisplayName: string;
    BaseDirName: string;
    CurrentVersion: string;
    ExeSubPath: string;
    ConfigSubPath: string;
    constructor Create(const AName, ABaseDirName: string); virtual;
    function GetBaseDir: string; virtual;
    function GetVersionDir: string; virtual;
    function GetShortVersion: string; virtual;
    function GetExePath: string; virtual;
    function GetConfigPath: string; virtual;
    function ListVersions(OutList: TStrings): Integer; virtual;
    procedure DetectDefaultVersion; virtual;
  end;

  TService = class(TCommonService)
  public
    Running: Boolean;
    Enabled: Boolean;
    Port: Integer;
    Pid: Cardinal;
    ImageIndex: Integer;
    ServiceThread: TServiceThread;
    UI: TServiceUI;
    constructor Create(const AName, ABaseDirName: string; ADefaultPort: Integer); reintroduce; virtual;
    destructor Destroy; override;
    function IsActiveAndInstalled: Boolean; virtual;
    function StartService: Boolean; virtual;
    function StopService: Boolean; virtual;
    function ReloadService: Boolean; virtual;
    function CheckRunning: Boolean; virtual;
  end;

  TWebServer = class(TService)
  public
    SslEnabled: Boolean;
    SslPort: Integer;
    constructor Create(const AName, ABaseDirName: string; ADefaultPort, ADefaultSslPort: Integer); reintroduce;
    function StartService: Boolean; override;
    function StopService: Boolean; override;
    function ReloadService: Boolean; override;
  end;

  TMySQL = class(TService)
  public
    DataDir: string;
    constructor Create;
    function GetDataDir: string;
    function GetLogPath: string;
    function StartService: Boolean; override;
    function StopService: Boolean; override;
    function ResetRootPassword(const NewPass: string; OutLog: TStrings): Boolean;
    function CreateDatabase(const DbName: string; out ErrMsg: string): Boolean;
    function BackupAllDatabases(out BackupDir: string): Boolean;
  end;

  TMongoDB = class(TService)
  public
    constructor Create;
    function GetDataDir: string;
    function GetLogPath: string;
    function StartService: Boolean; override;
  end;

  TPostgreSQL = class(TService)
  public
    constructor Create;
    function GetDataDir: string;
    function GetLogPath: string;
    function StartService: Boolean; override;
    function StopService: Boolean; override;
  end;

  TPHP = class(TService)
  public
    constructor Create;
    function GetExtDir: string;
    function GetErrorLogPath: string;
    function GetXdebugDllPath: string;
    procedure GetExtensions(OutList: TStrings);
    function ToggleExtension(const ExtName: string): Boolean;
    function GetIniSetting(const KeyName, DefaultVal: string): string;
    function SetIniSetting(const KeyName, Val: string): Boolean;
  end;

  TPython = class(TService)
  public
    constructor Create;
  end;

  TRuby = class(TService)
  public
    constructor Create;
  end;

  TJava = class(TService)
  public
    constructor Create;
  end;

  TGo = class(TService)
  public
    constructor Create;
    function GetGoPath: string;
    function GetGoRoot: string;
  end;

  TCmder = class(TCommonService)
  public
    constructor Create;
    procedure OpenTerminal(const WorkDir: string = '');
  end;

  TNexagon = class(TObject)
  public
    RootDir: string;
    DocumentRoot: string;
    DocumentRootList: string;
    DataDir: string;
    Language: string;
    Profile: string;
    HostnameFormat: string;
    RunAtStartup: Boolean;
    MinimizeWhenRun: Boolean;
    AutoStart: Integer;
    AutoVirtualHosts: Boolean;
    AutoBackup: Boolean;
    BackupInterval: Integer;
    AutoUpdate: Boolean;
    UseGoWorkspace: Boolean;
    MailCatcherEnabled: Boolean;
    MailCatcherDisplayTime: Integer;
    MailSenderEnabled: Boolean;
    GmailAddress: string;
    GmailPassword: string;
    LangStrings: TStringList;
    SitesConf: TStringList;
    PackagesConf: TStringList;
    constructor Create;
    destructor Destroy; override;
    function DetectRootDir: string;
    function GetIniPath: string;
    function GetUsrDir: string;
    function GetTmpDir: string;
    function GetSslDir: string;
    function GetMailCatcherDir: string;
    function GetMailSenderDir: string;
    procedure AddDocumentRootToList(const ADir: string);
    procedure GetDocumentRootListItems(OutList: TStrings);
    procedure LoadConfig;
    procedure SaveConfig;
    procedure LoadLanguage(const LangName: string = '');
    function T(Id: Integer; const DefaultText: string): string;
    procedure ListAvailableLanguages(OutList: TStrings);
    procedure ListProfiles(OutList: TStrings);
    procedure SwitchProfile(const ProfileName: string);
    procedure SyncPhpIni;
    procedure CopyPhpDllsToApache;
    procedure SyncApacheConfig;
    procedure SyncNginxConfig;
    procedure EnsureNginxPhpUpstreamRunning;
    procedure StopNginxPhpUpstream;
    procedure SyncMySqlConfig;
    procedure SyncSendmailConfig;
    function EnsureSslCertificates: Boolean;
    function AddSslCertToTrustStore: Boolean;
    function GenerateAutoVirtualHosts: Integer;
    function CreateVirtualHostForProject(const ProjectName, DocRootPath: string): string;
    procedure LoadSitesAndPackages;
    function BuildNexagonPathList(OutList: TStrings): string;
    function GetPathVariablesReport: string;
    function AddNexagonToUserPath: Boolean;
    function RemoveNexagonFromUserPath: Boolean;
    function CatchIncomingEmailFromStdin: string;
    function GetLatestEmailFile: string;
    function GenerateMailTestScript(const RecipientEmail: string): string;
  end;

var
  Nexagon: TNexagon = nil;
  SrvPHP: TPHP = nil;
  SrvApache: TWebServer = nil;
  SrvNginx: TWebServer = nil;
  SrvMySQL: TMySQL = nil;
  SrvMongoDB: TMongoDB = nil;
  SrvPostgreSQL: TPostgreSQL = nil;
  SrvMemcached: TService = nil;
  SrvRedis: TService = nil;
  SrvMailpit: TService = nil;
  SrvNodeJS: TService = nil;
  SrvPython: TPython = nil;
  SrvRuby: TRuby = nil;
  SrvJava: TJava = nil;
  SrvGo: TGo = nil;
  SrvCmder: TCmder = nil;

  GlobalImageListServices24x24: TImageList = nil;
  GlobalImageListMenuTray: TImageList = nil;
  OnGlobalServicesUpdated: TNotifyEvent = nil;
  OnGlobalServiceStatusChanged: TNotifyEvent = nil;

procedure InitAllServices(RuntimePanel: TWinControl);
procedure FreeAllServices;
procedure LayoutRuntimeServices(RuntimePanel: TWinControl);
procedure RefreshAllServicesUI(Force: Boolean = False);
function AnyPrimaryServiceRunning: Boolean;
function StartAllEnabledServices: Integer;
function StopAllRunningServices: Integer;
function OpenUrlOrFile(const Target: string; const Params: string = ''): Boolean;
function IsTcpPortListening(APort: Integer): Boolean;

implementation

uses
  StrUtils;

type
  TMibTcpRow = record
    dwState: DWORD;
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
    dwRemoteAddr: DWORD;
    dwRemotePort: DWORD;
  end;
  PMibTcpRow = ^TMibTcpRow;

  TMibTcp6RowOwnerPid = record
    ucLocalAddr: array[0..15] of Byte;
    dwLocalScopeId: DWORD;
    dwLocalPort: DWORD;
    ucRemoteAddr: array[0..15] of Byte;
    dwRemoteScopeId: DWORD;
    dwRemotePort: DWORD;
    dwState: DWORD;
    dwOwningPid: DWORD;
  end;
  PMibTcp6RowOwnerPid = ^TMibTcp6RowOwnerPid;

function GetTcpTable(pTcpTable: Pointer; var pdwSize: DWORD; bOrder: BOOL): DWORD; stdcall; external 'iphlpapi.dll';
function GetExtendedTcpTable(pTcpTable: Pointer; var pdwSize: DWORD; bOrder: BOOL;
  ulAf: DWORD; TableClass: Integer; Reserved: DWORD): DWORD; stdcall; external 'iphlpapi.dll';

function IsTcpPortListening(APort: Integer): Boolean;
var
  BufSize, NumEntries, I: DWORD;
  Buf: PByte;
  Row4: PMibTcpRow;
  Row6: PMibTcp6RowOwnerPid;
  NetPort: DWORD;
begin
  Result := False;
  if (APort <= 0) or (APort > 65535) then Exit;
  NetPort := ((DWORD(APort) and $FF) shl 8) or ((DWORD(APort) shr 8) and $FF);

  BufSize := 0;
  if GetTcpTable(nil, BufSize, False) = ERROR_INSUFFICIENT_BUFFER then
  begin
    GetMem(Buf, BufSize);
    try
      if GetTcpTable(Buf, BufSize, False) = NO_ERROR then
      begin
        NumEntries := PDWORD(Buf)^;
        Row4 := PMibTcpRow(Buf + SizeOf(DWORD));
        for I := 0 to NumEntries - 1 do
        begin
          if (Row4^.dwState = 2) and ((Row4^.dwLocalPort and $FFFF) = NetPort) then
            Exit(True);
          Inc(Row4);
        end;
      end;
    finally
      FreeMem(Buf);
    end;
  end;

  BufSize := 0;
  if GetExtendedTcpTable(nil, BufSize, False, 23, 3, 0) = ERROR_INSUFFICIENT_BUFFER then
  begin
    GetMem(Buf, BufSize);
    try
      if GetExtendedTcpTable(Buf, BufSize, False, 23, 3, 0) = NO_ERROR then
      begin
        NumEntries := PDWORD(Buf)^;
        Row6 := PMibTcp6RowOwnerPid(Buf + SizeOf(DWORD));
        for I := 0 to NumEntries - 1 do
        begin
          if ((Row6^.dwLocalPort and $FFFF) = NetPort) then
            Exit(True);
          Inc(Row6);
        end;
      end;
    finally
      FreeMem(Buf);
    end;
  end;
end;

function OpenUrlOrFile(const Target: string; const Params: string): Boolean;
var
  PTarget, PParams: PChar;
begin
  if Target = '' then Exit(False);
  PTarget := PChar(Target);
  if Params <> '' then PParams := PChar(Params) else PParams := nil;
  Result := ShellExecute(0, 'open', PTarget, PParams, nil, SW_SHOWNORMAL) > 32;
end;

function RunCommandHidden(const ExePath, Args, WorkDir: string; WaitFinish: Boolean = True): Integer;
var
  P: TProcess;
  I: Integer;
begin
  Result := -1;
  if not FileExists(ExePath) then Exit;
  P := TProcess.Create(nil);
  try
    P.Executable := ExePath;
    P.CommandLine := '"' + ExePath + '" ' + Args;
    if (WorkDir <> '') and DirectoryExists(WorkDir) then
      P.CurrentDirectory := WorkDir
    else
      P.CurrentDirectory := ExtractFilePath(ExePath);
    for I := 1 to GetEnvironmentVariableCount do
      P.Environment.Add(GetEnvironmentString(I));
    P.ShowWindow := swoHide;
    if WaitFinish then
      P.Options := [poWaitOnExit, poNoConsole]
    else
      P.Options := [poNoConsole];
    P.Execute;
    if WaitFinish then
      Result := P.ExitStatus
    else
      Result := Integer(P.ProcessID);
  except
    Result := -1;
  end;
  P.Free;
end;

function FindProcessPidByName(const ExeName: string): Cardinal;
var
  Snap: THandle;
  PE: TProcessEntry32;
begin
  Result := 0;
  if ExeName = '' then Exit;
  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap = INVALID_HANDLE_VALUE then Exit;
  try
    FillChar(PE, SizeOf(PE), 0);
    PE.dwSize := SizeOf(PE);
    if Process32First(Snap, PE) then
    begin
      repeat
        if SameText(StrPas(PE.szExeFile), ExeName) then
        begin
          Result := PE.th32ProcessID;
          Break;
        end;
      until not Process32Next(Snap, PE);
    end;
  finally
    CloseHandle(Snap);
  end;
end;

procedure KillProcessByName(const ExeName: string);
var
  Snap, HProc: THandle;
  PE: TProcessEntry32;
begin
  if ExeName = '' then Exit;
  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap = INVALID_HANDLE_VALUE then Exit;
  try
    FillChar(PE, SizeOf(PE), 0);
    PE.dwSize := SizeOf(PE);
    if Process32First(Snap, PE) then
    begin
      repeat
        if SameText(StrPas(PE.szExeFile), ExeName) then
        begin
          HProc := OpenProcess(PROCESS_TERMINATE or SYNCHRONIZE, False, PE.th32ProcessID);
          if HProc <> 0 then
          begin
            TerminateProcess(HProc, 0);
            WaitForSingleObject(HProc, 40);
            CloseHandle(HProc);
          end;
        end;
      until not Process32Next(Snap, PE);
    end;
  finally
    CloseHandle(Snap);
  end;
end;

function WaitForServiceReady(AService: TService; MaxWaitMs: Integer): Boolean;
var
  Elapsed, StepMs: Integer;
  ExeName: string;
  FoundPid: Cardinal;
begin
  Result := False;
  if not Assigned(AService) then Exit;
  ExeName := ExtractFileName(AService.GetExePath);
  Elapsed := 0;
  StepMs := 20;
  while Elapsed < MaxWaitMs do
  begin
    Sleep(StepMs);
    Inc(Elapsed, StepMs);
    FoundPid := FindProcessPidByName(ExeName);
    if FoundPid > 0 then
    begin
      AService.Pid := FoundPid;
      if (AService.Port <= 0) or IsTcpPortListening(AService.Port) then
      begin
        AService.Running := True;
        Exit(True);
      end;
    end
    else if (Elapsed >= 100) and Assigned(AService.ServiceThread) and AService.ServiceThread.Finished then
      Break;
  end;
  FoundPid := FindProcessPidByName(ExeName);
  if (FoundPid > 0) and ((AService.Port <= 0) or IsTcpPortListening(AService.Port)) then
  begin
    AService.Pid := FoundPid;
    AService.Running := True;
    Result := True;
  end
  else
  begin
    AService.Running := False;
    AService.Pid := 0;
    Result := False;
  end;
end;

procedure WaitForServiceStopped(AService: TService; MaxWaitMs: Integer);
var
  Elapsed, StepMs: Integer;
  ExeName: string;
begin
  if not Assigned(AService) then Exit;
  ExeName := ExtractFileName(AService.GetExePath);
  Elapsed := 0;
  StepMs := 15;
  while Elapsed < MaxWaitMs do
  begin
    if (FindProcessPidByName(ExeName) = 0) and
       ((AService.Port <= 0) or not IsTcpPortListening(AService.Port)) then
      Break;
    Sleep(StepMs);
    Inc(Elapsed, StepMs);
  end;
end;

{ TServiceThread }

constructor TServiceThread.Create(CreateSuspended: Boolean; AService: TService);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := False;
  Service := AService;
end;

destructor TServiceThread.Destroy;
begin
  inherited Destroy;
end;

procedure TServiceThread.SyncNotifyStopped;
begin
  if Assigned(Service) then
  begin
    Service.CheckRunning;
    if Assigned(Service.UI) then
      Service.UI.UpdateUI(False);
    if Assigned(OnGlobalServiceStatusChanged) then
      OnGlobalServiceStatusChanged(Service)
    else if Assigned(OnGlobalServicesUpdated) then
      OnGlobalServicesUpdated(Service);
  end;
end;

procedure TServiceThread.Execute;
var
  I: Integer;
  LProc: TProcess;
  PathDirs: TStringList;
  NewPath: string;
begin
  if Trim(CommandLine) = '' then Exit;
  LProc := TProcess.Create(nil);
  PathDirs := TStringList.Create;
  try
    LProc.CommandLine := CommandLine;
    if (WorkDir <> '') and DirectoryExists(WorkDir) then
      LProc.CurrentDirectory := WorkDir;
    for I := 1 to GetEnvironmentVariableCount do
      LProc.Environment.Add(GetEnvironmentString(I));
    if Assigned(Nexagon) then
    begin
      NewPath := Nexagon.BuildNexagonPathList(PathDirs);
      if NewPath <> '' then
        LProc.Environment.Values['PATH'] := NewPath + ';' + GetEnvironmentVariable('PATH');
    end;
    LProc.Options := [poNoConsole];
    LProc.ShowWindow := swoHide;
    try
      LProc.Execute;
      if Assigned(Service) then
        Service.Pid := LProc.ProcessID;
      while not Terminated and LProc.Running do
        Sleep(25);
    except
    end;
  finally
    PathDirs.Free;
    FreeAndNil(LProc);
    if Assigned(Service) and not Terminated then
      Queue(@SyncNotifyStopped);
  end;
end;

{ TServiceUI }

constructor TServiceUI.Create(AService: TService; AParent: TWinControl);
begin
  inherited Create;
  Service := AService;
  RowTop := 0;
  FInitialized := False;

  StatusImg := TImage.Create(AParent);
  StatusImg.Parent := AParent;
  StatusImg.Width := 24;
  StatusImg.Height := 24;
  StatusImg.Left := 20;
  StatusImg.Transparent := True;
  StatusImg.Cursor := crHandPoint;
  StatusImg.ShowHint := True;
  StatusImg.Hint := Service.DisplayName;
  StatusImg.OnClick := @OnStatusImgClick;
  StatusImg.Visible := False;

  NameLabel := TLabel.Create(AParent);
  NameLabel.Parent := AParent;
  NameLabel.Left := 50;
  NameLabel.AutoSize := True;
  NameLabel.Font.Name := 'Arial';
  NameLabel.Font.Size := 10;
  NameLabel.Font.Color := $00808080;
  NameLabel.ShowHint := True;
  NameLabel.Visible := False;

  PortLabel := TLabel.Create(AParent);
  PortLabel.Parent := AParent;
  PortLabel.Left := 420;
  PortLabel.AutoSize := True;
  PortLabel.Font.Name := 'Arial';
  PortLabel.Font.Size := 10;
  PortLabel.Font.Color := $00808080;
  PortLabel.ShowHint := True;
  PortLabel.Visible := False;

  SslImg := nil;
  ReloadLabel := nil;
  WebUiImg := nil;

  if (SameText(Service.Name, 'Apache')) or (SameText(Service.Name, 'Nginx')) then
  begin
    SslImg := TImage.Create(AParent);
    SslImg.Parent := AParent;
    SslImg.Width := 24;
    SslImg.Height := 24;
    SslImg.Transparent := True;
    SslImg.Cursor := crHandPoint;
    SslImg.ShowHint := True;
    SslImg.Hint := 'SSL';
    SslImg.OnClick := @OnSslClick;
    SslImg.Visible := False;

    ReloadLabel := TLabel.Create(AParent);
    ReloadLabel.Parent := AParent;
    ReloadLabel.Left := 570;
    ReloadLabel.AutoSize := True;
    ReloadLabel.Font.Name := 'Arial';
    ReloadLabel.Font.Size := 10;
    ReloadLabel.Font.Color := $00808080;
    ReloadLabel.Caption := 'Reload';
    ReloadLabel.Cursor := crHandPoint;
    ReloadLabel.ShowHint := True;
    ReloadLabel.OnClick := @OnReloadClick;
    ReloadLabel.OnMouseEnter := @OnReloadMouseEnter;
    ReloadLabel.OnMouseLeave := @OnReloadMouseLeave;
    ReloadLabel.Visible := False;
  end
  else if SameText(Service.Name, 'Mailpit') then
  begin
    WebUiImg := TImage.Create(AParent);
    WebUiImg.Parent := AParent;
    WebUiImg.Width := 30;
    WebUiImg.Height := 30;
    WebUiImg.Transparent := True;
    WebUiImg.Cursor := crHandPoint;
    WebUiImg.ShowHint := True;
    WebUiImg.Hint := Service.DisplayName + ' Web UI';
    WebUiImg.OnClick := @OnWebUiClick;
    WebUiImg.Visible := False;
  end;
end;

destructor TServiceUI.Destroy;
begin
  inherited Destroy;
end;

procedure TServiceUI.SetRowPosition(ATop: Integer);
var
  ShowRow: Boolean;
begin
  RowTop := ATop;
  ShowRow := Service.IsActiveAndInstalled;
  StatusImg.Top := ATop - 3;
  StatusImg.Left := 20;
  StatusImg.Visible := ShowRow;

  NameLabel.Top := ATop;
  NameLabel.Left := 50;
  NameLabel.Visible := ShowRow;

  PortLabel.Top := ATop;
  PortLabel.Left := 420;
  PortLabel.Visible := ShowRow;

  if Assigned(ReloadLabel) then
  begin
    ReloadLabel.Top := ATop;
    ReloadLabel.Left := 570;
    ReloadLabel.Visible := ShowRow;
  end;

  UpdateUI(True);
end;

procedure TServiceUI.UpdateUI(Force: Boolean);
var
  ShowRow, CurSslEnabled: Boolean;
  CurSslPort: Integer;
  ShortVer, PortText: string;
  WebSrv: TWebServer;
  Bmp: TBitmap;
  SslIdx: Integer;
begin
  ShowRow := Service.IsActiveAndInstalled;
  if StatusImg.Visible <> ShowRow then StatusImg.Visible := ShowRow;
  if NameLabel.Visible <> ShowRow then NameLabel.Visible := ShowRow;
  if PortLabel.Visible <> ShowRow then PortLabel.Visible := ShowRow;
  if Assigned(ReloadLabel) and (ReloadLabel.Visible <> ShowRow) then ReloadLabel.Visible := ShowRow;
  if Assigned(SslImg) and (SslImg.Visible <> ShowRow) then SslImg.Visible := ShowRow;
  if Assigned(WebUiImg) and (WebUiImg.Visible <> ShowRow) then WebUiImg.Visible := ShowRow;
  if not ShowRow then Exit;

  CurSslEnabled := False;
  CurSslPort := 0;
  if Service is TWebServer then
  begin
    CurSslEnabled := TWebServer(Service).SslEnabled;
    CurSslPort := TWebServer(Service).SslPort;
  end;

  if not Force and FInitialized and
     (FLastRunning = Service.Running) and
     (FLastPort = Service.Port) and
     (FLastSslEnabled = CurSslEnabled) and
     (FLastSslPort = CurSslPort) and
     (FLastVersion = Service.CurrentVersion) then
    Exit;

  FInitialized := True;
  FLastRunning := Service.Running;
  FLastPort := Service.Port;
  FLastSslEnabled := CurSslEnabled;
  FLastSslPort := CurSslPort;
  FLastVersion := Service.CurrentVersion;

  if Assigned(GlobalImageListServices24x24) and (GlobalImageListServices24x24.Count >= 2) then
  begin
    Bmp := TBitmap.Create;
    try
      if Service.Running then
        GlobalImageListServices24x24.GetBitmap(1, Bmp)
      else
        GlobalImageListServices24x24.GetBitmap(0, Bmp);
      StatusImg.Picture.Assign(Bmp);
    finally
      Bmp.Free;
    end;
  end;

  ShortVer := Service.GetShortVersion;
  if ShortVer <> '' then
    NameLabel.Caption := Service.DisplayName + ' ' + ShortVer
  else
    NameLabel.Caption := Service.DisplayName;

  if Service.Running then
  begin
    NameLabel.Font.Color := clBlack;
    PortLabel.Font.Color := clBlack;
    if Service.Pid > 0 then
      NameLabel.Hint := Format('%s (PID: %d)', [Service.CurrentVersion, Service.Pid])
    else
      NameLabel.Hint := Service.CurrentVersion;
  end
  else
  begin
    NameLabel.Font.Color := $00808080;
    PortLabel.Font.Color := $00808080;
    NameLabel.Hint := Service.CurrentVersion;
  end;

  PortText := IntToStr(Service.Port);
  if Service is TWebServer then
  begin
    WebSrv := TWebServer(Service);
    if WebSrv.SslEnabled then
    begin
      PortText := Format('%d, %d', [WebSrv.Port, WebSrv.SslPort]);
      PortLabel.Hint := Format('Port: %d, SSL Port: %d', [WebSrv.Port, WebSrv.SslPort]);
    end
    else
      PortLabel.Hint := Format('Port: %d', [WebSrv.Port]);
  end
  else if SameText(Service.Name, 'Mailpit') then
  begin
    PortText := Format('%d/8025', [Service.Port]);
    PortLabel.Hint := Format('SMTP Port: %d, Web UI Port: 8025', [Service.Port]);
  end
  else
    PortLabel.Hint := Format('Port: %d', [Service.Port]);
  PortLabel.Caption := PortText;

  if Assigned(SslImg) and (Service is TWebServer) then
  begin
    WebSrv := TWebServer(Service);
    SslImg.Top := RowTop - 3;
    SslImg.Left := NameLabel.Left + NameLabel.Width + 5;
    if Assigned(GlobalImageListMenuTray) then
    begin
      Bmp := TBitmap.Create;
      try
        if WebSrv.SslEnabled then
        begin
          if WebSrv.Running then SslIdx := 7 else SslIdx := 9;
          GlobalImageListMenuTray.GetBitmap(SslIdx, Bmp);
          if Assigned(Nexagon) then
            SslImg.Hint := Nexagon.T(160, 'SSL is enabled. Click to disable')
          else
            SslImg.Hint := 'SSL is enabled. Click to disable';
        end
        else
        begin
          GlobalImageListMenuTray.GetBitmap(8, Bmp);
          if Assigned(Nexagon) then
            SslImg.Hint := Nexagon.T(168, 'SSL is disabled. Click to enable')
          else
            SslImg.Hint := 'SSL is disabled. Click to enable';
        end;
        SslImg.Picture.Assign(Bmp);
      finally
        Bmp.Free;
      end;
    end;
  end;

  if Assigned(WebUiImg) then
  begin
    WebUiImg.Top := RowTop;
    WebUiImg.Left := NameLabel.Left + NameLabel.Width + 10;
    if Assigned(GlobalImageListMenuTray) then
    begin
      Bmp := TBitmap.Create;
      try
        GlobalImageListMenuTray.GetBitmap(19, Bmp);
        WebUiImg.Picture.Assign(Bmp);
      finally
        Bmp.Free;
      end;
    end;
  end;

  if Assigned(ReloadLabel) then
  begin
    if Assigned(Nexagon) then
      ReloadLabel.Caption := Nexagon.T(107, 'Reload');
    ReloadLabel.Hint := ReloadLabel.Caption + ' ' + Service.DisplayName;
    if Service.Running then
      ReloadLabel.Font.Color := clBlue
    else
      ReloadLabel.Font.Color := $00808080;
  end;
end;

procedure TServiceUI.OnStatusImgClick(Sender: TObject);
begin
  if Service.CheckRunning then
    Service.StopService
  else
    Service.StartService;
  UpdateUI(False);
  if Assigned(OnGlobalServiceStatusChanged) then
    OnGlobalServiceStatusChanged(Self)
  else if Assigned(OnGlobalServicesUpdated) then
    OnGlobalServicesUpdated(Self);
end;

procedure TServiceUI.OnSslClick(Sender: TObject);
var
  WebSrv: TWebServer;
begin
  if Service is TWebServer then
  begin
    WebSrv := TWebServer(Service);
    WebSrv.SslEnabled := not WebSrv.SslEnabled;
    if WebSrv.SslEnabled and Assigned(Nexagon) then
      Nexagon.EnsureSslCertificates;
    if Assigned(Nexagon) then
    begin
      Nexagon.SaveConfig;
      if SameText(WebSrv.Name, 'Apache') then Nexagon.SyncApacheConfig;
      if SameText(WebSrv.Name, 'Nginx') then Nexagon.SyncNginxConfig;
    end;
    if WebSrv.Running then
      WebSrv.ReloadService;
    UpdateUI(False);
    if Assigned(OnGlobalServiceStatusChanged) then
      OnGlobalServiceStatusChanged(Self)
    else if Assigned(OnGlobalServicesUpdated) then
      OnGlobalServicesUpdated(Self);
  end;
end;

procedure TServiceUI.OnReloadClick(Sender: TObject);
begin
  if Service.Running then
  begin
    Service.ReloadService;
    UpdateUI(False);
    if Assigned(OnGlobalServiceStatusChanged) then
      OnGlobalServiceStatusChanged(Self);
  end;
end;

procedure TServiceUI.OnReloadMouseEnter(Sender: TObject);
begin
  if Assigned(ReloadLabel) and Service.Running then
  begin
    ReloadLabel.Font.Color := $00800000;
    ReloadLabel.Font.Style := [fsUnderline];
  end;
end;

procedure TServiceUI.OnReloadMouseLeave(Sender: TObject);
begin
  if Assigned(ReloadLabel) and Service.Running then
  begin
    ReloadLabel.Font.Color := $00FF0000;
    ReloadLabel.Font.Style := [];
  end;
end;

procedure TServiceUI.OnWebUiClick(Sender: TObject);
begin
  OpenUrlOrFile('http://localhost:8025');
end;

{ TCommonService }

constructor TCommonService.Create(const AName, ABaseDirName: string);
begin
  inherited Create;
  Name := AName;
  DisplayName := AName;
  BaseDirName := ABaseDirName;
  CurrentVersion := '';
  ExeSubPath := '';
  ConfigSubPath := '';
  DetectDefaultVersion;
end;

function TCommonService.GetBaseDir: string;
begin
  if Assigned(Nexagon) then
    Result := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\' + BaseDirName
  else
    Result := 'bin\' + BaseDirName;
end;

function TCommonService.GetVersionDir: string;
begin
  if CurrentVersion <> '' then
    Result := IncludeTrailingPathDelimiter(GetBaseDir) + CurrentVersion
  else
    Result := GetBaseDir;
end;

function TCommonService.GetShortVersion: string;
var
  S: string;
  I, StartIdx, EndIdx: Integer;
  FoundDigit: Boolean;
begin
  Result := '';
  if CurrentVersion = '' then Exit;
  // Exact implementation of 0x10009db50: strip 'x64', then take first contiguous [0..9.] run
  S := StringReplace(CurrentVersion, 'x64', '', [rfReplaceAll, rfIgnoreCase]);
  FoundDigit := False;
  StartIdx := 0;
  EndIdx := 0;
  for I := 1 to Length(S) do
  begin
    if (S[I] in ['0'..'9']) and not FoundDigit then
    begin
      StartIdx := I;
      FoundDigit := True;
    end
    else if FoundDigit then
    begin
      if not (S[I] in ['0'..'9', '.']) then
      begin
        EndIdx := I - 1;
        Break;
      end;
    end;
  end;
  if FoundDigit then
  begin
    if EndIdx = 0 then
      EndIdx := Length(S);
    Result := Copy(S, StartIdx, EndIdx - StartIdx + 1);
  end;
end;

function TCommonService.GetExePath: string;
begin
  if ExeSubPath <> '' then
    Result := IncludeTrailingPathDelimiter(GetVersionDir) + ExeSubPath
  else
    Result := GetVersionDir;
end;

function TCommonService.GetConfigPath: string;
begin
  if ConfigSubPath <> '' then
    Result := IncludeTrailingPathDelimiter(GetVersionDir) + ConfigSubPath
  else
    Result := '';
end;

function TCommonService.ListVersions(OutList: TStrings): Integer;
var
  SR: TSearchRec;
  Base: string;
begin
  OutList.Clear;
  Base := IncludeTrailingPathDelimiter(GetBaseDir);
  if FindFirst(Base + '*', faDirectory, SR) = 0 then
  begin
    repeat
      if ((SR.Attr and faDirectory) <> 0) and (SR.Name <> '.') and (SR.Name <> '..') then
        OutList.Add(SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  Result := OutList.Count;
end;

procedure TCommonService.DetectDefaultVersion;
var
  Vers: TStringList;
begin
  Vers := TStringList.Create;
  try
    Vers.Sorted := True;
    if ListVersions(Vers) > 0 then
      CurrentVersion := Vers[Vers.Count - 1];
  finally
    Vers.Free;
  end;
end;

{ TService }

constructor TService.Create(const AName, ABaseDirName: string; ADefaultPort: Integer);
begin
  inherited Create(AName, ABaseDirName);
  Port := ADefaultPort;
  Running := False;
  Enabled := False;
  Pid := 0;
  ImageIndex := 1;
  ServiceThread := nil;
  UI := nil;
end;

destructor TService.Destroy;
begin
  StopService;
  if Assigned(UI) then FreeAndNil(UI);
  inherited Destroy;
end;

function TService.IsActiveAndInstalled: Boolean;
begin
  // Exact implementation of 0x1000abc80:
  Result := (Enabled or Running) and (CurrentVersion <> '') and DirectoryExists(GetVersionDir);
end;

function TService.CheckRunning: Boolean;
var
  ExeName: string;
  FoundPid: Cardinal;
begin
  ExeName := ExtractFileName(GetExePath);
  if ExeName <> '' then
  begin
    FoundPid := FindProcessPidByName(ExeName);
    if (FoundPid > 0) and ((Port <= 0) or IsTcpPortListening(Port)) then
    begin
      Pid := FoundPid;
      Running := True;
      Exit(True);
    end;
  end;
  Running := False;
  Pid := 0;
  Result := False;
end;

function TService.StartService: Boolean;
var
  Exe, Cmd: string;
begin
  if CheckRunning then Exit(True);
  Exe := GetExePath;
  if not FileExists(Exe) then Exit(False);

  if SameText(Name, 'Memcached') then
    Cmd := Format('"%s" -p %d', [Exe, Port])
  else if SameText(Name, 'Redis') then
  begin
    if FileExists(GetConfigPath) then
      Cmd := Format('"%s" "%s" --port %d', [Exe, GetConfigPath, Port])
    else
      Cmd := Format('"%s" --port %d', [Exe, Port]);
  end
  else if SameText(Name, 'Mailpit') then
    Cmd := Format('"%s" --smtp 127.0.0.1:%d --listen 127.0.0.1:8025', [Exe, Port])
  else
    Cmd := '"' + Exe + '"';

  if Assigned(ServiceThread) then
  begin
    ServiceThread.Terminate;
    FreeAndNil(ServiceThread);
  end;
  ServiceThread := TServiceThread.Create(True, Self);
  ServiceThread.CommandLine := Cmd;
  ServiceThread.WorkDir := GetVersionDir;
  ServiceThread.Start;
  Result := WaitForServiceReady(Self, 1500);
  if Assigned(UI) then UI.UpdateUI(False);
end;

function TService.StopService: Boolean;
var
  ExeName: string;
begin
  if Assigned(ServiceThread) then
    ServiceThread.Terminate;
  ExeName := ExtractFileName(GetExePath);
  if ExeName <> '' then
    KillProcessByName(ExeName);
  WaitForServiceStopped(Self, 400);
  if Assigned(ServiceThread) then
    FreeAndNil(ServiceThread);
  Running := False;
  Pid := 0;
  if Assigned(UI) then UI.UpdateUI(False);
  Result := True;
end;

function TService.ReloadService: Boolean;
begin
  StopService;
  Result := StartService;
end;

{ TWebServer }

constructor TWebServer.Create(const AName, ABaseDirName: string; ADefaultPort, ADefaultSslPort: Integer);
begin
  inherited Create(AName, ABaseDirName, ADefaultPort);
  SslPort := ADefaultSslPort;
  SslEnabled := False;
end;

function TWebServer.StartService: Boolean;
var
  Exe, Cmd, PidFile: string;
begin
  if CheckRunning then Exit(True);
  if Assigned(Nexagon) then
  begin
    ForceDirectories(Nexagon.GetTmpDir + '\xdebug');
    Nexagon.SyncPhpIni;
    Nexagon.SyncSendmailConfig;
    if Nexagon.AutoVirtualHosts then
      Nexagon.GenerateAutoVirtualHosts;
    if SameText(Name, 'Apache') then
    begin
      PidFile := IncludeTrailingPathDelimiter(GetVersionDir) + 'logs\httpd.pid';
      if FileExists(PidFile) then
        DeleteFile(PChar(PidFile));
      Nexagon.CopyPhpDllsToApache;
      Nexagon.SyncApacheConfig;
    end
    else if SameText(Name, 'Nginx') then
    begin
      Nexagon.SyncNginxConfig;
      Nexagon.EnsureNginxPhpUpstreamRunning;
    end;
  end;

  Exe := GetExePath;
  if not FileExists(Exe) then Exit(False);

  if SameText(Name, 'Nginx') then
    Cmd := Format('"%s" -p "%s"', [Exe, GetVersionDir])
  else
    Cmd := Format('"%s"', [Exe]);

  if Assigned(ServiceThread) then
  begin
    ServiceThread.Terminate;
    FreeAndNil(ServiceThread);
  end;
  ServiceThread := TServiceThread.Create(True, Self);
  ServiceThread.CommandLine := Cmd;
  ServiceThread.WorkDir := GetVersionDir;
  ServiceThread.Start;
  Result := WaitForServiceReady(Self, 2000);
  if Assigned(UI) then UI.UpdateUI(False);
end;

function TWebServer.StopService: Boolean;
var
  PidFile: string;
begin
  if SameText(Name, 'Nginx') then
  begin
    if FileExists(GetExePath) then
      RunCommandHidden(GetExePath, '-p "' + GetVersionDir + '" -s stop', GetVersionDir, False);
    Sleep(30);
    if Assigned(Nexagon) then
      Nexagon.StopNginxPhpUpstream;
  end;
  Result := inherited StopService;
  if SameText(Name, 'Apache') then
  begin
    PidFile := IncludeTrailingPathDelimiter(GetVersionDir) + 'logs\httpd.pid';
    if FileExists(PidFile) then
      DeleteFile(PChar(PidFile));
  end;
end;

function TWebServer.ReloadService: Boolean;
begin
  if not CheckRunning then Exit(StartService);
  if Assigned(Nexagon) then
  begin
    Nexagon.SyncPhpIni;
    if Nexagon.AutoVirtualHosts then
      Nexagon.GenerateAutoVirtualHosts;
    if SameText(Name, 'Apache') then
      Nexagon.SyncApacheConfig
    else if SameText(Name, 'Nginx') then
    begin
      Nexagon.SyncNginxConfig;
      Nexagon.EnsureNginxPhpUpstreamRunning;
    end;
  end;
  if SameText(Name, 'Nginx') then
  begin
    RunCommandHidden(GetExePath, '-p "' + GetVersionDir + '" -s reload', GetVersionDir, False);
    Sleep(40);
    Result := CheckRunning;
  end
  else
  begin
    StopService;
    Result := StartService;
  end;
  if Assigned(UI) then UI.UpdateUI(False);
end;

{ TMySQL }

constructor TMySQL.Create;
begin
  inherited Create('MySQL', 'mysql', 3306);
  Enabled := True;
  ImageIndex := 12;
  ExeSubPath := 'bin\mysqld.exe';
  ConfigSubPath := 'my.ini';
end;

function TMySQL.GetDataDir: string;
var
  VerTag: string;
begin
  VerTag := 'mysql-8';
  if Pos('5.7', CurrentVersion) > 0 then VerTag := 'mysql-5.7'
  else if Pos('8.4', CurrentVersion) > 0 then VerTag := 'mysql-8.4'
  else if Pos('mariadb', LowerCase(CurrentVersion)) > 0 then VerTag := 'mariadb';
  if Assigned(Nexagon) and (Nexagon.DataDir <> '') then
    Result := IncludeTrailingPathDelimiter(Nexagon.DataDir) + VerTag
  else
    Result := IncludeTrailingPathDelimiter(GetVersionDir) + 'data';
end;

function TMySQL.GetLogPath: string;
begin
  Result := IncludeTrailingPathDelimiter(GetDataDir) + 'mysqld.log';
end;

function TMySQL.StartService: Boolean;
var
  Exe, DDir, LogFile, Cmd: string;
begin
  if CheckRunning then Exit(True);
  Exe := GetExePath;
  if not FileExists(Exe) then Exit(False);

  if Assigned(Nexagon) then
    Nexagon.SyncMySqlConfig;

  DDir := GetDataDir;
  ForceDirectories(DDir);
  if not DirectoryExists(IncludeTrailingPathDelimiter(DDir) + 'mysql') then
    RunCommandHidden(Exe, '--defaults-file="' + GetConfigPath + '" --initialize-insecure --console', GetVersionDir, True);

  LogFile := GetLogPath;
  Cmd := Format('"%s" --defaults-file="%s" --log-error="%s"', [Exe, GetConfigPath, LogFile]);
  if Assigned(ServiceThread) then
  begin
    ServiceThread.Terminate;
    FreeAndNil(ServiceThread);
  end;
  ServiceThread := TServiceThread.Create(True, Self);
  ServiceThread.CommandLine := Cmd;
  ServiceThread.WorkDir := GetVersionDir;
  ServiceThread.Start;
  Result := WaitForServiceReady(Self, 3500);
  if Assigned(UI) then UI.UpdateUI(False);
end;

function TMySQL.StopService: Boolean;
var
  AdminExe: string;
  WaitStep: Integer;
begin
  AdminExe := IncludeTrailingPathDelimiter(GetVersionDir) + 'bin\mysqladmin.exe';
  if FileExists(AdminExe) then
  begin
    RunCommandHidden(AdminExe, Format('-u root -P %d shutdown', [Port]), GetVersionDir, False);
    for WaitStep := 1 to 6 do
    begin
      Sleep(20);
      if FindProcessPidByName('mysqld.exe') = 0 then Break;
    end;
  end;
  Result := inherited StopService;
end;

function TMySQL.ResetRootPassword(const NewPass: string; OutLog: TStrings): Boolean;
var
  InitFile: string;
  SL: TStringList;
begin
  Result := False;
  if Assigned(OutLog) then OutLog.Add('Stopping running MySQL instance...');
  StopService;
  InitFile := IncludeTrailingPathDelimiter(Nexagon.GetTmpDir) + 'mysql_init.sql';
  SL := TStringList.Create;
  try
    SL.Add(Format('ALTER USER ''root''@''localhost'' IDENTIFIED BY ''%s'';', [NewPass]));
    SL.Add('FLUSH PRIVILEGES;');
    SL.SaveToFile(InitFile);
    if Assigned(OutLog) then OutLog.Add('Updating root password...');
    Result := StartService;
  finally
    SL.Free;
  end;
end;

function TMySQL.CreateDatabase(const DbName: string; out ErrMsg: string): Boolean;
var
  ClientExe, CleanName: string;
begin
  ErrMsg := '';
  Result := False;
  CleanName := StringReplace(DbName, '-', '_', [rfReplaceAll]);
  ClientExe := IncludeTrailingPathDelimiter(GetVersionDir) + 'bin\mysql.exe';
  if not FileExists(ClientExe) then
  begin
    ErrMsg := 'mysql.exe not found';
    Exit(False);
  end;
  Result := RunCommandHidden(ClientExe,
    Format('-u root -P %d -e "CREATE DATABASE IF NOT EXISTS `%s` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"',
    [Port, CleanName]), GetVersionDir, True) = 0;
end;

function TMySQL.BackupAllDatabases(out BackupDir: string): Boolean;
var
  DumpExe, OutFile: string;
begin
  Result := False;
  BackupDir := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'backup\mysql';
  ForceDirectories(BackupDir);
  DumpExe := IncludeTrailingPathDelimiter(GetVersionDir) + 'bin\mysqldump.exe';
  if not FileExists(DumpExe) then Exit(False);
  OutFile := IncludeTrailingPathDelimiter(BackupDir) + 'all-databases-' + FormatDateTime('yyyymmdd-hhnnss', Now) + '.sql';
  Result := RunCommandHidden(DumpExe,
    Format('-u root -P %d --all-databases --result-file="%s"', [Port, OutFile]), GetVersionDir, True) = 0;
end;

{ TMongoDB }

constructor TMongoDB.Create;
begin
  inherited Create('MongoDB', 'mongodb', 27017);
  ImageIndex := 12;
  ExeSubPath := 'bin\mongod.exe';
  ConfigSubPath := 'mongod.cfg';
end;

function TMongoDB.GetDataDir: string;
begin
  if Assigned(Nexagon) and (Nexagon.DataDir <> '') then
    Result := IncludeTrailingPathDelimiter(Nexagon.DataDir) + 'mongodb'
  else
    Result := IncludeTrailingPathDelimiter(GetVersionDir) + 'data';
end;

function TMongoDB.GetLogPath: string;
begin
  Result := IncludeTrailingPathDelimiter(GetDataDir) + 'mongod.log';
end;

function TMongoDB.StartService: Boolean;
var
  Exe: string;
begin
  if CheckRunning then Exit(True);
  Exe := GetExePath;
  if not FileExists(Exe) then Exit(False);
  ForceDirectories(GetDataDir);
  if Assigned(ServiceThread) then FreeAndNil(ServiceThread);
  ServiceThread := TServiceThread.Create(True, Self);
  ServiceThread.CommandLine := Format('"%s" --dbpath "%s" --logpath "%s" --port %d', [Exe, GetDataDir, GetLogPath, Port]);
  ServiceThread.WorkDir := GetVersionDir;
  ServiceThread.Start;
  Result := WaitForServiceReady(Self, 2000);
  if Assigned(UI) then UI.UpdateUI(False);
end;

{ TPostgreSQL }

constructor TPostgreSQL.Create;
begin
  inherited Create('PostgreSQL', 'postgresql', 5432);
  ImageIndex := 12;
  ExeSubPath := 'bin\postgres.exe';
end;

function TPostgreSQL.GetDataDir: string;
begin
  if Assigned(Nexagon) and (Nexagon.DataDir <> '') then
    Result := IncludeTrailingPathDelimiter(Nexagon.DataDir) + 'postgresql'
  else
    Result := IncludeTrailingPathDelimiter(GetVersionDir) + 'data';
end;

function TPostgreSQL.GetLogPath: string;
begin
  Result := IncludeTrailingPathDelimiter(GetDataDir) + 'postgresql.log';
end;

function TPostgreSQL.StartService: Boolean;
var
  PgCtl, InitDb: string;
begin
  if CheckRunning then Exit(True);
  PgCtl := IncludeTrailingPathDelimiter(GetVersionDir) + 'bin\pg_ctl.exe';
  InitDb := IncludeTrailingPathDelimiter(GetVersionDir) + 'bin\initdb.exe';
  if not FileExists(PgCtl) then Exit(False);
  ForceDirectories(GetDataDir);
  if not FileExists(IncludeTrailingPathDelimiter(GetDataDir) + 'PG_VERSION') and FileExists(InitDb) then
    RunCommandHidden(InitDb, Format('-D "%s" -U postgres -E UTF8', [GetDataDir]), GetVersionDir, True);
  RunCommandHidden(PgCtl, Format('-D "%s" -l "%s" -w start', [GetDataDir, GetLogPath]), GetVersionDir, True);
  Result := WaitForServiceReady(Self, 2000);
  if Assigned(UI) then UI.UpdateUI(False);
end;

function TPostgreSQL.StopService: Boolean;
var
  PgCtl: string;
begin
  PgCtl := IncludeTrailingPathDelimiter(GetVersionDir) + 'bin\pg_ctl.exe';
  if FileExists(PgCtl) then
    RunCommandHidden(PgCtl, Format('-D "%s" -l "%s" -w stop', [GetDataDir, GetLogPath]), GetVersionDir, True);
  Result := inherited StopService;
end;

{ TPHP }

constructor TPHP.Create;
begin
  inherited Create('PHP', 'php', 8000);
  ImageIndex := 5;
  ExeSubPath := 'php.exe';
  ConfigSubPath := 'php.ini';
end;

function TPHP.GetExtDir: string;
begin
  Result := IncludeTrailingPathDelimiter(GetVersionDir) + 'ext';
end;

function TPHP.GetErrorLogPath: string;
begin
  if Assigned(Nexagon) then
    Result := IncludeTrailingPathDelimiter(Nexagon.GetTmpDir) + 'php_errors.log'
  else
    Result := IncludeTrailingPathDelimiter(GetVersionDir) + 'php_errors.log';
end;

function TPHP.GetXdebugDllPath: string;
var
  SR: TSearchRec;
begin
  Result := '';
  if FindFirst(IncludeTrailingPathDelimiter(GetExtDir) + '*xdebug*.dll', faAnyFile, SR) = 0 then
  begin
    Result := IncludeTrailingPathDelimiter(GetExtDir) + SR.Name;
    FindClose(SR);
  end;
end;

function ParsePhpIniExtensionLine(const Line: string; out IsCommented: Boolean; out ExtToken: string): Boolean;
var
  S, LowS: string;
  P: Integer;
begin
  Result := False;
  IsCommented := False;
  ExtToken := '';
  S := TrimLeft(Line);
  if S = '' then Exit;
  if S[1] = ';' then
  begin
    Delete(S, 1, 1);
    // Skip docblock prose comments like ";   extension=mysqli" or ";;;;"
    if (S = '') or (S[1] = ';') or ((Length(S) >= 2) and (S[1] = ' ') and (S[2] = ' ')) then
      Exit;
    IsCommented := True;
    S := TrimLeft(S);
  end;
  LowS := LowerCase(S);
  if Pos('zend_extension', LowS) = 1 then
    Delete(S, 1, 14)
  else if Pos('extension', LowS) = 1 then
    Delete(S, 1, 9)
  else
    Exit;

  S := TrimLeft(S);
  if (S = '') or (S[1] <> '=') then Exit;
  Delete(S, 1, 1);
  P := Pos(';', S);
  if P > 0 then
    S := Copy(S, 1, P - 1);
  S := Trim(S);
  if (Length(S) >= 2) and (S[1] = '"') and (S[Length(S)] = '"') then
    S := Copy(S, 2, Length(S) - 2);
  if Pos('.so', LowerCase(S)) > 0 then Exit;
  S := LowerCase(ExtractFileName(S));
  if RightStr(S, 4) = '.dll' then
    SetLength(S, Length(S) - 4);
  if Pos('php_', S) = 1 then
    Delete(S, 1, 4);
  ExtToken := Trim(S);
  Result := ExtToken <> '';
end;

procedure TPHP.GetExtensions(OutList: TStrings);
var
  SR: TSearchRec;
  ExtName, ExtTok: string;
  SL, ActiveExts: TStringList;
  I: Integer;
  IsCommented, IsActive: Boolean;
begin
  OutList.Clear;
  ActiveExts := TStringList.Create;
  try
    if FileExists(GetConfigPath) then
    begin
      SL := TStringList.Create;
      try
        SL.LoadFromFile(GetConfigPath);
        for I := 0 to SL.Count - 1 do
          if ParsePhpIniExtensionLine(SL[I], IsCommented, ExtTok) and not IsCommented then
            if ActiveExts.IndexOf(ExtTok) < 0 then
              ActiveExts.Add(ExtTok);
      finally
        SL.Free;
      end;
    end;

    if FindFirst(IncludeTrailingPathDelimiter(GetExtDir) + 'php_*.dll', faAnyFile, SR) = 0 then
    begin
      repeat
        ExtName := ChangeFileExt(SR.Name, '');
        if Pos('php_', LowerCase(ExtName)) = 1 then
          Delete(ExtName, 1, 4);
        IsActive := (ActiveExts.IndexOf(LowerCase(ExtName)) >= 0) or
                    ((Pos('xdebug', LowerCase(ExtName)) = 1) and (ActiveExts.IndexOf('xdebug') >= 0));
        if IsActive then
          OutList.AddObject(ExtName, TObject(1))
        else
          OutList.AddObject(ExtName, TObject(0));
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  finally
    ActiveExts.Free;
  end;
end;

function TPHP.ToggleExtension(const ExtName: string): Boolean;
var
  SL: TStringList;
  I, ActiveIdx, CommentedIdx: Integer;
  CleanExt, ExtTok, TrimmedLine: string;
  IsCommented: Boolean;
begin
  Result := False;
  if not FileExists(GetConfigPath) then
  begin
    if Assigned(Nexagon) then Nexagon.SyncPhpIni;
  end;
  if not FileExists(GetConfigPath) then Exit;

  CleanExt := LowerCase(Trim(ExtName));
  if Pos('php_', CleanExt) = 1 then Delete(CleanExt, 1, 4);
  if RightStr(CleanExt, 4) = '.dll' then SetLength(CleanExt, Length(CleanExt) - 4);

  SL := TStringList.Create;
  try
    SL.LoadFromFile(GetConfigPath);
    ActiveIdx := -1;
    CommentedIdx := -1;
    for I := 0 to SL.Count - 1 do
    begin
      if ParsePhpIniExtensionLine(SL[I], IsCommented, ExtTok) and
         (SameText(ExtTok, CleanExt) or ((CleanExt = 'xdebug') and (Pos('xdebug', ExtTok) = 1))) then
      begin
        if not IsCommented then
        begin
          ActiveIdx := I;
          Break;
        end
        else if CommentedIdx < 0 then
          CommentedIdx := I;
      end;
    end;

    if ActiveIdx >= 0 then
    begin
      TrimmedLine := TrimLeft(SL[ActiveIdx]);
      SL[ActiveIdx] := ';' + TrimmedLine;
    end
    else if CommentedIdx >= 0 then
    begin
      TrimmedLine := TrimLeft(SL[CommentedIdx]);
      if (TrimmedLine <> '') and (TrimmedLine[1] = ';') then
        Delete(TrimmedLine, 1, 1);
      SL[CommentedIdx] := TrimLeft(TrimmedLine);
    end
    else
    begin
      if SameText(CleanExt, 'opcache') or (Pos('xdebug', CleanExt) = 1) then
        SL.Add('zend_extension=' + CleanExt)
      else
        SL.Add('extension=' + CleanExt);
    end;
    SL.SaveToFile(GetConfigPath);
    Result := True;
  finally
    SL.Free;
  end;
end;

function TPHP.GetIniSetting(const KeyName, DefaultVal: string): string;
var
  SL: TStringList;
  I, P: Integer;
  L: string;
begin
  Result := DefaultVal;
  if not FileExists(GetConfigPath) then Exit;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(GetConfigPath);
    for I := 0 to SL.Count - 1 do
    begin
      L := Trim(SL[I]);
      if (L = '') or (L[1] = ';') then Continue;
      P := Pos('=', L);
      if (P > 0) and SameText(Trim(Copy(L, 1, P - 1)), KeyName) then
      begin
        Result := Trim(Copy(L, P + 1, MaxInt));
        Exit;
      end;
    end;
  finally
    SL.Free;
  end;
end;

function TPHP.SetIniSetting(const KeyName, Val: string): Boolean;
var
  SL: TStringList;
  I, P: Integer;
  L: string;
  Updated: Boolean;
begin
  Result := False;
  if not FileExists(GetConfigPath) then Exit;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(GetConfigPath);
    Updated := False;
    for I := 0 to SL.Count - 1 do
    begin
      L := Trim(SL[I]);
      if (L = '') or (L[1] = ';') then Continue;
      P := Pos('=', L);
      if (P > 0) and SameText(Trim(Copy(L, 1, P - 1)), KeyName) then
      begin
        SL[I] := KeyName + ' = ' + Val;
        Updated := True;
        Break;
      end;
    end;
    if not Updated then
      SL.Add(KeyName + ' = ' + Val);
    SL.SaveToFile(GetConfigPath);
    Result := True;
  finally
    SL.Free;
  end;
end;

{ TPython / TRuby / TJava / TGo / TCmder }

constructor TPython.Create;
begin
  inherited Create('Python', 'python', 0);
  ExeSubPath := 'python.exe';
end;

constructor TRuby.Create;
begin
  inherited Create('Ruby', 'ruby', 0);
  ExeSubPath := 'bin\ruby.exe';
end;

constructor TJava.Create;
begin
  inherited Create('Java', 'java', 0);
  ExeSubPath := 'bin\java.exe';
end;

constructor TGo.Create;
begin
  inherited Create('Go', 'go', 0);
  ExeSubPath := 'bin\go.exe';
end;

function TGo.GetGoPath: string;
begin
  if Assigned(Nexagon) then
    Result := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'go'
  else
    Result := 'go';
end;

function TGo.GetGoRoot: string;
begin
  Result := GetVersionDir;
end;

constructor TCmder.Create;
begin
  inherited Create('Cmder', 'cmder');
  CurrentVersion := '';
  ExeSubPath := 'Cmder.exe';
end;

procedure TCmder.OpenTerminal(const WorkDir: string);
var
  TargetDir, Exe: string;
begin
  TargetDir := WorkDir;
  if (TargetDir = '') and Assigned(Nexagon) then
    TargetDir := Nexagon.DocumentRoot;
  Exe := IncludeTrailingPathDelimiter(GetBaseDir) + 'Cmder.exe';
  if FileExists(Exe) then
    ShellExecute(0, 'open', PChar(Exe), PChar('/START "' + TargetDir + '"'), PChar(GetBaseDir), SW_SHOWNORMAL)
  else
    ShellExecute(0, 'open', 'cmd.exe', PChar('/k cd /d "' + TargetDir + '"'), PChar(TargetDir), SW_SHOWNORMAL);
end;

{ TNexagon }

constructor TNexagon.Create;
begin
  inherited Create;
  LangStrings := TStringList.Create;
  SitesConf := TStringList.Create;
  PackagesConf := TStringList.Create;
  RootDir := DetectRootDir;
  DocumentRoot := IncludeTrailingPathDelimiter(RootDir) + 'www';
  DocumentRootList := DocumentRoot;
  DataDir := IncludeTrailingPathDelimiter(RootDir) + 'data';
  Language := 'English';
  Profile := 'default';
  HostnameFormat := '{name}.test';
  RunAtStartup := False;
  MinimizeWhenRun := False;
  AutoStart := 0;
  AutoVirtualHosts := True;
  AutoBackup := False;
  BackupInterval := 8;
  AutoUpdate := False;
  MailCatcherEnabled := True;
  MailCatcherDisplayTime := 3;
  MailSenderEnabled := False;
  GmailAddress := '';
  GmailPassword := '';
end;

destructor TNexagon.Destroy;
begin
  PackagesConf.Free;
  SitesConf.Free;
  LangStrings.Free;
  inherited Destroy;
end;

function TNexagon.DetectRootDir: string;
var
  ExeDir: string;
begin
  ExeDir := ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  if DirectoryExists(ExeDir + '\bin') and DirectoryExists(ExeDir + '\usr') then
    Result := ExeDir
  else if DirectoryExists('E:\nexagon\bin') then
    Result := 'E:\nexagon'
  else
    Result := ExeDir;
end;

function TNexagon.GetUsrDir: string;
begin
  Result := IncludeTrailingPathDelimiter(RootDir) + 'usr';
end;

function TNexagon.GetTmpDir: string;
begin
  Result := IncludeTrailingPathDelimiter(RootDir) + 'tmp';
  ForceDirectories(Result);
end;

function TNexagon.GetSslDir: string;
begin
  Result := IncludeTrailingPathDelimiter(RootDir) + 'etc\ssl';
  ForceDirectories(Result);
end;

function TNexagon.GetMailCatcherDir: string;
begin
  Result := IncludeTrailingPathDelimiter(RootDir) + 'bin\nexagon\mail';
  if not DirectoryExists(Result) then
    Result := IncludeTrailingPathDelimiter(GetTmpDir) + 'mail';
  ForceDirectories(Result);
end;

function TNexagon.GetMailSenderDir: string;
begin
  Result := IncludeTrailingPathDelimiter(RootDir) + 'bin\sendmail';
  ForceDirectories(Result);
end;

function TNexagon.GetIniPath: string;
begin
  ForceDirectories(GetUsrDir);
  Result := GetUsrDir + '\nexagon.ini';
end;

procedure TNexagon.AddDocumentRootToList(const ADir: string);
var
  SL: TStringList;
  CleanDir, DefaultWww: string;
begin
  CleanDir := ExcludeTrailingPathDelimiter(Trim(ADir));
  if CleanDir = '' then Exit;
  SL := TStringList.Create;
  try
    GetDocumentRootListItems(SL);
    if SL.IndexOf(CleanDir) < 0 then
      SL.Add(CleanDir);
    DefaultWww := IncludeTrailingPathDelimiter(RootDir) + 'www';
    if SL.IndexOf(DefaultWww) < 0 then
      SL.Insert(0, DefaultWww);
    SL.Delimiter := '|';
    SL.StrictDelimiter := True;
    DocumentRootList := SL.DelimitedText;
  finally
    SL.Free;
  end;
end;

procedure TNexagon.GetDocumentRootListItems(OutList: TStrings);
var
  Parts: TStringList;
  I, J: Integer;
  Item, DefaultWww, CurDocRoot: string;
  ExistsInOut: Boolean;

  procedure AddUnique(const S: string);
  var
    CleanS: string;
    K: Integer;
  begin
    CleanS := ExcludeTrailingPathDelimiter(Trim(S));
    if CleanS = '' then Exit;
    for K := 0 to OutList.Count - 1 do
      if SameText(OutList[K], CleanS) then Exit;
    OutList.Add(CleanS);
  end;

begin
  if not Assigned(OutList) then Exit;
  OutList.Clear;
  DefaultWww := IncludeTrailingPathDelimiter(RootDir) + 'www';
  AddUnique(DefaultWww);
  Parts := TStringList.Create;
  try
    Parts.Delimiter := '|';
    Parts.StrictDelimiter := True;
    Parts.DelimitedText := DocumentRootList;
    for I := 0 to Parts.Count - 1 do
    begin
      Item := ExcludeTrailingPathDelimiter(Trim(Parts[I]));
      if (Item <> '') and (DirectoryExists(Item) or SameText(Item, ExcludeTrailingPathDelimiter(DocumentRoot))) then
        AddUnique(Item);
    end;
  finally
    Parts.Free;
  end;
  CurDocRoot := ExcludeTrailingPathDelimiter(Trim(DocumentRoot));
  if CurDocRoot <> '' then
    AddUnique(CurDocRoot);
end;

procedure TNexagon.LoadConfig;
var
  Ini, ProfIni: TMemIniFile;
  ProfPath, V, SavedProf: string;

  function ReadUseBool(const Sec: string; DefaultUse: Boolean): Boolean;
  var
    DefInt: Integer;
  begin
    if DefaultUse then DefInt := -1 else DefInt := 0;
    Result := Ini.ReadInteger(Sec, 'Use', DefInt) <> 0;
  end;

  function ReadVer(const Sec, DefaultVer: string): string;
  begin
    Result := '';
    if Assigned(ProfIni) then
      Result := ProfIni.ReadString(Sec, 'Version', '');
    if Result = '' then
      Result := Ini.ReadString(Sec, 'Version', '');
    if Result = '' then
      Result := DefaultVer;
  end;

begin
  if not FileExists(GetIniPath) then
  begin
    if FileExists(GetUsrDir + '\tpl\nexagon.ini.tpl') then
      CopyFile(PChar(GetUsrDir + '\tpl\nexagon.ini.tpl'), PChar(GetIniPath), False);
  end;
  ProfIni := nil;
  Ini := TMemIniFile.Create(GetIniPath);
  try
    SavedProf := Ini.ReadString('preferences', 'Profile', '');
    if (Profile = '') or (SameText(Profile, 'default') and (SavedProf <> '')) then
      Profile := SavedProf;
    if Profile = '' then
      Profile := 'default';

    ProfPath := GetUsrDir + '\profile\' + Profile + '.ini';
    if FileExists(ProfPath) then
      ProfIni := TMemIniFile.Create(ProfPath);

    DocumentRoot := ExcludeTrailingPathDelimiter(Ini.ReadString('apache', 'DocumentRoot',
      Ini.ReadString('preferences', 'DocumentRoot', IncludeTrailingPathDelimiter(RootDir) + 'www')));
    DocumentRootList := Ini.ReadString('preferences', 'DocumentRootList', IncludeTrailingPathDelimiter(RootDir) + 'www');
    AddDocumentRootToList(DocumentRoot);
    DataDir := Ini.ReadString('preferences', 'DataDir', IncludeTrailingPathDelimiter(RootDir) + 'data');
    Language := Ini.ReadString('preferences', 'Lang', Ini.ReadString('preferences', 'Language', 'English'));
    HostnameFormat := Ini.ReadString('preferences', 'HostnameFormat', '{name}.test');
    RunAtStartup := Ini.ReadInteger('preferences', 'RunAtStartup', 0) <> 0;
    MinimizeWhenRun := Ini.ReadInteger('preferences', 'MinimizeWhenRun', 0) <> 0;
    AutoStart := Ini.ReadInteger('preferences', 'AutoStart', 0);
    AutoVirtualHosts := Ini.ReadInteger('preferences', 'AutoVirtualHosts', -1) <> 0;
    AutoBackup := Ini.ReadInteger('preferences', 'AutoBackup', -1) <> 0;
    BackupInterval := Ini.ReadInteger('preferences', 'BackupInterval', 8);
    AutoUpdate := Ini.ReadInteger('preferences', 'AutoUpdate', -1) <> 0;

    MailCatcherEnabled := Ini.ReadInteger('MailCatcher', 'Enabled', -1) <> 0;
    MailCatcherDisplayTime := Ini.ReadInteger('MailCatcher', 'WindowDisplayTime', 3);
    MailSenderEnabled := Ini.ReadInteger('MailSender', 'Enabled', 0) <> 0;
    GmailAddress := Ini.ReadString('MailSender', 'Email', '');
    GmailPassword := Ini.ReadString('MailSender', 'Password', '');

    if Assigned(SrvPHP) then
    begin
      V := ReadVer('php', SrvPHP.CurrentVersion);
      if (V <> '') and DirectoryExists(SrvPHP.GetBaseDir + '\' + V) then
        SrvPHP.CurrentVersion := V;
      SrvPHP.Enabled := ReadUseBool('php', False);
      SrvPHP.Port := Ini.ReadInteger('php', 'Port', 8000);
    end;
    if Assigned(SrvApache) then
    begin
      V := ReadVer('apache', SrvApache.CurrentVersion);
      if (V <> '') and DirectoryExists(SrvApache.GetBaseDir + '\' + V) then
        SrvApache.CurrentVersion := V;
      SrvApache.Enabled := ReadUseBool('apache', True);
      SrvApache.Port := Ini.ReadInteger('apache', 'Port', 80);
      SrvApache.SslPort := Ini.ReadInteger('apache', 'SslPort', 443);
      SrvApache.SslEnabled := Ini.ReadInteger('apache', 'SSLEnabled', 0) <> 0;
    end;
    if Assigned(SrvMySQL) then
    begin
      V := ReadVer('mysql', SrvMySQL.CurrentVersion);
      if (V <> '') and DirectoryExists(SrvMySQL.GetBaseDir + '\' + V) then
        SrvMySQL.CurrentVersion := V;
      SrvMySQL.Enabled := ReadUseBool('mysql', True);
      SrvMySQL.Port := Ini.ReadInteger('mysql', 'Port', 3306);
    end;
    if Assigned(SrvNginx) then
    begin
      V := ReadVer('nginx', SrvNginx.CurrentVersion);
      if (V <> '') and DirectoryExists(SrvNginx.GetBaseDir + '\' + V) then
        SrvNginx.CurrentVersion := V;
      SrvNginx.Enabled := ReadUseBool('nginx', False);
      SrvNginx.Port := Ini.ReadInteger('nginx', 'Port', 8080);
      SrvNginx.SslPort := Ini.ReadInteger('nginx', 'SslPort', 8443);
      SrvNginx.SslEnabled := Ini.ReadInteger('nginx', 'SSLEnabled', 0) <> 0;
    end;
    if Assigned(SrvPostgreSQL) then
    begin
      V := ReadVer('postgresql', SrvPostgreSQL.CurrentVersion);
      if (V <> '') and DirectoryExists(SrvPostgreSQL.GetBaseDir + '\' + V) then
        SrvPostgreSQL.CurrentVersion := V;
      SrvPostgreSQL.Enabled := ReadUseBool('postgresql', True);
      SrvPostgreSQL.Port := Ini.ReadInteger('postgresql', 'Port', 5432);
    end;
    if Assigned(SrvMongoDB) then
    begin
      V := ReadVer('mongodb', SrvMongoDB.CurrentVersion);
      if (V <> '') and DirectoryExists(SrvMongoDB.GetBaseDir + '\' + V) then
        SrvMongoDB.CurrentVersion := V;
      SrvMongoDB.Enabled := ReadUseBool('mongodb', True);
      SrvMongoDB.Port := Ini.ReadInteger('mongodb', 'Port', 27017);
    end;
    if Assigned(SrvMemcached) then
    begin
      V := ReadVer('memcached', SrvMemcached.CurrentVersion);
      if (V <> '') and DirectoryExists(SrvMemcached.GetBaseDir + '\' + V) then
        SrvMemcached.CurrentVersion := V;
      SrvMemcached.Enabled := ReadUseBool('memcached', False);
      SrvMemcached.Port := Ini.ReadInteger('memcached', 'Port', 11211);
    end;
    if Assigned(SrvRedis) then
    begin
      V := ReadVer('redis', SrvRedis.CurrentVersion);
      if (V <> '') and DirectoryExists(SrvRedis.GetBaseDir + '\' + V) then
        SrvRedis.CurrentVersion := V;
      SrvRedis.Enabled := ReadUseBool('redis', False);
      SrvRedis.Port := Ini.ReadInteger('redis', 'Port', 6379);
    end;
    if Assigned(SrvMailpit) then
    begin
      V := ReadVer('mailpit', SrvMailpit.CurrentVersion);
      if (V <> '') and DirectoryExists(SrvMailpit.GetBaseDir + '\' + V) then
        SrvMailpit.CurrentVersion := V;
      SrvMailpit.Enabled := ReadUseBool('mailpit', True);
      SrvMailpit.Port := Ini.ReadInteger('mailpit', 'Port', 1025);
    end;
  finally
    Ini.Free;
    if Assigned(ProfIni) then ProfIni.Free;
  end;
  LoadLanguage(Language);
  LoadSitesAndPackages;
  SyncApacheConfig;
  SyncNginxConfig;
end;

procedure TNexagon.SaveConfig;
var
  Ini, ProfIni: TMemIniFile;
  ProfPath: string;

  function BoolInt(B: Boolean): Integer;
  begin
    if B then Result := -1 else Result := 0;
  end;

begin
  Ini := TMemIniFile.Create(GetIniPath);
  ProfPath := GetUsrDir + '\profile\' + Profile + '.ini';
  ForceDirectories(ExtractFilePath(ProfPath));
  ProfIni := TMemIniFile.Create(ProfPath);
  try
    AddDocumentRootToList(DocumentRoot);
    Ini.WriteString('preferences', 'Profile', Profile);
    Ini.WriteString('preferences', 'DocumentRootList', DocumentRootList);
    Ini.WriteString('preferences', 'DataDir', DataDir);
    Ini.WriteString('preferences', 'Lang', Language);
    Ini.WriteString('preferences', 'HostnameFormat', HostnameFormat);
    Ini.WriteInteger('preferences', 'RunAtStartup', BoolInt(RunAtStartup));
    Ini.WriteInteger('preferences', 'MinimizeWhenRun', BoolInt(MinimizeWhenRun));
    Ini.WriteInteger('preferences', 'AutoStart', AutoStart);
    Ini.WriteInteger('preferences', 'AutoVirtualHosts', BoolInt(AutoVirtualHosts));
    Ini.WriteInteger('preferences', 'AutoBackup', BoolInt(AutoBackup));
    Ini.WriteInteger('preferences', 'BackupInterval', BackupInterval);
    Ini.WriteInteger('preferences', 'AutoUpdate', BoolInt(AutoUpdate));

    Ini.WriteInteger('MailCatcher', 'Enabled', BoolInt(MailCatcherEnabled));
    Ini.WriteInteger('MailCatcher', 'WindowDisplayTime', MailCatcherDisplayTime);
    Ini.WriteInteger('MailSender', 'Enabled', BoolInt(MailSenderEnabled));
    Ini.WriteString('MailSender', 'Email', GmailAddress);
    Ini.WriteString('MailSender', 'Password', GmailPassword);

    if Assigned(SrvPHP) then
    begin
      ProfIni.WriteString('php', 'Version', SrvPHP.CurrentVersion);
      Ini.WriteInteger('php', 'Use', BoolInt(SrvPHP.Enabled));
      Ini.WriteInteger('php', 'Port', SrvPHP.Port);
    end;
    if Assigned(SrvApache) then
    begin
      Ini.WriteString('apache', 'DocumentRoot', DocumentRoot);
      ProfIni.WriteString('apache', 'Version', SrvApache.CurrentVersion);
      Ini.WriteInteger('apache', 'Use', BoolInt(SrvApache.Enabled));
      Ini.WriteInteger('apache', 'Port', SrvApache.Port);
      Ini.WriteInteger('apache', 'SslPort', SrvApache.SslPort);
      Ini.WriteInteger('apache', 'SSLEnabled', BoolInt(SrvApache.SslEnabled));
    end;
    if Assigned(SrvMySQL) then
    begin
      ProfIni.WriteString('mysql', 'Version', SrvMySQL.CurrentVersion);
      Ini.WriteInteger('mysql', 'Use', BoolInt(SrvMySQL.Enabled));
      Ini.WriteInteger('mysql', 'Port', SrvMySQL.Port);
    end;
    if Assigned(SrvNginx) then
    begin
      ProfIni.WriteString('nginx', 'Version', SrvNginx.CurrentVersion);
      Ini.WriteInteger('nginx', 'Use', BoolInt(SrvNginx.Enabled));
      Ini.WriteInteger('nginx', 'Port', SrvNginx.Port);
      Ini.WriteInteger('nginx', 'SslPort', SrvNginx.SslPort);
      Ini.WriteInteger('nginx', 'SSLEnabled', BoolInt(SrvNginx.SslEnabled));
    end;
    if Assigned(SrvPostgreSQL) then
    begin
      ProfIni.WriteString('postgresql', 'Version', SrvPostgreSQL.CurrentVersion);
      Ini.WriteInteger('postgresql', 'Use', BoolInt(SrvPostgreSQL.Enabled));
      Ini.WriteInteger('postgresql', 'Port', SrvPostgreSQL.Port);
    end;
    if Assigned(SrvMongoDB) then
    begin
      ProfIni.WriteString('mongodb', 'Version', SrvMongoDB.CurrentVersion);
      Ini.WriteInteger('mongodb', 'Use', BoolInt(SrvMongoDB.Enabled));
      Ini.WriteInteger('mongodb', 'Port', SrvMongoDB.Port);
    end;
    if Assigned(SrvMemcached) then
    begin
      ProfIni.WriteString('memcached', 'Version', SrvMemcached.CurrentVersion);
      Ini.WriteInteger('memcached', 'Use', BoolInt(SrvMemcached.Enabled));
      Ini.WriteInteger('memcached', 'Port', SrvMemcached.Port);
    end;
    if Assigned(SrvRedis) then
    begin
      ProfIni.WriteString('redis', 'Version', SrvRedis.CurrentVersion);
      Ini.WriteInteger('redis', 'Use', BoolInt(SrvRedis.Enabled));
      Ini.WriteInteger('redis', 'Port', SrvRedis.Port);
    end;
    if Assigned(SrvMailpit) then
    begin
      ProfIni.WriteString('mailpit', 'Version', SrvMailpit.CurrentVersion);
      Ini.WriteInteger('mailpit', 'Use', BoolInt(SrvMailpit.Enabled));
      Ini.WriteInteger('mailpit', 'Port', SrvMailpit.Port);
    end;
    Ini.UpdateFile;
    ProfIni.UpdateFile;
  finally
    ProfIni.Free;
    Ini.Free;
  end;
end;

procedure TNexagon.LoadLanguage(const LangName: string);
var
  LangFile: string;
  SL: TStringList;
  I, P: Integer;
  Line, KeyStr, ValStr: string;
begin
  if LangName <> '' then
    Language := LangName;
  LangStrings.Clear;
  LangFile := IncludeTrailingPathDelimiter(RootDir) + 'bin\nexagon\lang\' + Language + '.txt';
  if not FileExists(LangFile) then
    LangFile := GetUsrDir + '\lang\' + Language + '.txt';
  if not FileExists(LangFile) then Exit;

  SL := TStringList.Create;
  try
    SL.LoadFromFile(LangFile);
    for I := 0 to SL.Count - 1 do
    begin
      Line := Trim(SL[I]);
      if (Line = '') or (Line[1] = '#') or (Line[1] = ';') then Continue;
      P := Pos('=', Line);
      if P > 0 then
      begin
        KeyStr := Trim(Copy(Line, 1, P - 1));
        ValStr := Trim(Copy(Line, P + 1, MaxInt));
        if ValStr <> '' then
          LangStrings.Values[KeyStr] := ValStr;
      end;
    end;
  finally
    SL.Free;
  end;
end;

function TNexagon.T(Id: Integer; const DefaultText: string): string;
var
  Val: string;
begin
  Val := LangStrings.Values[IntToStr(Id)];
  if Val <> '' then
    Result := StringReplace(Val, '\n', LineEnding, [rfReplaceAll])
  else
    Result := DefaultText;
  Result := StringReplace(Result, 'Nexagon', 'Nexagon', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TNexagon.ListAvailableLanguages(OutList: TStrings);
var
  SR: TSearchRec;
  LangDir: string;
begin
  OutList.Clear;
  LangDir := IncludeTrailingPathDelimiter(RootDir) + 'bin\nexagon\lang\';
  if FindFirst(LangDir + '*.txt', faAnyFile, SR) = 0 then
  begin
    repeat
      OutList.Add(ChangeFileExt(SR.Name, ''));
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  if OutList.IndexOf('English') < 0 then
    OutList.Insert(0, 'English');
end;

procedure TNexagon.ListProfiles(OutList: TStrings);
var
  SR: TSearchRec;
  ProfDir: string;
begin
  OutList.Clear;
  OutList.Add('default');
  ProfDir := GetUsrDir + '\profile\';
  if FindFirst(ProfDir + '*.ini', faAnyFile, SR) = 0 then
  begin
    repeat
      if not SameText(ChangeFileExt(SR.Name, ''), 'default') then
        OutList.Add(ChangeFileExt(SR.Name, ''));
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TNexagon.SwitchProfile(const ProfileName: string);
var
  Ini: TMemIniFile;
begin
  Profile := ProfileName;
  Ini := TMemIniFile.Create(GetIniPath);
  try
    Ini.WriteString('preferences', 'Profile', Profile);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
  LoadConfig;
end;

procedure TNexagon.SyncPhpIni;
var
  PhpIni, DevIni, ExtDirSlash, CaInfoSlash, L, DesiredExtLine, DesiredCaLine, OrigText: string;
  SL: TStringList;
  I, FirstExtDirIdx, CommentExtDirIdx, FirstCaIdx, CommentCaIdx: Integer;
begin
  if not Assigned(SrvPHP) then Exit;
  PhpIni := SrvPHP.GetConfigPath;
  if (PhpIni = '') then Exit;
  if not FileExists(PhpIni) then
  begin
    DevIni := IncludeTrailingPathDelimiter(SrvPHP.GetVersionDir) + 'php.ini-development';
    if FileExists(DevIni) then
      CopyFile(PChar(DevIni), PChar(PhpIni), False);
  end;
  if not FileExists(PhpIni) then Exit;

  ExtDirSlash := StringReplace(SrvPHP.GetExtDir, '\', '/', [rfReplaceAll]);
  CaInfoSlash := StringReplace(IncludeTrailingPathDelimiter(RootDir) + 'etc\ssl\cacert.pem', '\', '/', [rfReplaceAll]);
  DesiredExtLine := 'extension_dir = "' + ExtDirSlash + '"';
  DesiredCaLine := 'curl.cainfo = "' + CaInfoSlash + '"';

  SL := TStringList.Create;
  try
    SL.LoadFromFile(PhpIni);
    OrigText := SL.Text;
    FirstExtDirIdx := -1;
    CommentExtDirIdx := -1;
    FirstCaIdx := -1;
    CommentCaIdx := -1;

    for I := SL.Count - 1 downto 0 do
    begin
      L := LowerCase(Trim(SL[I]));
      if (Pos('extension_dir', L) = 1) and (Pos('=', L) > 0) then
      begin
        if FirstExtDirIdx >= 0 then
          SL.Delete(I);
        FirstExtDirIdx := I;
      end
      else if (Pos(';extension_dir', L) = 1) and (Pos('"ext"', L) > 0) then
        CommentExtDirIdx := I
      else if (Pos('curl.cainfo', L) = 1) and (Pos('=', L) > 0) then
      begin
        if FirstCaIdx >= 0 then
          SL.Delete(I);
        FirstCaIdx := I;
      end
      else if Pos(';curl.cainfo', L) = 1 then
        CommentCaIdx := I;
    end;

    if FirstExtDirIdx >= 0 then
      SL[FirstExtDirIdx] := DesiredExtLine
    else if CommentExtDirIdx >= 0 then
      SL.Insert(CommentExtDirIdx + 1, DesiredExtLine)
    else
      SL.Add(DesiredExtLine);

    if FileExists(IncludeTrailingPathDelimiter(RootDir) + 'etc\ssl\cacert.pem') then
    begin
      if FirstCaIdx >= 0 then
        SL[FirstCaIdx] := DesiredCaLine
      else if CommentCaIdx >= 0 then
        SL.Insert(CommentCaIdx + 1, DesiredCaLine);
    end;

    if SL.Text <> OrigText then
      SL.SaveToFile(PhpIni);
  finally
    SL.Free;
  end;
end;

procedure TNexagon.CopyPhpDllsToApache;
const
  ExcludedDlls: array[0..10] of string = (
    'zlib1.dll', 'ssleay32.dll', 'pcre.dll', 'nghttp2.dll', 'lua51.dll',
    'libxml2.dll', 'libhttpd.dll', 'libeay32.dll', 'libaprutil-1.dll',
    'libapriconv-1.dll', 'libapr-1.dll'
  );
var
  SR: TSearchRec;
  PhpDir, ApacheBin, SrcFile, DstFile: string;
  Skip: Boolean;
  I: Integer;
begin
  if not Assigned(SrvPHP) or not Assigned(SrvApache) then Exit;
  PhpDir := IncludeTrailingPathDelimiter(SrvPHP.GetVersionDir);
  ApacheBin := IncludeTrailingPathDelimiter(SrvApache.GetVersionDir) + 'bin\';
  if not DirectoryExists(PhpDir) or not DirectoryExists(ApacheBin) then Exit;

  if FindFirst(PhpDir + '*.dll', faAnyFile, SR) = 0 then
  begin
    repeat
      Skip := False;
      for I := Low(ExcludedDlls) to High(ExcludedDlls) do
        if SameText(SR.Name, ExcludedDlls[I]) then
        begin
          Skip := True;
          Break;
        end;
      if not Skip then
      begin
        SrcFile := PhpDir + SR.Name;
        DstFile := ApacheBin + SR.Name;
        if not FileExists(DstFile) then
          CopyFile(PChar(SrcFile), PChar(DstFile), False);
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TNexagon.SyncApacheConfig;
var
  HttpdConf, ModPhpConf, SslConf, DefaultConf: string;
  PhpDir,PhpDirRaw, DocRootFwd, RootFwd, SslDirFwd, ApacheVerFwd, PhpDll: string;
  SL: TStringList;
  SR: TSearchRec;
  I, J: Integer;
  Line: string;
begin
  if not Assigned(SrvApache) then Exit;
  HttpdConf := SrvApache.GetConfigPath;
  if not FileExists(HttpdConf) then Exit;

  if DocumentRoot <> '' then
    ForceDirectories(DocumentRoot);
  DocRootFwd := StringReplace(ExcludeTrailingPathDelimiter(DocumentRoot), '\', '/', [rfReplaceAll]);
  RootFwd := StringReplace(ExcludeTrailingPathDelimiter(RootDir), '\', '/', [rfReplaceAll]);
  SslDirFwd := StringReplace(ExcludeTrailingPathDelimiter(GetSslDir), '\', '/', [rfReplaceAll]);
  ApacheVerFwd := StringReplace(ExcludeTrailingPathDelimiter(SrvApache.GetVersionDir), '\', '/', [rfReplaceAll]);
  ForceDirectories(IncludeTrailingPathDelimiter(RootDir) + 'etc\apache2\sites-enabled');
  ForceDirectories(IncludeTrailingPathDelimiter(RootDir) + 'etc\apache2\alias');
  EnsureSslCertificates;

  // 1. Update etc/apache2/mod_php.conf (0x10007536d..0x1000755e1)
  if Assigned(SrvPHP) then
  begin
    PhpDirRaw := IncludeTrailingPathDelimiter(SrvPHP.GetVersionDir);
    PhpDir := StringReplace(ExcludeTrailingPathDelimiter(SrvPHP.GetVersionDir), '\', '/', [rfReplaceAll]);
    PhpDll := '';
    if FindFirst(PhpDirRaw + 'php*apache2_4.dll', faAnyFile, SR) = 0 then
    begin
      PhpDll := SR.Name;
      FindClose(SR);
    end;
    if PhpDll <> '' then
    begin
      ModPhpConf := IncludeTrailingPathDelimiter(RootDir) + 'etc\apache2\mod_php.conf';
      ForceDirectories(ExtractFilePath(ModPhpConf));
      SL := TStringList.Create;
      try
        SL.WriteBOM := False;
        SL.Add('# This file is auto-generated, so please keep it intact.');
        if FindFirst(PhpDirRaw + 'libcrypto*.dll', faAnyFile, SR) = 0 then
        begin
          SL.Add(Format('LoadFile "%s/%s"', [PhpDir, SR.Name]));
          FindClose(SR);
        end;
        if FindFirst(PhpDirRaw + 'libssl*.dll', faAnyFile, SR) = 0 then
        begin
          SL.Add(Format('LoadFile "%s/%s"', [PhpDir, SR.Name]));
          FindClose(SR);
        end;
        if Pos('php8', LowerCase(PhpDll)) = 1 then
          SL.Add(Format('LoadModule php_module "%s/%s"', [PhpDir, PhpDll]))
        else if Pos('php7', LowerCase(PhpDll)) = 1 then
          SL.Add(Format('LoadModule php7_module "%s/%s"', [PhpDir, PhpDll]))
        else
          SL.Add(Format('LoadModule php5_module "%s/%s"', [PhpDir, PhpDll]));
        SL.Add(Format('PHPIniDir "%s"', [PhpDir]));
        SL.Add('<IfModule mime_module>');
        SL.Add('    AddType application/x-httpd-php .php');
        SL.Add('</IfModule>');
        SL.SaveToFile(ModPhpConf);
      finally
        SL.Free;
      end;
    end;
  end;

  // 2. Update etc/apache2/httpd-ssl.conf (0x1000ac7fe..0x1000acb00)
  SslConf := IncludeTrailingPathDelimiter(RootDir) + 'etc\apache2\httpd-ssl.conf';
  SL := TStringList.Create;
  try
    SL.WriteBOM := False;
    if SrvApache.SslEnabled then
      SL.Add(Format('Listen %d', [SrvApache.SslPort]))
    else
      SL.Add(Format('#Listen %d', [SrvApache.SslPort]));
    SL.Add('SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4');
    SL.Add('SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4');
    SL.Add('SSLHonorCipherOrder on');
    SL.Add('SSLProtocol all -SSLv3');
    SL.Add('SSLProxyProtocol all -SSLv3');
    SL.Add('SSLPassPhraseDialog  builtin');
    SL.Add(Format('SSLSessionCache "shmcb:%s/logs/ssl_scache(512000)"', [ApacheVerFwd]));
    SL.Add('SSLSessionCacheTimeout  300');
    SL.SaveToFile(SslConf);
  finally
    SL.Free;
  end;

  // 3. Update etc/apache2/sites-enabled/00-default.conf (0x1000ac352..0x1000ac748)
  DefaultConf := IncludeTrailingPathDelimiter(RootDir) + 'etc\apache2\sites-enabled\00-default.conf';
  SL := TStringList.Create;
  try
    SL.WriteBOM := False;
    SL.Add(Format('<VirtualHost _default_:%d>', [SrvApache.Port]));
    SL.Add(Format('    DocumentRoot "%s"', [DocRootFwd]));
    SL.Add(Format('    <Directory "%s">', [DocRootFwd]));
    SL.Add('        Options Indexes FollowSymLinks Includes ExecCGI');
    SL.Add('        AllowOverride All');
    SL.Add('        Require all granted');
    SL.Add('    </Directory>');
    SL.Add('</VirtualHost>');
    if SrvApache.SslEnabled then
    begin
      SL.Add(Format('<VirtualHost _default_:%d>', [SrvApache.SslPort]));
      SL.Add(Format('    DocumentRoot "%s"', [DocRootFwd]));
      SL.Add(Format('    <Directory "%s">', [DocRootFwd]));
      SL.Add('        Options Indexes FollowSymLinks Includes ExecCGI');
      SL.Add('        AllowOverride All');
      SL.Add('        Require all granted');
      SL.Add('    </Directory>');
      SL.Add('    SSLEngine on');
      SL.Add(Format('    SSLCertificateFile      "%s/nexagon.crt"', [SslDirFwd]));
      SL.Add(Format('    SSLCertificateKeyFile   "%s/nexagon.key"', [SslDirFwd]));
      SL.Add('</VirtualHost>');
    end;
    SL.SaveToFile(DefaultConf);
  finally
    SL.Free;
  end;

  // 4. Update httpd.conf (DocumentRoot, <Directory>, Listen, Define SRVROOT / ServerRoot)
  SL := TStringList.Create;
  try
    SL.LoadFromFile(HttpdConf);
    SL.WriteBOM := False;
    for I := 0 to SL.Count - 1 do
    begin
      Line := Trim(SL[I]);
      if Pos('Define SRVROOT ', Line) = 1 then
        SL[I] := Format('Define SRVROOT "%s"', [ApacheVerFwd])
      else if Pos('ServerRoot ', Line) = 1 then
        SL[I] := Format('ServerRoot "%s"', [ApacheVerFwd])
      else if Pos('Listen ', Line) = 1 then
        SL[I] := 'Listen ' + IntToStr(SrvApache.Port)
      else if Pos('DocumentRoot ', Line) = 1 then
      begin
        SL[I] := Format('DocumentRoot "%s"', [DocRootFwd]);
        for J := I + 1 to I + 5 do
          if (J < SL.Count) and (Pos('<Directory ', Trim(SL[J])) = 1) then
          begin
            SL[J] := Format('<Directory "%s">', [DocRootFwd]);
            Break;
          end;
      end;
    end;
    SL.SaveToFile(HttpdConf);
  finally
    SL.Free;
  end;
end;

procedure TNexagon.SyncNginxConfig;
var
  UpstreamConf, NginxConfPath, TplPath, SnippetsDir, FastCgiPhpConf, DefaultConf: string;
  RootFwd, DocFwd, SslDirFwd, AliasDir, Content: string;
  SL: TStringList;
  SR: TSearchRec;
begin
  if not Assigned(SrvNginx) then Exit;
  RootFwd := StringReplace(ExcludeTrailingPathDelimiter(RootDir), '\', '/', [rfReplaceAll]);
  DocFwd := StringReplace(ExcludeTrailingPathDelimiter(DocumentRoot), '\', '/', [rfReplaceAll]);
  SslDirFwd := StringReplace(ExcludeTrailingPathDelimiter(GetSslDir), '\', '/', [rfReplaceAll]);

  ForceDirectories(IncludeTrailingPathDelimiter(RootDir) + 'etc\nginx\sites-enabled');
  ForceDirectories(IncludeTrailingPathDelimiter(RootDir) + 'etc\nginx\alias');

  // 1. Ensure php_upstream.conf (0x100081b10 & 0x100091510)
  UpstreamConf := IncludeTrailingPathDelimiter(RootDir) + 'etc\nginx\php_upstream.conf';
  SL := TStringList.Create;
  try
    SL.Add('# To increase PHP processes, add PHP_FCGI_CHILDREN to your nexagon.ini');
    SL.Add('upstream php_upstream {');
    SL.Add('    server 127.0.0.1:9001 weight=1 max_fails=1 fail_timeout=1;');
    SL.Add('}');
    SL.SaveToFile(UpstreamConf);
  finally
    SL.Free;
  end;

  // 2. Ensure <NginxVersionDir>/conf/snippets/fastcgi-php.conf (0x1000820d2 & 0x100091330)
  SnippetsDir := IncludeTrailingPathDelimiter(SrvNginx.GetVersionDir) + 'conf\snippets';
  ForceDirectories(SnippetsDir);
  FastCgiPhpConf := SnippetsDir + '\fastcgi-php.conf';
  if not FileExists(FastCgiPhpConf) then
  begin
    SL := TStringList.Create;
    try
      SL.Add('# regex to split $uri to $fastcgi_script_name and $fastcgi_path');
      SL.Add('fastcgi_split_path_info ^(.+\.php)(/.+)$;');
      SL.Add('');
      SL.Add('# Check that the PHP script exists before passing it');
      SL.Add('try_files $fastcgi_script_name =404;');
      SL.Add('');
      SL.Add('# Bypass the fact that try_files resets $fastcgi_path_info');
      SL.Add('# see: http://trac.nginx.org/nginx/ticket/321');
      SL.Add('set $path_info $fastcgi_path_info;');
      SL.Add('fastcgi_param PATH_INFO $path_info;');
      SL.Add('fastcgi_read_timeout 3600;');
      SL.Add('');
      SL.Add('fastcgi_index index.php;');
      SL.Add('include fastcgi.conf;');
      SL.SaveToFile(FastCgiPhpConf);
    finally
      SL.Free;
    end;
  end;

  // 3. Ensure <NginxVersionDir>/conf/nginx.conf includes php_upstream.conf and sites-enabled/*.conf (0x100081ed0)
  NginxConfPath := SrvNginx.GetConfigPath;
  if NginxConfPath <> '' then
  begin
    SL := TStringList.Create;
    try
      if FileExists(NginxConfPath) then
        SL.LoadFromFile(NginxConfPath);
      if Pos('sites-enabled', SL.Text) = 0 then
      begin
        TplPath := GetUsrDir + '\tpl\nginx.conf.manifest.tpl';
        if not FileExists(TplPath) then
          TplPath := IncludeTrailingPathDelimiter(RootDir) + 'bin\nexagon\tpl\nginx.conf.manifest.tpl';
        if FileExists(TplPath) then
          SL.LoadFromFile(TplPath)
        else
        begin
          SL.Clear;
          SL.Add('worker_processes  1;');
          SL.Add('events {');
          SL.Add('    worker_connections  1024;');
          SL.Add('}');
          SL.Add('http {');
          SL.Add('    include       mime.types;');
          SL.Add('    default_type  application/octet-stream;');
          SL.Add('    sendfile        on;');
          SL.Add('    keepalive_timeout  65;');
          SL.Add('    include "<<NEXAGON_ROOT>>/etc/nginx/php_upstream.conf";');
          SL.Add('    include "<<NEXAGON_ROOT>>/etc/nginx/sites-enabled/*.conf";');
          SL.Add('    client_max_body_size 2000M;');
          SL.Add('    server_names_hash_bucket_size 64;');
          SL.Add('}');
        end;
      end;
      Content := StringReplace(SL.Text, '<<NEXAGON_ROOT>>', RootFwd, [rfReplaceAll, rfIgnoreCase]);
      SL.Text := Content;
      ForceDirectories(ExtractFilePath(NginxConfPath));
      SL.SaveToFile(NginxConfPath);
    finally
      SL.Free;
    end;
  end;

  // 4. Normalize paths in etc/nginx/alias/*.conf so shipped aliases always point to RootFwd
  AliasDir := IncludeTrailingPathDelimiter(RootDir) + 'etc\nginx\alias\';
  if DirectoryExists(AliasDir) and (FindFirst(AliasDir + '*.conf', faAnyFile, SR) = 0) then
  begin
    SL := TStringList.Create;
    try
      repeat
        SL.LoadFromFile(AliasDir + SR.Name);
        Content := StringReplace(SL.Text, 'D:/Projects/Nexagon-installer/6.0-W64', RootFwd, [rfReplaceAll, rfIgnoreCase]);
        if Content <> SL.Text then
        begin
          SL.Text := Content;
          SL.SaveToFile(AliasDir + SR.Name);
        end;
      until FindNext(SR) <> 0;
    finally
      SL.Free;
      FindClose(SR);
    end;
  end;

  // 5. Generate etc/nginx/sites-enabled/00-default.conf (0x100081c10)
  DefaultConf := IncludeTrailingPathDelimiter(RootDir) + 'etc\nginx\sites-enabled\00-default.conf';
  EnsureSslCertificates;
  SL := TStringList.Create;
  try
    SL.Add('server {');
    SL.Add(Format('    listen %d default_server;', [SrvNginx.Port]));
    if SrvNginx.SslEnabled then
      SL.Add(Format('    listen %d ssl default_server;', [SrvNginx.SslPort]));
    SL.Add('    server_name localhost ;');
    SL.Add(Format('    root "%s";', [DocFwd]));
    SL.Add('    index index.html index.htm index.php;');
    SL.Add('    allow       127.0.0.1;');
    SL.Add('    deny        all;');
    SL.Add(Format('    include "%s/etc/nginx/alias/*.conf";', [RootFwd]));
    SL.Add('    location / {');
    SL.Add('        try_files $uri $uri/ =404;');
    SL.Add('        autoindex on;');
    SL.Add('    }');
    SL.Add('    location ~ \.php$ {');
    SL.Add('        include snippets/fastcgi-php.conf;');
    SL.Add('        fastcgi_pass php_upstream;');
    SL.Add('    }');
    if SrvNginx.SslEnabled then
    begin
      SL.Add(Format('    ssl_certificate "%s/nexagon.crt";', [SslDirFwd]));
      SL.Add(Format('    ssl_certificate_key "%s/nexagon.key";', [SslDirFwd]));
    end;
    SL.Add('    charset utf-8;');
    SL.Add('    location = /favicon.ico { access_log off; log_not_found off; }');
    SL.Add('    location = /robots.txt  { access_log off; log_not_found off; }');
    SL.Add('    location ~ /\.ht {');
    SL.Add('        deny all;');
    SL.Add('    }');
    SL.Add('}');
    SL.SaveToFile(DefaultConf);
  finally
    SL.Free;
  end;
end;

procedure TNexagon.EnsureNginxPhpUpstreamRunning;
var
  PhpCgiExe: string;
  P: TProcess;
  I: Integer;
begin
  if not Assigned(SrvPHP) then Exit;
  if FindProcessPidByName('php-cgi.exe') > 0 then Exit;
  PhpCgiExe := IncludeTrailingPathDelimiter(SrvPHP.GetVersionDir) + 'php-cgi.exe';
  if not FileExists(PhpCgiExe) then Exit;

  // Exact implementation of 0x10004efd0: spawn php-cgi.exe -b 127.0.0.1:9001
  P := TProcess.Create(nil);
  try
    P.Executable := PhpCgiExe;
    P.CommandLine := Format('"%s" -b 127.0.0.1:9001 -c "%s"', [PhpCgiExe, SrvPHP.GetConfigPath]);
    P.CurrentDirectory := SrvPHP.GetVersionDir;
    for I := 1 to GetEnvironmentVariableCount do
      P.Environment.Add(GetEnvironmentString(I));
    P.Environment.Values['PHP_FCGI_CHILDREN'] := '3';
    P.Environment.Values['PHP_FCGI_MAX_REQUESTS'] := '10000';
    P.Options := [poNoConsole];
    P.ShowWindow := swoHide;
    try
      P.Execute;
    except
    end;
  finally
    P.Free;
  end;
end;

procedure TNexagon.StopNginxPhpUpstream;
begin
  if FindProcessPidByName('php-cgi.exe') > 0 then
    KillProcessByName('php-cgi.exe');
end;

procedure TNexagon.SyncMySqlConfig;
var
  MyIni, TplIni, DDirFwd, Line, Trimmed: string;
  SL: TStringList;
  I: Integer;
begin
  if not Assigned(SrvMySQL) then Exit;
  MyIni := SrvMySQL.GetConfigPath;
  if not FileExists(MyIni) then
  begin
    TplIni := GetUsrDir + '\tpl\my.ini';
    if not FileExists(TplIni) then
      TplIni := GetUsrDir + '\tpl\my.ini.tpl';
    if FileExists(TplIni) then
      CopyFile(PChar(TplIni), PChar(MyIni), False);
  end;
  if not FileExists(MyIni) then Exit;
  DDirFwd := StringReplace(SrvMySQL.GetDataDir, '\', '/', [rfReplaceAll]);
  SL := TStringList.Create;
  try
    SL.LoadFromFile(MyIni);
    SL.WriteBOM := False;
    if (SL.Count > 0) and (Copy(SL[0], 1, 3) = #$EF#$BB#$BF) then
      SL[0] := Copy(SL[0], 4, MaxInt);
    for I := 0 to SL.Count - 1 do
    begin
      Line := SL[I];
      Trimmed := Trim(Line);
      if Trimmed = '=quick' then
        SL[I] := 'quick'
      else if Pos('port=', LowerCase(Trimmed)) = 1 then
        SL[I] := 'port=' + IntToStr(SrvMySQL.Port)
      else if Pos('datadir=', LowerCase(Trimmed)) = 1 then
        SL[I] := 'datadir="' + DDirFwd + '"';
    end;
    SL.SaveToFile(MyIni);
  finally
    SL.Free;
  end;
end;

procedure TNexagon.SyncSendmailConfig;
var
  SendmailIni: string;
  Ini: TMemIniFile;
begin
  SendmailIni := IncludeTrailingPathDelimiter(GetMailSenderDir) + 'sendmail.ini';
  if FileExists(SendmailIni) then
  begin
    Ini := TMemIniFile.Create(SendmailIni);
    try
      Ini.WriteString('sendmail', 'smtp_server', 'smtp.gmail.com');
      Ini.WriteString('sendmail', 'smtp_port', '587');
      Ini.WriteString('sendmail', 'auth_username', GmailAddress);
      Ini.WriteString('sendmail', 'auth_password', GmailPassword);
      Ini.WriteString('sendmail', 'force_sender', GmailAddress);
      Ini.UpdateFile;
    finally
      Ini.Free;
    end;
  end;
end;

function TNexagon.EnsureSslCertificates: Boolean;
var
  CrtFile, KeyFile, OpenSslExe, TplFile, ConfFile, HostName: string;
  SL: TStringList;
  SR: TSearchRec;
  DnsIdx: Integer;
begin
  CrtFile := IncludeTrailingPathDelimiter(GetSslDir) + 'nexagon.crt';
  KeyFile := IncludeTrailingPathDelimiter(GetSslDir) + 'nexagon.key';
  if FileExists(CrtFile) and FileExists(KeyFile) then Exit(True);

  OpenSslExe := '';
  if Assigned(SrvApache) then
    OpenSslExe := IncludeTrailingPathDelimiter(SrvApache.GetVersionDir) + 'bin\openssl.exe';
  if (OpenSslExe = '') or not FileExists(OpenSslExe) then
    OpenSslExe := IncludeTrailingPathDelimiter(RootDir) + 'bin\git\usr\bin\openssl.exe';
  if (OpenSslExe = '') or not FileExists(OpenSslExe) then
    OpenSslExe := 'C:\Program Files\Git\usr\bin\openssl.exe';
  if not FileExists(OpenSslExe) then Exit(False);

  TplFile := GetUsrDir + '\tpl\openssl.conf.tpl';
  if not FileExists(TplFile) then
    TplFile := IncludeTrailingPathDelimiter(RootDir) + 'bin\nexagon\tpl\openssl.conf.tpl';

  ConfFile := IncludeTrailingPathDelimiter(GetSslDir) + 'openssl.conf';
  SL := TStringList.Create;
  try
    if FileExists(TplFile) then
      SL.LoadFromFile(TplFile)
    else
    begin
      SL.Add('[req]');
      SL.Add('default_bits = 2048');
      SL.Add('default_md = sha256');
      SL.Add('distinguished_name = req_distinguished_name');
      SL.Add('req_extensions = v3_req');
      SL.Add('prompt = no');
      SL.Add('[req_distinguished_name]');
      SL.Add('C = SG');
      SL.Add('ST = Singapore');
      SL.Add('L = Singapore');
      SL.Add('O = Nexagon');
      SL.Add('OU = Server');
      SL.Add('CN = nexagon');
      SL.Add('[v3_req]');
      SL.Add('basicConstraints = CA:FALSE');
      SL.Add('keyUsage = digitalSignature, keyEncipherment');
      SL.Add('extendedKeyUsage = serverAuth');
      SL.Add('subjectAltName = @alt_names');
      SL.Add('[alt_names]');
      SL.Add('DNS.1 = localhost');
      SL.Add('IP.1 = 127.0.0.1');
    end;

    DnsIdx := 2;
    if DirectoryExists(DocumentRoot) and
       (FindFirst(IncludeTrailingPathDelimiter(DocumentRoot) + '*', faDirectory, SR) = 0) then
    begin
      repeat
        if ((SR.Attr and faDirectory) <> 0) and (SR.Name <> '.') and (SR.Name <> '..') and (SR.Name[1] <> '.') then
        begin
          HostName := StringReplace(HostnameFormat, '{name}', LowerCase(SR.Name), [rfReplaceAll, rfIgnoreCase]);
          SL.Add(Format('DNS.%d = %s', [DnsIdx, HostName]));
          Inc(DnsIdx);
          SL.Add(Format('DNS.%d = *.%s', [DnsIdx, HostName]));
          Inc(DnsIdx);
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
    SL.SaveToFile(ConfFile);
  finally
    SL.Free;
  end;

  RunCommandHidden(OpenSslExe,
    Format('req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout "%s" -out "%s" -config "%s" -extensions v3_req',
    [KeyFile, CrtFile, ConfFile]), ExtractFilePath(OpenSslExe), True);

  if (not FileExists(CrtFile) or not FileExists(KeyFile)) and
     FileExists(IncludeTrailingPathDelimiter(RootDir) + 'bin\git\usr\bin\openssl.exe') then
  begin
    OpenSslExe := IncludeTrailingPathDelimiter(RootDir) + 'bin\git\usr\bin\openssl.exe';
    RunCommandHidden(OpenSslExe,
      Format('req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout "%s" -out "%s" -config "%s" -extensions v3_req',
      [KeyFile, CrtFile, ConfFile]), ExtractFilePath(OpenSslExe), True);
  end;

  Result := FileExists(CrtFile) and FileExists(KeyFile);
end;

function TNexagon.AddSslCertToTrustStore: Boolean;
var
  CrtFile: string;
begin
  EnsureSslCertificates;
  CrtFile := IncludeTrailingPathDelimiter(GetSslDir) + 'nexagon.crt';
  if not FileExists(CrtFile) then Exit(False);
  Result := RunCommandHidden(GetEnvironmentVariable('SystemRoot') + '\System32\certutil.exe',
    '-user -addstore Root "' + CrtFile + '"', GetSslDir, True) = 0;
end;

function TNexagon.CreateVirtualHostForProject(const ProjectName, DocRootPath: string): string;
var
  HostName, ApacheVHostFile, NginxVHostFile, DocFwd, SslDirFwd, PubDir: string;
  SL: TStringList;
  ApachePort, ApacheSslPort, NginxPort, NginxSslPort: Integer;
begin
  HostName := StringReplace(HostnameFormat, '{name}', LowerCase(ProjectName), [rfReplaceAll, rfIgnoreCase]);
  if Pos('.', HostName) = 0 then HostName := LowerCase(ProjectName) + '.test';
  Result := HostName;

  PubDir := DocRootPath;
  if DirectoryExists(IncludeTrailingPathDelimiter(DocRootPath) + 'public') then
    PubDir := IncludeTrailingPathDelimiter(DocRootPath) + 'public';
  DocFwd := StringReplace(ExcludeTrailingPathDelimiter(PubDir), '\', '/', [rfReplaceAll]);
  SslDirFwd := StringReplace(ExcludeTrailingPathDelimiter(GetSslDir), '\', '/', [rfReplaceAll]);

  ApachePort := 80;
  ApacheSslPort := 443;
  if Assigned(SrvApache) then
  begin
    ApachePort := SrvApache.Port;
    ApacheSslPort := SrvApache.SslPort;
  end;

  ApacheVHostFile := IncludeTrailingPathDelimiter(RootDir) + 'etc\apache2\sites-enabled\auto.' + HostName + '.conf';
  ForceDirectories(ExtractFilePath(ApacheVHostFile));
  SL := TStringList.Create;
  try
    SL.Add(Format('define ROOT "%s"', [DocFwd]));
    SL.Add(Format('define SITE "%s"', [HostName]));
    SL.Add('');
    SL.Add(Format('<VirtualHost *:%d>', [ApachePort]));
    SL.Add('    DocumentRoot "${ROOT}"');
    SL.Add('    ServerName ${SITE}');
    SL.Add('    ServerAlias *.${SITE}');
    SL.Add('    <Directory "${ROOT}">');
    SL.Add('        AllowOverride All');
    SL.Add('        Require all granted');
    SL.Add('    </Directory>');
    SL.Add('</VirtualHost>');
    SL.Add('');
    SL.Add(Format('<VirtualHost *:%d>', [ApacheSslPort]));
    SL.Add('    DocumentRoot "${ROOT}"');
    SL.Add('    ServerName ${SITE}');
    SL.Add('    ServerAlias *.${SITE}');
    SL.Add('    <Directory "${ROOT}">');
    SL.Add('        AllowOverride All');
    SL.Add('        Require all granted');
    SL.Add('    </Directory>');
    SL.Add('    SSLEngine on');
    SL.Add(Format('    SSLCertificateFile      %s/nexagon.crt', [SslDirFwd]));
    SL.Add(Format('    SSLCertificateKeyFile   %s/nexagon.key', [SslDirFwd]));
    SL.Add('</VirtualHost>');
    SL.SaveToFile(ApacheVHostFile);
  finally
    SL.Free;
  end;

  NginxPort := 8080;
  NginxSslPort := 8443;
  if Assigned(SrvNginx) then
  begin
    NginxPort := SrvNginx.Port;
    NginxSslPort := SrvNginx.SslPort;
  end;

  NginxVHostFile := IncludeTrailingPathDelimiter(RootDir) + 'etc\nginx\sites-enabled\auto.' + HostName + '.conf';
  ForceDirectories(ExtractFilePath(NginxVHostFile));
  SL := TStringList.Create;
  try
    SL.Add('server {');
    SL.Add(Format('    listen %d;', [NginxPort]));
    SL.Add(Format('    listen %d ssl;', [NginxSslPort]));
    SL.Add(Format('    server_name %s *.%s;', [HostName, HostName]));
    SL.Add(Format('    root "%s";', [DocFwd]));
    SL.Add('    index index.html index.htm index.php;');
    SL.Add('    location / {');
    SL.Add('        try_files $uri $uri/ /index.php$is_args$args;');
    SL.Add('        autoindex on;');
    SL.Add('    }');
    SL.Add('    location ~ \.php$ {');
    SL.Add('        include snippets/fastcgi-php.conf;');
    SL.Add('        fastcgi_pass php_upstream;');
    SL.Add('    }');
    SL.Add(Format('    ssl_certificate "%s/nexagon.crt";', [SslDirFwd]));
    SL.Add(Format('    ssl_certificate_key "%s/nexagon.key";', [SslDirFwd]));
    SL.Add('    charset utf-8;');
    SL.Add('}');
    SL.SaveToFile(NginxVHostFile);
  finally
    SL.Free;
  end;
end;

function TNexagon.GenerateAutoVirtualHosts: Integer;
var
  SR: TSearchRec;
  BaseDoc, ApacheSitesDir, NginxSitesDir, HostName, HostsPath: string;
  HostsLines: TStringList;
  GeneratedHosts: TStringList;
  I: Integer;
  HasHost: Boolean;
begin
  Result := 0;
  if not DirectoryExists(DocumentRoot) then Exit;
  EnsureSslCertificates;

  // Clean up stale auto.*.conf from previous DocumentRoot
  ApacheSitesDir := IncludeTrailingPathDelimiter(RootDir) + 'etc\apache2\sites-enabled\';
  if DirectoryExists(ApacheSitesDir) and (FindFirst(ApacheSitesDir + 'auto.*.conf', faAnyFile, SR) = 0) then
  begin
    repeat
      DeleteFile(PChar(ApacheSitesDir + SR.Name));
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  NginxSitesDir := IncludeTrailingPathDelimiter(RootDir) + 'etc\nginx\sites-enabled\';
  if DirectoryExists(NginxSitesDir) and (FindFirst(NginxSitesDir + 'auto.*.conf', faAnyFile, SR) = 0) then
  begin
    repeat
      DeleteFile(PChar(NginxSitesDir + SR.Name));
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;

  BaseDoc := IncludeTrailingPathDelimiter(DocumentRoot);
  GeneratedHosts := TStringList.Create;
  try
    if FindFirst(BaseDoc + '*', faDirectory, SR) = 0 then
    begin
      repeat
        if ((SR.Attr and faDirectory) <> 0) and (SR.Name <> '.') and (SR.Name <> '..') and
           (SR.Name[1] <> '.') and not SameText(SR.Name, 'nexagon') then
        begin
          HostName := CreateVirtualHostForProject(SR.Name, BaseDoc + SR.Name);
          GeneratedHosts.Add(HostName);
          Inc(Result);
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;

    HostsPath := GetEnvironmentVariable('SystemRoot') + '\System32\drivers\etc\hosts';
    if FileExists(HostsPath) and (GeneratedHosts.Count > 0) then
    begin
      HostsLines := TStringList.Create;
      try
        try
          HostsLines.LoadFromFile(HostsPath);
          for I := 0 to GeneratedHosts.Count - 1 do
          begin
            HasHost := Pos(' ' + GeneratedHosts[I] + ' ', ' ' + HostsLines.Text + ' ') > 0;
            if not HasHost then
              HostsLines.Add('127.0.0.1      ' + GeneratedHosts[I] + '   #nexagon magic!   ');
          end;
          HostsLines.SaveToFile(HostsPath);
        except
          // May require admin elevation if hosts is locked
        end;
      finally
        HostsLines.Free;
      end;
    end;
  finally
    GeneratedHosts.Free;
  end;
end;

procedure TNexagon.LoadSitesAndPackages;
var
  SitesFile, PkgFile: string;
begin
  SitesConf.Clear;
  PackagesConf.Clear;
  SitesFile := GetUsrDir + '\sites.conf';
  if not FileExists(SitesFile) then
    SitesFile := IncludeTrailingPathDelimiter(RootDir) + 'bin\nexagon\sites.manifest.conf';
  if not FileExists(SitesFile) then
    SitesFile := GetUsrDir + '\tpl\sites.conf.tpl';
  if FileExists(SitesFile) then
    SitesConf.LoadFromFile(SitesFile);

  PkgFile := GetUsrDir + '\packages.conf';
  if not FileExists(PkgFile) then
    PkgFile := IncludeTrailingPathDelimiter(RootDir) + 'bin\nexagon\packages.manifest.conf';
  if not FileExists(PkgFile) then
    PkgFile := GetUsrDir + '\tpl\packages.conf.tpl';
  if FileExists(PkgFile) then
    PackagesConf.LoadFromFile(PkgFile);
end;

function TNexagon.BuildNexagonPathList(OutList: TStrings): string;
  procedure AddIfExist(const P: string);
  begin
    if (P <> '') and DirectoryExists(P) and (OutList.IndexOf(P) < 0) then
      OutList.Add(ExcludeTrailingPathDelimiter(P));
  end;
var
  I: Integer;
begin
  OutList.Clear;
  AddIfExist(IncludeTrailingPathDelimiter(RootDir) + 'bin\nexagon\utils');
  if Assigned(SrvMySQL) then AddIfExist(IncludeTrailingPathDelimiter(SrvMySQL.GetVersionDir) + 'bin');
  if Assigned(SrvPHP) then AddIfExist(SrvPHP.GetVersionDir);
  AddIfExist(IncludeTrailingPathDelimiter(RootDir) + 'bin\composer');
  if Assigned(SrvApache) then AddIfExist(IncludeTrailingPathDelimiter(SrvApache.GetVersionDir) + 'bin');
  if Assigned(SrvNginx) then AddIfExist(SrvNginx.GetVersionDir);
  if Assigned(SrvRedis) then AddIfExist(SrvRedis.GetVersionDir);
  if Assigned(SrvMemcached) then AddIfExist(SrvMemcached.GetVersionDir);
  if Assigned(SrvPostgreSQL) then AddIfExist(IncludeTrailingPathDelimiter(SrvPostgreSQL.GetVersionDir) + 'bin');
  if Assigned(SrvMongoDB) then AddIfExist(IncludeTrailingPathDelimiter(SrvMongoDB.GetVersionDir) + 'bin');
  if Assigned(SrvNodeJS) then AddIfExist(SrvNodeJS.GetVersionDir);
  AddIfExist(IncludeTrailingPathDelimiter(RootDir) + 'bin\notepad++');
  AddIfExist(IncludeTrailingPathDelimiter(RootDir) + 'bin\git\bin');
  AddIfExist(IncludeTrailingPathDelimiter(RootDir) + 'bin\git\cmd');
  AddIfExist(IncludeTrailingPathDelimiter(RootDir) + 'bin\git\usr\bin');
  AddIfExist(IncludeTrailingPathDelimiter(RootDir) + 'bin\ngrok');
  AddIfExist(IncludeTrailingPathDelimiter(RootDir) + 'bin\putty');

  Result := '';
  for I := 0 to OutList.Count - 1 do
  begin
    if Result <> '' then Result := Result + ';';
    Result := Result + OutList[I];
  end;
end;

function TNexagon.GetPathVariablesReport: string;
var
  SL, Parts: TStringList;
  Reg: TRegistry;
  UserPath, SysPath: string;
  I: Integer;
begin
  SL := TStringList.Create;
  Parts := TStringList.Create;
  try
    UserPath := '';
    SysPath := '';
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKeyReadOnly('Environment') then
      begin
        UserPath := Reg.ReadString('Path');
        Reg.CloseKey;
      end;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKeyReadOnly('SYSTEM\CurrentControlSet\Control\Session Manager\Environment') then
      begin
        SysPath := Reg.ReadString('Path');
        Reg.CloseKey;
      end;
    finally
      Reg.Free;
    end;

    SL.Add('# User PATH Variable:');
    SL.Add('--------------------------------');
    ExtractStrings([';'], [], PChar(UserPath), Parts);
    for I := 0 to Parts.Count - 1 do
      if Trim(Parts[I]) <> '' then SL.Add(Trim(Parts[I]));

    SL.Add('');
    SL.Add('');
    SL.Add('# System PATH Variable:');
    SL.Add('--------------------------------');
    Parts.Clear;
    ExtractStrings([';'], [], PChar(SysPath), Parts);
    for I := 0 to Parts.Count - 1 do
      if Trim(Parts[I]) <> '' then SL.Add(Trim(Parts[I]));

    Result := SL.Text;
  finally
    Parts.Free;
    SL.Free;
  end;
end;

function TNexagon.AddNexagonToUserPath: Boolean;
var
  Reg: TRegistry;
  LaraPaths, ExistingParts: TStringList;
  CurrentUserPath, NewUserPath: string;
  I: Integer;
  Res: PtrUInt;
begin
  Result := False;
  LaraPaths := TStringList.Create;
  ExistingParts := TStringList.Create;
  Reg := TRegistry.Create;
  try
    BuildNexagonPathList(LaraPaths);
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('Environment', True) then
    begin
      if Reg.ValueExists('Path') then
        CurrentUserPath := Reg.ReadString('Path')
      else
        CurrentUserPath := '';
      ExtractStrings([';'], [], PChar(CurrentUserPath), ExistingParts);
      for I := LaraPaths.Count - 1 downto 0 do
      begin
        if ExistingParts.IndexOf(LaraPaths[I]) < 0 then
          ExistingParts.Insert(0, LaraPaths[I]);
      end;
      NewUserPath := '';
      for I := 0 to ExistingParts.Count - 1 do
        if Trim(ExistingParts[I]) <> '' then
        begin
          if NewUserPath <> '' then NewUserPath := NewUserPath + ';';
          NewUserPath := NewUserPath + Trim(ExistingParts[I]);
        end;
      Reg.WriteExpandString('Path', NewUserPath);
      Reg.CloseKey;
      SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, LPARAM(PChar('Environment')), SMTO_ABORTIFHUNG, 2000, @Res);
      Result := True;
    end;
  finally
    Reg.Free;
    ExistingParts.Free;
    LaraPaths.Free;
  end;
end;

function TNexagon.RemoveNexagonFromUserPath: Boolean;
var
  Reg: TRegistry;
  ExistingParts: TStringList;
  CurrentUserPath, NewUserPath, RootLow: string;
  I: Integer;
  Res: PtrUInt;
begin
  Result := False;
  ExistingParts := TStringList.Create;
  Reg := TRegistry.Create;
  try
    RootLow := LowerCase(ExcludeTrailingPathDelimiter(RootDir));
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('Environment', True) then
    begin
      if Reg.ValueExists('Path') then
        CurrentUserPath := Reg.ReadString('Path')
      else
        CurrentUserPath := '';
      ExtractStrings([';'], [], PChar(CurrentUserPath), ExistingParts);
      NewUserPath := '';
      for I := 0 to ExistingParts.Count - 1 do
      begin
        if (Trim(ExistingParts[I]) <> '') and (Pos(RootLow, LowerCase(ExistingParts[I])) = 0) then
        begin
          if NewUserPath <> '' then NewUserPath := NewUserPath + ';';
          NewUserPath := NewUserPath + Trim(ExistingParts[I]);
        end;
      end;
      Reg.WriteExpandString('Path', NewUserPath);
      Reg.CloseKey;
      SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, LPARAM(PChar('Environment')), SMTO_ABORTIFHUNG, 2000, @Res);
      Result := True;
    end;
  finally
    Reg.Free;
    ExistingParts.Free;
  end;
end;

function TNexagon.CatchIncomingEmailFromStdin: string;
var
  StdInHandle: THandle;
  Mem: TMemoryStream;
  Buf: array[0..4095] of Byte;
  BytesRead: DWORD;
begin
  Result := IncludeTrailingPathDelimiter(GetMailCatcherDir) +
    'mail-' + FormatDateTime('yyyymmdd-hhnnss-zzz', Now) + '.eml.txt';
  Mem := TMemoryStream.Create;
  try
    StdInHandle := GetStdHandle(STD_INPUT_HANDLE);
    if (StdInHandle <> 0) and (StdInHandle <> INVALID_HANDLE_VALUE) then
    begin
      BytesRead := 0;
      while ReadFile(StdInHandle, Buf[0], SizeOf(Buf), BytesRead, nil) and (BytesRead > 0) do
        Mem.WriteBuffer(Buf[0], BytesRead);
    end;
    Mem.SaveToFile(Result);
  finally
    Mem.Free;
  end;
end;

function TNexagon.GetLatestEmailFile: string;
var
  SR: TSearchRec;
  BestTime: LongInt;
  Dir: string;
begin
  Result := '';
  BestTime := -1;
  Dir := IncludeTrailingPathDelimiter(GetMailCatcherDir);
  if FindFirst(Dir + '*.*', faAnyFile, SR) = 0 then
  begin
    repeat
      if ((SR.Attr and faDirectory) = 0) and (SR.Time > BestTime) then
      begin
        BestTime := SR.Time;
        Result := Dir + SR.Name;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

function TNexagon.GenerateMailTestScript(const RecipientEmail: string): string;
begin
  Result :=
    '<?php' + LineEnding +
    'echo "Nexagon Mail Analyzer" . PHP_EOL;' + LineEnding +
    'echo "----------------------------------------" . PHP_EOL;' + LineEnding +
    'echo "Sending test email from: ' + GmailAddress + '" . PHP_EOL;' + LineEnding +
    'echo "To: ' + RecipientEmail + '" . PHP_EOL;' + LineEnding +
    'echo "SMTP Host: smtp.gmail.com:587 (TLS)" . PHP_EOL;' + LineEnding +
    '$headers = "From: ' + GmailAddress + '\r\nReply-To: ' + GmailAddress + '\r\nX-Mailer: Nexagon-MailAnalyzer";' + LineEnding +
    '$ok = @mail("' + RecipientEmail + '", "[Nexagon] Test Mail", "Hello from Nexagon Mail Sender!", $headers);' + LineEnding +
    'echo ($ok ? "Result: mail() dispatched successfully." : "Result: mail() returned false (check credentials/SMTP).") . PHP_EOL;';
end;

{ Global Service Helpers }

procedure InitAllServices(RuntimePanel: TWinControl);
begin
  if not Assigned(Nexagon) then
    Nexagon := TNexagon.Create;

  SrvPHP := TPHP.Create;
  SrvApache := TWebServer.Create('Apache', 'apache', 80, 443);
  SrvApache.Enabled := True;
  SrvApache.ImageIndex := 17;
  SrvApache.ExeSubPath := 'bin\httpd.exe';
  SrvApache.ConfigSubPath := 'conf\httpd.conf';

  SrvNginx := TWebServer.Create('Nginx', 'nginx', 8080, 8443);
  SrvNginx.ImageIndex := 9;
  SrvNginx.ExeSubPath := 'nginx.exe';
  SrvNginx.ConfigSubPath := 'conf\nginx.conf';

  SrvMySQL := TMySQL.Create;
  SrvPostgreSQL := TPostgreSQL.Create;
  SrvMongoDB := TMongoDB.Create;

  SrvMemcached := TService.Create('Memcached', 'memcached', 11211);
  SrvMemcached.ExeSubPath := 'memcached.exe';

  SrvRedis := TService.Create('Redis', 'redis', 6379);
  SrvRedis.ExeSubPath := 'redis-server.exe';
  SrvRedis.ConfigSubPath := 'redis.windows.conf';

  SrvMailpit := TService.Create('Mailpit', 'mailpit', 1025);
  SrvMailpit.ImageIndex := 10;
  SrvMailpit.ExeSubPath := 'mailpit.exe';

  SrvNodeJS := TService.Create('Node.js', 'nodejs', 0);
  SrvNodeJS.ExeSubPath := 'node.exe';

  SrvPython := TPython.Create;
  SrvRuby := TRuby.Create;
  SrvJava := TJava.Create;
  SrvGo := TGo.Create;
  SrvCmder := TCmder.Create;

  Nexagon.LoadConfig;

  if Assigned(RuntimePanel) then
  begin
    SrvApache.UI := TServiceUI.Create(SrvApache, RuntimePanel);
    SrvNginx.UI := TServiceUI.Create(SrvNginx, RuntimePanel);
    SrvMySQL.UI := TServiceUI.Create(SrvMySQL, RuntimePanel);
    SrvPostgreSQL.UI := TServiceUI.Create(SrvPostgreSQL, RuntimePanel);
    SrvMongoDB.UI := TServiceUI.Create(SrvMongoDB, RuntimePanel);
    SrvMemcached.UI := TServiceUI.Create(SrvMemcached, RuntimePanel);
    SrvRedis.UI := TServiceUI.Create(SrvRedis, RuntimePanel);
    SrvMailpit.UI := TServiceUI.Create(SrvMailpit, RuntimePanel);
    SrvPHP.UI := TServiceUI.Create(SrvPHP, RuntimePanel);
    LayoutRuntimeServices(RuntimePanel);
  end;
end;

procedure FreeAllServices;
begin
  FreeAndNil(SrvApache);
  FreeAndNil(SrvNginx);
  FreeAndNil(SrvMySQL);
  FreeAndNil(SrvPostgreSQL);
  FreeAndNil(SrvMongoDB);
  FreeAndNil(SrvMemcached);
  FreeAndNil(SrvRedis);
  FreeAndNil(SrvMailpit);
  FreeAndNil(SrvPHP);
  FreeAndNil(SrvNodeJS);
  FreeAndNil(SrvPython);
  FreeAndNil(SrvRuby);
  FreeAndNil(SrvJava);
  FreeAndNil(SrvGo);
  FreeAndNil(SrvCmder);
  FreeAndNil(Nexagon);
end;

procedure LayoutRuntimeServices(RuntimePanel: TWinControl);
var
  Srvs: array[0..7] of TService;
  I, RowHeight, CurrentTop: Integer;
begin
  if not Assigned(RuntimePanel) then Exit;
  // Exact order from 0x10007c3b0:
  Srvs[0] := SrvApache;
  Srvs[1] := SrvMySQL;
  Srvs[2] := SrvPostgreSQL;
  Srvs[3] := SrvNginx;
  Srvs[4] := SrvMemcached;
  Srvs[5] := SrvRedis;
  Srvs[6] := SrvMongoDB;
  Srvs[7] := SrvMailpit;
  if Assigned(SrvPHP) and Assigned(SrvPHP.UI) then
  begin
    SrvPHP.Enabled := False;
    SrvPHP.UI.UpdateUI(True);
  end;

  // Exact coordinates from 0x10007e5d0: local_18 = 0x19 (25), local_20 = 0x28 (40)
  CurrentTop := 25;
  RowHeight := 40;
  for I := Low(Srvs) to High(Srvs) do
  begin
    if Assigned(Srvs[I]) and Assigned(Srvs[I].UI) then
    begin
      Srvs[I].UI.SetRowPosition(CurrentTop);
      if Srvs[I].IsActiveAndInstalled then
        Inc(CurrentTop, RowHeight);
    end;
  end;
end;

procedure RefreshAllServicesUI(Force: Boolean);
var
  Srvs: array[0..7] of TService;
  ExeNames: array[0..7] of string;
  FoundPids: array[0..7] of Cardinal;
  Snap: THandle;
  PE: TProcessEntry32;
  ProcName: string;
  I: Integer;
begin
  Srvs[0] := SrvApache;
  Srvs[1] := SrvMySQL;
  Srvs[2] := SrvPostgreSQL;
  Srvs[3] := SrvNginx;
  Srvs[4] := SrvMemcached;
  Srvs[5] := SrvRedis;
  Srvs[6] := SrvMongoDB;
  Srvs[7] := SrvMailpit;

  for I := Low(Srvs) to High(Srvs) do
  begin
    FoundPids[I] := 0;
    if Assigned(Srvs[I]) then
      ExeNames[I] := ExtractFileName(Srvs[I].GetExePath)
    else
      ExeNames[I] := '';
  end;

  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap <> INVALID_HANDLE_VALUE then
  begin
    try
      FillChar(PE, SizeOf(PE), 0);
      PE.dwSize := SizeOf(PE);
      if Process32First(Snap, PE) then
      begin
        repeat
          ProcName := StrPas(PE.szExeFile);
          for I := Low(Srvs) to High(Srvs) do
            if (FoundPids[I] = 0) and (ExeNames[I] <> '') and SameText(ProcName, ExeNames[I]) then
              FoundPids[I] := PE.th32ProcessID;
        until not Process32Next(Snap, PE);
      end;
    finally
      CloseHandle(Snap);
    end;
  end;

  for I := Low(Srvs) to High(Srvs) do
    if Assigned(Srvs[I]) then
    begin
      if (FoundPids[I] > 0) and ((Srvs[I].Port <= 0) or IsTcpPortListening(Srvs[I].Port)) then
      begin
        Srvs[I].Pid := FoundPids[I];
        Srvs[I].Running := True;
      end
      else
      begin
        Srvs[I].Pid := 0;
        Srvs[I].Running := False;
      end;
      if Assigned(Srvs[I].UI) then
        Srvs[I].UI.UpdateUI(Force);
    end;
end;

function AnyPrimaryServiceRunning: Boolean;
begin
  Result :=
    (Assigned(SrvApache) and SrvApache.Running) or
    (Assigned(SrvNginx) and SrvNginx.Running) or
    (Assigned(SrvMySQL) and SrvMySQL.Running) or
    (Assigned(SrvPostgreSQL) and SrvPostgreSQL.Running) or
    (Assigned(SrvMongoDB) and SrvMongoDB.Running) or
    (Assigned(SrvMemcached) and SrvMemcached.Running) or
    (Assigned(SrvRedis) and SrvRedis.Running) or
    (Assigned(SrvMailpit) and SrvMailpit.Running);
end;

function StartAllEnabledServices: Integer;
var
  Srvs: array[0..7] of TService;
  I: Integer;
begin
  Result := 0;
  Srvs[0] := SrvApache;
  Srvs[1] := SrvMySQL;
  Srvs[2] := SrvPostgreSQL;
  Srvs[3] := SrvNginx;
  Srvs[4] := SrvMemcached;
  Srvs[5] := SrvRedis;
  Srvs[6] := SrvMongoDB;
  Srvs[7] := SrvMailpit;
  for I := Low(Srvs) to High(Srvs) do
    if Assigned(Srvs[I]) and Srvs[I].IsActiveAndInstalled then
    begin
      if Srvs[I].StartService then
        Inc(Result);
    end;
end;

function StopAllRunningServices: Integer;
var
  Srvs: array[0..8] of TService;
  I: Integer;
begin
  Result := 0;
  Srvs[0] := SrvApache;
  Srvs[1] := SrvMySQL;
  Srvs[2] := SrvPostgreSQL;
  Srvs[3] := SrvNginx;
  Srvs[4] := SrvMemcached;
  Srvs[5] := SrvRedis;
  Srvs[6] := SrvMongoDB;
  Srvs[7] := SrvMailpit;
  Srvs[8] := SrvPHP;
  for I := Low(Srvs) to High(Srvs) do
    if Assigned(Srvs[I]) and (Srvs[I].Running or Srvs[I].CheckRunning) then
    begin
      if Srvs[I].StopService then
        Inc(Result);
    end;
end;

end.
