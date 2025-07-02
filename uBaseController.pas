(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-02T19:44:02.000+02:00
  Signature : 59de5656460c43df2e088e29a169ca71e8084f11
  ***************************************************************************
*)

unit uBaseController;

interface

uses
  System.SysUtils,
  Web.HTTPApp,
  Web.Stencils,
  uSessionManager,
  uInterfaces;

type
  TBaseController = class( TInterfacedObject, IAction )
  private
  protected
    FWebStencilsProcessor: TWebStencilsProcessor;
    FWebStencilsEngine: TWebStencilsEngine;

  public
    procedure InitializeActions( aWebModule: TWebModule; aWebStencil: TWebStencilsEngine ); virtual;
    procedure CheckSession( Request: TWebRequest );
  end;

implementation

{ TBaseController }

procedure TBaseController.CheckSession( Request: TWebRequest );
begin
  if ( Request.QueryFields.Values[ 'sesid' ] <> '' ) then
  begin

  end;
end;

procedure TBaseController.InitializeActions( aWebModule: TWebModule;
  aWebStencil: TWebStencilsEngine );
begin
  try
    FWebStencilsEngine := aWebStencil;
    FWebStencilsProcessor := TWebStencilsProcessor.Create( nil );
    FWebStencilsProcessor.Engine := FWebStencilsEngine;
  except
    on E: Exception do
      WriteLn( 'TTasksController.Create: ' + E.Message );
  end;
end;

end.
