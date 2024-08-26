return {
    draggable = function (gui, s)
        local UserInputService = game:GetService("UserInputService")
        local runService = (game:GetService("RunService"));
    
        local dragging
        local dragInput
        local dragStart
        local startPos
    
        local function Lerp(a, b, m)
            return a + (b - a) * m
        end;
    
        local lastMousePos
        local lastGoalPos
        local DRAG_SPEED = s or 8; -- // The speed of the UI darg.
    
        local function Update(dt)
            if not (startPos) then return end;
            if not (dragging) and (lastGoalPos) then
                gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
                return 
            end;
    
            local delta = (lastMousePos - UserInputService:GetMouseLocation())
            local xGoal = (startPos.X.Offset - delta.X);
            local yGoal = (startPos.Y.Offset - delta.Y);
            lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
            gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
        end;
    
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
                lastMousePos = UserInputService:GetMouseLocation()
    
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
    
        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
    
        runService.Heartbeat:Connect(Update)
    end,
    turkeyConvert = function(dupeNumber)
        local localPlayer = game:GetService("Players").LocalPlayer
        local character = localPlayer.Character

        character:PivotTo(CFrame.new(0, 9e9, 0))

        game.ReplicatedStorage.WearItem:FireServer({
            "Wear", "130213380", "Faces"
        })

        character.Head.face.Changed:Wait()

        local partNumber = dupeNumber --(#game:GetService("Players"):GetPlayers() - 1) * 2
        local oldTorsoNumber = #character.Torso:GetChildren()

        for i = 1, partNumber do
            workspace.Events.Morph.Player:FireServer("Turkey")
        end

        repeat task.wait() until #character.Torso:GetChildren() > oldTorsoNumber

        character.Humanoid:ChangeState(15)

        --[[while game:GetService("RunService").Heartbeat:Wait() do
            if localPlayer.Character ~= character then
                break
            end

            localPlayer.SimulationRadius = 9e9

            for _, object in pairs(character.Torso:GetChildren()) do
                if object.Name == "Part" then
                    object.CFrame = getRandomPlayer().Character:GetPivot()
                    
                    object:ApplyImpulse(Vector3.one * 9e9)
                    object.CanCollide = false

                    if not isnetworkowner(object) then
                        localPlayer.Character:PivotTo(object.CFrame)
                    end
                end
            end
        end--]]
    end
}