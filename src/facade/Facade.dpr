{
  Facade is a structural design pattern that provides a simplified interface to a library,
  a framework, or any other complex set of classes.
}
program Facade;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type

  /// <summary> A facade interface that will hide subsystems from client </summary>
  IFacade = interface
    procedure FacadeStuff();
  end;

  /// <summary> Subsystem to hide </summary>
  ISubsystem1 = interface
    procedure SubSystem1Stuff();
  end;

  /// <summary> Subsystem to hide </summary>
  ISubsystem2 = interface
    procedure SubSystem2Stuff();
  end;

  /// <summary> Producion code, where we'd like to apply a design pattern </summary>
  IClient = interface
    procedure Stuff(const AFacade: IFacade);
  end;

  {$REGION 'implenetation'}
  TClient = class(TInterfacedObject, IClient)
  public
    procedure Stuff(const AFacade: IFacade);
  end;

  TSubSystem1 = class(TInterfacedObject, ISubsystem1)
  public
    procedure SubSystem1Stuff;
  end;

  TSubSystem2 = class(TInterfacedObject, ISubsystem2)
  public
    procedure SubSystem2Stuff;
  end;

  TFacade = class(TInterfacedObject, IFacade)
  private
    FSubSystem1: ISubsystem1;
    FSubSystem2: ISubsystem2;
    property SubSystem1: ISubsystem1 read FSubSystem1;
    property SubSystem2: ISubsystem2 read FSubSystem2;
  public
    constructor Create(ASubSystem1: ISubsystem1; ASubSystem2: ISubsystem2);
    procedure FacadeStuff;
  end;

procedure TClient.Stuff(const AFacade: IFacade);
begin
  AFacade.FacadeStuff();
end;

constructor TFacade.Create(ASubSystem1: ISubsystem1; ASubSystem2: ISubsystem2);
begin
  inherited Create;
  FSubSystem1 := ASubSystem1;
  FSubSystem2 := ASubSystem2;
end;

procedure TFacade.FacadeStuff;
begin
  SubSystem1.SubSystem1Stuff;
  SubSystem2.SubSystem2Stuff;
end;

procedure TSubSystem1.SubSystem1Stuff;
begin
  Writeln('TSubSystem1.SubSystem1Stuff');
end;

procedure TSubSystem2.SubSystem2Stuff;
begin
  Writeln('TSubSystem2.SubSystem2Stuff');
end;
  {$ENDREGION}

begin
  try
    var client := TClient.Create() as IClient;
    var subsystem1 := TSubSystem1.Create() as ISubSystem1;
    var subsystem2 := TSubSystem2.Create() as ISubSystem2;
    var facade_ := TFacade.Create(subsystem1, subsystem2) as IFacade;

    client.Stuff(facade_);

    Sleep(5000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
