unit FMX.Helpers.Text;

interface

uses
  FMX.Objects, FMX.Types,System.Classes,System.UITypes;

type
   TTextHelper = class helper for TText
      procedure Center;
      procedure Bold;
      function MarginLRTB(L,R,T,B:Single): TText;

      function MarginAll(A : Single): TText;
      function FundoColor(aFontColor :TAlphaColor):TText;

      constructor Create(AOwner: TComponent;aText :string; aFontSize: Single;
       aFontColor :TAlphaColor;  AlignLayout : TAlignLayout = TAlignLayout.Top;
       TextAlign :TTextAlign = TTextAlign.Center
       ); overload;


   end;

implementation

{ TTextHelper }

uses FMX.Helpers.Shape;

procedure TTextHelper.Bold;
begin
  TextSettings.Font.Style := [TFontStyle.fsBold];
end;

procedure TTextHelper.Center;
begin
   AutoSize := False;
   TextSettings.HorzAlign := TTextAlign.Center;
   TextSettings.VertAlign := TTextAlign.Center;
   Align := TAlignLayout.Client;

end;

constructor TTextHelper.Create(AOwner: TComponent; aText: string;
  aFontSize: Single; aFontColor: TAlphaColor;  AlignLayout : TAlignLayout = TAlignLayout.Top;
  TextAlign :TTextAlign = TTextAlign.Center);

begin
  inherited Create(AOwner);
  TFMXObject(AOwner).AddObject(Self);


  if AlignLayout = TAlignLayout.Top then
     AutoSize := True;
  TextSettings.HorzAlign := TTextAlign.Leading;
  Align := AlignLayout;
  Text := aText;
  Font.Size := aFontSize;
  TextSettings.FontColor := aFontColor;
  Position.Y := Self.Height * Self.ControlsCount;
  HitTest := False;

  if TextAlign =  TTextAlign.Center then
     Center
  else
      TextSettings.HorzAlign := TextAlign;

end;

function TTextHelper.FundoColor(aFontColor: TAlphaColor): TText;
var Fundo :TRectangle;
begin
   Fundo := TRectangle.Create(Self,TAlignLayout.Client, aFontColor);
   Result := Self;
end;

function TTextHelper.MarginAll(A: Single): TText;
begin
  MarginLRTB(A,A,A,A);

  Result := Self;
end;

function TTextHelper.MarginLRTB(L, R, T, B: Single): TText;
begin
  Margins.Top := T;
  Margins.Right := R;
  Margins.Bottom:= B;
  Margins.Left := L;
  Result := Self;
end;

end.