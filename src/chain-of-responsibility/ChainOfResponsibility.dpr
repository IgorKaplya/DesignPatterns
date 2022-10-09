{
  Chain of Responsibility is behavioral design pattern that allows passing request along the chain of potential handlers.
}
program ChainOfResponsibility;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type

  /// <summary> Some request that will be passed along the chain </summary>
  IRequest = interface(IInterface)
  end;

  /// <summary> Handler for a request </summary>
  IHandler = interface
    procedure SetNext(const AHandler: IHandler);
    procedure Handle(const ARequest: IRequest);
  end;

  /// <summary> Production code that forms and invokes the chain. </summary>
  IClient = interface
    procedure Stuff(const ARequest: IRequest);
  end;

  {$REGION 'Implementation'}
  TClient = class(TInterfacedObject, IClient)
  public
    procedure Stuff(const ARequest: IRequest);
  end;

  TRequest = class(TInterfacedObject, IRequest)
  end;

  TBaseHandler = class(TInterfacedObject, IHandler)
  private
    FNext: IHandler;
  public
    procedure Handle(const ARequest: IRequest); virtual;
    procedure SetNext(const AHandler: IHandler);
  end;

  THandlerA = class(TBaseHandler)
  public
    procedure Handle(const ARequest: IRequest); override;
  end;

  THandlerB = class(TBaseHandler)
  public
    procedure Handle(const ARequest: IRequest); override;
  end;

  THandlerC = class(TBaseHandler)
  public
    procedure Handle(const ARequest: IRequest); override;
  end;

{ THandlerC }

procedure THandlerC.Handle(const ARequest: IRequest);
begin
  WriteLn('THandlerC.Handle');
  inherited;
end;

{ THandlerB }

procedure THandlerB.Handle(const ARequest: IRequest);
begin
  WriteLn('THandlerB.Handle');
  inherited;
end;

{ THandlerA }

procedure THandlerA.Handle(const ARequest: IRequest);
begin
  WriteLn('THandlerA.Handle');
  inherited;
end;

{ TBaseHandler }

procedure TBaseHandler.Handle(const ARequest: IRequest);
begin
  if Assigned(FNext) then
    FNext.Handle(ARequest);
end;

procedure TBaseHandler.SetNext(const AHandler: IHandler);
begin
  FNext := AHandler;
end;

{ TClient }

procedure TClient.Stuff(const ARequest: IRequest);
begin
  var handlerA := THandlerA.Create() as IHandler;  
  var handlerB := THandlerB.Create() as IHandler;
  var handlerC := THandlerC.Create() as IHandler;

  handlerA.SetNext(handlerB);
  handlerB.SetNext(handlerC);

  handlerA.Handle(ARequest);
end;
  {$ENDREGION}

begin
  try
    var client := TClient.Create() as IClient;
    var request := TRequest.Create() as IRequest;

    client.Stuff(request);
    
    Sleep(5000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
