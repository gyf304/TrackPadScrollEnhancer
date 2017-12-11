SmoothScroll(delta) {
    return DllCall("mouse_event", "UInt", 0x800, "Int", 0, "Int", 0, "Int", delta, "Int", 0)
}
