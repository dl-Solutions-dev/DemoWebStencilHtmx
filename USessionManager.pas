(* C2PP
  ***************************************************************************

  Copyright D. LEBLANC 2025
  Ce programme peut être copié et utilisé librement.

  ***************************************************************************

  Ce projet est une démo des possibilités combinés des webstencils et de
  HTMX.

  ***************************************************************************
  File last update : 2025-07-04T19:57:52.000+02:00
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
    FAuthenticated: Boolean;
    FPathInfo: string;
    FActive: Boolean;
    FLastUsed: TDateTime;

    procedure SetIdSession( const Value: string );
    procedure SetAuthenticated( const Value: Boolean );
    procedure SetPathInfo( const Value: string );
    procedure SetActive( const Value: Boolean );
    procedure SetLastUsed( const Value: TDateTime );
  public
    constructor Create;
    destructor Destroy; override;

    property IdSession: string read FIdSession write SetIdSession;
    property DMSession: TDMSession read FDMSession;
    property StartDate: TDateTime read FStartDate;
    property LastUsed: TDateTime read FLastUsed write SetLastUsed;
    property Authenticated: Boolean read FAuthenticated write SetAuthenticated;
    property PathInfo: string read FPathInfo write SetPathInfo;
    property Active: Boolean read FActive write SetActive;
  end;

  TThrdSessionsLife = class( TThread )
  public
    procedure Execute; override;
  end;

  TSessionManager = class
  private
    FSessionList: TThreadList;
    FSessionTimeOut: Integer;
    FThrdSessionLife: TThrdSessionsLife;

    class var
      FInstance: TSessionManager;

    procedure SetSessionTimeOut( const Value: Integer );
  public
    constructor Create;
    destructor Destroy; override;

    class function GetInstance: TSessionManager;

    function CreateSession: string;
    function GetSession( aIdSession: string ): TUserSession;

    property SessionTimeOut: Integer read FSessionTimeOut write SetSessionTimeOut;
    property SessionsList: TThreadList read FSessionList;
  end;

implementation

uses
  System.Hash,
  System.DateUtils;

{ TUserSession }

constructor TUserSession.Create;
begin
  FDMSession := TDMSession.Create( nil );
  FStartDate := Now;
  FActive := True;
end;

destructor TUserSession.Destroy;
begin
  FreeAndNil( FDMSession );

  inherited;
end;

procedure TUserSession.SetActive( const Value: Boolean );
begin
  FActive := Value;

  if not( FActive ) then
  begin
    FreeAndNil( FDMSession );
  end;
end;

procedure TUserSession.SetAuthenticated( const Value: Boolean );
begin
  FAuthenticated := Value;
end;

procedure TUserSession.SetIdSession( const Value: string );
begin
  FIdSession := Value;
end;

procedure TUserSession.SetLastUsed( const Value: TDateTime );
begin
  FLastUsed := Value;
end;

procedure TUserSession.SetPathInfo( const Value: string );
begin
  FPathInfo := Value;
end;

{ TSessionManager }

constructor TSessionManager.Create;
begin
  FSessionList := TThreadList.Create;
  FThrdSessionLife := TThrdSessionsLife.Create;

  FSessionTimeOut := 30000;
end;

function TSessionManager.CreateSession: string;
var
  LSession: TUserSession;
  LGUID: TGUID;
begin
  CreateGUID( LGUID );

  LSession := TUserSession.Create;
  LSession.IdSession := THashSHA1.GetHashString( LGUID.ToString );
  LSession.Authenticated := False;

  FSessionList.Add( LSession );

  Result := LSession.IdSession;
end;

destructor TSessionManager.Destroy;
var
  LList: TList;
begin
  FThrdSessionLife.Terminate;

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
  FreeAndNil( FThrdSessionLife );

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
      if ( TUserSession( LList[ i ] ).IdSession = aIdSession ) and (TUserSession( LList[ i ] ).Active) then
      begin
        TUserSession( LList[ i ] ).LastUsed := Now;

        Exit( TUserSession( LList[ i ] ) );
      end;
    end;
  finally
    FSessionList.UnlockList;
  end;
end;

procedure TSessionManager.SetSessionTimeOut( const Value: Integer );
begin
  FSessionTimeOut := Value;
end;

{ TThrdSessionsLife }

procedure TThrdSessionsLife.Execute;
var
  LSessionsList: TList;
  LSessionManager: TSessionManager;
begin
  LSessionManager := TSessionManager.GetInstance;

  repeat
    LSessionsList := LSessionManager.SessionsList.LockList;

    try
      for var i := 0 to LSessionsList.Count - 1 do
      begin
        if ( MilliSecondsBetween( TUserSession( LSessionsList[ i ] ).LastUsed, Now ) > TSessionManager.GetInstance.SessionTimeOut ) then
        begin
          TUserSession( LSessionsList[ i ] ).Active := False;
        end;
      end;
    finally
      LSessionManager.FSessionList.UnlockList;
    end;

    Sleep( 10000 );
  until Terminated;
end;

end.
