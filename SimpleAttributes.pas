unit SimpleAttributes;

interface

uses
  System.RTTI, System.Variants, System.Classes;

type
  TJoin = (InnerJoin, LeftJoin, RightJoin, FullJoin);

  Tabela = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(aName: string);
    property Name: string read FName;
  end;

  Campo = class(TCustomAttribute)
  private
    FName: string;
  public
    Constructor Create(aName: string);
    property Name: string read FName;
  end;

  PK = class(TCustomAttribute)
  end;

  FK = class(TCustomAttribute)
  private
    FColumnName: string;
    FRefTableName: string;
    FRefColumnName: string;
    FRefColumnNameSelect: String;
    FJoin: TJoin;
    FAlias: string;
  public
    constructor Create(AColumnName, ARefTableName, ARefColumnName,
      ARefColumnNameSelect: String; AJoin: TJoin = InnerJoin; AAlias: string = '');

    property ColumnName: string read FColumnName;
    property RefColumnName: string read FRefColumnName;
    property RefTableName: string read FRefTableName;
    property RefColumnNameSelect: string read FRefColumnNameSelect;
    property Join: TJoin read FJoin;
    property Alias: string read FAlias;
  end;

  Ignore = class(TCustomAttribute)
  end;

  AutoInc = class(TCustomAttribute)
  end;

  Bind = class(TCustomAttribute)
  private
    FField: String;
    procedure SetField(const Value: String);
  public
    constructor Create (aField : String);
  published
    property Field : String read FField write SetField;
  end;

implementation


{ Bind }

constructor Bind.Create(aField: String);
begin
  FField := aField;
end;

procedure Bind.SetField(const Value: String);
begin
  FField := Value;
end;

{ Tabela }

constructor Tabela.Create(aName: string);
begin
  FName := aName;
end;

{ Campo }

constructor Campo.Create(aName: string);
begin
  FName := aName;
end;

{ FK }

constructor FK.Create(AColumnName, ARefTableName, ARefColumnName,
  ARefColumnNameSelect: String; AJoin: TJoin = InnerJoin; AAlias: string = '');
begin
  FColumnName := AColumnName;
  FRefTableName := ARefTableName;
  FRefColumnName := ARefColumnName;
  FRefColumnNameSelect := ARefColumnNameSelect;
  FJoin := AJoin;
  FAlias := AAlias;
end;

end.
