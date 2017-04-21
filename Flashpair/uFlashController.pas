unit UFlashCOntroller;

interface

uses Ucontroller, uGame;

type
  TFlashController = class(TController)
    noi : integer;
    kachx, kachy : integer;
    SelSindex : String;
   public
    function GetIndex : String;
    procedure PutIndex(Sindex : String);
    procedure GetXYData(Text : STring; var kx,ky : integer);
    procedure PutXYData(Text : String;  kx,ky : integer);
    procedure ReadDiffOptions; override;
    procedure ReadInterfaceOptions; override;
    procedure PutCurrCoords(kx, ky : integer);
    procedure GetCurrCoords(var kx, ky : integer);
    procedure WriteInterfaceOptions; override;
    procedure WriteDiffOptions; override;
    function CanStartGame : boolean; override;
    function CreateGame(Sender : TObject) : TGame; override;
  end;

implementation

uses uFlashGame, uImagePanel;

function TFlashController.CreateGame(Sender : TObject) : TGame;
var kx, ky : integer;
begin
  GetCurrCoords(kx,ky);
  result := TFlashGame.Create(qpl,spq,kx*ky);
end;

procedure TFlashController.ReadDiffOptions;
begin
  inherited;
  with AReg do begin
    Active := True;
    noi := RSInteger('Difficulty','NOI',noi);
    Active := False;
  end;
end;

function TFlashController.GetIndex : String;
begin
  with AReg do begin
    Active := True;
    result := RSString('Scales','Index','');
    Active := False;
  end;
end;

procedure TFlashController.PutIndex(Sindex : String);
begin
  SelSIndex := Sindex;
  with AReg do begin
    Active := True;
    WSString('Scales','Index',Sindex);
    Active := False;
  end;
end;


procedure TFlashController.PutXYData(Text : String;  kx,ky : integer);
begin
  with AReg do begin
    Active := True;
    WSinteger('Scales',Text+'.X',kx);
    WSinteger('Scales',Text+'.Y',ky);
    Active := False
  end;
end;

procedure TFlashController.GetXYData(Text : String;  var kx,ky : integer);
begin
  with AReg do begin
    Active := True;
    kx := RSinteger('Scales',Text+'.X',kachx);
    ky := RSinteger('Scales',Text+'.Y',kachy);
    WSINTEGER('Scales',Text+'.X',kx);
    WSINTEGER('Scales',Text+'.Y',ky);                                 
    Active := False
  end;
end;

procedure TFlashController.GetCurrCoords(var kx, ky : integer);
begin
  GetXYData(SelSINdex,kx,ky);

end;

procedure TFlashController.PutCurrCoords(kx, ky : integer);
begin
   PutXYData(SelSIndex,Kx,ky)
end;


procedure TFlashController.WriteInterfaceOptions;
begin
  inherited;
  with Areg do begin
    Active := True;
    if (kachx*kachy < MAXIMAGES) and (kachx*kachy > 0) then begin
      WSInteger('InterfaceOptions','kachx',kachx);
      WSInteger('InterfaceOptions','kachy',kachy);
    end;
    Active := False;
  end;
end;

function TFlashController.CanStartGame : boolean;
var kx, ky : integer;
begin
  GetCurrCoords(kx,ky);
  result :=  (kx * ky) > qpl;
end;

procedure TFlashController.ReadInterfaceOptions;
var kx,ky : integer;
begin
  inherited;
  with Areg do begin
    Active := True;

    kx := RSInteger('InterfaceOptions','kachx',4);
    ky := RSInteger('InterfaceOptions','kachy',4);
    if (kx*ky < MAXIMAGES) and (kx*ky > 0) then begin
      kachx := kx;
      kachy := ky
    end else begin
      kachx := 3;
      kachy := 3
    end;
    Active := False;
  end;
end;

procedure TFlashController.WriteDiffOptions;
begin
  inherited;
  with AReg do begin
    Active := True;
    WSInteger('Difficulty','NOI',noi);
    Active := False;
  end;
end;

end.
