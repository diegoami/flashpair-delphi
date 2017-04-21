unit uClickitMainForm;

interface

uses Windows, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, MPlayer,
  stringfns, uController, uGame, ListBrowsePanel, QuizBrowsePanel,
  uImagePanel, RxMenus, ImgList;


type
  TMainForm = class(TForm)
    SDIAppMenu: TRxMainMenu;
    FileMenu: TMenuItem;
    UserItem: TMenuItem;
    ExitItem: TMenuItem;
    N1: TMenuItem;
    Help1: TMenuItem;
    SpeedPanel: TPanel;
    NewBtn: TSpeedButton;
    UserBtn: TSpeedButton;
    ExitBtn: TSpeedButton;
    StatusBar: TStatusBar;
    OptionsItem: TMenuItem;
    ColorsItem: TMenuItem;
    Environment: TMenuItem;
    DifficultyItem: TMenuItem;
    ContentsItem: TMenuItem;
    NewgameItem: TMenuItem;
    Panel1: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton3: TSpeedButton;
    StartLevelTimer: TTimer;
    Label1: TLabel;
    View1: TMenuItem;
    Images: TMenuItem;
    Scores1: TMenuItem;
    DifficultySpeedButton: TSpeedButton;
    SpeedButton5: TSpeedButton;
    MediaPlayer1: TMediaPlayer;
    About1: TMenuItem;
    N2: TMenuItem;
    Registration1: TMenuItem;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    DownloadMenuItem: TMenuItem;
    SpeedButton8: TSpeedButton;
    ImageList1: TImageList;
    SpeedButton1: TSpeedButton;
    MenuImageList: TImageList;
    procedure ShowHint(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure UserItemClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EnvironmentClick(Sender: TObject);
    procedure MapsMenuItemClick(Sender: TObject);
    procedure NewgameItemClick(Sender: TObject);
    procedure StartLevelTimerTimer(Sender: TObject);
    procedure DifficultyItemClick(Sender: TObject);
    procedure Scores1Click(Sender: TObject);
    procedure Registration1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ContentsItemClick(Sender: TObject);
    procedure DownloadMenuItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Debug1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SDIAppMenuGetImageIndex(Sender: TMenu; Item: TMenuItem;
      State: TMenuOwnerDrawState; var ImageIndex: Integer);
  private
    QuizChanged, NeverListShown : Boolean;
    procedure ShowScore;
  protected
   CurrPanel : TPanel;
   OldClickedImage :  TOnClickedImage;
   ListBrowsePanel1 : TListBrowsePanel;
   QuizBrowsePanel1 : TQuizBrowsePanel;
   procedure MafiaApp(Sender : TObject);
   procedure NewgameDisabledClick(Sender: TObject);
   procedure No(Sender : TObject);
   procedure Guessed(Sender : Tobject);
   procedure MainClickedImage(Sender : TObject; ImageName : String);
  public
    WebPage : String;
    QuizForm : TForm;
    BrowseForm : TForm;
    procedure DisableAll;
    procedure ReEnableAll;
    procedure ShowLevel(Level,Score : integer);
    procedure LoadQuiz(NT : integer; NS : Integer);
    procedure GameOver;
    procedure CheckMusic;
    procedure NextLevel(Sender : TObject; TimeLeft : integer);

  end;

var MainForm : TMainForm;



implementation

uses SysUtils, About,
   uScoreForm, uDebugForm, uUserForm, uColorForm,
  uDifficultyForm, uFlickDifficultyForm, uFlickColorForm, FlashBrowsePanel,
  uClickitAbout, uFPRegisterForm, uFlashPairAbout;

{$R *.DFM}

procedure TMainForm.ShowScore;
begin


  StatusBar.Panels[2].Text := 'Score : '+IntToStr(Round(Currgame.Score));       

end;

procedure TMainForm.ShowHint(Sender: TObject);
begin
  StatusBar.SimpleText := Application.Hint;
end;

procedure TMainForm.ShowLevel(Level, Score : Integer);
var LC : String;
begin
  {Label1.Caption}LC := 'Level '+IntToStr(Level) +Chr(13)+Chr(10)+
     'Score '+IntToStr(Score);
  MessageBox(0,PChar(LC),'Game in progress',0);
end;

procedure TMainForm.ExitItemClick(Sender: TObject);
begin



  if   Application.MessageBox(
        'Are you sure you want to leave?',
        'Message',
        MB_OKCANCEL ) = IDOK then begin
           Controller.Free;
          Close;
        end;


end;

procedure TMainForm.UserItemClick(Sender: TObject);
begin
  if {(UserForm <> nil) and} (Currgame = nil) then
    UserForm.Show;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  if {(ClickAboutBox <> nil) and } (Currgame = nil) then
    FlashPairAboutBox.Show;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin


  inherited;
  Application.OnHint := ShowHint;
  QuizBrowsePanel1 := TQuizBrowsePanel.Create(Self);                              

  ListBrowsePanel1 := TListBrowsePanel.Create(Self);                              
  with ListBrowsePanel1 do begin
    Parent := Self;
    TreeView.Images := ImageList1;
    Align := alClient;
    Font.Size := 8;
    Visible := True;
    OnClickedImage := MainClickedImage;
    PanelShow;
  end;
  CurrPanel := ListBrowsePanel1;
  QuizBrowsePanel1.Parent := Self;
  with QuizBrowsePanel1 do begin
    OnGuessed := Guessed;
    TreeView.Images := ImageList1;
    Align := alClient;
    Visible := False;

    OnAllGuessed := NextLevel;
    OnClickedImage := MainClickedImage;
  end;
  QuizBrowsePanel1.OnGameOver := GameOver;

end;


procedure TMainForm.MainClickedImage(Sender : TObject; ImageName : String);
begin
 // OldClickedImage(ImageName);


  Statusbar.Panels[0].Text := ImageName;
  Statusbar.Panels[1].Text := (Sender As TFlashBrowsePanel).GetIndexString;



end;

procedure TMainForm.No(Sender : TObject);
begin


  CurrGame.DecreaseScore(1.0);
  ShowScore;
  PlayWav(ExtractFilePath(Application.Exename)+'Sounds\No2.Wav');


end;

procedure TMainForm.Guessed(Sender : TObject);
begin


  CurrGame.AddScore(2.0*(1.0*(ListBrowsePanel1.ImagePanel1.GetMax/100)));
  ShowScore;
  PlayWav(ExtractFilePath(Application.Exename)+'Sounds\Whistle.Wav');


end;


procedure TMainForm.EnvironmentClick(Sender: TObject);
begin
  if (Currgame = nil) then begin
   // ListBrowsePanel1.PanelHide;
    FlickColorForm.ShowModal;
    ListBrowsePanel1.UpdateImageRes
  end;
end;

procedure TMainForm.LoadQuiz(NT : integer; NS : Integer);
begin


  if Quizform <> nil then begin {must be modified for Geoclick}
    try
      QuizForm.Show;
    except on EXception do begin
      QuizBrowsePanel1.GameOver;
      raise;
    end;
    end;
  end;


end;

procedure TMainForm.MapsMenuItemClick(Sender: TObject);
begin
  if  (CurrPanel = QuizBrowsePanel1) and  (Application.MessageBox(
        'Are you sure you want to abort the current game?',
        'Message',
        MB_OKCANCEL ) = IDOK)

    then begin

      QuizBrowsePanel1.GameOver;
      

    end;
end;

procedure TMainForm.NewgameDisabledClick(Sender: TObject);
begin
  MessageBox(0,'This feature has been disabled. Please Register!','Message',0);
end;

procedure TMainForm.NewgameItemClick(Sender: TObject);
begin


  if (Controller <> nil) and (Controller.CanStartGame) then begin
    ListBrowsePanel1.PanelHide;
    CurrPanel := QuizBrowsePanel1;
    CurrGame := Controller.CreateGame(Self);
    NextLevel(Self,0);
  end else begin
    MessageBox(0,'Cannot start level! Please choose more question per level or more images on the panel!','Warning',0);
    if BrowseForm <> nil then
      BrowseForm.Show;
  end;

end;

procedure TMainForm.CheckMusic;
begin
  if (Controller <> nil) and Controller.InterfaceOptions.MusicOn and ( (MediaPlayer1.Position >= MediaPlayer1.Length)) then begin
   try
    if Controller.InterfaceOptions.MusicFileName <> '' then
      MediaPlayer1.FileName := Controller.InterfaceOptions.MusicFileName;
    MediaPlayer1.Open;
    MediaPlayer1.Position:=0;
    MediaPlayer1.Play;
   except on EMCIDeviceError do end;
  end;
end;


procedure TMainForm.NextLevel(Sender : TObject; TimeLeft : integer);
begin


  if Currgame.Level > 1 then
    CurrGame.AddEndScore(TimeLeft,0);
  CurrGame.NextLevel;
  ShowLevel(Currgame.Level, Round(CurrGame.Score));

  StartLevelTimer.Enabled := True;
  if (Controller <> nil) and Controller.InterfaceOptions.MusicOn and (( Currgame.Level = 1) or (MediaPlayer1.Position >= MediaPlayer1.Length)) then begin
   try
    if Controller.InterfaceOptions.MusicFileName <> '' then
      MediaPlayer1.FileName := Controller.InterfaceOptions.MusicFileName;
    MediaPlayer1.Open;
    MediaPlayer1.Position:=0;
    MediaPlayer1.Play;
   except on EMCIDeviceError do end;
  end;


end;

procedure TMainForm.DisableAll;
begin


  NewBtn.OnClick := NewGameDisabledClick;
  NewGameItem.OnClick := NewGameDisabledClick;


end;

procedure TMainForm.ReEnableAll;
begin

  NewBtn.OnClick := NewGameItemClick;
  NewGameItem.OnClick := NewGameItemClick;

end;


procedure TMainForm.StartLevelTimerTimer(Sender: TObject);
var ByeStr : String;
    IVI, TTRT : integer;
begin


 try
  StartLevelTimer.Enabled := False;
  QuizBrowsePanel1.PanelShow;
  QuizBrowsePanel1.OnNo := No;
if CurrGame <> nil then
  CurrGame.StartLevel;
 except on Exception do
   QuizBrowsePanel1.GameOver
 end;


end;

procedure TMainForm.DifficultyItemClick(Sender: TObject);
begin
  if  (Currgame = nil) then
    FlashDifficultyForm.Show;
end;

procedure TMainForm.Scores1Click(Sender: TObject);
begin
  if (ScoreForm <> nil) and (Currgame = nil) then
    ScoreForm.Show;
end;

procedure TMainForm.GameOver;
var LC : String;
begin


  PlayWav(ExtractFilePath(Application.Exename)+'Sounds\Sound10.Wav');
  LC := 'GAME OVER' +Chr(13)+Chr(10)+
     'Score '+IntToStr(Round(Currgame.Score));
  MessageBox(0,PChar(LC),'Game over',0);
  //QuizBrowsePanel1.PanelHide;
  QuizBrowsePanel1.OnNo := nil;
  QuizBrowsePanel1.PanelHide;
  CurrPanel := ListBrowsePanel1;
  ListBrowsePanel1.PanelShow;
  if ScoreForm <> nil then begin
    ScoreForm.AddScore(Controller.Username,Round(Currgame.Score));
    ScoreForm.Save;
  end;

  if Controller <> nil then
    if Controller.InterfaceOptions.MusicOn then
      try
        MediaPlayer1.Stop;
      except on EMCIDeviceError do end;


end;

procedure TMainForm.Registration1Click(Sender: TObject);
begin

  RegisterForm.AReg := AReg;
  if (RegisterForm <> nil) and (Currgame = nil) then begin
    //RegisterForm.OnRegister := RegisterApp;
    RegisterForm.ShowModal;
    if RegisterForm.Registered then
      Caption := Application.Title+' by Diego Amicabile';
  end;
end;

procedure TMainForm.MafiaApp(Sender : TObject);
begin


  Caption := Application.Title+' by Diego Amicabile';
  ReEnableAll;


end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  RegisterForm.AReg := AReg;
  RegisterForm.CheckRegister;
  if RegisterForm.Registered then
    Caption := Application.Title+ ' by Diego Amicabile'
  else
    Caption := Application.Title+' by Diego Amicabile - EVALUATION VERSION';
end;

procedure TMainForm.ContentsItemClick(Sender: TObject);
var HelpFile : String;
begin
  HelpFile := ExtractFilePath(Application.Exename)+Application.Title+'.chm';
  ShowWebPage(HelpFile);
end;

procedure TMainForm.DownloadMenuItemClick(Sender: TObject);
begin
  
    ShowWebPage('http://clickit.pair.com/flashpair/collect/');
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TFlashBrowsePanel(CurrPanel).PanelHide;
  
end;

procedure TMainForm.Debug1Click(Sender: TObject);
begin
  DebugForm.Show;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
var Color : TColor;
begin
  //COlor := ListBrowsePanel1.ChangeColor;
  //QuizBrowsePanel1.ImagePanel1.Color := Color;
  (CurrPanel As TFlashBrowsePanel).ChangeColor;
end;

procedure TMainForm.SDIAppMenuGetImageIndex(Sender: TMenu; Item: TMenuItem;
  State: TMenuOwnerDrawState; var ImageIndex: Integer);
begin
  if Item = NewGameItem then
    ImageIndex :=  8
  else if Item = UserItem then
    ImageIndex :=  1
  else if Item = ExitItem then
    ImageIndex :=  11
  else if Item = ColorsItem then
    ImageIndex :=  2
  else if Item = Environment then
    ImageIndex :=  3
  else if Item = DifficultyItem then
    ImageIndex :=  4
  else if Item = Images then
    ImageIndex :=  5
  else if Item = Scores1 then
    ImageIndex :=  6
  else if Item = About1 then
    ImageIndex :=  10
  else if Item = ContentsItem then
    ImageIndex := 0
  else if Item = DownloadMenuItem then
    ImageIndex := 9
  else if Item = Registration1 then
    ImageIndex := 7

end;

end.
