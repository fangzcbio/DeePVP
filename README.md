DeePVP
==============

#### Contact
fangzc@smu.edu.cn or hzhou@smu.edu.cn

Change logs
-------
2023.10.11 The manual was updated because of the change of the virtual machine link.

Introduction
-------

DeePVP is a tool for the identification and classification of phage virion protein (PVP) using deep learning approach. The main module of DeePVP aims to discriminate PVPs from non-PVPs within a phage genome, while the extended module of DeePVP can further classify predicted PVPs into the ten major classes of PVPs, namely head-tail joining, collar, tail sheath, tail fiber, portal, minor tail, major tail, baseplate, minor capsid, and major capsid, which are the dominant categories in PVP. DeePVP takes a phage protein sequence file in "fasta" format as input, and outputs a tabular file. The program is optimized in both a [virtual machine](https://www.virtualbox.org/) with GUI and a [docker](https://www.docker.com/).

![151703377-b3153bab-911e-49f6-b16d-9b43fdef9eed](https://user-images.githubusercontent.com/107048586/172389231-10ce628c-e167-4f22-be2e-235128063fe3.png)

Manuals
-------
Please refer to [DeePVP manual.pdf](https://github.com/fangzcbio/DeePVP/blob/main/DeePVP%20manual.pdf) for the DeePVP usage.

Deep learning approach
------------
DeePVP takes a protein sequence in "one-hot" encoding form as input. The main module uses CNN to extract the sequence features to determine whether the given protein is a PVP. The CNN contains a 1D convolution layer, 1D global max pooling layer, batch normalization layer, full connection layer, and finally, a sigmoid layer that outputs a PVP score between 0 and 1. By default, a protein with a PVP score higher than 0.5 is regarded as a PVP. The extended module also uses CNN to classify the protein into a specific class of PVP. The CNN in the extended module contains a 1D convolution layer, 1D global max pooling layer, batch normalization layer, full connection layer, and finally, a softmax layer that outputs 10 likelihood scores representing the probability that the protein belongs to the head-tail joining, collar, tail sheath, tail fiber, portal, minor tail, major tail, baseplate, minor capsid, or major capsid class. By default, the category with the highest score will be chosen as the final prediction.

![Figure1](https://user-images.githubusercontent.com/107048586/175798873-1d43f61c-ddea-4f83-8a52-2ece5e5a9cde.png)

<br>

Performance comparison using [PhANNs](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7660903/) benchmark dataset
---------------
![Table1](https://user-images.githubusercontent.com/107048586/175799324-d2f78497-7694-48a5-ab4c-fd7be291b780.png)
![Table2](https://user-images.githubusercontent.com/107048586/175799426-839f7149-3969-4a22-b5ae-55e86082d6f4.png)

Reproduction
------------
All the supporting data for results reproduction is available in the GigaScience repository, [GigaDB](http://gigadb.org/). By referring to the "document_for_results_reproduction.txt" file and all the “readme” files, the readers can easily reproduce all the results.

License
-------
DeePVP is distributed under a GPL-3.0 license.

Publications
------------
Fang Z, Feng T, Zhou H and Chen M. DeePVP: Identification and classification of phage virion proteins using deep learning.
