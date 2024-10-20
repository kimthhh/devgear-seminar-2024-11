object FireDacMSSQLConnection: TFireDacMSSQLConnection
  Height = 198
  Width = 282
  object Connection: TFDConnection
    Left = 48
    Top = 8
  end
  object AureliusConnection1: TAureliusConnection
    AdapterName = 'FireDac'
    AdaptedConnection = Connection
    SQLDialect = 'MSSQL'
    Left = 48
    Top = 72
  end
end
