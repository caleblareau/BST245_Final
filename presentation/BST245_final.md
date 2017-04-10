<style>
.footer {
    color: black;
    background: #E8E8E8;
    position: fixed;
    top: 90%;
    text-align:center;
    width:100%;
}
.midcenter {
    position: fixed;
    top: 50%;
    left: 50%;
}
.small-code pre code {
  font-size: 1em;
}

.reveal h3 {
  word-wrap: normal;
  -moz-hyphens: none;
}
.reveal h1 {
  word-wrap: normal;
  -moz-hyphens: none;
}
</style>

Inferring Cellular Developmental Time
========================================================
autosize: true  
transition-speed: slow

"From Multivariate to Longitudinal Data"<br><br>April 11, 2017

<div class="footer" style="margin-top:-50px;background-color:transparent;"><SPAN STYLE="font-size:80%;font-weight:bold;">Caleb Lareau <br>bit.ly/LareauBST245</a> </SPAN></div>

Overview
========================================================
<br>
- Motivation
  - Single cell RNA-Seq<br><br>
- Model Dataset
  - EDA <br><br>
- Methods of estimating pseudotime (developmental time)
  - PCA 
  - Probablistic PCA
  - Gaussian Process Latent Variable Modeling 

Trajectories...
========================================================

========================================================
<DIV ALIGN=CENTER>
<img src="images/early.jpeg" width="40%" height="80%" /> ~3 million cells<br>
<img src="images/mid.png" width="40%" height="80%" /> ~ 20 billion cells<br>
<img src="images/late.gif" width="40%" height="80%" /> ~ 50 trillion cells<br><br>
</DIV>
- What are the key points in development for disease?


========================================================
<DIV ALIGN=CENTER>
<img src="images/neuro.png" width="70%" height="80%" /><br>
<img src="images/heme.jpg" width="40%" height="80%" />
</DIV>

Questions from a developmental biology perspective
========================================================
<br>
- What happens in a cell such that it becomes a brain, toe, or a heart?
  - When do these decisions get made? "Who" makes them?<br><br>
- How do the developmental trajectories of disease (leukemia / schizophrenia) differ from healthy individuals? <br><br>
- Can we identify important transition points and the genetic signature underlying them?


Waddington Landscape
========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/waddd.png" width="80%" height="80%" />
</DIV><br>

Some cancers regain stemness programs
========================================================
<DIV ALIGN=CENTER>
<img src="images/leuk.png" width="60%" height="80%" />
</DIV><br>
Stergachis $et al.$, Cell 2013


"Stem cell-like" covariate is important in AML
========================================================
<br><br>
<DIV ALIGN=CENTER>
<img src="images/surv1.png" width="40%" height="80%" />
<img src="images/surv2.png" width="40%" height="80%" />
</DIV><br>
Corces $et al.$ Nature Genetics, 2016

How do we characterize single cells?
========================================================


========================================================
<DIV ALIGN=CENTER>
<img src="images/cell_review.png" width="40%" height="80%" />
</DIV><br>
Proserpio and Mahata, Immunology 2015


========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/mRNA-cell.png" width="70%" height="80%" />
</DIV><br>

========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/scRNA.png" width="90%" height="80%" />
</DIV><br>

========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/counts.png" width="90%" height="80%" />
</DIV><br>

========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/boneRet.png" width="80%" height="80%" />
</DIV><br>

========================================================

<DIV ALIGN=CENTER>
<img src="images/blood.png" width="20%" height="80%" />
<img src="images/orderResult.png" width="80%" height="80%" />
</DIV><br>



========================================================
<DIV ALIGN=CENTER>
<img src="images/mESC_paper.png" width="100%" height="80%" />
</DIV>

========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/ovary.png" width="70%" height="80%" />
</DIV>

========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/measurements.png" width="70%" height="80%" />
</DIV>


========================================================
<DIV ALIGN=CENTER>
<img src="images/01colorkey.png" width="100%" height="80%" />
</DIV>


EDA
========================================================

<br>

```r
> dim(deng)

[1] 17585   255

> sum(deng == 0) / prod(dim(deng))

[1] 0.5019552

> head(sample(colnames(deng)))

[1] "earlyblast" "16cell"     "4cell"      "midblast"   "lateblast"  "16cell"   

> head(sample(rownames(deng)))

[1] "Gm7073"  "Mir697"  "Uqcrc2"  "Ap2m1"   "Slc10a3" "Ccr1"   
```

========================================================
<DIV ALIGN=CENTER>
<img src="images/02colorBar.png" width="100%" height="80%" />
</DIV>

Linearly increasing
========================================================
<DIV ALIGN=CENTER>
<img src="images/violin.5655.png" width="100%" height="80%" />
</DIV>

Dropoff
========================================================
<DIV ALIGN=CENTER>
<img src="images/violin.15783.png" width="100%" height="80%" />
</DIV>

Linear Decreasing
========================================================
<DIV ALIGN=CENTER>
<img src="images/violin.16990.png" width="100%" height="80%" />
</DIV>

Varying, no clear effect
========================================================
<DIV ALIGN=CENTER>
<img src="images/violin.17189.png" width="100%" height="80%" />
</DIV>


V-shaped
========================================================
<DIV ALIGN=CENTER>
<img src="images/violin.1706.png" width="100%" height="80%" />
</DIV>


Transition on/off
========================================================
<DIV ALIGN=CENTER>
<img src="images/violin.8642.png" width="100%" height="80%" />
</DIV>

Sigmoidal with dropout
========================================================
<DIV ALIGN=CENTER>
<img src="images/violin.1684.png" width="100%" height="80%" />
</DIV>

Overall picture
========================================================
<br>
$\forall$ gene $g$, fit OLS Regression with known timepoint $t$ per cell--   

$$\log_2(g +1) \sim \beta_0 + \beta_1 t $$

<DIV ALIGN=CENTER>
<img src="images/05allBetas.png" width="60%" height="60%" />
</DIV>

Permuted
========================================================
<br>
$\forall$ gene $g$, fit OLS Regression with permuted timepoint $t^*$ per cell--   

$$\log_2(g +1) \sim \beta_0 + \beta_1 t^* $$

<DIV ALIGN=CENTER>
<img src="images/06allBetas.png" width="60%" height="60%" />
</DIV>

Permuted
========================================================
<br>
$\forall$ gene $g$, fit OLS Regression with permuted **factor** timepoint $t^{**}$ per cell--   

$$\log_2(g +1) \sim \beta_0 + \beta_1 t^{**} $$

<DIV ALIGN=CENTER>
<img src="images/07allBetas.png" width="60%" height="60%" />
</DIV>


Statement of problem
========================================================
<br>
Given a matrix of $m$ genes (features) by $n$ samples in a matrix <b> $Y$</b>, determine a latent vector $P$ with dimension $1$ x $n$ that reflects the (smooth) developmental trajectory of the $n$ cells from the variance in $m$ genes.


Perfect latent variable
========================================================
<DIV ALIGN=CENTER>
<img src="images/perfect.png" width="50%" height="30%" />
</DIV>
<br>

```r
> cor(runif(length(time)) %>% sort(), as.numeric(time) %>% sort())^2

[1] 0.8799669
```

PCA
========================================================



PCA
========================================================
<DIV ALIGN=CENTER>
<img src="images/pc1.png" width="50%" height="30%" />
</DIV>
<br>

```r
> cor(pca$rotation[,1], as.numeric(time))^2

[1] 0.5933009
```


Correlation with all PCs
========================================================
<DIV ALIGN=CENTER>
<img src="images/allPCs.png" width="70%" height="30%" />
</DIV>


Pause...
========================================================
<br>
PCA by itself isn't satisfactory... <br><br> Ideas for improvements?

Improving on PCA 
========================================================
<br><br>
1) Quantifiying uncertainty <br> <br> 2)  Non-linear latent variable inference

Uncertainty
========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/atac.png" width="100%" height="80%" />
</DIV><br> <br>
From Buenrostro $et al.$ bioRxiv 2017


Mannifold / Non-linear dimension learning
========================================================
<br>
- Next several images taken from slides via Guy Wolf (Yale)

- These slides can be found <a href="http://users.math.yale.edu/users/gw289/CpSc-445-545/Slides/CPSC445%20-%20Topic%2010%20-%20Diffusion%20Maps.pdf">here</a> 

========================================================
<DIV ALIGN=CENTER>
<img src="images/mannifold.png" width="100%" height="80%" />
</DIV>

========================================================
<DIV ALIGN=CENTER>
<img src="images/obsexpman.png" width="100%" height="80%" />
</DIV>


========================================================
<br><br>
<DIV ALIGN=CENTER>
<img src="images/reviewTitle.png" width="70%" height="30%" />
</DIV>


========================================================
<br><br>
<DIV ALIGN=CENTER>
<img src="images/reviewImage.png" width="70%" height="30%" />
</DIV>

Tackling 1 and building to 2
========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/ppca.png" width="50%" height="70%" />
</DIV><br>


========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/probPCA.png" width="70%" height="70%" />
</DIV><br>
Slide from Neil Lawrence

Bayesian / Probablistic PCA
========================================================
<br>

```r
library(pcaMethods)

pca()

resPCA   <- pca(data, method="svd",       center=FALSE, nPcs=5)
resPPCA  <- pca(data, method="ppca",      center=FALSE, nPcs=5)
resBPCA  <- pca(data, method="bpca",      center=FALSE, nPcs=5)
resSVDI  <- pca(data, method="svdImpute", center=FALSE, nPcs=5)
```


========================================================
<br><br>
<DIV ALIGN=CENTER>
<img src="images/Lawrence.png" width="70%" height="70%" />
</DIV>

GPLVM
========================================================
<br>

```r
library(pseudogp)

fit <- fitPseudotime(data, smoothing_alpha = 30, smoothing_beta = 6,
                        iter = 1000, chains = 1)

posteriorBoxplot(fit)
```
<DIV ALIGN=CENTER>
<img src="images/psK.png" width="50%" height="70%" />
</DIV>


GPLVM -- Noteable application
========================================================
<br><br>
<DIV ALIGN=CENTER>
<img src="images/teichman.png" width="45%" height="70%" />
<img src="images/malaria.png" width="70%" height="70%" />
</DIV>


GPLVM
========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/gplvm.png" width="45%" height="70%" />
<img src="images/uncertain.png" width="45%" height="70%" />
</DIV> <br>

```r
> cor(gplvm_means, as.numeric(time))^2

[1] 0.783522
```

GPLVM versus PCA 1
========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/pc1.png" width="45%" height="70%" />
<img src="images/gplvm.png" width="45%" height="70%" />
</DIV> <br>


```r
> cor(pca$rotation[,1], as.numeric(time))^2

[1] 0.5933009

> cor(gplvm_means, as.numeric(time))^2

[1] 0.783522
```


GPLVM versus PCA 2
========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/PCAvGPLVM.png" width="70%" height="70%" />
</DIV> <br>

Wrapping up...
========================================================
<br>
- GPLVM provide both a probablistic and non-linear latent variable inference structure <br>
  - All other published algorithms provide point estimates, difficult to ascertain uncertainty
<br><br>
- Under this framework, Bayesian priors are allowed, which have been useful in published studies
<br><br>
- Tools and methods useful in many data analyses contexts (including machine learning)
  - Motivated here by single cell analysis
<br><br>

Detailed look at early embryo neurogenesis? 
========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/10x.png" width="90%" height="70%" />
</DIV> <br>


========================================================
<br>
<DIV ALIGN=CENTER>
<img src="images/HCA.png" width="45%" height="70%" />
<img src="images/zuck2.png" width=60%" height="70%" />
</DIV> <br>

Thanks! 
========================================================

