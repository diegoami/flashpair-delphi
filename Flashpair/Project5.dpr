program Project5;

uses
  Forms,
  uClickitMainForm in 'uClickitMainForm.pas' {ClickItMainForm},
  uRegisterForm in 'uRegisterForm.pas' {RegisterForm},
  uGame in 'uGame.pas',
  uController in 'uController.pas',
  StringFns in '..\StringFns.pas',
  uScoreForm in 'uScoreForm.pas' {ScoreForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TClickItMainForm, ClickItMainForm);
  Application.CreateForm(TRegisterForm, RegisterForm);
  Application.CreateForm(TScoreForm, ScoreForm);
  Application.Run;
end.
