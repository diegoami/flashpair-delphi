unit uBrowseForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, uImagePanel, SimpleBrowseDCTreeView, uFileLoader, comctrls, uController, uFlashController,
  ImgList;

type
  TBrowseForm = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    Splitter2: TSplitter;
    ColorDialog1: TColorDialog;
    Panel3: TPanel;
    Splitter3: TSplitter;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    //procedure ListView1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Splitter2Moved(Sender: TObject);
    {procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);}
    procedure Splitter1Moved(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);

  protected
    TValues : TStrings;
    Deff : TSTrings;

    SS : TStrings;
    OldFileFound :      TOnFileFound;

    TreeView : TSimpleBrowseDCTreeView;
    ImS : TSTrings;
    procedure AssignStringsToPanel; dynamic;
    procedure AddToPanel(Dir, Name : String); dynamic;
    procedure AddSimpleToPanel(Dir, Name : String);   dynamic;
    procedure OnClickNode(Sender : TObject; Node : TTreeNode); dynamic;
    procedure ShowImage(Sender : TObject; IMN : String);
  public
    ImagePanel1 : TImagePanel;
    procedure ClickedImage(Sender : TObject; ImageName : String); dynamic;
  end;


  //FSLoader : TFileLoader;
implementation

{$R *.DFM}

procedure TBrowseForm.ShowImage(Sender : TObject; IMN : String);
begin
  Image1.Picture.LoadFromFile(IMN);
end;

procedure TBrowseForm.FormCreate(Sender: TObject);


begin
  TValues := TStringList.Create;
  Deff := TStringList.Create;
  IMS := TStringList.Create;

  TreeView := TSimpleBrowseDCTreeView.Create(Self);
  TreeView.Parent := Panel1;
  TreeView.Align := AlClient;
  TreeView.Images := ImageList1;
  OldFileFound := TreeView.AddImageFIle;
  TreeView.FileLoader.OnFileFound := AddToPanel;
  TreeView.OnChange := OnClickNode;
  with TreeView.FileLoader do begin


    RecursiveScan := True;
    SS := TStringList.Create;
    SS.Add('.jpg');
    SS.Add('.bmp');
    SS.Add('.gif');
    AcceptedFiles := SS;
//    ScanDir('c:\Programme\Borland\Delphi 3\Miei\Flick\');
  end;
  ImagePanel1.OnClickedImage := ClickedImage;
  ImagePanel1.OnOverImage := SHowImage;
 {
  FSLoader := TFileLoader.Create;
  FSLoader.RecursiveScan := False;
  FSLoader.AcceptedFiles := SS;
  FSLoader.OnFileFound :=AddSimpleToPanel;}
  //ImagePanel1.AllBitmapFiles := IMS;
end;

procedure TBrowseForm.AddToPanel(Dir, Name : String);
begin                                                      
//  IMS.Add(Dir+Name);
//   OldFileFound(Dir,Name);
end;



procedure TBrowseForm.AddSimpleToPanel(Dir, Name : String);
var ListItem : TListItem;
  CVAL : String;
  IOF : integer;
  SNAme : String;
begin
  SName := Copy(Name,1,Length(Name)-4);
  //ListItem := ListView1.Items.Add;
  IOF := Deff.IndexOfName(Name);
  if IOF <> -1 then begin

    CVAL := Deff.Values[Name];
    CVAL := Dir+Deff.Strings[IOF];
    IMS.Add(CVal);
    {if ListView1.viewStyle = vsReport then begin
      ListItem.Caption := Name;
      ListItem.SubItems.Add(Deff.Values[Name]);
    end else
      ListItem.Caption := Deff.Values[Name];}
//  OldFileFound(Dir,Name);
  end else begin
      IMS.Add(Dir+Name);
      {ListItem.Caption := NAme;
      ListItem.SubItems.Add(SName);
      ListItem.Caption := Name}
  end;
 { if DESS.Count > 0 then begin
    IOF := Dess.IndexOfName(SName);
    if IOF <> -1 then
      ListItem.SubItems.Add(Dess.Values[SName]);
  end;}

end;


procedure TBrowseForm.FormResize(Sender: TObject);
begin
  ImagePanel1.Resize;
end;

procedure TBrowseForm.OnClickNode(Sender : TObject; Node : TTreenode);
var TS : String;
    TSF : String;

begin
  

  TValues.Clear;

  TS := String(NOde.Data);
  TSF := TS+'index.txt';
  if FileExists(TSF) then
    Deff.LoadFromFile(TSF);
  {TSF := TS+'desc.txt';
  if FileExists(TSF) then begin
    Dess.LoadFromFile(TSF);
    ListView1.ViewStyle := vsReport;
  end else
    ListView1.ViewStyle := vsSmallIcon;
  ListView1.Items.Clear;}
  IMS.Clear;
  with TreeView.FileLoader do begin
    RecursiveScan := False;
    OnFileFound :=AddSimpleToPanel;
    ScanDir(TS);
  end;
  AssignStringsToPanel;
  //Listview1.AlphaSort;


end;

procedure TBrowseForm.AssignStringsToPanel;
begin
  (IMS as TStringList).Sort;

  ImagePanel1.AllBitmapFiles := IMS;
end;

procedure TBrowseForm.ClickedImage(Sender : TObject; ImageName : String);
var ListItem : TListItem;
begin
  {ListItem := ListView1.FindCaption(0,ImageName,false,true,true);
  if ListItem <> nil then begin
    ListItem.MakeVisible(True);
    ListView1.Selected := ListItem;
    ListView1.Invalidate;
  end;}
end;

{
procedure TBrowseForm.ListView1Click(Sender: TObject);
begin
  if ListView1.Selected <> nil then
    ImagePanel1.FindValue(ListView1.Selected.Caption);

end;

}
procedure TBrowseForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    if ColorDialog1.Execute then
      ImagePanel1.Color := ColorDialog1.Color;
end;

procedure TBrowseForm.Splitter2Moved(Sender: TObject);
begin
  ImagePanel1.Resize;
end;
{
procedure TBrowseForm.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
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
}
{
procedure TBrowseForm.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if Column = ListView1.Columns[2] then
    ListView1.OnCompare := ListView1Compare
  else
    ListView1.OnCompare := nil;
  ListView1.AlphaSort;

end;
}
procedure TBrowseForm.Splitter1Moved(Sender: TObject);
begin
  ImagePanel1.Resize;
end;

procedure TBrowseForm.FormDestroy(Sender: TObject);
begin
  TValues.Free;
  Deff.Free;
  IMS.Free;

  TreeView.Free;
  

end;

procedure TBrowseForm.FormShow(Sender: TObject);
var kx, ky : integer;
begin
  kx := (Controller as TFlashController).kachx;
  ky := (Controller as TFlashController).kachy;
  Imagepanel1.NImagesOnRow := ky;
  Imagepanel1.NImages := kx*ky;
  with AReg do begin
    Active := True;
    Panel1.Width := RSInteger('Forms','TreePanelWidth',Panel1.Width);
    Left := RSinteger('Forms','BrowseMapsLeft',Left);
    Top := RSinteger('Forms','BrowseMapsTop',Top);
    Width := RSinteger('Forms','BrowseMapsWidth',Width);
    Height := RSinteger('Forms','BrowseMapsHeight',Height);
    Active := False;
  end;

end;

procedure TBrowseForm.FormHide(Sender: TObject);
begin
  with AReg do begin
    Active := True;
    WSInteger('Forms','TreePanelWidth',Panel1.Width);
    WSinteger('Forms','BrowseMapsLeft',Left);
    WSinteger('Forms','BrowseMapsTop',Top);
    WSinteger('Forms','BrowseMapsWidth',Width);
    WSinteger('Forms','BrowseMapsHeight',Height);
    Active := False;
  end;

end;

end.
