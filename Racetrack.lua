local Detector = peripheral.wrap("player_detector_1")
local ChatBox = peripheral.wrap("chat_box_2")
local IsRace = false
local IsTraining = true
local IsQualifying = false

local PointA = {x = -4239, y = 50, z = -3658}
local PointB = {x = -3927, y = 80, z = -3122}

local Track = {
    StartX1 = -3980,
    StartX2 = -3959,
    StartY1 = 68,
    StartY2 = 71,
    StartZ1 = -3241,
    StartZ2 = -3237,
    sec1X1 = -4112,
    sec1X2 = -4104,
    sec1Y1 = 63,
    sec1Y2 = 66,
    sec1Z1 = -3361,
    sec1Z2 = -3346,
    sec2X1 = -4198,
    sec2X2 = -4181,
    sec2Y1 = 70,
    sec2Y2 = 73,
    sec2Z1 = -3492,
    sec2Z2 = -3498,
    bestLapTime = 0,
    bestsec1 = 0,
    bestsec2 = 0,
    bestsec3 = 0,
}

local players = Detector.getOnlinePlayers()
local playerData = {}

for i, name in ipairs(players) do
    playerData[i] = {
        Name = name,
        Online = true,
        X = 0,
        Y = 0,
        Z = 0,
        Lap = 0,
        LastTime = 0,
        Time = 0,
        currentLapTime = 0,
        bestLapTime = 0,
        lastLapTime = 0,
        sec1 = 0,
        bestsec1 = 0,
        sec2 = 0,
        bestsec2 = 0,
        sec3 = 0,
        bestsec3 = 0,
        wasAtStart = false,
        wasAtsec1 = false,
        wasAtsec2 = false,
        LapCompletet = false
    }
end

function UpdatePlayerPos(Name)
    Name.X = Detector.getPlayerPos(Name.Name).x
    Name.Y = Detector.getPlayerPos(Name.Name).y
    Name.Z = Detector.getPlayerPos(Name.Name).z
end

--[[Die Funktion ermittelt ob der  Spieler sich über die Ziellinie bewegt hat und erfasst damit, bei einer bereits getarteten Runde die Zeit für Sektor 3 und 
dann die gesamte Rundenzeit. es wird mit den Bestzeiten des individuellen Spielers verglichen ebenso mit der allgemeinen Bestzeit und jenachdem ausgegebn und  
gespeichert. zuletzt wird alles für die erfasung einer neuen Rundenzeit vorbereitet.
]]
function PlayerAtStart(Name)
    if Name.X >= Track.StartX1 and Name.X <= Track.StartX2 and Name.Y >= Track.StartY1 and Name.Y <= Track.StartY2 and Name.Z >= Track.StartZ1 and Name.Z <= Track.StartZ2 then
        Name.Time = os.time()
        if Name.wasAtStart and Name.wasAtsec1 and Name.wasAtsec2 then

            Name.sec3 = Name.Time - Name.LastTime
            if Name.sec3 < 0 then
                Name.sec3 = Name.sec3 + 24
            end

            --Überschreiben Sektor 3 Zeit wenn schneller und Ausgabe über Chatbox der Sektorzeit an Spieler oder alle
            if Name.sec3 < Name.bestsec3 or Name.bestsec3 == 0 then
                if Name.sec3 < Track.bestsec3 or Track.bestsec3 == 0 then
                    ChatBox.sendMessage(Name.Name .. " " .. Name.sec3,"Sec 3", "<>", "&5")
                else
                    ChatBox.sendMessageToPlayer(tostring(Name.sec3), Name.Name, "Sec 3", "<>", "&a") 
                end
            else
                ChatBox.sendMessageToPlayer(tostring(Name.sec3), Name.Name, "Sec 3", "<>", "&e")
            end

            Name.currentLapTime = Name.sec1 + Name.sec2 + Name.sec3

            if Name.currentLapTime < Name.bestLapTime or Name.bestLapTime == 0 then
                Name.bestLapTime = Name.currentLapTime
                Name.bestsec1 = Name.sec1
                Name.bestsec2 = Name.sec2
                Name.bestsec3 = Name.sec3
                if Name.bestsec1 < Track.bestsec1 or Track.bestsec1 == 0 then
                    Track.bestsec1 = Name.bestsec1
                end

                if Name.bestsec2 < Track.bestsec2 or Track.bestsec2 == 0 then
                    Track.bestsec2 = Name.bestsec2
                end

                if Name.bestsec3 < Track.bestsec3 or Track.bestsec3 == 0 then
                    Track.bestsec3 = Name.bestsec3
                end

                if Name.currentLapTime < Track.bestLapTime or Track.bestLapTime == 0 then
                    ChatBox.sendMessage(Name.Name .. " " .. Name.currentLapTime, "Lap", "<>", "&5")
                    Track.bestLapTime = Name.currentLapTime
                else
                    ChatBox.sendMessageToPlayer(tostring(Name.currentLapTime), Name.Name, "Lap","<>", "&a")
                end
            else
                ChatBox.sendMessageToPlayer(tostring(Name.currentLapTime), Name.Name, "Lap", "<>", "&e")
            end
        else if not Name.LapCompletet then
            ChatBox.sendMessageToPlayer("Invalid Round", Name.Name, "...", "<>", "&c")
        end
        end 
        Name.LastTime = Name.Time
        Name.lastLapTime = Name.currentLapTime
        Name.currentLapTime = 0
        Name.LapCompletet = true
        Name.wasAtStart = false
        Name.wasAtsec1 = false
        Name.wasAtsec2 = false
        Name.Lap = Name.Lap + 1
    end
end

--[[
Die Funktion ermittelt ob der Spieler sich über die Linie von Sektor 1 bewegt hat und erfasst damit die Zeit für Sektor 1, es wird mit den Bestzeiten des 
individuellen Spielers verglichen ebenso mit der allgemeinen Bestzeit und jenachdem ausgegeben.
]]
function PlayerAtSec1(Name)
    if not Name.wasAtsec1 then
        if Name.X >= ((0.533 * Name.Z) - 2326) and Name.X <= ((0.533 * Name.Z) - 2320) and Name.Y >= Track.sec1Y1 and Name.Y <= Track.sec1Y2 and Name.Z >= Track.sec1Z1 and Name.Z <= Track.sec1Z2 then
            if Name.LapCompletet then
                Name.Time = os.time()
                Name.sec1 = Name.Time - Name.LastTime
                if Name.sec1 < 0 then
                    Name.sec1 = Name.sec3 + 24
                end
                Name.currentLapTime = Name.currentLapTime + Name.sec1
                    -- Ausgabe der Sektorzeit über Chatbox an Spieler oder alle
                if Name.sec1 < Name.bestsec1 or Name.bestsec1 == 0 then
                    if Name.sec1 < Track.bestsec1  or Track.bestsec1 == 0 then
                        ChatBox.sendMessage(Name.Name .. " " .. Name.sec1, "Sec 1", "<>", "&5")
                    else
                        ChatBox.sendMessageToPlayer(tostring(Name.sec1), Name.Name, "Sec 1", "<>", "&a")
                    end
                else
                    ChatBox.sendMessageToPlayer(tostring(Name.sec1), Name.Name, "Sec 1", "<>", "&e")
                end

                Name.LastTime = Name.Time
                Name.wasAtsec1 = true
                Name.wasAtStart = true
                Name.LapCompletet = false
            else
                ChatBox.sendMessageToPlayer("Invalid Round", Name.Name, "...", "<>", "&c")
            end
        end
    end
end

function PlayerAtSec2(Name)
    if not Name.wasAtsec2 then
        if Name.X >= Track.sec2X1 and Name.X <= Track.sec2X2 and Name.Y >= Track.sec2Y1 and Name.Y <= Track.sec2Y2 and Name.Z >= ((-0.353 * Name.X) - 4979) and Name.Z <= ((-0.353 * Name.X) - 4973) then
            if Name.wasAtStart and Name.wasAtsec1 then
                Name.Time = os.time()
                Name.sec2 = Name.Time - Name.LastTime
                if Name.sec2 < 0 then
                    Name.sec2 = Name.sec3 + 24
                end
                Name.currentLapTime = Name.currentLapTime + Name.sec2
                    -- Ausgabe der Sektorzeit über Chatbox an Spieler oder alle
                if Name.sec2 < Name.bestsec2 or Name.bestsec2 == 0 then
                    if Name.sec2 < Track.bestsec2 or Track.bestsec2 == 0 then
                        ChatBox.sendMessage(Name.Name .. " " .. Name.sec2, "Sec 2", "<>", "&5")
                    else
                        ChatBox.sendMessageToPlayer(tostring(Name.sec2), Name.Name, "Sec 2", "<>", "&a")
                    end
                else
                    ChatBox.sendMessageToPlayer(tostring(Name.sec2), Name.Name, "Sec 2", "<>", "&e")
                end

                Name.LastTime = Name.Time
                Name.wasAtsec2 = true
            else
                ChatBox.sendMessageToPlayer("Invalid Round", Name.Name, "...", "<>", "&c")
            end
        end
    end
end

--Trainingsfunktion
while IsTraining do
    for i, _ in ipairs(playerData) do
        UpdatePlayerPos(playerData[i])
        PlayerAtStart(playerData[i])
        PlayerAtSec1(playerData[i])
        PlayerAtSec2(playerData[i])
        if Detector.getPlayersInCoords(PointA, PointB) == nil then
            IsTraining = false
        end
    end
end