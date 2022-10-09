{
  Proxy is a structural design pattern that lets you provide a substitute or placeholder for another object.
  A proxy controls access to the original object, allowing you to perform something either before or after the request
  gets through to the original object.
}
program Proxy;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  /// <summary> Some service that we would like to proxify </summary>
  IService = interface
    procedure ServiceStuff();
  end;

  /// <summary> Production code, that relies on a service </summary>
  IClient = interface
    procedure Stuff(const AService: IService);
  end;

  /// <summary> Proxy interface for a service. </summary>
  IProxy = interface(IService)
  end;

  {$REGION 'Implementation'}
  TService = class(TInterfacedObject, IService)
  public
    procedure ServiceStuff;
  end;

  TClient = class(TInterfacedObject, IClient)
  public
    procedure Stuff(const AService: IService);
  end;

  TProxy = class(TInterfacedObject, IProxy)
  private
    FService: IService;
    property Service: IService read FService;
  public
    constructor Create();
    destructor Destroy; override;
    procedure ServiceStuff;
  end;

procedure TService.ServiceStuff;
begin
  WriteLn('Srevice stuff');
end;

procedure TClient.Stuff(const AService: IService);
begin
  AService.ServiceStuff();
end;

{ TProxy }

constructor TProxy.Create;
begin
  inherited;
  FService := TService.Create();
end;

destructor TProxy.Destroy;
begin
  FService := nil;
  inherited;
end;

procedure TProxy.ServiceStuff;
begin
  WriteLn('Proxy before service stuff');
  Service.ServiceStuff();
  WriteLn('Proxy after service stuff');
end;
  {$ENDREGION}

begin
  try
    var client := TClient.Create() as IClient;
    var proxyService := TProxy.Create() as IProxy;

    client.Stuff(proxyService);
    Sleep(5000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
