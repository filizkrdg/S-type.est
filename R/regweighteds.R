


# Weighted regression commands start here


regweighteds=function(y,x,W) {

  alpha=0.05
  #alpha=(0.05)/4

  if(is.data.frame(W)) W=as.vector(t(W))
  if(is.vector(W)) W=diag(W,nrow=length(W))

  m=sum(diag(W))

  if (is.vector(x)){
    n=length(x)
    p=1
    x=t(x)
    x=t(x)

  } else {
    n=dim(x)[1]
    p=dim(x)[2]

    if(p==1) {

      x=x[,1]
      x=t(x)
      x=t(x)

    } else {

      colind=2
      xx=cbind(x[,1],x[,2])
      while(colind<p) {
        colind=colind+1
        xx=cbind(xx,x[,colind])
      }
      x=xx }
  }

  if (is.vector(y)){
    y=t(y)
    y=t(y)
  } else {
    cy=dim(y)[2]
    if(cy==1) {

      y=y[,1]
      y=t(y)
      y=t(y)

    } else {

      colind=2
      yy=cbind(y[,1],y[,2])
      while(colind<cy) {
        colind=colind+1
        yy=cbind(yy,y[,colind])
      }
      y=yy }
  }


  #  print(x)
  #  print(y)

  #print(n)
  #print(p)

  #e=sprintf("The current model: Yhat=%f+%f(X-%f) \n \n",
  #          bet[1],bet[2],xM)
  #cat(e)


  X=cbind(matrix(1,n,1),x)

  Xw=W^0.5%*%X
  yw=W^0.5%*%y
  XpX=t(X)%*%W%*%X
  Xpy=t(X)%*%W%*%y

  #print(Xw)
  #print(yw)
  #print(XpX)
  #print(Xpy)

  invXpX=solve(XpX)
  beta=invXpX%*%Xpy

  #print(beta)

  yhat=X%*%beta
  yhatw=Xw%*%beta

  e=y-yhat
  ew=W^(1/2)%*%e


  SSE=t(ew)%*%ew
  SSE=as.numeric(SSE)
  MSE=SSE/(n-(p+1))


  s1=0
  for(i in 1:n) {
    s1=s1+W[i,i]*y[i]
  }
  ymeanw=s1/m
  SST=t(yw)%*%yw-m*ymeanw^2
  SST=as.numeric(SST)

  MST=SST/(n-1)
  SSR=t(yhatw)%*%yhatw-m*ymeanw^2
  SSR=as.numeric(SSR)

  R2=SSR/SST
  MSR=SSR/p
  F=MSR/MSE
  R2adj=1-MSE/MST

  sig=1-pf(F,p,n-(p+1))

  varbeta=invXpX*MSE
  stdbeta=sqrt(diag(varbeta))
  confint=rbind(t(beta)-qt(1-alpha/2,n-(p+1))*stdbeta,t(beta)+qt(1-alpha/2,n-(p+1))*stdbeta)
  anovatable=data.frame("s.v."=c("Regression","Error","Total"),
                        "S.S."=c(SSR,SSE,SST),
                        "d.f."=c(p,n-(p+1),n-1),
                        "M.S."=c(MSR,MSE,MST),
                        "F"=c(F,NA,NA),
                        "sig."=c(sig,NA,NA))

  z=list(beta=beta,e=e,ew=ew,yhat=yhat,yhatw=yhatw,MSE=MSE,F=F,sig=sig,varbeta=varbeta,
         stdbeta=stdbeta,R2=R2,R2adj=R2adj,anovatable=anovatable,confint=confint)

  return(z)
}



