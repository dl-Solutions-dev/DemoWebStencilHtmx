(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-02T21:47:54.000+02:00
  Signature : 51f1aa180195a50be7491d78a668e31ec61fb921
  ***************************************************************************
*)

unit UListeUsersController;

interface

uses
  System.SysUtils,
  Web.HTTPApp,
  Web.Stencils,
  uBaseController,
  uInterfaces,
  USessionManager;

type
  TListeUsers = class( TBaseController )
  private
    FSessionNo: string;
    FStartDate: TDateTime;
    FWebStencil: TWebStencilsEngine;
  public
    procedure ListeUsers( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure ApplyUser( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure DeleteUser( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure AddUser( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure EditLineMode( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure CancelEditLineUser( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure ApplyInsertUser( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
    procedure CancelAddUser( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );

    procedure InitializeActions( aWebModule: TWebModule; aWebStencil: TWebStencilsEngine ); override;
  end;

implementation


{ TListeUsers }

uses
  System.SyncObjs,
  FireDAC.Stan.Param,
  utils.ClassHelpers,
  UConsts,
  UHtmlTemplates,
  uInvokerActions,
  UDMSession;

procedure TListeUsers.AddUser( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TSessionManager.GetInstance.GetSession( Request.QueryFields.Values[ 'Session' ] );

    if Assigned( LSession ) then
    begin
      Response.Content := ADD_USER
        .Replace( TAG_SESSION, LSession.IdSession, [ rfReplaceAll ] );
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

procedure TListeUsers.ApplyInsertUser( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LIds: string;
  LNoSession: string;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TSessionManager.GetInstance.GetSession( Request.QueryFields.Values[ 'Session' ] );

    if Assigned( LSession ) then
    begin
      LSession.DMSession.QrySeq.close;
      LSession.DMSession.QrySeq.Open;

      LSession.DMSession.QryUser.Open;
      LSession.DMSession.QryUser.Append;
      LSession.DMSession.QryUserID_USER.Value := LSession.DMSession.QrySeqNEWID.Value;
      LSession.DMSession.QryUserNOM.Value := Request.ContentFields.Values[ 'Nom' ];
      LSession.DMSession.QryUserPRENOM.Value := Request.ContentFields.Values[ 'Prenom' ];
      LSession.DMSession.QryUser.Post;

      LIds := LSession.DMSession.QrySeqNEWID.Value.ToString;
      LNoSession := LSession.IdSession;

      Response.Content := LINE_USER
        .Replace( TAG_ID_USER, LIds, [ rfReplaceAll ] )
        .Replace( TAG_SESSION, LNoSession, [ rfReplaceAll ] )
        .Replace( TAG_PRENOM, LSession.DMSession.QryUser.FieldByName( 'PRENOM' ).AsString, [ rfReplaceAll ] )
        .Replace( TAG_NOM, LSession.DMSession.QryUser.FieldByName( 'NOM' ).AsString, [ rfReplaceAll ] );
    end;
  end;
end;

procedure TListeUsers.ApplyUser( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LIds: string;
begin
  if ( Request.QueryFields.Values[ 'Session' ] = '' ) then
  begin
    FSessionNo := TSessionManager.GetInstance.CreateSession;
  end;

  LSession := TSessionManager.GetInstance.GetSession( Request.QueryFields.Values[ 'Session' ] );
  FSessionNo := LSession.IdSession;

  FStartDate := LSession.StartDate;

  if ( Request.QueryFields.Values[ 'Id' ] <> '' ) and ( TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) ) { and
    ( TryStrToInt( Request.QueryFields.Values[ 'Col' ], LCol ) ) } then
  begin
    if LId <> -1 then
    begin
      LSession.DMSession.QryUser.close;
      LSession.DMSession.QryUser.ParamByName( 'ID_USER' ).AsInteger := LId;
      LSession.DMSession.QryUser.Open;
      LSession.DMSession.QryUser.Edit;

      LSession.DMSession.QryUserPRENOM.Value := Request.ContentFields.Values[ 'Prenom' ];
      LSession.DMSession.QryUserNOM.Value := Request.ContentFields.Values[ 'Nom' ];

      LSession.DMSession.QryUser.Post;

      LIds := Request.QueryFields.Values[ 'Id' ];

      Response.Content := LINE_USER
        .Replace( TAG_ID_USER, LIds, [ rfReplaceAll ] )
        .Replace( TAG_SESSION, FSessionNo, [ rfReplaceAll ] )
        .Replace( TAG_PRENOM, LSession.DMSession.QryUser.FieldByName( 'PRENOM' ).AsString, [ rfReplaceAll ] )
        .Replace( TAG_NOM, LSession.DMSession.QryUser.FieldByName( 'NOM' ).AsString, [ rfReplaceAll ] );
    end
    else
    begin

    end;
  end;

end;

procedure TListeUsers.CancelEditLineUser( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
  LIds, LNoSession: string;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TSessionManager.GetInstance.GetSession( Request.QueryFields.Values[ 'Session' ] );

    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.Critical.Acquire;
        try
          LSession.DMSession.QryUserCancel.close;
          LSession.DMSession.QryUserCancel.ParamByName( 'ID_USER' ).AsInteger := LId;
          LSession.DMSession.QryUserCancel.Open;

          if not( LSession.DMSession.QryUserCancel.Eof ) then
          begin
            LIds := LId.ToString;
            LNoSession := LSession.IdSession;

            Response.Content := LINE_USER
              .Replace( TAG_ID_USER, LIds, [ rfReplaceAll ] )
              .Replace( TAG_SESSION, LNoSession, [ rfReplaceAll ] )
              .Replace( TAG_PRENOM, LSession.DMSession.QryUser.FieldByName( 'PRENOM' ).AsString, [ rfReplaceAll ] )
              .Replace( TAG_NOM, LSession.DMSession.QryUser.FieldByName( 'NOM' ).AsString, [ rfReplaceAll ] );
          end;
        finally
          LSession.DMSession.Critical.Leave;
        end;
      end;
    end;
  end;
end;

procedure TListeUsers.CancelAddUser( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
begin
  Response.Content := '<tr style="display:none;"><td></td><td></td><td></td><td></td></tr>';
end;

procedure TListeUsers.DeleteUser( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TSessionManager.GetInstance.GetSession( Request.QueryFields.Values[ 'Session' ] );

    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.QryUser.close;
        LSession.DMSession.QryUser.ParamByName( 'ID_USER' ).AsInteger := LId;
        LSession.DMSession.QryUser.Open;

        if not( LSession.DMSession.QryUser.Eof ) then
        begin
          LSession.DMSession.QryUser.Delete;
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

procedure TListeUsers.EditLineMode( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LId: Integer;
begin
  if ( Request.QueryFields.Values[ 'Session' ] <> '' ) then
  begin
    LSession := TSessionManager.GetInstance.GetSession( Request.QueryFields.Values[ 'Session' ] );

    if Assigned( LSession ) then
    begin
      if TryStrToInt( Request.QueryFields.Values[ 'Id' ], LId ) then
      begin
        LSession.DMSession.Critical.Acquire;
        try
          LSession.DMSession.QryUser.close;
          LSession.DMSession.QryUser.ParamByName( 'ID_USER' ).AsInteger := LId;
          LSession.DMSession.QryUser.Open;

          if not( LSession.DMSession.QryUser.Eof ) then
          begin
            Response.Content := EDIT_LINE_USER
              .Replace( TAG_SESSION, LSession.IdSession, [ rfReplaceAll ] )
              .Replace( TAG_ID_USER, LId.ToString, [ rfReplaceAll ] )
              .Replace( TAG_PRENOM, LSession.DMSession.QryUser.FieldByName( 'PRENOM' ).AsString )
              .Replace( TAG_NOM, LSession.DMSession.QryUser.FieldByName( 'NOM' ).AsString );
          end;
        finally
          LSession.DMSession.Critical.Leave;
        end;
      end;
    end;
  end;
end;

procedure TListeUsers.InitializeActions( aWebModule: TWebModule;
  aWebStencil: TWebStencilsEngine );
begin
  FWebStencil := aWebStencil;

  aWebModule.AddRoutes( [
    TRoute.Create( mtGet, '/ListeUsers', Self.ListeUsers ),
    TRoute.Create( mtAny, '/ApplyUser', Self.ApplyUser ),
    TRoute.Create( mtDelete, '/DeleteUser', Self.DeleteUser ),
    TRoute.Create( mtAny, '/AddUser', Self.AddUser ),
    TRoute.Create( mtAny, '/EditLineMode', Self.EditLineMode ),
    TRoute.Create( mtAny, '/CancelEditUser', Self.CancelEditLineUser ),
    TRoute.Create( mtAny, '/ApplyInsertUser', Self.ApplyInsertUser ),
    TRoute.Create( mtAny, '/CancelAddUser', Self.CancelAddUser )
    ] );
end;

procedure TListeUsers.ListeUsers( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  LSession: TUserSession;
  LProcessorEngine: TWebStencilsProcessor;
begin
  if ( Request.QueryFields.Values[ 'Session' ] = '' ) then
  begin
    FSessionNo := TSessionManager.GetInstance.CreateSession;
  end;

  LSession := TSessionManager.GetInstance.GetSession( Request.QueryFields.Values[ 'Session' ] );
  if Assigned( LSession ) then
  begin
    LProcessorEngine := TWebStencilsProcessor.Create( nil );
    LProcessorEngine.Engine := FWebStencil;
    LProcessorEngine.InputFileName := './templates/ListeUsers.html';
    LProcessorEngine.PathTemplate := './Templates';

    FSessionNo := LSession.IdSession;

    FStartDate := LSession.StartDate;

    LSession.DMSession.QryUsers.close;
    LSession.DMSession.QryUsers.Open;

    if not LProcessorEngine.HasVar( 'UserList' ) then
      FWebStencil.AddVar( 'UserList', LSession.DMSession.QryUsers, False );

    Response.Content := LProcessorEngine.Content;
    Handled := True;
  end
  else
  begin
    Response.Content := 'Session non trouvée.';
  end;
end;

initialization

TInvokerActions.GetInvokerActions.AddAction( TListeUsers.Create );

end.
