unit uFlashPairAbout;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, stringfns;

type             
  TFlashPairAboutBox = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    ProductName: TLabel;
    Copyright: TLabel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    procedure OKButtonClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FlashPairAboutBox: TFlashPairAboutBox;

implementation

{$R *.DFM}

procedure TFlashPairAboutBox.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFlashPairAboutBox.Label2Click(Sender: TObject);
begin
  ShowWebPage('mailto:diegoami@yahoo.it');
end;

procedure TFlashPairAboutBox.Label1Click(Sender: TObject);
begin
  ShowWebPage('http://clickit.pair.com');
end;

procedure TFlashPairAboutBox.BitBtn1Click(Sender: TObject);
begin
  Close
end;

end.

