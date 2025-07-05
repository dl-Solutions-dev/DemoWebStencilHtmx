(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-05T21:56:06.000+02:00
  Signature : 9b891d0fbfc3691646c12da9460a46b3683d0482
  ***************************************************************************
*)

unit UCustomersListController;

interface

uses
  System.SysUtils,
  Web.HTTPApp,
  Web.Stencils,
  uBaseController,
  uInterfaces,
  USessionManager,
  UDMSession;

type
  TCustomersListController = class( TBaseController )
  private
//    FStartDate: TDateTime;
  public
    procedure ListeCustomers( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure ApplyCustomer( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure DeleteCustomer( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure AddCustomer( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure EditLineMode( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure CancelEditLineCustomer( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure ApplyInsertCustomer( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure CancelAddCusomer( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );

    procedure InitializeActions( aWebModule: TWebModule; aWebStencil: TWebStencilsEngine ); override;
  end;

implementation


{ TCustomersListController }

uses
  System.SyncObjs,
  System.StrUtils,
  FireDAC.Stan.Param,
  utils.ClassHelpers,
  UConsts,
  UHtmlTemplates,
  uInvokerActions,
  UWMMain;

procedure TCustomersListController.AddCustomer( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TWMMain( FWebModule ).UserSession;

    if Assigned( LSession ) then
    begin
      Response.Content := ADD_CUSTOMER
        .Replace( TAG_SESSION, LSession.IdSession, [ rfReplaceAll ] )
        .Replace( TAG_CB_TYPES_CUSTOMER, PickList( LSession.DMSession.qryCustomerTypes, 'Type', '', 'CT_TYPE', 'CT_LIBELLE', '' ), [ rfReplaceAll ] );
    end
    else
    begin
      Response.Content := 'Invalid session';
    end;
  end
  else
  begin
    Response.Content := 'Invalid session';
  end;
end;

procedure TCustomersListController.ApplyInsertCustomer( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LIds: string;
  LNoSession: string;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TWMMain( FWebModule ).UserSession;

    if Assigned( LSession ) then
    begin
      LSession.DMSession.QrySeq.close;
      LSession.DMSession.QrySeq.Open;

      LSession.DMSession.QryCustomer.Open;
      LSession.DMSession.QryCustomer.Append;
      LSession.DMSession.QryCustomerCUST_ID.Value := LSession.DMSession.QrySeqNEWID.Value;
      LSession.DMSession.QryCustomerCUST_NAME.Value := Request.ContentFields.Values[ 'Name' ];
      LSession.DMSession.QryCustomerCUST_VILLE.Value := Request.ContentFields.Values[ 'City' ];
      LSession.DMSession.QryCustomerCUST_PAYS.Value := Request.ContentFields.Values[ 'Country' ];
      LSession.DMSession.QryCustomerCUST_TYPE.Value := Request.ContentFields.Values[ 'Type' ];
      LSession.DMSession.QryCustomer.Post;

      LIds := LSession.DMSession.QrySeqNEWID.Value.ToString;
      LNoSession := LSession.IdSession;

      Response.Content := LINE_CUSTOMER
        .Replace( TAG_CUST_ID, LIds, [ rfReplaceAll ] )
        .Replace( TAG_SESSION, LNoSession, [ rfReplaceAll ] )
        .Replace( TAG_NAME, LSession.DMSession.QryCustomer.FieldByName( 'CUST_NAME' ).AsString, [ rfReplaceAll ] )
        .Replace( TAG_CITY, LSession.DMSession.QryCustomer.FieldByName( 'CUST_VILLE' ).AsString, [ rfReplaceAll ] )
        .Replace( TAG_COUNTRY, LSession.DMSession.QryCustomer.FieldByName( 'CUST_PAYS' ).AsString, [ rfReplaceAll ] )
        .Replace( TAG_TYPE, LSession.DMSession.QryCustomer.FieldByName( 'CUST_LIB_TYPE' ).AsString, [ rfReplaceAll ] );
    end;
  end;
end;

procedure TCustomersListController.ApplyCustomer( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LIds: string;
begin
  LSession := TWMMain( FWebModule ).UserSession;

  if ( Request.QueryFields.Values[ 'Id' ] <> '' ) and ( TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) ) then
  begin
    if LId <> -1 then
    begin
      LSession.DMSession.CnxCustomers.StartTransaction;

      LSession.DMSession.QryCustomer.close;
      LSession.DMSession.QryCustomer.ParamByName( 'CUST_ID' ).AsInteger := LId;
      LSession.DMSession.QryCustomer.Open;
      LSession.DMSession.QryCustomer.Edit;

      LSession.DMSession.QryCustomerCUST_NAME.Value := Request.ContentFields.Values[ 'Name' ];
      LSession.DMSession.QryCustomerCUST_VILLE.Value := Request.ContentFields.Values[ 'City' ];
      LSession.DMSession.QryCustomerCUST_PAYS.Value := Request.ContentFields.Values[ 'Country' ];
      LSession.DMSession.QryCustomerCUST_TYPE.Value := Request.ContentFields.Values[ 'Type' ];
      try
        LSession.DMSession.QryCustomer.Post;
        LSession.DMSession.CnxCustomers.Commit;
      except
        on e: Exception do
        begin
          LSession.DMSession.CnxCustomers.Rollback;
        end;
      end;

      LIds := Request.QueryFields.Values[ 'Id' ];

      Response.Content := LINE_CUSTOMER
        .Replace( TAG_CUST_ID, LIds, [ rfReplaceAll ] )
        .Replace( TAG_SESSION, LSession.IdSession, [ rfReplaceAll ] )
        .Replace( TAG_NAME, LSession.DMSession.QryCustomer.FieldByName( 'CUST_NAME' ).AsString, [ rfReplaceAll ] )
        .Replace( TAG_CITY, LSession.DMSession.QryCustomer.FieldByName( 'CUST_VILLE' ).AsString, [ rfReplaceAll ] )
        .Replace( TAG_COUNTRY, LSession.DMSession.QryCustomer.FieldByName( 'CUST_PAYS' ).AsString, [ rfReplaceAll ] )
        .Replace( TAG_TYPE, LSession.DMSession.QryCustomer.FieldByName( 'CUST_LiB_TYPE' ).AsString, [ rfReplaceAll ] );
    end
    else
    begin

    end;
  end;

end;

procedure TCustomersListController.CancelEditLineCustomer( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LIds, LNoSession: string;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TWMMain( FWebModule ).UserSession;
    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.Critical.Acquire;
        try
          LSession.DMSession.QryCustomerCancel.close;
          LSession.DMSession.QryCustomerCancel.ParamByName( 'CUST_ID' ).AsInteger := LId;
          LSession.DMSession.QryCustomerCancel.Open;

          if not( LSession.DMSession.QryCustomerCancel.Eof ) then
          begin
            LIds := LId.ToString;
            LNoSession := LSession.IdSession;

            Response.Content := LINE_CUSTOMER
              .Replace( TAG_CUST_ID, LIds, [ rfReplaceAll ] )
              .Replace( TAG_SESSION, LNoSession, [ rfReplaceAll ] )
              .Replace( TAG_NAME, LSession.DMSession.QryCustomer.FieldByName( 'CUST_NAME' ).AsString, [ rfReplaceAll ] )
              .Replace( TAG_CITY, LSession.DMSession.QryCustomer.FieldByName( 'CUST_VILLE' ).AsString, [ rfReplaceAll ] )
              .Replace( TAG_COUNTRY, LSession.DMSession.QryCustomer.FieldByName( 'CUST_PAYS' ).AsString, [ rfReplaceAll ] )
              .Replace( TAG_TYPE, LSession.DMSession.QryCustomer.FieldByName( 'CUST_LIB_TYPE' ).AsString, [ rfReplaceAll ] );
          end;
        finally
          LSession.DMSession.Critical.Leave;
        end;
      end;
    end;
  end;
end;

procedure TCustomersListController.CancelAddCusomer( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
begin
  Response.Content := '<tr style="display:none;"><td></td><td></td><td></td><td></td></tr>';
end;

procedure TCustomersListController.DeleteCustomer( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TWMMain( FWebModule ).UserSession;

    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.QryCustomer.close;
        LSession.DMSession.QryCustomer.ParamByName( 'CUST_ID' ).AsInteger := LId;
        LSession.DMSession.QryCustomer.Open;

        if not( LSession.DMSession.QryCustomer.Eof ) then
        begin
          LSession.DMSession.QryCustomer.Delete;
          Response.Content := '<tr style="display:none;"><td></td><td></td><td></td><td></td></tr>';
        end
        else
        begin
          Response.Content := 'utilisateur non trouvé.';
        end;
      end
      else
      begin
        Response.Content := 'IdUser incorrect.';
      end;
    end
    else
    begin
      Response.Content := 'Session non trouvée.';
    end;
  end
  else
  begin
    Response.Content := 'Session non trouvée.';
  end;
end;

procedure TCustomersListController.EditLineMode( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TWMMain( FWebModule ).UserSession;

    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.Critical.Acquire;
        try
          LSession.DMSession.QryCustomer.close;
          LSession.DMSession.QryCustomer.ParamByName( 'CUST_ID' ).AsInteger := LId;
          LSession.DMSession.QryCustomer.Open;

          if not( LSession.DMSession.QryCustomer.Eof ) then
          begin
            Response.Content := EDIT_LINE_CUSTOMER
              .Replace( TAG_SESSION, LSession.IdSession, [ rfReplaceAll ] )
              .Replace( TAG_CUST_ID, LId.ToString, [ rfReplaceAll ] )
              .Replace( TAG_NAME, LSession.DMSession.QryCustomer.FieldByName( 'CUST_NAME' ).AsString, [ rfReplaceAll ] )
              .Replace( TAG_CITY, LSession.DMSession.QryCustomer.FieldByName( 'CUST_VILLE' ).AsString, [ rfReplaceAll ] )
              .Replace( TAG_COUNTRY, LSession.DMSession.QryCustomer.FieldByName( 'CUST_PAYS' ).AsString, [ rfReplaceAll ] )
              .Replace( TAG_CB_TYPES_CUSTOMER, PickList( LSession.DMSession.qryCustomerTypes, 'Type', '', 'CT_TYPE', 'CT_LIBELLE',
              LSession.DMSession.QryCustomer.FieldByName( 'CUST_TYPE' ).AsString ),
              [ rfReplaceAll ] );
          end;
        finally
          LSession.DMSession.Critical.Leave;
        end;
      end;
    end;
  end;
end;

procedure TCustomersListController.InitializeActions( aWebModule: TWebModule;
  aWebStencil: TWebStencilsEngine );
begin
  inherited;

  FWebStencilsEngine := aWebStencil;

  aWebModule.AddRoutes( [
    TRoute.Create( mtGet, '/ListeCustomers', Self.ListeCustomers ),
    TRoute.Create( mtAny, '/ApplyCustomer', Self.ApplyCustomer ),
    TRoute.Create( mtDelete, '/DeleteCustomer', Self.DeleteCustomer ),
    TRoute.Create( mtAny, '/AddCustomer', Self.AddCustomer ),
    TRoute.Create( mtAny, '/EditLineMode', Self.EditLineMode ),
    TRoute.Create( mtAny, '/CancelEditLineCustomer', Self.CancelEditLineCustomer ),
    TRoute.Create( mtAny, '/ApplyInsertCustomer', Self.ApplyInsertCustomer ),
    TRoute.Create( mtAny, '/CancelAddCusomer', Self.CancelAddCusomer )
    ] );
end;

procedure TCustomersListController.ListeCustomers( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LProcessorEngine: TWebStencilsProcessor;
begin
  LSession := TWMMain( FWebModule ).UserSession;

  if Assigned( LSession ) then
  begin
    LProcessorEngine := TWebStencilsProcessor.Create( nil );
    LProcessorEngine.Engine := FWebStencilsEngine;
    LProcessorEngine.InputFileName := './templates/CustomersList.html';
    LProcessorEngine.PathTemplate := './Templates';

    FWebStencilsEngine.AddVar( 'Session', LSession, False );

    LSession.DMSession.CnxCustomers.Rollback;
    LSession.DMSession.QryCustomers.close;
    LSession.DMSession.QryCustomers.Open;

    if not LProcessorEngine.HasVar( 'CustomerList' ) then
      FWebStencilsEngine.AddVar( 'CustomerList', LSession.DMSession.QryCustomers, False );

    Response.Content := LProcessorEngine.Content;
    Handled := True;
  end
  else
  begin
    Response.Content := 'Session not found.';
  end;
end;

initialization

TInvokerActions.GetInvokerActions.AddAction( TCustomersListController.Create );

end.
