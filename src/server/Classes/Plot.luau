-- services
local Workspace = game:GetService("Workspace")

-- required for item and button pos
local templatePlot = Workspace.TemplateFactoryPlot

-- plot class
local Plot = {}
Plot.__index = Plot


function Plot.new(PlotPart : BasePart)
  local self = setmetatable({}, Plot)
  self.ownerID = nil
  self.part = PlotPart

  self:_createPlotFolderInstances()

  return self
end

function Plot:ClearPlot()
  self.itemsFolder:ClearAllChildren()
  self.buttonsFolder:ClearAllChildren()
end

function Plot:AssignOwner(player)
  print("Assigned plot to player")

  self.ownerID = player.UserId
  self.part:SetAttribute("OwnerID", self.ownerID)

  self:_cloneFromTemplate()
end

function Plot:ReleaseOwner()
  print("Released plot from player")

  self.ownerID = nil
  self.part:SetAttribute("OwnerID", nil)

  self:ClearPlot()
end

function Plot:_cloneFromTemplate()

  local templateItemsFolder = templatePlot:FindFirstChild("Items")
  assert(templateItemsFolder, "Could not find template items folder")

  for _, templateItem in ipairs(templateItemsFolder:GetChildren()) do
    local item = templateItem:Clone()
    local itemCFrame = item:GetPivot()
    local relativeItemCFrame = templatePlot.CFrame:ToObjectSpace(itemCFrame)
    local worldCFrameOfNewPlot = self.part.CFrame:ToWorldSpace(relativeItemCFrame)
    item:PivotTo(worldCFrameOfNewPlot)
    item.Parent = self.itemsFolder
  end

  local templateButtonsFolder = templatePlot:FindFirstChild("Buttons")
  assert(templateButtonsFolder, "Could not find template buttons folder")

  for _, templateButton in ipairs(templateButtonsFolder:GetChildren()) do
    local button = templateButton:Clone()
    local relativeCFrame = templatePlot.CFrame:ToObjectSpace(button.CFrame)
    button.CFrame = self.part.CFrame:ToWorldSpace(relativeCFrame)
    button.Parent = self.buttonsFolder
  end
end

function Plot:_createPlotFolderInstances()
  self.itemsFolder = Instance.new("Folder")
  self.itemsFolder.Name = "Items"
  self.itemsFolder.Parent = self.part

  self.buttonsFolder = Instance.new("Folder")
  self.buttonsFolder.Name = "Buttons"
  self.buttonsFolder.Parent = self.part
end

return Plot