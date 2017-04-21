unit uFlashGame;

interface
uses uGame;

type
  TFlashGame = class(TGame)
   public
    totimag : real;
    constructor Create(qpl, spq : integer; totim : integer);
    procedure AddScore(ScoreRel : real); override;
    procedure AddEndScore(ScoreRel : real; decreaselev : integer); override;
    procedure DecreaseScore(ScoreRel : real); override;
  end;

implementation

uses utils;

constructor TFlashGame.Create(qpl, spq : integer; totim : integer);
begin
  inherited Create(qpl, spq);
  totimag := Round(Totim)
end;

procedure TFlashGame.AddScore(ScoreRel : real);
var diffs : integer;
begin
  Score := Score+Scorerel*(1.0+(totimag-Round(qpl))/10.0);
end;

procedure TFlashGame.AddEndScore(ScoreRel : real; decreaselev : integer);
begin
  Score := Score+1.0*(Round(max(Round(ScoreRel)-sqp,0) /10));
end;

procedure TFlashGame.DecreaseScore(ScoreRel : real);
begin
  Score := Score-ScoreRel;
end;


end.
