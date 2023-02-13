addpath('source/analysis/lib/external')
addpath('source/analysis/lib')
%% First case:
%% p=r=2
D=[0.16 0.25 0.47 0.55 0.77];
axis=zeros(1,length(D));

T=[0.1 0.85];
T_star=[0 1];

fig_size = [100 100 700 100];
box_height=0.02;
text_height=0.04;

figure
set(gcf,'Position',fig_size)
hold on
scatter(D,axis,100,'x','LineWidth',2)
text([D],text_height*ones(1,length(D)),{'$$d_1$$', '$$d_2$$', '$$d_3$$', '$$d_4$$', '$$d_5$$'},...
    'VerticalAlignment','bottom','HorizontalAlignment','center', 'Interpreter', 'Latex')
set(gca,'visible','off')
yline(0,'LineWidth',2)
xlim([0 1])
ylim([-0.1 0.1])
text([0,1],[-text_height,-text_height],{'Word 1', 'Word 2'},...
    'VerticalAlignment','top','HorizontalAlignment','center')
scatter(T, [0 0],100,'o','LineWidth',2)
scatter(T_star, [0 0],100,'filled','o','LineWidth',2, ...
    'MarkerEdgeColor','r','MarkerFaceColor','r')
h=fill([0,D(1),D(1),0],[-box_height,-box_height,box_height,box_height],...
    [0.1,0.1,0.1],'LineStyle','none');
h.FaceAlpha=0.3;
h=fill([D(end),1,1,D(end)],[-box_height,-box_height,box_height,box_height],...
    [0.1,0.1,0.1],'LineStyle','none');
h.FaceAlpha=0.3;
hold off
print('output/analysis/illustration/2d', '-depsc', '-r1000')
print('output/analysis/illustration/2d', '-dpng', '-r1000')
close

figure
set(gcf,'Position',fig_size)
hold on
scatter(D,axis,100,'x','LineWidth',2)
text([D],text_height*ones(1,length(D)),{'$$d_1$$', '$$d_2$$', '$$d_3$$', '$$d_4$$', '$$d_5$$'},...
    'VerticalAlignment','bottom','HorizontalAlignment','center', 'Interpreter', 'Latex')
set(gca,'visible','off')
yline(0,'LineWidth',2)
xlim([0 1])
ylim([-0.1 0.1])
text([0,1],[-text_height,-text_height],{'Face 1', 'Face 2'},...
    'VerticalAlignment','top','HorizontalAlignment','center')
scatter(T, [0 0],100,'o','LineWidth',2)
scatter(T_star, [0 0],100,'filled','o','LineWidth',2, ...
    'MarkerEdgeColor','r','MarkerFaceColor','r')
h=fill([0,D(1),D(1),0],[-box_height,-box_height,box_height,box_height],...
    [0.1,0.1,0.1],'LineStyle','none');
h.FaceAlpha=0.3;
h=fill([D(end),1,1,D(end)],[-box_height,-box_height,box_height,box_height],...
    [0.1,0.1,0.1],'LineStyle','none');
h.FaceAlpha=0.3;
hold off
print('output/analysis/illustration/2d_topics', '-depsc', '-r1000')
print('output/analysis/illustration/2d_topics', '-dpng', '-r1000')
close


%% Next case:
%% p=4,r=2
colors=[1 1 0; 0 0.7 0.7 ;1 1 0; 1 1 0];
  
figure
vertices = [sqrt(8/9) 0 -1/3;-sqrt(2/9) sqrt(2/3) -1/3; -sqrt(2/9) -sqrt(2/3) -1/3; 0 0 1;];
faces    = [1 2 3; 1 3 4; 1 4 2; 2 3 4];
pyramid=trisurf(faces, vertices(:,1),vertices(:,2),vertices(:,3),'FaceAlpha', 0.5);
pyramid.FaceVertexCData = colors;
set(gca,'visible','off')
xlim([-1 1])
ylim([-1 1])
zlim([-0.5 1])
view([-25,25]);
vert1 = vertices(faces(:,1),:);
vert2 = vertices(faces(:,2),:);
vert3 = vertices(faces(:,3),:);
%Add line
orig  = [-0.5 0.4 0.2]*1.2;                   % ray's origin
dir   = [1 -0.8 -0.4]*1.3;                    % ray's destination
hold on;
print('output/analysis/illustration/4word', '-depsc', '-r1000')
print('output/analysis/illustration/4word', '-dpng', '-r1000')
close

figure
vertices = [sqrt(8/9) 0 -1/3;-sqrt(2/9) sqrt(2/3) -1/3; -sqrt(2/9) -sqrt(2/3) -1/3; 0 0 1;];
faces    = [1 2 3; 1 3 4; 1 4 2; 2 3 4];
pyramid=trisurf(faces, vertices(:,1),vertices(:,2),vertices(:,3),'FaceAlpha', 0.5);
pyramid.FaceVertexCData = colors;
set(gca,'visible','off')
xlim([-1 1])
ylim([-1 1])
zlim([-0.5 1])
view([-25,25]);
vert1 = vertices(faces(:,1),:);
vert2 = vertices(faces(:,2),:);
vert3 = vertices(faces(:,3),:);
%Add line
orig  = [-0.5 0.4 0.2]*1.2;                   % ray's origin
dir   = [1 -0.8 -0.4]*1.3;                    % ray's destination
hold on;
line('XData',orig(1)+[0 dir(1)],'YData',orig(2)+[0 dir(2)],'ZData',...
  orig(3)+[0 dir(3)],'Color',[0 0 0],'LineWidth',3)
[intersect,~,~,~,xcoor] = TriangleRayIntersection(orig, dir, ...
  vert1, vert2, vert3, 'lineType' , 'line');
scatter3(xcoor(intersect,1), xcoor(intersect,2), xcoor(intersect,3), 100, 'r', 'o', 'filled')
print('output/analysis/illustration/4word_2topic', '-depsc', '-r1000')
print('output/analysis/illustration/4word_2topic', '-dpng', '-r1000')
close

%With vertices=I_4, in the order of (top, right, front, left)
P1_side=vertices(2:end,:)'; %P1 point on left
P1=xcoor(4,:)';
weight_P1= P1_side\P1;
P1_4d= [weight_P1(3);0;weight_P1(2);weight_P1(1)];

P2_side=[vertices(1,:);vertices(3:4,:)]'; %P2 point on right
P2=xcoor(2,:)';
weight_P2= P2_side\P2;
P2_4d= [weight_P2(3);weight_P2(1);weight_P2(2);0];

A_example= [P1_4d P2_4d]
%% Final case
%% p=4,r=3

% Case A
plane.a=0.5;
plane.b=-0.2;
plane.c=-3;
plane.d=-0.1;

A=create_4d_fig(plane.a,plane.b,plane.c,plane.d, "caseA")

warning('off','all')
[~, fval] = constr_OLS(A,3)
writematrix(round(fval,2),'output/analysis/illustration/example_CaseA_viol.txt')


% Case B
plane.a=1.2;
plane.b=-0.15;
plane.c=2;
plane.d=0.3;

A=create_4d_fig(plane.a,plane.b,plane.c,plane.d, "caseB")

A1=A(:,1:3);
[~, fval1] = constr_OLS(A1,3)
A2=[A(:,1) A(:,3:4) ];
[~, fval2] = constr_OLS(A2,3)
A3=[A(:,1:2) A(:,4) ];
[~, fval3] = constr_OLS(A3,3)
A4=[A(:,2:4)];
[~, fval4] = constr_OLS(A4,3)

fval=[fval1;fval2;fval3;fval4];

writematrix(round(fval,2),'output/analysis/illustration/example_CaseB_viol.txt')


topics_x=[0.27,0.85,0.4];
topics_y=[0.15,0.05,0.65];

anchors_x=[0,1,0.55];
anchors_y=[0,0,1];
%Zoom in on plane for case A
figure
%set(gcf,'Position',fig_size)
set(gca,'visible','off')
hold on
h=fill(anchors_x,anchors_y,...
    [0.1,0.1,0.1]);
h.FaceAlpha=0.3;
scatter(topics_x,topics_y,100,'o','LineWidth',2)
scatter(anchors_x,anchors_y, 100, 'r', 'o', 'filled')
hold off
print('output/analysis/illustration/4d_plane_caseA', '-depsc', '-r300')
print('output/analysis/illustration/4d_plane_caseA', '-dpng', '-r300')
close

%Adds level sets to Figure
[alpha_04_x, alpha_04_y]=create_levelset(topics_x, topics_y, -0.4);
%[alpha05_x, alpha05_y]=create_levelset(topics_x, topics_y, 0.5);
[alpha02_x, alpha02_y]=create_levelset(topics_x, topics_y, 0.2);
[alpha08_x, alpha08_y]=create_levelset(topics_x, topics_y, 0.8);
[alpha12_x, alpha12_y]=create_levelset(topics_x, topics_y, 1.2);
figure
%set(gcf,'Position',fig_size)
set(gca,'visible','off')
hold on
h=fill(anchors_x,anchors_y,...
    [0.1,0.1,0.1]);
h.FaceAlpha=0.3;
scatter(topics_x,topics_y,100,'o','LineWidth',2)
scatter(anchors_x,anchors_y, 100, 'r', 'o', 'filled')
l1=plot(alpha_04_x,alpha_04_y,'LineWidth',2,'Color', [0,0,1]);
l2=plot(alpha02_x,alpha02_y,'LineWidth',2, 'Color', [0,0.4,1]);
%plot(alpha05_x,alpha05_y,'LineWidth',2,'Color', 'b')
l3=plot(alpha08_x,alpha08_y,'LineWidth',2,'Color', [0,0.7,1]);
l4=plot(alpha12_x,alpha12_y,'LineWidth',2,'Color',[0,1,1]);
legend([l1,l2,l3,l4],["\alpha=-0.4","\alpha=0.2","\alpha=0.8","\alpha=1.2"],'FontSize',12);
hold off
print('output/analysis/illustration/4d_plane_caseA_levels', '-dpdf', '-r300')
print('output/analysis/illustration/4d_plane_caseA_levels', '-dpng', '-r300')
close

%documents for p=3 figure
D1=[0.5 0.3 0.5 0.55 0.45];
D2=[0.35 0.2 0.47 0.15 0.5];

figure
%set(gcf,'Position',fig_size)
set(gca,'visible','off')
hold on
h=fill(anchors_x,anchors_y,[0.1,0.1,0.1]);
h.FaceAlpha=0.3;
scatter(topics_x,topics_y,100,'o','LineWidth',2)
scatter(anchors_x,anchors_y, 100, 'r', 'o', 'filled')
scatter(D1,D2,100,'x','b','LineWidth',2)
text(D1+0.01,D2+0.01,{'$$d_1$$', '$$d_2$$', '$$d_3$$', '$$d_4$$', '$$d_5$$'},...
    'VerticalAlignment','bottom','HorizontalAlignment','center', 'Interpreter', 'Latex')
hold off
print('output/analysis/illustration/3word_3topic', '-depsc', '-r300')
print('output/analysis/illustration/3word_3topic', '-dpng', '-r300')
close

figure
%set(gcf,'Position',fig_size)
set(gca,'visible','off')
hold on
h=fill([0,1,0.7, 0.15 ],[0,0,0.9,1],...
    [0.1,0.1,0.1]);
h.FaceAlpha=0.3;
scatter(topics_x,topics_y,100,'o','LineWidth',2)
scatter([0,1,0.7, 0.15 ],[0,0,0.9,1], 100, 'r', 'o', 'filled')
hold off
print('output/analysis/illustration/4d_plane_caseB', '-depsc', '-r300')
print('output/analysis/illustration/4d_plane_caseB', '-dpng', '-r300')
close


function A_example=create_4d_fig(a,b,c,d, name)
    %Define plane
    [x1, x2] = meshgrid(-1:0.1:1); 
    x3 = -1/c*(a*x1+b*x2+d);
    normVec = [a; b; c];

    % Define tetrahedron 
    vertices = [sqrt(8/9) 0 -1/3;-sqrt(2/9) sqrt(2/3) -1/3; -sqrt(2/9) -sqrt(2/3) -1/3; 0 0 1];
    faces    = [1 2 3; 1 3 4; 1 4 2; 2 3 4];
    camera= [-25,25];
    colors=[1 1 0; 0 0.7 0.7 ;1 1 0; 1 1 0];
    
    figure
    pyramid=trisurf(faces, vertices(:,1),vertices(:,2),vertices(:,3),'FaceAlpha', 0.5);
    pyramid.FaceVertexCData = colors;
    planeCoord = [x1(1,1), x2(1,1), x3(1,1)];
    [int_num, pint] = plane_normal_tetrahedron_intersect(planeCoord, normVec, vertices');
    pint = pint(:, 1:int_num);
    set(gca,'visible','off')
    %set(gcf,'renderer','opengl')
    hold on;
    surf(x1,x2,x3,'FaceAlpha',1, 'EdgeColor', [0 0 0 ],'FaceColor', [0.3 0.3 0.3])
    scatter3(pint(1,:), pint(2,:), pint(3,:), 100, 'r', 'o', 'filled')
    view(camera);
    xlim([-1 1])
    ylim([-1 1])
    zlim([-0.5 1])
    %str={'1','0','0','0'};
    %text(vertices(4,1)+0.2,vertices(4,2),vertices(4,3),str)
    print(strcat('output/analysis/illustration/4word_3topic_',name), '-dpng','-r1000')
    close

    if name == "caseA"
        %With vertices=I_4, in the order of (top, right, front, left)
        P1_edge=[vertices(4,:);vertices(1,:)]'; %P1 point on right edge
        P1=pint(:,1);
        weight_P1= P1_edge\P1;
        P1_4d= [weight_P1(1);weight_P1(2);0;0];
    
        P2_edge=[vertices(4,:);vertices(3,:)]'; %P2 point on front edge
        P2=pint(:,3);
        weight_P2= P2_edge\P2;
        P2_4d= [weight_P2(1);0;weight_P2(2);0];
    
        P3_edge=[vertices(4,:);vertices(2,:)]'; %P3 point on left edge
        P3=pint(:,2);
        weight_P2= P2_edge\P2;
        P3_4d= [weight_P2(1);0;0;weight_P2(2)];
    
        A_example= [P1_4d P2_4d P3_4d]
    elseif name == "caseB"
        %With vertices=I_4, in the order of (top, right, front, left)
        P1_edge=[vertices(1,:);vertices(3,:)]'; %P1 point on right front bottom edge
        P1=pint(:,2);
        weight_P1= P1_edge\P1;
        P1_4d= [0;weight_P1(1);weight_P1(2);0;];
    
        P2_edge=[vertices(4,:);vertices(3,:)]'; %P2 point on front edge
        P2=pint(:,3);
        weight_P2= P2_edge\P2;
        P2_4d= [weight_P2(1);0;weight_P2(2);0];
    
        P3_edge=[vertices(4,:);vertices(2,:)]'; %P3 point on left back edge
        P3=pint(:,4);
        weight_P3= P3_edge\P3;
        P3_4d= [weight_P3(1);0;0;weight_P3(2)];

        P4_edge=[vertices(1,:);vertices(2,:)]'; %P4 point on bottom back edge
        P4=pint(:,1);
        weight_P4= P4_edge\P4;
        P4_4d= [0;weight_P4(1);0;weight_P4(2)];
    
        A_example= [P1_4d P2_4d P3_4d P4_4d];

    end

    writematrix(round(A_example,2), strcat('output/analysis/illustration/example_',name, '.txt'))
end