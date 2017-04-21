unit uFlickDifficultyForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uDifficultyForm, StdCtrls, RXSpin, ExtCtrls, Ucontroller, uflashController,
  Buttons;

type
  TFlashDifficultyForm = class(TDifficultyForm)
    RxSpinEdit3: TRxSpinEdit;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    procedure OkClick(Sender: TObject); override;
  end;

var
  FlashDifficultyForm: TFlashDifficultyForm;

implementation

{$R *.DFM}

procedure TFlashDifficultyForm.FormShow(Sender: TObject);
begin
  RxSpinEdit3.Value :=  (Controller As TFlashController).noi;
  inherited;

end;

procedure TFlashDifficultyForm.OkClick(Sender: TObject);
begin
  if RxSpinEdit3.AsInteger < RxSpinEdit2.AsInteger then
    RxSpinEdit3.Value := RxSpinEdit2.AsInteger;
  (Controller As TFlashController).noi := RxSpinEdit3.AsInteger;

  inherited;

end;


end.
