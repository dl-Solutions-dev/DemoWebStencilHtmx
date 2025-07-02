unit UDMSession;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  System.SyncObjs;

type
  TDMSession = class( TDataModule )
    Export_sqlConnection: TFDConnection;
    QryUsers: TFDQuery;
    QryUsersID_USER: TIntegerField;
    QryUsersNOM: TWideStringField;
    QryUsersPRENOM: TWideStringField;
    QryUser: TFDQuery;
    QryUserID_USER: TIntegerField;
    QryUserNOM: TWideStringField;
    QryUserPRENOM: TWideStringField;
    QrySeq: TFDQuery;
    QrySeqNEWID: TLargeintField;
    QryUserCancel: TFDQuery;
    IntegerField1: TIntegerField;
    WideStringField1: TWideStringField;
    WideStringField2: TWideStringField;
    procedure DataModuleCreate( Sender: TObject );
    procedure DataModuleDestroy( Sender: TObject );
  private
    FCritical: TCriticalSection;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property Critical: TCriticalSection read FCritical;
  end;

var
  DMSession: TDMSession;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure TDMSession.DataModuleCreate( Sender: TObject );
begin
  FDManager.Active := True;
  FCritical := TCriticalSection.Create;
end;

procedure TDMSession.DataModuleDestroy( Sender: TObject );
begin
  FreeAndNil( FCritical );
end;

end.
