{
  Flyweight is a structural design pattern that lets you fit more objects into the available amount of RAM
  by sharing common parts of state between multiple objects instead of keeping all of the data in each object.
}
program Flyweight;

{$APPTYPE CONSOLE}

{$R *.res}

uses
   System.SysUtils
  ,System.Generics.Collections
  ;

type

  /// <summary> Some abstraction that has a repeating and unique parts </summary>
  IContext = interface
    procedure ContextStuff();
  end;

  /// <summary> An abstraction that holds repeating state of the context. </summary>
  IFlyweight = interface
  end;

  /// <summary> A manager for flyweight objects. Doesn`t create a new one if already contains the same. </summary>
  IFlyweightFactory = interface
    function GetFlyweight(const ARepeatingState: string): IFlyweight;
    /// <summary> Count is not required: just to see the state of the cache </summary>
    function Count(): integer;
  end;

  /// <summary> Production code that uses IContext.</summary>
  IClient = interface
    procedure Stuff(const AContext: IContext);
  end;

{$REGION 'Implementation'}

  TFlyweight = class(TInterfacedObject, IFlyweight)
  end;

  TFlyweightFactory = class(TInterfacedObject, IFlyweightFactory)
  private
    FCache: TDictionary<string, IFlyweight>;
  public
    constructor Create;
    destructor Destroy; override;
    function Count: integer;
    function GetFlyweight(const ARepeatingState: string): IFlyweight;
    property Cache: TDictionary<string, IFlyweight> read FCache;
  end;

  TContext = class(TInterfacedObject, IContext)
  private
    FFlyweight: IFlyweight;
    FFlyweightFacroty: IFlyweightFactory;
    FUniqueState: string;
    property FlyweightFacroty: IFlyweightFactory read FFlyweightFacroty;
  public
    constructor Create(AFlyweightFacroty: IFlyweightFactory; const ARepeatingState: string);
    destructor Destroy; override;
    procedure ContextStuff;
    property Flyweight: IFlyweight read FFlyweight;
    property UniqueState: string read FUniqueState;
  end;

  TClient = class(TInterfacedObject, IClient)
    procedure Stuff(const AContext: IContext);
  end;

constructor TFlyweightFactory.Create;
begin
  inherited Create;
  FCache := TDictionary<string, IFlyweight>.Create();
end;

destructor TFlyweightFactory.Destroy;
begin
  FCache.Free;
  inherited Destroy;
end;

function TFlyweightFactory.Count: integer;
begin
  Result := Cache.Count;
end;

{ TFlyweightFactory }

function TFlyweightFactory.GetFlyweight(const ARepeatingState: string): IFlyweight;
begin
  if not Cache.ContainsKey(ARepeatingState) then
    Cache.Add(ARepeatingState, TFlyweight.Create());
  Result := Cache[ARepeatingState];
end;

constructor TContext.Create(AFlyweightFacroty: IFlyweightFactory; const ARepeatingState: string);
begin
  inherited Create;
  FFlyweightFacroty := AFlyweightFacroty;
  FUniqueState := string.Format('%p', [Pointer(self)]);
  FFlyweight := FlyweightFacroty.GetFlyweight(ARepeatingState);
end;

destructor TContext.Destroy;
begin
  FFlyweightFacroty := nil;
  inherited Destroy;
end;

procedure TContext.ContextStuff;
begin
  Writeln(string.Format('Context %s uses a flyweight [%p] for the contextStuff()', [UniqueState, Pointer(Flyweight)]));
end;

{ TClient }

procedure TClient.Stuff(const AContext: IContext);
begin
  AContext.ContextStuff();
end;

{$ENDREGION}

var
  client: IClient;
  flywieghtFactory: IFlyweightFactory;
  contexts: TArray<IContext>;
begin
  try
    flywieghtFactory := TFlyweightFactory.Create();

    contexts := [
       TContext.Create(flywieghtFactory, 'RepeatingA')
      ,TContext.Create(flywieghtFactory, 'RepeatingA')
      ,TContext.Create(flywieghtFactory, 'RepeatingB')
      ,TContext.Create(flywieghtFactory, 'RepeatingB')
      ,TContext.Create(flywieghtFactory, 'RepeatingC')
    ];

    client := TClient.Create();
    for var ctx in contexts do
      client.Stuff(ctx);

    Writeln(string.Format('Application has %d contexts and %d flyweights.', [Length(contexts), flywieghtFactory.Count()]))
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Sleep(10000);
end.
