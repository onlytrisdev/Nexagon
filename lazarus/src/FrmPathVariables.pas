unit FrmPathVariables;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, Services;

type
  TFormPathVariables = class(TForm)
  published
    MemoPathVariables: TMemo;
    PanelMenu: TPanel;
    LabelMenu: TLabel;
    PopupMenuPATHVariable: TPopupMenu;
    MnuAddToUserPath: TMenuItem;
    MnuRemoveFromUserPath: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabelMenuClick(Sender: TObject);
    procedure LabelMenuMouseEnter(Sender: TObject);
    procedure LabelMenuMouseLeave(Sender: TObject);
    procedure MnuAddToUserPathClick(Sender: TObject);
    procedure MnuRemoveFromUserPathClick(Sender: TObject);
  public
    procedure RefreshPathDisplay;
  end;

var
  FormPathVariables: TFormPathVariables;

implementation

{$R *.lfm}

procedure TFormPathVariables.FormCreate(Sender: TObject);
begin
  PanelMenu.ShowHint := True;
  PanelMenu.Color := MemoPathVariables.Color;
  LabelMenu.Color := PanelMenu.Color;
end;

procedure TFormPathVariables.FormShow(Sender: TObject);
begin
  if Assigned(Nexagon) then
  begin
    Caption := Nexagon.T(152, 'Manage Path');
    MnuAddToUserPath.Caption := Nexagon.T(150, 'Add Nexagon to Path');
    MnuRemoveFromUserPath.Caption := Nexagon.T(151, 'Remove Nexagon from Path');
  end;
  RefreshPathDisplay;
end;

procedure TFormPathVariables.RefreshPathDisplay;
begin
  if Assigned(Nexagon) then
    MemoPathVariables.Text := Nexagon.GetPathVariablesReport;
end;

procedure TFormPathVariables.LabelMenuClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt := LabelMenu.ClientToScreen(Point(0, LabelMenu.Height));
  PopupMenuPATHVariable.PopUp(Pt.X, Pt.Y);
end;

procedure TFormPathVariables.LabelMenuMouseEnter(Sender: TObject);
begin
  LabelMenu.Font.Style := [fsUnderline];
end;

procedure TFormPathVariables.LabelMenuMouseLeave(Sender: TObject);
begin
  LabelMenu.Font.Style := [];
end;

procedure TFormPathVariables.MnuAddToUserPathClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
  begin
    Nexagon.AddNexagonToUserPath;
    RefreshPathDisplay;
  end;
end;

procedure TFormPathVariables.MnuRemoveFromUserPathClick(Sender: TObject);
begin
  if Assigned(Nexagon) then
  begin
    Nexagon.RemoveNexagonFromUserPath;
    RefreshPathDisplay;
  end;
end;

end.
