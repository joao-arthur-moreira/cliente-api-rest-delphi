unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.JSON, REST.Client, IPPeerClient, REST.Types, Datasnap.DBClient,
  Data.DB, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Authenticator.Basic,
  Vcl.ExtCtrls, System.Classes;

type
  TfrmPrincipal = class(TForm)
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
    edtNomeColetor: TLabeledEdit;
    btnCriarRecurso: TButton;
    edtCodigo: TLabeledEdit;
    btnAtualizarRecurso: TButton;
    edtNomeAtualzar: TLabeledEdit;
    Memo1: TMemo;
    Button1: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure btnCriarRecursoClick(Sender: TObject);
    procedure btnAtualizarRecursoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }

    // Objetos necessário para a comunicação com a API
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;

    // Objeto para receber o JSON de retorno
    FJSON: TJSONObject;

    procedure InicializarObjetos(metodo: TRESTRequestMethod);
    procedure EnviarRequisicao;
    procedure LiberarObjetos;
    function ConsultarDadosApiDrIndustrial: olevariant;
    function ProcessarRetorno: olevariant;
    procedure persistirLista;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation


{$R *.dfm}

{ TForm1 }

procedure TfrmPrincipal.BitBtn1Click(Sender: TObject);
begin
  ClientDataSet.Data := ConsultarDadosApiDrIndustrial;
end;

procedure TfrmPrincipal.btnAtualizarRecursoClick(Sender: TObject);
var
  jsObj: TJSONObject;
begin
  InicializarObjetos(rmPUT);

  jsObj := TJSONObject.Create();

  jsObj.AddPair('codigo', edtCodigo.Text);
  jsObj.AddPair('nome', edtNomeAtualzar.Text);

  FRESTRequest.AddBody(jsObj);

  EnviarRequisicao;

  LiberarObjetos;
  jsObj.Free;
end;

procedure TfrmPrincipal.btnCriarRecursoClick(Sender: TObject);
var
  jsObj: TJSONObject;
begin
  InicializarObjetos(rmPOST);

  jsObj := TJSONObject.Create();
  jsObj.AddPair('nome', edtNomeColetor.Text);
  FRESTRequest.AddBody(jsObj);


  EnviarRequisicao;

  LiberarObjetos;
  jsObj.Free;
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  persistirLista;
end;

function TfrmPrincipal.ConsultarDadosApiDrIndustrial: olevariant;
begin
  InicializarObjetos(rmGET);
  EnviarRequisicao;
  result := ProcessarRetorno;
  LiberarObjetos;
end;

procedure TfrmPrincipal.EnviarRequisicao;
var
  statusHttp: Integer;
  JSONValue: TJSONValue;
  JSONObject: TJSONObject;
begin
  FRESTRequest.Resource := 'coletores';
  // Executa a requisição
  try
    Memo1.Lines.Clear;
    FRESTRequest.Execute;
    statusHttp := FRESTResponse.StatusCode;
    if (statusHttp >= 400) and (statusHttp < 500) then
    begin
      ShowMessage('Requisição inválida!');
      for JSONValue in FRESTResponse.JSONValue as TJSONArray do
      begin
        JSONObject := JSONValue as TJSONObject;
        Memo1.Lines.Add(JSONObject.GetValue('mensagemUsuario').Value);
      end;
    end;
    //Memo1.Lines.Add(FRESTResponse.Content);
  except

  end;
  Memo1.Lines.Add(Format('HTTP-Status: %d', [FRESTResponse.StatusCode]));

  //Memo1.Lines := FRESTResponse.Headers;

  // Só pra mostrar a URL
  FRESTRequest.GetFullRequestURL();
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  ObjPrincipal, ObjSecundario: TJSONObject;
begin
  // Teste encadeando objetos JSON
  ObjPrincipal := TJSONObject.Create;
  try
    ObjSecundario := TJSONObject.Create;
    ObjSecundario.AddPair('material', '01.02.0001');
    ObjSecundario.AddPair('filial', 'DR');
    ObjSecundario.AddPair('cor', '999');
    ObjPrincipal.AddPair('codigo', ObjSecundario);

    objPrincipal.AddPair('nome', 'Teste');
    objPrincipal.AddPair('data', '01012017');

    Memo1.Lines.Add(ObjPrincipal.ToJSON);
  finally
    ObjPrincipal.Free;
  end;
end;

procedure TfrmPrincipal.InicializarObjetos(metodo: TRESTRequestMethod);
begin
  FRESTClient := TRESTClient.Create('localhost:8080/');

  FRESTClient.Authenticator := HTTPBasicAuthenticator;

  // Cria o objeto da classe TRESTResponse
  FRESTResponse := TRESTResponse.Create(nil);

  // Cria e configura o objeto da classe TRESTRequest
  FRESTRequest := TRESTRequest.Create(nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;

  //FREstResponse.TStatus;

  FRESTRequest.Method := metodo;

  // Cria o objeto para manipular o JSON
  FJSON := TJSONObject.Create;
end;

procedure TfrmPrincipal.LiberarObjetos;
begin
  FRESTRequest.Free;
  FRESTResponse.Free;
  FRESTClient.Free;
end;

procedure TfrmPrincipal.persistirLista;
var
  jsLista: TJSONArray;
  jsObj: TJSONObject;
  jsObjRe: TJSONObject;
  i,x: Integer;
begin
  InicializarObjetos(rmPOST);
  i := 5;

  jsLista := TJSONArray.Create;

  for x := 0 to i do
  begin
    jsObj := TJSONObject.Create();
    jsObj.AddPair('nome', 'Nome ' + IntToStr(x));

    jsLista.AddElement(jsObj);
  end;

  jsObjRe := TJSONObject.Create();
  jsObjRe.AddPair('coletores',jsLista);

  FRESTRequest.AddBody(jsObjRe);

  EnviarRequisicao;

  //Memo1.Lines.Add(jsLista.ToJSON);

  LiberarObjetos;
  if jsObj <> Nil then
   jsObj.Free;
  if jsLista <> Nil then
    jsLista.Free;
  if jsObjRe <> Nil then
    jsObjRe.Free;
end;

function TfrmPrincipal.ProcessarRetorno: olevariant;
var
  DataSetRetorno: TClientDataSet;
  JSONValue: TJSONValue;
  JSONObject: TJSONObject;
begin
  DataSetRetorno := TClientDataSet.Create(nil);
  try
    // Define as colunas
    DataSetRetorno.FieldDefs.Add('codigo', Data.DB.ftInteger);
    DataSetRetorno.FieldDefs.Add('nome', Data.DB.ftString, 40);
    DataSetRetorno.CreateDataSet;

    // Percorre o JSON, lendo os valores das chaves
    for JSONValue in FRESTResponse.JSONValue as TJSONArray do
    begin
      JSONObject := JSONValue as TJSONObject;

      DataSetRetorno.AppendRecord([
        JSONObject.GetValue('codigo').Value,
        JSONObject.GetValue('nome').Value
      ]);
    end;

    result := DataSetRetorno.Data;
  finally
    DataSetRetorno.Free;
  end;
end;

end.
