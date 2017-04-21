unit uGame;

interface

type
  TGame = class(TObject)
   public
    level : integer;
    Score : real;
    ScoreModifier : real;
    qpl, sqp : integer;
    constructor Create(lqpl, lsqp : integer);
    procedure AddScore(ScoreRel : real); dynamic;
    procedure AddEndScore(ScoreRel : real; decreaselev : integer); dynamic;
    procedure DecreaseScore(ScoreRel : real); dynamic; abstract;
    procedure GameOver;
    procedure StartLevel;
    procedure NextLevel;

  end;

var
    CurrGame : TGame;


implementation


uses uController, sysutils;

constructor TGame.Create(lqpl, lsqp : integer);
begin

  qpl := lqpl;
  sqp := lsqp;

  ScoreModifier := 1;
  Level :=0;
  Score := 0;

end;

procedure TGame.AddScore(ScoreRel : real);
var STA : real;
begin
  STA := ScoreRel*ScoreModifier;
  {if not GeoController.ClearedMaps then
    STA := STA/10;}
 Score := Score+STA;
end;


procedure TGame.AddEndScore(ScoreRel : real; decreaselev : integer);
var STA : integer;
begin
  
    STA := Round(ScoreRel-decreaselev);
  if STA > 0 then
    Score := Score+STA;
end;

procedure TGame.NextLevel;
begin
  Inc(Level);
end;

procedure TGame.StartLevel;
begin
end;

procedure TGame.GameOver;
begin
end;


end.
