function ss=connect_breakpoint(x0,y0,x1,y1)
N=sqrt((x0-x1)^2)+sqrt((y0-y1)^2);
ss=zeros(N-2,2);
for i=1:N-2
    distance=sqrt((x0-x1)^2+(y0-y1)^2);
    min_dis=distance_min(x0,y0,x1,y1,distance);
    ss(i,1)=min_dis(1,1);
    ss(i,2)=min_dis(1,2);
    x0=min_dis(1,1);
    y0=min_dis(1,2);
end