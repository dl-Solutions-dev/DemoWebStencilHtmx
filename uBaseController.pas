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
  File last update : 2025-07-26T19:22:46.000+02:00
  Signature : 66b6beb2b2f1973163a65adaac9a3c6c8b603479
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

    function PickList( aListe: TFDQuery; aPickListName, aCSSClass, aKey, aValue, aSelectedValue: string ): string;
    function LoginUser: string;

    procedure SendEmptyContent( aResponse: TWebResponse );
  public
    procedure InitializeActions( aWebStencil: TWebStencilsEngine ); virtual;
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

procedure TBaseController.InitializeActions( aWebStencil: TWebStencilsEngine );
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

function TBaseController.LoginUser: string;
var
  LProcessorEngine: TWebStencilsProcessor;
begin
  LProcessorEngine := TWebStencilsProcessor.Create( nil );
  try
    LProcessorEngine.Engine := FWebStencilsEngine;
    LProcessorEngine.InputFileName := './templates/Login.html';
    LProcessorEngine.PathTemplate := './Templates';

    Result := LProcessorEngine.Content;
  finally
    FreeAndNil( LProcessorEngine )
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

procedure TBaseController.SendEmptyContent( aResponse: TWebResponse );
begin
  aResponse.Content := ' ';
  aResponse.ContentLength := 1;
  aResponse.StatusCode := 200;
end;

end.
