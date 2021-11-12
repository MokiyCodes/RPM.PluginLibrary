local LiveLoad = game:GetService(
  'ServerScriptService'
):FindFirstChild('LiveLoadPlugins')

local RequestPermission = require(
  script.Parent.RequestPermissionWindow
)

local GetPlugin
GetPlugin = function( a, b, c, d )
  local options = (typeof(d) == 'nil') and a or b;
  local plugin = (typeof(d) == 'nil') and b or c;
  local PluginScript =
    (typeof(d) == 'nil') and c or d;

  local name = options.Name
  if LiveLoad then
    if LiveLoad:FindFirstChild(name) then
      local Cloned = LiveLoad[name]:Clone()
      if not Cloned:FindFirstChild('Plugin') then
        error(
          'Cannot find `Plugin` Script in LiveLoadPlugins! Plugin Loading Failed.'
        )
      end
      PluginScript = Cloned.Plugin
      if not PluginScript:FindFirstChild(
        'LoadPlugin'
      ) then
        error(
          'LoadPlugin Script not found. This is non-standard, and not supported! Please insert a script in `Plugin` called `LoadPlugin`, which should load the plugin.'
        )
      end
    else
      print(
        'INFO: LiveLoad found, but Debug Plugin for',
        name, 'was not.'
      )
    end
  end

  local PluginMeta = {}
  local Plugin = setmetatable(
    {}, { __index = plugin }
  )

  Plugin.Perms = options.Permissions

  -- Plugin Metatable Shite
  do
    PluginMeta.__index = Plugin;
    PluginMeta.__tostring = function()
      return
        'RPM Plugin Library | See Plugin.Credits() for Credits'
    end
    PluginMeta.Credits = function()
      local v =
        '| ########################## |\n| #   RPM Plugin Library   # |\n| #     by MokiyCodes      # |\n| ########################## |';
      print(v)
      return v
    end
  end

  Plugin.Name = name;
  Plugin.Raw = plugin;
  Plugin.Enum = setmetatable(
    require(
      script.Parent.Enum
    ), { ['__index'] = Enum }
  )

  -- Plugin Outputs
  do
    Plugin.print = function( ... )
      return print(name .. ' 🢂', ...)
    end
    Plugin.warn = function( ... )
      return warn(name .. ' 🢂', ...)
    end
    Plugin.error = function( ... )
      return error(
        name .. ' 🢂' ..
          table.concat({ ... }, ' '), 2
      )
    end
    Plugin._libprint = function( ... )
      return print(name .. ' (@ lib) 🢂 ', ...)
    end
    Plugin._libwarn = function( ... )
      return warn(name .. ' (@ lib) 🢂 ', ...)
    end
  end
  -- Plugin Event System
  do
    -- would've used KIIS but that's slightly non-standard, and this needs to be standard-compliant
    local ev = Instance.new('BindableEvent')
    Plugin.Fire = function( t, ... )
      if not t or not typeof(t) == 'string' then
        error(
          'Please specify a string as the first argument to Fire'
        )
      end
      ev:Fire(...)
    end
    Plugin.on = function( v, cb )
      -- fix some weird syntax highlighting issue
      ev['Eve' .. 'nt']:Connect(
        function( type, ... )
          if type == v then cb(...) end
        end
      )
    end
  end
  -- Reload plugin
  do
    Plugin.reload = function()
      Plugin._libwarn(
        'Reloading plugin! This can cause issues with most plugins, considering it doesn\'t unload the previous instance.'
      )
      Plugin.Fire(
        'unload', { ['type'] = 'reload' }
      )
    end
    local OldRL = _G.Reload or function() end
    _G.Reload = function()
      Plugin.reload();
      GetPlugin(a, b, c, d)
      return OldRL()
    end
  end
  -- Other Plugin Things
  do end

  RequestPermission(Plugin, 'sex')

  require(PluginScript)(
    setmetatable(
      {}, PluginMeta
    )
  )

  return 'SUCCESS'
end
return { ['Load'] = GetPlugin };
