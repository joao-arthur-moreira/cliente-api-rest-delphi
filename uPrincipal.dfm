object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Consulta API Rest DR-Industrial'
  ClientHeight = 243
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 24
    Top = 64
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
    Left = 24
    Top = 16
    Width = 121
    Height = 25
    Caption = 'Consultar API'
    TabOrder = 1
    OnClick = BitBtn1Click
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
    Username = 'usuario'
    Password = 'senha'
    Left = 320
    Top = 8
  end
end
