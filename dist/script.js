const inputRange = $("#slideUnlock")[0];
const maxValue = 100;
const speed = 2;
let rafID;
inputRange.min = 0;
inputRange.max = maxValue;

let callback = new Array();
let pocoUI = false;
let pocoSetTime;

window.addEventListener("message", function(event) {
    const nui = event.data;

    if (!callback[nui.type]) return;

    const func = callback[nui.type];
    func(nui)
});

function addNotify(text, time, webSend) {
    if (!pocoUI) return; // UI가 열려있지 않음
    const pocoNotify = $("<div>").addClass("notify slideIn")
    .append($("<div>").addClass("notifyHeader")
        .append($("<div>").addClass("Logo"))
        .append($("<p>").addClass("headerName").attr("id", "headerName").text("버블서버 의료국 알림"))
    )
    .append($("<div>").addClass("notifyContent")
        .append($("<p>").attr("id", "callmessage").html((webSend ? "[Web발신]<br>" : "") + text))
    );

    $("#notifyWrap").append(pocoNotify);

    new Audio("./sounds/note.mp3").play();

    setTimeout(() => {
        if (pocoNotify.hasClass("slideIn")) {
            pocoNotify.removeClass("slideIn").addClass("slideOut").on("animationend", function() {
                pocoNotify.remove();
            });
        }
    }, time * 1000);
}

callback["showUI"] = () => {
    pocoUI = true;

    $("#userName").text("");
    $("#viewport").addClass("active");
    if (pocoSetTime != undefined) clearTimeout(pocoSetTime);
}

callback["notify"] = (data) => {
    addNotify(data.text, data.time, true);
}

callback["hideUI"] = () => {
    reset(true);
    pocoUI = false;
    $("#viewport").removeClass("active");
    if (pocoSetTime != undefined) clearTimeout(pocoSetTime);
}

function reset(msg) {
    if (msg) $("#notifyWrap").html("");
    $("#container").removeClass("active");
    inputRange.value = 0;
}

function unlockStartHandler() {
    window.cancelAnimationFrame(rafID);
    currValue = + this.value;
}
  
function unlockEndHandler() {
    currValue = +this.value;
    if (currValue >= maxValue) successHandler();
    else rafID = window.requestAnimationFrame(animateHandler);
}

function animateHandler() {
    inputRange.value = currValue;
    if (currValue > -1) window.requestAnimationFrame(animateHandler);
    currValue = currValue - speed;
}

inputRange.addEventListener("mousedown", unlockStartHandler, false);
inputRange.addEventListener("mouseup", unlockEndHandler, false);

let CallBool = false;
function successHandler() {
    if (CallBool) return;
    CallBool = true;
    setTimeout(() => {
        CallBool = false;
    }, 1000);
    $("#container").addClass("active");
    addNotify("정상적으로 신고가 접수되었습니다. 잠시만 기다려 주세요.", 10, true);
    $.post(`https://${GetParentResourceName()}/ReviveRequest`);

    pocoSetTime = setTimeout(() => {
        if (pocoSetTime != undefined) { // pocoSetTime 이 있으면
            clearTimeout(pocoSetTime);
            $("#container").removeClass("active");
            inputRange.value = 0;

            addNotify(getTime() + "<br> 5분이내 구조되지 않아 다시 소방철을 호출할 수 있습니다.", 10, true);
            $.post(`https://${GetParentResourceName()}/NuiFocus`, JSON.stringify({poco: true}));
        }
    }, 1000 * 300/* 5분 */);
}

function getTime() {
    let today = new Date();

    let MM = ("0" + Number(today.getMonth() + 1)).slice(-2)
    let DD = ("0" + today.getDate(1)).slice(-2);
    let hh = ("0" + today.getHours()).slice(-2);
    let mm = ("0" + today.getMinutes()).slice(-2);
    let ss = ("0" + today.getSeconds()).slice(-2);

    return `${MM}/${DD} ${hh}시 ${mm}분 ${ss}초`
}

let ButtonCalltiem = false;

function handleButtonClick(message, type) {
    if (ButtonCalltiem) return addNotify("잠시 후 다시 시도해 주세요.", 3);

    ButtonCalltiem = true;
    this.children[0].classList.add("active");

    addNotify(message, 5);
    $.post(`https://${GetParentResourceName()}/Button`, JSON.stringify({
        type: type
    }));

    setTimeout(() => {
        this.children[0].classList.remove("active");
        ButtonCalltiem = false;
    }, 3000);
}

$("#userDeath").on("click", function() {
    handleButtonClick.call(this, "RP 중 다운을 선언하셨습니다.", "rpDownAlertChat");
});

$("#teamLose").on("click", function() {
    handleButtonClick.call(this, "RP 중 전멸을 선언하셨습니다.", "rpDeathAlertChat");
});

$("#teamstop").on("click", function() {
    handleButtonClick.call(this, "RP 중 중단을 선언하셨습니다.", "rpstopAlertChat");
});