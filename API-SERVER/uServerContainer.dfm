object ServerContainer: TServerContainer
  OnCreate = DataModuleCreate
  Height = 317
  Width = 446
  object SparkleHttpSysDispatcher: TSparkleHttpSysDispatcher
    Active = True
    Left = 128
    Top = 48
  end
  object XDataServer: TXDataServer
    BaseUrl = 'http://+:2001/tms/xdata'
    Dispatcher = SparkleHttpSysDispatcher
    Pool = XDataConnectionPool
    EntitySetPermissions = <>
    SwaggerOptions.Enabled = True
    SwaggerUIOptions.Enabled = True
    Left = 72
    Top = 16
    object XDataServerCORS: TSparkleCorsMiddleware
    end
    object XDataServerGeneric: TSparkleGenericMiddleware
    end
  end
  object XDataConnectionPool: TXDataConnectionPool
    Connection = AureliusConnection
    Left = 128
    Top = 104
  end
  object AureliusConnection: TAureliusConnection
    Left = 272
    Top = 48
  end
end
