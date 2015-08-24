% Snake game by Auralius Manurung
% manurung.auralius@gmail.com
%

%%
function mysnake()
    close all;    
    clc;    
    
    snake.running = 1;
    
    % Prepare a figure window    
    snake.fig_hnd = figure();
    hold on;
    snake.plot_hnd = plot(0, 0, 'LineWidth', 4);            
    snake.plot_head_hnd = plot(0, 0, 'ro');           
            
    % Initial snakes segments and direction
    snake.segments = [40 40; 39 40; 38 40];
    snake.dir = 'E';    
    
        
    % Allow data exchange from callback to GUI
    guidata(snake.fig_hnd, snake);
        
    % Initial drawing    
    init_figure();    
    draw_snake(snake); 
    
    intro();
end

%%
function init_figure()
    set (gcf, 'keypressfcn', @(src,eventdata)key_pressed_fcn(src, eventdata));        
    xlim([0, 80]);
    ylim([0, 80]);
    title('mysnake v1.0')
end

%%
function draw_snake(snake)
    set(snake.plot_hnd, 'XData', snake.segments(:,1));
    set(snake.plot_hnd, 'YData', snake.segments(:,2));
    
    set(snake.plot_head_hnd, 'XData', snake.segments(1,1));
    set(snake.plot_head_hnd, 'YData', snake.segments(1,2));
end

%%
function snake = turn_left(snake)
    v = snake.segments(1, :) - snake.segments(2, :);    
    snake.segments(2:end, :) = snake.segments(1:end-1, :);
    
    if isequal(v, [1 0]) % horizontal snake, face east
        snake.segments(1, :) = [snake.segments(1, 1) snake.segments(1, 2)+1];
    elseif isequal(v, [-1 0]) % horizontal snake, face west
        snake.segments(1, :) = [snake.segments(1, 1) snake.segments(1, 2)-1];
    elseif isequal(v, [0 1]) % vertical snake, fae north
        snake.segments(1, :) = [snake.segments(1, 1)-1 snake.segments(1, 2)];
    elseif isequal(v, [0 -1]) % vertical snake, face west
        snake.segments(1, :) = [snake.segments(1, 1)+1 snake.segments(1, 2)];
    end        
end

%%
function snake = turn_right(snake)
    v = snake.segments(1, :) - snake.segments(2, :);    
    snake.segments(2:end, :) = snake.segments(1:end-1, :);
    
    if isequal(v, [1 0]) % horizontal snake, face west
        snake.segments(1, :) = [snake.segments(1, 1) snake.segments(1, 2)-1];
    elseif isequal(v, [-1 0]) % horizontal snake, face east
        snake.segments(1, :) = [snake.segments(1, 1) snake.segments(1, 2)+1];
    elseif isequal(v, [0 -1]) % vertical snake, face south
        snake.segments(1, :) = [snake.segments(1, 1)-1 snake.segments(1, 2)];
    elseif isequal(v, [0 1]) % vertical snake, face north
        snake.segments(1, :) = [snake.segments(1, 1)+1 snake.segments(1, 2)];
    end       
end

%%
function snake = forward(snake)
    v = snake.segments(1, :) - snake.segments(2, :);    
    snake.segments(2:end, :) = snake.segments(1:end-1, :);
    snake.segments(1, :) = snake.segments(1, :) + v;
end

%%
function snake = increase(snake)
    v = snake.segments(end, :) - snake.segments(end-1, :);    
    snake.segments(end+1,:) = snake.segments(end,:) + v;
end

%%
function [] = key_pressed_fcn(H, E)  
    snake = guidata(H);
    % Figure keypressfcn    
    switch E.Key
        case 'rightarrow'
            if (snake.dir == 'N')
                snake.dir = 'E';
                snake = turn_right(snake);                
            elseif (snake.dir == 'S')
                snake.dir = 'E';
                snake = turn_left(snake);                
            elseif (snake.dir == 'E')
                snake = forward(snake);
            end
            draw_snake(snake);
            
            
        case 'leftarrow'
            if (snake.dir == 'N')
                snake.dir = 'W';
                snake = turn_left(snake);                
            elseif (snake.dir == 'S')
                snake.dir = 'W';
                snake = turn_right(snake);               
            elseif (snake.dir == 'W')
                snake = forward(snake);
            end
            draw_snake(snake);
            
        case 'uparrow'
            if (snake.dir == 'E')
                snake.dir = 'N';
                snake = turn_left(snake);                
            elseif (snake.dir == 'W')
                snake.dir = 'N';
                snake = turn_right(snake);                
            elseif (snake.dir == 'N')
                snake = forward(snake);
            end
            draw_snake(snake);            
            
        case 'downarrow'            
            if (snake.dir == 'E')
                snake.dir = 'S';
                snake = turn_right(snake);                
            elseif (snake.dir == 'W')
                snake.dir = 'S';
                snake = turn_left(snake);            
            elseif (snake.dir == 'S')
                snake = forward(snake);
            end
            draw_snake(snake);
            
        case 'space'
            snake = increase(snake);
            draw_snake(snake)
                        
        case 'escape'        
            snake.running = 0;            
            disp('quitting');
            close all;
            
        otherwise              
    end
    
    if snake.running == 1
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