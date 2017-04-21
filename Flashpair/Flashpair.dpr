program Flashpair;

uses
  Forms,
  sysutils,
  uDebugForm in '..\Geosource\Components\uDebugForm.pas' {DebugForm},
  uClickitMainForm in 'uClickitMainForm.pas' {MainForm},
  uGame in 'uGame.pas',
  uController in 'uController.pas',
  uScoreForm in 'uScoreForm.pas' {ScoreForm},
  uFlashController in 'uFlashController.pas',
  uColorForm in '..\Mylibs\CommonForms\uColorForm.pas' {ColorForm},
  uUserForm in '..\Mylibs\CommonForms\uUserForm.pas' {UserForm},
  uBrowseForm in 'uBrowseForm.pas' {BrowseForm},
  SimpleBrowseDCTreeView in 'SimpleBrowseDCTreeView.pas',
  uFileLoader in 'uFileLoader.pas',
  uImagePanel in 'uImagePanel.pas',
  uFlickDifficultyForm in 'uFlickDifficultyForm.pas' {FlashDifficultyForm},
  uDifficultyForm in '..\Mylibs\CommonForms\uDifficultyForm.pas' {DifficultyForm},
  uFlickColorForm in 'uFlickColorForm.pas' {FlickColorForm},
  ListBrowsePanel in 'ListBrowsePanel.pas',
  FlashBrowsePanel in 'FlashBrowsePanel.pas',
  QuizBrowsePanel in 'QuizBrowsePanel.pas',
  About in '..\MyLibs\HiReg\About.pas' {AboutForm},
  uFlashGame in 'uFlashGame.pas',
  Utils in 'Utils.pas',
  OvalButtonsPanel in '..\Geoclick\Components\OvalButtonsPanel.pas',
  StringFns in '..\Mylibs\StringFns.pas',
  uClickitAbout in '..\Mylibs\CommonForms\uClickitAbout.pas',
  uFPRegisterForm in 'uFPRegisterForm.pas' {RegisterForm},
  uFlashPairAbout in 'uFlashPairAbout.pas' {FlashPairAboutBox},
  GIFImage in '..\Source\GifImage\gifimage.pas';

{$R *.RES}

begin
  Application.Initialize;
  Controller := TFlashController.Create;

  
  Application.Title := 'FlashPair';

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TScoreForm, ScoreForm);
  Application.CreateForm(TUserForm, UserForm);
  Application.CreateForm(TFlashDifficultyForm, FlashDifficultyForm);
  Application.CreateForm(TFlickColorForm, FlickColorForm);
  Application.CreateForm(TRegisterForm, RegisterForm);
  Application.CreateForm(TFlashPairAboutBox, FlashPairAboutBox);
  MainForm.Webpage := 'http://clickit.pair.com/flashpair/collect/';

  Application.Run;
end.
