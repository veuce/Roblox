assert(syn, 'Synapse X only!')

local RunService = game:GetService('RunService')

-- Definitions
local camera = workspace.CurrentCamera
local decode = syn.crypt.base64.decode
local spawn = task.spawn

-- Image must be encoded in Base64
local CURRENT_IMG = decode('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')

local function ESP(player)
    -- I recommend use the powers of two for the size of image
    local label = Drawing.new('Text')
    label.Font = Drawing.Fonts.Plex 
    label.Size = 13 
    label.Center = true 
    label.Outline = true
    label.Color = Color3.fromRGB(255,255,255)
    label.Text = string.format("%s's Boomshakalaca", player.Name)
    label.ZIndex = 1
    
    local img = Drawing.new('Image')
    img.Visible = true 
    img.Data = CURRENT_IMG
    img.Size = Vector2.new(64, 64)
    img.ZIndex = 0
    
    coroutine.wrap(function()
        spawn(function()
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if player.Character ~= nil and player.Character:FindFirstChildOfClass('Humanoid') and player.Character:FindFirstChild('HumanoidRootPart') and player.Character.Humanoid.Health > 0 then 
                    local screenPos, isVisible = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                    
                    if isVisible then 
                        img.Position = Vector2.new(screenPos.X - 32, screenPos.Y - 32)
                        label.Position = Vector2.new(screenPos.X, screenPos.Y - 60)
                        
                        img.Visible = true
                        label.Visible = true
                    else
                        img.Visible = false
                        label.Visible = false
                    end
                    
                else
                    connection:Disconnect()
                    img:Remove()
                    label:Remove()
                end
            end)
        end)
    end)()
end

for _, v in pairs(game.Players:GetPlayers()) do 
    coroutine.wrap(ESP)(v)
end 

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        coroutine.wrap(ESP)(player)
    end)
end)
