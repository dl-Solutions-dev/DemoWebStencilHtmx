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
  public
    destructor Destroy; override;

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
  uInvokerActions,
  UWMMain;

procedure TCustomersListController.AddCustomer( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LProcessorEngine: TWebStencilsProcessor;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TWMMain( FWebModule ).UserSession;

    if Assigned( LSession ) then
    begin
      LProcessorEngine := TWebStencilsProcessor.Create( nil );
      try
        LProcessorEngine.Engine := FWebStencilsEngine;
        LProcessorEngine.InputFileName := './templates/CustomerAdd.html';
        LProcessorEngine.PathTemplate := './Templates';

        FWebStencilsEngine.AddVar( 'CustomerTypes', LSession.DMSession.qryCustomerTypes, False );

        Response.Content := LProcessorEngine.Content;
      finally
        FreeAndNil( LProcessorEngine );
      end;
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
//  LIds: string;
//  LNoSession: string;
  LProcessorEngine: TWebStencilsProcessor;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TWMMain( FWebModule ).UserSession;

    if Assigned( LSession ) then
    begin
      LProcessorEngine := TWebStencilsProcessor.Create( nil );
      try
        LProcessorEngine.Engine := FWebStencilsEngine;
        LProcessorEngine.InputFileName := './templates/CustomerLine.html';
        LProcessorEngine.PathTemplate := './Templates';

        LSession.DMSession.QrySeqCustomer.close;
        LSession.DMSession.QrySeqCustomer.Open;

        LSession.DMSession.QryCustomer.Open;
        LSession.DMSession.QryCustomer.Append;
        LSession.DMSession.QryCustomerCUST_ID.Value := LSession.DMSession.QrySeqCustomerNEWID.Value;
        LSession.DMSession.QryCustomerCUST_NAME.Value := Request.ContentFields.Values[ 'Name' ];
        LSession.DMSession.QryCustomerCUST_VILLE.Value := Request.ContentFields.Values[ 'City' ];
        LSession.DMSession.QryCustomerCUST_PAYS.Value := Request.ContentFields.Values[ 'Country' ];
        LSession.DMSession.QryCustomerCUST_TYPE.Value := Request.ContentFields.Values[ 'Type' ];
        LSession.DMSession.QryCustomer.Post;

//        LIds := LSession.DMSession.QryCustomerCUST_ID.Value.ToString;
//        LNoSession := LSession.IdSession;

          LProcessorEngine.AddVar( 'Customer', LSession.DMSession.QryCustomer, False );

        Response.Content := LProcessorEngine.Content;

        Handled := True;
      finally
        FreeAndNil( LProcessorEngine )
      end;
    end;
  end;
end;

procedure TCustomersListController.ApplyCustomer( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LIds: string;
  LProcessorEngine: TWebStencilsProcessor;
begin
  LSession := TWMMain( FWebModule ).UserSession;

  if ( Request.QueryFields.Values[ 'Id' ] <> '' ) and ( TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) ) then
  begin
    if LId <> -1 then
    begin
      LProcessorEngine := TWebStencilsProcessor.Create( nil );
      try
        LProcessorEngine.Engine := FWebStencilsEngine;
        LProcessorEngine.InputFileName := './templates/CustomerLine.html';
        LProcessorEngine.PathTemplate := './Templates';

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

          LProcessorEngine.AddVar( 'Customer', LSession.DMSession.QryCustomer, False );

        Response.Content := LProcessorEngine.Content;

        Handled := True;
      finally
        FreeAndNil( LProcessorEngine );
      end;
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
  LProcessorEngine: TWebStencilsProcessor;
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
          LProcessorEngine := TWebStencilsProcessor.Create( nil );
          try
            LProcessorEngine.Engine := FWebStencilsEngine;
            LProcessorEngine.InputFileName := './templates/CustomerLine.html';
            LProcessorEngine.PathTemplate := './Templates';

            LSession.DMSession.QryCustomerCancel.close;
            LSession.DMSession.QryCustomerCancel.ParamByName( 'CUST_ID' ).AsInteger := LId;
            LSession.DMSession.QryCustomerCancel.Open;

            if not( LSession.DMSession.QryCustomerCancel.Eof ) then
            begin
              LIds := LId.ToString;
              LNoSession := LSession.IdSession;

              if not LProcessorEngine.HasVar( 'Customer' ) then
                FWebStencilsEngine.AddVar( 'Customer', LSession.DMSession.QryCustomerCancel, False );

              Response.Content := LProcessorEngine.Content;
            end;
          finally
            FreeAndNil( LProcessorEngine );
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
  SendEmptyContent( Response );
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
          SendEmptyContent( Response );
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

destructor TCustomersListController.Destroy;
begin

  inherited;
end;

procedure TCustomersListController.EditLineMode( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LProcessorEngine: TWebStencilsProcessor;
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
            LProcessorEngine := TWebStencilsProcessor.Create( nil );
            try
              LProcessorEngine.Engine := FWebStencilsEngine;
              LProcessorEngine.InputFileName := './templates/CustomerEditLine.html';
              LProcessorEngine.PathTemplate := './Templates';

              LSession.DMSession.QryCustomer.Open;
              LSession.DMSession.QryCustomer.First;

              FWebStencilsEngine.AddVar( 'Customer', LSession.DMSession.QryCustomer, False );
              FWebStencilsEngine.AddVar( 'CustomerTypes', LSession.DMSession.qryCustomerTypes, False );

              Response.Content := LProcessorEngine.Content;
            finally
              FreeAndNil( LProcessorEngine );
            end;
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
    try
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
    finally
      FreeAndNil( LProcessorEngine )
    end;
  end
  else
  begin
    Response.Content := 'Session not found.';
  end;
end;

initialization

TInvokerActions.GetInvokerActions.AddAction( TCustomersListController.Create );

end.
