Hooks:Add("LocalizationManagerPostInit", "shin_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["hhmenu_hold_to_jump"] = "오토 점프",
		["hhmenu_hold_to_jump_help"] = "점프 버튼을 누르고 있으면 연속 점프가 가능하게 합니다.",
		["hhmenu_staticrecoil"] = "스테딕 반동",
		["hhmenu_staticrecoil_help"] = "자동 반동 보정을 비활성화하여 발사를 멈춘 후에도 조준을 조정하려면 마우스를 수동으로 당겨야합니다.",
		["hhmenu_holdtofire"] = "단발 무기를 길게 눌려서 속사",
		["hhmenu_holdtofire_help"] = "플레이어가 발사 버튼을 눌려 최대 발사 속도로 단발 무기를 발사할 수 있게 합니다.",
		
		["hud_assault_boss_incoming"] = "/// 경고: 보스 접근 중 ///",
		["hud_assault_boss"] = "어썰트를 끝낼려면 보스를 쓰려트리십시오",
		["hud_assault_bosses"] = "어썰트를 끝낼려면 모든 보스를 쓰려트리십시오",
	
		["hud_assault_FG_cover1"] = "서로를 죽여라, 하지만 이번에는 좋은 쪽",
		["hud_assault_FG_cover2"] = "완전한 광기",
		["hud_assault_FG_cover3"] = "디스플레이를 최대한 활용한 폭력행위",
		["hud_assault_FG_cover4"] = "또 다른 싸움이 너에게 다가오고 있다",
		["hud_assault_FG_cover5"] = "운명의 수레바퀴가 돌고 있다",
		["hud_assault_FG_cover6"] = "이건 베이컨을 곁들인 참치",
		["hud_assault_FG_cover7"] = "이 전투는 곧 폭발한다",
		["hud_assault_FG_cover8"] = "경찰들의 시체들",
		["hud_assault_FG_cover9"] = "너의 자극을 보여줘",
		["hud_assault_FG_cover10"] = "라 루나를 봐",
		["hud_assault_FG_cover11"] = "운명을 건너서 도망칠 수는 없다",
		["hud_assault_FG_cover12"] = "살고 죽게 놔두자",
		["hud_assault_FG_cover13"] = "곱슬곱슬한 콧수염은 어디에",
		["hud_assault_FG_cover14"] = "하이퍼 하이스팅에 온 걸 환영한다",
		["hud_assault_FG_cover15"] = "한 번 해보자고, 베이비",
		["hud_assault_FG_cover16"] = "전송을 제어 중",
		["hud_assault_FG_cover17"] = "지금 해보자고",
		["hud_assault_FG_cover18"] = "춤춰보자고, 얘들아",
		["hud_assault_FG_cover19"] = "제롬을 위한 핫 소스",
		["hud_assault_FG_cover20"] = "해답은 전투의 핵심에 있다",
		["hud_assault_FG_cover21"] = "이 파티가 미쳐가고 있어",
		["hud_assault_FG_cover22"] = "불타오르지만 내 심장은 여전히 불타오른다",
		["hud_assault_FG_cover23"] = "천국 아니면 지옥, 한 번 해보자",
		["hud_assault_FG_cover24"] = "호랑이처럼 싸우고 장작더미 속을 걸어보자",
		["hud_assault_FG_cover25"] = "이 개같은걸 끝내기 위해 캡틴을 먹자",
		["hud_assault_FG_cover26"] = "차드 우즈가 왔다",
		["hud_assault_FG_cover27"] = "찢고 죽여라, 끝이 날때 까지",
		["hud_assault_FG_cover28"] = "마라낙스 인퍼먹스",
		["hud_assault_FG_cover29"] = "차카 차카 파타 폰", --i gushed to a friend for like 30 minutes over how fun modding pd2 is and they told me to make a patapon reference, i am not allowed to say no
		["hud_assault_FG_cover30"] = "비방 댓글은 여기로", --fuglore? more like buglore
		["hud_assault_FG_cover31"] = "쓰러질 때까지 싸워라",
		["hud_assault_FG_cover32"] = "망할 것들에게 겁을 먹을 때마다 엄폐해라",
		["hud_assault_FG_cover33"] = "이건 새로운 광기를 가져올 것이다",	
		["hud_assault_FG_cover34"] = "흰색 밴 포착",
		["hud_assault_FG_cover35"] = "늪상어는 포함되어 있지 않다",
		["hud_assault_FG_cover36"] = "아이고 맙소사 우린 이제 죽었어",
		["hud_assault_FG_cover37"] = "매우 위험함", --w
		["hud_assault_FG_cover38"] = "랜덤 침팬지 이벤트",
		["hud_assault_FG_cover39"] = "적의 수: 존나 많음",
		["hud_assault_FG_cover40"] = "안녕?",
		["hud_assault_FG_cover41"] = "난 너가 식사를 대접 하는줄 알았는데",
		["hud_assault_FG_cover42"] = "포큰 인피니트를 하는 방법을 배우고 싶겠지",
		["hud_assault_FG_cover43"] = "영화가 시작된다",
		["hud_assault_FG_cover44"] = "멈출 수 없는 치명적인 액션",
		["hud_assault_FG_cover45"] = "소시지를 안전하게 보관해라",
		["hud_assault_FG_cover46"] = "너는 반은 하이스터이고, 반은 겁쟁이임",
		["hud_assault_FG_cover47"] = "가렛은 너한테 정말로 화 낼거야.",
		["hud_assault_FG_cover48"] = "죽은 경찰들 410,757,864,530",
		["hud_assault_FG_cover49"] = "하이스터 후터스에 온 걸 환영한다",
		["hud_assault_FG_cover50"] = "저 놈은 드라간이 아니잖아",
		["hud_assault_FG_cover51"] = "GUAC0가 추가된다면 말이다",
		["hud_assault_FG_cover52"] = "어퍼는 나를 이상하게 만들어",
		["hud_assault_FG_cover53"] = "파란색, 빨간색 및 검은색 편집증",
		["hud_assault_FG_cover54"] = "아무도 널 제외하고 색상을 볼 수 없어",
		["hud_assault_FG_cover55"] = "인류는 사회를 바꿀 수 없다는 것을 알고 있었고, 그래서 그들은 짐승을 비난했다", --long ass stay in cover text lol
		["hud_assault_FG_cover56"] = "날 만지면 니의 얼굴을 부술거임",
		["hud_assault_FG_cover57"] = "갑옷을 입은 믿음",
		["hud_assault_FG_cover58"] = "이 비트는 드뭄",
		["hud_assault_FG_cover59"] = "킬러 그로브로 이동하는 방법이다",
		["hud_assault_FG_cover60"] = "싸워 나가라",
		["hud_assault_FG_cover61"] = "멍청한 경찰들 같으니, 나는 '씨부랄' 발린이다",
		["hud_assault_FG_cover62"] = "그가 천천히 걸어가서 주먹질을 했나?",
		["hud_assault_FG_cover63"] = "#verifyvenuz",
		["hud_assault_FG_cover64"] = "신을 만날 준비가 됬냐?",
		["hud_assault_FG_cover65"] = "경찰과 이야기할 수만 있다면 말이야",
		["hud_assault_FG_cover66"] = "ROLLING EYES FALL",
		["hud_assault_FG_cover67"] = "RULING DIES OUT",
		["hud_assault_FG_cover68"] = "이게 우리가 총을 가지고 있는 이유지",
		["hud_assault_FG_cover69"] = "달리고 엄폐하는게 좋을걸",
		["hud_assault_FG_cover70"] = "엄폐물에서 빠져나가는게 좋을거다 이 경찰들아",
		["hud_assault_FG_cover71"] = "마지막 생존자라면, 문을 잠궈라",
		["hud_assault_FG_cover72"] = "피는 연료다",
		["hud_assault_FG_cover73"] = "캘리포니아는 이제 제껍니다",
		["hud_assault_FG_cover74"] = "뭘하려고",
		["hud_assault_FG_cover75"] = "우린 에너지다",
		["hud_assault_FG_cover76"] = "5미터 거리 유지해라",
		["hud_assault_FG_cover77"] = "우리는 힘을 얻었어",
		["hud_assault_FG_cover78"] = "아마 그건 고통스러운 방법이 될거야",
		["hud_assault_FG_cover79"] = "엄폐를 하지마라",
		["hud_assault_FG_cover80"] = "마우드아아아아",
		["hud_assault_FG_cover81"] = "그들에게 분기가 없다는걸 보여줘라",
		["hud_assault_FG_cover82"] = "적들을 집결시켜라",
		["hud_assault_FG_cover83"] = "온다고 얘들아",
		["hud_assault_FG_cover84"] = "0 퍼센트 FROGCODE 기능",
		["hud_assault_FG_cover85"] = "카드 하우스는 허용되지 않는다",
		["hud_assault_FG_cover86"] = "니 팬티를 구부려라",
		["hud_assault_FG_cover87"] = "격렬함에 온 걸 환영한다",
		["hud_assault_FG_cover88"] = "돈을 집을 수 있을 때 집어라",
		["hud_assault_FG_cover89"] = "멈추지 않는 때거리 폭력들",
		["hud_assault_FG_cover90"] = "노드와 넥서스, 이 생명을 먹여살린다",
		["hud_assault_FG_cover91"] = "그 30 스킬 포인트 빌드로 나에게 설교하지 마라",
		["hud_assault_FG_cover92"] = "나는 나다, 가짜가 되지말라고",
		["hud_assault_FG_cover93"] = "미쳐버리자",
		["hud_assault_FG_cover94"] = "그냥 그들의 일반적인 방향으로 쏴라",
		["hud_assault_FG_cover95"] = "고릴라 모드 활성화",
		["hud_assault_FG_cover96"] = "바지를 입기를 바란다",
		["hud_assault_FG_cover97"] = "액세스를 위반해라",
		["hud_assault_FG_cover98"] = "너는 폭력을 유지할 권리가 있다",
		["hud_assault_FG_cover99"] = "씨발 닥치고 엄폐 좆까",
		["hud_assault_FG_cover100"] = "너의 움직임을 보여줘",
		["hud_assault_FG_cover101"] = "싸이코로 되어라",
		["hud_assault_FG_cover102"] = "아드레날린이 뿜어진다",
		["hud_assault_FG_cover102"] = "아토믹 오버드라이브",
		["hud_assault_FG_cover103"] = "운명은 없다",
		["hud_assault_FG_cover104"] = "하이스트를 시작하자",
		["hud_assault_FG_cover105"] = "망할 엄폐로 들어와, 사랑아",
		["hud_assault_FG_cover106"] = "스푼은 없다",
		["hud_assault_FG_cover107"] = "열기를 만들어내라",
		["hud_assault_FG_cover108"] = "무언가 무언가",
		["hud_assault_FG_cover109"] = "살아남을 수 있다고 믿어라",
		["hud_assault_FG_cover110"] = "그들에게 스타일을 보여줘라",
		["hud_assault_FG_cover111"] = "행동으로 온다",
		["hud_assault_FG_cover112"] = "계속 움직여'",
		["hud_assault_FG_cover113"] = "해보자고",
		["hud_assault_FG_cover114"] = "힘을 가졌다구",
		["hud_assault_FG_cover115"] = "하이스팅 할 시간이다",
		["hud_assault_FG_cover116"] = "태도 가진 강도",
		["hud_assault_FG_cover117"] = "양아치 같은 놈아, 에이펙스 에이드를 마셔봐라",
		["hud_assault_FG_cover118"] = "ERROR: hud_assault_F- 뻥이다 새꺄",
		["hud_assault_FG_cover119"] = "별 큰 문제는 아니야",
		["hud_assault_FG_cover120"] = "왜 널 사랑하지",
		["hud_assault_FG_cover121"] = "태도 가진 강 도",
		["hud_assault_FG_cover122"] = "태도 가진 강 도",
		["hud_assault_FG_cover123"] = "덤벼보라고 이 새끼들아",
		["hud_assault_FG_cover124"] = "너가 가진 수류탄 다 던져라",
		["hud_assault_FG_cover125"] = "분노를 씻어내라",
		["hud_assault_FG_cover126"] = "레이드: 월드 워 2의 쿠르간 특집",
		["hud_assault_FG_cover127"] = "난 파티를 위해 옷을 거의 입지 않았어",
		["hud_assault_FG_cover128"] = "법이 앞에 있으므로 엄폐를 시도해라",
		["hud_assault_FG_cover129"] = "너의 용맹을 지켜라",
		["hud_assault_FG_cover130"] = "시그마의 말에 따르면 그들이 많은 수로 나온단다.",
		["hud_assault_FG_cover131"] = "현상 수배: 죽이거나 살리거나",
		["hud_assault_faction_nightmare"] = "VS. ???",
		["hud_assault_faction_sbz"] = "VS. SBZ 오퍼레이터",
		["hud_assault_faction_ovk"] = "VS. 오버킬 모더레이터",
		["hud_assault_faction_bofadeez"] = "VS. 본킬 태크 팀",
		["hud_assault_faction_bofa"] = "VS. 보 포스 알파 관리자",
		["hud_assault_faction_federales"] = "VS. 연방 정부",
		["hud_assault_faction_swat"] = "VS. SWAT 팀",
		["hud_assault_faction_sharedswat"] = "VS. SWAT 팀 & 머키워터 대대",		
		["hud_assault_faction_sharedfbi"] = "VS. FBI 전대 & 머키워터 대대",
		["hud_assault_faction_sharedgensec"] = "VS. 젠섹 기동부대 & 머키워터 대대",		
		["hud_assault_faction_sharedzeal"] = "VS. ZEAL 군단",				
		["hud_assault_faction_fbi"] = "VS. FBI 전대",
		["hud_assault_faction_fbitsu"] = "VS. FBI & 젠섹",
		["hud_assault_faction_ftsu"] = "VS. 젠섹 기동부대",
		["hud_assault_faction_zeal"] = "VS. ZEAL 군단",
		["hud_assault_faction_psc"] = "VS. 머키워터 대대",
		["hud_assault_faction_mad"] = "VS. 트라이앵글 부대",
		["hud_assault_faction_hvh"] = "당신은 때거리를 자극했습니다",
		["hud_assault_faction_generic"] = "VS. 모두",
		["hud_assault_faction_mexcross"] = "VS. 머키워터 대대",
		["hud_assault_danger"] = "!!! 위험 !!!",
		["hud_assault_dangermex"] = "!!! PERIGO !!!",
		["hud_assault_FG_danger1"] = "!!! 좀 만 버티라고 !!!",
		["hud_assault_FG_danger2"] = "!!! 아직 끝이 아니야 !!!",
		["hud_assault_FG_danger3"] = "!!! 돌아올 시간이야 !!!",
		["hud_assault_FG_danger4"] = "!!! 포기하지마 !!!",
		["hud_assault_FG_danger5"] = "!!! 총 쏘러 나가 !!!",
		["hud_assault_FG_danger6"] = "!!! 함께 나아가 !!!",
		["hud_assault_FG_danger7"] = "!!! 지금은 무너질 순 없어 !!!",
		["hud_assault_FG_danger8"] = "!!! 그들이 널 죽이려고 하면, 그들을 처죽이려라 !!!",
		["hud_assault_FG_danger9"] = "!!! 실패는 마음에만 있다고 !!!",
		["hud_assault_FG_danger10"] = "!!! 어떻게 조류가 얼마나 바뀐거야 !!!",
		["hud_assault_FG_danger11"] = "!!! 내 달팽이들이 서로 떡친다고 !!!",
		["hud_assault_FG_danger12"] = "!!! 도전을 유지해 !!!",
		["hud_assault_FG_danger13"] = "!!! 이 상황은 확실하게 니 잘못이 아니야 !!!",
		["hud_assault_FG_danger14"] = "!!! 이 상황은 전적으로 니 잘못이다 !!!",
		["hud_assault_FG_danger15"] = "!!! 표류되지 말라고 !!!",
		["hud_assault_FG_danger16"] = "!!! 하이퍼 하이스팅에 온 걸 환영한다, 이 오타쿠야 !!!",
		["hud_assault_FG_danger17"] = "!!! 이걸 처음 하냐 !!!",
		["hud_assault_FG_danger18"] = "!!! 오 젠장 오 젠장 오 젠장 !!!",
		["hud_assault_FG_danger19"] = "!!! 조심하는게 좋을거야 !!!",
		["hud_assault_FG_danger20"] = "!!! 어엄 !!!",
		["hud_assault_FG_danger21"] = "!!! 아마도 니 뒤질거다 !!!",
		["hud_assault_FG_danger22"] = "!!! 드라간이 화난건 실제로 거의 드문 장면인데 !!!",
		["hud_assault_FG_danger23"] = "!!! 은행 안에 있을래, 은행 안에 있을래 !!!",
		["hud_assault_FG_danger24"] = "!!! 니 엄폐에 있으라는 파트를 보고 있었지, 그렇지? !!!",
		["hud_assault_FG_danger25"] = "!!! 어쨌든 니 도움이 필요하지 않았어 !!!",
		["hud_assault_FG_danger26"] = "!!! 어썰트 배너에 의해 성공적으로 니 주의를 분산시켰다 !!!",
		["hud_assault_FG_danger27"] = "!!! 모두 지옥에 갈거야 !!!",
		["hud_assault_FG_danger28"] = "!!! 좆까라 그래 !!!",
		["hud_assault_FG_danger29"] = "!!! 탈출로는 없다 !!!",
		["hud_assault_FG_danger30"] = "!!! 널 도와 줄 수 있는 사람은 없어 !!!",
		["hud_assault_FG_danger31"] = "!!! 너는 곧 잼의 전체 크기까지 기소될거다 !!!",
		["hud_assault_FG_danger32"] = "!!! 이봐 씹새끼야, 이 어썰트 웨이브에서 내가 싸우는 걸 지켜보고 싶냐 !!!",
		["hud_assault_FG_danger33"] = "!!! 이런 망할 뒤집혀지네 !!!",
		["hud_assault_FG_danger34"] = "!!! 아 제발 !!!",
		["hud_assault_FG_danger35"] = "!!! 투척을 반복해 !!!",
		["hud_assault_FG_danger36"] = "!!! 지금 계속 진행하고 재시작이나 해 !!!",
		["hud_assault_FG_danger37"] = "!!! 모든게 괜찮아질테니, 할 수 있어 !!!",
		["hud_assault_FG_danger38"] = "!!! 해낼 수 있다고 !!!",
		["hud_assault_FG_danger39"] = "!!! 마녀 사냥이 끝났어 !!!",
		["hud_assault_FG_danger40"] = "!!! 난 1분 동안 떠났는데 이런 엿같은 일이 일어났어 !!!",
		["hud_assault_FG_danger41"] = "!!! 살려면 씨부랄 도망치라고 !!!",
		["hud_assault_FG_danger42"] = "!!! 젠장할, 우린 좆됬다고 !!!",
		["hud_assault_FG_danger43"] = "!!! 너의 빛이 저멀리 사라진다 !!!",
		["hud_assault_FG_danger44"] = "!!! 어둠을 받아들어라 !!!",
		["hud_assault_FG_danger45"] = "!!! 불행한 불알 !!!",
		["hud_assault_FG_danger46"] = "!!! 법이 이겼다 !!!",
		["hud_assault_FG_danger47"] = "!!! 솔직히 보기보다 나쁘지 않아 !!!",
		["hud_assault_FG_danger48"] = "!!! 덤불 주위에서 싸움을 멈춰 !!!",
		["hud_assault_FG_danger49"] = "!!! 지금은 두려움의 시간이야 !!!",
		["hud_assault_FG_danger50"] = "!!! 너의 몸이 곧 산산조각 날거야 !!!",
		["hud_assault_FG_danger51"] = "!!! 넌 완전 끝났어 !!!",
		["hud_assault_FG_danger52"] = "!!! 니 뭣같은건 단단하지 않구만 !!!",
		["hud_assault_FG_danger53"] = "!!! 심판 !!!",
		["hud_assault_FG_danger54"] = "!!! 이제 끝났어 !!!",
		["hud_assault_FG_danger55"] = "!!! 너의 고어가 빛날 것 !!!",
		["hud_assault_FG_danger56"] = "!!! 죽어 !!!",
		["hud_assault_FG_danger57"] = "!!! 악마를 울리게 만드는구나 !!!",
		["hud_assault_FG_danger58"] = "!!! 어리석다, 하이스터들아, 어리석다고 !!!",
		["hud_assault_FG_danger59"] = "!!! 이봐 친구, 상태가 안좋은거처럼 보여 !!!",
		["hud_assault_FG_danger60"] = "!!! 이건 불가피해 !!!",
		["hud_assault_FG_danger61"] = "!!! 우린 살아서 집으로 갈꺼라매, 이 거짓말쟁이야, 이 거짓말쟁이야 !!!",
		["hud_assault_FG_danger62"] = "!!! 수류탄을 더 던져봐 !!!",
		["hud_assault_FG_danger63"] = "!!! 너의 밈 여기까지다 !!!",
		["hud_assault_heat"] = "히트 보너스",
		["hud_heat_common"] = "휴식 시간!",
		["hud_heat_1"] = "아나키 군단들!",
		["hud_heat_2"] = "건방지게 굴지 마!",
		["hud_heat_3"] = "한 판 해보자고!",
		["hud_heat_4"] = "스트으으으라이크!",
		["hud_heat_5"] = "완벽한 녹아웃!",
		["hud_heat_6"] = "망할 오버킬 달성!",
		["hud_heat_7"] = "엉망진창!",
		["hud_heat_8"] = "울트라아아아아아아!!!",
		["hud_heat_9"] = "쫒아내기!",
		["hud_heat_10"] = "제압중!",
		["hud_heat_11"] = "이런 미친!",
		["hud_heat_12"] = "웜보 콤보!",
		["hud_heat_13"] = "넌 거친 사람이야!",
		["hud_heat_14"] = "이제 너의 시간이야!",
		["hud_heat_15"] = "모든걸 퍼부어!",
		["hud_heat_16"] = "연기 섹시 스타일답게!",
		["hud_heat_17"] = "파괴적인 마무리!",
		["hud_heat_18"] = "데드 온!",
		["hud_heat_19"] = "백발백중!",
		["hud_heat_20"] = "아주 멋지군!",
		["hud_heat_21"] = "저거 대박이군!",
		["hud_heat_22"] = "에이스!",
		["hud_heat_23"] = "어썰트 정복!",
		["hud_heat_24"] = "평화와 고요의 성취!",
		["hud_heat_25"] = "알림: 과신은 느리고 교활한 살인자다!",
		["hud_heat_26"] = "그림자가 남아 있다!",
		["hud_heat_27"] = "너희 모두 모피 코트이고 팬티는 없다. 썅년들아!",
		["hud_heat_28"] = "울트라킬!",
		["hud_heat_29"] = "현실을 유지해!",
		["hud_heat_30"] = "하이퍼 하이스팅에 온 걸 환영한다!",
		["hud_heat_31"] = "완벽해!",
		["hud_heat_32"] = "최고 승리!",
		["hud_heat_33"] = "살인마!",
		["hud_heat_34"] = "대학살!",
		["hud_heat_35"] = "이건 망할 전쟁이라구, 이 사람아!",
		["hud_heat_36"] = "잭팟!",
		["hud_heat_37"] = "토스티!",
		["hud_heat_38"] = "어둠 속으로 사라져!",
		["hud_heat_39"] = "사요나라아!",
		["hud_heat_40"] = "통제력을 발휘해!",
		["hud_heat_41"] = "극한 폭력!",
		["hud_heat_42"] = "지옥불이야, 지옥불이라고!",
		["hud_heat_43"] = "선봉자에게 말하지 마!",
		["hud_heat_44"] = "수호자들은 자신의 운명을 결정한다!",
		["hud_heat_45"] = "척추가 얼얼하네!",
		["hud_heat_46"] = "뼈가 진정되고 있네!",
		["hud_heat_47"] = "호러 쇼!",
		["hud_heat_48"] = "비명 질려!",
		["hud_heat_49"] = "자연의 섭리!",
		["hud_heat_50"] = "블라모!",
		["hud_heat_51"] = "승리했어, 그래, 하지만 항상 또 다른 전투가 있다고!",
		["hud_heat_52"] = "폭력을 위한 만세!",
		["hud_heat_53"] = "피, 피가 존나 많아!",
		["hud_heat_54"] = "어썰트 배너에게 성공적으로 축하받았어!",
		["hud_heat_55"] = "예이!",
		["hud_heat_56"] = "부서버려!",
		["hud_heat_57"] = "느낌표!",
		["hud_heat_58"] = "고기 보너스!",
		["hud_heat_gameplay"] = "당신은 순간적으로 때거리들을 밀어붙였습니다",
		["hud_assault_cover"] = "엄폐에 머물어라",
		["hud_assault_cover_blma"] = "엄폐에 머물어라고 씹새끼야",		
		["hud_assault_coverhvh"] = "멈추지 말아라",
		["hud_assault_cover_mexcross"] = "MANTENTE A CUBIERTO",
		["hud_assault_cover_repers"] = "ОСТАВАЙТЕСЬ В УКРЫТИИ",
		["hud_assault_cover_nightmare"] = "숨어있는 상태로 머물어라",
		["hud_assault_assault"] = "어썰트 진행 중",
		["hud_assault_assault_blma"] = "asal,t: blackmailer",		
		["hud_assault_assaultrepers"] = "ИДЁТ ШТУРМ НАЁМНИКОВ",		
		["hud_assault_assaulthvh"] = "NECROCIDE IN PROGRESS",
		["hud_assault_assault_mexcross"] = "ASALTO EN MARCHA",
		["hud_assault_assault_nightmare"] = "무언가가 잘못됬어",
		["hud_assault_assault_ghosts"] = "이상징후 진행 중",
		["menu_toggle_one_down"] = "신 샷아웃",
		["menu_one_down"] = "신 샷아웃",
		["menu_cs_modifier_heavies"] = "불도저를 제외한 모든 특수 적들은 이제 방탄복을 입고, 중무장 SMG가 스폰될 확률이 추가됩니다.",
		["menu_cs_modifier_magnetstorm"] = "적이 재장전하면 잠시 후 플레이어를 감전시키는 전기 버스트를 방출합니다.",
		["menu_cs_modifier_heavy_sniper"] = "스나이퍼 도저가 스폰될 확률이 추가됩니다.",
		["menu_cs_modifier_taser_overcharge"] = "테이저가 이제 당신을 감전시키는 동안 감전 피해를 두 배정도 입힙니다.",
		["menu_cs_modifier_dozer_lmg"] = "모든게 끔찍해진다!!!",
		["menu_cs_modifier_unison"] = "아직 제작 중인 수정자, 현재 아무것도 없습니다",
		["menu_cs_modifier_dozer_rage"] = "다른 차원에서 온 관통탄이 있는 Deagle-toting을 쓰는 메딕이 스폰될 확률이 추가됩니다.",
		["menu_cs_modifier_monsoon"] = "적들이 매 어썰트 웨이브마다 15%만큼 빨라집니다.",
		["menu_cs_modifier_dozer_minigun"] = "메딕 도저와 미니건 도저가 스폰될 확률을 추가합니다.",
		["menu_cs_modifier_shield_phalanx"] = "산탄총 사수가 젠섹 사이가 SWAT으로 교체될 확률이 추가됩니다.",
		["menu_cs_modifier_dozer_medic"] = "ERROR: menu_cs_modifier_suppressive_winters",
		["menu_cs_modifier_shin"] = "신 샷아웃이 활성화됩니다.",
		["menu_cs_modifier_no_hurt"] = "적들은 이제 비틀거림 저항이 더 증가합니다.",
		["menu_cs_modifier_medic_adrenaline"] = "완전 무장한 ZEAL 경무장이 생성될 확률을 추가합니다. 이 적은 뒤통수를 노려야만 죽일 수 있습니다.",
		["menu_cs_modifier_megacloakers"] = "클로커는 이제 킥을 50% 더 많이 피해 입히고, 두 배 더 멀리 보내고, 두 배 더 멀리에서 점프킥할 수 있습니다.",
		["menu_cs_modifier_voltergas"] = "연막탄이 최루 가스 연막탄으로 대체됩니다.",
		["menu_cs_modifier_bouncers"] = "적들은 사망 시 경고음과 파괴 가능한 폭발성 수류탄을 떨어뜨릴 수 있습니다.",
		["menu_cs_modifier_cloaker_tear_gas"] = "클로커는 이제 돌진하는 동안 조용해지고 25% 더 빠르게 움직입니다.",
		["menu_cs_modifier_enemy_health_damage"] = "적들은 추가로 피해량이 10%만큼 증가하고 체력이 5%만큼 증가하며 스텔스 상태에서 당신을 약간 더 빠르게 감지합니다.",
		["loading_heister_13"] = "당장 현실에서 경찰을 쏴봐!!! 니 인생을 확실하게 끝내줄거야! 믿어보라고!",
		["loading_heister_21"] = "제압이 방어구 재생을 완전히 멈추게 하는 것은 아닙니다! 방어구가 부서졌고 사격당할 때 당황하지 마세요! 시야에서 벗어나고 인내심을 가지세요!",
		["loading_heister_44"] = "메이헴, 데스 위시 및 데스 센텐스의 적들은 훨씬 더 잘 회피합니다! 그들이 언제 회피할지 예측해보십시오!",
		["loading_heister_45"] = "ZEAL 군단은 데스 센텐스에서만 등장합니다. 가치 있는 도전이겠지, 아마도?",
		["loading_heister_46"] = "모든 불도저는 위험한 방식을 가지고 있으므로 피해량, 억제 및 사거리를 주시하십시오!",
		["loading_heister_49"] = "당신의 싸움을 정확하게 선택하십시오! 혼자 미니건 도저를 상대하는 것이 항상 원하는 방식으로 해결되는 것은 아닙니다!",
		["loading_heister_51"] = "많은 일을 할 수 있는 제너럴리스트 빌드를 갖는 것은 완전히 괜찮습니다. 이를 뒷받침할 생소한 기술이 있다고 가정하면 말이죠!",
		["loading_heister_52"] = "선택한 방어구의 균형력 능력치는 공격을 받았을 때 카메라가 얼마나 세게 흔들리는지를 추적하지만... 하이퍼 하이스팅에서는 해당 통계가 모든 방어구에 동일하게 적용됩니다!",
		["loading_gameplay_15"] = "ZEAL은 패션 감각이 매우 뛰어납니다. 군중 속에서 그들의 색깔을 보고 어떤 무기를 사용하고 있는지 알아보세요!",
		["loading_gameplay_37"] = "더 높은 데미지의 소총과 산탄총은 적은 발사로도 테이저나 불도저와 같은 더 강한 적을 제압할 수 있지만 군중 제어는 약합니다. 다른 무기의 능력으로 이를 개선하십시오!",
		["loading_gameplay_46"] = "저격수는 당신이 사격 라인 내에서 시간을 보낼수록 더 정확해집니다. 그런 일이 일어나기 전에 저격수를 죽이세요!",
		["loading_gameplay_56"] = "무한 어썰트 중에서도 플레이어는 기다리기만 하면 구금 상태에서 벗어날 수 있습니다!",
		["loading_gameplay_76"] = "불도저를 죽이려면 죽을 때까지 쏘십시오! 노려할 곳은 특정 페이스 플레이트, 바이저 또는 얼굴입니다!",
		["loading_gameplay_92"] = "저격수를 무시하면 몇 초 만에 방어구와 체력을 매우 쉽게 고갈시킬 수 있습니다. 빨리 처리하십시오!",
		["loading_gameplay_13"] = "적을 아십시오. 메딕은 산탄총을 사용할 때 빨간 복장을, 소총을 사용할 때 파란 복장을 착용합니다!",
		["loading_gameplay_73"] = "적의 무리에서 도망치는 것이 때때로 나쁜 생각은 아니지만, 어썰트 웨이브를 끝낼려면 적들을 죽이는 것은 필수입니다!",
		["loading_gameplay_96"] = "하이퍼 하이스팅에서는 캡틴 윈터스가 나타나지 않습니다! 뭐, 그가 있을 수 있겠지만! 실제로는 그렇지 않습니다! 하지만 좀! 그래!",
		["loading_gameplay_97"] = "어떤 이유에서든 일반 캡틴 윈터스가 나타나면 MWS 페이지에 댓글을 게시하십시오! 그런 일이 일어나서는 안 됩니다!",
		["loading_gameplay_126"] = "캡틴 윈터스가 없는 게임을 용납할 수 없다면 언제나 바닐라로 돌아갈 수 있어! 널 비난하지는 않겠어!",
		["loading_trivia_59"] = "겨울은 여름과 반대되는 극지방과 온대 지역에서 일년 중 가장 추운 계절이고 매년 가을 이후 봄 이전에 발생합니다.",
		["loading_trivia_60"] = "01110111 01101001 01101110 01110100 01100101 01110010 01110011",
		["loading_trivia_61"] = "지금은 그들의 시즌이다. 너는 탈출할 수 없을 것이다.",
		["loading_trivia_62"] = "캡틴 윈터스는 가 아닙니다 ",
		["loading_trivia_93"] = "드리간은 테이저를 절대적으로 싫어합니다! 그를 플레이하면서 맨손으로 테이저의 얼굴에 펀치를 날리세요! 후회하지 않을 것입니다!",		
		["loading_hh_title"] = "하이퍼 하이스팅 팁들",
		["loading_hh_1"] = "데스 센텐스의 적들은 다양한 전술을 수행하는 경향이 있으므로 어떤 그룹이 어떤 전략을 사용하는지, 유리한 점을 얻을 수 있는지 확인하십시오!",
		["loading_hh_2"] = "닌자 적들은 일반 공격 부대보다 더 많은 피해를 입히고 회피가 훨씬 뛰어납니다! 공격하는 동안 덜 무장하고 더 독특한 유닛을 찾으십시오!",
		["loading_hh_3"] = "신 샷아웃은 가장 똑똑하고 빠르고 강인한 플레이어만을 위한 모드입니다! 활성화되면 적들이 훨씬 더 공격적으로 됩니다!",
		["loading_hh_4"] = "어려운 상황에 처하더라도 포기하지 마십시오! 항상 탈출구가 있을 수 있습니다!",
		["loading_hh_5"] = "하이퍼 하이스팅에서 클로커 킥은 뒤로 밀치고 엄청난 피해를 줄 수 있습니다! 그들에게서 떨어져 있으십시오!",
		["loading_hh_6"] = "하이퍼 하이스팅에서는 난이도가 올라갈수록 특수 적들이 더 위협적으로 변합니다! 그들을 주시하십시오!",
		["loading_hh_7"] = "하이퍼 하이스팅에서 경찰은 일반적으로 난이도가 2씩 늘어날 때마다 더 지능적이고, 더 빨라지고, 약간 더 많은 피해를 입히고, 더 정확합니다. 반면 그들의 그룹 전술은 모든 난이도에서 더 좋아집니다!",
		["loading_hh_8"] = "가능하다면 코너에서 경찰이 하는 말에 귀를 기울이면 일부 그룹이 어떤 전술을 가지고 있을지 예측하는 데 도움이 될 것입니다! 또한 그들이 연막탄과 섬광탄을 던지는 소리를 들을 수 있습니다!",
		["loading_hh_9"] = "하이퍼 하이스팅에서 산탄총 사수는 총을 쏠 때 총에서 나오는 거대한 연기 퍼프를 가지고 있습니다. 이것은 당신이 그들을 찾는 데 도움이 될 뿐만 아니라 그들이 언제 다시 발사할 수 있는지 알아내는 데도 도움이 됩니다!",	
		["loading_hh_10"] = "주변 영역을 왜곡하는 매우 밝고 강력한 예광탄를 본다면 그건 아마도 중요한 적에게서 오는 것일 수 있습니다! 산탄총 사수나 불도저처럼요!",
		["loading_hh_11"] = "하이퍼 하이스팅 디스코드에 가입해보십시오! ModWorkshop 페이지에서 링크를 찾을 수 있습니다!",
		["loading_hh_12"] = "닌자 적들은 특별히 제압하기 어렵지만 조커로 전환하면 매우 강력합니다!",
		["loading_hh_13"] = "하이퍼 하이스팅에서 중무장 SWAT, 강력 대응 부대 및 ZEAL 중무장 SWAT는 모든 난이도에서 총알 기반의 즉사 킬로부터 보호됩니다! 그러나 방패를 관통할 수 없는 무기 혹은 탄약 유형 한정으로만 보호됩니다!",
		["loading_hh_14"] = "옵션 메뉴의 모드 옵션을 통해 하이퍼 하이스팅 옵션으로 이동할 수 있습니다!",
		["loading_hh_15"] = "하이퍼 하이스팅에서는 적의 근접 공격을 받으면 일시적으로 비틀거리며 잠시 동안 공격할 수 없게 됩니다!",
		["loading_hh_16"] = "펑크는 리볼버, 더블 배럴 샷건 및 기관단총을 사용하고 지나치게 자신만만한 마초적인 적입니다. 당신이 그들을 냅두지 않으면 그들은 당신을 많이 다치게하지 않을 것입니다!",
		["loading_hh_17"] = "하이퍼 하이스팅에서는 테이저에게 무력화되고 클로커에게 쓰러지는 것도 실제 다운으로 간주되어 구금될 수도 있습니다! 주위를 조심하십시오!",
		["loading_hh_18"] = "하이퍼 하이스팅에서 특정 투척물은 기본적으로 탄약 회수해도 투척물을 회수할 수 있습니다!",
		["loading_hh_19"] = "하이퍼 하이스팅에서 스태미나가 부족해도 전력 질주가 취소되지는 않지만 속도가 느려지고 전력 질주 관련 보너스나 효과가 적용되지 않습니다!",
		["loading_hh_20"] = "하이퍼 하이스팅에서 일반 전력 질주는 스태미나가 10 이상일 때 전력 질주로 구성됩니다! 그 이하의 스태미나로 전력 질주하면 전력 질주 관련 효과가 발동하지 않습니다!",
		["loading_hh_21"] = "엄폐물에 있는 것은 방어구가 지속적으로 재생되고 손상되지 않도록 하는 좋은 방법입니다! 밀고 들어오는 적들을 조심하세요!",
		["loading_hh_22"] = "닌자는 측면 경로로 가는 경향이 있으며 종종 다른 유닛과 동행합니다!",
		["loading_hh_23"] = "히트 보너스는 체력과 탄약의 50%를 재생합니다!",
		["loading_hh_24"] = "히트 보너스는 경찰이 들이닥치는 것을 막고 목표를 달성할 시간을 벌어줍니다!",
		["loading_hh_25"] = "히트 보너스는 팀원이 잘하고 공격적으로 플레이하는 경우에만 발생하는 경향이 있습니다!",
		["loading_hh_26"] = "적들은 더 높은 난이도에서 부상을 입었을 때 훨씬 빨리 회복됩니다!",
		["loading_hh_27"] = "때로는 적을 죽이고 도망칠 필요가 없습니다! 그들의 몸에 몇 발의 총격을 가하고 도망가게 만들 수 있습니다!",
		["loading_hh_28"] = "불도저에게 많은 총격을 가하면 불도저가 잠시 동안 기절하여 빠르게 도망치거나 일격으로 마무리할 수 있습니다!",
		["loading_hh_29"] = "불도저를 기절시키는 가장 좋은 방법은 화염 방사기의 화염으로 불도저를 불태운 다음 총을 사용하여 기절 애니메이션을 하게 만드는 것입니다!",
		["loading_hh_30"] = "화염방사기는 적을 기절 애니메이션으로 묶는 데 효과적이며 멍청한 일반 적들을 매우 빨리 태우는 경향이 있습니다!",
		["loading_hh_31"] = "클로커는 움직일 때 방독면에서 큰 숨소리를 내며 이 소리에 귀를 기울이십시오!",
		["loading_hh_32"] = "하이퍼 하이스팅에서 산탄총은 사거리 내에서 피해의 최소 10%를 가합니다! SWAT 저격수를 조심하십시오!",
		["loading_hh_33"] = "하이퍼 하이스팅에서 산탄총을 사용할 때 무기의 정확도를 50 이상으로 높이면 더 높은 사거리에서 최소 피해가 증가합니다!",
		["loading_hh_34"] = "하이퍼 하이스팅에서 적에게 화상을 입힐 때 지속적으로 받는 피해는 무기의 피해 통계를 기반으로 합니다! 화염방사기와 드래곤의 숨결탄을 쓰는 샷건에 모두 적용됩니다!",
		["loading_hh_35"] = "염방사기의 지속 시간 경과에 따른 피해는 대부분 항상 드래곤의 숨결탄의 지속 시간 경과에 따른 피해보다 초과하지만 훨씬 짧습니다!",
		
		["loading_hs_1"] = "말하는 모든 단어 앞에 느낌표가 있어야돼!",
		["loading_hs_2"] = "죽지 않으면 더 쏴라!",
		["loading_hs_3"] = "세가지 단어로 요약 해본다! 수학은! 패자들을! 위한것이다!",
		["loading_hs_4"] = "쟤네들이 죽으면 니를 죽일 수 없어!",
		["loading_hs_5"] = "니가 말하는 다른 문장마다 사람들을 모욕한다면! 너는 게임을 존나 못한다는 거다!",
		["loading_hs_6"] = "제롬에게는 많은 형제들이 있어!",
		["loading_hs_7"] = "ZEAL과 함께 협력하는 제롬은 제롬 (쿨러)이라고 함!",
		["loading_hs_8"] = "크랙다운 디스코드로 가서 더 많은 네온 유닛을 요청해봐!",
		["loading_hs_9"] = "크라임 스프리에서 Deagle을 사용하는 메딕은 크랙다운의 세계관에서 왔어! 그가 어떻게 여기에 왔는지 묻지말라고!",
		["loading_hs_10"] = "조바니가 가장 좋아하는 음식은 플레인 오트밀임!",
		["loading_hs_11"] = "드라간은 폰게임이 없다.",
		["pattern_truthrunes_title"] = "진실의 룬",				
		["menu_l_global_value_hyperheist"] = "이 상품은 하이퍼 하이스팅의 아이템입니다!",
		["menu_l_global_value_hyperheisting_desc"] = "이 상품은 하이퍼 하이스팅의 아이템입니다!",		
		
		["shin_options_title"] = "하이퍼 하이스팅 옵션!",	
		
		["shin_toggle_helmet_title"] = "아주 강한 헬멧 날리기!",
		["shin_toggle_helmet_desc"] = "헬멧의 날아가는 힘과 위력을 강화하고 계산을 변경하여 더 멋진 으악을 줍니다!",
		
		["shin_toggle_hhassault_title"] = "세련된 어썰트 코너!",
		["shin_toggle_hhassault_desc"] = "[경찰 타격대 돌입 중] 허드 영역을 추가 풍미를 더하여 향상시킵니다! (예: 싸우고 있는 진영을 기반으로 한 완전히 독특한 어설트 텍스트!) 참고: 게임 중간에 변경된 경우 하이스트를 다시 시작해야 합니다!",
		
		["shin_toggle_hhskulldiff_title"] = "하이퍼 난이도 이름!",
		["shin_toggle_hhskulldiff_desc"] = "하이퍼 하이스팅의 스타일에 맞게 난이도 이름을 변경합니다!",
		
		["shin_toggle_blurzonereduction_title"] = "덜 흐릿한 블러존!",
		["shin_toggle_blurzonereduction_desc"] = "쿡 오프 제조장와 같은 사물의 흐릿한 효과가 게임 플레이에 방해가 되지 않도록 부드럽게 줄입니다!",
		
		["shin_toggle_highpriorityglint_title"] = "높은 우선 순위!",
		["shin_toggle_highpriorityglint_desc"] = "우선 순위가 높은 적들이 발사하려고 할 때 반짝임을 추가하고 3미터 이내에 있으면 *딩!* 소리를 내서 거위가 익었다는 것을 알려줍니다! (참고: 이것은 그들이 당신을 대상으로 하는 경우에만 적용됩니다!)",
		
		["shin_toggle_screenFX_title"] = "울트라 스크린FX!",
		["shin_toggle_screenFX_desc"] = "바닐라에 존재하는 화면 효과에 다양한 시각적 조정 및 추가 기능을 추가합니다! 참고: 뇌전증 걸린 사람에게는 권장하지 않습니다.",
		
		["shin_toggle_suppression_title"] = "X-treme 가시적 제압!",
		["shin_toggle_suppression_desc"] = "적에게 제압당할 때 화면에 독특한 시각 효과를 추가합니다!",
		
		["shin_toggle_health_effect_title"] = "낮은 체력 비주얼!",
		["shin_toggle_health_effect_desc"] = "당신의 체력이 얼마나 낮은지 나타내기 위해 피 묻은 화면 테두리 효과를 추가합니다! 참고: 변경 사항을 적용하려면 하이스트를 다시 시작해야 합니다.",
		
		["shin_screenshakemult_title"] = "스크린쉐이크 강도",
		["shin_screenshakemult_desc"] = "화면 흔들림 효과의 강도를 수동으로 설정할 수 있습니다! 멀미를 하는 경향이 있다면 낮출 수 있습니다! 참고: 화면 흔들림을 낮추면 게임이 훨씬 덜 임팩트 있게 느껴질 수 있습니다!",
		
		["shin_toggle_noweirddof_title"] = "환경 심도 비활성화",
		["shin_toggle_noweirddof_desc"] = "배경과 스카이박스에서 피사계 심도를 제거하여 훨씬 더 선명하게 보이도록 합니다! 참고: 조준 피사계 심도와 함께 작동합니다!",
		
		["shin_albanian_content_enable_title"] = "알바니아 농담 콘텐츠 활성화",
		["shin_enable_albanian_content_title"] = "알바니아 농담 콘텐츠 활성화",
		["shin_albanian_content_enable_desc"] = "알바니아 콘텐츠 성화 (경고: 이 기능을 활성화하면 안될 걸입니다!)",		
		["shin_toggle_overhaul_player_title"] = "하이퍼 하이스팅 플레이어 측 재조정!",
		["shin_toggle_overhaul_player_desc"] = "Gambit의 VIWR 모드 수정 버전과 함께 하이퍼 하이스팅 플레이어 측 재조정을 활성화합니다! 게임을 신선하게 만들기 위해 기존 스킬의 다양한 리워크를 제공합니다! 경고: 전체 게임을 다시 시작한 후에만 적용됩니다!!!",
		["shin_requires_restart_title"] = "재시작 필요!",
		["shin_requires_restart_desc"] = "다음 설정을 변경했습니다:\n$SETTINGSLIST\n이 변경 사항은 게임을 다시 시작할 때 적용됩니다.\n좋은 하루 되세요!",
		["menu_risk_pd"] = "완전하게 입문할 수 있습니다.",
		["menu_risk_swat"] = "간단하지만 도전적. 우린 멋져.",
		["menu_risk_fbi"] = "도전적이지만 편안합니다. 좋은 미풍이군.",
		["menu_risk_special"] = "따뜻한 여름날. 평범한 도전, 방심하지 마.",
		["menu_risk_easy_wish"] = "집중을 요구. 여기 뜨거워지는데!",
		["menu_risk_elite"] = "더 많은 유닛이 접근합니다! 코너에 더 많은 히트!",
		["menu_risk_sm_wish"] = "불길을 피할 길은 없다! 맞서 싸워라!",
		["menu_hh_mutator_incomp"] = "슬프게도! 이 뮤테이터는 하이퍼 하이스팅과 호환되지 않습니다...!",
	})
end)

 if _G.BB or FullSpeedSwarm or Iter or _G.SC or _G.deathvox then
	Hooks:Add("LocalizationManagerPostInit", "HH_Incompatible", function(loc)
	LocalizationManager:add_localized_strings({	
		["menu_toggle_one_down"] = "AI 모드를 제거해주십시오",
		["menu_one_down"] = "AI 모드를 제거해주십시오"
	})		
	end)
 end
 
if InFmenu then
  if InFmenu.settings.rainbowassault == true or InFmenu.settings.sanehp == true or InFmenu.settings.copmiss == true or InFmenu.settings.copfalloff or InFmenu.settings.skulldozersahoy == 2 or InFmenu.settings.skulldozersahoy == 3 then
	Hooks:Add("LocalizationManagerPostInit", "HH_IncompatibleIren", function(loc)
	LocalizationManager:add_localized_strings({	
		["menu_toggle_one_down"] = "모든 IRENFIST의 적 및 모든 적 스폰 조정 비활성화해주십시오",
		["menu_one_down"] = "모든 IRENFIST의 적 및 모든 적 스폰 조정 비활성화해주십시오"
	})		
	end)
  end
end

if PD2THHSHIN and PD2THHSHIN:SkullDiffEnabled() then
	Hooks:Add("LocalizationManagerPostInit", "HH_SKULLS", function(loc)
		LocalizationManager:add_localized_strings({			
			["menu_difficulty_normal"] = "스위트",
			["menu_difficulty_hard"] = "소프트",
			["menu_difficulty_very_hard"] = "마일드",
			["menu_difficulty_overkill"] = "스파이시",
			["menu_difficulty_easy_wish"] = "울트라 스파이시",
			["menu_difficulty_apocalypse"] = "스코징 핫",
			["menu_difficulty_sm_wish"] = "인터널"	
		})
	end)
end

 
Hooks:Add("LocalizationManagerPostInit", "HH_overhaul", function(loc)
	
	if PD2THHSHIN and PD2THHSHIN:IsOverhaulEnabled() then
		LocalizationManager:add_localized_strings({	
			--SPEED IS WAR
			["bm_menu_movement"] = "이동 속도",

			--Rogue
			["menu_deck4_1_desc"] = "회피 확률이 ##5%##만큼 증가합니다.",
			["menu_deck4_5_desc"] = "회피 확률이 ##10%##만큼 증가합니다.",
			["menu_deck4_7_desc"] = "회피 확률이 ##15%##만큼 증가합니다.",
		
			--Crook
			["menu_deck6_1_desc"] = "회피 확률이 ##5%##만큼 증가합니다.",
			["menu_deck6_5_desc"] = "방탄 조끼의 회피 확률이 ##5%##만큼 증가합니다.\n\n방탄 조끼의 방탄복이 ##20%##만큼 증가합니다.",
			["menu_deck6_7_desc"] = "방탄 조끼의 회피 확률이 ##5%##만큼 증가합니다.\n\n방탄 조끼의 방탄복이 ##25%##만큼 증가합니다.",
			
			--Burglar
			["menu_deck7_1_desc"] = "회피 확률이 ##5%##만큼 증가합니다.",
			
			--Ex-President
			["menu_deck13_3_desc"] = "처치 시 저장되는 체력이 ##4##만큼 증가합니다.\n\n체력을 ##5%##만큼 더 얻습니다.",
			["menu_deck13_5_desc"] = "저장할 수 있는 최대 체력이 ##50%##만큼 증가합니다.\n\nY체력을 ##5%##만큼 더 얻습니다.\n\n회피 확률이 ##5%##만큼 증가합니다.",
			["menu_deck13_7_desc"] = "처치 시 저장되는 체력이 ##4##만큼 증가합니다.\n\n체력을 ##5%##만큼 더 얻습니다.",
			
			--Sicario
			["menu_deck18_3_desc"] = "플레이어가 총에 맞을 때마다 회피 확률을 ##10%##만큼 얻습니다.\n\n이 효과는 플레이어가 회피하면 리셋되며 다음 ##6##초 동안 발생하지 않습니다.",
			["menu_deck18_5_desc"] = "회피 확률이 ##5%##만큼 증가합니다.",
			
			--Hacker
			["menu_deck21_3_desc"] = "최대 체력이 ##+10%##만큼 증가합니다.",
			["menu_deck21_5_desc"] = "피드백 또는 재밍 효과가 활성화된 상태에서 적을 최소 ##1##명씩 죽이면 ##30##초 동안 회피가 ##+15%##만큼 부여됩니다.",
		
			--Anarchist
			["menu_deck15_1"] = "전사의 소리",
			["menu_deck15_1_desc"] = "아니키스트는 방탄복 회복 타이머가 경과하면 즉시 방탄복을 완전히 재생하는 대신 ##6##초마다 방탄복을 ##12##씩 생성합니다.\n\n방탄복이 무거울 수록 틱당 ##더 많은 방탄복을 생성##하지만 틱 사이에 ##더 긴 재생 시간##이 있습니다.\n\n적을 죽이면 방탄복 생성을 위한 틱 사이의 ##재생 속도가 빨라집니다##, 죽인 적마다 타이머가 ##1/20##만큼 줄어듭니다.\n\n참고: 이 특성 덱을 사용할 때 방탄복 회복 속도를 증가시키는 스킬과 특성은 비활성화됩니다.",
			
			["menu_deck15_3"] = "너에게 달려오기",
			["menu_deck15_3_desc"] = "체력의 ##50%##가 ##25%##만큼 방어구로 전환됩니다.",
			
			["menu_deck15_5"] = "새로운 디자인",
			["menu_deck15_5_desc"] = "체력의 ##75%##가 ##50%##만큼 방어구로 전환됩니다.",
			
			["menu_deck15_7"] = "레퀴엠",
			["menu_deck15_7_desc"] = "적을 죽이면 이제 타이머의 ##1/10##만큼 방탄복 생성을 위한 틱 사이의 재생 속도가 빨라집니다.",
			
			["menu_deck15_9"] = "존중이 없음",
			["menu_deck15_9_desc"] = "체력 피해를 입으면 ##다음 틱 당 방탄복을 즉시 재생##합니다.\n\n덱 완성 보너스: PAYDAY 도중 높은 등급의 아이템을 얻을 확률이 ##10%## 상승합니다.",

			--Even more Fire Power!--
			["menu_more_fire_power_desc"] = "베이직: ##$basic;##\n성형작약탄 ##1##개, 트립마인 ##4##개를 소지합니다.\n\n에이스: ##$pro;##\n성형작약탄 ##4##개, 트립마인 ##7##개를 더 소지합니다.",
			
			--Infiltrator/Sociopath Shit--
			["menu_deck8_1_desc"] = "이동 속도가 ##5%##만큼 추가로 증가합니다.",
			
			["menu_deck8_3_desc"] = "이동 속도가 ##5%##만큼 추가로 증가합니다.",
			
			["menu_deck8_7_desc"] = "이동 속도가 ##15%##만큼 증가합니다. \n\n근접 무기로 연속적으로 적을 맞추면 ##1.5##초 동안 근접 무기의 휘두르는 속도를 ##25%##만큼 증가시킵니다.\n\n최대 ##4##번까지 중첩될 수 있습니다.\n\n시간이 모두 지나면 모든 중첩이 리셋됩니다.",
			
			["menu_deck8_9_desc"] = "근접 무기로 적을 공격하면 체력을 ##25%##만큼 회복합니다.\n\n이 효과는 ##5##초마다 한 번만 발생합니다.",

			["menu_deck9_1"] = "말 없는",

			["menu_deck9_1_desc"] = "이동 속도가 ##15%##만큼 증가합니다. \n\n근접 무기로 연속적으로 적을 맞추면 ##1.5##초 동안 근접 무기의 휘두르는 속도를 ##25%##만큼 증가시킵니다.\n\n최대 ##4##번까지 중첩될 수 있습니다.\n\n시간이 모두 지나면 모든 중첩이 리셋됩니다.",
 
			["menu_deck9_5_desc"] ="근접 무기로 적을 죽이면 ##10%##의 체력이 회복됩니다. \n\n이 효과는 ##1##초마다 한 번만 발생합니다. \n\n이동 속도가 ##5%##만큼 추가로 증가합니다.",
 
			--Stoic--
			["menu_deck19_1_desc"] = "금욕주의자의 힙 플라스크를 잠금 해체하고 장비합니다.\n\n이제 받는 피해가 ##66%##만큼 감소합니다. 남은 데미지는 그대로 적용됩니다.\n\n대신 ##66%##만큼 감소되는 데미지가 지속 시간(##12##초)에 적용됩니다.\n\n투척무기 키를 사용하여 금욕주의자의 힙 플라스크를 활성화하고 지속 피해을 즉시 무효화할 수 있습니다. 플라스크의 재사용 대기시간은 ##15##초이지만 남은 시간은 적 처치 시 1초씩 줄어듭니다.",
			["menu_deck19_3_desc"] = "체력을 ##15%##만큼 더 얻습니다.",

			["menu_deck17_9"] = "한계까지 밀어붙여",
			
			["menu_deck2_1_desc"] = "체력을 ##5%##만큼 더 얻습니다.",
			
			["menu_deck2_3_desc"] = "팀원과 가까이 있을 때 적의 표적이 될 가능성이 ##15%##만큼 더 높아집니다.\n\n체력을 ##5%##만큼 더 얻습니다.",
			
			["menu_deck2_5_desc"] = "체력을 ##5%##만큼 더 얻습니다.",
			
			["menu_deck2_7_desc"] = "적을 죽이면 ##50%## 확률로 희생자로부터 ##6m## 반경 내에 있는 적들 사이에 ##패닉##을 퍼트립니다.\n\n##패닉##은 적들을 ##통제할 수 없는 공포로 몰아넣습니다.##",
			
			["menu_deck2_9_desc"] = "추가로 ##5%##만큼 체력을 얻습니다.\n\n##5##초마다 체력의 ##1%##를 재생합니다.",
			
			["menu_deck10_3_desc"] = "탄약을 획득하면 팀의 다른 플레이어도 일반 픽업의 ##50%##만큼 탄약을 획득합니다.\n\n이 효과는 ##5##초마다 한 번만 발생합니다.\n\n체력을 ##10%##만큼 더 얻습니다.",

			["menu_deck10_5_desc"] = "탄약을 줍고 체력을 회복하면 팀원들도 해당 탄약 획득량의 ##50%##만큼 치유됩니다.\n\n체력을 ##5%## 더 얻습니다.",
			
			--Grinder
			["menu_deck11_1_desc"] = "최대 체력의 ##50%##로 시작하며 그 이상으로 치료할 수 없습니다.\n\n적에게 피해를 입히면 ##3##초 동안 ##0.3##초마다 체력이 ##1##씩 회복됩니다.\n\n이 효과는 중첩되지만 ##1.5##초마다 한 번만 발생하며 ##투피스 정장## 또는 ##경량 방탄 조끼##를 착용한 경우에만 발생합니다.\n\n참고: 체력 제한은 ##증명할 내용##과 중첩됩니다.",
			
			["menu_deck11_3_desc"] = "이제 적에게 피해를 입히면 ##3##초 동안 ##0.3##초마다 체력이 ##2##씩 회복됩니다.\n\n체력을 ##10%## 더 얻습니다.",
			
			["menu_deck11_7_desc"] = "이제 적에게 피해를 입히면 ##3##초 동안 ##0.3##초마다 체력이 ##4##씩 회복됩니다.\n\n체력을 ##5%## 더 얻습니다.",
			
			["menu_deck17_3_desc"] = "You gain ##5%## more health.",
			["menu_deck17_5_desc"] = "You gain ##5%## more health.\n\nEnemies nearby will prefer targeting you, whenever possible, while the Injector effect is active.",
			["menu_deck17_7_desc"] = "You gain ##5%## more health.\n\nThe amount of health received during the Injector effect is increased by ##25%## while below ##50%## health.",
			["menu_deck17_9_desc"] = "You gain an additional ##5%## more health.\n\nFor every ##50## points of health gained during the Injector effect while at maximum health, the recharge time of the injector is reduced by ##1## second.",
			
			--Leech
			["menu_deck22_1_desc"] = "Unlocks and equips the Leech Ampule.\n\nChanging to another perk deck will make the Leech Ampule unavailable again.\n\nThe Leech Ampule replaces your current throwable, is equipped in your throwable slot and can be switched out if desired.\n\nWhile in game you can use throwable key ##$BTN_ABILITY;## to activate the Leech Ampule.\n\nActivating the Leech Ampule will restore ##40%## health, drain all your stamina and disable your armor and your ability to sprint for the duration of the Leech Ampule.\n\nWhile the Leech Ampule is active your health is divided into segments of ##20%## and damage taken from enemies removes one segment.\n\nKilling ##2## enemies will restore one segment of your health and block damage for ##1## second.\n\nAnytime you take damage your teammates are healed for ##5%## of their health.\n\nThe Leech Ampule lasts ##6## seconds and has a cooldown of ##60## seconds.",
			
			["menu_second_chances_beta_desc"] = "BASIC: ##$basic##\nYou gain the ability to disable ##1## camera from detecting you and your crew. Effect lasts for ##25## seconds.\n\nACE: ##$pro##\nYou lockpick ##75%## faster. You also gain the ability to lockpick safes.",
			
			["menu_perseverance_beta_desc"] = "BASIC: ##$basic##\nInstead of getting downed instantly, you gain the ability to keep on fighting for ##3## seconds with a ##60%## movement penalty before going down. \n\nACE: ##$pro##\nIncreases the duration of Swan Song to ##6## seconds.",
						
			["menu_overkill_beta_desc"] = "BASIC: ##$basic##\nKilling an enemy at medium range has a ##75%## chance to spread ##Panic## among your enemies.\n\n##Panic## will make enemies go into ##bursts of uncontrollable fear.##\n\nACE: ##$pro##\nWhen you kill an enemy with a shotgun, shotguns recieve a ##50%## damage increase that lasts for ##3## seconds.",
			
			["menu_tea_time_beta"] = "Trooper's Syringe",
			["menu_tea_time_beta_desc"] = "BASIC: ##$basic##\nAnyone who uses one of your First Aid Kits or Doctor Bags gains a ##+50%## increase in ##Reload Speed and Interaction Speed## that lasts for ##15## seconds.\n\nACE: ##$pro##\nUsing one of your First Aid Kits or Doctor Bags now also grants the user ##infinite stamina## for ##15## seconds.\n\n##Contains vaccinations, antibiotics, pain killers, steroids, heroine, gasoline...and something that feels like burning.##",
			
			["menu_tea_cookies_beta_desc"] = "BASIC: ##$basic##\nYou gain ##2## extra First Aid Kits.\n\nACE: ##$pro##\nYou gain ##2## more extra First Aid Kits.\n\nYour deployed First Aid Kits will be automatically used if a player is downed within a ##5## meter radius of the First Aid Kit.\n\nThis cannot occur more than once every ##60## seconds.",
			
			["menu_medic_2x_beta"] = "Vitamins",
			["menu_medic_2x_beta_desc"] = "BASIC: ##$basic##\nYour doctor bags now have ##2## charges.\n\nACE: ##$pro##\nYou receive ##+25%## healing from all sources.\n\nYour Doctor Bags now grant the user the ability to resist one instance of ##lethal damage##.\n\n##The container's label has very visible quotation marks.##",
			
			["menu_inspire_beta_desc"] = "BASIC: ##$basic##\nYou revive crew members ##100%## faster. Shouting at your teammates will increase both their movement and reload speed by ##30%## and enable them to resist suppression for ##10## seconds. \n\nACE: ##$pro##\nThere is a ##100%## chance that you can revive crew members at a distance of up to ##9## meters by shouting at them. This cannot occur more than once every ##30## seconds.",
			
			["menu_martial_arts_beta"] = "Martial Master",			
			["menu_martial_arts_beta_desc"] = "BASIC:##$basic##\nYou take ##50%## less damage from all melee attacks.\n\nACE: ##$pro##\nYou are ##100%## more likely to knock down enemies with a melee strike.",
			
			["menu_carbon_blade_beta_desc"] = "BASIC: ##$basic##\nYour saws no longer wear down on damage to enemies. Your saws deal ##100%## more damage.\n\n##Don't forget, huh, I mean for real, my saws all rule, with the world, with appeal!## \n\nACE: ##$pro##\nYou can now saw through shields with your OVE9000 portable saw. When killing an enemy with the saw, you have a ##50%## chance to cause nearby enemies in a ##10m## radius to panic. Panic will make enemies go into short bursts of uncontrollable fear.",
			
			["menu_single_shot_ammo_return_beta"] = "Strange Bandolier",
			["menu_single_shot_ammo_return_beta_desc"] = "BASIC: ##$basic##\nGetting a headshot will refund ##1## bullet to your used weapon.\n\nThis can only be triggered by Pistols, SMGs, Assault Rifles and Sniper Rifles.\n\nACE: ##$pro##\nGetting a headshot will increase your firerate by ##20%## for ##5## seconds.\n\nThis can only be activated by Pistols, SMGs, Assault Rifles and Sniper Rifles.\n\n##The internal mechanisms of your weapons appear to have been re-shapen into mobius strips...##",
			
			["menu_sniper_graze_damage"] = "Fine Red Mist",
			["menu_sniper_graze_damage_desc"] = "BASIC: ##$basic##\nSuccessfully killing an enemy with a headshot will cause a ##massive blood explosion## that ##staggers## enemies and deals ##300## damage within a ##2m## radius of the victim.\n\nThis can only be activated by weapons fired in their ##single-fire## mode.\n\nACE: ##$pro##\nFine Red Mist's blood explosion range is increased to ##4 meters##.\n\n##Thanks for standing still, wanker!##",
			
			["menu_shotgun_cqb_beta"] = "High Quality Grease",
			["menu_shotgun_cqb_beta_desc"] = "BASIC: ##$basic##\nYour weapon swap speed is increased by ##+50%## while you are ##sprinting##.\n\nACE: ##$pro##\nYou reload shotguns ##+20%## faster while sprinting and ##+40%## faster when you're not.\n\n##You don't want to know what it actually is, but there's no arguing with the results.##",
			
			["menu_shotgun_impact_beta"] = "Shotgun Shoulders",
			["menu_shotgun_impact_beta_desc"] = "BASIC: ##$basic##\nYour shotguns gain ##+12## stability.\n\nACE: ##$pro##\nYour shotguns deal ##+25%## damage to ##healthy enemies##.\n\n##FLASHYN!##",
			
			["menu_close_by_beta"] = "Cool Hunting",
			["menu_close_by_beta_desc"] = "BASIC: ##$basic##\nYour shotguns gain ##+25%## increased magazine capacity.\n\nIn addition, your shotguns with magazines have their magazine size increased by ##+8##.\n\nACE: ##$pro##\nYour shotguns gain a ##+0.5%## increase to firerate when you kill an enemy.\n\nThe buff lasts ##2## seconds, and can be stacked ##infinitely##, with each activation ##refreshing it's duration##.\n\n##Problem solved!##",
			
			["menu_iron_man_beta_desc"] = "BASIC: ##$basic##\nIncreases the armor recovery rate for you and your crew by ##25%##.\n\nACE: ##$pro##\nYour Melee Weapons can now ##stagger shields##.",
			
			["menu_juggernaut_beta"] = "Big Guy",
			["menu_juggernaut_beta_desc"] = "BASIC: ##$basic##\nUnlocks the ability to wear the ##Improved Combined Tactical Vest##.\n\nACE: ##$pro##\nYou gain ##115## extra health.\n\nNOTE: ##Big Guy Aced## is applied after multipliers.\n\n##For you.##",
			
			["bm_menu_skill_locked_level_7"] = "Requires the Big Guy skill",
			
			["menu_bandoliers_beta"] = "Destructive Criticism",
			["menu_bandoliers_beta_desc"] = "BASIC: ##$basic##\nYour total ammo capacity is increased by ##25%## and the ammo pickup of your weapons is increased by ##100%##.\n\nACE: ##$pro##\nKilling enemies speeds up the cooldowns on your grenades by ##2%## of their cooldown.\n\nIn addition, the chance of regaining non-grenade Throwables from ammo boxes is increased by ##100%##.\n\nNOTE: Does not stack with the ##Walk-in Closet## ammo pickup bonus gained from perk decks.\n\n##Sticks and stones may break their bones, but YOU are going to VAPORIZE them.##",
			
			["menu_nine_lives_beta"] = "Necromantic Aspect",
			["menu_nine_lives_beta_desc"] = "BASIC: ##$basic##\nAfter being revived, you knock down all cops within ##4 meters##.\n\nACE: ##$pro##\nYou are now protected from ##lethal damage## for ##1.5## seconds after being revived.\n\n##I live...again.##",
			
			["menu_feign_death"] = "Dark Metamorphosis",
			["menu_feign_death_desc"] = "BASIC: ##$basic##\nUpon killing an enemy, regenerate ##2.5## Health.\n\nACE: ##$pro##\nThe regeneration is increased to ##5## Health.\n\n##...But enough talk! Have at you!##",
			
			["menu_pistol_beta_messiah"] = "Resurrection",
			["menu_pistol_beta_messiah_desc"] = "BASIC: ##$basic##\nWhile in bleedout, you can revive yourself if you kill an enemy.  This can only happen every ##240## seconds.\n\nACE: ##$pro##\nYou gain the ability to get downed ##1## more time before going into custody.\n\n##The mark of my divinity shall scar thy DNA.##",
			
			["menu_heavy_impact_beta"] = "Short Holster",
			["menu_heavy_impact_beta_desc"] = "BASIC: ##$basic##\nYou swap weapons ##50%## faster.\n\nACE: ##$pro##\nYour weapons' recoil is reduced by ##20%##.\n\nNOTE: This applies separately from the Stability weapon stat.\n\n##Comfy and easy to wear.##",
			
			["menu_fast_fire_beta"] = "Lead Demiurge",
			["menu_fast_fire_beta_desc"] = "BASIC: ##$basic##\nYour SMGs, LMGs and Assault Rifles gain ##+50%## increased magazine size.\n\nACE: ##$pro##\nHolding down your fire button with any weapon set to automatic fire will slowly increase your firerate by ##25%## over the course of ##3## seconds.\n\n##no popo##",
			
			["menu_body_expertise_beta"] = "Livid Lead",
			["menu_body_expertise_beta_desc"] = "BASIC: ##$basic##\nKilling an enemy with a weapon set to automatic fire will ##automatically## reload ##10%## of your magazine ##from your reserve ammo##.\n\nACE: ##$pro##\n##Livid Lead## reloads ##one extra bullet## on activation and can now also be activated by ##killing an enemy with a Melee Weapon##.\n\n##No better way to take your anger out on people.##",
			
			["menu_gun_fighter_beta_desc"] = "BASIC: ##$basic##\nPistols gain ##5## more damage points. \n\nACE: ##$pro##\nPistols gain an additional ##5## damage points.",
		
			["menu_dance_instructor_desc"] = "BASIC: ##$basic##\nYour pistol magazine sizes are increased by ##5## bullets. \n\nACE: ##$pro##\nYou gain a ##25%## increased rate of fire with pistols.",
			
			["menu_expert_handling_desc"] = "BASIC: ##$basic##\nEach successful pistol hit gives you a ##10%## increased accuracy bonus for ##10## seconds and can stack ##4## times.\n\nACE: ##$pro##\nYou reload all pistols ##25%## faster.",
			
			["menu_sprinter_beta"] = "High Vigour",
			["menu_sprinter_beta_desc"] = "BASIC: ##$basic##\nYour stamina regenerates ##25%## faster.\n\nACE: ##$pro##\nYou gain ##+10## ##Dodge##. ##Dodge## gives you a random chance to ##completely negate damage##.\n\nUpon successfully ##dodging## an attack, regain ##5## stamina.",
			
			["menu_insulation_beta"] = "The Rubber",
			["menu_insulation_beta_desc"] = "BASIC: ##$basic##\nYou ##no longer uncontrollably fire your weapons## while being electrocuted. Your camera shake while being electrocuted is reduced by ##50%##.\n\nACE: ##$pro##\nYou can now move while being electrocuted at ##20%## of your normal movement speed. Your weapon's Accuracy and Stability ##are no longer affected by electrocution##.\n\n##Never engage without protection.##",
			
			--BASIC: When tased, you can now withstand being ##shocked## ##2## more times before you explode with electricity.
			--ACED: When tased, ##you can now free yourself from the Taser## by completing a ##Quick Time Event##.\n\nPressing the Interact key just as a Taser ##shocks## you three times in a row will free you.\n\nFailing to press the Interact key or pressing it at the wrong time cancels the skill.
			
			["menu_jail_diet_beta"] = "Sneakier Bastard",
			["menu_jail_diet_beta_desc"] = "BASIC: ##$basic##\nYou gain a ##1+## ##Dodge## for every ##1## point of detection risk under ##35## up to ##10%##.\n\nACE: ##$pro##\nUpon ##failing to dodge## an attack, re-roll for the same chance as your current ##Dodge## chance to reduce taken damage from the attack by ##25%##.",
			
			["menu_backstab_beta"] = "Lower Blow",
			["menu_backstab_beta_desc"] = "BASIC: ##$basic##\nYou gain ##3%## chance to deal ##Critical Hits## for every ##1## point of concealment under ##35## up to ##30%##.\n\n##Critical Hits## deal ##1.5x## the damage of normal hits.\n\nACE: ##$pro##\nYour ##Critical Hits## now deal ##3x## the damage of normal hits.",
			
			["menu_unseen_strike_beta_desc"] = "BASIC: ##$basic##\nIf you do not lose any armor or health for ##4## seconds, you gain a ##35%## chance to deal ##Critical Hits## for ##6## seconds.\n\nACE: ##$pro##\nThe duration of the ##Critical Hits## buff is increased by ##12## seconds.\n\nTaking damage at any point while the effect is active will cancel the effect.",
			
			["menu_oppressor_beta_desc"] = "BASIC: ##$basic##\nThe duration of the visual effect caused by flashbangs is reduced by ##25%##.\n\nACE: ##$pro##\nYour armor recovery rate is increased by ##15%##.",
			
			["menu_prison_wife_beta"] = "Jackpot",
			["menu_prison_wife_beta_desc"] = "BASIC: ##$basic##\nYou regenerate ##5## armor for each successful headshot. This effect cannot occur more than once every ##10## seconds.\n\nACE: ##$pro##\nUpon killing an enemy with a headshot, you gain the ability to resist one instance of ##lethal damage##. This does not apply multiple times, and can only be activated every ##10## seconds.\n\n##Let's rock, baby!##",
			
			["menu_show_of_force_beta"] = "Cool Headed",
			["menu_show_of_force_beta_desc"] = "BASIC: ##$basic##\nYou gain ##+50%## resistance to suppression while interacting with objects.\n\nACE: ##$pro##\nYou gain ##+50%## resistance to damage while performing interactions.\n\n##Phew, good thing I'm indestructible.##",
			
			["menu_awareness_beta"] = "Wave Dash",
			["menu_awareness_beta_desc"] = "BASIC: ##$basic##\nAt the first ##0.3## seconds of a regular sprint, you gain ##25%## faster movement speed.\n\nYou gain ##+5## ##Dodge## while this effect is active.\n\nACE: ##$pro##\nThe stamina cost of starting a sprint and jumping while sprinting is reduced by ##50%##.\n\nThe stamina requirement to activate sprint-related effects and bonuses is reduced by ##50%##.\n\n##Mission Complete!##",
			
			["menu_trigger_happy_beta"] = "Two Tap",
			["menu_trigger_happy_beta_desc"] = "BASIC: ##$basic##\nAfter ##hitting an enemy## with a Pistol or Akimbo Pistols, gain a ##+40%## damage boost that lasts for ##1.25## seconds.\n\nACE: ##$pro##\nThe duration of the damage boost is increased to ##2## seconds.\n\n##Stay friends, problem that you can't defend!##",	

			["menu_bloodthirst"] = "The Instinct",
			["menu_bloodthirst_desc"] = "BASIC: ##$basic##\nAfter every ##2## non-melee kills, gain ##100%## increased Melee damage and an inactive ##5%## reload speed bonus for your next reload.\n\nThis can be stacked for up to ##600%## extra melee damage and ##30%## extra reload speed.\n\nKilling an enemy with a Melee Weapon will ##activate## the reload speed bonus and ##reset## the melee damage bonus.\n\nACE: ##$pro##\nYour Melee Weapons gain ##100%## extra damage when fully charged and you charge your melee weapons ##50%## faster.\n\n##Fight on.##",
			
			["menu_steroids_beta"] = "Swing Rhythm",
			["menu_steroids_beta_desc"] = "BASIC: ##$basic##\nYour melee attacks deal ##100%## more damage and you swing your melee weapons ##100%## faster.\n\nACE: ##$pro##\nYou cannot be staggered by enemies while ##charging your melee or swinging it.##\n\n##Groovy.##",
			
			["menu_wolverine_beta"] = "Unstoppable",
			["menu_wolverine_beta_desc"] = "BASIC: ##$basic##\nThe less health you have, the more power you gain.\n\nWhen under ##100%## Health, deal up to ##500%## more melee and saw damage.\n\nWhen under ##50%## Health, you reload all weapons ##50%## faster.\n\nACE: ##$pro##\nWhen at ##50%## Health or below, you gain ##+50%## resistance to suppression and your interaction speed with Medic Bags and First Aid Kits is increased by ##75%##.",
			
			["menu_frenzy"] = "Something To Prove",
			["menu_frenzy_desc"] = "BASIC: ##$basic##\nYou start with ##50%## of your Maximum Health and cannot heal above that.\n\n##ALL DAMAGE DEALT## is increased by ##25%##.\n\nACE: ##$pro##\n##You lose 1 down.##\n\nYour movement speed is increased by ##25%##.\n\n##ALL DAMAGE DEALT## is further increased by ##25%##.\n\n##Kill all sons of bitches, right?##",
			
			["bm_grenade_copr_ability_desc"] = "Activating the Leech ability requires you to break a small opaque glass ampule under your nose and take a deep breath. You're not quite sure what's in it, but it makes the world come into focus, and causes your adrenaline to spike.\n\nOne thing is certain; it sure as shit isn't smelling salts, if the faint wriggling shadow inside it doesn't spell it out.",
			
			["hud_stats_pagers_used"] = "남은 스트라이크",
			
			--mutual perks
			["menu_deckall_2"] = "그것에 익숙해지다",
			["menu_deckall_2_desc"] = "제압 저항을 ##+50%##만큼 얻습니다.",
			
			["menu_deckall_6_desc"] = "##방탄복 가방## 장비를 잠금 해제합니다.\n\n##방탄복 가방##은 습격 중에 방탄복을 교체하는 데 사용할 수 있습니다.",
			
			-- weapon stuff below
			["bm_GEN_speed_strap"] = "곤잘레스 탄창",
			["bm_GEN_decorative_strap"] = "스타일을 위해 무기에 쓸모없는 장식용 씽타이마지그를 추가합니다! 재장전 속도가 더 빨라진 것처럼 느껴질겁니다!",--bye bye power creep
			["bm_GEN_fmg9_speed_strap"] = "연예인 X9 매거진",
			["bm_GEN_fmg9_speed_strap_desc"] = "유명한 래퍼 X9이 체포되기 전 무대 공연에서 사용한 것으로, 재장전 속도가 빨라지는 느낌을 줍니다!",
			
			["bm_wp_g3_b_short"] = "짧은 총열",
			["bm_wp_g3_b_sniper"] = "긴 총열",
			
			["bm_wp_upg_a_piercing_desc"] = "적의 방탄복을 관통합니다.",
			["bm_wp_upg_a_custom_desc"] = "산탄총탄에 멋진 야광 효과를 제공합니다! 순수하게 에스테틱하군요!",
			
			["bm_w_p90"] = "Kobus 90 관통용 기관단총",
			["bm_w_p90_desc"] = "벽, 적, 방패, 방탄복을 관통하는 관통탄을 사용합니다!",
			["bm_w_asval"] = "Valkyria 관통용 소총",
			["bm_w_asval_desc"] = "벽, 적, 방패, 방탄복을 관통하는 관통탄을 사용합니다!",
			["des_shak12"] = "적과 방탄복을 관통하는 중탄을 사용합니다!",
			["bm_w_shak12_desc"] = "적과 방탄복을 관통하는 중탄을 사용합니다!",
			["des_ching"] = "적, 방패, 방탄복을 관통하는 대구경 탄환을 사용합니다!",
			["bm_w_ching_desc"] = "적, 방패, 방탄복을 관통하는 대구경 탄환을 사용합니다",
			["des_akm"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["bm_w_akm_desc"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["des_scar"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["bm_w_scar_desc"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["des_akm_gold"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["bm_w_akm_gold_desc"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["des_flint"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["bm_w_flint_desc"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["des_ak12"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["bm_w_ak12_desc"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["des_fal"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["bm_w_fal_desc"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["des_m16"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			["bm_w_m16_desc"] = "방탄복을 관통하는 철갑탄을 사용합니다!",
			
			["des_GEN_shotgun_push"] = "이 무기에는 샷건 푸시 기능이 있습니다.",

			
			--DMR KITS
			["bm_GEN_light_DMR_desc"] = "이 무기에 적과 방탄복을 관통하는 중탄을 부여합니다! 그 대신 발사 속도가 감소합니다!",
			["bm_GEN_heavy_DMR_desc"] = "이 무기에 적, 방패 및 방탄복을 관통하는 대구경 탄을 부여합니다! 그 대신 발사 속도가 크게 감소합니다!",
			["bm_GEN_sniper_kit"] = "강력 개조 키트",
			["bm_GEN_sniperkit_desc"] = "이 무기에 벽, 적, 방패 및 방탄복을 관통하는 관통탄을 부여합니다! 그 대신 발사 속도가 대폭 감소합니다!",
			
			["bm_menu_damage_falloff_lol_1"] = "A LOT",
			["bm_menu_damage_falloff_lol_2"] = "PLENTY",
			["bm_menu_damage_falloff_lol_3"] = "YES",
			["bm_menu_damage_falloff_lol_4"] = "ALL",
			["bm_menu_damage_falloff_lol_5"] = "MANY",
			["bm_menu_damage_falloff_lol_6"] = "LOTS",
			["bm_menu_damage_falloff_lol_7"] = "LONG",
			["bm_menu_damage_falloff_lol_8"] = "MUCH",
			["bm_menu_damage_falloff_lol_9"] = "145M+",
			["bm_menu_damage_falloff_lol_10"] = "HYPER",
			["bm_menu_damage_falloff_lol_11"] = "OVK",
			["bm_menu_damage_falloff_lol_12"] = "LOADS",
			["bm_menu_damage_falloff_lol_13"] = "HUGE",
			["bm_menu_damage_falloff_lol_14"] = "HATE",
			["bm_menu_damage_falloff_lol_15"] = "LARGE",
			["bm_menu_damage_falloff_lol_15"] = "NYOOM",
			["bm_menu_damage_falloff_lol_16"] = "SWOLE",
			["bm_menu_damage_falloff_lol_17"] = "LOVE",
			["bm_menu_damage_falloff_lol_18"] = "SEVEN",
			["bm_menu_damage_falloff_lol_19"] = "SPACE",
			["bm_menu_damage_falloff_lol_20"] = "TURBO",
			["bm_menu_damage_falloff_lol_21"] = "TACO",
			["bm_menu_damage_falloff_lol_22"] = "CANDY",
			["bm_menu_damage_falloff_lol_23"] = "NITRO",
			["bm_menu_damage_falloff_lol_24"] = "YEAH!",
			["bm_menu_damage_falloff_lol_24"] = "VERY",
			["bm_menu_damage_falloff_lol_25"] = "+++++",
			["bm_menu_damage_falloff_lol_26"] = "WOW",
			["bm_menu_damage_falloff_lol_27"] = "SIGHT",
			["bm_menu_damage_falloff_lol_28"] = "OH MY",
			["bm_menu_damage_falloff_lol_29"] = "FUN",
			["bm_menu_damage_falloff_lol_30"] = "NICE",
			["bm_menu_damage_falloff_lol_31"] = "RUDE",
			["bm_menu_damage_falloff_lol_32"] = "HAPPY",
			["bm_menu_damage_falloff_lol_33"] = "UWU",
			["bm_menu_damage_falloff_lol_34"] = "JEEZ",
			["bm_menu_damage_falloff_lol_35"] = "WOAH",
			["bm_menu_damage_falloff_lol_36"] = "DANG",
			["bm_menu_damage_falloff_lol_37"] = "YOWZA",
			["bm_menu_damage_falloff_lol_38"] = "CASH",
			["bm_menu_damage_falloff_lol_39"] = "CONGA",
			["bm_menu_damage_falloff_lol_40"] = "UNGA",
			["bm_menu_damage_falloff_lol_41"] = "BUNGA",
			["bm_menu_damage_falloff_lol_42"] = "OWO",
		})
	end
	
end)
