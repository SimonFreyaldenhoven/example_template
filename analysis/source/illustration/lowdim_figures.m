addpath('../lib/external')

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
print('../../output/illustration/2d', '-depsc', '-r1000')
print('../../output/illustration/2d', '-dpng', '-r1000')
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
line('XData',orig(1)+[0 dir(1)],'YData',orig(2)+[0 dir(2)],'ZData',...
  orig(3)+[0 dir(3)],'Color',[0 0 0],'LineWidth',3)
[intersect,~,~,~,xcoor] = TriangleRayIntersection(orig, dir, ...
  vert1, vert2, vert3, 'lineType' , 'line');
scatter3(xcoor(intersect,1), xcoor(intersect,2), xcoor(intersect,3), 100, 'r', 'o', 'filled')
print('../../output/illustration/3d', '-depsc', '-r1000')
print('../../output/illustration/3d', '-dpng', '-r1000')
close


exit