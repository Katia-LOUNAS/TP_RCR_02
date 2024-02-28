% Define the structure of the Bayesian Network
dag = zeros(3);
dag(1, [2 3]) = 1;

% Define the node sizes
node_sizes = [2 2 2];

% Create a Bayesian network object
bnet = mk_bnet(dag, node_sizes);

% Define conditional probability tables
bnet.CPD{1} = tabular_CPD(bnet, 1, 'CPT', [0.7 0.3]);
bnet.CPD{2} = tabular_CPD(bnet, 2, 'CPT', [0.6 0.4 0.3 0.7]);
bnet.CPD{3} = tabular_CPD(bnet, 3, 'CPT', [0.5 0.5 0.2 0.8]);

% Create an inference engine (junction tree)
engine = jtree_inf_engine(bnet);

% Set evidence (observations)
evidence = cell(1, numel(bnet.node_sizes));
evidence{1} = 1;  % Instance for variable 1
evidence{2} = 2;  % Instance for variable 2

% Perform inference to calculate P(variable of interest | evidence)
interest = 3;  % Variable of interest

% Find the clique containing the variable of interest
c = [];
for i = 1:length(engine.clpot)
    if ismember(interest, engine.clpot{i}.domain)
        c = i;
        break;
    end
end

% Check if the clique was found
if isempty(c)
    error('Clique containing the variable of interest not found.');
end

% Marginalize the potential associated with the clique
marginal = marginalize_pot(engine.clpot{c}, evidence);

% Convert the marginalized potential to a marginal distribution
marg = pot_to_marginal(marginal, interest, engine.observed);
disp(['P(X' num2str(interest) ' | E) = ' num2str(marg.T)]);




