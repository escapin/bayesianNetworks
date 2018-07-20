function marg  = inferenceVarElim(bnet, evidenceNode, queryNode) 

    engine = jtree_inf_engine(bnet);        % junction tree engine, which is the mother of all exact inference algorithms
    %engine = var_elim_inf_engine(bnet);
    [engine, loglik1] = enter_evidence(engine, evidenceNode);
    marg = marginal_nodes(engine, queryNode);
end