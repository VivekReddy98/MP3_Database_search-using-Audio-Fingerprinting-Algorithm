function result = circshift_gs(a,gs)
P = zeros(size(a));
Q = zeros(size(a));
R = zeros(size(a));
S = zeros(size(a));
for i=1:gs
    A = circshift(a,[0,i]);
    P = P + (a>A);
    
    B = circshift(a,[i,0]);
    Q = Q + (a>B);
    
    C = circshift(a,[0,-i]);
    R = R + (a>C);
    
    D = circshift(a,[-i,0]);
    S = S + (a>D);
end
result = (P+Q+R+S == 4*gs);
end
