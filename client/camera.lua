local C = CineDirector.Client
C.Camera = { active = false, speed = Config.DefaultSpeed, fov = Config.DefaultFov, dof = false }
function C.Camera.toggle()
  local cam = C.Camera
  cam.active = not cam.active
  if not cam.active then RenderScriptCams(false, true, 250, true, true); if cam.handle then DestroyCam(cam.handle) end; cam.handle=nil; return end
  cam.handle = CreateCam('DEFAULT_SCRIPTED_CAMERA', true); local p=GetGameplayCamCoord(); SetCamCoord(cam.handle,p.x,p.y,p.z); SetCamRot(cam.handle,GetGameplayCamRot(2),2); SetCamFov(cam.handle,cam.fov); RenderScriptCams(true,true,250,true,true)
  CreateThread(function() while cam.active do
    local rot=GetCamRot(cam.handle,2); local pos=GetCamCoord(cam.handle); local forward=GetCamForwardVector(cam.handle); local right=vector3(forward.y,-forward.x,0); local speed=cam.speed*(IsControlPressed(0,21) and 3 or 1)
    if IsControlPressed(0,32) then pos=pos+forward*speed*0.02 end; if IsControlPressed(0,33) then pos=pos-forward*speed*0.02 end; if IsControlPressed(0,34) then pos=pos-right*speed*0.02 end; if IsControlPressed(0,35) then pos=pos+right*speed*0.02 end
    SetCamCoord(cam.handle,pos.x,pos.y,pos.z); SetCamRot(cam.handle,rot.x-GetDisabledControlNormal(0,2)*8,rot.y,rot.z-GetDisabledControlNormal(0,1)*8,2); Wait(0)
  end end)
end
function C.Camera.savePreset(name) local p,r=GetCamCoord(C.Camera.handle),GetCamRot(C.Camera.handle,2); C.presets[#C.presets+1]={name=name,position=CineDirector.Util.vecToTable(p),rotation=CineDirector.Util.vecToTable(r),fov=C.Camera.fov} end
