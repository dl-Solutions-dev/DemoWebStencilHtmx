(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-05T23:32:46.000+02:00
  Signature : 1809c1e6fdb0c909e8b618a59b4bd83c4f17a3e9
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
  System.SyncObjs,
  Datasnap.DBClient;

type
  TDMSession = class( TDataModule )
    CnxCustomers: TFDConnection;
    QryCustomers: TFDQuery;
    QryCustomer: TFDQuery;
    QrySeqCustomer: TFDQuery;
    QrySeqCustomerNEWID: TLargeintField;
    QryCustomerCancel: TFDQuery;
    QryCustomersCUST_ID: TIntegerField;
    QryCustomersCUST_NAME: TWideStringField;
    QryCustomersCUST_VILLE: TWideStringField;
    QryCustomersCUST_PAYS: TWideStringField;
    QryCustomersCUST_TYPE: TWideStringField;
    QryCustomerCUST_ID: TIntegerField;
    QryCustomerCUST_NAME: TWideStringField;
    QryCustomerCUST_VILLE: TWideStringField;
    QryCustomerCUST_PAYS: TWideStringField;
    QryCustomerCUST_TYPE: TWideStringField;
    QryCustomerCancelCUST_ID: TIntegerField;
    QryCustomerCancelCUST_NAME: TWideStringField;
    QryCustomerCancelCUST_VILLE: TWideStringField;
    QryCustomerCancelCUST_PAYS: TWideStringField;
    QryCustomerCancelCUST_TYPE: TWideStringField;
    QryCustomersCUST_LIB_TYPE: TStringField;
    QryCustomerCUST_LIB_TYPE: TStringField;
    qryCustomerTypes: TFDQuery;
    qryCustomerTypesCT_TYPE: TWideStringField;
    qryCustomerTypesCT_LIBELLE: TWideStringField;
    QryCustomerTotQuotes: TFDQuery;
    QryCustomerTotOrders: TFDQuery;
    QryCustomerTotQuotesTOTAL_QUOTE: TFMTBCDField;
    QryCustomerTotOrdersTOTAL_ORDER: TFMTBCDField;
    QryListQuotes: TFDQuery;
    QryListOrders: TFDQuery;
    QryListQuotesDOC_ID: TIntegerField;
    QryListQuotesDOC_TYPE: TWideStringField;
    QryListQuotesDOC_DESCRIPTION: TWideStringField;
    QryListQuotesDOC_AMOUNT: TFMTBCDField;
    QryListQuotesDOC_CUST_ID: TIntegerField;
    QryListOrdersDOC_ID: TIntegerField;
    QryListOrdersDOC_TYPE: TWideStringField;
    QryListOrdersDOC_DESCRIPTION: TWideStringField;
    QryListOrdersDOC_AMOUNT: TFMTBCDField;
    QryListOrdersDOC_CUST_ID: TIntegerField;
    QrySeqDoc: TFDQuery;
    QrySeqDocNEWID: TLargeintField;
    QryQuote: TFDQuery;
    QryQuoteDOC_ID: TIntegerField;
    QryQuoteDOC_TYPE: TWideStringField;
    QryQuoteDOC_DESCRIPTION: TWideStringField;
    QryQuoteDOC_AMOUNT: TFMTBCDField;
    QryQuoteDOC_CUST_ID: TIntegerField;
    QryQuoteCancel: TFDQuery;
    QryQuoteCancelDOC_ID: TIntegerField;
    QryQuoteCancelDOC_TYPE: TWideStringField;
    QryQuoteCancelDOC_DESCRIPTION: TWideStringField;
    QryQuoteCancelDOC_AMOUNT: TFMTBCDField;
    QryQuoteCancelDOC_CUST_ID: TIntegerField;
    QryOrder: TFDQuery;
    QryOrderCancel: TFDQuery;
    QryOrderCancelDOC_ID: TIntegerField;
    QryOrderCancelDOC_TYPE: TWideStringField;
    QryOrderCancelDOC_DESCRIPTION: TWideStringField;
    QryOrderCancelDOC_AMOUNT: TFMTBCDField;
    QryOrderCancelDOC_CUST_ID: TIntegerField;
    QryOrderDOC_ID: TIntegerField;
    QryOrderDOC_TYPE: TWideStringField;
    QryOrderDOC_DESCRIPTION: TWideStringField;
    QryOrderDOC_AMOUNT: TFMTBCDField;
    QryOrderDOC_CUST_ID: TIntegerField;
    procedure DataModuleCreate( Sender: TObject );
    procedure DataModuleDestroy( Sender: TObject );
    procedure QryCustomersCalcFields( DataSet: TDataSet );
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

procedure TDMSession.QryCustomersCalcFields( DataSet: TDataSet );
begin
  if DataSet.FieldByName( 'CUST_TYPE' ).AsString = 'C' then
  begin
    DataSet.FieldByName( 'CUST_LIB_TYPE' ).AsString := 'Customer';
  end
  else
  begin
    DataSet.FieldByName( 'CUST_LIB_TYPE' ).AsString := 'Prospect';
  end;
end;

end.
