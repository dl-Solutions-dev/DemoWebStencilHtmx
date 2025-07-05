object DMSession: TDMSession
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 1920
  Width = 2560
  PixelsPerInch = 192
  object CnxCustomers: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\danyleblanc\Documents\DL-Projets\DemoWebStenci' +
        'lHtmx\Database\CUSTOMERS.FDB'
      'ConnectionDef=EXPORT_SQL')
    Connected = True
    LoginPrompt = False
    Left = 231
    Top = 59
  end
  object QryCustomers: TFDQuery
    OnCalcFields = QryCustomersCalcFields
    Connection = CnxCustomers
    SQL.Strings = (
      'SELECT * FROM CUSTOMERS'
      'order by CUST_NAME')
    Left = 231
    Top = 219
    object QryCustomersCUST_ID: TIntegerField
      FieldName = 'CUST_ID'
      Origin = 'CUST_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QryCustomersCUST_NAME: TWideStringField
      FieldName = 'CUST_NAME'
      Origin = 'CUST_NAME'
      Required = True
      Size = 500
    end
    object QryCustomersCUST_VILLE: TWideStringField
      FieldName = 'CUST_VILLE'
      Origin = 'CUST_VILLE'
      Size = 500
    end
    object QryCustomersCUST_PAYS: TWideStringField
      FieldName = 'CUST_PAYS'
      Origin = 'CUST_PAYS'
      Size = 500
    end
    object QryCustomersCUST_TYPE: TWideStringField
      FieldName = 'CUST_TYPE'
      Origin = 'CUST_TYPE'
      FixedChar = True
      Size = 1
    end
    object QryCustomersCUST_LIB_TYPE: TStringField
      FieldKind = fkCalculated
      FieldName = 'CUST_LIB_TYPE'
      Size = 100
      Calculated = True
    end
  end
  object QryCustomer: TFDQuery
    OnCalcFields = QryCustomersCalcFields
    Connection = CnxCustomers
    SQL.Strings = (
      'select * from CUSTOMERS'
      'where CUST_ID = :CUST_ID')
    Left = 392
    Top = 216
    ParamData = <
      item
        Name = 'CUST_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object QryCustomerCUST_ID: TIntegerField
      FieldName = 'CUST_ID'
      Origin = 'CUST_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QryCustomerCUST_NAME: TWideStringField
      FieldName = 'CUST_NAME'
      Origin = 'CUST_NAME'
      Required = True
      Size = 500
    end
    object QryCustomerCUST_VILLE: TWideStringField
      FieldName = 'CUST_VILLE'
      Origin = 'CUST_VILLE'
      Size = 500
    end
    object QryCustomerCUST_PAYS: TWideStringField
      FieldName = 'CUST_PAYS'
      Origin = 'CUST_PAYS'
      Size = 500
    end
    object QryCustomerCUST_TYPE: TWideStringField
      FieldName = 'CUST_TYPE'
      Origin = 'CUST_TYPE'
      FixedChar = True
      Size = 1
    end
    object QryCustomerCUST_LIB_TYPE: TStringField
      FieldKind = fkCalculated
      FieldName = 'CUST_LIB_TYPE'
      Size = 500
      Calculated = True
    end
  end
  object QrySeq: TFDQuery
    Connection = CnxCustomers
    SQL.Strings = (
      'SELECT NEXT VALUE FOR GEN_CUST_ID as "NEWID"  FROM RDB$DATABASE')
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
  object QryCustomerCancel: TFDQuery
    Connection = CnxCustomers
    SQL.Strings = (
      'select * from CUSTOMERS'
      'where CUST_ID = :CUST_ID')
    Left = 384
    Top = 368
    ParamData = <
      item
        Name = 'CUST_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object QryCustomerCancelCUST_ID: TIntegerField
      FieldName = 'CUST_ID'
      Origin = 'CUST_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QryCustomerCancelCUST_NAME: TWideStringField
      FieldName = 'CUST_NAME'
      Origin = 'CUST_NAME'
      Required = True
      Size = 500
    end
    object QryCustomerCancelCUST_VILLE: TWideStringField
      FieldName = 'CUST_VILLE'
      Origin = 'CUST_VILLE'
      Size = 500
    end
    object QryCustomerCancelCUST_PAYS: TWideStringField
      FieldName = 'CUST_PAYS'
      Origin = 'CUST_PAYS'
      Size = 500
    end
    object QryCustomerCancelCUST_TYPE: TWideStringField
      FieldName = 'CUST_TYPE'
      Origin = 'CUST_TYPE'
      FixedChar = True
      Size = 1
    end
  end
  object qryCustomerTypes: TFDQuery
    Connection = CnxCustomers
    SQL.Strings = (
      'select * from CUSTOMER_TYPES'
      'order by CT_LIBELLE')
    Left = 240
    Top = 496
    object qryCustomerTypesCT_TYPE: TWideStringField
      FieldName = 'CT_TYPE'
      Origin = 'CT_TYPE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      FixedChar = True
      Size = 1
    end
    object qryCustomerTypesCT_LIBELLE: TWideStringField
      FieldName = 'CT_LIBELLE'
      Origin = 'CT_LIBELLE'
      Size = 100
    end
  end
  object QryCustomerTotQuotes: TFDQuery
    Connection = CnxCustomers
    SQL.Strings = (
      'select sum(DOC_AMOUNT) as "TOTAL_QUOTE" from DOCUMENTS'
      'where DOC_CUST_ID = :DOC_CUST_ID'
      'and DOC_TYPE='#39'Q'#39)
    Left = 624
    Top = 216
    ParamData = <
      item
        Name = 'DOC_CUST_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object QryCustomerTotQuotesTOTAL_QUOTE: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'TOTAL_QUOTE'
      Origin = 'TOTAL_QUOTE'
      ProviderFlags = []
      ReadOnly = True
      Precision = 18
      Size = 2
    end
  end
  object QryCustomerTotOrders: TFDQuery
    Connection = CnxCustomers
    SQL.Strings = (
      'select sum(DOC_AMOUNT) as "TOTAL_ORDER" from DOCUMENTS'
      'where DOC_CUST_ID = :DOC_CUST_ID'
      'and DOC_TYPE='#39'O'#39)
    Left = 624
    Top = 368
    ParamData = <
      item
        Name = 'DOC_CUST_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object QryCustomerTotOrdersTOTAL_ORDER: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'TOTAL_ORDER'
      Origin = 'TOTAL_ORDER'
      ProviderFlags = []
      ReadOnly = True
      Precision = 18
      Size = 2
    end
  end
  object QryListQuotes: TFDQuery
    Connection = CnxCustomers
    SQL.Strings = (
      'select * from DOCUMENTS'
      'where DOC_CUST_ID = :DOC_CUST_ID'
      'and DOC_TYPE='#39'Q'#39)
    Left = 624
    Top = 496
    ParamData = <
      item
        Name = 'DOC_CUST_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object QryListQuotesDOC_ID: TIntegerField
      FieldName = 'DOC_ID'
      Origin = 'DOC_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QryListQuotesDOC_TYPE: TWideStringField
      FieldName = 'DOC_TYPE'
      Origin = 'DOC_TYPE'
      Required = True
      FixedChar = True
      Size = 1
    end
    object QryListQuotesDOC_DESCRIPTION: TWideStringField
      FieldName = 'DOC_DESCRIPTION'
      Origin = 'DOC_DESCRIPTION'
      Size = 1000
    end
    object QryListQuotesDOC_AMOUNT: TFMTBCDField
      FieldName = 'DOC_AMOUNT'
      Origin = 'DOC_AMOUNT'
      Precision = 18
      Size = 2
    end
    object QryListQuotesDOC_CUST_ID: TIntegerField
      FieldName = 'DOC_CUST_ID'
      Origin = 'DOC_CUST_ID'
      Required = True
    end
  end
  object QryListOrders: TFDQuery
    Connection = CnxCustomers
    SQL.Strings = (
      'select * from DOCUMENTS'
      'where DOC_CUST_ID = :DOC_CUST_ID'
      'and DOC_TYPE='#39'O'#39)
    Left = 784
    Top = 496
    ParamData = <
      item
        Name = 'DOC_CUST_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object QryListOrdersDOC_ID: TIntegerField
      FieldName = 'DOC_ID'
      Origin = 'DOC_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QryListOrdersDOC_TYPE: TWideStringField
      FieldName = 'DOC_TYPE'
      Origin = 'DOC_TYPE'
      Required = True
      FixedChar = True
      Size = 1
    end
    object QryListOrdersDOC_DESCRIPTION: TWideStringField
      FieldName = 'DOC_DESCRIPTION'
      Origin = 'DOC_DESCRIPTION'
      Size = 1000
    end
    object QryListOrdersDOC_AMOUNT: TFMTBCDField
      FieldName = 'DOC_AMOUNT'
      Origin = 'DOC_AMOUNT'
      Precision = 18
      Size = 2
    end
    object QryListOrdersDOC_CUST_ID: TIntegerField
      FieldName = 'DOC_CUST_ID'
      Origin = 'DOC_CUST_ID'
      Required = True
    end
  end
end
