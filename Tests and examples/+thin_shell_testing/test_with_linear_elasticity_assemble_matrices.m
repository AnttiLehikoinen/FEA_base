%assemble_matrices
% Assemble the required matrices for centrifugal stress analysis, using the
% 2D plane-strain formulation.

Np = msh.number_of_nodes;

N = Nodal2D(Operators.grad);
S11 = FEMatrixConstructor();
S22 = FEMatrixConstructor();
S12 = FEMatrixConstructor();
J1 = [1 0;0 0;0 1]; %for Voigt notation
J2 = [0 0;0 1;1 0];

for k = 1:numel(materials)
    mat = materials(k);
   
    els = mat.elements;
    tens = mat.stiffness_tensor;
        
    S11.assemble_matrix(N, N, reshape(J1'*tens*J1, [], 1), els, mat.mesh);
    S22.assemble_matrix(N, N, reshape(J2'*tens*J2, [], 1), els, mat.mesh);
    S12.assemble_matrix(N, N, reshape(J1'*tens*J2, [], 1), els, mat.mesh);
end

S11 = S11.finalize(Np, Np);
S12 = S12.finalize(Np, Np);
S22 = S22.finalize(Np, Np);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% boundary condition matrix

%matrix for boundary conditions
Pc = InterpolatingMatrixConstructor();
Pc.add_zeros([1 Np+[1 2]]);

%n_up = find(msh.nodes(2,:)==2);
%Pc.add_zeros([n_up Np+n_up]);

P = Pc.finalize(msh.number_of_nodes*2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% volume stress vector

Fx = 2e5;
Fy = 1e6;

fx = FEMatrixConstructor().assemble_matrix( Nodal2D(), IDfun(), Fx, elements_with_source, msh);
fx = fx.finalize(Np, 1);

fy = FEMatrixConstructor().assemble_matrix( Nodal2D(), IDfun(), Fy, elements_with_source, msh);
fy = fy.finalize(Np, 1);

return
%plotting free nodes