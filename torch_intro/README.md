intro to pytorch. simple oprations 

### Useful server commands 
* compress local dataset folder: `tar -czvf cifar.tar.gz cifar10`
* push to remote (faster than single files): `scp -r /Users/faa/Documents/GitHub/torch/torch_intro/data/cifar.tar.gz root@201.238.124.65:/workspace/`
* uncompress on remote: `tar -xzvf cifar.tar.gz`
* copy from remote to local: `scp root@201.238.124.65:/model_state_dict_intermediate.pth ./`

### Linux remote tips
* On runpod pytorch container: Jupyter is started in root and all notebooks have `/` as execution context; 
* to change in the current dir: select `python kernel` in the notebook, then `existing jupyter server`, host: `http://0.0.0.0:8888`, password from `runpod pod -> edit pod -> environment vars`, then select `ipykernel /workplace/<FILE>.ipynb`
* Start tensorboard from the command palette inside the parent folder of the current run. Ex.: `/tf_runs/run_1` path will be `/tf_runs`