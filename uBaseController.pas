(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-05T18:00:34.000+02:00
  Signature : a3da069154ec278374c13e9e4d0cb248d952edd9
  ***************************************************************************
*)

unit uBaseController;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
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
    FWebModule: TWebModule;

    function PickList( aListe: TFDQuery; aPickListName, aCSSClass, aKey, aValue, aSelectedValue: string ): string;
  public
    procedure InitializeActions( aWebModule: TWebModule; aWebStencil: TWebStencilsEngine ); virtual;
    procedure CheckSession( Request: TWebRequest );
  end;

implementation

uses
  System.StrUtils;

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
    FWebModule := aWebModule;
  except
    on E: Exception do
      WriteLn( 'TTasksController.Create: ' + E.Message );
  end;
end;

function TBaseController.PickList( aListe: TFDQuery; aPickListName, aCSSClass, aKey, aValue,
  aSelectedValue: string ): string;
begin
  Result := '<select id="' + aPickListName + '" name="' + aPickListName + '"' + IfThen( aCSSClass <> '', 'class="' + aCSSClass, '' ) + '>';

  aListe.Open;
  aListe.First;

  while not( aListe.Eof ) do
  begin
    Result := Result + '<option value="' + aListe.FieldByName( aKey ).AsString + '"' + IfThen( aListe.FieldByName( aKey ).AsString = aSelectedValue,
      ' selected', '' ) + '>' + aListe.FieldByName( aValue ).AsString + '</option>';

    aListe.Next;
  end;

  Result := Result + '</select>';
end;

end.
