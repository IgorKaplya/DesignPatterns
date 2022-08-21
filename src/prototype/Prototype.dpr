{
  Prototype is a creational design pattern that lets you copy existing objects without making your code dependent on their classes.
}
program Prototype;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type

  /// <summary> Makes a copy of an object </summary>
  IPrototype<T> = interface
    function Clone(): T;
  end;

  /// <summary> Object to copy </summary>
  IProduct = interface
    procedure DoStuff();
  end;

  TProduct = class(TInterfacedObject, IProduct, IPrototype<IProduct>)
  private
    FPrivateField: string;
  public
    function Clone(): IProduct;
    procedure DoStuff(); virtual; abstract;
  end;

  TProductA = class(TProduct)
    procedure DoStuff(); override;
  end;

  TProductB = class(TProduct)
    procedure DoStuff(); override;
  end;

  TClient = class
    procedure DoSomeStuff(const APrototype: IPrototype<IProduct>);
  end;

{ TProduct }

function TProduct.Clone: IProduct;
begin
  var clonedObject := Self.ClassType.Create() as TProduct;
  clonedObject.FPrivateField := 'Clone of ' + Self.ClassName;
  Result := clonedObject;
end;

{ TClient }

procedure TClient.DoSomeStuff(const APrototype: IPrototype<IProduct>);
begin
  APrototype.Clone.DoStuff();
end;

{ TProductA }

procedure TProductA.DoStuff;
begin
  WriteLn(FPrivateField + ' stuff A');
end;

{ TProductB }

procedure TProductB.DoStuff;
begin
  WriteLn(FPrivateField + ' stuff B');
end;

begin
  try
    var client := TClient.Create();
    try
      var prototype1 := TProductA.Create();
      var prototype2 := TProductB.Create();

      client.DoSomeStuff(prototype1);
      client.DoSomeStuff(prototype2);
    finally
      client.Free;
    end;

    Sleep(5000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
