track = reaper.GetSelectedTrack(0, 0)
okay, note = reaper.GetUserInputs("Note Number", 1, "Note Number", "1")

if okay == false then goto ending
end

colors = {0x01000000, 0x01ffffff, 0x01ff0000, 0x0100ffff, 0x01ff00ff, 0x0100ff00,
          0x010000ff, 0x01ffff00, 0x01ff7f00, 0x017f3f00, 0x01ff7f7f, 0x013f3f3f,
          0x017f7f7f, 0x017fff7f, 0x017f7fff, 0x01bfbfbf}

starttime, endtime = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
qnotetime = 60 / reaper.Master_GetTempo()

if starttime == endtime then -- no time selection exists

   -- check if a mediaItem is selected, and if so take its start & end times and delete it
   if reaper.CountSelectedMediaItems() == 0 then
      starttime = reaper.GetCursorPosition()
      endtime = starttime + qnotetime
   else
      selectedItem = reaper.GetSelectedMediaItem(0, 0)
      starttime = reaper.GetMediaItemInfo_Value(selectedItem, "D_POSITION")
      endtime = starttime + reaper.GetMediaItemInfo_Value(selectedItem, "D_LENGTH")
      reaper.DeleteTrackMediaItem(track, selectedItem)
   end      
end

length = (endtime - starttime)

midiItem = reaper.CreateNewMIDIItemInProj(track, starttime, starttime + qnotetime)
midiTake = reaper.GetActiveTake(midiItem)
reaper.MIDI_InsertNote(midiTake, false, false, 0, 480, 0, note, 127)

reaper.SetMediaItemInfo_Value(midiItem, "B_LOOPSRC", 1)
reaper.SetMediaItemLength(midiItem, length, false)
reaper.GetSetMediaItemTakeInfo_String(midiTake, 'P_NAME', note, true)
colorIndex = math.fmod(note,16)+1
r = (colors[colorIndex] & 0x00ff0000) >> 16
g = (colors[colorIndex] & 0x0000ff00) >> 8
b = (colors[colorIndex] & 0x000000ff)
itemColor = reaper.ColorToNative(r, g, b)
reaper.SetMediaItemTakeInfo_Value(midiTake, 'I_CUSTOMCOLOR', itemColor|0x01000000)

::ending::

