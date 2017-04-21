unit ListBrowsePanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, uImagePanel, SimpleBrowseDCTreeView, uFileLoader, comctrls, FlashBrowsePanel, AMReg;

type
  TListBrowsePanel = class(TFlashBrowsePanel)

  protected
    ListView1: TListView;
    Panel2 : TPanel;
    procedure ListView1Click(Sender: TObject);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure DefineList(LV : TListView);
  protected
    CurrNode : TTreeNode;
    LoadingList : Boolean;
    Dess : TStrings;
    procedure AddToPanel(Dir, Name : String); override;
    procedure PanelHide ; override;
    procedure AddSimpleToPanel(Dir, Name : String);  override;
    procedure OnClickNode(Sender : TObject; Node : TTreeNode); override;
    procedure CheckedNode(Sender: TObject; Node: TTreeNode);
  public
    function GetIndexString : String; override;
    procedure Resize; override;
    constructor Create(AOwner : TComponent); override;
    procedure PanelShow; override;
    destructor Destroy; override;
    procedure ClickedImage(Sender : TObject; ImageName : String); override;
  end;

implementation


uses dcDTree, Ucontroller, uFlashController;

procedure TListBrowsePanel.AddToPanel(Dir, Name : String);
begin
  inherited;
end;

function TListBrowsePanel.GetIndexString : String;
begin
  result :=  IntToStr(ImagePanel1.GetCurrPos)+'/'+IntToStr(ImagePanel1.GetMax);
end;


procedure TListBrowsePanel.PanelHide ;
begin

  {try
   if (TreeView.Selected <> nil) and (Controller <> nil) then
     TFlashController(Controller).PutIndex(TreeView.Selected.Text); //LOGGER.LOG('TreeView.Selected.Text='+TreeView.Selected.Text,2);
  except on Exception do end;
}
  inherited;
  with AReg do begin
    Active := True;
    WSInteger('Forms','ListTreePanelWidth',ImagePanel1.Width);
    WSInteger('Forms','ListPanelWidth',Panel1.Width);
    WSInteger('Forms','ListListPanelHeight',Panel2.Height);
    WSInteger('Forms','ListImagePanelColor',ImagePanel1.Color);
    WSinteger('Forms','ListBrowseMapsLeft',Left);
    WSinteger('Forms','ListBrowseMapsTop',Top);
    WSinteger('Forms','ListBrowseMapsWidth',Width);
    WSinteger('Forms','ListBrowseMapsHeight',Height);
    WSinteger('Forms','ListFlagPanelHeight',Panel3.Height);     
    Active := False;
  end;

end;

procedure TListBrowsePanel.AddSimpleToPanel(Dir, Name : String);
var ListItem : TListItem;
  CVAL : String;
  IOF : integer;
  SNAme : String;
  SimpleDef : String;
begin
  { Adds ListItems to ListView }

  inherited;

  ListItem := ListView1.Items.Add;
  SimpleDef := GetSmallDef(Dir,Name);
  ListItem.Caption := SimpleDef;
  ListItem.SubItems.Add(Name);
//    OldFileFound(Dir,Name);

  if DESS.Count > 0 then begin   //checks if description available
    IOF := Dess.IndexOfName(SimpleDef);
    if IOF <> -1 then
      ListItem.SubItems.Add(Dess.Values[SName])
  end;
  ListItem.Checked := (TDrawNode(CurrNode).CheckState = csChecked) or (Controller.ExcludeNames.IndexOf(SimpleDef) = -1);

end;

procedure TListBrowsePanel.OnClickNode(Sender : TObject; Node : TTreenode);
var TS : String;
    TSF : String;
begin

  (Controller As TFLashController).SelSIndex := Node.Text;

  Dess.Clear; CurrNode := Node;
  ListView1.Items.Clear;
  LoadingList := True;
  inherited;
  LoadingList := False;
  TS := String(NOde.Data); TSF := TS+'desc.txt';
  if FileExists(TSF) then
    Dess.LoadFromFile(TSF);
  ListView1.ViewStyle := vsReport;
  Listview1.AlphaSort;
end;

procedure TListBrowsePanel.ClickedImage(Sender : TObject; ImageName : String);
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

procedure TListBrowsePanel.ListView1Click(Sender: TObject);
begin
  if ListView1.Selected <> nil then
    ImagePanel1.FindValue(ListView1.Selected.Caption, true);

end;

procedure TListBrowsePanel.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
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

procedure TListBrowsePanel.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if Column = ListView1.Columns[2] then
    ListView1.OnCompare := ListView1Compare
  else
    ListView1.OnCompare := nil;
  ListView1.AlphaSort;
end;


procedure TListBrowsePanel.Resize;
var  WW, HH, IHH : integer;
  IW, IH : integer;
begin
  inherited;
  WW := Width div 3 * 2;
  HH := Height div 4 * 3;
  IHH := Height-HH;
  {Splitter2.Top := HH;
  Splitter2.Height := 8;
  Splitter1.Height :=HH;
  ImagePanel1.Height := HH;
  Panel1.Height := HH;
  //Splitter3.Top := IHH;
  Panel3.Top := IHH;    }
  with Panel2 do begin
    Left := 0;
    Top := HH;

    Height := IHH-10;
  end;
 try
  with AReg do begin
    Active := True;
    IH := RSinteger('Forms','ListBrowseMapsHeight',Height);
    IW := RSinteger('Forms','ListBrowseMapsWidth',Width);
    if ( (abs(IH-Height) < 15) and (abs(IW-Width) < 15) ) then begin

     Panel2.Height := RSinteger('Forms','ListListPanelHeight',Panel2.Height);

     ImagePanel1.Color := RSInteger('Forms','ListImagePanelColor',ImagePanel1.Color);
     Panel3.Height := RSinteger('Forms','ListFlagPanelHeight',Panel3.Height);

     ImagePanel1.Width := RSInteger('Forms','ListTreePanelWidth',ImagePanel1.Width); 
//    Splitter1.Left := RSInteger('Forms','SplitterLeft',Splitter1.Left);
     Panel1.Width := RSInteger('Forms','ListPanelWidth',Panel1.Width); 

     Left := RSinteger('Forms','ListBrowseMapsLeft',Left);
     Top := RSinteger('Forms','ListBrowseMapsTop',Top);
     Width := RSinteger('Forms','ListBrowseMapsWidth',Width);
     Height := RSinteger('Forms','ListBrowseMapsHeight',Height);
    end;
     Active := False;
  end;
 except on EAMRegError do end;
end;

constructor TListBrowsePanel.Create(AOwner : TComponent);
var NewColumn : TListColumn;
   WW, HH, IHH : integer;
begin
  WW := Width div 3 * 2;
  HH := Height div 4 * 3;
  IHH := Height-HH;
  inherited;     {
  Splitter2.Top := WW;
  Splitter2.Height := 8;
  Splitter1.Height :=HH;
  ImagePanel1.Height := HH;
  Panel1.Height := HH;
  Splitter3.Top := IHH;
  Panel3.Top := IHH;}
  Panel2 := TPanel.Create(Self);
  with Panel2 do begin
    Parent := Self;
    Left := 0;
    Top := HH;
    Height := IHH;
    Align := alBottom;
    TabOrder := 2
  end;
  ListView1 := TListView.Create(Panel2);
  with ListView1 do begin
    Parent := Panel2;
    Left := 1;
    Top := 1;
    Align := alClient;
    IconOptions.WrapText := True;
    IconOptions.AutoArrange := False;
    IconOptions.Arrangement := iaLeft;
    ViewStyle := vsReport;
    OnClick := ListView1Click;
  end;


  Dess := TStringList.Create;
  Resize;
end;


procedure TListBrowsePAnel.DefineList(LV : TListView);
var NewColumn : TListColumn;
begin
  with LV do begin
    NewColumn := Columns.Add;
    NewColumn.Caption := 'ID';
    NewColumn.Width := 150;
    NewColumn := Columns.Add;
    NewColumn.Caption := 'FileName';
    NewColumn.Width := 150;
    NewColumn := Columns.Add;
    NewColumn.Caption := 'Description';
    NewColumn.Width := 500;
    IconOptions.AutoArrange := True;
    Checkboxes := True;
    OnChange := ListView1Change;
    OnColumnClick := ListView1ColumnClick;
    TabOrder := 0;
    ViewStyle := vsReport
  end;
end;

procedure TListBrowsePAnel.CheckedNode(Sender: TObject; Node: TTreeNode);
var i : integer;
  ListItem : TListItem;
begin
  inherited;
  CurrNode := Node;
  for i := 0 to ListView1.Items.Count-1 do begin
    ListItem := ListView1.Items[i];
    ListItem.Checked := (TDrawNode(Node).CheckState = csChecked);
    Controller.Include(ListItem.Caption)
  end;
  for i := 0 to Node.Count-1 do
    TDrawNode(Node.Item[i]).CheckState := TDrawNode(Node).CheckState;
  Controller.SelectedStrings.Assign(TreeView.GetDataInCheckedNodes);
  Controller.SaveExclusions;
end;

procedure TListBrowsePanel.PanelShow;
var NewColumn : TlistColumn;
 i : integer;
 SIndex : String;
begin
  { Clears and fills TreeView
   initializes Controller.AllSel
   Checkes Selected Strings in TreeView }
  inherited;
  ImagePanel1.Resize;
  TreeView.Items.Clear;
  LoadingList := True;
  TreeView.FileLoader.ScanDir(ExtractFilePath(Application.ExeName));
  LoadingList := False;   LoadingTree := False;

  CurrNode := nil;
  TreeView.Checkboxes := True;
  TreeView.SetUnChecked;
  //TreeView.OnChange := OnClickNode;
  TreeView.OnClickCheck := CheckedNode;
  Controller.AllSel := TreeView.GetAllDataInNodes;
  Controller.LoadExclusions;
  TreeView.CheckNodesInStrings(Controller.SelectedStrings);         

  try
    SIndex := (Controller as TFlashController).GetIndex;
    if SIndex = '' then
      raise Exception.Create('Not Found');
    TreeView.Selected := Treeview.GetNodeByText(SIndex); 


    (Controller As TFLashController).SelSIndex := Sindex;
  except on Exception do begin
    TreeView.Selected := Treeview.Items[0];




   i := 0;

   repeat
    TreeView.Selected := TreeView.Items[i];
    inc(I)
   until ImagePanel1.GetMax > ImagePanel1.NImages;
   
   CheckedNode(Self,TDrawNode(TreeView.Selected));
   end;
  end;

  DefineList(ListView1); //must be here, otherwise "No parent window"
  TreeView.DeleteDir('Drivers');
  TreeView.DeleteDir('Sound');
    TreeView.DeleteDir('Sounds');

  
end;

procedure TListBrowsePanel.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin


  inherited;
  if not ((LoadingList) or (Ord(Change) < 0)) then begin
   try
    if Controller = nil then exit;

    if Item.Checked then
      Controller.Include(Item.Caption)
    else
      Controller.Exclude(Item.Caption);
    Controller.SaveExclusions;
   except on Exception do end;
  end;
end;

destructor TListBrowsePanel.Destroy;
begin
  ListView1.Free;
  Panel2.Free;
  Dess.Free;
  inherited;

end;

end.
