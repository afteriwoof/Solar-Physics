%% This is file `spr-mp-sola.bst'
%%
%% Please submit bugs or your comments to vtexspr@vtex.lt
%%
%% Sorting entries is done by name and year fields!
%%
%% You are free to use this style file as you see fit, provided 
%% that you do not make changes to the file. 
%% If you DO make changes, you are required to rename this file.
%%
%% It may be distributed under the terms of the LaTeX Project Public
%% License, as described in lppl.txt in the base LaTeX distribution.
%% Either version 1.0 or, at your option, any later version.

% BibTeX programming: Linas Stonys, VTeX, Lithuania, lstonys@vtex.lt 
%
% 2009-06-03 -- added letters to the \citeauthoryear{}{} year section (if the same year) 
%               \citeauthoryear{autho}{2000a}  
%               \citeauthoryear{autho}{2000b}  
%               not cutting letters from the pages any more
% 2009-06-04 -- added letters to the volume ("CS-" if publisher = "ASP" and "SP-" if publisher = "ESA")            
%               \doiurl in \textsf font

ENTRY
  { address
    author
    booktitle
    chapter
    doi
    edition
    editor
    howpublished
    institution
    isbn
    journal
    key
    month
    note
    number
    organization
    pages   
    publisher
    school
    series
    title
    type
    volume
    year
    url
  }
  {}
   { label extra.label sort.label short.list }

INTEGERS { output.state before.all mid.sentence after.sentence
           after.block after.authors between.elements bother}

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
  #4 'after.authors :=
  #5 'between.elements :=
}

STRINGS { s t  element}
STRINGS { longest.label last.label  }
STRINGS { v l f j b }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { " " * write$ newline$}
    { output.state after.block =
        { add.period$ write$
          newline$
         % "\newblock " write$
        }
        {
          output.state after.authors =
          { ": " * write$
            newline$
          }
          { output.state between.elements =
              { ", " * write$ newline$}
              { output.state before.all =
                   'write$
                  { add.period$ " " * write$ newline$}
                  	
                  	
                  if$
              }
              if$
          }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}
FUNCTION {fin.entry}
{
"." *
write$ newline$
}

FUNCTION {stupid.colon}
{ after.authors 'output.state := }


FUNCTION {insert.comma}
{ output.state before.all =
    'skip$
    { between.elements 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}


FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {sort.format.month}
{ 't :=
 	 t #1 #2 substring$ "01" =
 	 t	#1 #1 substring$ "1" =
 	 t	#2 #2 substring$ "" =
 	 and or
 	 { "January" }
    { t #1 #2 substring$ "02" =
			t	#1 #1 substring$ "2" =
			t	#2 #2 substring$ "" =
			and or
      { "February" }
      { t #1 #2 substring$ "03" =
 		    t #1 #1 substring$ "3" =
 		    t	#2 #2 substring$ "" =
 		    and or
        { "March" }
        { t #1 #2 substring$ "04" =
        	t #1 #1 substring$ "4" =
        	or
          { "April" }
          { t #1 #2 substring$ "05" =
           	t #1 #1 substring$ "5" =
           	or
            { "May" }
            { t #1 #2 substring$ "06" =
  	          t #1 #1 substring$ "6" =
  	          or
              { "June" }
              { t #1 #2 substring$ "07" =
              	t #1 #1 substring$ "7" =
              	or
                { "July" }
                { t #1 #2 substring$ "08" =
 		              t #1 #1 substring$ "8" =
 		              or
                  { "August" }
                  { t #1 #2 substring$ "09" =
                    t #1 #1 substring$ "9" =
                    or
                    { "September" }
                    { t #1 #2 substring$ "10" =
                      { "October" }
                      { t #1 #2 substring$ "11" =
                        { "November" }
                        { t #1 #2 substring$ "12" =
                          { "December" }
                          { t } % No match
                        if$
                        }
                      if$
                      }
                    if$
                    }
                  if$
                  }
                if$
                }
              if$
              }
            if$
            }
          if$
          }
        if$
        }
      if$
      }
    if$
    }
  if$
 
}

FUNCTION {batitle}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
				'skip$
		    { "\batitle{" swap$ * "}" * }
			if$	
  	}
  if$
}
INTEGERS {sk}
FUNCTION {is.num}
{ chr.to.int$
  duplicate$ "0" chr.to.int$ < not
  swap$ "9" chr.to.int$ > not and
}

FUNCTION {byear}
{ duplicate$ empty$
    { pop$ "" }
    {'t :=
     t text.length$ 'sk :=
			#5 sk =
					{t #1 #4 substring$ 's :=
					 t #5 #1 substring$ 'longest.label :=
					 	longest.label is.num not	
							{"\byear{" s * "}" * longest.label * "," *}
							{"\byear{"  t * "}," * }
						if$
					}
					{"\byear{"  t * "}" * extra.label * "," *}
			if$
    }
  if$
}
FUNCTION {bissue}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
				'skip$
		    { "\bissue{" swap$ * "}" * }
			if$	
  	}
  if$
}
FUNCTION {bctitle}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
				'skip$
    		{"\bctitle{" swap$ * "}" *}
			if$	
  	}
  if$
}

FUNCTION {binstitute}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
				'skip$
		    { "\binstitute{" swap$ * "}" * }
			if$	
  	}
  if$
}
FUNCTION {bsnm}
{ duplicate$ empty$
    { pop$ "" }
    { "\bsnm{" swap$ * "}" * }
  if$
}
FUNCTION {bpublisher}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
    		 'skip$
    		 {"\bpublisher{" swap$ * "}" * }
    	if$
    }
  if$
}
FUNCTION {bfpage}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
    		 'skip$
		     { "\bfpage{" swap$ * "}" * }
    	if$
    }
  if$
}
FUNCTION {blpage}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
    		 'skip$
		     { "\blpage{" swap$ * "}" * }
    	if$
    }
  if$
}
FUNCTION {bvolume}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
		    { "\textbf{" swap$ * "}" * }
		    { "\bvolume{" swap$ * "}" * }
    	if$
    }
  if$
}
FUNCTION {betal}
{ duplicate$ empty$
    { pop$ "" }
    { "\betal{" swap$ * "}" * }
  if$
}
FUNCTION {binits}
{ duplicate$ empty$
    { pop$ "" }
    { "\binits{" swap$ * "}" * }
  if$
}
FUNCTION {bseriesno}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
		    { "\textbf{" swap$ * "}" * }
    		{ "\bseriesno{" swap$ * "}" * }
			if$	
  	}
  if$
}
FUNCTION {bbtitle}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
    		{"\textit{" swap$ * "}" *}
    		{"\bbtitle{" swap$ * "}" *}
			if$	
  	}
  if$
}


FUNCTION {bparticle}
{ duplicate$ empty$
    { pop$ "" }
    { "\bparticle{" swap$ * "}" * }
  if$
}
FUNCTION {bsuffix}
{ duplicate$ empty$
    { pop$ "" }
    { " \bsuffix{" swap$ * "}" * }
  if$
}
FUNCTION {blocation}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
				'skip$
		    { "\blocation{" swap$ * "}" * }
			if$	
  	}
  if$
}


FUNCTION {bjtitle}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
		    { "\textit{" swap$ * "}" * }
		    { "\bjtitle{" swap$ * "}" *}
			if$	
  	}
  if$
}

FUNCTION {springer.publisher}
{publisher #1 #8 substring$ "Springer" =
	{ "Springer"  }
  { publisher }
if$
}

FUNCTION {format.pub.address}
{ publisher empty$
	howpublished empty$
	and
    { address empty$
				'skip$
        {	insert.comma
        	address blocation output
        }
      if$
    }
    { address empty$
        {publisher empty$
		        {howpublished bpublisher} 
		        {publisher bpublisher} 
		     if$ 
		     #1 bother =
		        {", \blocation{???}" *  }
  				'skip$
		     if$
		     output   
        }
        {publisher empty$
		        {howpublished } 
		        {springer.publisher } 
		     if$ 
		      bpublisher output
					insert.comma
        	address blocation output
        }
      if$
    }
  if$
}
INTEGERS { nameptr namesleft numnames}
FUNCTION {format.author.editor}
{ 'b :=
   	b "editor" =
   	b "beditor" =
   	or
			{editor 's :=}
			{author 's :=}
		if$
 
	", " 'longest.label := 
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    {	 s nameptr "{vv~}" format.name$ bparticle 'v := 
       s nameptr "{ll}" format.name$ bsnm 'l :=   
    	s nameptr "{f{.}.}" format.name$ binits  'f := 
     	s nameptr "{jj}" format.name$ bsuffix 'j := 

   		l  "\bsnm{others}" =
   		l  "\bsnm{{others}}" =
   		l  "\bsnm{et al.}" =
   		l  "\bsnm{{et al.}}" =
   		or or or
   		{	b "bauthor" =
   		 	b "beditor" =
		   	or
		   		 {"et al."  * }
   				 {"\betal"  * }
				if$
  		}
   		{
		   	j empty$
				   {"" 'j :=} 		
			     'skip$
				if$

		   	f empty$
				   {"" 'longest.label :=} 		
			     'skip$
				if$

   	b "editor" =
	 		{"\beditor{" * v * l * longest.label  * f * j * "}"  * "" 't :=}
		  'skip$
		if$

   	b "author" =
	 		{"\bauthor{" * v * l * longest.label * f * j * "}" * "" 't :=}
		  'skip$
		if$

   	b "bauthor" =
   	b "beditor" =
   	or
	 		{"\oauthor{" * v * l * longest.label * f * j * "}" * "" 't :=}
		  'skip$
		if$
		 } 
		if$
		 	namesleft #0 >
        { namesleft #1 >
            {", " * t * }
            {""}
          if$
        }
        't
      
      if$
      nameptr #1 + 'nameptr := 
      namesleft #1 - 'namesleft :=
    }
  while$
  
}

FUNCTION {format.springer.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{vv~}{ll}{, f{.}.}{~jj}" format.name$ 't :=
    
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            { numnames #1 >
                { ", " * }
                'skip$
              if$
              t "others" =
                { " et~al." * }
                { "" * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}


FUNCTION {format.editors}
{ editor empty$
    { "" }
    {
      bother #0 =
				  {author empty$
    					{"beditor" format.author.editor}
    					{editor format.springer.names}
    				if$
    			}
 					{"editor"  format.author.editor}
 			if$
      editor num.names$ #1 >
        { " (eds.)" * }
        { " (ed.)" * }
      if$
    }
  if$
}
FUNCTION {format.authors}
{ author empty$
    { "" }
 		{ bother #0 =
				  {"bauthor" format.author.editor}
 					{"author"  format.author.editor}
 			if$
 		}
  if$
}


FUNCTION {cite.author.editor}
{ 's :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #3 >
    { pop$ " \textit{et~al.}" * }
    { #3 =
        { s #3 "{vv~}{ll}{ jj}{ f}" format.name$ "others" =
            { " \textit{et~al.}"  * }
            { ", " * s #2 "{vv~}{ll}" format.name$ * 
             ", and " * s #3 "{vv~}{ll}" format.name$ *  
            }
          if$
        }
		    {s num.names$ #2 =
    		        {s #2 "{vv~}{ll}{ jj}{ f}" format.name$ "others" =
            				{ " \textit{et~al.}"  * }
     		    				{ " and " * s #2 "{vv~}{ll}" format.name$ * }
     		    			if$
     		    		}
     		    		'skip$
        	 if$
        }
      if$
    }
  if$
}
FUNCTION {check.auth.edit.org}
{author empty$
		{
			editor empty$
					{
						organization empty$
								{""}
								{organization}
						if$		
					}
					{editor cite.author.editor}
			if$		
		}
		{author cite.author.editor}
 if$	
}

FUNCTION {check.year}
{year empty$
		{""}
		{year extra.label *
		}
	if$	
}

FUNCTION {output.bibitem}
{newline$
	  	"\bibitem[\protect\citeauthoryear{" write$
	   			check.auth.edit.org write$ 
	   	"}{" write$ 
	   			check.year write$ 
	   	"}]{" write$ 
	  			cite$ write$
  		"}" write$
  		newline$
  		""
  before.all 'output.state :=
}


INTEGERS { multiresult char.num k int}
FUNCTION {string.to.integer}
{ 't :=
    t text.length$ 'k :=
  #1 'char.num :=
      { t char.num #1 substring$ 's :=
	 	  s is.num
	 	  s "." =
	 	  or 
	 	  char.num k = not
	 	  and
	 	 	}
	 	 {char.num #1 + 'char.num :=}
  while$
  char.num #1 - 'char.num :=
  t #1 char.num substring$ 
  
%  "S" k * write$
}


FUNCTION {find.integer}
{ 'b :=
  #0 'int :=
    { int not
      b empty$ not
      and
    }
    { b #1 #1 substring$ 's :=
    	s is.num 
        {#1 'int :=}
        { b #2 global.max$ substring$ 'b := }
      if$
    }
  while$
  int 
}


FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$}
  if$
}
FUNCTION {note.presented}
 {note #1 #9 substring$ "presented" = 
 	note #1 #9 substring$ "Presented" = 
 or}
 
FUNCTION {n.filter}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "," =
      t #1 #1 substring$ "\" =
      t #1 #1 substring$ "~" =
      or or
            {  "" *
                  t #2 global.max$ substring$ 't :=
            }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { "" }
    { #0 bother =
    	 		{year extra.label * "," * }
			    { year  byear  }
	    if$
    }
  if$
}
FUNCTION {format.month}
{ month empty$
'skip$
{month sort.format.month}
if$
}
FUNCTION {formatpatent.date}
{ year empty$
    'skip$
    { month empty$
       { year }
        {format.month " " * year *}
      if$
    }
  if$
}
FUNCTION {month.year.date}
{ year empty$
    'skip$
    { month empty$
        {year byear}
        { format.month " " * year byear * }
      if$
    }
  if$
}
FUNCTION {bcomment}
{ duplicate$ empty$
    { pop$ "" }
    { #0 bother =
    	 		'skip$
			    { "\bcomment{" swap$ * "}" * }
	    if$
    }
  if$
}


FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {format.volume}
{ volume empty$
    { "book" type$ =
    		{number empty$
    			{""}
		      {publisher "l" change.case$ "asp" =
     			   {"CS-" number *}
        		 { 
			          publisher "l" change.case$ "esa" =
      			    	{"SP-" number *}
           				{number}
          			if$ 
        		 }
        		if$
			      bseriesno 
      		}
    			if$
    		}
    		{""} 
      if$
    }
    { publisher empty$
      {volume}
      {publisher "l" change.case$ "asp" =
        {"CS-" volume *}
        { 
          publisher "l" change.case$ "esa" =
           {"SP-" volume *}
           {volume}
          if$ 
        }
        if$
      }
      if$    
      bseriesno 
    }
  if$
}
FUNCTION {format.art.vol}
{ volume empty$
	'skip$
	{volume n.filter bvolume  }
  if$
	number empty$
    'skip$
    { "(" number bissue * ")" * *
      volume empty$
	{ "there's a number but no volume in " cite$ * warning$ }
	'skip$
      if$
    }
  if$
  
}

FUNCTION {format.series}
{ series empty$
		'skip$ 
    { #0 bother =
					{"\textit{" series * "}" * }
			    {"\bsertitle{" series * "}" * }
    	if$
    }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { "" 'v :=
			"" 'l :=    
			"" 'f :=    
    	edition "l" change.case$ 's :=
 				"1" s =
 				"first" s =  			
   			or
   				{
   					"1" 'v :=
						"st" 'l :=  
   				}
   				{
 						"2" s =
 						"second" s =  			
   					or
   						{
   							"2" 'v :=
								"nd" 'l :=  
   						}
   						{
 								"3" s =
 								"third" s =  			
   							or
   								{
   									"3" 'v :=
										"rd" 'l :=  
   								}
   								{
 										"4" s =
 										"fourth" s =  			
   									or
   										{
   											"4" 'v :=
												"th" 'l :=  
   										}
   										{
 												"5" s =
 												"fifth" s =  			
   											or
   												{
   													"5" 'v :=
														"th" 'l :=  
   												}
   												{
 														"6" s =
 														"sixth" s =  			
										   			or
   														{
   															"6" 'v :=
																"th" 'l :=  
										   				}
										   				{
												 				"7" s =
												 				"seventh" s =  			
												   			or
												   				{
												   					"7" 'v :=
																		"th" 'l :=  
												   				}
												   				{
														 				"8" s =
														 				"eighth" s =  			
														   			or
														   				{
														   					"8" 'v :=
																				"th" 'l :=  
														   				}
														   				{
																 				"9" s =
																 				"nineth" s =  			
																   			or
																   				{
																   					"9" 'v :=
																						"th" 'l :=  
																   				}
																   				{
   																						edition "t" change.case$ 'f :=
  																 				}
																   			if$	 
														   				}
														   			if$	 
												   				}
												   			if$	 
										   				}
   													if$	 
								   				}
								   			if$	 
						   				}
						   			if$	 
				   				}
				   			if$	 
   						}
   					if$	 
   				}
   			if$	 
   		 #0 bother =		
   				{	f "" =
   						{ v l *	'f :=}
   						'skip$
   					if$
   				}
   				{	f "" =
   						{ "\bedition{" v * "}" * l *	'f :=}
   						{ "\bedition{" f * "}" *	'f :=}
   					if$
   				}
   		if$
   		f " edn." *
    }
  if$
}
FUNCTION {format.isbn}
{ isbn empty$
    { "" }
    { 	#0 bother =
		    		{isbn}
		    		{"\bisbn{"  isbn * "}" *}
		    if$
		}	
  if$
}


FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
	"" 'l :=

    {t empty$ not}
    { t #1 #1 substring$  's :=
    	
      s is.num not
        { "" l = not
        		{t find.integer 
								{#1 'multiresult := }
								{#0 'multiresult := }
       		 		if$
       		 		"" 't :=
       			}
       			{
       			t #2 global.max$ substring$ 't :=
       			}
       		if$	
        }
        { l  s * 'l :=
        	t #2 global.max$ substring$ 't := 
        }
      if$
    }
  while$
  multiresult 
}
FUNCTION {w.to.z}{
  f "w" =
  f "x" =
  f "y" =
  f "z" =
  or or or or
}


FUNCTION {is.letter}
{"l" change.case$ 'f :=
  f "a" =
  f "b" =
  f "c" =
  f "d" =
  f "e" =
  f "f" =
  f "g" =
  f "h" =
  f "i" =
  f "j" =
  f "k" =
  f "l" =
  f "m" =
  f "n" =
  f "o" =
  f "p" =
  f "q" =
  f "r" =
  f "s" =
  f "t" =
  f "u" =
  f "v" =
  w.to.z
  or or or or or or or or or or or or or or or or or or or or or 
  {#1}
  {#0}
  if$
} 

FUNCTION {clearpage}
{ 't :=
	"" 's :=
	"" 'l :=
	
    { t empty$ not }
    {
    	t #1 #1 substring$ 's :=
      s is.num not
      s is.letter not
      and  
				'skip$
        {	l  s * 'l := 	}
      if$
      t #2 global.max$ substring$ 't :=
		}
  while$
  l
       
}


FUNCTION {do.pages}
{'t :=
	"" 'j :=
	"" 'v :=
    {t empty$ not}
    { t #1 #1 substring$  's :=
      s is.num not
      s "," = not
      s is.letter not
      and  
      and
        { "" j = 
       			{  
       				t #2 global.max$ substring$ 't :=
       			}
        		{t find.integer 
								{t clearpage  'v := }
								'skip$
       		 		if$
       		 	
        		 	"" 't := 
       			}
       		if$	
        }
        {
        j  s * 'j :=
          	t #2 global.max$ substring$ 't := 
        }
      if$
    }
  while$
  j clearpage  'j :=
  j  bfpage "\,--\,"  * v blpage *
}


FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        {insert.comma pages do.pages }
        {insert.comma pages clearpage bfpage}

      if$
    }
  if$
}

FUNCTION {format.url}
{ url empty$
    { "" }
    { 	#0 bother =
				    {"\url{" url * "}" * }
				    {"\burl{" url * "}" * }
		    if$
		}	
  if$
}



FUNCTION {format.doi}
{ doi empty$
		 {""}
		 { "doi:\doiurl{" doi * "}" * }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    {#1 bother =
    			{ editor empty$
      			  { "In: \bbtitle{???}"  output}
  		      	{ "In: " format.editors * output
        			  "\bbtitle{???}"  output 
      			  }
  				  if$
	    		}
    			'skip$
    	if$
    }
    { editor empty$
        { "In: " booktitle bbtitle * output}
        { "In: " format.editors * output
        	 booktitle bbtitle  output 
        }
      if$
    }
    
  if$
}

FUNCTION {format.in.ed}
{ title empty$
   'skip$
    { editor empty$
        {  title bbtitle output}
       { author empty$
        {  format.editors output
        		stupid.colon
        		format.date output
        		title bbtitle output
        }
        { "In: " format.editors * output 
        	title bbtitle output
        }
        if$
   		 }
      if$
    }
    
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {patent.number}
{    number empty$
		 'skip$
    { number }
  if$
}
INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}   
 
FUNCTION {format.inpres}
{ "l" change.case$ 't :=
      "in press: " #10
       "in press. " #10
        "in press " #9 t chop.word
      chop.word
     chop.word
  #1 global.max$ substring$
}

FUNCTION {bcomment.note}
{note empty$
'skip$
 {note format.inpres bcomment output}
 if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.chapter.and.note}
{		note empty$ chapter empty$ organization empty$ and and
		'skip$
	{	chapter empty$
		"nenumeris" last.label =
		or
			{organization empty$
					{note bcomment output}
					{note empty$
							{organization bcomment output}
							{organization ". " * note * bcomment output}
					 if$
					}
			 if$
			}
			{note empty$
				{"Chap. "  chapter * bcomment output}
						{		type empty$
									{ "Chap. " }
									{ type "t" change.case$ "Section" = 
									 		{	"Sect. " }
											{ "Chap. " }
										if$	
									}
								if$
										chapter * ". " * note * bcomment  output
						}
					if$
				}
			if$
	}
	if$
		
}

FUNCTION {item.pabaiga}
{
  new.sentence
  type$ "unpublished" =
  		{	note empty$
  				'skip$
  				{note.presented
  						'skip$
  						{note output}
  				 if$		
  				}
  			if$	
  		}
			{
			  type$ "proceedings" =
						{author empty$ editor empty$ and
								'bcomment.note
					 			'format.chapter.and.note 
						 if$	
						}
			 			'format.chapter.and.note 
			 	if$		
			}
	if$
	new.sentence 
  format.isbn output
  new.sentence
  format.doi  output
  new.sentence
  format.url output
  fin.entry
}
FUNCTION {insert.element}
{	#0 bother =
  		{element "{botherref}" * write$ newline$}
  		{
			   type$ "article" =
						{element "{barticle}" * write$ newline$}
						'skip$
				 if$
				 type$ "book" =
		     type$ "proceedings" =
         type$ "manual" =
         type$ "booklet" =
         or or or 
					  {element "{bbook}" * write$ newline$}
						'skip$
				 if$
					
			   type$ "inbook" =
					  {	"nenumeris" last.label =
					  		{element "{bchapter}" * write$ newline$}
						  	{element "{bbook}" * write$ newline$}
					  	if$	
					  }
						'skip$
				 if$
			  
			   type$ "incollection" =
		     type$ "inproceedings" =
		     or 
					  {element "{bchapter}" * write$ newline$}
						'skip$
				 if$

   		}
  if$
}
FUNCTION {end.element}
{ "\end" 'element :=
	item.pabaiga
  insert.element
  "\endbibitem" write$ newline$
}
FUNCTION {begin.element}
{ "\begin" 'element :=
  insert.element
}


FUNCTION {article}
{ output.bibitem
	author empty$
	institution empty$ 
	editor empty$
	and and
	journal empty$ 
  year empty$ 
 	or or 
  volume empty$ pages  empty$ 
  doi empty$ and
   or or
			{#0 'bother :=} 
			{#1 'bother :=} 
	if$	

begin.element
  author empty$
    { editor empty$
    			'skip$
     			{format.editors "author and editor" output.check stupid.colon}
    	if$
    }
    { format.authors output.nonnull
    	stupid.colon
    }
  if$
			format.date output
			format.title batitle "title" output.check
		    journal empty$
						'skip$
    				{new.sentence journal bjtitle  output}
				if$
    volume empty$
    'skip$
		{format.art.vol output }
		if$
   	    pages empty$
      'skip$
      {insert.comma}
      if$
      format.pages output
end.element
}

FUNCTION {patent}
{ output.bibitem
#0 'bother :=
begin.element
 format.authors output.nonnull
  stupid.colon
    format.title "title" output.check
    add.period$
		patent.number output
		insert.comma
  	formatpatent.date output
end.element
}

FUNCTION { other } { patent }

FUNCTION {book}
{ output.bibitem
	author empty$
	institution empty$ 
	organization empty$ 
	editor empty$
	and and and
	title empty$ 
  year empty$ 
 	publisher empty$  
   or or or 
			{#0 'bother :=} 
			{#1 'bother :=} 
	if$	

begin.element
	  author empty$
    	{ format.editors "author and editor" output.check}
    	{ format.authors output.nonnull}
  if$
  stupid.colon
  format.date output
  format.title bbtitle "title" output.check
    	series empty$
         {
         format.volume output
         insert.comma 
         format.edition output
         new.sentence
         }
         {
         insert.comma
         format.edition output
         insert.comma
         format.series output
         format.volume output
         }
      if$ 
			publisher empty$
			  'skip$
  			{edition empty$ not series empty$  and
  					'new.sentence
  					'insert.comma
  			 if$		
  			}
		  if$
      format.pub.address
      new.sentence
      format.pages output
end.element      
}

FUNCTION {booklet}
{output.bibitem
	author empty$
	title empty$ 
  year empty$ 
 	howpublished empty$  
   or or or
			{#0 'bother :=} 
			{#1 'bother :=} 
	if$	

begin.element
  author empty$
 		 'skip$
  		{format.authors output.nonnull stupid.colon}
  if$
  format.date  output
  format.title bbtitle "title" output.check
  new.sentence
  insert.comma
  format.pub.address
	new.sentence
end.element
}
FUNCTION {misc}
{output.bibitem
 #0 'bother :=
begin.element
  author empty$
 		 'skip$
  		{format.authors output.nonnull stupid.colon}
  if$
  format.date  output
  format.title bbtitle "title" output.check
  new.sentence
  insert.comma
  format.pub.address
	new.sentence
end.element
}

FUNCTION {inbook}
{ output.bibitem

  author empty$
	institution empty$ 
	organization empty$ 
	editor empty$
	and and and
	title empty$ 
  year empty$ 
 	publisher empty$ 
  or or or
			{#0 'bother :=} 
			{#1 'bother :=} 
	if$	

	chapter empty$
			{	"" 'last.label :=}
  		{	chapter string.to.integer empty$ author empty$ not and
						{	"nenumeris" 'last.label :=}
						{	"" 'last.label :=}
  			if$
  		}
  if$
  
begin.element
 author empty$
  'skip$
  {format.authors output.nonnull
  	stupid.colon
  		format.date output
  }
  if$ 
    		"nenumeris" last.label =
					{chapter bctitle output
      			add.period$
      		}
  				'skip$
			if$
   format.in.ed 
    	series empty$
         {
         format.volume output
         insert.comma 
         format.edition output
         new.sentence
         }
         {
         insert.comma
         format.edition output
         insert.comma
         format.series output
         format.volume output
         }
      if$ 
			publisher empty$
			  'skip$
  			{edition empty$ not series empty$  and
  					'new.sentence
  					'insert.comma
  			 if$		
  			}
		  if$
      format.pub.address
      new.sentence
      format.pages output
  end.element
}

FUNCTION {incollection}
{ output.bibitem
  author empty$
	institution empty$ 
	and
	booktitle empty$ 
	title empty$
  year empty$ 
 	publisher empty$  
   or or or or
			{#0 'bother :=} 
			{#1 'bother :=} 
	if$	
begin.element
	author empty$
			'skip$	
			{format.authors output.nonnull
			 stupid.colon
			}
	if$		 
	format.date output
  format.title bctitle "title" output.check
  	title empty$
  	'skip$
   	{new.sentence}
  	if$
    		format.in.ed.booktitle 
    	series empty$
         {
         format.volume output
         insert.comma 
         format.edition output
         }
         {
         edition empty$
         		'skip$
         		{insert.comma 
		         format.edition output
						 insert.comma
						} 
         if$		
         format.series output
         format.volume output
        }
      if$ 
 		  insert.comma
      format.pub.address
      new.sentence
      format.pages output
end.element
 }

FUNCTION {inproceedings}
{ output.bibitem
	author empty$
	institution empty$ 
	and
	title empty$ 
	year empty$ 
 	publisher empty$ 
   or or or
			{#0 'bother :=} 
			{#1 'bother :=} 
	if$	
begin.element
  format.authors output.nonnull
  author empty$
 		 'skip$
  	 {stupid.colon}
  if$
   format.date output
  format.title bctitle "title" output.check
 	 title empty$ booktitle empty$ not and
		  'skip$
			 {new.sentence}
	 if$
		format.in.ed.booktitle 
      series empty$
         'skip$
        {insert.comma format.series output}
      if$  
      	format.volume output
    	publisher empty$
   			'skip$
    		{insert.comma}
			if$
    format.pub.address
      pages empty$
   		   'skip$
    			{insert.comma}
    	if$  
    format.pages output
end.element
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem

	author empty$
	organization empty$ 
	title empty$ 
  year empty$ 
 	address  empty$ 
  
   or or or or
			{#0 'bother :=} 
			{#1 'bother :=} 
	if$	
begin.element

  author empty$
    { organization empty$
        'skip$
        { organization bpublisher output.nonnull
          stupid.colon% add.period$
        }
      if$
    }
    { format.authors output.nonnull
    stupid.colon}
  if$
  		format.date output
  title empty$
  		'skip$
  		{format.title bbtitle output
 			}
   if$
  edition empty$
    	{new.sentence}
 			{insert.comma}
	if$
  format.edition output
  edition empty$
			'skip$
    	{new.sentence}
	if$
   author empty$ organization empty$
   or
        'skip$
        { organization bpublisher output.nonnull
          insert.comma
        }
  if$
  address empty$
     'skip$
     {address blocation output}
  if$
  end.element
}


FUNCTION {phdthesis}
{output.bibitem
#0 'bother :=

begin.element
  author empty$
 		 'skip$
  		{format.authors output.nonnull stupid.colon}
  if$
  format.date output
  format.title "title" output.check
  new.sentence
  type$ "mastersthesis"  =
  		{"Master's thesis" format.thesis.type output.nonnull}
  		{"PhD thesis" format.thesis.type output.nonnull}
  if$		
  school empty$
     'skip$
     { insert.comma }
  if$
  school "school" output.check
  address empty$
     'skip$
     { insert.comma }
  if$
  address output
end.element
}
FUNCTION {mastersthesis}{phdthesis}


FUNCTION {proceedings}
{ output.bibitem
	author empty$
	institution empty$ 
	organization empty$ 
	editor empty$
	and and and
	title empty$ 
  year empty$ 
 	publisher empty$
   or or or 
			{#0 'bother :=} 
			{#1 'bother :=} 
	if$	

begin.element
  author empty$
   	{ editor empty$
   			 {organization binstitute "organization" output.check }
			   { format.editors output.nonnull}
  		if$ 
  	}
    { format.authors output.nonnull}
  if$
    stupid.colon
  format.date output
  format.title bbtitle output
      series empty$
         'skip$
        {insert.comma format.series output}
      if$  
      	format.volume output
    	publisher empty$
   			'skip$
    		{insert.comma}
			if$
    format.pub.address
      pages empty$
   		   'skip$
    			{insert.comma}
    	if$
  format.pages output
end.element
}	

FUNCTION {techreport}
{output.bibitem
#0 'bother :=

begin.element
  author empty$
 		 'skip$
  		{format.authors output.nonnull stupid.colon}
  if$
  format.date output
  format.title "title" output.check
  new.sentence
  format.tr.number output.nonnull
  institution empty$
     'skip$
     { insert.comma }
  if$
  institution "institution" output.check
  address empty$
     'skip$
     { insert.comma }
  if$
  address output
end.element
}

FUNCTION {unpublished}
{output.bibitem
#0 'bother :=

begin.element
  author empty$
 		 'skip$
  		{format.authors output.nonnull stupid.colon}
  if$
   year empty$ not author empty$ not and
  {format.date output}
  'skip$
  if$
  format.title "title" output.check
  title empty$
  'skip$
  {new.sentence}
  if$
  note empty$
    'skip$
  	{	note.presented 
  				{note output}
    			'skip$
  		if$
  	}
  if$
   year empty$ not author empty$ and
  		{insert.comma year output}
  		'skip$
  if$
end.element
}

FUNCTION {default.type} { unpublished }

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}


READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}
FUNCTION {format.lab.names}
{ 's :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
        'skip$
        { s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " et~al." * }
            { " and " * s #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            'key
          if$
        }
        { editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        'key
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {calc.short.authors}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
        'editor.key.organization.label
        { type$ "manual" =
            'author.key.organization.label
            'author.key.label
          if$
        }
      if$
    }
  if$
  'short.list :=
}

FUNCTION {calc.label}
{ calc.short.authors
  short.list
  "("
  *
  year duplicate$ empty$
  short.list key field.or.null = or
     { pop$ "" }
     'skip$
  if$
  *
  'label :=
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
        { "   " * numnames int.to.str$ * "   " *}
        'skip$
      if$
      s nameptr "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = 
      t "others" = 
      and
        { "et al" * }
        { t sortify * }
      if$
		#3 numnames  <
  			{#0 'namesleft :=
  				 	" zzz   " *
  			}    
	      {
	     	  nameptr #1 + 'nameptr :=
  	    	namesleft #1 - 'namesleft :=
  	    }
  	  if$  	
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
        { "to sort, need author or key in " cite$ * warning$
          "zzz"
        }
        { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
        { key empty$
            { "to sort, need author, editor, or key in " cite$ * warning$
              "z"
            }
            { key sortify }
          if$
        }
        { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
        { key empty$
            { "to sort, need author, organization, or key in " cite$ * warning$
              "z"
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
        { key empty$
            { "to sort, need editor, organization, or key in " cite$ * warning$
              "z"
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}
{ calc.label
  label sortify
  "    "
  *
  type$ "book" =
  type$ "inbook" =
  or
 		{author empty$
   		'editor.organization.sort
      'author.organization.sort
     if$
    }
    { type$ "proceedings" =
      type$ "incollection" =
       or
    		{author empty$
        		'editor.organization.sort
            'author.organization.sort
        if$
        }
        { type$ "manual" =
            'author.organization.sort
            'author.sort
          if$
        }
      if$
    }
  if$
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$ 'sort.label :=
  sort.label *
  #1 entry.max$ substring$ 'sort.key$ :=
}

ITERATE {presort}

SORT


INTEGERS { longest.label.width last.extra.num number.label }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #0 int.to.chr$ 'last.label :=
  "" 'j :=
  #0 'longest.label.width :=
  #0 'last.extra.num :=
  #0 'number.label :=
}

FUNCTION {forward.pass}
{ last.label label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      label 'last.label :=
    }
  if$
  number.label #1 + 'number.label :=
}

FUNCTION {reverse.pass}
{ j "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  extra.label 'j :=
  label extra.label * 'label :=
}

EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {bib.sort.order}
{ sort.label  'sort.key$ :=
%sort.key$ top$
}

ITERATE {bib.sort.order}

SORT

FUNCTION {write.preambule}
{   "\begin{thebibliography}{" number.label int.to.str$ * "}" * write$ newline$
	"% BibTex style file: spr-mp-sola.bst, 2010-05-13" write$ newline$
	"\ifx \bisbn   \undefined \def \bisbn  #1{ISBN #1}\fi" write$ newline$
	"\ifx \binits  \undefined \def \binits#1{#1}\fi" write$ newline$
	"\ifx \bauthor  \undefined \def \bauthor#1{#1}\fi" write$ newline$
	"\ifx \batitle  \undefined \def \batitle#1{#1}\fi" write$ newline$
	"\ifx \bjtitle  \undefined \def \bjtitle#1{\textit{#1}}\fi" write$ newline$
	"\ifx \bvolume  \undefined \def \bvolume#1{\textbf{#1}}\fi" write$ newline$
	"\ifx \byear  \undefined \def \byear#1{#1}\fi" write$ newline$
	"\ifx \bissue  \undefined \def \bissue#1{#1}\fi" write$ newline$
	"\ifx \bfpage  \undefined \def \bfpage#1{#1}\fi" write$ newline$
	"\ifx \blpage  \undefined \def \blpage #1{#1}\fi" write$ newline$
	"\ifx \burl  \undefined \def \burl#1{\textsf{#1}}\fi" write$ newline$
	"\ifx \href  \undefined \def \href#1#2{\textsf{#2}}\fi" write$ newline$
	"\ifx \doiurl  \undefined \def \doiurl#1{\href{http://dx.doi.org/#1}{\textsf{#1}}}\fi" write$ newline$
	"\ifx \betal  \undefined \def \betal{\textit{et al.}}\fi" write$ newline$
	"\ifx \binstitute  \undefined \def \binstitute#1{#1}\fi" write$ newline$
	"\ifx \bctitle  \undefined \def \bctitle#1{#1}\fi" write$ newline$
	"\ifx \beditor  \undefined \def \beditor#1{#1}\fi" write$ newline$
	"\ifx \bpublisher  \undefined \def \bpublisher#1{#1}\fi" write$ newline$
	"\ifx \bbtitle  \undefined \def \bbtitle#1{\textit{#1}}\fi" write$ newline$
	"\ifx \bedition  \undefined \def \bedition#1{#1}\fi" write$ newline$
	"\ifx \bseriesno  \undefined \def \bseriesno#1{\textbf{#1}}\fi" write$ newline$
	"\ifx \blocation  \undefined \def \blocation#1{#1}\fi" write$ newline$
	"\ifx \bsertitle  \undefined \def \bsertitle#1{\textit{#1}}\fi" write$ newline$
	"\ifx \bsnm \undefined \def \bsnm#1{#1}\fi" write$ newline$
	"\ifx \bsuffix \undefined \def \bsuffix#1{#1}\fi" write$ newline$
	"\ifx \bparticle \undefined \def \bparticle#1{#1}\fi" write$ newline$
	"\ifx \barticle \undefined \def \barticle#1{}\fi" write$ newline$

}


FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  write.preambule
  "\ifx \botherref \undefined \def \botherref#1{}\fi" write$ newline$
  "\ifx \url \undefined \def \url#1{\textsf{#1}}\fi" write$ newline$
	"\ifx \bchapter \undefined \def \bchapter#1{}\fi" write$ newline$
	"\ifx \bbook \undefined \def \bbook#1{}\fi" write$ newline$
	"\ifx \bcomment \undefined \def \bcomment#1{#1}\fi" write$ newline$
	"\ifx \oauthor \undefined \def \oauthor#1{#1}\fi" write$ newline$
	"\ifx \citeauthoryear \undefined \def \citeauthoryear#1{#1}\fi" write$ newline$
	"\def \endbibitem {}" write$ newline$
}
EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
 "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}




