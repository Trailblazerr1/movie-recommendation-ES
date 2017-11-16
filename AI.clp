;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MOVIE RECOMMENDATION SYSTEM;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; MAIN MODULE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;QUESTION AND ANSWERS TEMPLATE;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate question
	(slot text)
	(slot type)
	(slot ident))

(deftemplate answer
	(slot ident)
	(slot text))

(deftemplate recommendation
	(slot movie))

;;FACTS


(deffacts question-data
	"The questions the system can ask."
		(question (ident drama) (type yes-no)
				(text "Do you like Drama ?"))

		(question (ident horror) (type yes-no)
				(text "Do you like Horror ?"))

		(question (ident action) (type yes-no)
				(text "Doy you like Action ?"))

		(question (ident animated) (type yes-no)
				(text "Doy you like Animated ?"))

		(question (ident sci-fi) (type yes-no)
				(text "Do you like Sci-Fi ?"))

		(question (ident adventure) (type yes-no)
				(text "Do you loke Adventure ?"))

		(question (ident romantic) (type yes-no)
				(text "Doy you like Romantic ?"))

		(question (ident comedy) (type yes-no)
				(text "Do you like Comedy ?"))

		(question (ident mood) (type happy-sad-motivated)
				(text "Tell me your mood ?"))

		(question (ident group) (type alone-family-partner)
				(text "Are you with Family/Partner/Alone?"))

		(question (ident age) (type child-young-adult)
					(text "What is your age group ?"))
		
)	

(defglobal ?*crlf* = "
")

;; ASK MODULE

(defmodule ask)

(deffunction is-of-type (?answer ?type)
	
	"Check that the answer has the right form"
	(if (eq ?type yes-no) then
		(return (or (eq ?answer yes) (eq ?answer no)))

	elif (eq ?type happy-sad-motivated) then
		 (return (or (eq ?answer happy) (or (eq ?answer sad) (eq ?answer motivated) )))

	elif (eq ?type alone-family-partner) then
		 (return (or (eq ?answer alone) (or (eq ?answer family) (eq ?answer partner) )))

	elif (eq ?type child-young-adult) then
		(return (or (eq ?answer child) (or (eq ?answer young) (eq ?answer adult) ))) )
)

(deffunction ask-user (?question ?type)

  "Ask a question, and return the answer"
  (bind ?answer "")
  (while (not (is-of-type ?answer ?type)) do
         (printout t ?question " ")
         (if (eq ?type yes-no) then
           (printout t "(yes or no) "))
	     (if (eq ?type happy-sad-motivated) then
           (printout t "(happy or sad or motivated) "))
         (if (eq ?type alone-family-partner) then
           (printout t "(alone or family or partner) "))
         (if (eq ?type child-young-adult) then
           (printout t "(child or young or adult) "))
   
    (bind ?answer (read)))
 (return ?answer))


(defrule ask::ask-question-by-id

	"Given the identifier of a question, ask it and assert the answer"
	(declare (auto-focus TRUE))
	(MAIN::question (ident ?id) (text ?text) (type ?type))
	(not (MAIN::answer (ident ?id)))
	?ask <- (MAIN::ask ?id)
	=>
	(bind ?answer (ask-user ?text ?type))
	(assert (answer (ident ?id) (text ?answer)))
	(retract ?ask)
	(return))


;; RULES MODULE

(defmodule mode1)

(defrule request-mood

	=>
	(assert (ask mood))
)

(defmodule mode2)

(defrule request-age

	=>
	(assert (ask age))
)

(defmodule mode3)

(defrule request-group
	=>
	(assert (ask group))

)

(defmodule mode4)

(defrule request-drama
	=>
	(assert (ask drama))
)
(defrule request-horror
	=>
	(assert (ask horror))
)
(defrule request-action
	=>
	(assert (ask action))
)
(defrule request-sci-fi
	=>
	(assert (ask sci-fi))
)
(defrule request-adventure
	=>
	(assert (ask adventure))
)
(defrule request-comedy
	=>
	(assert (ask comedy))
)
(defrule request-romantic
	=>
	(assert (ask romantic))
)
(defrule request-animated
	=>
	(assert (ask animated))
)


;; STARTUP MODULE

(defmodule startup)

(defrule print-start

	=>
	(printout t crlf crlf crlf)
	(printout t "*******************************************************" crlf)
	(printout t "*******************************************************" crlf)
	(printout t "*****WELCOME TO MOVIE RECOMMENDATION EXPERT SYSTEM*****" crlf)
	(printout t "*******************************************************" crlf)
	(printout t "*******************************************************"crlf)
	(printout t "*******************************************************" crlf crlf)
	(printout t "Please Answer the questions and I will recommend you a movie" crlf)
	(printout t "That may interest you.")
	(printout t crlf crlf crlf)

)
;; EXPERT SYSTEM MODULE WITH RULES

(defmodule recommend)

(defrule sad_1
	(answer (ident mood) (text sad))
	=>
	(assert
		(recommendation (movie "FRUIT VALE STATION"))
	)
)

(defrule happy_1
	(answer (ident mood) (text happy))
	=>
	(assert 
		(recommendation (movie "LAST HOLIDAY"))
	)
)

(defrule motivated_1
	(answer (ident mood) (text motivated))
	=>
	(assert
		(recommendation (movie "GOOD WILL HUNTING"))
	)
)

(defrule movie-action-horror-sci-fi
	(answer (ident action) (text yes))
	(answer (ident horror) (text yes))
	(answer (ident sci-fi) (text yes))
	=>
	(assert
	(recommendation (movie "LIGHTS OUT"))
	)
)

(defrule movie-sci-fi-adventure
	(answer (ident sci-fi) (text yes))
	(answer (ident adventure) (text yes))
	=>
	(assert
	(recommendation (movie "JOURNEY TO THE CENTER OF EARTH"))
	)
)

(defrule movie-action-comedy
	(answer (ident action) (text yes))
	(answer (ident comedy) (text yes))
	=>
	(assert
	(recommendation (movie "RUSH HOUR"))
	)
)

(defrule movie-drama-action
	(answer (ident action) (text yes))
	(answer (ident drama) (text yes))
	=>
	(assert
	(recommendation (movie "AVENGERS"))
	)
)

(defrule movie-horror-sci-fi
	(answer (ident horror) (text yes))
	(answer (ident sci-fi) (text yes))
	=>
	(assert
	(recommendation (movie "BABA DOOK"))
	)
)

(defrule movie-drama
	(answer (ident drama) (text yes))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "TITANIC"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "DUNKIRK"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "THE GODFATHER"))))
)

(defrule movie-horror
	(answer (ident horror) (text yes))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "THE CONJURING"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "ANNABELLE"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "EXORCIST"))))
)

(defrule movie-action
	(answer (ident action) (text yes))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "FAST AND FURIOUS"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "DIE"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "300"))))
)

(defrule movie-sci-fi
	(answer (ident sci-fi) (text yes))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "STARS WARS"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "INTERSTELLAR"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "INCEPTION"))))
)

(defrule movie-adventure
	(answer (ident adventure) (text yes))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "JURRASIC PARK"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "LIFE OF PI"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "APOCALYPTO"))))
)

(defrule movie-comdey
	(answer (ident comedy) (text yes))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "OLD SCHOOL"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "THE HANGOVER"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "STEP BROTHERS"))))
)

(defrule movie-romantic
	(answer (ident romantic) (text yes))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "THE NOTEBOOK"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "A WALK TO REMEMBER"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "THE HOLIDAY"))))
)

(defrule movie-animated
	(answer (ident animated) (text yes))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "THE LION KING"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "KUNG FU PANDA"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "ICE AGE"))))
)

(defrule movie-horror-adult
	(answer (ident horror) (text yes))
	(answer (ident adult) (text yes))
	=>
	(assert
	(recommendation (movie "IT"))
	)
)

(defrule movie-adult
	(answer (ident age) (text adult))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "FACING WIDOWS"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "INTIMACY"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "KNOCKED UP"))))
)

(defrule movie-young
	(answer (ident age) (text young))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "THE LONE RANGER"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "DEADPOOL"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "UNBROKEN"))))
)

(defrule movie-child
	(answer (ident age) (text child))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "KARATE KID"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "ALADDIN"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "HOME ALONE"))))
)

(defrule movie-alone
	(answer (ident group) (text alone))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "THE MATRIX"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "THE BIG SHORT"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "THE DAMNED UNLIKE"))))
)

(defrule movie-partner
	(answer (ident group) (text partner))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "THE VOW"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "FRANKIE AND JOHNY"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "THE BEST OF YOU"))))
)

(defrule movie-family
	(answer (ident group) (text family))
	=>
	(bind ?y (mod (random) 3))
	(if (eq ?y 0) then
		(assert (recommendation (movie "DOLPHIN TALE"))))
	(if (eq ?y 1) then
		(assert (recommendation (movie "THE MUPPPETS"))))
	(if (eq ?y 3) then
		(assert (recommendation (movie "NIGHT AT THE MUSEUM"))))
)

;;RESULT

(defmodule report)

(defrule result 
    ?r1 <- (recommendation (movie ?f1))
    (not (recommendation (movie ?f2&:(< (str-compare ?f2 ?f1) 0))))
    =>
    
    (printout t crlf "WATCH THIS MOVIE => " ?f1  crlf)
    (retract ?r1)
)

;;run module

(deffunction expert-system ()
	(reset)
	(focus startup mode1 mode2 mode3 mode4 recommend report)
	(run)
)

(while TRUE
	(expert-system))

