function [jointDistr, localCondDistr] = computeJointDistr(bnetCPT, dataLearning)


engine = jtree_inf_engine(bnetCPT);
%engine = enumerative_inf_engine(bnetCPT);
% junction tree engine, is the only available to compute full joint
% distribution


N=size(bnetCPT.dag,1);  % number of nodes
T=size(dataLearning,2); % number of samples

presence=2;
evidencePresence=cell(1, N);
soft_ev=cell(1, size(bnetCPT.dag,1));

localCondDistr=zeros(N,T);
for i=1:T
    evidencePresence{1}=cell2mat(dataLearning(1,i));
    marg = inferenceVarElim(bnetCPT, evidencePresence, presence);
    soft_ev{presence} = marg.T';
    
    % OBSERVED NODES
    for queryNode=bnetCPT.observed
        evidenceNode=cell(1, size(bnetCPT.dag,1));
        fam = family(bnetCPT.dag,queryNode);
        if (size(fam,2)>1)
            fam=fam(1,end-1);
            evidenceNode(fam)=dataLearning(fam,i);
        end
        [engine, loglik1] = enter_evidence(engine, evidenceNode, 'soft', soft_ev);
        %[engine, loglik1] = enter_evidence(engine, evidenceNode);

        marg=marginal_nodes(engine, queryNode);

        localCondDistr(queryNode,i)=marg.T(cell2mat(dataLearning(queryNode,i)));
    end
    
    % HIDDEN NODES
    localCondDistr(bnetCPT.hidden,i)=1;
end

jointDistr=prod(localCondDistr);