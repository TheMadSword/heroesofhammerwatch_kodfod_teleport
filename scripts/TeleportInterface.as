namespace KodfodTeleport
{
    class TeleportInterface : UserWindow 
    {
        ScrollableWidget@ m_wList;
        Widget@ m_wTemplateButton;
        Widget@ m_wTemplateSeperator;
        ScalableSpriteButtonWidget@ teleportKeyButton;
        ScalableSpriteButtonWidget@ teleportMenuButton;
        ScalableSpriteButtonWidget@ infoMenuButton;
        GameChatWidget@ m_wChat;

        TeleportInterface(GUIBuilder@ b)
        {
            super(b, "gui/TeleportMenu.gui");
            
            @m_wList = cast<ScrollableWidget>(m_widget.GetWidgetById("list"));
            @m_wTemplateButton = m_widget.GetWidgetById("template-button");
            @m_wTemplateSeperator = m_widget.GetWidgetById("template-seperator");
            @m_wChat = cast<GameChatWidget>(m_widget.GetWidgetById("gamechat"));;
        }

        void Show() override
        {
            m_wList.PauseScrolling();
			m_wList.ClearChildren();
            
            int currentAct = GetActBasedOnTheme();
            bool players_added;

            for (uint i = 0; i < g_players.length(); i++)
            {

                Widget@ wNewPlayer = null;
                auto wNewButton = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
                string name = GetPlayerRecordByPeer(g_players[i].peer).GetName();
                auto playerRec = GetLocalPlayerRecord();
                if (name == playerRec.GetName()){
                    // Skip own player's name
                    continue;
                }
                wNewButton.m_func = "action " + name;
                wNewButton.SetText(name);
                @wNewPlayer = wNewButton;
                if (wNewPlayer is null)
				continue;

				wNewPlayer.m_visible = true;
				wNewPlayer.SetID("");
				m_wList.AddChild(wNewPlayer);
                players_added = true;
            }

            if (players_added)
            {
                // SEPERATOR
                auto wSeperator = cast<RectWidget>(m_wTemplateSeperator.Clone());
                wSeperator.m_visible = Network::IsServer();
                m_wList.AddChild(wSeperator);
                // END SEPERATOR
            }

            // START CUSTOM LEVELS
            if (currentAct != -1) // In town
            {
                auto wNextLevel = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
                wNextLevel.SetText("Next Level");
                wNextLevel.m_func = ("nextLevel");
                wNextLevel.m_visible = Network::IsServer();
                wNextLevel.SetID("");
                m_wList.AddChild(wNextLevel);

                auto wPreviousLevel = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
                wPreviousLevel.SetText("Previous Level");
                wPreviousLevel.m_func = ("previousLevel");
                wPreviousLevel.m_visible = Network::IsServer();
                wPreviousLevel.SetID("");
                m_wList.AddChild(wPreviousLevel);

                if (currentAct != 4 || currentAct != 5 || currentAct != 6) // No portal rooms for these levels
                {
                    auto wPortalRoom = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
                    wPortalRoom.SetText("Portal Room");
                    wPortalRoom.m_func = ("portalRoom");
                    wPortalRoom.m_visible = Network::IsServer();
                    wPortalRoom.SetID("");
                    m_wList.AddChild(wPortalRoom);
                }

                auto wTown = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
                wTown.SetText("Town");
                wTown.m_func = ("town");
                wTown.m_visible = Network::IsServer();
                wTown.SetID("");
                wTown.m_tooltipText = "DOES NOT SAVE!";
                m_wList.AddChild(wTown);
                // SEPERATOR
                auto wSeperator2 = cast<RectWidget>(m_wTemplateSeperator.Clone());
                wSeperator2.m_visible = Network::IsServer();
                m_wList.AddChild(wSeperator2);
                // END SEPERATOR
            } else 
            {
                auto wNextLevel = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
                wNextLevel.SetText("Start Dungeon");
                wNextLevel.m_func = ("nextLevelTown");
                wNextLevel.m_visible = Network::IsServer();
                wNextLevel.SetID("");
                m_wList.AddChild(wNextLevel);
            }

            // LEVELS

            auto currentActNumber = GetActBasedOnTheme();
            uint numOfLevels = 0;
            switch (currentActNumber)
            {
                case -1:
                case 6:
                numOfLevels = 0;
                break;
                case 0:
                case 1:
                case 2:
                case 3:
                    numOfLevels = 3;
                break;
                case 4:
                    numOfLevels = 2; 
                break;
                case 5:
                    numOfLevels = 2;
                break;
            }

            for (uint i = 0; i < numOfLevels; i++)
            {
                auto wLevelNumber = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
                int floor_number = i+1;
                wLevelNumber.SetText("Level " + floor_number);
                wLevelNumber.m_func = ("levelNumber " + i);
                wLevelNumber.m_visible = Network::IsServer();
                wLevelNumber.SetID("");
                m_wList.AddChild(wLevelNumber);
            }

            // END LEVELS

            // BOSS
            bool showBoss = true;
            print("ActNumber: " + currentActNumber);
            if (currentActNumber == -1 || currentActNumber == 5 || currentActNumber == 7)
            {
                showBoss = false;
            }
            if (showBoss)
            {
                auto wBossRoom = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
                wBossRoom.SetText("Act Boss Room");
                wBossRoom.m_func = ("bossRoom");
                wBossRoom.m_visible = Network::IsServer();
                wBossRoom.SetID("");
                m_wList.AddChild(wBossRoom);
            }

            // END BOSS
            
            // SEPERATOR
            auto wSeperator3 = cast<RectWidget>(m_wTemplateSeperator.Clone());
            wSeperator3.m_visible = Network::IsServer();
            m_wList.AddChild(wSeperator3);
            // END SEPERATOR

            for (uint i = 0; i < 7; i++)
            {
                auto wActNumber = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
                int act_number = i+1;
                wActNumber.SetText("Act " + act_number);
                wActNumber.m_func = ("actNumber " + i);
                wActNumber.m_visible = Network::IsServer();
                wActNumber.SetID("");
                m_wList.AddChild(wActNumber);
            }

            // SEPERATOR
            auto wSeperator4 = cast<RectWidget>(m_wTemplateSeperator.Clone());
            wSeperator4.m_visible = true;
            m_wList.AddChild(wSeperator4);
            // END SEPERATOR

            auto winfoButton = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
            @infoMenuButton = winfoButton;
            infoMenuButton.SetText("Custom Keys Broken");
            infoMenuButton.m_visible = true;
            infoMenuButton.SetID("");
            m_wList.AddChild(infoMenuButton);

            auto wteleportKeyButton = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
            if (wteleportKeyButton !is null)
            {
                @teleportKeyButton = wteleportKeyButton;
            }else {
                print("KODFOD TELEPORT ERROR: wteleportKeyButton is null");
                return;
            }
            teleportKeyButton.SetText("Teleport Key: " + GetStringNameForKeyID(TeleportToPoint_Key));
            //teleportKeyButton.m_func = ("changeTeleportKey");
            teleportKeyButton.m_visible = true;
            teleportKeyButton.SetID("");
            m_wList.AddChild(teleportKeyButton);

            // changeMenuKey
            auto wteleportMenuButton = cast<ScalableSpriteButtonWidget>(m_wTemplateButton.Clone());
            if (wteleportMenuButton !is null)
            {
                @teleportMenuButton = wteleportMenuButton;
            } else {
                print("[Kodfod Teleport]: Something went horribly wrong!");
            }
            teleportMenuButton.SetText("Menu Key: " + GetStringNameForKeyID(OpenMenu_Key));
            //teleportMenuButton.m_func = ("changeMenuKey");
            teleportMenuButton.m_visible = true;
            teleportMenuButton.SetID("");
            m_wList.AddChild(teleportMenuButton);

            // END CUSTOM LEVELS
			m_wList.ResumeScrolling();
			UserWindow::Show();
        }

        void OnFunc(Widget@ sender, string name) override
		{
			auto parse = name.split(" ");
            if(parse[0] == "action" && parse.length() == 2)
			{
                auto peerID = -1;
                for (uint i = 0; i < g_players.length(); i++)
                {
                    auto _temp = GetPlayerRecordByPeer(g_players[i].peer);
                    print(_temp.GetName());
                    if (_temp.GetName() == parse[1]){
                        peerID = g_players[i].peer;
                        continue;
                    }
                }
                if (peerID == -1)
                {
                    print("Peer was -1...");
                    UserWindow::OnFunc(sender, name);
                    return;
                }
				auto target = GetPlayerRecordByPeer(peerID);
                auto a = target.actor;
                vec3 newPos;
                if (a is null)
                {
                    newPos = target.corpse.m_unit.GetPosition();
                } else 
                {
                    print("Teleporting to Corpse...");
                    newPos = target.actor.m_unit.GetPosition();
                }
                auto playerRec = GetLocalPlayerRecord();
                auto aa = playerRec.actor;
                if (aa !is null)
                {
                    playerRec.actor.m_unit.SetPosition(newPos);
                } 
                (Network::Message("PlayerMoveForce") << newPos << newPos).SendToAll();
                UserWindow::Close();
                AddFloatingText(FloatingTextType::Pickup, "Teleported!",  playerRec.actor.m_unit.GetPosition());
			} else if (parse[0] == "nextLevel")
            {
                auto script = WorldScript::LevelExitNext();
	            script.ServerExecute();
            } else if (parse[0] == "nextLevelTown")
            {
                auto gm = cast<Campaign>(g_gameMode);
                auto nextLevel = gm.m_rotation.GetLevel(0);
                ChangeLevel(nextLevel.m_filename);
            } else if (parse[0] == "previousLevel")
            {
                auto gm = cast<Campaign>(g_gameMode);
			    gm.m_levelCount--;
                auto nextLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                ChangeLevel(nextLevel.m_filename);
            } else if (parse[0] == "portalRoom")
            {
                ChangeLevel("levels/challenge.lvl");
            } else if (parse[0] == "town") 
            {
                ChangeLevel("levels/town_outlook.lvl");
            } else if (parse[0] == "levelNumber")
            {
                int t = parseInt(parse[1]);
                auto gm = cast<Campaign>(g_gameMode);
                gm.m_levelCount = t + GetActOffset(GetActBasedOnTheme());
                auto nextLevel = gm.m_rotation.GetLevel(t + GetActOffset(GetActBasedOnTheme()));
                ChangeLevel(nextLevel.m_filename);
            } else if  (parse[0] == "bossRoom")
            {
                auto gm = cast<Campaign>(g_gameMode);
                auto currentAct = GetActBasedOnTheme();
                DungeonRotationLevel@ currentLevel;
                if (gm.m_levelCount != 0)
                {
                    @currentLevel = gm.m_rotation.GetLevel(gm.m_levelCount-1);
                }
                switch (currentAct)
                {
                    case 0:
                        gm.m_levelCount = 3;
                        @currentLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(currentLevel.m_filename);
                    break;
                    case 1:
                        gm.m_levelCount = 7;
                        @currentLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(currentLevel.m_filename);
                    break;
                    case 2:
                        gm.m_levelCount = 11;
                        @currentLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(currentLevel.m_filename);
                    break;
                    case 3:
                        gm.m_levelCount = 15;
                        @currentLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(currentLevel.m_filename);
                    break;
                    case 4:
                        gm.m_levelCount = 18;
                        @currentLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(currentLevel.m_filename);
                    break;
                    case 5:
                        gm.m_levelCount = 20;
                        @currentLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(currentLevel.m_filename);
                    break;
                    case 6:
                        gm.m_levelCount = 22;
                        @currentLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(currentLevel.m_filename);
                    break;
                }
                //ChangeLevel(currentLevel.m_filename);
            }
            else if (parse[0] == "actNumber")
            {
                int t = parseInt(parse[1]);
                auto gm = cast<Campaign>(g_gameMode);
                DungeonRotationLevel@ nextLevel;
                switch (t)
                {
                    case 0:
                        gm.m_levelCount = 0;
                        @nextLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(nextLevel.m_filename);
                    break;
                    case 1:
                        gm.m_levelCount = 4;
                        @nextLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(nextLevel.m_filename);
                    break;
                    case 2:
                        gm.m_levelCount = 8;
                        @nextLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(nextLevel.m_filename);
                    break;
                    case 3:
                        gm.m_levelCount = 12;
                        @nextLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(nextLevel.m_filename);
                    break;
                    case 4:
                        gm.m_levelCount = 16;
                        @nextLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(nextLevel.m_filename);
                    break;
                    case 5:
                        gm.m_levelCount = 19;
                        @nextLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(nextLevel.m_filename);
                    break;
                    case 6:
                        gm.m_levelCount = 21;
                        @nextLevel = gm.m_rotation.GetLevel(gm.m_levelCount);
                        ChangeLevel(nextLevel.m_filename);
                    break;
                }
                //ChangeLevel(nextLevel.m_filename);
            } else if (parse[0] == "changeTeleportKey")
            {
                teleportKeyButton.SetText("Press Button...");
                ChangeTeleportKeyButtonPressed = true;
            }else if (parse[0] == "changeMenuKey")
            {
                teleportMenuButton.SetText("Press Button...");
                ChangeMenuKeyButtonPressed = true;
            }
			else
				UserWindow::OnFunc(sender, name);
		}
    }

    int GetActBasedOnTheme()
    {
        auto gm = cast<Campaign>(g_gameMode);
        auto currentLevel = gm.m_rotation.GetLevel(gm.m_levelCount-1);
        if (currentLevel is null)
        {
            print("Test 0");
            @currentLevel = gm.m_rotation.GetLevel(0);
        }
        auto currentAct = 0;
        print("LEVELS = " + gm.m_levelCount);
        auto gm_test = cast<Town>(g_gameMode);
        if (gm_test !is null)
        {
            currentAct = -1;
            return currentAct;
        } if (currentLevel.m_level == 0)
        {
            currentAct = 0;
        } if (currentLevel.m_theme == "prison" || currentLevel.m_filename == "levels/boss_mines.lvl")
        {
            currentAct = 1;
        } if (currentLevel.m_theme == "armory" || currentLevel.m_filename == "levels/boss_prison.lvl")
        {
            currentAct = 2;
        } if (currentLevel.m_theme == "archives" || currentLevel.m_filename == "levels/boss_armory.lvl")
        {
            currentAct = 3;
        } if (currentLevel.m_theme == "chambers" || currentLevel.m_filename == "levels/boss_archives.lvl")
        {
            currentAct = 4;
        } if (currentLevel.m_theme == "battlements" || currentLevel.m_filename == "levels/boss_chambers.lvl")
        {
            currentAct = 5;
        }         
        if (currentLevel.m_act == 5 && currentLevel.m_level == 1)
        {
            currentAct = 6;
        }
        if (currentLevel.m_act == 6 && currentLevel.m_level == 0)
        {
            currentAct = 7;
        }
        print("Test 9.5");
        print("m_fileName: " + currentLevel.m_filename);
        print("m_act: " + currentLevel.m_act);
        print("m_level: " + currentLevel.m_level);
        print("m_theme: " + currentLevel.m_theme);
        return currentAct;
    }

    int GetActOffset(int ActNumber)
    {
        int send = 0;
        switch (ActNumber)
        {
            case 0:
                send = 0;
            break;
            case 1:
                send = 4;
            break;
            case 2:
                send = 8;
            break;
            case 3:
                send = 12;
            break;
            case 4:
                send = 16;
            break;
            case 5:
                send = 19;
            break;
            case 6:
                send = 21;
            break;
        }
        print("ActNumber: " + ActNumber + " | Send: " + send);
        return send;
    }
}