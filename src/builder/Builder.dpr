{
  Builder is a creational design pattern that lets you construct complex objects step by step.
  The pattern allows you to produce different types and representations of an object using the same
  construction code.
}
program Builder;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  /// <summary> Complex object </summary>
  IProduct = interface
    procedure DoStuff();
  end;

  /// <summary> Builder </summary>
  IBuilder = interface
    procedure StepA();
    procedure StepB();
    procedure StepC();
    function Build(): IProduct;
  end;

  /// <summary>  Defines the order in which to call construction steps </summary>
  TDirector = reference to procedure(const Arg1: IBuilder);

{$REGION 'Implementations'}

  TProduct = class(TInterfacedObject, IProduct)
    procedure DoStuff();
  end;

  TBuilder = class(TInterfacedObject, IBuilder)
    procedure StepA();
    procedure StepB();
    procedure StepC();
    function Build(): IProduct;
  end;

  TClient = class
    procedure DoSomeDtuff(const ABuilder: IBuilder; ADirector: TDirector);
  end;

{ TProduct }

procedure TProduct.DoStuff;
begin
  Writeln('Stuff');
end;


{ TBuilder }

function TBuilder.Build: IProduct;
begin
  Result := TProduct.Create();
end;

procedure TBuilder.StepA;
begin
  Writeln('StepA');
end;

procedure TBuilder.StepB;
begin
  Writeln('StepB');
end;

procedure TBuilder.StepC;
begin
  Writeln('StepC');
end;

{ TClient }

procedure TClient.DoSomeDtuff(const ABuilder: IBuilder; ADirector: TDirector);
begin
  ADirector(ABuilder);
  ABuilder.Build.DoStuff();
end;

{$ENDREGION}

begin
  try
    var client := TClient.Create();
    try
      var _builder := TBuilder.Create() as IBuilder;

      client.DoSomeDtuff(_builder, procedure(const ABuilder: IBuilder)
      begin
        _builder.StepA;
        _builder.StepB;
        _builder.StepC;
      end);

    finally
      client.Free;
    end;

    Sleep(5000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
