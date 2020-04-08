_ENV = setenv(...,_ENV);

-- 缓存创建的单位
_globalunits = {}

fog = {
    name = "fog",
    help = "设置战争迷雾(int opt)",
    f = function (option)
        option = tonumber(option);
        if (option == 0) then
            common.FogEnable(true);
            common.FogMaskEnable(true);
            print("a");
        else
            common.FogEnable(false);
            common.FogMaskEnable(false);
            print("b");
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
    -- -createcircle hgry 0 0 0 600 120 120 -1 3 circle
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
                print (_angle);
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
    help = "发布命令 指定点(name, order, x, y)",
    -- -orderpoint cube move 100 100
    f = function(name, order, x, y)
        local units = _globalunits[name];
        if (units == nil) then
            return;
        end

        for i,v in ipairs(units) do
            common.IssuePointOrder(v, order, x, y);
        end
    end
};