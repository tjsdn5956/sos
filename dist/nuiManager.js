let callback = new Array();

window.addEventListener("message", function(event) {
    const nui = event.data;

    if (!callback[nui.type]) return;

    const func = callback[nui.type];
    func(nui)
});