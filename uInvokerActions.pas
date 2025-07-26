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
  File last update : 2025-07-26T19:37:26.000+02:00
  Signature : bbff831e45be083bcb0ae2b006da1cc2137a651a
  ***************************************************************************
*)

unit uInvokerActions;

interface

uses
  Classes,
  System.SysUtils,
  Web.HTTPApp,
  Web.Stencils,
  uInterfaces;

type
  TInvokerActions = class( TInterfacedObject, IInvokeAction )
  private
    FActionList: TInterfaceList;

    class var FInvoker: TInvokerActions;
  public
    constructor Create;
    destructor Destroy; override;

    class destructor DestroyClass;

    class function GetInvokerActions: TInvokerActions;

    // IInvokeAction
    procedure AddAction( aAction: IAction );
    procedure RemoveAction( aAction: IAction );
    procedure InitializeActions( aWebStencil: TWebStencilsEngine );
    // procedure LogParametres( ASession: TIWApplication );
  end;

implementation

{ TInvokerActions }

procedure TInvokerActions.AddAction( aAction: IAction );
var
  t: textfile;
begin
  AssignFile( t, ExtractFilePath( ParamStr( 0 ) ) + 'tractinit.txt' );
  if not( FileExists( ExtractFilePath( ParamStr( 0 ) ) + 'tractinit.txt' ) ) then
    rewrite( t )
  else
    append( t );

  Writeln( t, 'ajout action' );
  CloseFile( t );
  if FActionList.IndexOf( aAction ) = -1 then
  begin
    FActionList.Add( aAction );
  end;
end;

constructor TInvokerActions.Create;
begin
  inherited;

  FActionList := TInterfaceList.Create;
end;

destructor TInvokerActions.Destroy;
begin
  FActionList.Free;

  inherited;
end;

class destructor TInvokerActions.DestroyClass;
begin
  if Assigned( FInvoker ) then
    FInvoker.Free;
end;

class function TInvokerActions.GetInvokerActions: TInvokerActions;
begin
  if not Assigned( FInvoker ) then
  begin
    FInvoker := TInvokerActions.Create;
  end;

  Result := FInvoker;
end;

// procedure TInvokerActions.LogParametres( ASession: TIWApplication );
// var
// I: Integer;
// begin
// for I := 0 to ASession.RunParams.Count - 1 do
// begin
// AddTrace( trInformation, ASession.RunParams.Names[ I ] + ' -> ' + ASession.RunParams.ValueFromIndex[ I ] );
// end;
// end;

procedure TInvokerActions.InitializeActions( aWebStencil: TWebStencilsEngine );
var
  I: Integer;
  wHandledAction: Boolean;
begin
  wHandledAction := False;

  for I := 0 to FActionList.Count - 1 do
  begin
    IAction( FActionList[ I ] ).InitializeActions( aWebStencil );

    if wHandledAction then
      Break;
  end;

  if not( wHandledAction ) then
  begin

  end;
end;

procedure TInvokerActions.RemoveAction( aAction: IAction );
begin
  if FActionList.IndexOf( aAction ) <> -1 then
    FActionList.Remove( aAction );
end;

end.
