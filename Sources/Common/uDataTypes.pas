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



implementation



end.
