function F = MM_HyperExp(p)
    global m1;
    global m2;
    global m3;
    l1 = p(1);
    l2 = p(2);
    p1 = p(3);
    
    F = zeros(1,3);
    F(1) = (p1/l1 + (1-p1)/l2)/m1(2) - 1;
    F(2) = 2*(p1/l1^2 + (1-p1)/l2^2)/m2(2) - 1;
    F(3) = 6*(p1/l1^3 + (1-p1)/l2^3)/m3(2) - 1;
end