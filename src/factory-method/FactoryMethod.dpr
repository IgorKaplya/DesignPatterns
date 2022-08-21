{
  Factory Method is a creational design pattern that provides an interface for creating objects in a superclass,
  but allows subclasses to alter the type of objects that will be created.

  https://refactoring.guru/design-patterns/factory-method
}

program FactoryMethod;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  /// <summary> Interface of an Object to be created. </summary>
  IProduct = interface
    procedure DoStuff();
  end;

  /// <summary> Superinterface for creating objects. </summary>
  ICreator = interface
    function FactoryMethod: IProduct;
  end;

  {$REGION 'Implementations'}

  /// <summary> Object implementation A </summary>
  TProductA = class(TInterfacedObject, IProduct)
    procedure DoStuff();
  end;

  /// <summary> Object implementation B </summary>
  TProductB = class(TInterfacedObject, IProduct)
    procedure DoStuff();
  end;

  /// <summary> Implementation A of a superinterface for creating objects. </summary>
  TCreatorA = class(TInterfacedObject, ICreator)
    function FactoryMethod(): IProduct;
  end;

  /// <summary> Implementation B of a superinterface for creating objects. </summary>
  TCreatorB = class(TInterfacedObject, ICreator)
    function FactoryMethod(): IProduct;
  end;

  /// <summary> Production code where we use factory method pattern. </summary>
  TClient = class
    procedure DoSomeStuff(const ACreator: ICreator);
  end;


{ TCreatorA }

function TCreatorA.FactoryMethod: IProduct;
begin
  Result := TProductA.Create();
end;

{ TProductA }

procedure TProductA.DoStuff;
begin
  Writeln('Do stuff A');
end;

{ TProductA1 }

procedure TProductB.DoStuff;
begin
  Writeln('Do stuff B');
end;

{ TCreatorB }

function TCreatorB.FactoryMethod: IProduct;
begin
  Result := TProductB.Create();
end;

{ TClient }

procedure TClient.DoSomeStuff(const ACreator: ICreator);
begin
  ACreator
    .FactoryMethod()
    .DoStuff();
end;

{$ENDREGION}

begin
  try
    var creatorA := TCreatorA.Create() as ICreator;
    var creatorB:= TCreatorB.Create() as ICreator;

    var client := TClient.Create();
    try
      client.DoSomeStuff(creatorA);
      client.DoSomeStuff(creatorB);
    finally
      client.Free();
    end;

    Sleep(5000);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
