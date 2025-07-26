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
  File last update : 2025-07-14T19:37:04.000+02:00
  Signature : 3eb76aaac8e7b5665ff2765730f40e569b1fc137
  ***************************************************************************
*)

program DemoWebStencilHtmx;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  UFrmMainTest in 'UFrmMainTest.pas' {Form1},
  UWMMain in 'UWMMain.pas' {WMMain: TWebModule},
  UDMSession in 'UDMSession.pas' {DMSession: TDataModule},
  USessionManager in 'USessionManager.pas',
  UConsts in 'UConsts.pas',
  uBaseController in 'uBaseController.pas',
  uInterfaces in 'uInterfaces.pas',
  utils.ClassHelpers in 'utils.ClassHelpers.pas',
  UCustomersListController in 'UCustomersListController.pas',
  uInvokerActions in 'uInvokerActions.pas',
  UMenu in 'UMenu.pas',
  UCustomerDetailsController in 'UCustomerDetailsController.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
