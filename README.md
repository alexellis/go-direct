## go-direct

This is an experiment to show the memory used for a function when the OpenFaaS watchdog is not included as part of the bundle.

The watchdog performs a number of key functions, however if optimizing memory is an absolute must, you may be able to remove it and implement some of the functionality yourself such as draining requests, safe shutdown, logging and metrics.

This function, with no additional libraries included.

```bash
kubectl top pod -n openfaas-fn
NAME                         CPU(cores)   MEMORY(bytes)   
go-direct-798cd8c6fc-p8s8z   1m           1Mi             
```

A simple bcrypt function using the golang-middleware template with the watchdog built-in:

```bash
kubectl top pod -n openfaas-fn
bcrypt-6bdcf89d5c-4l8vp      1m           7Mi             
```
