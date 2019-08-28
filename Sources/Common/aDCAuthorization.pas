unit aDCAuthorization;

interface

uses
  System.Classes,
  FMX.Forms,
  aOPCSource;

const
  EncryptKey = 77;

type
  TaDCAuthorization = class(TComponent)
  private
    FUser: string;
    FPermissions: string;
    FOPCSource: TaOPCSource;
    FPassword: string;
    procedure SetUser(const Value: string);
    procedure SetPermissions(const Value: string);
    procedure SetOPCSource(const Value: TaOPCSource);
    procedure SetPassword(const Value: string);
    function GetEncryptedPassword: string;
    procedure SetEncryptedPassword(const Value: string);

    function Encrypt(Value: string): string;
  protected
    FTimeStamp: TDateTime;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property Permissions: string read FPermissions write SetPermissions;
    property EncryptedPassword: string read GetEncryptedPassword write SetEncryptedPassword;

    function Execute(aParent: TCustomForm = nil; aShowInTaskBar: boolean = false): boolean;

    function CheckPermissions: boolean;
    function Login: boolean;

    procedure ReadCommandLine;
    procedure ReadCommandLineExt;

    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OPCSource: TaOPCSource read FOPCSource write SetOPCSource;
    property User: string read FUser write SetUser;
    property Password: string read FPassword write SetPassword;
  end;


implementation

uses
  System.UITypes, System.SysUtils,
  FMX.Dialogs,
  uUserChoice;

{ TaOPCAuthorization }

function TaDCAuthorization.CheckPermissions: boolean;
begin
  Result := false;
  try
    Permissions := '';
    if User <> '' then
      Permissions := OPCSource.GetUserPermission(User, Password, '');
    Result := Permissions <> '';

//    Result := OPCSource.Login(User, Password);

  except
    on e: Exception do
      ;
  end;
end;

constructor TaDCAuthorization.Create(aOwner: TComponent);
begin
  inherited;

end;

destructor TaDCAuthorization.Destroy;
begin

  inherited;
end;

function TaDCAuthorization.Encrypt(Value: string): string;
var
  i: integer;
begin
  Result := Value;
  for i := 1 to Length(Result) do
    Result[i] := Chr(Ord(Result[i]) xor ((i + EncryptKey) mod 255));
end;

function TaDCAuthorization.Execute(aParent: TCustomForm; aShowInTaskBar: boolean): boolean;
var
  //s: string;
  i: integer;
  UserChoice: TUserChoice;
begin
  Result := False;

  UserChoice := TUserChoice.Create(Application);
  try
    UserChoice.OPCSource := OPCSource;
    UserChoice.cbUser.Items.Text := OPCSource.GetUsers;
    UserChoice.cbUser.ItemIndex := UserChoice.cbUser.Items.IndexOf(User);

//    while not Result do
//    begin
      UserChoice.ePassword.Text := '';

//      UserChoice.ShowModal(
//        procedure (ModalResult: TModalResult)
//        begin
//          if ModalResult = mrOK then
//            ShowMessage('OK')
//          else
//            ShowMessage('Cancel');
//          UserChoice.DisposeOf;
//        end
//      )

      UserChoice.ShowModal(
        procedure (ModalResult: TModalResult)
        begin
          if ModalResult = mrOk then
          begin
            try
              User := UserChoice.cbUser.Selected.Text;
              Password := UserChoice.ePassword.Text;
              //Result :=
              OPCSource.Login(User, Password);
//              if not Result then
//                MessageDlg(
//                  Format('� ������������ %s ������������ ���� ��� ������ � ��������!', [User]),
//                  TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
            except
              on e: Exception do
                MessageDlg(e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
            end;
          end
          else
          begin
            Permissions := '';
            //Break;
          end;

          //UserChoice.DisposeOf;

        end
        );

//      if UserChoice.ShowModal = mrOk then
//      begin
//        try
//          User := UserChoice.cbUser.Selected.Text;
//          Password := UserChoice.ePassword.Text;
//          Result := OPCSource.Login(User, Password);
//          if not Result then
//            MessageDlg(
//              Format('� ������������ %s ������������ ���� ��� ������ � ��������!', [User]),
//              TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
//        except
//          on e: Exception do
//            MessageDlg(e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
//        end;
//      end
//      else
//      begin
//        Permissions := '';
//        break;
//      end;
//    end;
  finally
    //UserChoice.Free;
  end;

end;

function TaDCAuthorization.GetEncryptedPassword: string;
begin
  Result := Encrypt(Password);
end;

function TaDCAuthorization.Login: boolean;
begin
  Result := false;
  try
    Result := OPCSource.Login(User, Password);
  except
    on e: Exception do ;
  end;
end;

procedure TaDCAuthorization.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FOPCSource) then
    FOPCSource := nil;
end;

procedure TaDCAuthorization.ReadCommandLine;
var
  i: integer;
  ch: string;
begin
  for i := 0 to ParamCount do
  begin
    ch := copy(LowerCase(ParamStr(i)), 1, 2);
    if ch = '-u' then
      User := Copy(ParamStr(i), 3, length(ParamStr(i)))
    else if ch = '-p' then
      Password := Copy(ParamStr(i), 3, length(ParamStr(i)));
  end;
end;

procedure TaDCAuthorization.ReadCommandLineExt;
var
  s: TStringList;
  i: Integer;
begin
  s := TStringList.Create;
  try
    for i := 1 to ParamCount do
      s.Add(UpperCase(ParamStr(i)));

    // ��� ������������
    if s.Values['USER'] <> '' then
      User := s.Values['USER']
    else if s.Values['U'] <> '' then
      User := s.Values['U'];

    // ������
    if s.Values['PASSWORD'] <> '' then
      Password := s.Values['PASSWORD']
    else if s.Values['P'] <> '' then
      Password := s.Values['P'];
  finally
    s.Free;
  end;

end;

procedure TaDCAuthorization.SetEncryptedPassword(const Value: string);
begin
  Password := Encrypt(Value);
end;

procedure TaDCAuthorization.SetOPCSource(const Value: TaOPCSource);
begin
  FOPCSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TaDCAuthorization.SetPassword(const Value: string);
begin
  FPassword := Value;
  if FOPCSource <> nil then
    FOPCSource.Password := Value;
end;

procedure TaDCAuthorization.SetPermissions(const Value: string);
begin
  FPermissions := Value;
end;

procedure TaDCAuthorization.SetUser(const Value: string);
begin
  FUser := Value;
  if FOPCSource <> nil then
    FOPCSource.User := Value;
end;

end.
