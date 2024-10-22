object ServerContainer: TServerContainer
  OnCreate = DataModuleCreate
  Height = 210
  Width = 350
  object SparkleHttpSysDispatcher: TSparkleHttpSysDispatcher
    Active = True
    Left = 72
    Top = 16
  end
  object XDataServer: TXDataServer
    BaseUrl = 'http://+:2001/tms/xdata'
    Dispatcher = SparkleHttpSysDispatcher
    Pool = XDataConnectionPool
    EntitySetPermissions = <>
    SwaggerOptions.Enabled = True
    SwaggerUIOptions.Enabled = True
    Left = 216
    Top = 16
    object XDataServerCORS: TSparkleCorsMiddleware
    end
    object XDataServerGeneric: TSparkleGenericMiddleware
    end
  end
  object XDataConnectionPool: TXDataConnectionPool
    Connection = AureliusConnection
    Left = 216
    Top = 72
  end
  object AureliusConnection: TAureliusConnection
    Left = 216
    Top = 128
  end
end
