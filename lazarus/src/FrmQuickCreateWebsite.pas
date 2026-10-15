unit FrmQuickCreateWebsite;

{$mode objfpc}{$H+}

interface

uses
  Windows, WinInet, Classes, SysUtils, StrUtils, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Process, Services;

type
  TFormQuickCreateWebsite = class(TForm)
  published
    PanelExtract: TPanel;
    LabelExtract: TLabel;
    ImageExplore: TImage;
    ProgressBarExtract: TProgressBar;
    LabelCantDownload: TLabel;
    PanelBottom: TPanel;
    LabelCreateDatabase: TLabel;
    PanelDownload: TPanel;
    LabelDownload: TLabel;
    LabelSizeInfo: TLabel;
    ImageDownloadInfoOff: TImage;
    ImageDownloadInfoOn: TImage;
    LabelDownloadProgress: TLabel;
    ProgressBarDownload: TProgressBar;
    PanelGeneratedPrettyUrl: TPanel;
    LabelGeneratedprettyurl: TLabel;
    LabelPrettyUrl: TLabel;
    PanelMySQLError: TPanel;
    LabelMySQLError: TLabel;
    BtnVisitSite: TButton;
    BtnClose: TButton;
    LabelPercentExtract: TLabel;
    TimerLazyQuick: TTimer;
    TimerExtractData: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImageExploreClick(Sender: TObject);
    procedure LabelCantDownloadClick(Sender: TObject);
    procedure LabelCantDownloadMouseEnter(Sender: TObject);
    procedure LabelCantDownloadMouseLeave(Sender: TObject);
    procedure ImageDownloadInfoOffMouseEnter(Sender: TObject);
    procedure ImageDownloadInfoOnClick(Sender: TObject);
    procedure ImageDownloadInfoOnMouseLeave(Sender: TObject);
    procedure LabelPrettyUrlClick(Sender: TObject);
    procedure LabelPrettyUrlMouseEnter(Sender: TObject);
    procedure LabelPrettyUrlMouseLeave(Sender: TObject);
    procedure BtnVisitSiteClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure TimerLazyQuickTimer(Sender: TObject);
    procedure TimerExtractDataTimer(Sender: TObject);
  public
    IsQuickApp: Boolean;
    AppType: string;
    ProjectName: string;
    DownloadUrl: string;
    TargetDir: string;
    PrettyUrl: string;
    CachedArchivePath: string;
    function DownloadFileWithWinInet(const AUrl, ADestFile: string): Boolean;
    function ExtractArchiveToDir(const AArchiveFile, ADestDir: string): Boolean;
    procedure FlattenSingleSubdir(const ADir: string);
    procedure ConfigureWordPressWpConfig(const AProjectDir, ADbName: string);
    procedure ConfigureLaravelEnv(const AProjectDir, ADbName, AHostUrl: string);
    procedure StartQuickCreate(const AAppType, AProjectName, ADownloadUrl: string);
    procedure StartQuickAdd(const APkgName, ADownloadUrl: string);
  end;

var
  FormQuickCreateWebsite: TFormQuickCreateWebsite;

implementation

{$R *.lfm}

function GenerateRandomSalt(Len: Integer): string;
const
  Chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()-_=+';
var
  I: Integer;
begin
  SetLength(Result, Len);
  for I := 1 to Len do
    Result[I] := Chars[Random(Length(Chars)) + 1];
end;

function ExtractFileNameFromUrl(const AUrl: string; const FallbackName: string): string;
var
  CleanUrl: string;
  P: Integer;
begin
  CleanUrl := AUrl;
  P := Pos('?', CleanUrl);
  if P > 0 then
    CleanUrl := Copy(CleanUrl, 1, P - 1);
  P := LastDelimiter('/', CleanUrl);
  if P > 0 then
    Result := Copy(CleanUrl, P + 1, MaxInt)
  else
    Result := '';
  if (Result = '') or (Pos('.', Result) = 0) then
    Result := LowerCase(StringReplace(FallbackName, ' ', '-', [rfReplaceAll])) + '.zip';
end;

procedure TFormQuickCreateWebsite.FormCreate(Sender: TObject);
begin
  Randomize;
  IsQuickApp := True;
  LabelPercentExtract.Caption := '';
  LabelPrettyUrl.Caption := '';
  LabelCreateDatabase.Caption := '';
  LabelPrettyUrl.Left := LabelGeneratedprettyurl.Left;
  PanelBottom.Color := clWhite;
  ImageDownloadInfoOn.Top := ImageDownloadInfoOff.Top;
  ImageDownloadInfoOn.Left := ImageDownloadInfoOff.Left;
  Color := clWhite;
end;

procedure TFormQuickCreateWebsite.FormShow(Sender: TObject);
begin
  if Assigned(Nexagon) then
  begin
    if IsQuickApp then
      Caption := Nexagon.T(607, 'Quick app') + ' - ' + AppType
    else
      Caption := Nexagon.T(608, 'Quick add') + ' - ' + AppType;
    LabelDownload.Caption := Nexagon.T(602, 'Download') + ':';
    LabelExtract.Caption := Nexagon.T(604, 'Extract') + ':';
    LabelGeneratedprettyurl.Caption := Nexagon.T(606, 'Generated pretty url') + ':';
    BtnVisitSite.Caption := Nexagon.T(234, 'Visit Website');
    BtnClose.Caption := Nexagon.T(112, 'Close');
  end;
end;

procedure TFormQuickCreateWebsite.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caHide;
end;

procedure TFormQuickCreateWebsite.FormDestroy(Sender: TObject);
begin
  // Cleanup
end;

function TFormQuickCreateWebsite.DownloadFileWithWinInet(const AUrl, ADestFile: string): Boolean;
var
  hInet, hUrl: HINTERNET;
  Buffer: array[0..32767] of Byte;
  BytesRead, ContentLen, BufLen, Reserved: DWORD;
  TotalRead: Int64;
  FS: TFileStream;
  Flags: DWORD;
  Pct: Integer;
begin
  Result := False;
  if AUrl = '' then Exit;
  ForceDirectories(ExtractFilePath(ADestFile));

  hInet := InternetOpenA('Nexagon', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if hInet = nil then Exit;
  try
    Flags := INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_CACHE_WRITE;
    if StartsText('https://', AUrl) then
      Flags := Flags or INTERNET_FLAG_SECURE or INTERNET_FLAG_IGNORE_CERT_CN_INVALID or INTERNET_FLAG_IGNORE_CERT_DATE_INVALID;
    hUrl := InternetOpenUrlA(hInet, PChar(AUrl), nil, 0, Flags, 0);
    if hUrl = nil then Exit;
    try
      ContentLen := 0;
      BufLen := SizeOf(ContentLen);
      Reserved := 0;
      HttpQueryInfoA(hUrl, HTTP_QUERY_CONTENT_LENGTH or HTTP_QUERY_FLAG_NUMBER, @ContentLen, BufLen, Reserved);

      FS := TFileStream.Create(ADestFile, fmCreate);
      try
        TotalRead := 0;
        BytesRead := 0;
        while InternetReadFile(hUrl, @Buffer[0], SizeOf(Buffer), BytesRead) and (BytesRead > 0) do
        begin
          FS.WriteBuffer(Buffer[0], BytesRead);
          Inc(TotalRead, BytesRead);
          if ContentLen > 0 then
          begin
            Pct := Round((TotalRead * 100.0) / ContentLen);
            if Pct > 100 then Pct := 100;
            ProgressBarDownload.Position := Pct;
            LabelDownloadProgress.Caption := Format('%d%%', [Pct]);
            LabelSizeInfo.Caption := Format('%.1f KB / %.1f KB', [TotalRead / 1024.0, ContentLen / 1024.0]);
          end
          else
          begin
            LabelDownloadProgress.Caption := Format('%.1f KB', [TotalRead / 1024.0]);
            LabelSizeInfo.Caption := LabelDownloadProgress.Caption;
          end;
          Application.ProcessMessages;
        end;
        Result := TotalRead > 0;
      finally
        FS.Free;
      end;
    finally
      InternetCloseHandle(hUrl);
    end;
  finally
    InternetCloseHandle(hInet);
  end;
end;

procedure TFormQuickCreateWebsite.FlattenSingleSubdir(const ADir: string);
var
  SR: TSearchRec;
  SubDirs, Files: TStringList;
  SingleSub, SrcItem, DstItem: string;
begin
  if not DirectoryExists(ADir) then Exit;
  SubDirs := TStringList.Create;
  Files := TStringList.Create;
  try
    if FindFirst(IncludeTrailingPathDelimiter(ADir) + '*', faAnyFile, SR) = 0 then
    begin
      repeat
        if (SR.Name = '.') or (SR.Name = '..') then Continue;
        if (SR.Attr and faDirectory) <> 0 then
          SubDirs.Add(SR.Name)
        else
          Files.Add(SR.Name);
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
    // Exact logic from 0x10009a020: if extraction produced 1 top-level folder and 0 files, move contents up
    if (SubDirs.Count = 1) and (Files.Count = 0) then
    begin
      SingleSub := IncludeTrailingPathDelimiter(ADir) + SubDirs[0];
      if FindFirst(IncludeTrailingPathDelimiter(SingleSub) + '*', faAnyFile, SR) = 0 then
      begin
        repeat
          if (SR.Name = '.') or (SR.Name = '..') then Continue;
          SrcItem := IncludeTrailingPathDelimiter(SingleSub) + SR.Name;
          DstItem := IncludeTrailingPathDelimiter(ADir) + SR.Name;
          MoveFileA(PChar(SrcItem), PChar(DstItem));
        until FindNext(SR) <> 0;
        FindClose(SR);
      end;
      RemoveDir(SingleSub);
    end;
  finally
    Files.Free;
    SubDirs.Free;
  end;
end;

function TFormQuickCreateWebsite.ExtractArchiveToDir(const AArchiveFile, ADestDir: string): Boolean;
var
  SevenZipExe, TarExe, CmdLine: string;
  P: TProcess;
begin
  Result := False;
  if not FileExists(AArchiveFile) then Exit;
  ForceDirectories(ADestDir);
  ProgressBarExtract.Position := 20;
  LabelPercentExtract.Caption := 'Extracting...';
  Application.ProcessMessages;

  SevenZipExe := '';
  if Assigned(Nexagon) then
    SevenZipExe := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\nexagon\utils\7z.exe';
  TarExe := GetEnvironmentVariable('SystemRoot') + '\System32\tar.exe';

  if FileExists(SevenZipExe) and not EndsText('.tar.gz', LowerCase(AArchiveFile)) then
    CmdLine := Format('"%s" x "%s" -o"%s" -bd -aoa -y', [SevenZipExe, AArchiveFile, ADestDir])
  else if FileExists(TarExe) then
    CmdLine := Format('"%s" -xf "%s" -C "%s"', [TarExe, AArchiveFile, ADestDir])
  else
    Exit(False);

  P := TProcess.Create(nil);
  try
    P.CommandLine := CmdLine;
    P.Options := [poWaitOnExit, poNoConsole];
    P.ShowWindow := swoHide;
    P.Execute;
    Result := P.ExitStatus = 0;
  finally
    P.Free;
  end;

  if Result then
  begin
    FlattenSingleSubdir(ADestDir);
    ProgressBarExtract.Position := 100;
    if Assigned(Nexagon) then
      LabelPercentExtract.Caption := Nexagon.T(605, 'Extracted')
    else
      LabelPercentExtract.Caption := 'Extracted';
  end;
end;

procedure TFormQuickCreateWebsite.ConfigureWordPressWpConfig(const AProjectDir, ADbName: string);
var
  SampleFile, ConfigFile, Content, DbHostStr, CleanDb: string;
  SL: TStringList;
  I: Integer;
begin
  SampleFile := IncludeTrailingPathDelimiter(AProjectDir) + 'wp-config-sample.php';
  ConfigFile := IncludeTrailingPathDelimiter(AProjectDir) + 'wp-config.php';
  if not FileExists(SampleFile) then Exit;

  CleanDb := StringReplace(ADbName, '-', '_', [rfReplaceAll]);
  DbHostStr := 'localhost';
  if Assigned(SrvMySQL) and (SrvMySQL.Port <> 3306) then
    DbHostStr := 'localhost:' + IntToStr(SrvMySQL.Port);

  SL := TStringList.Create;
  try
    SL.LoadFromFile(SampleFile);
    Content := SL.Text;
    // Exact replacements from 0x1000b42c0..0x1000b47dd
    Content := StringReplace(Content, 'database_name_here', CleanDb, [rfReplaceAll]);
    Content := StringReplace(Content, 'username_here', 'root', [rfReplaceAll]);
    Content := StringReplace(Content, 'password_here', '', [rfReplaceAll]);
    Content := StringReplace(Content, '''localhost''', '''' + DbHostStr + '''', [rfReplaceAll]);
    Content := StringReplace(Content,
      'define( ''DB_COLLATE'', '''' );',
      'define( ''DB_COLLATE'', '''' );' + LineEnding +
      '$pageURL = ''http'';' + LineEnding +
      'if (isset($_SERVER["HTTPS"]) and $_SERVER["HTTPS"] == "on") {$pageURL .= "s";}' + LineEnding +
      '$pageURL .= "://";' + LineEnding +
      'if ($_SERVER["SERVER_PORT"] and $_SERVER["SERVER_PORT"] != "80") {' + LineEnding +
      '    $pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"];' + LineEnding +
      '} else {' + LineEnding +
      '    $pageURL .= $_SERVER["SERVER_NAME"];' + LineEnding +
      '}' + LineEnding +
      'define(''WP_SITEURL'', $pageURL);' + LineEnding +
      'define(''WP_HOME'', $pageURL);',
      []);
    for I := 1 to 8 do
      Content := StringReplace(Content, 'put your unique phrase here', GenerateRandomSalt(64), []);
    SL.Text := Content;
    SL.SaveToFile(ConfigFile);
  finally
    SL.Free;
  end;
end;

procedure TFormQuickCreateWebsite.ConfigureLaravelEnv(const AProjectDir, ADbName, AHostUrl: string);
var
  EnvExample, EnvFile, Content, CleanDb: string;
  SL: TStringList;
  DbPort: Integer;
begin
  EnvExample := IncludeTrailingPathDelimiter(AProjectDir) + '.env.example';
  EnvFile := IncludeTrailingPathDelimiter(AProjectDir) + '.env';
  if not FileExists(EnvFile) and FileExists(EnvExample) then
    CopyFile(PChar(EnvExample), PChar(EnvFile), False);
  if not FileExists(EnvFile) then Exit;

  CleanDb := StringReplace(ADbName, '-', '_', [rfReplaceAll]);
  DbPort := 3306;
  if Assigned(SrvMySQL) then DbPort := SrvMySQL.Port;

  SL := TStringList.Create;
  try
    SL.LoadFromFile(EnvFile);
    Content := SL.Text;
    // Exact replacements from 0x1000b4820..0x1000b4b44
    Content := StringReplace(Content, 'DB_DATABASE=homestead', 'DB_DATABASE=' + CleanDb, [rfReplaceAll]);
    Content := StringReplace(Content, 'DB_DATABASE=laravel', 'DB_DATABASE=' + CleanDb, [rfReplaceAll]);
    Content := StringReplace(Content, 'DB_USERNAME=homestead', 'DB_USERNAME=root', [rfReplaceAll]);
    Content := StringReplace(Content, 'DB_PASSWORD=secret', 'DB_PASSWORD=', [rfReplaceAll]);
    Content := StringReplace(Content, 'DB_PORT=3306', 'DB_PORT=' + IntToStr(DbPort), [rfReplaceAll]);
    if AHostUrl <> '' then
      Content := StringReplace(Content, 'APP_URL=http://localhost', 'APP_URL=' + AHostUrl, [rfReplaceAll]);
    SL.Text := Content;
    SL.SaveToFile(EnvFile);
  finally
    SL.Free;
  end;
end;

procedure TFormQuickCreateWebsite.StartQuickCreate(const AAppType, AProjectName, ADownloadUrl: string);
begin
  IsQuickApp := True;
  AppType := AAppType;
  ProjectName := AProjectName;
  DownloadUrl := Trim(ADownloadUrl);
  if Assigned(Nexagon) then
    TargetDir := IncludeTrailingPathDelimiter(Nexagon.DocumentRoot) + ProjectName
  else
    TargetDir := ProjectName;

  PanelMySQLError.Visible := False;
  PanelGeneratedPrettyUrl.Visible := True;
  ProgressBarDownload.Position := 0;
  ProgressBarExtract.Position := 0;
  LabelPercentExtract.Caption := '';
  LabelDownloadProgress.Caption := '';
  LabelSizeInfo.Caption := ProjectName;
  BtnVisitSite.Visible := True;
  BtnVisitSite.Enabled := False;
  FormShow(Self);
  Show;
  TimerLazyQuick.Enabled := True;
end;

procedure TFormQuickCreateWebsite.StartQuickAdd(const APkgName, ADownloadUrl: string);
var
  CleanPkg: string;
begin
  IsQuickApp := False;
  CleanPkg := Trim(APkgName);
  if (CleanPkg <> '') and (CleanPkg[1] = '*') then
    Delete(CleanPkg, 1, 1);
  AppType := CleanPkg;
  ProjectName := CleanPkg;
  DownloadUrl := Trim(ADownloadUrl);
  if Assigned(Nexagon) then
    TargetDir := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\' + LowerCase(CleanPkg)
  else
    TargetDir := 'bin\' + LowerCase(CleanPkg);

  PanelMySQLError.Visible := False;
  PanelGeneratedPrettyUrl.Visible := False;
  ProgressBarDownload.Position := 0;
  ProgressBarExtract.Position := 0;
  LabelPercentExtract.Caption := '';
  LabelDownloadProgress.Caption := '';
  LabelSizeInfo.Caption := CleanPkg;
  LabelCreateDatabase.Caption := '';
  BtnVisitSite.Visible := False;
  FormShow(Self);
  Show;
  TimerLazyQuick.Enabled := True;
end;

procedure TFormQuickCreateWebsite.TimerLazyQuickTimer(Sender: TObject);
var
  ErrMsg, HostName, IndexPhp, ArchiveName, CliCmd, PathStr: string;
  SL, PathDirs: TStringList;
  P: TProcess;
  I: Integer;
begin
  TimerLazyQuick.Enabled := False;
  if not Assigned(Nexagon) then Exit;

  if not IsQuickApp then
  begin
    // Quick Add package installation flow (0x1000b22b0..0x1000b25f9)
    ArchiveName := ExtractFileNameFromUrl(DownloadUrl, AppType);
    CachedArchivePath := IncludeTrailingPathDelimiter(Nexagon.GetTmpDir) + ArchiveName;
    if FileExists(CachedArchivePath) or DownloadFileWithWinInet(DownloadUrl, CachedArchivePath) then
    begin
      ProgressBarDownload.Position := 100;
      LabelDownloadProgress.Caption := '100%';
      ForceDirectories(TargetDir);
      ExtractArchiveToDir(CachedArchivePath, IncludeTrailingPathDelimiter(TargetDir) + ChangeFileExt(ArchiveName, ''));
      LabelCreateDatabase.Caption := Format('Done! - "%s"', [AppType]);
    end
    else
      LabelCreateDatabase.Caption := 'Download failed: ' + DownloadUrl;
    Exit;
  end;

  // Step 1: Create Database if MySQL is running (0x1000b3050)
  LabelCreateDatabase.Caption := Format('%s database "%s"...', [Nexagon.T(600, 'Creating'), ProjectName]);
  Application.ProcessMessages;
  if Assigned(SrvMySQL) and SrvMySQL.CheckRunning then
  begin
    if SrvMySQL.CreateDatabase(ProjectName, ErrMsg) then
      LabelCreateDatabase.Caption := Format('%s (%s)', [Nexagon.T(402, 'Created database!'), ProjectName])
    else
    begin
      PanelMySQLError.Visible := True;
      LabelMySQLError.Caption := ErrMsg;
    end;
  end
  else
    LabelCreateDatabase.Caption := Format('Database "%s" (MySQL not running, skipped)', [ProjectName]);

  // Step 2: Download / Execute CLI / Scaffold into TargetDir (0x1000b1eb3)
  ForceDirectories(TargetDir);
  if StartsText('http://', DownloadUrl) or StartsText('https://', DownloadUrl) then
  begin
    ArchiveName := ExtractFileNameFromUrl(DownloadUrl, AppType);
    CachedArchivePath := IncludeTrailingPathDelimiter(Nexagon.GetTmpDir) + ArchiveName;
    if FileExists(CachedArchivePath) or DownloadFileWithWinInet(DownloadUrl, CachedArchivePath) then
    begin
      ProgressBarDownload.Position := 100;
      LabelDownloadProgress.Caption := '100%';
      ExtractArchiveToDir(CachedArchivePath, TargetDir);
    end;
  end
  else if DownloadUrl <> '' then
  begin
    // CLI command in sites.conf (e.g. composer create-project / git clone) - 0x1000b2dd0
    CliCmd := StringReplace(DownloadUrl, '%s', ProjectName, [rfReplaceAll]);
    ProgressBarDownload.Position := 50;
    LabelDownloadProgress.Caption := 'Running CLI...';
    Application.ProcessMessages;
    P := TProcess.Create(nil);
    PathDirs := TStringList.Create;
    try
      P.Executable := GetEnvironmentVariable('ComSpec');
      P.CommandLine := '"' + P.Executable + '" /c ' + CliCmd;
      P.CurrentDirectory := Nexagon.DocumentRoot;
      for I := 1 to GetEnvironmentVariableCount do
        P.Environment.Add(GetEnvironmentString(I));
      PathStr := Nexagon.BuildNexagonPathList(PathDirs);
      if PathStr <> '' then
        P.Environment.Values['PATH'] := PathStr + ';' + GetEnvironmentVariable('PATH');
      P.Options := [poWaitOnExit, poNoConsole];
      P.ShowWindow := swoHide;
      P.Execute;
    finally
      PathDirs.Free;
      P.Free;
    end;
    ProgressBarDownload.Position := 100;
    LabelDownloadProgress.Caption := '100%';
    ProgressBarExtract.Position := 100;
    LabelPercentExtract.Caption := Nexagon.T(605, 'Extracted');
  end
  else
  begin
    // Blank Project Scaffold
    ProgressBarDownload.Position := 100;
    LabelDownloadProgress.Caption := '100%';
    IndexPhp := IncludeTrailingPathDelimiter(TargetDir) + 'index.php';
    if not FileExists(IndexPhp) then
    begin
      SL := TStringList.Create;
      try
        SL.Add('<?php');
        SL.Add(Format('// Created by Nexagon Quick App (%s)', [AppType]));
        SL.Add(Format('echo "<h1>Welcome to %s (%s)</h1>";', [ProjectName, AppType]));
        SL.SaveToFile(IndexPhp);
      finally
        SL.Free;
      end;
    end;
    ProgressBarExtract.Position := 100;
    LabelPercentExtract.Caption := '100% - Extracted to ' + TargetDir;
  end;

  // Step 3: Generate Virtual Host & Auto-Configure WordPress / Laravel (0x1000b20d0)
  HostName := Nexagon.CreateVirtualHostForProject(ProjectName, TargetDir);
  Nexagon.GenerateAutoVirtualHosts;
  PrettyUrl := 'http://' + HostName;
  ConfigureWordPressWpConfig(TargetDir, ProjectName);
  ConfigureLaravelEnv(TargetDir, ProjectName, PrettyUrl);

  LabelPrettyUrl.Caption := PrettyUrl;
  LabelPrettyUrl.Font.Color := clBlue;
  BtnVisitSite.Enabled := True;

  if Assigned(SrvApache) and SrvApache.Running then SrvApache.ReloadService;
  if Assigned(SrvNginx) and SrvNginx.Running then SrvNginx.ReloadService;
end;

procedure TFormQuickCreateWebsite.TimerExtractDataTimer(Sender: TObject);
begin
  TimerExtractData.Enabled := False;
end;

procedure TFormQuickCreateWebsite.ImageExploreClick(Sender: TObject);
begin
  if DirectoryExists(TargetDir) then
    OpenUrlOrFile('explorer.exe', '"' + TargetDir + '"');
end;

procedure TFormQuickCreateWebsite.LabelCantDownloadClick(Sender: TObject);
begin
  if DownloadUrl <> '' then
    OpenUrlOrFile(DownloadUrl);
end;

procedure TFormQuickCreateWebsite.LabelCantDownloadMouseEnter(Sender: TObject);
begin
  LabelCantDownload.Font.Style := [fsUnderline];
end;

procedure TFormQuickCreateWebsite.LabelCantDownloadMouseLeave(Sender: TObject);
begin
  LabelCantDownload.Font.Style := [];
end;

procedure TFormQuickCreateWebsite.ImageDownloadInfoOffMouseEnter(Sender: TObject);
begin
  ImageDownloadInfoOn.Visible := True;
end;

procedure TFormQuickCreateWebsite.ImageDownloadInfoOnClick(Sender: TObject);
begin
  if DownloadUrl <> '' then
    OpenUrlOrFile(DownloadUrl);
end;

procedure TFormQuickCreateWebsite.ImageDownloadInfoOnMouseLeave(Sender: TObject);
begin
  ImageDownloadInfoOn.Visible := False;
end;

procedure TFormQuickCreateWebsite.LabelPrettyUrlClick(Sender: TObject);
begin
  if PrettyUrl <> '' then
    OpenUrlOrFile(PrettyUrl);
end;

procedure TFormQuickCreateWebsite.LabelPrettyUrlMouseEnter(Sender: TObject);
begin
  LabelPrettyUrl.Font.Style := [fsUnderline];
end;

procedure TFormQuickCreateWebsite.LabelPrettyUrlMouseLeave(Sender: TObject);
begin
  LabelPrettyUrl.Font.Style := [];
end;

procedure TFormQuickCreateWebsite.BtnVisitSiteClick(Sender: TObject);
begin
  if PrettyUrl <> '' then
    OpenUrlOrFile(PrettyUrl);
end;

procedure TFormQuickCreateWebsite.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
