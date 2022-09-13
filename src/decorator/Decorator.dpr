{
  Decorator is a structural pattern that allows adding new behaviors to objects dynamically by placing them inside special wrapper
  objects, called decorators.
}
program Decorator;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type

  /// <summary> A bare component that may be extended with decorators.</summary>
  IComponent = interface
    procedure ComponentStuff();
  end;

  /// <summary> This class descendants will act as clothes for IComponent/TDecorator adding logical layers.</summary>
  TDecorator = class(TInterfacedObject, IComponent)
  public
    constructor Create(const Wrapee: IComponent); virtual; abstract;
    procedure ComponentStuff; virtual; abstract;
  end;

  /// <summary> Some production code that accepts an IComponent.</summary>
  IClient = interface
    procedure Stuff(const AComponent: IComponent);
  end;

  {$REGION 'Implementation'}
  TComponent = class(TInterfacedObject, IComponent)
  public
    procedure ComponentStuff;
  end;

  TDecoratorA = class(TDecorator)
  private
    FWrapee: IComponent;
  public
    procedure ComponentStuff; override;
    constructor Create(const Wrapee: IComponent); override;
  end;

  TDecoratorB = class(TDecorator)
  private
    FWrapee: IComponent;
  public
    procedure ComponentStuff; override;
    constructor Create(const Wrapee: IComponent); override;
  end;

  TClient = class(TInterfacedObject, IClient)
  public
    procedure Stuff(const AComponent: IComponent);
  end;

{ TComponent }

procedure TComponent.ComponentStuff;
begin
  Writeln('TComponent.ComponentStuff');
end;

{ TDecoratorA }

procedure TDecoratorA.ComponentStuff;
begin
  Writeln('TDecoratorA.ComponentStuff');
  FWrapee.ComponentStuff();
end;

constructor TDecoratorA.Create(const Wrapee: IComponent);
begin
  FWrapee := Wrapee;
end;

{ TDecoratorB }

procedure TDecoratorB.ComponentStuff;
begin
  Writeln('TDecoratorB.ComponentStuff');
  FWrapee.ComponentStuff();
end;

constructor TDecoratorB.Create(const Wrapee: IComponent);
begin
  FWrapee := Wrapee;
end;

{ TClient }

procedure TClient.Stuff(const AComponent: IComponent);
begin
  AComponent.ComponentStuff;
end;
  {$ENDREGION}

begin
  try
    var client := TClient.Create() as IClient;
    var component := TComponent.Create() as IComponent;
    var decoratorA := TDecoratorA.Create(component);
    var decoratorB := TDecoratorB.Create(decoratorA);

    client.Stuff(component);
    Writeln('');

    client.Stuff(decoratorA);
    Writeln('');

    client.Stuff(decoratorB);
    Writeln('');

    Sleep(10000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
