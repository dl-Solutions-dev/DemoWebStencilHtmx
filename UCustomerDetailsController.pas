(* C2PP
  ***************************************************************************

  Copyright 2025 Dany Leblanc under AGPL 3.0 license.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
  OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-26T19:15:24.000+02:00
  Signature : b289c5d13a47dc215c29ebd4b1fbb8e829f10f65
  ***************************************************************************
*)

unit UCustomerDetailsController;

interface

uses
  System.Classes,
  System.SysUtils,
  Web.HTTPApp,
  Web.Stencils,
  uBaseController;

type
  TCustomerDetailsController = class( TBaseController )
  public
    procedure DetailsCustomer( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure ApplyQuote( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure DeleteQuote( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure AddQuote( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure EditQuoteLineMode( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure CancelEditLineQuote( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure ApplyInsertQuote( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure CancelAddQuote( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure GetTotalQuote( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );

    procedure ApplyOrder( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure DeleteOrder( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure AddOrder( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure EditOrderLineMode( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure CancelEditLineOrder( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure ApplyInsertOrder( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure CancelAddOrder( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure GetTotalOrder( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );

    procedure InitializeActions( aWebModule: TWebModule; aWebStencil: TWebStencilsEngine ); override;
  end;

implementation

{ TCustomerDetailsController }

uses
  Data.FMTBcd,
  System.SyncObjs,
  FireDAC.Stan.Param,
  utils.ClassHelpers,
  USessionManager,
  UWMMain,
  uInvokerActions,
  UConsts;

procedure TCustomerDetailsController.AddOrder( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LProcessorEngine: TWebStencilsProcessor;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );

    if Assigned( LSession ) then
    begin
      LProcessorEngine := TWebStencilsProcessor.Create( nil );
      try
        LProcessorEngine.Engine := FWebStencilsEngine;
        LProcessorEngine.InputFileName := './templates/OrderAdd.html';
        LProcessorEngine.PathTemplate := './Templates';

        LSession.DMSession.QryCustomer.Close;
        LSession.DMSession.QryCustomer.ParamByName( 'CUST_ID' ).AsInteger := LSession.DMSession.IdCustomer;
        LSession.DMSession.QryCustomer.Open;

        LProcessorEngine.AddVar( 'Customer', LSession.DMSession.QryCustomer, False );

        Response.Content := LProcessorEngine.Content;
      finally
        FreeAndNil( LProcessorEngine );
      end;
      //
      // Response.Content := ADD_QUOTE
      // .Replace( TAG_SESSION, LSession.IdSession, [ rfReplaceAll ] );
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

procedure TCustomerDetailsController.AddQuote( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LProcessorEngine: TWebStencilsProcessor;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );

    if Assigned( LSession ) then
    begin
      LProcessorEngine := TWebStencilsProcessor.Create( nil );
      try
        LProcessorEngine.Engine := FWebStencilsEngine;
        LProcessorEngine.InputFileName := './templates/QuoteAdd.html';
        LProcessorEngine.PathTemplate := './Templates';

        LSession.DMSession.QryCustomer.Close;
        LSession.DMSession.QryCustomer.ParamByName( 'CUST_ID' ).AsInteger := Request.QueryFields.Values[ 'CustId' ].ToInteger;
        LSession.DMSession.QryCustomer.Open;

        LProcessorEngine.AddVar( 'Customer', LSession.DMSession.QryCustomer, False );

        Response.Content := LProcessorEngine.Content;
      finally
        FreeAndNil( LProcessorEngine );
      end;
      //
      // Response.Content := ADD_QUOTE
      // .Replace( TAG_SESSION, LSession.IdSession, [ rfReplaceAll ] );
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

procedure TCustomerDetailsController.ApplyInsertOrder( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LProcessorEngine: TWebStencilsProcessor;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );

    if Assigned( LSession ) then
    begin
      LSession.DMSession.QrySeqDoc.Close;
      LSession.DMSession.QrySeqDoc.Open;

      LSession.DMSession.QryOrder.Open;
      LSession.DMSession.QryOrder.Append;
      try
        LSession.DMSession.QryOrderDOC_ID.Value := LSession.DMSession.QrySeqDocNEWID.Value;
        LSession.DMSession.QryOrderDOC_TYPE.Value := 'O';
        LSession.DMSession.QryOrderDOC_DESCRIPTION.Value := Request.ContentFields.Values[ 'Description' ];
        LSession.DMSession.QryOrderDOC_AMOUNT.Value := Request.ContentFields.Values[ 'Amount' ].ToDouble;
        LSession.DMSession.QryOrderDOC_CUST_ID.Value := Request.QueryFields.Values[ 'CustId' ].ToInteger;
        LSession.DMSession.QryOrder.Post;
        LSession.DMSession.CnxCustomers.CommitRetaining;

        LProcessorEngine := TWebStencilsProcessor.Create( nil );
        try
          LProcessorEngine.Engine := FWebStencilsEngine;
          LProcessorEngine.InputFileName := './templates/OrderLine.html';
          LProcessorEngine.PathTemplate := './Templates';
          LProcessorEngine.AddVar( 'Order', LSession.DMSession.QryOrder, False );

          Response.Content := LProcessorEngine.Content;

          FreeAndNil( LProcessorEngine );
        except
          FreeAndNil( LProcessorEngine );
        end;
      except
        LSession.DMSession.QryOrder.Cancel;
        SendEmptyContent( Response );
      end;

    end;
  end;
end;

procedure TCustomerDetailsController.ApplyInsertQuote( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LProcessorEngine: TWebStencilsProcessor;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );

    if Assigned( LSession ) then
    begin
      LSession.DMSession.QrySeqDoc.Close;
      LSession.DMSession.QrySeqDoc.Open;

      LSession.DMSession.QryQuote.Open;
      LSession.DMSession.QryQuote.Append;
      try
        LSession.DMSession.QryQuoteDOC_ID.Value := LSession.DMSession.QrySeqDocNEWID.Value;
        LSession.DMSession.QryQuoteDOC_TYPE.Value := 'Q';
        LSession.DMSession.QryQuoteDOC_DESCRIPTION.Value := Request.ContentFields.Values[ 'Description' ];
        LSession.DMSession.QryQuoteDOC_AMOUNT.Value := Request.ContentFields.Values[ 'Amount' ].ToDouble;
        LSession.DMSession.QryQuoteDOC_CUST_ID.Value := Request.QueryFields.Values[ 'CustId' ].ToInteger;
        LSession.DMSession.QryQuote.Post;
        LSession.DMSession.CnxCustomers.CommitRetaining;

        LProcessorEngine := TWebStencilsProcessor.Create( nil );
        try
          LProcessorEngine.Engine := FWebStencilsEngine;
          LProcessorEngine.InputFileName := './templates/QuoteLine.html';
          LProcessorEngine.PathTemplate := './Templates';
          LProcessorEngine.AddVar( 'Quote', LSession.DMSession.QryQuote, False );

          Response.Content := LProcessorEngine.Content;

          FreeAndNil( LProcessorEngine );
        except
          FreeAndNil( LProcessorEngine );
        end;
      except
        LSession.DMSession.QryQuote.Cancel;
        SendEmptyContent( Response );
      end;
    end;
  end;
end;

procedure TCustomerDetailsController.ApplyOrder( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LProcessorEngine: TWebStencilsProcessor;
begin
  LSession := UserSession( Sender );

  if ( Request.QueryFields.Values[ 'Id' ] <> '' ) and ( TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) ) then
  begin
    LSession.DMSession.CnxCustomers.StartTransaction;

    LSession.DMSession.QryOrder.Close;
    LSession.DMSession.QryOrder.ParamByName( 'DOC_ID' ).AsInteger := LId;
    LSession.DMSession.QryOrder.Open;
    LSession.DMSession.QryOrder.Edit;

    LSession.DMSession.QryOrderDOC_DESCRIPTION.Value := Request.ContentFields.Values[ 'Description' ];
    LSession.DMSession.QryOrderDOC_AMOUNT.Value := Request.ContentFields.Values[ 'Amount' ];
    try
      LSession.DMSession.QryOrder.Post;
      LSession.DMSession.CnxCustomers.Commit;
    except
      on e: Exception do
      begin
        LSession.DMSession.CnxCustomers.Rollback;
      end;
    end;
    LProcessorEngine := TWebStencilsProcessor.Create( nil );
    try
      LProcessorEngine.Engine := FWebStencilsEngine;
      LProcessorEngine.InputFileName := './templates/OrderLine.html';
      LProcessorEngine.PathTemplate := './Templates';

      LProcessorEngine.AddVar( 'Order', LSession.DMSession.QryOrder, False );

      Response.Content := LProcessorEngine.Content;
    finally
      FreeAndNil( LProcessorEngine );
    end;
  end;
end;

procedure TCustomerDetailsController.ApplyQuote( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LProcessorEngine: TWebStencilsProcessor;
begin
  LSession := UserSession( Sender );

  if ( Request.QueryFields.Values[ 'Id' ] <> '' ) and ( TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) ) then
  begin
    LSession.DMSession.CnxCustomers.StartTransaction;

    LSession.DMSession.QryQuote.Close;
    LSession.DMSession.QryQuote.ParamByName( 'DOC_ID' ).AsInteger := LId;
    LSession.DMSession.QryQuote.Open;
    LSession.DMSession.QryQuote.Edit;

    LSession.DMSession.QryQuoteDOC_DESCRIPTION.Value := Request.ContentFields.Values[ 'Description' ];
    LSession.DMSession.QryQuoteDOC_AMOUNT.Value := Request.ContentFields.Values[ 'Amount' ];
    try
      LSession.DMSession.QryQuote.Post;
      LSession.DMSession.CnxCustomers.Commit;
    except
      on e: Exception do
      begin
        LSession.DMSession.CnxCustomers.Rollback;
      end;
    end;
    LProcessorEngine := TWebStencilsProcessor.Create( nil );
    try
      LProcessorEngine.Engine := FWebStencilsEngine;
      LProcessorEngine.InputFileName := './templates/QuoteLine.html';
      LProcessorEngine.PathTemplate := './Templates';

      LProcessorEngine.AddVar( 'Quote', LSession.DMSession.QryQuote, False );

      Response.Content := LProcessorEngine.Content;
    finally
      FreeAndNil( LProcessorEngine );
    end;
  end;
end;

procedure TCustomerDetailsController.CancelAddOrder( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
begin
  SendEmptyContent( Response );
end;

procedure TCustomerDetailsController.CancelAddQuote( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
begin
  SendEmptyContent( Response );
end;

procedure TCustomerDetailsController.CancelEditLineOrder( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LIds, LNoSession: string;
  LProcessorEngine: TWebStencilsProcessor;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );
    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.Critical.Acquire;
        try
          LProcessorEngine := TWebStencilsProcessor.Create( nil );
          try
            LProcessorEngine.Engine := FWebStencilsEngine;
            LProcessorEngine.InputFileName := './templates/OrderLine.html';
            LProcessorEngine.PathTemplate := './Templates';

            LSession.DMSession.QryOrderCancel.Close;
            LSession.DMSession.QryOrderCancel.ParamByName( 'DOC_ID' ).AsInteger := LId;
            LSession.DMSession.QryOrderCancel.Open;

            if not( LSession.DMSession.QryOrderCancel.Eof ) then
            begin
              LIds := LId.ToString;
              LNoSession := LSession.IdSession;

              LProcessorEngine.AddVar( 'Order', LSession.DMSession.QryOrderCancel, False );

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

procedure TCustomerDetailsController.CancelEditLineQuote( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LIds, LNoSession: string;
  LProcessorEngine: TWebStencilsProcessor;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );
    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.Critical.Acquire;
        try
          LProcessorEngine := TWebStencilsProcessor.Create( nil );
          try
            LProcessorEngine.Engine := FWebStencilsEngine;
            LProcessorEngine.InputFileName := './templates/QuoteLine.html';
            LProcessorEngine.PathTemplate := './Templates';

            LSession.DMSession.QryQuoteCancel.Close;
            LSession.DMSession.QryQuoteCancel.ParamByName( 'DOC_ID' ).AsInteger := LId;
            LSession.DMSession.QryQuoteCancel.Open;

            if not( LSession.DMSession.QryQuoteCancel.Eof ) then
            begin
              LIds := LId.ToString;
              LNoSession := LSession.IdSession;

              LProcessorEngine.AddVar( 'Quote', LSession.DMSession.QryQuoteCancel, False );

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

procedure TCustomerDetailsController.DeleteOrder( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );

    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.QryOrder.Close;
        LSession.DMSession.QryOrder.ParamByName( 'DOC_ID' ).AsInteger := LId;
        LSession.DMSession.QryOrder.Open;

        if not( LSession.DMSession.QryOrder.Eof ) then
        begin
          LSession.DMSession.QryOrder.Delete;
          LSession.DMSession.CnxCustomers.CommitRetaining;
          SendEmptyContent( Response );
        end
        else
        begin
          Response.Content := 'Quote non trouvé.';
        end;
      end
      else
      begin
        Response.Content := 'IdQuote incorrect.';
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

procedure TCustomerDetailsController.DeleteQuote( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );

    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.QryQuote.Close;
        LSession.DMSession.QryQuote.ParamByName( 'DOC_ID' ).AsInteger := LId;
        LSession.DMSession.QryQuote.Open;

        if not( LSession.DMSession.QryQuote.Eof ) then
        begin
          LSession.DMSession.QryQuote.Delete;
          LSession.DMSession.CnxCustomers.CommitRetaining;
          SendEmptyContent( Response );
        end
        else
        begin
          Response.Content := 'Quote non trouvé.';
        end;
      end
      else
      begin
        Response.Content := 'IdQuote incorrect.';
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

procedure TCustomerDetailsController.DetailsCustomer( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LProcessorEngine: TWebStencilsProcessor;
  LCustId: Integer;
begin
  LSession := UserSession( Sender );

  if Assigned( LSession ) then
  begin
    if TryStrToInt( Request.QueryFields.Values[ 'CustId' ], LCustId ) then
    begin
      LSession.DMSession.IdCustomer := LCustId;

      LProcessorEngine := TWebStencilsProcessor.Create( nil );
      LProcessorEngine.Engine := FWebStencilsEngine;
      LProcessorEngine.InputFileName := './templates/CustomerDetails.html';
      LProcessorEngine.PathTemplate := './Templates';

      LProcessorEngine.AddVar( 'Session', LSession, False );

      LSession.DMSession.CnxCustomers.Rollback;
      LSession.DMSession.QryCustomerTotQuotes.Close;
      LSession.DMSession.QryCustomerTotQuotes.ParamByName( 'DOC_CUST_ID' ).AsInteger := LCustId;
      LSession.DMSession.QryCustomerTotQuotes.Open;

      LProcessorEngine.AddVar( 'TotalQuotes', LSession.DMSession.QryCustomerTotQuotes, False );

      LSession.DMSession.QryCustomerTotOrders.Close;
      LSession.DMSession.QryCustomerTotOrders.ParamByName( 'DOC_CUST_ID' ).AsInteger := LCustId;
      LSession.DMSession.QryCustomerTotOrders.Open;

      LProcessorEngine.AddVar( 'TotalOrders', LSession.DMSession.QryCustomerTotOrders, False );

      LSession.DMSession.QryListQuotes.Close;
      LSession.DMSession.QryListQuotes.ParamByName( 'DOC_CUST_ID' ).AsInteger := LCustId;
      LSession.DMSession.QryListQuotes.Open;

      LProcessorEngine.AddVar( 'ListQuotes', LSession.DMSession.QryListQuotes, False );

      LSession.DMSession.QryListOrders.Close;
      LSession.DMSession.QryListOrders.ParamByName( 'DOC_CUST_ID' ).AsInteger := LCustId;
      LSession.DMSession.QryListOrders.Open;

      LProcessorEngine.AddVar( 'ListOrders', LSession.DMSession.QryListOrders, False );

      LSession.DMSession.QryCustomer.Close;
      LSession.DMSession.QryCustomer.ParamByName( 'CUST_ID' ).AsInteger := LCustId;
      LSession.DMSession.QryCustomer.Open;

      LProcessorEngine.AddVar( 'Customer', LSession.DMSession.QryCustomer, False );

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

procedure TCustomerDetailsController.EditOrderLineMode( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LProcessorEngine: TWebStencilsProcessor;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );

    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.Critical.Acquire;
        try
          LSession.DMSession.QryOrder.Close;
          LSession.DMSession.QryOrder.ParamByName( 'DOC_ID' ).AsInteger := LId;
          LSession.DMSession.QryOrder.Open;

          if not( LSession.DMSession.QryOrder.Eof ) then
          begin
            LProcessorEngine := TWebStencilsProcessor.Create( nil );
            try
              LProcessorEngine.Engine := FWebStencilsEngine;
              LProcessorEngine.InputFileName := './templates/OrderEditLine.html';
              LProcessorEngine.PathTemplate := './Templates';

              LSession.DMSession.QryOrder.Open;
              LSession.DMSession.QryOrder.First;

              LProcessorEngine.AddVar( 'Order', LSession.DMSession.QryOrder, False );

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

procedure TCustomerDetailsController.EditQuoteLineMode( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LProcessorEngine: TWebStencilsProcessor;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );

    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.Critical.Acquire;
        try
          LSession.DMSession.QryQuote.Close;
          LSession.DMSession.QryQuote.ParamByName( 'DOC_ID' ).AsInteger := LId;
          LSession.DMSession.QryQuote.Open;

          if not( LSession.DMSession.QryQuote.Eof ) then
          begin
            LProcessorEngine := TWebStencilsProcessor.Create( nil );
            try
              LProcessorEngine.Engine := FWebStencilsEngine;
              LProcessorEngine.InputFileName := './templates/QuoteEditLine.html';
              LProcessorEngine.PathTemplate := './Templates';

              LSession.DMSession.QryQuote.Open;
              LSession.DMSession.QryQuote.First;

              LProcessorEngine.AddVar( 'Quote', LSession.DMSession.QryQuote, False );

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

procedure TCustomerDetailsController.GetTotalOrder( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );

    if Assigned( LSession ) then
    begin
      LSession.DMSession.QryCustomerTotOrders.Close;
      LSession.DMSession.QryCustomerTotOrders.ParamByName( 'DOC_CUST_ID' ).AsInteger := LSession.DMSession.QryCustomerCUST_ID.Value;
      LSession.DMSession.QryCustomerTotOrders.Open;

      Response.Content := BcdToStr( LSession.DMSession.QryCustomerTotOrdersTOTAL_ORDER.Value );
    end;
  end;
end;

procedure TCustomerDetailsController.GetTotalQuote( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := UserSession( Sender );

    if Assigned( LSession ) then
    begin
      LSession.DMSession.QryCustomerTotQuotes.Close;
      LSession.DMSession.QryCustomerTotQuotes.ParamByName( 'DOC_CUST_ID' ).AsInteger := LSession.DMSession.QryCustomerCUST_ID.Value;
      LSession.DMSession.QryCustomerTotQuotes.Open;

      Response.Content := BcdToStr( LSession.DMSession.QryCustomerTotQuotesTOTAL_QUOTE.Value );
    end;
  end;
end;

procedure TCustomerDetailsController.InitializeActions( aWebModule: TWebModule;
  aWebStencil: TWebStencilsEngine );
begin
  inherited;

  aWebModule.AddRoutes( [
    TRoute.Create( mtGet, '/DetailsCustomer', Self.DetailsCustomer ),
    TRoute.Create( mtAny, '/ApplyQuote', Self.ApplyQuote ),
    TRoute.Create( mtDelete, '/DeleteQuote', Self.DeleteQuote ),
    TRoute.Create( mtAny, '/AddQuote', Self.AddQuote ),
    TRoute.Create( mtAny, '/EditQuoteLineMode', Self.EditQuoteLineMode ),
    TRoute.Create( mtAny, '/CancelEditLineQuote', Self.CancelEditLineQuote ),
    TRoute.Create( mtAny, '/ApplyInsertQuote', Self.ApplyInsertQuote ),
    TRoute.Create( mtAny, '/CancelAddQuote', Self.CancelAddQuote ),
    TRoute.Create( mtAny, '/GetTotalQuote', Self.GetTotalQuote ),

    TRoute.Create( mtAny, '/ApplyOrder', Self.ApplyOrder ),
    TRoute.Create( mtDelete, '/DeleteOrder', Self.DeleteOrder ),
    TRoute.Create( mtAny, '/AddOrder', Self.AddOrder ),
    TRoute.Create( mtAny, '/EditOrderLineMode', Self.EditOrderLineMode ),
    TRoute.Create( mtAny, '/CancelEditLineOrder', Self.CancelEditLineOrder ),
    TRoute.Create( mtAny, '/ApplyInsertOrder', Self.ApplyInsertOrder ),
    TRoute.Create( mtAny, '/CancelAddOrder', Self.CancelAddOrder ),
    TRoute.Create( mtAny, '/GetTotalOrder', Self.GetTotalOrder )
    ] );
end;

initialization

TInvokerActions.GetInvokerActions.AddAction( TCustomerDetailsController.Create );

end.
