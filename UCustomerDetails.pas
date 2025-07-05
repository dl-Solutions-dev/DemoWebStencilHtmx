(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-05T22:04:02.000+02:00
  Signature : 76dbcbd80a5a9d4fd4bc2f75da0fccf4c51fdb56
  ***************************************************************************
*)

unit UCustomerDetails;

interface

uses
  System.Classes,
  System.SysUtils,
  Web.HTTPApp,
  Web.Stencils,
  uBaseController;

type
  TCustomerDetails = class( TBaseController )
  public
    procedure DetailsCustomer( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );

    procedure InitializeActions( aWebModule: TWebModule; aWebStencil: TWebStencilsEngine ); override;
  end;

implementation

{ TCustomerDetails }

uses
  utils.ClassHelpers,
  USessionManager,
  UWMMain, uInvokerActions;

procedure TCustomerDetails.DetailsCustomer( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LProcessorEngine: TWebStencilsProcessor;
  LCustId: Integer;
begin
  LSession := TWMMain( FWebModule ).UserSession;

  if Assigned( LSession ) then
  begin
    if TryStrToInt( Request.QueryFields.Values[ 'CustId' ], LCustId ) then
    begin
      LProcessorEngine := TWebStencilsProcessor.Create( nil );
      LProcessorEngine.Engine := FWebStencilsEngine;
      LProcessorEngine.InputFileName := './templates/CustomerDetails.html';
      LProcessorEngine.PathTemplate := './Templates';

      FWebStencilsEngine.AddVar( 'Session', LSession, False );

      LSession.DMSession.CnxCustomers.Rollback;
      LSession.DMSession.QryCustomerTotQuotes.close;
      LSession.DMSession.QryCustomerTotQuotes.ParamByName( 'DOC_CUST_ID' ).AsInteger := LCustId;
      LSession.DMSession.QryCustomerTotQuotes.Open;

      if not LProcessorEngine.HasVar( 'TotalQuotes' ) then
        FWebStencilsEngine.AddVar( 'TotalQuotes', LSession.DMSession.QryCustomerTotQuotes, False );

      LSession.DMSession.QryCustomerTotOrders.close;
      LSession.DMSession.QryCustomerTotOrders.ParamByName( 'DOC_CUST_ID' ).AsInteger := LCustId;
      LSession.DMSession.QryCustomerTotOrders.Open;

      if not LProcessorEngine.HasVar( 'TotalOrders' ) then
        FWebStencilsEngine.AddVar( 'TotalOrders', LSession.DMSession.QryCustomerTotOrders, False );

      LSession.DMSession.QryListQuotes.close;
      LSession.DMSession.QryListQuotes.ParamByName( 'DOC_CUST_ID' ).AsInteger := LCustId;
      LSession.DMSession.QryListQuotes.Open;

      if not LProcessorEngine.HasVar( 'ListQuotes' ) then
        FWebStencilsEngine.AddVar( 'ListQuotes', LSession.DMSession.QryListQuotes, False );

      LSession.DMSession.QryListOrders.close;
      LSession.DMSession.QryListOrders.ParamByName( 'DOC_CUST_ID' ).AsInteger := LCustId;
      LSession.DMSession.QryListOrders.Open;

      if not LProcessorEngine.HasVar( 'ListOrders' ) then
        FWebStencilsEngine.AddVar( 'ListOrders', LSession.DMSession.QryListOrders, False );

      LSession.DMSession.QryCustomer.close;
      LSession.DMSession.QryCustomer.ParamByName( 'CUST_ID' ).AsInteger := LCustId;
      LSession.DMSession.QryCustomer.Open;

      if not LProcessorEngine.HasVar( 'Customer' ) then
        FWebStencilsEngine.AddVar( 'Customer', LSession.DMSession.QryCustomer, False );

      Response.Content := LProcessorEngine.Content;
      Handled := True;
    end
    else
    begin
      Response.Content := 'Invalid Customer id';
    end;
  end
  else
  begin
    Response.Content := 'Session not found.';
  end;
end;

procedure TCustomerDetails.InitializeActions( aWebModule: TWebModule;
  aWebStencil: TWebStencilsEngine );
begin
  inherited;

  aWebModule.AddRoutes( [
    TRoute.Create( mtGet, '/DetailsCustomer', Self.DetailsCustomer )
    ] );
end;

initialization

TInvokerActions.GetInvokerActions.AddAction( TCustomerDetails.Create );

end.
