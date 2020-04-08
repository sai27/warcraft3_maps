_ENV = setenv(...,_ENV);
--转换256进制整数
ids1 = {}
ids2 = {}

local function _id(a)
	local r = ('>I4'):pack(a)
	base.ids1[a] = r
	base.ids2[r] = a
	return r
end

function id2string(a)
	return ids1[a] or _id(a)
end

local function __id2(a)
	local r = ('>I4'):unpack(a)
	ids2[a] = r
	ids1[r] = a
	return r
end

function string2id(a)
	return ids2[a] or __id2(a)
end