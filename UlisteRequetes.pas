unit UlisteRequetes;

interface

uses
  System.SysUtils,
  Web.HTTPApp,
  Web.Stencils,
  uBaseController,
  uInterfaces,
  USessionManager;

type
  TListeRequetes = class( TBaseController )
  private
    FSessionNo: string;
  public
    procedure ListeRequetes( Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );

    procedure InitializeActions( aWebModule: TWebModule; aWebStencil: TWebStencilsEngine ); override;
  end;

implementation

uses
  utils.ClassHelpers;

{ TListeRequetes }

procedure TListeRequetes.InitializeActions( aWebModule: TWebModule;
  aWebStencil: TWebStencilsEngine );
begin
  inherited;

  FWebStencilsEngine := aWebStencil;

  aWebModule.AddRoutes( [
    TRoute.Create( mtGet, '/ListeRequetes', Self.ListeRequetes )
    ] );
end;

procedure TListeRequetes.ListeRequetes( Sender: TObject; Request: TWebRequest;
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
    LProcessorEngine.Engine := FWebStencilsEngine;
    LProcessorEngine.InputFileName := './templates/ListeRequetes.html';
    LProcessorEngine.PathTemplate := './Templates';

    FSessionNo := LSession.IdSession;

    LSession.DMSession.QryUsers.close;
    LSession.DMSession.QryUsers.Open;

    if not LProcessorEngine.HasVar( 'RequestList' ) then
      FWebStencilsEngine.AddVar( 'RequestList', LSession.DMSession.QryRequetes, False );

    Response.Content := LProcessorEngine.Content;
    Handled := True;
  end
  else
  begin
    Response.Content := 'Session non trouvée.';
  end;
end;

end.
