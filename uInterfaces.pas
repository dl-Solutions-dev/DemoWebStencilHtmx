unit uInterfaces;

interface

uses
  Web.HTTPApp,
  Web.Stencils;

type
  IInvokeAction = interface;

  IAction = interface
    ['{EDD3F333-F82D-4618-B49D-450E02D3C16C}']
    procedure InitializeActions( aWebModule: TWebModule; aWebStencil:TWebStencilsEngine );
  end;

  IInvokeAction = interface
    ['{D75EDAD9-1C9E-43AF-8A9A-1F164703335E}']
    procedure AddAction( aAction : IAction);
    procedure RemoveAction( aAction: IAction);
    procedure InitializeActions( aWebModule:TWebModule; aWebStencil:TWebStencilsEngine);
  end;

implementation

end.
