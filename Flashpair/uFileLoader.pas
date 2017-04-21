unit uFileLoader;



interface

uses classes, sysutils;
type
  TOnFileFound = procedure(Dir : String; Name : String) of object;
  TOnDirFound = procedure(Dir : String) of object;
  TOnDirEnd = procedure(Dir : String) of Object;

  TFileLoader = class
    private
      FOnFileFound : TOnFileFound;
      FOnDirFound : TOnDirFound;
      FOnDirEnd : TOnDirEnd;
      FRecursiveScan : Boolean;
      FAcceptedFiles : TStrings;
    protected
      CurrDir : String;
      function IsFileAcceptable(FileName : String) : boolean;
    public
      destructor Destroy;
      procedure ScanDir(Dir : String);
      class function GetLastDir(Dir : String) : String;
      constructor Create;
    published
      property OnDirFound : TOnDirFound read FOnDirFound write FOnDirFound;
      property OnDirEnd : TOnDirEnd read FOnDirEnd write FOnDirEnd;

      property OnFileFound : TOnFileFound read FOnFileFound write FOnFileFound;
      property RecursiveScan : boolean read FRecursiveScan write FRecursiveScan;
      property AcceptedFiles : TStrings read FAcceptedFiles write FAcceptedFiles;
  end;
implementation

constructor TFileLoader.Create;
begin
  inherited Create;
  FAcceptedFiles := TStringList.Create;
end;

destructor TFileLoader.Destroy;
begin
  FAcceptedFiles.Free;
  inherited;
end;

function TFIleLoader.IsFileAcceptable(FileName : String) : Boolean;
var i : integer;
  CExt, FExt : String;
  CS : String;
  PP : Integer;
begin
  result := false;
  for i := 0 to FAcceptedFiles.Count-1 do begin
    CS := FAcceptedFiles.Strings[i];
    PP := Length(FileName)-Pos('.',FileName);
    FExt := Copy(Filename,Length(FileName)-PP,PP+1);
    if CS = FExt then
      result := true;
  end;
end;

class function TFileLoader.GetLastDir(Dir : String) : String;
  var PP : integer;
     CS : String;
  begin
    PP := Pos('\',Dir);
    CS := Copy(Dir,PP+1,Length(Dir)-PP);
    if CS = '' then
      result := Dir
    else
      result := GetLastDir(CS);
  end;

procedure TFileLoader.ScanDir(Dir : String);

  procedure ProcessSearchRec(Sr : TSearchRec);
  var
      Ext : String;
      IExt : integer;
      NoExt : String;
      DataString : String;
      PString : PChar;
  begin
    if ((sr.Attr and faDirectory) > 0) and (sr.Name <> '.') and (sr.Name <> '..') then begin

      DataString := Dir+sr.Name+'\';
      if Assigned(FOnDirFound) then
        FOnDirFound(DataString);
      if FRecursiveScan then
        ScanDir(Dir+sr.Name+'\');
    end else if ((sr.Attr and faDirectory) <= 0) then begin
      DataString := Dir+sr.Name;
      if IsFileAcceptable(DataString) and Assigned(FOnFileFound) then
        FOnFileFound(Dir,sr.Name);
    end;
  end;

var sr: TSearchRec;

begin
  if (FindFirst(Dir+'*.*', faAnyFile, Sr) = 0) then
    ProcessSearchRec(sr);
  while (FindNext(sr) = 0) do
    ProcessSearchRec(sr);
  FindClose(sr);
  if Assigned(FOnDirEnd) then
    FOnDirEnd(Dir);
end;



end.
