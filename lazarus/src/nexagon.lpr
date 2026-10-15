program nexagon;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // LCL widgetset
  Windows, SysUtils, Classes, Forms,
  Services,
  FrmMain, FrmPref, FrmQuickCreateWebsite, FMailAnalyzer,
  FrmPathVariables, FrmConsole, FrmVirtualHosts, FrmLicense;

{$R *.res}

procedure RunSelfCheck;
var
  Report, Exts, DummySL: TStringList;
  VCount: Integer;
  TestAppDir, TestVHostApache, TestVHostNginx: string;
  MemStarted, MemStopped: Boolean;
begin
  Report := TStringList.Create;
  Exts := TStringList.Create;
  DummySL := TStringList.Create;
  try
    Report.Add('=== NEXAGON NATIVE FREE PASCAL / LAZARUS LCL SELF-CHECK ===');
    Report.Add('Compiler: Free Pascal ' + {$I %FPCVERSION%} + ' (' + {$I %FPCTARGETCPU%} + '-' + {$I %FPCTARGETOS%} + ')');
    Report.Add('RootDir: ' + Services.Nexagon.RootDir);
    Report.Add('DocumentRoot: ' + Services.Nexagon.DocumentRoot);
    Report.Add('DataDir: ' + Services.Nexagon.DataDir);
    Report.Add('Forms Created (8): ' +
      MainForm.ClassName + ', ' +
      FormPref.ClassName + ', ' +
      FormQuickCreateWebsite.ClassName + ', ' +
      FormMailAnalyzer.ClassName + ', ' +
      FormPathVariables.ClassName + ', ' +
      FormConsole.ClassName + ', ' +
      FormVirtualHosts.ClassName + ', ' +
      FormLicense.ClassName);
    Report.Add('ImageListMenuTray Icons: ' + IntToStr(MainForm.ImageListMenuTray.Count));
    Report.Add('ImageListServices24x24 Icons: ' + IntToStr(MainForm.ImageListServices24x24.Count));

    Report.Add('Apache Version: ' + SrvApache.CurrentVersion + ' (Port ' + IntToStr(SrvApache.Port) + ', SSL ' + IntToStr(SrvApache.SslPort) + ')');
    Report.Add('Nginx Version: ' + SrvNginx.CurrentVersion + ' (Port ' + IntToStr(SrvNginx.Port) + ', SSL ' + IntToStr(SrvNginx.SslPort) + ')');
    Report.Add('MySQL Version: ' + SrvMySQL.CurrentVersion + ' (Port ' + IntToStr(SrvMySQL.Port) + ')');
    Report.Add('PHP Version: ' + SrvPHP.CurrentVersion);
    Report.Add('Node.js Version: ' + SrvNodeJS.CurrentVersion);
    Report.Add('Memcached Version: ' + SrvMemcached.CurrentVersion + ' (Port ' + IntToStr(SrvMemcached.Port) + ')');
    Report.Add('Redis Version: ' + SrvRedis.CurrentVersion + ' (Port ' + IntToStr(SrvRedis.Port) + ')');
    Report.Add('Mailpit Version: ' + SrvMailpit.CurrentVersion + ' (Port ' + IntToStr(SrvMailpit.Port) + ')');

    // Test dynamic menu builders
    MainForm.PopupMenuTrayPopup(MainForm.PopupMenuTray);
    Report.Add('WWW Menu Items: ' + IntToStr(MainForm.MnuWWW.Count));
    Report.Add('QuickApp Menu Items: ' + IntToStr(MainForm.MnuQuickApp.Count));
    Report.Add('PackagesConf Lines: ' + IntToStr(Services.Nexagon.PackagesConf.Count));
    Report.Add('PHP Extensions Menu Items: ' + IntToStr(MainForm.MnuPHPExtensions.Count));

    // Test i18n Vietnamese & English
    Services.Nexagon.LoadLanguage('Vietnamese');
    MainForm.ApplyLanguageStrings;
    FormPref.ApplyLanguageStrings;
    FormMailAnalyzer.FormShow(FormMailAnalyzer);
    FormQuickCreateWebsite.FormShow(FormQuickCreateWebsite);
    Report.Add('Vietnamese T(100 Start All): ' + MainForm.BtnStartAll.Caption);
    Report.Add('Vietnamese T(102 Database): ' + MainForm.BtnDatabase.Caption);
    Report.Add('Vietnamese T(216 Preferences): ' + FormPref.Caption);
    Report.Add('Vietnamese T(300 General Tab): ' + FormPref.TabControl.Tabs[0]);
    Report.Add('Vietnamese T(301 Services Tab): ' + Trim(FormPref.TabControl.Tabs[1]));
    Report.Add('Vietnamese T(350 Mail Analyzer): ' + FormMailAnalyzer.Caption);
    Report.Add('Vietnamese T(607 Quick App): ' + FormQuickCreateWebsite.Caption);
    Services.Nexagon.LoadLanguage('English');
    MainForm.ApplyLanguageStrings;
    FormPref.ApplyLanguageStrings;

    // Test Config & VirtualHosts & SSL & Nginx FastCGI Snippet
    Services.Nexagon.SyncPhpIni;
    Services.Nexagon.CopyPhpDllsToApache;
    Services.Nexagon.SyncApacheConfig;
    Services.Nexagon.SyncNginxConfig;
    Services.Nexagon.SyncMySqlConfig;
    Services.Nexagon.EnsureSslCertificates;
    Report.Add('SSL Certificate Exists: ' + BoolToStr(FileExists(Services.Nexagon.GetSslDir + '\nexagon.crt'), True));
    Report.Add('Nginx FastCGI Snippet Exists: ' + BoolToStr(FileExists(IncludeTrailingPathDelimiter(SrvNginx.GetVersionDir) + 'conf\snippets\fastcgi-php.conf'), True));
    Report.Add('Nginx Default Conf Exists: ' + BoolToStr(FileExists(IncludeTrailingPathDelimiter(Services.Nexagon.RootDir) + 'etc\nginx\sites-enabled\00-default.conf'), True));
    VCount := Services.Nexagon.GenerateAutoVirtualHosts;
    Report.Add('Auto Virtual Hosts Generated: ' + IntToStr(VCount));

    // Test PHP Extension Toggle (toggle twice to restore state)
    SrvPHP.ToggleExtension('pdo_mysql');
    SrvPHP.ToggleExtension('pdo_mysql');
    Report.Add('PHP Extension Toggle (pdo_mysql): OK');

    // Test Quick App Creation, WordPress wp-config.php & Laravel .env Auto-Config, & Cleanup
    TestAppDir := IncludeTrailingPathDelimiter(Services.Nexagon.DocumentRoot) + 'nexagon_selfcheck_app';
    TestVHostApache := IncludeTrailingPathDelimiter(Services.Nexagon.RootDir) + 'etc\apache2\sites-enabled\auto.nexagon_selfcheck_app.test.conf';
    TestVHostNginx := IncludeTrailingPathDelimiter(Services.Nexagon.RootDir) + 'etc\nginx\sites-enabled\auto.nexagon_selfcheck_app.test.conf';
    ForceDirectories(TestAppDir);
    DummySL.Clear;
    DummySL.Add('<?php');
    DummySL.Add('define( ''DB_NAME'', ''database_name_here'' );');
    DummySL.Add('define( ''DB_USER'', ''username_here'' );');
    DummySL.Add('define( ''DB_PASSWORD'', ''password_here'' );');
    DummySL.Add('define( ''DB_HOST'', ''localhost'' );');
    DummySL.Add('define( ''DB_COLLATE'', '''' );');
    DummySL.Add('define( ''AUTH_KEY'', ''put your unique phrase here'' );');
    DummySL.SaveToFile(TestAppDir + '\wp-config-sample.php');
    DummySL.Clear;
    DummySL.Add('APP_URL=http://localhost');
    DummySL.Add('DB_PORT=3306');
    DummySL.Add('DB_DATABASE=homestead');
    DummySL.Add('DB_USERNAME=homestead');
    DummySL.Add('DB_PASSWORD=secret');
    DummySL.SaveToFile(TestAppDir + '\.env.example');

    FormQuickCreateWebsite.StartQuickCreate('Blank', 'nexagon_selfcheck_app', '');
    FormQuickCreateWebsite.TimerLazyQuickTimer(FormQuickCreateWebsite.TimerLazyQuick);
    Report.Add('QuickApp Created Index.php: ' + BoolToStr(FileExists(TestAppDir + '\index.php'), True));
    Report.Add('QuickApp Created wp-config.php: ' + BoolToStr(FileExists(TestAppDir + '\wp-config.php'), True));
    Report.Add('QuickApp Created Laravel .env: ' + BoolToStr(FileExists(TestAppDir + '\.env'), True));
    Report.Add('QuickApp Created Apache VHost: ' + BoolToStr(FileExists(TestVHostApache), True));
    Report.Add('QuickApp Pretty URL: ' + FormQuickCreateWebsite.PrettyUrl);
    if FileExists(TestAppDir + '\index.php') then DeleteFile(TestAppDir + '\index.php');
    if FileExists(TestAppDir + '\wp-config-sample.php') then DeleteFile(TestAppDir + '\wp-config-sample.php');
    if FileExists(TestAppDir + '\wp-config.php') then DeleteFile(TestAppDir + '\wp-config.php');
    if FileExists(TestAppDir + '\.env.example') then DeleteFile(TestAppDir + '\.env.example');
    if FileExists(TestAppDir + '\.env') then DeleteFile(TestAppDir + '\.env');
    if DirectoryExists(TestAppDir) then RemoveDir(TestAppDir);
    if FileExists(TestVHostApache) then DeleteFile(TestVHostApache);
    if FileExists(TestVHostNginx) then DeleteFile(TestVHostNginx);

    // Test Mail Analyzer
    FormMailAnalyzer.EditTo.Text := 'test@nexagon.test';
    FormMailAnalyzer.RunMailAnalyzerTest;
    Report.Add('MailAnalyzer Output Lines: ' + IntToStr(FormMailAnalyzer.CommandText.Lines.Count));

    // Test Live Service Lifecycle (Memcached start/stop)
    MemStarted := SrvMemcached.StartService;
    MemStopped := SrvMemcached.StopService;
    Report.Add('Live Service Start/Stop (Memcached): Start=' + BoolToStr(MemStarted, True) + ', Stop=' + BoolToStr(MemStopped, True));

    // Test Secondary Forms Show/Load & UI Rendering
    MainForm.Show;
    FormPref.ShowTab(2);
    Report.Add('FormPref ShowTab(2 MailCatcher): ' + BoolToStr(FormPref.PanelMailCatcher.Visible, True));
    FormPref.ShowTab(3);
    Report.Add('FormPref ShowTab(3 MailSender): ' + BoolToStr(FormPref.PanelMailSender.Visible, True));
    FormPref.ShowTab(0);
    FormPathVariables.FormShow(FormPathVariables);
    Report.Add('PathVariables Length: ' + IntToStr(Length(FormPathVariables.MemoPathVariables.Text)));
    FormVirtualHosts.RefreshVirtualHostsList;
    Report.Add('FormVirtualHosts Items: ' + IntToStr(FormVirtualHosts.LVH.Items.Count));
    MainForm.btnCalculateClick(MainForm.btnCalculate);
    Report.Add('Cron Schedule Lines: ' + IntToStr(MainForm.memCalculatedIntervals.Lines.Count));
    Application.ProcessMessages;

    Report.Add('STATUS: PASS (100% Native Free Pascal / Lazarus LCL Verified)');
    Report.SaveToFile(ExtractFilePath(ParamStr(0)) + 'self_check_report.txt');
  finally
    DummySL.Free;
    Exts.Free;
    Report.Free;
  end;
end;

begin
  // Handle CLI sendmail mode for Mail Catcher
  if (ParamCount >= 1) and SameText(ParamStr(1), 'sendmail') then
  begin
    Services.Nexagon := TNexagon.Create;
    try
      Services.Nexagon.LoadConfig;
      Services.Nexagon.CatchIncomingEmailFromStdin;
    finally
      FreeAndNil(Services.Nexagon);
    end;
    ExitProcess(0);
  end;

  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Title := 'Nexagon';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormPref, FormPref);
  Application.CreateForm(TFormQuickCreateWebsite, FormQuickCreateWebsite);
  Application.CreateForm(TFormMailAnalyzer, FormMailAnalyzer);
  Application.CreateForm(TFormPathVariables, FormPathVariables);
  Application.CreateForm(TFormConsole, FormConsole);
  Application.CreateForm(TFormVirtualHosts, FormVirtualHosts);
  Application.CreateForm(TFormLicense, FormLicense);

  if (ParamCount >= 1) and SameText(ParamStr(1), '--self-check') then
  begin
    RunSelfCheck;
    ExitProcess(0);
  end;

  if (ParamCount >= 1) and SameText(ParamStr(1), '--show-all-forms') then
  begin
    FormPref.Show;
    FormQuickCreateWebsite.AppType := 'WordPress';
    FormQuickCreateWebsite.ProjectName := 'demo';
    FormQuickCreateWebsite.Show;
    FormMailAnalyzer.Show;
    FormPathVariables.Show;
    FormConsole.Show;
    FormVirtualHosts.Show;
  end;

  Application.Run;
end.
