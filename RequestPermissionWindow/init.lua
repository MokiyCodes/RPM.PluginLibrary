local FrameBuilder = require(script.BuildFrame)

return function( plugin, title )

  plugin._libprint(
    'Opening Request Permission Window'
  )

  -- Create new "DockWidgetPluginGuiInfo" object
  local widgetInfo = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Float, true, true, 515,
    475, 384, 341
  )

  -- Create new widget GUI
  local widget =
    plugin.Raw:CreateDockWidgetPluginGui(
      plugin.Name, widgetInfo
    )
  widget.Title = title -- Optional widget title
  widget.ResetOnSpawn = false;
  widget.Enabled = true;

  local Frame = FrameBuilder();
  Frame.Parent = widget;

  local v = Instance.new('BindableEvent')

  local RunPermCheck = function()
    local DomainPrefix = 'domain@'

    local PermCBs
    PermCBs = {
      ['#Domain'] = function( d, i )
        i = i or 0;
        if i >= 10 then
          plugin._liberror(
            'Timed out when trying to get permissions for domain',
            d
          )
        end
        plugin._libprint(
          'Requesting Permissions for Domain', d
        )

        local a, b = pcall(
          function()
            game:GetService('HttpService')
              :GetAsync(
                'http://' .. d ..
                  '/?request=permwindow'
              )
          end
        )

        if not a then
          plugin._libwarn(
            'Error while running HTTP:', b,
            '\nPlease make sure that the host (' ..
              d .. ') resolves on http://' .. d ..
              ':80/?request=permwindow` to remove this warning.\nThis warning also shows if the user has denied the prompt, or not answered it yet.\n',
            'Repeating in 5s\nTo abort, close this, then try clicking Allow again.'
          )
          wait(5) -- todo add optimized wait
          return PermCBs['#Domain'](d, i + 1)
        end
      end;
      ['Scripts'] = function( i )
        i = i or 0;
        if i >= 10 then
          plugin._liberror(
            'Timed out when trying to get permissions for scripts'
          )
        end
        local a, b = pcall(
          function()
            local Scrept = Instance.new('Script')
            Scrept.Name = 'RequestPermissionScript'
            Scrept.Parent = game:GetService(
              'Workspace'
            )
            Scrept.Source = 'print(\'Permissions should\\\'ve been recieved if you see this\')'
            Scrept:Destroy()
          end
        )

        if game:GetService('Workspace')
          :FindFirstChild(
            'RequestPermissionScript'
          ) then
          game:GetService('Workspace').RequestPermissionScript:Destroy()
        end

        if not a then
          plugin._libwarn(
            'Failed to gain scripts permission (pcall failed) - Trying again in 5 seconds...'
          )
          wait(5) -- todo add optimized wait
          return PermCBs['Scripts'](i + 1)
        end
      end;
    }

    for _, perm in pairs(plugin.Perms) do
      if string.sub(perm, 1, #DomainPrefix) ==
        DomainPrefix then
        PermCBs['#Domain'](
          string.sub(
            perm, #DomainPrefix + 1
          )
        )
      else
        (PermCBs[perm] or function()
          plugin._libwarn(
            'Permission', perm, 'not found!'
          )
        end)()
      end
      plugin._libprint(
        'Ran permission check for perm', perm
      )
    end
    v:Fire(false);
  end

  Frame.Allow.MouseButton1Click:Connect(
    function()
      widget.Enabled = false;
      RunPermCheck()
    end
  )
  Frame.Deny.MouseButton1Click:Connect(
    function()
      widget.Enabled = false;
      v:Fire(1);
    end
  )

  local result = v.Event:Wait();

  if result == 1 then
    plugin.error(
      'The permissions prompt was denied - Exiting...'
    )
  end
end
