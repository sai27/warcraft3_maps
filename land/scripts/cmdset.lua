_ENV = setenv(...,_ENV);

-- 初始化操作
local initTrigger = common.CreateTrigger();
local initAction = function()
    handler.fog.f(0);
    handler.time.f(12,0);
end

common.TriggerAddAction(initTrigger, initAction);
common.TriggerRegisterTimerEvent(initTrigger,0, false);



-- Esc触发
local actionExeTrigger = common.CreateTrigger();

--一系列命令集合
local actionExeAction = function()
    local x1a = -120;
    local x2a = -200;
    local x3a = -200;
    local y1a = 0;
    local y2a = -35;
    local y3a = 35;

    local x1b = 120;
    local x2b = 200;
    local x3b = 200;
    local y1b = 0;
    local y2b = -35;
    local y3b = 35;

    local dist = 250;
    local count = 6;

    local playera = 0;
    local playerb = 1;
    -- hum农民
    handler.createcube.f("hmil", playera, x1a, y1a, 1, count, dist, 0, -1, "v_hpea");
    handler.orderself.f("v_hpea","holdposition");
    handler.delability.f("v_hpea","ARal");
    
    -- hum男巫
    handler.createcube.f("hmpr", playera, x2a, y2a, 1, count, dist, 0, -1, "v_hmpr");
    handler.tech.f(playera,"Rhpt",2);
    handler.orderself.f("v_hmpr","healoff");
    handler.orderself.f("v_hmpr","holdposition");
    handler.delability.f("v_hmpr","Aatk");
    --handler.setstate.f("v_hmpr",3, 800);
    handler.setstate.f("v_hmpr",2, 800);

    -- hum女巫
    handler.createcube.f("hsor", playera, x3a, y3a, 1, count, dist, 0, -1, "v_hsor");
    handler.tech.f(playera,"Rhst",2);
    handler.orderself.f("v_hsor","slowoff");
    handler.orderself.f("v_hsor","holdposition");
    handler.delability.f("v_hsor","Aatk");
    --handler.setstate.f("v_hsor",3, 800);
    handler.setstate.f("v_hsor",2, 800);

    -- ud农民
    handler.createcube.f("uaco", playerb, x1b, y1b, 1, count, dist, 180, -1, "v_uaco");
    handler.orderself.f("v_uaco","holdposition");

    -- ud男巫
    handler.createcube.f("unec", playerb, x2b, y2b, 1, count, dist, 180, -1, "v_unec");
    handler.tech.f(playerb,"Rune",2);
    handler.orderself.f("v_unec","raisedeadoff");
    handler.orderself.f("v_unec","holdposition");
    handler.delability.f("v_unec","Aatk");
    --handler.setstate.f("v_unec",3, 800);
    handler.setstate.f("v_unec",2, 800);

    -- ud女巫
    handler.createcube.f("uban", playerb, x3b, y3b, 1, count, dist, 180, -1, "v_uban");
    handler.tech.f(playerb,"Ruba",2);
    handler.orderself.f("v_uban","curseoff");
    handler.orderself.f("v_uban","holdposition");
    handler.delability.f("v_uban","Aatk");
    --handler.setstate.f("v_uban",3, 800);
    handler.setstate.f("v_uban",2, 800);

    common.TriggerSleepAction(5);

    -- 心灵之火
    handler.ordertarget.f("v_hmpr", "v_hpea", "innerfire");

    common.TriggerSleepAction(1);

    -- 魔法护盾
    handler.ordertarget.f("v_uban", "v_uaco", "antimagicshell");

    common.TriggerSleepAction(1);

    -- 狂热
    handler.ordertarget.f("v_unec", "v_uaco", "unholyfrenzy");

    common.TriggerSleepAction(2);

    handler.orderpointoffset.f("v_hpea","attack", 90, 0);
    handler.orderpointoffset.f("v_uaco","attack", 90, 180,"true");

    common.TriggerSleepAction(0.3);
    -- 减速
    handler.ordertarget.f("v_hsor", "v_uaco", "slow");

    -- 残废
    handler.ordertarget.f("v_unec", "v_hpea", "cripple");
    -- 诅咒
    handler.ordertarget.f("v_uban", "v_hpea", "curse");

    common.TriggerSleepAction(28);
    -- 减速
    handler.ordertarget.f("v_hsor", "v_uaco", "slow");
    -- 心灵之火
    handler.ordertarget.f("v_hmpr", "v_hpea", "innerfire");

    common.TriggerSleepAction(2);

    -- 魔法护盾
    handler.ordertarget.f("v_uban", "v_uaco", "antimagicshell");
    -- 狂热
    handler.ordertarget.f("v_unec", "v_uaco", "unholyfrenzy");

    common.TriggerSleepAction(1);
    -- 残废
    handler.ordertarget.f("v_unec", "v_hpea", "cripple");
    -- 诅咒
    handler.ordertarget.f("v_uban", "v_hpea", "curse");
end

common.TriggerAddAction(actionExeTrigger, actionExeAction);
common.TriggerRegisterPlayerEvent(actionExeTrigger,common.Player(0), common.ConvertPlayerEvent(17));