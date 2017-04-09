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
- Single cell RNA-Seq
- Model Dataset
  - EDA
- Methods of estimating pseudotime (developmental time)
  - PCA (Probablistic)
  - Gaussian Process Latent Variable Modeling
  - Diffusion Components
- Evaluation of methods in model data setting

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


========================================================
<DIV ALIGN=CENTER>
<img src="images/cell_review.png" width="40%" height="80%" />
</DIV><br>
Proserpio and Mahata, Immunology 2015

Statement of problem
========================================================
<br>
<b>Given a matrix of $m$ genes (features) by $n$ samples, compute a vector $n$ x $1$ that:</b>


========================================================
<DIV ALIGN=CENTER>
<img src="images/mESC_paper.png" width="100%" height="80%" />
</DIV>


Mannifold learning
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


Impetus 
========================================================
<br>
- Lots of single cell data on the horizon... <br><br>
<DIV ALIGN=CENTER>
<img src="images/mESC_paper.png" width="50%" height="50%" /> <br>
Assumes ~2% non-missing rate
</DIV>
- What do? 


========================================================
<DIV ALIGN=CENTER>
<img src="images/01colorkey.png" width="100%" height="80%" />
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

$$log_2(g +1) = \beta_0 + \beta_1 t $$

<DIV ALIGN=CENTER>
<img src="images/05allBetas.png" width="60%" height="60%" />
</DIV>

========================================================
<br><br>
<DIV ALIGN=CENTER>
<img src="images/reviewTitle.png" width="30%" height="30%" />
<img src="images/reviewImage.png" width="70%" height="30%" />

</DIV>

========================================================
<br><br>
<DIV ALIGN=CENTER>
<img src="images/ppca.png" width="50%" height="70%" />
</DIV><br>

========================================================
<br><br>
<DIV ALIGN=CENTER>
<img src="images/Lawrence.png" width="70%" height="70%" />
</DIV>



========================================================
<br><br>
<DIV ALIGN=CENTER>
<img src="images/probPCA.png" width="70%" height="70%" />
</DIV><br>
Slides from Neil Lawrence

GPLVM
========================================================
<br><br>
<DIV ALIGN=CENTER>
<img src="images/teichman.png" width="45%" height="70%" />
<img src="images/malaria.png" width="70%" height="70%" />
</DIV>


GPLVM
========================================================
<br><br>
<DIV ALIGN=CENTER>
<img src="images/GPLVM.png" width="45%" height="70%" />
<img src="images/wSE.png" width="45%" height="70%" />
</DIV>

