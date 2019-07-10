function f=mass_evaluate(f, M, V)
%evaluate objectives for multiple chromosome in parallel by submitting jobs
%to LSF. Modify function submit_job, check_job and get_job_data to use.
%
%f,  N x (V+M), chromosome
%M,  integer, number of objectives
%V,  integer, number of variables
% created 10/12/2011, Xiaobiao Huang
%


N = size(f,1);
if 1 %serial
        for i=1:N
            f(i,V + 1: M + V) = func_obj(f(i,1:V));
        end
        
        return
end

