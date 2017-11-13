--
-- ���촰������Ⱦɫ���
-- By ����@˫����@ݶ����
-- ZhaiYiMing.CoM
-- 2014��5��19��05:07:02
--
local _L = MY.LoadLangPack(MY.GetAddonInfo().szRoot.."MY_Farbnamen/lang/")
local _SUB_ADDON_FOLDER_NAME_ = "MY_Farbnamen"
local XML_LINE_BREAKER = XML_LINE_BREAKER
local tinsert, tconcat, tremove = table.insert, table.concat, table.remove
---------------------------------------------------------------
-- ���ú�����
---------------------------------------------------------------
MY.CreateDataRoot(MY_DATA_PATH.SERVER)
local SZ_CONFIG_PATH = "config/player_force_color.jx3dat"
local SZ_DB_PATH = MY.FormatPath({"cache/player_info.db", MY_DATA_PATH.SERVER})
local Config_Default = {
	tForceColor = MY.LoadLUAData({SZ_CONFIG_PATH, MY_DATA_PATH.GLOBAL}) or {
		[FORCE_TYPE.JIANG_HU ] = {255, 255, 255}, -- ����
		[FORCE_TYPE.SHAO_LIN ] = {255, 178, 95 }, -- ����
		[FORCE_TYPE.WAN_HUA  ] = {196, 152, 255}, -- ��
		[FORCE_TYPE.TIAN_CE  ] = {255, 111, 83 }, -- ���
		[FORCE_TYPE.CHUN_YANG] = {89 , 224, 232}, -- ����
		[FORCE_TYPE.QI_XIU   ] = {255, 129, 176}, -- ����
		[FORCE_TYPE.WU_DU    ] = {55 , 147, 255}, -- �嶾
		[FORCE_TYPE.TANG_MEN ] = {121, 183, 54 }, -- ����
		[FORCE_TYPE.CANG_JIAN] = {214, 249, 93 }, -- �ؽ�
		[FORCE_TYPE.GAI_BANG ] = {205, 133, 63 }, -- ؤ��
		[FORCE_TYPE.MING_JIAO] = {240, 70 , 96 }, -- ����
		[FORCE_TYPE.CANG_YUN ] = {180, 60 , 0  }, -- ����
		[FORCE_TYPE.CHANG_GE ] = {100, 250, 180}, -- ����
		[FORCE_TYPE.BA_DAO   ] = {106 ,108, 189}, -- �Ե�
	},
}
local DB = SQLite3_Open(SZ_DB_PATH)
if not DB then
	return MY.Sysmsg({_L['Cannot connect to database!!!'], r = 255, g = 0, b = 0}, _L["MY_Farbnamen"])
end
DB:Execute("CREATE TABLE IF NOT EXISTS InfoCache (id INTEGER PRIMARY KEY, name VARCHAR(20) NOT NULL, force INTEGER, role INTEGER, level INTEGER, title VARCHAR(20), camp INTEGER, tong INTEGER)")
DB:Execute("CREATE INDEX IF NOT EXISTS info_cache_name_idx ON InfoCache(name)")
local DBI_W  = DB:Prepare("REPLACE INTO InfoCache (id, name, force, role, level, title, camp, tong) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")
local DBI_RI = DB:Prepare("SELECT id, name, force, role, level, title, camp, tong FROM InfoCache WHERE id = ?")
local DBI_RN = DB:Prepare("SELECT id, name, force, role, level, title, camp, tong FROM InfoCache WHERE name = ?")
DB:Execute("CREATE TABLE IF NOT EXISTS TongCache (id INTEGER PRIMARY KEY, name VARCHAR(20))")
local DBT_W  = DB:Prepare("REPLACE INTO TongCache (id, name) VALUES (?, ?)")
local DBT_RI = DB:Prepare("SELECT id, name FROM InfoCache WHERE id = ?")

MY_Farbnamen = MY_Farbnamen or {
	bEnabled = true,
}
RegisterCustomData("MY_Farbnamen.bEnabled")

do if IsDebugClient() then -- �ɰ滺��ת��
	local SZ_IC_PATH = MY.FormatPath("cache/PLAYER_INFO/$relserver/")
	if IsLocalFileExist(SZ_IC_PATH) then
		MY.Debug({"Farbnamen info cache trans from file to sqlite start!"}, "MY_Farbnamen", MY_DEBUG.LOG)
		DB:Execute("BEGIN TRANSACTION")
		for i = 0, 999 do
			local data = MY.LoadLUAData("cache/PLAYER_INFO/$relserver/DAT2/" .. i .. ".$lang.jx3dat")
			if data then
				for id, p in pairs(data) do
					DBI_W:ClearBindings()
					DBI_W:BindAll(p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8])
					DBI_W:Execute()
				end
			end
		end
		DB:Execute("END TRANSACTION")
		MY.Debug({"Farbnamen info cache trans from file to sqlite finished!"}, "MY_Farbnamen", MY_DEBUG.LOG)
		
		MY.Debug({"Farbnamen tong cache trans from file to sqlite start!"}, "MY_Farbnamen", MY_DEBUG.LOG)
		DB:Execute("BEGIN TRANSACTION")
		for i = 0, 128 do
			for j = 0, 128 do
				local data = MY.LoadLUAData("cache/PLAYER_INFO/$relserver/TONG/" .. i .. "-" .. j .. ".$lang.jx3dat")
				if data then
					for id, name in pairs(data) do
						DBT_W:ClearBindings()
						DBT_W:BindAll(id, name)
						DBT_W:Execute()
					end
				end
			end
		end
		DB:Execute("END TRANSACTION")
		MY.Debug({"Farbnamen tong cache trans from file to sqlite finished!"}, "MY_Farbnamen", MY_DEBUG.LOG)
		
		MY.Debug({"Farbnamen cleaning file cache start: " .. SZ_IC_PATH}, "MY_Farbnamen", MY_DEBUG.LOG)
		CPath.DelDir(SZ_IC_PATH)
		MY.Debug({"Farbnamen cleaning file cache finished!"}, "MY_Farbnamen", MY_DEBUG.LOG)
	end
end end

local Config = clone(Config_Default)
local _MY_Farbnamen = {
	tForceString = clone(g_tStrings.tForceTitle),
	tRoleType    = {
		[ROLE_TYPE.STANDARD_MALE  ] = _L['man'],
		[ROLE_TYPE.STANDARD_FEMALE] = _L['woman'],
		[ROLE_TYPE.LITTLE_BOY     ] = _L['boy'],
		[ROLE_TYPE.LITTLE_GIRL    ] = _L['girl'],
	},
	tCampString  = clone(g_tStrings.STR_GUILD_CAMP_NAME),
	aPlayerQueu = {},
}
---------------------------------------------------------------
-- ���츴�ƺ�ʱ����ʾ���
---------------------------------------------------------------
-- �����������ݵ� HOOK �����ˡ�����ʱ�� ��
MY.HookChatPanel("MY_FARBNAMEN", function(h, szChannel, szMsg, dwTime)
	return szMsg, h:GetItemCount()
end, function(h, nCount, szChannel, szMsg, dwTime)
	if MY_Farbnamen.bEnabled then
		for i = h:GetItemCount() - 1, nCount or 0, -1 do
			MY_Farbnamen.Render(h:Lookup(i))
		end
	end
end, function(h)
	for i = h:GetItemCount() - 1, 0, -1 do
		MY_Farbnamen.Render(h:Lookup(i))
	end
end)
-- ���ŵ�����Ⱦɫ�ӿ�
-- (userdata) MY_Farbnamen.Render(userdata namelink)    ����namelinkȾɫ namelink��һ������TextԪ��
-- (string) MY_Farbnamen.Render(string szMsg)           ��ʽ��szMsg �������������
MY_Farbnamen.Render = function(szMsg)
	if type(szMsg) == 'string' then
		-- <text>text="[���Ǹ�����]" font=10 r=255 g=255 b=255  name="namelink_4662931" eventid=515</text><text>text="˵��" font=10 r=255 g=255 b=255 </text><text>text="[����]" font=10 r=255 g=255 b=255  name="namelink_4662931" eventid=771</text><text>text="\n" font=10 r=255 g=255 b=255 </text>
		local xml = MY.Xml.Decode(szMsg)
		if xml then
			for _, ele in ipairs(xml) do
				if ele[''].name and ele[''].name:sub(1, 9) == 'namelink_' then
					local szName = string.gsub(ele[''].text, '[%[%]]', '')
					local tInfo = MY_Farbnamen.GetAusName(szName)
					if tInfo then
						ele[''].r = tInfo.rgb[1]
						ele[''].g = tInfo.rgb[2]
						ele[''].b = tInfo.rgb[3]
					end
					ele[''].eventid = 82803
					ele[''].script = (ele[''].script or '') .. '\nthis.OnItemMouseEnter=function() MY_Farbnamen.ShowTip(this) end\nthis.OnItemMouseLeave=function() HideTip() end'
				end
			end
			szMsg = MY.Xml.Encode(xml)
		end
		-- szMsg = string.gsub( szMsg, '<text>([^<]-)text="([^<]-)"([^<]-name="namelink_%d-"[^<]-)</text>', function (szExtra1, szName, szExtra2)
		--     szName = string.gsub(szName, '[%[%]]', '')
		--     local tInfo = MY_Farbnamen.GetAusName(szName)
		--     if tInfo then
		--         szExtra1 = string.gsub(szExtra1, '[rgb]=%d+', '')
		--         szExtra2 = string.gsub(szExtra2, '[rgb]=%d+', '')
		--         szExtra1 = string.gsub(szExtra1, 'eventid=%d+', '')
		--         szExtra2 = string.gsub(szExtra2, 'eventid=%d+', '')
		--         return string.format(
		--             '<text>%stext="[%s]"%s eventid=883 script="this.OnItemMouseEnter=function() MY_Farbnamen.ShowTip(this) end\nthis.OnItemMouseLeave=function() HideTip() end" r=%d g=%d b=%d</text>',
		--             szExtra1, szName, szExtra2, tInfo.rgb[1], tInfo.rgb[2], tInfo.rgb[3]
		--         )
		--     end
		-- end)
	elseif type(szMsg) == 'table' and type(szMsg.GetName) == 'function' and szMsg:GetName():sub(1, 8) == 'namelink' then
		local namelink = szMsg
		local ui = MY.UI(namelink):hover(MY_Farbnamen.ShowTip, HideTip, true)
		local szName = string.gsub(namelink:GetText(), '[%[%]]', '')
		local tInfo = MY_Farbnamen.GetAusName(szName)
		if tInfo then
			ui:color(tInfo.rgb)
		end
	end
	return szMsg
end
-- ��ʾTip
MY_Farbnamen.ShowTip = function(namelink)
	local x, y, w, h = 0, 0, 0, 0
	if type(namelink) ~= "table" then
		namelink = this
	end
	if not namelink then
		return
	end
	local szName = string.gsub(namelink:GetText(), '[%[%]]', '')
	x, y = namelink:GetAbsPos()
	w, h = namelink:GetSize()
	
	local tInfo = MY_Farbnamen.GetAusName(szName)
	if tInfo then
		local tTip = {}
		-- author info
		if tInfo.dwID and tInfo.szName and tInfo.szName == MY.GetAddonInfo().tAuthor[tInfo.dwID] then
			tinsert(tTip, GetFormatText(_L['mingyi plugins'], 8, 255, 95, 159))
			tinsert(tTip, GetFormatText(' ', 136, 255, 95, 159))
			tinsert(tTip, GetFormatText(_L['[author]'], 8, 0, 255, 0))
			tinsert(tTip, XML_LINE_BREAKER)
		end
		-- ���� �ȼ�
		tinsert(tTip, GetFormatText(('%s(%d)'):format(tInfo.szName, tInfo.nLevel), 136))
		-- �Ƿ�ͬ����
		if UI_GetClientPlayerID() ~= tInfo.dwID and MY.IsParty(tInfo.dwID) then
			tinsert(tTip, GetFormatText(_L['[teammate]'], nil, 0, 255, 0))
		end
		tinsert(tTip, XML_LINE_BREAKER)
		-- �ƺ�
		if tInfo.szTitle and #tInfo.szTitle > 0 then
			tinsert(tTip, GetFormatText('<' .. tInfo.szTitle .. '>', 136))
			tinsert(tTip, XML_LINE_BREAKER)
		end
		-- ���
		if tInfo.szTongID and #tInfo.szTongID > 0 then
			tinsert(tTip, GetFormatText('[' .. tInfo.szTongID .. ']', 136))
			tinsert(tTip, XML_LINE_BREAKER)
		end
		-- ���� ���� ��Ӫ
		tinsert(tTip, GetFormatText(
			(_MY_Farbnamen.tForceString[tInfo.dwForceID] or tInfo.dwForceID) .. _L.STR_SPLIT_DOT ..
			(_MY_Farbnamen.tRoleType[tInfo.nRoleType] or tInfo.nRoleType)    .. _L.STR_SPLIT_DOT ..
			(_MY_Farbnamen.tCampString[tInfo.nCamp] or tInfo.nCamp), 136
		))
		tinsert(tTip, XML_LINE_BREAKER)
		-- ������
		if MY_Anmerkungen and MY_Anmerkungen.GetPlayerNote then
			local tPlayerNote = MY_Anmerkungen.GetPlayerNote(tInfo.dwID)
			if tPlayerNote then
				tinsert(tTip, GetFormatText(tPlayerNote.szContent, 136))
				tinsert(tTip, XML_LINE_BREAKER)
			end
		end
		-- ������Ϣ
		if IsCtrlKeyDown() then
			tinsert(tTip, XML_LINE_BREAKER)
			tinsert(tTip, GetFormatText(_L("Player ID: %d", tInfo.dwID), 102))
		end
		-- ��ʾTip
		OutputTip(tconcat(tTip), 450, {x, y, w, h}, MY.Const.UI.Tip.POS_TOP)
	end
end
---------------------------------------------------------------
-- ���ݴ洢
---------------------------------------------------------------
local l_infocache       = {} -- ��ȡ���ݻ���
local l_infocache_w     = {} -- �޸����ݻ���
local l_remoteinfocache = {} -- ������ݻ���
local l_tongnames       = {} -- ������ݻ���
local l_tongnames_w     = {} -- ����޸����ݻ���
local function GetTongName(dwID)
	if not dwID then
		return
	end
	local szTong = l_tongnames[dwID]
	if not szTong then
		DBT_RI:ClearBindings()
		DBT_RI:BindAll(dwID)
		local data = DBT_RI:GetNext()
		if data then
			szTong = data.name
			l_tongnames[dwID] = data.name
		end
	end
	return szTong
end

local function OnExit()
	DB:Execute("BEGIN TRANSACTION")
	for i, p in pairs(l_infocache_w) do
		DBI_W:ClearBindings()
		DBI_W:BindAll(p.id, p.name, p.force, p.role, p.level, p.title, p.camp, p.tong)
		DBI_W:Execute()
	end
	DB:Execute("END TRANSACTION")
	
	DB:Execute("BEGIN TRANSACTION")
	for id, name in pairs(l_tongnames_w) do
		DBT_W:ClearBindings()
		DBT_W:BindAll(id, name)
		DBT_W:Execute()
	end
	DB:Execute("END TRANSACTION")
	
	DB:Release()
end
MY.RegisterExit("MY_Farbnamen_Save", OnExit)

-- ͨ��szName��ȡ��Ϣ
function MY_Farbnamen.Get(szKey)
	local info = l_remoteinfocache[szKey] or l_infocache[szKey]
	if not info then
		if type(szKey) == "string" then
			DBI_RN:ClearBindings()
			DBI_RN:BindAll(szKey)
			info = DBI_RN:GetNext()
		elseif type(szKey) == "number" then
			DBI_RI:ClearBindings()
			DBI_RI:BindAll(szKey)
			info = DBI_RI:GetNext()
		end
		if info then
			l_infocache[info.id] = info
			l_infocache[info.name] = info
		end
	end
	if info then
		return {
			dwID      = info.id,
			szName    = info.name,
			dwForceID = info.force,
			nRoleType = info.role,
			nLevel    = info.level,
			szTitle   = info.title,
			nCamp     = info.camp,
			szTongID  = GetTongName(info.tong) or "",
			rgb       = Config.tForceColor[info.force] or {255, 255, 255}
		}
	end
end
MY_Farbnamen.GetAusName = MY_Farbnamen.Get

-- ͨ��dwID��ȡ��Ϣ
function MY_Farbnamen.GetAusID(dwID)
	MY_Farbnamen.AddAusID(dwID)
	return MY_Farbnamen.Get(dwID)
end

-- ����ָ��dwID�����
function MY_Farbnamen.AddAusID(dwID)
	local player = GetPlayer(dwID)
	if not player or not player.szName or player.szName == "" then
		return false
	else
		local info = l_infocache[player.dwID] or {}
		info.id    = player.dwID
		info.name  = player.szName
		info.force = player.dwForceID or -1
		info.role  = player.nRoleType or -1
		info.level = player.nLevel or -1
		info.title = player.nX ~= 0 and player.szTitle or info.title
		info.camp  = player.nCamp or -1
		info.tong  = player.dwTongID or -1
		
		if IsRemotePlayer(info.id) then
			l_infocache[info.id] = info
			l_infocache[info.name] = info
		else
			local dwTongID = player.dwTongID
			if dwTongID and dwTongID ~= 0 then
				local szTong = GetTongClient().ApplyGetTongName(dwTongID, 254)
				if szTong and szTong ~= "" then
					l_tongnames[dwTongID] = szTong
					l_tongnames_w[dwTongID] = szTong
				end
			end
			l_infocache[info.id] = info
			l_infocache[info.name] = info
			l_infocache_w[info.id] = info
		end
		return true
	end
end
-- �����û�����
function _MY_Farbnamen.SaveCustomData()
	local t = {}
	t.tForceColor = {}
	for dwForceID, tCol in pairs(Config.tForceColor) do
		if not IsSameData(tCol, Config_Default[dwForceID]) then
			t.tForceColor[dwForceID] = tCol
		end
	end
	MY.SaveLUAData({SZ_CONFIG_PATH, MY_DATA_PATH.ROLE}, t)
end
-- �����û�����
function _MY_Farbnamen.LoadCustomData()
	local t = MY.LoadLUAData({SZ_CONFIG_PATH, MY_DATA_PATH.ROLE}) or {}
	if t.tForceColor then
		for k, v in pairs(t.tForceColor) do
			Config.tForceColor[k] = v
		end
	end
end

function MY_Farbnamen.GetForceRgb(nForce)
	return Config.tForceColor[nForce] or Config_Default.tForceColor[nForce] or {255, 255, 255}
end

--------------------------------------------------------------
-- �˵�
--------------------------------------------------------------
MY_Farbnamen.GetMenu = function()
	local t = {szOption = _L['Farbnamen']}
	table.insert(t, {
		szOption = _L["enable"],
		fnAction = function()
			MY_Farbnamen.bEnabled = not MY_Farbnamen.bEnabled
		end,
		bCheck = true,
		bChecked = MY_Farbnamen.bEnabled
	})
	table.insert(t, {
		szOption = _L['customize color'],
		fnDisable = function()
			return not MY_Farbnamen.bEnabled
		end,
	})
	for nForce, szForce in pairs(_MY_Farbnamen.tForceString) do
		table.insert(t[#t], {
			szOption = szForce,
			rgb = Config.tForceColor[nForce],
			bColorTable = true,
			fnChangeColor = function(_,r,g,b)
				Config.tForceColor[nForce] = {r,g,b}
				_MY_Farbnamen.SaveCustomData()
			end,
		})
	end
	table.insert(t[#t], { bDevide = true })
	table.insert(t[#t], {
		szOption = _L['load default setting'],
		fnAction = function()
			Config.tForceColor = clone(Config_Default.tForceColor)
			_MY_Farbnamen.SaveCustomData()
		end,
		fnDisable = function()
			return not MY_Farbnamen.bEnabled
		end,
	})
	table.insert(t, {
		szOption = _L["reset data"],
		fnAction = function()
			DB:Execute("DELETE FROM InfoCache")
			MY.Sysmsg({_L['cache data deleted.']}, _L['Farbnamen'])
		end,
		fnDisable = function()
			return not MY_Farbnamen.bEnabled
		end,
	})
	return t
end
MY.RegisterPlayerAddonMenu('MY_Farbenamen', MY_Farbnamen.GetMenu)
MY.RegisterTraceButtonMenu('MY_Farbenamen', MY_Farbnamen.GetMenu)
--------------------------------------------------------------
-- ע���¼�
--------------------------------------------------------------
do
local l_peeklist = {}
local function onBreathe()
	for dwID, nRetryCount in pairs(l_peeklist) do
		if MY_Farbnamen.AddAusID(dwID) or nRetryCount > 5 then
			l_peeklist[dwID] = nil
		else
			l_peeklist[dwID] = nRetryCount + 1
		end
	end
end
MY.BreatheCall(250, onBreathe)

local function OnPeekPlayer()
	if arg0 == PEEK_OTHER_PLAYER_RESPOND.SUCCESS then
		l_peeklist[arg1] = 0
	end
end
MY.RegisterEvent("PEEK_OTHER_PLAYER", OnPeekPlayer)
MY.RegisterEvent("PLAYER_ENTER_SCENE", function() l_peeklist[arg0] = 0 end)
MY.RegisterEvent("ON_GET_TONG_NAME_NOTIFY", function() l_tongnames[arg1], l_tongnames_w[arg1] = arg2, arg2 end)
MY.RegisterInit('MY_FARBNAMEN_CUSTOMDATA', _MY_Farbnamen.LoadCustomData)
end
