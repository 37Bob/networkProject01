function min_ss= distance_min(x0,y0,x1,y1,ss)
    min_ss=zeros(1,2);
    ss=zeros(1,8);
    ss(1)=sqrt((x0-1-x1)^2+(y0-1-y1)^2);
    ss(2)=sqrt((x0-1-x1)^2+(y0-y1)^2);
    ss(3)=sqrt((x0-1-x1)^2+(y0+1-y1)^2);
    ss(4)=sqrt((x0-x1)^2+(y0-1-y1)^2);
    ss(5)=sqrt((x0-x1)^2+(y0+1-y1)^2);
    ss(6)=sqrt((x0+1-x1)^2+(y0-1-y1)^2);
    ss(7)=sqrt((x0+1-x1)^2+(y0-y1)^2);
    ss(8)=sqrt((x0+1-x1)^2+(y0+1-y1)^2);
    s_s=min(ss);
    if ss(1)==s_s
        min_ss(1,1)=x0-1;min_ss(1,2)=y0-1;
    end
    if ss(2)==s_s
        min_ss(1,1)=x0-1;min_ss(1,2)=y0;
    end
    if ss(3)==s_s
        min_ss(1,1)=x0-1;min_ss(1,2)=y0+1;
    end
    if ss(4)==s_s
        min_ss(1,1)=x0;min_ss(1,2)=y0-1;
    end
    if ss(5)==s_s
        min_ss(1,1)=x0;min_ss(1,2)=y0+1;
    end 
    if ss(6)==s_s
        min_ss(1,1)=x0+1;min_ss(1,2)=y0-1;
    end
    if ss(7)==s_s
        min_ss(1,1)=x0+1;min_ss(1,2)=y0;
    end 
    if ss(8)==s_s
        min_ss(1,1)=x0+1;min_ss(1,2)=y0+1;
    end
end