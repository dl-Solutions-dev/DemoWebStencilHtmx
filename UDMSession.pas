(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-02T23:34:44.000+02:00
  Signature : 688c77ce6b65b539e848d84171d5c38a1d6c7c96
  ***************************************************************************
*)

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
  System.SyncObjs, Datasnap.DBClient;

type
  TDMSession = class( TDataModule )
    CnxExport: TFDConnection;
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
    CdsMenu: TClientDataSet;
    CdsMenuLibelle: TStringField;
    CdsMenuIcone: TStringField;
    CdsMenuUrl: TStringField;
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

  CdsMenu.CreateDataSet;
end;

procedure TDMSession.DataModuleDestroy( Sender: TObject );
begin
  FreeAndNil( FCritical );
end;

end.
