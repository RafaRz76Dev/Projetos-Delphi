unit FMX.Helpers.Image;

interface

uses
   FMX.Graphics, FMX.ImgList, FMX.MultiResBitmap, FMX.Objects, FMX.Types,
   System.Classes, System.Net.URLClient, System.Net.HttpClient,
   System.Net.HttpClientComponent,
   System.Types, System.SysUtils;

type
   TImageHelper = class helper for TImage
     procedure ImageByName(Name :String);
     function Size(const ASize :Single) :TImage;
     function AddText(aText:String): TImage;
     procedure LoadFromURL(const aFileName :string);
     procedure GeraQrCode;
     constructor Create(AOwner :TComponent; ImageName: String ;
         AlignLayout : TAlignLayout = TAlignLayout.Left) overload;

   end;

type
   TBitmapHelper = class helper for TBitmap
     procedure LoadFromURL(const aFileName :string; qrCode :string = '');
   end;

var
  ImageList :TImageList;

implementation

uses System.IOUtils;

{ TImageHelper }

function TImageHelper.AddText(aText: String): TImage;
begin
   Hint := Hint + atext;
   Result := Self;
end;

constructor TImageHelper.Create(AOwner: TComponent; ImageName: String;
  AlignLayout: TAlignLayout);
begin
   inherited Create(AOwner);
   Align := AlignLayout;
   ImageByName(ImageName);
   TFMXObject(AOwner).AddObject(Self);
   Width := Height;


end;

procedure TImageHelper.GeraQrCode;
begin
   Bitmap.LoadFromURL(Hint);
end;

procedure TImageHelper.ImageByName(Name: String);
var
   Item : TCustomBitmapItem;
   Size :TSize;
begin
   if ImageList.BitmapItemByName(Name,Item,Size) then
      Self.Bitmap := Item.MultiResBitmap.Bitmaps[1.0]

end;

procedure TImageHelper.LoadFromURL(const aFileName: string);
begin
   Bitmap.LoadFromURL(aFileName);
end;

function TImageHelper.Size(const ASize: Single): TImage;
begin
   Hint := 'https://chart.apis.google.com/chart?cht=qr&chs='+ InttoStr(Trunc(aSize))+'x'+InttoStr(Trunc(aSize))+'&';
   Result := Self;
end;

{ TBitmapHelper }

procedure TBitmapHelper.LoadFromURL(const aFileName: string; qrCode :string = '');
var
   MyFile :TFileStream;
   NetHTTPClient : TNetHTTPClient;
   FileName :string;
begin
   if aFileName <> '' then begin
      if qrCode <> '' then
         FileName := qrCode
      else
         FileName := TPath.GetFileNameWithoutExtension(aFileName);

      TThread.CreateAnonymousThread(
      procedure()
      begin
         MyFile := TFileStream.Create(
                                   TPath.Combine(
                                   TPath.GetDocumentsPath,
                                   FileName),fmCreate);

         try
           NetHTTPClient := TNetHTTPClient.Create(nil);
           NetHTTPClient.Get(aFileName,MyFile);
         finally
           NetHTTPClient.DisposeOf;
         end;

         TThread.Synchronize(TThread.CurrentThread,
         procedure ()
         begin
            try
               Self.LoadFromStream(MyFile);
            except
               Self.Clear(0);
            end;
            MyFile.DisposeOf;
         end);

      end).Start;
   end;

end;


end.
