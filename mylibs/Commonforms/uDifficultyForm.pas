unit uDifficultyForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, ExtCtrls, Buttons;

type
  TDifficultyForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    RxSpinEdit1: TRxSpinEdit;
    RxSpinEdit2: TRxSpinEdit;
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    procedure OkClick(Sender: TObject); dynamic;
  end;




implementation

{$R *.DFM}

uses uController;

procedure TDifficultyForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TDifficultyForm.FormShow(Sender: TObject);
begin
  RXSpinEdit1.Value := Controller.spq;
  RXSpinEdit2.Value := Controller.qpl;
  with AReg do begin
    Active := True;
    Left := RSInteger('Forms','DifficultyLeft',Left);
    Top := RSInteger('Forms','DifficultyTop',Top);
    Active := False;
  end;




end;

procedure TDifficultyForm.OkClick(Sender: TObject);
begin
  Controller.spq := RXSpinEdit1.AsInteger;
  Controller.qpl := RXSpinEdit2.AsInteger;
  with AReg do begin
    Active := True;
    WSInteger('Forms','DifficultyLeft',Left);
    WSInteger('Forms','DifficultyTop',Top);
    Active := False;
  end;

  Controller.WriteDiffOptions;
  Close;
end;

procedure TDifficultyForm.FormCreate(Sender: TObject);
begin
  OkButton.OnClick := OkClick;
end;

end.
