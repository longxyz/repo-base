local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,叶心安-远古海滩,释言丶-伊森利恩,空灵道-回音山,魔道刺靑-菲拉斯,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,不要捣乱-贫瘠之地,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯,戦乙女-霜之哀伤";
local recentDonators = {["奥尔加隆"] = "Fz,茹鸶;Ft,雪莉;Fs,北白",["破碎岭"] = "Fz,小米粥丶;Fr,鹤命;Fq,迷茫的炭烧",["贫瘠之地"] = "Fz,蚰蜒;Fx,抓一只小德,梦醉红尘;Fu,古友;Fs,冰封的冷漠;Fr,暖暖的回忆,隅野沙耶香,灬哆哆灬;Fq,霰丶,闇丶影,汽水糖児",["冰霜之刃"] = "Fz,安德;Fw,丶陶醉乄;Fr,汗圆焚尸手",["死亡之翼"] = "Fz,冰蓝灬;Fx,丶凌晨㥆,屁风暴烈酒;Fw,闪闪发光滴;Ft,寸刃,第一神手;Fs,秦风细雨;Fr,逆天猪,优秀的武僧,祝掌门吐血啦,布川一夫;Fq,放牛郎丶",["凤凰之神"] = "Fz,哒达哒;Fy,求求你打死我,学习个屁,欢乐斗帝主;Fx,Wxh,雪怒乄;Fw,守望光明,丨巭勥丨;Fu,暴暴的硬邦邦,白芍菜心;Ft,清風丶呆贼,怕死的黑牛丶;Fs,一缕散暮愁,哦耶哦买噶;Fq,七月七夕,吴名是;Fp,和平丶",["主宰之剑"] = "Fy,玖玥玖玥;Fx,愤怒丶的豆子;Fw,暮雨晨曦;Fv,亅大炮;Fu,壹枕黄粱;Fs,季秋,淼焱丶;Fr,張少主,蒙头睡的书虫,自闭的弱鱼;Fp,飞洋灬",["白银之手"] = "Fy,包子吃不胖,唐卡特琳娜;Fw,王贼,春风十里丶丶;Fv,喵本熊;Ft,是曲奇饼干哟,秋秋叁佰斤;Fs,银鞍照白馬,清心的劣人;Fr,嘤嘤鱼,疯花生,灬哆哆灬,Fovdkt;Fq,小傻瓜月牙,聖米迦勒,宝强稳住",["燃烧之刃"] = "Fy,丶迷醉,杀剧舞荒;Fx,次米粉;Fv,路灰灰,虚晃一枪;Fu,小封心丷;Ft,酒尽归故里;Fr,斷劍陰盜言;Fp,兔子软贝特丶",["克尔苏加德"] = "Fy,迪蒙赫特;Fv,南巷;Ft,老夫一抬腿;Fp,荧丶惑,何曰是归年,何曰是来年",["玛里苟斯"] = "Fy,冰柠雪",["安苏"] = "Fy,魅影灬爱洁儿,战莽;Fu,二哈灬愤怒;Ft,莽夫丶蒋;Fr,威士乄忌;Fq,Junriver,那个水法",["冰风岗"] = "Fy,乄麦芽糖;Fv,Rebirthdeak",["雷霆之怒"] = "Fy,永夜初夏;Fv,乔宝宝丶",["遗忘海岸"] = "Fy,犄角大魔王",["黑铁"] = "Fy,墨丨",["罗宁"] = "Fy,无法形容;Fq,菊花芬外香;Fp,欣喵酱,忻喵酱",["洛丹伦"] = "Fy,大魔王桐桐;Fq,戦將",["国王之谷"] = "Fy,白袍巫师呢;Fx,迪路獣;Fw,瑪雅之靈;Fv,秀冬;Fu,哇咖;Ft,气宗天下第一;Fr,太湖雪",["能源舰"] = "Fy,张海棠",["格瑞姆巴托"] = "Fy,丶风林火山丶;Fw,夜里很温柔;Fv,拜舍尔鲸鸟;Fq,爱吃火龙果丶;Fp,清雨潇寒",["血环"] = "Fy,Lansnot",["红龙女王"] = "Fy,曲线湾",["深渊之巢"] = "Fy,八戒",["???"] = "Fy,且看云烟散;Fv,牧士左岸;Ft,丶哈雷,透透;Fs,甲基苯丙",["索拉丁"] = "Fy,云师兄",["龙骨平原"] = "Fy,残盾丶;Fs,Dps",["苏塔恩"] = "Fx,以梦丶;Fq,壹灯",["石爪峰"] = "Fx,黄瓜娃娃丶",["拉文凯斯"] = "Fx,晚夜烛凉;Fv,兜里有圣光",["金色平原"] = "Fx,忆露年丶;Fq,冰镇冰冰猫",["回音山"] = "Fx,蠢萌小熊猫;Fq,落寂天星;Fp,風中縋楓,夏沫灬小米",["熊猫酒仙"] = "Fx,眼瞎的阿昆达;Fu,擒贼先擒汪;Ft,恶魔灬来临;Fs,追逐九号球;Fr,飘逸贝贝,幽梦鹊花鹃;Fp,葱拌豆花",["海克泰尔"] = "Fx,感覺;Fr,姒妖;Fp,怕吉,小心我打你哦",["普罗德摩"] = "Fx,土匪妈妈",["战歌"] = "Fx,丫头牛牛",["闪电之刃"] = "Fx,图噜咔咔哇",["迅捷微风"] = "Fw,神澈,尐老弓",["迦拉克隆"] = "Fw,薛定諤旳貓;Fs,Lionkk;Fr,弑神武帝",["血色十字军"] = "Fw,丶汐诺;Fu,盗魂;Fq,风骚喝糖水",["朵丹尼尔"] = "Fw,冷雨叶",["拉贾克斯"] = "Fw,听暖",["巴瑟拉斯"] = "Fw,锈水财阀泰迪",["霜之哀伤"] = "Fw,托尔贝恩",["银松森林"] = "Fw,少年蓝色经典",["玛法里奥"] = "Fw,阿紫",["雷霆之王"] = "Fw,柴小协真好听",["无尽之海"] = "Fv,沐秋色,古德拜拜;Fu,焱焰;Fs,女神张钧甯;Fq,捅过蛋总一刀",["洛肯"] = "Fv,Siners",["末日行者"] = "Fv,花与布偶猫;Fq,丨简丶单丨;Fp,名流之恋",["影之哀伤"] = "Fv,一念无明,咕喵王梦境;Fu,走光;Fr,燃烧卡路里丶;Fq,綽約多姿,夜若轻羽,丨竹叶青",["熔火之心"] = "Fv,瑟萊德絲公主",["奥杜尔"] = "Fv,美少女小猎,美少女猎手",["铜龙军团"] = "Fv,墨染青颜丶",["萨菲隆"] = "Fv,莉亞",["阿古斯"] = "Fv,十八疯了;Fu,布兰妮,我是饿馍;Ft,焦糖豆包;Fs,元素圣灵;Fq,躺地板,爱晒大阳的鱼",["羽月"] = "Fv,Disneymagic",["黑暗虚空"] = "Fv,不能叫我山鸡",["阿纳克洛斯"] = "Fv,小马兄",["甜水绿洲"] = "Fv,丶林夕丶",["激流之傲"] = "Fv,Tiann",["語風[TW]"] = "Fu,灰獭獭",["伊森利恩"] = "Fu,蠢蠢小粉猪;Fr,北冰洋;Fq,你耶耶突然",["梦境之树"] = "Fu,明月清风;Fp,阿弹",["千针石林"] = "Fu,天佑盘古墓,天佑与复生,天佑和复生",["安东尼达斯"] = "Fu,不想遇见你;Fs,滴滴打滴",["黄金之路"] = "Fu,红叶知弦",["奥特兰克"] = "Fu,群主发红包;Ft,哆啦誒萌",["霜狼"] = "Fu,藤丸立香;Fr,Fayditachi",["轻风之语"] = "Fu,Tearsinrain",["日落沼澤[TW]"] = "Fu,姓聖的騎士",["格雷迈恩"] = "Fu,慕容紫莹;Fs,Monkee",["塞拉摩"] = "Fu,伊丽达雷;Ft,鬼刀手里干",["永恒之井"] = "Ft,烟脂酒鬼",["扎拉赞恩"] = "Ft,远游",["奈法利安"] = "Ft,五更琉璃灬",["丹莫德"] = "Ft,游龍;Fs,焚书战神",["天空之墙"] = "Ft,博問丶,博闻丶",["红云台地"] = "Ft,幽玄影",["加基森"] = "Ft,临江暮雪",["萨尔"] = "Fs,伊利蛋努凤",["伊兰尼库斯"] = "Fs,Hawkeye",["灰谷"] = "Fs,梁朝伟;Fq,初宸;Fp,前所未见",["爱斯特纳"] = "Fs,愤怒的泡泡",["梅尔加尼"] = "Fs,伊森亨特",["埃苏雷格"] = "Fs,只道寻常",["丽丽（四川）"] = "Fs,Saintangle",["试炼之环"] = "Fs,奔跑的糍饭糕",["加里索斯"] = "Fr,橙皮酸梅",["影牙要塞"] = "Fr,橘貓皇吾",["烈焰峰"] = "Fr,小乌龟啊",["奥蕾莉亚"] = "Fr,逝去的黑风",["亚雷戈斯"] = "Fr,狗鸭蛋;Fq,你耶耶突然",["罗曼斯"] = "Fr,南夏奈;Fp,星白闲",["夏维安"] = "Fr,肉炒电线杆丶",["提瑞斯法"] = "Fr,零六水鱼",["埃克索图斯"] = "Fr,灬阿猫灬",["银月"] = "Fr,神之利牙",["埃德萨拉"] = "Fr,Arthasgrw",["血吼"] = "Fq,卡卡德鲁",["安纳塞隆"] = "Fq,双马尾",["斩魔者"] = "Fq,东东丨枪,东东丶枪",["暗影之月"] = "Fq,莉娅苟萨",["风暴峭壁"] = "Fq,有黑眼圈多好",["幽暗沼泽"] = "Fq,丶麒麟",["亡语者"] = "Fq,我以为你死了",["莱索恩"] = "Fq,遇朮临疯",["瓦拉斯塔兹"] = "Fq,Evolution",["勇士岛"] = "Fq,奥多芙",["燃烧平原"] = "Fp,灬锯齿灬",["诺兹多姆"] = "Fp,Whitley",["万色星辰"] = "Fp,巫行云",["杜隆坦"] = "Fp,灵小溪",["寒冰皇冠"] = "Fp,Reclusive",["艾萨拉"] = "Fp,师承冠希",["布兰卡德"] = "Fp,富贵牛牛",["守护之剑"] = "Fp,风暴祭司",["鹰巢山"] = "Fp,九五二七",["菲拉斯"] = "Fp,盾之朽木"};
local start = { year = 2018, month = 8, day = 3, hour = 7, min = 0, sec = 0 }
local now = time()
local player_shown = {}
U1Donators.players = player_shown

local topNamesOrder = {} for i, name in ipairs({ strsplit(',', topNames) }) do topNamesOrder[name] = i end

local realms, players, player_days = {}, {}, {}
local base64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
local function ConvertDonators(day_realm_players)
    if not day_realm_players then return end
    for realm, allday in pairs(day_realm_players) do
        if not tContains(realms, realm) then table.insert(realms, realm) end
        for _, oneday in ipairs({strsplit(';', allday)}) do
            local date;
            for i, player in ipairs({strsplit(',', oneday)}) do
                if i == 1 then
                    local dec = (base64:find(player:sub(1,1)) - 1) * 64 + (base64:find(player:sub(2,2)) - 1)
                    local y, m, d = floor(dec/12/31)+2018, floor(dec/31)%12+1, dec%31+1
                    date = format("%04d-%02d-%02d", y, m, d)
                else
                    local fullname = player .. '-' .. (realm:gsub("%[.-%]", ""))
                    if not tContains(players, fullname) then
                        table.insert(players, fullname)
                        player_days[fullname] = date
                        player_shown[fullname] = topNamesOrder[fullname] or 0
                    end
                end
            end
        end
    end
end
ConvertDonators(recentDonators)
recentDonators = nil
ConvertDonators(U1.historyDonators)
U1.historyDonators = nil

table.sort(players, function(a, b)
    local order1 = topNamesOrder[a] or 9999
    local order2 = topNamesOrder[b] or 9999
    if order1 ~= order2 then return order1 < order2 end
    local _, r1 = strsplit("-", a)
    local _, r2 = strsplit("-", b)
    if r1 ~= r2 then
        if r1 == '???' then return false
        elseif r2 == '???' then return true
        else return r1 < r2; end
    end
    local day1 = player_days[a]
    local day2 = player_days[b]
    if day1 ~= day2 then return day1 > day2 end
    return a < b
end)
-- 排完序就不需要了
topNames = nil
topNamesOrder = nil

function U1Donators:CreateFrame()
    local f = WW:Frame("U1DonatorsFrame", UIParent, "BasicFrameTemplateWithInset"):Size(320, 500):TR(U1Frame, "TL", -10, 0):SetToplevel(1):SetFrameStrata("DIALOG")

    f.TitleText:SetText("爱不易的捐助者，谢谢你们")
    f.InsetBg:SetPoint("TOPLEFT", 4, -50)
    CoreUIMakeMovable(f)

    local scroll = CoreUICreateHybridStep1(nil, f(), nil, true, true, nil)
    WW(scroll):TL(f.InsetBg, 3, -3):BR(f.InsetBg, -2-21, 2):un() --:TL(3, -20)
    f.scroll = scroll

    local headn = TplColumnButton(f, nil, 22):SetWidth(108):SetText("玩家主角色"):SetScript("OnClick", noop):un()
    WW(headn:GetFontString()):SetFontHeight(14):un()
    local heads = TplColumnButton(f, nil, 22):SetWidth(80):SetText("服务器"):SetScript("OnClick", noop):un()
    WW(heads:GetFontString()):SetFontHeight(14):un()
    local headd = TplColumnButton(f, nil, 22):SetWidth(100):SetText("捐助时间"):SetScript("OnClick", noop):un()
    WW(headd:GetFontString()):SetFontHeight(14):un()
    CoreUIAnchor(f, "TOPLEFT", "TOPLEFT", 8, -30, "LEFT", "RIGHT", 0, 0, headn, heads, headd)

    local function fix_text_width(obj)
      obj:GetFontString():SetAllPoints()
    end

    scroll.creator = function(self, index, name)
      local row = WW(self.scrollChild):Button(name):LEFT():RIGHT():Size(0, 20)
      row:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], 'ADD')

      row.name = row:Button():Size(100, 20):EnableMouse(false):SetButtonFont(U1FCenterTextMid):SetText(111):GetButtonText():SetJustifyH("Center"):up()
      row.server = row:Button():Size(75, 20):EnableMouse(false):SetButtonFont(U1FCenterTextTiny):SetText(111):GetButtonText():SetJustifyH("Right"):up()
      row.firstdate = row:Button():Size(90, 20):EnableMouse(false):SetButtonFont(U1FCenterTextTiny):SetText(333):GetButtonText():SetJustifyH("Right"):up()

      fix_text_width(row.name)
      fix_text_width(row.server)
      fix_text_width(row.firstdate)

      CoreUIAnchor(row, "LEFT", "LEFT", 5, 0, "LEFT", "RIGHT", 5, 0, row.name, row.server, row.firstdate)
      return row:un()
    end

    scroll.getNumFunc = function()
      return #players
    end

    scroll.updateFunc = function(self, row, index)
      row.index = index
      local name, realm = strsplit('-', players[index])
      row.name:SetText(name)
      row.server:SetText(realm)
      row.firstdate:SetText(player_days[players[index]]);
      --row.name:GetFontString():SetTextColor(1,1,1)
      --local date_fmt = '%Y/%m/%d'
      --local txt = date(date_fmt, time())
      --row.firstdate:SetText(txt)
    end

    CoreUICreateHybridStep2(scroll, 0, 0, "TOPLEFT", "TOPLEFT", 0)

    f:Hide();
    return f()
end

CoreOnEvent("PLAYER_ENTERING_WORLD", function()
    local origs = {}
    local addMessageReplace = function(self, msg, ...)
        msg = msg and tostring(msg) or ""
        local h, t, part1, fullname, part2 = msg:find("(\124Hplayer:(.-):.-:.-:.-\124h%[)(\124c.........-\124r%]\124h)")
        if fullname and ((U1Donators and U1Donators.players[fullname]) or (U1STAFF and U1STAFF[fullname])) then
            --local _, height = self:GetFont()
            msg = msg:sub(1,h-1) .. part1 .. '\124TInterface\\AddOns\\!!!163UI!!!\\Textures\\UI2-logo:' .. (13) .. '\124t' .. part2 .. msg:sub(t+1);
        end
        origs[self](self, msg, ...)
    end
    WithAllChatFrame(function(cf)
        if cf:GetID() == 2 then return end
        origs[cf] = cf.AddMessage
        cf.AddMessage = addMessageReplace
    end)
    return "remove"
end)