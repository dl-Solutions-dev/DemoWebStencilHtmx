(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-02T21:46:30.000+02:00
  Signature : 05c1f3be76310869ba59f6c63003ffce5fb18d49
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
  UHtmlTemplates,
  UConsts;

type
  TWMMain = class( TWebModule )
    wsEngineDbToXls: TWebStencilsEngine;
    wspIndex: TWebStencilsProcessor;
    wspListeUsers: TWebStencilsProcessor;
    WebFileDispatcher: TWebFileDispatcher;
    wspEditUser: TWebStencilsProcessor;
    procedure WebModuleCreate( Sender: TObject );
    procedure WMMainDefaultHandlerAction( Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean );
  private
    { Déclarations privées }
    FTitle: string;
    FSessionNo: string;
    FStartDate: TDateTime;

    procedure SetTitle( const Value: string );
    procedure SetSessionNo( const Value: string );
    procedure SetStartDate( const Value: TDateTime );
  public
    { Déclarations publiques }
    property Title: string read FTitle write SetTitle;
    property SessionNo: string read FSessionNo write SetSessionNo;
    property StartDate: TDateTime read FStartDate write SetStartDate;
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

procedure TWMMain.WebModuleCreate( Sender: TObject );
begin
  FTitle := 'Export';

  wsEngineDbToXls.AddVar( 'App', Self, False );

  TInvokerActions.GetInvokerActions.InitializeActions( Self, wsEngineDbToXls );
end;

procedure TWMMain.WMMainDefaultHandlerAction( Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean );
begin
  if ( Request.QueryFields.Values[ 'Session' ] = '' ) then
  begin
    FSessionNo := TSessionManager.GetInstance.CreateSession;
  end
  else
  begin
    FSessionNo := TSessionManager.GetInstance.GetSession( Request.QueryFields.Values[ 'Session' ] ).IdSession;
  end;

  Response.Content := wspIndex.Content;
  Handled := True;
end;

end.
