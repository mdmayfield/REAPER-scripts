envelope = reaper.GetSelectedEnvelope(0)
starttime, endtime = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

if (envelope == nil) or (starttime == endtime) then goto ending
end

_,startvalue = reaper.Envelope_Evaluate(envelope, starttime, 0, 0)
_,endvalue = reaper.Envelope_Evaluate(envelope, endtime, 0, 0)

reaper.DeleteEnvelopePointRange(envelope, starttime, endtime+0.0001)

reaper.InsertEnvelopePoint(envelope, starttime, startvalue, 0, 0, 0, true)
reaper.InsertEnvelopePoint(envelope, starttime, 1, 0, 0, 0, true)
reaper.InsertEnvelopePoint(envelope, endtime, 1, 0, 0, 0, true)
reaper.InsertEnvelopePoint(envelope, endtime, endvalue, 0, 0, 0, true)
reaper.Envelope_SortPoints(envelope)
reaper.UpdateArrange()

::ending::
