# Local Trajectory Privacy Protection Code
This is the source code of  the local trajectory privacy protection scheme which was published in IEEE Transactions on Industrial Informatics: [ Local Trajectory Privacy Protection in 5G Enabled Industrial Intelligent Logistics](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9552545)

In this paper, we propose two algorithms QLP and QJLP to provide trajectory protection satisfying LDP for users. The following two pictures are the treating processes of the two algorithms in the paper.
![QLP](https://i.postimg.cc/d1X8W8Zn/QLP.png) ![QJLP](https://i.postimg.cc/RCHfSJH5/QJLP.png)
## Building Datasets
Due to privacy issues, we only upload part of the disturbing data instead of the original dataset.

We suggest that you can download datasets such as [T_Drive](https://www.microsoft.com/en-us/research/publication/t-drive-trajectory-data-sample/) for further research.
## Preparing
MATLAB should be installed. If you have some original data and want to preprocess it, you can refer to the file `preproc.m`.
##  Processing

|Function|Implemented functionality|
|--|--|
|`one-timerappor.m`|One-Time RAPPOR|
|`basicrappor.m`|Basic RAPPOR|
|`binary2dec.m`|change binary to decimal|
|`dec2binary.m`|change decimal to binary|
|`getposcode.m`|Quadtree position encoding|
|`getqlpvec.m`|Trajectory vector defined in QLP|
|`getqjlpvec.m`|Trajectory vector defined in QJLP|
|`QLP.m`|get perturbed vector using QLP|
|`QJLP.m`|get perturbed vector using QJLP|
|`QLPAgg.m`|aggregate the perturbed vectors using QLP|
|`QJLPAgg.m`|aggregate the perturbed vectors using QJLP|

## Citation
If you use the Local Trajectory Privacy Protection Code in your paper, please cite the paper:
```
@ARTICLE{9552545,
  author={Yang, Zhigang and Wang, Ruyan and Wu, Dapeng and Wang, Honggang and Song, Haina and Ma, Xinqiang},
  journal={IEEE Transactions on Industrial Informatics}, 
  title={Local Trajectory Privacy Protection in 5G Enabled Industrial Intelligent Logistics}, 
  year={2022},
  volume={18},
  number={4},
  pages={2868-2876},
  doi={10.1109/TII.2021.3116529}}
}
```
## Acknowledgement
We thank Zhigang Yang and Lufen Fu for contributing to the codebase.

We thank the contributors for using the Local Trajectory Privacy Protection Code.
