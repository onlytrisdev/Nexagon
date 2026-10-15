unit FMailAnalyzer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Process, Services;

type
  TFormMailAnalyzer = class(TForm)
  published
    PanelBottom: TPanel;
    CommandRun: TComboBox;
    PanelRight: TPanel;
    LabelSendTestMailTo: TLabel;
    EditTo: TEdit;
    BtnReTest: TButton;
    BtnClose: TButton;
    PanelTop: TPanel;
    CommandText: TMemo;
    SaveDialog1: TSaveDialog;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnReTestClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
  public
    procedure RunMailAnalyzerTest;
  end;

var
  FormMailAnalyzer: TFormMailAnalyzer;

implementation

{$R *.lfm}

procedure TFormMailAnalyzer.FormCreate(Sender: TObject);
begin
  Width := 800;
  Height := 600;
  CommandText.Clear;
  BtnReTest.Enabled := True;
  BtnReTest.ShowHint := True;
  BtnClose.ShowHint := True;
end;

procedure TFormMailAnalyzer.FormShow(Sender: TObject);
begin
  if Assigned(Nexagon) then
  begin
    Caption := Nexagon.T(350, 'Mail Analyzer');
    LabelSendTestMailTo.Caption := Nexagon.T(351, 'Send test mail to:');
    BtnReTest.Caption := Nexagon.T(352, 'Re-test');
    BtnClose.Caption := Nexagon.T(354, 'Close');
    if (EditTo.Text = '') and (Nexagon.GmailAddress <> '') then
      EditTo.Text := Nexagon.GmailAddress;
  end;
  LabelSendTestMailTo.Left := (EditTo.Left - LabelSendTestMailTo.Width) - 5;
end;

procedure TFormMailAnalyzer.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caHide;
end;

procedure TFormMailAnalyzer.FormDestroy(Sender: TObject);
begin
  // Cleanup if needed
end;

procedure TFormMailAnalyzer.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMailAnalyzer.BtnReTestClick(Sender: TObject);
begin
  RunMailAnalyzerTest;
end;

procedure TFormMailAnalyzer.RunMailAnalyzerTest;
var
  Recipient, TestPhpPath, PhpExe: string;
  SL, OutSL: TStringList;
  P: TProcess;
begin
  Recipient := Trim(EditTo.Text);
  if (Recipient = '') or (Pos('@', Recipient) = 0) then
  begin
    if Assigned(Nexagon) then
      MessageDlg(Nexagon.T(213, 'Please enter a valid email address'), mtWarning, [mbOK], 0);
    EditTo.SetFocus;
    Exit;
  end;

  CommandText.Clear;
  CommandText.Lines.Add('Running Mail Analyzer for: ' + Recipient + '...');
  if not Assigned(Nexagon) or not Assigned(SrvPHP) then Exit;

  TestPhpPath := IncludeTrailingPathDelimiter(Nexagon.GetTmpDir) + 'mail_analyzer_test.php';
  SL := TStringList.Create;
  try
    SL.Text := Nexagon.GenerateMailTestScript(Recipient);
    SL.SaveToFile(TestPhpPath);
  finally
    SL.Free;
  end;

  PhpExe := SrvPHP.GetExePath;
  if FileExists(PhpExe) then
  begin
    P := TProcess.Create(nil);
    OutSL := TStringList.Create;
    try
      P.Executable := PhpExe;
      P.Parameters.Add(TestPhpPath);
      P.CurrentDirectory := Nexagon.GetTmpDir;
      P.Options := [poUsePipes, poStderrToOutPut, poNoConsole];
      P.ShowWindow := swoHide;
      P.Execute;
      while P.Running do
        Sleep(10);
      OutSL.LoadFromStream(P.Output);
      CommandText.Lines.AddStrings(OutSL);
    finally
      OutSL.Free;
      P.Free;
    end;
  end
  else
    CommandText.Lines.Add('Error: php.exe not found at ' + PhpExe);
end;

end.
