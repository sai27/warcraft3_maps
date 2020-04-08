_ENV = setenv(...,_ENV);

sf = {
    name = "setfog",
    help = "设置战争迷雾(boolean opt)",
    f = function (option)
        if (option == true) then
            common.FogEnable(true);
            common.FogMaskEnable(true);
        else
            common.FogEnable(false);
            common.FogMaskEnable(false);
        end
    end
}
