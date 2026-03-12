--[[
  ████████╗      ██╗  ██╗██╗   ██╗██████╗
     ██╔══╝      ██║  ██║██║   ██║██╔══██╗
     ██║   █████╗███████║██║   ██║██████╔╝
     ██║   ╚════╝██╔══██║██║   ██║██╔══██╗
     ██║         ██║  ██║╚██████╔╝██████╔╝
     ╚═╝         ╚═╝  ╚═╝ ╚═════╝ ╚═════╝
  T-HUB v5.0 VIP | Arsenal | trixxsobased
  Executor : Xeno v1.3.25b+
  Base     : Antigravity v5.0 + community research
  3 tabs   : Combat · Visuals · Settings

  CHANGELOG v5.0:
  - Ghost ESP fix (parent nil check)
  - Full character lifecycle (CharacterAdded/Removing)
  - Team mode system (FFA/1v1/2v2/3v3) + team ESP toggle
  - Max ESP distance filter with slider
  - Skeleton HP gradient coloring
  - Tracer from bottom-center screen
  - Shield (ForceField) indicator
  - Status bar: mode + target name
  - Silent aim: Raycast-only hook, removed legacy ray hooks
  - AimSmooth lerp for human-like aiming
  - Round end auto-cleanup
]]




local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenSvc     = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local Lighting     = game:GetService("Lighting")
local VirtualUser  = game:GetService("VirtualUser")
local Workspace    = game:GetService("Workspace")
local RepStorage   = game:GetService("ReplicatedStorage")

local LP     = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local GuiParent = (gethui and gethui()) or game:GetService("CoreGui")




local C = {
    BG        = Color3.fromRGB(12,  12,  12),
    Sidebar   = Color3.fromRGB(8,   8,   8),
    Card      = Color3.fromRGB(15,  15,  15),
    CardHov   = Color3.fromRGB(22,  22,  22),
    Accent    = Color3.fromRGB(205, 28,  0),
    AccentHi  = Color3.fromRGB(255, 55, 20),
    AccentLo  = Color3.fromRGB(130, 18,  0),
    Text      = Color3.fromRGB(208, 208, 208),
    TextDim   = Color3.fromRGB(100, 100, 100),
    TogOff    = Color3.fromRGB(36,  36,  36),
    White     = Color3.fromRGB(255, 255, 255),
    Black     = Color3.fromRGB(0,   0,   0),
    TeamBlue  = Color3.fromRGB(80,  140, 255),  
    ShieldCyan= Color3.fromRGB(0,   220, 220),  
}




local S = {
    
    AimOn       = false,
    AimFOV      = 120,
    AimHead     = true,
    AimTeam     = false,
    AimVis      = true,
    AimFOVShow  = false,
    AimSmooth   = 0.85,      
    CamLock     = false,
    CamSmooth   = 0.08,
    HitboxOn    = false,
    HitboxMult  = 2.0,
    NoRecoil    = false,
    RecoilReduce= 65,
    Triggerbot  = false,
    TrigDelay   = 80,
    Prediction  = false,
    PredStr     = 50,
    BHop        = false,
    
    ESPCorner   = false,
    ESPName     = false,
    ESPHealth   = false,
    ESPSkel     = false,
    ESPTracer   = false,
    ESPTeam     = true,       
    ESPMaxDist  = 500,        
    MatchMode   = "Solo",     
    FPSCount    = false,
    FPSUnlock   = false,
    
    AntiAFK     = false,
    RoundEndEvent = "Blank",  
}


local currentTarget = nil     
local smoothedDir   = nil     




local function getChar() return LP.Character end
local function getHum()  local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end

local function getHealth(char, hum)
    
    local hpVal = char:FindFirstChild("HP") 
               or char:FindFirstChild("Health")
               or char:FindFirstChild("hp")
    if hpVal and (hpVal:IsA("NumberValue") or hpVal:IsA("IntValue")) then
        local maxHP = char:FindFirstChild("MaxHP") 
                   or char:FindFirstChild("MaxHealth")
        local max = (maxHP and maxHP.Value) or hum.MaxHealth or 100
        return hpVal.Value, max
    end
    
    local attrHP = hum:GetAttribute("HP") or hum:GetAttribute("Health")
    if attrHP then
        return attrHP, hum.MaxHealth or 100
    end
    
    return hum.Health, hum.MaxHealth
end

local function getHealth(char, hum)
    
    local hpVal = char:FindFirstChild("HP") 
               or char:FindFirstChild("Health")
               or char:FindFirstChild("hp")
    if hpVal and (hpVal:IsA("NumberValue") or hpVal:IsA("IntValue")) then
        local maxHP = char:FindFirstChild("MaxHP") 
                   or char:FindFirstChild("MaxHealth")
        local max = (maxHP and maxHP.Value) or hum.MaxHealth or 100
        return hpVal.Value, max
    end
    
    local attrHP = hum:GetAttribute("HP") or hum:GetAttribute("Health")
    if attrHP then
        return attrHP, hum.MaxHealth or 100
    end
    
    return hum.Health, hum.MaxHealth
end

local function tw(obj, props, t, style, dir)
    TweenSvc:Create(obj,
        TweenInfo.new(t or 0.16, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function make(cls, props, par)
    local o = Instance.new(cls)
    if props then for k,v in pairs(props) do o[k]=v end end
    if par   then o.Parent = par end
    return o
end

local function rnd(n) return math.floor(n+0.5) end


for _, name in ipairs({"THUB_Main","THUB_Toast","THUB_FPS","THUB_WM"}) do
    local old = GuiParent:FindFirstChild(name)
    if old then old:Destroy() end
end




print((string.char(91,84,45,72,85,66,93,32,61,61,61,32,82,101,112,108,105,99,97,116,101,100,83,116,111,114,97,103,101,32,82,101,109,111,116,101,69,118,101,110,116,115,32,61,61,61)))
for _,v in ipairs(RepStorage:GetChildren()) do
    if v:IsA("RemoteEvent") then
        print((string.char(91,84,45,72,85,66,93,32,82,101,109,111,116,101,69,118,101,110,116,58)), v.Name)
    end
end
print((string.char(91,84,45,72,85,66,93,32,61,61,61,32,69,110,100,32,115,99,97,110,46,32,83,101,116,32,83,46,82,111,117,110,100,69,110,100,69,118,101,110,116,32,116,111,32,116,104,101,32,114,111,117,110,100,45,101,110,100,32,101,118,101,110,116,32,110,97,109,101,32,61,61,61)))




local toastSG = make("ScreenGui",{Name="THUB_Toast",ResetOnSpawn=false,
    DisplayOrder=9999,IgnoreGuiInset=true},GuiParent)
local toastF = make("Frame",{
    BackgroundColor3=C.BG, Size=UDim2.new(0,210,0,34),
    Position=UDim2.new(0.5,-105,0,-42), BorderSizePixel=0,
},toastSG)
make("UICorner",{CornerRadius=UDim.new(0,7)},toastF)
make("UIStroke",{Color=C.Accent,Thickness=1,Transparency=0.3},toastF)
local toastLbl = make("TextLabel",{
    Text="",Font=Enum.Font.GothamBold,TextSize=12,
    TextColor3=C.White,BackgroundTransparency=1,
    Size=UDim2.new(1,0,1,0),Parent=toastF
})

local toastQ={}; local toastBusy=false
local function toast(msg,col)
    table.insert(toastQ,{msg=msg,col=col or C.Accent})
    if toastBusy then return end
    toastBusy=true
    task.spawn(function()
        while #toastQ>0 do
            local item=table.remove(toastQ,1)
            toastLbl.Text=item.msg; toastLbl.TextColor3=item.col
            tw(toastF,{Position=UDim2.new(0.5,-105,0,10)},0.22,
                Enum.EasingStyle.Back,Enum.EasingDirection.Out)
            task.wait(1.5)
            tw(toastF,{Position=UDim2.new(0.5,-105,0,-42)},0.18)
            task.wait(0.22)
        end
        toastBusy=false
    end)
end




local drawObjs={}
local function newD(cls)
    if not Drawing then return nil end
    local ok,d=pcall(Drawing.new,cls)
    if ok then table.insert(drawObjs,d); return d end
end




local wmSG = make("ScreenGui",{Name="THUB_WM",ResetOnSpawn=false,
    DisplayOrder=998,IgnoreGuiInset=true},GuiParent)
local wmLbl = make("TextLabel",{
    Text=(string.char(84,45,72,85,66,32,118,53,46,48,32,86,73,80)),Font=Enum.Font.GothamBold,TextSize=11,
    TextColor3=C.Accent,BackgroundTransparency=1,
    TextStrokeTransparency=0.6,TextStrokeColor3=C.Black,
    Size=UDim2.new(0,100,0,16),Position=UDim2.new(0,8,0,6),
    TextXAlignment=Enum.TextXAlignment.Left,
},wmSG)




local fovCircle = newD("Circle")
if fovCircle then
    fovCircle.Color=C.Accent; fovCircle.Thickness=1
    fovCircle.Filled=false; fovCircle.Visible=false
end

local function getEffectiveFOV()
    return S.AimFOV * (S.HitboxOn and S.HitboxMult or 1)
end


local function isAlive(char)
    if not char or char.Parent == nil then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Health <= 0 then return false end
    if hum:GetState() == Enum.HumanoidStateType.Dead then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root or root.Parent == nil then return false end
    return true
end


local function getTeamColor(player)
    if not player then return nil end
    local ok, tc = pcall(function() return player.TeamColor end)
    return ok and tc or nil
end

local function isEnemy(p)
    if p == LP then return false end
    if S.MatchMode == "Solo" then return true end
    local myTC = getTeamColor(LP)
    local theirTC = getTeamColor(p)
    if myTC and theirTC then
        return myTC ~= theirTC
    end
    return true
end


local function hasShield(char)
    return char and char:FindFirstChildWhichIsA("ForceField") ~= nil
end

local function getTarget()
    local bestP, bestDist = nil, getEffectiveFOV()
    local mouse = UIS:GetMouseLocation()
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP or not p.Character then continue end
        if not isAlive(p.Character) then continue end
        if not isEnemy(p) then continue end
        local part = (S.AimHead and p.Character:FindFirstChild("Head"))
                  or p.Character:FindFirstChild("UpperTorso")
                  or p.Character:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        if S.AimVis then
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {LP.Character, Camera}
            params.FilterType = Enum.RaycastFilterType.Exclude
            local res = Workspace:Raycast(
                Camera.CFrame.Position,
                (part.Position - Camera.CFrame.Position).Unit * 999,
                params
            )
            if res and not res.Instance:IsDescendantOf(p.Character) then continue end
        end
        local vp,onS = Camera:WorldToViewportPoint(part.Position)
        if not onS then continue end
        local d = (Vector2.new(vp.X,vp.Y) - mouse).Magnitude
        
        if hasShield(p.Character) then d = d * 1.5 end
        if d < bestDist then bestDist=d; bestP=p end
    end
    currentTarget = bestP  
    return bestP
end


local function getPredictedPos(part)
    local pos = part.Position
    if S.Prediction then
        local vel = part.AssemblyLinearVelocity
        if vel and vel.Magnitude > 1 then
            local ping = (game:GetService("Stats"):FindFirstChild("PerformanceStats")
                and game:GetService("Stats").PerformanceStats:FindFirstChild("Ping")
                and game:GetService("Stats").PerformanceStats.Ping:GetValue() or 50)
            local basePred = 0.13  
            local t = basePred + ping/1000
            pos = pos + vel * t * (S.PredStr / 50)
        end
    end
    return pos
end


local saHooked = false
if hookfunction and newcclosure then
    pcall(function()
        local wsRaycast = Workspace.Raycast
        hookfunction(wsRaycast, newcclosure(function(self, origin, direction, params)
            if S.AimOn and self == Workspace 
            and typeof(origin) == (string.char(86,101,99,116,111,114,51)) 
            and typeof(direction) == (string.char(86,101,99,116,111,114,51))
            and direction.Magnitude > 50 then
                local target = getTarget()
                if target and target.Character and isAlive(target.Character) then
                    local aimPart = (S.AimHead and target.Character:FindFirstChild("Head"))
                                 or target.Character:FindFirstChild("UpperTorso")
                                 or target.Character:FindFirstChild("HumanoidRootPart")
                    if aimPart then
                        local tPos = getPredictedPos(aimPart)
                        local newDir = (tPos - origin).Unit * direction.Magnitude
                        if smoothedDir then
                            smoothedDir = smoothedDir:Lerp(newDir, 1 - S.AimSmooth)
                        else
                            smoothedDir = newDir
                        end
                        return wsRaycast(self, origin, smoothedDir, params)
                    end
                end
            end
            return wsRaycast(self, origin, direction, params)
        end))
        saHooked = true
    end)
end


UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        smoothedDir = nil
    end
end)


RunService.RenderStepped:Connect(function()
    if fovCircle then
        local m = UIS:GetMouseLocation()
        fovCircle.Position = m
        fovCircle.Radius   = getEffectiveFOV()
        fovCircle.Visible  = S.AimFOVShow
    end
    if not S.CamLock then return end
    local target = getTarget()
    if not(target and target.Character) then return end
    local part = (S.AimHead and target.Character:FindFirstChild("Head"))
              or target.Character:FindFirstChild("HumanoidRootPart")
    if not part then return end
    Camera.CFrame = Camera.CFrame:Lerp(
        CFrame.new(Camera.CFrame.Position, part.Position),
        math.clamp(S.CamSmooth, 0.01, 1)
    )
end)




RunService.Heartbeat:Connect(function()
    if not S.Triggerbot then return end
    local mouse = UIS:GetMouseLocation()
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP or not p.Character then continue end
        if not isEnemy(p) then continue end
        if not isAlive(p.Character) then continue end
        for _,part in ipairs(p.Character:GetDescendants()) do
            if not part:IsA("BasePart") then continue end
            local vp,on = Camera:WorldToViewportPoint(part.Position)
            if on and (Vector2.new(vp.X,vp.Y)-mouse).Magnitude < 12 then
                local delay = S.TrigDelay + math.random(-15,15)
                task.delay(delay/1000, function()
                    if mouse1press then
                        pcall(mouse1press); task.wait(0.04+math.random()*0.03)
                        pcall(mouse1release)
                    end
                end)
                return
            end
        end
    end
end)




local isFiring = false
local recoilConn
local lastCF = nil

UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not S.NoRecoil then return end
    isFiring = true
    lastCF = Camera.CFrame  
    recoilConn = RunService.RenderStepped:Connect(function()
        if not isFiring or not S.NoRecoil then
            if recoilConn then recoilConn:Disconnect(); recoilConn = nil end
            lastCF = nil
            return
        end
        local cf = Camera.CFrame
        local cy, cx, _ = cf:ToEulerAnglesYXZ()
        local _, bx, _ = lastCF:ToEulerAnglesYXZ()
        local dX = cx - bx
        
        if dX > 0.006 then
            local corrected = bx + (dX * (1 - S.RecoilReduce/100))
            corrected = math.clamp(corrected, bx - 0.01, bx + 0.05)
            Camera.CFrame = CFrame.new(cf.Position)
                * CFrame.fromEulerAnglesYXZ(corrected, cy, 0)
        end
        
        local _, nx, _ = Camera.CFrame:ToEulerAnglesYXZ()
        local _, lx, _ = lastCF:ToEulerAnglesYXZ()
        if nx < lx then  
            lastCF = Camera.CFrame
        end
    end)
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    isFiring = false
    lastCF = nil
    if recoilConn then recoilConn:Disconnect(); recoilConn = nil end
end)



local espD = {}

local BONES_R15 = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
}

local function initESP(p)
    if espD[p] or p==LP then return end
    local d = {
        corners = {},
        name    = newD("Text"),
        hpBG    = newD("Line"),
        hp      = newD("Line"),
        hpTxt   = newD("Text"),
        tracer  = newD("Line"),
        bones   = {},
        shield  = newD("Text"),  
    }
    for i=1,8 do
        local l = newD("Line")
        if l then l.Thickness=1.5; l.Visible=false end
        d.corners[i] = l
    end
    if d.name then
        d.name.Size=13; d.name.Center=true; d.name.Outline=true
        d.name.Color=C.White; d.name.Visible=false
    end
    if d.hpBG then
        d.hpBG.Thickness=4; d.hpBG.Color=Color3.fromRGB(22,22,22)
        d.hpBG.Visible=false
    end
    if d.hp then d.hp.Thickness=2.5; d.hp.Visible=false end
    if d.hpTxt then
        d.hpTxt.Size=10; d.hpTxt.Center=false; d.hpTxt.Outline=true
        d.hpTxt.Visible=false
    end
    if d.tracer then
        d.tracer.Thickness=1; d.tracer.Color=C.Accent
        d.tracer.Visible=false
    end
    
    if d.shield then
        d.shield.Size=12; d.shield.Center=false; d.shield.Outline=true
        d.shield.Color=C.ShieldCyan; d.shield.Visible=false
        d.shield.Text="S"
    end
    for i=1,#BONES_R15 do
        local l = newD("Line")
        if l then l.Color=Color3.fromRGB(255,255,255); l.Thickness=0.8; l.Visible=false end
        d.bones[i] = l
    end
    espD[p] = d
end


local function hideAllESP(d)
    if not d then return end
    for _,l in ipairs(d.corners) do if l then l.Visible=false end end
    if d.name   then d.name.Visible=false end
    if d.hpBG   then d.hpBG.Visible=false end
    if d.hp     then d.hp.Visible=false end
    if d.hpTxt  then d.hpTxt.Visible=false end
    if d.tracer then d.tracer.Visible=false end
    if d.shield then d.shield.Visible=false end
    for _,b in ipairs(d.bones) do if b then b.Visible=false end end
end

local espConnected = {}

local function clearESP(p)
    espConnected[p] = nil
    if not espD[p] then return end
    for _,v in pairs(espD[p]) do
        if type(v)==(string.char(116,97,98,108,101)) then
            for _,sub in pairs(v) do if sub and sub.Remove then pcall(function() sub:Remove() end) end end
        elseif v and v.Remove then pcall(function() v:Remove() end) end
    end
    espD[p]=nil
end


local function setupPlayerESP(p)
    if p == LP or espConnected[p] then return end
    espConnected[p] = true
    initESP(p)
    p.CharacterAdded:Connect(function()
        initESP(p)
    end)
    p.CharacterRemoving:Connect(function()
        if espD[p] then hideAllESP(espD[p]) end
    end)
end

Players.PlayerAdded:Connect(setupPlayerESP)
Players.PlayerRemoving:Connect(clearESP)

for _,p in ipairs(Players:GetPlayers()) do setupPlayerESP(p) end


local function getESPColor(p)
    if S.MatchMode == "Solo" then
        return C.Accent  
    end
    
    local myTC = getTeamColor(LP)
    local theirTC = getTeamColor(p)
    if myTC and theirTC and myTC == theirTC then
        return C.TeamBlue  
    else
        return C.Accent    
    end
end


local function shouldShowESP(p)
    if S.MatchMode == "Solo" then return true end
    local myTC = getTeamColor(LP)
    local theirTC = getTeamColor(p)
    if myTC and theirTC then
        local isTeammate = myTC == theirTC
        if isTeammate and not S.ESPTeam then return false end
    end
    return true
end


RunService.RenderStepped:Connect(function()
    local cx = Camera.ViewportSize.X / 2

    for p,d in pairs(espD) do
        local char = p.Character

        
        if not char or char.Parent == nil then hideAllESP(d); continue end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not hum or not root or root.Parent == nil then hideAllESP(d); continue end
        if hum.Health <= 0 then hideAllESP(d); continue end
        if hum:GetState() == Enum.HumanoidStateType.Dead then hideAllESP(d); continue end

        local anyOn = S.ESPCorner or S.ESPName or S.ESPHealth or S.ESPSkel or S.ESPTracer
        if not anyOn then hideAllESP(d); continue end

        
        if not shouldShowESP(p) then hideAllESP(d); continue end

        local rvp, onS = Camera:WorldToViewportPoint(root.Position)
        if not onS then hideAllESP(d); continue end

        local dist = rnd((root.Position - Camera.CFrame.Position).Magnitude)

        
        if dist > S.ESPMaxDist then hideAllESP(d); continue end

        local headTop = Camera:WorldToViewportPoint((head or root).Position + Vector3.new(0, 0.65, 0))
        local footBot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.1, 0))

        local h = math.abs(headTop.Y - footBot.Y)
        if h < 5 then hideAllESP(d); continue end
        local w = h * 0.5

        
        local espCol = getESPColor(p)
        local hp, maxhp = getHealth(char, hum)
        local pct = math.clamp(hp / maxhp, 0, 1)

        local cw = math.max(w * 0.2, 4)
        local ch = math.max(h * 0.2, 4)

        local x1 = rvp.X - w/2
        local y1 = headTop.Y
        local x2 = rvp.X + w/2
        local y2 = footBot.Y

        
        if S.ESPCorner then
            if d.corners[1] then d.corners[1].From=Vector2.new(x1,y1); d.corners[1].To=Vector2.new(x1+cw,y1); d.corners[1].Color=espCol; d.corners[1].Visible=true end
            if d.corners[2] then d.corners[2].From=Vector2.new(x1,y1); d.corners[2].To=Vector2.new(x1,y1+ch); d.corners[2].Color=espCol; d.corners[2].Visible=true end
            if d.corners[3] then d.corners[3].From=Vector2.new(x2,y1); d.corners[3].To=Vector2.new(x2-cw,y1); d.corners[3].Color=espCol; d.corners[3].Visible=true end
            if d.corners[4] then d.corners[4].From=Vector2.new(x2,y1); d.corners[4].To=Vector2.new(x2,y1+ch); d.corners[4].Color=espCol; d.corners[4].Visible=true end
            if d.corners[5] then d.corners[5].From=Vector2.new(x1,y2); d.corners[5].To=Vector2.new(x1+cw,y2); d.corners[5].Color=espCol; d.corners[5].Visible=true end
            if d.corners[6] then d.corners[6].From=Vector2.new(x1,y2); d.corners[6].To=Vector2.new(x1,y2-ch); d.corners[6].Color=espCol; d.corners[6].Visible=true end
            if d.corners[7] then d.corners[7].From=Vector2.new(x2,y2); d.corners[7].To=Vector2.new(x2-cw,y2); d.corners[7].Color=espCol; d.corners[7].Visible=true end
            if d.corners[8] then d.corners[8].From=Vector2.new(x2,y2); d.corners[8].To=Vector2.new(x2,y2-ch); d.corners[8].Color=espCol; d.corners[8].Visible=true end
        else
            for _,l in ipairs(d.corners) do if l then l.Visible=false end end
        end

        
        if d.name then
            if S.ESPName then
                d.name.Text    = p.Name.."  ["..dist.."m]"
                d.name.Position= Vector2.new(rvp.X, y1-16)
                local t = math.clamp(dist/200, 0, 1)
                local r = 255 - t*155
                d.name.Color = Color3.fromRGB(r, r, r)
                d.name.Visible = true
            else d.name.Visible=false end
        end

        
        if d.shield then
            if S.ESPName and hasShield(char) then
                d.shield.Position = Vector2.new(rvp.X + (#p.Name*3.5) + 30, y1-16)
                d.shield.Visible = true
            else
                d.shield.Visible = false
            end
        end

        
        if d.hpBG and d.hp then
            if S.ESPHealth then
                local barX = x1 - 6
                d.hpBG.From   = Vector2.new(barX, y2)
                d.hpBG.To     = Vector2.new(barX, y1)
                d.hpBG.Visible= true
                d.hp.From    = Vector2.new(barX, y2)
                d.hp.To      = Vector2.new(barX, y2 - h*pct)
                d.hp.Color   = Color3.fromHSV(pct * 0.33, 1, 1)
                d.hp.Visible = true
                if d.hpTxt then
                    d.hpTxt.Text    = tostring(rnd(hp))
                    d.hpTxt.Position= Vector2.new(barX - 4, y2 - h*pct - 6)
                    d.hpTxt.Color   = Color3.fromHSV(pct * 0.33, 1, 1)
                    d.hpTxt.Visible = true
                end
            else
                d.hpBG.Visible=false; d.hp.Visible=false
                if d.hpTxt then d.hpTxt.Visible=false end
            end
        end

        
        if d.tracer then
            if S.ESPTracer then
                d.tracer.From   = Vector2.new(cx, Camera.ViewportSize.Y)
                d.tracer.To     = Vector2.new(rvp.X, y2)
                d.tracer.Color  = espCol
                d.tracer.Visible= true
            else d.tracer.Visible=false end
        end

        
        for i, bp in ipairs(BONES_R15) do
            local b = d.bones[i]
            if not b then continue end
            
            
            if not S.ESPSkel or not shouldShowESP(p) then
                b.Visible = false
                continue
            end
            
            local bpart1 = char:FindFirstChild(bp[1])
            local bpart2 = char:FindFirstChild(bp[2])
            if bpart1 and bpart2 then
                local v1 = Camera:WorldToViewportPoint(bpart1.Position)
                local v2 = Camera:WorldToViewportPoint(bpart2.Position)
                b.From      = Vector2.new(v1.X, v1.Y)
                b.To        = Vector2.new(v2.X, v2.Y)
                b.Color     = espCol  
                b.Thickness = 1
                b.Visible   = true
            else
                b.Visible = false
            end
        end
    end
end)




local function roundEndCleanup()
    for p, d in pairs(espD) do
        hideAllESP(d)
    end
    currentTarget = nil
    smoothedDir = nil
    lastCF = nil
    if recoilConn then recoilConn:Disconnect(); recoilConn = nil end
    toast("Round ended — reset", C.AccentHi)
end


task.spawn(function()
    task.wait(2)  
    if S.RoundEndEvent ~= "" then
        local ev = RepStorage:FindFirstChild(S.RoundEndEvent)
        if ev and ev:IsA("RemoteEvent") then
            ev.OnClientEvent:Connect(roundEndCleanup)
            print((string.char(91,84,45,72,85,66,93,32,72,111,111,107,101,100,32,114,111,117,110,100,32,101,110,100,32,101,118,101,110,116,58)), S.RoundEndEvent)
        else
            print((string.char(91,84,45,72,85,66,93,32,82,111,117,110,100,32,101,110,100,32,101,118,101,110,116,32,110,111,116,32,102,111,117,110,100,58)), S.RoundEndEvent)
        end
    end
end)




local bhopConn
local function doBHop(state)
    if bhopConn then bhopConn:Disconnect(); bhopConn=nil end
    if not state then return end
    local hum=getHum(); if not hum then return end
    bhopConn = hum.StateChanged:Connect(function(_,new)
        if new==Enum.HumanoidStateType.Landed
        and UIS:IsKeyDown(Enum.KeyCode.Space) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end




LP.Idled:Connect(function()
    if S.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)




local fpsSG = make("ScreenGui",{Name="THUB_FPS",ResetOnSpawn=false,
    DisplayOrder=997,IgnoreGuiInset=true},GuiParent)
local fpsLbl = make("TextLabel",{
    Text=(string.char(70,80,83,58,32,48)),Font=Enum.Font.GothamBold,TextSize=12,
    TextColor3=C.Accent,BackgroundTransparency=1,
    Size=UDim2.new(0,80,0,18),Position=UDim2.new(1,-90,0,6),
    TextXAlignment=Enum.TextXAlignment.Right,
    Visible=false,
},fpsSG)
local fpsN=0
RunService.RenderStepped:Connect(function() fpsN=fpsN+1 end)
task.spawn(function()
    while true do task.wait(1)
        if S.FPSCount then fpsLbl.Text=(string.char(70,80,83,58,32))..fpsN end
        fpsN=0
    end
end)



local mainSG = make("ScreenGui",{
    Name="THUB_Main",ResetOnSpawn=false,
    DisplayOrder=100,IgnoreGuiInset=true,
},GuiParent)

local W,H = 480,360
local mainF = make("Frame",{
    BackgroundColor3=C.BG,BorderSizePixel=0,
    AnchorPoint=Vector2.new(0.5,0.5),
    Position=UDim2.new(0.5,0,0.5,0),
    Size=UDim2.new(0,W,0,H),
    ClipsDescendants=true,
},mainSG)
make("UICorner",{CornerRadius=UDim.new(0,10)},mainF)



local TH=40
local topF = make("Frame",{
    BackgroundColor3=C.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(1,0,0,TH),ZIndex=3,
},mainF)
make("UICorner",{CornerRadius=UDim.new(0,10)},topF)
make("Frame",{BackgroundColor3=C.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,1,-10),ZIndex=3},topF)
make("Frame",{BackgroundColor3=C.Accent,BorderSizePixel=0,
    Size=UDim2.new(0,3,0,22),Position=UDim2.new(0,0,0.5,-11),ZIndex=4},topF)
make("TextLabel",{Text=(string.char(84,45,72,85,66)),Font=Enum.Font.GothamBlack,TextSize=14,
    TextColor3=C.White,BackgroundTransparency=1,
    Size=UDim2.new(0,55,1,0),Position=UDim2.new(0,10,0,0),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4},topF)
make("TextLabel",{Text=(string.char(65,114,115,101,110,97,108,32,86,73,80)),Font=Enum.Font.GothamBold,TextSize=12,
    TextColor3=C.Accent,BackgroundTransparency=1,
    Size=UDim2.new(0,75,1,0),Position=UDim2.new(0,65,0,0),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4},topF)
make("TextLabel",{Text="RShift  ·  toggle",Font=Enum.Font.Gotham,TextSize=10,
    TextColor3=C.TextDim,BackgroundTransparency=1,
    Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,0,0,0),
    TextXAlignment=Enum.TextXAlignment.Right,ZIndex=4},topF)


local hookStatus = make("Frame",{
    Size=UDim2.new(0,8,0,8),AnchorPoint=Vector2.new(0,0.5),
    Position=UDim2.new(0,150,0.5,0),BorderSizePixel=0,
    BackgroundColor3=saHooked and Color3.fromRGB(60,210,80) or Color3.fromRGB(200,50,50),
    ZIndex=5,
},topF)
make("UICorner",{CornerRadius=UDim.new(1,0)},hookStatus)
make("TextLabel",{
    Text=saHooked and "hook ✓" or "hook ✗",
    Font=Enum.Font.Gotham,TextSize=9,
    TextColor3=saHooked and Color3.fromRGB(60,210,80) or Color3.fromRGB(200,50,50),
    BackgroundTransparency=1,
    Size=UDim2.new(0,45,1,0),Position=UDim2.new(0,162,0,0),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
},topF)


local SBH = 18
local statusBar = make("Frame",{
    BackgroundColor3=C.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(1,0,0,SBH),
    Position=UDim2.new(0,0,1,-SBH),
    ZIndex=3,
},mainF)
make("UICorner",{CornerRadius=UDim.new(0,10)},statusBar)
make("Frame",{BackgroundColor3=C.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,0,0),ZIndex=3},statusBar)
local statusLbl = make("TextLabel",{
    Text="",Font=Enum.Font.GothamMedium,TextSize=10,
    TextColor3=C.TextDim,BackgroundTransparency=1,
    Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,
},statusBar)


task.spawn(function()
    while true do
        task.wait(0.5)
        local parts = {}
        
        table.insert(parts, S.MatchMode)
        if S.AimOn     then table.insert(parts, "SA") end
        if S.CamLock   then table.insert(parts, "CL") end
        if S.HitboxOn  then table.insert(parts, "HB") end
        if S.NoRecoil  then table.insert(parts, "NR") end
        if S.Triggerbot then table.insert(parts, "TB") end
        if S.BHop      then table.insert(parts, "BH") end
        if S.ESPCorner then table.insert(parts, "ESP") end
        if S.ESPSkel   then table.insert(parts, (string.char(83,107,101,108))) end
        
        if S.AimOn and currentTarget then
            table.insert(parts, "→ "..currentTarget.Name)
        end
        if #parts > 0 then
            statusLbl.Text = table.concat(parts, "  ·  ")
            statusLbl.TextColor3 = C.Accent
        else
            statusLbl.Text = (string.char(97,108,108,32,111,102,102))
            statusLbl.TextColor3 = C.TextDim
        end
    end
end)


local dOn,dStart,dPos
topF.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
        dOn=true; dStart=i.Position; dPos=mainF.Position
        i.Changed:Connect(function()
            if i.UserInputState==Enum.UserInputState.End then dOn=false end
        end)
    end
end)
UIS.InputChanged:Connect(function(i)
    if dOn and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d=i.Position-dStart
        mainF.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,
                                  dPos.Y.Scale,dPos.Y.Offset+d.Y)
    end
end)

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then
        mainF.Visible=not mainF.Visible
    end
    if i.KeyCode==Enum.KeyCode.CapsLock then
        S.AimOn=not S.AimOn
        toast(S.AimOn and (string.char(83,105,108,101,110,116,32,65,105,109,32,79,78)) or (string.char(83,105,108,101,110,116,32,65,105,109,32,79,70,70)),
              S.AimOn and C.AccentHi or C.TextDim)
    end
end)


local SW=145
local sideF = make("Frame",{
    BackgroundColor3=C.Sidebar,BorderSizePixel=0,
    Position=UDim2.new(0,0,0,TH),
    Size=UDim2.new(0,SW,1,-TH),
},mainF)
make("UICorner",{CornerRadius=UDim.new(0,10)},sideF)
make("Frame",{BackgroundColor3=C.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,0,0)},sideF)
make("Frame",{BackgroundColor3=C.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(0,10,1,0),Position=UDim2.new(1,-10,0,0)},sideF)

local navScroll = make("ScrollingFrame",{
    BackgroundTransparency=1,
    Position=UDim2.new(0,0,0,6),
    Size=UDim2.new(1,0,1,-6),
    ScrollBarThickness=0,
    CanvasSize=UDim2.new(0,0,0,0),
    BorderSizePixel=0,
},sideF)
local navLayout = make("UIListLayout",{
    SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3),
},navScroll)
make("UIPadding",{PaddingTop=UDim.new(0,4),
    PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)},navScroll)
navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    navScroll.CanvasSize=UDim2.new(0,0,0,navLayout.AbsoluteContentSize.Y+8)
end)

local contentF = make("Frame",{
    BackgroundTransparency=1,
    Position=UDim2.new(0,SW,0,TH),
    Size=UDim2.new(1,-SW,1,-TH-SBH),
},mainF)




local activTab=nil; local allTabs={}

local function Tab(label)
    local btn=make("TextButton",{
        Text="",BackgroundTransparency=1,
        BackgroundColor3=C.Sidebar,BorderSizePixel=0,
        Size=UDim2.new(1,0,0,32),AutoButtonColor=false,
    },navScroll)
    make("UICorner",{CornerRadius=UDim.new(0,7)},btn)

    local bar=make("Frame",{
        BackgroundColor3=C.Accent,BorderSizePixel=0,
        Size=UDim2.new(0,3,0.55,0),
        AnchorPoint=Vector2.new(0,0.5),
        Position=UDim2.new(0,0,0.5,0),
        BackgroundTransparency=1,
    },btn)
    make("UICorner",{CornerRadius=UDim.new(0,2)},bar)

    local lbl=make("TextLabel",{
        Text=label,Font=Enum.Font.GothamMedium,TextSize=12,
        TextColor3=C.TextDim,BackgroundTransparency=1,
        Size=UDim2.new(1,-10,1,0),
        Position=UDim2.new(0,12,0,0),
        TextXAlignment=Enum.TextXAlignment.Left,
    },btn)

    local page=make("ScrollingFrame",{
        BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),
        ScrollBarThickness=2,ScrollBarImageColor3=C.TextDim,
        CanvasSize=UDim2.new(0,0,0,0),Visible=false,BorderSizePixel=0,
    },contentF)
    local pageLayout=make("UIListLayout",{
        SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),
    },page)
    make("UIPadding",{
        PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10),
        PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),
    },page)
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize=UDim2.new(0,0,0,pageLayout.AbsoluteContentSize.Y+20)
    end)

    local td={btn=btn,bar=bar,lbl=lbl,page=page}
    table.insert(allTabs,td)

    local function activate()
        if activTab==td then return end
        if activTab then
            tw(activTab.btn,{BackgroundTransparency=1},0.14)
            tw(activTab.lbl,{TextColor3=C.TextDim},0.14)
            tw(activTab.bar,{BackgroundTransparency=1},0.14)
            activTab.page.Visible=false
        end
        activTab=td
        tw(btn,{BackgroundTransparency=0.87},0.14)
        tw(lbl,{TextColor3=C.White},0.14)
        tw(bar,{BackgroundTransparency=0},0.14)
        page.Visible=true
    end

    btn.MouseButton1Click:Connect(activate)
    btn.MouseEnter:Connect(function() if activTab~=td then tw(btn,{BackgroundTransparency=0.93},0.1) end end)
    btn.MouseLeave:Connect(function() if activTab~=td then tw(btn,{BackgroundTransparency=1},0.1) end end)
    if #allTabs==1 then activate() end

    local T={}

    function T:Section(text)
        local frame = make("Frame",{
            BackgroundTransparency=1,
            Size=UDim2.new(1,0,0,8),
        },page)
        make("Frame",{
            BackgroundColor3=Color3.fromRGB(30,30,30),
            BorderSizePixel=0,
            Size=UDim2.new(1,0,0,1),
            AnchorPoint=Vector2.new(0,0.5),
            Position=UDim2.new(0,0,0.5,0)
        },frame)
    end

    function T:Toggle(text, default, cb)
        local state=default or false
        local card=make("Frame",{BackgroundColor3=C.Card,BorderSizePixel=0,
            Size=UDim2.new(1,0,0,32)},page)
        make("UICorner",{CornerRadius=UDim.new(0,8)},card)
        card.MouseEnter:Connect(function() tw(card,{BackgroundColor3=C.CardHov},0.1) end)
        card.MouseLeave:Connect(function() tw(card,{BackgroundColor3=C.Card},0.1) end)
        make("TextLabel",{Text=text,Font=Enum.Font.GothamMedium,TextSize=12,
            TextColor3=C.Text,BackgroundTransparency=1,
            Size=UDim2.new(1,-48,1,0),Position=UDim2.new(0,44,0,0),
            TextXAlignment=Enum.TextXAlignment.Left},card)
        local track=make("Frame",{
            BackgroundColor3=state and C.Accent or C.TogOff,
            BorderSizePixel=0,Size=UDim2.new(0,28,0,16),
            AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,8,0.5,0)},card)
        make("UICorner",{CornerRadius=UDim.new(1,0)},track)
        local knob=make("Frame",{BackgroundColor3=C.White,BorderSizePixel=0,
            Size=UDim2.new(0,12,0,12),AnchorPoint=Vector2.new(0,0.5),
            Position=state and UDim2.new(1,-14,0.5,0) or UDim2.new(0,2,0.5,0)},track)
        make("UICorner",{CornerRadius=UDim.new(1,0)},knob)
        make("TextButton",{Text="",BackgroundTransparency=1,
            Size=UDim2.new(1,0,1,0)},card).MouseButton1Click:Connect(function()
            state=not state
            tw(track,{BackgroundColor3=state and C.Accent or C.TogOff},0.16)
            tw(knob,{Position=state and UDim2.new(1,-14,0.5,0) or UDim2.new(0,2,0.5,0)},0.16)
            if cb then cb(state) end
        end)
    end
    function T:DualToggleBtn(text1, default1, cb1, text2, cb2)
        local state=default1 or false
        local card=make("Frame",{BackgroundColor3=C.Card,BorderSizePixel=0,
            Size=UDim2.new(1,0,0,36)},page)
        make("UICorner",{CornerRadius=UDim.new(0,8)},card)
        card.MouseEnter:Connect(function() tw(card,{BackgroundColor3=C.CardHov},0.1) end)
        card.MouseLeave:Connect(function() tw(card,{BackgroundColor3=C.Card},0.1) end)
        
        
        local track=make("Frame",{
            BackgroundColor3=state and C.Accent or C.TogOff,
            BorderSizePixel=0,Size=UDim2.new(0,28,0,16),
            AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,8,0.5,0)},card)
        make("UICorner",{CornerRadius=UDim.new(1,0)},track)
        local knob=make("Frame",{BackgroundColor3=C.White,BorderSizePixel=0,
            Size=UDim2.new(0,12,0,12),AnchorPoint=Vector2.new(0,0.5),
            Position=state and UDim2.new(1,-14,0.5,0) or UDim2.new(0,2,0.5,0)},track)
        make("UICorner",{CornerRadius=UDim.new(1,0)},knob)
        make("TextLabel",{Text=text1,Font=Enum.Font.GothamMedium,TextSize=12,
            TextColor3=C.Text,BackgroundTransparency=1,
            Size=UDim2.new(0.5,-48,1,0),Position=UDim2.new(0,44,0,0),
            TextXAlignment=Enum.TextXAlignment.Left},card)
        local tBtn=make("TextButton",{Text="",BackgroundTransparency=1,
            Size=UDim2.new(0.5,0,1,0)},card)
        tBtn.MouseButton1Click:Connect(function()
            state=not state
            tw(track,{BackgroundColor3=state and C.Accent or C.TogOff},0.16)
            tw(knob,{Position=state and UDim2.new(1,-14,0.5,0) or UDim2.new(0,2,0.5,0)},0.16)
            if cb1 then cb1(state) end
        end)
        
        
        local rb=make("TextButton",{Text=text2,Font=Enum.Font.GothamBold,TextSize=11,
            TextColor3=C.White,BackgroundColor3=C.Accent,BorderSizePixel=0,
            Size=UDim2.new(0.4,0,0,24),AnchorPoint=Vector2.new(1,0.5),
            Position=UDim2.new(1,-8,0.5,0),AutoButtonColor=false},card)
        make("UICorner",{CornerRadius=UDim.new(0,6)},rb)
        rb.MouseEnter:Connect(function() tw(rb,{BackgroundColor3=C.AccentHi},0.1) end)
        rb.MouseLeave:Connect(function() tw(rb,{BackgroundColor3=C.Accent},0.1) end)
        rb.MouseButton1Click:Connect(function()
            tw(rb,{Size=UDim2.new(0.4,-4,0,22)},0.07)
            task.delay(0.08,function() tw(rb,{Size=UDim2.new(0.4,0,0,24)},0.1) end)
            if cb2 then cb2(rb) end
        end)
    end

    function T:Slider(text, min, max, default, cb)
        local val=math.clamp(default,min,max)
        local card=make("Frame",{BackgroundColor3=C.Card,BorderSizePixel=0,
            Size=UDim2.new(1,0,0,44)},page)
        make("UICorner",{CornerRadius=UDim.new(0,8)},card)
        card.MouseEnter:Connect(function() tw(card,{BackgroundColor3=C.CardHov},0.1) end)
        card.MouseLeave:Connect(function() tw(card,{BackgroundColor3=C.Card},0.1) end)
        make("TextLabel",{Text=text,Font=Enum.Font.GothamMedium,TextSize=12,
            TextColor3=C.Text,BackgroundTransparency=1,
            Size=UDim2.new(1,-60,0,22),Position=UDim2.new(0,10,0,3),
            TextXAlignment=Enum.TextXAlignment.Left},card)
        local valLbl=make("TextLabel",{Text=tostring(val),Font=Enum.Font.GothamBold,
            TextSize=10,TextColor3=C.Accent,BackgroundTransparency=1,
            Size=UDim2.new(0,48,0,22),Position=UDim2.new(1,-58,0,3),
            TextXAlignment=Enum.TextXAlignment.Right},card)
        local trk=make("Frame",{BackgroundColor3=C.TogOff,BorderSizePixel=0,
            Size=UDim2.new(1,-20,0,3),Position=UDim2.new(0,10,0,28)},card)
        make("UICorner",{CornerRadius=UDim.new(1,0)},trk)
        local fill=make("Frame",{BackgroundColor3=C.Accent,BorderSizePixel=0,
            Size=UDim2.new((val-min)/(max-min),0,1,0)},trk)
        make("UICorner",{CornerRadius=UDim.new(1,0)},fill)
        local knob2=make("Frame",{BackgroundColor3=C.White,BorderSizePixel=0,
            Size=UDim2.new(0,10,0,10),AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.new((val-min)/(max-min),0,0.5,0)},trk)
        make("UICorner",{CornerRadius=UDim.new(1,0)},knob2)
        local sliding=false
        local function upd(x)
            local r=math.clamp((x-trk.AbsolutePosition.X)/trk.AbsoluteSize.X,0,1)
            val=math.floor(min+(max-min)*r)
            valLbl.Text=tostring(val)
            fill.Size=UDim2.new(r,0,1,0)
            knob2.Position=UDim2.new(r,0,0.5,0)
            if cb then cb(val) end
        end
        card.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true; upd(i.Position.X) end
        end)
        UIS.InputChanged:Connect(function(i)
            if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i.Position.X) end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
        end)
    end

    function T:Button(text, cb)
        local card=make("Frame",{BackgroundColor3=C.Card,BorderSizePixel=0,
            Size=UDim2.new(1,0,0,36)},page)
        make("UICorner",{CornerRadius=UDim.new(0,8)},card)
        card.MouseEnter:Connect(function() tw(card,{BackgroundColor3=C.CardHov},0.1) end)
        card.MouseLeave:Connect(function() tw(card,{BackgroundColor3=C.Card},0.1) end)
        local lbl=make("TextLabel",{Text=text,Font=Enum.Font.GothamMedium,TextSize=12,
            TextColor3=C.Text,BackgroundTransparency=1,
            Size=UDim2.new(1,-78,1,0),Position=UDim2.new(0,10,0,0),
            TextXAlignment=Enum.TextXAlignment.Left},card)
        local rb=make("TextButton",{Text="RUN",Font=Enum.Font.GothamBold,TextSize=11,
            TextColor3=C.White,BackgroundColor3=C.Accent,BorderSizePixel=0,
            Size=UDim2.new(0,52,0,24),AnchorPoint=Vector2.new(1,0.5),
            Position=UDim2.new(1,-10,0.5,0),AutoButtonColor=false},card)
        make("UICorner",{CornerRadius=UDim.new(0,6)},rb)
        rb.MouseEnter:Connect(function() tw(rb,{BackgroundColor3=C.AccentHi},0.1) end)
        rb.MouseLeave:Connect(function() tw(rb,{BackgroundColor3=C.Accent},0.1) end)
        rb.MouseButton1Click:Connect(function()
            tw(rb,{Size=UDim2.new(0,48,0,22)},0.07)
            task.delay(0.08,function() tw(rb,{Size=UDim2.new(0,52,0,24)},0.1) end)
            if cb then cb(lbl) end
        end)
        return card, lbl
    end

    function T:Label(text, val)
        local card=make("Frame",{BackgroundColor3=C.Card,BorderSizePixel=0,
            Size=UDim2.new(1,0,0,32)},page)
        make("UICorner",{CornerRadius=UDim.new(0,8)},card)
        make("TextLabel",{Text=text,Font=Enum.Font.GothamMedium,TextSize=12,
            TextColor3=C.Text,BackgroundTransparency=1,
            Size=UDim2.new(1,-90,1,0),Position=UDim2.new(0,10,0,0),
            TextXAlignment=Enum.TextXAlignment.Left},card)
        if val then
            make("TextLabel",{Text=val,Font=Enum.Font.GothamBold,TextSize=11,
                TextColor3=C.Accent,BackgroundTransparency=1,
                Size=UDim2.new(0,80,1,0),AnchorPoint=Vector2.new(1,0),
                Position=UDim2.new(1,-10,0,0),
                TextXAlignment=Enum.TextXAlignment.Right},card)
        end
    end

    return T
end





local tC = Tab("⚔ Combat")
tC:Toggle((string.char(83,105,108,101,110,116,32,65,105,109,32,32,91,67,97,112,115,76,111,99,107,93)), false, function(v)
    S.AimOn=v
    toast(v and (string.char(83,105,108,101,110,116,32,65,105,109,32,79,78)) or (string.char(83,105,108,101,110,116,32,65,105,109,32,79,70,70)), v and C.AccentHi or C.TextDim)
end)
tC:Slider((string.char(70,79,86,32,83,105,122,101)),      20, 150, 120, function(v) S.AimFOV=v end)
tC:Toggle((string.char(83,104,111,119,32,70,79,86,32,67,105,114,99,108,101)),   false, function(v) S.AimFOVShow=v end)

tC:Section("")
tC:Toggle((string.char(65,105,109,32,97,116,32,72,101,97,100)),       true,  function(v) S.AimHead=v end)
tC:Toggle((string.char(84,101,97,109,32,67,104,101,99,107)),        false, function(v) S.AimTeam=v end)
tC:Toggle((string.char(86,105,115,105,98,105,108,105,116,121,32,67,104,101,99,107)),  true,  function(v) S.AimVis=v end)

tC:Section("")
tC:Slider((string.char(65,105,109,32,83,109,111,111,116,104,32,37)),  50, 95, 85, function(v) S.AimSmooth=v/100 end)

tC:Section("")
tC:Toggle((string.char(76,101,97,100,32,83,104,111,116)), false, function(v) S.Prediction=v end)
tC:Slider((string.char(80,114,101,100,32,83,116,114,101,110,103,116,104)), 0, 100, 50, function(v) S.PredStr=v end)

tC:Section("")
tC:Toggle((string.char(78,111,32,82,101,99,111,105,108)), false, function(v)
    S.NoRecoil=v; lastCF=nil
    toast(v and ((string.char(78,111,32,82,101,99,111,105,108,32,79,78,32,32,40))..S.RecoilReduce.."%)") or (string.char(78,111,32,82,101,99,111,105,108,32,79,70,70)))
end)
tC:Slider((string.char(82,101,99,111,105,108,32,82,101,100,117,99,101,32,37)), 30, 90, 65, function(v) S.RecoilReduce=v end)
tC:Toggle((string.char(84,114,105,103,103,101,114,98,111,116)), false, function(v)
    S.Triggerbot=v
    toast(v and (string.char(84,114,105,103,103,101,114,98,111,116,32,79,78)) or (string.char(84,114,105,103,103,101,114,98,111,116,32,79,70,70)))
end)
tC:Slider((string.char(84,114,105,103,103,101,114,32,68,101,108,97,121,32,40,109,115,41)), 40, 200, 80, function(v) S.TrigDelay=v end)

tC:Section("")
tC:Toggle((string.char(67,97,109,101,114,97,32,76,111,99,107)), false, function(v) S.CamLock=v end)
tC:Slider((string.char(76,111,99,107,32,83,109,111,111,116,104,110,101,115,115)),  1, 20, 8, function(v) S.CamSmooth=v/100 end)
tC:Toggle((string.char(72,105,116,98,111,120,32,69,120,116,101,110,100)), false, function(v)
    S.HitboxOn=v
    toast(v and ("Hitbox ON  ×"..string.format((string.char(37,46,49,102)),S.HitboxMult)) or (string.char(72,105,116,98,111,120,32,79,70,70)))
end)
tC:Slider((string.char(70,79,86,32,77,117,108,116,105,112,108,105,101,114)), 10, 50, 20, function(v) S.HitboxMult=v/10 end)

tC:Section("")
tC:Toggle((string.char(66,117,110,110,121,32,72,111,112)), false, function(v) S.BHop=v; doBHop(v) end)


local tV = Tab("👁 Visuals")
tV:Toggle((string.char(67,111,114,110,101,114,32,66,111,120)),    false, function(v) S.ESPCorner=v end)
tV:Toggle((string.char(78,97,109,101,115,32,43,32,68,105,115,116)),  false, function(v) S.ESPName=v end)
tV:Toggle((string.char(72,101,97,108,116,104,32,66,97,114)),    false, function(v) S.ESPHealth=v end)
tV:Toggle((string.char(83,107,101,108,101,116,111,110)),      false, function(v) S.ESPSkel=v end)
tV:Toggle((string.char(84,114,97,99,101,114,115)),       false, function(v) S.ESPTracer=v end)

tV:Section("")
tV:Slider((string.char(77,97,120,32,69,83,80,32,68,105,115,116)), 50, 1000, 500, function(v) S.ESPMaxDist=v end)

tV:Section("")
local modeList = {"Solo","Teams"}
local modeIdx = 1
tV:DualToggleBtn((string.char(83,104,111,119,32,84,101,97,109,32,69,83,80)), true, function(v)
    S.ESPTeam=v
    toast(v and (string.char(84,101,97,109,32,69,83,80,32,115,104,111,119,110)) or (string.char(84,101,97,109,32,69,83,80,32,104,105,100,100,101,110)))
end, (string.char(77,111,100,101,58,32))..S.MatchMode, function(btn)
    modeIdx = (modeIdx % #modeList) + 1
    S.MatchMode = modeList[modeIdx]
    if btn then btn.Text = (string.char(77,111,100,101,58,32))..S.MatchMode end
    toast((string.char(77,111,100,101,58,32))..S.MatchMode, C.AccentHi)
end)

tV:Section("")
tV:Toggle((string.char(70,80,83,32,67,111,117,110,116,101,114)),  false, function(v) S.FPSCount=v; fpsLbl.Visible=v end)
tV:Toggle((string.char(70,80,83,32,85,110,108,111,99,107,101,114)), false, function(v)
    if setfpscap then pcall(setfpscap, v and 9999 or 60) end
end)


local tS = Tab("⚙ Settings")
tS:Toggle((string.char(65,110,116,105,45,65,70,75)), false, function(v) S.AntiAFK=v end)
tS:Button((string.char(82,101,106,111,105,110)), function()
    pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId,LP) end)
end)
tS:Button((string.char(67,111,112,121,32,71,97,109,101,32,73,68)), function()
    if setclipboard then pcall(setclipboard,tostring(game.PlaceId)) end
    toast((string.char(71,97,109,101,32,73,68,32,99,111,112,105,101,100,33)))
end)
tS:Button((string.char(83,99,97,110,32,82,111,117,110,100,32,69,118,101,110,116,115)), function()
    local found = {}
    for _,v in ipairs(RepStorage:GetChildren()) do
        if v:IsA("RemoteEvent") then
            table.insert(found, v.Name)
            print((string.char(91,84,45,72,85,66,93,32,82,101,109,111,116,101,69,118,101,110,116,58)), v.Name)
        end
    end
    toast((string.char(70,111,117,110,100,32))..#found.." events — check console")
end)

tS:Section("")
tS:Label((string.char(84,111,103,103,108,101,32,72,117,98)),        "RightShift")
tS:Label((string.char(84,111,103,103,108,101,32,83,105,108,101,110,116,32,65,105,109)), "CapsLock")

tS:Section("")
tS:Label((string.char(86,101,114,115,105,111,110)),  (string.char(118,53,46,48,32,86,73,80)))
tS:Label((string.char(67,114,101,97,116,111,114)),  (string.char(116,114,105,120,120,115,111,98,97,115,101,100)))
tS:Label((string.char(69,120,101,99,117,116,111,114)), (string.char(88,101,110,111)))
tS:Label((string.char(84,97,114,103,101,116)),   (string.char(65,114,115,101,110,97,108)))


toast((string.char(84,45,72,85,66,32,118,53,46,48,32,86,73,80,32,108,111,97,100,101,100)) .. (saHooked and "  ✓" or (string.char(32,32,104,111,111,107,32,102,97,105,108))),
      saHooked and C.AccentHi or Color3.fromRGB(255,80,80))
print((string.char(91,84,45,72,85,66,93,32,118,53,46,48,32,86,73,80,32,124,32,65,114,115,101,110,97,108,32,124,32,104,111,111,107,58)), saHooked)