%Function used to graph the changes in optimivation vector v
%!!!The 2 populations need to have 2 attributes!!!
function [] = LDASimulation(p1_file, p2_file, file_delim)
	
	%Setting up data matrices
	p1 = dlmread(p1_file, file_delim);
	p1 = p1';
	[p1_attributes p1_samples] = size(p1);

	p2 = dlmread(p2_file, file_delim);
	p2 = p2';
	[p2_attributes p2_samples] = size(p2);


	%Iterating through data matrices and predicting
	max_iteration = max(p1_samples, p2_samples);
	for i=1:max_iteration
		if (i <= p1_samples)
			plot(p1(1, 1:i), p1(2, 1:i), 'r+');
			dlmwrite('p1_file.csv', p1(:, 1:i)', ',');
		endif
		hold on;
		if(i <= p2_samples)
			plot(p2(1, 1:i), p2(2, 1:i), 'b+');
			dlmwrite('p2_file.csv', p2(:, 1:i)', ',');
		endif
		hold on;


		[_, v] = LDAPrediction('p1_file.csv', 'p2_file.csv', ',', [1; 1]);
		fplot(@(x) (v(2, 1) / v(1, 1)) * x, [-100 100], 'g');
		set(gca, 'XAxisLocation', 'origin');
		set(gca, 'YAxisLocation', 'origin');
		legend(gca, 'off');
		ylim([-400 400]);
		xlim([-100 100]);
		xticks([-100:25:100]);
		yticks([-400:100:400]);
		xlabel('Age');
		ylabel('Height');
		pause(1);
		hold off;
	endfor
	delete 'p1_file.csv';
	delete 'p2_file.csv';
endfunction
