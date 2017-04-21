unit uImagePanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  ExtCtrls, forms, stdctrls, jpeg, utils, rxctrls, stringfns;

const
  MAXIMAGES = 100;

type
  ETooManyImages = class(Exception);
  TOnClickedImage = procedure (Sender : TObject; ImageName : String) of object;
  TImagePanelOrientation = (ImagePanelVertical, ImagePanelHorizontal);
  TImagePanel = class(TPanel)
  private
    FNImages : integer;
    FAllBitmapFile : string;
    FAllBitmapFiles : TStrings;
    FOnClickedImage : TOnClickedImage;
    FOnOverImage : TOnClickedImage;

    FIndex : Integer;
    FOrientation : TImagePanelOrientation;
    FNImagesOnRow : integer;
    FLabelFont : TFont;
    FLabelVisible : Boolean;
    procedure setAllBitmapFile(FileName : String);
    function ConvertRealToIndex(R : integer) : integer;
    function GetRealName(index : Integer) : String;
    procedure setAllBitmapFiles(FileNames : TStrings);
    procedure SetIndex(Ind : Integer);
    procedure setNImages(NIM : Integer);
    procedure OrderByBelLabel;
    function GetOrder(Image : TIMage) : integer;
    function ConvertIndexToReal(Ind : integer) : integer;
  protected
    //LeftButton, RightButton : TButton;
    SelectedImage : TImage;
    Images : array[1..MAXIMAGES] of TImage;
    Labels : array[1..MAXIMAGES] of TRxLabel;
    ScrollBar : TScrollBar;
    CurrBevel : TShape;
    procedure ImageClick(Sender : TObject);
    function BeautifyLabel(S : String) : String;
    procedure BevelClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure UpdateFiles;
    procedure ScrollBarChange(Sender : TObject);
    procedure SetLabelVisible(LV : boolean);
    procedure setLabelFont(LF : TFont);
    procedure ButtonClick(Sender : TObject);
    procedure MouseOverImage(Sender: TObject; Shift: TShiftState; X, Y: Integer);

  public
    function IsVisible(ImageName : STring) : boolean;
    function FindValue(SC : STring; MustCenter : boolean) : integer;
    procedure SelectImage(Image : TImage);
    function getCurrPos : integer;
    function getMax : integer;
    procedure Resize; override;
    procedure ShowName(Name : String; MustCenter : Boolean);

    destructor Destroy; override;
    procedure Loaded; override;
    constructor Create(AOwner : TComponent); override;
  published
    property LabelFont : TFont read FLabelFont write setLabelFont;
    property LabelVisible : boolean read FLabelVisible write setLabelVisible;
    property Orientation : TImagePanelOrientation read FOrientation write FOrientation;
    property NImages : integer read FNImages write setNImages;
    property NImagesOnRow : integer read FNimagesOnRow write FNImagesOnRow;
    property AllBitmapFile : string read FAllBitmapFile write setAllBitmapFile;
    property AllBitmapFiles : TStrings read FAllBitmapFiles write setAllBitmapFiles;
    property ImIndex : integer read FIndex write SetIndex;
    property OnClickedImage : TOnClickedImage read FOnClickedImage write FOnClickedImage;
    property OnOverImage : TOnClickedImage read FOnOverImage write FOnOverImage;

  end;

procedure Register;

implementation

uses uDebugForm;

procedure TImagePanel.OrderByBelLabel;
var BelLabel : TStringList;
 i : integer;
 TAF : TStrings;
 Ci : integer;
 CS : String;
begin
  if DebugForm = nil then exit;
  BelLabel := TStringList.Create;
  TAF := TStringList.Create;
  TAF.Assign(AllBitmapFiles);
  for i := 0 to AllBitmapFiles.Count-1 do begin
    CS  := GetRealName(i);
    //Log(CS + ' ' + IntToStr(i));
    BelLabel.AddObject(CS,TObject(i));
  end;
  BelLabel.Sort;
  for i := 0 to BelLabel.Count-1 do begin
    CI := Integer(BelLabel.Objects[i]);
    AllBitmapFiles.Strings[I] := TAF.Strings[CI]
  end;
end;

function TImagePanel.GetCurrPos : integer;
begin
  result := GetOrder(SelectedImage)+FIndex;
end;

function TImagePanel.GetMax : integer;
begin
  result := max(FAllBitmapFiles.Count,NImages);
end;

procedure TImagePanel.BevelClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ImageClick(SelectedImage);
end;

function TImagePanel.ConvertIndexToReal(Ind : integer) : integer;
var Dex : integer;
begin
  Dex := max(min(max(Ind+Findex-1,0),FAllBitmapFiles.Count-1),0);
  result := Dex;
end;

function TImagePanel.ConvertRealToIndex(R : integer) : integer;
var FIn : integer;
begin
  FIn := R-FIndex+1;
  if FIn < 1 then FIn := 1;
  If Fin > NImages then FIn := NImages;
  result := FIn;
end;


procedure TImagePanel.SetLabelVisible(LV : boolean);
var i : Integer;
begin
  FLabelVisible := LV;
  for i := 1 to FNImages do if Labels[i] <> nil then
    Labels[i].Visible := LV;
end;

procedure TIMagePanel.Loaded;
var i : integer;
begin
  FIndex := 0;
  OrderByBelLabel;
  for i := 1 to FNImages do begin
    LAbels[i].Visible := FLabelVisible;
    Labels[i].Font := FLabelFont;
    Labels[i].Caption := FAllBitmapFiles.Strings[ConvertIndexToReal(i)];
  end;

  for i := 0 to FAllBitmapFiles.Count-1 do
    FAllBitmapFiles.Objects[i] := TObject(FLabelVisible);
end;

procedure TImagePanel.ShowName(Name : String; MustCenter : Boolean);
var ff : integer;
begin
  FF := FindValue(Name, false);
  FAllBitmapFiles.Objects[FF] := TObject(True); 
  if MustCenter then
    SelectImage(Images[ConvertRealToIndex(FF)]);
  UpdateFiles;
end;


procedure TImagePanel.SetLabelFont(LF : TFont);
var i : Integer;
begin
  FLabelFont.Assign(LF);
  if FNImages > 0 then
  for i := 1 to FNImages do if Labels[i] <> nil then
    Labels[i].Font := LF;
end;

function TImagePanel.IsVisible(ImageName : STring) : boolean;
var Ind : integer;
  i : integer;
  S : String;
begin
  result := false;
  for i := 0 to FAllBitmapFiles.Count-1 do begin
    S := FAllBitmapFiles.Strings[i];
    if pos(ImageName,S) > 0 then

      result := FLabelVisible or boolean(FAllBitmapFiles.Objects[i]);
  end;
end;



constructor TImagePanel.Create(AOwner : TComponent);
var i : integer;
begin
  inherited Create(AOwner);
  Caption := '';
  FLAbelFont := TFont.Create;
  CurrBevel := TShape.Create(Self);
  CurrBevel.Brush.Style := bsClear;
  CurrBevel.Pen.Width := 2;
  CurrBevel.OnMouseDown := BevelClick;
  FIndex  := 0;
  FAllBitmapFiles := TStringList.Create;
  ScrollBar := TScrollBar.Create(self);
  ScrollBar.Parent := Self;
  ScrollBar.OnChange := ScrollBarChange;
  for i := 1 to FNImages do begin
    Images[i] := TImage.Create(Self);
    Images[i].Parent := Self;
    Images[i].Stretch := True;
    Images[i].OnClick := ImageClick;
    Images[i].OnMouseMove := MouseOverImage;
    Labels[i] := TRxLabel.Create(Self);

    Labels[i].Parent := Self;
    if FAllBitmapFile <> '' then
      Images[i].Picture.LoadFromFile(FAllBitmapFile)
    else
      Images[i].Picture := nil;
  end;
//  ScrollBar := TControlScrollBar(Self,sbHorizontal);
  if (NImages > 0) and (NIMagesOnRow > 0) then
    Resize;
end;

destructor TImagePanel.Destroy;
var i : integer;
begin
  for i := 1 to FNimages do begin
    Images[i].Free;
    Labels[i].Free;
  end;
  fLabelFont.Free;
  FAllBitmapFiles.Free;
  ScrollBar.Free;
  CurrBevel.Free;
  inherited;
end;

function TImagePanel.FindValue(SC : STring; MustCenter : Boolean) : integer;
var i : integer;
  CIF : String;
begin

  result := 0;
  for i := 0 to FAllBitmapFIles.Count-1 do begin
    CIF := FAllBitmapFiles.Strings[i];
    if Pos(SC,CIF) > 0 then begin
      result := i
    end
  end;
  if MustCenter then begin
    SetIndex(result);
  end;
end;

function TImagePanel.GetOrder(Image : TIMage) : integer;
var i : integer;
begin

  result := 0;
  for i := 1 to FNImages do
    if Images[i] = Image then
      result := i;

end;

procedure TImagePanel.ImageClick(Sender : TObject);
var FN : String;
  Oor : Integer;

  SN : String;
begin
  OOr := ConvertIndexToReal(GetOrder(Sender AS TIMage));
  SelectImage(Sender As TImage);
  if Assigned(FOnClickedImage) then begin
    SN := GetRealName(OOr);
    FONclickedImage(Self,SN);
  end;
end;

function TImagePanel.GetRealName(index : integer) : String;
var Rim,SF,N : String;
begin

    N := FAllBitmapFiles.Names[index];
    RIM := String(FAllBitmapFiles.Values[N]);
    if RIM = '' then begin
      SF :=ExtractFileName(FAllBitmapFiles.Strings[index]);
      result := Copy(SF,1,Length(SF)-4)
    end else
      result := RIM;
end;



procedure TImagePanel.Resize;
  procedure VerticalResize;
  var i,j : integer;
   xgrid, ygrid : integer;
   divid : integer;
   CurrImage : TImage;
   CurrLabel : TRxLabel;
  begin
    xgrid := Width div (FNImagesOnRow*4-1);
    divid := 4+((FNImages div FNImagesOnRow)-1)*3;
    ygrid := (Height - 20) div divid;
    for i := 1 to FNImagesOnRow do
      for j := 1 to FNImages div FNImagesOnRow do begin
        CurrImage := Images[(j-1)*FNimagesOnRow+i];
        CurrLabel := Labels[(j-1)*FNimagesOnRow+i];
        CurrLabel.Left := ((i-1)*3)*Xgrid;
        CurrLabel.Top := (3 + (j-1)*3)*YGrid;
        CurrLabel.Width := XGrid*3;
        
        CurrImage.Left := (1+(i-1)*3)*Xgrid-xgrid div 2;
        CurrImage.Width := XGrid*2;
        CurrImage.Height := YGrid*2;
        CurrImage.Top := (1 + (j-1)*3)*YGrid;
      end;
  end;

  procedure HorizontalResize;
  var i,j : integer;
   xgrid, ygrid : integer;
   divid : integer;
   CurrImage : TImage;
   CurrLabel : TRxLabel;
  begin
    divid := 4+((FNImages div FNImagesOnRow)-1)*3;
    xgrid := Width div divid;

    ygrid := (Height-20) div (FNImagesOnRow*4-1);
    for i := 1 to FNImages div FNImagesOnRow do
      for j := 1 to FNImagesOnRow do begin
        CurrImage := Images[(i-1)*FNimagesOnRow+j];
        CurrLabel := Labels[(i-1)*FNimagesOnRow+j];
        CurrLabel.Left := ((i-1)*3)*Xgrid - xgrid;
        CurrLabel.Top := (3 + (j-1)*3)*YGrid;
        CurrLabel.Width := XGrid*3;
        
        CurrImage.Height := YGrid*2;

        CurrImage.Left := (1+(i-1)*3)*Xgrid;
        CurrImage.Width := XGrid*2;
        CurrImage.Height := YGrid*2;
        CurrImage.Top := (1 + (j-1)*3)*YGrid;
      end;

  end;

begin
  if FOrientation = ImagePanelHorizontal then
    HorizontalResize
  else
    VerticalResize;
  ScrollBar.Height := Height-10;
  ScrollBar.Left := Width - 20;
  ScrollBar.Kind := sbVertical;
  ScrollBar.Width := 20;
  SelectImage(SelectedImage);
  UpdateFiles;
end;

procedure TImagePanel.setNImages(NIM : Integer);
var i : integer;
  BefNImages : integer;
begin
  if NIM > MAXIMAGES then begin
    raise ETooManyImages.Create('Too many Images on panel');
    exit
  end;
  BefNImages := FNimages;
  FNImages := NIM;
  for i := 1 to NIM do begin
    if Images[i] = nil then begin
      Images[i] := TImage.Create(Self);
      Images[i].Parent := Self;
      Images[i].Stretch := True;
      Images[i].OnClick := ImageClick;
      Images[i].OnMouseMove := MouseOverImage;
    end;
    if Labels[i] = nil then begin
      Labels[i] := TRxLabel.Create(Self);
      
      Labels[i].Parent := Self;
    end;
  end;
  if BefNImages > FNImages then
    for i := FNimages+1 to BefNImages do begin
      Images[i].Free;
      Labels[i].Free;
      Images[i] := nil;
      Labels[i] := nil;
    end;
  if (FAllBitmapFiles.Count-NIMages) > 0 then
    ScrollBar.Max := FAllBitmapFiles.Count-NImages;
  ScrollBar.LargeChange := NImages;
  UpdateFiles;
  ScrollBar.Visible := GetMax > NImages;
end;

procedure TImagePanel.setAllBitmapFile(FileName : String);
var i : integer;
begin

  FAllBitmapFile := FileName;
  for i := 1 to NImages do
    Images[i].Picture.LoadFromFile(FileName);
  
end;

procedure TImagePanel.setAllBitmapFiles(FileNames : TStrings);
var i : integer;
begin
  if FileNames.Count = 0 then exit;

  FAllBitmapFiles.Assign(FileNames);
  for i := 0 to FAllBitmapFiles.Count-1 do
    FAllBitmapFiles.Objects[i] := TObject(FLabelVisible);
  Findex := 0;
  ScrollBar.Min := 0;
  ScrollBar.Position := 0;
  ScrollBar.Max := max(FileNames.Count-NImages,1);
  ScrollBar.LargeChange := NImages;
  OrderByBelLabel;
  UpdateFiles;
  Resize;
  ScrollBar.Visible := GetMax > NImages;
end;

procedure TImagePanel.MouseOverImage(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var OOr : integer;
  SN : String;
  Or1 : integer;
begin
 try
  if (Sender = nil) or ((Sender as TImage).Picture = nil ) then exit;
  Or1 := GetOrder(Sender AS TIMage);
  if (Or1 = 0) or (FAllBitmapFiles.Count=0) then exit;
  OOr := ConverTindexToReal(Or1);
  if Assigned(FOnOverImage) then begin
    SN := FallBitmapFiles.Names[OOr];

    if (SN = '') and ((OOr) < FAllBitmapFiles.Count) then
      FONOverImage(Self,FAllBitmapFiles.Strings[OOR])
    else
      FOnOverImage(Self,SN);
  end;
 except on EStringListError do end;
end;

function TImagePanel.BeautifyLabel(S : String) : String;
var P : integer;
  i : integer;
  CB : Integer;
  SPS : String;
  NS : integer;

begin
  CB := 18;
  result := S;
  if Length(S) >= CB then begin
    P := Pos(' ',S);
    NS := min(Length(S)-min(CB,P),CB div 3);
    SPS := GetSpaces(NS);
    result := Copy(S,1,P-1)+#10+#13+SPS+Copy(S,P,Length(S)-P+1);
  end else
    P := Length(S);
    NS := CB-P;
         SPS := GetSpaces(NS);



    result := SPS+result;

end;

procedure TImagePanel.SelectImage(Image : TImage);
begin

  if Image = nil then exit;
  SelectedImage := Image;
  CurrBevel.Parent := Self;
  CurrBevel.Left := Image.Left-5;
  CurrBevel.Top := Image.Top-5;
  CurrBevel.Width := Image.Width + 10;
  CurrBevel.Height := Image.Height+10;
end;

procedure TImagePanel.UpdateFiles;
var i, jr : integer;
  ox , oy : integer;
  SV, SN, SNN : String;
begin
  OrderByBelLabel;
  for i := 1 to NImages do begin
    jr := ConvertIndexToReal(i);
    if (jr < FAllBitmapFiles.Count) and (jr >= 0) then begin
      ox := Labels[i].Left;
      oy := Labels[i].Top;

      Labels[i].Free;
      Labels[i] := TRxLabel.Create(Self);
      Labels[i].Parent := Self;
      Labels[i].Left := ox;
      Labels[i].Top := oy;
      //Labels[i].Alignment := taCenter;
      Labels[i].Font.Assign(LabelFont);
      Labels[i].Visible := FLabelVisible or boolean(FAllBitmapFiles.Objects[ConvertIndexToReal(i)]);
      SN := FAllBitmapFiles.Names[jr];
      SV := FAllBitmapFiles.Values[SN];
      if SV <> '' then begin
        if (Images[i] = nil) or (Labels[i] = nil) then begin
          raise Exception.Create('Trying to update nil Image');
          exit;
        end;
        Images[i].Picture.LoadFromFile(SN);
        Labels[i].Caption := BeautifyLabel(SV);
        //Labels[i].Caption := SV;
      end else begin
        if Pos('=',SN) = 0 then begin
          Images[i].Picture.LoadFromFile(SN);
          SNN := ExtractFileName(SN);
          //
          Labels[i].Caption := BeautifyLabel(Copy(SNN,1,Length(SNN)-4));
          //Labels[i].Caption := Copy(SNN,1,Length(SNN)-4);
        end
      end
    end else begin
      Images[i].Picture := nil;
      Labels[i].Caption := '';
    end;
  end;
    //SelectImage(SelectedImage);
    CurrBevel.Parent := nil;

    Invalidate;
end;


procedure TImagePanel.SetIndex(Ind : Integer);
begin
  FIndex := max(min(max(Ind,0),GetMax-NImages),0);

  ScrollBar.Position := FIndex;
  UpdateFiles;
  //SelectImage(Images[1]);
end;


procedure TImagePanel.ScrollBarChange(Sender : TObject);
begin
  ImIndex := ScrollBar.Position;
  if FNImages >= 1 then
    ImageClick(Images[1]);

end;

procedure TImagePanel.ButtonClick(Sender : TObject);
begin
{  if Sender = LeftButton then
    ScrollBar.Position := ScrollBar.Position-FNImagesOnRow
  else
    ScrollBar.Position := ScrollBar.Position+FNImagesOnRow;
}end;

procedure Register;
begin
  RegisterComponents('Geoclick', [TImagePanel]);
end;

end.
