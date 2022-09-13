{
  Bridge is a structural design pattern that lets you split a large class or a set of closely related classes into
  two separate hierarchies: abstraction and implementation, which can be developed independently of each other.
}
program Bridge;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type

  IImplementation = interface
    procedure ImplementationStuff();
  end;

  IAbstraction = interface
    procedure AbstractStuff();
  end;

  IClient = interface
    procedure DoStuff(const AAbstaction: IAbstraction);
  end;

  TImplementationA = class(TInterfacedObject, IImplementation)
    procedure ImplementationStuff();
  end;

  TImplementationB = class(TInterfacedObject, IImplementation)
    procedure ImplementationStuff();
  end;

  TAbstraction = class(TInterfacedObject, IAbstraction)
  private
    FImplementation: IImplementation;
  public
    procedure AbstractStuff;
    constructor Create(const AImplementation: IImplementation);
  end;

  TClient = class(TInterfacedObject, IClient)
    procedure DoStuff(const AAbstaction: IAbstraction);
  end;

{$REGION 'Imlpementation'}

{ TAbstraction }

procedure TAbstraction.AbstractStuff;
begin
  FImplementation.ImplementationStuff();
end;

constructor TAbstraction.Create(const AImplementation: IImplementation);
begin
  FImplementation := AImplementation;
end;

{ TClient }

procedure TClient.DoStuff(const AAbstaction: IAbstraction);
begin
  AAbstaction.AbstractStuff;
end;

{ TImplementationB }

procedure TImplementationB.ImplementationStuff;
begin
  Writeln('TImplementationB.ImplementationStuff');
end;

{ TImplementationA }

procedure TImplementationA.ImplementationStuff;
begin
  Writeln('TImplementationA.ImplementationStuff');
end;

{$ENDREGION}

begin
  try
    var client := TClient.Create() as IClient;
    var abstactionA := TAbstraction.Create(TImplementationA.Create);
    var abstactionB := TAbstraction.Create(TImplementationB.Create);
    client.DoStuff(abstactionA);
    client.DoStuff(abstactionB);
    Sleep(5000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
