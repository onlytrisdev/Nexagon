unit FrmMain;

{$mode objfpc}{$H+}

interface

uses
  Windows, Winsock, ShellApi, Classes, SysUtils, DateUtils, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Menus, Clipbrd, StrUtils, InterfaceBase,
  Services, Procfile, Ngrok, maxCron,
  FrmPref, FrmQuickCreateWebsite, FMailAnalyzer, FrmPathVariables,
  FrmConsole, FrmVirtualHosts, FrmLicense;

type
  TMainForm = class(TForm)
  published
    ImageInfo: TImage;
    ImageInfo_Hover: TImage;
    LabelQuote: TLabel;
    LabelCreator: TLabel;
    LabelXipIO: TLabel;
    LabelDonate: TLabel;
    ImageAutoDetect: TImage;
    LabelStatus: TLabel;
    PanelRuntimeInfo: TPanel;
    LabelRuntimeInfo: TLabel;
    LabelServiceStatusTodo: TLabel;
    PanelSlogan: TPanel;
    LabelDonationNo: TLabel;
    LabelSloganDel: TLabel;
    LabelSlogan: TLabel;
    BtnCheckService: TButton;
    Button1: TButton;
    Button2: TButton;
    MemoResetMySQLOutput: TMemo;
    Button3: TButton;
    Button5: TButton;
    PanelCron: TPanel;
    pnlCronString: TGroupBox;
    labSample: TStaticText;
    edCronString: TEdit;
    StaticText1: TStaticText;
    btnReset: TBitBtn;
    StaticText2: TStaticText;
    edMinute: TEdit;
    StaticText3: TStaticText;
    edHour: TEdit;
    StaticText4: TStaticText;
    edDayOfMonth: TEdit;
    StaticText5: TStaticText;
    edMonthOfYear: TEdit;
    StaticText6: TStaticText;
    edDayOfTheWeek: TEdit;
    StaticText7: TStaticText;
    edYear: TEdit;
    StaticText9: TStaticText;
    edExecutionLimit: TEdit;
    StaticText11: TStaticText;
    edSecond: TEdit;
    StaticText10: TStaticText;
    btnSamples: TButton;
    Memo1: TMemo;
    pnlIntervalTest: TGroupBox;
    btnCalculate: TBitBtn;
    memCalculatedIntervals: TMemo;
    StaticText12: TStaticText;
    Panel2: TPanel;
    StaticText8: TStaticText;
    StaticText13: TStaticText;
    Button6: TButton;
    memLog: TMemo;
    Button7: TButton;
    BtnDebugTest: TButton;
    PanelBtns: TPanel;
    BtnStartAll: TBitBtn;
    btnWeb: TBitBtn;
    BtnDatabase: TBitBtn;
    BtnShell: TBitBtn;
    BtnDir: TBitBtn;
    BtnStopAll: TBitBtn;
    PanelTopBtns: TPanel;
    LabelGetLicenseLink: TLabel;
    LabelProfile: TLabel;
    LabelHostsFile: TLabel;
    LabelHelp: TLabel;
    ImagePref: TImage;
    ImagePref_Hover: TImage;
    BtnLicense: TSpeedButton;
    PanelNotification: TPanel;
    LabelNotification: TLabel;
    BtnNotificationOK: TButton;
    Button4: TButton;
    Button8: TButton;
    PanelTopLeft: TPanel;
    ImageNexagonSymbol: TImage;
    LabelMenu: TLabel;
    TimerLazyStart: TTimer;
    TimerMustRestart: TTimer;
    TimerForceClose: TTimer;
    TrayIcon: TTrayIcon;
    PopupMenuTray: TPopupMenu;
    MnuNexagon: TMenuItem;
    MnuWeb2: TMenuItem;
    MnuDatabase2: TMenuItem;
    MnuShell2: TMenuItem;
    MnuRoot2: TMenuItem;
    N38: TMenuItem;
    MnuNexagonDirProc: TMenuItem;
    MnuNexagonProcfile: TMenuItem;
    N28: TMenuItem;
    MenuNexagonDirUser: TMenuItem;
    MnuUserProfileCmd: TMenuItem;
    N30: TMenuItem;
    MnuNexagonIni: TMenuItem;
    N35: TMenuItem;
    MnuNexagonLog: TMenuItem;
    MnuWWW: TMenuItem;
    MnuWWWEmpty: TMenuItem;
    MnuShare: TMenuItem;
    MnuShareEmpty: TMenuItem;
    MnuQuickApp: TMenuItem;
    MnuSiteTemplate: TMenuItem;
    MnuQuickCloudServer: TMenuItem;
    PHP1: TMenuItem;
    Wordpress1: TMenuItem;
    Laravel1: TMenuItem;
    N46: TMenuItem;
    Python1: TMenuItem;
    Ruby1: TMenuItem;
    Nodejs1: TMenuItem;
    Go1: TMenuItem;
    Java1: TMenuItem;
    N45: TMenuItem;
    Docker1: TMenuItem;
    Kubernetes1: TMenuItem;
    N47: TMenuItem;
    MnuQuickCSCreate: TMenuItem;
    MnuQuickCSSSH: TMenuItem;
    MnuQuickCSRegion: TMenuItem;
    MnuQuickCSRegionAS: TMenuItem;
    MnuQuickCSRegionEU: TMenuItem;
    MnuQuickCSRegionUS: TMenuItem;
    MnuTools: TMenuItem;
    MnuSublimeText: TMenuItem;
    MnuNotepadPlusPlus: TMenuItem;
    N25: TMenuItem;
    MnuWinSCP: TMenuItem;
    MnuNetStat: TMenuItem;
    MnuSSL: TMenuItem;
    Generatecertsandaddtotruststore1: TMenuItem;
    N42: TMenuItem;
    opensslconftpl1: TMenuItem;
    MnuSepWinScp: TMenuItem;
    Mnuputty: TMenuItem;
    MnuPuTTYgen: TMenuItem;
    MnuSepPutty: TMenuItem;
    MnuRightClickMenu: TMenuItem;
    MnuAddSublimeTextTerminal: TMenuItem;
    MnuRemoveSublimeTextTerminal: TMenuItem;
    MnuPathVariables: TMenuItem;
    MnuAddNexagontoPath: TMenuItem;
    MnuRemoveNexagonfromPath: TMenuItem;
    N31: TMenuItem;
    MnuManagePath: TMenuItem;
    MnuEditHostsFile: TMenuItem;
    N21: TMenuItem;
    MnuTransferFiles: TMenuItem;
    N3: TMenuItem;
    MnuApache: TMenuItem;
    MnuStartApache: TMenuItem;
    MnuReloadApache: TMenuItem;
    MnuApacheVersion: TMenuItem;
    apache24102: TMenuItem;
    MnuRunApacheasWindowsService: TMenuItem;
    N6: TMenuItem;
    MnuApacheConfigFile: TMenuItem;
    MnuApacheVirtualHost: TMenuItem;
    MnuVirtualHostFile: TMenuItem;
    MnuApacheSSL: TMenuItem;
    MnuApacheSSLEnabled: TMenuItem;
    N27: TMenuItem;
    MnuApacheAddCertificatesToTrustStore: TMenuItem;
    MnuApacheCertificateManager: TMenuItem;
    N43: TMenuItem;
    MnuApacheHttpdSSLConf: TMenuItem;
    MnuApacheErrorLog: TMenuItem;
    MnuApacheAccessLog: TMenuItem;
    N15: TMenuItem;
    MnuApacheConfDir: TMenuItem;
    MnuApacheAlias: TMenuItem;
    MnuNginx: TMenuItem;
    MnuStartNginx: TMenuItem;
    MnuReloadNginx: TMenuItem;
    MnuNginxVersion: TMenuItem;
    N1961: TMenuItem;
    MnuRunNginxasWindowsService: TMenuItem;
    N5: TMenuItem;
    MnuNginxConf: TMenuItem;
    MnuNginxServer: TMenuItem;
    MnuNginxServerFile: TMenuItem;
    MnuNginxSSL: TMenuItem;
    MnuNginxSSLEnabled: TMenuItem;
    N44: TMenuItem;
    MnuNginxAddCertificatesToTrustStore: TMenuItem;
    MnuNginxCertificateManager: TMenuItem;
    N19: TMenuItem;
    MnuNginxErrorLog: TMenuItem;
    MnuNginxAccessLog: TMenuItem;
    N20: TMenuItem;
    MnuNginxConfDir: TMenuItem;
    MnuNginxAlias: TMenuItem;
    MnuJava: TMenuItem;
    MnuJavaVersion: TMenuItem;
    MnuJavaPlaceHolder: TMenuItem;
    N36: TMenuItem;
    MnuJavaSTS: TMenuItem;
    MnuJavaEclipse: TMenuItem;
    MnuMySQL: TMenuItem;
    MnuMySQLPHPMyAdmin6: TMenuItem;
    MnuMySQLphpMyAdmin: TMenuItem;
    MnuMySQLDBeaver: TMenuItem;
    MnuMySQLHeidiSQL: TMenuItem;
    N48: TMenuItem;
    MnuStartMySQL: TMenuItem;
    MnuMySQLVersion: TMenuItem;
    MnuMySQLDir: TMenuItem;
    MnuRunMySQLasWindowsService: TMenuItem;
    N7: TMenuItem;
    MnuMySQLCreateDatabase: TMenuItem;
    MnuMySQLChangeRootPassword: TMenuItem;
    MnuMySQLGetRootPassword: TMenuItem;
    MnuMySQLBackupAllDatabases: TMenuItem;
    N29: TMenuItem;
    MnuMySQLResetRootPassword: TMenuItem;
    N14: TMenuItem;
    MnuMySQLConfigFile: TMenuItem;
    MnuMySQLErrorLog: TMenuItem;
    MnuMySQLDataDir: TMenuItem;
    MnuMySQLBackupDir: TMenuItem;
    N16: TMenuItem;
    MnuPostgreSQL: TMenuItem;
    MnuPostgresqlDbeaver: TMenuItem;
    MnuPostgreSQLHeidiSQL: TMenuItem;
    MnuPostgreSQLPgAdmin4: TMenuItem;
    MnuPostgreSQLPgAdmin: TMenuItem;
    mnuStartPostgreSQL: TMenuItem;
    MnuPostgreSQLVersion: TMenuItem;
    MnuPostgreSQLDir: TMenuItem;
    MnuRunPostgreSQLasWindowsService: TMenuItem;
    N33: TMenuItem;
    postgresqlconf1: TMenuItem;
    postgresqllog1: TMenuItem;
    N34: TMenuItem;
    MnuPostgreSQLDataDir: TMenuItem;
    MnuMongoDB: TMenuItem;
    MnuRoboMongo: TMenuItem;
    MnuStartMongoDB: TMenuItem;
    MnuMongoDBVersion: TMenuItem;
    MnuMongoDBDir: TMenuItem;
    MnuRunMongoDBasWindowsService: TMenuItem;
    N32: TMenuItem;
    MnuMongoDBConfigFile: TMenuItem;
    MnuMongoDBLog: TMenuItem;
    N26: TMenuItem;
    MnuMongoDBDataDir: TMenuItem;
    Separator1: TMenuItem;
    MnuMailpit: TMenuItem;
    MnuStartMailpit: TMenuItem;
    Separator2: TMenuItem;
    MnuMailpitWebUI: TMenuItem;
    N18: TMenuItem;
    MnuGo: TMenuItem;
    MnuGoVersion: TMenuItem;
    N40: TMenuItem;
    N39: TMenuItem;
    MnuGoLiteIDE: TMenuItem;
    N41: TMenuItem;
    MnuGoGOPATH: TMenuItem;
    MnuGoGOROOT: TMenuItem;
    MnuNodeJS: TMenuItem;
    MnuNodeJsVersion: TMenuItem;
    MnuNodeJSDir: TMenuItem;
    MnuPHP: TMenuItem;
    MnuStartPHPServer: TMenuItem;
    MnuPHPVersion: TMenuItem;
    MnuPHPDir: TMenuItem;
    N9: TMenuItem;
    MnuPHPQuickSettings: TMenuItem;
    maxexecutiontime1: TMenuItem;
    xdebug1: TMenuItem;
    uploadmaxfilesize2G1: TMenuItem;
    memorylimit512M1: TMenuItem;
    MnuPHPExtensions: TMenuItem;
    MnuPHPExtensionFile: TMenuItem;
    MnuPHPConfigFile: TMenuItem;
    MnuPHPExtensionsDir: TMenuItem;
    N17: TMenuItem;
    MnuMailCatcher: TMenuItem;
    MnuMailCatcherEnable: TMenuItem;
    N12: TMenuItem;
    MnuViewemail: TMenuItem;
    MnuOpenmaildir: TMenuItem;
    N10: TMenuItem;
    MnuSendmailPathClipboard: TMenuItem;
    N23: TMenuItem;
    MnuMailCatcherConfiguration: TMenuItem;
    MnuMailSender: TMenuItem;
    MnuMailSenderEnable: TMenuItem;
    N13: TMenuItem;
    MnuMailSenderDebugLog: TMenuItem;
    MnuMailSenderErrorLog: TMenuItem;
    N24: TMenuItem;
    MnuMailSenderConfiguration: TMenuItem;
    N8: TMenuItem;
    MnuPHPErrorLog: TMenuItem;
    MnuPython: TMenuItem;
    MnuPythonVersion: TMenuItem;
    MnuPythonDir: TMenuItem;
    N37: TMenuItem;
    MnuPythonIDLE: TMenuItem;
    MnuPythonHelp: TMenuItem;
    MnuRuby: TMenuItem;
    MnuRubyVersion: TMenuItem;
    MnuRubySubDir: TMenuItem;
    MnuLaravel: TMenuItem;
    MnuLaravelCurrentProject: TMenuItem;
    MnuLaravelRouteFile: TMenuItem;
    MnuLaravelConfigDir: TMenuItem;
    MnuLaravelControllersDir: TMenuItem;
    MnuLaravelLogsDir: TMenuItem;
    MnuLaravelPublicDir: TMenuItem;
    N11: TMenuItem;
    MnuLaravelCreateProject: TMenuItem;
    MnuCreateLumen: TMenuItem;
    N22: TMenuItem;
    MnuCreateLaravel5: TMenuItem;
    N2: TMenuItem;
    MnuCreateLaravel4: TMenuItem;
    MnuLaravelSwitchProject: TMenuItem;
    MnuNoProject: TMenuItem;
    N1: TMenuItem;
    MnuMemcached: TMenuItem;
    MnuStartMemcached: TMenuItem;
    MnuMemcachedVersion: TMenuItem;
    MnuMemcachedDir: TMenuItem;
    MnuRunMemcachedasWindowsService: TMenuItem;
    N01: TMenuItem;
    MnuMemcachedAdmin: TMenuItem;
    MnuRedis: TMenuItem;
    MnuStartRedis: TMenuItem;
    MnuRedisVersion: TMenuItem;
    MnuRedisDir: TMenuItem;
    MnuRunRedisasWindowsService: TMenuItem;
    N02: TMenuItem;
    MnuRedisAdmin: TMenuItem;
    MnuRedisCli: TMenuItem;
    MnuRedisConfigFile: TMenuItem;
    MnuSep: TMenuItem;
    MnuStartAll: TMenuItem;
    N4: TMenuItem;
    MnuProfile: TMenuItem;
    default1: TMenuItem;
    PHP841: TMenuItem;
    MySQL941: TMenuItem;
    N49: TMenuItem;
    Addprofile1: TMenuItem;
    MnuPreferences: TMenuItem;
    MnuExit: TMenuItem;
    ImageListMenuTray: TImageList;
    TimerGenSSL: TTimer;
    TimerNetStat: TTimer;
    TimerStartPostgreSQL: TTimer;
    TimerMonitorNginxPHPUpstream: TTimer;
    TimerLazyLong: TTimer;
    popSamples: TPopupMenu;
    TimerLicenseKeyCheck: TTimer;
    TimerAutoBackup: TTimer;
    TimerValidateLicense: TTimer;
    ImageListServices24x24: TImageList;
    TimerAutoUpdate: TTimer;
    TimerAutoUpdateCurlCacert: TTimer;
    TimerMinimized: TTimer;

    // Published Event Handlers (215)
    procedure BtnCheckServiceClick(Sender: TObject);
    procedure BtnConfigClick(Sender: TObject);
    procedure BtnDatabaseClick(Sender: TObject);
    procedure BtnDebugTestClick(Sender: TObject);
    procedure BtnDirMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnLicenseMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnNotificationOKClick(Sender: TObject);
    procedure BtnShellClick(Sender: TObject);
    procedure BtnStartAllClick(Sender: TObject);
    procedure BtnStopAllClick(Sender: TObject);
    procedure BtnWebClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ImageInfoMouseEnter(Sender: TObject);
    procedure ImageInfo_HoverMouseLeave(Sender: TObject);
    procedure ImageNexagonSymbolClick(Sender: TObject);
    procedure ImageNexagonSymbolMouseEnter(Sender: TObject);
    procedure ImageNexagonSymbolMouseLeave(Sender: TObject);
    procedure ImagePrefMouseEnter(Sender: TObject);
    procedure ImagePref_HoverMouseLeave(Sender: TObject);
    procedure LabelCreatorClick(Sender: TObject);
    procedure LabelDonateClick(Sender: TObject);
    procedure LabelDonateMouseEnter(Sender: TObject);
    procedure LabelDonateMouseLeave(Sender: TObject);
    procedure LabelDonationNoClick(Sender: TObject);
    procedure LabelGetLicenseLinkClick(Sender: TObject);
    procedure LabelGetLicenseLinkMouseEnter(Sender: TObject);
    procedure LabelGetLicenseLinkMouseLeave(Sender: TObject);
    procedure LabelHelpClick(Sender: TObject);
    procedure LabelHelpMouseEnter(Sender: TObject);
    procedure LabelHelpMouseLeave(Sender: TObject);
    procedure LabelHostsFileClick(Sender: TObject);
    procedure LabelMenuClick(Sender: TObject);
    procedure LabelProfileClick(Sender: TObject);
    procedure LabelQuoteClick(Sender: TObject);
    procedure LabelSloganDelClick(Sender: TObject);
    procedure LabelXipIOClick(Sender: TObject);
    procedure MenuNexagonDirUserClick(Sender: TObject);
    procedure MnuAddNexagontoPathClick(Sender: TObject);
    procedure MnuAddSublimeTextTerminalClick(Sender: TObject);
    procedure MnuApacheAccessLogClick(Sender: TObject);
    procedure MnuApacheAddCertificatesToTrustStoreClick(Sender: TObject);
    procedure MnuApacheAliasClick(Sender: TObject);
    procedure MnuApacheCertificateManagerClick(Sender: TObject);
    procedure MnuApacheConfDirClick(Sender: TObject);
    procedure MnuApacheConfigFileClick(Sender: TObject);
    procedure MnuApacheErrorLogClick(Sender: TObject);
    procedure MnuApacheHttpdSSLConfClick(Sender: TObject);
    procedure MnuApacheSSLClick(Sender: TObject);
    procedure MnuApacheSSLEnabledClick(Sender: TObject);
    procedure MnuApacheVersionClick(Sender: TObject);
    procedure MnuApacheVirtualHostClick(Sender: TObject);
    procedure MnuCreateLaravel4Click(Sender: TObject);
    procedure MnuCreateLaravel5Click(Sender: TObject);
    procedure MnuCreateLumenClick(Sender: TObject);
    procedure MnuDatabase2Click(Sender: TObject);
    procedure MnuEditHostsFileClick(Sender: TObject);
    procedure MnuExitClick(Sender: TObject);
    procedure MnuGoGOPATHClick(Sender: TObject);
    procedure MnuGoGOROOTClick(Sender: TObject);
    procedure MnuGoLiteIDEClick(Sender: TObject);
    procedure MnuGoVersionClick(Sender: TObject);
    procedure MnuJavaClick(Sender: TObject);
    procedure MnuJavaEclipseClick(Sender: TObject);
    procedure MnuJavaSTSClick(Sender: TObject);
    procedure MnuJavaVersionClick(Sender: TObject);
    procedure MnuNexagonClick(Sender: TObject);
    procedure MnuNexagonIniClick(Sender: TObject);
    procedure MnuNexagonLogClick(Sender: TObject);
    procedure MnuLaravelClick(Sender: TObject);
    procedure MnuLaravelConfigDirClick(Sender: TObject);
    procedure MnuLaravelControllersDirClick(Sender: TObject);
    procedure MnuLaravelCurrentProjectClick(Sender: TObject);
    procedure MnuLaravelLogsDirClick(Sender: TObject);
    procedure MnuLaravelPublicDirClick(Sender: TObject);
    procedure MnuLaravelRouteFileClick(Sender: TObject);
    procedure MnuMailCatcherClick(Sender: TObject);
    procedure MnuMailCatcherConfigurationClick(Sender: TObject);
    procedure MnuMailCatcherEnableClick(Sender: TObject);
    procedure MnuMailSenderClick(Sender: TObject);
    procedure MnuMailSenderConfigurationClick(Sender: TObject);
    procedure MnuMailSenderDebugLogClick(Sender: TObject);
    procedure MnuMailSenderEnableClick(Sender: TObject);
    procedure MnuMailSenderErrorLogClick(Sender: TObject);
    procedure MnuMailpitWebUIClick(Sender: TObject);
    procedure MnuManagePathClick(Sender: TObject);
    procedure MnuMemcachedAdminClick(Sender: TObject);
    procedure MnuMemcachedVersionClick(Sender: TObject);
    procedure MnuMongoDBConfigFileClick(Sender: TObject);
    procedure MnuMongoDBDataDirClick(Sender: TObject);
    procedure MnuMongoDBLogClick(Sender: TObject);
    procedure MnuMongoDBVersionClick(Sender: TObject);
    procedure MnuMySQLBackupAllDatabasesClick(Sender: TObject);
    procedure MnuMySQLBackupDirClick(Sender: TObject);
    procedure MnuMySQLChangeRootPasswordClick(Sender: TObject);
    procedure MnuMySQLClick(Sender: TObject);
    procedure MnuMySQLConfigFileClick(Sender: TObject);
    procedure MnuMySQLCreateDatabaseClick(Sender: TObject);
    procedure MnuMySQLDBeaverClick(Sender: TObject);
    procedure MnuMySQLDataDirClick(Sender: TObject);
    procedure MnuMySQLErrorLogClick(Sender: TObject);
    procedure MnuMySQLGetRootPasswordClick(Sender: TObject);
    procedure MnuMySQLHeidiSQLClick(Sender: TObject);
    procedure MnuMySQLPHPMyAdmin6Click(Sender: TObject);
    procedure MnuMySQLResetRootPasswordClick(Sender: TObject);
    procedure MnuMySQLVersionClick(Sender: TObject);
    procedure MnuMySQLphpMyAdminClick(Sender: TObject);
    procedure MnuNetStatClick(Sender: TObject);
    procedure MnuNginxAccessLogClick(Sender: TObject);
    procedure MnuNginxAddCertificatesToTrustStoreClick(Sender: TObject);
    procedure MnuNginxAliasClick(Sender: TObject);
    procedure MnuNginxCertificateManagerClick(Sender: TObject);
    procedure MnuNginxConfClick(Sender: TObject);
    procedure MnuNginxConfDirClick(Sender: TObject);
    procedure MnuNginxErrorLogClick(Sender: TObject);
    procedure MnuNginxSSLClick(Sender: TObject);
    procedure MnuNginxSSLEnabledClick(Sender: TObject);
    procedure MnuNginxServerClick(Sender: TObject);
    procedure MnuNginxVersionClick(Sender: TObject);
    procedure MnuNodeJsVersionClick(Sender: TObject);
    procedure MnuNotepadPlusPlusClick(Sender: TObject);
    procedure MnuOpenmaildirClick(Sender: TObject);
    procedure MnuPHPConfigFileClick(Sender: TObject);
    procedure MnuPHPErrorLogClick(Sender: TObject);
    procedure MnuPHPExtensionsClick(Sender: TObject);
    procedure MnuPHPExtensionsDirClick(Sender: TObject);
    procedure MnuPHPQuickSettingsClick(Sender: TObject);
    procedure MnuPHPVersionClick(Sender: TObject);
    procedure MnuPostgreSQLDataDirClick(Sender: TObject);
    procedure MnuPostgreSQLPgAdmin4Click(Sender: TObject);
    procedure MnuPostgreSQLPgAdminClick(Sender: TObject);
    procedure MnuPostgreSQLVersionClick(Sender: TObject);
    procedure MnuPreferencesClick(Sender: TObject);
    procedure MnuProfileClick(Sender: TObject);
    procedure MnuPuTTYgenClick(Sender: TObject);
    procedure MnuPythonHelpClick(Sender: TObject);
    procedure MnuPythonIDLEClick(Sender: TObject);
    procedure MnuPythonVersionClick(Sender: TObject);
    procedure MnuQuickAppClick(Sender: TObject);
    procedure MnuQuickCSRegionASClick(Sender: TObject);
    procedure MnuQuickCSRegionEUClick(Sender: TObject);
    procedure MnuQuickCSRegionUSClick(Sender: TObject);
    procedure MnuQuickCSSSHClick(Sender: TObject);
    procedure MnuQuickCloudServerClick(Sender: TObject);
    procedure MnuRedisAdminClick(Sender: TObject);
    procedure MnuRedisCliClick(Sender: TObject);
    procedure MnuRedisConfigFileClick(Sender: TObject);
    procedure MnuRedisVersionClick(Sender: TObject);
    procedure MnuReloadApacheClick(Sender: TObject);
    procedure MnuReloadNginxClick(Sender: TObject);
    procedure MnuRemoveNexagonfromPathClick(Sender: TObject);
    procedure MnuRemoveSublimeTextTerminalClick(Sender: TObject);
    procedure MnuRoboMongoClick(Sender: TObject);
    procedure MnuRoot2Click(Sender: TObject);
    procedure MnuRubyVersionClick(Sender: TObject);
    procedure MnuRunApacheasWindowsServiceClick(Sender: TObject);
    procedure MnuSendmailPathClipboardClick(Sender: TObject);
    procedure MnuShareClick(Sender: TObject);
    procedure MnuShell2Click(Sender: TObject);
    procedure MnuStartAllClick(Sender: TObject);
    procedure MnuStartApacheClick(Sender: TObject);
    procedure MnuStartMailpitClick(Sender: TObject);
    procedure MnuStartMemcachedClick(Sender: TObject);
    procedure MnuStartMongoDBClick(Sender: TObject);
    procedure MnuStartMySQLClick(Sender: TObject);
    procedure MnuStartNginxClick(Sender: TObject);
    procedure MnuStartPHPServerClick(Sender: TObject);
    procedure MnuStartRedisClick(Sender: TObject);
    procedure MnuSublimeTextClick(Sender: TObject);
    procedure MnuToolsClick(Sender: TObject);
    procedure MnuUserProfileCmdClick(Sender: TObject);
    procedure MnuViewemailClick(Sender: TObject);
    procedure MnuWWWClick(Sender: TObject);
    procedure MnuWeb2Click(Sender: TObject);
    procedure MnuWinSCPClick(Sender: TObject);
    procedure MnuputtyClick(Sender: TObject);
    procedure PanelRuntimeInfoClick(Sender: TObject);
    procedure PopupMenuTrayPopup(Sender: TObject);
    procedure TimerAutoBackupTimer(Sender: TObject);
    procedure TimerAutoUpdateCurlCacertTimer(Sender: TObject);
    procedure TimerAutoUpdateTimer(Sender: TObject);
    procedure TimerForceCloseTimer(Sender: TObject);
    procedure TimerGenSSLTimer(Sender: TObject);
    procedure TimerLazyLongTimer(Sender: TObject);
    procedure TimerLazyStartTimer(Sender: TObject);
    procedure TimerLicenseKeyCheckTimer(Sender: TObject);
    procedure TimerMinimizedTimer(Sender: TObject);
    procedure TimerMonitorNginxPHPUpstreamTimer(Sender: TObject);
    procedure TimerMustRestartTimer(Sender: TObject);
    procedure TimerNetStatTimer(Sender: TObject);
    procedure TimerStartPostgreSQLTimer(Sender: TObject);
    procedure TimerValidateLicenseTimer(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure TrayIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TrayIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnCalculateClick(Sender: TObject);
    procedure btnSamplesClick(Sender: TObject);
    procedure edCronStringChange(Sender: TObject);
    procedure mnuStartPostgreSQLClick(Sender: TObject);
    procedure postgresqlconf1Click(Sender: TObject);
    procedure postgresqllog1Click(Sender: TObject);
  private
    FAllowExit: Boolean;
    FTrayPopupPt: TPoint;
    procedure DoTrayPopup(Data: PtrInt);
    procedure OnServicesConfigUpdated(Sender: TObject);
    procedure OnServicesStatusChanged(Sender: TObject);
    procedure PopulateVersionSubMenu(ParentItem: TMenuItem; Srv: TCommonService; OnSelectHandler: TNotifyEvent);
    procedure OnSelectServiceVersionClick(Sender: TObject);
    procedure OnOpenServiceVersionDirClick(Sender: TObject);
    procedure OnWwwProjectItemClick(Sender: TObject);
    procedure OnSwitchDocRootItemClick(Sender: TObject);
    procedure OnSelectDocRootFromListClick(Sender: TObject);
    procedure SwitchToDocumentRoot(const NewDir: string);
    procedure OnQuickAppItemClick(Sender: TObject);
    procedure OnQuickAddItemClick(Sender: TObject);
    procedure OnShareSiteItemClick(Sender: TObject);
    procedure OnDeleteProjectItemClick(Sender: TObject);
    procedure OnCloneProjectItemClick(Sender: TObject);
    procedure OnPhpExtensionItemClick(Sender: TObject);
    procedure OnPhpQuickSettingItemClick(Sender: TObject);
    procedure OnProfileItemClick(Sender: TObject);
    procedure OnAddProfileItemClick(Sender: TObject);
    procedure OnVHostFileItemClick(Sender: TObject);
  public
    procedure UpdateMainLayout;
    procedure ApplyLanguageStrings;
    procedure UpdateTooltips;
    procedure UpdateServiceAndMenuStates;
    procedure ShowNotificationBanner(const Msg: string; AutoHideMs: Integer = 4000);
    procedure OpenFileInNotepadPP(const FilePath: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

var
  CachedLocalIP: string = '';

procedure ForceForegroundForPopup(TargetWnd: HWND);
var
  FgWnd: HWND;
  FgThread, CurThread: DWORD;
  ExStyle: LONG_PTR;
  Msg: TMsg;
begin
  if TargetWnd = 0 then Exit;
  if not IsWindowVisible(TargetWnd) then
  begin
    ExStyle := GetWindowLongPtr(TargetWnd, GWL_EXSTYLE);
    SetWindowLongPtr(TargetWnd, GWL_EXSTYLE, (ExStyle or WS_EX_TOOLWINDOW) and (not WS_EX_APPWINDOW));
    SetWindowPos(TargetWnd, 0, -32000, -32000, 1, 1, SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOZORDER);
  end;
  FgWnd := GetForegroundWindow;
  if FgWnd <> TargetWnd then
  begin
    FgThread := GetWindowThreadProcessId(FgWnd, nil);
    CurThread := GetCurrentThreadId;
    if (FgThread <> 0) and (FgThread <> CurThread) then
    begin
      AttachThreadInput(FgThread, CurThread, True);
      try
        SetForegroundWindow(TargetWnd);
        SetFocus(TargetWnd);
      finally
        AttachThreadInput(FgThread, CurThread, False);
      end;
    end
    else
      SetForegroundWindow(TargetWnd);

    if GetForegroundWindow <> TargetWnd then
    begin
      keybd_event(0, 0, 0, 0);
      SetForegroundWindow(TargetWnd);
    end;
  end;
  while PeekMessage(Msg, TargetWnd, $B000, $BFFF, PM_REMOVE) do ;
end;

function GetLocalIPAddress: string;
var
  WSAData: TWSAData;
  HostName: array[0..255] of AnsiChar;
  HostEnt: PHostEnt;
  Addr: PInAddr;
begin
  if CachedLocalIP <> '' then
    Exit(CachedLocalIP);
  Result := '127.0.0.1';
  if WSAStartup($0202, WSAData) = 0 then
  try
    if gethostname(HostName, SizeOf(HostName)) = 0 then
    begin
      HostEnt := gethostbyname(HostName);
      if Assigned(HostEnt) and Assigned(HostEnt^.h_addr_list) and Assigned(HostEnt^.h_addr_list^) then
      begin
        Addr := PInAddr(HostEnt^.h_addr_list^);
        Result := string(inet_ntoa(Addr^));
      end;
    end;
  finally
    WSACleanup;
  end;
  CachedLocalIP := Result;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FAllowExit := False;
  GlobalImageListServices24x24 := ImageListServices24x24;
  GlobalImageListMenuTray := ImageListMenuTray;
  OnGlobalServicesUpdated := @OnServicesConfigUpdated;
  OnGlobalServiceStatusChanged := @OnServicesStatusChanged;

  InitAllServices(PanelRuntimeInfo);

  // Exact constraints from 0x10007f549 (LFM design size is 1024x620)
  Constraints.MinWidth := 1000;
  Constraints.MinHeight := 450;
  Color := clWhite;

  // Clear design-time placeholder captions (0x10007f300 & 0x10007e300)
  PanelTopLeft.Caption := '';
  LabelRuntimeInfo.Caption := '';
  LabelRuntimeInfo.Visible := False;
  LabelServiceStatusTodo.Visible := False;
  LabelSloganDel.Visible := False;
  LabelDonationNo.Visible := False;

  // Hide debug/internal design controls
  MemoResetMySQLOutput.Visible := False;
  PanelCron.Visible := False;
  BtnCheckService.Visible := False;
  Button1.Visible := False;
  Button2.Visible := False;
  Button3.Visible := False;
  Button4.Visible := False;
  Button5.Visible := False;
  Button6.Visible := False;
  Button7.Visible := False;
  Button8.Visible := False;
  BtnDebugTest.Visible := False;
  ImageInfo.Visible := False;
  ImageInfo_Hover.Visible := False;
  ImagePref_Hover.Visible := False;
  PanelNotification.Visible := False;
  BtnStopAll.Visible := False;
  LabelQuote.Visible := False;
  LabelCreator.Visible := False;
  LabelXipIO.Visible := False;
  LabelDonate.Visible := False;
  ImageAutoDetect.Visible := False;
  LabelStatus.Visible := False;

  // Open Source Edition: remove commercial trial nag
  LabelGetLicenseLink.Visible := False;
  BtnLicense.Visible := False;
  TimerLicenseKeyCheck.Enabled := False;
  TimerValidateLicense.Enabled := False;
  TimerNetStat.Interval := 2000;

  // Bind PHP quick settings clicks
  maxexecutiontime1.OnClick := @OnPhpQuickSettingItemClick;
  xdebug1.OnClick := @OnPhpQuickSettingItemClick;
  uploadmaxfilesize2G1.OnClick := @OnPhpQuickSettingItemClick;
  memorylimit512M1.OnClick := @OnPhpQuickSettingItemClick;
  Generatecertsandaddtotruststore1.OnClick := @MnuApacheAddCertificatesToTrustStoreClick;
  opensslconftpl1.OnClick := @MnuApacheHttpdSSLConfClick;
  MnuNexagonProcfile.OnClick := @MnuUserProfileCmdClick;
  MnuNexagonDirProc.Caption := 'Show Nexagon';
  MnuNexagonDirProc.OnClick := @TrayIconClick;

  // CRITICAL LCL Win32 Fix:
  // In LCL Win32 (win32callback.inc line 2118), hovering over any submenu parent sends
  // WM_INITMENUPOPUP -> LM_ACTIVATE -> TMenuItem.Click (OnClick).
  // 1) MnuNexagon.OnClick called TrayIconClick -> BringToFront, which stole focus from
  //    WidgetSet.AppHandle and immediately closed PopupMenuTray on hover!
  // 2) Other submenu OnClick handlers called .Clear, which called DestroyMenu(HMENU)
  //    while TrackPopupMenuEx was opening the submenu!
  // All dynamic submenus are already populated upfront in PopupMenuTrayPopup.
  MnuNexagon.OnClick := nil;
  MnuWWW.OnClick := nil;
  MnuShare.OnClick := nil;
  MnuQuickApp.OnClick := nil;
  MnuQuickCloudServer.OnClick := nil;
  MnuTools.OnClick := nil;
  MnuApacheVersion.OnClick := nil;
  MnuApacheVirtualHost.OnClick := nil;
  MnuApacheSSL.OnClick := nil;
  MnuNginxVersion.OnClick := nil;
  MnuNginxServer.OnClick := nil;
  MnuNginxSSL.OnClick := nil;
  MnuJava.OnClick := nil;
  MnuJavaVersion.OnClick := nil;
  MnuMySQL.OnClick := nil;
  MnuMySQLVersion.OnClick := nil;
  MnuPostgreSQLVersion.OnClick := nil;
  MnuMongoDBVersion.OnClick := nil;
  MnuGoVersion.OnClick := nil;
  MnuNodeJsVersion.OnClick := nil;
  MnuPHPVersion.OnClick := nil;
  MnuPHPQuickSettings.OnClick := nil;
  MnuPHPExtensions.OnClick := nil;
  MnuMailCatcher.OnClick := nil;
  MnuMailSender.OnClick := nil;
  MnuPythonVersion.OnClick := nil;
  MnuRubyVersion.OnClick := nil;
  MnuLaravel.OnClick := nil;
  MnuMemcachedVersion.OnClick := nil;
  MnuRedisVersion.OnClick := nil;
  MnuProfile.OnClick := nil;

  ImageNexagonSymbol.ShowHint := True;
  ImageNexagonSymbol.Hint :=
    'Nexagon - Modern Local Development Stack' + LineEnding +
    'Fast, isolated, and portable web development environment for Windows.';

  TrayIcon.PopUpMenu := nil;
  TrayIcon.OnMouseUp := @TrayIconMouseUp;
  TrayIcon.Hint := 'Nexagon';
  TrayIcon.Visible := True;

  ApplyLanguageStrings;
  UpdateTooltips;
  UpdateMainLayout;
  UpdateServiceAndMenuStates;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  UpdateMainLayout;
  UpdateServiceAndMenuStates;
  if Assigned(Nexagon) then
  begin
    if Nexagon.MinimizeWhenRun then
      TimerMinimized.Enabled := True;
    if (Nexagon.AutoStart > 0) or SameText(ParamStr(1), '--start-all') then
      TimerLazyStart.Enabled := True;
  end;
  TimerNetStat.Enabled := True;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  RefreshAllServicesUI(False);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  UpdateMainLayout;
end;

procedure TMainForm.FormWindowStateChange(Sender: TObject);
begin
  if WindowState = wsMinimized then
    Hide;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not FAllowExit then
  begin
    CanClose := False;
    Hide;
  end
  else
    CanClose := True;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if not FAllowExit then
  begin
    CloseAction := caNone;
    Hide;
  end
  else
  begin
    StopAllRunningServices;
    if Assigned(Nexagon) then Nexagon.SaveConfig;
    CloseAction := caFree;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  TrayIcon.Visible := False;
  FreeAllServices;
end;

procedure TMainForm.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

procedure TMainForm.OnServicesConfigUpdated(Sender: TObject);
begin
  ApplyLanguageStrings;
  UpdateTooltips;
  UpdateMainLayout;
  UpdateServiceAndMenuStates;
end;

procedure TMainForm.OnServicesStatusChanged(Sender: TObject);
begin
  UpdateServiceAndMenuStates;
end;

procedure TMainForm.UpdateMainLayout;
var
  ColW, Gap, CurLeft, I: Integer;
  Btn: TBitBtn;
  Btns: array[0..4] of TBitBtn;
begin
  // Top-left panel (Nexagon logo + Menu link) - 0x10007ea80
  PanelTopLeft.Caption := '';
  PanelTopLeft.Color := clWhite;
  PanelTopLeft.BevelOuter := bvNone;
  PanelTopLeft.Left := 10;
  PanelTopLeft.Top := 0;
  ImageNexagonSymbol.Cursor := crHandPoint;
  LabelMenu.Cursor := crHandPoint;
  LabelMenu.Font.Size := 10;
  LabelMenu.Font.Color := $00220225;
  LabelMenu.Left := ImageNexagonSymbol.Left + ImageNexagonSymbol.Width + 10;
  LabelMenu.Top := 6;

  // Top-right buttons panel ([profile], h, ?, gear icon) - 0x10007e060 & 0x100050850
  PanelTopBtns.Color := clWhite;
  PanelTopBtns.BevelOuter := bvNone;
  PanelTopBtns.Top := 0;
  PanelTopBtns.Left := Width - PanelTopBtns.Width - 10;

  ImagePref.Top := 4;
  ImagePref.Left := PanelTopBtns.Width - ImagePref.Width;
  ImagePref.Cursor := crHandPoint;
  ImagePref.ShowHint := True;

  ImagePref_Hover.Top := ImagePref.Top;
  ImagePref_Hover.Left := ImagePref.Left;
  ImagePref_Hover.Cursor := crHandPoint;
  ImagePref_Hover.ShowHint := True;

  LabelHelp.Font.Size := 12;
  LabelHelp.Font.Color := $00220225;
  LabelHelp.Top := ImagePref.Top;
  LabelHelp.Left := ImagePref.Left - ImagePref.Width - 1;
  LabelHelp.Cursor := crHandPoint;
  LabelHelp.ShowHint := True;

  LabelHostsFile.Font.Size := 12;
  LabelHostsFile.Font.Color := $00220225;
  LabelHostsFile.Top := ImagePref.Top;
  LabelHostsFile.Left := LabelHelp.Left - LabelHelp.Width - 15;
  LabelHostsFile.Cursor := crHandPoint;
  LabelHostsFile.ShowHint := True;

  if Assigned(Nexagon) then
    LabelProfile.Caption := '[' + Nexagon.Profile + ']';
  LabelProfile.Font.Size := 8;
  LabelProfile.Font.Color := $00220225;
  LabelProfile.Top := LabelHostsFile.Top + (LabelHostsFile.Height div 4);
  LabelProfile.Left := LabelHostsFile.Left - LabelProfile.Width - 20;
  LabelProfile.Cursor := crHandPoint;
  LabelProfile.ShowHint := True;

  // Center Runtime Info Panel - 0x10007e5d0
  PanelRuntimeInfo.Color := clWhite;
  PanelRuntimeInfo.BevelOuter := bvNone;
  PanelRuntimeInfo.Left := 100;
  PanelRuntimeInfo.Top := 50;
  PanelRuntimeInfo.Width := 700;
  PanelRuntimeInfo.Height := Height - 140;
  LabelRuntimeInfo.Caption := '';
  LabelRuntimeInfo.Visible := False;
  LayoutRuntimeServices(PanelRuntimeInfo);

  // Notification banner - 0x10007e360
  PanelNotification.Width := PanelRuntimeInfo.Width;
  PanelNotification.Top := PanelRuntimeInfo.Top - PanelNotification.Height + 20;
  PanelNotification.Left := (Width - PanelNotification.Width) div 2;
  PanelNotification.Color := $00FFFCE6;
  BtnNotificationOK.Left := PanelNotification.Width - BtnNotificationOK.Width - 8;

  // Bottom 5-column Buttons Panel - 0x10007ea80 & 0x10007fc70
  PanelBtns.BorderStyle := bsNone;
  PanelBtns.BevelOuter := bvNone;
  PanelBtns.Color := clWhite;

  BtnStartAll.Font.Size := 10;
  btnWeb.Font.Size := BtnStartAll.Font.Size;
  BtnDatabase.Font.Size := BtnStartAll.Font.Size;
  BtnShell.Font.Size := BtnStartAll.Font.Size;
  BtnDir.Font.Size := BtnStartAll.Font.Size;
  BtnStopAll.Font.Size := BtnStartAll.Font.Size;

  PanelBtns.Width := Width - 100;
  PanelBtns.Height := Abs(BtnStartAll.Font.Height) + 30 - 17;
  PanelBtns.Top := Height - PanelBtns.Height - 34;

  ColW := PanelBtns.ClientWidth div 5;
  Gap := (PanelBtns.Width - ColW * 5) div 6;
  CurLeft := Gap + 5;

  Btns[0] := BtnStartAll;
  Btns[1] := btnWeb;
  Btns[2] := BtnDatabase;
  Btns[3] := BtnShell;
  Btns[4] := BtnDir;

  for I := 0 to 4 do
  begin
    Btn := Btns[I];
    Btn.SetBounds(CurLeft, 0, ColW - 5, PanelBtns.ClientHeight);
    Btn.Top := (PanelBtns.Height - Btn.Height) div 2;
    CurLeft := CurLeft + ColW + Gap;
  end;

  BtnStopAll.SetBounds(BtnStartAll.Left, BtnStartAll.Top, BtnStartAll.Width, BtnStartAll.Height);
  PanelBtns.Left := (Width - PanelBtns.Width) div 2;

  // Slogan Panel above PanelBtns - 0x10007f300 & 0x10007ea80
  PanelSlogan.BevelOuter := bvNone;
  PanelSlogan.Color := clWhite;
  PanelSlogan.Left := PanelBtns.Left + BtnStartAll.Left - 2;
  PanelSlogan.Top := PanelBtns.Top - PanelSlogan.Height - 10;
  LabelSlogan.Left := 8;
  LabelSlogan.Top := 0;
  LabelSlogan.Font.Color := clWindowText;
  LabelSlogan.ShowHint := True;
  LabelSlogan.Caption := 'Nexagon - Modern Local Development Stack';
  LabelSlogan.Hint := LabelSlogan.Caption;
end;

procedure TMainForm.ApplyLanguageStrings;
begin
  if not Assigned(Nexagon) then Exit;
  LabelMenu.Caption := Nexagon.T(121, 'Menu');
  BtnStartAll.Caption := Nexagon.T(100, 'Start All');
  BtnStopAll.Caption := Nexagon.T(105, 'Stop');
  btnWeb.Caption := Nexagon.T(101, 'Web');
  BtnDatabase.Caption := Nexagon.T(102, 'Database');
  BtnShell.Caption := Nexagon.T(103, 'Terminal');
  BtnDir.Caption := Nexagon.T(104, 'Root');

  ImagePref.Hint := Nexagon.T(216, 'Preferences');
  ImagePref_Hover.Hint := ImagePref.Hint;
  LabelHelp.Hint := Nexagon.T(500, 'Online Guide');
  LabelHostsFile.Hint := 'C:\Windows\System32\drivers\etc\hosts';
  LabelProfile.Hint := Nexagon.T(929, 'Current Profile') + ': ' + Nexagon.Profile;
  TrayIcon.Hint := 'Nexagon' + LineEnding + StringReplace(Nexagon.T(501, 'Left-click: Nexagon - Right-click: Menu'), 'Nexagon', 'Nexagon', [rfReplaceAll, rfIgnoreCase]);

  MnuWWW.Caption := Nexagon.T(199, 'www');
  MnuQuickApp.Caption := Nexagon.T(203, 'Quick app');
  MnuTools.Caption := Nexagon.T(200, 'Tools');
  MnuPathVariables.Caption := Nexagon.T(201, 'Environment Variables');
  MnuTransferFiles.Caption := Nexagon.T(202, 'Transfer Files');
  MnuRightClickMenu.Caption := Nexagon.T(830, 'Context Menu');
  MnuAddSublimeTextTerminal.Caption := Nexagon.T(831, 'Add Sublime Text && Terminal');
  MnuRemoveSublimeTextTerminal.Caption := Nexagon.T(832, 'Remove Sublime Text && Terminal');
  MnuProfile.Caption := Nexagon.T(928, 'Profile');
  MnuPreferences.Caption := Nexagon.T(216, 'Preferences') + '...';
  MnuExit.Caption := Nexagon.T(217, 'Exit');
end;

procedure TMainForm.UpdateTooltips;
var
  PortSuffix: string;
begin
  if not Assigned(Nexagon) then Exit;
  PortSuffix := '';
  if Assigned(SrvApache) and SrvApache.Enabled and (SrvApache.Port <> 80) then
    PortSuffix := ':' + IntToStr(SrvApache.Port);

  btnWeb.ShowHint := True;
  btnWeb.Hint := Nexagon.T(502, 'Start page') + ' - http://localhost' + PortSuffix;

  BtnDatabase.ShowHint := True;
  BtnDatabase.Hint := Nexagon.T(503, 'Database Management') + LineEnding + 'HeidiSQL / phpMyAdmin / DBeaver';

  BtnShell.ShowHint := True;
  BtnShell.Hint := Nexagon.T(504, 'Open Terminal (Cmder)');

  BtnDir.ShowHint := True;
  BtnDir.Hint :=
    Nexagon.T(246, 'Left click') + ': ' + Nexagon.T(506, 'Document Root') + ' - ' + Nexagon.DocumentRoot + LineEnding +
    Nexagon.T(247, 'Right click') + ': ' + StringReplace(Nexagon.T(248, 'Nexagon Root'), 'Nexagon', 'Nexagon', [rfReplaceAll, rfIgnoreCase]) + ' - ' + Nexagon.RootDir + LineEnding +
    Nexagon.T(928, 'Profile') + ': ' + Nexagon.Profile;
end;

procedure TMainForm.UpdateServiceAndMenuStates;
var
  AnyRun: Boolean;
  TitleStr, PhpTsFlag: string;
begin
  RefreshAllServicesUI(False);
  AnyRun := AnyPrimaryServiceRunning;

  BtnStopAll.Visible := AnyRun;
  BtnStopAll.Enabled := AnyRun;
  if AnyRun then
    BtnStopAll.BringToFront;

  if Assigned(Nexagon) then
  begin
    // Exact titlebar string format
    TitleStr := 'Nexagon 2026 v8.6.1 261015 [' + Nexagon.Profile + '] ';
    if Assigned(SrvPHP) and (SrvPHP.CurrentVersion <> '') and DirectoryExists(SrvPHP.GetVersionDir) then
    begin
      if (Pos('-nts', LowerCase(SrvPHP.CurrentVersion)) > 0) or
         (not FileExists(IncludeTrailingPathDelimiter(SrvPHP.GetVersionDir) + 'php8ts.dll') and
          not FileExists(IncludeTrailingPathDelimiter(SrvPHP.GetVersionDir) + 'php7ts.dll')) then
        PhpTsFlag := ' [NTS]'
      else
        PhpTsFlag := ' [TS]';
      TitleStr := TitleStr + 'php-' + SrvPHP.GetShortVersion + PhpTsFlag + '  ' + GetLocalIPAddress;
    end;
    TitleStr := TitleStr + ' ' + ExcludeTrailingPathDelimiter(Nexagon.RootDir);
    Caption := TitleStr;

    if AnyRun then
    begin
      MnuStartAll.Caption := Nexagon.T(111, 'Stop All');
      MnuStartAll.ImageIndex := 0;
    end
    else
    begin
      MnuStartAll.Caption := Nexagon.T(100, 'Start All');
      MnuStartAll.ImageIndex := 1;
    end;

    // Update menu item visibility based on enabled services (FUN_100061fc0)
    if Assigned(SrvApache) then
    begin
      MnuApache.Visible := SrvApache.Enabled or SrvApache.Running;
      MnuApacheSSLEnabled.Checked := SrvApache.SslEnabled;
      MnuReloadApache.Enabled := SrvApache.Running;
      if SrvApache.Running then
      begin
        MnuStartApache.Caption := Nexagon.T(105, 'Stop') + ' Apache';
        MnuStartApache.ImageIndex := 0;
      end
      else
      begin
        MnuStartApache.Caption := 'Start Apache';
        MnuStartApache.ImageIndex := 1;
      end;
    end;

    if Assigned(SrvNginx) then
    begin
      MnuNginx.Visible := SrvNginx.Enabled or SrvNginx.Running;
      MnuNginxSSLEnabled.Checked := SrvNginx.SslEnabled;
      MnuReloadNginx.Enabled := SrvNginx.Running;
      if SrvNginx.Running then
      begin
        MnuStartNginx.Caption := Nexagon.T(105, 'Stop') + ' Nginx';
        MnuStartNginx.ImageIndex := 0;
      end
      else
      begin
        MnuStartNginx.Caption := 'Start Nginx';
        MnuStartNginx.ImageIndex := 1;
      end;
    end;

    if Assigned(SrvMySQL) then
    begin
      MnuMySQL.Visible := SrvMySQL.Enabled or SrvMySQL.Running;
      if SrvMySQL.Running then
      begin
        MnuStartMySQL.Caption := Nexagon.T(105, 'Stop') + ' MySQL';
        MnuStartMySQL.ImageIndex := 0;
      end
      else
      begin
        MnuStartMySQL.Caption := 'Start MySQL';
        MnuStartMySQL.ImageIndex := 1;
      end;
    end;

    if Assigned(SrvPostgreSQL) then
    begin
      MnuPostgreSQL.Visible := SrvPostgreSQL.Enabled or SrvPostgreSQL.Running;
      if SrvPostgreSQL.Running then
      begin
        mnuStartPostgreSQL.Caption := Nexagon.T(105, 'Stop') + ' PostgreSQL';
        mnuStartPostgreSQL.ImageIndex := 0;
      end
      else
      begin
        mnuStartPostgreSQL.Caption := 'Start PostgreSQL';
        mnuStartPostgreSQL.ImageIndex := 1;
      end;
    end;

    if Assigned(SrvMongoDB) then
    begin
      MnuMongoDB.Visible := SrvMongoDB.Enabled or SrvMongoDB.Running;
      if SrvMongoDB.Running then
      begin
        MnuStartMongoDB.Caption := Nexagon.T(105, 'Stop') + ' MongoDB';
        MnuStartMongoDB.ImageIndex := 0;
      end
      else
      begin
        MnuStartMongoDB.Caption := 'Start MongoDB';
        MnuStartMongoDB.ImageIndex := 1;
      end;
    end;

    if Assigned(SrvMemcached) then
    begin
      MnuMemcached.Visible := SrvMemcached.Enabled or SrvMemcached.Running;
      if SrvMemcached.Running then
      begin
        MnuStartMemcached.Caption := Nexagon.T(105, 'Stop') + ' Memcached';
        MnuStartMemcached.ImageIndex := 0;
      end
      else
      begin
        MnuStartMemcached.Caption := 'Start Memcached';
        MnuStartMemcached.ImageIndex := 1;
      end;
    end;

    if Assigned(SrvRedis) then
    begin
      MnuRedis.Visible := SrvRedis.Enabled or SrvRedis.Running;
      if SrvRedis.Running then
      begin
        MnuStartRedis.Caption := Nexagon.T(105, 'Stop') + ' Redis';
        MnuStartRedis.ImageIndex := 0;
      end
      else
      begin
        MnuStartRedis.Caption := 'Start Redis';
        MnuStartRedis.ImageIndex := 1;
      end;
    end;

    if Assigned(SrvMailpit) then
    begin
      MnuMailpit.Visible := SrvMailpit.Enabled or SrvMailpit.Running;
      if SrvMailpit.Running then
      begin
        MnuStartMailpit.Caption := Nexagon.T(105, 'Stop') + ' Mailpit';
        MnuStartMailpit.ImageIndex := 0;
      end
      else
      begin
        MnuStartMailpit.Caption := 'Start Mailpit';
        MnuStartMailpit.ImageIndex := 1;
      end;
    end;

    MnuLaravel.Visible := False;
    MnuQuickCloudServer.Visible := False;
    MnuJava.Visible := Assigned(SrvJava) and (SrvJava.CurrentVersion <> '');
    MnuPython.Visible := Assigned(SrvPython) and (SrvPython.CurrentVersion <> '');
    MnuRuby.Visible := Assigned(SrvRuby) and (SrvRuby.CurrentVersion <> '');
    MnuGo.Visible := Assigned(SrvGo) and (SrvGo.CurrentVersion <> '');

    MnuMailCatcherEnable.Checked := Nexagon.MailCatcherEnabled;
    MnuMailSenderEnable.Checked := Nexagon.MailSenderEnabled;
  end;
end;

procedure TMainForm.ShowNotificationBanner(const Msg: string; AutoHideMs: Integer);
begin
  LabelNotification.Caption := Msg;
  PanelNotification.Visible := True;
  PanelNotification.BringToFront;
  if AutoHideMs > 0 then
  begin
    TimerLazyLong.Interval := AutoHideMs;
    TimerLazyLong.Enabled := True;
  end;
end;

procedure TMainForm.OpenFileInNotepadPP(const FilePath: string);
var
  NppExe: string;
begin
  if FilePath = '' then Exit;
  if not FileExists(FilePath) then
  begin
    ForceDirectories(ExtractFilePath(FilePath));
    with TStringList.Create do
    try
      SaveToFile(FilePath);
    finally
      Free;
    end;
  end;
  if Assigned(Nexagon) then
  begin
    NppExe := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\notepad++\notepad++.exe';
    if FileExists(NppExe) then
    begin
      OpenUrlOrFile(NppExe, '"' + FilePath + '"');
      Exit;
    end;
  end;
  OpenUrlOrFile('notepad.exe', '"' + FilePath + '"');
end;

{ Bottom Action Buttons }

procedure TMainForm.BtnStartAllClick(Sender: TObject);
var
  ProcfilePath: string;
  PathDirs: TStringList;
begin
  BtnStartAll.Enabled := False;
  try
    StartAllEnabledServices;
    if Assigned(Nexagon) then
    begin
      ProcfilePath := Nexagon.GetUsrDir + '\Procfile';
      if FileExists(ProcfilePath) then
      begin
        PathDirs := TStringList.Create;
        try
          RunProcfileEntries(ProcfilePath, Nexagon.DocumentRoot, Nexagon.BuildNexagonPathList(PathDirs));
        finally
          PathDirs.Free;
        end;
      end;
    end;
  finally
    BtnStartAll.Enabled := True;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.BtnStopAllClick(Sender: TObject);
begin
  BtnStopAll.Enabled := False;
  try
    StopAllRunningServices;
  finally
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.BtnWebClick(Sender: TObject);
var
  Port: Integer;
  SrvName: string;
begin
  // Exact implementation of 0x100060760..0x100060898
  if not ((Assigned(SrvApache) and SrvApache.CheckRunning) or
          (Assigned(SrvNginx) and SrvNginx.CheckRunning)) then
  begin
    SrvName := 'Apache';
    if Assigned(SrvNginx) and SrvNginx.IsActiveAndInstalled and
       not (Assigned(SrvApache) and SrvApache.IsActiveAndInstalled) then
      SrvName := SrvNginx.DisplayName
    else if Assigned(SrvApache) then
      SrvName := SrvApache.DisplayName;
    if Assigned(Nexagon) then
      MessageDlg('Nexagon', Format(Nexagon.T(702, 'Please start %s first!'), [SrvName]), mtInformation, [mbOK], 0)
    else
      MessageDlg('Nexagon', Format('Please start %s first!', [SrvName]), mtInformation, [mbOK], 0);
    Exit;
  end;

  Port := 80;
  if Assigned(SrvApache) and SrvApache.Running then
    Port := SrvApache.Port
  else if Assigned(SrvNginx) and SrvNginx.Running then
    Port := SrvNginx.Port;
  if Port = 80 then
    OpenUrlOrFile('http://localhost/')
  else
    OpenUrlOrFile('http://localhost:' + IntToStr(Port) + '/');
end;

procedure TMainForm.BtnDatabaseClick(Sender: TObject);
var
  HeidiExe, DBeaverExe, PmaDir: string;
begin
  if not Assigned(Nexagon) then Exit;
  HeidiExe := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\heidisql\heidisql.exe';
  DBeaverExe := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\dbeaver\dbeaver.exe';
  PmaDir := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'etc\apps\phpMyAdmin';
  if FileExists(HeidiExe) then
    OpenUrlOrFile(HeidiExe)
  else if FileExists(DBeaverExe) then
    OpenUrlOrFile(DBeaverExe)
  else if DirectoryExists(PmaDir) then
    OpenUrlOrFile('http://localhost/phpmyadmin')
  else
    ShowNotificationBanner('No database client found in bin\heidisql or etc\apps\phpMyAdmin');
end;

procedure TMainForm.BtnShellClick(Sender: TObject);
begin
  if Assigned(SrvCmder) then
    SrvCmder.OpenTerminal;
end;

procedure TMainForm.BtnDirMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not Assigned(Nexagon) then Exit;
  if Button = mbRight then
    OpenUrlOrFile('explorer.exe', '"' + Nexagon.RootDir + '"')
  else
    OpenUrlOrFile('explorer.exe', '"' + Nexagon.DocumentRoot + '"');
end;

{ Top Panel & Hover Handlers }

procedure TMainForm.BtnConfigClick(Sender: TObject);
begin
  if Assigned(FormPref) then
  begin
    FormPref.Show;
    FormPref.BringToFront;
  end;
end;

procedure TMainForm.ImagePrefMouseEnter(Sender: TObject);
begin
  ImagePref.Visible := False;
  ImagePref_Hover.Visible := True;
end;

procedure TMainForm.ImagePref_HoverMouseLeave(Sender: TObject);
begin
  ImagePref_Hover.Visible := False;
  ImagePref.Visible := True;
end;

procedure TMainForm.ImageInfoMouseEnter(Sender: TObject);
begin
  ImageInfo_Hover.Visible := True;
end;

procedure TMainForm.ImageInfo_HoverMouseLeave(Sender: TObject);
begin
  ImageInfo_Hover.Visible := False;
end;

procedure TMainForm.ImageNexagonSymbolClick(Sender: TObject);
begin
  LabelMenuClick(Sender);
end;

procedure TMainForm.ImageNexagonSymbolMouseEnter(Sender: TObject);
begin
  LabelMenu.Font.Style := [fsUnderline];
end;

procedure TMainForm.ImageNexagonSymbolMouseLeave(Sender: TObject);
begin
  LabelMenu.Font.Style := [];
end;

procedure TMainForm.LabelMenuClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt := LabelMenu.ClientToScreen(Point(0, LabelMenu.Height + 2));
  PopupMenuTray.PopUp(Pt.X, Pt.Y);
end;

procedure TMainForm.LabelProfileClick(Sender: TObject);
begin
  LabelMenuClick(Sender);
end;

procedure TMainForm.LabelHostsFileClick(Sender: TObject);
begin
  MnuEditHostsFileClick(Sender);
end;

procedure TMainForm.LabelHelpClick(Sender: TObject);
begin
  OpenUrlOrFile('https://nexagon.org/docs');
end;

procedure TMainForm.LabelHelpMouseEnter(Sender: TObject);
begin
  if Sender is TLabel then
    TLabel(Sender).Font.Style := TLabel(Sender).Font.Style + [fsUnderline];
end;

procedure TMainForm.LabelHelpMouseLeave(Sender: TObject);
begin
  if Sender is TLabel then
    TLabel(Sender).Font.Style := TLabel(Sender).Font.Style - [fsUnderline];
end;

procedure TMainForm.BtnNotificationOKClick(Sender: TObject);
begin
  PanelNotification.Visible := False;
end;

{ PopupMenuTray Dynamic Builders }

procedure TMainForm.PopupMenuTrayPopup(Sender: TObject);
begin
  UpdateServiceAndMenuStates;
  MnuWWWClick(MnuWWW);
  MnuQuickAppClick(MnuQuickApp);
  MnuShareClick(MnuShare);
  MnuToolsClick(MnuTools);
  MnuProfileClick(MnuProfile);
  if MnuApache.Visible then
  begin
    MnuApacheVersionClick(MnuApacheVersion);
    MnuApacheVirtualHostClick(MnuApacheVirtualHost);
  end;
  if MnuNginx.Visible then
  begin
    MnuNginxVersionClick(MnuNginxVersion);
    MnuNginxServerClick(MnuNginxServer);
  end;
  if MnuMySQL.Visible then MnuMySQLVersionClick(MnuMySQLVersion);
  if MnuPostgreSQL.Visible then MnuPostgreSQLVersionClick(MnuPostgreSQLVersion);
  if MnuMongoDB.Visible then MnuMongoDBVersionClick(MnuMongoDBVersion);
  if MnuMemcached.Visible then MnuMemcachedVersionClick(MnuMemcachedVersion);
  if MnuRedis.Visible then MnuRedisVersionClick(MnuRedisVersion);
  MnuPHPVersionClick(MnuPHPVersion);
  MnuPHPExtensionsClick(MnuPHPExtensions);
  MnuPHPQuickSettingsClick(MnuPHPQuickSettings);
  MnuNodeJsVersionClick(MnuNodeJsVersion);
  if MnuPython.Visible then MnuPythonVersionClick(MnuPythonVersion);
  if MnuRuby.Visible then MnuRubyVersionClick(MnuRubyVersion);
  if MnuJava.Visible then MnuJavaVersionClick(MnuJavaVersion);
  if MnuGo.Visible then MnuGoVersionClick(MnuGoVersion);
  ForceForegroundForPopup(WidgetSet.AppHandle);
end;

procedure TMainForm.PopulateVersionSubMenu(ParentItem: TMenuItem; Srv: TCommonService; OnSelectHandler: TNotifyEvent);
var
  Vers: TStringList;
  I: Integer;
  Item: TMenuItem;
begin
  if not Assigned(ParentItem) or not Assigned(Srv) then Exit;
  ParentItem.Clear;
  ParentItem.Caption := Format('%s [%s]', [Nexagon.T(109, 'Version'), Srv.GetShortVersion]);
  Vers := TStringList.Create;
  try
    Srv.ListVersions(Vers);
    for I := 0 to Vers.Count - 1 do
    begin
      Item := TMenuItem.Create(ParentItem);
      Item.Caption := Vers[I];
      Item.RadioItem := True;
      Item.Checked := SameText(Vers[I], Srv.CurrentVersion);
      Item.Tag := PtrInt(Srv);
      Item.OnClick := OnSelectHandler;
      ParentItem.Add(Item);
    end;
    Item := TMenuItem.Create(ParentItem);
    Item.Caption := '-';
    ParentItem.Add(Item);

    Item := TMenuItem.Create(ParentItem);
    Item.Caption := 'dir: ' + Srv.CurrentVersion;
    Item.Tag := PtrInt(Srv);
    Item.ImageIndex := 14;
    Item.OnClick := @OnOpenServiceVersionDirClick;
    ParentItem.Add(Item);
  finally
    Vers.Free;
  end;
end;

procedure TMainForm.OnSelectServiceVersionClick(Sender: TObject);
var
  Item: TMenuItem;
  Srv: TCommonService;
  WasRunning: Boolean;
begin
  if not (Sender is TMenuItem) then Exit;
  Item := TMenuItem(Sender);
  Srv := TCommonService(PtrInt(Item.Tag));
  if not Assigned(Srv) then Exit;
  if SameText(Srv.CurrentVersion, Item.Caption) then Exit;

  WasRunning := (Srv is TService) and TService(Srv).Running;
  if WasRunning then
    TService(Srv).StopService;

  Srv.CurrentVersion := Item.Caption;
  if Assigned(Nexagon) then
  begin
    if Srv = SrvPHP then
    begin
      Nexagon.SyncPhpIni;
      Nexagon.CopyPhpDllsToApache;
      Nexagon.SyncApacheConfig;
      if Assigned(SrvApache) and SrvApache.Running then SrvApache.ReloadService;
    end;
    Nexagon.SaveConfig;
  end;

  if WasRunning and (Srv is TService) then
    TService(Srv).StartService;

  UpdateServiceAndMenuStates;
  ShowNotificationBanner(Format('%s switched to %s', [Srv.DisplayName, Srv.CurrentVersion]));
end;

procedure TMainForm.OnOpenServiceVersionDirClick(Sender: TObject);
var
  Srv: TCommonService;
begin
  if not (Sender is TMenuItem) then Exit;
  Srv := TCommonService(PtrInt(TMenuItem(Sender).Tag));
  if Assigned(Srv) then
    OpenUrlOrFile('explorer.exe', '"' + Srv.GetVersionDir + '"');
end;

procedure TMainForm.MnuWWWClick(Sender: TObject);
var
  SR: TSearchRec;
  SwitchItem, SubItem, Item: TMenuItem;
  DocRoots: TStringList;
  I: Integer;
begin
  if not Assigned(Nexagon) then Exit;
  MnuWWW.Clear;

  SwitchItem := TMenuItem.Create(MnuWWW);
  SwitchItem.Caption := Nexagon.T(237, 'Switch Document Root') + ' [' + Nexagon.DocumentRoot + ']';
  SwitchItem.ImageIndex := 14;
  DocRoots := TStringList.Create;
  try
    Nexagon.GetDocumentRootListItems(DocRoots);
    for I := 0 to DocRoots.Count - 1 do
    begin
      SubItem := TMenuItem.Create(SwitchItem);
      SubItem.Caption := DocRoots[I];
      SubItem.Checked := SameText(ExcludeTrailingPathDelimiter(DocRoots[I]), ExcludeTrailingPathDelimiter(Nexagon.DocumentRoot));
      SubItem.OnClick := @OnSelectDocRootFromListClick;
      SwitchItem.Add(SubItem);
    end;
  finally
    DocRoots.Free;
  end;

  SubItem := TMenuItem.Create(SwitchItem);
  SubItem.Caption := '-';
  SwitchItem.Add(SubItem);

  SubItem := TMenuItem.Create(SwitchItem);
  SubItem.Caption := Nexagon.T(238, 'Select another');
  SubItem.ImageIndex := 14;
  SubItem.OnClick := @OnSwitchDocRootItemClick;
  SwitchItem.Add(SubItem);

  MnuWWW.Add(SwitchItem);

  Item := TMenuItem.Create(MnuWWW);
  Item.Caption := '-';
  MnuWWW.Add(Item);

  Item := TMenuItem.Create(MnuWWW);
  Item.Caption := 'localhost';
  Item.ImageIndex := 11;
  Item.OnClick := @BtnWebClick;
  MnuWWW.Add(Item);

  if FindFirst(IncludeTrailingPathDelimiter(Nexagon.DocumentRoot) + '*', faDirectory, SR) = 0 then
  begin
    repeat
      if ((SR.Attr and faDirectory) <> 0) and (SR.Name <> '.') and (SR.Name <> '..') and (SR.Name[1] <> '.') then
      begin
        Item := TMenuItem.Create(MnuWWW);
        Item.Caption := SR.Name;
        Item.ImageIndex := 11;
        Item.OnClick := @OnWwwProjectItemClick;
        MnuWWW.Add(Item);
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TMainForm.OnWwwProjectItemClick(Sender: TObject);
var
  ProjName, HostUrl: string;
begin
  if not (Sender is TMenuItem) or not Assigned(Nexagon) then Exit;
  ProjName := StripHotkey(TMenuItem(Sender).Caption);
  if Nexagon.AutoVirtualHosts and not SameText(ProjName, 'nexagon') then
  begin
    HostUrl := 'http://' + StringReplace(Nexagon.HostnameFormat, '{name}', LowerCase(ProjName), [rfReplaceAll]);
    OpenUrlOrFile(HostUrl);
  end
  else
    OpenUrlOrFile('http://localhost/' + ProjName);
end;

procedure TMainForm.SwitchToDocumentRoot(const NewDir: string);
var
  CleanDir: string;
begin
  if not Assigned(Nexagon) then Exit;
  CleanDir := ExcludeTrailingPathDelimiter(Trim(NewDir));
  if CleanDir = '' then Exit;
  if Pos(' ', CleanDir) > 0 then
  begin
    MessageDlg('Path must not have SPACE!' + LineEnding + CleanDir, mtWarning, [mbOK], 0);
    Exit;
  end;
  ForceDirectories(CleanDir);
  Nexagon.DocumentRoot := CleanDir;
  Nexagon.AddDocumentRootToList(CleanDir);
  if Assigned(FormPref) and Assigned(FormPref.EditDocumentRoot) then
    FormPref.EditDocumentRoot.Text := CleanDir;
  Nexagon.SaveConfig;
  Nexagon.SyncApacheConfig;
  Nexagon.SyncNginxConfig;
  if Nexagon.AutoVirtualHosts then
    Nexagon.GenerateAutoVirtualHosts;
  if Assigned(SrvApache) and (SrvApache.Running or SrvApache.CheckRunning) then
    SrvApache.ReloadService;
  if Assigned(SrvNginx) and (SrvNginx.Running or SrvNginx.CheckRunning) then
    SrvNginx.ReloadService;
  UpdateServiceAndMenuStates;
  UpdateTooltips;
  ShowNotificationBanner(Nexagon.T(317, 'Document Root') + ': ' + Nexagon.DocumentRoot);
end;

procedure TMainForm.OnSelectDocRootFromListClick(Sender: TObject);
begin
  if not (Sender is TMenuItem) then Exit;
  SwitchToDocumentRoot(StripHotkey(TMenuItem(Sender).Caption));
end;

procedure TMainForm.OnSwitchDocRootItemClick(Sender: TObject);
begin
  if Assigned(FormPref) then
  begin
    FormPref.BtnDocumentRootClick(Sender);
    if Assigned(Nexagon) then
      ShowNotificationBanner(Nexagon.T(317, 'Document Root') + ': ' + Nexagon.DocumentRoot);
  end;
end;

procedure TMainForm.MnuQuickAppClick(Sender: TObject);
var
  I, P: Integer;
  Line, KeyStr, ValStr: string;
  Item: TMenuItem;
begin
  if not Assigned(Nexagon) then Exit;
  MnuQuickApp.Clear;
  Nexagon.LoadSitesAndPackages;
  for I := 0 to Nexagon.SitesConf.Count - 1 do
  begin
    Line := Trim(Nexagon.SitesConf[I]);
    if (Line = '') or (Line[1] = '#') or (Line[1] = '[') then Continue;
    if (Pos('AutoCreateDatabase', Line) = 1) or (Pos('Cached', Line) = 1) then Continue;
    if Line[1] = '-' then
    begin
      Item := TMenuItem.Create(MnuQuickApp);
      Item.Caption := '-';
      MnuQuickApp.Add(Item);
      Continue;
    end;
    P := Pos('=', Line);
    if P > 0 then
    begin
      KeyStr := Trim(Copy(Line, 1, P - 1));
      ValStr := Trim(Copy(Line, P + 1, MaxInt));
      Item := TMenuItem.Create(MnuQuickApp);
      Item.Caption := KeyStr;
      Item.Hint := ValStr;
      Item.OnClick := @OnQuickAppItemClick;
      MnuQuickApp.Add(Item);
    end;
  end;

  Item := TMenuItem.Create(MnuQuickApp);
  Item.Caption := '-';
  MnuQuickApp.Add(Item);

  Item := TMenuItem.Create(MnuQuickApp);
  Item.Caption := 'Configuration (sites.conf)...';
  Item.OnClick := @MnuNexagonIniClick;
  MnuQuickApp.Add(Item);
end;

procedure TMainForm.OnQuickAppItemClick(Sender: TObject);
var
  AppType, Url, ProjName: string;
begin
  if not (Sender is TMenuItem) then Exit;
  AppType := StripHotkey(TMenuItem(Sender).Caption);
  Url := TMenuItem(Sender).Hint;
  ProjName := LowerCase(StringReplace(AppType, ' ', '-', [rfReplaceAll]));
  if InputQuery('Quick app - ' + AppType, 'Please input project name:', ProjName) then
  begin
    ProjName := Trim(ProjName);
    if ProjName <> '' then
      FormQuickCreateWebsite.StartQuickCreate(AppType, ProjName, Url);
  end;
end;

procedure TMainForm.MnuShareClick(Sender: TObject);
var
  SR: TSearchRec;
  Item: TMenuItem;
begin
  if not Assigned(Nexagon) then Exit;
  MnuShare.Clear;
  if FindFirst(IncludeTrailingPathDelimiter(Nexagon.DocumentRoot) + '*', faDirectory, SR) = 0 then
  begin
    repeat
      if ((SR.Attr and faDirectory) <> 0) and (SR.Name <> '.') and (SR.Name <> '..') and (SR.Name[1] <> '.') then
      begin
        Item := TMenuItem.Create(MnuShare);
        Item.Caption := SR.Name;
        Item.OnClick := @OnShareSiteItemClick;
        MnuShare.Add(Item);
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TMainForm.OnShareSiteItemClick(Sender: TObject);
var
  ProjName, HostName: string;
  Port: Integer;
begin
  if not (Sender is TMenuItem) or not Assigned(Nexagon) then Exit;
  ProjName := StripHotkey(TMenuItem(Sender).Caption);
  HostName := StringReplace(Nexagon.HostnameFormat, '{name}', LowerCase(ProjName), [rfReplaceAll]);
  Port := 80;
  if Assigned(SrvApache) and SrvApache.Enabled then Port := SrvApache.Port;
  if not TNgrok.ShareSite(Nexagon.RootDir, HostName, Port) then
    ShowNotificationBanner('ngrok.exe not found in bin\ngrok');
end;

procedure TMainForm.MnuToolsClick(Sender: TObject);
var
  QuickAddSub, DelSub, CloneSub, Item: TMenuItem;
  I, P: Integer;
  Line, KeyStr, ValStr: string;
  SR: TSearchRec;
begin
  if not Assigned(Nexagon) then Exit;

  // Find or create Quick Add, Delete Project, Clone Project inside MnuTools
  QuickAddSub := MnuTools.Find('Quick add');
  if not Assigned(QuickAddSub) then
  begin
    QuickAddSub := TMenuItem.Create(MnuTools);
    QuickAddSub.Caption := 'Quick add';
    MnuTools.Add(QuickAddSub);
  end;
  QuickAddSub.Clear;
  for I := 0 to Nexagon.PackagesConf.Count - 1 do
  begin
    Line := Trim(Nexagon.PackagesConf[I]);
    if (Line = '') or (Line[1] = '#') or (Line[1] = '[') then Continue;
    P := Pos('=', Line);
    if P > 0 then
    begin
      KeyStr := Trim(Copy(Line, 1, P - 1));
      if KeyStr[1] = '*' then Delete(KeyStr, 1, 1);
      ValStr := Trim(Copy(Line, P + 1, MaxInt));
      Item := TMenuItem.Create(QuickAddSub);
      Item.Caption := KeyStr;
      Item.Hint := ValStr;
      Item.OnClick := @OnQuickAddItemClick;
      QuickAddSub.Add(Item);
    end;
  end;

  DelSub := MnuTools.Find('Delete project');
  if not Assigned(DelSub) then
  begin
    DelSub := TMenuItem.Create(MnuTools);
    DelSub.Caption := 'Delete project';
    MnuTools.Add(DelSub);
  end;
  DelSub.Clear;

  CloneSub := MnuTools.Find('Clone project');
  if not Assigned(CloneSub) then
  begin
    CloneSub := TMenuItem.Create(MnuTools);
    CloneSub.Caption := 'Clone project';
    MnuTools.Add(CloneSub);
  end;
  CloneSub.Clear;

  if FindFirst(IncludeTrailingPathDelimiter(Nexagon.DocumentRoot) + '*', faDirectory, SR) = 0 then
  begin
    repeat
      if ((SR.Attr and faDirectory) <> 0) and (SR.Name <> '.') and (SR.Name <> '..') and (SR.Name[1] <> '.') then
      begin
        Item := TMenuItem.Create(DelSub);
        Item.Caption := SR.Name;
        Item.OnClick := @OnDeleteProjectItemClick;
        DelSub.Add(Item);

        Item := TMenuItem.Create(CloneSub);
        Item.Caption := SR.Name;
        Item.OnClick := @OnCloneProjectItemClick;
        CloneSub.Add(Item);
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TMainForm.OnQuickAddItemClick(Sender: TObject);
var
  PkgName, Url: string;
begin
  if not (Sender is TMenuItem) then Exit;
  PkgName := StripHotkey(TMenuItem(Sender).Caption);
  Url := TMenuItem(Sender).Hint;
  if (Url <> '') and Assigned(FormQuickCreateWebsite) then
    FormQuickCreateWebsite.StartQuickAdd(PkgName, Url)
  else
    ShowNotificationBanner('Package ' + PkgName + ' has no URL configured in usr\packages.conf');
end;

procedure TMainForm.OnDeleteProjectItemClick(Sender: TObject);
var
  ProjName, TargetDir: string;
begin
  if not (Sender is TMenuItem) or not Assigned(Nexagon) then Exit;
  ProjName := StripHotkey(TMenuItem(Sender).Caption);
  TargetDir := IncludeTrailingPathDelimiter(Nexagon.DocumentRoot) + ProjName;
  if MessageDlg('Delete project', Format('Are you sure you want to delete project "%s"?', [ProjName]),
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ShellExecute(0, 'open', 'cmd.exe', PChar('/c rmdir /s /q "' + TargetDir + '"'), nil, SW_HIDE);
    ShowNotificationBanner('Deleted project ' + ProjName);
  end;
end;

procedure TMainForm.OnCloneProjectItemClick(Sender: TObject);
var
  SrcName, NewName, SrcDir, DstDir: string;
begin
  if not (Sender is TMenuItem) or not Assigned(Nexagon) then Exit;
  SrcName := StripHotkey(TMenuItem(Sender).Caption);
  NewName := SrcName + '-clone';
  if InputQuery('Clone project', 'Enter new project name:', NewName) then
  begin
    SrcDir := IncludeTrailingPathDelimiter(Nexagon.DocumentRoot) + SrcName;
    DstDir := IncludeTrailingPathDelimiter(Nexagon.DocumentRoot) + Trim(NewName);
    ShellExecute(0, 'open', 'xcopy.exe', PChar(Format('"%s" "%s\" /E /I /H /Y', [SrcDir, DstDir])), nil, SW_HIDE);
    Nexagon.CreateVirtualHostForProject(Trim(NewName), DstDir);
    ShowNotificationBanner('Cloned ' + SrcName + ' -> ' + NewName);
  end;
end;

{ Apache & Nginx Submenu Handlers }

procedure TMainForm.MnuApacheVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuApacheVersion, SrvApache, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuNginxVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuNginxVersion, SrvNginx, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuMySQLVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuMySQLVersion, SrvMySQL, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuPostgreSQLVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuPostgreSQLVersion, SrvPostgreSQL, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuMongoDBVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuMongoDBVersion, SrvMongoDB, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuMemcachedVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuMemcachedVersion, SrvMemcached, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuRedisVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuRedisVersion, SrvRedis, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuPHPVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuPHPVersion, SrvPHP, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuNodeJsVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuNodeJsVersion, SrvNodeJS, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuPythonVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuPythonVersion, SrvPython, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuRubyVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuRubyVersion, SrvRuby, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuJavaVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuJavaVersion, SrvJava, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuGoVersionClick(Sender: TObject);
begin
  PopulateVersionSubMenu(MnuGoVersion, SrvGo, @OnSelectServiceVersionClick);
end;

procedure TMainForm.MnuApacheVirtualHostClick(Sender: TObject);
var
  SR: TSearchRec;
  Dir: string;
  Item: TMenuItem;
begin
  if not Assigned(Nexagon) then Exit;
  MnuApacheVirtualHost.Clear;
  Dir := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'etc\apache2\sites-enabled\';
  if FindFirst(Dir + '*.conf', faAnyFile, SR) = 0 then
  begin
    repeat
      Item := TMenuItem.Create(MnuApacheVirtualHost);
      Item.Caption := SR.Name;
      Item.Hint := Dir + SR.Name;
      Item.OnClick := @OnVHostFileItemClick;
      MnuApacheVirtualHost.Add(Item);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TMainForm.MnuNginxServerClick(Sender: TObject);
var
  SR: TSearchRec;
  Dir: string;
  Item: TMenuItem;
begin
  if not Assigned(Nexagon) then Exit;
  MnuNginxServer.Clear;
  Dir := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'etc\nginx\sites-enabled\';
  if FindFirst(Dir + '*.conf', faAnyFile, SR) = 0 then
  begin
    repeat
      Item := TMenuItem.Create(MnuNginxServer);
      Item.Caption := SR.Name;
      Item.Hint := Dir + SR.Name;
      Item.OnClick := @OnVHostFileItemClick;
      MnuNginxServer.Add(Item);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TMainForm.OnVHostFileItemClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    OpenFileInNotepadPP(TMenuItem(Sender).Hint);
end;

{ PHP Extensions & Quick Settings }

procedure TMainForm.MnuPHPExtensionsClick(Sender: TObject);
var
  Exts: TStringList;
  I: Integer;
  Item: TMenuItem;
begin
  if not Assigned(SrvPHP) then Exit;
  MnuPHPExtensions.Clear;
  Exts := TStringList.Create;
  try
    SrvPHP.GetExtensions(Exts);
    for I := 0 to Exts.Count - 1 do
    begin
      Item := TMenuItem.Create(MnuPHPExtensions);
      Item.Caption := Exts[I];
      Item.Checked := PtrInt(Exts.Objects[I]) <> 0;
      Item.OnClick := @OnPhpExtensionItemClick;
      MnuPHPExtensions.Add(Item);
    end;
  finally
    Exts.Free;
  end;
end;

procedure TMainForm.OnPhpExtensionItemClick(Sender: TObject);
var
  ExtName: string;
begin
  if not (Sender is TMenuItem) or not Assigned(SrvPHP) then Exit;
  ExtName := StripHotkey(TMenuItem(Sender).Caption);
  if SrvPHP.ToggleExtension(ExtName) then
  begin
    if Assigned(SrvApache) and SrvApache.Running then SrvApache.ReloadService;
    if Assigned(SrvNginx) and SrvNginx.Running then SrvNginx.ReloadService;
    ShowNotificationBanner('Toggled PHP extension: ' + ExtName);
  end;
end;

procedure TMainForm.MnuPHPQuickSettingsClick(Sender: TObject);
begin
  if not Assigned(SrvPHP) then Exit;
  maxexecutiontime1.Caption := 'max_execution_time = ' + SrvPHP.GetIniSetting('max_execution_time', '36000');
  uploadmaxfilesize2G1.Caption := 'upload_max_filesize = ' + SrvPHP.GetIniSetting('upload_max_filesize', '2G');
  memorylimit512M1.Caption := 'memory_limit = ' + SrvPHP.GetIniSetting('memory_limit', '512M');
  xdebug1.Checked := SrvPHP.GetXdebugDllPath <> '';
end;

procedure TMainForm.OnPhpQuickSettingItemClick(Sender: TObject);
var
  Cap, KeyStr, CurVal, NewVal: string;
  P: Integer;
begin
  if not (Sender is TMenuItem) or not Assigned(SrvPHP) then Exit;
  Cap := StripHotkey(TMenuItem(Sender).Caption);
  if SameText(Cap, 'xdebug') then
  begin
    if SrvPHP.GetXdebugDllPath = '' then
    begin
      MessageDlg('Xdebug',
        'This feature helps you toggle Xdebug just 1 click.' + LineEnding +
        'However, you haven''t installed Xdebug yet.' + LineEnding +
        'See https://forum.nexagon.org/topic/264/xdebug', mtInformation, [mbOK], 0);
      Exit;
    end;
    SrvPHP.ToggleExtension('xdebug');
    Exit;
  end;

  P := Pos('=', Cap);
  if P > 0 then
  begin
    KeyStr := Trim(Copy(Cap, 1, P - 1));
    CurVal := Trim(Copy(Cap, P + 1, MaxInt));
    NewVal := CurVal;
    if InputQuery('PHP Quick Settings', KeyStr + ':', NewVal) then
    begin
      if SrvPHP.SetIniSetting(KeyStr, Trim(NewVal)) then
      begin
        if SameText(KeyStr, 'upload_max_filesize') then
          SrvPHP.SetIniSetting('post_max_size', Trim(NewVal));
        if Assigned(SrvApache) and SrvApache.Running then SrvApache.ReloadService;
        if Assigned(SrvNginx) and SrvNginx.Running then SrvNginx.ReloadService;
      end;
    end;
  end;
end;

{ Profiles Submenu }

procedure TMainForm.MnuProfileClick(Sender: TObject);
var
  Profs: TStringList;
  I: Integer;
  Item: TMenuItem;
begin
  if not Assigned(Nexagon) then Exit;
  MnuProfile.Clear;
  Profs := TStringList.Create;
  try
    Nexagon.ListProfiles(Profs);
    for I := 0 to Profs.Count - 1 do
    begin
      Item := TMenuItem.Create(MnuProfile);
      Item.Caption := Profs[I];
      Item.RadioItem := True;
      Item.Checked := SameText(Profs[I], Nexagon.Profile);
      Item.OnClick := @OnProfileItemClick;
      MnuProfile.Add(Item);
    end;
    Item := TMenuItem.Create(MnuProfile);
    Item.Caption := '-';
    MnuProfile.Add(Item);

    Item := TMenuItem.Create(MnuProfile);
    Item.Caption := 'Add profile...';
    Item.OnClick := @OnAddProfileItemClick;
    MnuProfile.Add(Item);
  finally
    Profs.Free;
  end;
end;

procedure TMainForm.OnProfileItemClick(Sender: TObject);
var
  ProfName: string;
begin
  if not (Sender is TMenuItem) or not Assigned(Nexagon) then Exit;
  ProfName := StripHotkey(TMenuItem(Sender).Caption);
  Nexagon.SwitchProfile(ProfName);
  OnServicesConfigUpdated(Self);
  ShowNotificationBanner('Switched to profile: ' + ProfName);
end;

procedure TMainForm.OnAddProfileItemClick(Sender: TObject);
var
  NewProf, ProfFile: string;
begin
  if not Assigned(Nexagon) then Exit;
  NewProf := 'my-profile';
  if InputQuery('Add Profile', 'Enter profile name:', NewProf) then
  begin
    NewProf := Trim(NewProf);
    if NewProf <> '' then
    begin
      ForceDirectories(Nexagon.GetUsrDir + '\profile');
      ProfFile := Nexagon.GetUsrDir + '\profile\' + NewProf + '.ini';
      CopyFile(PChar(Nexagon.GetIniPath), PChar(ProfFile), False);
      Nexagon.SwitchProfile(NewProf);
      OnServicesConfigUpdated(Self);
    end;
  end;
end;

{ Service Start/Stop/Reload & File Open Handlers }

procedure TMainForm.MnuStartAllClick(Sender: TObject);
begin
  if AnyPrimaryServiceRunning then
    BtnStopAllClick(Sender)
  else
    BtnStartAllClick(Sender);
end;

procedure TMainForm.MnuStartApacheClick(Sender: TObject);
begin
  if Assigned(SrvApache) then
  begin
    if SrvApache.Running then SrvApache.StopService else SrvApache.StartService;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.MnuReloadApacheClick(Sender: TObject);
begin
  if Assigned(SrvApache) then
  begin
    SrvApache.ReloadService;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.MnuStartNginxClick(Sender: TObject);
begin
  if Assigned(SrvNginx) then
  begin
    if SrvNginx.Running then SrvNginx.StopService else SrvNginx.StartService;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.MnuReloadNginxClick(Sender: TObject);
begin
  if Assigned(SrvNginx) then
  begin
    SrvNginx.ReloadService;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.MnuStartMySQLClick(Sender: TObject);
begin
  if Assigned(SrvMySQL) then
  begin
    if SrvMySQL.Running then SrvMySQL.StopService else SrvMySQL.StartService;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.mnuStartPostgreSQLClick(Sender: TObject);
begin
  if Assigned(SrvPostgreSQL) then
  begin
    if SrvPostgreSQL.Running then SrvPostgreSQL.StopService else SrvPostgreSQL.StartService;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.MnuStartMongoDBClick(Sender: TObject);
begin
  if Assigned(SrvMongoDB) then
  begin
    if SrvMongoDB.Running then SrvMongoDB.StopService else SrvMongoDB.StartService;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.MnuStartMemcachedClick(Sender: TObject);
begin
  if Assigned(SrvMemcached) then
  begin
    if SrvMemcached.Running then SrvMemcached.StopService else SrvMemcached.StartService;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.MnuStartRedisClick(Sender: TObject);
begin
  if Assigned(SrvRedis) then
  begin
    if SrvRedis.Running then SrvRedis.StopService else SrvRedis.StartService;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.MnuStartMailpitClick(Sender: TObject);
begin
  if Assigned(SrvMailpit) then
  begin
    if SrvMailpit.Running then SrvMailpit.StopService else SrvMailpit.StartService;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.MnuStartPHPServerClick(Sender: TObject);
begin
  if Assigned(SrvPHP) then
  begin
    if SrvPHP.Running then SrvPHP.StopService else SrvPHP.StartService;
    UpdateServiceAndMenuStates;
  end;
end;

procedure TMainForm.MnuApacheSSLEnabledClick(Sender: TObject);
begin
  if Assigned(SrvApache) and Assigned(SrvApache.UI) then
    SrvApache.UI.OnSslClick(Sender);
end;

procedure TMainForm.MnuNginxSSLEnabledClick(Sender: TObject);
begin
  if Assigned(SrvNginx) and Assigned(SrvNginx.UI) then
    SrvNginx.UI.OnSslClick(Sender);
end;

procedure TMainForm.MnuApacheAddCertificatesToTrustStoreClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
  begin
    if Nexagon.AddSslCertToTrustStore then
      ShowNotificationBanner('Added Nexagon SSL Certificate to Windows Trust Store')
    else
      ShowNotificationBanner('Generated SSL Certificate in etc\ssl\nexagon.crt');
  end;
end;

procedure TMainForm.MnuNginxAddCertificatesToTrustStoreClick(Sender: TObject);
begin
  MnuApacheAddCertificatesToTrustStoreClick(Sender);
end;

procedure TMainForm.MnuApacheCertificateManagerClick(Sender: TObject);
begin
  OpenUrlOrFile('certmgr.msc');
end;

procedure TMainForm.MnuNginxCertificateManagerClick(Sender: TObject);
begin
  OpenUrlOrFile('certmgr.msc');
end;

procedure TMainForm.MnuApacheConfigFileClick(Sender: TObject);
begin
  if Assigned(SrvApache) then OpenFileInNotepadPP(SrvApache.GetConfigPath);
end;

procedure TMainForm.MnuApacheHttpdSSLConfClick(Sender: TObject);
begin
  if Assigned(Nexagon) then OpenFileInNotepadPP(Nexagon.GetUsrDir + '\tpl\openssl.conf.tpl');
end;

procedure TMainForm.MnuApacheErrorLogClick(Sender: TObject);
begin
  if Assigned(SrvApache) then OpenFileInNotepadPP(IncludeTrailingPathDelimiter(SrvApache.GetVersionDir) + 'logs\error.log');
end;

procedure TMainForm.MnuApacheAccessLogClick(Sender: TObject);
begin
  if Assigned(SrvApache) then OpenFileInNotepadPP(IncludeTrailingPathDelimiter(SrvApache.GetVersionDir) + 'logs\access.log');
end;

procedure TMainForm.MnuApacheConfDirClick(Sender: TObject);
begin
  if Assigned(Nexagon) then OpenUrlOrFile('explorer.exe', '"' + IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'etc\apache2\sites-enabled"');
end;

procedure TMainForm.MnuApacheAliasClick(Sender: TObject);
begin
  if Assigned(Nexagon) then OpenUrlOrFile('explorer.exe', '"' + IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'etc\apache2\alias"');
end;

procedure TMainForm.MnuNginxConfClick(Sender: TObject);
begin
  if Assigned(SrvNginx) then OpenFileInNotepadPP(SrvNginx.GetConfigPath);
end;

procedure TMainForm.MnuNginxErrorLogClick(Sender: TObject);
begin
  if Assigned(SrvNginx) then OpenFileInNotepadPP(IncludeTrailingPathDelimiter(SrvNginx.GetVersionDir) + 'logs\error.log');
end;

procedure TMainForm.MnuNginxAccessLogClick(Sender: TObject);
begin
  if Assigned(SrvNginx) then OpenFileInNotepadPP(IncludeTrailingPathDelimiter(SrvNginx.GetVersionDir) + 'logs\access.log');
end;

procedure TMainForm.MnuNginxConfDirClick(Sender: TObject);
begin
  if Assigned(Nexagon) then OpenUrlOrFile('explorer.exe', '"' + IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'etc\nginx\sites-enabled"');
end;

procedure TMainForm.MnuNginxAliasClick(Sender: TObject);
begin
  if Assigned(Nexagon) then OpenUrlOrFile('explorer.exe', '"' + IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'etc\nginx\alias"');
end;

procedure TMainForm.MnuMySQLPHPMyAdmin6Click(Sender: TObject);
begin
  OpenUrlOrFile('http://localhost/phpmyadmin');
end;

procedure TMainForm.MnuMySQLphpMyAdminClick(Sender: TObject);
begin
  OpenUrlOrFile('http://localhost/phpmyadmin');
end;

procedure TMainForm.MnuMySQLDBeaverClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\dbeaver\dbeaver.exe');
end;

procedure TMainForm.MnuMySQLHeidiSQLClick(Sender: TObject);
begin
  BtnDatabaseClick(Sender);
end;

procedure TMainForm.MnuMySQLCreateDatabaseClick(Sender: TObject);
var
  DbName, ErrMsg: string;
begin
  if not Assigned(SrvMySQL) then Exit;
  DbName := 'my_db';
  if InputQuery('Create Database', 'Database name:', DbName) then
  begin
    if SrvMySQL.CreateDatabase(Trim(DbName), ErrMsg) then
      ShowNotificationBanner('Created database: ' + DbName)
    else
      MessageDlg('MySQL Error', 'Could not create database: ' + ErrMsg, mtError, [mbOK], 0);
  end;
end;

procedure TMainForm.MnuMySQLChangeRootPasswordClick(Sender: TObject);
var
  NewPass: string;
begin
  if not Assigned(SrvMySQL) then Exit;
  NewPass := '';
  if InputQuery('Change MySQL root password', 'New password (leave empty for blank):', NewPass) then
  begin
    SrvMySQL.ResetRootPassword(NewPass, MemoResetMySQLOutput.Lines);
    ShowNotificationBanner('Updated MySQL root password');
  end;
end;

procedure TMainForm.MnuMySQLGetRootPasswordClick(Sender: TObject);
begin
  Clipboard.AsText := '';
  ShowNotificationBanner('Default MySQL user: root (empty password)');
end;

procedure TMainForm.MnuMySQLResetRootPasswordClick(Sender: TObject);
begin
  MnuMySQLChangeRootPasswordClick(Sender);
end;

procedure TMainForm.MnuMySQLBackupAllDatabasesClick(Sender: TObject);
var
  BackupDir: string;
begin
  if Assigned(SrvMySQL) then
  begin
    if SrvMySQL.BackupAllDatabases(BackupDir) then
    begin
      ShowNotificationBanner('Backed up all databases to ' + BackupDir);
      OpenUrlOrFile('explorer.exe', '"' + BackupDir + '"');
    end
    else
      ShowNotificationBanner('Backup failed (ensure MySQL is running)');
  end;
end;

procedure TMainForm.MnuMySQLConfigFileClick(Sender: TObject);
begin
  if Assigned(SrvMySQL) then OpenFileInNotepadPP(SrvMySQL.GetConfigPath);
end;

procedure TMainForm.MnuMySQLErrorLogClick(Sender: TObject);
begin
  if Assigned(SrvMySQL) then OpenFileInNotepadPP(SrvMySQL.GetLogPath);
end;

procedure TMainForm.MnuMySQLDataDirClick(Sender: TObject);
begin
  if Assigned(SrvMySQL) then OpenUrlOrFile('explorer.exe', '"' + SrvMySQL.GetDataDir + '"');
end;

procedure TMainForm.MnuMySQLBackupDirClick(Sender: TObject);
var
  Dir: string;
begin
  if Assigned(Nexagon) then
  begin
    Dir := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'backup\mysql';
    ForceDirectories(Dir);
    OpenUrlOrFile('explorer.exe', '"' + Dir + '"');
  end;
end;

procedure TMainForm.MnuPostgreSQLPgAdmin4Click(Sender: TObject);
begin
  OpenUrlOrFile('http://localhost:5050');
end;

procedure TMainForm.MnuPostgreSQLPgAdminClick(Sender: TObject);
begin
  if Assigned(SrvPostgreSQL) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(SrvPostgreSQL.GetVersionDir) + 'bin\pgAdmin3.exe');
end;

procedure TMainForm.postgresqlconf1Click(Sender: TObject);
begin
  if Assigned(SrvPostgreSQL) then
    OpenFileInNotepadPP(IncludeTrailingPathDelimiter(SrvPostgreSQL.GetDataDir) + 'postgresql.conf');
end;

procedure TMainForm.postgresqllog1Click(Sender: TObject);
begin
  if Assigned(SrvPostgreSQL) then
    OpenFileInNotepadPP(SrvPostgreSQL.GetLogPath);
end;

procedure TMainForm.MnuPostgreSQLDataDirClick(Sender: TObject);
begin
  if Assigned(SrvPostgreSQL) then
    OpenUrlOrFile('explorer.exe', '"' + SrvPostgreSQL.GetDataDir + '"');
end;

procedure TMainForm.MnuRoboMongoClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\robomongo\robomongo.exe');
end;

procedure TMainForm.MnuMongoDBConfigFileClick(Sender: TObject);
begin
  if Assigned(SrvMongoDB) then OpenFileInNotepadPP(SrvMongoDB.GetConfigPath);
end;

procedure TMainForm.MnuMongoDBLogClick(Sender: TObject);
begin
  if Assigned(SrvMongoDB) then OpenFileInNotepadPP(SrvMongoDB.GetLogPath);
end;

procedure TMainForm.MnuMongoDBDataDirClick(Sender: TObject);
begin
  if Assigned(SrvMongoDB) then OpenUrlOrFile('explorer.exe', '"' + SrvMongoDB.GetDataDir + '"');
end;

procedure TMainForm.MnuMailpitWebUIClick(Sender: TObject);
begin
  OpenUrlOrFile('http://localhost:8025');
end;

procedure TMainForm.MnuPHPConfigFileClick(Sender: TObject);
begin
  if Assigned(SrvPHP) then OpenFileInNotepadPP(SrvPHP.GetConfigPath);
end;

procedure TMainForm.MnuPHPExtensionsDirClick(Sender: TObject);
begin
  if Assigned(SrvPHP) then OpenUrlOrFile('explorer.exe', '"' + SrvPHP.GetExtDir + '"');
end;

procedure TMainForm.MnuPHPErrorLogClick(Sender: TObject);
begin
  if Assigned(SrvPHP) then OpenFileInNotepadPP(SrvPHP.GetErrorLogPath);
end;

{ Mail Catcher & Mail Sender Menu Items }

procedure TMainForm.MnuMailCatcherClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    MnuMailCatcherEnable.Checked := Nexagon.MailCatcherEnabled;
end;

procedure TMainForm.MnuMailCatcherEnableClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
  begin
    Nexagon.MailCatcherEnabled := not Nexagon.MailCatcherEnabled;
    Nexagon.SaveConfig;
    MnuMailCatcherEnable.Checked := Nexagon.MailCatcherEnabled;
  end;
end;

procedure TMainForm.MnuViewemailClick(Sender: TObject);
var
  LatestMail: string;
begin
  if not Assigned(Nexagon) then Exit;
  LatestMail := Nexagon.GetLatestEmailFile;
  if LatestMail <> '' then
    OpenFileInNotepadPP(LatestMail)
  else
    ShowNotificationBanner('No caught emails found in ' + Nexagon.GetMailCatcherDir);
end;

procedure TMainForm.MnuOpenmaildirClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile('explorer.exe', '"' + Nexagon.GetMailCatcherDir + '"');
end;

procedure TMainForm.MnuSendmailPathClipboardClick(Sender: TObject);
var
  SendmailPath: string;
begin
  SendmailPath := '"' + ParamStr(0) + '" sendmail';
  Clipboard.AsText := SendmailPath;
  ShowNotificationBanner('Copied sendmail_path to clipboard');
end;

procedure TMainForm.MnuMailCatcherConfigurationClick(Sender: TObject);
begin
  if Assigned(FormPref) then
    FormPref.ShowTab(2);
end;

procedure TMainForm.MnuMailSenderClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    MnuMailSenderEnable.Checked := Nexagon.MailSenderEnabled;
end;

procedure TMainForm.MnuMailSenderEnableClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
  begin
    Nexagon.MailSenderEnabled := not Nexagon.MailSenderEnabled;
    Nexagon.SyncSendmailConfig;
    Nexagon.SaveConfig;
    MnuMailSenderEnable.Checked := Nexagon.MailSenderEnabled;
  end;
end;

procedure TMainForm.MnuMailSenderDebugLogClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenFileInNotepadPP(IncludeTrailingPathDelimiter(Nexagon.GetMailSenderDir) + 'debug.log');
end;

procedure TMainForm.MnuMailSenderErrorLogClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenFileInNotepadPP(IncludeTrailingPathDelimiter(Nexagon.GetMailSenderDir) + 'error.log');
end;

procedure TMainForm.MnuMailSenderConfigurationClick(Sender: TObject);
begin
  if Assigned(FormPref) then
    FormPref.ShowTab(3);
end;

{ Tools & Path Variables & Misc Handlers }

procedure TMainForm.MnuManagePathClick(Sender: TObject);
begin
  if Assigned(FormPathVariables) then
  begin
    FormPathVariables.Show;
    FormPathVariables.BringToFront;
  end;
end;

procedure TMainForm.MnuAddNexagontoPathClick(Sender: TObject);
begin
  if Assigned(Nexagon) and Nexagon.AddNexagonToUserPath then
    ShowNotificationBanner('Added Nexagon to User PATH');
end;

procedure TMainForm.MnuRemoveNexagonfromPathClick(Sender: TObject);
begin
  if Assigned(Nexagon) and Nexagon.RemoveNexagonFromUserPath then
    ShowNotificationBanner('Removed Nexagon from User PATH');
end;

procedure TMainForm.MnuEditHostsFileClick(Sender: TObject);
begin
  OpenFileInNotepadPP(GetEnvironmentVariable('SystemRoot') + '\System32\drivers\etc\hosts');
end;

procedure TMainForm.MnuNetStatClick(Sender: TObject);
begin
  if Assigned(FormConsole) then
  begin
    FormConsole.Show;
    FormConsole.BringToFront;
    FormConsole.RunCommandToConsole('netstat -ano | findstr LISTENING');
  end;
end;

procedure TMainForm.MnuNotepadPlusPlusClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\notepad++\notepad++.exe');
end;

procedure TMainForm.MnuSublimeTextClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\sublime\sublime_text.exe');
end;

procedure TMainForm.MnuWinSCPClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\winscp\WinSCP.exe');
end;

procedure TMainForm.MnuputtyClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\putty\putty.exe');
end;

procedure TMainForm.MnuPuTTYgenClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\putty\puttygen.exe');
end;

procedure TMainForm.MnuAddSublimeTextTerminalClick(Sender: TObject);
var
  CmdFile: string;
begin
  if Assigned(Nexagon) then
  begin
    CmdFile := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\nexagon\right.click.menu.add.cmd';
    if FileExists(CmdFile) then
      ShellExecute(Handle, 'runas', PChar(CmdFile), nil, nil, SW_SHOWNORMAL)
    else
      ShowNotificationBanner('Added Nexagon right-click context menu');
  end;
end;

procedure TMainForm.MnuRemoveSublimeTextTerminalClick(Sender: TObject);
var
  CmdFile: string;
begin
  if Assigned(Nexagon) then
  begin
    CmdFile := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\nexagon\right.click.menu.remove.cmd';
    if FileExists(CmdFile) then
      ShellExecute(Handle, 'runas', PChar(CmdFile), nil, nil, SW_SHOWNORMAL)
    else
      ShowNotificationBanner('Removed Nexagon right-click context menu');
  end;
end;

procedure TMainForm.MnuPreferencesClick(Sender: TObject);
begin
  BtnConfigClick(Sender);
end;

procedure TMainForm.MnuExitClick(Sender: TObject);
begin
  FAllowExit := True;
  Close;
end;

{ TrayIcon & Secondary Menu Shortcuts }

procedure TMainForm.TrayIconClick(Sender: TObject);
var
  ExStyle: LONG_PTR;
begin
  if WidgetSet.AppHandle <> 0 then
  begin
    ExStyle := GetWindowLongPtr(WidgetSet.AppHandle, GWL_EXSTYLE);
    if (ExStyle and WS_EX_TOOLWINDOW) <> 0 then
      SetWindowLongPtr(WidgetSet.AppHandle, GWL_EXSTYLE, ExStyle and (not WS_EX_TOOLWINDOW));
  end;
  Show;
  WindowState := wsNormal;
  BringToFront;
end;

procedure TMainForm.TrayIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Do NOT call SetForegroundWindow on WM_RBUTTONDOWN!
  // Stealing focus on WM_RBUTTONDOWN causes Windows 11 System Tray Overflow Flyout (^)
  // to dismiss and cancel the right-click before WM_RBUTTONUP arrives.
end;

procedure TMainForm.DoTrayPopup(Data: PtrInt);
begin
  ForceForegroundForPopup(WidgetSet.AppHandle);
  PopupMenuTray.PopUp(FTrayPopupPt.X, FTrayPopupPt.Y);
  PostMessage(WidgetSet.AppHandle, WM_NULL, 0, 0);
end;

procedure TMainForm.TrayIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    FTrayPopupPt := Point(X, Y);
    Application.QueueAsyncCall(@DoTrayPopup, 0);
    PostMessage(WidgetSet.AppHandle, WM_NULL, 0, 0);
  end;
end;

procedure TMainForm.MnuNexagonClick(Sender: TObject);
begin
  TrayIconClick(Sender);
end;

procedure TMainForm.MnuWeb2Click(Sender: TObject);
begin
  BtnWebClick(Sender);
end;

procedure TMainForm.MnuDatabase2Click(Sender: TObject);
begin
  BtnDatabaseClick(Sender);
end;

procedure TMainForm.MnuShell2Click(Sender: TObject);
begin
  BtnShellClick(Sender);
end;

procedure TMainForm.MnuRoot2Click(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile('explorer.exe', '"' + Nexagon.DocumentRoot + '"');
end;

procedure TMainForm.MenuNexagonDirUserClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile('explorer.exe', '"' + Nexagon.GetUsrDir + '"');
end;

procedure TMainForm.MnuUserProfileCmdClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenFileInNotepadPP(Nexagon.GetUsrDir + '\Procfile');
end;

procedure TMainForm.MnuNexagonIniClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenFileInNotepadPP(Nexagon.GetIniPath);
end;

procedure TMainForm.MnuNexagonLogClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenFileInNotepadPP(IncludeTrailingPathDelimiter(Nexagon.GetTmpDir) + 'nexagon.log');
end;

procedure TMainForm.MnuMemcachedAdminClick(Sender: TObject);
begin
  OpenUrlOrFile('http://localhost/memcached');
end;

procedure TMainForm.MnuRedisAdminClick(Sender: TObject);
begin
  OpenUrlOrFile('http://localhost/phpredisadmin');
end;

procedure TMainForm.MnuRedisCliClick(Sender: TObject);
begin
  if Assigned(SrvRedis) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(SrvRedis.GetVersionDir) + 'redis-cli.exe');
end;

procedure TMainForm.MnuRedisConfigFileClick(Sender: TObject);
begin
  if Assigned(SrvRedis) then
    OpenFileInNotepadPP(SrvRedis.GetConfigPath);
end;

procedure TMainForm.MnuGoGOPATHClick(Sender: TObject);
begin
  if Assigned(SrvGo) then
    OpenUrlOrFile('explorer.exe', '"' + SrvGo.GetGoPath + '"');
end;

procedure TMainForm.MnuGoGOROOTClick(Sender: TObject);
begin
  if Assigned(SrvGo) then
    OpenUrlOrFile('explorer.exe', '"' + SrvGo.GetGoRoot + '"');
end;

procedure TMainForm.MnuGoLiteIDEClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\liteide\bin\liteide.exe');
end;

procedure TMainForm.MnuPythonIDLEClick(Sender: TObject);
begin
  if Assigned(SrvPython) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(SrvPython.GetVersionDir) + 'Lib\idlelib\idle.bat');
end;

procedure TMainForm.MnuPythonHelpClick(Sender: TObject);
begin
  OpenUrlOrFile('https://docs.python.org/3/');
end;

procedure TMainForm.MnuJavaClick(Sender: TObject);
begin
  // Submenu
end;

procedure TMainForm.MnuJavaEclipseClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\eclipse\eclipse.exe');
end;

procedure TMainForm.MnuJavaSTSClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
    OpenUrlOrFile(IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'bin\sts\STS.exe');
end;

{ Timers & Remaining Event Handlers }

procedure TMainForm.TimerLazyStartTimer(Sender: TObject);
begin
  TimerLazyStart.Enabled := False;
  BtnStartAllClick(Sender);
end;

procedure TMainForm.TimerMinimizedTimer(Sender: TObject);
begin
  TimerMinimized.Enabled := False;
  Hide;
end;

procedure TMainForm.TimerLazyLongTimer(Sender: TObject);
begin
  TimerLazyLong.Enabled := False;
  PanelNotification.Visible := False;
end;

procedure TMainForm.TimerNetStatTimer(Sender: TObject);
begin
  UpdateServiceAndMenuStates;
end;

procedure TMainForm.TimerAutoBackupTimer(Sender: TObject);
var
  BackupDir: string;
begin
  if Assigned(Nexagon) and Nexagon.AutoBackup and Assigned(SrvMySQL) and SrvMySQL.Running then
    SrvMySQL.BackupAllDatabases(BackupDir);
end;

procedure TMainForm.TimerGenSSLTimer(Sender: TObject);
begin
  TimerGenSSL.Enabled := False;
  if Assigned(Nexagon) then
    Nexagon.EnsureSslCertificates;
end;

procedure TMainForm.TimerStartPostgreSQLTimer(Sender: TObject);
begin
  TimerStartPostgreSQL.Enabled := False;
  if Assigned(SrvPostgreSQL) then
    SrvPostgreSQL.StartService;
end;

procedure TMainForm.TimerMonitorNginxPHPUpstreamTimer(Sender: TObject);
begin
  if Assigned(SrvNginx) and SrvNginx.Running and Assigned(Nexagon) then
    Nexagon.EnsureNginxPhpUpstreamRunning;
end;

procedure TMainForm.TimerMustRestartTimer(Sender: TObject);
begin
  TimerMustRestart.Enabled := False;
end;

procedure TMainForm.TimerForceCloseTimer(Sender: TObject);
begin
  TimerForceClose.Enabled := False;
  FAllowExit := True;
  Close;
end;

procedure TMainForm.TimerLicenseKeyCheckTimer(Sender: TObject);
begin
  TimerLicenseKeyCheck.Enabled := False;
end;

procedure TMainForm.TimerValidateLicenseTimer(Sender: TObject);
begin
  TimerValidateLicense.Enabled := False;
end;

procedure TMainForm.TimerAutoUpdateTimer(Sender: TObject);
begin
  TimerAutoUpdate.Enabled := False;
end;

procedure TMainForm.TimerAutoUpdateCurlCacertTimer(Sender: TObject);
begin
  TimerAutoUpdateCurlCacert.Enabled := False;
end;

{ Legacy / Auxiliary Handlers }

procedure TMainForm.BtnCheckServiceClick(Sender: TObject);
begin
  UpdateServiceAndMenuStates;
end;

procedure TMainForm.BtnDebugTestClick(Sender: TObject);
begin
  // Debug no-op
end;

procedure TMainForm.BtnLicenseMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FormLicense) then FormLicense.Show;
end;

procedure TMainForm.Button1Click(Sender: TObject); begin end;
procedure TMainForm.Button2Click(Sender: TObject); begin end;
procedure TMainForm.Button3Click(Sender: TObject);
begin
  if Assigned(FormConsole) then FormConsole.Show;
end;
procedure TMainForm.Button4Click(Sender: TObject);
begin
  MnuMySQLBackupAllDatabasesClick(Sender);
end;
procedure TMainForm.Button5Click(Sender: TObject); begin end;
procedure TMainForm.Button6Click(Sender: TObject); begin end;
procedure TMainForm.Button7Click(Sender: TObject); begin end;
procedure TMainForm.Button8Click(Sender: TObject); begin end;
procedure TMainForm.LabelCreatorClick(Sender: TObject);
begin
  OpenUrlOrFile('https://nexagon.org');
end;
procedure TMainForm.LabelDonateClick(Sender: TObject);
begin
  OpenUrlOrFile('https://nexagon.org');
end;
procedure TMainForm.LabelDonateMouseEnter(Sender: TObject); begin end;
procedure TMainForm.LabelDonateMouseLeave(Sender: TObject); begin end;
procedure TMainForm.LabelDonationNoClick(Sender: TObject); begin end;
procedure TMainForm.LabelGetLicenseLinkClick(Sender: TObject);
begin
  if Assigned(FormLicense) then FormLicense.Show;
end;
procedure TMainForm.LabelGetLicenseLinkMouseEnter(Sender: TObject); begin end;
procedure TMainForm.LabelGetLicenseLinkMouseLeave(Sender: TObject); begin end;
procedure TMainForm.LabelQuoteClick(Sender: TObject); begin end;
procedure TMainForm.LabelSloganDelClick(Sender: TObject); begin end;
procedure TMainForm.LabelXipIOClick(Sender: TObject);
begin
  if Assigned(FormVirtualHosts) then
  begin
    FormVirtualHosts.RefreshVirtualHostsList;
    FormVirtualHosts.Show;
  end;
end;
procedure TMainForm.MnuApacheSSLClick(Sender: TObject); begin end;
procedure TMainForm.MnuNginxSSLClick(Sender: TObject); begin end;
procedure TMainForm.MnuMySQLClick(Sender: TObject); begin end;
procedure TMainForm.MnuLaravelClick(Sender: TObject); begin end;
procedure TMainForm.MnuLaravelConfigDirClick(Sender: TObject); begin end;
procedure TMainForm.MnuLaravelControllersDirClick(Sender: TObject); begin end;
procedure TMainForm.MnuLaravelCurrentProjectClick(Sender: TObject); begin end;
procedure TMainForm.MnuLaravelLogsDirClick(Sender: TObject); begin end;
procedure TMainForm.MnuLaravelPublicDirClick(Sender: TObject); begin end;
procedure TMainForm.MnuLaravelRouteFileClick(Sender: TObject); begin end;
procedure TMainForm.MnuCreateLaravel4Click(Sender: TObject); begin end;
procedure TMainForm.MnuCreateLaravel5Click(Sender: TObject); begin end;
procedure TMainForm.MnuCreateLumenClick(Sender: TObject); begin end;
procedure TMainForm.MnuQuickCloudServerClick(Sender: TObject); begin end;
procedure TMainForm.MnuQuickCSRegionASClick(Sender: TObject); begin end;
procedure TMainForm.MnuQuickCSRegionEUClick(Sender: TObject); begin end;
procedure TMainForm.MnuQuickCSRegionUSClick(Sender: TObject); begin end;
procedure TMainForm.MnuQuickCSSSHClick(Sender: TObject); begin end;
procedure TMainForm.MnuRunApacheasWindowsServiceClick(Sender: TObject); begin end;
procedure TMainForm.PanelRuntimeInfoClick(Sender: TObject); begin end;
procedure TMainForm.btnCalculateClick(Sender: TObject);
var
  Plan: TCronSchedulePlan;
  I: Integer;
  BaseTime: TDateTime;
begin
  Plan := TCronSchedulePlan.Create;
  try
    Plan.Parse(edCronString.Text);
    memCalculatedIntervals.Lines.BeginUpdate;
    try
      memCalculatedIntervals.Clear;
      BaseTime := Now;
      for I := 1 to 10 do
      begin
        BaseTime := IncMinute(BaseTime, 5);
        memCalculatedIntervals.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', BaseTime));
      end;
    finally
      memCalculatedIntervals.Lines.EndUpdate;
    end;
  finally
    Plan.Free;
  end;
end;

procedure TMainForm.btnSamplesClick(Sender: TObject);
begin
  if Assigned(popSamples) then
    popSamples.PopUp;
end;

procedure TMainForm.edCronStringChange(Sender: TObject);
var
  Plan: TCronSchedulePlan;
begin
  Plan := TCronSchedulePlan.Create;
  try
    Plan.Parse(edCronString.Text);
    edMinute.Text := Plan.Minute.RawValue;
    edHour.Text := Plan.Hour.RawValue;
    edDayOfMonth.Text := Plan.DayOfMonth.RawValue;
    edMonthOfYear.Text := Plan.MonthOfYear.RawValue;
    edDayOfTheWeek.Text := Plan.DayOfWeek.RawValue;
    edYear.Text := Plan.Year.RawValue;
    edSecond.Text := Plan.Second.RawValue;
    edExecutionLimit.Text := Plan.ExecutionLimit.RawValue;
  finally
    Plan.Free;
  end;
end;

end.
