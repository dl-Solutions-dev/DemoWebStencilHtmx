object DMSession: TDMSession
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 1920
  Width = 2560
  PixelsPerInch = 192
  object CnxExport: TFDConnection
    Params.Strings = (
      'ConnectionDef=EXPORT_SQL')
    Connected = True
    LoginPrompt = False
    Left = 231
    Top = 59
  end
  object QryUsers: TFDQuery
    Connection = CnxExport
    SQL.Strings = (
      'SELECT * FROM EXPORT_SQL_USERS'
      'order by NOM')
    Left = 231
    Top = 219
    object QryUsersID_USER: TIntegerField
      FieldName = 'ID_USER'
      Origin = 'ID_USER'
      Required = True
    end
    object QryUsersNOM: TWideStringField
      FieldName = 'NOM'
      Origin = 'NOM'
      Size = 100
    end
    object QryUsersPRENOM: TWideStringField
      FieldName = 'PRENOM'
      Origin = 'PRENOM'
      Size = 100
    end
  end
  object QryUser: TFDQuery
    Connection = CnxExport
    SQL.Strings = (
      'select * from EXPORT_SQL_USERS'
      'where ID_USER = :ID_USER')
    Left = 384
    Top = 216
    ParamData = <
      item
        Name = 'ID_USER'
        DataType = ftInteger
        ParamType = ptInput
        Value = 2
      end>
    object QryUserID_USER: TIntegerField
      FieldName = 'ID_USER'
      Origin = 'ID_USER'
      Required = True
    end
    object QryUserNOM: TWideStringField
      FieldName = 'NOM'
      Origin = 'NOM'
      Size = 100
    end
    object QryUserPRENOM: TWideStringField
      FieldName = 'PRENOM'
      Origin = 'PRENOM'
      Size = 100
    end
  end
  object QrySeq: TFDQuery
    Connection = CnxExport
    SQL.Strings = (
      'SELECT NEXT VALUE FOR GEN_USER_ID as "NEWID"  FROM RDB$DATABASE')
    Left = 232
    Top = 368
    object QrySeqNEWID: TLargeintField
      AutoGenerateValue = arDefault
      FieldName = 'NEWID'
      Origin = 'NEWID'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object QryUserCancel: TFDQuery
    Connection = CnxExport
    SQL.Strings = (
      'select * from EXPORT_SQL_USERS'
      'where ID_USER = :ID_USER')
    Left = 384
    Top = 368
    ParamData = <
      item
        Name = 'ID_USER'
        DataType = ftInteger
        ParamType = ptInput
        Value = 2
      end>
    object IntegerField1: TIntegerField
      FieldName = 'ID_USER'
      Origin = 'ID_USER'
      Required = True
    end
    object WideStringField1: TWideStringField
      FieldName = 'NOM'
      Origin = 'NOM'
      Size = 100
    end
    object WideStringField2: TWideStringField
      FieldName = 'PRENOM'
      Origin = 'PRENOM'
      Size = 100
    end
  end
  object CdsMenu: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 232
    Top = 520
    object CdsMenuLibelle: TStringField
      FieldName = 'Libelle'
      Size = 500
    end
    object CdsMenuIcone: TStringField
      FieldName = 'Icone'
      Size = 50
    end
    object CdsMenuUrl: TStringField
      FieldName = 'Url'
      Size = 500
    end
  end
end
