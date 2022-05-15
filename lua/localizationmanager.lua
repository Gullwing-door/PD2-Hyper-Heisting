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
		["hud_assault_FG_cover109"] = "DARE TO BELIEVE YOU CAN SURVIVE",
		["hud_assault_FG_cover110"] = "STYLE ON THEM",
		["hud_assault_FG_cover111"] = "ACTION IS COMING",
		["hud_assault_FG_cover112"] = "KEEP IT MOVIN'",
		["hud_assault_FG_cover113"] = "LET'S DO THIS",
		["hud_assault_FG_cover114"] = "I HAVE THE POWER",
		["hud_assault_FG_cover115"] = "IT'S HEISTING TIME",
		["hud_assault_FG_cover116"] = "ROBBERS WITH ATTITUDE",
		["hud_assault_FG_cover117"] = "양아치 같은 놈아, APHEX ACID를 마셔보자고",
		["hud_assault_FG_cover118"] = "ERROR: hud_assault_F- 뻥이다 이 놈아",
		["hud_assault_FG_cover119"] = "IT'S NOT A BIG DEAL",
		["hud_assault_FG_cover120"] = "WHY OH YOU ARE LOVE",
		["hud_assault_FG_cover121"] = "ROB BEARS WITH ATTITUDE",
		["hud_assault_FG_cover122"] = "ROB BEERS WITH ATTITUDE",
		["hud_assault_FG_cover123"] = "BRING IT ON YOU BASTARDS",
		["hud_assault_FG_cover124"] = "THROW ALL YOUR GRENADES",
		["hud_assault_FG_cover125"] = "WASH AWAY THE ANGER",
		["hud_assault_FG_cover126"] = "FEATURING KURGAN FROM RAID: WORLD WAR 2",
		["hud_assault_FG_cover127"] = "I'M HARDLY DRESSED FOR A PARTY",
		["hud_assault_FG_cover128"] = "LAW AHEAD THEREFORE TRY COVER",
		["hud_assault_FG_cover129"] = "GUARD YOUR VALOR",
		["hud_assault_FG_cover130"] = "BY SIGMAR, THEY COME IN NUMBER",
		["hud_assault_FG_cover131"] = "현상 수배: 죽이거나 살리거나",
		["hud_assault_faction_nightmare"] = "VS. ???",
		["hud_assault_faction_sbz"] = "VS. SBZ OPERATORS",
		["hud_assault_faction_ovk"] = "VS. OVERKILL MODERATORS",
		["hud_assault_faction_bofadeez"] = "VS. BOVERKILL TAG TEAM",
		["hud_assault_faction_bofa"] = "VS. BO FORCE ALPHA ADMINISTRATORS",
		["hud_assault_faction_federales"] = "VS. LOS FEDERALES",
		["hud_assault_faction_swat"] = "VS. SWAT TEAM",
		["hud_assault_faction_sharedswat"] = "VS. SWAT TEAM & MURKYWATER BATTALION",		
		["hud_assault_faction_sharedfbi"] = "VS. FBI SQUADRON & MURKYWATER BATTALION",
		["hud_assault_faction_sharedgensec"] = "VS. GENSEC TASKFORCE & MURKYWATER BATTALION",		
		["hud_assault_faction_sharedzeal"] = "VS. ZEAL LEGION",				
		["hud_assault_faction_fbi"] = "VS. FBI SQUADRON",
		["hud_assault_faction_fbitsu"] = "VS. FBI & GENSEC",
		["hud_assault_faction_ftsu"] = "VS. GENSEC TASKFORCE",
		["hud_assault_faction_zeal"] = "VS. ZEAL LEGION",
		["hud_assault_faction_psc"] = "VS. MURKYWATER BATTALION",
		["hud_assault_faction_mad"] = "VS. TRIANGLE TROOPS",
		["hud_assault_faction_hvh"] = "YOU HAVE STARTLED THE HORDE",
		["hud_assault_faction_generic"] = "VS. EVERYONE",
		["hud_assault_faction_mexcross"] = "VS. BATALLÓN MURKYWATER",
		["hud_assault_danger"] = "!!! DANGER !!!",
		["hud_assault_dangermex"] = "!!! PERIGO !!!",
		["hud_assault_FG_danger1"] = "!!! HANG IN THERE !!!",
		["hud_assault_FG_danger2"] = "!!! IT'S NOT OVER YET !!!",
		["hud_assault_FG_danger3"] = "!!! TIME FOR A COMEBACK !!!",
		["hud_assault_FG_danger4"] = "!!! DON'T GIVE UP !!!",
		["hud_assault_FG_danger5"] = "!!! GO OUT WITH A BANG !!!",
		["hud_assault_FG_danger6"] = "!!! GET IT TOGETHER !!!",
		["hud_assault_FG_danger7"] = "!!! CAN'T FALL APART NOW !!!",
		["hud_assault_FG_danger8"] = "!!! IF THEY TRY TO KILL YOU, KILL THEM HARDER !!!",
		["hud_assault_FG_danger9"] = "!!! FAILURE IS IN THE MIND !!!",
		["hud_assault_FG_danger10"] = "!!! HOW QUICKLY THE TIDE TURNS !!!",
		["hud_assault_FG_danger11"] = "!!! MY SNAILS LOVE TO FUCK !!!",
		["hud_assault_FG_danger12"] = "!!! STAY DEFIANT !!!",
		["hud_assault_FG_danger13"] = "!!! THIS IS DEFINITELY NOT YOUR FAULT !!!",
		["hud_assault_FG_danger14"] = "!!! THIS IS TOTALLY YOUR FAULT !!!",
		["hud_assault_FG_danger15"] = "!!! DON'T GO DRIFTING !!!",
		["hud_assault_FG_danger16"] = "!!! WELCOME TO HYPER HEISTING, NERD !!!",
		["hud_assault_FG_danger17"] = "!!! IS THIS YOUR FIRST TIME PLAYING? !!!",
		["hud_assault_FG_danger18"] = "!!! OH SHIT OH SHIT OH SHIT !!!",
		["hud_assault_FG_danger19"] = "!!! BETTER WATCH OUT !!!",
		["hud_assault_FG_danger20"] = "!!! UH OH !!!",
		["hud_assault_FG_danger21"] = "!!! GUESS YOU'LL DIE !!!",
		["hud_assault_FG_danger22"] = "!!! RARE FOOTAGE OF DRAGAN ACTUALLY ANGRY !!!",
		["hud_assault_FG_danger23"] = "!!! ME SAY ALONE BANK, ME SAY ALONE BANK !!!",
		["hud_assault_FG_danger24"] = "!!! YOU WERE LISTENING THE STAY IN COVER PART, RIGHT? !!!",
		["hud_assault_FG_danger25"] = "!!! YOU TOTALLY DID NOT NEED HELP ANYWAY !!!",
		["hud_assault_FG_danger26"] = "!!! YOU HAVE BEEN SUCCESSFULLY DISTRACTED BY THE ASSAULT BANNER !!!",
		["hud_assault_FG_danger27"] = "!!! THIS IS ALL GOING TO HELL !!!",
		["hud_assault_FG_danger28"] = "!!! SCREW THIS !!!",
		["hud_assault_FG_danger29"] = "!!! THERE IS NO ESCAPE !!!",
		["hud_assault_FG_danger30"] = "!!! NOBODY IS AROUND TO HELP !!!",
		["hud_assault_FG_danger31"] = "!!! YOU WILL BE PROSECUTED TO THE FULL EXTENT OF THE JAM !!!",
		["hud_assault_FG_danger32"] = "!!! HEY SHITASS, WANNA WATCH ME FIGHT OFF THIS ASSAULT WAVE? !!!",
		["hud_assault_FG_danger33"] = "!!! GOSH FLIPPIN DANG IT !!!",
		["hud_assault_FG_danger34"] = "!!! AW COME ON !!!",
		["hud_assault_FG_danger35"] = "!!! REPORTED FOR THROWING !!!",
		["hud_assault_FG_danger36"] = "!!! YOU CAN GO AHEAD AND RESTART NOW !!!",
		["hud_assault_FG_danger37"] = "!!! EVERYTHING IS OK, YOU GOT THIS !!!",
		["hud_assault_FG_danger38"] = "!!! YOU'LL MAKE IT !!!",
		["hud_assault_FG_danger39"] = "!!! THE WITCH HUNTS ARE OVER !!!",
		["hud_assault_FG_danger40"] = "!!! I LEAVE FOR ONE MINUTE AND THIS SHIT HAPPENS !!!",
		["hud_assault_FG_danger41"] = "!!! RUN FOR YOUR FUCKING LIFE !!!",
		["hud_assault_FG_danger42"] = "!!! WE'RE SCREWED, LEG IT !!!",
		["hud_assault_FG_danger43"] = "!!! YOUR LIGHT FADES AWAY !!!",
		["hud_assault_FG_danger44"] = "!!! EMBRACE THE DARKNESS !!!",
		["hud_assault_FG_danger45"] = "!!! UNFORTUNATE BALLSACK !!!",
		["hud_assault_FG_danger46"] = "!!! LAW PREVAILS !!!",
		["hud_assault_FG_danger47"] = "!!! HONESTLY IT'S NOT AS BAD AS IT LOOKS !!!",
		["hud_assault_FG_danger48"] = "!!! STOP BEATING AROUND THE BUSH !!!",
		["hud_assault_FG_danger49"] = "!!! NOW IS THE TIME FOR FEAR !!!",
		["hud_assault_FG_danger50"] = "!!! YOUR BODY WILL SHATTER !!!",
		["hud_assault_FG_danger51"] = "!!! YOU'RE FINISHED !!!",
		["hud_assault_FG_danger52"] = "!!! YOUR SHIT AINT TIGHT !!!",
		["hud_assault_FG_danger53"] = "!!! JUDGEMENT !!!",
		["hud_assault_FG_danger54"] = "!!! IT ENDETH NOW !!!",
		["hud_assault_FG_danger55"] = "!!! THY GORE SHALL GLISTEN !!!",
		["hud_assault_FG_danger56"] = "!!! DIE !!!",
		["hud_assault_FG_danger57"] = "!!! YOU MAKE EVEN THE DEVIL CRY !!!",
		["hud_assault_FG_danger58"] = "!!! FOOLISHNESS, HEISTER, FOOLISHNESS !!!",
		["hud_assault_FG_danger59"] = "!!! SAY PAL, YOU DON'T LOOK SO GOOD !!!",
		["hud_assault_FG_danger60"] = "!!! IT IS INEVITABLE !!!",
		["hud_assault_FG_danger61"] = "!!! WE'RE GOING HOME ALIVE, LIAR, LIAR !!!",
		["hud_assault_FG_danger62"] = "!!! TRY THROWING MORE GRENADES !!!",
		["hud_assault_FG_danger63"] = "!!! YOUR MEMES END HERE !!!",
		["hud_assault_heat"] = "HEAT BONUS",
		["hud_heat_common"] = "BREAK TIME!",
		["hud_heat_1"] = "ANARCHY REIGNS!",
		["hud_heat_2"] = "DON'T GET COCKY!",
		["hud_heat_3"] = "ROCK ON!",
		["hud_heat_4"] = "STRIIIIIKE!",
		["hud_heat_5"] = "A TOTAL KNOCKOUT!",
		["hud_heat_6"] = "COMPLETE FUCKING OVERKILL!",
		["hud_heat_7"] = "WRECKED!",
		["hud_heat_8"] = "ULTRAAAAAAAA!!!",
		["hud_heat_9"] = "BANISHED!",
		["hud_heat_10"] = "DOMINATING!",
		["hud_heat_11"] = "HOLY SHIT!",
		["hud_heat_12"] = "WOMBO COMBO!",
		["hud_heat_13"] = "YOU'RE A WILD ONE!",
		["hud_heat_14"] = "THIS IS YOUR TIME!",
		["hud_heat_15"] = "GIVE IT YOUR ALL!",
		["hud_heat_16"] = "SMOKIN' SEXY STYLE!",
		["hud_heat_17"] = "DESTRUCTIVE FINISH!",
		["hud_heat_18"] = "DEAD ON!",
		["hud_heat_19"] = "BULLSEYE!",
		["hud_heat_20"] = "BADASS!",
		["hud_heat_21"] = "THAT'S RAD!",
		["hud_heat_22"] = "ACES!",
		["hud_heat_23"] = "ASSAULT VANQUISHED!",
		["hud_heat_24"] = "PEACE AND TRANQUILITY ACHIEVED!",
		["hud_heat_25"] = "REMINDER: OVERCONFIDENCE IS A SLOW AND INSIDIOUS KILLER!",
		["hud_heat_26"] = "THE SHADOW REMAINS CAST!",
		["hud_heat_27"] = "YOU'RE ALL FURCOAT AND NO KNICKERS, BITCHES!",
		["hud_heat_28"] = "ULTRAKILL!",
		["hud_heat_29"] = "KEEP IT REAL!",
		["hud_heat_30"] = "WELCOME TO HYPER HEISTING!",
		["hud_heat_31"] = "PERFECT!",
		["hud_heat_32"] = "SUPREME VICTORY!",
		["hud_heat_33"] = "KILLER!",
		["hud_heat_34"] = "MASSACRE!",
		["hud_heat_35"] = "THIS IS FUCKIN' WAR, BABY!",
		["hud_heat_36"] = "JACKPOT!",
		["hud_heat_37"] = "TOASTY!",
		["hud_heat_38"] = "VANISH INTO DARK!",
		["hud_heat_39"] = "SAYONARA!",
		["hud_heat_40"] = "TAKE CONTROL, BRAIN POWER!",
		["hud_heat_41"] = "ULTRA-VIOLENCE!",
		["hud_heat_42"] = "HELLFIRE, HELLFIRE!",
		["hud_heat_43"] = "DON'T TELL THE VANGUARD!",
		["hud_heat_44"] = "GUARDIANS MAKE THEIR OWN FATE!",
		["hud_heat_45"] = "SPINE TINGLING!",
		["hud_heat_46"] = "BONE CHILLING!",
		["hud_heat_47"] = "HORROR SHOW!",
		["hud_heat_48"] = "SHRIEKIFIED!",
		["hud_heat_49"] = "RULES OF NATURE!",
		["hud_heat_50"] = "BLAMMO!",
		["hud_heat_51"] = "A VICTORY, YES, BUT THERE IS ALWAYS ANOTHER BATTLE!",
		["hud_heat_52"] = "HOORAY FOR VIOLENCE!",
		["hud_heat_53"] = "BLOOD, SO MUCH BLOOD!",
		["hud_heat_54"] = "YOU HAVE BEEN SUCCESSFULLY CELEBRATED BY THE ASSAULT BANNER!",
		["hud_heat_55"] = "YAY!",
		["hud_heat_56"] = "SMASHING!",
		["hud_heat_57"] = "EXCLAMATION MARK!",
		["hud_heat_58"] = "MEAT BONUS!",
		["hud_heat_gameplay"] = "YOU HAVE PUSHED BACK THE HORDE MOMENTARILY",
		["hud_assault_cover"] = "STAY IN COVER",
		["hud_assault_cover_blma"] = "stya cover she set u up godamn bitch",		
		["hud_assault_coverhvh"] = "DON'T STOP MOVING",
		["hud_assault_cover_mexcross"] = "MANTENTE A CUBIERTO",
		["hud_assault_cover_repers"] = "ОСТАВАЙТЕСЬ В УКРЫТИИ",
		["hud_assault_cover_nightmare"] = "REMAIN HIDDEN",
		["hud_assault_assault"] = "ASSAULT IN PROGRESS",
		["hud_assault_assault_blma"] = "asal,t: blackmailer",		
		["hud_assault_assaultrepers"] = "ИДЁТ ШТУРМ НАЁМНИКОВ",		
		["hud_assault_assaulthvh"] = "NECROCIDE IN PROGRESS",
		["hud_assault_assault_mexcross"] = "ASALTO EN MARCHA",
		["hud_assault_assault_nightmare"] = "SOMETHING IS WRONG",
		["hud_assault_assault_ghosts"] = "MANIFESTATION IN PROGRESS",
		["menu_toggle_one_down"] = "SHIN SHOOTOUT",
		["menu_one_down"] = "SHIN SHOOTOUT",
		["menu_cs_modifier_heavies"] = "All special enemies except Bulldozers now have body armor, adds a chance for an armored SMG heavy to spawn.",
		["menu_cs_modifier_magnetstorm"] = "When enemies reload, they emit an electric burst after a short moment that tases players.",
		["menu_cs_modifier_heavy_sniper"] = "Adds a chance for Sniperdozers to spawn.",
		["menu_cs_modifier_taser_overcharge"] = "Tasers now deal double the amount of shock damage while tasing you.",
		["menu_cs_modifier_dozer_lmg"] = "EVERYTHING IS HORRIBLE!!!",
		["menu_cs_modifier_unison"] = "WIP NEW MODIFIER, DOES NOTHING CURRENTLY",
		["menu_cs_modifier_dozer_rage"] = "Adds a chance for an armor piercing Deagle-toting Medic from another dimension to spawn.",
		["menu_cs_modifier_monsoon"] = "Enemies become 15% faster for every assault wave.",
		["menu_cs_modifier_dozer_minigun"] = "Adds a chance for Medicdozers and Minigun Dozers to spawn.",
		["menu_cs_modifier_shield_phalanx"] = "Shotgunners have a chance to be replaced by a Gensec Saiga SWAT.",
		["menu_cs_modifier_dozer_medic"] = "ERROR: menu_cs_modifier_suppressive_winters",
		["menu_cs_modifier_shin"] = "SHIN SHOOTOUT is now enabled.",
		["menu_cs_modifier_no_hurt"] = "Enemies are now more resistant to staggers.",
		["menu_cs_modifier_medic_adrenaline"] = "Adds a chance for a fully armored ZEAL Light to spawn, killable only by shots in the back of the head.",
		["menu_cs_modifier_megacloakers"] = "Cloakers now kick for 50% more damage, send you twice as far, and can jumpkick you from twice as far.",
		["menu_cs_modifier_voltergas"] = "Smoke Grenades are replaced by Tear Gas Smoke Grenades.",
		["menu_cs_modifier_bouncers"] = "Enemies have a chance drop a destructible explosive grenade with a beeping timer on death.",
		["menu_cs_modifier_cloaker_tear_gas"] = "Cloakers are now silent while charging and move 25% faster.",
		["menu_cs_modifier_enemy_health_damage"] = "Enemies deal an additional 10% more damage, have 5% more health, and detect you slightly faster in Stealth.",
		["loading_heister_13"] = "Go shoot a cop in real life RIGHT NOW!!! It'll end well! Trust me!",
		["loading_heister_21"] = "Suppression does NOT completely stop armor regeneration! When taking fire with your armor down, don't panic! Try to cut line of sight and be patient!",
		["loading_heister_44"] = "Mayhem, Death Wish and Death Sentence enemies are much better at dodging! Try to predict when they will execute them!",
		["loading_heister_45"] = "The ZEAL Legion only shows up on Death Sentence, a worthy challenge, maybe?",
		["loading_heister_46"] = "All Bulldozers have their own way of being dangerous, try to keep an eye out for their damage, suppression and range!",
		["loading_heister_49"] = "Try to pick your fights properly! Taking on a Minigun Dozer alone is not always gonna work out the way you want it to!",
		["loading_heister_51"] = "Having a generalist build that can do a lot of things is completely ok, assuming you have the raw skill to back it up!",
		["loading_heister_52"] = "The Steadiness stat of your selected armor tracks how hard your camera shakes when getting hit...but in Hyper Heisting, that stat is the same for all armors!",
		["loading_gameplay_15"] = "The ZEALs have extremely good fashion sense, look out for their colors in a crowd to tell what weapons they're using!",
		["loading_gameplay_37"] = "Higher damage rifles and shotguns can take out tougher enemies like Tasers and Bulldozers with less shots, but are weak at crowd control, try to make up for that with another weapon's capabilities!",
		["loading_gameplay_46"] = "Snipers get more accurate as you spend time in their line of fire, try to kill them before that happens!",
		["loading_gameplay_56"] = "During infinite assaults, players can still get out of custody by simply waiting!",
		["loading_gameplay_76"] = "To kill the bulldozer, shoot at it until it dies! It's faceplate, visor, or face in specific!",
		["loading_gameplay_92"] = "Snipers can very easily deplete your armor and health in seconds if ignored, deal with them quickly!",
		["loading_gameplay_13"] = "Know your enemy. The Medic wears a red outfit when wielding a shotgun and a blue outfit when wielding a rifle!",
		["loading_gameplay_73"] = "Running from the horde isn't a bad idea sometimes, but killing enemies is essential to ending an assault wave!",
		["loading_gameplay_96"] = "Captain Winters does not show up in Hyper Heisting! Well, he does! But not really! But kinda! Yeah!",
		["loading_gameplay_97"] = "If regular Captain Winters shows up in any way, for any reason, please post a comment on the MWS page! That's not supposed to happen!",
		["loading_gameplay_126"] = "If you can't tolerate the game without Captain Winters in it, you can always go back to vanilla! I won't judge!",
		["loading_trivia_59"] = "Winters is the coldest season of the year in polar and temperate zones, opposite to Summers. It occurs after Autumn and before Spring in each year.",
		["loading_trivia_60"] = "01110111 01101001 01101110 01110100 01100101 01110010 01110011",
		["loading_trivia_61"] = "THIS IS THEIR SEASON. YOU WILL NOT ESCAPE.",
		["loading_trivia_62"] = "Captain Winters is not ",
		["loading_trivia_93"] = "Dragan absolutely loathes Tasers! Try punching one in the face with your bare hands while playing as him! You won't regret it!",		
		["loading_hh_title"] = "Hyper Heisting tips",
		["loading_hh_1"] = "Enemies on Death Sentence tend to perform a lot of different tactics, try to identify which groups do which to get an advantage!",
		["loading_hh_2"] = "Ninja enemies deal more damage, and are way better at dodging than the regular assault force! Look out for less armored, more unique units during the assault!",
		["loading_hh_3"] = "Shin Shootout is a mode meant for only the smartest, fastest, toughest players! Enemies become much more aggressive when it's enabled!",
		["loading_hh_4"] = "If you're in a tough situation, don't give up! There's always a way out!",
		["loading_hh_5"] = "In Hyper Heisting, cloaker kicks can send you FLYING backwards and deal massive damage! Stay away from them!",
		["loading_hh_6"] = "In Hyper Heisting, special enemies get more dangerous as difficulties increase! Keep a close eye on them!",
		["loading_hh_7"] = "In Hyper Heisting, the cops are generally more intelligent, get faster, deal slightly more damage, and are more accurate every 2 difficulties, while their group tactics get better every difficulty!",
		["loading_hh_8"] = "Listen out for what the cops are saying from around the corner if you can, it'll help you predict what kind of tactics some of the groups might have! You can even hear them throw out smoke grenades and flashbangs!",
		["loading_hh_9"] = "In Hyper Heisting, shotgunners have massive smoke puffs that come out of their gun when they fire, these can help you locate them, and also help you figure out when they can fire again!",	
		["loading_hh_10"] = "If you see extra-bright powerful tracers that distort the area around them, that's probably coming from some important enemy! Like a Shotgunner, or a Bulldozer!",
		["loading_hh_11"] = "Join the Hyper Heisting Discord! You can find a link to it in the ModWorkshop page!",
		["loading_hh_12"] = "Ninja enemies are particularly hard to dominate, but are very strong when converted into Jokers!",
		["loading_hh_13"] = "In Hyper Heisting, Heavy SWATs, Maximum Force Responders, and ZEAL Heavy SWATs gain protection from bullet-based instant kills on all difficulties! But only from weapons and ammo types that can't shoot through shields!",
		["loading_hh_14"] = "You can get to the Hyper Heisting Options through Mod Options in the Options menu!",
		["loading_hh_15"] = "In Hyper Heisting, getting hit by an enemy melee attack will temporarily stagger you, and cause you to be unable to attack for a few moments!",
		["loading_hh_16"] = "Punks are overconfident fodder enemies wielding revolvers, double barreled shotguns, and submachine guns. They will not hurt you much if you do not let them!",
		["loading_hh_17"] = "In Hyper Heisting, Tasers tasing you into incapacitation and getting downed by Cloakers count as actual downs, which can send you into custody! Be careful around them!",
		["loading_hh_18"] = "In Hyper Heisting, certain throwables can get their ammo back just from pickups by default!",
		["loading_hh_19"] = "In Hyper Heisting, being out of stamina does not cancel your sprint, but does cause it to be slower, and not apply sprinting-related bonuses or effects!",
		["loading_hh_20"] = "In Hyper Heisting, a regular sprint consists of sprinting while above 10 stamina! Sprinting with lower stamina than that will cause sprint-related effects to not activate!",
		["loading_hh_21"] = "Staying in cover is a great way to keep your armor constantly regenerating and intact! Just be careful with enemies pushing in!",
		["loading_hh_22"] = "Ninjas tend to take flanking routes, and are often accompanied by other units!",
		["loading_hh_23"] = "A Heat Bonus will regenerate 50% of your HP and ammo!",
		["loading_hh_24"] = "Heat Bonuses tend to stop cops right in their tracks from pushing in, and buys you some time to do objectives!",
		["loading_hh_25"] = "Heat Bonuses tend to only happen if your crew is doing well, and playing aggressively!",
		["loading_hh_26"] = "Enemies recover much quicker from being wounded on higher difficulties!",
		["loading_hh_27"] = "Sometimes killing an enemy to get away them isn't nescessary! You can just make them keel over with a few gunshots to the body and run!",
		["loading_hh_28"] = "Focusing a lot of gunfire on Bulldozers will stun them for a brief moment, allowing for a quick getaway, or finishing blow!",
		["loading_hh_29"] = "A great way to stun Bulldozers is to pelt them with flames from a Flamethrower for a bit, and then use a gun to guarantee the stun animation!",
		["loading_hh_30"] = "Flamethrowers are great at locking down enemies into stun animations, and tend to finish common mooks off extremely quickly!",
		["loading_hh_31"] = "Cloakers make loud breathing sounds from their gas masks when moving around, keep an ear out!",
		["loading_hh_32"] = "In Hyper Heisting, Shotguns deal a minimum of 10% of their damage at a range! SWAT snipers beware!",
		["loading_hh_33"] = "In Hyper Heisting, when using Shotguns, raising your weapon's Accuracy above 50 grants you increased minimum damage at higher ranges!",
		["loading_hh_34"] = "In Hyper Heisting, the continuous damage an enemy takes when burning is based on the weapon's damage stat! Both for Flamethrowers, and Dragon's Breath rounds on shotguns!",
		["loading_hh_35"] = "A Flamethrower's damage over time will mostly always exceed the Dragon's Breath rounds' damage over time, but will also be much shorter!",
		
		["loading_hs_1"] = "It's imperative that everything you say has an exclamation mark in front of it!",
		["loading_hs_2"] = "If it doesn't die, shoot it harder!",
		["loading_hs_3"] = "Three words! Math! Is! For! Losers!",
		["loading_hs_4"] = "They can't kill you if they're dead!",
		["loading_hs_5"] = "You can't be bad at the game if you insult them every other sentence you say!",
		["loading_hs_6"] = "Jerome has many brothers!",
		["loading_hs_7"] = "The Jerome that works with the ZEALs is called Jerome (Cooler)!",
		["loading_hs_8"] = "Go to Crackdown's discord and ask for more neon units!",
		["loading_hs_9"] = "The Deagle-wielding Medic in Crime Spree is from Crackdown's universe! Don't ask how he got here!",
		["loading_hs_10"] = "Jovanny's favorite food is plain oatmeal!",
		["loading_hs_11"] = "Dragan does not have games on his phone.",
		["pattern_truthrunes_title"] = "Truth Runes",				
		["menu_l_global_value_hyperheist"] = "This is a Hyper Heisting item!",
		["menu_l_global_value_hyperheisting_desc"] = "This is a Hyper Heisting item!",		
		
		["shin_options_title"] = "Hyper Heisting Options!",	
		
		["shin_toggle_helmet_title"] = "Extreme Helmet Popping!",
		["shin_toggle_helmet_desc"] = "Enhances the force and power of flying helmets, and changes its calculations to give that feeling of extra oomph!",
		
		["shin_toggle_hhassault_title"] = "Stylish Assault Corner!",
		["shin_toggle_hhassault_desc"] = "Enhances the [POLICE ASSAULT IN PROGRESS] hud area by adding extra flavor! (Such as entirely unique assault text based on the faction you are fighting against!) NOTE: Requires restarting the heist if changed mid-game!",
		
		["shin_toggle_hhskulldiff_title"] = "Hyper Difficulty Names!",
		["shin_toggle_hhskulldiff_desc"] = "Changes the difficulty names to suit Hyper Heisting's style!",
		
		["shin_toggle_blurzonereduction_title"] = "Less Blurry Blurzones!",
		["shin_toggle_blurzonereduction_desc"] = "Gently reduces the blurring effect of things such as the Cook Off Methlab in order to stop them from getting in the way of gameplay!",
		
		["shin_toggle_highpriorityglint_title"] = "High Priority Tells!",
		["shin_toggle_highpriorityglint_desc"] = "Adds a glint to high priority enemies when they're about to fire, and plays a *ding!* when they're within 3 meters to let you know your goose is cooked! (Note: All of this only applies if they're targeting you!)",
		
		["shin_toggle_screenFX_title"] = "Ultra ScreenFX!",
		["shin_toggle_screenFX_desc"] = "Adds various visual adjustments and additions to screen effects that are present in Vanilla! Note: Not recommended to those prone to epilepsy.",
		
		["shin_toggle_suppression_title"] = "X-treme Visible Suppression!",
		["shin_toggle_suppression_desc"] = "Adds a unique visual effect to your screen for when you are being suppressed by enemies!",
		
		["shin_toggle_health_effect_title"] = "Low Health Visuals!",
		["shin_toggle_health_effect_desc"] = "Adds a bloody screen border effect to indicate how low your health is! NOTE: Requires a heist restart to apply changes.",
		
		["shin_screenshakemult_title"] = "Screenshake Intensity",
		["shin_screenshakemult_desc"] = "Allows you to manually set how intense screenshake effects are! You can lower it if you're prone to motion sickness! NOTE: Lowering the screenshake can make the game feel a lot less impactful!",
		
		["shin_toggle_noweirddof_title"] = "Disable Enviromental Depth Of Field!",
		["shin_toggle_noweirddof_desc"] = "Removes the Depth Of Field from backgrounds and the skybox allowing for them to look much clearer! NOTE: Works with the aiming Depth Of Field!",
		
		["shin_albanian_content_enable_title"] = "enable albanian joke content",
		["shin_enable_albanian_content_title"] = "enable albanian joke content",
		["shin_albanian_content_enable_desc"] = "nable abanian përmbajtje (WARNING: You probably shouldn't enable this!)",		
		["shin_toggle_overhaul_player_title"] = "HH Player-Side Rebalance!",
		["shin_toggle_overhaul_player_desc"] = "Enables the HH playerside rebalance, paired with a modified version of Gambyt's VIWR mod! Featuring various reworks of existing skills to make the game feel fresh! WARNING: ONLY TAKES EFFECT AFTER FULL GAME RESTART!!!",
		["shin_requires_restart_title"] = "Restart required!",
		["shin_requires_restart_desc"] = "You have made changes to the following settings:\n$SETTINGSLIST\nChanges will take effect on game restart.\nHave a nice day!",
		["menu_risk_pd"] = "Accessible. Stone cold.",
		["menu_risk_swat"] = "Simple but challenging. We are cool.",
		["menu_risk_fbi"] = "Challenging, but relaxed. A nice breeze.",
		["menu_risk_special"] = "Plain challenging, keeps your attention. A warm, summer day.",
		["menu_risk_easy_wish"] = "Demands focus. Getting hot in here!",
		["menu_risk_elite"] = "More units rolling in! More heat around the corner!",
		["menu_risk_sm_wish"] = "There is no escaping the flames! FIGHT!",
		["menu_hh_mutator_incomp"] = "This mutator is incompatible with Hyper Heisting...! Sadly!",
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
			["menu_difficulty_normal"] = "SWEET",
			["menu_difficulty_hard"] = "SOFT",
			["menu_difficulty_very_hard"] = "MILD",
			["menu_difficulty_overkill"] = "SPICY",
			["menu_difficulty_easy_wish"] = "ULTRA SPICY",
			["menu_difficulty_apocalypse"] = "SCORCHING HOT",
			["menu_difficulty_sm_wish"] = "INFERNAL"	
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
			
			["menu_deck15_3"] = "당신에게 달려오기",
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
			
			["menu_deck2_3_desc"] = "You are ##15%## more likely to be targeted by enemies when you are close to your crew members.\n\nYou gain ##5%## more health.",
			
			["menu_deck2_5_desc"] = "체력을 ##5%##만큼 더 얻습니다.",
			
			["menu_deck2_7_desc"] = "On killing an enemy, you have a ##50%## chance to spread ##Panic## amongst enemies within a ##6m## radius of the victim.\n\n##Panic## will make enemies go into ##bursts of uncontrollable fear.##",
			
			["menu_deck2_9_desc"] = "You gain an additional ##5%## more health.\n\nYou regenerate ##1%## of your health every ##5## seconds.",
			
			["menu_deck10_3_desc"] = "When you pick up ammo, you trigger an ammo pickup for ##50%## of normal pickup to other players in your team.\n\nCannot occur more than once every ##5## seconds.\n\nYou gain ##10%## more health.",

			["menu_deck10_5_desc"] = "When you get healed from picking up ammo packs, your teammates also get healed for ##50%## of the amount.\n\nYou gain ##5%## more health.",
			
			--Grinder
			["menu_deck11_1_desc"] = "You start with ##50%## of your Maximum Health and cannot heal above that.\n\nDamaging an enemy heals ##1## life points every ##0.3## seconds for ##3## seconds.\n\nThis effect stacks but cannot occur more than once every ##1.5## seconds, and only while wearing the ##Two-Piece Suit## or ##Lightweight Ballistic Vest##.\n\nNOTE: The health limit stacks with ##Something To Prove##.",
			
			["menu_deck11_3_desc"] = "Damaging an enemy now heals ##2## life points every ##0.3## seconds for ##3## seconds.\n\nYou gain ##10%## more health.",
			
			["menu_deck11_7_desc"] = "Damaging an enemy now heals ##4## life points every ##0.3## seconds for ##3## seconds.\n\nYou gain ##5%## more health.",
			
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
