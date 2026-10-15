unit Procfile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process, Windows;

type
  TEnvVar = class(TObject)
  public
    Key: string;
    Value: string;
    constructor Create(const AKey, AValue: string);
  end;

  TProcfileProcess = class(TObject)
  public
    Name: string;
    Command: string;
    AlwaysShow: Boolean;
    Enabled: Boolean;
    Proc: TProcess;
    constructor Create(const AName, ACommand: string; AAlwaysShow: Boolean = False);
    destructor Destroy; override;
    function Run(const WorkDir, PathEnv: string): Boolean;
    procedure Stop;
  end;

  procedure RunProcfileEntries(const ProcfilePath, WorkDir, PathEnv: string);

implementation

constructor TEnvVar.Create(const AKey, AValue: string);
begin
  inherited Create;
  Key := AKey;
  Value := AValue;
end;

constructor TProcfileProcess.Create(const AName, ACommand: string; AAlwaysShow: Boolean);
begin
  inherited Create;
  Name := AName;
  Command := ACommand;
  AlwaysShow := AAlwaysShow;
  Enabled := True;
  Proc := nil;
end;

destructor TProcfileProcess.Destroy;
begin
  Stop;
  inherited Destroy;
end;

function TProcfileProcess.Run(const WorkDir, PathEnv: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  if Trim(Command) = '' then Exit;
  Stop;
  Proc := TProcess.Create(nil);
  try
    Proc.Executable := 'cmd.exe';
    Proc.Parameters.Add('/c');
    Proc.Parameters.Add(Command);
    if (WorkDir <> '') and DirectoryExists(WorkDir) then
      Proc.CurrentDirectory := WorkDir;
    for I := 1 to GetEnvironmentVariableCount do
      Proc.Environment.Add(GetEnvironmentString(I));
    if PathEnv <> '' then
      Proc.Environment.Values['PATH'] := PathEnv;
    if AlwaysShow then
      Proc.ShowWindow := swoShowNormal
    else
      Proc.ShowWindow := swoHide;
    Proc.Options := [];
    Proc.Execute;
    Result := True;
  except
    FreeAndNil(Proc);
  end;
end;

procedure TProcfileProcess.Stop;
begin
  if Assigned(Proc) then
  begin
    try
      if Proc.Running then
        Proc.Terminate(0);
    except
    end;
    FreeAndNil(Proc);
  end;
end;

procedure RunProcfileEntries(const ProcfilePath, WorkDir, PathEnv: string);
var
  Lines: TStringList;
  I, P: Integer;
  Line, Name, Cmd: string;
  AlwaysShow: Boolean;
  Entry: TProcfileProcess;
begin
  if not FileExists(ProcfilePath) then Exit;
  Lines := TStringList.Create;
  try
    Lines.LoadFromFile(ProcfilePath);
    for I := 0 to Lines.Count - 1 do
    begin
      Line := Trim(Lines[I]);
      if (Line = '') or (Line[1] = '#') or (Line[1] = ';') then Continue;
      AlwaysShow := False;
      if Pos('!', Line) = 1 then
      begin
        AlwaysShow := True;
        Delete(Line, 1, 1);
      end;
      P := Pos(':', Line);
      if P > 0 then
      begin
        Name := Trim(Copy(Line, 1, P - 1));
        Cmd := Trim(Copy(Line, P + 1, MaxInt));
      end
      else
      begin
        Name := 'proc_' + IntToStr(I + 1);
        Cmd := Line;
      end;
      if Cmd <> '' then
      begin
        Entry := TProcfileProcess.Create(Name, Cmd, AlwaysShow);
        try
          Entry.Run(WorkDir, PathEnv);
        finally
          // Keep process detached; free wrapper
          Entry.Proc := nil;
          Entry.Free;
        end;
      end;
    end;
  finally
    Lines.Free;
  end;
end;

end.
