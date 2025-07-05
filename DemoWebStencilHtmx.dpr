(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-05T19:41:34.000+02:00
  Signature : f364958d3b391d99a4abceb32360a8c8ac5ea93d
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
  UCustomersListController in 'UCustomersListController.pas',
  uInvokerActions in 'uInvokerActions.pas',
  UMenu in 'UMenu.pas',
  UCustomerDetails in 'UCustomerDetails.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
