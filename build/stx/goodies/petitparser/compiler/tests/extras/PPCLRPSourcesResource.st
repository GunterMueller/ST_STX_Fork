"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

TestResource subclass:#PPCLRPSourcesResource
	instanceVariableNames:'sources'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!


!PPCLRPSourcesResource methodsFor:'accessing'!

sources
    sources isNil ifTrue:[ 
        sources := #(
            doranewbridge
            doraultratouch
            escapament
            follower
            linebounderfollower
            linecrossfollower
            rtimer
            stairsclimber
            stopwatch
            timer
        ) collect:[:e | self perform: e].                
    ].
    ^ sources

    "Created: / 30-07-2015 / 19:04:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCLRPSourcesResource methodsFor:'sources - individual'!

doranewbridge
^ ';; A Random Space Explorer behavior for a differential drive robot
;; Wall collisions are detected with the ultrasonic sensor

(var speed :=[20])
(var timeout := [1000 atRandom])
(machine Dora
  (state forward
    (onentry [
      robot motorA startAtSpeed: speed.
      robot motorD startAtSpeed: speed.
    ])
    (onexit [robot fullStop]))
  (state shock
    (onentry [
      robot motorA startAtSpeed: speed negated.
      robot motorD startAtSpeed: speed negated.
    ])
    (onexit [robot fullStop]))
  (state turn
    (onentry [
      robot motorA startAtSpeed: speed.
      robot motorD startAtSpeed: speed negated
    ])
    (onexit [
      robot fullStop.
      timeout := 1000 atRandom
    ]))
  (ontime 500 shock -> turn st)
  (ontime timeout turn -> forward tf)
  (on tooclose forward -> shock fs)
  (event tooclose [robot sensor2 read < 200])
)
(spawn Dora forward)
'

    "Created: / 30-07-2015 / 17:39:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doraultratouch
^ ';; A Random Space Explorer behavior for a differential drive robot
;; Wall collisions are detected with the ultrasonic sensor and touch sensors

(var speed :=[20])
(var timeout := [1000 atRandom])
(machine Dora
  (state forward
    (onentry [
      robot motorA startAtSpeed: speed.
      robot motorD startAtSpeed: speed.
    ])
    (onexit [robot fullStop]))
  (state shock
    (onentry [
      robot motorA startAtSpeed: speed negated.
      robot motorD startAtSpeed: speed negated.
    ])
    (onexit [robot fullStop]))
  (state turn
    (onentry [
      robot motorA startAtSpeed: speed.
      robot motorD startAtSpeed: speed negated
    ])
    (onexit [
      robot fullStop.
      timeout := 1000 atRandom
    ]))
  (ontime 500 shock -> turn st)
  (ontime timeout turn -> forward tf)
  (on tooclose forward -> shock fs)
  (on shockLeft forward -> shock sl)
  (on shockRight forward -> shock sf)
  (event tooclose [robot sensor2 read < 200])
  (event shockLeft [robot sensor4 read = 1])
  (event shockRight [robot sensor1 read = 1])
)
(spawn Dora forward)

'

    "Created: / 30-07-2015 / 17:40:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

escapament
^ ';;; A simple escapement
(machine esc
        (state tick)
        (state tock)
        (ontime 500 tick -> tock tito)
        (ontime 500 tock -> tick toti)
)
(spawn esc tick)'

    "Created: / 30-07-2015 / 17:37:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

follower
^ ';; A line follower for a differential drive robot
;; Uses the Lego color sensor,
;; position is front and center, and pointed to the line (down)
(var sensor := [robot sensor3])
(var mright := [robot motorA])
(var mleft := [robot motorD])
(var speed := [4])
(machine follower
        (state init
                (onentry [sensor setMode: #Mode2])
        )
        (state moving
                (onentry [
                        mright startAtSpeed: speed * 2.
                        mleft startAtSpeed: speed * 2.
                        ])
                (onexit [robot fullStop])
        )
        (state looking
                (machine lookalgo
                        (var looktime := [1000])
                        (state lookright
                                (onentry 
                                        [mright startAtSpeed: speed negated.
                                        mleft startAtSpeed: speed.]))
                        (state lookleft
                                )
                        (state centerfromright
                                (onentry 
                                        [mright startAtSpeed: speed.
                                        mleft startAtSpeed: speed negated.]))
                        (state centerfromleft
                                (onentry 
                                        [mright startAtSpeed: speed negated.
                                        mleft startAtSpeed: speed.])
                                (onexit [looktime := looktime * 2]))
                        (ontime looktime lookright -> centerfromright tlrb)
                        (ontime looktime centerfromright -> lookleft tlr)
                        (ontime looktime lookleft -> centerfromleft tfail)
                        (ontime looktime centerfromleft -> lookright tfailb)
                        )
                (onentry (spawn lookalgo lookright))
                )
        (eps init -> moving tinit)
        (on out moving -> looking tms)
        (event out [(sensor read = 1) not])
        (event in  [sensor read = 1])
        (on in looking -> moving tsm)
)
(spawn follower init)

'

    "Created: / 30-07-2015 / 17:40:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linebounderfollower
^ ';; Line following robot for a differential drive robot
;;; that "bounces" off the left hand side of the line
;; Uses the Lego color sensor,
;; position is front and center, and pointed to the line (down)
(var sensor := [robot sensor3])
(var mright := [robot motorA])
(var mleft := [robot motorD])
(machine linebounce
        (state init
                (onentry [sensor setMode: #Mode2.]))
        (eps init -> white iw)
        (state white
                (onentry [
                        mright startAtSpeed: 4.
                        mleft startAtSpeed: 18])
                (onexit [mright stop. mleft stop]))
        (state black
                (onentry [
                        mright startAtSpeed: 10.
                        mleft startAtSpeed: -4])
                (onexit [mright stop. mleft stop]))
        (on seeblack white -> black wb)
        (on seewhite black -> white bw)
        (event seeblack [sensor read = 1])
        (event seewhite [(sensor read = 1) not])
)
(spawn linebounce init)

'

    "Created: / 30-07-2015 / 17:41:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linecrossfollower
^ ';;; Line following for a differential drive robot
;;; goes forward by always crossing the line
;; Uses the Lego color sensor,
;; position is front and center, and pointed to the line (down)
(var sensor := [robot sensor3])
(var mright := [robot motorA])
(var mleft := [robot motorD])
(var speed := [15])
(machine linecross
        (state left
                (onentry [mright startAtSpeed: speed]))
        (state crossfl  
                (onexit [mright stop]))
        (state right
                (onentry [mleft startAtSpeed: speed]))
        (state crossfr
                (onexit [mleft stop]))  
        (on black right -> crossfr rlx)
        (on black left -> crossfl lrx)
        (on white crossfr -> left rl)
        (on white crossfl -> right lr)
        (event black [sensor read = 1])
        (event white [(sensor read = 1) not])
)
(spawn linecross left)

'

    "Created: / 30-07-2015 / 17:41:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rtimer
^ ';;a resettable timer with 10 sec intervals
(var minute := [0])
(machine rtimer
        (state zero)
        (state ten)
        (state twenty)
        (state thirty)
        (state fourty)
        (state fifty
                (onexit [minute := minute + 1]))
        (ontime 10000 zero -> ten toten)
        (ontime 10000 ten -> twenty totwenty)
        (ontime 10000 twenty -> thirty tothirty)
        (ontime 10000 thirty -> fourty tofourty)
        (ontime 10000 fourty -> fifty tofifty)
        (ontime 10000 fifty -> zero tozero)
        (var doreset := [0])
        (state init
                (onentry [minute := 0.
                        doreset := 0]))
        (on resetting *-> init reset)
        (eps init -> zero go)
        (event resetting [doreset = 1])
)
(spawn rtimer zero)
'

    "Created: / 30-07-2015 / 17:38:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stairsclimber
^ ';;; A stairs climber building using the MindStorm expansion set
;;; Use the new JetStorm Bridge funcionality
;;; Use ontime transition to estimate the second step of the climbing
;;; Watch example in: http://youtu.be/6HXcKwMO8Fo

(var backWheelsSpeed := [-50])
(var frontWheelsSpeed := [-50])
(var climbSpeed := [-50])
(var startGyro := [0])
(var deltaGyro := [4])
(machine Stair
  (state forward
    (onentry [
      robot motorA startAtSpeed: backWheelsSpeed.
      robot motorB startAtSpeed: frontWheelsSpeed.
      startGyro := robot sensor2 read.
      ]
    )
    (onexit [
      robot fullStop.
      ]
    )
  )

  (state climb
    (onentry [
      robot motorD startAtSpeed: climbSpeed.
      robot motorB startAtSpeed: frontWheelsSpeed.
      ]
    )
    (onexit [
      robot fullStop.
      ]
    )
  )

  (state forward2
    (onentry [
      robot motorA startAtSpeed: backWheelsSpeed.
      robot motorB startAtSpeed: frontWheelsSpeed.
      ]
    )
  )

  (state climb2
    (onentry [
      robot motorD startAtSpeed: climbSpeed negated.
      ]
    )
    (onexit [
      robot fullStop 
      ]
    )
  )

  (state stop
    (onentry [robot fullStop])
  )

  (on incline forward -> climb incline)
  (on finishClimb climb -> forward2 finishClimb)
  (event finishClimb [robot sensor3 read == 1])
  (event incline [robot sensor2 read > (deltaGyro + startGyro)])

  (ontime 3000 forward2 -> climb2 for2)
  (ontime 6000 climb2 -> forward loop)
)
(spawn Stair forward)

'

    "Created: / 30-07-2015 / 17:42:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stopwatch
^ ';; A stopwatch.
;; Inspect the variables start and reset,
;; and from the inspectors change the values
(machine stopwatch
        (var start := [false])
        (var reset := [false])
        (var seconds := [0])
        (state waiting )
        (on e_starting waiting -> tick t_st)
        (event e_starting [start])
        (state tick)
        (state tock (onexit [seconds := seconds + 1]))
        (ontime 500 tick -> tock t_tito)
        (ontime 500 tock -> tick t_toti)

        (on e_reset *-> resetting t_reset)
        (event e_reset [reset])
        (state resetting
                (onentry [reset := false. seconds := 0] ))
        (eps resetting -> tick t_et)

        (on e_stop *-> waiting t_es)
        (event e_stop [start not])
)
(spawn stopwatch waiting)
'

    "Created: / 30-07-2015 / 17:38:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timer
^ ';; a timer with 10 sec intervals

(var minute := [0])
(machine timer
        (state zero)
        (state ten)
        (state twenty)
        (state thirty)
        (state fourty)
        (state fifty
                (onexit [minute := minute + 1]))
        (ontime 10000 zero -> ten toten)
        (ontime 10000 ten -> twenty totwenty)
        (ontime 10000 twenty -> thirty tothirty)
        (ontime 10000 thirty -> fourty tofourty)
        (ontime 10000 fourty -> fifty tofifty)
        (ontime 10000 fifty -> zero tozero)
)
(spawn timer zero)

'

    "Created: / 30-07-2015 / 17:39:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCLRPSourcesResource class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

