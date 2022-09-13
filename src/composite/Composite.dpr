{
  Composite is a structural design pattern that lets you compose objects into tree structures
  and then work with these structures as if they were individual objects.
}
program Composite;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type

  /// <summary> Lean object that does some logic.</summary>
  IComponent = interface
    procedure ComponentStuff();
  end;

  /// <summary> A containter that composites a collection of IComponent as a single IComponent. </summary>
  IComposite = interface(IComponent)
    function GetChildren(): TArray<IComponent>;
    procedure Add(const AItem: IComponent);
    // remove() should be here, but omitted for simplicity.
  end;

  /// <summary> Production code that doesn`t care how complex component really is.</summary>
  IClient = interface
    procedure Stuff(AComponent: IComponent);
  end;

{$REGION 'Implementations'}
  TSimpleComponent = class(TInterfacedObject, IComponent)
  private
    FName: string;
  public
    constructor Create(const AName: string);
    procedure ComponentStuff;
  end;

  TComplexComponent = class(TInterfacedObject, IComposite)
  private
    FChildren: TArray<IComponent>;
    FName: string;
  public
    constructor Create(const AName: string);
    procedure ComponentStuff;
    procedure Add(const AItem: IComponent);
    function GetChildren: TArray<IComponent>;
  end;

  TClient = class(TInterfacedObject, IClient)
  public
    procedure Stuff(AComponent: IComponent);
  end;

constructor TSimpleComponent.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
end;

{ TSimpleComponent }

procedure TSimpleComponent.ComponentStuff;
begin
  Writeln(FName);
end;

constructor TComplexComponent.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
end;

{ TComplexComponent }

procedure TComplexComponent.Add(const AItem: IComponent);
begin
  FChildren := FChildren + [AItem];
end;

procedure TComplexComponent.ComponentStuff;
begin
  Writeln(String.Format('%s children count: %d.', [FName, Length(FChildren)]));
  for var item in FChildren do
    item.ComponentStuff();
end;

function TComplexComponent.GetChildren: TArray<IComponent>;
begin
  Result := FChildren;
end;

{ TClient }

procedure TClient.Stuff(AComponent: IComponent);
begin
  AComponent.ComponentStuff;
end;

{$ENDREGION}

begin
  try
    var client := TClient.Create() as IClient;
    var tree := TComplexComponent.Create('tree') as IComposite;
    var branch := TComplexComponent.Create('branch') as IComposite;
    var leaf1 := TSimpleComponent.Create('leaf on a tree') as IComponent;
    var leaf2 := TSimpleComponent.Create('leaf1 on a branch') as IComponent;
    var leaf3 := TSimpleComponent.Create('leaf2 on a branch') as IComponent;

    tree.Add(leaf1);
    branch.Add(leaf2);
    branch.Add(leaf3);
    tree.Add(branch);

    client.Stuff(tree);
    Writeln('');
    client.Stuff(leaf1);
    Writeln('');
    client.Stuff(branch);

    Sleep(5000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
