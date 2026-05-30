Detector = peripheral.find("playerDetector")
ChatBox = peripheral.find("chatBox")
IsRace = false
IsTraining = false
IsQualifying = false

PointA = {x = 0, y = 0, z = 0}
PointB = {x = 0, y = 0, z = 0}

Track = {
    StartX1 = 0,
    StartX2 = 0,
    StartY1 = 0,
    StartY2 = 0,
    StartZ1 = 0,
    StartZ2 = 0,
    sec1X1 = 0,
    sec1X2 = 0,
    sec1Y1 = 0,
    sec1Y2 = 0,
    sec1Z1 = 0,
    sec1Z2 = 0,
    sec2X1 = 0,
    sec2X2 = 0,
    sec2Y1 = 0,
    sec2Y2 = 0,
    sec2Z1 = 0,
    sec2Z2 = 0,
    sec3X1 = 0,
    sec3X2 = 0,
    sec3Y1 = 0,
    sec3Y2 = 0,
    sec3Z1 = 0,
    sec3Z2 = 0,
    bestLapTime = 0,
    bestsec1 = 0,
    bestsec2 = 0,
    bestsec3 = 0,
}

XamYT = {
    Name = "XamYT",
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
}

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

            --Überschreiben Sektor 3 Zeit wenn schneller und Ausgabe über Chatbox der Sektorzeit an Spieler oder alle
            if Name.sec3 < Name.bestsec3 or Name.bestsec3 == 0 then
                if Name.sec3 < Track.bestsec3 then
                    ChatBox.sendMessage(Name.Name .. " " .. Name.sec3,"Sec 3", "<>", "&5")
                else
                    ChatBox.sendMessageToPlayer(Name.sec3, Name.Name, "Sec 3", "<>", "&a")
                end
            else
                ChatBox.sendMessageToPlayer(Name.sec3, Name.Name, "Sec 3", "<>", "&7")
            end

            Name.currentLapTime = Name.sec1 + Name.sec2 + Name.sec3

            -- Überschreiben der besten Lap Time wenn schneller und Ausgabe über Chatbox an Spieler oder alle
            if Name.currentLapTime < Name.bestLapTime or Name.bestLapTime == 0 then
                Name.bestLapTime = Name.currentLapTime
                Name.bestsec1 = Name.sec1
                Name.bestsec2 = Name.sec2
                Name.bestsec3 = Name.sec3
                if Name.currentLapTime < Track.bestLapTime then
                    Track.bestLapTime = Name.currentLapTime
                    Track.bestsec1 = Name.sec1
                    Track.bestsec2 = Name.sec2
                    Track.bestsec3 = Name.sec3
                    ChatBox.sendMessage(Name.Name .. " " .. Name.currentLapTime, "Lap", "<>", "&5")
                else
                    ChatBox.sendMessageToPlayer(Name.currentLapTime, Name.Name, "Lap","<>", "&a")
                end
            else
                ChatBox.sendMessageToPlayer(Name.currentLapTime, Name.Name, "Lap", "<>", "&7")
            end

        end
        Name.LastTime = Name.Time
        Name.lastLapTime = Name.currentLapTime
        Name.currentLapTime = 0
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
    if Name.X >= Track.sec1X1 and Name.X <= Track.sec1X2 and Name.Y >= Track.sec1Y1 and Name.Y <= Track.sec1Y2 and Name.Z >= Track.sec1Z1 and Name.Z <= Track.sec1Z2 then
        if Name.wasAtStart then
            Name.Time = os.time()
            Name.sec1 = Name.Time - Name.LastTime
            Name.currentLapTime = Name.currentLapTime + Name.sec1
                -- Ausgabe der Sektorzeit über Chatbox an Spieler oder alle
            if Name.sec1 < Name.bestsec1 or Name.bestsec1 == 0 then
                if Name.sec1 < Track.bestsec1 then
                    ChatBox.sendMessage(Name.Name .. " " .. Name.sec1, "Sec 1", "<>", "&5")
                else
                    ChatBox.sendMessageToPlayer(Name.sec1, Name.Name, "Sec 1", "<>", "&a")
                end
            else
                ChatBox.sendMessageToPlayer(Name.sec1, Name.Name, "Sec 1", "<>", "&7")
            end

            Name.LastTime = Name.Time
            Name.wasAtsec1 = true
        else
            ChatBox.sendMessageToPlayer("Invalid Round", Name.Name, "...", "<>", "&c")
        end
    end
end

function PlayerAtSec2(Name)
    if Name.X >= Track.sec2X1 and Name.X <= Track.sec2X2 and Name.Y >= Track.sec2Y1 and Name.Y <= Track.sec2Y2 and Name.Z >= Track.sec2Z1 and Name.Z <= Track.sec2Z2 then
        if Name.wasAtStart and Name.wasAtsec1 then
            Name.Time = os.time()
            Name.sec2 = Name.Time - Name.LastTime
            Name.currentLapTime = Name.currentLapTime + Name.sec2
                -- Ausgabe der Sektorzeit über Chatbox an Spieler oder alle
            if Name.sec2 < Name.bestsec2 or Name.bestsec2 == 0 then
                if Name.sec2 < Track.bestsec2 then
                    ChatBox.sendMessage(Name.Name .. " " .. Name.sec2, "Sec 2", "<>", "&5")
                else
                    ChatBox.sendMessageToPlayer(Name.sec2, Name.Name, "Sec 2", "<>", "&a")
                end
            else
                ChatBox.sendMessageToPlayer(Name.sec2, Name.Name, "Sec 2", "<>", "&7")
            end

            Name.LastTime = Name.Time
            Name.wasAtsec2 = true
        else
            ChatBox.sendMessageToPlayer("Invalid Round", Name.Name, "...", "<>", "&c")
        end
    end
end

--Trainingsfunktion
while IsTraining do
    UpdatePlayerPos(XamYT)
    PlayerAtStart(XamYT)
    PlayerAtSec1(XamYT)
    PlayerAtSec2(XamYT)
    if Detector.getPlayersInCoords(PointA, PointB) == nil then
        IsTraining = false
    end
end