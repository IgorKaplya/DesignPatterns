{
  Adapter is a structural design pattern that allows objects with incompatible interfaces to collaborate.
}
program Adapter;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type

  /// <summary> Service object </summary>
  IService = interface
    procedure DoStuff();
  end;

  /// <summary> Client interface </summary>
  IClient = interface
    procedure DoClientStuff();
  end;

  /// <summary> Adapter implements the client interface, while wrapping the service object </summary>
  TAdapter = class(TInterfacedObject, IClient)
  private
    FAdaptee: IService;
    property Adaptee: IService read FAdaptee;
  public
    constructor Create(AAdaptee: IService);
    procedure DoClientStuff;
  end;

  /// <summary> Class that can collaborate with the client interface </summary>
  TClient = class
    procedure DoSomeStuff(const AAdapter: IClient);
  end;

{$REGION 'Implementations'}

  TService = class(TInterfacedObject, IService)
  public
    procedure DoStuff();
  end;

{ TClient }

procedure TClient.DoSomeStuff(const AAdapter: IClient);
begin
  AAdapter.DoClientStuff();
end;

{ TAdapter }

constructor TAdapter.Create(AAdaptee: IService);
begin
  FAdaptee := AAdaptee;
end;

procedure TAdapter.DoClientStuff;
begin
  Adaptee.DoStuff();
end;

{ TSevice }

procedure TService.DoStuff;
begin
  Writeln('Service stuff');
end;

{$ENDREGION}

begin
  try
    var client := TClient.Create();
    try
      var service := TService.Create() as IService;
      var adapter1 := TAdapter.Create(service) as IClient;
      client.DoSomeStuff(adapter1);
    finally
      client.Free;
    end;

    Sleep(5000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
