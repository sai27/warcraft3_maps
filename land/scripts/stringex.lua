-- 字符串处理库

-- 如果str包含sub, 则返回true
function string.contains(str, sub)
    return str:find(sub, nil, true) ~= nil
end

-- 以sep(为特殊字符, 使用模式匹配)为分割符将str分割为一个table
-- maxsplit : 最大分割次数, 默认为全部分割
-- include  : 返回的table中是否包含分隔符
-- plain    : 分隔符是否进行模式匹配, 默认为不使用
function string.psplit(str, sep, maxsplit, include)
    return str:split(sep, maxsplit, include, false)
end

-- 以sep(为特殊字符, 使用模式匹配)为分割符将str分割为一个table
-- maxsplit : 最大分割次数, 默认为全部分割
-- include  : 返回的table中是否包含分隔符
-- plain    : 分隔符是否进行模式匹配, 默认为不使用
function string.split(str, sep, maxsplit, include, plain)
    if not sep or sep == '' then
        local res = {}
        local key = 0
        for c in str:gmatch('.') do
            key = key + 1
            res[key] = c
        end
        return res
    end

    maxsplit = maxsplit or 0
    if plain == nil then
        plain = true
    end

    local res = {}
    local key = 0
    local i = 1
    local startpos, endpos
    local match
    while i <= #str + 1 do
        -- 查找下一个分割点
        startpos, endpos = str:find(sep, i, plain)
        -- 如果找到插入表中
        if startpos then
            match = str:sub(i, startpos - 1)
            key = key + 1
            res[key] = match

            if include then
                key = key + 1
                res[key] = str:sub(startpos, endpos)
            end

            -- 如果达到最大分割次数了, 结束遍历
            if key == maxsplit - 1 then
                key = key + 1
                res[key] = str:sub(endpos + 1)
                break
            end
            i = endpos + 1
        -- 如果没找到, 那么把剩下的内容插入表中, 并结束遍历
        else
            key = key + 1
            res[key] = str:sub(i)
            break
        end
    end

    return res
end

function string.split1(str,delimiter)
    if str == nil or str == '' or delimiter == nil then
        return nil
    end

    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result,match)
    end
    return result
end

-- string.sub的包装
function string.slice(str, from, to)
    return str:sub(from or 1, to or #str)
end

-- 用str2替换str的from, to之间的内容
function string.splice(str, from, to, str2)
    return str:sub(1, from - 1)..str2..str:sub(to + 1)
end

-- 返回一个遍历str的迭代器
function string.it(str)
    return str:gmatch('.')
end

-- 去除str的前后空白符
function string.trim(str)
    return str:match('^%s*(.-)%s*$')
end

-- 将str所有空白字符替换为一个空白符
function string.spaces_collapse(str)
    return str:gsub('%s+', ' '):trim()
end

-- 将str中所有包含在chars中的字符移除
function string.stripchars(str, chars)
    return (str:gsub('['..chars:escape()..']', ''))
end

-- 返回str的字符长度
function string.length(str)
    return #str
end

-- 检测str是否以substr开始
function string.startswith(str, substr)
    return str:sub(1, #substr) == substr
end

-- 检测str是否以substr结束
function string.endswith(str, substr)
    return str:sub(-#substr) == substr
end

-- 检测str是否以start开始, 且以finish结束
function string.enclosed(str, start, finish)
    finish = finish or start
    return str:startswith(start) and str:endswith(finish)
end

-- 将str以start开始, 且以finish结束
function string.enclose(str, start, finish)
    finish = finish or start
    return start..str..finish
end

-- 以pad填充str左侧至len长度
function string.lpad(str, pad, len)
    local r = len-#str
    if r<0 then return str end
    return pad:rep(r) .. str
end

-- 以pad填充str右侧至len长度
function string.rpad(str, pad, len)
    local r = len-#str
    if r<0 then return str end
    return str .. pad:rep(r)
end

-- str左侧补零至len长度
function string.zfill(str, len)
    return str:lpad('0', len)
end

-- 空串判断
function string.empty(str)
    return str == ''
end
function string.null(str)
    return str == nil
end
function string.isnullorempty(str)
    return str == '' or str == nil
end

-- 将特殊字符进行转移处理
function string.escape(str)
    return (str:gsub('[[%]%%^$*()%.%+?-]', '%%%1'))
end

-- sub在str中出现的次数
function string.count(str, sub)
    return str:pcount(sub:escape())
end

-- pat在str中出现的次数
function string.pcount(str, pat)
    local _, c = string.gsub(str, pat, '')
    return c
end

-- 以size为大小将str拆分为一个table
function string.chunks(str, size)
    local res = {}
    local key = 0
    for i = 1, #str, size do
        key = key + 1
        rawset(res, key, str:sub(i, i + size - 1))
    end
    return res
end

function string.split_num(src)
	local tmp_sarray = src:split('*');
    local rst = {}
    if tmp_sarray == nil or #tmp_sarray == 0 then
        table.insert(rst,tonumber(src))
    else
        for _,v in ipairs(tmp_sarray) do
		    table.insert(rst,tonumber(v))
	    end
    end
	return rst;
end