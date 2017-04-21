unit uDCSimpleFolderTreeView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, dcDTree;

type
  TDCSimpleFolderTreeView = class(TDCMSTreeView)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Geoclick', [TDCSimpleFolderTreeView]);
end;

end.
