unit uQuizForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uBrowseForm, ExtCtrls, uImagePanel, uFileLoader, SimpleBrowseDCTreeView, uFlashController, uController,
  OvalButtonsPanel, ComCtrls;

type
  TQuizBrowseForm = class(TBrowseForm)
    ScrollBox1: TScrollBox;
    OvalButtonsPanel1: TOvalButtonsPanel;
    ProgressBar1: TProgressBar;
    ProgressbarTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure ClickedImage(ImageName : String); override;
    procedure FormShow(Sender: TObject);
    procedure ScrollBox1Resize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    ToTStrings : TStrings;
    OldDirFound : TOnDirFound;
    OldFileFound : TOnFileFound;
    procedure NewDirFound(Dir : String);
    procedure NewFileFound(Dir, Name : String);
  protected
    procedure AssignStringsToPanel; override;
    procedure LoadQuiz(NB : integer; Sec : Integer);
  public
    { Public declarations }
  end;

var
  QuizBrowseForm: TQuizBrowseForm;

implementation

{$R *.DFM}

procedure TQuizBrowseForm.AssignStringsToPanel;
var nsh, i, j, q : integer;
 TS, TN, CS : String;
 SSS : TStrings;
begin
  Randomize;
  SSS := TStringList.Create;{
  nsh := Random(IMS.Count*5);
  for q := 1 to nsh do begin
    i := Random(IMS.Count);
    j := Random(IMS.Count);
    TS := IMS.Strings[i];
    IMS.Strings[i] := IMS.Strings[j];
    IMS.Strings[j] := TS;
  end;
  for i := 0 to (Controller AS FlashController).noi do
    SSS.Add(IMS.Strings[i]); }
  for i := 0 to (Controller AS TFlashController).noi do begin
    j := Random(IMS.Count);
    if SSS.IndexOf(IMS.Strings[j]) = -1 then
      SSS.Add(IMS.Strings[j]);
  end;
  for q := 0 to IMS.Count-1 do begin
    CS := IMS.Strings[q];
    TS := EXtractFileName(Copy(CS,1,Pos('=',CS)-1));
    if (Deff <> nil) and (Deff.Values[TS] <> '') then
      TN := Deff.Values[TS]
    else
      TN := TS;
    if (SSS.IndexOf(CS) = -1) and (OvalButtonsPanel1.ValueList.IndexOf(TN) <> -1) then
      SSS.Add(CS);
  end;
  IMS.Assign(SSS);
  ImagePanel1.AllBitmapFiles := IMS;
  SSS.Free;
end;


procedure TQuizBrowseForm.NewFileFound(Dir, Name : String);
var  CVAL : String;
  IOF : integer;
  SNAme : String;
begin
  if Controller.SelectedStrings.IndexOf(Dir) <> -1 then begin
    OldFileFound(Dir,Name);
    SName := Copy(Name,1,Length(Name)-4);
  //ListItem := ListView1.Items.Add;
    IOF := Deff.IndexOfName(Name);
    if IOF <> -1 then begin

      CVAL := Deff.Values[Name];
      TotStrings.Add(CVal);
    end else
      TotStrings.Add(Name);
  end;
end;

procedure TQuizBrowseForm.FormCreate(Sender: TObject);
begin

  inherited;
  OldDirFound := TreeView.FileLoader.OnDirFound;
  TreeView.FileLoader.OnDirFound := NewDirFound;
  TotStrings := TStringList.Create;
  //SetTotStrings;

end;



procedure TQuizBrowseForm.NewDirFound(Dir : String);
begin
  if Controller.SelectedStrings.IndexOf(Dir) <> -1 then begin
    if FileExists(Dir+'index.txt') then
      Deff.LoadFromFile(Dir+'index.txt');
    OldDirFound(Dir);
  end;
end;


procedure TQuizBrowseForm.FormShow(Sender: TObject);
begin
  inherited;
  TotStrings.Clear;
  OldFileFound := TreeView.FileLoader.OnFileFound;
  TreeView.FileLoader.OnFileFound := NewFileFound;
  TreeView.FileLoader.ScanDir('c:\Programme\Borland\Delphi 3\Miei\Flick\');
  //OvalButtonsPanel1.PossibleValuesList := ToTStrings;

  OvalButtonsPanel1.ButtonWidth := Controller.ButtonOptions.Width;
  OvalButtonsPanel1.FaceColor := Controller.ButtonOptions.FaceColor;
  OvalButtonsPanel1.SelectColor := Controller.ButtonOptions.SelColor;
  OvalButtonsPanel1.SetFont(Controller.ButtonOptions.Font);
  LoadQuiz(Controller.qpl,Controller.spq);
  ScrollBox1Resize(Self);
  //SetDisable;
  OvalButtonsPanel1.SelectFirst;

end;

procedure TQuizBrowseForm.LoadQuiz(NB : integer; Sec : Integer);
var i, ISS : integer;
  TSL,TRL : TStrings;
  ES : String;
begin
  OvalButtonsPanel1.NButtons := NB;

  ProgressBar1.Max := Sec;
  ProgressBar1.Position := Sec;
  ProgressBarTimer.Enabled := True;
  TRL := TStringList.Create;

  if (TotStrings.COunt <= NB)  then begin
    MessageBox(0,'Not enough hotspots!','Warning',0);
    {if CurrGame <> nil then
      CurrGame.Gameover}
  end;

  for i := 0 to Controller.ExcludeNames.Count-1 do begin
    ES := Controller.ExcludeNames.Strings[i];
    ISS := TotStrings.IndexOf(ES);
    if ISS <> -1 then
      TotStrings.Delete(ISS);
  end;
  //CurrGame.ScoreModifier := Round(TSL.Count)/100+(30-GeoController.spq)/10+(50-GeoController.qpl)/50;
  OvalButtonsPanel1.PossibleValuesList := TotStrings;
  try
    OvalButtonsPanel1.GenerateTest(OvalButtonsPanel1.NButtons);
  except on ENoValues do begin

      //CurrGame.GameOver;
      ProgressBarTimer.Enabled := False;
      raise;
    end;
  end;

  ScrollBox1Resize(Self);
  //TSL.Free;
  TRL.Free;
end;


procedure TQuizBrowseForm.ScrollBox1Resize(Sender: TObject);
begin
  inherited;
  OvalbuttonsPanel1.Resize;
end;

procedure TQuizBrowseForm.ClickedImage(ImageName : String);
var ListItem : TListItem;
begin

    if ImageName = OvalButtonsPanel1.GetCurrentString then begin

      OvalButtonsPanel1.Guessed;
      ImagePanel1.ShowName(ImageName,false)
    end;
    
end;


procedure TQuizBrowseForm.FormDestroy(Sender: TObject);
begin
  TotStrings.Free;
  inherited;

end;

end.
