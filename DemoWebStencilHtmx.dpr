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
  uInvokerActions in 'uInvokerActions.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
