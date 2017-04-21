unit uColorForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, uController, StdCtrls, Mask, ToolEdit, RxCombos,
  RXCtrls, RXSpin, OvalBtn, Buttons;

type

  TColorForm = class(TForm)
    Panel1: TPanel;
    RxSpinEdit1: TRxSpinEdit;
    RxLabel1: TRxLabel;
    Label1: TLabel;
    ColorComboBox1: TColorComboBox;
    ColorComboBox2: TColorComboBox;
    Panel2: TPanel;
    FilenameEdit1: TFilenameEdit;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    FontDialog1: TFontDialog;
    SoundCheckBox: TCheckBox;
    OvalButton1: TOvalButton;
    
    procedure FormShow(Sender: TObject);

    procedure RxSpinEdit1Change(Sender: TObject);
    procedure ColorComboBox1Change(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private

    HemiDragType : boolean;
    { Private declarations }
  public
    procedure OkButtonClick(Sender: TObject); dynamic;

  end;

var
  ColorForm: TColorForm;

implementation

{$R *.DFM}

procedure TColorForm.FormShow(Sender: TObject);
begin
  with AReg do begin
    Active := True;
    Left := RSInteger('Forms','ColorLeft',Left);
    Top := RSInteger('Forms','ColorTop',Top);
    Active := False;
  end;

  OvalButton1.Caption := Controller.Username;
  OvalButton1.Color := Controller.ButtonOptions.FaceColor;
  OvalButton1.Width := Controller.ButtonOptions.Width;
  OvalButton1.Font := Controller.ButtonOptions.Font;
  RxSpinEdit1.Value := OvalButton1.Width;
  ColorComboBox1.ColorValue := OvalButton1.Color;
  ColorComboBox2.ColorValue := Controller.ButtonOptions.SelColor;
  Label4.Font.Assign(Controller.ButtonOptions.Font);
  Label4.Font.Style := Label4.Font.Style+[fsUnderline];
  Label4.Font.Color := clBlue;

  HemiDragType := False;
  FileNameEdit1.FileName := Controller.InterfaceOptions.MusicFileName;
  CheckBox1.Checked := Controller.InterfaceOptions.Musicon;
  SoundCheckBox.Checked := Controller.InterfaceOptions.Soundon;
  {CheckBox2.Checked := Controller.InterfaceOptions.NormalScroll;
  CheckBox3.Checked := Controller.InterfaceOptions.NormalZoom;   }

end;


procedure TColorForm.OkButtonClick(Sender: TObject);
begin
  with AReg do begin
    Active := True;
    WSInteger('Forms','ColorLeft',Left);
    WSInteger('Forms','ColorTop',Top);
    Active := False;
  end;

  Controller.ButtonOptions.Width := RxSpinEdit1.AsInteger;
  Controller.ButtonOptions.FAceColor := OvalButton1.Color;
  Controller.ButtonOptions.SelColor := ColorComboBox2.ColorValue;
  Controller.ButtonOptions.Font := OvalButton1.Font;
  Controller.InterfaceOptions.MusicFileName := FileNameEdit1.FileName;
  Controller.InterfaceOptions.Musicon:= CheckBox1.Checked;
  Controller.InterfaceOptions.Soundon:= SoundCheckBox.Checked;
{  Controller.InterfaceOptions.NormalScroll := CheckBox2.Checked;
  Controller.InterfaceOptions.NormalZoom := CheckBox3.Checked;}
  Controller.WriteButtonOptions;
  Controller.WriteInterfaceOptions;

  Close;

end;

procedure TColorForm.RxSpinEdit1Change(Sender: TObject);
begin
 OvalButton1.Width := RxSpinEdit1.AsInteger;
end;

procedure TColorForm.ColorComboBox1Change(Sender: TObject);
begin
  OvalButton1.Color := ColorComboBox1.ColorValue;

end;


procedure TColorForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TColorForm.Label4Click(Sender: TObject);
begin
  FontDialog1.Font := OvalButton1.Font; 
  if FOntDialog1.Execute then begin

    OvalButton1.Font := FontDialog1.Font;

    Label4.Font.Assign(FontDialog1.Font);
    Label4.Font.Style := Label4.Font.Style+[fsUnderline];
    Label4.Font.Color := clBlue;

  end;
  COlorCombobox1Change(Self);

end;

procedure TColorForm.FormCreate(Sender: TObject);
begin
  OkButton.OnClick := OkButtonClick;
end;

end.
