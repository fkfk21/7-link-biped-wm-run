function snapshot(sol)

    xb   = sol.states.xb.value;
    yb   = sol.states.yb.value;
    thb  = sol.states.thb.value;
    lw   = sol.states.lw.value;
    th1  = sol.states.th1.value;
    th2  = sol.states.th2.value;
    th3  = sol.states.th3.value;
    th4  = sol.states.th4.value;
    th5  = sol.states.th5.value;
    th6  = sol.states.th6.value;

    plot([-10 10],[0 0],'k')
    hold on
    axis equal
    ylim([-0.2 1.5])
    xlim([-0.5 0.5])

        for k = 1:4
            q = [xb(3*k-2);yb(3*k-2);thb(3*k-2);lw(3*k-2);th1(3*k-2);th2(3*k-2);th3(3*k-2);th4(3*k-2);th5(3*k-2);th6(3*k-2)];
            th_abs = [
                q(3) + q(5);
                q(3) + q(5) + q(6);
                q(3) + q(5) + q(6) + q(7);
                q(3) + q(8);
                q(3) + q(8) + q(9);
                q(3) + q(8) + q(9) + q(10);
                q(3)
                ];
            lwm = q(4);
            pb = [q(1) q(2)];

            pj(1,:) = pb      +  params.l1              * [cos(th_abs(1)) sin(th_abs(1))]; %leg1 knee
            pj(2,:) = pj(1,:) +  params.l2              * [cos(th_abs(2)) sin(th_abs(2))]; %leg1 ankle
            pj(3,:) = pj(2,:) + (params.l3 - params.c1) * [cos(th_abs(3)) sin(th_abs(3))]; %leg1 toe
            pj(4,:) = pj(2,:) -  params.c1              * [cos(th_abs(3)) sin(th_abs(3))]; %leg1 heel
            pj(5,:) = pb      +  params.l4              * [cos(th_abs(4)) sin(th_abs(4))]; %leg2 knee
            pj(6,:) = pj(5,:) +  params.l5              * [cos(th_abs(5)) sin(th_abs(5))]; %leg2 ankle
            pj(7,:) = pj(6,:) + (params.l6 - params.c2) * [cos(th_abs(6)) sin(th_abs(6))]; %leg2 toe
            pj(8,:) = pj(6,:) -  params.c2              * [cos(th_abs(6)) sin(th_abs(6))]; %leg2 heel
            pj(9,:) = pb      +  params.l7              * [cos(th_abs(7)) sin(th_abs(7))]; %head
            pj(10,:) = pb      + (params.l7 - lwm    )  * [cos(th_abs(7)) sin(th_abs(7))];
            hold on;
            if k == 1
                line([q(1)   ,pj(1,1)],[q(2)   ,pj(1,2)],'Color',[1,0,0]);
                line([pj(3,1),pj(4,1)],[pj(3,2),pj(4,2)],'Color',[1,0,0]);
                line([q(1)   ,pj(5,1)],[q(2)   ,pj(5,2)],'Color',[1,0,0]);
                line([pj(1,1),pj(2,1)],[pj(1,2),pj(2,2)],'Color',[1,0,0]);
                line([pj(5,1),pj(6,1)],[pj(5,2),pj(6,2)],'Color',[1,0,0]);
                line([pj(7,1),pj(8,1)],[pj(7,2),pj(8,2)],'Color',[1,0,0]);
                line([q(1)   ,pj(9,1)],[q(2)   ,pj(9,2)],'Color',[1,0,0]);
                line([pj(10,1),pj(10,1)],[pj(10,2),pj(10,2)],'Color',[1,0,0],'marker','O');
            end
            if k == 2
                line([q(1)   ,pj(1,1)],[q(2)   ,pj(1,2)],'Color',[0,1,0]);
                line([pj(3,1),pj(4,1)],[pj(3,2),pj(4,2)],'Color',[0,1,0]);
                line([q(1)   ,pj(5,1)],[q(2)   ,pj(5,2)],'Color',[0,1,0]);
                line([pj(1,1),pj(2,1)],[pj(1,2),pj(2,2)],'Color',[0,1,0]);
                line([pj(5,1),pj(6,1)],[pj(5,2),pj(6,2)],'Color',[0,1,0]);
                line([pj(7,1),pj(8,1)],[pj(7,2),pj(8,2)],'Color',[0,1,0]);
                line([q(1)   ,pj(9,1)],[q(2)   ,pj(9,2)],'Color',[0,1,0]);
                line([pj(10,1),pj(10,1)],[pj(10,2),pj(10,2)],'Color',[0,1,0],'marker','O');
            end
            if k == 3
                line([q(1)   ,pj(1,1)],[q(2)   ,pj(1,2)],'Color',[0,0,1]);
                line([pj(3,1),pj(4,1)],[pj(3,2),pj(4,2)],'Color',[0,0,1]);
                line([q(1)   ,pj(5,1)],[q(2)   ,pj(5,2)],'Color',[0,0,1]);
                line([pj(1,1),pj(2,1)],[pj(1,2),pj(2,2)],'Color',[0,0,1]);
                line([pj(5,1),pj(6,1)],[pj(5,2),pj(6,2)],'Color',[0,0,1]);
                line([pj(7,1),pj(8,1)],[pj(7,2),pj(8,2)],'Color',[0,0,1]);
                line([q(1)   ,pj(9,1)],[q(2)   ,pj(9,2)],'Color',[0,0,1]);
                line([pj(10,1),pj(10,1)],[pj(10,2),pj(10,2)],'Color',[0,0,1],'marker','O');
            end
            if k == 4
                line([q(1)   ,pj(1,1)],[q(2)   ,pj(1,2)],'Color',[1,0,1]);
                line([pj(3,1),pj(4,1)],[pj(3,2),pj(4,2)],'Color',[1,0,1]);
                line([q(1)   ,pj(5,1)],[q(2)   ,pj(5,2)],'Color',[1,0,1]);
                line([pj(1,1),pj(2,1)],[pj(1,2),pj(2,2)],'Color',[1,0,1]);
                line([pj(5,1),pj(6,1)],[pj(5,2),pj(6,2)],'Color',[1,0,1]);
                line([pj(7,1),pj(8,1)],[pj(7,2),pj(8,2)],'Color',[1,0,1]);
                line([q(1)   ,pj(9,1)],[q(2)   ,pj(9,2)],'Color',[1,0,1]);
                line([pj(10,1),pj(10,1)],[pj(10,2),pj(10,2)],'Color',[1,0,1],'marker','O');
            end


          %   l8 = line([pj(10,1),pj(10,1)],[pj(10,2),pj(10,2)],'marker','o');
        end
    end
