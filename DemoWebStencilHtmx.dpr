(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-02T23:27:48.000+02:00
  Signature : cfd6f60e3b0ce7e51cba49ca3111df21c1360ca4
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
  UHtmlTemplates in 'UHtmlTemplates.pas',
  UConsts in 'UConsts.pas',
  uBaseController in 'uBaseController.pas',
  uInterfaces in 'uInterfaces.pas',
  utils.ClassHelpers in 'utils.ClassHelpers.pas',
  UListeUsersController in 'UListeUsersController.pas',
  uInvokerActions in 'uInvokerActions.pas',
  UMenu in 'UMenu.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
