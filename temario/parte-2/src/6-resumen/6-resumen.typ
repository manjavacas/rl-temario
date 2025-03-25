#import "@preview/typslides:1.2.5": *

#show: typslides.with(
  ratio: "16-9",
  theme: "bluey",
)

#set text(lang: "es")
#set text(hyphenate: false)

#set figure(numbering: none)

#let colmath(x, color: red) = text(fill: color)[$#x$]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: [Resumen],
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)

// *****************************************************************************

#table-of-contents(title: "Contenidos")


// *****************************************************************************

#title-slide([Visión general])

// *****************************************************************************

#blank-slide[
  #align(center)[
    #box(height: 400pt)[
      #image("images/summary.png", width: 65%)
    ]]
]

// *****************************************************************************

#title-slide([Conceptos clave])


// *****************************************************************************

#slide(title: [Conceptos clave])[

  #framed[¿Diferencia entre problemas #stress[episódicos] y #stress[continuados]?]

  - #text(fill:olive)[*Episódicos*]: problemas divisibles en episodios con un duración determinada, desde un estado inicial hasta un estado terminal.

  - #text(fill:purple)[*Continuados*]: no existen estados terminales.

]

// *****************************************************************************

#slide(title: [Conceptos clave])[

  #framed[¿Diferencia entre #stress[estado] y #stress[observación]?]

  - #text(fill:red)[*Estado*]: contiene información *completa* sobre el estado actual del entorno.

  - #text(fill:blue)[*Observación*]: contiene la información *parcial* percibida por el agente. Es un *subconjunto* de la información contenida en el estado.

  _Diferenciamos entre MDP y POMDP._

]


// *****************************************************************************

#slide(title: [Conceptos clave])[

  #framed[¿Diferencia entre #stress[valor] y #stress[recompensa]?]

  - #text(fill:blue)[*Valor*]: retorno esperado a partir de un estado o par acción--estado.

  - #text(fill:green)[*Recompensa*]: valor inmediato percibido al alcanzar un estado o realizar una determinada acción desde un estado.
]


// *****************************************************************************

#slide(title: [Conceptos clave])[

  #framed[¿Qué es el #stress[retorno]?]

  #text(fill:purple)[*Retorno*]: recompensa acumulada al final de un episodio o secuencia de _time steps_.

]


// *****************************************************************************

#slide(title: [Conceptos clave])[

  #framed[¿Diferencia entre #stress[exploración] y #stress[explotación]?]

  - #text(fill:olive)[*Exploración*]: elección de acciones subóptimas que pueden conducir a nuevas experiencias/transiciones/recompensas no percibidas.

  - #text(fill:red)[*Explotación*]: aplicación de la política (óptima) actual para maximizar una función de recompensa.

]

// *****************************************************************************

#slide(title: [Conceptos clave])[

  #framed[¿Diferencia entre #stress[predicción] y #stress[control]?]

  - #text(fill:blue)[*Predicción*]: estimación de las funciones de valor para una política dada. Consiste en *evaluar* una política.

  - #text(fill:purple)[*Control*]: encontrar la política óptima que maximice la recompensa acumulada. Implica *evaluación* y *mejora* de la política actual.

]


// *****************************************************************************

#slide(title: [Conceptos clave])[

  #framed[¿Diferencia entre métodos #stress[_on-policy_] y #stress[_off-policy_]?]

  - #text(fill:red)[*_On-policy_*]: la política empleada para generar experiencia y aprender es #stress[la misma] que se emplea para actuar.

  - #text(fill:blue)[*_Off-policy_*]: una política genera experiencia (#stress[comportamiento]) mientras que otra se emplea para actuar (#stress[objetivo]).

]


// *****************************************************************************

#slide(title: [Conceptos clave])[

  #framed[¿Diferencia entre #stress[_model-based_] y #stress[_model-free_]?]

  - #text(fill:blue)[*_Model-based_*]: métodos de RL basados en el aprendizaje y/o aprovechamiento de modelos para generar experiencia y *planificar* un comportamiento óptimo.

  - #text(fill:olive)[*_Model-free_*]: métodos de RL que no requieren un modelo del entorno y *aprenden directamente* a partir de interacción real.

]


// *****************************************************************************

#slide(title: [Conceptos clave])[
  #box(height: 400pt)[

    #columns(2)[

      #text(fill: olive)[*Programación dinámica*]
      #text(size: 17pt)[
        - Evaluación de la política.

        - Mejora de la política.

        - Iteración de la política.

        - DP síncrona _vs._ asíncrona.

        - Iteración de la política generalizada (GPI).
      ]


      #columns(2)[

        #text(fill: orange)[*Bandits*]
        #text(size: 13pt)[
          - Exploración _vs._ explotación.

          - $epsilon$-_greedy_.

          - _Upper Confidence Bound_

          - _Thompson Sampling_

          - Actualizaciones incrementales

        ]

        #colbreak()

        #text(fill: blue)[*Planificación*]

        #text(size: 15pt)[
          - Dyna-Q

          - Dyna-Q+

          - MC _tree search_

        ]
      ]

      #colbreak()

      #text(fill: red)[*Métodos basados en muestreo*]

      - Monte Carlo.

      - Inicios de exploración.

      - _Importance sampling_.

      - _On-policy vs. off-policy_.

      - _TD learning_.

      - SARSA.

      - _Q-learning_.

      - _Expected SARSA_.

      - Métodos _n-step_.

    ]

  ]
]


// *****************************************************************************

#title-slide([Limitaciones de los métodos tabulares])


// *****************************************************************************

#slide(title: [Métodos tabulares])[

  #framed[Los métodos vistos hasta el momento se denominan #stress[tabulares] debido a la forma en que almacenan y gestionan la información.]

  Por ejemplo, en el caso de las *políticas*, estas pueden representarse como una *tabla* que relaciona estados y acciones, o estados, acciones y valores.

  - Ej. _Q-table_.

  _Asumimos que el número de estados y acciones es *discreto* y *limitado*, por lo que su gestión es computacionalmente viable._

]


// *****************************************************************************

#slide(title: [Limitaciones])[

  #align(center)[#framed[#emoji.quest ¿Pero qué ocurre si el #stress[espacio de estados] / #stress[acciones] es *infinito*?]]

  #v(.4cm)

  ... o lo suficientemente grande como para ser *inabarcable* por los métodos vistos #emoji.face.think

  #v(1cm)

  #text(size: 30pt)[
    #align(center)[_¡Lo veremos en la siguiente parte!_ #emoji.confetti #emoji.face]
  ]

]


// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: [Resumen],
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)
