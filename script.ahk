#Requires AutoHotkey v2.0
#SingleInstance Force
SetKeyDelay -1, -1
SendMode "Input"

; ==============================================================================
; SYSTEM CONFIGURATION
; ==============================================================================
; Increase timer precision to 1ms (important for music connectivity)
DllCall("Winmm\timeBeginPeriod", "UInt", 1)
; Set high process priority to avoid interruption by background tasks
ProcessSetPriority "High"

if !DirExist("Songs")
    DirCreate("Songs")

; ==============================================================================
; GLOBAL VARIABLES
; ==============================================================================
global StopPlaying := false
global IsPaused := false
global IsRunning := false
global IsOptimizedMode := false
global IsSeeking := false 
global GlobalEvents := [] 
global TotalDuration := 0 
global CurrentTimeMs := 0 
global StartTimeSystem := 0 

global EditCtrl, MaxTapesCtrl, SB, MyGui, BtnStart, BtnStop, BtnNext, BtnPrev
global CbSustain, CbIgnoreChords, CbMono, TransposeCtrl, InfoText, CbAutoNext
global ProgressSlider, TimeDisplay, SpeedCtrl
global DdlWindows, BtnRefreshWin, SongList
global GlobalTranspose := 0
global GlobalSpeed := 1.0 
global IsMiniMode := false
global GroupHide := []
global BtnMiniMode

AddHide(ctrl) {
    global GroupHide
    GroupHide.Push(ctrl)
    return ctrl
}
; ==============================================================================
; GUI INITIALIZATION
; ==============================================================================
MyGui := Gui("+AlwaysOnTop +MinimizeBox -Resize", "OverField Piano / Guitar Player")
MyGui.SetFont("s10", "Consolas") 
MyGui.OnEvent("Close", (*) => SaveAndExit())
MyGui.BackColor := "F0F0F0"

BtnMiniMode := MyGui.Add("Button", "x450 y5 w80 h20", "Mini Mode")
BtnMiniMode.SetFont("s8")
BtnMiniMode.OnEvent("Click", (*) => ToggleMiniMode())

; --- SECTION 1: LIBRARY + SOURCE ---
MyGui.SetFont("s10 bold")
AddHide(MyGui.Add("GroupBox", "x10 y10 w520 h180", " [1] LIBRARY + SOURCE "))
MyGui.SetFont("s10 norm")

AddHide(MyGui.Add("Text", "xp+15 yp+25", "Playlist (Folder 'Songs'):"))
SongList := AddHide(MyGui.Add("ListBox", "y+5 w190 h100 vSelectedSong"))
SongList.OnEvent("DoubleClick", (*) => LoadSongFromPlaylist())

; Playlist Navigation Buttons
BtnMoveUp := AddHide(MyGui.Add("Button", "x+2 yp w28 h49", "▲"))
BtnMoveUp.OnEvent("Click", (*) => MoveSongUp())
BtnMoveDown := AddHide(MyGui.Add("Button", "xp y+2 w28 h49", "▼"))
BtnMoveDown.OnEvent("Click", (*) => MoveSongDown())

BtnRefreshLib := AddHide(MyGui.Add("Button", "x25 y+5 w105 h28", "⟳ Refresh"))
BtnRefreshLib.OnEvent("Click", (*) => RefreshPlaylist())

BtnOpenFolder := AddHide(MyGui.Add("Button", "x+10 yp w105 h28", "📂 Open Dir"))
BtnOpenFolder.OnEvent("Click", (*) => Run("Songs"))

AddHide(MyGui.Add("Text", "x260 y35", "Manual Input / Preview:"))

BtnPaste := AddHide(MyGui.Add("Button", "y+5 w85 h28", "📋 Paste"))
BtnPaste.OnEvent("Click", (*) => PasteFromClipboard())

BtnClear := AddHide(MyGui.Add("Button", "x+5 yp w85 h28", "🗑️ Clear"))
BtnClear.OnEvent("Click", (*) => ClearData())

BtnExpand := AddHide(MyGui.Add("Button", "x260 y+5 w85 h28", "✏️ Edit"))
BtnExpand.OnEvent("Click", (*) => OpenJsonEditor())

BtnSaveSong := AddHide(MyGui.Add("Button", "x+5 yp w85 h28", "💾 Save"))
BtnSaveSong.OnEvent("Click", (*) => SaveSongToLibrary())

EditCtrl := AddHide(MyGui.Add("Edit", "x260 y+5 w260 h25 vJsonData -Wrap ReadOnly", ""))
InfoText := AddHide(MyGui.Add("Text", "x260 y+2 w260 r1 cBlue Right", "Waiting for data..."))

; --- SECTION 2: SETTINGS ---
MyGui.SetFont("s10 bold")
AddHide(MyGui.Add("GroupBox", "x10 y200 w520 h140", " [2] SETTINGS "))
MyGui.SetFont("s10 norm")

CbSustain := AddHide(MyGui.Add("Checkbox", "x30 yp+30 Checked", "Sustain"))
CbAutoNext := AddHide(MyGui.Add("Checkbox", "x130 yp", "Auto-Next"))
AddHide(MyGui.Add("Text", "x260 yp w100 Right", "Transpose:")) 
TransposeCtrl := AddHide(MyGui.Add("Edit", "x+10 yp-3 w60 Center", "0"))
AddHide(MyGui.Add("UpDown", "Range-24-24", 0))

CbIgnoreChords := AddHide(MyGui.Add("Checkbox", "x30 y+15 Checked", "No Chords"))
AddHide(MyGui.Add("Text", "x260 yp w100 Right", "Max Notes:")) 
MaxTapesCtrl := AddHide(MyGui.Add("Edit", "x+10 yp-3 w60 Number Center", "15"))
AddHide(MyGui.Add("UpDown", "Range1-50", 15))

CbMono := AddHide(MyGui.Add("Checkbox", "x30 y+15", "Mono Mode"))
CbMono.SetFont("bold cBlue")
AddHide(MyGui.Add("Text", "x260 yp w100 Right", "Speed:"))
SpeedCtrl := AddHide(MyGui.Add("Edit", "x+10 yp-2 w60 Number Center", "100"))
SpeedCtrl.OnEvent("Change", (*) => OnSpeedChange())
AddHide(MyGui.Add("UpDown", "Range10-500", 100))
AddHide(MyGui.Add("Text", "x+5 yp w20", "%"))

; --- SECTION 3: CONTROLS ---
MyGui.SetFont("s10 bold")
AddHide(MyGui.Add("GroupBox", "x10 y350 w520 h170", " [3] CONTROLS "))
MyGui.SetFont("s10 norm")

AddHide(MyGui.Add("Text", "xp+20 yp+25", "Target:"))

DdlWindows := AddHide(MyGui.Add("DropDownList", "x+10 yp-2 w320 vTargetWindow", ["(Unlocked - Any Window)"]))
DdlWindows.Choose(1)
DdlWindows.GetPos(,,,&ddlH) ; Get actual height to align the button next to it

BtnRefreshWin := AddHide(MyGui.Add("Button", "x+5 yp w40 h" . ddlH, "🗘"))
BtnRefreshWin.OnEvent("Click", (*) => RefreshWindowList())

MyGui.SetFont("s14 bold")
TimeDisplay := MyGui.Add("Text", "x20 y+15 w500 Center c2F4F4F", "00:00 / 00:00")
MyGui.SetFont("s10 norm")

ProgressSlider := MyGui.Add("Slider", "x20 y+5 w500 Range0-100 ToolTip NoTicks", 0)
ProgressSlider.OnEvent("Change", (*) => OnSeek())

BtnStart := MyGui.Add("Button", "x20 y+15 w150 h45", "▶ START (F4)")
BtnStart.SetFont("bold s12")
BtnStart.OnEvent("Click", (*) => TogglePlayPause())

BtnPrev := MyGui.Add("Button", "x+5 w105 h45", "← PREV (^Left)")
BtnPrev.SetFont("bold s9")
BtnPrev.OnEvent("Click", (*) => PrevSong())

BtnNext := MyGui.Add("Button", "x+5 w105 h45", "→ NEXT (^Right)")
BtnNext.SetFont("bold s9")
BtnNext.OnEvent("Click", (*) => SkipSong())

BtnStop := MyGui.Add("Button", "x+5 w105 h45", "■ STOP (F8)")
BtnStop.SetFont("bold s10")
BtnStop.OnEvent("Click", (*) => StopMusic())

SB := AddHide(MyGui.Add("StatusBar",, " Ready."))

; Save positions for restore
global MiniModeSavedPos := Map()
TimeDisplay.GetPos(&ox, &oy, &ow, &oh)
MiniModeSavedPos["Time"] := {x:ox, y:oy, w:ow, h:oh}
ProgressSlider.GetPos(&ox, &oy, &ow, &oh)
MiniModeSavedPos["Slider"] := {x:ox, y:oy, w:ow, h:oh}
BtnStart.GetPos(&ox, &oy, &ow, &oh)
MiniModeSavedPos["Start"] := {x:ox, y:oy, w:ow, h:oh}
BtnStop.GetPos(&ox, &oy, &ow, &oh)
MiniModeSavedPos["Stop"] := {x:ox, y:oy, w:ow, h:oh}
BtnNext.GetPos(&ox, &oy, &ow, &oh)
MiniModeSavedPos["Next"] := {x:ox, y:oy, w:ow, h:oh}
BtnPrev.GetPos(&ox, &oy, &ow, &oh)
MiniModeSavedPos["Prev"] := {x:ox, y:oy, w:ow, h:oh}
SB.SetParts(350, 170)

; Load Initial Data
RefreshWindowList()
RefreshPlaylist()
LoadSettings()

MyGui.Show("w540 h560")

; ==============================================================================
; PLAYLIST MANAGEMENT
; ==============================================================================

RefreshPlaylist() {
    SongList.Delete()
    count := 0
    Loop Files, "Songs\*.json" {
        SongList.Add([A_LoopFileName])
        count++
    }
    Loop Files, "Songs\*.txt" {
        SongList.Add([A_LoopFileName])
        count++
    }
    UpdateStatus("📂 Library refreshed: " . count . " songs.", 1)
}

LoadSongFromPlaylist() {
    selected := SongList.Text
    if (selected == "")
        return
        
    filePath := "Songs\" . selected
    try {
        fileContent := FileRead(filePath)
        EditCtrl.Value := fileContent
        UpdateStatus("📂 Loaded: " . selected, 1)
        AnalyzeOnly()
    } catch as err {
        MsgBox("Error reading file: " . err.Message, "Error", "4096 Icon!")
    }
}

; Use SendMessage to manipulate ListBox directly (LB_INSERTSTRING = 0x0181)
; because AHK v2 ListBox has no native Insert() method.
MoveSongUp() {
    idx := SongList.Value 
    if (idx <= 1) 
        return
    
    txt := SongList.Text
    SongList.Delete(idx)
    SendMessage(0x0181, idx - 2, StrPtr(txt), SongList.Hwnd)
    SongList.Choose(idx - 1)
}

MoveSongDown() {
    idx := SongList.Value
    items := ControlGetItems(SongList.Hwnd)
    count := items.Length
    
    if (idx == 0 || idx == count) 
        return
        
    txt := SongList.Text
    SongList.Delete(idx)
    SendMessage(0x0181, idx, StrPtr(txt), SongList.Hwnd)
    SongList.Choose(idx + 1)
}

SaveSongToLibrary() {
    jsonStr := EditCtrl.Value
    if (jsonStr = "") {
        MsgBox("No content to save! Please paste JSON first.", "Warning", "4096 Icon!")
        return
    }

    SaveGui := Gui("+Owner" . MyGui.Hwnd . " +AlwaysOnTop -MinimizeBox", "Save to Library")
    SaveGui.SetFont("s10", "Segoe UI")
    
    SaveGui.Add("Text", "x10 y10 w300", "Enter song name:")
    NameEdit := SaveGui.Add("Edit", "x10 y+5 w300 h30")
    NameEdit.SetFont("s10", "Consolas")
    
    BtnConfirm := SaveGui.Add("Button", "x10 y+15 w145 h35 Default", "💾 Save")
    BtnConfirm.OnEvent("Click", (*) => ProcessSave(NameEdit.Value, SaveGui))
    
    BtnCancel := SaveGui.Add("Button", "x+10 yp w145 h35", "❌ Cancel")
    BtnCancel.OnEvent("Click", (*) => SaveGui.Destroy())
    
    SaveGui.OnEvent("Escape", (*) => SaveGui.Destroy())
    SaveGui.Show()

    ProcessSave(fileName, guiObj) {
        if (fileName == "") {
            MsgBox("Please enter a name.", "Warning", "4096 Icon!")
            return
        }
        ; Remove invalid characters in Windows filenames
        fileName := RegExReplace(fileName, '[\\/:*?"<>|]', "")
        if !InStr(fileName, ".json") && !InStr(fileName, ".txt")
            fileName .= ".json"
        filePath := "Songs\" . fileName

        if FileExist(filePath) {
            res := MsgBox("File '" . fileName . "' already exists.`nOverwrite?", "Confirm", "YesNo 4096 Icon?")
            if (res = "No")
                return
            FileDelete(filePath)
        }

        try {
            FileAppend(jsonStr, filePath, "UTF-8")
            UpdateStatus("💾 Saved: " . fileName, 1)
            RefreshPlaylist()
            guiObj.Destroy()
        } catch as err {
            MsgBox("Save failed: " . err.Message, "Error", "4096 Icon!")
        }
    }
}

; ==============================================================================
; SETTINGS MANAGEMENT (INI FILE)
; ==============================================================================

SaveAndExit() {
    try {
        IniWrite(MaxTapesCtrl.Value, "config.ini", "Settings", "MaxNotes")
        IniWrite(SpeedCtrl.Value, "config.ini", "Settings", "Speed")
        IniWrite(TransposeCtrl.Value, "config.ini", "Settings", "Transpose")
        
        IniWrite(CbSustain.Value, "config.ini", "Settings", "Sustain")
        IniWrite(CbIgnoreChords.Value, "config.ini", "Settings", "NoChords")
        IniWrite(CbMono.Value, "config.ini", "Settings", "Mono")
        IniWrite(CbAutoNext.Value, "config.ini", "Settings", "AutoNext")
    }
    ExitApp()
}

LoadSettings() {
    if !FileExist("config.ini")
        return

    try {
        mn := IniRead("config.ini", "Settings", "MaxNotes", 15)
        sp := IniRead("config.ini", "Settings", "Speed", 100)
        tp := IniRead("config.ini", "Settings", "Transpose", 0)
        
        sus := IniRead("config.ini", "Settings", "Sustain", 1)
        nc := IniRead("config.ini", "Settings", "NoChords", 1)
        mo := IniRead("config.ini", "Settings", "Mono", 0)
        an := IniRead("config.ini", "Settings", "AutoNext", 0)

        MaxTapesCtrl.Value := mn
        SpeedCtrl.Value := sp
        OnSpeedChange()
        
        TransposeCtrl.Value := tp
        GlobalTranspose := Number(tp)
        
        CbSustain.Value := sus
        CbIgnoreChords.Value := nc
        CbMono.Value := mo
        CbAutoNext.Value := an
        
        UpdateStatus("⚙️ Settings loaded.", 1)
    }
}

; ==============================================================================
; GUI HELPER FUNCTIONS
; ==============================================================================

OpenJsonEditor() {
    global EditCtrl
    JsonGui := Gui("+Owner" . MyGui.Hwnd . " +AlwaysOnTop", "JSON Editor")
    JsonGui.SetFont("s10", "Consolas")
    JsonGui.Add("Text",, "Paste or Edit JSON here:")
    BigEdit := JsonGui.Add("Edit", "xm y+5 w600 h400 Multi HScroll VScroll")
    try {
        BigEdit.Value := EditCtrl.Value
    } catch {
        BigEdit.Value := ""
    }
    BtnSave := JsonGui.Add("Button", "xm w295 h40", "Save & Close")
    BtnSave.SetFont("bold")
    BtnSave.OnEvent("Click", (*) => SaveJson(BigEdit.Value, JsonGui))
    BtnCancel := JsonGui.Add("Button", "x+10 w295 h40", "Cancel")
    BtnCancel.OnEvent("Click", (*) => JsonGui.Destroy())
    JsonGui.Show()
}

SaveJson(content, guiObj) {
    EditCtrl.Value := content
    guiObj.Destroy()
    UpdateStatus("✅ Data Updated.", 1)
    AnalyzeOnly()
}

PasteFromClipboard() {
    if !A_Clipboard {
        UpdateStatus("⚠️ Clipboard Empty!", 1)
        return
    }
    EditCtrl.Value := A_Clipboard
    UpdateStatus("✅ Data Pasted.", 1)
    AnalyzeOnly()
}

ClearData() {
    EditCtrl.Value := ""
    UpdateStatus("🗑️ Data Cleared.", 1)
    InfoText.Text := "Waiting for data..."
    InfoText.Opt("cBlue")
    TransposeCtrl.Value := 0
    IsOptimizedMode := false
    ResetProgress()
}

UpdateStatus(statusText, part := 1) {
    SB.SetText(statusText, part)
}

ResetProgress() {
    ProgressSlider.Value := 0
    TimeDisplay.Text := "00:00 / 00:00"
    TotalDuration := 0
    CurrentTimeMs := 0
}

FormatTimeMs(ms) {
    seconds := Floor(ms / 1000)
    mins := Floor(seconds / 60)
    secs := Mod(seconds, 60)
    return Format("{:02}:{:02}", mins, secs)
}

RefreshWindowList() {
    Wins := ["(Unlocked - Any Window)"]
    ids := WinGetList()
    for this_id in ids {
        try {
            this_title := WinGetTitle(this_id)
            if (this_title != "" && this_title != "Program Manager" && this_title != "Start" && !InStr(this_title, "OverField Piano"))
                Wins.Push(this_title)
        }
    }
    DdlWindows.Delete()
    DdlWindows.Add(Wins)
    DdlWindows.Choose(1)
    UpdateStatus("🔄 Window list refreshed.", 1)
}

OnSpeedChange() {
    global GlobalSpeed, SpeedCtrl, StartTimeSystem, CurrentTimeMs, IsRunning, IsPaused
    try {
        val := Number(SpeedCtrl.Value)
        if (val <= 0)
            return
        GlobalSpeed := val / 100
    } catch {
        return
    }
    
    if (IsRunning && !IsPaused) {
        ; Recalculate system timestamp when changing speed to prevent skipping
        StartTimeSystem := A_TickCount - (CurrentTimeMs / GlobalSpeed)
    }
}

OnSeek() {
    global IsSeeking, CurrentTimeMs, TotalDuration, IsRunning
    if (TotalDuration <= 0)
        return
    IsSeeking := true
    percent := ProgressSlider.Value
    CurrentTimeMs := Floor((percent / 100) * TotalDuration)
    TimeDisplay.Text := FormatTimeMs(CurrentTimeMs) . " / " . FormatTimeMs(TotalDuration)
    if (!IsRunning) {
        IsSeeking := false
        return
    }
    ReleaseAllKeys()
}

; ==============================================================================
; PLAYBACK CONTROL LOGIC
; ==============================================================================

TogglePlayPause() {
    global IsRunning, IsPaused, BtnStart
    if (!IsRunning) {
        StartMusic()
    } else {
        if (IsPaused) {
            IsPaused := false
            BtnStart.Text := " PAUSE (F4)"
            UpdateStatus("▶ Playing...", 1)
            ToolTip("▶ RESUME")
            SetTimer () => ToolTip(), -1000
        } else {
            IsPaused := true
            BtnStart.Text := "▶ RESUME (F4)"
            UpdateStatus("⏸ Paused", 1)
            ToolTip("⏸ PAUSED")
            ReleaseAllKeys()
        }
    }
}

StartMusic() {
    global StopPlaying, IsPaused, IsRunning, EditCtrl, GlobalTranspose, MaxTapesCtrl, CbMono, BtnStart, TransposeCtrl, IsOptimizedMode
    global GlobalEvents, TotalDuration, CurrentTimeMs, GlobalSpeed, DdlWindows
    
    jsonStr := EditCtrl.Value
    if (jsonStr = "") {
        InfoText.Text := "⚠️ NO DATA!"
        InfoText.Opt("cRed")
        SetTimer () => (InfoText.Text == "⚠️ NO DATA!" ? InfoText.Text := "Waiting for data..." : ""), -2000
        return
    }

    StopPlaying := false
    IsPaused := false
    IsRunning := true
    IsOptimizedMode := false
    IsSeeking := false
    
    BtnStart.Text := "⏸ PAUSE (F4)"
    
    RawNotes := PrepareRawNotes(jsonStr)
    if (RawNotes = "") {
        ResetUI()
        return
    }

    Analysis := AnalyzeInternal(RawNotes)
    
    ; Warning Thresholds: <80% fit OR >2000 notes
    if (Analysis.FitPercent < 80 || Analysis.TotalNotes > 2000) {
        durSec := Analysis.DurationMs / 1000
        nps := durSec > 0 ? Round(Analysis.TotalNotes / durSec, 2) : 0
        durStr := FormatTimeMs(Analysis.DurationMs)
        
        Msg := "⚠️ COMPLEX SONG DETECTED!`n`n"
             . "🎵 Total Notes: " . Analysis.TotalNotes . "`n"
             . "⏱ Duration: " . durStr . "`n"
             . "⚡ Speed (NPS): " . nps . " notes/sec`n"
             . "🎹 Key Fit: " . Analysis.FitPercent . "%`n`n"
             . "This song might lag or skip notes.`n"
             . "Enable 'Smart Optimization' to fix this?"
             
        Result := MsgBox(Msg, "Performance Warning", "YesNo 4096 Icon!")
        if (Result == "Yes") {
            IsOptimizedMode := true
            UpdateStatus("🚀 Optimization Enabled!", 1)
        }
    }

    try {
        GlobalTranspose := Number(TransposeCtrl.Value)
    } catch {
        GlobalTranspose := 0
    }

    if (CbMono.Value) {
        RawNotes := ApplyPolyphonyLimit(RawNotes, 1)
    } else {
        Limit := IsOptimizedMode ? 10 : Number(MaxTapesCtrl.Value)
        if (Limit > 0)
            RawNotes := ApplyPolyphonyLimit(RawNotes, Limit)
    }

    GlobalEvents := ConvertToEventArray(RawNotes)
    
    if (GlobalEvents.Length > 0)
        TotalDuration := GlobalEvents[GlobalEvents.Length].Time
    else
        TotalDuration := 0
        
    CurrentTimeMs := 0
    ProgressSlider.Value := 0
    TimeDisplay.Text := "00:00 / " . FormatTimeMs(TotalDuration)

    TargetTitle := DdlWindows.Text
    if (TargetTitle != "(Unlocked - Any Window)") {
        if !WinExist(TargetTitle) {
            MsgBox("Window not found: " . TargetTitle, "Error", "4096 Icon!")
            ResetUI()
            return
        }
        WinActivate(TargetTitle)
    }

    Loop 3 {
        if (StopPlaying) {
            ResetUI()
            UpdateStatus("Cancelled.")
            return
        }
        UpdateStatus("⏳ Starting in " . (4 - A_Index) . "s")
        ToolTip("=== GET READY ===`nStarting in: " . (4 - A_Index) . "s")
        Sleep 1000
    }
    
    ToolTip() 
    StatusMsg := "🎶 Playing... (TP: " . GlobalTranspose . ")"
    if (IsOptimizedMode)
        StatusMsg .= " [OPT]"
    UpdateStatus(StatusMsg, 1)

    PlayEventsArray()
    
    ReleaseAllKeys()
    ResetUI()
    
    if (!StopPlaying) {
        UpdateStatus("✅ Finished.")
        ProgressSlider.Value := 100
        TimeDisplay.Text := FormatTimeMs(TotalDuration) . " / " . FormatTimeMs(TotalDuration)
        
        if (CbAutoNext.Value) {
            SetTimer PlayNextSong, -1000 ; Wait 1s then play next
        }
    }
}

PlayNextSong() {
    global SongList, BtnStart
    idx := SongList.Value
    items := ControlGetItems(SongList.Hwnd)
    if (idx < items.Length) {
        SongList.Choose(idx + 1)
        LoadSongFromPlaylist()
        StartMusic()
    } else {
        UpdateStatus("🏁 Playlist Ended.")
    }
}

PlayPrevSong() {
    global SongList, BtnStart
    idx := SongList.Value
    if (idx > 1) {
        SongList.Choose(idx - 1)
        LoadSongFromPlaylist()
        StartMusic()
    } else {
        UpdateStatus("⚠️ Top of Playlist.")
    }
}

SkipSong() {
    global IsRunning, StopPlaying
    if (IsRunning) {
        StopMusic()
        Sleep 200 ; Short wait to ensure clear state
    }
    PlayNextSong()
}

PrevSong() {
    global IsRunning, StopPlaying
    if (IsRunning) {
        StopMusic()
        Sleep 200
    }
    PlayPrevSong()
}

StopMusic() {
    global StopPlaying, IsPaused
    StopPlaying := true
    IsPaused := false 
    ResetUI()
    UpdateStatus("⏹ STOPPED")
    ToolTip()
    ReleaseAllKeys()
}

ResetUI() {
    global IsRunning, BtnStart
    IsRunning := false
    BtnStart.Text := "▶ START (F4)"
}

ReleaseAllKeys() {
    Keys := ["1","2","3","4","5","6","7","q","w","e","r","t","y","u","a","s","d","f","g","h","j","z","x","c","v","b","n","m"]
    for k in Keys {
        if GetKeyState(k)
            Send "{" . k . " up}"
    }
}

; ==============================================================================
; CORE MUSIC LOGIC
; ==============================================================================

ConvertToEventArray(rawNoteString) {
    TempStr := ""
    Loop Parse, rawNoteString, "`n", "`r" {
        if (A_LoopField = "")
            continue
        parts := StrSplit(A_LoopField, "|")
        StartTime := Number(parts[1])
        Duration  := Number(parts[2])
        Midi      := Number(parts[3])
        EndTime := StartTime + Duration
        
        TempStr .= Format("{:010.0f}", StartTime) . "|" . Midi . "|1`n"
        TempStr .= Format("{:010.0f}", EndTime)   . "|" . Midi . "|0`n"
    }
    SortedStr := Sort(TempStr, "N")
    
    EventArr := []
    Loop Parse, SortedStr, "`n", "`r" {
        if (A_LoopField = "")
            continue
        parts := StrSplit(A_LoopField, "|")
        EventArr.Push({Time: Number(parts[1]), Midi: Number(parts[2]), Type: Number(parts[3])})
    }
    return EventArr
}

PlayEventsArray() {
    global StopPlaying, IsPaused, GlobalTranspose, CbSustain, IsOptimizedMode
    global GlobalEvents, TotalDuration, CurrentTimeMs, IsSeeking, ProgressSlider, TimeDisplay
    global GlobalSpeed, StartTimeSystem, DdlWindows
    
    if (GlobalEvents.Length == 0)
        return

    StartIndex := 1
    Loop GlobalEvents.Length {
        if (GlobalEvents[A_Index].Time >= CurrentTimeMs) {
            StartIndex := A_Index
            break
        }
    }
    
    StartTimeSystem := A_TickCount - (CurrentTimeMs / GlobalSpeed)
    LastGuiUpdate := 0
    UseSustain := CbSustain.Value
    TargetTitle := DdlWindows.Text
    
    i := StartIndex
    while (i <= GlobalEvents.Length) {
        if (StopPlaying)
            return

        ; Auto-Pause logic when game window loses focus
        if (TargetTitle != "(Unlocked - Any Window)") {
            if (!WinActive(TargetTitle)) {
                WaitStart := A_TickCount
                UpdateStatus("⏸ Waiting for game window...", 1)
                ReleaseAllKeys()
                while (!WinActive(TargetTitle) && !StopPlaying) {
                    Sleep 100
                }
                StartTimeSystem += (A_TickCount - WaitStart)
                UpdateStatus("▶ Game active! Resuming...", 1)
            }
        }

        if (IsSeeking) {
            IsSeeking := false 
            Loop GlobalEvents.Length {
                if (GlobalEvents[A_Index].Time >= CurrentTimeMs) {
                    i := A_Index
                    break
                }
            }
            StartTimeSystem := A_TickCount - (CurrentTimeMs / GlobalSpeed)
            continue 
        }

        if (IsPaused) {
            PauseStart := A_TickCount
            while (IsPaused && !StopPlaying && !IsSeeking) {
                DllCall("Sleep", "UInt", 50)
            }
            StartTimeSystem += (A_TickCount - PauseStart)
            if (IsSeeking)
                continue
        }

        Event := GlobalEvents[i]
        TargetTime := Event.Time
        
        if (A_TickCount - LastGuiUpdate > 200) {
            CurrentTimeMs := (A_TickCount - StartTimeSystem) * GlobalSpeed
            if (TotalDuration > 0) {
                val := (CurrentTimeMs / TotalDuration) * 100
                ProgressSlider.Value := (val > 100) ? 100 : val
                TimeDisplay.Text := FormatTimeMs(CurrentTimeMs) . " / " . FormatTimeMs(TotalDuration)
            }
            LastGuiUpdate := A_TickCount
        }

        PlayAt := StartTimeSystem + (TargetTime / GlobalSpeed)
        
        ; Hybrid Wait Loop: Combine Sleep and Busy Wait for high precision
        while (A_TickCount < PlayAt) {
            if (StopPlaying || IsSeeking || IsPaused)
                break
            
            if (TargetTitle != "(Unlocked - Any Window)" && !WinActive(TargetTitle))
                break 
            
            Remaining := PlayAt - A_TickCount
            if (Remaining > 15) {
                DllCall("Sleep", "UInt", 1) 
            } 
        }
        
        if (StopPlaying)
            return
        if (IsSeeking || IsPaused)
            continue 
        
        if (TargetTitle != "(Unlocked - Any Window)" && !WinActive(TargetTitle))
            continue

        FinalMidi := Event.Midi + GlobalTranspose
        Key := GetKeyFromMidi(FinalMidi)
        
        if (Key != "") {
            if (UseSustain) {
                if (Event.Type == 1)
                    Send "{" . Key . " down}"
                else
                    Send "{" . Key . " up}"
            } else {
                if (Event.Type == 1)
                    Send "{" . Key . "}"
            }
        }
        
        i++ 
    }
}

GetKeyFromMidi(midi) {
    global CbIgnoreChords, IsOptimizedMode
    
    if (IsOptimizedMode) {
        while (midi < 48)
            midi += 12
        while (midi > 83)
            midi -= 12
    } else {
        while (midi < 36)
            midi += 12
        while (midi > 96)
            midi -= 12
    }
        
    static KeyMap := Map(
        48,"a", 50,"s", 52,"d", 53,"f", 55,"g", 57,"h", 59,"j",
        60,"q", 62,"w", 64,"e", 65,"r", 67,"t", 69,"y", 71,"u",
        72,"1", 74,"2", 76,"3", 77,"4", 79,"5", 81,"6", 83,"7"
    )
    
    if (!CbIgnoreChords.Value) {
        if (midi == 36) ; C2
            return "z"
        if (midi == 38) ; D2
            return "x"
        if (midi == 40) ; E2
            return "c"
        if (midi == 41) ; F2
            return "v"
        if (midi == 43) ; G2
            return "b"
        if (midi == 45) ; A2
            return "n"
        if (midi == 47) ; B2
            return "m"
    }
    
    if KeyMap.Has(midi)
        return KeyMap[midi]
        
    return ""
}

PrepareRawNotes(jsonString) {
    global SB
    try {
        html := ComObject("HTMLFile")
        html.write("<meta http-equiv='X-UA-Compatible' content='IE=9'>")
        JS := html.parentWindow
        jsonObj := JS.JSON.parse(jsonString)
        
        NoteList := ""
        TrackCount := 0
        
        tracks := jsonObj.tracks
        Loop tracks.length {
            track := tracks.%A_Index-1%
            if (track.instrument.family == "drums" || track.name == "DRUMS")
                continue
            TrackCount++
            notes := track.notes
            Loop notes.length {
                note := notes.%A_Index-1%
                timeMs := note.time * 1000
                durMs  := note.duration * 1000
                if (durMs < 10) 
                    durMs := 10
                NoteList .= Format("{:010.0f}", timeMs) . "|" . Format("{:010.0f}", durMs) . "|" . note.midi . "`n"
            }
        }
        SB.SetText("Tracks: " . TrackCount, 2)
        return Sort(NoteList, "N")
    } catch as err {
        UpdateStatus("❌ Invalid JSON!", 1)
        return ""
    }
}

ApplyPolyphonyLimit(noteString, limit) {
    if (limit <= 0)
        return noteString
    NewNoteList := ""
    CurrentTime := -1
    Buffer := [] 
    Loop Parse, noteString, "`n", "`r" {
        if (A_LoopField = "")
            continue
        parts := StrSplit(A_LoopField, "|")
        Time := Number(parts[1])
        if (Time != CurrentTime) {
            if (Buffer.Length > 0) {
                NewNoteList .= ProcessBuffer(Buffer, limit)
                Buffer := []
            }
            CurrentTime := Time
        }
        Buffer.Push(A_LoopField)
    }
    if (Buffer.Length > 0)
        NewNoteList .= ProcessBuffer(Buffer, limit)
    return NewNoteList
}

ProcessBuffer(arrLines, limit) {
    if (arrLines.Length <= limit) {
        res := ""
        for line in arrLines
            res .= line . "`n"
        return res
    }
    ParsedBuffer := []
    for line in arrLines {
        parts := StrSplit(line, "|")
        ParsedBuffer.Push({full: line, midi: Number(parts[3])})
    }
    
    Loop ParsedBuffer.Length {
        i := A_Index
        Loop ParsedBuffer.Length - i {
            j := A_Index + i
            if (ParsedBuffer[i].midi < ParsedBuffer[j].midi) { 
                temp := ParsedBuffer[i]
                ParsedBuffer[i] := ParsedBuffer[j]
                ParsedBuffer[j] := temp
            }
        }
    }
    
    res := ""
    Loop limit {
        if (A_Index > ParsedBuffer.Length)
            break
        res .= ParsedBuffer[A_Index].full . "`n"
    }
    return res
}

AnalyzeOnly() {
    jsonStr := EditCtrl.Value
    if (jsonStr = "")
        return
    RawNotes := PrepareRawNotes(jsonStr)
    if (RawNotes != "")
        AnalyzeAndSuggest(RawNotes)
}

AnalyzeInternal(noteString) {
    totalNotes := 0
    inRangeCount := 0
    midiArray := []
    maxTime := 0
    
    Loop Parse, noteString, "`n", "`r" {
        if (A_LoopField = "")
            continue
        parts := StrSplit(A_LoopField, "|")
        
        t := Number(parts[1])
        d := Number(parts[2])
        if (t + d > maxTime)
            maxTime := t + d
            
        midi := Number(parts[3])
        midiArray.Push(midi)
        rem := Mod(midi, 12)
        isWhiteKey := (rem=0 || rem=2 || rem=4 || rem=5 || rem=7 || rem=9 || rem=11)
        if (midi >= 48 && midi <= 83 && isWhiteKey)
            inRangeCount++
        totalNotes++
    }
    
    if (totalNotes == 0)
        return {TotalNotes: 0, FitPercent: 0, BestShift: 0, DurationMs: 0}

    bestShift := 0
    maxFit := -1
    Loop 25 { 
        shift := A_Index - 13
        currentFit := 0
        for midi in midiArray {
            m := midi + shift
            rem := Mod(m, 12)
            isWhiteKey := (rem=0 || rem=2 || rem=4 || rem=5 || rem=7 || rem=9 || rem=11)
            if (m >= 48 && m <= 83 && isWhiteKey)
                currentFit++
        }
        if (currentFit > maxFit) {
            maxFit := currentFit
            bestShift := shift
        }
    }
    
    percent := Round((maxFit / totalNotes) * 100, 1)
    return {TotalNotes: totalNotes, FitPercent: percent, BestShift: bestShift, DurationMs: maxTime}
}

AnalyzeAndSuggest(noteString) {
    global TransposeCtrl, InfoText, TotalDuration, TimeDisplay
    
    Analysis := AnalyzeInternal(noteString)
    
    TotalDuration := Analysis.DurationMs
    TimeDisplay.Text := "00:00 / " . FormatTimeMs(TotalDuration)
    
    InfoText.Text := "✅ Notes: " . Analysis.TotalNotes . " | Fit: " . Analysis.FitPercent . "%`n💡 Suggest Transpose: " . (Analysis.BestShift > 0 ? "+" : "") . Analysis.BestShift
    
    if (Analysis.FitPercent < 80)
        InfoText.Opt("cRed")
    else
        InfoText.Opt("cGreen")
    
    TransposeCtrl.Value := Analysis.BestShift
}

; ==============================================================================
; HOTKEYS
; ==============================================================================

#MaxThreadsPerHotkey 2
F4:: {
    global IsRunning
    TogglePlayPause()
    return
}
#MaxThreadsPerHotkey 1


F8::StopMusic()

^Right::SkipSong()
^Left::PrevSong()

OnFileDrop(GuiObj, GuiCtrlObj, FileArray, X, Y) {
    global EditCtrl, InfoText, TotalDuration, CurrentTimeMs, ProgressSlider
    
    if (FileArray.Length < 1)
        return

    filepath := FileArray[1]
    SplitPath(filepath, &name, &dir, &ext, &name_no_ext, &drive)
    
    if (ext != "txt" && ext != "json") {
        MsgBox("Only .txt and .json files are supported!", "Invalid File", "48 Icon!")
        return
    }

    try {
        content := FileRead(filepath, "UTF-8")
        EditCtrl.Value := content
        UpdateStatus("📂 Loaded: " . name, 1)
        
        ; Auto analyze
        AnalyzeOnly()
    } catch as err {
        MsgBox("Failed to read file:`n" . err.Message, "Error", "16 Icon!")
    }
}

ToggleMiniMode() {
    global IsMiniMode, GroupHide, MyGui, BtnMiniMode, MiniModeSavedPos
    global TimeDisplay, ProgressSlider, BtnStart, BtnStop, SB

    IsMiniMode := !IsMiniMode
    
    ; Toggle visibility
    for ctrl in GroupHide {
        try ctrl.Visible := !IsMiniMode
    }
    
    if (IsMiniMode) {
        MyGui.Opt("-Resize")
        
        ; Define Mini Layout
        TimeDisplay.Move(10, 25, 330, 25)
        ProgressSlider.Move(10, 50, 330, 30) ; Slider needs height
        
        wBtn := 80
        BtnStart.Move(5, 85, wBtn, 40)
        BtnPrev.Move(5 + wBtn + 5, 85, wBtn, 40)
        BtnNext.Move(5 + wBtn + 5 + wBtn + 5, 85, wBtn, 40)
        BtnStop.Move(5 + wBtn + 5 + wBtn + 5 + wBtn + 5, 85, wBtn, 40)
        
        BtnMiniMode.Text := "Expand"
        BtnMiniMode.Move(280, 2, 60, 20) ; Top right of mini win
        
        MyGui.Show("w350 h140")
        
    } else {
        MyGui.Opt("-Resize") 
        
        ; Restore
        p := MiniModeSavedPos["Time"], TimeDisplay.Move(p.x, p.y, p.w, p.h)
        p := MiniModeSavedPos["Slider"], ProgressSlider.Move(p.x, p.y, p.w, p.h)
        
        p := MiniModeSavedPos["Start"], BtnStart.Move(p.x, p.y, p.w, p.h)
        p := MiniModeSavedPos["Prev"], BtnPrev.Move(p.x, p.y, p.w, p.h)
        p := MiniModeSavedPos["Next"], BtnNext.Move(p.x, p.y, p.w, p.h)
        p := MiniModeSavedPos["Stop"], BtnStop.Move(p.x, p.y, p.w, p.h)
        
        BtnMiniMode.Text := "Mini Mode"
        BtnMiniMode.Move(450, 5, 80, 20)
        
        MyGui.Show("w540 h560")
    }
}