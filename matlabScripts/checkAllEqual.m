function res = checkAllEqual(vect)

res = prod(prod((vect(1)*ones(size(vect)) == vect)+0));
