; Code taken from online lecture!

; Last Edited: 08-10-07

function m_thin, A, max_iterations=max_iterations, count=count

;+ 
;B=m_thin(A) 
;performs morphological thinning on a binary image. 
; 
;KEYWORDS: 
;MAX_ITERATIONS (default=20) Set this value to the maximum 
; number of iterations to allow. 
; 
;COUNT returns the number of iterations actually used. 
; 
;REFERENCE: 
;Gonzalez and Woods, Digital Image Processing (2nd Ed), Sec 9.5.5 
; 
;HISTORY: 
;Written for SIMG-782 class by H. Rhody, Sept. 2002. 
;- 
sa=Size(A) 
IF sa[0] NE 2 THEN MESSAGE,'A must be 2D'
IF N_Elements(max_iterations) LE 0 THEN max_iterations=20 
;Pad with zeros to enable the structuring elements to work 
;to the edge of the set. The padding is removed before 
;returning the result. 
B=BytArr(sa[1]+4,sa[2]+4) 
B[2:sa[1]+1,2:sa[2]+1]=A NE 0 

;STRUCTURING ELEMENTS 
S1=[[0b,0b,0b],[0b,1b,0b],[1b,1b,1b]] 
T1=[[1b,1b,1b],[0b,0b,0b],[0b,0b,0b]] 
S2=[[0b,0b,0b],[1b,1b,0b],[1b,1b,0b]] 
T2=[[0b,1b,1b],[0b,0b,1b],[0b,0b,0b]] 
S3=Reverse(Transpose(S1),1) 
T3=Reverse(Transpose(T1),1) 
S4=Reverse(Transpose(S2),1) 
T4=Reverse(Transpose(T2),1) 
S5=Reverse(S1,2) 
T5=Reverse(T1,2) 
S6=Reverse(S4,1) 
T6=Reverse(T4,1) 
S7=Reverse(S3,1) 
T7=Reverse(T3,1) 
S8=Reverse(S2,1) 
T8=Reverse(T2,1)

X=B 
Y=BYTARR(sa[1]+4,sa[2]+4) 
count=0 
WHILE MAX(X NE Y) GT 0 AND count LT max_iterations DO BEGIN 
	Y=X 
	X=Y AND NOT Morph_HitOrMiss(X,S1,T1) 
	X=X AND NOT morph_HitOrMiss(X,S2,T2) 
	X=X AND NOT morph_HitOrMiss(X,S3,T3) 
	X=X AND NOT morph_HitOrMiss(X,S4,T4) 
	X=X AND NOT morph_HitOrMiss(X,S5,T5) 
	X=X AND NOT morph_HitOrMiss(X,S6,T6) 
	X=X AND NOT morph_HitOrMiss(X,S7,T7) 
	X=X AND NOT morph_HitOrMiss(X,S8,T8) 
	count=count+1 
ENDWHILE 
RETURN,X[2:sa[1]+1,2:sa[2]+1] 
END
