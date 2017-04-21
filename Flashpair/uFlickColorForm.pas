unit uFlickColorForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uColorForm, StdCtrls, Mask, ToolEdit, RxCombos, RXSpin, OvalBtn, RXCtrls,
  ExtCtrls, uController, uFlashController, Buttons;

type
  TFlickColorForm = class(TColorForm)
    XRxSpinEdit: TRxSpinEdit;
    YRxSpinEdit: TRxSpinEdit;
    xLabel: TLabel;
    YLabel: TLabel;
    AllImagesCB: TCheckBox;
    procedure FormShow(Sender: TObject);
  
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OkButtonClick(Sender: TObject); override;
  end;

var
  FlickColorForm: TFlickColorForm;

implementation

{$R *.DFM}

procedure TFlickColorForm.FormShow(Sender: TObject);
var Kachx, kachy : integer;
begin
  inherited;
  (Controller As TFlashController).GetCurrCoords(kachx, kachy);
  XRxSpinEdit.Value := Kachx;
  YRxSpinEdit.Value := Kachy;
end;

procedure TFlickColorForm.OkButtonClick(Sender: TObject);
begin
  if not AllImagesCB.Checked then
    (Controller As TFlashController).PutCurrCoords(XRxSpinEdit.AsInteger, YRxSpinEdit.AsInteger)
  else begin
   (Controller As TFlashController).Kachx := XRxSpinEdit.AsInteger;
   (Controller As TFlashController).Kachy := YRxSpinEdit.AsInteger;
  end;
  inherited;
end;


end.
