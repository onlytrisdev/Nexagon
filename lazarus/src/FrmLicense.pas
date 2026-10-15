unit FrmLicense;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  Services;

type
  TFormLicense = class(TForm)
  published
    LabelYourLicenseKey: TLabel;
    LabelGetLicenseKey: TLabel;
    LabelTrial: TLabel;
    EditLicenseKey: TEdit;
    BtnVerifyLicense: TButton;
    Button1: TButton;
    PopupMenuGetLicenseKey: TPopupMenu;
    MnuNexagonLifetime: TMenuItem;
    MnuNexagon1year1: TMenuItem;
    N1: TMenuItem;
    MnuNexagonNonCommerciallicenseStandard1: TMenuItem;
    MnuNexagonNonCommerciallicenseExtended1: TMenuItem;
    N2: TMenuItem;
    MnuAlllicenses1: TMenuItem;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LabelGetLicenseKeyClick(Sender: TObject);
    procedure LabelTrialClick(Sender: TObject);
    procedure BtnVerifyLicenseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure MnuNexagonLifetimeClick(Sender: TObject);
    procedure MnuNexagon1year1Click(Sender: TObject);
    procedure MnuNexagonNonCommerciallicenseStandard1Click(Sender: TObject);
    procedure MnuNexagonNonCommerciallicenseExtended1Click(Sender: TObject);
    procedure MnuAlllicenses1Click(Sender: TObject);
  end;

var
  FormLicense: TFormLicense;

implementation

{$R *.lfm}

procedure TFormLicense.FormCreate(Sender: TObject);
begin
  Color := clWhite;
  Width := 831;
end;

procedure TFormLicense.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caHide;
end;

procedure TFormLicense.LabelGetLicenseKeyClick(Sender: TObject);
begin
  PopupMenuGetLicenseKey.PopUp;
end;

procedure TFormLicense.LabelTrialClick(Sender: TObject);
begin
  Close;
end;

procedure TFormLicense.BtnVerifyLicenseClick(Sender: TObject);
begin
  MessageDlg('Nexagon Open Source Edition', 'License verified: Perpetual Activated Edition.', mtInformation, [mbOK], 0);
  Close;
end;

procedure TFormLicense.Button1Click(Sender: TObject);
begin
  BtnVerifyLicenseClick(Sender);
end;

procedure TFormLicense.MnuNexagonLifetimeClick(Sender: TObject);
begin
  OpenUrlOrFile('https://nexagon.org');
end;

procedure TFormLicense.MnuNexagon1year1Click(Sender: TObject);
begin
  OpenUrlOrFile('https://nexagon.org');
end;

procedure TFormLicense.MnuNexagonNonCommerciallicenseStandard1Click(Sender: TObject);
begin
  OpenUrlOrFile('https://nexagon.org');
end;

procedure TFormLicense.MnuNexagonNonCommerciallicenseExtended1Click(Sender: TObject);
begin
  OpenUrlOrFile('https://nexagon.org');
end;

procedure TFormLicense.MnuAlllicenses1Click(Sender: TObject);
begin
  OpenUrlOrFile('https://nexagon.org');
end;

end.
