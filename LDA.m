function[] = LDA(data_file, data_separator)
	
	%Reading data matrix
	data_matrix = dlmread(data_file, data_separator);
	
	%Turning the matrix into an attribute * sample matrix
	data_matrix = data_matrix';
	[attributes samples] = size(data_matrix);

	%Checking if the number of samples is odd and splitting the matrix
	if (mod(samples, 2) == 0)
		population_1 = data_matrix(:, 1:samples/2);
		population_2 = data_matrix(:, samples/2 + 1: end);
	else
		data_matrix = data_matrix(:, 1:end-1);
		samples -= 1;
		population_1 = data_matrix(:, 1:samples/2);
		population_2 = data_matrix(:, samples/2 + 1: end);
	
	endif

	%Computing the mean vectors
	mean_1 = mean(population_1')';
	mean_2 = mean(population_2')';


	%Computing the covariance matrices
	SIG_1 = zeros(attributes);
	SIG_2 = zeros(attributes);
	
	for i=1:samples / 2
		SIG_1 += (population_1(:, i) - mean_1) * (population_1(:, i) - mean_1)';
		SIG_2 += (population_2(:, i) - mean_2) * (population_2(:, i) - mean_2)';
	endfor
	%SIG_1 /= samples;
	%SIG_2 /= samples;

	%Preparing for the gen. evalue problem
	S = (mean_1 - mean_2) * (mean_1 - mean_2)';
	M = (SIG_1 + SIG_2);
	
	%Computing the vector that optimizes the gen. evalue problem
	v = inv(M) * (mean_1 - mean_2);
	v = v / norm(v)

	%Plotting initial data
	subplot(1, 2, 1)
	plot(population_1(1, :), population_1(2, :), 'r+');
	hold on;
	plot(population_2(1, :), population_2(2, :), 'b+');
	hold on;
	min_x = min([min(population_1(1, :)); min(population_2(1, :))]);
	max_x = max([max(population_1(1, :)); max(population_2(1, :))]);
	fplot(@(x) (v(2, 1) / v(1, 1)) * x, [-50 200], 'g');
	legend(gca, 'off');
	set(gca, 'XAxisLocation', 'origin');
	set(gca, 'YAxisLocation', 'origin');
	title("Initial, unprojected data");
	xlabel('Age');
	ylabel('Height');

	%Computing the projections
	for i=1:samples / 2
		population_1(:, i) = v * v' * population_1(:, i);
		population_2(:, i) = v * v' * population_2(:, i);
	endfor

	%Plotting final data
	subplot(1, 2, 2);
	min_x = min([min(population_1(1, :)); min(population_2(1, :))]);
	max_x = max([max(population_1(1, :)); max(population_2(1, :))]);
	fplot(@(x) (v(2, 1) / v(1, 1)) * x, [min_x max_x], 'g');
	legend(gca, 'off');
	hold on;
	plot(population_1(1, :), population_1(2, :), 'r+');
	hold on;
	plot(population_2(1, :), population_2(2, :), 'b+');
	hold on;
	mean = (mean_1 + mean_2) / 2;
	mean = v * v' * mean;
	plot(mean(1, 1), mean(2, 1), 'k*');
	title("Projected data");
	xlabel('Age');
	ylabel('Height');
endfunction
