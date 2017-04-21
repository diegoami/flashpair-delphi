 unit QuizBrowsePanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uBrowseForm, ExtCtrls, uImagePanel, uFileLoader, SimpleBrowseDCTreeView, uFlashController, uController,
  OvalButtonsPanel, ComCtrls, FlashBrowsePanel, AMReg ;

type
  TOnGameOver = procedure of object;
  TOnAllGuessed = procedure(Sender : TObject; TimeLeft : Integer) of object;

  TQuizBrowsePanel = class(TFlashBrowsePanel)


  private
    FGameOver : TOnGameOver;
    FOnNo, FOnGuessed : TNotifyEvent;
    FOnAllGuessed : TOnAllGuessed;
    ScrollBox1: TScrollBox;
    OvalButtonsPanel1: TOvalButtonsPanel;
    ProgressBar1: TProgressBar;
    ProgressbarTimer: TTimer;

    ToTStrings : TStrings;
    OldDirFound : TOnDirFound;
    OldFileFound : TOnFileFound;
    Timer2 : TTimer;
    TimerEndLevel : TTimer;
    procedure NewDirFound(Dir : String);
    //procedure NewFileFound(Dir, Name : String);
    procedure OvalsAllGuessed;

    procedure ProgressbarTimerTimer(Sender : TObject);
    

  protected
      AllIms : TStrings;
      NewIms : TStrings;
      IsClosing : boolean;

    procedure ClickedImage(Sender : TObject; ImageName : String); override;
    procedure Timer2OnTimer(Sender : TObject);
    procedure PanelShow; override;

    procedure PanelHide; override;
    procedure ScrollBox1Resize(Sender: TObject);

    procedure AssignStringsToPanel; override;
    procedure AddToPanel(Dir, Name : String); override;
    procedure LoadQuiz(NB : integer; Sec : Integer);
    procedure EndLevel(Sender : TObject);
  public
    Resized : boolean;
    constructor Create(AOwner : TComponent);
    procedure Resize; override;
    destructor Destroy;
    procedure GameOver;

  published
    property OnGameOver : TOnGameOver read FGameOver write FGameOver;
    property OnAllGuessed : TOnAllGuessed read FOnAllGuessed write FOnAllGuessed;
    property OnNo : TNotifyEvent read FOnNo write FOnNo;
    property OnGuessed : TNotifyEvent read FOnGuessed write FOnGuessed;
  end;


implementation
uses UdebugForm, UGame, utils, uCLickItMainForm;

procedure TQuizBrowsePanel.PanelHide;
begin
  inherited;
  with AReg do begin
    Active := True;
    WSInteger('Forms','QuizTreePanelWidth',ImagePanel1.Width);
    WSInteger('Forms','QuizPanelWidth',Panel1.Width);
    WSInteger('Forms','QuizImagePanelColor',ImagePanel1.Color);
    WSinteger('Forms','QuizBrowseMapsLeft',Left);
    WSinteger('Forms','QuizBrowseMapsTop',Top);
    WSinteger('Forms','QuizBrowseMapsWidth',Width);
    WSinteger('Forms','QuizBrowseMapsHeight',Height);
    WSinteger('Forms','QuizFlagPanelHeight',Panel3.Height);
    WSInteger('Forms', 'QuizBoxHeight',ScrollBox1.Height);
    Active := False;
  end;
end;


procedure TQuizBrowsePanel.AddToPanel(Dir, Name : String);
var S :WideString;
SD :String;
begin
   {TreeView.FileLoader.OnFileFound}

  S := GetCompleteDef(Dir,Name);
  SD := GetSmallDef(Dir,Name);
  if Controller.SelectedStrings.IndexOf(Dir) <> -1 then begin
    TotStrings.Add(SD);
    AllIMS.Add(S);
  end;

end;

procedure TQuizBrowsePanel.AssignStringsToPanel;
var nsh, i, j, q : integer;
 TS, TN, CS : String;
 SSS : TStrings;
begin
  Randomize;
  SSS := TStringList.Create;
  NewIms.Clear;
  for q := 0 to ALLIMS.Count-1 do begin
    CS := ALLIMS.Strings[q];
    TS := EXtractFileName(Copy(CS,1,Pos('=',CS)-1));
    if (Deff <> nil) and (Deff.Values[TS] <> '') then
      TN := Deff.Values[TS]
    else
      TN := TS;
    if (SSS.IndexOf(CS) = -1) and (OvalButtonsPanel1.ValueList.IndexOf(TN) <> -1) then
      SSS.Add(CS);
  end;
  while (SSS.Count < (ImagePanel1.NImages)) do begin
    j := Random(AllIMS.Count);
    if SSS.IndexOf(ALLIMS.Strings[j]) = -1 then
      SSS.Add(ALLIMS.Strings[j]);
  end;
  NewIMS.Assign(SSS);
  nsh := Random(NewIMS.Count*5);
  for q := 1 to nsh do begin
    i := Random(NewIMS.Count);
    j := Random(NewIMS.Count);
    TS := NewIMS.Strings[i];
    NewIMS.Strings[i] := NewIMS.Strings[j];
    NewIMS.Strings[j] := TS;
  end;
  ImagePanel1.AllBitmapFiles := NewIMS;
  SSS.Free;
end;

procedure TQuizBrowsePanel.Timer2OnTimer(Sender : TObject);
begin
  Timer2.Enabled := false;
  if CurrGame <> nil then
    GameOVer;
end;

procedure TQuizBrowsePanel.Resize;

var WW, IWW : integer;
HH, IHH : integer;
 IH, IW : integer;

begin
  //if Resized then exit;
  if IsClosing then exit;
  WW := Width div 3 * 2;
  IWW := Width - WW - 10;
  HH := Height div 4 * 3;
  IHH := Height - HH - 10;

  //ImagePanel1.Width := WW;

  with Progressbar1 do begin
    Top := Splitter3.Top-16;
  end;
 // Splitter2.Top := HH-16;
{  with Scrollbox1 do begin

    Top := HH;
    Height := IHH;
  end;}
 try
  with AReg do begin
   Active := True;
   IH := RSInteger('Forms','QuizBrowseMapsHeight',Height);
   IW := RSinteger('Forms','QuizBrowseMapsWidth',Width);
   if ( (abs(IH-Height) < 15) and (abs(IW-Width) < 15) ) and (not ISClosing) then begin
    ScrollBox1.Height := RSInteger('Forms','QuizBoxHeight',IHH);
    ImagePanel1.Color := RSInteger('Forms','QuizImagePanelColor',ImagePanel1.Color);
    Panel3.Height := RSinteger('Forms','QuizFlagPanelHeight',Panel3.Height);
    ImagePanel1.Width := RSInteger('Forms','QuizTreePanelWidth',WW);
    Panel1.Width := RSInteger('Forms','QuizPanelWidth',Panel1.Width);
    Left := RSinteger('Forms','QuizBrowseMapsLeft',Left);
    Top := RSinteger('Forms','QuizBrowseMapsTop',Top);
    Width := RSinteger('Forms','QuizBrowseMapsWidth',Width);
    Height := RSinteger('Forms','QuizBrowseMapsHeight',Height);

   end;
   Active := False;
  end;
 except on EAMRegError do end;
  OvalButtonsPanel1.Resize;
  if ImagePanel1.Width < (Width div 2) then
    ImagePanel1.Width := WW;

end;

constructor TQuizBrowsePanel.Create(AOwner : TComponent);
var WW, IWW : integer;
   HH : integer;
begin
  WW := Width div 3 * 2;
  IWW := Width - WW - 10;
  HH := Height div 4 * 3;
  inherited;
  Timer2 := TTimer.Create(Self);

  with Timer2 do begin
    Interval := 2000;
    Enabled := False;
    OnTimer :=Timer2OnTimer
  end;

  TimerEndLevel := TTimer.Create(Self);

  with TimerEndLevel do begin
    Interval := 1000;
    Enabled := False;
    OnTimer := EndLevel
  end;
  AllIMS := TStringList.Create;
  NewIms := TStringList.Create;

  TreeView.OnChange := nil;
  SPlitter2.OnMoved := Scrollbox1Resize;
  ImagePanel1.LabelVisible := False;
  Progressbar1 := TProgressbar.Create(Panel1);
  with Progressbar1 do begin
    Parent := Panel1;
    Left := 1;
    Top := Splitter3.Top-16;
    Height := 16;
    Align := AlBottom;
    Min := 0;
    Max := 100;
    TabOrder := 1;
  end;
  ScrollBox1 :=  TScrollBox.Create(Self);
  with Scrollbox1 do begin
    Parent := Self;
    Left := 0;
    Align := alBottom;
    TabOrder := 2;
    OnResize := ScrollBox1Resize;
  end;
  OvalButtonsPanel1 := TOvalButtonsPanel.Create(ScrollBox1);
  with OvalButtonsPanel1 do begin
    Parent := Scrollbox1;
    Left := 0;
    Top := 0;
    TabOrder := 0;
    ButtonWidth := 0;
    OvalDirection := OvalHorizontal;
    SelectColor := clBlack;
    DisableColor := clBlack;
    NButtons := 0;
    FaceColor := clBlack;
    Disappear := True;
    OnAllGuessed := OvalsAllGuessed;
  end;
  ProgressBarTimer := TTimer.Create(Self);
  with ProgressbarTimer do begin

    Enabled := False;
    OnTimer := ProgressbarTimerTimer;
    Interval := 1000
  end;
  Panel1.Width := 10;
  OldDirFound := TreeView.FileLoader.OnDirFound;
  TreeView.FileLoader.OnDirFound := NewDirFound;
  TotStrings :=   TStringList.Create;
  Resized := true;

end;

procedure TQuizBrowsePanel.GameOver;
var OldClickeDimage : TOnClickedImage;
begin
  ISClosing := True;
  ProgressbarTimer.Enabled := False;
  OldClickedImage := ImagePanel1.OnClickedImage;
  ImagePanel1.OnClickedImage := nil;

  if Assigned(FGameOver) then
    FGameOver;   // requires CurrGame.Score; MessageBox


  ImagePanel1.OnClickedImage := OldClickedImage;
  CurrGame.Free;
  CurrGame := Nil;

     PanelHide;
end;

procedure TQuizBrowsePanel.ProgressbarTimerTimer(Sender : TObject);
begin
  if ProgressBar1.Position = 0 then begin
    ProgressbarTimer.Enabled := False;

    if Assigned(FGameOver) then begin

      ImagePanel1.LabelVisible := True;
      ImagePanel1.Resize;
      Timer2.Enabled := True
    end
  end else
    Progressbar1.Position := Progressbar1.Position-1;
end;

procedure TQuizBrowsePanel.OvalsAllGuessed;
begin
  ISclosing := True;
  ProgressbarTimer.Enabled := false;
  TimerEndLevel.Enabled := True;


end;

procedure TQuizBrowsePanel.EndLevel(Sender : TObject);
begin
  TimerEndLevel.Enabled := False;
  PanelHide;
  if Assigned(FOnAllGuessed) then
    FOnAllGuessed(Self,Progressbar1.Position);

end;


procedure TQuizBrowsePanel.NewDirFound(Dir : String);
var ITF : TStrings;
   i, j, pi, pj : integer;
   iv, jv : String;
begin
{   TreeView.FileLoader.OnDirFound }

  ITF := TStringList.Create;
  if Controller.SelectedStrings.IndexOf(Dir) <> -1 then begin
    if FileExists(Dir+'index.txt') then begin
      ITF.LoadFromFile(Dir+'index.txt');
      Deff.AddStrings(ITF)
    end;
    OldDirFound(Dir);
  end;
  ITF.Free;
  
end;

procedure TQuizBrowsePanel.PanelShow;
var Kindex : integer;
  kx, ky : integer;
begin
  { Loads tree, sets ImagePanel resolution
    sets OvalButton's options}
  IsClosing := False;

  inherited;

  AllIMS.Clear;
  TreeView.Items.Clear;
  TotStrings.Clear;
  LoadingTree := True;
  TreeView.FileLoader.ScanDir(ExtractFilePath(Application.Exename));
  LoadingTree := False;

  //OvalButtonsPanel1.PossibleValuesList := ToTStrings;
  try
    TreeView.Selected := Treeview.Items[0];
    (Controller AS TFlashController).GetXYData(TreeView.Selected.Text,kx,ky);
    ImagePanel1.NImagesOnRow := ky;
    ImagePanel1.NImages := ky*kx;
  except on Exception do end;
  OvalButtonsPanel1.ButtonWidth := Controller.ButtonOptions.Width;
  OvalButtonsPanel1.FaceColor := Controller.ButtonOptions.FaceColor;
  OvalButtonsPanel1.SelectColor := Controller.ButtonOptions.SelColor;
  OvalButtonsPanel1.SetFont(Controller.ButtonOptions.Font);
  LoadQuiz(Controller.qpl,Controller.spq);
  //ScrollBox1Resize(Self);
  //SetDisable;
  OvalButtonsPanel1.SelectFirst;

  AssignStringsToPanel;

  ImagePanel1.Loaded;
  Resized := False;
 // Resize


end;

procedure TQuizBrowsePanel.LoadQuiz(NB : integer; Sec : Integer);
var i, ISS : integer;
  TSL,TRL : TStrings;
  ES : String;
begin

  OvalButtonsPanel1.NButtons := NB;
  ImagePanel1.LabelVisible := False;
  ProgressBar1.Max := max(Sec*NB-(Sec*CurrGame.Level div 4),Sec*NB); 
  ProgressBar1.Position := ProgressBar1.Max;
  ProgressBarTimer.Enabled := True;
  TRL := TStringList.Create;
  if (TotStrings.COunt <= NB)  then begin
    raise Exception.Create('Not enough images!');
    exit;
  end;
 if Controller.ExcludeNames.Count < TotStrings.Count then
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
  Resized := False;

end;

procedure TQuizBrowsePanel.ScrollBox1Resize(Sender: TObject);
begin
  inherited;
  OvalButtonsPanel1.Height := ScrollBox1.Height;
  OvalbuttonsPanel1.Resize;
end;

procedure TQuizBrowsePanel.ClickedImage(Sender : TObject; ImageName : String);
var ListItem : TListItem;
  IsRight : Boolean;
begin
  inherited;
  (Parent AS TMainForm).CheckMusic;
  IsRight := false;
  if ImageName = OvalButtonsPanel1.GetCurrentString then begin
    OvalButtonsPanel1.Guessed;
    IsRight := True;
    if Assigned(FOnGuessed) then
      FOnGuessed(Self);
    ImagePanel1.ShowName(ImageName,false)

  end else
    if Assigned(FOnNo) then
      FOnNo(self);
{  if Assigned(FOnGuess) then
    FOnGuess(IsRight);}
end;

destructor TQuizBrowsePanel.Destroy;
begin
  IsClosing := True;
  PanelHide;
  OvalButtonsPanel1.Free;
  AllIMS.Free;
  ScrollBox1.Free;
  TotStrings.Free;
  ProgressBar1.Free;
  inherited;


end;

end.
