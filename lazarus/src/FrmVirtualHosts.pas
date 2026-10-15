unit FrmVirtualHosts;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Services;

type
  TFormVirtualHosts = class(TForm)
  published
    PanelTop: TPanel;
    LVH: TListView;
    PanelBottom: TPanel;
    BtnOK: TButton;
    BtnCancel: TButton;
    CheckBox2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  public
    procedure RefreshVirtualHostsList;
  end;

var
  FormVirtualHosts: TFormVirtualHosts;

implementation

{$R *.lfm}

procedure TFormVirtualHosts.FormCreate(Sender: TObject);
begin
  LVH.Columns[0].Width := 1;
  LVH.Columns[1].Width := 28;
  LVH.Columns[2].Width := 250;
  LVH.Columns[3].Width := 250;
  RefreshVirtualHostsList;
end;

procedure TFormVirtualHosts.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormVirtualHosts.RefreshVirtualHostsList;
var
  SR: TSearchRec;
  Dir, SiteName: string;
  Idx: Integer;
  Item: TListItem;
begin
  LVH.Items.Clear;
  if not Assigned(Nexagon) then Exit;
  Dir := IncludeTrailingPathDelimiter(Nexagon.RootDir) + 'etc\apache2\sites-enabled\';
  Idx := 0;
  if FindFirst(Dir + '*.conf', faAnyFile, SR) = 0 then
  begin
    repeat
      Inc(Idx);
      SiteName := ChangeFileExt(SR.Name, '');
      if Pos('auto.', LowerCase(SiteName)) = 1 then
        Delete(SiteName, 1, 5);
      Item := LVH.Items.Add;
      Item.Caption := '';
      Item.SubItems.Add(IntToStr(Idx));
      Item.SubItems.Add('http://' + SiteName);
      Item.SubItems.Add('http://' + SiteName + '.127.0.0.1.nip.io');
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

end.
