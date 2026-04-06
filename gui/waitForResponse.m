function response = waitForResponse(gui)

    % Reset previous response
    setappdata(gui.fig,'response',[]);

    % Wait until user clicks a button
    while isempty(getappdata(gui.fig,'response'))
        pause(0.01);
    end

    response = getappdata(gui.fig,'response');
end