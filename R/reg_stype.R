

#' Fit a model using S-type robust estimator
#'
#' This function fits a regression model using the S-type estimator.
#' @param x A numeric vector of predictors.
#' @param y A numeric vector of responses.
#' @return A list containing the model coefficients and diagnostics.
#' @export

#regstype=function(y,x,c=c.default,maxit=maxit.default,eps=eps.default) {
reg_stype=function(y,x,c) {

  #c.default=1.548
  #maxit.default=100
  #eps.default=0.00001

  f1=function(u,c) {

    2*(((u^2)/2-(u^4)/(2*(c^2))+(u^6)/(6*(c^4)))*((1/sqrt(2*pi)*exp((-u^2)/2))))
  }
  f2=function(u,c) {
    2*((c^2/6)*((1/sqrt(2*pi)*exp((-u^2)/2))))
  }

  maxit=100
  eps=0.00001

  K=integrate(f1,c=c,0,c)$value+integrate(f2,c=c,c,Inf)$value

  maxit=100
  eps=0.00001

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

  s=p+1

  regls=lm(y~x)

  betals=regls$coefficients
  betals=t(betals)
  betals=t(betals)

  els=regls$residuals
  els=t(els)
  els=t(els)

  betas=array(NA,dim=c(s,maxit))
  es=array(NA,dim=c(n,maxit))
  us=array(NA,dim=c(n,maxit))
  sigmas=array(NA,dim=c(maxit))
  conds=array(NA,dim=c(maxit))


  for(i in 1:s){
    betas[i,1]=betals[i]
  }

  for(i in 1:n){
    es[i,1]=els[i]
  }

  sigmas[1]=mad(es[,1])

  for(i in 1:n){
    us[i,1]=es[i,1]/sigmas[1]
  }


  W1s=(1-((us/c)^2))^2

  Ws=(abs(us)<=c)*W1s

  regtemp=regweighteds(y,x,as.vector(Ws[,1]))

  for(i in 1:s){
    betas[i,2]=regtemp$beta[i]
  }

  for(i in 1:n){
    es[i,2]=regtemp$e[i]
  }


  fark=betas[,2]-betas[,1]

  conds[1]=norm(t(fark),"2")/norm(t(betas[,2]),"2")

  ites=2

  while ((conds[ites-1]>=eps)&ites<100) {

    sigmas[ites]=sqrt((1/(n*K))*sum(regtemp$ew^2))


    for(i in 1:n){
      us[i,ites]=es[i,ites]/sigmas[ites]
      Ws[i,ites]=(((abs(us[i,ites])<=c)*(((us[i,ites]^2)/2)-((us[i,ites]^4)/(2*(c^2)))+((us[i,ites]^6)/(6*(c^4)))))/(us[i,ites]^2))+
        ((abs(us[i,ites])>c)*(((c^2)/6)/(us[i,ites]^2)))
    }


    regtemp=regweighteds(y,x,as.vector(Ws[,ites]))


    ites=ites+1

    for(i in 1:s){
      betas[i,ites]=regtemp$beta[i]
    }

    for(i in 1:n){
      es[i,ites]=regtemp$e[i]
    }


    fark=betas[,ites]-betas[,ites-1]

    conds[ites-1]=norm(t(fark),"2")/norm(t(betas[,ites]),"2")

  }

  beta=betas[,ites]

  sigma=sigmas[ites-1]
  W=as.vector(Ws[,ites-1])

  e=regtemp$e
  yhat=regtemp$yhat
  MSE=regtemp$MSE
  F=regtemp$F
  sig=regtemp$sig
  varbeta=regtemp$varbeta
  stdbeta=regtemp$stdbeta
  R2=regtemp$R2
  R2adj=regtemp$R2adj
  anovatable=regtemp$anovatable
  confint=regtemp$confint



  z=list(beta=beta,betas=betas,e=e,es=es,yhat=yhat,MSE=MSE,F=F,sig=sig,varbeta=varbeta,
         stdbeta=stdbeta,R2=R2,R2adj=R2adj,anovatable=anovatable,confint=confint,ites=ites,sigmas=sigmas,
         sigma=sigma,W=W,Ws=Ws,conds=conds)

  return(z)
}


