cfg = {}

cfg.permission = "ems.privatessss" -- 의료국 퍼미션 (이 권한으로 호출을 받습니다.)

cfg.callTime = 120 -- 몇 초 동안 소생콜이 표시될지 설정합니다. (초)

cfg.AIsetting = { -- AI 설정
    enable = true, -- (true : 의료국 인원이 없을때 AI가 자동으로 소생합니다. / false : 의료국 인원이 없을때 즉시 리스폰(뉴라이프) 합니다.)
    money = 10000, -- AI 가 소생할시 지불할 돈입니다. (지불할 돈이 없다면 리스폰(뉴라이프) 합니다.) [0원은 무료입니다.]
    delay = {5,5} -- AI 가 몇 초 뒤에 소생할지 설정합니다. (초) (AI 가 비활성화 이라면 무시됩니다.)
}

cfg.AlertChat = {
    enable = true,  -- (true : 의료국에서 호출을 받았을때 모든 사람에게 채팅으로 표시합니다. / false : 채팅으로 표시 하지 않습니다.)
    template = "^1🚨의료국 긴급출동 알림^0 : {0}님, 119 신고가 접수되었습니다! 현장으로 즉시 출동하겠습니다! 담당 구급대원: {1} ({2}KM)"
}   

cfg.rpBtnEvent = true -- (true : RP다운, RP전멸 버튼 활성화 / false : RP다운, RP전멸 버튼 비활성화 ※비활성화 할 경우 버튼이 보이지 않음)

cfg.rpDownAlertChat = {
    template = '<div class="chatIcon system">시스템</div><span style="padding: 2px 5px;">&nbsp;&nbsp; {0}님이, RP중 <span style="color:#3498db">다운</span>을 선언하셨습니다.</span>'
} 

cfg.rpstopAlertChat = {
    template = '<div class="chatIcon system">시스템</div><span style="padding: 2px 5px;">&nbsp;&nbsp; {0}님이, RP중 <span style="color:#db4535">중단</span>을 선언하셨습니다.</span>'
} 

cfg.rpDeathAlertChat = {
    template = '<div class="chatIcon system">시스템</div><span style="padding: 2px 5px;">&nbsp;&nbsp; {0}님이, RP중 <span style="color:#2ecc71">전멸</span>을 선언하셨습니다.</span>'
}