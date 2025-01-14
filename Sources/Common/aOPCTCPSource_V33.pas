unit aOPCTCPSource_V33;

interface

uses
  Classes,
  aOPCTCPSource_V30,
  uSCSTypes;

type
  TaOPCTCPSource_V33 = class(TaOPCTCPSource_V30)
  public
    constructor Create(aOwner: TComponent); override;

    function CreateClient(aClientID: Integer): Integer;
    function CreateTracker(aClientID: Integer; const aTrackerSID, aTrackerLogin,
  aProtoSID: string; aInherit: Boolean): Integer;
    procedure AddOrUpdateSCSTracker(aParams: TAddTrackerParamsDTO);
    procedure DeleteSCSTracker(aSID: string);
  end;


implementation

uses
  System.SysUtils,
  SynCrossPlatformJSON;
//  SynCommons;

{ TaOPCTCPSource_V33 }

procedure TaOPCTCPSource_V33.AddOrUpdateSCSTracker(aParams: TAddTrackerParamsDTO);
var
  s: string;
  j: TJSONVariantData;
begin
  j.Init;
  j.SetPath('Operation', aParams.Operation);
  j.SetPath('ClientName', aParams.ClientName);
  j.SetPath('ClientSID', aParams.ClientSID);
  j.SetPath('TrackerName', aParams.TrackerName);
  j.SetPath('TrackerType', aParams.TrackerType);
  j.SetPath('TrackerModel', aParams.TrackerModel);
  j.SetPath('TrackerLogin', aParams.TrackerLogin);
  j.SetPath('GPS', aParams.GPS);
  j.SetPath('Ignition', aParams.Ignition);
  j.SetPath('CAN300', aParams.CAN300);
  j.SetPath('FLCount', aParams.FLCount);
  j.SetPath('DistanceTO', aParams.DistanceTO);
  j.SetPath('DistanceTrip', aParams.DistanceTrip);
  j.SetPath('Location', aParams.Location);
  j.SetPath('LocationFileName', aParams.LocationFileName);
  s := j.ToJSON;

//  s :=  UTF8DecodeToUnicodeString(RecordSaveJSON(aParams, TypeInfo(TAddTrackerParamsDTO)));
  LockAndDoCommandFmt('AddOrUpdateSCSTracker %s', [s]);
end;

constructor TaOPCTCPSource_V33.Create(aOwner: TComponent);
begin
  inherited;
  ProtocolVersion := 33;
end;

function TaOPCTCPSource_V33.CreateClient(aClientID: Integer): Integer;
begin
  Result := StrToInt(LockDoCommandReadLnFmt('CreateClient %d', [aClientID]));
end;

function TaOPCTCPSource_V33.CreateTracker(aClientID: Integer; const aTrackerSID, aTrackerLogin,
  aProtoSID: string; aInherit: Boolean): Integer;
begin
  Result := StrToInt(LockDoCommandReadLnFmt('CreateTracker %d;%s;%s;%s;%s',
    [aClientID, aTrackerSID, aTrackerLogin, aProtoSID, BoolToStr(aInherit, False)]));
end;

procedure TaOPCTCPSource_V33.DeleteSCSTracker(aSID: string);
begin
  LockAndDoCommandFmt('DeleteSCSTracker %s', [aSID]);
end;

end.
