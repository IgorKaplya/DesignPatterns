{
  Abstract Factory is a creational design pattern that lets you produce families of related objects without specifying their concrete classes.
}
program AbstractFactory;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  /// <summary> Product A of a family N </summary>
  IProductA = interface
    procedure StuffA();
  end;

  /// <summary> Product B of a family N </summary>
  IProductB = interface
    procedure StuffB();
  end;

  /// <summary> Factory of product families </summary>
  IAbstractFactory = interface
    function CreateProductA(): IProductA;
    function CreateProductB(): IProductB;
  end;

  /// <summary>  Production code, where we use abstract factory </summary>
  TClient = class
    procedure CreateProducts(const AFactory: IAbstractFactory);
  end;

{$REGION 'Implementations'}

  /// <summary> Concrete product A of a family 1 </summary>
  TProductA1 = class(TInterfacedObject, IProductA)
    procedure StuffA();
  end;
  /// <summary> Concrete product B of a family 1 </summary>
  TProductB1 = class(TInterfacedObject, IProductB)
    procedure StuffB();
  end;

  /// <summary> Concrete factory that creates products of family 1 </summary>
  TFactory1 = class(TInterfacedObject, IAbstractFactory)
    function CreateProductA(): IProductA;
    function CreateProductB(): IProductB;
  end;

  /// <summary> Concrete product A of a family 2 </summary>
  TProductA2 = class(TInterfacedObject, IProductA)
    procedure StuffA();
  end;

  /// <summary> Concrete product B of a family 2 </summary>
  TProductB2 = class(TInterfacedObject, IProductB)
    procedure StuffB();
  end;
  /// <summary> Concrete factory that creates products of family 2 </summary>
  TFactory2 = class(TInterfacedObject, IAbstractFactory)
    function CreateProductA(): IProductA;
    function CreateProductB(): IProductB;
  end;

{ TClient }

procedure TClient.CreateProducts(const AFactory: IAbstractFactory);
begin
  AFactory.CreateProductA().StuffA;
  AFactory.CreateProductB().StuffB;
end;

{ TProductA1 }

procedure TProductA1.StuffA;
begin
  Writeln('StuffA1');
end;

{ TProductB1 }

procedure TProductB1.StuffB;
begin
  Writeln('StuffB1');
end;

{ TFactory1 }

function TFactory1.CreateProductA: IProductA;
begin
  Result := TProductA1.Create();
end;

function TFactory1.CreateProductB: IProductB;
begin
  Result := TProductB1.Create();
end;

{ TProductA2 }

procedure TProductA2.StuffA;
begin
  Writeln('StuffA2');
end;

{ TProductB2 }

procedure TProductB2.StuffB;
begin
  Writeln('StuffB2');
end;

{ TFactory2 }

function TFactory2.CreateProductA: IProductA;
begin
  Result := TProductA2.Create();
end;

function TFactory2.CreateProductB: IProductB;
begin
  Result := TProductB2.Create();
end;

{$ENDREGION}

begin
  try
    var client := TClient.Create();
    try
      var factory1 := TFactory1.Create() as IAbstractFactory;
      var factory2 := TFactory2.Create() as IAbstractFactory;

      client.CreateProducts(factory1);
      client.CreateProducts(factory2);
    finally
      client.Free();
    end;
    Sleep(5000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
