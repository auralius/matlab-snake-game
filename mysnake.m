% Snake game by Auralius Manurung
% manurung.auralius@gmail.com
% 25.08.2015
%
% Structure of the snake
%   snake.collision => flag for collision (1 or 0)
%   snake.running => set to 0 when program is terminated
%   snake.xmax => world length
%   snake.ymax => world height
%   snake.fig_hnd => figure handle
%   snake.plot_hnd => a plot handle for the snake
%   snake.plot_head_hnd => a plot handle for head of the snake
%   snake.segments => N x 2 where N is the length of the snake
%   snake.dir = {'E', 'S', 'W', 'N'}
%
%%
function mysnake()
    close all;    
    clc;    
    
    snake.running = 1;
    snake.collision = 0;
    
    % Snake world size
    snake.xmax = 100;
    snake.ymax = 100;
    
    % Prepare a figure window    
    snake.fig_hnd = figure();
    hold on;
    snake.plot_hnd = plot(0, 0, 'b.', 'MarkerSize', 10);            
    snake.plot_head_hnd = plot(0, 0, 'go', 'MarkerSize', 5, 'LineWidth', 2);            
            
    % Initial snakes segments and direction
    snake.segments = [snake.xmax/2   snake.ymax/2; ...
                      snake.xmax/2-1 snake.ymax/2; ...
                      snake.xmax/2-2 snake.ymax/2];
    snake.dir = 'E';    
    
        
    % Allow data exchange from callback to GUI
    guidata(snake.fig_hnd, snake);
        
    % Initial drawing    
    init_figure(snake);    
    draw_snake(snake); 
    
    % Introduction massage
    intro();
    
    snake_loop(snake);
end

%%
function snake_loop(snake)
    % The main loop     
    while 1
        snake = guidata(snake.fig_hnd);  
        
        snake = forward(snake);
        draw_snake(snake);               
        
        %
        % Your AI here
        % Use turn_left, turn_right, and forward functions here
        % Don't forget to refresh the plot by calling draw_snake function
        % You can disable key_pressed_fcn callback function
        %

        guidata(snake.fig_hnd, snake);                
        
        if snake.running == 0
            break;
        end
        
        % Animation delay
        pause(0.3);          
    end
    close all;
end

%%
function init_figure(snake)
    set (gcf, 'keypressfcn', @(src,eventdata)key_pressed_fcn(src, eventdata));        
    xlim([0, snake.xmax]);
    ylim([0, snake.ymax]);
    title('mysnake v1.0')
end

%%
function draw_snake(snake)    
    set(snake.plot_hnd, 'XData', snake.segments(:,1));
    set(snake.plot_hnd, 'YData', snake.segments(:,2));
    
    set(snake.plot_head_hnd, 'XData', snake.segments(1,1));
    set(snake.plot_head_hnd, 'YData', snake.segments(1,2));
    
    if snake.collision == 1
        set(snake.plot_head_hnd, 'Color', 'r');
    else
        set(snake.plot_head_hnd, 'Color', 'g');
    end
end

%%
function snake = turn_left(snake)    
    snake.segments(2:end, :) = snake.segments(1:end-1, :);
    
    if snake.dir == 'E' % horizontal snake, face east
        snake.segments(1, :) = [snake.segments(1, 1) snake.segments(1, 2)+1];
    elseif snake.dir == 'W' % horizontal snake, face west
        snake.segments(1, :) = [snake.segments(1, 1) snake.segments(1, 2)-1];
    elseif snake.dir == 'N' % vertical snake, face north
        snake.segments(1, :) = [snake.segments(1, 1)-1 snake.segments(1, 2)];
    elseif snake.dir == 'S' % vertical snake, face south
        snake.segments(1, :) = [snake.segments(1, 1)+1 snake.segments(1, 2)];
    end        
end

%%
function snake = turn_right(snake)
    snake.segments(2:end, :) = snake.segments(1:end-1, :);
    
    if snake.dir == 'E' % horizontal snake, face east
        snake.segments(1, :) = [snake.segments(1, 1) snake.segments(1, 2)-1];
    elseif snake.dir == 'W' % horizontal snake, face west
        snake.segments(1, :) = [snake.segments(1, 1) snake.segments(1, 2)+1];
    elseif snake.dir == 'S' % vertical snake, face south
        snake.segments(1, :) = [snake.segments(1, 1)-1 snake.segments(1, 2)];
    elseif snake.dir == 'N' % vertical snake, face north
        snake.segments(1, :) = [snake.segments(1, 1)+1 snake.segments(1, 2)];
    end       
end

%%
function snake = forward(snake)
    v = snake.segments(1, :) - snake.segments(2, :);    
    
    % Toroidal grid
    if v(1,1) == -snake.xmax
        v(1,1) = 1;
    elseif v(1,1) == snake.xmax
        v(1,1) = -1;
    end
    
    if v(1,2) == -snake.ymax
        v(1,2) = 1;
    elseif v(1,2) == snake.ymax
        v(1,2) = -1;
    end
    
    % Shift the snake
    snake.segments(2:end, :) = snake.segments(1:end-1, :);
    snake.segments(1, :) = snake.segments(1, :) + v;
    
    % Toroidal grid again
    if snake.segments(1, 1) == snake.xmax + 1
        snake.segments(1, 1) = 0;
    elseif snake.segments(1, 1) == - 1
        snake.segments(1, 1) = snake.xmax;
    end
    
    if snake.segments(1, 2) == snake.ymax + 1
        snake.segments(1, 2) = 0;
    elseif snake.segments(1, 2) == - 1
        snake.segments(1, 2) = snake.ymax;
    end
end

%%
function snake = check_collision(snake)
    snake.collision = 0;
    r = sum(snake.segments(2:end, 1) == snake.segments(1, 1) & snake.segments(2:end, 2) == snake.segments(1, 2));
    if r > 0
        snake.collision = 1;
        disp('collision');
    end
end

%%
function snake = increase(snake)
    v = snake.segments(end, :) - snake.segments(end-1, :);    
    
     % Toroidal grid
    if v(1,1) == -snake.xmax
        v(1,1) = 1;
    elseif v(1,1) == snake.xmax
        v(1,1) = -1;
    end
    
    if v(1,2) == -snake.ymax
        v(1,2) = 1;
    elseif v(1,2) == snake.ymax
        v(1,2) = -1;
    end
    
    % Increase the length by 1 segment
    snake.segments(end+1,:) = snake.segments(end,:) + v;
    
    % Toroidal grid again
    if snake.segments(end,1) == snake.xmax + 1
        snake.segments(end, 1) = 0;
    elseif snake.segments(end, 1) == - 1
        snake.segments(end, 1) = snake.xmax;    
    end
    
    if snake.segments(end, 2) == snake.ymax + 1
        snake.segments(end, 2) = 0;
    elseif snake.segments(end, 2) == - 1
        snake.segments(end, 2) = snake.ymax;    
    end
end

%%
function [] = key_pressed_fcn(H, E)  
    snake = guidata(H);
    % Figure keypressfcn    
    switch E.Key
        case 'rightarrow'
            if (snake.dir == 'N')                
                snake = turn_right(snake);                
                snake.dir = 'E';
            elseif (snake.dir == 'S')                
                snake = turn_left(snake);                
                snake.dir = 'E';
            elseif (snake.dir == 'E')
                snake = forward(snake);
            end                        
            
        case 'leftarrow'
            if (snake.dir == 'N')                
                snake = turn_left(snake);                
                snake.dir = 'W';
            elseif (snake.dir == 'S')                
                snake = turn_right(snake);               
                snake.dir = 'W';
            elseif (snake.dir == 'W')
                snake = forward(snake);
            end            
            
        case 'uparrow'
            if (snake.dir == 'E')                
                snake = turn_left(snake);                
                snake.dir = 'N';
            elseif (snake.dir == 'W')                
                snake = turn_right(snake);                
                snake.dir = 'N';
            elseif (snake.dir == 'N')
                snake = forward(snake);
            end            
            
        case 'downarrow'            
            if (snake.dir == 'E')                
                snake = turn_right(snake);                
                snake.dir = 'S';
            elseif (snake.dir == 'W')                
                snake = turn_left(snake);            
                snake.dir = 'S';
            elseif (snake.dir == 'S')
                snake = forward(snake);
            end            
            
        case 'space'
            snake = increase(snake);            
                        
        case 'escape'        
            snake.running = 0;
            guidata(snake.fig_hnd, snake);
            disp('bye');            
            
        otherwise              
    end
    
    if snake.running == 1
        snake = check_collision(snake);
        draw_snake(snake);
        guidata(snake.fig_hnd, snake);
    end
end

%%
function intro()
h = msgbox({'Use the arrow keys to maneuver.', ...
    'Use the [Space] to increase the snake length.', ... 
    'Use the [Esc] to quit.', ... 
    '', ...
    'manurung.auralius@gmail.com'}, 'mysnake v1.0');
end