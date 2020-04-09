_ENV = setenv(...,_ENV);

-- 缓存创建的单位
_globalunits = {}

fog = {
    name = "fog",
    help = "设置战争迷雾(int opt)",
    f = function (option)
        option = tonumber(option) or 0;
        if (option ~= 0) then
            common.FogEnable(true);
            common.FogMaskEnable(true);
        else
            common.FogEnable(false);
            common.FogMaskEnable(false);
        end
    end
};

createcube = {
    name = "create unit cube",
    help = "创建方形阵(name, playeridx, left, bottom, xcount, ycount, delta, angle, edgecount, to)",
    -- -createcube hsor 0 0 0 10 10 120 270 2 cube
    f = function (name, playeridx, left, bottom, xcount, ycount, delta, angle, edgecount, to)
        name        = name or "hfoo";
        playeridx   = tonumber(playeridx) or 0;
        left        = tonumber(left) or 0;
        bottom      = tonumber(bottom) or 0;
        xcount      = tonumber(xcount) or 1;
        ycount      = tonumber(ycount) or 1;
        delta       = tonumber(delta) or 120;
        angle       = tonumber(angle) or 270;
        edgecount   = tonumber(edgecount) or -1;

        local units = nil;
        local unit = nil;

        if (to ~= nil and type(to)~=string) then
            to = tostring(to);
            units = {}
        end

        local x = left;
        local y = bottom;
        for i=1, xcount do
            for j=1, ycount do
                unit = nil;
                if (edgecount > 0) then
                    if (i<edgecount+1 or i>(xcount - edgecount)) then
                        unit = common.CreateUnit(common.Player(playeridx), base.string2id(name), x, y, angle);
                    else
                        if (j<edgecount+1 or j>(ycount - edgecount)) then
                            unit = common.CreateUnit(common.Player(playeridx), base.string2id(name), x, y, angle);
                        end
                    end
                else
                    unit = common.CreateUnit(common.Player(playeridx), base.string2id(name), x, y, angle);
                end
                
                y = bottom + j * delta;

                if (units) then
                    if (unit) then
                        units[#units+1] = unit;
                    end
                end
            end
            x = left + i * delta;
            y = bottom;
        end

        if (units) then
            _globalunits[to] = units;
        end
    end
};

createcircle = {
    name = "create unit circle",
    help = "创建圆形阵(name, playeridx, left, bottom, xcount, ycount, delta, angle, edgecount, to)",
    -- -createcircle hrif 0 0 0 500 120 120 -1 2 circle
    f = function (name, playeridx, x, y, radius, deltaradius, deltacircle, angle, edgecount, to)
        name        = name or "hfoo";
        playeridx   = tonumber(playeridx) or 0;
        x           = tonumber(x) or 0;
        y           = tonumber(y) or 0;
        radius      = tonumber(radius) or 1000;
        deltaradius = tonumber(deltaradius) or 120;
        deltacircle = tonumber(deltacircle) or 120;
        angle       = tonumber(angle) or -1;
        edgecount   = tonumber(edgecount) or 1;

        local units = nil;
        if (to ~= nil and type(to)~=string) then
            to = tostring(to);
            units = {}
        end

        for _=1, edgecount do
            local len = 2*math.pi*radius;
            local _count = math.floor(len / deltacircle);
            local _rad = 2*math.pi / _count;
            
            for i=1, _count do
                local _angle = _rad*i;
            --    print (_angle);
                local _x = math.cos(_angle)*radius;
                local _y = math.sin(_angle)*radius;
                _x = _x + x;
                _y = _y + y;
                if (angle >=0 ) then
                    _angle = angle;
                else
                    if (angle == -2) then
                        _angle = math.deg(_angle) + 180;
                    else
                        _angle = math.deg(_angle);
                    end
                end
                local unit = common.CreateUnit(common.Player(playeridx), base.string2id(name), _x, _y, _angle);
                if (units) then
                    units[#units+1] = unit;
                end
         --       common.TriggerSleepAction(0.1);
            end
            radius = radius - deltaradius;
            if (radius <= 0) then
                break;
            end
        end

        if (units) then
            _globalunits[to] = units;
        end
    end
}

orderpoint = {
    name = "order point",
    help = "发布命令 指定点(set, order, x, y)",
    -- -createcube hsor 0 0 0 10 10 120 270 2 cube
    -- -orderpoint cube move 100 100
    f = function(set, order, x, y)
        x = tonumber(x) or 0;
        y = tonumber(y) or 0;

        local units = _globalunits[set];
        if (units == nil) then
            return;
        end

        for i,v in ipairs(units) do
            common.IssuePointOrder(v, order, x, y);
        end
    end
};

orderpointoffset = {
    name = "order point offset",
    help = "发布命令 偏移点(set, order, offset, angle, reverse)",
    -- -createcube hsor 0 0 0 10 10 120 0 2 cube
    -- -createcircle hrif 0 0 0 500 120 120 -1 2 circle
    -- -orderpointoffset cube move 100 0 true
    f = function(set, order, offset, angle, reverse)
        offset      = tonumber(offset) or 0;
        angle       = tonumber(angle) or 0;
        reverse     = reverse or "false";

        angle = math.rad(angle);

        local units = _globalunits[set];
        if (units == nil) then
            return;
        end
        
        local _count = #units;
        for i=1,_count do
            local v = nil;
            if (reverse == "false") then
                v = units[i];
            else
                v = units[_count-i+1];
                print("true")
            end

            local _x = common.GetUnitX(v);
            local _y = common.GetUnitY(v);
            _x = _x + offset * math.cos(angle);
            _y = _y + offset * math.sin(angle);
            common.IssuePointOrder(v, order, _x, _y);
        end
    end
};

orderself = {
    name = "order point offset",
    help = "发布命令 自身(set, order)",
    -- -orderself cube holdposition
    f = function(set, order)
        local units = _globalunits[set];
        if (units == nil) then
            return;
        end

        for i,v in ipairs(units) do
            common.IssueImmediateOrder(v, order);
        end
    end
}

-- 发布命令-目标
ordertarget = {
    name = "order point offset",
    help = "发布命令 自身(set, order)",
    -- -ordertarget
    f = function(set1, set2, order)
        local units1 = _globalunits[set1];
        if (units1 == nil) then
            return;
        end

        local units2 = _globalunits[set2];
        if (units2 == nil) then
            return;
        end

        if (#units1 ~= #units2) then
            return;
        end
        
        local _count = #units1;
        for i=1,_count do
            common.IssueTargetOrder(units1[i], order, units2[i]);
        end
    end
}

ally = {
    name = "player ally setting",
    help = "设置结盟状态(player1, player2, ally)",
    -- -ally 0 1 true
    f = function(player1, player2, ally)
        player1 = tonumber(player1) or 0;
        player2 = tonumber(player1) or 0;
        ally = ally or "false";

        if (ally == "false") then
            common.SetPlayerAlliance(common.Player(player1), common.Player(player2), common.ConvertAllianceType(0), false);
        else
            common.SetPlayerAlliance(common.Player(player1), common.Player(player2), common.ConvertAllianceType(0), true);
        end
        
    end
}

playanim = {
    name = "player anim",
    help = "播放动画(set, anim, type) type 0:normal type 1:rare",
    f = function (set, anim, type)
        anim = anim or "stand";
        type = tonumber(type) or 0;

        local units = _globalunits[set];
        if (units == nil) then
            return;
        end

        for i,v in ipairs(units) do
            common.SetUnitAnimationWithRarity(v, anim, common.ConvertRarityControl(type));
        end
    end
}

movespeed = {
    name = "move speed",
    help = "设置移动速度(set, speed)",
    f = function (set, speed)
        speed = tonumber(speed);

        local units = _globalunits[set];
        if (units == nil) then
            return;
        end

        for i,v in ipairs(units) do
            if (speed) then
                common.SetUnitMoveSpeed(v, speed);
            else
                common.SetUnitMoveSpeed(v, common.GetUnitDefaultMoveSpeed(v));
            end
        end
    end
}

-- 设置时间与流逝速度
time = {
    name = "time",
    help = "设置时间(time，scale)",
    f = function (time,scale)
        common.SetFloatGameState(common.ConvertFGameState(2),time);
        common.SetTimeOfDayScale(scale);
    end
}

-- 设置科技

tech = {
    name = "tech",
    help = "设置科技(time，scale)",
    f = function (playerid,name, level)
        common.SetPlayerTechResearched(common.Player(playerid),base.string2id(name),level);
    end
}

-- 删除技能
delability = {
    name = "delability",
    help = "删除技能(set,name)",
    f = function (set,name)
        local units = _globalunits[set];
        if (units == nil) then
            return;
        end

        for i,v in ipairs(units) do
            common.UnitRemoveAbility(v, base.string2id(name));
        end
    end
}

-- 设置属性
setstate = {
    name = "setstate",
    help = "设置属性(set,idx,value)",
    f = function (set,idx,value)
        idx = tonumber(idx) or 0;
        value = tonumber(value) or 100;

        local units = _globalunits[set];
        if (units == nil) then
            return;
        end

        for i,v in ipairs(units) do
            common.SetUnitState(v, common.ConvertUnitState(idx),value);
        end
    end
}

-- 删除选择的单位