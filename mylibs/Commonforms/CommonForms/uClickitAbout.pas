unit uClickitAbout;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, stringfns;

type             
  TClickitAboutBox = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    ProductName: TLabel;
    Copyright: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClickitAboutBox: TClickitAboutBox;

implementation

{$R *.DFM}

procedure TClickitAboutBox.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TClickitAboutBox.Label2Click(Sender: TObject);
begin
  ShowWebPage('mailto:diegoami@yahoo.it');
end;

procedure TClickitAboutBox.Label1Click(Sender: TObject);
begin
  ShowWebPage('http://clickit.pair.com');
end;

procedure TClickitAboutBox.FormCreate(Sender: TObject);
begin
  ProductName.Caption := Application.Title;
end;

end.

