function [out,order] = shuffle(mat,dim)
arguments
    mat
    dim int32
end

dims = size(mat);
if dim == 1
    for i = 1:dims(2)
        order(:,i) = randperm(dims(dim));
        out(:,i) = mat(order(:,i),i);
    end

elseif dim == 2
    for i = 1:dims(1)
        order(i,:) = randperm(dims(dim));
        out(i,:) = mat(i,order(i,:));
    end
else
    error('Dimension argument not supported')
end