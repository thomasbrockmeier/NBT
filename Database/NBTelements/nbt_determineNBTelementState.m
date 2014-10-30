function State=nbt_determineNBTelementState()

State = get(findobj('Tag','NBTelementSwitch'),'Value');
if(isempty(State))
    State = 0;
    return
end
State = State;
end