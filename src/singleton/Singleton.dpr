{
  Singleton is a creational design pattern that lets you ensure that a class has only one instance,
  while providing a global access point to this instance.
}
program Singleton;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type

  TSingleton = class(TObject)
  strict private
    class var FInstance: TSingleton;
    class destructor Destroy();
    constructor InternalCreate();
  public
    class function GetInstance(): TSingleton;
    procedure DoStuff();
    constructor Create(); deprecated;
  end;

  TClient = class
    procedure DoSomeStuff(ASingleton: TSingleton);
  end;

{ TSingleton }

constructor TSingleton.Create();
begin
  raise Exception.Create('Singleton creation not allowed');
end;

class destructor TSingleton.Destroy;
begin
  FreeAndNil(FInstance);
end;

procedure TSingleton.DoStuff;
begin
  Writeln(Self.GetHashCode.ToString + ' Stuff');
end;

class function TSingleton.GetInstance: TSingleton;
begin
  if not Assigned(FInstance) then
    FInstance := TSingleton.InternalCreate();
  Result := FInstance;
end;

constructor TSingleton.InternalCreate;
begin
  inherited Create();
end;

{ TClient }

procedure TClient.DoSomeStuff(ASingleton: TSingleton);
begin
  ASingleton.DoStuff();
end;

begin
  try
    var client := TClient.Create();
    try
      var singleton1 := TSingleton.GetInstance();
      var singleton2 := TSingleton.GetInstance();

      client.DoSomeStuff(singleton1);
      client.DoSomeStuff(singleton2);

      try
        TSingleton.Create();
      except on e: Exception do  Writeln(E.ClassName, ': ', E.Message);
      end;
    finally
      client.Free;
    end;

    Sleep(5000);
  except
    on E: Exception do Writeln(E.ClassName, ': ', E.Message);
  end;
end.
