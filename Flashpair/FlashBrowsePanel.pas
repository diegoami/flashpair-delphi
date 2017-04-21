unit FlashBrowsePanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, uImagePanel, SimpleBrowseDCTreeView,
  uFileLoader, comctrls, uController, uFlashController, RxCtrls;

type

  TFlashBrowsePanel = class(TPanel)
  private
    { Private declarations }
  protected

    ReadRegister : Boolean;
    FOnClickedImage : ToNClickedImage;
    Panel1: TPanel;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    Splitter2: TSplitter;
    ColorDialog1: TColorDialog;
    Panel3: TPanel;
    Splitter3: TSplitter;
    Image1: TImage;
    TValues : TStrings;
    Deff : TSTrings;

    SS : TStrings;
    OldFileFound :      TOnFileFound;

    ImS : TSTrings;
    LoadingTree : Boolean;
    procedure AssignStringsToPanel; dynamic;
    procedure AddToPanel(Dir, Name : String); dynamic;
    procedure AddSimpleToPanel(Dir, Name : String);   dynamic;
    procedure OnClickNode(Sender : TObject; Node : TTreeNode); dynamic;
    procedure ShowImage(Sender : TObject; IMN : String);
    function GetCompleteDef(Dir, Name : String) : STring;
    function GetSmallDef(Dir, Name : String) : String;
  public

    ImagePanel1: TImagePanel;
    TreeView : TSimpleBrowseDCTreeView;
    procedure UpdateImageRes;
    function GetIndexString : String; dynamic;
    procedure Resize; override;
    function ChangeColor : TColor;
    constructor Create(AOwner : TComponent); override;
    procedure BrowsePanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Splitter2Moved(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    destructor Destroy; override;
    procedure PanelShow; virtual;
    procedure PanelHide; virtual;
    procedure ClickedImage(Sender : TObject; ImageName : String); dynamic;
    { Public declarations }
  published
    property OnClickedImage : TOnClickedImage read FOnClickedImage write FONClickedImage;
  end;

procedure Register;

implementation



procedure TFlashBrowsePanel.AddToPanel(Dir, Name : String);
begin
  { OldFileFound(Dir,Name); would be here if I wanted also to list files }
end;

function TFlashBrowsePanel.GetIndexString : String;
begin
  result := ''
end;


procedure TFlashBrowsePanel.ShowImage(Sender : TObject; IMN : String);
var VV : String;
begin
  {OnOverImage}

  Image1.Picture.LoadFromFile(IMN);
  if ImagePanel1.IsVisible(IMN) then begin
    VV := Deff.Values[ExtractFileName(IMN)];                
    if VV <> '' then
      FOnClickedImage(Self,VV)
    else
      FOnClickedImage(Self,ExtractFileName(IMN));
  end;

end;

procedure TFlashBrowsePanel.Resize;
var WW, IWW : integer;
   HH : integer;

begin

  

  WW := Width div 3 * 2;
  IWW := Width - WW - 10;
  HH := Height div 4 * 3;     
  with Splitter2 do begin
    Top := HH;
    Height := 10;
  end;
  with Splitter1 do begin
    Left := WW;
    Top := 0;
    Width := 6;
  end;
  with ImagePanel1 do begin
    Width := WW;
    Height := HH;
    Resize
  end;
  Panel1 := TPanel.Create(Self);
  with Panel1 do begin
    Left := WW;
    Top := 0;
    Width := IWW;
    Height := HH
  end;
  with  Splitter3 do begin
      Left := 1;
      Top := HH div 2-10;
      Height := 12;
    end;
    with Panel3 do begin
      Left := 1;
      Top := HH div 3 * 2;
//      Width := IWW;
      Height := HH div 2;
    end;

end;

constructor TFlashBrowsePanel.Create(AOwner : TComponent);
var WW, IWW : integer;
   HH : integer;
begin
{ creates Panel
  initializes TreeView
  initializes ImagePanel }


  LoadingTree := False;
  inherited;
  ReadRegister := False;
  WW := Width div 3 * 2;
  IWW := Width - WW - 10;
  HH := Height div 4 * 3;     
  Splitter2 := TSplitter.Create(Self);
  with Splitter2 do begin
    Parent := Self;
    Left := 0;
    Top := HH;
    Height := 10;
    Cursor := crVSplit;
    Align := alBottom;
    OnMoved := Splitter2Moved;
  end;
  Splitter1 := TSplitter.Create(Self);
  with Splitter1 do begin
    Parent := Self;
    Left := WW;
    Top := 0;
    Width := 6;
    Cursor := crHSplit;
    OnMoved := Splitter1Moved;
  end;
  ImagePanel1 := TImagePanel.Create(Self);
  with ImagePanel1 do begin
    Parent := Self;
    Left := 0;
    Top := 0;
    Width := WW;
    Height := HH;
    Align := alLeft;
    TabOrder := 0;
    OnMouseDown := BrowsePanelMouseDown;
    LabelVisible := True;
    Orientation := ImagePanelVertical;
    NImages := 16;
    NImagesOnRow := 4;
    ImIndex := 1;
  end;
  Panel1 := TPanel.Create(Self);
  with Panel1 do begin
    Parent := Self;
    Left := WW;
    Top := 0;
    Width := IWW;
    Height := HH;
    Align := alClient;

  end;
  Splitter3 := TSplitter.Create(Panel1);
 with  Splitter3 do begin
   Parent := Panel1;
      Left := 1;
      Top := Width-10;
      Height := 12;
      Cursor := crVSplit;
      Align := alBottom;
    end;
    Panel3 := TPanel.Create(Panel1);
    with Panel3 do begin
      Parent := Panel1;
      Left := 1;
      Top := HH div 3 * 2;
      Width := IWW;
      Height := 117;
      Align := alBottom;
      TabOrder := 0;
    end;
 Image1 := TImage.Create(Panel3);
 with Image1 do begin
   Parent := Panel3;
        Left := 1;
        Top := 1;
        Align := alClient;
        Stretch := True;
      end;
   ColorDialog1 := TColorDialog.Create(Self);

  TValues := TStringList.Create;
  Deff := TStringList.Create;
  IMS := TStringList.Create;

  TreeView := TSimpleBrowseDCTreeView.Create(Panel1);
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
  end;
  ImagePanel1.OnClickedImage := ClickedImage;
  ImagePanel1.OnOverImage := SHowImage;
  

end;


function TFlashBrowsePanel.GetCompleteDef(Dir, Name : String) : STring;
begin

  result := Dir+Name+'='+GetSmallDef(Dir,Name);


end;


function TFlashBrowsePanel.GetSmallDef(Dir, Name : String) : STring;
var
    CVAL : String;
  IOF : integer;
  SNAme : String;
begin

  SName := Copy(Name,1,Length(Name)-4); 
  //ListItem := ListView1.Items.Add;
  IOF := Deff.IndexOfName(Name);
  if IOF <> -1 then begin
    CVAL := Deff.Values[Name];
    //CVAL := Dir+Deff.Strings[IOF];
    result := CVAL
  end else begin
      result := SName
   end;

end;



procedure TFlashBrowsePanel.AddSimpleToPanel(Dir, Name : String);
{TreeView.OnClickedNode, TFileLoader.OnFileFound}
begin

  IMS.Add(GetCompleteDef(Dir,Name));


end;



procedure TFlashBrowsePanel.UpdateImageRes;
var kx, ky : integer;
begin
  if (Controller <> nil) and (TreeView.Selected <> nil) then begin
    (Controller As TFlashController).GetXYData(TreeView.Selected.Text,kx,ky);
    ImagePanel1.NImagesOnRow:= ky;
    ImagePanel1.NImages:= kx*ky;
    ImagePanel1.Resize
  end;
end;

procedure TFlashBrowsePanel.OnClickNode(Sender : TObject; Node : TTreenode);
var TS : String;
    TSF : String;
    TFL : TFileLoader;
    ITS : TStrings;
    kx, ky : integer;
begin
   { Loads Deff, IMS with key=values & complete defs for currentnode
     Puts Images and Image resolution for current node into ImagePanel1}


  if LoadingTree then exit;
  UpdateImageRes;
  TValues.Clear;
  ITS := TStringList.Create;
  TS := String(NOde.Data);
  TSF := TS+'index.txt'; 
  if FileExists(TSF) then begin
    ITS.LoadFromFile(TSF);
    Deff.AddStrings(ITS); 
  end;
  IMS.Clear;
  TFL := TFIleLoader.Create;
  TFL.AcceptedFiles := TreeView.FileLoader.AcceptedFiles;
  with TFL do begin  {fills IMS with complete def for images }
    RecursiveScan := False;
    OnFileFound :=AddSimpleToPanel;
    ScanDir(TS);
  end;                     
  AssignStringsToPanel;


end;

procedure TFlashBrowsePanel.AssignStringsToPanel;
begin


  (IMS as TStringList).Sort;
  ImagePanel1.AllBitmapFiles := IMS;

end;

procedure TFlashBrowsePanel.ClickedImage(Sender : TObject; ImageName : String);
var ListItem : TListItem;
begin

  if Assigned(FOnClickedImage) then
    FOnClickedImage(Self,ImageName);

end;

function TFlashBrowsePanel.ChangeColor : TColor;
begin
  if ColorDialog1.Execute then
    ImagePanel1.Color := ColorDialog1.Color;
  Invalidate;
  //PanelHide;
end;

procedure TFlashBrowsePanel.BrowsePanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    ChangeColor;
end;

procedure TFlashBrowsePanel.Splitter2Moved(Sender: TObject);
begin
  ImagePanel1.Resize;
end;
procedure TFlashBrowsePanel.Splitter1Moved(Sender: TObject);
begin
  ImagePanel1.Resize;
end;

destructor TFlashBrowsePanel.Destroy;
begin


  Splitter1.Free;
  Splitter2.Free;
  ImagePanel1.Free;
  Image1.Free;
  Panel3.Free;
  TreeView.Free;
  Splitter3.Free;
  Panel1.Free;
  TValues.Free;
  Deff.Free;
  IMS.Free;
  inherited;

end;

procedure TFlashBrowsePanel.PanelShow;
var kIndex : String;
begin

  Visible := True;
  LoadingTree := True;
  Resize;

end;

procedure TFlashBrowsePanel.PanelHide;
begin

  Visible := False;
  LoadingTree := False;


end;

procedure Register;
begin
  RegisterComponents('Geoclick', [TFlashBrowsePanel]);
end;

end.
