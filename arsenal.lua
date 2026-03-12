-- Obfuscated by custom encoder
--[[
  ████████╗      ██╗  ██╗██╗   ██╗██████╗
     ██╔══╝      ██║  ██║██║   ██║██╔══██╗
     ██║   █████╗███████║██║   ██║██████╔╝
     ██║   ╚════╝██╔══██║██║   ██║██╔══██╗
     ██║         ██║  ██║╚██████╔╝██████╔╝
     ╚═╝         ╚═╝  ╚═╝ ╚═════╝ ╚═════╝
  _ZrDbseHl-HUB v5.0 VIP | Arsenal | trixxsobased
  Executor : Xeno _grbvpmsA.3.25b+
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
  - Status _sswDsiwW: mode + _FOpeQCzG name
  - Silent aim: Raycast-only hook, removed legacy ray hooks
  - AimSmooth lerp for human-like aiming
  - Round end auto-cleanup
]]




local Players      = game:GetService(string.char(80,108,97,121,101,114,115))
local _HuJHNeLX          = game:GetService(string.char(85,115,101,114,73,110,112,117,116,83,101,114,118,105,99,101))
local _UUeBfevn     = game:GetService(string.char(84,119,101,101,110,83,101,114,118,105,99,101))
local RunService   = game:GetService(string.char(82,117,110,83,101,114,118,105,99,101))
local Lighting     = game:GetService(string.char(76,105,103,104,116,105,110,103))
local VirtualUser  = game:GetService(string.char(86,105,114,116,117,97,108,85,115,101,114))
local Workspace    = game:GetService(string.char(87,111,114,107,115,112,97,99,101))
local _NwuZcdFB   = game:GetService(string.char(82,101,112,108,105,99,97,116,101,100,83,116,111,114,97,103,101))

local _UeJdHgxc     = Players.LocalPlayer
local _udVNXJtv = Workspace.CurrentCamera

local _OMEsNFAx = (gethui and gethui()) or game:GetService(string.char(67,111,114,101,71,117,105))




local _UpPgzDlS = {
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




local _hiyOLKmJ = {
    
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
    MatchMode   = string.char(83,111,108,111),     
    FPSCount    = false,
    FPSUnlock   = false,
    
    AntiAFK     = false,
    RoundEndEvent = string.char(66,108,97,110,107),  
}


local _SfVkUVJr = nil     
local _zEsrtlNN   = nil     




local function _zJTZRRsn() return _UeJdHgxc.Character end
local function _CeIuIUwQ()  local _sSHKYudf=_zJTZRRsn(); return _sSHKYudf and _sSHKYudf:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100)) end

local function _lyvlTKhk(_CdcucxoB, _WzrgHGkD)
    
    local _YHazxQkY = _CdcucxoB:FindFirstChild(string.char(72,80)) 
               or _CdcucxoB:FindFirstChild(string.char(72,101,97,108,116,104))
               or _CdcucxoB:FindFirstChild(string.char(104,112))
    if _YHazxQkY and (_YHazxQkY:IsA(string.char(78,117,109,98,101,114,86,97,108,117,101)) or _YHazxQkY:IsA(string.char(73,110,116,86,97,108,117,101))) then
        local _woWgwywO = _CdcucxoB:FindFirstChild(string.char(77,97,120,72,80)) 
                   or _CdcucxoB:FindFirstChild(string.char(77,97,120,72,101,97,108,116,104))
        local _sqttqRmu = (_woWgwywO and _woWgwywO.Value) or _WzrgHGkD.MaxHealth or 100
        return _YHazxQkY.Value, _sqttqRmu
    end
    
    local _DhoDzzNJ = _WzrgHGkD:GetAttribute(string.char(72,80)) or _WzrgHGkD:GetAttribute(string.char(72,101,97,108,116,104))
    if _DhoDzzNJ then
        return _DhoDzzNJ, _WzrgHGkD.MaxHealth or 100
    end
    
    return _WzrgHGkD.Health, _WzrgHGkD.MaxHealth
end

local function _lyvlTKhk(_CdcucxoB, _WzrgHGkD)
    
    local _YHazxQkY = _CdcucxoB:FindFirstChild(string.char(72,80)) 
               or _CdcucxoB:FindFirstChild(string.char(72,101,97,108,116,104))
               or _CdcucxoB:FindFirstChild(string.char(104,112))
    if _YHazxQkY and (_YHazxQkY:IsA(string.char(78,117,109,98,101,114,86,97,108,117,101)) or _YHazxQkY:IsA(string.char(73,110,116,86,97,108,117,101))) then
        local _woWgwywO = _CdcucxoB:FindFirstChild(string.char(77,97,120,72,80)) 
                   or _CdcucxoB:FindFirstChild(string.char(77,97,120,72,101,97,108,116,104))
        local _sqttqRmu = (_woWgwywO and _woWgwywO.Value) or _WzrgHGkD.MaxHealth or 100
        return _YHazxQkY.Value, _sqttqRmu
    end
    
    local _DhoDzzNJ = _WzrgHGkD:GetAttribute(string.char(72,80)) or _WzrgHGkD:GetAttribute(string.char(72,101,97,108,116,104))
    if _DhoDzzNJ then
        return _DhoDzzNJ, _WzrgHGkD.MaxHealth or 100
    end
    
    return _WzrgHGkD.Health, _WzrgHGkD.MaxHealth
end

local function _enktMukE(obj, props, _AetPxiHt, style, dir)
    _UUeBfevn:Create(obj,
        TweenInfo.new(_AetPxiHt or 0.16, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function _QLkOtXdu(cls, props, par)
    local _BbvtigDJ = Instance.new(cls)
    if props then for k,v in pairs(props) do _BbvtigDJ[k]=v end end
    if par   then _BbvtigDJ.Parent = par end
    return _BbvtigDJ
end

local function _krkojvCR(n) return math.floor(n+0.5) end


for _DajaONQk, name in ipairs({string.char(84,72,85,66,95,77,97,105,110),string.char(84,72,85,66,95,84,111,97,115,116),string.char(84,72,85,66,95,70,80,83),string.char(84,72,85,66,95,87,77)}) do
    local _XNsvFzEW = _OMEsNFAx:FindFirstChild(name)
    if _XNsvFzEW then _XNsvFzEW:Destroy() end
end




print(string.char(91,84,45,72,85,66,93,32,61,61,61,32,82,101,112,108,105,99,97,116,101,100,83,116,111,114,97,103,101,32,82,101,109,111,116,101,69,118,101,110,116,115,32,61,61,61))
for _DajaONQk,v in ipairs(_NwuZcdFB:GetChildren()) do
    if v:IsA(string.char(82,101,109,111,116,101,69,118,101,110,116)) then
        print(string.char(91,84,45,72,85,66,93,32,82,101,109,111,116,101,69,118,101,110,116,58), v.Name)
    end
end
print(string.char(91,84,45,72,85,66,93,32,61,61,61,32,69,110,100,32,115,99,97,110,46,32,83,101,116,32,83,46,82,111,117,110,100,69,110,100,69,118,101,110,116,32,116,111,32,116,104,101,32,114,111,117,110,100,45,101,110,100,32,101,118,101,110,116,32,110,97,109,101,32,61,61,61))




local _LFRYkYAa = _QLkOtXdu(string.char(83,99,114,101,101,110,71,117,105),{Name=string.char(84,72,85,66,95,84,111,97,115,116),ResetOnSpawn=false,
    DisplayOrder=9999,IgnoreGuiInset=true},_OMEsNFAx)
local _NpiEMPTT = _QLkOtXdu(string.char(70,114,97,109,101),{
    BackgroundColor3=_UpPgzDlS.BG, Size=UDim2.new(0,210,0,34),
    Position=UDim2.new(0.5,-105,0,-42), BorderSizePixel=0,
},_LFRYkYAa)
_QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,7)},_NpiEMPTT)
_QLkOtXdu(string.char(85,73,83,116,114,111,107,101),{Color=_UpPgzDlS.Accent,Thickness=1,Transparency=0.3},_NpiEMPTT)
local _OIepfNuW = _QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{
    Text=string.char(),Font=Enum.Font.GothamBold,TextSize=12,
    TextColor3=_UpPgzDlS.White,BackgroundTransparency=1,
    Size=UDim2.new(1,0,1,0),Parent=_NpiEMPTT
})

local _FNthdXao={}; local _yZncAFti=false
local function _SJVwthSI(msg,col)
    table.insert(_FNthdXao,{msg=msg,col=col or _UpPgzDlS.Accent})
    if _yZncAFti then return end
    _yZncAFti=true
    task.spawn(function()
        while #_FNthdXao>0 do
            local _HzgOksZf=table.remove(_FNthdXao,1)
            _OIepfNuW.Text=_HzgOksZf.msg; _OIepfNuW.TextColor3=_HzgOksZf.col
            _enktMukE(_NpiEMPTT,{Position=UDim2.new(0.5,-105,0,10)},0.22,
                Enum.EasingStyle.Back,Enum.EasingDirection.Out)
            task.wait(1.5)
            _enktMukE(_NpiEMPTT,{Position=UDim2.new(0.5,-105,0,-42)},0.18)
            task.wait(0.22)
        end
        _yZncAFti=false
    end)
end




local _CgvmEWJZ={}
local function _TJQheFEU(cls)
    if not Drawing then return nil end
    local _RxfPFzzj,_kNuYwsuW=pcall(Drawing.new,cls)
    if _RxfPFzzj then table.insert(_CgvmEWJZ,_kNuYwsuW); return _kNuYwsuW end
end




local _mODPqQOG = _QLkOtXdu(string.char(83,99,114,101,101,110,71,117,105),{Name=string.char(84,72,85,66,95,87,77),ResetOnSpawn=false,
    DisplayOrder=998,IgnoreGuiInset=true},_OMEsNFAx)
local _XIUEUQFr = _QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{
    Text=string.char(84,45,72,85,66,32,118,53,46,48,32,86,73,80),Font=Enum.Font.GothamBold,TextSize=11,
    TextColor3=_UpPgzDlS.Accent,BackgroundTransparency=1,
    TextStrokeTransparency=0.6,TextStrokeColor3=_UpPgzDlS.Black,
    Size=UDim2.new(0,100,0,16),Position=UDim2.new(0,8,0,6),
    TextXAlignment=Enum.TextXAlignment.Left,
},_mODPqQOG)




local _XHgeQfyW = _TJQheFEU(string.char(67,105,114,99,108,101))
if _XHgeQfyW then
    _XHgeQfyW.Color=_UpPgzDlS.Accent; _XHgeQfyW.Thickness=1
    _XHgeQfyW.Filled=false; _XHgeQfyW.Visible=false
end

local function _AvcJIBnD()
    return _hiyOLKmJ.AimFOV * (_hiyOLKmJ.HitboxOn and _hiyOLKmJ.HitboxMult or 1)
end


local function _PxsvLHPM(_CdcucxoB)
    if not _CdcucxoB or _CdcucxoB.Parent == nil then return false end
    local _WzrgHGkD = _CdcucxoB:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100))
    if not _WzrgHGkD then return false end
    if _WzrgHGkD.Health <= 0 then return false end
    if _WzrgHGkD:GetState() == Enum.HumanoidStateType.Dead then return false end
    local _PjoIVQlg = _CdcucxoB:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
    if not _PjoIVQlg or _PjoIVQlg.Parent == nil then return false end
    return true
end


local function _OCqBPyWo(player)
    if not player then return nil end
    local _RxfPFzzj, tc = pcall(function() return player.TeamColor end)
    return _RxfPFzzj and tc or nil
end

local function _PCZZmIvQ(p)
    if p == _UeJdHgxc then return false end
    if _hiyOLKmJ.MatchMode == string.char(83,111,108,111) then return true end
    local _LwAzfNeq = _OCqBPyWo(_UeJdHgxc)
    local _QEwzrrak = _OCqBPyWo(p)
    if _LwAzfNeq and _QEwzrrak then
        return _LwAzfNeq ~= _QEwzrrak
    end
    return true
end


local function _ThmhisuZ(_CdcucxoB)
    return _CdcucxoB and _CdcucxoB:FindFirstChildWhichIsA(string.char(70,111,114,99,101,70,105,101,108,100)) ~= nil
end

local function _jPvHKvzS()
    local _rWXNbMTw, bestDist = nil, _AvcJIBnD()
    local _arFbBGMY = _HuJHNeLX:GetMouseLocation()
    for _DajaONQk,p in ipairs(Players:GetPlayers()) do
        if p==_UeJdHgxc or not p.Character then continue end
        if not _PxsvLHPM(p.Character) then continue end
        if not _PCZZmIvQ(p) then continue end
        local _qmOgEzmy = (_hiyOLKmJ.AimHead and p.Character:FindFirstChild(string.char(72,101,97,100)))
                  or p.Character:FindFirstChild(string.char(85,112,112,101,114,84,111,114,115,111))
                  or p.Character:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
        if not _qmOgEzmy then continue end
        if _hiyOLKmJ.AimVis then
            local _pymAzVYs = RaycastParams.new()
            _pymAzVYs.FilterDescendantsInstances = {_UeJdHgxc.Character, _udVNXJtv}
            _pymAzVYs.FilterType = Enum.RaycastFilterType.Exclude
            local _CcEzJokl = Workspace:Raycast(
                _udVNXJtv.CFrame.Position,
                (_qmOgEzmy.Position - _udVNXJtv.CFrame.Position).Unit * 999,
                _pymAzVYs
            )
            if _CcEzJokl and not _CcEzJokl.Instance:IsDescendantOf(p.Character) then continue end
        end
        local _SQWlcXmW,onS = _udVNXJtv:WorldToViewportPoint(_qmOgEzmy.Position)
        if not onS then continue end
        local _kNuYwsuW = (Vector2.new(_SQWlcXmW.X,_SQWlcXmW.Y) - _arFbBGMY).Magnitude
        
        if _ThmhisuZ(p.Character) then _kNuYwsuW = _kNuYwsuW * 1.5 end
        if _kNuYwsuW < bestDist then bestDist=_kNuYwsuW; _rWXNbMTw=p end
    end
    _SfVkUVJr = _rWXNbMTw  
    return _rWXNbMTw
end


local function _WkfCBJRV(_qmOgEzmy)
    local _sHGDHdNt = _qmOgEzmy.Position
    if _hiyOLKmJ.Prediction then
        local _gEfIgbox = _qmOgEzmy.AssemblyLinearVelocity
        if _gEfIgbox and _gEfIgbox.Magnitude > 1 then
            local _LeygKLea = (game:GetService(string.char(83,116,97,116,115)):FindFirstChild(string.char(80,101,114,102,111,114,109,97,110,99,101,83,116,97,116,115))
                and game:GetService(string.char(83,116,97,116,115)).PerformanceStats:FindFirstChild(string.char(80,105,110,103))
                and game:GetService(string.char(83,116,97,116,115)).PerformanceStats.Ping:GetValue() or 50)
            local _IoyrmQwm = 0.13  
            local _AetPxiHt = _IoyrmQwm + _LeygKLea/1000
            _sHGDHdNt = _sHGDHdNt + _gEfIgbox * _AetPxiHt * (_hiyOLKmJ.PredStr / 50)
        end
    end
    return _sHGDHdNt
end


local _YxQyJtEu = false
if hookfunction and newcclosure then
    pcall(function()
        local _NFCvktDm = Workspace.Raycast
        hookfunction(_NFCvktDm, newcclosure(function(self, origin, direction, _pymAzVYs)
            if _hiyOLKmJ.AimOn and self == Workspace 
            and typeof(origin) == string.char(86,101,99,116,111,114,51) 
            and typeof(direction) == string.char(86,101,99,116,111,114,51)
            and direction.Magnitude > 50 then
                local _FOpeQCzG = _jPvHKvzS()
                if _FOpeQCzG and _FOpeQCzG.Character and _PxsvLHPM(_FOpeQCzG.Character) then
                    local _DCgRLXgF = (_hiyOLKmJ.AimHead and _FOpeQCzG.Character:FindFirstChild(string.char(72,101,97,100)))
                                 or _FOpeQCzG.Character:FindFirstChild(string.char(85,112,112,101,114,84,111,114,115,111))
                                 or _FOpeQCzG.Character:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
                    if _DCgRLXgF then
                        local _PIcmJCoM = _WkfCBJRV(_DCgRLXgF)
                        local _VkceDRUJ = (_PIcmJCoM - origin).Unit * direction.Magnitude
                        if _zEsrtlNN then
                            _zEsrtlNN = _zEsrtlNN:Lerp(_VkceDRUJ, 1 - _hiyOLKmJ.AimSmooth)
                        else
                            _zEsrtlNN = _VkceDRUJ
                        end
                        return _NFCvktDm(self, origin, _zEsrtlNN, _pymAzVYs)
                    end
                end
            end
            return _NFCvktDm(self, origin, direction, _pymAzVYs)
        end))
        _YxQyJtEu = true
    end)
end


_HuJHNeLX.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        _zEsrtlNN = nil
    end
end)


RunService.RenderStepped:Connect(function()
    if _XHgeQfyW then
        local _cjJIIXhi = _HuJHNeLX:GetMouseLocation()
        _XHgeQfyW.Position = _cjJIIXhi
        _XHgeQfyW.Radius   = _AvcJIBnD()
        _XHgeQfyW.Visible  = _hiyOLKmJ.AimFOVShow
    end
    if not _hiyOLKmJ.CamLock then return end
    local _FOpeQCzG = _jPvHKvzS()
    if not(_FOpeQCzG and _FOpeQCzG.Character) then return end
    local _qmOgEzmy = (_hiyOLKmJ.AimHead and _FOpeQCzG.Character:FindFirstChild(string.char(72,101,97,100)))
              or _FOpeQCzG.Character:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
    if not _qmOgEzmy then return end
    _udVNXJtv.CFrame = _udVNXJtv.CFrame:Lerp(
        CFrame.new(_udVNXJtv.CFrame.Position, _qmOgEzmy.Position),
        math.clamp(_hiyOLKmJ.CamSmooth, 0.01, 1)
    )
end)




RunService.Heartbeat:Connect(function()
    if not _hiyOLKmJ.Triggerbot then return end
    local _arFbBGMY = _HuJHNeLX:GetMouseLocation()
    for _DajaONQk,p in ipairs(Players:GetPlayers()) do
        if p==_UeJdHgxc or not p.Character then continue end
        if not _PCZZmIvQ(p) then continue end
        if not _PxsvLHPM(p.Character) then continue end
        for _DajaONQk,_qmOgEzmy in ipairs(p.Character:GetDescendants()) do
            if not _qmOgEzmy:IsA(string.char(66,97,115,101,80,97,114,116)) then continue end
            local _SQWlcXmW,on = _udVNXJtv:WorldToViewportPoint(_qmOgEzmy.Position)
            if on and (Vector2.new(_SQWlcXmW.X,_SQWlcXmW.Y)-_arFbBGMY).Magnitude < 12 then
                local delay = _hiyOLKmJ.TrigDelay + math.random(-15,15)
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




local _ZOkhpNcf = false
local _uOHespdq
local _jYTPwaEL = nil

_HuJHNeLX.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not _hiyOLKmJ.NoRecoil then return end
    _ZOkhpNcf = true
    _jYTPwaEL = _udVNXJtv.CFrame  
    _uOHespdq = RunService.RenderStepped:Connect(function()
        if not _ZOkhpNcf or not _hiyOLKmJ.NoRecoil then
            if _uOHespdq then _uOHespdq:Disconnect(); _uOHespdq = nil end
            _jYTPwaEL = nil
            return
        end
        local _cPIdZcqe = _udVNXJtv.CFrame
        local _wTPMyGCH, _ESeLQvZJ, _DajaONQk = _cPIdZcqe:ToEulerAnglesYXZ()
        local _DajaONQk, bx, _DajaONQk = _jYTPwaEL:ToEulerAnglesYXZ()
        local _sLbICZLt = _ESeLQvZJ - bx
        
        if _sLbICZLt > 0.006 then
            local _gMETbBOV = bx + (_sLbICZLt * (1 - _hiyOLKmJ.RecoilReduce/100))
            _gMETbBOV = math.clamp(_gMETbBOV, bx - 0.01, bx + 0.05)
            _udVNXJtv.CFrame = CFrame.new(_cPIdZcqe.Position)
                * CFrame.fromEulerAnglesYXZ(_gMETbBOV, _wTPMyGCH, 0)
        end
        
        local _DajaONQk, nx, _DajaONQk = _udVNXJtv.CFrame:ToEulerAnglesYXZ()
        local _DajaONQk, lx, _DajaONQk = _jYTPwaEL:ToEulerAnglesYXZ()
        if nx < lx then  
            _jYTPwaEL = _udVNXJtv.CFrame
        end
    end)
end)

_HuJHNeLX.InputEnded:Connect(function(i)
    if i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    _ZOkhpNcf = false
    _jYTPwaEL = nil
    if _uOHespdq then _uOHespdq:Disconnect(); _uOHespdq = nil end
end)



local _pSsQEvsu = {}

local _vAdFFPMO = {
    {string.char(72,101,97,100),string.char(85,112,112,101,114,84,111,114,115,111)},{string.char(85,112,112,101,114,84,111,114,115,111),string.char(76,111,119,101,114,84,111,114,115,111)},
    {string.char(85,112,112,101,114,84,111,114,115,111),string.char(82,105,103,104,116,85,112,112,101,114,65,114,109)},{string.char(82,105,103,104,116,85,112,112,101,114,65,114,109),string.char(82,105,103,104,116,76,111,119,101,114,65,114,109)},{string.char(82,105,103,104,116,76,111,119,101,114,65,114,109),string.char(82,105,103,104,116,72,97,110,100)},
    {string.char(85,112,112,101,114,84,111,114,115,111),string.char(76,101,102,116,85,112,112,101,114,65,114,109)},{string.char(76,101,102,116,85,112,112,101,114,65,114,109),string.char(76,101,102,116,76,111,119,101,114,65,114,109)},{string.char(76,101,102,116,76,111,119,101,114,65,114,109),string.char(76,101,102,116,72,97,110,100)},
    {string.char(76,111,119,101,114,84,111,114,115,111),string.char(82,105,103,104,116,85,112,112,101,114,76,101,103)},{string.char(82,105,103,104,116,85,112,112,101,114,76,101,103),string.char(82,105,103,104,116,76,111,119,101,114,76,101,103)},{string.char(82,105,103,104,116,76,111,119,101,114,76,101,103),string.char(82,105,103,104,116,70,111,111,116)},
    {string.char(76,111,119,101,114,84,111,114,115,111),string.char(76,101,102,116,85,112,112,101,114,76,101,103)},{string.char(76,101,102,116,85,112,112,101,114,76,101,103),string.char(76,101,102,116,76,111,119,101,114,76,101,103)},{string.char(76,101,102,116,76,111,119,101,114,76,101,103),string.char(76,101,102,116,70,111,111,116)},
}

local function _fITRsNGR(p)
    if _pSsQEvsu[p] or p==_UeJdHgxc then return end
    local _kNuYwsuW = {
        corners = {},
        name    = _TJQheFEU(string.char(84,101,120,116)),
        hpBG    = _TJQheFEU(string.char(76,105,110,101)),
        _xZBENUIW      = _TJQheFEU(string.char(76,105,110,101)),
        hpTxt   = _TJQheFEU(string.char(84,101,120,116)),
        tracer  = _TJQheFEU(string.char(76,105,110,101)),
        bones   = {},
        shield  = _TJQheFEU(string.char(84,101,120,116)),  
    }
    for i=1,8 do
        local _jOVTcYDl = _TJQheFEU(string.char(76,105,110,101))
        if _jOVTcYDl then _jOVTcYDl.Thickness=1.5; _jOVTcYDl.Visible=false end
        _kNuYwsuW.corners[i] = _jOVTcYDl
    end
    if _kNuYwsuW.name then
        _kNuYwsuW.name.Size=13; _kNuYwsuW.name.Center=true; _kNuYwsuW.name.Outline=true
        _kNuYwsuW.name.Color=_UpPgzDlS.White; _kNuYwsuW.name.Visible=false
    end
    if _kNuYwsuW.hpBG then
        _kNuYwsuW.hpBG.Thickness=4; _kNuYwsuW.hpBG.Color=Color3.fromRGB(22,22,22)
        _kNuYwsuW.hpBG.Visible=false
    end
    if _kNuYwsuW._xZBENUIW then _kNuYwsuW._xZBENUIW.Thickness=2.5; _kNuYwsuW._xZBENUIW.Visible=false end
    if _kNuYwsuW.hpTxt then
        _kNuYwsuW.hpTxt.Size=10; _kNuYwsuW.hpTxt.Center=false; _kNuYwsuW.hpTxt.Outline=true
        _kNuYwsuW.hpTxt.Visible=false
    end
    if _kNuYwsuW.tracer then
        _kNuYwsuW.tracer.Thickness=1; _kNuYwsuW.tracer.Color=_UpPgzDlS.Accent
        _kNuYwsuW.tracer.Visible=false
    end
    
    if _kNuYwsuW.shield then
        _kNuYwsuW.shield.Size=12; _kNuYwsuW.shield.Center=false; _kNuYwsuW.shield.Outline=true
        _kNuYwsuW.shield.Color=_UpPgzDlS.ShieldCyan; _kNuYwsuW.shield.Visible=false
        _kNuYwsuW.shield.Text=string.char(83)
    end
    for i=1,#_vAdFFPMO do
        local _jOVTcYDl = _TJQheFEU(string.char(76,105,110,101))
        if _jOVTcYDl then _jOVTcYDl.Color=Color3.fromRGB(255,255,255); _jOVTcYDl.Thickness=0.8; _jOVTcYDl.Visible=false end
        _kNuYwsuW.bones[i] = _jOVTcYDl
    end
    _pSsQEvsu[p] = _kNuYwsuW
end


local function _HDiZaBGV(_kNuYwsuW)
    if not _kNuYwsuW then return end
    for _DajaONQk,_jOVTcYDl in ipairs(_kNuYwsuW.corners) do if _jOVTcYDl then _jOVTcYDl.Visible=false end end
    if _kNuYwsuW.name   then _kNuYwsuW.name.Visible=false end
    if _kNuYwsuW.hpBG   then _kNuYwsuW.hpBG.Visible=false end
    if _kNuYwsuW._xZBENUIW     then _kNuYwsuW._xZBENUIW.Visible=false end
    if _kNuYwsuW.hpTxt  then _kNuYwsuW.hpTxt.Visible=false end
    if _kNuYwsuW.tracer then _kNuYwsuW.tracer.Visible=false end
    if _kNuYwsuW.shield then _kNuYwsuW.shield.Visible=false end
    for _DajaONQk,_YfeNbdqU in ipairs(_kNuYwsuW.bones) do if _YfeNbdqU then _YfeNbdqU.Visible=false end end
end

local _ncwurVii = {}

local function _YhGPQFhG(p)
    _ncwurVii[p] = nil
    if not _pSsQEvsu[p] then return end
    for _DajaONQk,v in pairs(_pSsQEvsu[p]) do
        if type(v)==string.char(116,97,98,108,101) then
            for _DajaONQk,sub in pairs(v) do if sub and sub.Remove then pcall(function() sub:Remove() end) end end
        elseif v and v.Remove then pcall(function() v:Remove() end) end
    end
    _pSsQEvsu[p]=nil
end


local function _ezknczrZ(p)
    if p == _UeJdHgxc or _ncwurVii[p] then return end
    _ncwurVii[p] = true
    _fITRsNGR(p)
    p.CharacterAdded:Connect(function()
        _fITRsNGR(p)
    end)
    p.CharacterRemoving:Connect(function()
        if _pSsQEvsu[p] then _HDiZaBGV(_pSsQEvsu[p]) end
    end)
end

Players.PlayerAdded:Connect(_ezknczrZ)
Players.PlayerRemoving:Connect(_YhGPQFhG)

for _DajaONQk,p in ipairs(Players:GetPlayers()) do _ezknczrZ(p) end


local function _MxFbtZYx(p)
    if _hiyOLKmJ.MatchMode == string.char(83,111,108,111) then
        return _UpPgzDlS.Accent  
    end
    
    local _LwAzfNeq = _OCqBPyWo(_UeJdHgxc)
    local _QEwzrrak = _OCqBPyWo(p)
    if _LwAzfNeq and _QEwzrrak and _LwAzfNeq == _QEwzrrak then
        return _UpPgzDlS.TeamBlue  
    else
        return _UpPgzDlS.Accent    
    end
end


local function _EaZSzxNF(p)
    if _hiyOLKmJ.MatchMode == string.char(83,111,108,111) then return true end
    local _LwAzfNeq = _OCqBPyWo(_UeJdHgxc)
    local _QEwzrrak = _OCqBPyWo(p)
    if _LwAzfNeq and _QEwzrrak then
        local _dHDByJMP = _LwAzfNeq == _QEwzrrak
        if _dHDByJMP and not _hiyOLKmJ.ESPTeam then return false end
    end
    return true
end


RunService.RenderStepped:Connect(function()
    local _ESeLQvZJ = _udVNXJtv.ViewportSize.X / 2

    for p,_kNuYwsuW in pairs(_pSsQEvsu) do
        local _CdcucxoB = p.Character

        
        if not _CdcucxoB or _CdcucxoB.Parent == nil then _HDiZaBGV(_kNuYwsuW); continue end
        local _WzrgHGkD  = _CdcucxoB:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100))
        local _PjoIVQlg = _CdcucxoB:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
        local _EDvtnZPA = _CdcucxoB:FindFirstChild(string.char(72,101,97,100))
        if not _WzrgHGkD or not _PjoIVQlg or _PjoIVQlg.Parent == nil then _HDiZaBGV(_kNuYwsuW); continue end
        if _WzrgHGkD.Health <= 0 then _HDiZaBGV(_kNuYwsuW); continue end
        if _WzrgHGkD:GetState() == Enum.HumanoidStateType.Dead then _HDiZaBGV(_kNuYwsuW); continue end

        local _qsXmZImg = _hiyOLKmJ.ESPCorner or _hiyOLKmJ.ESPName or _hiyOLKmJ.ESPHealth or _hiyOLKmJ.ESPSkel or _hiyOLKmJ.ESPTracer
        if not _qsXmZImg then _HDiZaBGV(_kNuYwsuW); continue end

        
        if not _EaZSzxNF(p) then _HDiZaBGV(_kNuYwsuW); continue end

        local _fJABkvoN, onS = _udVNXJtv:WorldToViewportPoint(_PjoIVQlg.Position)
        if not onS then _HDiZaBGV(_kNuYwsuW); continue end

        local _llwcfinY = _krkojvCR((_PjoIVQlg.Position - _udVNXJtv.CFrame.Position).Magnitude)

        
        if _llwcfinY > _hiyOLKmJ.ESPMaxDist then _HDiZaBGV(_kNuYwsuW); continue end

        local _yZudHHlC = _udVNXJtv:WorldToViewportPoint((_EDvtnZPA or _PjoIVQlg).Position + Vector3.new(0, 0.65, 0))
        local _hOclVyyX = _udVNXJtv:WorldToViewportPoint(_PjoIVQlg.Position - Vector3.new(0, 3.1, 0))

        local _qgQmADmZ = math.abs(_yZudHHlC.Y - _hOclVyyX.Y)
        if _qgQmADmZ < 5 then _HDiZaBGV(_kNuYwsuW); continue end
        local _ePATZpUu = _qgQmADmZ * 0.5

        
        local _kukOGrfn = _MxFbtZYx(p)
        local _xZBENUIW, maxhp = _lyvlTKhk(_CdcucxoB, _WzrgHGkD)
        local _QmLrmRyu = math.clamp(_xZBENUIW / maxhp, 0, 1)

        local _wQlwhFVm = math._sqttqRmu(_ePATZpUu * 0.2, 4)
        local _vjMsmaqa = math._sqttqRmu(_qgQmADmZ * 0.2, 4)

        local _igWtxMMs = _fJABkvoN.X - _ePATZpUu/2
        local _omPLQQyD = _yZudHHlC.Y
        local _sLjOcpvD = _fJABkvoN.X + _ePATZpUu/2
        local _oDxTUNDb = _hOclVyyX.Y

        
        if _hiyOLKmJ.ESPCorner then
            if _kNuYwsuW.corners[1] then _kNuYwsuW.corners[1].From=Vector2.new(_igWtxMMs,_omPLQQyD); _kNuYwsuW.corners[1].To=Vector2.new(_igWtxMMs+_wQlwhFVm,_omPLQQyD); _kNuYwsuW.corners[1].Color=_kukOGrfn; _kNuYwsuW.corners[1].Visible=true end
            if _kNuYwsuW.corners[2] then _kNuYwsuW.corners[2].From=Vector2.new(_igWtxMMs,_omPLQQyD); _kNuYwsuW.corners[2].To=Vector2.new(_igWtxMMs,_omPLQQyD+_vjMsmaqa); _kNuYwsuW.corners[2].Color=_kukOGrfn; _kNuYwsuW.corners[2].Visible=true end
            if _kNuYwsuW.corners[3] then _kNuYwsuW.corners[3].From=Vector2.new(_sLjOcpvD,_omPLQQyD); _kNuYwsuW.corners[3].To=Vector2.new(_sLjOcpvD-_wQlwhFVm,_omPLQQyD); _kNuYwsuW.corners[3].Color=_kukOGrfn; _kNuYwsuW.corners[3].Visible=true end
            if _kNuYwsuW.corners[4] then _kNuYwsuW.corners[4].From=Vector2.new(_sLjOcpvD,_omPLQQyD); _kNuYwsuW.corners[4].To=Vector2.new(_sLjOcpvD,_omPLQQyD+_vjMsmaqa); _kNuYwsuW.corners[4].Color=_kukOGrfn; _kNuYwsuW.corners[4].Visible=true end
            if _kNuYwsuW.corners[5] then _kNuYwsuW.corners[5].From=Vector2.new(_igWtxMMs,_oDxTUNDb); _kNuYwsuW.corners[5].To=Vector2.new(_igWtxMMs+_wQlwhFVm,_oDxTUNDb); _kNuYwsuW.corners[5].Color=_kukOGrfn; _kNuYwsuW.corners[5].Visible=true end
            if _kNuYwsuW.corners[6] then _kNuYwsuW.corners[6].From=Vector2.new(_igWtxMMs,_oDxTUNDb); _kNuYwsuW.corners[6].To=Vector2.new(_igWtxMMs,_oDxTUNDb-_vjMsmaqa); _kNuYwsuW.corners[6].Color=_kukOGrfn; _kNuYwsuW.corners[6].Visible=true end
            if _kNuYwsuW.corners[7] then _kNuYwsuW.corners[7].From=Vector2.new(_sLjOcpvD,_oDxTUNDb); _kNuYwsuW.corners[7].To=Vector2.new(_sLjOcpvD-_wQlwhFVm,_oDxTUNDb); _kNuYwsuW.corners[7].Color=_kukOGrfn; _kNuYwsuW.corners[7].Visible=true end
            if _kNuYwsuW.corners[8] then _kNuYwsuW.corners[8].From=Vector2.new(_sLjOcpvD,_oDxTUNDb); _kNuYwsuW.corners[8].To=Vector2.new(_sLjOcpvD,_oDxTUNDb-_vjMsmaqa); _kNuYwsuW.corners[8].Color=_kukOGrfn; _kNuYwsuW.corners[8].Visible=true end
        else
            for _DajaONQk,_jOVTcYDl in ipairs(_kNuYwsuW.corners) do if _jOVTcYDl then _jOVTcYDl.Visible=false end end
        end

        
        if _kNuYwsuW.name then
            if _hiyOLKmJ.ESPName then
                _kNuYwsuW.name.Text    = p.Name..string.char(32,32,91).._llwcfinY..string.char(109,93)
                _kNuYwsuW.name.Position= Vector2.new(_fJABkvoN.X, _omPLQQyD-16)
                local _AetPxiHt = math.clamp(_llwcfinY/200, 0, 1)
                local _vVvitZca = 255 - _AetPxiHt*155
                _kNuYwsuW.name.Color = Color3.fromRGB(_vVvitZca, _vVvitZca, _vVvitZca)
                _kNuYwsuW.name.Visible = true
            else _kNuYwsuW.name.Visible=false end
        end

        
        if _kNuYwsuW.shield then
            if _hiyOLKmJ.ESPName and _ThmhisuZ(_CdcucxoB) then
                _kNuYwsuW.shield.Position = Vector2.new(_fJABkvoN.X + (#p.Name*3.5) + 30, _omPLQQyD-16)
                _kNuYwsuW.shield.Visible = true
            else
                _kNuYwsuW.shield.Visible = false
            end
        end

        
        if _kNuYwsuW.hpBG and _kNuYwsuW._xZBENUIW then
            if _hiyOLKmJ.ESPHealth then
                local _JoHLdmlf = _igWtxMMs - 6
                _kNuYwsuW.hpBG.From   = Vector2.new(_JoHLdmlf, _oDxTUNDb)
                _kNuYwsuW.hpBG.To     = Vector2.new(_JoHLdmlf, _omPLQQyD)
                _kNuYwsuW.hpBG.Visible= true
                _kNuYwsuW._xZBENUIW.From    = Vector2.new(_JoHLdmlf, _oDxTUNDb)
                _kNuYwsuW._xZBENUIW.To      = Vector2.new(_JoHLdmlf, _oDxTUNDb - _qgQmADmZ*_QmLrmRyu)
                _kNuYwsuW._xZBENUIW.Color   = Color3.fromHSV(_QmLrmRyu * 0.33, 1, 1)
                _kNuYwsuW._xZBENUIW.Visible = true
                if _kNuYwsuW.hpTxt then
                    _kNuYwsuW.hpTxt.Text    = tostring(_krkojvCR(_xZBENUIW))
                    _kNuYwsuW.hpTxt.Position= Vector2.new(_JoHLdmlf - 4, _oDxTUNDb - _qgQmADmZ*_QmLrmRyu - 6)
                    _kNuYwsuW.hpTxt.Color   = Color3.fromHSV(_QmLrmRyu * 0.33, 1, 1)
                    _kNuYwsuW.hpTxt.Visible = true
                end
            else
                _kNuYwsuW.hpBG.Visible=false; _kNuYwsuW._xZBENUIW.Visible=false
                if _kNuYwsuW.hpTxt then _kNuYwsuW.hpTxt.Visible=false end
            end
        end

        
        if _kNuYwsuW.tracer then
            if _hiyOLKmJ.ESPTracer then
                _kNuYwsuW.tracer.From   = Vector2.new(_ESeLQvZJ, _udVNXJtv.ViewportSize.Y)
                _kNuYwsuW.tracer.To     = Vector2.new(_fJABkvoN.X, _oDxTUNDb)
                _kNuYwsuW.tracer.Color  = _kukOGrfn
                _kNuYwsuW.tracer.Visible= true
            else _kNuYwsuW.tracer.Visible=false end
        end

        
        for i, bp in ipairs(_vAdFFPMO) do
            local _YfeNbdqU = _kNuYwsuW.bones[i]
            if not _YfeNbdqU then continue end
            
            
            if not _hiyOLKmJ.ESPSkel or not _EaZSzxNF(p) then
                _YfeNbdqU.Visible = false
                continue
            end
            
            local _dlwKMyVV = _CdcucxoB:FindFirstChild(bp[1])
            local _FFzTuGRt = _CdcucxoB:FindFirstChild(bp[2])
            if _dlwKMyVV and _FFzTuGRt then
                local _grbvpmsA = _udVNXJtv:WorldToViewportPoint(_dlwKMyVV.Position)
                local _tFeaXRPK = _udVNXJtv:WorldToViewportPoint(_FFzTuGRt.Position)
                _YfeNbdqU.From      = Vector2.new(_grbvpmsA.X, _grbvpmsA.Y)
                _YfeNbdqU.To        = Vector2.new(_tFeaXRPK.X, _tFeaXRPK.Y)
                _YfeNbdqU.Color     = _kukOGrfn  
                _YfeNbdqU.Thickness = 1
                _YfeNbdqU.Visible   = true
            else
                _YfeNbdqU.Visible = false
            end
        end
    end
end)




local function _QrhundVO()
    for p, _kNuYwsuW in pairs(_pSsQEvsu) do
        _HDiZaBGV(_kNuYwsuW)
    end
    _SfVkUVJr = nil
    _zEsrtlNN = nil
    _jYTPwaEL = nil
    if _uOHespdq then _uOHespdq:Disconnect(); _uOHespdq = nil end
    _SJVwthSI(string.char(82,111,117,110,100,32,101,110,100,101,100,32,226,128,148,32,114,101,115,101,116), _UpPgzDlS.AccentHi)
end


task.spawn(function()
    task.wait(2)  
    if _hiyOLKmJ.RoundEndEvent ~= string.char() then
        local _EsSvcFco = _NwuZcdFB:FindFirstChild(_hiyOLKmJ.RoundEndEvent)
        if _EsSvcFco and _EsSvcFco:IsA(string.char(82,101,109,111,116,101,69,118,101,110,116)) then
            _EsSvcFco.OnClientEvent:Connect(_QrhundVO)
            print(string.char(91,84,45,72,85,66,93,32,72,111,111,107,101,100,32,114,111,117,110,100,32,101,110,100,32,101,118,101,110,116,58), _hiyOLKmJ.RoundEndEvent)
        else
            print(string.char(91,84,45,72,85,66,93,32,82,111,117,110,100,32,101,110,100,32,101,118,101,110,116,32,110,111,116,32,102,111,117,110,100,58), _hiyOLKmJ.RoundEndEvent)
        end
    end
end)




local _OmYFNOKw
local function _jgKFMnVF(_QOAPUOwf)
    if _OmYFNOKw then _OmYFNOKw:Disconnect(); _OmYFNOKw=nil end
    if not _QOAPUOwf then return end
    local _WzrgHGkD=_CeIuIUwQ(); if not _WzrgHGkD then return end
    _OmYFNOKw = _WzrgHGkD.StateChanged:Connect(function(_DajaONQk,new)
        if new==Enum.HumanoidStateType.Landed
        and _HuJHNeLX:IsKeyDown(Enum.KeyCode.Space) then
            _WzrgHGkD:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end




_UeJdHgxc.Idled:Connect(function()
    if _hiyOLKmJ.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)




local _uIKazJyl = _QLkOtXdu(string.char(83,99,114,101,101,110,71,117,105),{Name=string.char(84,72,85,66,95,70,80,83),ResetOnSpawn=false,
    DisplayOrder=997,IgnoreGuiInset=true},_OMEsNFAx)
local _fcjWzkLD = _QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{
    Text=string.char(70,80,83,58,32,48),Font=Enum.Font.GothamBold,TextSize=12,
    TextColor3=_UpPgzDlS.Accent,BackgroundTransparency=1,
    Size=UDim2.new(0,80,0,18),Position=UDim2.new(1,-90,0,6),
    TextXAlignment=Enum.TextXAlignment.Right,
    Visible=false,
},_uIKazJyl)
local _wUNZigwX=0
RunService.RenderStepped:Connect(function() _wUNZigwX=_wUNZigwX+1 end)
task.spawn(function()
    while true do task.wait(1)
        if _hiyOLKmJ.FPSCount then _fcjWzkLD.Text=string.char(70,80,83,58,32).._wUNZigwX end
        _wUNZigwX=0
    end
end)



local _tqpJZuEb = _QLkOtXdu(string.char(83,99,114,101,101,110,71,117,105),{
    Name=string.char(84,72,85,66,95,77,97,105,110),ResetOnSpawn=false,
    DisplayOrder=100,IgnoreGuiInset=true,
},_OMEsNFAx)

local _zjmzSGKU,H = 480,360
local _zbBQivpR = _QLkOtXdu(string.char(70,114,97,109,101),{
    BackgroundColor3=_UpPgzDlS.BG,BorderSizePixel=0,
    AnchorPoint=Vector2.new(0.5,0.5),
    Position=UDim2.new(0.5,0,0.5,0),
    Size=UDim2.new(0,_zjmzSGKU,0,H),
    ClipsDescendants=true,
},_tqpJZuEb)
_QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,10)},_zbBQivpR)



local _IWBobrcZ=40
local _KOKtJxUt = _QLkOtXdu(string.char(70,114,97,109,101),{
    BackgroundColor3=_UpPgzDlS.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(1,0,0,_IWBobrcZ),ZIndex=3,
},_zbBQivpR)
_QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,10)},_KOKtJxUt)
_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,1,-10),ZIndex=3},_KOKtJxUt)
_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.Accent,BorderSizePixel=0,
    Size=UDim2.new(0,3,0,22),Position=UDim2.new(0,0,0.5,-11),ZIndex=4},_KOKtJxUt)
_QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{Text=string.char(84,45,72,85,66),Font=Enum.Font.GothamBlack,TextSize=14,
    TextColor3=_UpPgzDlS.White,BackgroundTransparency=1,
    Size=UDim2.new(0,55,1,0),Position=UDim2.new(0,10,0,0),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4},_KOKtJxUt)
_QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{Text=string.char(65,114,115,101,110,97,108,32,86,73,80),Font=Enum.Font.GothamBold,TextSize=12,
    TextColor3=_UpPgzDlS.Accent,BackgroundTransparency=1,
    Size=UDim2.new(0,75,1,0),Position=UDim2.new(0,65,0,0),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4},_KOKtJxUt)
_QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{Text=string.char(82,83,104,105,102,116,32,32,194,183,32,32,116,111,103,103,108,101),Font=Enum.Font.Gotham,TextSize=10,
    TextColor3=_UpPgzDlS.TextDim,BackgroundTransparency=1,
    Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,0,0,0),
    TextXAlignment=Enum.TextXAlignment.Right,ZIndex=4},_KOKtJxUt)


local _BWBVJdYV = _QLkOtXdu(string.char(70,114,97,109,101),{
    Size=UDim2.new(0,8,0,8),AnchorPoint=Vector2.new(0,0.5),
    Position=UDim2.new(0,150,0.5,0),BorderSizePixel=0,
    BackgroundColor3=_YxQyJtEu and Color3.fromRGB(60,210,80) or Color3.fromRGB(200,50,50),
    ZIndex=5,
},_KOKtJxUt)
_QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(1,0)},_BWBVJdYV)
_QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{
    Text=_YxQyJtEu and string.char(104,111,111,107,32,226,156,147) or string.char(104,111,111,107,32,226,156,151),
    Font=Enum.Font.Gotham,TextSize=9,
    TextColor3=_YxQyJtEu and Color3.fromRGB(60,210,80) or Color3.fromRGB(200,50,50),
    BackgroundTransparency=1,
    Size=UDim2.new(0,45,1,0),Position=UDim2.new(0,162,0,0),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
},_KOKtJxUt)


local _ZLxxfUVT = 18
local _lxbSrYkB = _QLkOtXdu(string.char(70,114,97,109,101),{
    BackgroundColor3=_UpPgzDlS.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(1,0,0,_ZLxxfUVT),
    Position=UDim2.new(0,0,1,-_ZLxxfUVT),
    ZIndex=3,
},_zbBQivpR)
_QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,10)},_lxbSrYkB)
_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,0,0),ZIndex=3},_lxbSrYkB)
local _MUWdHNjH = _QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{
    Text=string.char(),Font=Enum.Font.GothamMedium,TextSize=10,
    TextColor3=_UpPgzDlS.TextDim,BackgroundTransparency=1,
    Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,
},_lxbSrYkB)


task.spawn(function()
    while true do
        task.wait(0.5)
        local _PRkInAJl = {}
        
        table.insert(_PRkInAJl, _hiyOLKmJ.MatchMode)
        if _hiyOLKmJ.AimOn     then table.insert(_PRkInAJl, string.char(83,65)) end
        if _hiyOLKmJ.CamLock   then table.insert(_PRkInAJl, string.char(67,76)) end
        if _hiyOLKmJ.HitboxOn  then table.insert(_PRkInAJl, string.char(72,66)) end
        if _hiyOLKmJ.NoRecoil  then table.insert(_PRkInAJl, string.char(78,82)) end
        if _hiyOLKmJ.Triggerbot then table.insert(_PRkInAJl, string.char(84,66)) end
        if _hiyOLKmJ.BHop      then table.insert(_PRkInAJl, string.char(66,72)) end
        if _hiyOLKmJ.ESPCorner then table.insert(_PRkInAJl, string.char(69,83,80)) end
        if _hiyOLKmJ.ESPSkel   then table.insert(_PRkInAJl, string.char(83,107,101,108)) end
        
        if _hiyOLKmJ.AimOn and _SfVkUVJr then
            table.insert(_PRkInAJl, string.char(226,134,146,32).._SfVkUVJr.Name)
        end
        if #_PRkInAJl > 0 then
            _MUWdHNjH.Text = table.concat(_PRkInAJl, string.char(32,32,194,183,32,32))
            _MUWdHNjH.TextColor3 = _UpPgzDlS.Accent
        else
            _MUWdHNjH.Text = string.char(97,108,108,32,111,102,102)
            _MUWdHNjH.TextColor3 = _UpPgzDlS.TextDim
        end
    end
end)


local _AzgiRqjp,dStart,dPos
_KOKtJxUt.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
        _AzgiRqjp=true; dStart=i.Position; dPos=_zbBQivpR.Position
        i.Changed:Connect(function()
            if i.UserInputState==Enum.UserInputState.End then _AzgiRqjp=false end
        end)
    end
end)
_HuJHNeLX.InputChanged:Connect(function(i)
    if _AzgiRqjp and i.UserInputType==Enum.UserInputType.MouseMovement then
        local _kNuYwsuW=i.Position-dStart
        _zbBQivpR.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+_kNuYwsuW.X,
                                  dPos.Y.Scale,dPos.Y.Offset+_kNuYwsuW.Y)
    end
end)

_HuJHNeLX.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then
        _zbBQivpR.Visible=not _zbBQivpR.Visible
    end
    if i.KeyCode==Enum.KeyCode.CapsLock then
        _hiyOLKmJ.AimOn=not _hiyOLKmJ.AimOn
        _SJVwthSI(_hiyOLKmJ.AimOn and string.char(83,105,108,101,110,116,32,65,105,109,32,79,78) or string.char(83,105,108,101,110,116,32,65,105,109,32,79,70,70),
              _hiyOLKmJ.AimOn and _UpPgzDlS.AccentHi or _UpPgzDlS.TextDim)
    end
end)


local _eAKXrVuJ=145
local _VRryuzgW = _QLkOtXdu(string.char(70,114,97,109,101),{
    BackgroundColor3=_UpPgzDlS.Sidebar,BorderSizePixel=0,
    Position=UDim2.new(0,0,0,_IWBobrcZ),
    Size=UDim2.new(0,_eAKXrVuJ,1,-_IWBobrcZ),
},_zbBQivpR)
_QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,10)},_VRryuzgW)
_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,0,0)},_VRryuzgW)
_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.Sidebar,BorderSizePixel=0,
    Size=UDim2.new(0,10,1,0),Position=UDim2.new(1,-10,0,0)},_VRryuzgW)

local _ncrBWPfC = _QLkOtXdu(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101),{
    BackgroundTransparency=1,
    Position=UDim2.new(0,0,0,6),
    Size=UDim2.new(1,0,1,-6),
    ScrollBarThickness=0,
    CanvasSize=UDim2.new(0,0,0,0),
    BorderSizePixel=0,
},_VRryuzgW)
local _DynBLzpw = _QLkOtXdu(string.char(85,73,76,105,115,116,76,97,121,111,117,116),{
    SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3),
},_ncrBWPfC)
_QLkOtXdu(string.char(85,73,80,97,100,100,105,110,103),{PaddingTop=UDim.new(0,4),
    PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)},_ncrBWPfC)
_DynBLzpw:GetPropertyChangedSignal(string.char(65,98,115,111,108,117,116,101,67,111,110,116,101,110,116,83,105,122,101)):Connect(function()
    _ncrBWPfC.CanvasSize=UDim2.new(0,0,0,_DynBLzpw.AbsoluteContentSize.Y+8)
end)

local _FPspukgG = _QLkOtXdu(string.char(70,114,97,109,101),{
    BackgroundTransparency=1,
    Position=UDim2.new(0,_eAKXrVuJ,0,_IWBobrcZ),
    Size=UDim2.new(1,-_eAKXrVuJ,1,-_IWBobrcZ-_ZLxxfUVT),
},_zbBQivpR)




local _lZBYGgZJ=nil; local _RaqqOyJF={}

local function _iXBjTiQU(label)
    local _LjYHPwJA=_QLkOtXdu(string.char(84,101,120,116,66,117,116,116,111,110),{
        Text=string.char(),BackgroundTransparency=1,
        BackgroundColor3=_UpPgzDlS.Sidebar,BorderSizePixel=0,
        Size=UDim2.new(1,0,0,32),AutoButtonColor=false,
    },_ncrBWPfC)
    _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,7)},_LjYHPwJA)

    local _sswDsiwW=_QLkOtXdu(string.char(70,114,97,109,101),{
        BackgroundColor3=_UpPgzDlS.Accent,BorderSizePixel=0,
        Size=UDim2.new(0,3,0.55,0),
        AnchorPoint=Vector2.new(0,0.5),
        Position=UDim2.new(0,0,0.5,0),
        BackgroundTransparency=1,
    },_LjYHPwJA)
    _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,2)},_sswDsiwW)

    local _sOrUbahf=_QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{
        Text=label,Font=Enum.Font.GothamMedium,TextSize=12,
        TextColor3=_UpPgzDlS.TextDim,BackgroundTransparency=1,
        Size=UDim2.new(1,-10,1,0),
        Position=UDim2.new(0,12,0,0),
        TextXAlignment=Enum.TextXAlignment.Left,
    },_LjYHPwJA)

    local _dthbMnYQ=_QLkOtXdu(string.char(83,99,114,111,108,108,105,110,103,70,114,97,109,101),{
        BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),
        ScrollBarThickness=2,ScrollBarImageColor3=_UpPgzDlS.TextDim,
        CanvasSize=UDim2.new(0,0,0,0),Visible=false,BorderSizePixel=0,
    },_FPspukgG)
    local _KDdaHVvh=_QLkOtXdu(string.char(85,73,76,105,115,116,76,97,121,111,117,116),{
        SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),
    },_dthbMnYQ)
    _QLkOtXdu(string.char(85,73,80,97,100,100,105,110,103),{
        PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10),
        PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),
    },_dthbMnYQ)
    _KDdaHVvh:GetPropertyChangedSignal(string.char(65,98,115,111,108,117,116,101,67,111,110,116,101,110,116,83,105,122,101)):Connect(function()
        _dthbMnYQ.CanvasSize=UDim2.new(0,0,0,_KDdaHVvh.AbsoluteContentSize.Y+20)
    end)

    local _VTQlJtMl={_LjYHPwJA=_LjYHPwJA,_sswDsiwW=_sswDsiwW,_sOrUbahf=_sOrUbahf,_dthbMnYQ=_dthbMnYQ}
    table.insert(_RaqqOyJF,_VTQlJtMl)

    local function _NySZSkWs()
        if _lZBYGgZJ==_VTQlJtMl then return end
        if _lZBYGgZJ then
            _enktMukE(_lZBYGgZJ._LjYHPwJA,{BackgroundTransparency=1},0.14)
            _enktMukE(_lZBYGgZJ._sOrUbahf,{TextColor3=_UpPgzDlS.TextDim},0.14)
            _enktMukE(_lZBYGgZJ._sswDsiwW,{BackgroundTransparency=1},0.14)
            _lZBYGgZJ._dthbMnYQ.Visible=false
        end
        _lZBYGgZJ=_VTQlJtMl
        _enktMukE(_LjYHPwJA,{BackgroundTransparency=0.87},0.14)
        _enktMukE(_sOrUbahf,{TextColor3=_UpPgzDlS.White},0.14)
        _enktMukE(_sswDsiwW,{BackgroundTransparency=0},0.14)
        _dthbMnYQ.Visible=true
    end

    _LjYHPwJA.MouseButton1Click:Connect(_NySZSkWs)
    _LjYHPwJA.MouseEnter:Connect(function() if _lZBYGgZJ~=_VTQlJtMl then _enktMukE(_LjYHPwJA,{BackgroundTransparency=0.93},0.1) end end)
    _LjYHPwJA.MouseLeave:Connect(function() if _lZBYGgZJ~=_VTQlJtMl then _enktMukE(_LjYHPwJA,{BackgroundTransparency=1},0.1) end end)
    if #_RaqqOyJF==1 then _NySZSkWs() end

    local _ZrDbseHl={}

    function _ZrDbseHl:Section(text)
        local _pvEznmal = _QLkOtXdu(string.char(70,114,97,109,101),{
            BackgroundTransparency=1,
            Size=UDim2.new(1,0,0,8),
        },_dthbMnYQ)
        _QLkOtXdu(string.char(70,114,97,109,101),{
            BackgroundColor3=Color3.fromRGB(30,30,30),
            BorderSizePixel=0,
            Size=UDim2.new(1,0,0,1),
            AnchorPoint=Vector2.new(0,0.5),
            Position=UDim2.new(0,0,0.5,0)
        },_pvEznmal)
    end

    function _ZrDbseHl:Toggle(text, default, cb)
        local _QOAPUOwf=default or false
        local _dwAjaFAn=_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.Card,BorderSizePixel=0,
            Size=UDim2.new(1,0,0,32)},_dthbMnYQ)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,8)},_dwAjaFAn)
        _dwAjaFAn.MouseEnter:Connect(function() _enktMukE(_dwAjaFAn,{BackgroundColor3=_UpPgzDlS.CardHov},0.1) end)
        _dwAjaFAn.MouseLeave:Connect(function() _enktMukE(_dwAjaFAn,{BackgroundColor3=_UpPgzDlS.Card},0.1) end)
        _QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{Text=text,Font=Enum.Font.GothamMedium,TextSize=12,
            TextColor3=_UpPgzDlS.Text,BackgroundTransparency=1,
            Size=UDim2.new(1,-48,1,0),Position=UDim2.new(0,44,0,0),
            TextXAlignment=Enum.TextXAlignment.Left},_dwAjaFAn)
        local _vTHUBwhe=_QLkOtXdu(string.char(70,114,97,109,101),{
            BackgroundColor3=_QOAPUOwf and _UpPgzDlS.Accent or _UpPgzDlS.TogOff,
            BorderSizePixel=0,Size=UDim2.new(0,28,0,16),
            AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,8,0.5,0)},_dwAjaFAn)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(1,0)},_vTHUBwhe)
        local _dxXbAjPm=_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.White,BorderSizePixel=0,
            Size=UDim2.new(0,12,0,12),AnchorPoint=Vector2.new(0,0.5),
            Position=_QOAPUOwf and UDim2.new(1,-14,0.5,0) or UDim2.new(0,2,0.5,0)},_vTHUBwhe)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(1,0)},_dxXbAjPm)
        _QLkOtXdu(string.char(84,101,120,116,66,117,116,116,111,110),{Text=string.char(),BackgroundTransparency=1,
            Size=UDim2.new(1,0,1,0)},_dwAjaFAn).MouseButton1Click:Connect(function()
            _QOAPUOwf=not _QOAPUOwf
            _enktMukE(_vTHUBwhe,{BackgroundColor3=_QOAPUOwf and _UpPgzDlS.Accent or _UpPgzDlS.TogOff},0.16)
            _enktMukE(_dxXbAjPm,{Position=_QOAPUOwf and UDim2.new(1,-14,0.5,0) or UDim2.new(0,2,0.5,0)},0.16)
            if cb then cb(_QOAPUOwf) end
        end)
    end
    function _ZrDbseHl:DualToggleBtn(text1, default1, cb1, text2, cb2)
        local _QOAPUOwf=default1 or false
        local _dwAjaFAn=_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.Card,BorderSizePixel=0,
            Size=UDim2.new(1,0,0,36)},_dthbMnYQ)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,8)},_dwAjaFAn)
        _dwAjaFAn.MouseEnter:Connect(function() _enktMukE(_dwAjaFAn,{BackgroundColor3=_UpPgzDlS.CardHov},0.1) end)
        _dwAjaFAn.MouseLeave:Connect(function() _enktMukE(_dwAjaFAn,{BackgroundColor3=_UpPgzDlS.Card},0.1) end)
        
        
        local _vTHUBwhe=_QLkOtXdu(string.char(70,114,97,109,101),{
            BackgroundColor3=_QOAPUOwf and _UpPgzDlS.Accent or _UpPgzDlS.TogOff,
            BorderSizePixel=0,Size=UDim2.new(0,28,0,16),
            AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,8,0.5,0)},_dwAjaFAn)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(1,0)},_vTHUBwhe)
        local _dxXbAjPm=_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.White,BorderSizePixel=0,
            Size=UDim2.new(0,12,0,12),AnchorPoint=Vector2.new(0,0.5),
            Position=_QOAPUOwf and UDim2.new(1,-14,0.5,0) or UDim2.new(0,2,0.5,0)},_vTHUBwhe)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(1,0)},_dxXbAjPm)
        _QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{Text=text1,Font=Enum.Font.GothamMedium,TextSize=12,
            TextColor3=_UpPgzDlS.Text,BackgroundTransparency=1,
            Size=UDim2.new(0.5,-48,1,0),Position=UDim2.new(0,44,0,0),
            TextXAlignment=Enum.TextXAlignment.Left},_dwAjaFAn)
        local _gLZgAHnV=_QLkOtXdu(string.char(84,101,120,116,66,117,116,116,111,110),{Text=string.char(),BackgroundTransparency=1,
            Size=UDim2.new(0.5,0,1,0)},_dwAjaFAn)
        _gLZgAHnV.MouseButton1Click:Connect(function()
            _QOAPUOwf=not _QOAPUOwf
            _enktMukE(_vTHUBwhe,{BackgroundColor3=_QOAPUOwf and _UpPgzDlS.Accent or _UpPgzDlS.TogOff},0.16)
            _enktMukE(_dxXbAjPm,{Position=_QOAPUOwf and UDim2.new(1,-14,0.5,0) or UDim2.new(0,2,0.5,0)},0.16)
            if cb1 then cb1(_QOAPUOwf) end
        end)
        
        
        local _MZiRFTdp=_QLkOtXdu(string.char(84,101,120,116,66,117,116,116,111,110),{Text=text2,Font=Enum.Font.GothamBold,TextSize=11,
            TextColor3=_UpPgzDlS.White,BackgroundColor3=_UpPgzDlS.Accent,BorderSizePixel=0,
            Size=UDim2.new(0.4,0,0,24),AnchorPoint=Vector2.new(1,0.5),
            Position=UDim2.new(1,-8,0.5,0),AutoButtonColor=false},_dwAjaFAn)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,6)},_MZiRFTdp)
        _MZiRFTdp.MouseEnter:Connect(function() _enktMukE(_MZiRFTdp,{BackgroundColor3=_UpPgzDlS.AccentHi},0.1) end)
        _MZiRFTdp.MouseLeave:Connect(function() _enktMukE(_MZiRFTdp,{BackgroundColor3=_UpPgzDlS.Accent},0.1) end)
        _MZiRFTdp.MouseButton1Click:Connect(function()
            _enktMukE(_MZiRFTdp,{Size=UDim2.new(0.4,-4,0,22)},0.07)
            task.delay(0.08,function() _enktMukE(_MZiRFTdp,{Size=UDim2.new(0.4,0,0,24)},0.1) end)
            if cb2 then cb2(_MZiRFTdp) end
        end)
    end

    function _ZrDbseHl:Slider(text, min, _sqttqRmu, default, cb)
        local _soMmPlJx=math.clamp(default,min,_sqttqRmu)
        local _dwAjaFAn=_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.Card,BorderSizePixel=0,
            Size=UDim2.new(1,0,0,44)},_dthbMnYQ)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,8)},_dwAjaFAn)
        _dwAjaFAn.MouseEnter:Connect(function() _enktMukE(_dwAjaFAn,{BackgroundColor3=_UpPgzDlS.CardHov},0.1) end)
        _dwAjaFAn.MouseLeave:Connect(function() _enktMukE(_dwAjaFAn,{BackgroundColor3=_UpPgzDlS.Card},0.1) end)
        _QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{Text=text,Font=Enum.Font.GothamMedium,TextSize=12,
            TextColor3=_UpPgzDlS.Text,BackgroundTransparency=1,
            Size=UDim2.new(1,-60,0,22),Position=UDim2.new(0,10,0,3),
            TextXAlignment=Enum.TextXAlignment.Left},_dwAjaFAn)
        local _BKSWkMee=_QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{Text=tostring(_soMmPlJx),Font=Enum.Font.GothamBold,
            TextSize=10,TextColor3=_UpPgzDlS.Accent,BackgroundTransparency=1,
            Size=UDim2.new(0,48,0,22),Position=UDim2.new(1,-58,0,3),
            TextXAlignment=Enum.TextXAlignment.Right},_dwAjaFAn)
        local _ijxCQfRh=_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.TogOff,BorderSizePixel=0,
            Size=UDim2.new(1,-20,0,3),Position=UDim2.new(0,10,0,28)},_dwAjaFAn)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(1,0)},_ijxCQfRh)
        local _ztlzoRpr=_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.Accent,BorderSizePixel=0,
            Size=UDim2.new((_soMmPlJx-min)/(_sqttqRmu-min),0,1,0)},_ijxCQfRh)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(1,0)},_ztlzoRpr)
        local _dSHipjPu=_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.White,BorderSizePixel=0,
            Size=UDim2.new(0,10,0,10),AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.new((_soMmPlJx-min)/(_sqttqRmu-min),0,0.5,0)},_ijxCQfRh)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(1,0)},_dSHipjPu)
        local _bnIXKkSQ=false
        local function _VnDILRTO(x)
            local _vVvitZca=math.clamp((x-_ijxCQfRh.AbsolutePosition.X)/_ijxCQfRh.AbsoluteSize.X,0,1)
            _soMmPlJx=math.floor(min+(_sqttqRmu-min)*_vVvitZca)
            _BKSWkMee.Text=tostring(_soMmPlJx)
            _ztlzoRpr.Size=UDim2.new(_vVvitZca,0,1,0)
            _dSHipjPu.Position=UDim2.new(_vVvitZca,0,0.5,0)
            if cb then cb(_soMmPlJx) end
        end
        _dwAjaFAn.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then _bnIXKkSQ=true; _VnDILRTO(i.Position.X) end
        end)
        _HuJHNeLX.InputChanged:Connect(function(i)
            if _bnIXKkSQ and i.UserInputType==Enum.UserInputType.MouseMovement then _VnDILRTO(i.Position.X) end
        end)
        _HuJHNeLX.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then _bnIXKkSQ=false end
        end)
    end

    function _ZrDbseHl:Button(text, cb)
        local _dwAjaFAn=_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.Card,BorderSizePixel=0,
            Size=UDim2.new(1,0,0,36)},_dthbMnYQ)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,8)},_dwAjaFAn)
        _dwAjaFAn.MouseEnter:Connect(function() _enktMukE(_dwAjaFAn,{BackgroundColor3=_UpPgzDlS.CardHov},0.1) end)
        _dwAjaFAn.MouseLeave:Connect(function() _enktMukE(_dwAjaFAn,{BackgroundColor3=_UpPgzDlS.Card},0.1) end)
        local _sOrUbahf=_QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{Text=text,Font=Enum.Font.GothamMedium,TextSize=12,
            TextColor3=_UpPgzDlS.Text,BackgroundTransparency=1,
            Size=UDim2.new(1,-78,1,0),Position=UDim2.new(0,10,0,0),
            TextXAlignment=Enum.TextXAlignment.Left},_dwAjaFAn)
        local _MZiRFTdp=_QLkOtXdu(string.char(84,101,120,116,66,117,116,116,111,110),{Text=string.char(82,85,78),Font=Enum.Font.GothamBold,TextSize=11,
            TextColor3=_UpPgzDlS.White,BackgroundColor3=_UpPgzDlS.Accent,BorderSizePixel=0,
            Size=UDim2.new(0,52,0,24),AnchorPoint=Vector2.new(1,0.5),
            Position=UDim2.new(1,-10,0.5,0),AutoButtonColor=false},_dwAjaFAn)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,6)},_MZiRFTdp)
        _MZiRFTdp.MouseEnter:Connect(function() _enktMukE(_MZiRFTdp,{BackgroundColor3=_UpPgzDlS.AccentHi},0.1) end)
        _MZiRFTdp.MouseLeave:Connect(function() _enktMukE(_MZiRFTdp,{BackgroundColor3=_UpPgzDlS.Accent},0.1) end)
        _MZiRFTdp.MouseButton1Click:Connect(function()
            _enktMukE(_MZiRFTdp,{Size=UDim2.new(0,48,0,22)},0.07)
            task.delay(0.08,function() _enktMukE(_MZiRFTdp,{Size=UDim2.new(0,52,0,24)},0.1) end)
            if cb then cb(_sOrUbahf) end
        end)
        return _dwAjaFAn, _sOrUbahf
    end

    function _ZrDbseHl:Label(text, _soMmPlJx)
        local _dwAjaFAn=_QLkOtXdu(string.char(70,114,97,109,101),{BackgroundColor3=_UpPgzDlS.Card,BorderSizePixel=0,
            Size=UDim2.new(1,0,0,32)},_dthbMnYQ)
        _QLkOtXdu(string.char(85,73,67,111,114,110,101,114),{CornerRadius=UDim.new(0,8)},_dwAjaFAn)
        _QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{Text=text,Font=Enum.Font.GothamMedium,TextSize=12,
            TextColor3=_UpPgzDlS.Text,BackgroundTransparency=1,
            Size=UDim2.new(1,-90,1,0),Position=UDim2.new(0,10,0,0),
            TextXAlignment=Enum.TextXAlignment.Left},_dwAjaFAn)
        if _soMmPlJx then
            _QLkOtXdu(string.char(84,101,120,116,76,97,98,101,108),{Text=_soMmPlJx,Font=Enum.Font.GothamBold,TextSize=11,
                TextColor3=_UpPgzDlS.Accent,BackgroundTransparency=1,
                Size=UDim2.new(0,80,1,0),AnchorPoint=Vector2.new(1,0),
                Position=UDim2.new(1,-10,0,0),
                TextXAlignment=Enum.TextXAlignment.Right},_dwAjaFAn)
        end
    end

    return _ZrDbseHl
end





local _qmJfFCPb = _iXBjTiQU(string.char(226,154,148,32,67,111,109,98,97,116))
_qmJfFCPb:Toggle(string.char(83,105,108,101,110,116,32,65,105,109,32,32,91,67,97,112,115,76,111,99,107,93), false, function(v)
    _hiyOLKmJ.AimOn=v
    _SJVwthSI(v and string.char(83,105,108,101,110,116,32,65,105,109,32,79,78) or string.char(83,105,108,101,110,116,32,65,105,109,32,79,70,70), v and _UpPgzDlS.AccentHi or _UpPgzDlS.TextDim)
end)
_qmJfFCPb:Slider(string.char(70,79,86,32,83,105,122,101),      20, 150, 120, function(v) _hiyOLKmJ.AimFOV=v end)
_qmJfFCPb:Toggle(string.char(83,104,111,119,32,70,79,86,32,67,105,114,99,108,101),   false, function(v) _hiyOLKmJ.AimFOVShow=v end)

_qmJfFCPb:Section(string.char())
_qmJfFCPb:Toggle(string.char(65,105,109,32,97,116,32,72,101,97,100),       true,  function(v) _hiyOLKmJ.AimHead=v end)
_qmJfFCPb:Toggle(string.char(84,101,97,109,32,67,104,101,99,107),        false, function(v) _hiyOLKmJ.AimTeam=v end)
_qmJfFCPb:Toggle(string.char(86,105,115,105,98,105,108,105,116,121,32,67,104,101,99,107),  true,  function(v) _hiyOLKmJ.AimVis=v end)

_qmJfFCPb:Section(string.char())
_qmJfFCPb:Slider(string.char(65,105,109,32,83,109,111,111,116,104,32,37),  50, 95, 85, function(v) _hiyOLKmJ.AimSmooth=v/100 end)

_qmJfFCPb:Section(string.char())
_qmJfFCPb:Toggle(string.char(76,101,97,100,32,83,104,111,116), false, function(v) _hiyOLKmJ.Prediction=v end)
_qmJfFCPb:Slider(string.char(80,114,101,100,32,83,116,114,101,110,103,116,104), 0, 100, 50, function(v) _hiyOLKmJ.PredStr=v end)

_qmJfFCPb:Section(string.char())
_qmJfFCPb:Toggle(string.char(78,111,32,82,101,99,111,105,108), false, function(v)
    _hiyOLKmJ.NoRecoil=v; _jYTPwaEL=nil
    _SJVwthSI(v and (string.char(78,111,32,82,101,99,111,105,108,32,79,78,32,32,40).._hiyOLKmJ.RecoilReduce..string.char(37,41)) or string.char(78,111,32,82,101,99,111,105,108,32,79,70,70))
end)
_qmJfFCPb:Slider(string.char(82,101,99,111,105,108,32,82,101,100,117,99,101,32,37), 30, 90, 65, function(v) _hiyOLKmJ.RecoilReduce=v end)
_qmJfFCPb:Toggle(string.char(84,114,105,103,103,101,114,98,111,116), false, function(v)
    _hiyOLKmJ.Triggerbot=v
    _SJVwthSI(v and string.char(84,114,105,103,103,101,114,98,111,116,32,79,78) or string.char(84,114,105,103,103,101,114,98,111,116,32,79,70,70))
end)
_qmJfFCPb:Slider(string.char(84,114,105,103,103,101,114,32,68,101,108,97,121,32,40,109,115,41), 40, 200, 80, function(v) _hiyOLKmJ.TrigDelay=v end)

_qmJfFCPb:Section(string.char())
_qmJfFCPb:Toggle(string.char(67,97,109,101,114,97,32,76,111,99,107), false, function(v) _hiyOLKmJ.CamLock=v end)
_qmJfFCPb:Slider(string.char(76,111,99,107,32,83,109,111,111,116,104,110,101,115,115),  1, 20, 8, function(v) _hiyOLKmJ.CamSmooth=v/100 end)
_qmJfFCPb:Toggle(string.char(72,105,116,98,111,120,32,69,120,116,101,110,100), false, function(v)
    _hiyOLKmJ.HitboxOn=v
    _SJVwthSI(v and (string.char(72,105,116,98,111,120,32,79,78,32,32,195,151)..string.format(string.char(37,46,49,102),_hiyOLKmJ.HitboxMult)) or string.char(72,105,116,98,111,120,32,79,70,70))
end)
_qmJfFCPb:Slider(string.char(70,79,86,32,77,117,108,116,105,112,108,105,101,114), 10, 50, 20, function(v) _hiyOLKmJ.HitboxMult=v/10 end)

_qmJfFCPb:Section(string.char())
_qmJfFCPb:Toggle(string.char(66,117,110,110,121,32,72,111,112), false, function(v) _hiyOLKmJ.BHop=v; _jgKFMnVF(v) end)


local _pjoGXjPv = _iXBjTiQU(string.char(240,159,145,129,32,86,105,115,117,97,108,115))
_pjoGXjPv:Toggle(string.char(67,111,114,110,101,114,32,66,111,120),    false, function(v) _hiyOLKmJ.ESPCorner=v end)
_pjoGXjPv:Toggle(string.char(78,97,109,101,115,32,43,32,68,105,115,116),  false, function(v) _hiyOLKmJ.ESPName=v end)
_pjoGXjPv:Toggle(string.char(72,101,97,108,116,104,32,66,97,114),    false, function(v) _hiyOLKmJ.ESPHealth=v end)
_pjoGXjPv:Toggle(string.char(83,107,101,108,101,116,111,110),      false, function(v) _hiyOLKmJ.ESPSkel=v end)
_pjoGXjPv:Toggle(string.char(84,114,97,99,101,114,115),       false, function(v) _hiyOLKmJ.ESPTracer=v end)

_pjoGXjPv:Section(string.char())
_pjoGXjPv:Slider(string.char(77,97,120,32,69,83,80,32,68,105,115,116), 50, 1000, 500, function(v) _hiyOLKmJ.ESPMaxDist=v end)

_pjoGXjPv:Section(string.char())
local _qbmbJnum = {string.char(83,111,108,111),string.char(84,101,97,109,115)}
local _hrhSDxbj = 1
_pjoGXjPv:DualToggleBtn(string.char(83,104,111,119,32,84,101,97,109,32,69,83,80), true, function(v)
    _hiyOLKmJ.ESPTeam=v
    _SJVwthSI(v and string.char(84,101,97,109,32,69,83,80,32,115,104,111,119,110) or string.char(84,101,97,109,32,69,83,80,32,104,105,100,100,101,110))
end, string.char(77,111,100,101,58,32).._hiyOLKmJ.MatchMode, function(_LjYHPwJA)
    _hrhSDxbj = (_hrhSDxbj % #_qbmbJnum) + 1
    _hiyOLKmJ.MatchMode = _qbmbJnum[_hrhSDxbj]
    if _LjYHPwJA then _LjYHPwJA.Text = string.char(77,111,100,101,58,32).._hiyOLKmJ.MatchMode end
    _SJVwthSI(string.char(77,111,100,101,58,32).._hiyOLKmJ.MatchMode, _UpPgzDlS.AccentHi)
end)

_pjoGXjPv:Section(string.char())
_pjoGXjPv:Toggle(string.char(70,80,83,32,67,111,117,110,116,101,114),  false, function(v) _hiyOLKmJ.FPSCount=v; _fcjWzkLD.Visible=v end)
_pjoGXjPv:Toggle(string.char(70,80,83,32,85,110,108,111,99,107,101,114), false, function(v)
    if setfpscap then pcall(setfpscap, v and 9999 or 60) end
end)


local _YYrtxRND = _iXBjTiQU(string.char(226,154,153,32,83,101,116,116,105,110,103,115))
_YYrtxRND:Toggle(string.char(65,110,116,105,45,65,70,75), false, function(v) _hiyOLKmJ.AntiAFK=v end)
_YYrtxRND:Button(string.char(82,101,106,111,105,110), function()
    pcall(function() game:GetService(string.char(84,101,108,101,112,111,114,116,83,101,114,118,105,99,101)):Teleport(game.PlaceId,_UeJdHgxc) end)
end)
_YYrtxRND:Button(string.char(67,111,112,121,32,71,97,109,101,32,73,68), function()
    if setclipboard then pcall(setclipboard,tostring(game.PlaceId)) end
    _SJVwthSI(string.char(71,97,109,101,32,73,68,32,99,111,112,105,101,100,33))
end)
_YYrtxRND:Button(string.char(83,99,97,110,32,82,111,117,110,100,32,69,118,101,110,116,115), function()
    local _kLHaYNSZ = {}
    for _DajaONQk,v in ipairs(_NwuZcdFB:GetChildren()) do
        if v:IsA(string.char(82,101,109,111,116,101,69,118,101,110,116)) then
            table.insert(_kLHaYNSZ, v.Name)
            print(string.char(91,84,45,72,85,66,93,32,82,101,109,111,116,101,69,118,101,110,116,58), v.Name)
        end
    end
    _SJVwthSI(string.char(70,111,117,110,100,32)..#_kLHaYNSZ..string.char(32,101,118,101,110,116,115,32,226,128,148,32,99,104,101,99,107,32,99,111,110,115,111,108,101))
end)

_YYrtxRND:Section(string.char())
_YYrtxRND:Label(string.char(84,111,103,103,108,101,32,72,117,98),        string.char(82,105,103,104,116,83,104,105,102,116))
_YYrtxRND:Label(string.char(84,111,103,103,108,101,32,83,105,108,101,110,116,32,65,105,109), string.char(67,97,112,115,76,111,99,107))

_YYrtxRND:Section(string.char())
_YYrtxRND:Label(string.char(86,101,114,115,105,111,110),  string.char(118,53,46,48,32,86,73,80))
_YYrtxRND:Label(string.char(67,114,101,97,116,111,114),  string.char(116,114,105,120,120,115,111,98,97,115,101,100))
_YYrtxRND:Label(string.char(69,120,101,99,117,116,111,114), string.char(88,101,110,111))
_YYrtxRND:Label(string.char(84,97,114,103,101,116),   string.char(65,114,115,101,110,97,108))


_SJVwthSI(string.char(84,45,72,85,66,32,118,53,46,48,32,86,73,80,32,108,111,97,100,101,100) .. (_YxQyJtEu and string.char(32,32,226,156,147) or string.char(32,32,104,111,111,107,32,102,97,105,108)),
      _YxQyJtEu and _UpPgzDlS.AccentHi or Color3.fromRGB(255,80,80))
print(string.char(91,84,45,72,85,66,93,32,118,53,46,48,32,86,73,80,32,124,32,65,114,115,101,110,97,108,32,124,32,104,111,111,107,58), _YxQyJtEu)