function Pout = finalize(this, Ntot)

P = this.parts;

%determining free nodes
N_Ps = size(P, 2); %number of interpolation blocks given

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% finding entries of interpolation matrices

Pinds = cell(3, N_Ps);
if size(P,1) > 1
    checkIndices = true;
else
    checkIndices = false;
end

for kp = 1:N_Ps
    if issparse(P{1, kp})
        [I, J, E] = find(P{1, kp});
    elseif size(P{1,kp},1) == 3
        [I, J, E] = deal( P{1, kp}(1,:)', P{1, kp}(2,:)', transpose(P{1, kp}(3,:)) );
    elseif isempty(P{1,kp})
        continue;
    else
        error('Incorrect input in P.');
    end
    
    %checking if P_kp needs to be row- or column-scaled
    if checkIndices && ~isempty(P{2,kp})
        Pinds{1,kp} = P{2,kp}(I');
    else
        Pinds{1,kp} = I';
    end
    
    if checkIndices && ~isempty(P{3,kp})
        Pinds{2,kp} = P{3,kp}(J');
    else
        Pinds{2,kp} = J';
    end
    Pinds{3,kp} = E';
end

minion_nodes = unique( horzcat( Pinds{1,:} ) );

[freeNodes, IA] = setdiff(1:Ntot, minion_nodes);

Np_free = numel(freeNodes);
indsOfFree = zeros(1, Ntot);
indsOfFree(IA) = 1:Np_free;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%constructing total matrix
%PT = [];

%free nodes
%PT = sparseAdd(freeNodes, 1:Np_free, ones(1,Np_free), PT);
this.add_triplets(freeNodes, 1:Np_free, ones(1,Np_free));

%slave nodes
for kp = 1:N_Ps
    %checking for possibly zero input
    inds = find( Pinds{3,kp} ~= 0 );
    
    if isempty(inds)
        continue
    end
    
    %PT = sparseAdd( Pinds{1,kp}(inds), indsOfFree( Pinds{2,kp}(inds) ), Pinds{3,kp}(inds), PT );
    this.add_triplets(Pinds{1,kp}(inds), indsOfFree( Pinds{2,kp}(inds) ), Pinds{3,kp}(inds));
    
    %any( ~indsOfFree( Pinds{2,kp}(inds) ) )
end
Pout = finalize@MatrixConstructorBase(this, Ntot, Np_free);

end