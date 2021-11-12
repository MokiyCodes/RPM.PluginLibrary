-- yoinked from an old example enum overwrite script that I made ages ago
local ENUM = function( str, ... )
  local thisEnum = {
    __enum = { str; ... }; -- if any of these match, consider it to be equal
    __metatable = 'Enum ' .. str ..
      ' has a locked metatable. Please replace it with a new enum if you wish to modify it\'s metatable'; -- Metatable locked msg
    __tostring = function() return str; end; -- tostring()
    __eq = function( a, b )
      for i, o in pairs(a.__enum) do
        if b[i] and b[i] == o then
          return true;
        end
      end
      return false;
    end; -- this is a "loose" check, useful for cases that don't follow the recommended `inputEnum==enum.a.b`, but rather `inputEnum==32` or similar
  }
  thisEnum.__index = thisEnum;
  return setmetatable({}, thisEnum)
end

local _enum = setmetatable(
  {
    -- your enums go here!
    ['UnloadType'] = {
      ['Unload'] = ENUM(
        'Enum.UnloadType.Unload', 1
      );
      ['Reload'] = ENUM(
        'Enum.UnloadType.Reload', 2
      );
      ['Error'] = ENUM('Enum.UnloadType.Error', 3);
    };
  }, { __index = Enum }
);

return _enum
