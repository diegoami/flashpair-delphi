unit uRegisterForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, IceLock, Amreg, registry, stringfns, RXCtrls, uController;
const
  TimeToRegister = 40;
  GENPASSWORD = '8ud3j0v1c3';
  MAXTRIES = 6;
type
  TRegisterForm = class(TForm)
    Notebook1: TNotebook;
    RegisLabel: TLabel;
    UserEdit: TEdit;
    PassLabel: TLabel;
    PasswordEdit: TEdit;
    Userlabel: TLabel;
    UserNameLabel: TLabel;
    OkButton: TButton;
    CancelButton: TButton;
    IceLock1: tIceLock;
    Bevel1: TBevel;
    Bevel2: TBevel;
    RegButton: TButton;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure RegButtonClick(Sender: TObject);
  private

    tries : integer;
    RegUser : String;
    RegPassw : String;

  public
    KeyName : String;
    IconName : String;
    ValueName : String;
    Registered : boolean;
    Times : integer;
    procedure CheckRegister;
    procedure AnnoyUser;
  published
    //property AReg : TAmReg read FAMreg write FAMReg;
  end;

var
  RegisterForm: TRegisterForm;

implementation

{$R *.DFM}

procedure TRegisterForm.FormShow(Sender: TObject);
var Us, EncPw, Pw, RPW : String;
begin
  tries := 0;
  if Registered then
    Notebook1.ActivePage := 'Information'
  else
    Notebook1.ActivePage := 'Registering';
end;

procedure TRegisterForm.CancelButtonClick(Sender: TObject);
begin
  if Registered or (Times <= TimeToRegister) then
    Close;
end;

procedure TRegisterForm.OkButtonClick(Sender: TObject);
var Us, EncPw, Pw, RPW : String;
  TARUS : STring;
begin
  if Notebook1.ActivePage = 'Registering' then begin
    US := UserEdit.Text;
    PW := PasswordEdit.Text;
    RPW := IceLock1.BuildUserKey(US,false);
    EncPw := RPW;
    if PW = GENPASSWORD then
      Label1.Caption := RPW;
    if PW <> RPW then begin
      MessageBox(0,'Invalid password','Invalid password',0);
      inc(tries);
      if tries >= MAXTRIES then Application.Terminate;
    end else begin
      MessageBox(0,'Thank you for registering','Message',0);
      with Areg do begin
        Active := True;
        TARUS := User;
        User := '';
        WSString('','Reginfo',US);
        WSString('','Regpw',EncPw);
        User := TARUS;
        Active := False;
      end;
      UserNameLabel.Caption := US;
      Registered := True;
      Notebook1.ActivePage := 'Information';
    end;
  end else
    Hide;
end;


procedure TRegisterForm.AnnoyUser;
var MM : String;
begin
  if not Registered then begin

    if Times <= (TimeToRegister div 2) then begin
      MM := 'Welcome! You can use this Application another ' + IntToStr(TimeToRegister-Times) +' times before registering';
      Application.MessageBox(Pchar(MM),'',0)

    end else if Times > (TimeToRegister div 2) then begin
      MM := ' You have used this Application '+IntToStr(Times)+ ' times. Please Register!';
      Application.MessageBox(PChar(MM),'',0);

    end;

  end;
end;




procedure TRegisterForm.CheckRegister;
var Us, EncPw, Pw, RPW, EncT : String;
   TARUS : String;
   ValSize,i : Integer;
    SC, SCC : STRING;
    KeyHandle: HKEY;
    Reg : TRegistry;
    WinGk : String;
    Filepro : String;
    TTimes : integer;
begin
  Reg := TRegistry.Create;
  FilePro := ExtractFilePath(Application.Exename)+IconName;
  if FileExists(FilePro) then begin
    DeleteFile(FilePro);
    Times := 1
  end;
  with Reg do begin
    RootKey := HKEY_CURRENT_USER;
    OpenKey(KeyName,true);
    try
      WinGk := ReadString(ValueName);
      TTimes := 0;
  { query "secret" values... }
      for i := 1 to TimeToRegister+2 do begin
        SC := Application.Title+IntToStr(i);
        SCC := SC;
        if WinGk = SCC then
          TTimes := I;

      end;
      if TTimes = TimeToRegister + 2 then
        TTimes := TimeToRegister + 1;
      if TTimes <> 0 then
        Times := TTimes;

    except on ERegistryException do
      Times := 1;
    end;
    EncT := Application.Title+IntToStr(Times+1);
    WriteString(ValueName,EncT);
  end;
  with AReg do begin
    Active := True;
    TARUS := User;
    User := '';
    Us := RSString('','Reginfo','');

    if US = '' then begin
      Notebook1.ActivePage := 'Registering';
      Registered := False;

    end else begin
      PW := IceLock1.BuildUserKey(US,false);
      EncPw := PW;
      RPW := RSString('','Regpw','');
      if RPW = EncPW then begin
        Notebook1.ActivePage := 'Information';
        UserNameLabel.Caption := US;

        Registered := True;
      end;

    end;
    User := TARUS;
    Active := False;
  end;
end;

procedure TRegisterForm.RegButtonClick(Sender: TObject);
begin
  ShowWebPage('http://clickit.pair.com');
end;

end.
