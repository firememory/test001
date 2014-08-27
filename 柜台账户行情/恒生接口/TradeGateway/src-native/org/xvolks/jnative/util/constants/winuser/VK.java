package org.xvolks.jnative.util.constants.winuser;

public enum VK
{
	VK_LBUTTON(0x1), // Linker Mausbutton
	VK_RBUTTON(0x2), // Rechter Mausbutton
	VK_MBUTTON(0x4), // Mittlerer Mausbutton
	VK_BACK(0x8), // Backspace Taste
	VK_TAB(0x9), // Tab Taste
	VK_CLEAR(0xC), // Numpad 5 ohne Numlock
	VK_RETURN(0xD), // Enter Taste
	VK_SHIFT(0x10), // Shift Taste
	VK_CONTROL(0x11), // STRG Taste
	VK_MENU(0x12), // Alt Taste
	VK_PAUSE(0x13), // Pause/Untbr
	VK_CAPITAL(0x14), // Caps Lock/Feststelltaste
	VK_ESCAPE(0x1B), // Escape
	VK_SPACE(0x20), // Space/Leertaste
	VK_PRIOR(0x21), // PageUp/Bild hoch
	VK_NEXT(0x22), // PageDown/Bild runter
	VK_END(0x23), // Ende
	VK_HOME(0x24), // Home/Pos1
	VK_LEFT(0x25), // Linke Pfeiltaste
	VK_UP(0x26), // Obere Pfeiltaste
	VK_RIGHT(0x27), // Rechte Pfeiltaste
	VK_DOWN(0x28), // Untere Pfeiltaste
	VK_PRINT(0x2A), // Drucken (Nokia Tastaturen)
	VK_SNAPSHOT(0x2C), // Drucken/S-Abf
	VK_INSERT(0x2D), // Einf�gen
	VK_DELETE(0x2E), // Entfernen
	VK_HELP(0x2F), // Hilfe
	VK_0(0x30), // Taste 0
	VK_1(0x31), // Taste 1
	VK_2(0x32), // Taste 2
	VK_3(0x33 ), // Taste 3
	VK_4(0x34), // Taste 4
	VK_5(0x35), // Taste 5
	VK_6(0x36), // Taste 6
	VK_7(0x37), // Taste 7
	VK_8(0x38 ), // Taste 8
	VK_9(0x39 ), // Taste 9
	VK_A(0x41 ), // Taste A
	VK_B(0x42 ), // Taste B
	VK_C(0x43 ), // Taste C
	VK_D(0x44 ), // Taste D
	VK_E(0x45 ), // Taste E
	VK_F(0x46 ), // Taste F
	VK_G(0x47 ), // Taste G
	VK_H(0x48), // Taste H
	VK_I(0x49), // Taste I
	VK_J(0x4A), // Taste J
	VK_K(0x4B), // Taste K
	VK_L(0x4C ), // Taste L
	VK_M(0x4D ), // Taste M
	VK_N(0x4E), // Taste N
	VK_O(0x4F), // Taste O
	VK_P(0x50 ), // Taste P
	VK_Q(0x51 ), // Taste Q
	VK_R(0x52), // Taste R
	VK_S(0x53), // Taste S
	VK_T(0x54 ), // Taste T
	VK_U(0x55), // Taste U
	VK_V(0x56), // Taste V
	VK_W(0x57 ), // Taste W
	VK_X(0x58), // Taste X
	VK_Y(0x59), // Taste Y
	VK_Z(0x5A), // Taste Z
	VK_STARTKEY(0x5B), // Startmen�taste
	VK_CONTEXTKEY(0x5D), // Kentextmen�
	VK_NUMPAD0(0x60), // Numpad Taste 0
	VK_NUMPAD1(0x61), // Numpad Taste 1
	VK_NUMPAD2(0x62), // Numpad Taste 2
	VK_NUMPAD3(0x63), // Numpad Taste 3
	VK_NUMPAD4(0x64), // Numpad Taste 4
	VK_NUMPAD5(0x65), // Numpad Taste 5
	VK_NUMPAD6(0x66), // Numpad Taste 6
	VK_NUMPAD7(0x67), // Numpad Taste 7
	VK_NUMPAD8(0x68 ), // Numpad Taste 8
	VK_NUMPAD9(0x69 ), // Numpad Taste 9
	VK_MULTIPLY(0x6A), // Numpad Multiplikations Taste (*)
	VK_ADD(0x6B), // Numpad Additions Taste (+)
	VK_SUBTRACT(0x6D), // Numpad Subtrations Taste (-)
	VK_DECIMAL(0x6E), // Numpad Komma Taste (,)
	VK_DIVIDE(0x6F), // Numpad Devidierungs Taste (/)
	VK_F1(0x70), // F1 Taste
	VK_F2(0x71), // F2 Taste
	VK_F3(0x72 ), // F3 Taste
	VK_F4(0x73 ), // F4 Taste
	VK_F5(0x74 ), // F5 Taste
	VK_F6(0x75 ), // F6 Taste
	VK_F7(0x76), // F7 Taste
	VK_F8(0x77), // F8 Taste
	VK_F9(0x78 ), // F9 Taste
	VK_F10(0x79), // F10 Taste
	VK_F11(0x7A ), // F11 Taste
	VK_F12(0x7B ), // F12 Taste
	VK_F13(0x7C), // F13 Taste
	VK_F14(0x7D), // F14 Taste
	VK_F15(0x7E ), // F15 Taste
	VK_F16(0x7F ), // F16 Taste
	VK_F17(0x80 ), // F17 Taste
	VK_F18(0x81 ), // F18 Taste
	VK_F19(0x82 ), // F19 Taste
	VK_F20(0x83 ), // F20 Taste
	VK_F21(0x84 ), // F21 Taste
	VK_F22(0x85 ), // F22 Taste
	VK_F23(0x86 ), // F23 Taste
	VK_F24(0x87 ), // F24 Taste
	VK_NUMLOCK(0x90), // Numlock Taste
	VK_OEM_SCROLL(0x91), // Scroll Lock
	VK_LSHIFT(0xA0), // Linke Shift-Taste
	VK_RSHIFT(0xA1), // Rechte Shift-Taste
	VK_LCONTROL(0xA2), // Linke STRG-Taste
	VK_RCONTROL(0xA3), // Rechte STRG-Taste
	VK_LMENU(0xA4), // Linke ALT-Taste
	VK_RMENU(0xA5), // Rechte ALT-Taste
	VK_OEM_1(0xBA), // ";"-Taste
	VK_OEM_PLUS(0xBB), // "
	VK_OEM_COMMA(0xBC), // ","-Taste
	VK_OEM_MINUS(0xBD), // "-"-Taste
	VK_OEM_PERIOD(0xBE), // "."-taste
	VK_OEM_2(0xBF), // "/"-Taste
	VK_OEM_3(0xC0), // "`"-Taste
	VK_OEM_4(0xDB), // "["-Taste
	VK_OEM_5(0xDC), // "\"-Taste
	VK_OEM_6(0xDD), // "]"-Taste
	VK_OEM_7(0xDE), // "
	VK_ICO_F17(0xE0), // F17 einer Olivette Tastatur (Intern)
	VK_ICO_F18(0xE1), // F18 einer Olivette Tastatur (Intern)
	VK_OEM102(0xE2), // "<"-Taste oder "|"-Taste einer IBM-Kompatiblen 102 Tastatur (Nicht US)
	VK_ICO_HELP(0xE3), // Hilfetaste einer Olivetti Tastatur (Intern) 
	VK_ICO_00(0xE4), // 00-Taste einer Olivetti Tastatur (Intern)
	VK_ICO_CLEAR(0xE6), // L�schen Taste einer Olivetti Tastatur (Intern) 
	VK_OEM_RESET(0xE9), // Reset Taste (Nokia)
	VK_OEM_JUMP(0xEA), // Springen Taste (Nokia)
	VK_OEM_PA1(0xEB), // PA1 Taste (Nokia)
	VK_OEM_PA2(0xEC), // PA2 Taste (Nokia)
	VK_OEM_PA3(0xED), // PA3 Taste (Nokia)
	VK_OEM_WSCTRL(0xEE), // WSCTRL Taste (Nokia)
	VK_OEM_CUSEL(0xEF), // WSCTRL Taste (Nokia)
	VK_OEM_ATTN(0xF0), // ATTN Taste (Nokia)
	VK_OEM_FINNISH(0xF1), // Fertig Taste (Nokia)
	VK_OEM_COPY(0xF2), // Kopieren Taste (Nokia)
	VK_OEM_AUTO(0xF3), // Auto Taste (Nokia)
	VK_OEM_ENLW(0xF4), // ENLW Taste (Nokia)
	VK_OEM_BACKTAB(0xF5), // BackTab Taste (Nokia)
	VK_ATTN(0xF6), // ATTN-Taste
	VK_CRSEL(0xF7), // CRSEL-Taste
	VK_EXSEL(0xF8), // EXSEL-Taste
	VK_EREOF(0xF9), // EREOF-Taste
	VK_PLAY(0xFA), // PLAY-Taste
	VK_ZOOM(0xFB), // ZOOM-Taste
	VK_NONAME(0xFC), // NONAME-Taste
	VK_PA1(0xFD), // PA1-Taste
	VK_OEM_CLEAR(0xFE) // OEM_CLEAR-Taste
		;
	private int mValue;
	public int getValue()
	{
		return mValue;
	}
	private VK(int lValue)
	{
		mValue = lValue;
	}
}
