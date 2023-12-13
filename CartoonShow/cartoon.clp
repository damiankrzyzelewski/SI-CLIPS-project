;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle))
   (multislot conclusions))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))
   
;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""

  =>
  
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************
(defrule if-video-game-based ""

   (logical (start))

   =>

   (assert (UI-state (display StartQuestion)
                     (relation-asserted video-game-based)
                     (response Yes)
                     (valid-answers Yes No))))

(defrule if-a-celebrity ""
	(logical (video-game-based No))
   =>
   (assert (UI-state (display CelebrityQuestion)
                     (relation-asserted celebrity)
                     (response Yes)
                     (valid-answers Yes No))))
   
(defrule if-nintendo-franchise ""

   (logical (video-game-based Yes))

   =>

   (assert (UI-state (display NintendoQuestion)
                     (relation-asserted nintendo-franchise)
                     (response Yes)
                     (valid-answers Yes No))))


   
(defrule if-animal-furries-and-the-like ""

   (logical (celebrity No))

   =>

   (assert (UI-state (display AnimalQuestion)
                     (relation-asserted animals-furries)
                     (response Yes)
                     (valid-answers Yes No))))
   
(defrule if-cats ""

   (logical (animals-furries Yes))

   =>

   (assert (UI-state (display CatsQuestion)
                     (relation-asserted cats)
                     (response Yes)
                     (valid-answers Yes No))))

(defrule if-rodents ""

   (logical (animals-furries Yes))
   (logical (cats No))

   =>

   (assert (UI-state (display RodentsQuestion)
                     (relation-asserted rodents)
                     (response Yes)
                     (valid-answers Yes No))))

(defrule if-dinosaurs ""

   (logical (animals-furries Yes))
   (logical (rodents No))

   =>

   (assert (UI-state (display DinosaursQuestion)
                     (relation-asserted dinosaurs)
                     (response Yes)
                     (valid-answers Yes No))))

(defrule if-ducks ""
   (logical (animals-furries Yes))
   (logical (dinosaurs No))
   =>
   (assert (UI-state (display DucksQuestion)
                     (relation-asserted ducks)
                     (response Yes)
                     (valid-answers Yes No))))


(defrule if-bears ""
   (logical (animals-furries Yes))
   (logical (ducks No))
   =>
   (assert (UI-state (display BearsQuestion)
                     (relation-asserted bears)
                     (response Yes)
                     (valid-answers Yes No))))


(defrule if-monkeys ""
   (logical (animals-furries Yes))
   (logical (bears No))
   =>
   (assert (UI-state (display MonkeysQuestion)
                     (relation-asserted monkeys)
                     (response Yes)
                     (valid-answers Yes No))))


((defrule if-cows ""
   (logical (animals-furries Yes))
   (logical (monkeys No))
   =>
   (assert (UI-state (display CowsQuestion)
                     (relation-asserted cows)
                     (response Yes)
                     (valid-answers Yes No))))

(defrule if-godless-abominations""
	(logical (animals-furries Yes))
   (logical (cows No)) 
  
   =>

   (assert (UI-state (display GAQuestion)
                     (relation-asserted godless-abominations)
                     (response Yes)
                     (valid-answers Yes No))))
(defrule if-giant-robots""
	(logical (animals-furries No))
   =>

   (assert (UI-state (display RobotsQuestion)
                     (relation-asserted giant-robots)
                     (response Yes)
                     (valid-answers Yes No))))
(defrule if-movie-based ""
	(logical (giant-robots No))
   =>

   (assert (UI-state (display MovieQuestion)
                     (relation-asserted movie-based)
                     (response Yes)
                     (valid-answers Yes No))))
                     
(defrule if-r-rated ""
	(logical (movie-based Yes))
   =>

   (assert (UI-state (display RQuestion)
                     (relation-asserted r-rated)
                     (response Yes)
                     (valid-answers Yes No)))) 
(defrule if-post-apo ""
	(logical (movie-based No))
   =>

   (assert (UI-state (display PostApoQuestion)
                     (relation-asserted post-apo)
                     (response Yes)
                     (valid-answers Yes No))))  
(defrule if-swords-sorcery ""
	(logical (post-apo No))
   =>

   (assert (UI-state (display SwordsQuestion)
                     (relation-asserted swords-sorcery)
                     (response Yes)
                     (valid-answers Yes No)))) 
(defrule if-military-law ""
	(logical (post-apo No))
   =>

   (assert (UI-state (display MilitaryQuestion)
                     (relation-asserted military-law)
                     (response Yes)
                     (valid-answers Yes No))))
(defrule if-space ""
	(logical (military-law No))
   =>
   (assert (UI-state (display SpaceQuestion)
                     (relation-asserted space)
                     (response Yes)
                     (valid-answers Yes No))))
(defrule if-cowboys ""
	(logical (space No))
   =>
   (assert (UI-state (display CowboysQuestion)
                     (relation-asserted cowboys)
                     (response Yes)
                     (valid-answers Yes No)))) 
(defrule if-understand-wgo ""
	(logical (space No))
   =>
   (assert (UI-state (display WgoQuestion)
                     (relation-asserted understand-wgo)
                     (response Yes)
                     (valid-answers Yes No))))  
(defrule if-kids-stuff ""
	(logical (understand-wgo Yes))
   =>
   (assert (UI-state (display KidsQuestion)
                     (relation-asserted kids-stuff)
                     (response Yes)
                     (valid-answers Yes No))))  
(defrule if-educational ""
	(logical (kids-stuff Yes))
   =>
   (assert (UI-state (display EduQuestion)
                     (relation-asserted educational)
                     (response Yes)
                     (valid-answers Yes No))))
(defrule if-awesome ""
	(logical (understand-wgo No))
   =>
   (assert (UI-state (display AwesomeQuestion)
                     (relation-asserted awesome-way)
                     (response Yes)
                     (valid-answers Yes No))))  
(defrule if-computers ""
	(logical (kids-stuff No))
   =>
   (assert (UI-state (display CompQuestion)
                     (relation-asserted computers)
                     (response Yes)
                     (valid-answers Yes No)))) 
(defrule if-outrageous ""
	(logical (computers No))
   =>
   (assert (UI-state (display OutrageusQuestion)
                     (relation-asserted outrageus)
                     (response Yes)
                     (valid-answers Yes No))))
(defrule if-undead ""
	(logical (understand-wgo Yes))
   =>
   (assert (UI-state (display UndeadQuestion)
                     (relation-asserted undead)
                     (response Yes)
                     (valid-answers Yes No))))     
                                                            
;;;****************
;;;* RESULT RULES*
;;;****************

(defrule nintendo-franchise-yes ""
   (logical (nintendo-franchise Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "The Super Mario Bros. Super Show" "Captain N The Game Master" "The Adventures of Super Mario Bros. 3" "Super Mario World" "The Legend of Zelda" "Pokemon"))))

(defrule nintendo-franchise-no ""
   (logical (nintendo-franchise No))
   =>
   (assert (UI-state (state final)
                     (conclusions "Adventures of Sonic the Hedgehog" "Mega Man" "Mortal Kombat Defenders of the Realm" "Double Dragon" "Wing Commander Academy" "Street Fighter"))))

(defrule a-celebrity-yes ""
   (logical (celebrity Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Chuck Norris: Karate Kommandos" "Mister T"))))

(defrule cats-yes ""
   (logical (cats Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "ThunderCats" "Swat Kats"))))

(defrule rodents-yes ""
   (logical (rodents Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Danger Mouse" "Biker Mice from Mars" "Chip N Dale Rescue Rangers"))))

(defrule dinosaurs-yes ""
   (logical (dinosaurs Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Dinosaucers" "Cadillacs and Dinosaurs" "Extreme Dinosaurs" "Dino Rideres"))))

(defrule ducks-yes ""
   (logical (ducks Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Count Duckula" "DuckTales" "Darkwing Duck"))))

(defrule bears-yes ""
   (logical (bears Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "TaleSpin" "Disney's Adventures of the Gummi Bears" "The Care Bears"))))

(defrule monkeys-yes ""
   (logical (monkeys Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Captain Simian and the Space Monkeys"))))

(defrule cows-yes ""
   (logical (cows Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Wild West Cowboys of Moo Mesa"))))

(defrule godless-abominations-yes ""
   (logical (godless-abominations Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Smurfs" "Snorks"))))

(defrule godless-abominations-no ""
   (logical (godless-abominations No))
   =>
   (assert (UI-state (state final)
                     (conclusions "Teenage Mutant Ninja Turtles" "Street Sharks" "Gargoyles"))))

(defrule giant-robots-yes ""
   (logical (giant-robots Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Robotech" "Voltron" "Transformers" "Challenge of the GoBots"))))

(defrule r-rated-yes ""
   (logical (r-rated Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Rambo and the Force of Freedom" "Robocop: The Animated Series" "Highlander: the Animated Series"))))

(defrule r-rated-no ""
   (logical (r-rated No))
   =>
   (assert (UI-state (state final)
                     (conclusions "Star Wars: Ewoks" "Star Wars: Droids" "Extreme Ghostbusters" "The Real Ghostbusters" "James Bond Jr."))))

(defrule post-apo-yes ""
   (logical (post-apo Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Highlander: the Animated Series" "Cadillacs and Dinosaurs" "Thundarr the Barbarian" "Spiral Zone"))))

(defrule swords-sorcery-yes ""
   (logical (swords-sorcery Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "The Pirates of Dark Water" "King Arthur and the Knights of Justice" "He-man and the Masters of the Universe" "Conan the Adventurer" "Thundarr the Barbarian" "Visionaries" "Dungeons & Dragons" "She-Ra, Princess of Power"))))

(defrule military-law-yes ""
   (logical (military-law Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "C.O.P.S" "G.I Joe" "M.A.S.K." "Rambo and the Force of Freedom" "Robocop: The Animated Series"  "Exosquad" "Spiral Zone" "SilverHawks" "Centurions" "Sky Commanders" "Sam & Max: Freelance Police" "Inspector Gadget" "The Adventures of the Galaxy Rangers" "BraveStarr"))))

(defrule space-yes ""
   (logical (space Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Captain Simian and the Space Monkeys" "Jayce and the Wheeled Warriors" "Exosquad" "SilverHawks" "The Adventures of the Galaxy Rangers" "BraveStarr"))))

(defrule cowboys-yes ""
   (logical (cowboys Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Wild West Cowboys of Moo Mesa" "The Adventures of the Galaxy Rangers" "BraveStarr"))))

(defrule educational-yes ""
   (logical (educational Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "The Magic School Bus" "Captain Planet and the Planeteers"))))

(defrule educational-no ""
   (logical (educational No))
   =>
   (assert (UI-state (state final)
                     (conclusions "Mighty Max" "The Real Adventures of Jonny Quest" "Bionic Six"))))

(defrule computers-yes ""
   (logical (computers Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "ReBoot"))))

(defrule outrageous-yes ""
   (logical (outrageous Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Jem"))))

(defrule undead-yes ""
   (logical (undead Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Mummies Alive" "Skeleton Warriors"))))

(defrule undead-no ""
   (logical (undead No))
   =>
   (assert (UI-state (state final)
                     (conclusions "The World of David the Gnome"))))

(defrule awesome-yes ""
   (logical (cowboys Yes))
   =>
   (assert (UI-state (state final)
                     (conclusions "Inhumanoids"))))

(defrule awesome-no ""
   (logical (cowboys No))
   =>
   (assert (UI-state (state final)
                     (conclusions "Aeon Flux"))))
                     

                     
;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

   (declare (salience 5))
   
   (UI-state (id ?id))
   
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
             
   =>
   
   (modify ?f (current ?id)
              (sequence ?id ?s))
   
   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
                      
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))
   
   ?f <- (next ?id)

   (state-list (sequence ?id $?))
   
   (UI-state (id ?id)
             (relation-asserted ?relation))
                   
   =>
      
   (retract ?f)

   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
     
   (UI-state (id ?id) (response ?response))
   
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))
   
   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
     
   (UI-state (id ?id) (response ~?response))
   
   ?f2 <- (UI-state (id ?nid))
   
   =>
         
   (modify ?f1 (sequence ?b ?id ?e))
   
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)
   
   (state-list (sequence ?id $?))
   
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
                
   =>
      
   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
      
   (assert (add-response ?id ?response)))   

(defrule handle-add-response

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id ?response)
                
   =>
      
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   
   (retract ?f1))   

(defrule handle-add-response-none

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id)
                
   =>
      
   (str-assert (str-cat "(" ?relation ")"))
   
   (retract ?f1))   

(defrule handle-prev

   (declare (salience 10))
      
   ?f1 <- (prev ?id)
   
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
                
   =>
   
   (retract ?f1)
   
   (modify ?f2 (current ?p))
   
   (halt))
   
