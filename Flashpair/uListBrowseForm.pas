unit uListBrowseForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, uImagePanel, SimpleBrowseDCTreeView, uFileLoader, comctrls, uBrowseForm;

type
  TListBrowseForm = class(TBrowseForm)
    ListView1: TListView;

    procedure ListView1Click(Sender: TObject);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormDestroy(Sender: TObject);

  protected
    CurrNode : TTreeNode;
    LoadingList : Boolean;
    Dess : TStrings;
    procedure AddToPanel(Dir, Name : String); override;
    procedure AddSimpleToPanel(Dir, Name : String);  override;
    procedure OnClickNode(Sender : TObject; Node : TTreeNode); override;
    procedure CheckedNode(Sender: TObject; Node: TTreeNode);

  public
    procedure ClickedImage(ImageName : String); override;
  end;

var
  ListBrowseForm: TListBrowseForm;
  //FSLoader : TFileLoader;
implementation

{$R *.DFM}

uses dcDTree, Ucontroller;

{procedure TListBrowseForm.ShowImage(IMN : String);
begin
  Image1.Picture.LoadFromFile(IMN);
end;
}
procedure TListBrowseForm.AddToPanel(Dir, Name : String);
begin
  inherited;
//  IMS.Add(Dir+Name);
//   OldFileFound(Dir,Name);
end;

procedure TListBrowseForm.AddSimpleToPanel(Dir, Name : String);
var ListItem : TListItem;
  CVAL : String;
  IOF : integer;
  SNAme : String;
  SS : String;
begin
  inherited;
  SName := Copy(Name,1,Length(Name)-4);
  ListItem := ListView1.Items.Add;
  IOF := Deff.IndexOfName(Name);
  if IOF <> -1 then begin
    if ListView1.viewStyle = vsReport then begin

      ListItem.Caption := Deff.Values[Name];
      ListItem.SubItems.Add(Name);
    end else begin
      ListItem.Caption := Deff.Values[Name];
      ListItem.SubItems.Add(Name);
    end;
//  OldFileFound(Dir,Name);
  end else begin

      ListItem.Caption := NAme;
      ListItem.SubItems.Add(SName);
      ListItem.Caption := Name
  end;
  if DESS.Count > 0 then begin
    IOF := Dess.IndexOfName(SName);
    if IOF <> -1 then
      ListItem.SubItems.Add(Dess.Values[SName])
    else
      ListItem.SubItems.Add(SName)

  end else
    ListItem.SubItems.Add(SName);
  SS := ListItem.SubItems.Strings[0];
  ListItem.Checked := (TDrawNode(CurrNode).CheckState = csChecked) or (Controller.ExcludeNames.IndexOf(SS) = -1);


end;



procedure TListBrowseForm.OnClickNode(Sender : TObject; Node : TTreenode);
var TS : String;
    TSF : String;

begin
  CurrNode := Node;
  Dess.Clear;
  TS := String(NOde.Data);

  TSF := TS+'desc.txt';
  if FileExists(TSF) then begin
    Dess.LoadFromFile(TSF);
    ListView1.ViewStyle := vsReport;
  end else
    ListView1.ViewStyle := vsSmallIcon;
  ListView1.Items.Clear;
  LoadingList := True;
  inherited;
  Listview1.AlphaSort;
  LoadingList := False;
  //CheckedNode(Sender,Node);
end;

procedure TListBrowseForm.ClickedImage(ImageName : String);
var ListItem : TListItem;
begin
  inherited;
  ListItem := ListView1.FindCaption(0,ImageName,false,true,true);
  if ListItem <> nil then begin
    ListItem.MakeVisible(True);
    ListView1.Selected := ListItem;
    ListView1.Invalidate;
  end;
end;


procedure TListBrowseForm.ListView1Click(Sender: TObject);
begin
  if ListView1.Selected <> nil then
    ImagePanel1.FindValue(ListView1.Selected.Caption);

end;




procedure TListBrowseForm.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var SC1, SC2 : integer;
begin
  Compare := 0;
  SC1 := Item1.SubItems.Count;
  SC2 := Item2.SubItems.Count;
  if SC1 < 2 then Compare := 1;
  if SC2 < 2  then Compare := Compare-1;
  if (SC1 < 2) or (SC2 < 2) then
    exit;
  Compare := CompareStr(Item1.SubItems.Strings[1], Item2.SubItems.Strings[1]);
end;

procedure TListBrowseForm.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if Column = ListView1.Columns[2] then
    ListView1.OnCompare := ListView1Compare
  else
    ListView1.OnCompare := nil;
  ListView1.AlphaSort;

end;




procedure TListBrowseForm.FormCreate(Sender: TObject);
begin

  inherited;
  TreeView.FileLoader.ScanDir('c:\Programme\Borland\Delphi 3\Miei\Flick\');

  CurrNode := niL;
  Dess := TStringList.Create;
  TreeView.Checkboxes := True;
  TreeView.SetUnChecked;
  //TreeView.OnChange := OnClickNode;
  TreeView.OnClickCheck := CheckedNode;
  Controller.AllSel := TreeView.GetAllDataInNodes;
end;

procedure TListBrowseForm.CheckedNode(Sender: TObject; Node: TTreeNode);
var i : integer;
  ListItem : TListItem;

begin
  inherited;
  CurrNode := Node;
  for i := 0 to ListView1.Items.Count-1 do begin
    ListItem := ListView1.Items[i];
    ListItem.Checked := (TDrawNode(Node).CheckState = csChecked);
  end;               
  Controller.SelectedStrings.Assign(TreeView.GetDataInCheckedNodes);
  Controller.SaveExclusions;
end;

procedure TListBrowseForm.FormShow(Sender: TObject);
begin
  inherited;

  Controller.LoadExclusions;
  TreeView.CheckNodesInStrings(Controller.SelectedStrings);

end;

procedure TListBrowseForm.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var CS : String;
begin
  inherited;

  if LoadingList then exit;
  CS := Item.SubItems.Strings[0];
  if Item.Checked then
    Controller.Include(CS)
  else
    Controller.Exclude(CS);
  Controller.SaveExclusions;
end;

procedure TListBrowseForm.FormDestroy(Sender: TObject);
begin
  Dess.Free;
  inherited;

end;

end.
