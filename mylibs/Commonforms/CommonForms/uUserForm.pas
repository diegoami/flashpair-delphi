unit uUserForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, uController;

type
  TUserForm = class(TForm)
    Label1: TLabel;
    OKButton: TButton;
    CancelButton: TButton;
    ComboBox1: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UserForm: TUserForm;

implementation

{$R *.DFM}

procedure TUserForm.FormShow(Sender: TObject);
begin

  ComboBox1.Items.Clear;
  ComboBox1.Items.Assign(Controller.GetAllUsers);

  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(Controller.Username);
end;

procedure TUserForm.OKButtonClick(Sender: TObject);

begin

  //GeoController.Username := ComboBox1.Items[ComboBox1.ItemIndex];
  Controller.Username := ComboBox1.Text;
  Close;
end;

procedure TUserForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

end.
