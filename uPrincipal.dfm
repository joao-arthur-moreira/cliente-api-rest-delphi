object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Consulta API Rest DR-Industrial'
  ClientHeight = 524
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 6
    Top = 28
    Width = 473
    Height = 171
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object BitBtn1: TBitBtn
    Left = 6
    Top = 1
    Width = 121
    Height = 25
    Caption = 'Consultar API'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object edtNomeColetor: TLabeledEdit
    Left = 7
    Top = 224
    Width = 177
    Height = 21
    EditLabel.Width = 67
    EditLabel.Height = 13
    EditLabel.Caption = 'Nome coletor:'
    TabOrder = 2
  end
  object btnCriarRecurso: TButton
    Left = 200
    Top = 222
    Width = 169
    Height = 25
    Caption = 'Criar recurso na API'
    TabOrder = 3
    OnClick = btnCriarRecursoClick
  end
  object edtCodigo: TLabeledEdit
    Left = 7
    Top = 272
    Width = 66
    Height = 21
    EditLabel.Width = 37
    EditLabel.Height = 13
    EditLabel.Caption = 'C'#243'digo:'
    TabOrder = 4
  end
  object btnAtualizarRecurso: TButton
    Left = 200
    Top = 294
    Width = 169
    Height = 25
    Caption = 'Atualizar recurso na API'
    TabOrder = 5
    OnClick = btnAtualizarRecursoClick
  end
  object edtNomeAtualzar: TLabeledEdit
    Left = 7
    Top = 309
    Width = 177
    Height = 21
    EditLabel.Width = 67
    EditLabel.Height = 13
    EditLabel.Caption = 'Nome coletor:'
    TabOrder = 6
  end
  object Memo1: TMemo
    Left = 8
    Top = 368
    Width = 470
    Height = 148
    TabOrder = 7
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 256
    Top = 128
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 312
    Top = 128
  end
  object HTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'ti3'
    Password = 'adm1981'
    Left = 320
    Top = 8
  end
end
