{$INCLUDE dcDataTypes.inc}

unit uDataTypes;

interface

type
  // ��� ������, � ������� ������ ��������� ��������
  {$IFDEF VALUE_IS_DOUBLE}
  TSensorValue = Double;
  {$ELSE}
  TSensorValue = Extended;
  {$ENDIF}

  PSensorValue = ^TSensorValue;


  // ������, � ������� ������ ��������� � ����� ������
  TSensorDataRec = packed record
    Time: TDateTime;
    Value: TSensorValue;
  end;
  PSensorDataRec = ^TSensorDataRec;

  // ������ �� ������ ������� + ���������� �� ������
  TSensorHistDataRec = packed record
    Time: TDateTime;
    Value, Error: TSensorValue;
  end;

  // ������ �������
  TSensorDataArr = array of TSensorDataRec;

const
  cSensorDataRecSize = SizeOf(TSensorDataRec);

function DataArrToString(aDataArr: TSensorDataArr): string;



implementation

uses
  SynCommons;


function DataArrToString(aDataArr: TSensorDataArr): string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(aDataArr) to High(aDataArr) do
    Result := Result + UTF8ToString(DateTimeToIso8601(aDataArr[i].Time, True)) + ';' + DoubleToString(aDataArr[i].Value) + ';';
end;




end.
