object WMMain: TWMMain
  OnCreate = WebModuleCreate
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WMMainDefaultHandlerAction
    end>
  Height = 460
  Width = 830
  PixelsPerInch = 192
  object wsEngineDbToXls: TWebStencilsEngine
    Dispatcher = WebFileDispatcher
    PathTemplates = <>
    Left = 128
    Top = 64
  end
  object wspIndex: TWebStencilsProcessor
    Engine = wsEngineDbToXls
    InputFileName = './templates/Index.html'
    PathTemplate = './Templates'
    Left = 128
    Top = 216
  end
  object wspListeUsers: TWebStencilsProcessor
    Engine = wsEngineDbToXls
    InputFileName = './templates/ListeUsers.html'
    PathTemplate = './Templates'
    Left = 280
    Top = 216
  end
  object WebFileDispatcher: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/html'
        Extensions = 'html;htm'
      end
      item
        MimeType = 'application/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpeg;jpg'
      end
      item
        MimeType = 'image/png'
        Extensions = 'png'
      end
      item
        MimeType = 'image/svg+xml'
        Extensions = 'svg;svgz'
      end
      item
        MimeType = 'image/x-icon'
        Extensions = 'ico'
      end>
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    RootDirectory = '/'
    VirtualPath = '/'
    Left = 304
    Top = 64
  end
  object wspEditUser: TWebStencilsProcessor
    Engine = wsEngineDbToXls
    InputFileName = './templates/User.html'
    PathTemplate = './Templates'
    Left = 408
    Top = 216
  end
end
