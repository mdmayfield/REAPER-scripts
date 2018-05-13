-- When executed, this script will perform actions from the Item Notes of
-- the item currently under the playhead on the first selected track.
-- Syntax is the same as Action Markers, i.e. !1008 optional comment 41040 40285

selectedTrack = reaper.GetSelectedTrack(0,0)
if selectedTrack == nil then
  goto exit
end

playhead = reaper.GetPlayPosition()
itemCount = reaper.CountMediaItems(0)
if itemCount == 0 then
  goto exit
end

name = "<none>"

for i=0, itemCount do
  item = reaper.GetMediaItem(0, i)
  if item ~= nil then
    itemTrack = reaper.GetMediaItemTrack(item)
    if itemTrack == selectedTrack then
      itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
      itemLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
      if itemStart <= playhead and itemStart+itemLength > playhead then
        -- TODO: check if item has a take, and if so, use active take name
        name = reaper.ULT_GetMediaItemNote(item)
        goto showName
      end
    end
  end
end

::showName::

--reaper.ShowConsoleMsg(name)

if string.sub(name, 1, 1) == "!" then
--  reaper.ShowConsoleMsg(" Command(s) Detected: ")

  cmds = {}
  
  for i in name:gmatch("[%deE.-]+") do
    cmdNum = tonumber(i)
    if cmdNum ~= nil then
      cmds[#cmds+1] = cmdNum
    end
  end

  for i, command in ipairs(cmds) do
--    reaper.ShowConsoleMsg(command .. " ")
    reaper.Main_OnCommandEx(command, 0, 0)
  end

end

--commandNumber = tonumber(name)
--if commandNumber ~= nil then
--  reaper.Main_OnCommandEx(commandNumber, 0, 0)
--end

::exit::

