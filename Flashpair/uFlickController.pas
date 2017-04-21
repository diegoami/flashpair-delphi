unit uFlickController;

interface

uses classes, uFileLoader;
type
  TFlickController = class

    protected
      FileLoader : TFileLoader;
      procedure AddImageFile(Dir, Name : String);
    public
      AllImageFiles : TStrings;
      constructor Create; 
      //procedure FIllImageFiles(DIr : String);
  end;

implementation

constructor TFlickController.Create;
var SS : TStringList;
begin
  inherited;
  AllImageFiles := TStringList.Create;
  FileLoader := TFileLoader.Create;
  FileLoader.RecursiveScan := True;
  FileLoader.OnFileFound := AddImageFile;
  SS := TStringList.Create;
  SS.Add('.jpg');
  SS.Add('.bmp');
//  SS.Add('.gif');
  FileLoader.AcceptedFiles := SS;
  FileLoader.ScanDir('c:\Programme\Borland\Delphi 3\Images\');
end;

procedure TFlickController.AddImageFile(Dir, Name : String);
begin
  AllImageFiles.Add(Dir+Name);
end;



end.
