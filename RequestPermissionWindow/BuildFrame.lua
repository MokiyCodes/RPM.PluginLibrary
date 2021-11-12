local partsWithId = {}
local awaitRef = {}

local root = {
  ID = 0;
  Type = 'Frame';
  Properties = {
    Name = 'RequestPermissionsContainer';
    BorderColor3 = Color3.new(23 / 51, 23 / 51, 1);
    Size = UDim2.new(1, 0, 1, 0);
    BorderSizePixel = 5;
    BackgroundColor3 = Color3.new(
      3 / 85, 3 / 85, 4 / 51
    );
  };
  Children = {
    {
      ID = 1;
      Type = 'TextButton';
      Properties = {
        FontSize = Enum.FontSize.Size14;
        BackgroundColor3 = Color3.new(
          77 / 255, 52 / 85, 23 / 51
        );
        TextColor3 = Color3.new(1, 1, 1);
        Size = UDim2.new(
          0.2355945110321, 0, 0.14877769351006, 0
        );
        Text = '';
        TextSize = 14;
        TextWrapped = true;
        AnchorPoint = Vector2.new(0.5, 0.5);
        Font = Enum.Font.GothamSemibold;
        Name = 'Allow';
        Position = UDim2.new(
          0.16400499641895, 0, 0.8658481836319, 0
        );
        TextScaled = true;
        ZIndex = 2;
        BorderSizePixel = 0;
        TextWrap = true;
      };
      Children = {
        {
          ID = 2;
          Type = 'Frame';
          Properties = {
            Size = UDim2.new(1, 0, 1, 4);
            Name = 'Shadow';
            BorderSizePixel = 0;
            BackgroundColor3 = Color3.new(
              58 / 255, 118 / 255, 86 / 255
            );
          };
          Children = {};
        };
        {
          ID = 3;
          Type = 'TextLabel';
          Properties = {
            BackgroundColor3 = Color3.new(1, 1, 1);
            FontSize = Enum.FontSize.Size14;
            TextSize = 14;
            TextColor3 = Color3.new(1, 1, 1);
            BorderColor3 = Color3.new(
              9 / 85, 14 / 85, 53 / 255
            );
            Text = 'Allow';
            TextWrapped = true;
            Size = UDim2.new(1, -20, 0, 40);
            AnchorPoint = Vector2.new(0.5, 0.5);
            Font = Enum.Font.GothamSemibold;
            BackgroundTransparency = 1;
            Position = UDim2.new(0.5, 0, 0.5, 0);
            TextScaled = true;
            ZIndex = 2;
            BorderSizePixel = 0;
            TextWrap = true;
          };
          Children = {};
        };
      };
    };
    {
      ID = 4;
      Type = 'TextButton';
      Properties = {
        FontSize = Enum.FontSize.Size14;
        BackgroundColor3 = Color3.new(
          52 / 85, 11 / 51, 56 / 255
        );
        TextColor3 = Color3.new(1, 1, 1);
        Size = UDim2.new(
          0.23559449613094, 0, 0.15369449555874, 0
        );
        Text = '';
        TextSize = 14;
        TextWrapped = true;
        AnchorPoint = Vector2.new(0.5, 0.5);
        Font = Enum.Font.GothamSemibold;
        Name = 'Deny';
        Position = UDim2.new(
          0.83178806304932, 0, 0.86217057704926, 0
        );
        TextScaled = true;
        ZIndex = 2;
        BorderSizePixel = 0;
        TextWrap = true;
      };
      Children = {
        {
          ID = 5;
          Type = 'Frame';
          Properties = {
            Size = UDim2.new(1, 0, 1, 4);
            Name = 'Shadow';
            BorderSizePixel = 0;
            BackgroundColor3 = Color3.new(
              39 / 85, 41 / 255, 14 / 85
            );
          };
          Children = {};
        };
        {
          ID = 6;
          Type = 'TextLabel';
          Properties = {
            BackgroundColor3 = Color3.new(1, 1, 1);
            FontSize = Enum.FontSize.Size14;
            TextSize = 14;
            TextColor3 = Color3.new(1, 1, 1);
            BorderColor3 = Color3.new(
              9 / 85, 14 / 85, 53 / 255
            );
            Text = 'Deny';
            TextWrapped = true;
            Size = UDim2.new(1, -20, 0, 40);
            AnchorPoint = Vector2.new(0.5, 0.5);
            Font = Enum.Font.GothamSemibold;
            BackgroundTransparency = 1;
            Position = UDim2.new(0.5, 0, 0.5, 0);
            TextScaled = true;
            ZIndex = 2;
            BorderSizePixel = 0;
            TextWrap = true;
          };
          Children = {};
        };
      };
    };
    {
      ID = 7;
      Type = 'TextLabel';
      Properties = {
        TextWrapped = true;
        TextColor3 = Color3.new(1, 1, 1);
        Text = 'The Plugin %NAME% Requires the following permissions:<br/><font size="24" color="#ff0000">%PERMISSIONS%</font><font size="16"><br/>If you click accept, please click \'accept\' on all the prompts after this prompt.</font>';
        TextXAlignment = Enum.TextXAlignment.Left;
        FontSize = Enum.FontSize.Size32;
        Font = Enum.Font.SourceSans;
        BackgroundTransparency = 1;
        Position = UDim2.new(
          0.052122037857771, 0, 0.050604056566954,
          0
        );
        Size = UDim2.new(
          0.89529895782471, 0, 0.68219417333603, 0
        );
        BackgroundColor3 = Color3.new(1, 1, 1);
        TextSize = 32;
        TextWrap = true;
        RichText = true;
      };
      Children = {};
    };
  };
};

local function Scan( item, parent )
  local obj = Instance.new(item.Type)
  if (item.ID) then
    local awaiting = awaitRef[item.ID]
    if (awaiting) then
      awaiting[1][awaiting[2]] = obj
      awaitRef[item.ID] = nil
    else
      partsWithId[item.ID] = obj
    end
  end
  for p, v in pairs(item.Properties) do
    if (type(v) == 'string') then
      local id = tonumber(v:match('^_R:(%w+)_$'))
      if (id) then
        if (partsWithId[id]) then
          v = partsWithId[id]
        else
          awaitRef[id] = { obj; p }
          v = nil
        end
      end
    end
    obj[p] = v
  end
  for _, c in pairs(item.Children) do
    Scan(c, obj)
  end
  obj.Parent = parent
  return obj
end

return function() return Scan(root, nil) end
