unit FrmPref;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Registry, Services, FMailAnalyzer;

type
  TFormPref = class(TForm)
  published
    TabControl: TTabControl;
    PanelMailSender: TPanel;
    LabelGmailAddress: TLabel;
    LabelGmailPassword: TLabel;
    LabelMailAdvanced: TLabel;
    LabelMailSenderNote: TLabel;
    BtnTestMail: TButton;
    EditEmail: TEdit;
    EditPassword: TEdit;
    CheckBoxMailSenderEnabled: TCheckBox;
    PanelMailAdvanced: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    LabelBasicSettings: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Button1: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit7: TEdit;
    ComboBox2: TComboBox;
    Edit8: TEdit;
    Edit1: TEdit;
    ComboBox3: TComboBox;
    CheckBox1: TCheckBox;
    PanelMailCatcher: TPanel;
    LabelMailCatcherNote: TLabel;
    LabelMailCatcherYouCanView: TLabel;
    LabelMailCatcherWindowDisplayTime: TLabel;
    LabelMailCatcherSecond: TLabel;
    EditMailCatcherWindowDisplayTime: TEdit;
    CheckBoxMailCatcherEnabled: TCheckBox;
    PanelContainer: TPanel;
    PanelGeneral: TPanel;
    LabelDocumentRoot: TLabel;
    LabelLang: TLabel;
    LabelDataDir: TLabel;
    LabelHostNameFormat: TLabel;
    CheckBoxAutoVirtualHosts: TCheckBox;
    EditDocumentRoot: TEdit;
    CheckBoxRunAtStartup: TCheckBox;
    CheckBoxAutoStart: TCheckBox;
    BtnDocumentRoot: TButton;
    CheckBoxMinimizeWhenRun: TCheckBox;
    ComboBoxLang: TComboBox;
    EditHostnameFormat: TEdit;
    EditDataDir: TEdit;
    BtnDataDir: TButton;
    CheckBoxAutoUpdate: TCheckBox;
    CheckBoxAutoBackup: TCheckBox;
    EditBackupInterval: TEdit;
    LabelBackupInterval: TLabel;
    UpDownBackupInterval: TUpDown;
    PanelServicesAndPorts: TPanel;
    ImageSep: TImage;
    LabelSep: TLabel;
    LabelApacheSSLPort: TLabel;
    LabelNginxSSLPort: TLabel;
    EditPHPServerPort: TEdit;
    EditMySqlPort: TEdit;
    CheckBoxPHPServer: TCheckBox;
    CheckBoxMySql: TCheckBox;
    EditApachePort: TEdit;
    CheckBoxApache: TCheckBox;
    CheckBoxMemcached: TCheckBox;
    EditMemcachedPort: TEdit;
    CheckBoxRedis: TCheckBox;
    EditNginxPort: TEdit;
    EditRedisPort: TEdit;
    EditApacheSSLPort: TEdit;
    CheckBoxNginx: TCheckBox;
    CheckBoxPostgreSQL: TCheckBox;
    CheckBoxApacheSSLEnabled: TCheckBox;
    CheckBoxMongoDB: TCheckBox;
    EditNginxSSLPort: TEdit;
    CheckBoxNginxSSLEnabled: TCheckBox;
    EditMongoDBPort: TEdit;
    EditPostgreSQLPort: TEdit;
    CheckBoxMailpit: TCheckBox;
    EditMailpitPort: TEdit;
    procedure BtnDataDirClick(Sender: TObject);
    procedure BtnDocumentRootClick(Sender: TObject);
    procedure BtnTestMailClick(Sender: TObject);
    procedure CheckBoxApacheClick(Sender: TObject);
    procedure CheckBoxApacheSSLEnabledMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBoxAutoBackupMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBoxAutoStartClick(Sender: TObject);
    procedure CheckBoxAutoUpdateMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBoxAutoVirtualHostsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBoxMailCatcherEnabledClick(Sender: TObject);
    procedure CheckBoxMailSenderEnabledClick(Sender: TObject);
    procedure CheckBoxMailpitClick(Sender: TObject);
    procedure CheckBoxMemcachedClick(Sender: TObject);
    procedure CheckBoxMinimizeWhenRunClick(Sender: TObject);
    procedure CheckBoxMongoDBClick(Sender: TObject);
    procedure CheckBoxMySqlClick(Sender: TObject);
    procedure CheckBoxNginxClick(Sender: TObject);
    procedure CheckBoxNginxSSLEnabledMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBoxPHPServerClick(Sender: TObject);
    procedure CheckBoxPostgreSQLClick(Sender: TObject);
    procedure CheckBoxRedisClick(Sender: TObject);
    procedure CheckBoxRunAtStartupMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ComboBoxLangChange(Sender: TObject);
    procedure EditApachePortChange(Sender: TObject);
    procedure EditApacheSSLPortChange(Sender: TObject);
    procedure EditBackupIntervalChange(Sender: TObject);
    procedure EditEmailChange(Sender: TObject);
    procedure EditHostnameFormatChange(Sender: TObject);
    procedure EditMailCatcherWindowDisplayTimeChange(Sender: TObject);
    procedure EditMailpitPortChange(Sender: TObject);
    procedure EditMemcachedPortChange(Sender: TObject);
    procedure EditMongoDBPortChange(Sender: TObject);
    procedure EditMySqlPortChange(Sender: TObject);
    procedure EditNginxPortChange(Sender: TObject);
    procedure EditNginxSSLPortChange(Sender: TObject);
    procedure EditPHPServerPortChange(Sender: TObject);
    procedure EditPasswordChange(Sender: TObject);
    procedure EditPostgreSQLPortChange(Sender: TObject);
    procedure EditRedisPortChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabelBasicSettingsClick(Sender: TObject);
    procedure LabelDocumentRootClick(Sender: TObject);
    procedure LabelMailAdvancedClick(Sender: TObject);
    procedure PanelGeneralClick(Sender: TObject);
    procedure PanelMailCatcherClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure UpDownBackupIntervalChanging(Sender: TObject; var AllowChange: Boolean);
  private
    FLoading: Boolean;
    procedure NotifyServicesChanged;
  public
    procedure SwitchToPanel(APanel: TPanel);
    procedure ApplyLanguageStrings;
    procedure LoadValuesFromConfig;
    procedure ShowTab(TabIdx: Integer);
  end;

var
  FormPref: TFormPref;

implementation

{$R *.lfm}

procedure TFormPref.FormCreate(Sender: TObject);
begin
  FLoading := True;
  try
    Width := 800;
    Height := 800;
    TabControl.Height := Height - 20;
    TabControl.Width := Width - 20;
    TabControl.Top := (Height - TabControl.Height) div 2;
    TabControl.Left := (Width - TabControl.Width) div 2;
    Color := clWhite;

    PanelContainer.Align := alClient;
    PanelGeneral.Left := 30;
    PanelGeneral.Top := 10;
    PanelServicesAndPorts.Left := PanelGeneral.Left;
    PanelServicesAndPorts.Top := PanelGeneral.Top;
    PanelMailCatcher.Left := PanelServicesAndPorts.Left;
    PanelMailCatcher.Top := PanelServicesAndPorts.Top;
    PanelMailSender.Left := PanelServicesAndPorts.Left;
    PanelMailSender.Top := PanelServicesAndPorts.Top;
    PanelMailAdvanced.Top := PanelServicesAndPorts.Top;
    PanelMailAdvanced.Left := PanelServicesAndPorts.Left;

    PanelMailCatcher.Visible := False;
    PanelMailSender.Visible := False;
    PanelMailAdvanced.Visible := False;

    EditPassword.PasswordChar := '*';

    ApplyLanguageStrings;
    SwitchToPanel(PanelGeneral);
  finally
    FLoading := False;
  end;
end;

procedure TFormPref.SwitchToPanel(APanel: TPanel);
begin
  PanelGeneral.Visible := False;
  PanelServicesAndPorts.Visible := False;
  PanelMailCatcher.Visible := False;
  PanelMailSender.Visible := False;
  PanelMailAdvanced.Visible := False;
  if Assigned(APanel) then
    APanel.Visible := True;
end;

procedure TFormPref.ShowTab(TabIdx: Integer);
begin
  Show;
  BringToFront;
  if (TabIdx >= 0) and (TabIdx < TabControl.Tabs.Count) then
  begin
    TabControl.TabIndex := TabIdx;
    TabControlChange(TabControl);
  end
  else if TabIdx = 2 then
    SwitchToPanel(PanelMailCatcher)
  else if TabIdx = 3 then
    SwitchToPanel(PanelMailSender);
end;

procedure TFormPref.ApplyLanguageStrings;
var
  SavedIndex: Integer;
begin
  if not Assigned(Nexagon) then Exit;
  Caption := Nexagon.T(216, 'Preferences');
  SavedIndex := TabControl.TabIndex;
  if SavedIndex < 0 then SavedIndex := 0;
  TabControl.Tabs.BeginUpdate;
  try
    TabControl.Tabs.Clear;
    TabControl.Tabs.Add(Nexagon.T(300, 'General'));
    TabControl.Tabs.Add(Nexagon.T(301, 'Services & Ports'));
    if SavedIndex < TabControl.Tabs.Count then
      TabControl.TabIndex := SavedIndex
    else
      TabControl.TabIndex := 0;
  finally
    TabControl.Tabs.EndUpdate;
  end;

  CheckBoxRunAtStartup.Caption := Nexagon.T(310, 'Run Nexagon when Windows starts');
  CheckBoxRunAtStartup.Hint := Nexagon.T(311, 'Automatically start Nexagon when you log in to Windows');
  CheckBoxMinimizeWhenRun.Caption := Nexagon.T(312, 'Run minimized');
  CheckBoxMinimizeWhenRun.Hint := Nexagon.T(313, 'Nexagon will stay in the system tray');
  CheckBoxAutoStart.Caption := Nexagon.T(314, 'Start All automatically');
  CheckBoxAutoStart.Hint := Nexagon.T(315, 'Automatically start selected services such as Apache, MySQL,...');
  LabelLang.Caption := Nexagon.T(316, 'Language') + ':';
  LabelDocumentRoot.Caption := Nexagon.T(317, 'Document Root') + ':';
  EditDocumentRoot.Hint := Nexagon.T(318, 'Click to change Document Root');
  LabelDataDir.Caption := Nexagon.T(319, 'Data Root') + ':';
  EditDataDir.Hint := Nexagon.T(320, 'Click to change Data Directory');
  CheckBoxAutoVirtualHosts.Caption := Nexagon.T(322, 'Auto create virtual hosts');
  CheckBoxAutoVirtualHosts.Hint := Nexagon.T(323, 'Just put code in Document Root and click Reload');
  LabelHostNameFormat.Caption := Nexagon.T(324, 'Format') + ':';
  EditHostnameFormat.Hint := Format(Nexagon.T(325, 'For example, if your project name is %s' + LineEnding + '%s'), ['blog', 'blog.test']);
  EditHostnameFormat.Left := LabelHostNameFormat.Left + LabelHostNameFormat.Width + 10;

  CheckBoxAutoBackup.Caption := Nexagon.T(360, 'Auto Backup');
  CheckBoxAutoBackup.Hint := Format(Nexagon.T(361, 'Automatically backup Data Directory to %s'), [Nexagon.RootDir + '\backup']);
  LabelBackupInterval.Caption := Nexagon.T(362, 'Backup Interval') + ':';
  EditBackupInterval.Hint := Nexagon.T(363, 'hours');
  EditBackupInterval.Left := LabelBackupInterval.Left + LabelBackupInterval.Width + 10;
  UpDownBackupInterval.Left := EditBackupInterval.Left + EditBackupInterval.Width;

  CheckBoxAutoUpdate.Caption := Nexagon.T(380, 'Auto Update');
  CheckBoxAutoUpdate.Hint := Nexagon.T(381, 'Automatically check for latest PHP versions');

  LabelSep.Caption := Nexagon.T(328, 'Advanced');
  CheckBoxApacheSSLEnabled.Caption := Nexagon.T(110, 'Enabled');
  CheckBoxNginxSSLEnabled.Caption := Nexagon.T(110, 'Enabled');
  CheckBoxMailCatcherEnabled.Caption := Nexagon.T(110, 'Enabled');
  CheckBoxMailSenderEnabled.Caption := Nexagon.T(110, 'Enabled');

  LabelMailCatcherNote.Caption := Nexagon.T(329, 'When calling mail() function, Nexagon will display info on bottom right.');
  LabelMailCatcherWindowDisplayTime.Caption := Nexagon.T(330, 'This window will be displayed in');
  LabelMailCatcherYouCanView.Caption := Nexagon.T(331, 'You can always view the latest email at:' + LineEnding + 'Menu > PHP > Mail Catcher > View latest email');

  LabelGmailAddress.Caption := Nexagon.T(340, 'Gmail Address') + ':';
  LabelGmailPassword.Caption := Nexagon.T(341, 'Gmail Password') + ':';
  BtnTestMail.Caption := Nexagon.T(342, 'Test Sending Mail') + ' / ' + Nexagon.T(350, 'Mail Analyzer');
  LabelMailSenderNote.Caption := Nexagon.T(343, 'Your Gmail password will be encrypted.');
end;

procedure TFormPref.LoadValuesFromConfig;
var
  Idx: Integer;
  HasBin: Boolean;
begin
  if not Assigned(Nexagon) then Exit;
  FLoading := True;
  try
    Nexagon.ListAvailableLanguages(ComboBoxLang.Items);
    Idx := ComboBoxLang.Items.IndexOf(Nexagon.Language);
    if Idx >= 0 then ComboBoxLang.ItemIndex := Idx;

    CheckBoxRunAtStartup.Checked := Nexagon.RunAtStartup;
    CheckBoxMinimizeWhenRun.Checked := Nexagon.MinimizeWhenRun;
    CheckBoxAutoStart.Checked := Nexagon.AutoStart > 0;
    EditDocumentRoot.Text := Nexagon.DocumentRoot;
    EditDataDir.Text := Nexagon.DataDir;
    CheckBoxAutoVirtualHosts.Checked := Nexagon.AutoVirtualHosts;
    EditHostnameFormat.Text := Nexagon.HostnameFormat;
    CheckBoxAutoBackup.Checked := Nexagon.AutoBackup;
    EditBackupInterval.Text := IntToStr(Nexagon.BackupInterval);
    CheckBoxAutoUpdate.Checked := Nexagon.AutoUpdate;

    CheckBoxMailCatcherEnabled.Checked := Nexagon.MailCatcherEnabled;
    EditMailCatcherWindowDisplayTime.Text := IntToStr(Nexagon.MailCatcherDisplayTime);
    CheckBoxMailSenderEnabled.Checked := Nexagon.MailSenderEnabled;
    EditEmail.Text := Nexagon.GmailAddress;
    EditPassword.Text := Nexagon.GmailPassword;

    if Assigned(SrvApache) then
    begin
      HasBin := FileExists(SrvApache.GetExePath);
      CheckBoxApache.Checked := SrvApache.Enabled;
      EditApachePort.Text := IntToStr(SrvApache.Port);
      EditApacheSSLPort.Text := IntToStr(SrvApache.SslPort);
      CheckBoxApacheSSLEnabled.Checked := SrvApache.SslEnabled;
      CheckBoxApache.Enabled := HasBin;
      EditApachePort.Enabled := HasBin;
      CheckBoxApacheSSLEnabled.Enabled := HasBin;
      LabelApacheSSLPort.Enabled := HasBin and CheckBoxApacheSSLEnabled.Checked;
      EditApacheSSLPort.Enabled := HasBin and CheckBoxApacheSSLEnabled.Checked;
    end;
    if Assigned(SrvMySQL) then
    begin
      HasBin := FileExists(SrvMySQL.GetExePath);
      CheckBoxMySql.Checked := SrvMySQL.Enabled;
      EditMySqlPort.Text := IntToStr(SrvMySQL.Port);
      CheckBoxMySql.Enabled := HasBin;
      EditMySqlPort.Enabled := HasBin;
    end;
    if Assigned(SrvPostgreSQL) then
    begin
      HasBin := FileExists(SrvPostgreSQL.GetExePath);
      CheckBoxPostgreSQL.Checked := SrvPostgreSQL.Enabled;
      EditPostgreSQLPort.Text := IntToStr(SrvPostgreSQL.Port);
      CheckBoxPostgreSQL.Enabled := HasBin;
      EditPostgreSQLPort.Enabled := HasBin;
    end;
    if Assigned(SrvNginx) then
    begin
      HasBin := FileExists(SrvNginx.GetExePath);
      CheckBoxNginx.Checked := SrvNginx.Enabled;
      EditNginxPort.Text := IntToStr(SrvNginx.Port);
      EditNginxSSLPort.Text := IntToStr(SrvNginx.SslPort);
      CheckBoxNginxSSLEnabled.Checked := SrvNginx.SslEnabled;
      CheckBoxNginx.Enabled := HasBin;
      EditNginxPort.Enabled := HasBin;
      CheckBoxNginxSSLEnabled.Enabled := HasBin;
      LabelNginxSSLPort.Enabled := HasBin and CheckBoxNginxSSLEnabled.Checked;
      EditNginxSSLPort.Enabled := HasBin and CheckBoxNginxSSLEnabled.Checked;
    end;
    if Assigned(SrvMemcached) then
    begin
      HasBin := FileExists(SrvMemcached.GetExePath);
      CheckBoxMemcached.Checked := SrvMemcached.Enabled;
      EditMemcachedPort.Text := IntToStr(SrvMemcached.Port);
      CheckBoxMemcached.Enabled := HasBin;
      EditMemcachedPort.Enabled := HasBin;
    end;
    if Assigned(SrvRedis) then
    begin
      HasBin := FileExists(SrvRedis.GetExePath);
      CheckBoxRedis.Checked := SrvRedis.Enabled;
      EditRedisPort.Text := IntToStr(SrvRedis.Port);
      CheckBoxRedis.Enabled := HasBin;
      EditRedisPort.Enabled := HasBin;
    end;
    if Assigned(SrvMongoDB) then
    begin
      HasBin := FileExists(SrvMongoDB.GetExePath);
      CheckBoxMongoDB.Checked := SrvMongoDB.Enabled;
      EditMongoDBPort.Text := IntToStr(SrvMongoDB.Port);
      CheckBoxMongoDB.Enabled := HasBin;
      EditMongoDBPort.Enabled := HasBin;
    end;
    if Assigned(SrvMailpit) then
    begin
      HasBin := FileExists(SrvMailpit.GetExePath);
      CheckBoxMailpit.Checked := SrvMailpit.Enabled;
      EditMailpitPort.Text := IntToStr(SrvMailpit.Port);
      CheckBoxMailpit.Enabled := HasBin;
      EditMailpitPort.Enabled := HasBin;
    end;
    if Assigned(SrvPHP) then
    begin
      CheckBoxPHPServer.Checked := SrvPHP.Enabled;
      EditPHPServerPort.Text := IntToStr(SrvPHP.Port);
    end;
  finally
    FLoading := False;
  end;
end;

procedure TFormPref.NotifyServicesChanged;
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.SaveConfig;
  if Assigned(OnGlobalServicesUpdated) then
    OnGlobalServicesUpdated(Self);
end;

procedure TFormPref.FormShow(Sender: TObject);
begin
  LoadValuesFromConfig;
  ApplyLanguageStrings;
  TabControlChange(TabControl);
end;

procedure TFormPref.FormActivate(Sender: TObject);
begin
  // Keep active
end;

procedure TFormPref.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(Nexagon) then
    Nexagon.SaveConfig;
  CloseAction := caHide;
end;

procedure TFormPref.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(Nexagon) then
    Nexagon.SaveConfig;
  CanClose := True;
end;

procedure TFormPref.TabControlChange(Sender: TObject);
begin
  case TabControl.TabIndex of
    0: SwitchToPanel(PanelGeneral);
    1: SwitchToPanel(PanelServicesAndPorts);
    2: SwitchToPanel(PanelMailCatcher);
    3: SwitchToPanel(PanelMailSender);
  else
    SwitchToPanel(PanelGeneral);
  end;
end;

procedure TFormPref.ComboBoxLangChange(Sender: TObject);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  if ComboBoxLang.Text <> '' then
  begin
    Nexagon.LoadLanguage(ComboBoxLang.Text);
    ApplyLanguageStrings;
    NotifyServicesChanged;
  end;
end;

procedure TFormPref.BtnDocumentRootClick(Sender: TObject);
var
  Dir: string;
begin
  if not Assigned(Nexagon) then Exit;
  Dir := Nexagon.DocumentRoot;
  if SelectDirectory(Nexagon.T(506, 'Document Root'), '', Dir) then
  begin
    if Pos(' ', Trim(Dir)) > 0 then
    begin
      MessageDlg('Path must not have SPACE!' + LineEnding + Dir, mtWarning, [mbOK], 0);
      Exit;
    end;
    ForceDirectories(Dir);
    Dir := ExcludeTrailingPathDelimiter(Trim(Dir));
    EditDocumentRoot.Text := Dir;
    Nexagon.DocumentRoot := Dir;
    Nexagon.AddDocumentRootToList(Dir);
    Nexagon.SaveConfig;
    Nexagon.SyncApacheConfig;
    Nexagon.SyncNginxConfig;
    if Nexagon.AutoVirtualHosts then
      Nexagon.GenerateAutoVirtualHosts;
    if Assigned(SrvApache) and (SrvApache.Running or SrvApache.CheckRunning) then
      SrvApache.ReloadService;
    if Assigned(SrvNginx) and (SrvNginx.Running or SrvNginx.CheckRunning) then
      SrvNginx.ReloadService;
    NotifyServicesChanged;
  end;
end;

procedure TFormPref.BtnDataDirClick(Sender: TObject);
var
  Dir: string;
begin
  if not Assigned(Nexagon) then Exit;
  Dir := Nexagon.DataDir;
  if SelectDirectory(Nexagon.T(507, 'Data Directory'), '', Dir) then
  begin
    if Pos(' ', Trim(Dir)) > 0 then
    begin
      MessageDlg('Path must not have SPACE!' + LineEnding + Dir, mtWarning, [mbOK], 0);
      Exit;
    end;
    ForceDirectories(Dir);
    EditDataDir.Text := Dir;
    Nexagon.DataDir := Dir;
    Nexagon.SyncMySqlConfig;
    if Assigned(SrvMySQL) and (SrvMySQL.Running or SrvMySQL.CheckRunning) then
      SrvMySQL.ReloadService;
    NotifyServicesChanged;
  end;
end;

procedure TFormPref.BtnTestMailClick(Sender: TObject);
begin
  if Assigned(FormMailAnalyzer) then
  begin
    FormMailAnalyzer.EditTo.Text := EditEmail.Text;
    FormMailAnalyzer.Show;
    FormMailAnalyzer.BringToFront;
    FormMailAnalyzer.RunMailAnalyzerTest;
  end;
end;

procedure TFormPref.CheckBoxRunAtStartupMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Reg: TRegistry;
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.RunAtStartup := not CheckBoxRunAtStartup.Checked;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) then
    begin
      if Nexagon.RunAtStartup then
        Reg.WriteString('Nexagon', '"' + ParamStr(0) + '"')
      else if Reg.ValueExists('Nexagon') then
        Reg.DeleteValue('Nexagon');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxMinimizeWhenRunClick(Sender: TObject);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.MinimizeWhenRun := CheckBoxMinimizeWhenRun.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxAutoStartClick(Sender: TObject);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.AutoStart := Ord(CheckBoxAutoStart.Checked);
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxAutoVirtualHostsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.AutoVirtualHosts := not CheckBoxAutoVirtualHosts.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxAutoBackupMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.AutoBackup := not CheckBoxAutoBackup.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxAutoUpdateMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.AutoUpdate := not CheckBoxAutoUpdate.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.EditHostnameFormatChange(Sender: TObject);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.HostnameFormat := Trim(EditHostnameFormat.Text);
  NotifyServicesChanged;
end;

procedure TFormPref.EditBackupIntervalChange(Sender: TObject);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.BackupInterval := StrToIntDef(EditBackupInterval.Text, 8);
  NotifyServicesChanged;
end;

procedure TFormPref.UpDownBackupIntervalChanging(Sender: TObject; var AllowChange: Boolean);
begin
  AllowChange := True;
end;

procedure TFormPref.CheckBoxMailCatcherEnabledClick(Sender: TObject);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.MailCatcherEnabled := CheckBoxMailCatcherEnabled.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.EditMailCatcherWindowDisplayTimeChange(Sender: TObject);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.MailCatcherDisplayTime := StrToIntDef(EditMailCatcherWindowDisplayTime.Text, 3);
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxMailSenderEnabledClick(Sender: TObject);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.MailSenderEnabled := CheckBoxMailSenderEnabled.Checked;
  Nexagon.SyncSendmailConfig;
  NotifyServicesChanged;
end;

procedure TFormPref.EditEmailChange(Sender: TObject);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.GmailAddress := Trim(EditEmail.Text);
  NotifyServicesChanged;
end;

procedure TFormPref.EditPasswordChange(Sender: TObject);
begin
  if FLoading or not Assigned(Nexagon) then Exit;
  Nexagon.GmailPassword := EditPassword.Text;
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxApacheClick(Sender: TObject);
begin
  if FLoading or not Assigned(SrvApache) then Exit;
  SrvApache.Enabled := CheckBoxApache.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxApacheSSLEnabledMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FLoading or not Assigned(SrvApache) then Exit;
  SrvApache.SslEnabled := not CheckBoxApacheSSLEnabled.Checked;
  LabelApacheSSLPort.Enabled := SrvApache.SslEnabled;
  EditApacheSSLPort.Enabled := SrvApache.SslEnabled;
  if Assigned(Nexagon) then
  begin
    if SrvApache.SslEnabled then
      Nexagon.EnsureSslCertificates;
    Nexagon.SyncApacheConfig;
    Nexagon.GenerateAutoVirtualHosts;
  end;
  NotifyServicesChanged;
end;

procedure TFormPref.EditApachePortChange(Sender: TObject);
begin
  if FLoading or not Assigned(SrvApache) then Exit;
  SrvApache.Port := StrToIntDef(EditApachePort.Text, 80);
  if Assigned(Nexagon) then
  begin
    Nexagon.SyncApacheConfig;
    Nexagon.GenerateAutoVirtualHosts;
  end;
  NotifyServicesChanged;
end;

procedure TFormPref.EditApacheSSLPortChange(Sender: TObject);
begin
  if FLoading or not Assigned(SrvApache) then Exit;
  SrvApache.SslPort := StrToIntDef(EditApacheSSLPort.Text, 443);
  if Assigned(Nexagon) then
  begin
    Nexagon.SyncApacheConfig;
    Nexagon.GenerateAutoVirtualHosts;
  end;
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxMySqlClick(Sender: TObject);
begin
  if FLoading or not Assigned(SrvMySQL) then Exit;
  SrvMySQL.Enabled := CheckBoxMySql.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.EditMySqlPortChange(Sender: TObject);
begin
  if FLoading or not Assigned(SrvMySQL) then Exit;
  SrvMySQL.Port := StrToIntDef(EditMySqlPort.Text, 3306);
  if Assigned(Nexagon) then
    Nexagon.SyncMySqlConfig;
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxPostgreSQLClick(Sender: TObject);
begin
  if FLoading or not Assigned(SrvPostgreSQL) then Exit;
  SrvPostgreSQL.Enabled := CheckBoxPostgreSQL.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.EditPostgreSQLPortChange(Sender: TObject);
begin
  if FLoading or not Assigned(SrvPostgreSQL) then Exit;
  SrvPostgreSQL.Port := StrToIntDef(EditPostgreSQLPort.Text, 5432);
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxNginxClick(Sender: TObject);
begin
  if FLoading or not Assigned(SrvNginx) then Exit;
  SrvNginx.Enabled := CheckBoxNginx.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxNginxSSLEnabledMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FLoading or not Assigned(SrvNginx) then Exit;
  SrvNginx.SslEnabled := not CheckBoxNginxSSLEnabled.Checked;
  LabelNginxSSLPort.Enabled := SrvNginx.SslEnabled;
  EditNginxSSLPort.Enabled := SrvNginx.SslEnabled;
  if Assigned(Nexagon) then
  begin
    if SrvNginx.SslEnabled then
      Nexagon.EnsureSslCertificates;
    Nexagon.SyncNginxConfig;
    Nexagon.GenerateAutoVirtualHosts;
  end;
  NotifyServicesChanged;
end;

procedure TFormPref.EditNginxPortChange(Sender: TObject);
begin
  if FLoading or not Assigned(SrvNginx) then Exit;
  SrvNginx.Port := StrToIntDef(EditNginxPort.Text, 8080);
  if Assigned(Nexagon) then
  begin
    Nexagon.SyncNginxConfig;
    Nexagon.GenerateAutoVirtualHosts;
  end;
  NotifyServicesChanged;
end;

procedure TFormPref.EditNginxSSLPortChange(Sender: TObject);
begin
  if FLoading or not Assigned(SrvNginx) then Exit;
  SrvNginx.SslPort := StrToIntDef(EditNginxSSLPort.Text, 8443);
  if Assigned(Nexagon) then
  begin
    Nexagon.SyncNginxConfig;
    Nexagon.GenerateAutoVirtualHosts;
  end;
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxMemcachedClick(Sender: TObject);
begin
  if FLoading or not Assigned(SrvMemcached) then Exit;
  SrvMemcached.Enabled := CheckBoxMemcached.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.EditMemcachedPortChange(Sender: TObject);
begin
  if FLoading or not Assigned(SrvMemcached) then Exit;
  SrvMemcached.Port := StrToIntDef(EditMemcachedPort.Text, 11211);
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxRedisClick(Sender: TObject);
begin
  if FLoading or not Assigned(SrvRedis) then Exit;
  SrvRedis.Enabled := CheckBoxRedis.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.EditRedisPortChange(Sender: TObject);
begin
  if FLoading or not Assigned(SrvRedis) then Exit;
  SrvRedis.Port := StrToIntDef(EditRedisPort.Text, 6379);
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxMongoDBClick(Sender: TObject);
begin
  if FLoading or not Assigned(SrvMongoDB) then Exit;
  SrvMongoDB.Enabled := CheckBoxMongoDB.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.EditMongoDBPortChange(Sender: TObject);
begin
  if FLoading or not Assigned(SrvMongoDB) then Exit;
  SrvMongoDB.Port := StrToIntDef(EditMongoDBPort.Text, 27017);
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxMailpitClick(Sender: TObject);
begin
  if FLoading or not Assigned(SrvMailpit) then Exit;
  SrvMailpit.Enabled := CheckBoxMailpit.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.EditMailpitPortChange(Sender: TObject);
begin
  if FLoading or not Assigned(SrvMailpit) then Exit;
  SrvMailpit.Port := StrToIntDef(EditMailpitPort.Text, 1025);
  NotifyServicesChanged;
end;

procedure TFormPref.CheckBoxPHPServerClick(Sender: TObject);
begin
  if FLoading or not Assigned(SrvPHP) then Exit;
  SrvPHP.Enabled := CheckBoxPHPServer.Checked;
  NotifyServicesChanged;
end;

procedure TFormPref.EditPHPServerPortChange(Sender: TObject);
begin
  if FLoading or not Assigned(SrvPHP) then Exit;
  SrvPHP.Port := StrToIntDef(EditPHPServerPort.Text, 8000);
  NotifyServicesChanged;
end;

procedure TFormPref.LabelBasicSettingsClick(Sender: TObject);
begin
  SwitchToPanel(PanelMailSender);
end;

procedure TFormPref.LabelMailAdvancedClick(Sender: TObject);
begin
  SwitchToPanel(PanelMailAdvanced);
end;

procedure TFormPref.LabelDocumentRootClick(Sender: TObject);
begin
  // Clicking label focuses or opens dir
end;

procedure TFormPref.PanelGeneralClick(Sender: TObject);
begin
  // No-op
end;

procedure TFormPref.PanelMailCatcherClick(Sender: TObject);
begin
  // No-op
end;

end.
