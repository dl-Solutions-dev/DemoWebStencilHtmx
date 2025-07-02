(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-02T21:47:04.000+02:00
  Signature : 9e856112c2d57d69c698eac66173b16245a1c849
  ***************************************************************************
*)

unit USessionManager;

interface

uses
  System.Classes,
  System.SysUtils,
  UDMSession;

type
  TUserSession = class
  private
    FDMSession: TDMSession;
    FIdSession: string;
    FStartDate: TDateTime;

    procedure SetIdSession( const Value: string );
  public
    constructor Create;
    destructor Destroy; override;

    property IdSession: string read FIdSession write SetIdSession;
    property DMSession: TDMSession read FDMSession;
    property StartDate: TDateTime read FStartDate;
  end;

  TSessionManager = class
  private
    FSessionList: TThreadList;

    class var
      FInstance: TSessionManager;
  public
    constructor Create;
    destructor Destroy; override;

    class function GetInstance: TSessionManager;

    function CreateSession: string;
    function GetSession( aIdSession: string ): TUserSession;
  end;

implementation

uses
  System.Hash;

{ TUserSession }

constructor TUserSession.Create;
begin
  FDMSession := TDMSession.Create( nil );
  FStartDate := Now;
end;

destructor TUserSession.Destroy;
begin
  FreeAndNil( FDMSession );

  inherited;
end;

procedure TUserSession.SetIdSession( const Value: string );
begin
  FIdSession := Value;
end;

{ TSessionManager }

constructor TSessionManager.Create;
begin
  FSessionList := TThreadList.Create;
end;

function TSessionManager.CreateSession: string;
var
  LSession: TUserSession;
  LGUID: TGUID;
begin
  CreateGUID( LGUID );

  LSession := TUserSession.Create;
  LSession.IdSession := THashSHA1.GetHashString( LGUID.ToString );

  FSessionList.Add( LSession );

  Result := LSession.IdSession;
end;

destructor TSessionManager.Destroy;
var
  LList: TList;
begin
  LList := FSessionList.LockList;
  try
    for var i := 0 to LList.Count - 1 do
    begin
      TUserSession( LList[ i ] ).Free;
    end;
  finally
    FSessionList.UnlockList;
  end;

  FreeAndNil( FSessionList );

  inherited;
end;

class function TSessionManager.GetInstance: TSessionManager;
begin
  if not( Assigned( FInstance ) ) then
  begin
    FInstance := TSessionManager.Create;
  end;

  Result := FInstance;
end;

function TSessionManager.GetSession( aIdSession: string ): TUserSession;
var
  LList: TList;
begin
  Result := nil;

  LList := FSessionList.LockList;
  try
    for var i := 0 to LList.Count - 1 do
    begin
      if ( TUserSession( LList[ i ] ).IdSession = aIdSession ) then
      begin
        Exit( TUserSession( LList[ i ] ) );
      end;
    end;
  finally
    FSessionList.UnlockList;
  end;
end;

end.
