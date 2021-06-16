classdef params
    properties (Constant)
        % gravity acceleration
        g=9.80665;

        % mass of link
        m1 = 6.8/4; %upper leg
        m2 = 3.2/4; %lower leg
        m3 = 0.6/4; %foot
        m4 = 6.8/4; %upper leg
        m5 = 3.2/4; %lower leg
        m6 = 0.6/4; %foot
        m7 = 12.0/4; %torso

        % mass of wobbling mass
        mw = 0.5;

        % inertia of link
        %il = 1/12 * ModelDynamics.ml .* ModelDynamics.ll.^2;
        i1 = 0.47/4; %upper leg
        i2 = 0.20/4; %lower leg
        i3 = 0.05/4; %foot
        i4 = 0.47/4; %upper leg
        i5 = 0.20/4; %lower leg
        i6 = 0.05/4; %foot
        i7 = 1.00/4; %torso

        % length of link
        l1 = 0.4; %upper leg
        l2 = 0.4; %lower leg
        l3 = 0.1; %foot
        l4 = 0.4; %upper leg
        l5 = 0.4; %lower leg
        l6 = 0.1; %foot
        l7 = 0.625; %torso

        % distance from joint to CoM
        a1 = params.l1 / 2; %upper leg
        a2 = params.l2 / 2; %lower leg
        a3 = params.l3 / 2; %foot
        a4 = params.l4 / 2; %upper leg
        a5 = params.l5 / 2; %lower leg
        a6 = params.l6 / 2; %foot
        a7 = params.l7 / 2; %torso

        % distance from ankle to heel
        c1 = params.a3; %foot
        c2 = params.a6; %foot

        % dumper of SEA
        D = diag(0.01 * ones(6,1));

        % drive matrix
        S = [zeros(3,7);eye(7)];
    end
end
