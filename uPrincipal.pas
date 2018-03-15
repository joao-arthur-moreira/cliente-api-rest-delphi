unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.JSON, REST.Client, IPPeerClient, REST.Types, Datasnap.DBClient,
  Data.DB, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Authenticator.Basic,
  Vcl.ExtCtrls;

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
    procedure BitBtn1Click(Sender: TObject);
    procedure btnCriarRecursoClick(Sender: TObject);
    procedure btnAtualizarRecursoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

function TfrmPrincipal.ConsultarDadosApiDrIndustrial: olevariant;
begin
  InicializarObjetos(rmGET);
  EnviarRequisicao;
  result := ProcessarRetorno;
  LiberarObjetos;
end;

procedure TfrmPrincipal.EnviarRequisicao;
begin
  FRESTRequest.Resource := 'coletores';

  // Executa a requisição
  FRESTRequest.Execute;

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
