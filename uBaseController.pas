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
