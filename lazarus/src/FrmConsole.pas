unit FrmConsole;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, Process, Services;

type
  TFormConsole = class(TForm)
  published
    PanelMain: TPanel;
    Button1: TButton;
    PanelMenu: TPanel;
    LabelMenu: TLabel;
    CommandText: TMemo;
    PopupMenuConsole: TPopupMenu;
    Procfile1: TMenuItem;
    EnvironmentVariables1: TMenuItem;
    Console1: TMenuItem;
    N1: TMenuItem;
    Alwaysontop1: TMenuItem;
    ShowCommand1: TMenuItem;
    AutoScroll1: TMenuItem;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure LabelMenuClick(Sender: TObject);
    procedure LabelMenuMouseEnter(Sender: TObject);
    procedure LabelMenuMouseLeave(Sender: TObject);
    procedure Console1Click(Sender: TObject);
    procedure CommandTextMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  public
    procedure RunCommandToConsole(const CmdLine: string);
  end;

var
  FormConsole: TFormConsole;

implementation

{$R *.lfm}

procedure TFormConsole.FormCreate(Sender: TObject);
begin
  PanelMenu.ShowHint := True;
  PanelMenu.Color := CommandText.Color;
  LabelMenu.Color := PanelMenu.Color;
  CommandText.OnMouseUp := @CommandTextMouseUp;
end;

procedure TFormConsole.FormResize(Sender: TObject);
begin
  PanelMenu.Top := 1;
  PanelMenu.Left := (ClientWidth - PanelMenu.Width) - 24;
  LabelMenu.Top := 1;
  LabelMenu.Left := 1;
end;

procedure TFormConsole.FormShow(Sender: TObject);
begin
  FormResize(Sender);
  if CommandText.Lines.Count = 0 then
    CommandText.Lines.Add('Nexagon Console Ready.');
end;

procedure TFormConsole.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caHide;
end;

procedure TFormConsole.Button1Click(Sender: TObject);
begin
  if Assigned(SrvCmder) then
    SrvCmder.OpenTerminal;
end;

procedure TFormConsole.LabelMenuClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt := LabelMenu.ClientToScreen(Point(0, LabelMenu.Height));
  PopupMenuConsole.PopUp(Pt.X, Pt.Y);
end;

procedure TFormConsole.LabelMenuMouseEnter(Sender: TObject);
begin
  LabelMenu.Font.Style := [fsUnderline];
end;

procedure TFormConsole.LabelMenuMouseLeave(Sender: TObject);
begin
  LabelMenu.Font.Style := [];
end;

procedure TFormConsole.Console1Click(Sender: TObject);
begin
  if Assigned(SrvCmder) then
    SrvCmder.OpenTerminal;
end;

procedure TFormConsole.CommandTextMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    PopupMenuConsole.PopUp;
end;

procedure TFormConsole.RunCommandToConsole(const CmdLine: string);
var
  P: TProcess;
  OutSL: TStringList;
  Mem: TMemoryStream;
  Buf: array[0..4095] of Byte;
  N: LongInt;
begin
  CommandText.Lines.Add('> ' + CmdLine);
  P := TProcess.Create(nil);
  OutSL := TStringList.Create;
  Mem := TMemoryStream.Create;
  try
    P.Executable := 'cmd.exe';
    P.Parameters.Add('/c');
    P.Parameters.Add(CmdLine);
    if Assigned(Nexagon) then
      P.CurrentDirectory := Nexagon.DocumentRoot;
    P.Options := [poUsePipes, poStderrToOutPut, poNoConsole];
    P.ShowWindow := swoHide;
    P.Execute;
    while P.Running or (P.Output.NumBytesAvailable > 0) do
    begin
      if P.Output.NumBytesAvailable > 0 then
      begin
        N := P.Output.Read(Buf, SizeOf(Buf));
        if N > 0 then
          Mem.WriteBuffer(Buf, N);
      end
      else
        Sleep(10);
    end;
    Mem.Position := 0;
    OutSL.LoadFromStream(Mem);
    CommandText.Lines.AddStrings(OutSL);
  finally
    Mem.Free;
    OutSL.Free;
    P.Free;
  end;
end;

end.
