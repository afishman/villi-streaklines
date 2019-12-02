function plotTank(tank)
    faceColor = 'k';
    hold on
    daspect([1,1,1])
    
    for villi = tank
        plot(villiPolygon(villi),'FaceColor',[0 0 0],'FaceAlpha',1)

        %plot(villiPolygon(villi), 'FaceColor', faceColor, 'HandleVisibility','off');
    end

end