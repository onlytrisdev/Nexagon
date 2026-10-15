unit maxCron;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateUtils;

type
  TCronPart = class(TObject)
  public
    RawValue: string;
    constructor Create(const AValue: string = '*');
  end;

  TCronSchedulePlan = class(TObject)
  public
    Minute: TCronPart;
    Hour: TCronPart;
    DayOfMonth: TCronPart;
    MonthOfYear: TCronPart;
    DayOfWeek: TCronPart;
    Year: TCronPart;
    Second: TCronPart;
    ExecutionLimit: TCronPart;
    constructor Create;
    destructor Destroy; override;
    procedure Parse(const CronText: string);
  end;

  TmaxCronEvent = class(TObject)
  public
    Name: string;
    EventPlan: string;
    Plan: TCronSchedulePlan;
    OnScheduleEvent: TNotifyEvent;
    Enabled: Boolean;
    LastRun: TDateTime;
    constructor Create;
    destructor Destroy; override;
  end;

  TmaxCron = class(TObject)
  private
    FEvents: TList;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const AName: string): TmaxCronEvent;
    procedure Clear;
  end;

implementation

constructor TCronPart.Create(const AValue: string);
begin
  inherited Create;
  RawValue := AValue;
end;

constructor TCronSchedulePlan.Create;
begin
  inherited Create;
  Minute := TCronPart.Create('*');
  Hour := TCronPart.Create('*');
  DayOfMonth := TCronPart.Create('*');
  MonthOfYear := TCronPart.Create('*');
  DayOfWeek := TCronPart.Create('*');
  Year := TCronPart.Create('*');
  Second := TCronPart.Create('0');
  ExecutionLimit := TCronPart.Create('0');
end;

destructor TCronSchedulePlan.Destroy;
begin
  Minute.Free;
  Hour.Free;
  DayOfMonth.Free;
  MonthOfYear.Free;
  DayOfWeek.Free;
  Year.Free;
  Second.Free;
  ExecutionLimit.Free;
  inherited Destroy;
end;

procedure TCronSchedulePlan.Parse(const CronText: string);
var
  Parts: TStringList;
begin
  Parts := TStringList.Create;
  try
    Parts.Delimiter := ' ';
    Parts.StrictDelimiter := False;
    Parts.DelimitedText := Trim(CronText);
    if Parts.Count > 0 then Minute.RawValue := Parts[0];
    if Parts.Count > 1 then Hour.RawValue := Parts[1];
    if Parts.Count > 2 then DayOfMonth.RawValue := Parts[2];
    if Parts.Count > 3 then MonthOfYear.RawValue := Parts[3];
    if Parts.Count > 4 then DayOfWeek.RawValue := Parts[4];
    if Parts.Count > 5 then Year.RawValue := Parts[5];
    if Parts.Count > 6 then Second.RawValue := Parts[6];
    if Parts.Count > 7 then ExecutionLimit.RawValue := Parts[7];
  finally
    Parts.Free;
  end;
end;

constructor TmaxCronEvent.Create;
begin
  inherited Create;
  Plan := TCronSchedulePlan.Create;
  EventPlan := '* * * * * * 0 0';
  Enabled := False;
  LastRun := 0;
end;

destructor TmaxCronEvent.Destroy;
begin
  Plan.Free;
  inherited Destroy;
end;

constructor TmaxCron.Create;
begin
  inherited Create;
  FEvents := TList.Create;
end;

destructor TmaxCron.Destroy;
begin
  Clear;
  FEvents.Free;
  inherited Destroy;
end;

function TmaxCron.Add(const AName: string): TmaxCronEvent;
begin
  Result := TmaxCronEvent.Create;
  Result.Name := AName;
  FEvents.Add(Result);
end;

procedure TmaxCron.Clear;
var
  I: Integer;
begin
  for I := 0 to FEvents.Count - 1 do
    TObject(FEvents[I]).Free;
  FEvents.Clear;
end;

end.
