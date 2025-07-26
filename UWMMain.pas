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
  File last update : 2025-07-26T19:43:55.331+02:00
  Signature : d519a74c82fafe0038bf8bc13e3be921e5f9e475
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
    { Déclarations privées }
    FTitle: string;
    FSessionNo: string;
    FStartDate: TDateTime;
    FUserSession: TUserSession;

    procedure SetTitle( const Value: string );
    procedure SetSessionNo( const Value: string );
    procedure SetStartDate( const Value: TDateTime );
    procedure SetUserSession( const Value: TUserSession );
  public
    { Déclarations publiques }
    property Title: string read FTitle write SetTitle;
    property SessionNo: string read FSessionNo write SetSessionNo;
    property StartDate: TDateTime read FStartDate write SetStartDate;
    property UserSession: TUserSession read FUserSession write SetUserSession;
  end;

var
  WebModuleClass: TComponentClass = TWMMain;

function UserSession( aWebActionitem: TObject ): TUserSession;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}


uses uInvokerActions;

{$R *.dfm}


function UserSession( aWebActionitem: TObject ): TUserSession;
begin
  Result := TWMMain( TWebActionItem( aWebActionitem ).Collection.Owner ).UserSession;
end;

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
