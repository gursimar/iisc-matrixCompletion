clear all
clc

for mc_itr = 1:500

    M_p = rand(20,20);
    for r=1:20

        % Taking SVD approximation
        [u_p s_p v_p] = svd(M_p);
        v_tr_p = v_p';
        M_com_p = u_p(:,1:r) * s_p(1:r,1:r) * v_tr_p(1:r,:);

        FRO_p(mc_itr,r) = sum(sum((M_p - M_com_p ).^2));
    end
end

plot(sum(FRO_p)/mc_itr)