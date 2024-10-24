object ServerContainer: TServerContainer
  OnCreate = DataModuleCreate
  Height = 315
  Width = 525
  PixelsPerInch = 144
  object SparkleHttpSysDispatcher: TSparkleHttpSysDispatcher
    Active = True
    Left = 108
    Top = 24
  end
  object XDataServer: TXDataServer
    BaseUrl = 'http://+:2001/tms/xdata'
    Dispatcher = SparkleHttpSysDispatcher
    Pool = XDataConnectionPool
    EntitySetPermissions = <>
    SwaggerOptions.Enabled = True
    SwaggerUIOptions.Enabled = True
    Left = 324
    Top = 24
    object XDataServerCORS: TSparkleCorsMiddleware
    end
    object XDataServerGeneric: TSparkleGenericMiddleware
    end
  end
  object XDataConnectionPool: TXDataConnectionPool
    Connection = AureliusConnection
    Left = 324
    Top = 108
  end
  object AureliusConnection: TAureliusConnection
    Left = 324
    Top = 192
  end
end
