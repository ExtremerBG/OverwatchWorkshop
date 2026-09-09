settings {
    "main": {
        "description": "Version 2 by ExtremerBG#2712 - Code 4KZZP\r\n Original by Jeshaal#1649 - Code 3N0R2",
        "modeName": "Jetpack Cat Racing 2"
    },
    "lobby": {
        "mapRotation": "afterGame",
        "spectatorSlots": 12,
        "team1Slots": 0,
        "team2Slots": 9,
        "returnToLobby": "never"
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                "circuitRoyal",
                "dorado",
                {
                    "eichenwalde": [
                        "972777519512094292",
                        "972777519512095572"
                    ]
                },
                "eichenwaldeHalloween",
                "hanamura",
                "hanamuraWinter",
                {
                    "kingsRow": [
                        "evening",
                        "night",
                        "972777519512068194"
                    ]
                },
                "kingsRowWinter",
                {
                    "rialto": [
                        "morning",
                        "evening",
                        "972777519512068197"
                    ]
                },
                "volskaya"
            ]
        },
        "general": {
            "enableHeroSwitching": false,
            "heroLimit": "off",
            "respawnTime%": 30
        }
    },
    "heroes": {
        "allTeams": {
            "jetpackCat": {
                "secondaryFireMaximumTime%": 500,
                "secondaryFireRechargeRate%": 500,
                "enablePassiveUnlimitedFuel": true,
                "ability1Cooldown%": 0,
                "ability2Cooldown%": 0,
                "enableUlt": false
            },
            "enabledHeroes": [
                "jetpackCat"
            ]
        }
    }
}

#Global variables

globalvar Starting 0
globalvar Racetrack_Game 1
globalvar Lobby_High 2
globalvar Lobby_Best 3
globalvar Racetrack_PerNode_Boost 4

#Player variables

playervar Racetrack 0
playervar Timer 1
playervar High_Score 2
playervar Racing 3
playervar Base_SpeedBoost 4
playervar PurrBoost_Effect 5
playervar PurrBoost_Text 6
playervar Purrboost_NanoEffect_ID_Array 7
playervar Purrboost_NanoEffect_Target 8
playervar PurrBoost_RingCounter 10
playervar Node_1_Effect 11
playervar Node_2_Effect 12
playervar PurrBoost_AfterXrings_Counter 13

#Subroutine names

subroutine PurrBoostText 0
subroutine NodeEffects 2
subroutine NodePassSFX 4

#Activated extensions

#!extension buffStatusEffects
#!extension buffAndDebuffSounds
#!extension explosionSounds
#!extension projectiles


#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "Add to Racetrack":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Disabled
    
    Racetrack_Game.append(eventPlayer.getEyePosition())
    createIcon(getAllPlayers(), eventPlayer.getEyePosition(), Icon.ARROW_DOWN, IconReeval.VISIBILITY, Color.WHITE)


rule "Disable inspector":
    @Disabled
    
    disableInspector()


rule "Game Setup":
    setMatchTime(305)
    setObjectiveDescription(getAllPlayers(), "{0} Jetpack Cat Racing - Code 4KZZP".format(heroIcon(Hero.JETPACK_CAT)), HudReeval.VISIBILITY_AND_STRING)
    Racetrack_Game = []
    Lobby_High = []
    hudSubtext(getAllPlayers(), "Press {0} to use purr speed boost".format(inputBindingString(Button.ABILITY_2)), HudPosition.RIGHT, 0, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), "Hold {0} to restart".format(inputBindingString(Button.RELOAD)), HudPosition.RIGHT, 0, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING)
    hudSubtext(getAllPlayers(), "Hold {0} to change camera".format(inputBindingString(Button.INTERACT)), HudPosition.RIGHT, 0, Color.AQUA, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(getAllPlayers(), "Lobby Best: {0} by {1}".format(sorted(Lobby_High)[0], Lobby_Best), HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "Volskaya Industries":
    @Condition __getCurrentMap__() == Map.VOLSKAYA
    
    Starting = vect(-10.628, 9.626, 19.068)
    Racetrack_Game = [vect(-15.63, 7.184, 34.912), vect(-17.47, 5.118, 52.249), vect(-19.993, 8.754, 70.92), vect(-29.008, 12.611, 75.678), vect(-42.074, 13.11, 74.283), vect(-64.946, 5.527, 52.4), vect(-98.997, 4.859, 57.923), vect(-102.755, 4.638, 66.313), vect(-99.341, 4.866, 73.493), vect(-86.859, 4.544, 77.395), vect(-58.07, 4.933, 95.297), vect(-28.197, 5.602, 98.226), vect(-5.113, 0.097, 100.164), vect(20.514, -0.988, 101.062), vect(37.493, -1.373, 89.011), vect(39.523, -1.467, 69.684), vect(24.011, -0.609, 46.118), vect(0.426, 1.399, 25.545), vect(-16.476, 6.793, 28.745)]
    Racetrack_PerNode_Boost = len(Racetrack_Game) / 10


rule "Hanamura":
    @Condition __getCurrentMap__() == Map.HANAMURA
    
    Starting = vect(69.447, 13.709, 3.227)
    Racetrack_Game = [vect(55.31, 11.133, 9.266), vect(29.707, 8.628, 11.127), vect(5.313, 4.482, 2.078), vect(-4.063, 4.042, -8.343), vect(-17.38, 0.756, -17.216), vect(-26.126, 5.056, -50.521), vect(-26.721, 3.746, -67.521), vect(-20.674, 3.591, -76.343), vect(-0.854, 5.924, -82.08), vect(14.102, 6.337, -74.915), vect(28.236, 4.267, -60.297), vect(32.851, 4.951, -42.201), vect(25.275, 3.13, -30.573), vect(11.991, 2.447, -24.385), vect(16.174, 2.392, -6.394), vect(28.754, 3.516, -3.708), vect(39.216, 3.909, -11.624), vect(57.521, 1.663, -13.342), vect(67.34, 3.716, -5.188), vect(68.84, 6.15, 7.811)]
    Racetrack_PerNode_Boost = len(Racetrack_Game) / 12


rule "Hanamura Winter":
    @Condition __getCurrentMap__() == Map.HANAMURA_WINTER
    
    Starting = vect(69.447, 13.709, 3.227)
    Racetrack_Game = [vect(55.31, 11.133, 9.266), vect(29.707, 8.628, 11.127), vect(5.313, 4.482, 2.078), vect(-4.063, 4.042, -8.343), vect(-17.38, 0.756, -17.216), vect(-26.126, 5.056, -50.521), vect(-26.721, 3.746, -67.521), vect(-20.674, 3.591, -76.343), vect(-0.854, 5.924, -82.08), vect(14.102, 6.337, -74.915), vect(28.236, 4.267, -60.297), vect(32.851, 4.951, -42.201), vect(25.275, 3.13, -30.573), vect(11.991, 2.447, -24.385), vect(16.174, 2.392, -6.394), vect(28.754, 3.516, -3.708), vect(39.216, 3.909, -11.624), vect(57.521, 1.663, -13.342), vect(67.34, 3.716, -5.188), vect(68.84, 6.15, 7.811)]
    Racetrack_PerNode_Boost = len(Racetrack_Game) / 12


rule "Circuit Royale":
    @Condition __getCurrentMap__() == Map.CIRCUIT_ROYAL
    
    Starting = vect(-63.092, 19.061, -41.668)
    Racetrack_Game = [vect(-53.641, 13.536, -41.479), vect(-34.12, 10.55, -41.657), vect(-21.127, 9.304, -29.655), vect(-21.983, 8.472, -9.899), vect(-16.404, 8.064, 3.199), vect(-5.232, 8.553, 4.751), vect(6.568, 8.718, -4.389), vect(5.468, 13.841, -26.904), vect(15.007, 13.063, -38.756), vect(22.848, 16.548, -28.173), vect(29.165, 16.369, -12.011), vect(59.743, 16.456, -9.967), vect(64.545, 16.607, 3.808), vect(56.732, 15.231, 19.058), vect(66.289, 13.842, 33.599), vect(85.58, 14.877, 27.167), vect(105.15, 19.15, 23.557), vect(105.291, 19.53, 33.537), vect(95.396, 19.633, 43.823), vect(62.5, 21.121, 53.809), vect(41.806, 21.956, 48.069), vect(27.022, 22.607, 40.311), vect(11.481, 23.156, 31.769), vect(2.747, 26.388, 21.349), vect(-10.467, 19.309, 10.476), vect(-20.481, 21.853, -0.662), vect(-35.744, 26.195, -14.557), vect(-50.105, 20.578, -24.259), vect(-53.734, 14.237, -41.146)]
    Racetrack_PerNode_Boost = len(Racetrack_Game) / 10


rule "Dorado":
    @Condition __getCurrentMap__() == Map.DORADO
    
    Starting = vect(-3.321, 10.885, 4.219)
    Racetrack_Game = [vect(11.539, 3.979, 5.665), vect(29.67, 8.829, 2.197), vect(37.063, 18.143, -6.771), vect(41.682, 22.152, -12.468), vect(63.967, 24.868, -20.54), vect(81.002, 20.163, -6.788), vect(85.286, 22.485, 15.304), vect(92.147, 23.353, 30.175), vect(111.378, 24.212, 31.505), vect(139.042, 13.955, 27.63), vect(147.295, 13.668, 36.151), vect(163.354, 13.845, 43.972), vect(170.938, 14.481, 57.311), vect(184.013, 16.787, 50.442), vect(177.854, 21.545, 36.597), vect(155.333, 15.785, 24.958), vect(144.677, 14.299, 29.783), vect(121.855, 13.716, 19.711), vect(123.432, 12.799, -2.438), vect(95.706, 11.853, -20.531), vect(87.751, 11.855, -24.141), vect(72.063, 14.015, -14.382), vect(39.013, 8.085, -18.048), vect(14.574, 9.578, -11.385), vect(5.479, 9.258, -8.387), vect(4.818, 6.764, 2.715), vect(11.84, 4.351, 5.864)]
    Racetrack_PerNode_Boost = len(Racetrack_Game) / 14


rule "Rialto":
    @Condition __getCurrentMap__() == Map.RIALTO
    
    Starting = vect(107.775, 4.948, -21.257)
    Racetrack_Game = [vect(89.326, 5.411, -21.137), vect(71.471, 4.702, -21.43), vect(67.008, 5.814, -45.725), vect(44.204, 7.662, -66.725), vect(31.899, 8.255, -66.88), vect(9.724, 10.965, -77.426), vect(-12.113, 14.047, -77.773), vect(-30.532, 17.601, -74.886), vect(-39.011, 18.698, -86.257), vect(-56.925, 13.876, -102.818), vect(-57.185, 13.208, -130.562), vect(-47.071, 10.674, -140.276), vect(-47.138, 10.345, -147.479), vect(-66.938, 10.594, -145.932), vect(-66.076, 9.875, -136.463), vect(-66.183, 10.491, -124.363), vect(-57.134, 11.351, -119.526), vect(-57.629, 22.541, -80.334), vect(-51.595, 18.91, -64.204), vect(-34.973, 13.246, -49.913), vect(-21.252, 8.79, -42.706), vect(0.632, 1.365, -41.862), vect(13.474, 9.381, -46.529), vect(31.327, 12.855, -35.043), vect(43.825, 12.376, -11.256), vect(71.118, 5.898, 4.977), vect(86.217, 5.01, 7.733), vect(89.483, 5.984, -20.7)]
    Racetrack_PerNode_Boost = len(Racetrack_Game) / 10


rule "King's Row":
    @Condition __getCurrentMap__() == Map.KINGS_ROW
    
    Starting = vect(-4.057, 18.303, 16.517)
    Racetrack_Game = [vect(-6.018, 13.126, 1.408), vect(-8.498, 11.226, -24.786), vect(-17.804, 11.014, -34.361), vect(-30.674, 10.956, -33.545), vect(-39.323, 11.011, -35.114), vect(-63.381, 8.313, -33.252), vect(-82.484, 8.078, -40.765), vect(-97.055, 7.241, -10.747), vect(-117.459, 8.615, -4.016), vect(-133.072, 9.029, 9.203), vect(-147.825, 9.006, 11.021), vect(-148.448, 7.803, 19.239), vect(-141.217, 5.624, 23.962), vect(-118.972, 2.534, 18.772), vect(-123.793, 3.778, -2.206), vect(-99.89, 4.841, -9.863), vect(-90.618, 6.485, -22.572), vect(-83.162, 7.014, -24.805), vect(-69.482, 7.294, -20.787), vect(-60.382, 8.092, -32.04), vect(-48.309, 8.676, -33.428), vect(-38.042, 3.871, -24.814), vect(-23.43, 3.716, -28.183), vect(-11.984, 4.083, -29.041), vect(-8.094, 7.192, -18.804), vect(-5.964, 13.434, 1.557)]
    Racetrack_PerNode_Boost = len(Racetrack_Game) / 12


rule "King's Row Winter":
    @Condition __getCurrentMap__() == Map.KINGS_ROW_WINTER
    
    Starting = vect(-4.057, 18.303, 16.517)
    Racetrack_Game = [vect(-6.018, 13.126, 1.408), vect(-8.498, 11.226, -24.786), vect(-17.804, 11.014, -34.361), vect(-30.674, 10.956, -33.545), vect(-39.323, 11.011, -35.114), vect(-63.381, 8.313, -33.252), vect(-82.484, 8.078, -40.765), vect(-97.055, 7.241, -10.747), vect(-117.459, 8.615, -4.016), vect(-133.072, 9.029, 9.203), vect(-147.825, 9.006, 11.021), vect(-148.448, 7.803, 19.239), vect(-141.217, 5.624, 23.962), vect(-118.972, 2.534, 18.772), vect(-123.793, 3.778, -2.206), vect(-99.89, 4.841, -9.863), vect(-90.618, 6.485, -22.572), vect(-83.162, 7.014, -24.805), vect(-69.482, 7.294, -20.787), vect(-60.382, 8.092, -32.04), vect(-48.309, 8.676, -33.428), vect(-38.042, 3.871, -24.814), vect(-23.43, 3.716, -28.183), vect(-11.984, 4.083, -29.041), vect(-8.094, 7.192, -18.804), vect(-5.964, 13.434, 1.557)]
    Racetrack_PerNode_Boost = len(Racetrack_Game) / 12


rule "Eichenwalde":
    @Condition __getCurrentMap__() == Map.EICHENWALDE
    
    Starting = vect(-11.615, 8.374, -8.658)
    Racetrack_Game = [vect(-6.534, 11.063, -22.158), vect(6.604, 12.39, -26.837), vect(13.274, 15.076, -43.445), vect(19.241, 17.252, -54.811), vect(24.571, 19.93, -72.863), vect(59.198, 15.14, -93.575), vect(81.056, 16.497, -94.093), vect(88.621, 15.928, -75.294), vect(99.45, 15.176, -72.463), vect(101.066, 14.76, -60.344), vect(90.115, 15.358, -53.731), vect(94.862, 15.448, -41.956), vect(117.13, 15.339, -41.104), vect(126.556, 17.283, -35.436), vect(141.502, 17.556, -41.767), vect(135.197, 14.673, -62.632), vect(123.154, 14.383, -61.318), vect(110.442, 14.814, -58.905), vect(104.815, 14.874, -52.272), vect(103.576, 16.322, -42.237), vect(94.604, 16.86, -39.805), vect(90.293, 22.363, -59.57), vect(88.494, 22.147, -65.975), vect(82.16, 22.417, -70.058), vect(66.692, 21.795, -62.287), vect(56.935, 20.52, -56.573), vect(55.425, 19.752, -46.87), vect(52.489, 18.981, -37.864), vect(43.118, 16.907, -22.959), vect(30.33, 13.408, -12.461), vect(9.838, 10.638, -6.16), vect(-6.439, 11.471, -21.554)]
    Racetrack_PerNode_Boost = len(Racetrack_Game) / 20


rule "Eichenwalde Halloween":
    @Condition __getCurrentMap__() == Map.EICHENWALDE_HALLOWEEN
    
    Starting = vect(-11.615, 8.374, -8.658)
    Racetrack_Game = [vect(-6.534, 11.063, -22.158), vect(6.604, 12.39, -26.837), vect(13.274, 15.076, -43.445), vect(19.241, 17.252, -54.811), vect(24.571, 19.93, -72.863), vect(59.198, 15.14, -93.575), vect(81.056, 16.497, -94.093), vect(88.621, 15.928, -75.294), vect(99.45, 15.176, -72.463), vect(101.066, 14.76, -60.344), vect(90.115, 15.358, -53.731), vect(94.862, 15.448, -41.956), vect(117.13, 15.339, -41.104), vect(126.556, 17.283, -35.436), vect(141.502, 17.556, -41.767), vect(135.197, 14.673, -62.632), vect(123.154, 14.383, -61.318), vect(110.442, 14.814, -58.905), vect(104.815, 14.874, -52.272), vect(103.576, 16.322, -42.237), vect(94.604, 16.86, -39.805), vect(90.293, 22.363, -59.57), vect(88.494, 22.147, -65.975), vect(82.16, 22.417, -70.058), vect(66.692, 21.795, -62.287), vect(56.935, 20.52, -56.573), vect(55.425, 19.752, -46.87), vect(52.489, 18.981, -37.864), vect(43.118, 16.907, -22.959), vect(30.33, 13.408, -12.461), vect(9.838, 10.638, -6.16), vect(-6.439, 11.471, -21.554)]
    Racetrack_PerNode_Boost = len(Racetrack_Game) / 20


rule "Player Spawn":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.Racetrack = Racetrack_Game
    eventPlayer.PurrBoost_Effect = null
    eventPlayer.Racing = false
    eventPlayer.Base_SpeedBoost = 110
    eventPlayer.Timer = 0
    eventPlayer.High_Score = []
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.teleport(Starting)
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.Racetrack[0]), Relativity.TO_WORLD)
    hudHeader(eventPlayer, "Speed: {0} m/s".format(eventPlayer.getSpeed()), HudPosition.LEFT, 0, Color.WHITE, HudReeval.STRING_AND_COLOR)
    hudHeader(eventPlayer, "Time: {0}".format(eventPlayer.Timer), HudPosition.LEFT, 0.1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(eventPlayer, "Best Time: {0}".format(sorted(eventPlayer.High_Score)[0]), HudPosition.LEFT, 0.2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    createInWorldText(getAllPlayers(), "Best Time: {0}".format(sorted(eventPlayer.High_Score)[0]), updateEveryFrame(eventPlayer.getEyePosition() + vect(0, 0.5, 0)), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    eventPlayer.setMoveSpeed(eventPlayer.Base_SpeedBoost)


rule "Score":
    @Event eachPlayer
    @Condition distance(eventPlayer.Racetrack[0], eventPlayer.getEyePosition()) <= 3.5
    
    NodePassSFX()
    del eventPlayer.Racetrack[0]
    chaseAtRate(eventPlayer.Timer, 100000000, 1)
    eventPlayer.Racing = true
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setMoveSpeed(eventPlayer.Base_SpeedBoost)
    eventPlayer.Base_SpeedBoost += Racetrack_PerNode_Boost
    if not eventPlayer.isUsingAbility2():
        eventPlayer.PurrBoost_RingCounter++
        eventPlayer.PurrBoost_AfterXrings_Counter--
        if eventPlayer.PurrBoost_RingCounter > 2:
            eventPlayer.setAbility2Enabled(true)


rule "Track Finish":
    @Event eachPlayer
    @Condition eventPlayer.Racetrack == []
    
    eventPlayer.Racing = false
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    stopChasing(eventPlayer.Timer)
    bigMessage(eventPlayer, "Time: {0} {1}".format(eventPlayer.Timer, "(New Personal Best!)" if sorted(eventPlayer.High_Score)[0] == eventPlayer.Timer else ""))
    eventPlayer.High_Score.append(eventPlayer.Timer)
    eventPlayer.setAbility1Enabled(true)
    if eventPlayer.Timer == 0:
        goto lbl_0
    Lobby_High.append(eventPlayer.Timer)
    Lobby_Best = eventPlayer if sorted(Lobby_High)[0] == sorted(eventPlayer.High_Score)[0] else Lobby_Best
    lbl_0:
    eventPlayer.Base_SpeedBoost = 110
    eventPlayer.setMoveSpeed(eventPlayer.Base_SpeedBoost)


rule "Reset":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.PurrBoost_RingCounter = 0
    eventPlayer.teleport(Starting)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.Racetrack = Racetrack_Game
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.Racetrack[0]), Relativity.TO_WORLD)
    eventPlayer.Timer = 0
    stopChasing(eventPlayer.Timer)
    eventPlayer.Racing = false
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.Base_SpeedBoost = 110
    eventPlayer.setMoveSpeed(eventPlayer.Base_SpeedBoost)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.PurrBoost_AfterXrings_Counter = 3


rule "Change Camera":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    wait(0.234, Wait.ABORT_WHEN_FALSE)
    eventPlayer.Z = 1 if eventPlayer.Z == 0 else 0
    wait()
    if eventPlayer.Z == 1:
        smallMessage(eventPlayer, "Right Shoulder")
        eventPlayer.startCamera(updateEveryFrame(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(vect(-0.75, 0, 0), eventPlayer, Transform.ROTATION) + eventPlayer.getFacingDirection() * -4.3, null, eventPlayer, false) + ((directionTowards(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * -4.3 + worldVector(vect(-0.75, 0, 0), eventPlayer, Transform.ROTATION), null, eventPlayer, false), eventPlayer.getEyePosition() + worldVector(vect(-0.75, 0, 0), eventPlayer, Transform.ROTATION))) * 0.3)), updateEveryFrame(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 1000 + worldVector(vect(-0.75, 0, 0), eventPlayer, Transform.ROTATION)), 10000)
        wait(0.3, Wait.ABORT_WHEN_FALSE)
        smallMessage(eventPlayer, "Left Shoulder")
        eventPlayer.startCamera(updateEveryFrame(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(vect(0.75, 0, 0), eventPlayer, Transform.ROTATION) + eventPlayer.getFacingDirection() * -4.3, null, eventPlayer, false) + ((directionTowards(raycastHitPosition(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * -4.3 + worldVector(vect(0.75, 0, 0), eventPlayer, Transform.ROTATION), null, eventPlayer, false), eventPlayer.getEyePosition() + worldVector(vect(0.75, 0, 0), eventPlayer, Transform.ROTATION))) * 0.3)), updateEveryFrame(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 1000 + worldVector(vect(0.75, 0, 0), eventPlayer, Transform.ROTATION)), 10000)
    else:
        eventPlayer.stopCamera()


rule "PurrBoost Nano Effect 1":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility2() == true
    
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.WHITE, eventPlayer, 1)
    eventPlayer.Purrboost_NanoEffect_Target = (sorted(getLivingPlayers(eventPlayer.getTeam()).exclude(eventPlayer).filter(lambda x: isInLoS(eventPlayer.getEyePosition(), x.getEyePosition()) and distance(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), x.getEyePosition()), x.getEyePosition()) <= 2 and distance(eventPlayer, x) <= 40), lambda x: distance(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * distance(eventPlayer.getEyePosition(), x.getEyePosition()), x.getEyePosition())))[0]
    if entityExists(eventPlayer.Purrboost_NanoEffect_Target):
        goto lbl_0
    eventPlayer.Purrboost_NanoEffect_Target = eventPlayer
    lbl_0:
    wait(1, Wait.RESTART_WHEN_TRUE)
    eventPlayer.Purrboost_NanoEffect_Target = null


rule "PurrBoost Nano Effect 2":
    @Event eachPlayer
    @Condition getPlayers(eventPlayer.getTeam()).any(lambda player: player.Purrboost_NanoEffect_Target == eventPlayer) == true
    
    wait(0.128)
    destroyEffect(eventPlayer.Purrboost_NanoEffect_ID_Array[0])
    destroyEffect(eventPlayer.Purrboost_NanoEffect_ID_Array[1])
    createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED, Color.TEAM_1 if eventPlayer.getTeam() == Team.1 else Color.TEAM_2, eventPlayer, 1, EffectReeval.VISIBILITY)
    eventPlayer.Purrboost_NanoEffect_ID_Array[0] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED_SOUND, Color.WHITE, eventPlayer, 50, EffectReeval.VISIBILITY)
    eventPlayer.Purrboost_NanoEffect_ID_Array[1] = getLastCreatedEntity()
    waitUntil(getPlayers(eventPlayer.getTeam()).all(lambda player: player.Purrboost_NanoEffect_Target != eventPlayer), 99999)
    destroyEffect(eventPlayer.Purrboost_NanoEffect_ID_Array[0])
    destroyEffect(eventPlayer.Purrboost_NanoEffect_ID_Array[1])
    eventPlayer.Purrboost_NanoEffect_ID_Array = []


rule "Ability 1 Message":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.Racing == true
    
    wait(0.032, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "{0} Ability 1 is unavailable during races".format(abilityIconString(Hero.JETPACK_CAT, Button.ABILITY_1)))


rule "Ability 1 Disable When Racing":
    @Event eachPlayer
    @Condition eventPlayer.Racing == true
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(0.75)
    eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "PurrBoost Bind":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility2() == true
    
    playEffect(getAllPlayers(), DynamicEffect.PHARAH_CONCUSSIVE_BLAST_SOUND, Color.WHITE, eventPlayer, 200)
    createProjectileEffect(getAllPlayers(), Projectile.PHARAH_ROCKET, null, eventPlayer, eventPlayer.getFacingDirection(), 0.15, ProjectileEffectReeval.POSITION_DIRECTION_AND_SIZE)
    eventPlayer.PurrBoost_Effect = getLastCreatedEntity()
    eventPlayer.applyImpulse(eventPlayer.getThrottle(), 10, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.1)
    eventPlayer.applyImpulse(eventPlayer.getThrottle(), 20, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.1)
    eventPlayer.applyImpulse(eventPlayer.getThrottle(), 30, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.1)
    eventPlayer.applyImpulse(eventPlayer.getThrottle(), 40, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.1)
    eventPlayer.applyImpulse(eventPlayer.getThrottle(), 20, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.1)
    eventPlayer.applyImpulse(eventPlayer.getThrottle(), 10, Relativity.TO_PLAYER, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.1)
    destroyEffect(eventPlayer.PurrBoost_Effect)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.PurrBoost_RingCounter = 0
    eventPlayer.PurrBoost_AfterXrings_Counter = 3
    eventPlayer.cancelPrimaryAction()


def PurrBoostText():
    @Name "PurrBoost Text Loop"
    
    destroyHudText(eventPlayer.PurrBoost_Text)
    if eventPlayer.PurrBoost_AfterXrings_Counter >= 1:
        hudHeader(eventPlayer, "Purr Boost after {0} rings".format(eventPlayer.PurrBoost_AfterXrings_Counter), HudPosition.TOP, 0, Color.ROSE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.PurrBoost_Text = getLastCreatedText()
        waitUntil(eventPlayer.PurrBoost_AfterXrings_Counter <= 0, 99999)
        loop()
    elif eventPlayer.PurrBoost_AfterXrings_Counter <= 0 and not eventPlayer.isUsingAbility2():
        hudHeader(eventPlayer, "Purr Boost available", HudPosition.TOP, 0, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.PurrBoost_Text = getLastCreatedText()
        waitUntil(eventPlayer.isUsingAbility2(), 99999)
        loop()
    elif eventPlayer.isUsingAbility2():
        hudHeader(eventPlayer, "Purr Boost active", HudPosition.TOP, 0, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING)
        eventPlayer.PurrBoost_Text = getLastCreatedText()
        waitUntil(not eventPlayer.isUsingAbility2(), 99999)
        loop()


rule "Call PurrBoost Text Loop":
    @Event eachPlayer
    
    eventPlayer.PurrBoost_AfterXrings_Counter = 3
    PurrBoostText()


def NodeEffects():
    @Name "Racetrack Nodes Effects Loop"
    
    destroyEffect(eventPlayer.Node_1_Effect)
    destroyEffect(eventPlayer.Node_2_Effect)
    if eventPlayer.PurrBoost_RingCounter == 0:
        createEffect(eventPlayer if eventPlayer.Racetrack[0] != 0 else [], Effect.GOOD_AURA, Color.GREEN, eventPlayer.Racetrack[0], 2.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.Node_1_Effect = getLastCreatedEntity()
        createEffect(eventPlayer if eventPlayer.Racetrack[1] != 0 else [], Effect.GOOD_AURA, Color.WHITE, eventPlayer.Racetrack[1], 2.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.Node_2_Effect = getLastCreatedEntity()
        waitUntil(eventPlayer.PurrBoost_RingCounter != 0, 99999)
        loop()
    elif eventPlayer.PurrBoost_RingCounter == 1:
        createEffect(eventPlayer if eventPlayer.Racetrack[0] != 0 else [], Effect.GOOD_AURA, Color.GREEN, eventPlayer.Racetrack[0], 2.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.Node_1_Effect = getLastCreatedEntity()
        createEffect(eventPlayer if eventPlayer.Racetrack[1] != 0 else [], Effect.GOOD_AURA, Color.SKY_BLUE, eventPlayer.Racetrack[1], 2.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.Node_2_Effect = getLastCreatedEntity()
        waitUntil(eventPlayer.PurrBoost_RingCounter != 1, 99999)
        loop()
    else:
        createEffect(eventPlayer if eventPlayer.Racetrack[0] != 0 else [], Effect.GOOD_AURA, Color.SKY_BLUE, eventPlayer.Racetrack[0], 2.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.Node_1_Effect = getLastCreatedEntity()
        createEffect(eventPlayer if eventPlayer.Racetrack[1] != 0 else [], Effect.GOOD_AURA, Color.WHITE, eventPlayer.Racetrack[1], 2.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.Node_2_Effect = getLastCreatedEntity()
        waitUntil(eventPlayer.PurrBoost_RingCounter < 2, 99999)
        loop()


rule "Call Racetrack Nodes Effects Loop":
    @Event eachPlayer
    
    eventPlayer.PurrBoost_RingCounter = 0
    NodeEffects()


def NodePassSFX():
    @Name "Racetrack Node Pass Sounds"
    
    if eventPlayer.PurrBoost_AfterXrings_Counter <= 1:
        playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer, 150)
        playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getEyePosition(), 75)
    else:
        playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer, 150)


rule "Above 140 Move Speed % up until ~240 cat's booster starts slowing down...? fixed-ish in the most stupid way possible":
    @Event eachPlayer
    @Condition eventPlayer.Base_SpeedBoost >= 140
    
    eventPlayer.Base_SpeedBoost += 100
    eventPlayer.setMoveSpeed(eventPlayer.Base_SpeedBoost)


