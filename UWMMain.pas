(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut �tre copi� et utilis� librement.

  ***************************************************************************

  Ce projet est une d�mo des possibilit�s combin�s des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-05T21:05:22.000+02:00
  Signature : 6c21511566e9638a17e77940323245411536b414
  ***************************************************************************
*)

unit UWMMain;

interface

uses
  System.SysUtils,
  System.Classes,
  Web.HTTPApp,
  Web.Stencils,
  UDMSession,
  USessionManager,
  UConsts;

type
  TWMMain = class( TWebModule )
    wsEngineCustomers: TWebStencilsEngine;
    WebFileDispatcher: TWebFileDispatcher;
    wspIndex: TWebStencilsProcessor;
    wspBadLogin: TWebStencilsProcessor;
    procedure WebModuleCreate( Sender: TObject );
    procedure WMMainDefaultHandlerAction( Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean );
    procedure WebModuleBeforeDispatch( Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean );
    procedure WMMainWaLoginAction( Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean );
  private
    { D�clarations priv�es }
    FTitle: string;
    FSessionNo: string;
    FStartDate: TDateTime;
    FUserSession: TUserSession;

    procedure SetTitle( const Value: string );
    procedure SetSessionNo( const Value: string );
    procedure SetStartDate( const Value: TDateTime );
    procedure SetUserSession( const Value: TUserSession );
  public
    { D�clarations publiques }
    property Title: string read FTitle write SetTitle;
    property SessionNo: string read FSessionNo write SetSessionNo;
    property StartDate: TDateTime read FStartDate write SetStartDate;
    property UserSession: TUserSession read FUserSession write SetUserSession;
  end;

var
  WebModuleClass: TComponentClass = TWMMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}


uses uInvokerActions;

{$R *.dfm}


procedure TWMMain.SetSessionNo( const Value: string );
begin
  FSessionNo := Value;
end;

procedure TWMMain.SetStartDate( const Value: TDateTime );
begin
  FStartDate := Value;
end;

procedure TWMMain.SetTitle( const Value: string );
begin
  FTitle := Value;
end;

procedure TWMMain.SetUserSession( const Value: TUserSession );
begin
  FUserSession := Value;
end;

procedure TWMMain.WebModuleBeforeDispatch( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
var
  wT: TextFile;
begin
  if ( Request.QueryFields.Values[ 'Session' ] = '' ) then
  begin
    FSessionNo := TSessionManager.GetInstance.CreateSession;
  end
  else
  begin
    FSessionNo := Request.QueryFields.Values[ 'Session' ];
  end;

  FUserSession := TSessionManager.GetInstance.GetSession( FSessionNo );
  if Assigned( FUserSession ) then
  begin
    if not( FUserSession.Authenticated ) and ( CompareStr( Request.PathInfo, '/Login' ) <> 0 ) then
    begin
      FUserSession.PathInfo := Request.PathInfo + '?' + Request.Query;
    end;
  end;
end;

procedure TWMMain.WebModuleCreate( Sender: TObject );
begin
  FTitle := 'Export';

  wsEngineCustomers.AddVar( 'App', Self, False );

  TInvokerActions.GetInvokerActions.InitializeActions( Self, wsEngineCustomers );
end;

procedure TWMMain.WMMainDefaultHandlerAction( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
begin
  Response.Content := wspIndex.Content;
  Handled := True;
end;

procedure TWMMain.WMMainWaLoginAction( Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean );
begin
  if Assigned( FUserSession ) then
  begin
    if ( FUserSession.DMSession.LoginUser( Request ) ) then
    begin
      FUserSession.Authenticated := True;

      Response.SendRedirect( '.' + FUserSession.PathInfo );
    end
    else
    begin
      Response.Content := wspBadLogin.Content;
    end;
  end;
end;

end.
