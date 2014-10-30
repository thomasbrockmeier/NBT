
function [ScreenWidth, ScreenHeight] = nbt_getScreenSize()
hh =java.awt.Toolkit.getDefaultToolkit().getScreenSize;
ScreenWidth = hh.width;
ScreenHeight = hh.height;
end