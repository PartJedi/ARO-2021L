clear
MasterList = [[999.9;.1;-.9], [1000;34.054963;-117.752209], [999.9;-.1,;-.9], [11.4;.8,;-.2], [99.9;.1;.9], [100;0;1], [99.9;-.1;.9], [99.9;.9;-.1], [100;1;0], [99.9;.9;.1], [99.9;-.9;.1], [100;-1;0], [99.9;-.9;-.1], [11.3;.8;.2]];
PlayList = MasterList;
Center = [34.103600;-117.720002];
Velocity = PlayList(1,:);
val = 0;
idx = 0;
Average_Surrounding = -1;
while 1.05*Average_Surrounding < val
    [val, idx] = max(Velocity);
    Surrounding_Velocity = [];
    if (idx-1)==0
        Surrounding_Velocity = [Surrounding_Velocity, Velocity(end), Velocity(end-1)];
    else
        Surrounding_Velocity = [Surrounding_Velocity, Velocity(idx-1)];
    end
%     if (idx-2)==0
%         Surrounding_Velocity = [Surrounding_Velocity, Velocity(end)];
%     else
%         Surrounding_Velocity = [Surrounding_Velocity, Velocity(idx-2)];
%     end
    if (idx+1)>length(Velocity)
        Surrounding_Velocity = [Surrounding_Velocity, Velocity(1), Velocity(2)];
    else
        Surrounding_Velocity = [Surrounding_Velocity, Velocity(idx+1)];
    end
%     if (idx+2)>length(Velocity)
%         Surrounding_Velocity = [Surrounding_Velocity, Velocity(1)];
%     else
%         Surrounding_Velocity = [Surrounding_Velocity, Velocity(idx+2)];
%     end
    Average_Surrounding = mean(Surrounding_Velocity);
    if 1.05*Average_Surrounding >= val
        naisu = PlayList(:,idx);
        wind_speed = naisu(1);
    else 
        PlayList(:, idx) = [];
        Velocity(idx) = [];
        Surrounding_Velocity = [];
        val = 0;
        Average_Surrounding = -1;
    end
end

dLat = naisu(3)-Center(2);

dLon = naisu(2)-Center(1);

GPSChange = LatLonxy(dLat, dLon, 1); %calls function below to convert dLat to dnorth and dLon to dEast
    dNorth = GPSChange(1);                                                                                                                      
    dEast = GPSChange(2);    

if dNorth==-1 && dEast== 0
    theta = 270;
    plane_theta = 90+theta;
elseif dNorth>=0 && dEast>=0
    theta = atand(dNorth/dEast);
    plane_theta = 90+theta;
elseif dNorth>=0 && dEast<=0
    theta = 180+atand(dNorth/dEast);
    plane_theta = -(270-theta);
elseif dNorth<=0 && dEast<=0
    theta = 180+atand(dNorth/dEast);
    plane_theta = 90+theta;
elseif dNorth<=0 && dEast>=0
    theta = atand(dNorth/dEast);
    plane_theta = 90+theta;
end

if plane_theta>=180
    wind_theta = plane_theta-180;
elseif plane_theta<180 
    wind_theta = plane_theta+180;
end

theta
plane_theta
wind_theta

function GPSChange = LatLonxy(dlat, dlon, California)
if(California == 0) %We are in Maryland, Since 0 means false and 1 means true
     % Change in degrees Latitude for every meter {Deg/meter}
     ChngLat = 1.112684551E5;
     %1/ChngLon =8.987273079E-6                                                         SIMILAR TO ABOVE .....  .07% diff :)
     % Change in degrees Longitude for every meter {Deg/meter}
     ChngLon = 8.750104301E4;
     % 1/ChngLon = 1.14284352E-5    aboveChngLon = 0.0000114353 .                       SIMILAR TO ABOVE.......  0.06% diff
     
     % Displacement of payload {meters}
     GPSChange = [dlat*ChngLat, dlon*ChngLon];
else %We are in California
     % Change in degrees Latitude for every meter {Deg/meter}
     ChngLat = 1.111785102E5;
     %1/ChngLon = 8.994543983E-6     aboveChngLat = 0.0000089931;                     SIMILAR TO ABOVE.............. 0.02% diff                    
                
     % Change in degrees Longitude for every meter {Deg/meter}
     ChngLon = 9.226910619E4; 
     %%1/ChngLon = 1.08378637E-5    aboveChngLon = 0.000010967;                        SIMILAR TO ABOVE........ 1.18%diff                                        
     
     % Displacement of payload {meters}
     GPSChange = [dlat*ChngLat, dlon*ChngLon];
end
end