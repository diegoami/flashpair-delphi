unit SimpleBrowseDCTreeView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, dcDTree, uFileLoader;

type
  TIterateProc = function(Node : TTreeNode) : boolean of object;
  TSimpleBrowseDCTreeView = class(TDCMSTreeView)
   private
     CheckedNodes : TStrings;
     FFileLoader : TFIleLoader;
     AllDirs : TStrings;
     FoundNode : TTreeNode;
      CL : integer;
    Nodes : array[0..10] of  TTreeNode;

     TS : String;
     function CheckNode(Node : TTreeNode) : boolean;
     function UnCheckNode(Node : TTreeNode) : boolean;
 //    function CheckNodeIfInStrings(StringsToCheck : TStrings);
    function CheckDataInNodes(Node : TTreeNode) : boolean;
    function GetDataInNodes(Node : TTreeNode) : boolean;
    function DeleteNodeifDir(Node : TTreeNode) : boolean;
function GetNodeifText(Node : TTreeNode) : boolean;

  protected

    procedure IterateTree(IterateProc : TIterateProc);
    procedure AddFolderFile(Dir : String);
    procedure LastFolderFile(Dir : String);
  public
    CurrNode : TTreeNode;
    procedure DeleteDir(Dir : String);
    destructor Destroy; override;
    procedure AddImageFile(Dir, Name : String);
    constructor Create(AOwner : TComponent); override;
    procedure SetChecked;
    procedure SetUnChecked;
    function GetDataInCheckedNodes : TStrings;
    function GetAllDataInNodes : TStrings;
    procedure CheckNodesInStrings(StringsToCheck : TStrings);
    function GetNodeByText(Text : String) : TTreeNode;

  published
    property FileLoader : TFileLoader read FFileLoader write FFileLoader;
  end;

procedure Register;

implementation

uses utils;

procedure TSimpleBrowseDCTreeView.CheckNodesInStrings(StringsToCheck : TStrings);
var i : integer;
  SD : String;
  Node : TTreeNode;
begin
  for i := 0 to Items.Count-1 do begin
    NOde := Items.Item[i];
    SD := String(Node.Data);
    if StringsToCheck.Indexof(SD) <> -1 then
      TDrawNode(Node).CheckState := csChecked;
  end;
end;

function TSimpleBrowseDCTreeView.GetNodeifText(Node : TTreeNode) : boolean;
begin
  if Node.Text = TS then
    FoundNode := Node
end;


function TSimpleBrowseDCTreeView.GetNodeByText(Text : String) : TTreeNode;
begin
  FoundNode := Items[0];
  TS := Text;
  IterateTree(GetNodeIfText);
  result := FoundNode
end;


function TSimpleBrowseDCTreeView.CheckDataInNodes(Node : TTreeNode) : boolean;
begin
  if Node = nil then
    exit;
  if TDrawNode(Node).Checkstate = CsChecked then
    CheckedNodes.Add(String(Node.Data));
end;

function TSimpleBrowseDCTreeView.GetDataInCheckedNodes : TStrings;
begin
  CheckedNodes.Clear;
  IterateTree(CheckDataInNodes);
  result := CheckedNodes;
end;


function TSimpleBrowseDCTreeView.GetDataInNodes(Node : TTreeNode) : boolean;
begin
  if Node = nil then
    exit
  else
    CheckedNodes.Add(String(Node.Data));
end;

function TSimpleBrowseDCTreeView.GetAllDataInNodes : TStrings;
begin
  CheckedNodes.Clear;
  IterateTree(GetDataInNodes);
  result := CheckedNodes;
end;

function TSimpleBrowseDCTreeView.CheckNode(Node : TTreeNode) : boolean;
begin

    TDrawNode(Node).CheckState:= csChecked;
    result := false;
end;


function TSimpleBrowseDCTreeView.UnCheckNode(Node : TTreeNode) : boolean;
begin
  TDrawNode(Node).CheckState:= csUnChecked;
end;

procedure TSimpleBrowseDCTreeView.SetChecked;
begin
  IterateTree(CheckNode);
end;

procedure TSimpleBrowseDCTreeView.SetUnChecked;
begin
  IterateTree(UnCheckNode);
end;


procedure TSimpleBrowseDCTreeView.IterateTree(IterateProc : TIterateProc);
var i : integer;
  CNode,NNode : TTreeNode;
begin
  if Items.Count <= 0 then exit;
  CNode := Items.Item[0];
  while CNode <> nil  do begin

    NNode := CNode.GetNext;
    IterateProc(CNode);
    CNode := NNode;
  end;
end;



destructor TSimpleBrowseDCTreeView.Destroy;
begin
  AllDirs.Free;
  //CheckedNodes.Free;
  FFileLoader.Free;
  inherited;
end;

constructor TSimpleBrowseDCTreeView.Create(AOwner : TComponent);
begin
  inherited;
  HideSelection := False;
  AllDirs := TstringList.Create;
  CheckedNodes := TStringList.Create;
  CL := 1;
  Nodes[CL] := nil;
  FFIleLoader := TFileLoader.Create;
  FFileLoader.OnFileFound := AddImageFile;
  FFileLoader.OnDirFound := AddFolderFile;
  FFileLoader.OnDirEnd := LastFolderFile;
end;

procedure TSimpleBrowseDCTreeView.AddImageFile(Dir,Name : String);
var NewNode : TTreeNode;
    NName : String;
begin
  //NNAME := DelBSlash(Name);
  NewNode := Items.AddChild(Nodes[CL],Name);
  NewNode.ImageIndex := 2;
  NewNode.SelectedIndex := 2;
  CurrNode := NewNode;

end;

procedure  TSimpleBrowseDCTreeView.AddFolderFile(Dir: String);
var LastDir : String;
begin

  if CL < 0 then CL := 0;
  LastDir := TFileLoader.GetLAstDir(Dir);
  Nodes[CL+1] := Items.AddChild(Nodes[CL],LastDir);
  Nodes[CL+1].ImageIndex    := 0;
  Nodes[CL+1].SelectedIndex := 1;
  CurrNode := Nodes[CL+1];
//  AllDirs.Add(Dir);
  CurrNode.Data := PChar(AllDirs.Strings[AllDirs.Add(Dir)]);
  inc(CL);
end;

procedure TSimpleBrowseDCTreeView.LastFolderFile(Dir: String);
begin
  dec(CL);
end;

function TSimpleBrowseDCTreeView.DeleteNodeifDir(Node : TTreeNode) : boolean;
begin
  if Pos(TS,Node.Text) > 0 then
    Items.Delete(Node);
end;

procedure TSimpleBrowseDCTreeView.DeleteDir(Dir : String);
begin
  TS := Dir;
  IterateTree(DeleteNodeifDir)
end;



procedure Register;
begin
  RegisterComponents('Geoclick', [TSimpleBrowseDCTreeView]);
end;

end.
