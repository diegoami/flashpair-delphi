unit uController;

interface

uses classes, graphics, sysutils, AmReg, utils, registry, forms, ugame;

const
  ScoreIfCaught = 100;
type

  TDifficulty = (Easy, Medium, Hard);
  TButtonOptions = record
    Width : Integer;
    Font : TFont;
    SelColor, FaceColor : TColor;
  end;

  TInterfaceOptions = record
    NormalScroll : boolean;
    NormalZoom : boolean;
    MusicFileName : String;
    MusicOn : Boolean;
    SoundOn : Boolean;
  end;

  TController = class(Tobject)
    protected
      AllRs : TStrings;
      
      CheckedFiles : TStrings;
      CheckedDirs : TSTrings;
      FUSerName : String;
      procedure ReadButtonOptions;
      procedure ReadInterfaceOptions; dynamic;
      procedure ReadDiffOptions; dynamic;
    protected
      function GetUserName : String;
      procedure SetUserName(N : String);
    public

      Difficulty : TDifficulty;
      ButtonOptions : TButtonOptions;
      InterfaceOptions : TInterfaceOPtions;
      SelectedStrings : TStrings;
      AllSel : TStrings;
      SDSTrings : TStrings;
      ExcludeNames : TStrings;
      qpl, spq : integer;

      property UserName : String read GetUserName write SetUserName;
      function CreateGame(Sender : TObject) : TGame; virtual;
      procedure PlaySound(Which : String);
      procedure SaveExclusions;
      function GetAllUsers : TStrings;
      procedure LoadExclusions;
      function CanStartGame : boolean; dynamic;

      function isExcluded(S : String) : boolean;
      destructor Destroy; override;
      procedure WriteButtonOptions;
      procedure WriteDiffOptions; dynamic;
      procedure WriteInterfaceOptions; dynamic;

      procedure Exclude(S : String);
      procedure Include(S : String);

      constructor Create;
   end;

var
  Controller : TController;
  Rootname : String;
  Areg : TAMReg;

implementation

uses stringfns;

var AlReg : TRegistry;
function TController.GetUserName : string;
begin
  result := FUserName;
end;

destructor TController.Destroy;
begin
  if FuserName = '' then
    FUSerName := 'default';
  SetUserName(FUserName);

  AllRs.Free;
  CheckedFiles.Free;
  SelectedStrings.Free;
  CheckedDirs.Free;
  AllSel.Free;
  SDStrings.Free;
  ExcludeNames.Free;
  inherited;
end;

function TController.CanStartGame : boolean;
begin
  result := true;
  if (SelectedStrings = nil) or (SelectedStrings.Count = 0) then
    result := false;
end;


function TController.GetAllUsers : TStrings;
var i : integer;
  S : String;
begin

  if AllRs   <> nil then
    AllRs.Clear;
  try
    with AREg do begin
      User := '';
      Active := True;
      GetAllKeys(AllRs);
      Active := False;
      User := FUserName;
    end;
  except on ERegistryException do
  end;
  i := 0;
  while i < AllRs.Count do begin
    S := AllRs.Strings[i];
    if (S = '1.0') or (S = 'ButtonOptions') or (S = 'InterfaceOptions') or (S = 'Forms') or (S = 'Difficulty') or (S = 'Scales' ) then
      AllRs.Delete(i)
    else
      inc(i);
  end;
  result := AllRs;
end;


procedure TController.SetUserName(N : String);
begin
  if N = '' then N := 'default';
  FUSerName := N;
  AReg.User := '';
  with AReg do begin
    Active := True;
    WSString('','UserName',N);
    WSString(N,'(Standard)','');
    Active := False;
    AReg.USer := N;
  end;
  ReadButtonOptions;
  ReadInterfaceOptions;
  ReadDiffOptions;
  LoadExclusions;
end;

function TController.IsExcluded(S : String) : boolean;
var b : boolean;
  i : integer;
begin
  if (ExcludeNames = nil) then exit;
  i := ExcludeNames.IndexOf(S);
  b := i <> -1;
  result := b;
end;

procedure TController.ReadDiffOptions;
begin
  with AReg do begin
    Active := True;
    spq := RSInteger('Difficulty','SPQ',spq);
    qpl := RSInteger('Difficulty','QPL',qpl);
    Active := False;
  end;
end;

procedure TController.WriteDiffOptions;
begin
  with AReg do begin
    Active := True;
    WSInteger('Difficulty','SPQ',spq);
    WSInteger('Difficulty','QPL',qpl);
    Active := False;
  end;
end;

procedure TController.SaveExclusions;
begin
  if (SelectedStrings = nil) or (ExcludeNames = nil) then exit;
  try
    SelectedStrings.SaveToFile(ExtractFilePath(Application.Exename)+FUserName+'.hsl');
    ExcludeNames.SaveToFile(ExtractFilePath(Application.Exename)+FUserName+'.exl');
  except on EFOpenError do end;
end;

procedure TController.LoadExclusions;
begin

  if (SelectedStrings = nil) or (ExcludeNames = nil) then exit;
  try
    SelectedStrings.LoadFromFile(ExtractFilePath(Application.Exename)+FUserName+'.hsl');

    ExcludeNames.LoadFromFile(ExtractFilePath(Application.Exename)+FUserName+'.exl');

  except on EFOpenError do if
    SelectedStrings.Count = 0 then
      SelectedStrings.Assign(AllSel)
    else
      SaveExclusions;
  end;
end;

procedure TController.ReadButtonOptions;
begin
  with ButtonOptions,AReg  do begin
      Active := True;
      Width := RSINteger('ButtonOptions','ButtonWidth',Width);
      SelColor := RSINteger('ButtonOptions','SelColor',SelColor);
      FaceColor := RSINteger('ButtonOptions','FaceColor',FaceColor);
      Font.Color := RSINteger('ButtonOptions','FontColor',Font.Color);
      Font.Size := RSINteger('ButtonOptions','FontSize',Font.Size);
      Font.Name := RSString('ButtonOptions','FontName',Font.Name);
      Font.Style := IntToFontStyle(RSInteger('ButtonOptions','FontStyle',FontStyleToInt(Font.Style)));
      Active := False;
  end;
end;

procedure TController.WriteButtonOptions;
begin
  with ButtonOptions,AReg  do begin
    Active := TRue;
    WSINteger('ButtonOptions','SelColor',SelColor);
    WSINteger('ButtonOptions','ButtonWidth',Width);
    WSINteger('ButtonOptions','FaceColor',FaceColor);
    WSInteger('ButtonOptions','FontColor',Font.Color);
    WSINteger('ButtonOptions','FontSize',Font.Size);
    WSINteger('ButtonOptions','FontStyle',FontStyleToInt(Font.Style));
    WSString('ButtonOptions','FontName',Font.Name);
    Active := False;
  end;
end;

procedure TController.ReadInterfaceOptions;
var defFileName : String;
begin

    defFileName := ExtractFilePath(Application.Exename) +'Sounds\Macaren2.mid';
    with InterfaceOptions, AReg do begin
      Active := True;
      NormalScroll := RSBool('InterfaceOptions','NormalScroll', NormalScroll);
      NormalZoom := RSBool('InterfaceOptions','NormalZoom', NormalZoom);
      MusicOn := RSBool('InterfaceOptions','MusicOn', MusicOn);
      SoundOn := RSBool('InterfaceOptions','SoundOn', SoundOn);
      MusicFileName := RSString('InterfaceOptions','MusicFileName',MusicFileName);
      Active := False;
    end;

end;

procedure TController.WriteInterfaceOptions;
begin

  with InterfaceOptions, AReg do begin
    Active := True;
    WSBool('InterfaceOptions','NormalScroll',NormalScroll);
    WSBool('InterfaceOptions','NormalZoom', NormalZoom);
    WSBool('InterfaceOptions','MusicOn', MusicOn);
    WSBool('InterfaceOptions','SoundOn', SoundOn);
    WSString('InterfaceOptions','MusicFileName', MusicFileName);
    Active := False;
  end;

end;

procedure TController.Exclude(S : String);
begin
 if ExcludeNames = Nil then exit;
 try
  if ExcludeNames.Indexof(s) = -1 then
    ExcludeNames.Add(S);
 except on Exception do end;
end;

procedure TController.Include(S : String);
begin
 if ExcludeNames = Nil then exit;
 try
  if ExcludeNames.Indexof(s) <> -1 then
    ExcludeNames.Delete(ExcludeNames.IndexOf(S));
 except on Exception do end;
end;

constructor TController.Create;
var defFilename : string;
begin
  inherited Create;
  AllSel := TStringList.Create;
  CheckedFiles := TStringList.Create;
  ButtonOptions.Font := TFont.Create;
  with AReg do begin
    Active := True;
    FUserName := RSString('','UserName','default');
    Active := False;
    User := FUserName;
  end;
  SelectedStrings := TStringList.Create;
  AllRs := TStringList.Create;
  CheckedDirs := TStringList.Create;
  ExcludeNames := TStringList.Create;
  SDStrings := TStringList.Create;
  with ButtonOptions do begin
      Font := TFont.Create;
      Width := 180;
      SelColor := clGreen;
      FaceColor := clRed;
      Font.Color := clBlue;
      Font.Size := 12;
      Font.Name := 'Arial';
  end;
  defFileName := ExtractFilePath(Application.Exename) +'Sounds\Macaren2.mid';
  with InterfaceOptions do begin
      NormalScroll :=  False;
      NormalZoom := true;
      MusicOn := false;
      SoundOn := False;
      MusicFileName := defFileName;
  end;
  spq := 12;
  qpl := 8;
  ReadButtonOptions;
  ReadInterfaceOptions;
  ReadDiffOptions;
  LoadExclusions;
end;


function TController.CreateGame(Sender : TObject) : TGame;
begin
  result := TGame.Create(qpl,spq);
end;

procedure TController.PlaySound(Which : String);
var GuessedFile : String;
begin
  try
    if InterfaceOptions.SoundOn then begin
      GuessedFile := ExtractFilePath(Application.ExeName)+'Sounds\'+Which+'.wav';
      Stringfns.PlayWav(GuessedFile);
    end;
  except on EFOpenError do end;
end;

initialization
  AReg := TAmReg.Create(nil);
  with AReg do begin
    Rootkey := HKeyLocalMachine;
    Group := 'Software';
    Company := 'Click It';
    AlReg := TRegistry.Create;
    Reg := AlReg;
  end;
  AReg.Application := Application.Title;

end.
