unit SimpleSQL;

interface

uses
  SimpleInterface;

Type
  TSimpleSQL<T : class, constructor> = class(TInterfacedObject, iSimpleSQL<T>)
    private
      FInstance : T;
      FFields : String;
      FWhere : String;
      FOrderBy : String;
      FGroupBy : String;
      FJoin : String;
      FLimitPagePosition : TSimpleDAOLimitPagePosition;
      FLimitPageSQL : String;
    public
      constructor Create(aInstance : T);
      destructor Destroy; override;
      class function New(aInstance : T) : iSimpleSQL<T>;
      function Insert (var aSQL : String) : iSimpleSQL<T>;
      function Update (var aSQL : String) : iSimpleSQL<T>;
      function Delete (var aSQL : String) : iSimpleSQL<T>;
      function Select (var aSQL : String) : iSimpleSQL<T>;
      function SelectId(var aSQL: String): iSimpleSQL<T>;
      function Fields (aSQL : String) : iSimpleSQL<T>;
      function Where (aSQL : String) : iSimpleSQL<T>;
      function OrderBy (aSQL : String) : iSimpleSQL<T>;
      function GroupBy (aSQL : String) : iSimpleSQL<T>;
      function Join (aSQL : String) : iSimpleSQL<T>;
      function LimitPagePosition(AValue : TSimpleDAOLimitPagePosition): iSimpleSQL<T>;
      function LimitPageSQL(aSQL : String) : iSimpleSQL<T>;
      function &End : iSimpleSQL<T>;
  end;

implementation

uses
  System.SysUtils,
  SimpleRTTI, System.Generics.Collections;

{ TSimpleSQL<T> }

constructor TSimpleSQL<T>.Create(aInstance : T);
begin
  FInstance := aInstance;
end;

function TSimpleSQL<T>.Delete(var aSQL: String): iSimpleSQL<T>;
var
  aClassName, aWhere : String;
begin
  Result := Self;

  TSimpleRTTI<T>.New(FInstance)
    .TableName(aClassName)
    .Where(aWhere);

  aSQL := aSQL + 'DELETE FROM ' + aClassName;
  aSQL := aSQL + ' WHERE ' + aWhere;

end;

destructor TSimpleSQL<T>.Destroy;
begin

  inherited;
end;

function TSimpleSQL<T>.Fields(aSQL: String): iSimpleSQL<T>;
begin
  Result := Self;
  FFields := aSQL;
end;

function TSimpleSQL<T>.GroupBy(aSQL: String): iSimpleSQL<T>;
begin
  Result := Self;
  FGroupBy := aSQL;
end;

function TSimpleSQL<T>.Insert(var aSQL: String): iSimpleSQL<T>;
var
  aClassName, aFields, aParam : String;
begin
  Result := Self;

    TSimpleRTTI<T>.New(FInstance)
      .TableName(aClassName)
      .FieldsInsert(aFields)
      .Param(aParam);

    aSQL := aSQL + 'INSERT INTO ' + aClassName;
    aSQL := aSQL + ' (' + aFields + ') ';
    aSQL := aSQL + ' VALUES (' + aParam + ');';
end;

function TSimpleSQL<T>.Join(aSQL: String): iSimpleSQL<T>;
begin
  Result := Self;
  FJoin := aSQL;
end;

class function TSimpleSQL<T>.New(aInstance : T): iSimpleSQL<T>;
begin
  Result := Self.Create(aInstance);
end;

function TSimpleSQL<T>.OrderBy(aSQL: String): iSimpleSQL<T>;
begin
  Result := Self;
  FOrderBy := aSQL;
end;

function TSimpleSQL<T>.Select (var aSQL : String) : iSimpleSQL<T>;
var
  aFields, aJoins, aClassName : String;
begin
  Result := Self;

  TSimpleRTTI<T>.New(nil)
    .Fields(aFields)
    .Joins(aJoins)
    .TableName(aClassName);

  if length(trim(FFields)) <> 0 then
    aSQL := aSQL + ' SELECT ' + FFields
  else
    aSQL := aSQL + ' SELECT ' + aFields;

  aSQL := aSQL + ' FROM ' + aClassName;

  if length(trim(FJoin)) <> 0 then
    aSQL := aSQL + ' ' + FJoin + ' '
  else
    aSQL := aSQL + ' ' + aJoins + ' ';

  if length(trim(FWhere)) <> 0 then
    aSQL := aSQL + ' WHERE ' + FWhere;

  if length(trim(FGroupBy)) <> 0 then
    aSQL := aSQL + ' GROUP BY ' + FGroupBy;

  if length(trim(FOrderBy)) <> 0 then
    aSQL := aSQL + ' ORDER BY ' + FOrderBy;

  if (length(trim(FLimitPageSQL)) <> 0) and (FLimitPagePosition = lpBottom) then
    aSQL := aSQL + ' ' + FLimitPageSQL;
end;

function TSimpleSQL<T>.SelectId(var aSQL: String): iSimpleSQL<T>;
var
  aFields, aClassName, aWhere : String;
begin
  Result := Self;

  TSimpleRTTI<T>.New(FInstance)
    .Fields(aFields)
    .TableName(aClassName)
    .Where(aWhere);

  if length(trim(FWhere)) <> 0 then
    aSQL := aSQL + ' WHERE ' + FWhere;

  aSQL := aSQL + ' SELECT ' + aFields;
  aSQL := aSQL + ' FROM ' + aClassName;
  aSQL := aSQL + ' WHERE ' + aWhere;
end;

function TSimpleSQL<T>.Update(var aSQL: String): iSimpleSQL<T>;
var
  ClassName, aUpdate, aWhere : String;
begin
  Result := Self;

  TSimpleRTTI<T>.New(FInstance)
    .TableName(ClassName)
    .Update(aUpdate)
    .Where(aWhere);

  aSQL := aSQL + 'UPDATE ' + ClassName;
  aSQL := aSQL + ' SET ' + aUpdate;
  aSQL := aSQL + ' WHERE ' + aWhere;

end;

function TSimpleSQL<T>.Where(aSQL: String): iSimpleSQL<T>;
begin
  Result := Self;
  FWhere := aSQL;
end;

function TSimpleSQL<T>.LimitPagePosition(AValue: TSimpleDAOLimitPagePosition): iSimpleSQL<T>;
begin
  Result := Self;
  FLimitPagePosition := AValue;
end;

function TSimpleSQL<T>.LimitPageSQL(aSQL: String): iSimpleSQL<T>;
begin
  Result := Self;
  FLimitPageSQL := aSQL;
end;

function TSimpleSQL<T>.&End: iSimpleSQL<T>;
begin
  Result := Self;
end;

end.
