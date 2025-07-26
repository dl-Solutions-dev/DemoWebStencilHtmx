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
  File last update : 2025-07-26T19:59:26.000+02:00
  Signature : 2437ff3c4e582ed46eae691a7e4979951f917a24
  ***************************************************************************
*)

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
    procedure InitializeActions( aWebModule: TWebModule; aWebStencil:TWebStencilsEngine);
  end;

implementation

end.
