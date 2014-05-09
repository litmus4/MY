-- language data (zhcn) updated at 2014-4-10 03:38:11
data = {
    -- common
    ['nearby channel'] = '近聊頻道',
    ['friend channel'] = '好友頻道',
    ['team channel'] = '隊伍頻道',
    ['raid channel'] = '團隊頻道',
    ['raid/battle channel'] = '團隊/戰場',
    ['tong channel'] = '幫會頻道',
    ['tong alliance channel'] = '同盟頻道',
    ['map channel'] = '地圖頻道',
    ['school channel'] = '門派頻道',
    ['camp channel'] = '陣營頻道',
    ['whisper channel'] = '密聊頻道',
    ['world channel'] = '世界頻道',
    ['system channel'] = '系統頻道',
    
    ['NEARBY'] = '近聊',
    ['FRIENDS'] = '好友',
    ['TEAM'] = '隊伍',
    ['RAID'] = '團隊/戰場',
    ['TONG'] = '幫會',
    ['TONG_ALLIANCE'] = '同盟',
    ['MAP'] = '地圖',
    ['SCHOOL'] = '門派',
    ['CAMP'] = '陣營',
    ['WHISPER'] = '密聊',
    ['WORLD'] = '世界',
    ['SYSTEM'] = '系統',
    
    ['send'] = '發送',
    ['send to'] = '發送到',
    ['send to ...'] = '發送到...',
    
    ['ji guan'] = '機關',
    ['nu jian'] = '弩箭',
    
    ['all force'] = '所有人',
    ['JiangHu'] = '江湖',
    ['ChunYang'] = '純陽',
    ['TianCe'] = '天策',
    ['CangJian'] = '藏劍',
    ['GaiBang'] = '丐幫',
    ['WuDu'] = '五毒',
    ['MingJiao'] = '明教',
    ['WanHua'] = '萬花',
    ['QiXiu'] = '七秀',
    ['ShaoLin'] = '少林',
    ['TangMen'] = '唐門',
    
    ['start'] = '開始',
    ['restart'] = '重新開始',
    ['stop'] = '停止',
    ['clear'] = '清空',
    ['cancel'] = '取消',
    ['use'] = '使用',
    ['publish'] = '發佈',
    ['publish setting'] = '發佈設置',
    ['publish top %d'] = '發佈前%d名',
    ['publish all'] = '發佈所有',
    
    ['add'] = '添加',
    ['delete'] = '刪除',
    ['add group'] = '添加分組',
    ['delete group'] = '刪除分組',
    
    ['copy'] = '複製',
    ['paste'] = '粘貼',
    ['whisper'] = '密聊',
    -- MY.lua
    ['mingyi plugin'] = '茗伊插件',
    ['mingyi plugins'] = '茗伊插件集',
    ['%s, welcome to use mingyi plugins!'] = '歡迎%s使用茗伊插件集！',
    ['Open/Close main panel'] = '打開/關閉主界面',
    ["unable to open ini file [%s]"] = "無法打開界面 INI 文件 [%s]",
    ["can not find wnd component [%s]"] = "找不到窗體組件 [%s]",
    ["unable to append handle item [%s]"] = "無法追加容器組件 [%s]",
    ["unable to append handle item from string."] = "從字符串追加容器組件失敗。",
    -- MY_TalkEx.lua
    ['talk ex'] = '喊話輔助',
    ['have a trick with'] = '調侃一下',
    ['teammates where'] = '團隊中',
    ['nearby players where'] = '附近的',
    ['please input something.'] = '請先輸入一些內容。',
    ['no trick target found.'] = '找不到可以調侃的玩家，您可以嘗試更改篩選條件。',
    -- MY_CheckUpdate.lua
    ['new version found.'] = '發現新版本！',
    ['new version found, would you want to download immediately?'] = '發現新版本！是否立即前往下載？',
    ['download immediately'] = '立即下載',
    ['see new feature'] = '更新日誌',
    -- MY_ChatMonitor.lua
    ['chat monitor'] = '聊天監控',
    ['waiting...'] = '等待中…',
    ['load preset'] = '加載預設',
    ['regexp'] = '正則',
    ['regular expression'] = '正則表達式',
    ['show message preview box'] = '新消息彈窗',
    ['welcome to use mingyi chat monitor.'] = '歡迎使用茗伊聊天監控。',
    ['key words:'] = '關鍵字：',
    ['CHAT_MONITOR_KEYWORDS_SAMPLE'] = "10|十人,血戰天策|XZTC,!小鐵被吃了,!開宴黑鐵;大戰",
    ['CHAT_MONITOR_TIP'] = '關鍵字過濾器\n說明：\n半角分號;分隔多個條件\n每個條件中用半角逗號,表示且\n每個條件中用半角分隔符|表示或\n每個條件中用半角感歎號!表示非\n\n例1：大明宮;DMG;血戰天策;XZTC\n-----------------\n如上例子代表匹配含有DMG或大明宮或XZTC或血戰天策的聊天記錄。\n\n例2：25,大明宮;10,血戰天策\n-----------------\n如上例子代表匹配同時含有"25"和"大明宮"或者同時含有"10"和"血戰天策"的聊天記錄。\n\n例3：\n10|十人,血戰天策|XZTC,!小鐵被吃了,!開宴黑鐵;大戰\n-----------------\n如上例子代表匹配同時含有"10"或"十人"，"XZTC"或"血戰天策"，並且不含有"小鐵被吃了"，也不含有"開宴黑鐵"的句子；或者含有"大戰"的聊天記錄。\n\n關於正則，不會正則表達式的小夥伴不要隨便打鉤哦~~會正則表達式的小夥伴(┘￣︶￣)┘└(￣︶￣└)[GiveMeFive!] \n-----------------\nPs：作者語言表達能力不佳，有什麼看不懂的，你拓麻來打我啊hhhhhhhhhhhhhhhhhhhhhhh…',
    -- MY_Logoff.lua
    ['express logoff'] = '快速登出',
    ['# condition logoff'] = '● 條件登出',
    ['# express logoff'] = '● 快速登出',
    ['while'] = '當',
    ['[ select a target ]'] = '[請選擇目標]',
    ['( current target )'] = '(當前目標)',
    ['life below       %'] = '血量低於　　　%時',
    ['%d player(s) selected'] = '已選擇的%d個玩家',
    ['all disappeared'] = '全部離開視野時',
    ['while client level exceeds'] = '當自身等級達到　　　級時',
    ['second(s) later'] = '秒之後',
    ['While it meets any condition below'] = '符合以上條件之一時',
    ['return to role list'] = '返回角色選擇',
    ['return to game login'] = '返回賬號登錄',
    ['return to role list while not fight'] = '脫戰後返回角色選擇',
    ['return to game login while not fight'] = '脫戰後返回賬號登錄',
    ['* hotkey setting'] = '☆ 快捷鍵設定',
    ['force return to role list.'] = '强制返回角色選擇页面。',
    ['force return to game login.'] = '强制返回账户登录页面。',
    ['return to role list while leaving fighting.'] = '在下一次脫離戰鬥的一瞬間返回角色選擇頁面。',
    ['return to game login while leaving fighting.'] = '在下一次脫離戰鬥的一瞬間返回賬戶登錄頁面。',
    
    -- MY_ToolBox.lua
    ['tool box'] = '常用工具',
    -- MY_ScreenShotHelper.lua
    ['screen shot helper'] = '截圖助手',
    -- MY_RescueTeam.lua
    ['rescue team helper'] = '救場必備',
    -- MY_RollMon.lua
    ['roll monitor'] = '點數監控',
    ['--------------- roll restart ----------------'] = '——————— 記錄已清空 擲頭重新開始 ———————',
    ['---------------------------------------------'] = '——————————————————————————',
    ['left click to publish, right click to open setting.'] = '左鍵發佈，右鍵設置。',
    ['left click to restart, right click to open setting.'] = '左鍵重新開始，右鍵設置。',
    ['ROLL_MONITOR_EXP'] = '"([^"]*)擲出(%d+)點。%(1 %- 100%)"',
    ['only first score'] = '只記錄第一次',
    ['only last score'] = '只記錄最後一次',
    ['highest score'] = '多次搖點取最高點',
    ['lowest score'] = '多次搖點取最低點',
    ['average score'] = '多次搖點取平均值',
    ['average score with out pole'] = '去掉最高最低取平均值',
    ["haven't roll yet."] = '尚未擲骰子。',
    ['[%s] rolls for %d times, valid score is %s.'] = '[%s]擲了%d次骰子，有效點數為%s。',
}