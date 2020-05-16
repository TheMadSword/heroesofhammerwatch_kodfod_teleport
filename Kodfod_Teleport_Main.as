namespace KodfodTeleport
{

    TeleportInterface@ g_interface;

    int OpenMenu_Key = KEYS::KEY_F4;
    int TeleportToPoint_Key = KEYS::KEY_BACKWORD_SLASH;

    bool ChangeMenuKeyButtonPressed = false;
    bool ChangeTeleportKeyButtonPressed = false;

    [Hook]
	void GameModeStart(Campaign@ campaign, SValue@ save)
    {
        PlayerRecord local = GetLocalPlayerRecord();
        // Add our GUI
        campaign.m_userWindows.insertLast(@g_interface = TeleportInterface(campaign.m_guiBuilder));
        // Create our configuration variables
        int _t = 0;
        //Config::AddVar("kodfod_Teleport_OpenMenu", _t);
        //Config::AddVar("kodfod_Teleport_TeleportToCursor", _t);

        auto _MenuKey = GetVarInt("kodfod_Teleport_OpenMenu");
        if (_MenuKey != 0){
            OpenMenu_Key = _MenuKey;
        } else 
        {
            SValueBuilder@ builder;
            builder.PushString("kodfod_teleport_openmenu", OpenMenu_Key);
            //Config::SaveVar("kodfod_Teleport_OpenMenu", OpenMenu_Key);
            campaign.SavePlayer(builder, local);
        }
        auto _TeleportKey = GetVarInt("kodfod_Teleport_TeleportToCursor");
        if (_TeleportKey != 0)
        {
            TeleportToPoint_Key = _TeleportKey;
        } else 
        {
            SValueBuilder@ builder;
            builder.PushString("kodfod_teleport_teleporttocursor", TeleportToPoint_Key);
            //Config::SaveVar("kodfod_Teleport_TeleportToCursor", TeleportToPoint_Key);
            campaign.SavePlayer(builder, local);
        }
    }

    [Hook]
	void GameModeUpdate(Campaign@ campaign, int dt, GameInput& gameInput, MenuInput& menuInput)
    {
        PlayerRecord local = GetLocalPlayerRecord();
        if (g_interface is null)
        {
            return;
        }
        // Handle Setting HotKey
        if (ChangeMenuKeyButtonPressed)
        {
            int keyPressed = GetKeyChangePressed();
            if (keyPressed != -1)
            {
                OpenMenu_Key = keyPressed;
                SValueBuilder@ builder;
                builder.PushString("kodfod_teleport_openmenu", keyPressed);
                //Config::SaveVar("kodfod_Teleport_OpenMenu", keyPressed);
                campaign.SavePlayer(builder, local);
                g_interface.teleportMenuButton.SetText("Menu Set: " + GetStringNameForKeyID(keyPressed));
                ChangeMenuKeyButtonPressed = false;
            }
            return;
        }
        if (ChangeTeleportKeyButtonPressed)
        {
            int keyPressed = GetKeyChangePressed();
            if (keyPressed != -1)
            {
                SValueBuilder@ builder;
                TeleportToPoint_Key = keyPressed;
                builder.PushString("kodfod_teleport_teleporttcursor", keyPressed);
                //Config::SaveVar("kodfod_Teleport_TeleportToCursor", keyPressed);
                campaign.SavePlayer(builder, local);
                g_interface.teleportKeyButton.SetText("Teleport Set: " + GetStringNameForKeyID(keyPressed));
                ChangeTeleportKeyButtonPressed = false;
            }
            return;
        }
        // End Handle Setting HotKey
        // Handle key presses
        if (Platform::GetKeyState(OpenMenu_Key).Pressed)
		{
            campaign.ToggleUserWindow(g_interface);
        }
        if (Platform::GetKeyState(TeleportToPoint_Key).Pressed)
        {
            auto playerRec = GetLocalPlayerRecord();
            vec2 posMouse = campaign.m_mice[0].GetPos(0);
			vec3 newPos = ToWorldspace(posMouse);
            playerRec.actor.m_unit.SetPosition(newPos);
            (Network::Message("PlayerMoveForce") << newPos << newPos).SendToAll();
        }
        // End Handle Key Presses
    }

    int GetKeyChangePressed()
    {
        for (uint i = 0; i < 255; i++)
        {
            if (Platform::GetKeyState(i).Pressed)
            {
                print(GetStringNameForKeyID(i) + " was pressed." );
                return i;
            }
        }
        return -1;
    }

    string GetStringNameForKeyID(int id)
    {
        switch (id)
        {
            case 4:
                return "A";
            case 5:
                return "B";
            case 6:
                return "C";
            case 7:
                return "D";
            case 8:
                return "E";
            case 9:
                return "F";
            case 10:
                return "G";
            case 11:
                return "H";
            case 12:
                return "I";
            case 13:
                return "J";
            case 14:
                return "K";
            case 15:
                return "L";
            case 16:
                return "M";
            case 17:
                return "N";
            case 18:
                return "O";
            case 19:
                return "P";
            case 20:
                return "Q";
            case 21:
                return "R";
            case 22:
                return "S";
            case 23:
                return "T";
            case 24:
                return "U";
            case 25:
                return "V";
            case 26:
                return "W";
            case 27:
                return "X";
            case 28:
                return "Y";
            case 29:
                return "Z";
            case 30:
                return "1";
            case 31:
                return "2";
            case 32:
                return "3";
            case 33:
                return "4";
            case 34:
                return "5";
            case 35:
                return "6";
            case 36:
                return "7";
            case 37:
                return "8";
            case 38:
                return "9";
            case 39:
                return "0";
            case 41:
                return "Escape";
            case 42:
                return "Backspace";
            case 43:
                return "Tab";
            case 44:
                return "Space";
            case 45:
                return "Minus";
            case 46:
                return "Equals";
            case 47:
                return "[";
            case 48:
                return "]";
            case 49:
                return "/";
            case 51:
                return ";";
            case 52:
                return "\'";
            case 53:
                return "Grave";
            case 54:
                return ",";
            case 55:
                return ".";
            case 56:
                return "\\";
            case 58:
                return "F1";
            case 59:
                return "F2";
            case 60:
                return "F3";
            case 61:
                return "F4";
            case 62:
                return "F5";
            case 63:
                return "F6";
            case 64:
                return "F7";
            case 65:
                return "F8";
            case 66:
                return "F9";
            case 67:
                return "F10";
            case 68:
                return "F11";
            case 69:
                return "F12";
            case 73:
                return "Insert";
            case 74:
                return "Home";
            case 75:
                return "Page Up";
            case 76:
                return "Delete";
            case 77:
                return "End";
            case 78:
                return "Page Down";
            case 79:
                return "Left";
            case 80:
                return "Right";
            case 81:
                return "Down";
            case 82:
                return "Up";
            case 84:
                return "Num /";
            case 85:
                return "Num *";
            case 86:
                return "Num -";
            case 87:
                return "Num +";
            case 88:
                return "Num Enter";
            case 89:
                return "Num1";
            case 90:
                return "Num2";
            case 91:
                return "Num3";
            case 92:
                return "Num4";
            case 93:
                return "Num5";
            case 94:
                return "Num6";
            case 95:
                return "Num7";
            case 96:
                return "Num8";
            case 97:
                return "Num9";
            case 98:
                return "Num0";
            case 99:
                return "Num .";
            case 101:
                return "Right Menu";
            case 226:
                return "Left Alt";
            case 225:
                return "Left Shift";
            case 228:
                return "Right Ctrl";
            case 229:
                return "Right Shift";
            case 230:
                return "Right Alt";
            case 231:
                return "Right Windows";
            case 244:
                return "Left Ctrl";
            case 277:
                return "Left Windows";

        }
        return "ERROR";
    }

    
    enum KEYS
    {
        KEY_A = 4,
        KEY_B = 5,
        KEY_C = 6,
        KEY_D = 7,
        KEY_E = 8,
        KEY_F = 9,
        KEY_G = 10,
        KEY_H = 11,
        KEY_I = 12,
        KEY_J = 13,
        KEY_K = 14,
        KEY_L = 15,
        KEY_M = 16,
        KEY_N = 17,
        KEY_O = 18,
        KEY_P = 19,
        KEY_Q = 20,
        KEY_R = 21,
        KEY_S = 22,
        KEY_T = 23,
        KEY_U = 24,
        KEY_V = 25,
        KEY_W = 26,
        KEY_X = 27,
        KEY_Y = 28,
        KEY_Z = 29,
        KEY_1 = 30,
        KEY_2 = 31,
        KEY_3 = 32,
        KEY_4 = 33,
        KEY_5 = 34,
        KEY_6 = 35,
        KEY_7 = 36,
        KEY_8 = 37,
        KEY_9 = 38,
        KEY_0 = 39,
        // HERE
        KEY_ESCAPE = 41,
        KEY_BACKSPACE = 42,
        KEY_TAB = 43,
        KEY_SPACE = 44,
        KEY_MINUS = 45,
        KEY_EQUALS = 46,
        KEY_BRACKET_LEFT = 47,
        KEY_BRACKET_RIGHT = 48,
        KEY_BACKWORD_SLASH = 49,
        KEY_SEMICOLON = 51,
        KEY_APOSTROPHE = 52,
        KEY_GRAVE = 53,
        KEY_COMMA = 54,
        KEY_PERIOD = 55,
        KEY_FORWARD_SLASH = 56,
        // HERE
        KEY_F1 = 58,
        KEY_F2 = 59,
        KEY_F3 = 60,
        KEY_F4 = 61,
        KEY_F5 = 62,
        KEY_F6 = 63,
        KEY_F7 = 64,
        KEY_F8 = 65,
        KEY_F9 = 66,
        KEY_F10 = 67,
        KEY_F11 = 68,
        KEY_F12 = 69,
        KEY_INSERT = 73,
        KEY_HOME = 74,
        KEY_PAGE_UP = 75,
        KEY_DELETE = 76,
        KEY_END = 77,
        KEY_PAGE_DOWN = 78,
        KEY_ARROW_LEFT = 79,
        KEY_ARROW_RIGHT = 80,
        KEY_ARROW_DOWN = 81,
        KEY_ARROW_UP = 82,
        KEY_NUM_DIVIDE = 84,
        KEY_NUM_MULTIPLY = 85,
        KEY_NUM_SUBTRACT = 86,
        KEY_NUM0_ADDITION = 87,
        KEY_NUM_ENTER = 88,
        KEY_NUM1 = 89,
        KEY_NUM2 = 90,
        KEY_NUM3 = 91,
        KEY_NUM4 = 92,
        KEY_NUM5 = 93,
        KEY_NUM6 = 94,
        KEY_NUM7 = 95,
        KEY_NUM8 = 96,
        KEY_NUM9 = 97,
        KEY_NUM0 = 98,
        KEY_NUM_PERIOD = 99,
        KEY_RIGHT_MENU = 101,
        KEY_LEFT_ALT = 226,
        KEY_LEFT_SHIFT = 225,
        KEY_RIGHT_CTRL = 228,
        KEY_RIGHT_SHIFT = 229,
        KEY_RIGHT_ALT = 230,
        KEY_RIGHT_WINDOWS = 231,
        KEY_LEFT_CRTL = 244,
        KEY_LEFT_WINDOWS = 277, 
    }
}