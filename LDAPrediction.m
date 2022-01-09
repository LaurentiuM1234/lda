%Function will not work properly for populations containing only 1 sample. 
%The scatter matrix is singular in that case
function [prediction, v] = LDAPrediction(pop_1_file, pop_2_file, file_delim, sample)
	
	%Preparing the data matrices
	population_1 = dlmread(pop_1_file, file_delim);
	population_1 = population_1';

	population_2 = dlmread(pop_2_file, file_delim);
	population_2 = population_2';

	[p1_attributes p1_samples] = size(population_1);
	[p2_attributes p2_samples] = size(population_2);


	%Computing the mean vectors
	p1_mean = mean(population_1')';
	p2_mean = mean(population_2')';
	
	
	%Computing the scatter matrices
	p1_sig = zeros(p1_attributes);
	p2_sig = zeros(p2_attributes);

	for i=1:p1_samples
		p1_sig += (population_1(:, i) - p1_mean) * (population_1(:, i) - p1_mean)';
	endfor

	for i=1:p2_samples
		p2_sig += (population_2(:, i) - p2_mean) * (population_2(:, i) - p2_mean)';
	endfor

	%Computing the optimization vector
	v = inv((p1_sig + p2_sig)) * (p1_mean - p2_mean);
	v = v / norm(v);

	%Computing the separation mean
	s_mean = (p1_mean + p2_mean) / 2;
	s_mean = v * v' * s_mean;

	%Projecting the sample onto the optimization vector
	p_sample = v * v' * sample;
	
	%Making the prediction
	p_p1_mean = v * v' * p1_mean;
	p_p2_mean = v * v' * p2_mean;

	if(norm(p_p1_mean) > norm(s_mean))
		%The first population is on the right side
		if(norm(p_sample) > norm(s_mean))
			prediction = "First population";
		else
			if(norm(p_sample) == (s_mean))
				prediction = "Uncertain";
			else
				prediction = "Second population";
			endif
		endif
	else
		%The second population is on the right side
		if(norm(p_sample) > norm(s_mean))
			prediction = "Second population";
		else
			if(norm(p_sample) == norm(s_mean))
				prediction = "Uncertain";
			else
				prediction = "First population";
			endif
		endif
	endif

endfunction
