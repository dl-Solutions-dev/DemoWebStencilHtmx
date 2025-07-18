﻿(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-02T23:53:18.494+02:00
  Signature : d6bfc0e581c774400da55a334cf56a120cdefebc
  ***************************************************************************
*)

unit utils.ClassHelpers;

interface

uses
  Web.HTTPApp,
  System.SysUtils;

type
  TRoute = record
  public
    MethodType: TMethodType;
    PathInfo: string;
    OnAction: THTTPMethodEvent;
    Default: Boolean;
    constructor Create(const AMethodType: TMethodType; const APathInfo: String; const AOnAction: THTTPMethodEvent;
      const ADefault: Boolean = false);
  end;

  // Allows creating Actions/Routes in a more declarative way
  TWebModuleHelper = class Helper for TwebModule
  public
    function AddAction(const AMethodType: TMethodType; const APathInfo: String; const AOnAction: THTTPMethodEvent;
      const ADefault: Boolean = false): TwebModule;
    procedure AddRoutes(ARoutes: array of TRoute);
  end;

implementation

uses
  RTTI;

{ TRoute }

constructor TRoute.Create(const AMethodType: TMethodType; const APathInfo: string; const AOnAction: THTTPMethodEvent;
  const ADefault: Boolean = false);
begin
  MethodType := AMethodType;
  PathInfo := APathInfo;
  OnAction := AOnAction;
  default := ADefault;
end;

{ TWebModuleHelper }

function TWebModuleHelper.AddAction(const AMethodType: TMethodType; const APathInfo: String;
  const AOnAction: THTTPMethodEvent; const ADefault: Boolean = false): TwebModule;
begin
  var act := Actions.Add;
  act.MethodType := AMethodType;
  // Convert the enum AMethodType to string to add it to the Action name and avoid collisions between endpoints
  var MethodTypeString := TRttiEnumerationType.GetName(AMethodType);
  act.Name := APathInfo + MethodTypeString;
  act.PathInfo := APathInfo;
  act.OnAction := AOnAction;
  act.Default := ADefault;
  Result := self;
end;

procedure TWebModuleHelper.AddRoutes(ARoutes: array of TRoute);
begin
  for var Route in ARoutes do
    AddAction(Route.MethodType, Route.PathInfo, Route.OnAction, Route.Default);
end;

end.
