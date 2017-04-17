envelope = reaper.GetSelectedEnvelope(0)
starttime, endtime = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

if (envelope == nil) or (starttime == endtime) then goto ending
end

reaper.DeleteEnvelopePointRange(envelope, starttime, endtime+0.0001)

reaper.InsertEnvelopePoint(envelope, starttime, 1, 0, 0, 0, true)
reaper.InsertEnvelopePoint(envelope, endtime, 0, 0, 0, 0, true)
reaper.Envelope_SortPoints(envelope)
reaper.UpdateArrange()

::ending::
